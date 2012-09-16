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

    return (
        dn => "cn=" .$params{cn} . "," . $params{base},
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
        base      => $base,            # The OU (organization unit) which the group belongs to
        cn        => $name,            # the group name
        gidNumber => $id,              # the gid of the group
    );
    # these three attributes are required

    my $entry = $group->entry;
    # get the group as a instance of Net::LDAP::Entry

    my $group = App::LDAP::LDIF::Group->new($entry)
    # new from a entry

=cut
