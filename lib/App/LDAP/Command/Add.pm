package App::LDAP::Command::Add;

use Modern::Perl;

use Moose;

with 'App::LDAP::Role::Command';

sub run {
    my ($self,) = @_;
    ...
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

