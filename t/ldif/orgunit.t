use Modern::Perl;
use Test::More;

use App::LDAP::LDIF::OrgUnit;

my $ou = App::LDAP::LDIF::OrgUnit->new(
    base => "dc=example,dc=com",
    name => "People",
);

is (
    $ou->dn,
    "ou=People,dc=example,dc=com",
    "dn is composed of name and base",
);

is_deeply (
    $ou->objectClass,
    [qw(organizationalUnit)],
    "objectClass has default value",
);

is (
    $ou->entry->ldif,
<<LDIF

dn: ou=People,dc=example,dc=com
ou: People
objectClass: organizationalUnit
LDIF
);

done_testing;
