package App::LDAP::Command::Del::Group;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

sub run {
    my ($self) = shift;

    my $ldap   = App::LDAP->instance->ldap;
    my $config = App::LDAP::Config->instance;

    my $group = $ARGV[2];

    my ($base, $scope) = split /\?/, $config->{nss_base_group};

    my $result = $ldap->search(
        base   => $base,
        scope  => $scope,
        filter => "cn=$group",
    );

    if ($result->count) {
        $ldap->delete($result->entry(0)->dn);
        say "group $group has been deleted";
    } else {
        say "group $group not found";
    }

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
