package App::LDAP::Command::Add::Host;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

has base => (
    is  => "rw",
    isa => "Str",
);

use Term::Prompt;

use App::LDAP::Utils;
use App::LDAP::LDIF::Host;

sub run {
    my ($self) = shift;

    my $hostname = $ARGV[2] or die "no hostname specified";

    my $ip = prompt('x', 'ip address:', '', '');

    my $host = App::LDAP::LDIF::Host->new(
        base => $self->base // config->{nss_base_hosts}->[0],
        name => $hostname,
        ip   => $ip,
    );

    $host->save;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
