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

use Term::ReadPassword;
use Crypt::Password;

# {{{ sub run
sub run {
    my ($self) = shift;

    my $ldap   = App::LDAP->instance->ldap;
    my $config = App::LDAP::Config->instance;

    my $uid = next_uid;

    my $username = $ARGV[2] or die "no username specified"; # should validate the username
    my $password = read_password("password: ");
    my $comfirm  = read_password("comfirm password: ");
    ($password eq $comfirm) or die "not the same";

    my ($base, $scope) = split /\?/, $config->{nss_base_passwd};
    $base = $self->base // $base;

    my $user = App::LDAP::LDIF::User->new(
        ou       => $base,
        name     => $username,
        password => '{crypt}'.password($password, undef, "sha512"),
        id       => $uid->get_value("uidNumber"),
    );

    $user->loginShell    ( $self->shell )  if $self->shell;
    $user->homeDirectory ( $self->home  )  if $self->home;

    $user->save;

    $uid->replace(uidNumber => $uid->get_value("uidNumber")+1)->update($ldap);

    App::LDAP::Command::Add::Group->new->run;

    say "add user $username successfully";
}
# }}}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
