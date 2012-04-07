use inc::Module::Install;

name           'App-LDAP';
all_from       'lib/App/LDAP.pm';
author         'shelling <navyblueshellingford@gmail.com>';
repository     'http://github.com/shelling/app-ldap';
license        'MIT';
perl_version   '5.010';

install_script 'bin/ldap';

requires       'Modern::Perl';
requires       'Net::LDAP';
requires       'Moose';
requires       'Term::ReadPassword';
requires       'Authen::SASL';
requires       'Crypt::Password';
requires       'Namespace::Dispatch';
requires       'MooseX::Getopt';

test_requires  'Test::More';

tests          't/*.t t/*/*.t';
author_tests   'xt';

auto_include;
WriteAll;
