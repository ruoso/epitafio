package Epitafio::DB;
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

use base qw(DBIx::Class::Schema);

# silence DBIC from complaining about our reaction hacks
$ENV{DBIC_OVERWRITE_HELPER_METHODS_OK} = 1;

__PACKAGE__->load_classes();

1;

__END__

=head1 NAME

Epitafio::DB - DBIx::Class::Schema para o banco de dados do Epitáfio

=head1 DESCRIPTION

Essa classe prove o schema de banco de dados para uso com o DBIx::Class.

=cut
