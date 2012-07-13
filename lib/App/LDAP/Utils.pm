package App::LDAP::Utils;

use Modern::Perl;

use Crypt::Password;

use base "Exporter";

our @EXPORT = qw( config
                  ldap
                  encrypt
                  find_user
                  new_password
                  current_user
                  next_uid
                  next_gid );

sub next_uid {
    ldap()->search(
        base   => config()->{base},
        filter => "(objectClass=uidnext)",
    )->entry(0);
}

sub next_gid {
    ldap()->search(
        base   => config()->{base},
        filter => "(objectClass=gidnext)",
    )->entry(0);
}

sub config {
    App::LDAP::Config->instance;
}

sub ldap {
    App::LDAP::Connection->instance;
}

sub encrypt {
    my $plain = shift;
    "{crypt}".password($plain, undef, "sha512");
}

sub find_user {
    my ( $attr, $value ) = @_;
    my $search = ldap->search(
        base   => config->{nss_base_passwd}->[0],
        scope  => config->{nss_base_passwd}->[1],
        filter => "$attr=$value",
    );
    if ($search->count > 0) {
        return $search->entry(0);
    } else {
        die "user $attr=$value not found";
    }
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

use Net::LDAP;
use Net::LDAP::Extension::WhoAmI;
sub current_user {
    my $dn = ldap()->who_am_i->response;
    $dn =~ s{dn:}{};

    my $search = ldap()->search(
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
