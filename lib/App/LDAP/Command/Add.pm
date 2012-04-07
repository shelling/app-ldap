package App::LDAP::Command::Add;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

sub run {
  my ($self,) = @_;
  say $self->dump;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

