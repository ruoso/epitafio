package Epitafio::Model::Sepultamento;
use Epitafio::ModelUtil;
use Moose;
use utf8;
extends 'Epitafio::ModelCemiterio';

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
  my $obito = $self->cemiterio->obitos
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
    ->find({ 'me.tt_ini' => { '<=' => $ref_time },
             'me.tt_fim' => { '>' => $ref_time },
             'exumacao.tt_ini' => { '<=' => $ref_time },
             'exumacao.tt_fim' => { '>' => $ref_time },
             'exumacao.id_exumacao' => undef },
           { join => 'exumacao' })
      || die 'Existe um sepultamento não exumado';

  # antes de sepultar, vamos localizar o jazigo.
  my $jazigo = $self->dbic->resultset('Jazigo')
    ->find({ 'me.tt_ini' => { '<=' => $ref_time },
             'me.tt_fim' => { '>' => $ref_time },
             'me.id_jazigo' => $dados->{id_jazigo},
             'cemiterio.id_cemiterio' => $self->cemiterio->id_cemiterio },
           { join => { lote => { quadra => 'cemiterio' }}})
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
    ({ 'me.tt_ini' => { '<=' => $ref_time },
       'me.tt_fim' => { '>' => $ref_time },
       'me.vt_ini' => { '<=' => $ref_time },
       'me.vt_fim' => { '>' => $ref_time },
       'obitos_jazigo.tt_ini' => { '<=' => $ref_time },
       'obitos_jazigo.tt_fim' => { '>' => $ref_time },
       'lote.tt_ini' => { '<=' => $ref_time },
       'lote.tt_fim' => { '>' => $ref_time },
       'lote.vt_ini' => { '<=' => $ref_time },
       'lote.vt_fim' => { '>' => $ref_time },
       'quadra.tt_ini' => { '<=' => $ref_time },
       'quadra.tt_fim' => { '>' => $ref_time },
       'quadra.vt_ini' => { '<=' => $ref_time },
       'quadra.vt_fim' => { '>' => $ref_time },
       'cemiterio.tt_ini' => { '<=' => $ref_time },
       'cemiterio.tt_fim' => { '>' => $ref_time },
       'cemiterio.vt_ini' => { '<=' => $ref_time },
       'cemiterio.vt_fim' => { '>' => $ref_time },
       'cemiterio.id_cemiterio' => $self->cemiterio->id_cemiterio, },
     { join => ['obitos_jazigo',{ lote => { quadra => 'cemiterio' }}],
       group_by => [qw(me.id_jazigo me.vt_ini me.vt_fim me.tt_ini me.tt_fim
                       me.au_usr me.id_lote me.identificador me.tipo)],
       '+select' => [\"MAX(CASE WHEN obitos_jazigo.vt_fim IS NULL THEN '-infinity' ELSE obitos_jazigo.vt_fim END)"],
       '+as' => ['ultimo_sepultamento'],
       'order_by' => \"MAX(CASE WHEN obitos_jazigo.vt_fim IS NULL THEN '-infinity' ELSE obitos_jazigo.vt_fim END)",
       'rows' => 10,
     });

};

=item desfazer_sepultamento

Este método deve ser chamado para desfazer o registro de um
sepultamento. Isso significa que o registro foi feito de maneira
incorreta, e que precisa ser desfeito para ser lançado corretamente.

Recebe o id do sepultamento, e não retorna nada (vai morrer em caso de
erro).

=cut

txn_method 'desfazer_sepultamento' => authorized 'supervisao' => sub {
  my ($self, $id_sepultamento) = @_;

  my $ref_time = now;

  my $sepultamento = $self->cemiterio->sepultamentos
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>' => $ref_time },
             id_sepultamento => $id_sepultamento })
      or die 'Sepultamento não encontrado';

  # vamos invalidar o sepultamento
  $sepultamento->update({ tt_fim => $ref_time });

  # Vamos encontrar o óbito desse sepultamento.
  my $obito = $sepultamento->obito
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>' => $ref_time }})
      or die 'Inconsistência no banco: obito';

  # Vamos encontrar o jazigo onde o sepultamento foi realizado.
  my $jazigo = $sepultamento->jazigo
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>' => $ref_time },
             vt_ini => { '<=' => $ref_time },
             vt_fim => { '>' => $ref_time }})
      or die 'Inconsistência no banco: jazigo';

  # Agora vamos remover a associação entre o jazigo e o óbito
  my $jazob = $jazigo->obitos
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>' => $ref_time },
             vt_ini => { '<=' => $ref_time },
             vt_fim => { '>' => $ref_time },
             id_obito => $obito->id_obito })
      or die 'Inconsistencia no banco: obitojazigo';

  $jazob->update({ tt_fim => $ref_time });
  $jazob->copy({ tt_ini => $ref_time,
                 tt_fim => 'infinity',
                 vt_fim => $ref_time });

  # Vamos ver se esse sepultamento encerra uma exumação.
  my $exumacao = $sepultamento->encerrando
    ->find({ tt_ini => { '<=' => $ref_time },
             tt_fim => { '>' => $ref_time }});

  if ($exumacao) {
    # temos que reabrir essa exumação
    $exumacao->update({ tt_fim => $ref_time });
    $exumacao->copy({ id_exumacao => $exumacao->id_exumacao,
                      tt_ini => $ref_time,
                      tt_fim => 'infinity',
                      id_sepultamento_destino => undef });
  }

};

1;
