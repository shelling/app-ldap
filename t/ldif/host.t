use Modern::Perl;
use Test::More;

use App::LDAP::LDIF::Host;

my $host = App::LDAP::LDIF::Host->new(
    base => "ou=Hosts,dc=example,dc=com",
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

use IO::String;

my $ldif_string = IO::String->new(q{
dn: cn=hello,ou=Hosts,dc=example,dc=com
cn: hello
objectClass: top
objectClass: ipHost
objectClass: device
ipHostNumber: 192.168.1.1
});

my $entry = Net::LDAP::LDIF->new($ldif_string, "r", onerror => "die")->read_entry;

my $new_from_entry = App::LDAP::LDIF::Host->new($entry);

is (
    $new_from_entry->entry->ldif,
    $entry->ldif,
    "new from entry is identical to original",
);

done_testing;
