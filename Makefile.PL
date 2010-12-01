use inc::Module::Install;
name 'App-LDAP';
all_from 'lib/App/LDAP.pm';

# requires '';
requires "Net::LDAP";
requires "Rubyish::Attribute";

tests 't/*.t';
author_tests 'xt';

install_script "bin/ldap";

test_requires 'Test::More';
repository "http://github.com/shelling/app-ldap";
auto_include;
WriteAll;
