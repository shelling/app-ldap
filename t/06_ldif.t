use strict;
use Test::More;

BEGIN { 
  my @modules = qw(
    App::LDAP::LDIF
    App::LDAP::LDIF::User
    App::LDAP::LDIF::Group
    App::LDAP::LDIF::Host
    App::LDAP::LDIF::Sudoer
  );

  for (@modules) {
    use_ok($_)
  }
}

done_testing;
