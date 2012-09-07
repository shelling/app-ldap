use Modern::Perl;
use Test::More;

use App::LDAP::LDIF::User;

my $user = App::LDAP::LDIF::User->new(
    base     => "ou=People,dc=example,dc=com",
    name     => "nobody",
    password => "appldap0000",
    id       => 1001,
);

is_deeply (
    [sort map {$_->name} App::LDAP::LDIF::User->meta->get_all_attributes],
    [sort qw( dn
              uid
              cn
              objectClass
              userPassword
              shadowLastChange
              shadowMax
              shadowWarning
              loginShell
              uidNumber
              gidNumber
              homeDirectory )],
    "ensure the attributes",
);

is (
    $user->dn,
    "uid=nobody,ou=People,dc=example,dc=com",
    "dn is compose of name and its ou",
);

is (
    $user->uid,
    "nobody",
    "uid is name",
);

is (
    $user->cn,
    "nobody",
    "cn is name",
);

is_deeply (
    $user->objectClass,
    [qw(account posixAccount top shadowAccount)],
    "objectClass has default",
);

is (
    $user->userPassword,
    "appldap0000",
    "password should be assigned",
);

is (
    $user->shadowLastChange,
    "11111",
    "shadowLastChange has default",
);

is (
    $user->shadowMax,
    "99999",
    "shadowMax has default",
);

is (
    $user->shadowWarning,
    "7",
    "shadowWarning has default",
);

is (
    $user->loginShell,
    "/bin/bash",
    "default shell should be bash",
);

is (
    $user->entry->ldif,
<<LDIF

dn: uid=nobody,ou=People,dc=example,dc=com
uid: nobody
cn: nobody
objectClass: account
objectClass: posixAccount
objectClass: top
objectClass: shadowAccount
userPassword: appldap0000
shadowLastChange: 11111
shadowMax: 99999
shadowWarning: 7
loginShell: /bin/bash
uidNumber: 1001
gidNumber: 1001
homeDirectory: /home/nobody
LDIF
,
    "provide the same order as openldap utils",
);

use IO::String;

my $ldif_string = IO::String->new(q{
dn: uid=foo,ou=People,dc=ntucpel,dc=org
uid: foo
cn: foo
objectClass: account
objectClass: posixAccount
objectClass: top
objectClass: shadowAccount
userPassword: {crypt}$6$PqFBTKAN$H9of7E7oITubjIQqWNIs3YrVkjVGgiUBzhWRc9G6EHvC1
 VqVyHOJvf7nRoYeyCCVprZpH4otVQAHcxowOAmD91
shadowLastChange: 11111
shadowMax: 99999
shadowWarning: 7
loginShell: /bin/bash
uidNumber: 2000
gidNumber: 2000
homeDirectory: /home/foo
});

my $entry = Net::LDAP::LDIF->new($ldif_string, "r", onerror => "die")->read_entry;

my $new_from_entry = App::LDAP::LDIF::User->new($entry);

is (
    $new_from_entry->entry->ldif,
    $entry->ldif,
    "new from entry is identical to original",
);

done_testing;
