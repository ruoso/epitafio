use warnings;
use strict;

use Test::More qw(no_plan);

use aliased 'Epitafio::UI::ViewPort::UserBar';

our $identity;

package AuthProvider;
use Moose;

sub login { $identity = Identity->new(name => 'John Doe') }

package Identity;
use Moose;

has name => (isa => 'Str', is => 'rw', required => 1);

# return success value
sub logout { undef $identity; 1 }

package main;

# don't provide an identity
my $userbar = UserBar->new(
    location => 'userbar',
    ctx => bless({}, 'Catalyst'),
    authentication_provider => AuthProvider->new
);

is_deeply([$userbar->current_events], [qw(login help contact)]);

# we should no-op if we don't have a user
ok(!$userbar->logout);
ok(!$userbar->name);

$userbar->login;
$userbar->identity($identity);

is_deeply([$userbar->current_events], [qw(logout login help contact)]);

is($userbar->name, 'John Doe');
ok($userbar->logout);

ok(!$identity);
ok(!$userbar->identity);
ok(!$userbar->logout);
ok(!$userbar->name);

is_deeply([$userbar->current_events], [qw(login help contact)]);
