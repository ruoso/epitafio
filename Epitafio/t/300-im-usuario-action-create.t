use warnings;
use strict;

# prevent the original DBIx::Class::ResultSet from loading
BEGIN { $INC{'DBIx/Class/ResultSet.pm'} = 1 }

use Test::More qw(no_plan);
use FindBin;
use lib "${FindBin::Bin}/lib";
use Epitafio::Test::Action;

use aliased 'Epitafio::IM::Usuario::Action::Create';

package Object;
use Moose;
has $_ => (isa => 'Str', is => 'rw') for qw(nome matricula senha ativo);

has in_storage => (isa => 'Bool', is => 'rw', default => 0);

sub insert {
  my($self) = @_;
  $self->in_storage(1);
  return $self;
}

sub ident_condition {{}}

# mock for DBIx::Class::ResultSource
package Source;
use Moose;

sub unique_constraints {}
sub resultset { DBIx::Class::ResultSet->new }

# mock for DBIx::Class::ResultSet
package DBIx::Class::ResultSet;
sub new {
  my $class = shift;
  return bless({}, $class) unless ref $class;
  return $class->new_result;
}

sub new_result { Object->new }

sub result_source { Source->new }

package main;

my $create_user = Create->new(
  ctx => bless({}, 'Catalyst'),
  target_model => DBIx::Class::ResultSet->new,
  criptografia => 'MD5'
);

# can't apply without user info
ok(!$create_user->can_apply);

my %user = (
  matricula       => '12345',
  nome            => 'zedocaixao',
  senha           => 'foobar',
  confirmar_senha => 'foobar'
);

Epitafio::Test::Action::check_can_apply( $create_user => \%user );
$create_user->sync_all;

my $p_hash = $create_user->parameter_hashref;

# atributo confirmar senha não é submetido
ok(!exists $p_hash->{confirmar_senha});

# check if password has been encrypted
isnt($p_hash->{senha}, $user{senha});

my $object = $create_user->do_apply;

is($object->$_, $user{$_}) for qw(nome matricula);
ok($object->ativo);
ok($object->in_storage);
