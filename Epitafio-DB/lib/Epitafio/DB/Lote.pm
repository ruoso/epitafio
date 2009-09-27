package Epitafio::DB::Lote;
# Copyright 2009
#   Daniel Ruoso <daniel@ruoso.com>
#
# Este arquivo é parte do programa Epitáfio - Sistema de Gestão de
# Cemitérios
#
# O Epitáfio é um software livre; você pode redistribui-lo e/ou
# modifica-lo dentro dos termos da Licença Pública Geral GNU como
# publicada pela Fundação do Software Livre (FSF); na versão 2 da
# Licença.
#
# Este programa é distribuido na esperança que possa ser util, mas SEM
# NENHUMA GARANTIA; sem uma garantia implicita de ADEQUAÇÂO a qualquer
# MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a Licença Pública Geral GNU
# para maiores detalhes.
#
# Você deve ter recebido uma cópia da Licença Pública Geral GNU, sob o
# título "LICENCA.txt", junto com este programa, se não, escreva para a
# Fundação do Software Livre(FSF) Inc., 51 Franklin St, Fifth Floor,

use Reaction::Class;
BEGIN { extends 'DBIx::Class' }
use namespace::autoclean;

__PACKAGE__->load_components(qw(InflateColumn::DateTime PK::Auto Core));
__PACKAGE__->table('lote');
__PACKAGE__->add_columns
  (
   id_lote =>
   {
    data_type => 'integer',
    is_auto_increment => 1,
   },
   vt_ini =>
   {
    data_type => 'timestamp with time zone',
   },
   vt_fim =>
   {
    data_type => 'timestamp with time zone',
   },
   tt_ini =>
   {
    data_type => 'timestamp with time zone',
   },
   tt_fim =>
   {
    data_type => 'timestamp with time zone',
   },
   au_usr =>
   {
    data_type => 'varchar(15)',
   },
   id_quadra =>
   {
    data_type => 'integer',
   },
   identificador =>
   {
    data_type => 'varchar',
   },
  );


__PACKAGE__->set_primary_key(qw(id_lote vt_ini vt_fim tt_ini tt_fim));

has quadra => (
    isa => 'Epitafio::DB::Quadra',
    is => 'rw',
    required => 1
);

__PACKAGE__->belongs_to('quadra', 'Epitafio::DB::Quadra',
                        { 'foreign.id_quadra' => 'self.id_quadra' });

has jazigos => (
    isa => 'ArrayRef',
    reader => { get_jazigos => sub {[$_[0]->jazigos_rs->all]} }
);

__PACKAGE__->has_many('jazigos', 'Epitafio::DB::Jazigo',
                        { 'foreign.id_lote' => 'self.id_lote' });

has autor => (
    isa => 'Epitafio::DB::Usuario',
    is => 'rw',
    required => 1
);

__PACKAGE__->belongs_to('autor', 'Epitafio::DB::Usuario',
                        { 'foreign.matricula' => 'self.au_usr' });

1;

__END__

=head1 NAME

Lote - Registra os Lotes em uma Quadra

=head1 DESCRIPTION

Registra os dados do lote.

=cut

