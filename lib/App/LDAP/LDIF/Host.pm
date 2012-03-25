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
