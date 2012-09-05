use Modern::Perl;
use Test::More;

use App::LDAP::LDIF::Sudoer;

my $sudoer = App::LDAP::LDIF::Sudoer->new(
    base => "ou=Sudoer,dc=example,dc=com",
    name => "first",
);

is (
    $sudoer->dn,
    "cn=first,ou=Sudoer,dc=example,dc=com",
    "dn is composed of name and ou",
);

is_deeply (
    $sudoer->objectClass,
    [qw(top sudoRole)],
    "objectClass has default value",
);

is (
    $sudoer->cn,
    "first",
    "cn is name",
);

is (
    $sudoer->sudoUser,
    "first",
    "sudoUser is name",
);

is (
    $sudoer->sudoHost,
    "ALL",
    "sudoHost has default value ALL",
);

is (
    $sudoer->sudoRunAsUser,
    "ALL",
    "sudoRunAsUser has default value ALL",
);

is (
    $sudoer->sudoCommand,
    "ALL",
    "sudoCommand has default value ALL",
);

is (
    $sudoer->entry->ldif,
<<LDIF

dn: cn=first,ou=Sudoer,dc=example,dc=com
objectClass: top
objectClass: sudoRole
cn: first
sudoUser: first
sudoHost: ALL
sudoRunAsUser: ALL
sudoCommand: ALL
LDIF
,
    "can produce correct ldif",
);

use IO::String;

my $ldif_string = IO::String->new(q{
dn: cn=foo,ou=SUDOers,dc=ntucpel,dc=org
objectClass: top
objectClass: sudoRole
cn: foo
sudoUser: foo
sudoHost: ALL
sudoRunAsUser: ALL
sudoCommand: ALL
});

my $entry = Net::LDAP::LDIF->new($ldif_string, "r", onerror => "die")->read_entry;

my $new_from_entry = App::LDAP::LDIF::Sudoer->new($entry);

is (
    $new_from_entry->entry->ldif,
    $entry->ldif,
    "new from entry is identical to original",
);



done_testing;
