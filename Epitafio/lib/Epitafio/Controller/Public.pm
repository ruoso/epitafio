package Epitafio::Controller::Public;
use Moose;
BEGIN { extends 'Reaction::UI::Controller::Root' }

use aliased 'Reaction::UI::ViewPort::Data';
use aliased 'Reaction::UI::ViewPort::SiteLayout';

sub base :Chained('/base') :CaptureArgs(0) :PathPart('') {}

sub root :Chained('base') :Args(0) :PathPart('') {
  my ($self, $c) = @_;
  $c->res->body('Interface publica ainda nao implementada. Acesse /admin');
}

1;
