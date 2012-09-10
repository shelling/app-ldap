package App::LDAP::Command::Add::Group;

use Modern::Perl;

use Moose;

with qw( App::LDAP::Role::Command
         App::LDAP::Role::Bindable );

has base => (
    is  => "rw",
    isa => "Str",
);

use App::LDAP::LDIF::Group;

# {{{
sub run {
    my ($self) = shift;

    my $gid = next_gid();

    my $groupname = $self->extra_argv->[2] or die "no group name specified";

    die "group $groupname already exists" if App::LDAP::LDIF::Group->search(
        base   => config()->{nss_base_group}->[0],
        scope  => config()->{nss_base_group}->[1],
        filter => "cn=$groupname",
    );

    my $group = App::LDAP::LDIF::Group->new(
        base => $self->base // config()->{nss_base_group}->[0],
        name => $groupname,
        id   => $gid->get_value("gidNumber"),
    );

    $group->save;

    $gid->replace(gidNumber => $gid->get_value("gidNumber")+1)->update(ldap());
}
# }}}

sub next_gid {
    ldap()->search(
        base   => config()->{base},
        filter => "(objectClass=gidnext)",
    )->entry(0);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
