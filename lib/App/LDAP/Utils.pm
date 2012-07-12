package App::LDAP::Utils;

use Modern::Perl;

use Crypt::Password;

use base "Exporter";

our @EXPORT = qw( config
                  encrypt
                  new_password
                  next_uid
                  next_gid );

sub next_uid {
    my $ldap   = App::LDAP->instance->ldap;
    my $config = App::LDAP::Config->instance;

    my $entry = $ldap->search(
        base   => $config->{base},
        filter => "(objectClass=uidnext)",
    )->entry(0);
}

sub next_gid {
    my $ldap   = App::LDAP->instance->ldap;
    my $config = App::LDAP::Config->instance;

    $ldap->search(
        base   => $config->{base},
        filter => "(objectClass=gidnext)",
    )->entry(0);
}

sub config {
    App::LDAP::Config->instance;
}

sub encrypt {
    my $plain = shift;
    "{crypt}".password($plain, undef, "sha512");
}


use Term::ReadPassword;
sub new_password {
    my $password = read_password("password: ");
    my $comfirm  = read_password("comfirm password: ");

    if ($password eq $comfirm) {
        return $password;
    } else {
        die "not the same";
    }
}

1;
