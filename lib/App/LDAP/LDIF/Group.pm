package App::LDAP::LDIF::Group;

use Modern::Perl;

use Moose;

extends qw(
    App::LDAP::ObjectClass::PosixGroup
);

with qw(
    App::LDAP::LDIF
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
        %params,
    );
}

has dn => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has '+objectClass' => (
    default => sub {
        [
            qw( posixGroup
                top )
        ]
    },
);

has '+userPassword' => (
    default => "{crypt}x",
);

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
