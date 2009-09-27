package Epitafio::Controller::Cemiterio;
use Moose;
use namespace::autoclean;
BEGIN { extends 'Reaction::UI::Controller' }

=head2 root

Se veio aqui, precisa escolher um cemitério para poder seguir adiante.

=cut

sub root :Chained('/base') PathPart('') Args(0) {
  
}

=head2 base

Esta é a base para todas as ações que dependem do contexto de um
cemitério.

=cut

sub base :Chained('/base') :Pathpart('') :CaptureArgs(1) {
  my ($self, $id_cemiterio) = @_;

  $c->stash->{cemiterio} = $c->model('DB::Cemiterio')
    ->find({ id_cemiterio => $id_cemiterio,
             tt_ini => { '<=' => $rt },
             tt_fim => { '>' => $rt },
             vt_ini => { '<=' => $rt },
             vt_fim => { '>' => $rt }})
      or die 'Cemiterio não encontrado';

}

1;
