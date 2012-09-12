package App::LDAP::Command::Add::User;

use Modern::Perl;

use Moose;

with qw( App::LDAP::Role::Command
         App::LDAP::Role::Bindable );

has shell => (
    is            => "rw",
    isa           => "Str",
    documentation => "the login shell. default /bin/bash.",
);

has home => (
    is            => "rw",
    isa           => "Str",
    documentation => 'the home directory. default /home/\$username',
);

has group => (
    is            => "rw",
    isa           => "Str",
    documentation => 'the group name. default $username',
);

has base => (
    is            => "rw",
    isa           => "Str",
    documentation => 'the organizational unit this user belongs to. default /etc/ldap/ldap.conf nss_base_passwd.',
);

use App::LDAP::LDIF::User;

around prepare => sub {
    my $orig = shift;
    my $self = shift;

    $self->group($self->extra_argv->[2]) unless $self->group;
    # $self->group is the same as user name if undefined

    $self->$orig(@_);
};

# {{{ sub run
sub run {
    my ($self) = shift;

    my $uid = next_uid();

    my $username = $self->extra_argv->[2] or die "no username specified";

    die "user $username already exists" if App::LDAP::LDIF::User->search(
        base   => config()->{nss_base_passwd}->[0],
        scope  => config()->{nss_base_passwd}->[1],
        filter => "uid=$username",
    );

    my $user = App::LDAP::LDIF::User->new(
        base     => $self->base // config()->{nss_base_passwd}->[0],
        name     => $username,
        password => encrypt(new_password()),
        id       => $uid->get_value("uidNumber"),
    );

    $user->loginShell    ( $self->shell )  if $self->shell;
    $user->homeDirectory ( $self->home  )  if $self->home;

    $user->save;

    $uid->replace(uidNumber => $uid->get_value("uidNumber")+1)->update(ldap());

}
# }}}

sub next_uid {
    ldap()->search(
        base   => config()->{base},
        filter => "(objectClass=uidnext)",
    )->entry(0);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

App::LDAP::Command::Add::User - handler for adding users

=head1 SYNOPSIS

    # ldap add user hello

    # ldap add user mark --shell zsh --home /home/developer/mark


=cut
