package Epitafio::DB::Jazigo;
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
BEGIN { extends qw(DBIx::Class) }
use namespace::autoclean;

__PACKAGE__->load_components(qw(InflateColumn::DateTime PK::Auto Core));
__PACKAGE__->table('jazigo');
__PACKAGE__->add_columns
  (
   id_jazigo =>
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
   id_lote =>
   {
    data_type => 'integer',
   },
   identificador =>
   {
    data_type => 'varchar',
   },
   tipo =>
   {
    data_type => 'varchar',
   },
  );


__PACKAGE__->set_primary_key(qw(id_jazigo vt_ini vt_fim tt_ini tt_fim));

has lote => (isa => 'Epitafio::DB::Lote', is => 'rw', required => 1);

__PACKAGE__->belongs_to('lote', 'Epitafio::DB::Lote',
                        { 'foreign.id_lote' => 'self.id_lote' });

has obitos => (
  isa => 'ArrayRef',
  reader => { get_obitos => sub { [$_[0]->obitos_rs->all] } },
  writer => 'set_obitos',
  required => 1
);

__PACKAGE__->has_many('obitos_jazigo', 'Epitafio::DB::ObitoJazigo',
                        { 'foreign.id_jazigo' => 'self.id_jazigo' });

__PACKAGE__->many_to_many(obitos => obitos_jazigo => 'obito');

has sepultamentos => (
  isa => 'ArrayRef',
  reader => { get_sepultamentos => sub { [$_[0]->sepultamentos_rs->all] } }
);

__PACKAGE__->has_many('sepultamentos', 'Epitafio::DB::Sepultamento',
                        { 'foreign.id_jazigo' => 'self.id_jazigo' });

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

Jazigo - Registra os Jazigos em um Lote

=head1 DESCRIPTION

Registra os dados do jazigo.

=cut

