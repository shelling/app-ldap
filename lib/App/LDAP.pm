package App::LDAP;

our $VERSION = '0.06';

use Modern::Perl;

use Moose;
use MooseX::Singleton;

has ldap => (
    is  => "rw",
);

use Net::LDAP;
use Term::ReadPassword;

use App::LDAP::Command;
use App::LDAP::Config;
use Net::LDAP::Extension::WhoAmI;

sub run {
  my ($self,) = @_;
  App::LDAP::Config->read;
  $self->connect;
  my $command = App::LDAP::Command
                  ->dispatch(@ARGV)
                  ->new_with_options
                  ->run();
}

sub connect {
  my ($self) = @_;
  $self->ldap( $self->handshake() );
  ($< == 0) ? $self->bindroot() : $self->binduser();
  say "bind as ", $self->ldap->who_am_i->response;
}

sub bindroot {
  my ($self) = @_;
  my $userdn = App::LDAP::Config->instance->{rootbinddn};
  my $userpw = read_password("ldap admin password: ");
  $self->ldap->bind($userdn, password => $userpw);
}

sub binduser {
  my ($self) = @_;
  my ($base, $scope) = @{App::LDAP::Config->instance->{nss_base_passwd}};
  my $userdn = $self->ldap
                    ->search(base => $base, scope => $scope, filter => "uidNumber=$<")
                    ->entry(0)
                    ->dn;
  my $userpw = read_password("your password: ");
  $self->ldap->bind($userdn, password => $userpw);
}

sub handshake {
    my ($self,) = @_;
    my $config = App::LDAP::Config->instance;
    Net::LDAP->new(
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

App::LDAP - CLI tool providing common manipulation on LDAP servers

=head1 SYNOPSIS

    use App::LDAP;

    App::LDAP->new->run;

=head1 DESCRIPTION

App::LDAP is intent on providing client-side solution of
L<RFC 2307|http://www.ietf.org/rfc/rfc2307.txt>,
L<RFC 2798|http://www.ietf.org/rfc/rfc2798.txt>.

=head1 AUTHOR

shelling E<lt>navyblueshellingford@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) shelling

The MIT License

=cut
