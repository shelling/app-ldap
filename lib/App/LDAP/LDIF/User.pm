package App::LDAP::LDIF::User;

use Modern::Perl;

use Moose;

with qw(
    App::LDAP::LDIF
);

sub params_to_args {
    my ($self, %params) = @_;

    my $base     = delete $params{base};
    my $name     = delete $params{name};
    my $password = delete $params{password};

    return (
        dn            => "uid=$name,$base",
        uid           => $name,
        cn            => $name,
        userPassword  => $password,
        homeDirectory => "/home/$name",
        %params,
    );
}

# posixAccount and shadowAccount

has [qw(dn uid cn userPassword uidNumber gidNumber homeDirectory)] => (
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has objectClass => (
    is      => "rw",
    isa     => "ArrayRef[Str]",
    default => sub {
        [
            qw( inetOrgPerson
                posixAccount
                top
                shadowAccount )
        ],
    },
);

has shadowLastChange => (
    is      => "rw",
    isa     => "Str",
    default => "11111",
);

has shadowMin => (
    is      => "rw",
    isa     => "Num",
    default => 0,
);

has shadowMax => (
    is      => "rw",
    isa     => "Num",
    default => 99999,
);

has shadowWarning => (
    is      => "rw",
    isa     => "Num",
    default => 7,
);

has [qw( shadowInactive shadowExpire shadowFlag )] => (
    is  => "rw",
    isa => "Num",
);

has loginShell => (
    is      => "rw",
    isa     => "Str",
    default => "/bin/bash",
);

has gecos => (
    is  => "rw",
    isa => "Str",
);

has description => (
    is  => "rw",
    isa => "Str",
);

# inetOrgPerson

has sn => (                     # person
    is       => "rw",
    isa      => "Str",
    required => 1,
);

has mail => (                   # inetOrgPerson
    is       => "rw",
    isa      => "ArrayRef[Str]",
    required => 1,
);

has [qw( audio
         businessCategory
         carLicense
         departmentNumber
         displayName
         employeeNumber
         employeeType
         givenName
         homePhone
         homePostalAddress
         initials
         jpegPhoto
         labeledURI
         manager
         mobile
         o
         pager
         photo
         roomNumber
         secretary
         userCertificate
         x500uniqueIdentifier
         preferredLanguage
         userSMIMECertificate
         userPKCS12

         title
         x121Address
         registeredAddress
         destinationIndicator
         preferredDeliveryMethod
         telexNumber
         teletexTerminalIdentifier
         telephoneNumber
         internationaliSDNNumber
         facsimileTelephoneNumber
         street
         postOfficeBox
         postalCode
         postalAddress
         physicalDeliveryOfficeName
         ou
         st
         l

         seeAlso )] => (
    is  => "rw",
    isa => "Str",
);

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

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=pod

=head1 NAME

App::LDAP::LDIF::User - the representation of users in LDAP

=head1 SYNOPSIS

    my $user = App::LDAP::LDIF::User->new(
        base      => $base,       # the OU (organization unit) which the user belongs to
        name      => $name,       # user name
        password  => $password,   # the password used by the user
        uidNumber => $uid,        # the uid of the user
        gidNumber => $gid,        # the gid of the user
        sn        => $sn,         # the surname of this user
        mail      => [$mail],     # mail addresses, obviously
    );
    # these 7 parameters are required
    # extra parameters of attributes such as title of User can be provided in constructor, too.
    # attributes dn, uid, cn, userPassword and homeDirectory would be
    # derived from base, name and password
    # DO NOT give these attributes in constructor

    $user->loginShell("/bin/zsh")
    # set zsh as the user's shell

    $uesr->gidNumber("27")
    # set the user to have 27 as group id

    my $entry = $user->entry
    # get the user as a instance of Net::LDAP::Entry

    my $from_entry = App::LDAP::LDIF::User->new($entry)
    # new from a Net::LDAP::Entry instance

=head1 DESCRIPTION



=head1 objectClass

App::LDAP::LDIF::User is composed of objectClass top, posixAccount, shadowAccount and inetOrgPerson.

The objectClass top is described in RFC2256 (core.schema of OpenLDAP) indicating this kind of entry MUST have objectClass.

The early versions used objectClass account rather than inetOrgPerson. Both account and inetOrgPerson are STRUCTURAL so
that only one of them could be satisfied.

The objectClass posixAccount and shadowAccount are described in RFC2307 (nis.schema of OpenLDAP).

The objectClass inetOrgPerson is described in RFC2798 (inetorgperson.schema of OpenLDAP). The inetOrgPerson is derived
from organizationalPerson which is derived from person.

Here is the copy of the definitions of these objectClass:

=head2 posixAccount

    objectclass ( 1.3.6.1.1.1.2.0 NAME 'posixAccount'
        DESC 'Abstraction of an account with POSIX attributes'
        SUP top AUXILIARY
        MUST ( cn $ uid $ uidNumber $ gidNumber $ homeDirectory )
        MAY ( userPassword $ loginShell $ gecos $ description )
    )

=head2 shadowAccount

    objectclass ( 1.3.6.1.1.1.2.1
        NAME 'shadowAccount'
        DESC 'Additional attributes for shadow passwords'
        SUP top AUXILIARY
        MUST uid
        MAY ( userPassword $ shadowLastChange $ shadowMin $
              shadowMax $ shadowWarning $ shadowInactive $
              shadowExpire $ shadowFlag $ description )
    )

=head2 inetOrgPerson

    objectclass	( 2.16.840.1.113730.3.2.2
        NAME 'inetOrgPerson'
        DESC 'RFC2798: Internet Organizational Person'
        SUP organizationalPerson
        STRUCTURAL
        MAY (
            audio $ businessCategory $ carLicense $ departmentNumber $
            displayName $ employeeNumber $ employeeType $ givenName $
            homePhone $ homePostalAddress $ initials $ jpegPhoto $
            labeledURI $ mail $ manager $ mobile $ o $ pager $
            photo $ roomNumber $ secretary $ uid $ userCertificate $
            x500uniqueIdentifier $ preferredLanguage $
            userSMIMECertificate $ userPKCS12
        )
    )

=head2 organizationalPerson

    objectclass ( 2.5.6.7 NAME 'organizationalPerson'
        DESC 'RFC2256: an organizational person'
        SUP person STRUCTURAL
        MAY (
            title $ x121Address $ registeredAddress $ destinationIndicator $
            preferredDeliveryMethod $ telexNumber $ teletexTerminalIdentifier $
            telephoneNumber $ internationaliSDNNumber $ 
            facsimileTelephoneNumber $ street $ postOfficeBox $ postalCode $
            postalAddress $ physicalDeliveryOfficeName $ ou $ st $ l
        )
    )

=head2 person

    objectclass ( 2.5.6.6 NAME 'person'
        DESC 'RFC2256: a person'
        SUP top STRUCTURAL
        MUST ( sn $ cn )
        MAY ( userPassword $ telephoneNumber $ seeAlso $ description )
    )

=head1 NOTES

=head2 userPassword

The objectClass posixAccount and shadowAccount define userPassword MAY be an attribute of a uesr. Because App::LDAP is
designed for working with pam_ldap, userPassword is defined as a required attribute here.

=head2 sn

The objectClass inetOrgPerson is derived from organizationalPerson which is derived from person. The person defines sn
MUST be a attribute of a user. Since the inetOrgPerson has sn as a required attribute.

=head2 mail

the objectClass inetOrgPerson defines mail MAY be an attributes of a user. However, in most situations that
inetOrgPerson is applied, mail is a necessary attribute. Since, App::LDAP defines mail as an required attribute here.

=cut
