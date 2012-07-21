package App::LDAP::Role;

use Modern::Perl;

use Moose::Role;

use App::LDAP::Config;
sub config {
    App::LDAP::Config->instance;
}

use App::LDAP::Connection;
sub ldap {
    App::LDAP::Connection->instance;
}

sub find_user {
    my ( $attr, $value ) = @_;
    my $search = ldap()->search(
        base   => config()->{nss_base_passwd}->[0],
        scope  => config()->{nss_base_passwd}->[1],
        filter => "$attr=$value",
    );
    if ($search->count > 0) {
        return $search->entry(0);
    } else {
        die "user $attr=$value not found";
    }
}

no Moose;

1;
