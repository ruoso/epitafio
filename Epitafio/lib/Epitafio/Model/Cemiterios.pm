package Epitafio::Model::Cemiterios;
use Epitafio::ModelUtil;
use Moose;
use utf8;
extends 'Epitafio::Model';

=over

=item listar_cemiterios_usuario

Retorna os cemitérios que esse usuário tem permissão para ver.

=cut

txn_method 'listar_cemiterios_usuario' => sub {
  my ($self) = shift;

  # datetime de referencia.
  my $ref_time = now;

  $self->dbic->resultset('Cemiterio')->search
    ({ 'me.tt_ini' => { '<=' => $ref_time },
       'me.tt_fim' => { '>' => $ref_time },
       'me.vt_ini' => { '<=' => $ref_time },
       'me.vt_fim' => { '>' => $ref_time },
       'usuarios.tt_ini' => { '<=' => $ref_time },
       'usuarios.tt_fim' => { '>' => $ref_time },
       'usuarios.vt_ini' => { '<=' => $ref_time },
       'usuarios.vt_fim' => { '>' => $ref_time },
       'usuarios.matricula' => $self->user->matricula },
     { join => 'usuarios' })->all;

};


1;
