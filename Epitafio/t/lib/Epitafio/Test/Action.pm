package Epitafio::Test::Action;
use Moose;
use Test::More ();

sub check_can_apply {
  my($action, $spec) = @_;
  my @attrs = keys %$spec;
  while(@attrs) {
    my $attr = shift @attrs;
    $action->$attr($spec->{$attr});
    last if @attrs == 0;
    Test::More::ok(!$action->can_apply);
  }
}

1;
