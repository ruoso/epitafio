package Epitafio::DB::Obito;
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
__PACKAGE__->table('obito');
__PACKAGE__->add_columns
  (
   id_obito =>
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
   id_cemiterio =>
   {
    data_type => 'integer',
   },
   nome =>
   {
    data_type => 'varchar',
   },
   identidade =>
   {
    data_type => 'varchar',
   },
   emissor =>
   {
    data_type => 'varchar',
   },
   cpf =>
   {
    data_type => 'char(11)',
   },
   endereco =>
   {
    data_type => 'varchar',
   },
   cep =>
   {
    data_type => 'char(8)',
   },
   profissao =>
   {
    data_type => 'varchar',
   },
   causa_mortis =>
   {
    data_type => 'varchar',
   },
   funeraria =>
   {
    data_type => 'varchar',
   },
   certidao_nr =>
   {
    data_type => 'varchar',
   },
   certidao_lv =>
   {
    data_type => 'varchar',
   },
   certidao_fl =>
   {
    data_type => 'varchar',
   },
   certidao_dt =>
   {
    data_type => 'timestamp with time zone',
   },
   certidao_cartorio =>
   {
    data_type => 'varchar',
   },
  );


__PACKAGE__->set_primary_key(qw(id_obito tt_ini));

has jazigos => (
  isa => 'ArrayRef',
  reader => { get_jazigos => sub { [$_[0]->jazigos_rs->all] } },
  writer => 'set_jazigos',
  required => 1
);

__PACKAGE__->has_many('obitos_jazigo', 'Epitafio::DB::ObitoJazigo',
                        { 'foreign.id_obito' => 'self.id_obito' });

__PACKAGE__->many_to_many(jazigos => obitos_jazigo => 'jazigo');

has sepultamentos => (
    isa => 'ArrayRef',
    reader => { get_sepultamentos => sub {[$_[0]->sepultamentos_rs->all]} }
);

__PACKAGE__->has_many('sepultamentos', 'Epitafio::DB::Sepultamento',
                        { 'foreign.id_obito' => 'self.id_obito' });

has exumacoes => (
    isa => 'ArrayRef',
    reader => { get_exumacoes => sub {[$_[0]->exumacoes_rs->all]} }
);

__PACKAGE__->has_many('exumacoes', 'Epitafio::DB::Exumacao',
                        { 'foreign.id_obito' => 'self.id_obito' });

has cremacoes => (
    isa => 'ArrayRef',
    reader => { get_cremacoes => sub {[$_[0]->cremacoes_rs->all]} }
);

__PACKAGE__->has_many('cremacoes', 'Epitafio::DB::Cremacao',
                        { 'foreign.id_obito' => 'self.id_obito' });

has remocoes => (
    isa => 'ArrayRef',
    reader => { get_remocoes => sub {[$_[0]->remocoes_rs->all]} }
);

__PACKAGE__->has_many('remocoes', 'Epitafio::DB::Remocao',
                        { 'foreign.id_obito' => 'self.id_obito' });

has autor => (
  isa => 'Epitafio::DB::Usuario',
  is => 'rw',
  required => 1
);

__PACKAGE__->belongs_to('autor', 'Epitafio::DB::Usuario',
                        { 'foreign.matricula' => 'self.au_usr' });

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

Obito - Registra os Obitos

=head1 DESCRIPTION

Registra os dados do obito.

=cut

