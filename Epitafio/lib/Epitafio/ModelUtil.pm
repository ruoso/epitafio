package Epitafio::ModelUtil;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(txn_method authorized rs_handled now);

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

sub authorized {
  my ($role, $code) = @_;
  return sub {
    if ($_[0]->user->in_role($role)) {
      $code->(@_);
    } else {
      die 'Access Denied!';
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
