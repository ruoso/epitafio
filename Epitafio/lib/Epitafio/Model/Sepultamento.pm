package Epitafio::Model::Sepultamento;
use Epitafio::ModelUtil;
use Moose;
extends 'Epitafio::Model';

txn_method 'sepultar' => authorized 'operacao' => sub {
  my $self = shift;
  # implement model logic here.
};

txn_method $_ => authorized 'operacao' =>
  rs_handled => ('Sepultamento' => $_) for qw(search find all);


1;
