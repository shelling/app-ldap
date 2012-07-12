package App::LDAP::Utils;

use Modern::Perl;

use Crypt::Password;

use base "Exporter";

our @EXPORT = qw( config
                  encrypt
                  new_password
                  current_user
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

use Net::LDAP::Extension::WhoAmI;
sub current_user {
    my $dn = App::LDAP->instance->ldap->who_am_i->response;
    $dn =~ s{dn:}{};

    my $search = App::LDAP->instance->ldap->search(
        base   => $dn,
        scope  => "base",
        filter => "objectClass=*",
    );

    if ($search->count > 0) {
        return $search->entry(0);
    } else {
        die "$dn not found";
    }
}

1;
