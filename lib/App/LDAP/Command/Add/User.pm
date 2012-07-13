package App::LDAP::Command::Add::User;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

has shell => (
    is  => "rw",
    isa => "Str",
);

has home => (
    is  => "rw",
    isa => "Str",
);

has group => (
    is  => "rw",
    isa => "Str",
);

has base => (
    is  => "rw",
    isa => "Str",
);

use App::LDAP::Utils;
use App::LDAP::LDIF::User;
use App::LDAP::Command::Add::Group;

# {{{ sub run
sub run {
    my ($self) = shift;

    my $uid = next_uid;

    my $username = $ARGV[2] or die "no username specified"; # should validate the username

    my $user = App::LDAP::LDIF::User->new(
        base     => $self->base // config->{nss_base_passwd}->[0],
        name     => $username,
        password => encrypt(new_password()),
        id       => $uid->get_value("uidNumber"),
    );

    $user->loginShell    ( $self->shell )  if $self->shell;
    $user->homeDirectory ( $self->home  )  if $self->home;

    $user->save;

    $uid->replace(uidNumber => $uid->get_value("uidNumber")+1)->update(ldap());

    App::LDAP::Command::Add::Group->new->run;

    say "add user $username successfully";
}
# }}}

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
