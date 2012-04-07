package App::LDAP::Command::Export;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

sub run {
  my ($self,) = @_;
  say "command->export";
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
