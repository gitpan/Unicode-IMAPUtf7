package Unicode::IMAPUtf7;

=head1 NAME

Unicode::IMAPUtf7 - Perl extension to deal with IMAP UTF7

=head1 SYNOPSIS

  use Unicode::IMAPUtf7;

  my $t = Unicode::IMAPUtf7->new();
  print $t->encode('RÃ©pertoire');
  print $t->decode('R&AOk-pertoire');

**DEPRECATED**

  print Unicode::IMAPUtf7::imap_utf7_encode('Répertoire');
  print Unicode::IMAPUtf7::imap_utf7_decode('R&AOk-pertoire');

**DEPRECATED**

=head1 DESCRIPTION

IMAP mailbox names are encoded in a modified UTF7 when names contains 
international characters outside of the printable ASCII range. The
modified UTF-7 encoding is defined in RFC2060 (section 5.1.3).

=cut

use strict;
use Exporter;
use Unicode::String;
use Carp;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

BEGIN {
	@ISA = qw(Exporter);
	@EXPORT = ();
	@EXPORT_OK = qw(imap_utf7_decode imap_utf7_encode);
	%EXPORT_TAGS = (
		'all' => [qw (imap_utf7_decode imap_utf7_encode)],
	);
	$VERSION = '1.99_1';
}

=head1 METHODS

=cut

=over 4

=item new()

Returns a new instance of a Unicode::IMAPUtf7 object.

=back

=cut

sub new {
	my $proto = shift;
	my $class = ref ($proto) || $proto || __PACKAGE__;
	my $self = bless {}, $class;

	$self;
}

=over 4

=item encode($text)

Returns the modified UTF7-text for a string in UTF8.

=back

=cut

sub encode {
	my ($self, $s) = @_;

	return _imap_utf7_encode(Unicode::String::utf8($s)->utf7);
}

=over 4

=item decode($text)

Returns the decoded string into UTF8 data.

=back

=cut

sub decode {
	my ($self, $s) = @_;

	return Unicode::String::utf7(_imap_utf7_decode($s))->utf8;
}

sub imap_utf7_decode {
	my ($s) = @_;

	$s = _imap_utf7_decode($s);

	return Unicode::String::utf7($s)->latin1;
}

sub _imap_utf7_decode {
	my ($s) = @_;

	# Algorithm
	# On remplace , par / dans les BASE 64 (, entre & et -)
	# On remplace les &, non suivi d'un - par +
	# On remplace les &- par &
	$s =~ s/&([^,&\-]*),([^,\-&]*)\-/&$1\/$2\-/g;
	$s =~ s/&(?!\-)/\+/g;
	$s =~ s/&\-/&/g;

	return $s;
}

sub imap_utf7_encode {
	my ($s) = @_;

	$s = Unicode::String::latin1($s)->utf7;

	$s = _imap_utf7_encode($s);

	return $s;
}

sub _imap_utf7_encode {
	my ($s) = @_;

	$s =~ s/\+([^\/&\-]*)\/([^\/\-&]*)\-/\+$1,$2\-/g;
	$s =~ s/&/&\-/g;
	$s =~ s/\+([^+\-]+)?\-/&$1\-/g;

	return $s;
}

1;
__END__

=head1 DEPRECATED METHODS

B<imap_utf7_encode>: returns the modified UTF7-text for a string in Latin1.

B<imap_utf7_decode>: returns the decoded string into Latin1 data.

These functions may disappear in some later version.
Please update with the new OO and UTF8 scheme. See Unicode::String
for conversion functions between Latin1 and UTF8.

=head1 RFC2060 - section 5.1.3 - Mailbox International Naming Convention

By convention, international mailbox names are specified using a
modified version of the UTF-7 encoding described in [UTF-7].  The
purpose of these modifications is to correct the following problems
with UTF-7:

1) UTF-7 uses the "+" character for shifting; this conflicts with
   the common use of "+" in mailbox names, in particular USENET
   newsgroup names.

2) UTF-7's encoding is BASE64 which uses the "/" character; this
   conflicts with the use of "/" as a popular hierarchy delimiter.

3) UTF-7 prohibits the unencoded usage of "\"; this conflicts with
   the use of "\" as a popular hierarchy delimiter.

4) UTF-7 prohibits the unencoded usage of "~"; this conflicts with
   the use of "~" in some servers as a home directory indicator.

5) UTF-7 permits multiple alternate forms to represent the same
   string; in particular, printable US-ASCII chararacters can be
   represented in encoded form.

In modified UTF-7, printable US-ASCII characters except for "&"
represent themselves; that is, characters with octet values 0x20-0x25
and 0x27-0x7e.  The character "&" (0x26) is represented by the two-
octet sequence "&-".

All other characters (octet values 0x00-0x1f, 0x7f-0xff, and all
Unicode 16-bit octets) are represented in modified BASE64, with a
further modification from [UTF-7] that "," is used instead of "/".
Modified BASE64 MUST NOT be used to represent any printing US-ASCII
character which can represent itself.

"&" is used to shift to modified BASE64 and "-" to shift back to US-
ASCII.  All names start in US-ASCII, and MUST end in US-ASCII (that
is, a name that ends with a Unicode 16-bit octet MUST end with a "-
").

For example, here is a mailbox name which mixes English, Japanese,
and Chinese text: ~peter/mail/&ZeVnLIqe-/&U,BTFw-

=head1 REQUESTS & BUGS

Please report any requests, suggestions or bugs via the RT bug-tracking system 
at http://rt.cpan.org/ or email to bug-Unicode-IMAPUtf7\@rt.cpan.org. 

http://rt.cpan.org/NoAuth/Bugs.html?Dist=Unicode-IMAPUtf7 is the RT queue for Unicode::IMAPUtf7.
Please check to see if your bug has already been reported. 

=head1 COPYRIGHT

Copyright 2001-2003

Fabien Potencier, cpan@zelab.net - http://cpan.zelab.net/

This software may be freely copied and distributed under the same
terms and conditions as Perl.

=head1 SEE ALSO

perl(1), Unicode::String.

=cut
