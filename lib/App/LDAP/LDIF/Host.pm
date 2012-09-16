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

    my $base = $params{base};
    my $name = $params{name};
    my $ip   = $params{ip};

    return (
        dn           => "cn=$name,$base",
        cn           => [$name],
        ipHostNumber => $ip,
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

sub entry {
    my ($self) = shift;
    my $entry = Net::LDAP::Entry->new( $self->dn );

    $entry->add($_ => $self->$_)
      for qw( cn
              objectClass
              ipHostNumber );

    $entry;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

App::LDAP::LDIF::Host - the representation of hosts in LDAP

=head1 SYNOPSIS

    my $host = App::LDAP::LDIF::Host->new(
        base => $base,           # the OU (organization unit) which the host belongs to
        name => $name,           # the host name
        ip   => $ip,             # the ip of this host
    );

    my $entry = $host->entry;    # get the host as a instance of Net::Ldap::Entry

=cut
