package App::LDAP::LDIF::Host;

use Modern::Perl;

use Moose;

extends qw(
    App::LDAP::ObjectClass::IpHost
    App::LDAP::ObjectClass::Device
);

with qw (
    App::LDAP::LDIF
);

sub params_to_args {
    my ($self, %params) = @_;

    return (
        dn => "cn=" . $params{cn}[0] ."," . $params{base},
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
            qw( top
                ipHost
                device )
        ]
    },
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

App::LDAP::LDIF::Host - the representation of hosts in LDAP

=head1 SYNOPSIS

    my $host = App::LDAP::LDIF::Host->new(
        base         => $base,               # the OU (organization unit) which the host belongs to
        cn           => [$name1, $name2],    # the host name
        ipHostNumber => $ipHostNumber,       # the ip of this host
    );

    my $entry = $host->entry;
    # get the host as a instance of Net::Ldap::Entry

    my $host = App::LDAP::LDIF::Host->new($entry)
    # new from a Net::LDAP::Entry instance

=cut
