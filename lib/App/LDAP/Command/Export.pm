use 5.010;
use strict;
use warnings;

package App::LDAP::Command::Export;
use base qw(App::CLI::Command);

sub run {
  my ($self,) = @_;
  say "command->export";
}

1;
