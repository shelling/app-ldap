package App::LDAP::LDIF::Host;

use Modern::Perl;

use Moose;

with 'App::LDAP::LDIF';

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    if (ref($_[0]) eq 'Net::LDAP::Entry') {
        my $entry = shift;

        my %attrs = map {
            my $asref = $self->meta->get_attribute($_)->type_constraint->name ~~ /Ref/;
            $_, $entry->get_value($_, asref => $asref);
        } $entry->attributes;

        $self->$orig(dn => $entry->dn, %attrs);
    } else {
        my $args = {@_};
        my $base = $args->{base};
        my $name = $args->{name};
        my $ip   = $args->{ip};

        $self->$orig(
            dn           => "cn=$name,$base",
            cn           => $name,
            ipHostNumber => $ip,
        );
    }
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
        base => $base,           # the OU (organization unit) which the host belongs to
        name => $name,           # the host name
        ip   => $ip,             # the ip of this host
    );

    my $entry = $host->entry;    # get the host as a instance of Net::Ldap::Entry

=cut
