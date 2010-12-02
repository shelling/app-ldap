use 5.010;
use strict;
use warnings;

package App::LDAP::Command::Add::User;
use base qw(App::CLI::Command);

sub run {
  my ($self,) = @_;
  say "command->add->user";
}

1;
