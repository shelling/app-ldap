package App::LDAP::LDIF::User;

use Modern::Perl;

use Moose;

use Net::LDAP::Entry;

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = {@_};
    my $ou       = $args->{ou};
    my $name     = $args->{name};
    my $id       = $args->{id};
    my $password = $args->{password};

    $self->$orig(
        dn            => "uid=$name,$ou",
        uid           => $name,
        cn            => $name,
        userPassword  => $password,
        uidNumber     => $id,
        gidNumber     => $id,
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

    my $entry = Net::LDAP::Entry->new( $self->dn );

    for (qw( uid
             cn
             objectClass
             userPassword
             shadowLastChange
             shadowMax
             shadowWarning
             loginShell
             uidNumber
             gidNumber
             homeDirectory ))
    {
        $entry->add($_ => $self->{$_});
    }

    $entry;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
