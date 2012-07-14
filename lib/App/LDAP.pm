package App::LDAP;

our $VERSION = '0.07';

use Modern::Perl;

use Moose;
use MooseX::Singleton;

use Term::ReadPassword;

use App::LDAP::Command;
use App::LDAP::Config;
use App::LDAP::Utils;
use App::LDAP::Connection;

sub run {
  my ($self,) = @_;

  App::LDAP::Config->read;

  $self->handshake;

  ($< == 0) ? $self->bindroot() : $self->binduser();

  App::LDAP::Command
      ->dispatch(@ARGV)
      ->new_with_options
      ->run();
}

sub bindroot {
  my ($self) = @_;
  my $userpw = read_password("ldap admin password: ");
  ldap->bind(
      config->{rootbinddn},
      password => $userpw
  );
}

sub binduser {
  my ($self) = @_;
  my $userdn = find_user("uidNumber", $<)->dn;
  my $userpw = read_password("your password: ");
  ldap->bind($userdn, password => $userpw);
}

sub handshake {
    my ($self,) = @_;
    App::LDAP::Connection->new(
        config->{uri},
        port       => config->{port},
        version    => config->{ldap_version},
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
