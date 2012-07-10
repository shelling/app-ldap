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

use App::LDAP::LDIF::Host;

sub run {
    my ($self) = shift;

    my $hostname = $ARGV[2] or die "no hostname specified";

    my ($base, $scope) = @{App::LDAP::Config->instance->{nss_base_hosts}};
    $base = $self->base // $base;

    my $ip = prompt('x', 'ip address:', '', '');

    my $host = App::LDAP::LDIF::Host->new(
        base => $base,
        name => $hostname,
        ip   => $ip,
    );

    $host->save;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
