package App::LDAP::Command::Del::Group;

use Modern::Perl;

use Moose;

with 'App::LDAP::Role::Command';

use App::LDAP::LDIF::Group;

sub run {
    my ($self) = shift;

    my $group = $self->extra_argv->[2] or die "no group name specified";

    App::LDAP::LDIF::Group->delete(
        base   => config()->{nss_base_group}->[0],
        scope  => config()->{nss_base_group}->[1],
        filter => "cn=$group",
    );

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
