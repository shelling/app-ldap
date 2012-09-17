use Modern::Perl;
use Test::More;

BEGIN {
    use_ok 'App::LDAP::LDIF::Sudoer';
}

is_deeply (
    [sort map {$_->name} App::LDAP::LDIF::Sudoer->meta->get_all_attributes],
    [sort qw( dn
              objectClass

              cn
              sudoUser
              sudoHost
              sudoCommand
              sudoRunAs
              sudoRunAsUser
              sudoRunAsGroup
              sudoOption
              description )],
    "make sure attributes",
);

is_deeply (
    [sort map {$_->name} grep {$_->is_required} App::LDAP::LDIF::Sudoer->meta->get_all_attributes],
    [sort qw(dn objectClass cn sudoUser)],
    "make sure required attributes",
);

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

is_deeply (
    $sudoer->cn,
    ["first"],
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

like (
    $sudoer->entry->ldif,
    qr{
objectClass: top
objectClass: sudoRole
},
    "objectClass has been exported",
);

use IO::String;

my $ldif_string = IO::String->new(q{
dn: cn=foo,ou=SUDOers,dc=example,dc=com
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

done_testing;
