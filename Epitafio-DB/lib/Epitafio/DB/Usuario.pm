package Epitafio::DB::Usuario;
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
__PACKAGE__->table('usuario');
__PACKAGE__->add_columns
  (
   matricula =>
   {
    data_type => 'char(15)',
   },
   nome =>
   {
    data_type => 'varchar',
   },
   senha =>
   {
    data_type => 'varchar',
   },
   ativo =>
   {
    data_type => 'boolean',
   },
  );


__PACKAGE__->set_primary_key(qw(matricula));

__PACKAGE__->has_many('funcoes', 'Epitafio::DB::UsuarioFuncao',
                        { 'foreign.matricula' => 'self.matricula' });

__PACKAGE__->has_many('reg_cemiterios', 'Epitafio::DB::Cemiterio',
                        { 'foreign.au_usr' => 'self.matricula' });

__PACKAGE__->has_many('reg_quadras', 'Epitafio::DB::Quadra',
                        { 'foreign.au_usr' => 'self.matricula' });

__PACKAGE__->has_many('reg_lotes', 'Epitafio::DB::Lote',
                        { 'foreign.au_usr' => 'self.matricula' });

__PACKAGE__->has_many('reg_jazigo', 'Epitafio::DB::Jazigo',
                        { 'foreign.au_usr' => 'self.matricula' });

__PACKAGE__->has_many('reg_sepultamento', 'Epitafio::DB::Sepultamento',
                        { 'foreign.au_usr' => 'self.matricula' });

__PACKAGE__->has_many('reg_exumacao', 'Epitafio::DB::Exumacao',
                        { 'foreign.au_usr' => 'self.matricula' });

__PACKAGE__->has_many('reg_cremacao', 'Epitafio::DB::Cremacao',
                        { 'foreign.au_usr' => 'self.matricula' });

__PACKAGE__->has_many('reg_remocao', 'Epitafio::DB::Remocao',
                        { 'foreign.au_usr' => 'self.matricula' });

__PACKAGE__->has_many('reg_obitojazigo', 'Epitafio::DB::ObitoJazigo',
                        { 'foreign.au_usr' => 'self.matricula' });

__PACKAGE__->has_many('reg_obito', 'Epitafio::DB::Obito',
                        { 'foreign.au_usr' => 'self.matricula' });

__PACKAGE__->has_many('reg_usuariofuncao', 'Epitafio::DB::UsuarioFuncao',
                        { 'foreign.au_usr' => 'self.matricula' });

1;

__END__

=head1 NAME

Usuario - Operador do sistema

=head1 DESCRIPTION

Praticamente todas as tabelas do sistema têm uma referência para o
usuário que registrou essa operação.

=cut

