package App::LDAP::LDIF::Sudoer;

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

        $self->$orig(
            dn       => "cn=$name,$base",
            cn       => $name,
            sudoUser => $name,
        );
    }
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

