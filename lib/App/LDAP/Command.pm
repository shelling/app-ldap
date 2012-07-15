package App::LDAP::Command;

use Modern::Perl;

use Moose;

with 'App::LDAP::Role::Command';

sub run {
    my ($self,) = @_;
    say "ldap main dispather";
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
