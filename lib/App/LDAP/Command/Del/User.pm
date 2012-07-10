package App::LDAP::Command::Del::User;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

use App::LDAP::Command::Del::Group;

use App::LDAP::LDIF::User;

use App::LDAP::Utils;

sub run {
    my ($self) = shift;

    my $user   = $ARGV[2] or die "no username specified";

    App::LDAP::LDIF::User->delete(
        base   => config->{nss_base_passwd}->[0],
        scope  => config->{nss_base_passwd}->[1],
        filter => "uid=$user",
    );

    App::LDAP::Command::Del::Group->new->run;

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
