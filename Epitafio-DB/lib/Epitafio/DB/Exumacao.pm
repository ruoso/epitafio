package Epitafio::DB::Exumacao;
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

use strict;
use warnings;
use base qw(DBIx::Class);

__PACKAGE__->load_components(qw(InflateColumn::DateTime PK::Auto Core));
__PACKAGE__->table('exumacao');
__PACKAGE__->add_columns
  (
   id_exumacao =>
   {
    data_type => 'integer',
    is_auto_increment => 1,
   },
   vt_reg =>
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
    data_type => 'char(15)',
   },
   id_obito =>
   {
    data_type => 'integer',
   },
   matr_responsavel =>
   {
    data_type => 'char(15)',
   },
   id_sepultamento_origem =>
   {
    data_type => 'integer',
   },
   id_sepultamento_destino =>
   {
    data_type => 'integer',
    is_nullable => 1,
   },
   id_cremacao_destino =>
   {
    data_type => 'integer',
    is_nullable => 1,
   },
   id_remocao_destino =>
   {
    data_type => 'integer',
    is_nullable => 1,
   },
  );


__PACKAGE__->set_primary_key(qw(id_exumacao vt_reg tt_ini));

__PACKAGE__->belongs_to('obito', 'Epitafio::DB::Obito',
                        { 'foreign.id_obito' => 'self.id_obito' });

__PACKAGE__->belongs_to('responsavel', 'Epitafio::DB::Usuario',
                        { 'foreign.matricula' => 'self.matr_responsavel' });

__PACKAGE__->belongs_to('autor', 'Epitafio::DB::Usuario',
                        { 'foreign.matricula' => 'self.au_usr' });

__PACKAGE__->belongs_to('origem', 'Epitafio::DB::Sepultamento',
                        { 'foreign.id_sepultamento' => 'self.id_sepultamento_origem' });

__PACKAGE__->might_have('sepultamento_destino', 'Epitafio::DB::Sepultamento',
                        { 'foreign.id_sepultamento' => 'self.id_sepultamento_destino' });

__PACKAGE__->might_have('cremacao_destino', 'Epitafio::DB::Cremacao',
                        { 'foreign.id_cremacao' => 'self.id_cremacao_destino' });

__PACKAGE__->might_have('remocao_destino', 'Epitafio::DB::Remocao',
                        { 'foreign.id_remocao' => 'self.id_remocao_destino' });

1;

__END__

=head1 NAME

Exumacao - Registra uma Exumacao

=head1 DESCRIPTION

A exumação é necessariamente ligada a um sepultamento de origem, e
pode ter como destino um sepultamento, uma cremação ou uma remoção.

=cut

