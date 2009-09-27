package Epitafio::DB::Cremacao;
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
__PACKAGE__->table('cremacao');
__PACKAGE__->add_columns
  (
   id_cremacao =>
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
    data_type => 'varchar(15)',
   },
   id_obito =>
   {
    data_type => 'integer',
   },
   id_cemiterio =>
   {
    data_type => 'integer',
   },
   matr_responsavel =>
   {
    data_type => 'varchar(15)',
   },
   recep_rm_nome =>
   {
    data_type => 'varchar',
   },
   recep_rm_identidade =>
   {
    data_type => 'varchar',
   },
   recep_rm_emissor =>
   {
    data_type => 'varchar',
   },
   recep_rm_cpf =>
   {
    data_type => 'varchar(14)',
   },
   descricao_destino =>
   {
    data_type => 'varchar',
   },
  );


__PACKAGE__->set_primary_key(qw(id_cremacao tt_ini tt_fim));

has obito => (
    isa => 'Epitafio::DB::Obito',
    is => 'rw',
    required => 1
);

__PACKAGE__->belongs_to('obito', 'Epitafio::DB::Obito',
                        { 'foreign.id_obito' => 'self.id_obito' });

has responsavel => (
    isa => 'Epitafio::DB::Usuario',
    is => 'rw',
    required => 1
);

__PACKAGE__->belongs_to('responsavel', 'Epitafio::DB::Usuario',
                        { 'foreign.matricula' => 'self.matr_responsavel' });

has autor => (
    isa => 'Epitafio::DB::Usuario',
    is => 'rw',
    required => 1
);

__PACKAGE__->belongs_to('autor', 'Epitafio::DB::Usuario',
                        { 'foreign.matricula' => 'self.au_usr' });

has encerrando => (
    isa => 'Epitafio::DB::Exumacao',
    is => 'rw',
    required => 0
);

__PACKAGE__->might_have('encerrando', 'Epitafio::DB::Exumacao',
                        { 'foreign.id_cremacao_destino' => 'self.id_cremacao' });

has cemiterio => (
    isa => 'Epitafio::DB::Cemiterio',
    is => 'rw',
    required => 1
);

__PACKAGE__->belongs_to('cemiterio', 'Epitafio::DB::Cemiterio',
                        { 'foreign.id_cemiterio' => 'self.id_cemiterio' });

1;

__END__

=head1 NAME

Cremacao - Registra uma Cremacao

=head1 DESCRIPTION

A cremação pode acontecer tanto logo que o óbito é recebido quanto
depois de ele ser exumado.

=cut

