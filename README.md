# App::LDAP

App::LDAP is aimed at being a handy tool for system administrator to create/delete accounts, groups, sudoers,
hosts, and more without editing LDIF directly. Besides, it alos provides the abilities similar to migration tools
provided by PADL which makes you easily migrate to LDAP fast within only one tool set. The tool retrives all 
infomation via /etc/ldap.conf or the same file at different locations so that you can command almost the same 
as the time you are using /etc/* files. And all permission would be determined via the UID of users. So, just
configure your LDAP server and client well and install App::LDAP, it would serves there as the tools you are
familiar to.

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

    Following usage example assume that root DN is ou=your,ou=domain.

    $ ldap add user shelling         # add posixAccount shelling to LDAP server

    $ ldap del user shelling         # delete posixAccount shelling from LDAP server

    $ ldap passwd                    # change password of yourself

    $ sudo ldap passwd shelling      # using priviledge of root to change passwd of user shelling on LDAP server
                                     # your ldap.conf and ldap.secret should provide settings identifying root 
                                     # as cn=admin,ou=your,ou=domain

    $ sudo ldap passwd -l shelling   # lock posixAccount shelling

    $ ldap add host dns              # add host dns.your.domain

    $ ldap add group maintainer      # add group maintainer

    $ ldap add sudoer shelling       # set shelling as SUDOer
                                     # the ldap should have schema of SUDOers

    $ ldap ls /                      # show subnodes of root DN

    $ ldap import blah.ldif          # add content of blah.ldif into DB of ldap server

    $ ldap export -o out.ldif --base 'ou=People,dc=example,dc=com'

                                     # export content under ou=People,dc=example,dc=com

## LICENSE

Copyright (C) 2010 shelling

MIT (X11) License
