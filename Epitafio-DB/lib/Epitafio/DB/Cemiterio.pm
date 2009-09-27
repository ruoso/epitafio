package Epitafio::DB::Cemiterio;
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
__PACKAGE__->table('cemiterio');
__PACKAGE__->add_columns
  (
   id_cemiterio =>
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
    data_type => 'char(15)',
   },
   razao_social =>
   {
    data_type => 'varchar',
   },
   cnpj =>
   {
    data_type => 'integer(14)',
   },
   nome =>
   {
    data_type => 'varchar',
   },
   endereco =>
   {
    data_type => 'varchar',
   },
   responsavel_matr =>
   {
    data_type => 'char(15)',
   },
   responsavel_nome =>
   {
    data_type => 'varchar',
   },
   responsavel_cpf =>
   {
    data_type => 'char(11)',
   },
  );

sub display_name {
  shift->nome
}

__PACKAGE__->set_primary_key(qw(id_cemiterio vt_ini tt_ini));

has quadras => (
    isa => 'ArrayRef',
    reader => { get_quadras => sub {[$_[0]->quadras_rs->all]} }
);

__PACKAGE__->has_many(
    quadras => 'Epitafio::DB::Quadra' => {
       'foreign.id_cemiterio' => 'self.id_cemiterio'
    }
);

has usuarios => (
    isa => 'ArrayRef',
    reader => { get_usuarios => sub {[$_[0]->usuarios_rs->all]} }
);

__PACKAGE__->has_many(
    usuarios => 'Epitafio::DB::UsuarioFuncao' => {
        'foreign.id_cemiterio' => 'self.id_cemiterio'
    }
);

has obitos => (
    isa => 'ArrayRef',
    reader => { get_obitos => sub {[$_[0]->obitos_rs->all]} }
);

__PACKAGE__->has_many(
    obitos => 'Epitafio::DB::Obito' => {
        'foreign.id_cemiterio' => 'self.id_cemiterio'
    }
);

has sepultamentos => (
    isa => 'ArrayRef',
    reader => { get_sepultamentos => sub {[$_[0]->sepultamentos_rs->all]} }
);

__PACKAGE__->has_many(
    sepultamentos => 'Epitafio::DB::Sepultamento' => {
        'foreign.id_cemiterio' => 'self.id_cemiterio'
    }
);

has cremacoes => (
    isa => 'ArrayRef',
    reader => { get_cremacoes => sub {[$_[0]->cremacoes_rs->all]} }
);

__PACKAGE__->has_many(
    cremacoes => 'Epitafio::DB::Cremacao' => {
        'foreign.id_cemiterio' => 'self.id_cemiterio'
    }
);

has remocoes => (
    isa => 'ArrayRef',
    reader => { get_remocoes => sub {[$_[0]->remocoes_rs->all]} }
);

__PACKAGE__->has_many(
    remocoes => 'Epitafio::DB::Remocao' => {
        'foreign.id_cemiterio' => 'self.id_cemiterio'
    }
);

has exumacoes => (
    isa => 'ArrayRef',
    reader => { get_exumacoes => sub {[$_[0]->exumacoes_rs->all]} }
);

__PACKAGE__->has_many(
    exumacoes => 'Epitafio::DB::Exumacao' => {
        'foreign.id_cemiterio' => 'self.id_cemiterio'
    }
);

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

Cemiterio - Registra os cemiterios controlados pelo sistema

=head1 DESCRIPTION

Registra os dados do cemitério, e é a âncora inicial para os outros
dados do sistema.

=cut

