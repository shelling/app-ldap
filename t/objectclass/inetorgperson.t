use Modern::Perl;
use Test::More;
use Test::Exception;

BEGIN {
    use_ok 'App::LDAP::ObjectClass::InetOrgPerson';
}

for (qw( audio
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
         mail
         manager
         mobile
         o
         pager
         photo
         roomNumber
         secretary
         uid
         userCertificate
         x500uniqueIdentifier
         preferredLanguage
         userSMIMECertificate
         userPKCS12 )) {
    ok (
        App::LDAP::ObjectClass::InetOrgPerson->meta->has_attribute($_),
        "inetOrgPerson has attribute $_",
    );
}

done_testing;
