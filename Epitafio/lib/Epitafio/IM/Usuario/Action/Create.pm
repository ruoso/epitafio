package Epitafio::IM::Usuario::Action::Create;
use Reaction::Class;
extends 'Reaction::InterfaceModel::Action::DBIC::ResultSet::Create';
with 'Epitafio::IM::Usuario::Action::Role::ConfirmarSenha';
with 'Epitafio::IM::Usuario::Action::Role::CriptografarSenha';

use MooseX::Types::Moose qw(Bool);
use Reaction::Types::Core qw(SimpleStr);
use Epitafio::Types::Usuario qw(Matricula);

use namespace::autoclean;

has '+target_model' => (isa => 'DBIx::Class::ResultSet');

has matricula => (
  isa       => Matricula,
  is        => 'rw',
  required  => 1,
  predicate => 'has_matricula',
  lazy_fail => 1
);
has nome  => (
  isa       => SimpleStr,
  is        => 'rw',
  required  => 1,
  predicate => 'has_nome',
  lazy_fail => 1
);
has ativo => (
  isa      => Bool,
  is  => 'rw',
  default => 1
);

around error_for_attribute => sub {
  my $orig  = shift;
  my $self  = shift;
  my($attr) = @_;
  my $attr_name = $attr->name;
  return $self->$orig(@_) unless $attr->name =~ /^senha|confirma_senha$/;
  return 'confirmação da senha não confere' unless $self->senha_confirmada;
  $self->$orig(@_);
};

1;
