package App::LDAP::Config;

use Modern::Perl;
use Moose;
use MooseX::Singleton;

our @locations = qw(
  $ENV{HOME}/.ldaprc
  /etc/ldap.conf
  /etc/ldap/ldap.conf
  /usr/local/etc/ldap.conf
);

our @has_scope = qw(
    nss_base_passwd
    nss_base_shadow
    nss_base_group
    nss_base_hosts
    sudoers_base
);

sub read {
  my ($class, ) = @_;
  my $self = $class->new;
  for (@locations) {
    if (-f $_) {
      open my $config, "<", $_;
      while (<$config>) {
        unless ($_ =~ /(^#|^\n)/) {
          my ($key, $value) = split /\s+/, $_;
          my @value = split /\?/, $value;
          if ($key ~~ @has_scope) {
              $self->{$key} = [@value];
          } else {
              $self->{$key} = $value;
          }
        }
      }
      last;
    }
  }
  $self;
}

1;
