use 5.010;
use strict;
use warnings;

package App::LDAP::Command::Add::User;
use base qw(App::CLI::Command);
use App::LDAP::LDIF::User;
use Term::ReadPassword;
use Crypt::Password;

sub run {
  my ($self,) = @_;
  my $LDAP = $self->{app_info}->connection;
  my $config = $self->{app_info}->config;

  my $uidnext = $LDAP->search(
    base    => $config->{base},
    filter  => "(objectClass=uidNext)",
  )->entry(0);
  my $uid = $uidnext->get_value("uidNumber");

  my $gidnext = $LDAP->search(
    base    => $config->{base},
    filter  => "(objectClass=gidNext)",
  )->entry(0);
  my $gid = $gidnext->get_value("gidNumber");

  my $username = $ARGV[0] or die "no username specified";
  # need to verify the username is available
  my $password = read_password("password: ");
  my $comfirm  = read_password("comfirm password: ");
  ($password eq $comfirm) or die "not the same";
  $password = '{crypt}'.password($password, undef, "sha512")->{crypted};

  my ($base, $scope) = split /\?/, $config->{nss_base_passwd};
  my $user = App::LDAP::LDIF::User->new(
    dn          => "uid=$username,$base",
    uid         => $uid,
    gid         => $gid,
    name        => $username,
    password    => $password,
  );

  my $msg = $LDAP->add($user->entry);
  die $msg->error() if $msg->code;

  $uidnext->replace(uidNumber => $uid+1)->update($LDAP);
  $gidnext->replace(gidNumber => $gid+1)->update($LDAP);

  say "add user $username successfully";
}


1;
