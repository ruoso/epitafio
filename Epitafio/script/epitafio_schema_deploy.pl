use warnings;
use strict;

use FindBin;
use Config::JFDI;
use Path::Class ();
use Data::Dump;

use vars qw($app_path);
BEGIN { $app_path = Path::Class::dir($FindBin::Bin)->parent }
use lib $app_path->parent->subdir(qw(Epitafio-DB lib))->stringify;
use Epitafio::DB;

my $config = Config::JFDI->new(
    name => 'Epitafio',
    path => $app_path->stringify
);
$config->load;
my $connect_info = $config->get->{'Model::DB'}{connect_info};
$connect_info = [$connect_info] unless ref($connect_info) eq 'ARRAY';
my $schema = Epitafio::DB->connect(@$connect_info);

my %deploy_opts;

# verificação de pré-existência do schema
my($test_source) = $schema->sources;
eval { $schema->resultset($test_source)->count };
# se houver erro, provavelmente o schema não existe ainda
$deploy_opts{add_drop_table} = 1 unless $@;

$schema->deploy(\%deploy_opts);

print "Schema implantado com sucesso usando a seguinte configuração:\n";
print Data::Dump::dump($connect_info), "\n";
