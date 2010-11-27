package App::LDAP;
use strict;
use warnings;
our $VERSION = '0.01';

use App::LDAP::Command;

sub new {
  my $class = shift;
  bless {@_}, $class;
}

sub run {
  my ($self,) = @_;
  App::LDAP::Command->dispatch;
}


1;
__END__

=head1 NAME

App::LDAP -

=head1 SYNOPSIS

  use App::LDAP;

=head1 DESCRIPTION

App::LDAP is

=head1 AUTHOR

shelling E<lt>navyblueshellingford@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
