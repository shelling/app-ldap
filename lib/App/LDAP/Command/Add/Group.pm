package App::LDAP::Command::Add::Group;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

with 'MooseX::Getopt';

has base => (
    is  => "rw",
    isa => "Str",
);

use App::LDAP::Utils;
use App::LDAP::LDIF::Group;

# {{{
sub run {
    my ($self) = shift;

    my $ldap   = App::LDAP->instance->ldap;

    my $gid = next_gid;

    my $groupname = $ARGV[2] or die "no group name specified";

    my $base = $self->base // config->{nss_base_group}->[0];

    my $group = App::LDAP::LDIF::Group->new(
        base => $base,
        name => $groupname,
        id   => $gid->get_value("gidNumber"),
    );

    $group->save;

    $gid->replace(gidNumber => $gid->get_value("gidNumber")+1)->update($ldap);
}
# }}}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
