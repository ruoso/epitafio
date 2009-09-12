package Epitafio::ModelCemiterio;
use Moose;
use utf8;
extends 'Epitafio::Model';
has 'cemiterio' => (is => 'rw');

sub build_per_context_instance {
  my ($self, $c) = @_;

  # esse model exige que exista a informação de qual o cemitério que
  # se pretende trabalhar, também aproveitamos para ver se o usuário
  # tem alguma ligação com esse cemitério.
  my $id_cemiterio;
  my $rt = now();
  if ($c->req->param('id_cemiterio')) {
    $id_cemiterio = $c->req->param('id_cemiterio');
  } elsif ($c->session->{id_cemiterio}) {
    $id_cemiterio = $c->session->{id_cemiterio};
  } else {
    # vamos ver se o usuário tem acesso a apenas um cemitério, e nesse
    # caso assumimos que esse é o cemitério que ele deseja.
    # Aproveitamos para guardar isso na sessão.
    my %cemiterios =
      map { $_->cemiterio->id_cemiterio => 1 }
        $c->user->obj->funcoes
          ->search({ 'me.tt_ini' => { '<=' => $rt },
                     'me.tt_fim' => { '>' => $rt },
                     'me.vt_ini' => { '<=' => $rt },
                     'me.vt_fim' => { '>' => $rt },
                     'cemiterio.tt_ini' => { '<=' => $rt },
                     'cemiterio.tt_fim' => { '>' => $rt },
                     'cemiterio.vt_ini' => { '<=' => $rt },
                     'cemiterio.vt_fim' => { '>' => $rt }
                   },
                   { prefetch => 'cemiterio' })->all;
    if ((keys %cemiterios) == 1) {
      ($id_cemiterio) = keys %cemiterios;
      $c->session->{id_cemiterio} = $id_cemiterio;
    } else {
      die 'É preciso selecionar um cemitério';
    }
  }

  my $cemiterio = $c->model('DB::Cemiterio')
    ->find({ id_cemiterio => $id_cemiterio,
             tt_ini => { '<=' => $rt },
             tt_fim => { '>' => $rt },
             vt_ini => { '<=' => $rt },
             vt_fim => { '>' => $rt }})
      or die 'Cemiterio não encontrado';

  $self->new(user => $c->user->obj,
             dbic => $c->model('DB')->schema->restrict_with_object($c->user->obj),
             cemiterio => $cemiterio);
}

1;
