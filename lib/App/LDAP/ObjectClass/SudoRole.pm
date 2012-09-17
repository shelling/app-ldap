package App::LDAP::ObjectClass::SudoRole;

use Modern::Perl;

use Moose;

extends qw(App::LDAP::ObjectClass::Top);

has cn => (
    is       => "rw",
    isa      => "ArrayRef[Str]",
    required => 1,
);

has sudoUser => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has [qw( sudoHost
         sudoCommand
         sudoRunAs
         sudoRunAsUser
         sudoRunAsGroup
         sudoOption
         description )] => (
    is  => "rw",
    isa => "Str",
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=pod

=head1 NAME

App::LDAP::ObjectClass::SudoRole - schema of sudoRole

=head1 DEFINITION

    objectclass (
        1.3.6.1.4.1.15953.9.2.1
        NAME 'sudoRole'
        SUP top
        STRUCTURAL
        DESC 'Sudoer Entries'
        MUST ( cn )
        MAY ( sudoUser $ sudoHost $ sudoCommand $ sudoRunAs $
              sudoRunAsUser $ sudoRunAsGroup $ sudoOption $ description )
    )

=cut
