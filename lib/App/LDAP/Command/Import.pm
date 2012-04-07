package App::LDAP::Command::Import;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

use Net::LDAP::LDIF;

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
