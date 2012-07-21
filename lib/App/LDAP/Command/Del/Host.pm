package App::LDAP::Command::Del::Host;

use Modern::Perl;

use Moose;

with qw( App::LDAP::Role::Command
         App::LDAP::Role::Bindable );

use App::LDAP::LDIF::Host;

sub run {
    my ($self) = shift;

    my $hostname = $self->extra_argv->[2] or die "no hostname specified";

    App::LDAP::LDIF::Host->delete(
        base   => config()->{nss_base_hosts}->[0],
        scope  => config()->{nss_base_hosts}->[1],
        filter => "cn=$hostname",
    );

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
