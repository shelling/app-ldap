use Modern::Perl;
use Test::More;

use App::LDAP::LDIF::Host;

my $host = App::LDAP::LDIF::Host->new(
    ou   => "ou=Hosts,dc=example,dc=com",
    name => "perl-taiwan",
    ip   => "140.112.1.1",
);

is (
    $host->dn,
    "cn=perl-taiwan,ou=Hosts,dc=example,dc=com",
    "dn is composed of name and ou",
);

is (
    $host->cn,
    "perl-taiwan",
    "cn is name",
);

is_deeply (
    $host->objectClass,
    [qw(top ipHost device)],
    "objectClass has default value",
);

is (
    $host->ipHostNumber,
    "140.112.1.1",
    "ipHostNumber is ip",
);

is (
    $host->entry->ldif,
<<LDIF

dn: cn=perl-taiwan,ou=Hosts,dc=example,dc=com
cn: perl-taiwan
objectClass: top
objectClass: ipHost
objectClass: device
ipHostNumber: 140.112.1.1
LDIF
,
    "$host->entry shows the same order as openldap utils",
);

done_testing;
