use strict;
use warnings;

use Test::More tests => 7;

use HTML::FormFu;

my $form = HTML::FormFu->new({ render_class_args => { INCLUDE_PATH => 'share/templates/tt/xhtml' } });

my $e1 = $form->element('Text')->name('foo');
my $e2 = $form->element('Text')->name('bar');

$form->deflator( Strftime => 'foo', 'bar' );

{
    my @d = $form->get_deflator;

    is( @d, 1 );
}

{
    my @d = $form->get_deflator('foo');

    is( @d, 1 );
}

{
    my @d = $e1->get_deflator;

    is( @d, 1 );
}

{
    my @d = $e1->get_deflator( { name => 'foo' } );

    is( @d, 1 );
}

{
    my @d = $e2->get_deflator;

    is( @d, 1 );
}

{
    my @d = $e2->get_deflator( { name => 'bar' } );

    is( @d, 1 );
}

{
    my @i = $e2->get_deflator( { name => 'foo' } );

    is( @i, 0 );
}
