package App::LDAP::LDIF;

use Modern::Perl;

use Moose::Role;

use Net::LDAP::Entry;

use App::LDAP::Utils;

sub create {

}

sub read {

}

sub update {

}

sub delete {
    my ($self) = shift;
    my %options = @_;

    my $search = ldap->search(@_);

    if ($search->count) {
        ldap->delete($search->entry(0)->dn);
    } else {
        die $options{filter}." not found";
    }
}

sub save {
    my ($self) = shift;

    my $msg = ldap->add($self->entry);

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

    package Controler;
    my $dog = App::LDAP::LDIF::Animal->new( name => "lucky" );

    my $dog->save;

    my $cat = App::LDAP::LDIF::Animal->find( name => "mou" );
    say $cat->entry->ldif;

=cut

