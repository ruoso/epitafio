package Epitafio::Model::IM;
use Reaction::Class;
extends 'Catalyst::Model::Reaction::InterfaceModel::DBIC';
use namespace::autoclean;

__PACKAGE__->config(
    im_class => 'Epitafio::IM',
    db_dsn => 'dbi::SQLite:dbname=cemiterios.db'
);

__PACKAGE__->meta->make_immutable;

1;
