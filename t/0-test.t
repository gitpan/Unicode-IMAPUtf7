use Test::More tests => 10;

require_ok('Unicode::IMAPUtf7');
isa_ok(my $t = Unicode::IMAPUtf7->new, 'Unicode::IMAPUtf7');

my @input = qw(test Répertoire black&white black+white);
my @expected = qw(test R&AOk-pertoire black&-white black+white);
for (my $i = 0; $i < @input; $i++) {
	is($t->encode($input[$i]), $expected[$i]);
	is($t->decode($expected[$i]), $input[$i]);
}
