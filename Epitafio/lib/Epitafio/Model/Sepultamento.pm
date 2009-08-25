package Epitafio::Model::Sepultamento;
use Epitafio::ModelUtil;
use Moose;
use utf8;
extends 'Epitafio::Model';

=over

=item sepultar

Regitra um sepultamento. Recebe um hashref contendo o id_obito,
id_jazigo, matr_responsavel e a vt_reg do sepultamento.

=cut

txn_method 'sepultar' => authorized 'operacao' => sub {
  my ($self, $dados) = shift;

  # datetime de referencia.
  my $ref_time = now;

  # primeiro precisamos localizar o óbito referido.
  my $obito = $self->dbic->resultset('Obito')
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>' => $ref_time },
             id_obito => $dados->{id_obito} })
      || die 'Obito não encontrado';

  # agora precisamos garantir que esse óbito não foi removido e nem
  # cremado.
  $obito->remocoes
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>'  => $ref_time }})
      && die 'Obito removido não pode ser sepultado';

  $obito->cremacoes
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>'  => $ref_time }})
      && die 'Obito cremado não pode ser sepultado';

  # também precisamos ver se esse óbito não tem um sepultamento não
  # exumado.
  $obito->sepultamentos
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>' => $ref_time },
             'exumacao.tt_ini' => { '<=' => $ref_time },
             'exumacao.tt_fim' => { '>' => $ref_time },
             'exumacao.id_exumacao' => undef },
           { join => 'exumacao' })
      || die 'Existe um sepultamento não exumado';

  # antes de sepultar, vamos localizar o jazigo.
  my $jazigo = $self->dbic->resultset('Jazigo')
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>' => $ref_time },
             id_jazigo => $dados->{id_jazigo} })
      || die 'Jazigo não encontrado';

  # vamos ver se o jazigo está realmente vago
  $jazigo->obitos
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>' => $ref_time },
             vt_ini => { '<=' => $ref_time },
             vt_fim => { '>' => $ref_time } })
      && die 'Jazigo não está vago';

  # vamos criar o registro do sepultamento.
  my $sepultamento = $obito->sepultamentos
    ->create({ tt_ini => $ref_time,
               tt_fim => 'infinity',
               vt_reg => $dados->{vt_reg},
               au_usr => $self->user->matricula,
               id_jazigo => $dados->{id_jazigo},
               matr_responsavel => $dados->{matr_responsavel} });

  # vamos estabelecer a relação entre o óbito e o jazigo
  $obito->jazigos
    ->create({ tt_ini => $ref_time,
               tt_fim => 'infinity',
               au_usr => $self->user->matricula,
               id_jazigo => $dados->{id_jazigo},
               vt_ini => $dados->{vt_reg},
               vt_fim => 'infinity' });

  # esse sepultamento encerra uma exumacao?
  my $exumacao = $obito->exumacoes
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>' => $ref_time },
             id_cremacao_destino => undef,
             id_remocao_destino => undef,
             id_sepultamento_destino => undef });
  if ($exumacao) {
    # então vamos atualizar a exumação para encerrar.
    $exumacao->update({ tt_fim => $ref_time });
    $obito->exumacoes
      ->create({ tt_ini => $ref_time,
                 tt_fim => 'infinity',
                 id_sepultamento_destino => $sepultamento->id_sepultamento,
                 au_usr => $self->user->matricula,
                 map { $_ => $exumacao->$_() }
                 qw( id_exumacao vt_reg matr_responsavel
                     id_sepultamento_origem ) });
  }

};

=item jazigos_disponiveis

Este método irá buscar uma lista de jazigos vagos, pela órdem da data
em que o último óbito foi exumado, ou que nunca tenham recebido nenhum
óbito. Esta lista não implica uma reserva, o escalonamento em si ainda
depende de atividade humana.

Não recebe nenhum parâmetro e retorna uma lista.

=cut

txn_method 'jazigos_disponiveis' => readonly authorized 'operacao' => sub {
  my $self = shift;

  # datetime de referencia.
  my $ref_time = now;

  $self->dbic->resultset('Jazigo')->search
    ({ 'tt_ini' => { '<=' => $ref_time },
       'tt_fim' => { '>' => $ref_time },
       'obitos.tt_ini' => { '<=' => $ref_time },
       'obitos.tt_fim' => { '>' => $ref_time },
     { join => 'obitos' },
       group_by => [qw(id_jazigo vt_ini vt_fim tt_ini tt_fim
                       au_usr id_lote identificador tipo)],
       '+select' => [\"MAX(CASE WHEN obitos.vt_fim IS NULL THEN -1 ELSE obitos.vt_fim END)"],
       '+as' => ['ultimo_sepultamento'],
       'order_by' => 'ultimo_sepultamento',
       'rows' => 10,
     })->all;

};

1;
