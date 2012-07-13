package App::LDAP::Command::Del::Ou;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

has base => (
    is  => "rw",
    isa => "Str",
);

use App::LDAP::Utils;
use App::LDAP::LDIF::OrgUnit;

sub run {
    my ($self, ) = @_;

    my $ou = $ARGV[2] or die "no organization name specified";

    App::LDAP::LDIF::OrgUnit->delete(
        base   => config->{base},
        scope  => config->{scope},
        filter => "ou=$ou",
    );

}

1;

=pod

=head1 NAME

App::LDAP::Command::Del::Ou - the handler for deleting Organization Units

=cut
