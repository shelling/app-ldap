use 5.010;
use strict;
use warnings;

package App::LDAP;
use strict;
use warnings;
our $VERSION = '0.04';

use Rubyish::Attribute;

attr_accessor "config", "connection";

use Net::LDAP;
use Term::ReadPassword;

use App::LDAP::Command;
use App::LDAP::Config;
use Net::LDAP::Extension::WhoAmI;


sub new {
  my $class = shift;
  bless {@_}, $class;
}

sub run {
  my ($self,) = @_;
  $self->config( App::LDAP::Config->read );
  $self->connect;
  App::LDAP::Command->dispatch(app_info => $self);
}

sub connect {
  my ($self) = @_;
  my $config = $self->config;
  my $ldap = Net::LDAP->new(
    $config->{uri},
    port       => $config->{port},
    version    => $config->{ldap_version},
    onerror    => 'die',
  );
  if ($< == 0) {
    my $userdn = $config->{rootdn};
    my $userpw = $config->{rootpw};
    $ldap->bind($userdn, password => $userpw);
  } else {
    my ($base, $scope) = split /\?/, $config->{nss_base_passwd};
    my $userdn = $ldap->search( base => $base, scope => $scope, filter => "uidNumber=$<")
                      ->entry(0)
                      ->dn;
    my $userpw = read_password("your password: ");
    $ldap->bind($userdn, password => $userpw);
  }
  say "bind as ", $ldap->who_am_i->response;
  $self->connection($ldap);
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

Copyright (C) shelling

MIT

=cut
