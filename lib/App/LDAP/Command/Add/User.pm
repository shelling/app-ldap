use 5.010;
use strict;
use warnings;

package App::LDAP::Command::Add::User;
use base qw(App::CLI::Command);
use App::LDAP::LDIF::User;
use Net::LDAP::Entry;

sub run {
  my ($self,) = @_;
  my $LDAP = $self->{app_info}->connection;
  my $config = $self->{app_info}->config;

  my $uid = $LDAP->search(
    base    => $config->{base},
    filter  => "(objectClass=uidNext)",
  )->entry(0)->get_value("uidNumber");

  my $gid = $LDAP->search(
    base    => $config->{base},
    filter  => "(objectClass=gidNext)",
  )->entry(0)->get_value("gidNumber");

  my ($base, $scope) = split /\?/, $config->{nss_base_passwd};
  my $user = App::LDAP::LDIF::User->new(
    dn          => "uid=google,$base",
    uid         => $uid,
    gid         => $gid,
    name        => "google",
    password    => "facebook",
  );

  say $user->entry->ldif;
  my $msg = $LDAP->add($user->entry);
  say $msg->error() if $msg->code;
}


1;
