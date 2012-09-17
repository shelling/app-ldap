package App::LDAP::LDIF::Sudoer;

use Modern::Perl;

use Moose;

extends qw(
    App::LDAP::ObjectClass::SudoRole
);

with qw(
    App::LDAP::LDIF
);

sub params_to_args {
    my ($self, %params) = @_;

    my $base = $params{base};
    my $name = $params{name};

    return (
        dn       => "cn=$name,$base",
        cn       => [$name],
        sudoUser => $name,
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
            qw( top
                sudoRole )
        ]
    },
);

has '+sudoUser' => (
    required => 1,
);

has '+sudoHost' => (
    default => "ALL",
);

has '+sudoRunAsUser' => (
    default => "ALL",
);

has '+sudoCommand' => (
    default => "ALL",
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

App::LDAP::LDIF::Sudoer - the representation of sudoers in LDAP

=head1 SYNOPSIS

    my $sudoer = App::LDAP::LDIF::Sudoer->new(
        base => "ou=Sudoer,dc=example,dc=com",
        name => "administrator",
    );

    my $entry = $sudoer->entry;
    # to be Net::LDAP::Entry;

    my $sudoer = App::LDAP::LDIF::Sudoer->new($entry);
    # new from a Net::LDAP::Entry;

=cut

