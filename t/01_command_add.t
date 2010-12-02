use strict;
use Test::More;

BEGIN { 
  my @modules = qw(
    App::LDAP::Command::Add
    App::LDAP::Command::Add::User
  );
  for (@modules) {
    use_ok $_
  }
}

done_testing;
