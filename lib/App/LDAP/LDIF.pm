package App::LDAP::LDIF;

use Modern::Perl;

use Net::LDAP::Entry;

use Moose::Role;

with 'App::LDAP::Role';

sub create {

}

sub search {
    my ($class, %options) = @_;

    my $search = ldap()->search(%options);

    if ($search->count) {
        return $class->new( $search->entry(0) );
    } else {
        die $options{filter} . " not found";
    }
}

sub update {

}

sub delete {
    my ($self) = shift;

    my $msg = ldap()->delete($self->dn);

    die $msg->error if $msg->code;
}

sub save {
    # not yet be able to modify()
    my ($self) = shift;

    my $msg = ldap()->add($self->entry);

    die $msg->error if $msg->code;
}

1;

=head1 NAME

App::LDAP::LDIF - base class of models in App::LDAP

=head1 SYNOPSIS

    package App::LDAP::LDIF::Animal

    use Moose;
    with 'App::LDAP::LDIF';

    use Net::LDAP::Entry;

    has name => (
        is  => "rw",
        isa => "Str",
    );

    package Controller;
    my $dog = App::LDAP::LDIF::Animal->new( name => "lucky" );

    my $dog->save;

    my $cat = App::LDAP::LDIF::Animal->find( name => "mou" );
    say $cat->entry->ldif;

=cut

