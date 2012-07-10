package App::LDAP::Command::Del::Host;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

use App::LDAP::LDIF::Host;

use App::LDAP::Utils;

sub run {
    my ($self) = shift;

    my $hostname = $ARGV[2] or die "no hostname specified";

    App::LDAP::LDIF::Host->delete(
        base   => config->{nss_base_hosts}->[0],
        scope  => config->{nss_base_hosts}->[1],
        filter => "cn=$hostname",
    );

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
