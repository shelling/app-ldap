use 5.010;
use strict;
use warnings;

package App::LDAP::Command::Del;
use base qw(App::CLI::Command);
use constant subcommands => qw(User);

use App::LDAP::Command::Del::User; # should be deleted

sub run {
  my ($self,) = @_;
  say "command->del";
}

1;
