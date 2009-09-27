package Epitafio::Controller::Auth;
use Moose;
use namespace::autoclean;
BEGIN { extends 'Reaction::UI::Controller' }

use aliased 'Reaction::UI::ViewPort::Action';
use aliased 'Epitafio::IM::Action::Authenticate::Web::Local';

sub base :Chained('/base') :PathPart('admin') :CaptureArgs(0) {
  my ($self, $c) = @_;
  unless ($c->user) {
    $c->res->redirect($c->uri_for($self->action_for('login')));
    $c->detach;
  }
}

sub login :Chained('/base') Args(0) {
    my($self, $c) = @_;

    $self->push_viewport(Action,
        model => Local->new(
            target_model => $c,
        ),
        field_order => [qw(matricula senha)],
    );
}

1;
