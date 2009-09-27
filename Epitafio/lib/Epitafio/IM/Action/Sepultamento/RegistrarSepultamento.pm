package Epitafio::IM::Action::Sepultamento::RegistrarSepultamento;
use Reaction::Class;
use namespace::autoclean;
extends 'Reaction::InterfaceModel::Action';
use DateTime;

has model_obitos =>
  ( is => 'ro',
    metaclass => 'Reaction::Meta::Attribute',
    handles =>
    { jazigos_validos => 'jazigos_disponiveis' });

has obito =>
  ( isa => 'Epitafio::DB::Obito', is => 'rw',
    required => 1, lazy_fail => 1,
    valid_values => sub { shift->obitos_validos });

has jazigo =>
  ( isa => 'Epitafio::DB::Jazigo', is => 'rw',
    required => 1, lazy_fail => 1,
    valid_values => sub { shift->target_model->jazigos_disponiveis });

has vt_reg => (isa => 'DateTime', is => 'rw', lazy_fail => 1);

sub do_apply  {
  my ($self) = @_;
  $self->target_model->sepultar
    ({ id_obito => $self->obito->id_obito,
       id_jazigo => $self->jazigo->id_jazigo,
       vt_reg => $self->vt_reg });
}


1;
