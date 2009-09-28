package Epitafio::IM::Usuario::Action::Role::ConfirmarSenha;
use Reaction::Role;
use Reaction::Types::Core qw(Password);
use MooseX::Types::Moose qw(Bool);

use namespace::autoclean;

requires 'sync_all';
requires 'can_apply';

has senha => (
  isa       => Password,
  is        => 'rw',
  required  => 1,
  lazy_fail => 1,
  trigger_adopt('senha')
);
has confirmar_senha => (
  isa => Password,
  is => 'rw',
  required => 1,
  lazy_fail => 1,
  trigger_adopt('confirmar_senha')
);

has _senha_confirmada => (
  isa => Bool,
  is => 'rw',
  init_arg => undef,
  default => 0,
  clearer => 'clear__senha_confirmada',
  metaclass => 'Reaction::Meta::Attribute'
);

sub adopt_senha { shift->clear__senha_confirmada }
sub adopt_confirmar_senha { shift->clear__senha_confirmada }

sub senha_confirmada { shift->_senha_confirmada }

after sync_all => sub {
  my($self) = @_;
  $self->_senha_confirmada(1) if
    $self->has_senha && $self->has_confirmar_senha
     && ($self->senha eq $self->confirmar_senha);
};

around can_apply => sub {
  my $orig = shift;
  my $self = shift;
  return $self->$orig(@_) && $self->senha_confirmada
};

around parameter_hashref => sub {
  my $orig = shift;
  my $hash = shift->$orig(@_);
  delete $hash->{confirmar_senha};
  return $hash;
};

1;
