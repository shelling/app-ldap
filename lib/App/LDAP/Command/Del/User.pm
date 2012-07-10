package App::LDAP::Command::Del::User;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

use App::LDAP::Command::Del::Group;

use App::LDAP::LDIF::User;

sub run {
    my ($self) = shift;

    my $user   = $ARGV[2] or die "no username specified";

    my ($base, $scope) = @{App::LDAP::Config->instance->{nss_base_passwd}};

    App::LDAP::LDIF::User->delete(
        base   => $base,
        scope  => $scope,
        filter => "uid=$user",
    );

    App::LDAP::Command::Del::Group->new->run;

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
