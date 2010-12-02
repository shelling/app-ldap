use 5.010;
use strict;
use warnings;

package App::LDAP::Command::Del::User;
use base qw(App::CLI::Command);
use constant options => (

);

sub run {
  my ($self,) = @_;
  my $user = $ARGV[0];
  my $LDAP = $self->{app_info}->connection;
  my ($base, $scope) = split /\?/, $self->{app_info}->config->{nss_base_passwd};
  my $result = $LDAP->search(base => $base, scope => $scope, filter => "cn=$user");
  if ($result->count) {
    $LDAP->delete($result->entry(0)->dn);
    say "user $user has been delete";
  } else {
    say "user $user not found";
  }
}

1;
