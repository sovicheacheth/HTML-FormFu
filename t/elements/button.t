use strict;
use warnings;

use Test::More tests => 2;

use HTML::FormFu;

my $form = HTML::FormFu->new({ render_class_args => { INCLUDE_PATH => 'share/templates/tt/xhtml' } });

my $field = $form->element('Button')->name('foo');

my $field_xhtml = qq{<span class="button">
<input name="foo" type="button" />
</span>};

is( "$field", $field_xhtml, 'stringified field' );

my $form_xhtml = <<EOF;
<form action="" method="post">
$field_xhtml
</form>
EOF

is( "$form", $form_xhtml, 'stringified form' );

