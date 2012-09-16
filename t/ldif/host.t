use Modern::Perl;
use Test::More;

use App::LDAP::LDIF::Host;

is_deeply (
    [sort map {$_->name} App::LDAP::LDIF::Host->meta->get_all_attributes],
    [sort qw( dn

              objectClass
              cn
              serialNumber
              seeAlso
              owner
              ou
              o
              l
              description

              ipHostNumber
              manager )],
    "make sure attributes",
);

is_deeply (
    [sort map {$_->name} grep {$_->is_required} App::LDAP::LDIF::Host->meta->get_all_attributes],
    [sort qw( dn
              objectClass
              cn
              ipHostNumber )],
    "make sure required attributes",
);

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

is_deeply (
    $host->cn,
    ["perl-taiwan"],
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

like (
    $host->entry->ldif,
    qr{
objectClass: top
objectClass: ipHost
objectClass: device
},
    "objectClass has been exported",
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

done_testing;
