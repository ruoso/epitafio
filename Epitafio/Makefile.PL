#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;

name 'Epitafio';
all_from 'lib/Epitafio.pm';

requires 'Catalyst::Runtime' => '5.80007';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'parent';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Authentication::Credential::Password';

requires 'Config::JFDI';
requires 'Term::ReadPassword';

features(
  'Suporte a SQLite' => [
    '-default' => 1,
    [qw/DBD::SQLite/]
  ],
  'Suport a PostgreSQL' => [
    '-default' => 0,
    [qw/DBD::Pg/]
  ]
);

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;

print <<EOF
Essa distribuição requer a instalação de uma versão do Reaction que ainda não
foi submetida ao CPAN:

svn co http://code2.0beta.co.uk/reaction/svn/Reaction/0.001/trunk reaction
cd reaction
perl Makefile.PL
make test && make install

EOF
