package App::LDAP::Command::Add::Ou;

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

    my $name = $ARGV[2] or die "no organization name specified";

    my $ou = App::LDAP::LDIF::OrgUnit->new(
        base => $self->base // config->{base},
        name => $name,
    );

    $ou->save;

}


__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

App::LDAP::Command::Add::Ou - the handler for adding Organization Units

=cut
