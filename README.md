# App::LDAP

[![http://travis-ci.org/shelling/app-ldap.png](http://travis-ci.org/shelling/app-ldap.png)](http://travis-ci.org/shelling/app-ldap)

App::LDAP is aimed at being a handy tool for system administrator to create/delete accounts, groups, sudoers, hosts, and
more without editing LDIF directly. Besides, it also provides the abilities similar to migration tools provided by PADL
and a instinctive browser, that can make you easily migrate to LDAP fast within only one tool set. The tool retrives all
infomation via /etc/ldap.conf or the same file at different locations so that you can command almost the same as the
time you are using /etc/* files. And all permission would be determined via the UID of users. So, just configure your
LDAP server and client well and install App::LDAP, it would serves there as the tools you are familiar to and help you
migrate/import/export data rapidly. Enjoy the time managing hundreds of computers without more loading.

## WARNING

This software is under the heavy development and considered ALPHA
quality till the version hits v1.0.0. Things might be broken, not all
features have been implemented, and APIs will be likely to change. YOU
HAVE BEEN WARNED.

## INSTALLATION

App::LDAP installation is straightforward. If your CPAN shell is set up,
you should just be able to do

    $ cpan App::LDAP

Download it, unpack it, then build it as per the usual:

    $ perl Makefile.PL
    $ make && make test

Then install it:

    $ make install

## DOCUMENTATION

App::LDAP documentation is available as in POD. So you can do:

    $ perldoc App::LDAP

to read the documentation online with your favorite pager.

## USAGE

Assume your base is `dc=example,dc=org` which has been set up in /etc/ldap/ldap.conf or a acceptable place. and there are
also some Organizational Units has been set up for nss and pam modules as following.

+ ou=people,dc=example,dc=com
+ ou=groups,dc=example,dc=com
+ ou=hosts,dc=exampke,dc=com
+ ou=sudoers,dc=example,dc=com

App::LDAP also requires some third-party schemas to function. These schemas are shipped with the project in the folder
`schema/`. You can import them into the LDAP server via `$ ldapadd -Y EXTERNAL -I LDAPI:/// -f schema.ldif` or do it via
App::LDAP.

    $ sudo ldap init                      # configure server to load schema/* at runtime
    
After accomplishing all prerequisites, The schemas have been supported in App::LDAP::LDIF::* can be added or deleted vi
command line.

    $ sudo ldap add user shelling         # add posixAccount `uid=shelling,ou=people,dc=example,dc=com`

    $ sudo ldap add group maintainer      # add posixGroup `cn=maintainer,dc=groups,dc=example,dc=com`

    $ sudo ldap del user shelling         # delete posixAccount `uid=shelling,ou=people,dc=example,dc=com`

    $ sudo ldap del group maintainer      # delete posixGroup `cn=maintainer,dc=groups,dc=example,dc=com`

    $ sudo ldap add sudoer shelling       # set sudoer `cn=shelling,ou=sudoers,dc=example,dc=com`

    $ sudo ldap add host dns              # add host `cn=dns,ou=hosts,dc=example,dc=com`

    $ sudo ldap add ou test               # add organizational unit `ou=test,dc=example,dc=com`

App::LDAP can guess your role from your UID, and help you to change your password.

    $ ldap passwd                         # change password of yourself

    $ sudo ldap passwd shelling           # using priviledge of ldap admin to change passwd of shelling

    $ sudo ldap passwd shelling -l        # lock shelling

    $ sudo ldap passwd shelling -u        # unlock shelling
    
Doing backup and restoring are also supported.

    $ sudo ldap import blah.ldif          # add content of blah.ldif

    $ sudo ldap export out.ldif           # save all entries under `dc=example,dc=com` into out.ldif
                                     
## LICENSE

Copyright (C) 2010 shelling

MIT (X11) License
