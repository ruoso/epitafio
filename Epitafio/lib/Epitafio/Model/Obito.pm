package Epitafio::Model::Obito;
use Epitafio::ModelUtil;
use Moose;
use utf8;
extends 'Epitafio::ModelCemiterio';

=over

=item listar_obitos_em_aberto

Retorna os óbitos que não tiveram uma resolução, seja ela
sepultamento, cremação ou remoção.

=cut

txn_method 'listar_obitos_em_aberto' => authorized 'operacao' => sub {
  my ($self, $dados) = shift;

  # datetime de referencia.
  my $ref_time = now;

  $self->dbic->resultset('Obito')->search
    ({ 'me.tt_ini' => { '<=' => $ref_time },
       'me.tt_fim' => { '>' => $ref_time },
       'me.vt_reg' => { '<=' => $ref_time },
       'me.id_cemiterio' => $self->cemiterio->id_cemiterio,
       'remocoes.id_remocao' => undef,
       'remocoes.tt_ini' => { '<=' => $ref_time },
       'remocoes.tt_fim' => { '>' => $ref_time },
       'remocoes.vt_reg' => { '<=' => $ref_time },
       'cremacoes.id_cremacao' => undef,
       'cremacoes.tt_ini' => { '<=' => $ref_time },
       'cremacoes.tt_fim' => { '>' => $ref_time },
       'cremacoes.vt_reg' => { '<=' => $ref_time },
       'obitos_jazigo.id_jazigo' => undef,
       'obitos_jazigo.tt_ini' => { '<=' => $ref_time },
       'obitos_jazigo.tt_fim' => { '>' => $ref_time },
       'obitos_jazigo.vt_ini' => { '<=' => $ref_time },
       'obitos_jazigo.vt_fim' => { '>' => $ref_time }},
     { join => ['remocoes','cremacoes','obitos_jazigo'],
       'order_by' => 'nome',
     });

};


1;
