package Unicode::IMAPUtf7;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

use Unicode::String;

require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);
@EXPORT = qw(imap_utf7_decode imap_utf7_encode);
$VERSION = '1.03';

sub imap_utf7_decode {
	my ($s) = @_;

	# Algorithm
	# On remplace , par / dans les BASE 64 (, entre & et -)
	# On remplace les &, non suivi d'un - par +
	# On remplace les &- par &
	$s =~ s/&([^,&\-]*),([^,\-&]*)\-/&$1\/$2\-/g;
	$s =~ s/&(?!\-)/\+/g;
	$s =~ s/&\-/&/g;

	return Unicode::String::utf7($s)->latin1;
}

sub imap_utf7_encode {
	my ($s) = @_;

	$s = Unicode::String::latin1($s)->utf7;

	$s =~ s/\+([^\/&\-]*)\/([^\/\-&]*)\-/\+$1,$2\-/g;
	$s =~ s/&/&\-/g;
	$s =~ s/\+([^+\-]+)?\-/&$1\-/g;

	return $s;
}

1;
__END__

=head1 NAME

Unicode::IMAPUtf7 - Perl extension to deal with IMAP UTF7

=head1 SYNOPSIS

  use Unicode::IMAPUtf7;
  print Unicode::IMAPUtf7::imap_utf7_encode('Répertoire');
  print Unicode::IMAPUtf7::imap_utf7_decode('R&AOk-pertoire');

=head1 DESCRIPTION

IMAP mailbox names are encoded in a modified UTF7 when names contains 
international characters outside of the printable ASCII range. The
modified UTF-7 encoding is defined in RFC2060 (section 5.1.3).

B<imap_utf7_encode>: returns the modified UTF7-text for a string in Latin1.

B<imap_utf7_decode>: returns the decoded string into Latin1 data.

=head1 AUTHOR

Fabien Potencier, cpan@zelab.net - http://cpan.zelab.net/

=head1 SEE ALSO

perl(1), Unicode::String.

=cut
