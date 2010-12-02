use strict;
use Test::More;

BEGIN { 
  my @modules = qw(
    App::LDAP::Command::Del
    App::LDAP::Command::Del::User
  );
  for (@modules) {
    use_ok $_
  }
}

done_testing;
