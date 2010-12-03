use 5.010;
use strict;
use warnings;

package App::LDAP::LDIF::User;

my @attributes = qw(
  uid
  cn
  objectClass
  userPassword
  shadowLastChange
  shadowMax
  shadowWarning
  loginShell
  uidNumber
  gidNumber
  homeDirectory
);

my %default = (
  objectClass       => [qw(
                          account 
                          posixAccount
                          top
                          shadowAccount
                        )],
  shadowLastChange  => 13735,
  shadowMax         => 99999,
  shadowWarning     => 7,
);

my @require = qw(dn uid gid name password login_shell);

sub new {
  my $self = bless {}, shift;
  $self->set(@_);
  $self;
}

sub attributes {
  my ($self) = @_;
  my $password    = "suspend";
  my $id          = "1017";
  my %attributes            = %default;
  $attributes{uid}          = $self->{name};
  $attributes{cn}           = $self->{name};
  $attributes{userPassword} = $self->{password};
  $attributes{loginShell}   = $self->{login_shell};
  $attributes{uidNumber}    = $self->{uid};
  $attributes{gidNumber}    = $self->{gid};
  $attributes{homeDirectory}= "/home/".$self->{name};
  return %attributes;
}

sub entry {
  my ($self) = @_;
  $self->validate();
  my $entry = Net::LDAP::Entry->new($self->{dn});
  my %attributes = $self->attributes();
  for (@attributes) {
    $entry->add($_ => $attributes{$_});
  }
  $entry;
}

sub validate {
  my ($self) = @_;
  $self->{login_shell} //= '/bin/bash';
  for (@require) {
    defined($self->{$_}) or die "not yet assign all required columns$@";
  }
}

sub set {
  my ($self, %columns) = @_;
  for (@require) {
    $self->{$_} = $columns{$_}
  }
  return $self;
}

sub get {
  my ($self, $column) = @_;
  return $self->{$column};
}

1;
