package Epitafio::IM::Action::Sepultamento::EscolherCemiterio;
use Reaction::Class;
use namespace::autoclean;
extends 'Reaction::InterfaceModel::Action';

has model_cemiterios =>
  ( is => 'ro',
    metaclass => 'Reaction::Meta::Attribute',
    handles =>
    { obitos_validos => 'listar_cemiterios_usuario' });

has cemiterio =>
  ( isa => 'DB::Cemiterio', is => 'rw',
    required => 1, lazy_fail => 1,
    valid_values => sub { shift->listar_cemiterios_usuario });

1;
