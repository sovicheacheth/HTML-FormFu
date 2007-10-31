package HTML::FormFu::Deploy;

use strict;

use Fatal qw( open binmode close mkdir );
use File::Copy qw( copy move );
use File::Find qw( find );
use File::ShareDir qw( dist_file );
use File::Spec;
use Carp qw( croak );

our $SHARE_DIR;

if ( -f 'MANIFEST.SKIP' && -d 'share/templates/tt/xhtml' ) {
    warn "Running as a developer, using the local, not installed templates\n\n";
    
    $SHARE_DIR = 'share/templates/tt/xhtml';
}
else {
    # dist_dir() doesn't reliably return the directory our files are in.
    # find the path of one of our files, then get the directory from that
    
    my $path = dist_file( 'HTML-FormFu', 'templates/tt/xhtml/form' );
    
    my ( $volume, $dirs, $file ) = File::Spec->splitpath( $path );
    
    $SHARE_DIR = File::Spec->catpath( $volume, $dirs, '' );
}

sub file_list {
    my @dir;
    
    my $wanted = sub {
        return if /^\./;                          # skip files beginning with "."
        return unless -f $File::Find::name;       # skip non-files

        push @dir, $_;
    };
    
    find( $wanted, $SHARE_DIR );

    return @dir;
}

sub file_source {
    my $filename = shift
        or croak "filename argument required";

    my $path = File::Spec->catfile( $SHARE_DIR, $filename );

    croak "unknown filename" unless -f $path;

    open my $fh, '<', $path;
    
    my $data = do { local $/; <$fh> };
    
    $data = "" if !defined $data;
    
    close $fh;
    
    return $data;
}

sub deploy {
    my ($dir) = @_;
    
    croak "directory argument required" if !defined $dir;

    if ( !-d $dir ) {
        warn "creating directory '$dir'\n";
        mkdir $dir;
    }

    for my $filename ( file_list() ) {
        my $path = File::Spec->catfile( $dir, $filename );

        if ( -f $path ) {
            my $bck = $path . ".bck";
            warn "file '$path' already exists, backing up to $bck\n";
            my $ok = move( $path, $bck );
            if ( !$ok ) {
                warn "failed to backup, skipping file\n$@\n";
                next;
            }
        }

        my $fh;
        eval { open $fh, '>', $path };
        if ( $@ ) {
            warn "failed to open '$path' for writing, skipping file\n$@\n";
            next;
        }
        binmode $fh;
        print $fh file_source($filename);
        close $fh;
    }
    return;
}

1;
