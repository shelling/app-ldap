package App::LDAP::Command;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

sub run {
    say "ldap main dispather";
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
