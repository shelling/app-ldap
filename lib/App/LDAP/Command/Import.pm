use 5.010;
use strict;
use warnings;
use Net::LDAP::LDIF;

package App::LDAP::Command::Import;
use base qw(App::CLI::Command);
use constant options => (

);

sub run {
  my ($self) = @_;
  for (@ARGV) {
    (-f $_) ? $self->process($_) : say "$_ don\'t exist. skip.";
  }
}

sub process {
  my ($self, $file) = @_;
  say "import $file...";
  my $LDAP = $self->{app_info}->connection;
  my $LDIF = Net::LDAP::LDIF->new($file, "r", onerror => 'die');
  while (!$LDIF->eof) {
    my $entry = $LDIF->read_entry;
    my $msg = $LDAP->add($entry);
    warn $msg->error() if $msg->code;
  }
}

1;
