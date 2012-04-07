use Modern::Perl;
use Test::More;

BEGIN {

    my @modules = qw( App::LDAP::Command
                      App::LDAP::Command::Add
                      App::LDAP::Command::Add::User
                      App::LDAP::Command::Add::Group
                      App::LDAP::Command::Add::Host
                      App::LDAP::Command::Add::Sudoer );

    use_ok $_ for (@modules);

}

is (
    App::LDAP::Command->dispatch(qw(add)),
    "App::LDAP::Command::Add",
    "can dispatch to Command::Add",
);

is (
    App::LDAP::Command->dispatch(qw(add user)),
    "App::LDAP::Command::Add::User",
    "can dispatch to Command::Add::User",
);

is (
    App::LDAP::Command->dispatch(qw(add group)),
    "App::LDAP::Command::Add::Group",
    "can dispatch to Command::Add::Group",
);

is (
    App::LDAP::Command->dispatch(qw(add host)),
    "App::LDAP::Command::Add::Host",
    "can dispatch to Command::Add::Host",
);

is (
    App::LDAP::Command->dispatch(qw(add sudoer)),
    "App::LDAP::Command::Add::Sudoer",
    "can dispatch to Command::Add::Sudoer",
);

done_testing;
