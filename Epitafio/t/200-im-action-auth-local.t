use warnings;
use strict;

use Test::More qw(no_plan);

use aliased 'Epitafio::IM::Action::Authenticate::Web::Local';

our $check;
our $cred;

package App;
use Moose;

sub find_user {
  my($self, $info) = @_;
  $check = $info->{password}, return 1 if $info->{username} eq 'foo';
}

sub authenticate {
  my($self, $info) = @_;
  $cred = $info->{password}, return 1 if $info->{username} eq 'foo';
}

package main;

my $app = App->new;
my $auth = Local->new(ctx => bless({}, 'Catalyst'), target_model => $app);

# can't apply without user info
ok(!$auth->can_apply);

# can't apply with a corrent username and no password
$auth->username('foo');
ok(!$auth->can_apply);

# can't apply with an incorrect username and no password
$auth->username('baz');
ok(!$auth->can_apply);

# can't apply with an incorrect username and a password
$auth->password('barbaz');
ok(!$auth->can_apply);

# should apply with a correct user and a password
$auth->username('foo');
ok($auth->can_apply);

# target model actually checked the password
is($check, 'barbaz');

# target model hasn't used password as the credential
isnt($cred, 'barbaz');

$auth->do_apply;
is($cred, 'barbaz');
