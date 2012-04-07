use Modern::Perl;
use Test::More;

BEGIN { 
  my @modules = qw( App::LDAP::Command
                    App::LDAP::Command::Del
                    App::LDAP::Command::Del::User
                    App::LDAP::Command::Del::Group
                    App::LDAP::Command::Del::Host
                    App::LDAP::Command::Del::Sudoer );

  use_ok $_ for (@modules);

}

done_testing;
