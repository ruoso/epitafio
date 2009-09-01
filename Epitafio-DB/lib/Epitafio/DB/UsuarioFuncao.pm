package Epitafio::DB::UsuarioFuncao;
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
__PACKAGE__->table('usuariofuncao');
__PACKAGE__->add_columns
  (
   matricula =>
   {
    data_type => 'char(15)',
   },
   codigo =>
   {
    data_type => 'char(20)',
   },
   id_cemiterio =>
   {
    data_type => 'integer',
    is_nullable => 1,
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
    data_type => 'char(15)',
   }
  );


__PACKAGE__->set_primary_key(qw(matricula codigo id_cemiterio vt_ini tt_ini));

__PACKAGE__->belongs_to('usuario', 'Epitafio::DB::Usuario',
                        { 'foreign.matricula' => 'self.matricula' });

__PACKAGE__->belongs_to('funcao', 'Epitafio::DB::Funcao',
                        { 'foreign.codigo' => 'self.codigo' });

__PACKAGE__->belongs_to('cemiterio', 'Epitafio::DB::Cemiterio',
                        { 'foreign.id_cemiterio' => 'self.id_cemiterio' });

__PACKAGE__->belongs_to('autor', 'Epitafio::DB::Usuario',
                        { 'foreign.matricula' => 'self.au_usr' });


1;

__END__

=head1 NAME

UsuarioFuncao - Registra os papéis de um usuário

=head1 DESCRIPTION

Note que essa entidade também registra o histórico temporal de quem
tinha permissão de fazer o que no sistema

=cut

