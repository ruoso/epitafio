package Epitafio::Model::DB;
use strict;
use warnings;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(schema_class => 'Epitafio::DB');

1;
