package App::LDAP::Secret;

use Modern::Perl;
use Moose;
use MooseX::Singleton;
use File::Slurp;

our @locations = qw(
    /etc/ldap.secret
    /etc/libnss-ldap.secret
    /etc/pam_ldap.secret
);

has secret => (
    is  => "rw",
    isa => "Str",
);

sub read {
    my ($class, ) = @_;
    my $self = $class->new;

    my $secret = read_secret(
        grep {
            -f $_ 
        } ( 
            $< == 0 ?
            @locations :
            "$ENV{HOME}/.ldap.secret"
        )
    );

    $self->secret($secret) if $secret;
}

sub read_secret {
    my $file = shift;
    return undef unless $file;

    my $secret = read_file($file);
    chomp $secret;
    return $secret;
}

1;
