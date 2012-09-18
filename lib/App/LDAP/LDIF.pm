package App::LDAP::LDIF;

use Modern::Perl;

use Net::LDAP::Entry;

use Moose::Role;

with qw(
    App::LDAP::Role
    App::LDAP::Role::FromEntry
);

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    if (ref($_[0]) eq 'Net::LDAP::Entry') {
        $self->$orig( $self->entry_to_args(@_) );
    } else {
        $self->$orig(@_);
    }
};

sub create {

}

sub search {
    my ($class, %options) = @_;

    my $search = ldap()->search(%options);

    if ($search->count) {
        return $class->new( $search->entry(0) );
    } else {
        return undef;
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

sub entry {
    my ($self) = shift;

    my $entry = Net::LDAP::Entry->new( $self->dn );

    $entry->add($_ => $self->$_)
      for grep {
          $self->$_
      } grep {
          !/dn/
      } map {
          $_->name
      } $self->meta->get_all_attributes;

    $entry;
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

