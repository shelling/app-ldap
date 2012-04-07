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

use App::LDAP::Utils;
use App::LDAP::LDIF::User;

use Term::ReadPassword;
use Crypt::Password;

# {{{ sub run
sub run {
    my ($self, $app) = @_;

    my $ldap   = $app->connection;
    my $config = $app->config;

    my $uid = next_uid($app);
    my $gid = next_gid($app);

    my $username = $ARGV[2] or die "no username specified";
    # should verify whether the username is available
    my $password = read_password("password: ");
    my $comfirm  = read_password("comfirm password: ");
    ($password eq $comfirm) or die "not the same";

    my ($base, $scope) = split /\?/, $config->{nss_base_passwd};

    my $user = App::LDAP::LDIF::User->new(
        ou       => $base,
        name     => $username,
        password => '{crypt}'.password($password, undef, "sha512"),
        id       => $uid->get_value("uidNumber"),
    );

    $user->loginShell( $self->shell )    if $self->shell;
    $user->homeDirectory( $self->home )  if $self->home;

    my $msg = $ldap->add($user->entry); die $msg->error() if $msg->code;

    $uid->replace(uidNumber => $uid->get_value("uidNumber")+1)->update($ldap);
    $gid->replace(gidNumber => $gid->get_value("gidNumber")+1)->update($ldap);

    say "add user $username successfully";
}
# }}}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
