package App::LDAP::LDIF::Group;

use Modern::Perl;

use Moose;

with qw(
    App::LDAP::LDIF
    App::LDAP::Role::FromEntry
);

sub params_to_args {
    my ($self, %params) = @_;

    my $base = $params{base};
    my $name = $params{name};
    my $id   = $params{id};

    return (
        dn        => "cn=$name,$base",
        cn        => $name,
        gidNumber => $id,
    );
}

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

    $entry->add($_ => $self->$_)
      for qw( objectClass
              cn
              userPassword
              gidNumber );

    $entry;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

App::LDAP::LDIF::Group - the representation of groups in LDAP

=head1 SYNOPSIS

    my $group = App::LDAP::LDIF::Group->new(
        base => $base,            # The OU (organization unit) which the group belongs to
        name => $name,            # the group name
        id   => $id,              # the gid of the group
    );

    my $entry = $group->entry;    # get the group as a instance of Net::LDAP::Entry

=cut
