use 5.010;
use strict;
use warnings;

package App::LDAP::Command::Del::User;
use base qw(App::CLI::Command);
use constant options => (

);

sub run {
  my ($self,) = @_;
  say "command->del->user";
}

1;
