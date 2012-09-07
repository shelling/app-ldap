package App::LDAP::Role::FromEntry;

use Modern::Perl;

use Moose::Role;

with qw( App::LDAP::Role );

sub entry_to_args {
    my ($self, $entry) = @_;

    my %attrs = map {
        my $asref = $self->meta->get_attribute($_)->type_constraint->name ~~ /Ref/;
        $_, $entry->get_value($_, asref => $asref);
    } $entry->attributes;

    return (dn => $entry->dn, %attrs);
}

no Moose;

1;
