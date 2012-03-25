package App::LDAP::LDIF::Host;

use Moose;

use Net::LDAP::Entry;

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = {@_};
    my $ou   = $args->{ou};
    my $name = $args->{name};
    my $ip   = $args->{ip};

    $self->$orig(
        dn           => "cn=$name,$ou",
        cn           => $name,
        ipHostNumber => $ip,
    );

};

has dn => (
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
            qw( top
                ipHost
                device )
        ]
    },
);

has ipHostNumber => (
    is       => "rw",
    isa      => "Str",
    required => 1,
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
        ou   => $ou,             # the OU (organization unit) which the host belongs to
        name => $name,           # the host name
        ip   => $ip,             # the ip of this host
    );

    my $entry = $host->entry;    # get the host as a instance of Net::Ldap::Entry

=cut
