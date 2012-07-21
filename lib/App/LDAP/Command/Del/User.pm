package App::LDAP::Command::Del::User;

use Modern::Perl;

use Moose;

with qw( App::LDAP::Role::Command
         App::LDAP::Role::Bindable );

use App::LDAP::LDIF::User;

sub run {
    my ($self) = shift;

    my $user   = $self->extra_argv->[2] or die "no username specified";

    App::LDAP::LDIF::User->delete(
        base   => config()->{nss_base_passwd}->[0],
        scope  => config()->{nss_base_passwd}->[1],
        filter => "uid=$user",
    );

}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
