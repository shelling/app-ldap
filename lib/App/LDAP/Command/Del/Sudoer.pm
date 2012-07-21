package App::LDAP::Command::Del::Sudoer;

use Modern::Perl;

use Moose;

with qw( App::LDAP::Role::Command
         App::LDAP::Role::Bindable );

sub run {

}

__PACKAGE__->meta->make_immutable;
no Moose;


1;
