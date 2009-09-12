package Epitafio::IM;
use Reaction::Class;
extends 'Reaction::InterfaceModel::Object';
use Reaction::InterfaceModel::Reflector::DBIC;

my $reflector = Reaction::InterfaceModel::Reflector::DBIC->new;

$reflector->reflect_schema(
  model_class  => __PACKAGE__,
  schema_class => 'Epitafio::DB',
);

__PACKAGE__->meta->make_immutable;

1;
