package App::LDAP::Role::Command;

{
    package main;
    use Namespace::Dispatch;
}

use Modern::Perl;
use Moose::Role;
with qw( MooseX::Getopt );

sub dispatch {
    Namespace::Dispatch::dispatch(@_);
}

sub has_leaf {
    Namespace::Dispatch::has_leaf(@_);
}

sub leaves {
    Namespace::Dispatch::leaves(@_);
}

no Moose;

1;
