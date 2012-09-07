package App::LDAP::LDIF::OrgUnit;

use Moose;

with qw(
    App::LDAP::LDIF
    App::LDAP::Role::FromEntry
);

sub params_to_args {
    my ($self, %params) = @_;

    my $base = $params{base};
    my $name = $params{name};

    return (
        dn => "ou=$name,$base",
        ou => $name,
    );
}

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
