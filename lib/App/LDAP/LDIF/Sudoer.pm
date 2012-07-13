package App::LDAP::LDIF::Sudoer;

use Moose;

with 'App::LDAP::LDIF';

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = {@_};
    my $base = $args->{base};
    my $name = $args->{name};

    $self->$orig(
        dn       => "cn=$name,$base",
        cn       => $name,
        sudoUser => $name,
    );

};

has dn => (
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
                sudoRole )
        ]
    },
);

has cn => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has sudoUser => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has sudoHost => (
    is      => "rw",
    isa     => "Str",
    default => "ALL",
);

has sudoRunAsUser => (
    is      => "rw",
    isa     => "Str",
    default => "ALL",
);

has sudoCommand => (
    is      => "rw",
    isa     => "Str",
    default => "ALL",
);

sub entry {
    my ($self) = shift;
    my $entry = Net::LDAP::Entry->new( $self->dn );

    $entry->add($_ => $self->$_)
      for qw( objectClass
              cn
              sudoUser
              sudoHost
              sudoRunAsUser
              sudoCommand );

    $entry;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
