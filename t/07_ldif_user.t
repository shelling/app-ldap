use strict;
use Test::More;


package App::LDAP::LDIF::User;

use Moose;

use Net::LDAP::Entry;

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = {@_};
    my $base     = $args->{base};
    my $name     = $args->{name};
    my $id       = $args->{id};
    my $password = $args->{password};

    $self->$orig(
        dn => "uid=$name,$base",
        uid => $name,
        cn => $name,
        userPassword => $password,
        uidNumber => $id,
        gidNumber => $id,
        homeDirectory => "/home/$name",
    );

};

has dn => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has uid => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has cn => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has objectClass => (
    is      => "rw",
    isa     => "ArrayRef[Str]",
    default => sub {
        [
            qw( account
                posixAccount
                top
                shadowAccount )
        ],
    },
);

has userPassword => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has shadowLastChange => (
    is      => "rw",
    isa     => "Str",
    default => "00000",
);

has shadowMax => (
    is      => "rw",
    isa     => "Str",
    default => "99999",
);

has shadowWarning => (
    is      => "rw",
    isa     => "Str",
    default => "7",
);

has loginShell => (
    is      => "rw",
    isa     => "Str",
    default => "/bin/bash",
);

has uidNumber => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has gidNumber => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has homeDirectory => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

sub entry {
    my ($self) = shift;

    my $entry = Net::LDAP::Entry->new(
        dn => ""
    );
    $entry;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

package main;

use 5.010;

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
    "dn is compose of name and base",
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
    "00000",
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


done_testing;
