use 5.010;
use strict;
use warnings;

package App::LDAP;
use strict;
use warnings;
our $VERSION = '0.01';

use Rubyish::Attribute;

attr_accessor "config";

use App::LDAP::Command;
use App::LDAP::Config;

sub new {
  my $class = shift;
  bless {@_}, $class;
}

sub run {
  my ($self,) = @_;
  $self->config( App::LDAP::Config->read );
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
