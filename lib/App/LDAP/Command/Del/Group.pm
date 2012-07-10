package App::LDAP::Command::Del::Group;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

use App::LDAP::LDIF::Group;

sub run {
    my ($self) = shift;

    my $group = $ARGV[2] or die "no group name specified";

    my ($base, $scope) = @{App::LDAP::Config->instance->{nss_base_group}};

    App::LDAP::LDIF::Group->delete(
        base   => $base,
        scope  => $scope,
        filter => "cn=$group",
    );

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
