package App::LDAP::Command::Passwd;
use base qw(App::CLI::Command);
use 5.010;

sub run {
  my ($self,) = @_;
  say "command->passwd";
}


1;
