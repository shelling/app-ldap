package App::LDAP::Command::Import;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

use Net::LDAP::LDIF;

sub run {
    my ($self) = shift;

    my $app  = App::LDAP->instance;
    my $ldap = $app->ldap;

    shift @ARGV;
    process($ldap, $_) for @ARGV;
}

sub process {
    my ($ldap, $file) = @_;

    if (-f $file) {

        say "import $file...";

        my $ldif = Net::LDAP::LDIF->new($file, "r", onerror => 'die');

        while (!$ldif->eof) {
            my $entry = $ldif->read_entry;
            my $msg = $ldap->add($entry);
            warn $msg->error() if $msg->code;
        }

    } else {
        say "$_ don\'t exist. skip.";
        return;
    }

}

1;

=pod

=head1 NAME

App::LDAP::Command::Import

=head1 SYNOPSIS

    $ ldap import people.ldif

=cut
