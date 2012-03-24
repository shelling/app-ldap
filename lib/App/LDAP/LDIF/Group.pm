package App::LDAP::LDIF::Group;

use Moose;

use Net::LDAP::Entry;

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = {@_};
    my $ou   = $args->{ou};
    my $name = $args->{name};
    my $id   = $args->{id};

    $self->$orig(
        dn        => "cn=$name,$ou",
        cn        => $name,
        gidNumber => $id,
    );

};

has dn => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has objectClass => (
    is      => "rw",
    isa     => "ArrayRef[Str]",
    default => sub {
        [
            qw( posixGroup
                top )
        ]
    },
);

has cn => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has userPassword => (
    is      => "rw",
    isa     => "Str",
    default => "{crypt}x",
);


has gidNumber => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

sub entry {
    my ($self) = shift;

    my $entry = Net::LDAP::Entry->new( $self->dn );

    for (qw( objectClass
             cn
             userPassword
             gidNumber ))
    {
        $entry->add($_ => $self->$_);
    }

    $entry;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

App::LDAP::LDIF::Group - the presentation of groups in LDAP

=head1 SYNOPSIS


=cut
