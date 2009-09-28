use warnings;
use strict;

use FindBin;
use Config::JFDI;
use Term::ReadPassword ();
use Path::Class ();
use Data::Dump;
use vars qw($app_path);

BEGIN { $app_path = Path::Class::dir($FindBin::Bin)->parent }
use lib $app_path->parent->subdir(qw(Epitafio-DB lib))->stringify;
use lib $app_path->subdir('lib')->stringify;
use Epitafio::DB;


# solução prum bug chato no Moose que emite warnings o tempo todo
BEGIN { close STDERR }
use aliased 'Reaction::UI::ViewPort::Action';
use aliased 'Epitafio::IM::Usuario::Action::Create';

my $config = Config::JFDI->new(
    name => 'Epitafio',
    path => $app_path->stringify
);
$config->load;
my $connect_info = $config->get->{'Model::DB'}{connect_info};
$connect_info = [$connect_info] unless ref($connect_info) eq 'ARRAY';
my $schema = Epitafio::DB->connect(@$connect_info);

my %deploy_opts;

# verificaÃ§Ã£o de prÃ©-existÃªncia do schema
my($test_source) = $schema->sources;
eval { $schema->resultset($test_source)->count };
# se houver erro, provavelmente o schema nÃ£o foi implantado ainda
# se alguém souber uma forma melhor de fazer isso, por favor...
$deploy_opts{add_drop_table} = 1 unless $@;

$schema->deploy(\%deploy_opts);

print "Schema implantado com sucesso usando a seguinte configuraÃ§Ã£o:\n";
print Data::Dump::dump($connect_info), "\n";

# criar usuário inicial

# precisa existir por conta dos weak refs
my $ctx = bless({}, 'Catalyst');

my $create_usuario = Create->new(
  ctx => $ctx,
  target_model => $schema->resultset('Usuario'),
  criptografia => 'MD5',
  matricula    => 0
);
my $vp = Action->new(
  ctx => $ctx,
  model => $create_usuario,
  location => 'usuario',
  on_apply_callback => sub {
    my($vp, $object) = @_;
    print "Usuário '${\$object->nome}' criado com sucesso\n";
  }
);

do {
  my %args;
  if(!$create_usuario->has_nome) {
    print 'nome para super-usuário: ';
    chomp($args{nome} = <STDIN>);
  }
  if(!$create_usuario->senha_confirmada) {
    $args{senha}
      = Term::ReadPassword::read_password('senha: ');
    $args{confirmar_senha}
      = Term::ReadPassword::read_password('confirmar senha: ');
  }
  for my $field (@{$vp->fields}) {
    $field->value($args{$field->name}) if exists $args{$field->name};
  }
  $vp->sync_action_from_fields;
  $vp->apply;
  print $_->name . ': ' . $_->message . "\n"
    for grep { $_->has_message } @{$vp->fields};
} until ($create_usuario->can_apply);
