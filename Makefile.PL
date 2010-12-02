use inc::Module::Install;
name 'App-LDAP';
all_from 'lib/App/LDAP.pm';
author 'shelling <navyblueshellingford@gmail.com>';
repository "http://github.com/shelling/app-ldap";
license "MIT";
perl_version '5.010';

install_script "bin/ldap";

# requires '';
requires "Net::LDAP";
requires "App::CLI";
requires "Rubyish::Attribute";
requires "Term::ReadPassword";

test_requires 'Test::More';

tests 't/*.t';
author_tests 'xt';


auto_include;
WriteAll;
