package App::LDAP;

our $VERSION = '0.06';

use Modern::Perl;

use Moose;

has config => (
    is  => "rw",
);

has connection => (
    is  => "rw",
);

use Net::LDAP;
use Term::ReadPassword;

use App::LDAP::Command;
use App::LDAP::Config;
use Net::LDAP::Extension::WhoAmI;

sub run {
  my ($self,) = @_;
  $self->config( App::LDAP::Config->read );
  $self->connect;
  my $command = App::LDAP::Command
                  ->dispatch(@ARGV)
                  ->new_with_options
                  ->run($self);
}

sub connect {
  my ($self) = @_;
  $self->connection( $self->handshake() );
  ($< == 0) ? $self->bindroot() : $self->binduser();
  say "bind as ", $self->connection->who_am_i->response;
}

sub bindroot {
  my ($self) = @_;
  my $userdn = $self->config->{rootbinddn};
  my $userpw = read_password("ldap admin password: ");
  $self->connection->bind($userdn, password => $userpw);
}

sub binduser {
  my ($self) = @_;
  my ($base, $scope) = split /\?/, $self->config->{nss_base_passwd};
  my $userdn = $self->connection
                    ->search(base => $base, scope => $scope, filter => "uidNumber=$<")
                    ->entry(0)
                    ->dn;
  my $userpw = read_password("your password: ");
  $self->connection->bind($userdn, password => $userpw);
}

sub handshake {
  my ($self,) = @_;
  my $config = $self->config;
  return Net::LDAP->new(
    $config->{uri},
    port       => $config->{port},
    version    => $config->{ldap_version},
    onerror    => 'die',
  );
}

__PACKAGE__->meta->make_immutable;
no Moose;

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
