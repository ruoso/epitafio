package Epitafio::Model;
use Moose;
with 'Catalyst::Component::InstancePerContext';
has 'user' => (is => 'rw');
has 'dbic' => (is => 'rw');

sub build_per_context_instance {
  my ($self, $c) = @_;
  $self->new(user => $c->user->obj,
             dbic => $c->model('DB')->schema->restrict_with_object($c->user->obj));
}

1;
