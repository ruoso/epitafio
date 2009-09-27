package Epitafio::IM::Action::EscolherCemiterio;
use Reaction::Class;
use namespace::autoclean;
extends 'Reaction::InterfaceModel::Action';

has cemiterio =>
  ( isa => 'Epitafio::DB::Cemiterio', is => 'rw',
    required => 1, lazy_fail => 1,
    valid_values => sub { shift->target_model->listar_cemiterios_usuario });

1;
