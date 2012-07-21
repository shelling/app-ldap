package App::LDAP::Role::Command;

use Modern::Perl;

sub prepare {
    my $self = shift;
    return $self;
}

{
    package main;
    use Namespace::Dispatch;
}

use Modern::Perl;
use Moose::Role;
with qw( MooseX::Getopt
         App::LDAP::Role );

sub dispatch {
    Namespace::Dispatch::dispatch(@_);
}

sub has_leaf {
    Namespace::Dispatch::has_leaf(@_);
}

sub leaves {
    Namespace::Dispatch::leaves(@_);
}

use Crypt::Password;
sub encrypt {
    my $plain = shift;
    "{crypt}".password($plain, undef, "sha512");
}

use Term::ReadPassword;
sub new_password {
    my $password = read_password("password: ");
    my $comfirm  = read_password("comfirm password: ");

    if ($password eq $comfirm) {
        return $password;
    } else {
        die "not the same";
    }
}

no Moose;

1;
