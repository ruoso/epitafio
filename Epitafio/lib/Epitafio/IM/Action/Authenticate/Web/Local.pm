package Epitafio::IM::Action::Authenticate::Web::Local;
use Reaction::Class;
use namespace::autoclean;
extends 'Reaction::InterfaceModel::Action';
use Reaction::Types::Core qw(SimpleStr Password);
use utf8;

has '+target_model' => (weak_ref => 1);

has matricula => (isa => SimpleStr, is => 'rw', lazy_fail => 1);
has senha => (isa => Password, is => 'rw', lazy_fail => 1);

override error_for_attribute => sub { 'matrícula ou senha inválida' };

override can_apply => sub {
  my($self) = @_;
  super()
    && $self->target_model->authenticate($self->parameter_hashref)
      && $self->target_model->user
};

sub do_apply {
  my ($self) = @_;
  $self->target_model->res->redirect($self->target_model->uri_for('/admin'));
}

1;
