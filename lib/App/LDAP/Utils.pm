package App::LDAP::Utils;

use Modern::Perl;

use base "Exporter";

our @EXPORT = qw( next_uid
                  next_gid );

sub next_uid {
    my $app    = shift;
    my $ldap   = $app->connection;
    my $config = $app->config;

    my $entry = $ldap->search(
        base   => $config->{base},
        filter => "(objectClass=uidnext)",
    )->entry(0);
}

sub next_gid {
    my $app    = shift;
    my $ldap   = $app->connection;
    my $config = $app->config;

    $ldap->search(
        base   => $config->{base},
        filter => "(objectClass=gidnext)",
    )->entry(0);
}


1;
