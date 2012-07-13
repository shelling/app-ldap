package App::LDAP::Command::Passwd;

use Modern::Perl;

use Namespace::Dispatch;

use Moose;

use App::LDAP::Utils;

with 'MooseX::Getopt';

sub run {
    my ($self,) = @_;

    if ( $< == 0 ) {
        $ARGV[1]
        ? change_password(find_user_by_name($ARGV[1]))
        : change_password(current_user);
    } else {
        $ARGV[1]
        ? die "you may not view or modify password information for ".$ARGV[1]
        : change_password(current_user);
    }
}

sub change_password {
    my $user = shift;
    $user->replace(
        userPassword => encrypt(new_password())
    )->update(ldap);
}

sub find_user_by_name {
    my $name = shift;;
    my $search = ldap->search(
        base   => config->{nss_base_passwd}->[0],
        scope  => config->{nss_base_passwd}->[1],
        filter => "uid=$name",
    );
    if ($search->count > 0) {
        return $search->entry(0);
    } else {
        die "user $name not found";
    }
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
