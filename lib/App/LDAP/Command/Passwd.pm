use 5.010;
use strict;
use warnings;

package App::LDAP::Command::Passwd;
use base qw(App::CLI::Command);

sub run {
  my ($self,) = @_;
  say "command->passwd";
}


1;
