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

use IO::String;

my $ldif_string = IO::String->new(q{
dn: cn=foo,ou=Group,dc=example,dc=com
objectClass: posixGroup
objectClass: top
cn: foo
userPassword: {crypt}x
gidNumber: 2000
});

my $entry = Net::LDAP::LDIF->new($ldif_string, "r", onerror => "die")->read_entry;

my $new_from_entry = App::LDAP::LDIF::Group->new($entry);

done_testing;
