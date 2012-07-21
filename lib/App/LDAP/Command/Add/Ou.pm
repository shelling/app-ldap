package App::LDAP::Command::Add::Ou;

use Modern::Perl;

use Moose;

with qw( App::LDAP::Role::Command
         App::LDAP::Role::Bindable );

has base => (
    is  => "rw",
    isa => "Str",
);

use App::LDAP::LDIF::OrgUnit;

sub run {
    my ($self, ) = @_;

    my $name = $self->extra_argv->[2] or die "no organization name specified";

    my $ou = App::LDAP::LDIF::OrgUnit->new(
        base => $self->base // config()->{base},
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
