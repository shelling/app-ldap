use 5.010;
use strict;
use warnings;

package App::LDAP::Config;


use constant locations => qw(
  $ENV{HOME}/.ldaprc
  /etc/ldap.conf
  /etc/ldap/ldap.conf
  /usr/local/etc/ldap.conf
);

sub new {
  my $class = shift;
  bless {} ,$class;
}


sub read {
  my ($class, ) = @_;
  my $self = $class->new;
  for ($class->locations) {
    if (-f $_) {
      open my $config, "<", $_;
      while (<$config>) {
        unless ($_ =~ /(^#|^\n)/) {
          my ($key, $value) = split /\s+/, $_;
          $self->{$key} = $value;
        }
      }
      last;
    }
  }
  $self;
}


1;
