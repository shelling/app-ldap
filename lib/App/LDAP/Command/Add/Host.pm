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
    my ($self, $app) = @_;

    my $ldap   = $app->ldap;
    my $config = $app->config;

    my $hostname = $ARGV[2] or die "no hostname specified";

    my ($base, $scope) = split /\?/, $config->{nss_base_hosts};
    $base = $self->base // $base;

    my $ip = prompt('x', 'ip address:', '', '');

    my $host = App::LDAP::LDIF::Host->new(
        ou   => $base,
        name => $hostname,
        ip   => $ip,
    );

    my $msg = $ldap->add($host->entry); die $msg->error if $msg->code;

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
