use 5.010;
use strict;
use warnings;

package App::LDAP::Command::Add;
use base qw(App::CLI::Command);
use constant subcommands => qw(User);

use App::LDAP::Command::Add::User; # should be deleted

sub run {
  my ($self,) = @_;
  say "command->add";
}

1;
