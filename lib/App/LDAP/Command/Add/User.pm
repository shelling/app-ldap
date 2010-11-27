package App::LDAP::Command::Add::User;
use base qw(App::CLI::Command);
use 5.010;

sub run {
  my ($self,) = @_;
  say "command->add->user";
}

1;
