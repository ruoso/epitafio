package Epitafio::Controller::Cemiterio;
use Moose;
use namespace::autoclean;
BEGIN { extends 'Reaction::UI::Controller' }

use aliased 'Reaction::UI::ViewPort::Action';
use aliased 'Epitafio::IM::Action::EscolherCemiterio';
use aliased 'Epitafio::IM::Action::Sepultamento::RegistrarSepultamento';

=head2 root

Se veio aqui, precisa escolher um cemitério para poder seguir adiante.

=cut

sub root :Chained('/auth/base') PathPart('') Args(0) {
  my ($self, $c) = @_;

  my $cb = $self->make_context_closure
    (sub {
       my ($c, $vp) = @_;
       my $uri = $c->uri_for($self->action_for('intro'),[ $vp->model->cemiterio->id_cemiterio ]);
       $c->res->redirect($uri);
     });

  $self->push_viewport
    ( Action,
      model => EscolherCemiterio->new(target_model => $c->model('Cemiterios')),
      on_apply_callback => $cb );
}

=head2 base

Esta é a base para todas as ações que dependem do contexto de um
cemitério.

=cut

sub base :Chained('/auth/base') :PathPart('') :CaptureArgs(1) {
  my ($self, $c, $id_cemiterio) = @_;

  my $rt = DateTime->now();

  $c->stash->{cemiterio} = $c->model('DB::Cemiterio')
    ->find({ id_cemiterio => $id_cemiterio,
             tt_ini => { '<=' => $rt },
             tt_fim => { '>' => $rt },
             vt_ini => { '<=' => $rt },
             vt_fim => { '>' => $rt }})
      or die 'Cemiterio não encontrado';

}

=head2 intro

Esta é a tela de introdução a um cemitério em específico.

=cut

sub intro :Chained('base') :PathPart('') :Args(0) {
  my ($self, $c) = @_;
  $c->res->body('interface especifica NYI (tente ..../sepultar -- Cemiterio: '.$c->stash->{cemiterio}->nome);
}

=head2 sepultar

Esta é a tela onde é registrado um sepultamento

=cut

sub sepultar :Chained('/cemiterio/base') PathPart Args(0) {
  my ($self, $c) = @_;

  $self->push_viewport
    ( Action,
      model => RegistrarSepultamento->new
      ( target_model => $c->model('Sepultamento'),
        model_obitos => $c->model('Obito')),
      field_order => [qw(obito jazigo vt_reg)]);
}

1;
