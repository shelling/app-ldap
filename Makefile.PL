use inc::Module::Install;
name 'App-LDAP';
all_from 'lib/App/LDAP.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
