package App::LDAP::Command::Del::Host;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

use App::LDAP::LDIF::Host;

sub run {
    my ($self) = shift;

    my $hostname = $ARGV[2] or die "no hostname specified";

    my ($base, $scope) = split /\?/, App::LDAP::Config->instance->{nss_base_hosts};

    App::LDAP::LDIF::Host->delete(
        base   => $base,
        scope  => $scope,
        filter => "cn=$hostname",
    );

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
