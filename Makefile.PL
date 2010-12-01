use inc::Module::Install;
name 'App-LDAP';
all_from 'lib/App/LDAP.pm';
author 'shelling <navyblueshellingford@gmail.com>';
repository "http://github.com/shelling/app-ldap";
license "gpl";
perl_version '5.010';

# requires '';
requires "Net::LDAP";
requires "App::CLI";
requires "Rubyish::Attribute";

test_requires 'Test::More';

tests 't/*.t';
author_tests 'xt';

install_script "bin/ldap";

auto_include;
WriteAll;
