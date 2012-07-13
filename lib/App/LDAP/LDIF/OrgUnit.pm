package App::LDAP::LDIF::OrgUnit;

use Moose;

with 'App::LDAP::LDIF';

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = {@_};
    my $base = $args->{base};
    my $name = $args->{name};

    $self->$orig(
        dn => "ou=$name,$base",
        ou => $name,
    );

};

has [qw(dn ou)] => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has objectClass => (
    is      => "rw",
    isa     => "ArrayRef[Str]",
    default => sub {
        [
            qw( organizationalUnit )
        ]
    },
);

sub entry {
    my ($self) = shift;

    my $entry = Net::LDAP::Entry->new( $self->dn );

    $entry->add($_ => $self->$_)
      for qw( ou
              objectClass );

    $entry;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__

=pod

=head1 NAME

App::LDAP::LDIF::OrgUnit - the representation of organization unit in LDAP

=head1 SYNOPSIS

    my $ou = App::LDAP::LDIF::OrgUnit->new(
        name => $name,
        base => $base,
    );

=cut
