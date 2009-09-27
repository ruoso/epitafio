package Epitafio::ModelUtil;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(txn_method authorized rs_handled now readonly);

sub now {
  DateTime->now();
}

sub txn_method {
  my ($name, $code) = @_;
  my $method_name = caller().'::'.$name;
  no strict 'refs';
  *{$method_name} = sub {
    $_[0]->dbic->txn_do($code, @_)
  };
}

sub readonly {
  my ($code) = @_;
  sub {
    $_[0]->dbic->storage->dbh_do
      (sub {
         my ($storage, $dbh) = @_;
         $dbh->do('SET TRANSACTION READ ONLY');
       });
    $code->(@_);
  }
}

sub authorized {
  my ($role, $code) = @_;
  return sub {
    my $rt = now;
    if ($_[0]->isa('Epitafio::ModelCemiterio')) {
      # no caso de ser um ModelCemiterio, significa que temos que ver
      # se ele tem essa função nesse cemitério.
      if ($_[0]->cemiterio->usuarios
          ->find({ matricula => $_[0]->user->matricula,
                   tt_ini => { '<=' => $rt },
                   tt_fim => { '>' => $rt },
                   vt_ini => { '<=' => $rt },
                   vt_fim => { '>' => $rt },
                   codigo => $role })) {
        $code->(@_);
      } else {
        die 'Access Denied! {'.$role.'}';
      }
    } else {
      # as roles que não são específicas a cemitério devem ser
      # registradas sem associação com o cemitério
      if ($_[0]->user->funcoes
          ->find({ tt_ini => { '<=' => $rt },
                   tt_fim => { '>' => $rt },
                   vt_ini => { '<=' => $rt },
                   vt_fim => { '>' => $rt },
                   codigo => $role,
                   id_cemiterio => undef })) {
        $code->(@_);
      } else {
        die 'Access Denied! {'.$role.'}';
      }
    }
  }
}

sub rs_handled {
  my ($rs, $meth) = @_;
  return sub {
    $_[0]->dbic->resultset($rs)->$meth(@_)
  }
}

1;
