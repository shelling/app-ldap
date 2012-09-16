package App::LDAP::LDIF::OrgUnit;

use Modern::Perl;

use Moose;

extends qw(
    App::LDAP::ObjectClass::OrganizationalUnit
);

with qw(
    App::LDAP::LDIF
);

sub params_to_args {
    my ($self, %params) = @_;

    return (
        dn => "ou=" .$params{ou} ."," . $params{base},
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
            qw( organizationalUnit )
        ]
    },
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__

=pod

=head1 NAME

App::LDAP::LDIF::OrgUnit - the representation of organization unit in LDAP

=head1 SYNOPSIS

    my $ou = App::LDAP::LDIF::OrgUnit->new(
        base => $base,
        ou   => $name,
    );

=cut
