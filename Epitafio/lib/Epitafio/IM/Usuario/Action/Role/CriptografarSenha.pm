package Epitafio::IM::Usuario::Action::Role::CriptografarSenha;
use Reaction::Role;

use namespace::clean;

use aliased 'Digest';

requires 'parameter_hashref';
requires 'senha';

has _criptografia => (
  isa => 'Str',
  is => 'ro',
  init_arg => 'criptografia',
  predicate => 'has_criptografia',
  lazy_fail => 1,
  metaclass => 'Reaction::Meta::Attribute'
);

has _digest => (
  is => 'ro',
  init_arg => undef,
  lazy_build => 1,
  metaclass => 'Reaction::Meta::Attribute'
);

sub _build__digest { Digest->new(shift->_criptografia) }

sub criptografar_senha {
  my($self, $senha) = @_;
  my $digest = $self->_digest->clone;
  $digest->add($senha);
  return $digest->b64digest;
}

sub senhas_conferem {
  my($self, $senha1, $senha2) = @_;
  return
     $self->criptografar_senha($senha1)
  eq $self->criptografar_senha($senha2)
}

around parameter_hashref => sub {
  my $orig = shift;
  my $self = shift;
  my $p_hash = $self->$orig(@_);
  $p_hash->{senha} = $self->criptografar_senha($p_hash->{senha})
    if exists $p_hash->{senha};
  return $p_hash;
};

1;
