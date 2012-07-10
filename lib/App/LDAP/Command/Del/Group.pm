package App::LDAP::Command::Del::Group;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

use App::LDAP::LDIF::Group;

use App::LDAP::Utils;

sub run {
    my ($self) = shift;

    my $group = $ARGV[2] or die "no group name specified";

    App::LDAP::LDIF::Group->delete(
        base   => config->{nss_base_group}->[0],
        scope  => config->{nss_base_group}->[1],
        filter => "cn=$group",
    );

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
