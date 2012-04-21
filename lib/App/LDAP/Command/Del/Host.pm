package App::LDAP::Command::Del::Host;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

sub run {
    my ($self) = shift;

    my $app    = App::LDAP->instance;
    my $ldap   = $app->ldap;
    my $config = $app->config;

    my $hostname = $ARGV[2] or die "no hostname specified";

    my ($base, $scope) = split /\?/, $config->{nss_base_hosts};

    my $result = $ldap->search(
        base   => $base,
        scope  => $scope,
        filter => "cn=$hostname",
    );

    if ($result->count) {
        $ldap->delete($result->entry(0)->dn);
        say "host $hostname has been delete";
    } else {
        say "host $hostname not found";
    }

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
