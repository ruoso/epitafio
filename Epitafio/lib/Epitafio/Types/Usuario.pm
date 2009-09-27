package Epitafio::Types::Usuario;
use MooseX::Types -declare => [qw(Matricula)];
use MooseX::Types::Moose qw(Str);

subtype Matricula,
  as Str,
  where { length() > 0 and length() <= 15 },
  message { "O número de matrícula não pode exeder 15 caracteres" };

1;
