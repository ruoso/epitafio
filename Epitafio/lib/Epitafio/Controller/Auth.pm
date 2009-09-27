package Epitafio::Controller::Auth;
use Moose;
use namespace::autoclean;
BEGIN { extends 'Reaction::UI::Controller' }

use aliased 'Reaction::UI::ViewPort::Action';
use aliased 'Epitafio::IM::Action::Authenticate::Web::Local';

sub authenticate {
    my($self) = @_;
    my $c = $self->context;
    my $return_to = $c->req->uri;
    $self->redirect_to(
        $self->action_for('login'),
        undef,
        undef,
        { return_to => $return_to }
    );
}

sub base :Chained('/base') :PathPart('admin') :CaptureArgs(0) {
  my ($self, $c) = @_;
  unless ($c->user) {
    $c->res->redirect('/login');
    $c->detach;
  }
}

sub login :Chained('/base') Args(0) {
    my($self, $c) = @_;

    # create closure for invoking on_login after we've been authenticated
    my $cb = $self->make_context_closure(
         sub { $self->on_login(@_) }
    );

    $self->push_viewport(Action,
        model => Local->new(
            target_model => $c,
            field_map => { username => 'nome', password => 'senha' }
        ),
        field_order => [qw(username password)],
        on_apply_callback => $cb
    );
}

sub on_login {
    my($self, $c) = @_;
    my $return_to = $c->res->query_parameters->{return_to} || '/';
    $c->res->redirect($return_to);
}

1;
