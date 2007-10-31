use strict;
use warnings;

use Test::More tests => 1;

use HTML::FormFu;

my $form = HTML::FormFu->new({ render_class_args => { INCLUDE_PATH => 'share/templates/tt/xhtml' } });

$form->auto_fieldset( { nested_name => 'foo' } );

$form->element('Text')->name('bar')->constraint('Number');
$form->element('Text')->name('baz')->constraint('Number');
$form->element('Text')->name('bag')->constraint('Number');

$form->process( {
        'foo.bar'     => 1,
        'foo.baz'     => [ 2, 3 ],
        'foo.bag'     => 'yada',
        'foo.unknown' => 4,
    } );

is_deeply(
    $form->params,
    {
        foo => {
            bar => 1,
            baz => [ 2, 3 ],
        },
    }
);

