use Modern::Perl;
use Test::More;

use App::LDAP::LDIF::Group;

my $group = App::LDAP::LDIF::Group->new(
    base => "ou=Group,dc=example,dc=com",
    name => "nobody",
    id   => 1001,
);

is (
    $group->dn,
    "cn=nobody,ou=Group,dc=example,dc=com",
    "dn is compose of name and ou",
);

is_deeply (
    $group->objectClass,
    [qw(posixGroup top)],
    "objectClass has default value",
);

is (
    $group->cn,
    "nobody",
    "cn is name",
);

is (
    $group->userPassword,
    "{crypt}x",
    "userPassword has default value",
);

is (
    $group->entry->ldif,
<<LDIF

dn: cn=nobody,ou=Group,dc=example,dc=com
objectClass: posixGroup
objectClass: top
cn: nobody
userPassword: {crypt}x
gidNumber: 1001
LDIF
,
    "$group->entry() provide the same order as openldap utils",
);

done_testing;
