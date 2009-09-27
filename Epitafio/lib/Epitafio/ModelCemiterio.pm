package Epitafio::ModelCemiterio;
use Moose;
use utf8;
extends 'Epitafio::Model';
has 'cemiterio' => (is => 'rw');

sub build_per_context_instance {
  my ($self, $c) = @_;

  $self->new(user => $c->user->obj,
             dbic => $c->model('DB')->schema->restrict_with_object($c->user->obj),
             cemiterio => $c->stash->{cemiterio});
}

1;
