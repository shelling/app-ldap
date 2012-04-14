package App::LDAP::Command::Del::User;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

sub run {
    my ($self, $app) = @_;

    my $user   = $ARGV[2];
    my $ldap   = $app->ldap;
    my $config = $app->config;

    my ($base, $scope) = split /\?/, $config->{nss_base_passwd};

    my $result = $ldap->search(
        base   => $base,
        scope  => $scope,
        filter => "uid=$user",
    );

    if ($result->count) {
        $ldap->delete($result->entry(0)->dn);
        say "user $user has been delete";
    } else {
        say "user $user not found";
    }
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
