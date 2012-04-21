package App::LDAP::Command::Del::User;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

sub run {
    my ($self) = shift;

    my $ldap   = App::LDAP->instance->ldap;
    my $config = App::LDAP::Config->instance;

    my $user   = $ARGV[2];

    my ($base, $scope) = split /\?/, $config->{nss_base_passwd};

    my $result = $ldap->search(
        base   => $base,
        scope  => $scope,
        filter => "uid=$user",
    );

    if ($result->count) {
        $ldap->delete($result->entry(0)->dn);
        say "user $user has been deleted";
    } else {
        say "user $user not found";
    }
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
