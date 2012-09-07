package App::LDAP::LDIF::User;

use Modern::Perl;

use Moose;

with qw(
    App::LDAP::LDIF
    App::LDAP::Role::FromEntry
);

sub params_to_args {
    my ($self, %params) = @_;

    my $base     = $params{base};
    my $name     = $params{name};
    my $id       = $params{id};
    my $password = $params{password};

    return (
        dn            => "uid=$name,$base",
        uid           => $name,
        cn            => $name,
        userPassword  => $password,
        uidNumber     => $id,
        gidNumber     => $id,
        homeDirectory => "/home/$name",
    );
}

has [qw(dn uid cn userPassword uidNumber gidNumber homeDirectory)] => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has objectClass => (
    is      => "rw",
    isa     => "ArrayRef[Str]",
    default => sub {
        [
            qw( account
                posixAccount
                top
                shadowAccount )
        ],
    },
);

has shadowLastChange => (
    is      => "rw",
    isa     => "Str",
    default => "11111",
);

has shadowMax => (
    is      => "rw",
    isa     => "Str",
    default => "99999",
);

has shadowWarning => (
    is      => "rw",
    isa     => "Str",
    default => "7",
);

has loginShell => (
    is      => "rw",
    isa     => "Str",
    default => "/bin/bash",
);

sub entry {
    my ($self) = shift;

    my $entry = Net::LDAP::Entry->new( $self->dn );

    $entry->add($_ => $self->$_)
      for qw( uid
              cn
              objectClass
              userPassword
              shadowLastChange
              shadowMax
              shadowWarning
              loginShell
              uidNumber
              gidNumber
              homeDirectory );

    $entry;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=pod

=head1 NAME

App::LDAP::LDIF::User - the representation of users in LDAP

=head1 SYNOPSIS

    my $user = App::LDAP::LDIF::User->new(
        base     => $base,       # the OU (organization unit) which the user belongs to
        name     => $name,       # user name
        password => $password,   # the password used by the user
        id       => $id,         # the uid of the user, copying to be gid as default
    );

    $user->loginShell("/bin/zsh")
    # set zsh as the user's shell

    $uesr->gidNumber("27")
    # set the user to have 27 as group id

    my $entry = $user->entry     # get the user as a instance of Net::LDAP::Entry

=cut
