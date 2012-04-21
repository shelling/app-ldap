package App::LDAP::Utils;

use Modern::Perl;

use base "Exporter";

our @EXPORT = qw( next_uid
                  next_gid );

sub next_uid {
    my $app    = shift;
    my $ldap   = $app->ldap;
    my $config = App::LDAP::Config->instance;

    my $entry = $ldap->search(
        base   => $config->{base},
        filter => "(objectClass=uidnext)",
    )->entry(0);
}

sub next_gid {
    my $app    = shift;
    my $ldap   = $app->ldap;
    my $config = App::LDAP::Config->instance;

    $ldap->search(
        base   => $config->{base},
        filter => "(objectClass=gidnext)",
    )->entry(0);
}


1;
