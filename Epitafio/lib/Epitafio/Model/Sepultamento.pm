package Epitafio::Model::Sepultamento;
use Epitafio::ModelUtil;
use Moose;
extends 'Epitafio::Model';

txn_method 'sepultar' => authorized 'operacao' => sub {
  my $self = shift;
  # implement model logic here.
};

txn_method 'search' => authorized 'operacao' =>
  rs_handled => ('Sepultamento' => 'search');

1;
