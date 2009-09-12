package Epitafio::DB::Funcao;
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
__PACKAGE__->table('funcao');
__PACKAGE__->add_columns
  (
   codigo =>
   {
    data_type => 'char(20)',
   },
   descricao =>
   {
    data_type => 'varchar',
   },
  );


__PACKAGE__->set_primary_key(qw(codigo));

has usuarios => (
    isa => 'ArrayRef',
    reader => { get_usuarios => sub {[$_[0]->usuarios_rs->all]} }
);

__PACKAGE__->has_many('usuarios', 'Epitafio::DB::UsuarioFuncao',
                        { 'foreign.codigo' => 'self.codigo' });

1;

__END__

=head1 NAME

Funcao - Parâmetros para role-based authentication

=head1 DESCRIPTION

Define os tipos de papel desempenhados no sistema

=cut

