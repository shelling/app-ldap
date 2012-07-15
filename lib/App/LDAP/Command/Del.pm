package App::LDAP::Command::Del;

use Modern::Perl;

use Moose;

with 'App::LDAP::Role::Command';

sub run {
    my ($self,) = @_;
    say "command->del";
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
