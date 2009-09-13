package Epitafio::UI::ViewPort::PageLayout;
use Reaction::Class;
use namespace::autoclean;
extends 'Reaction::UI::ViewPort';
with 'Epitafio::UI::ViewPort::Role::Relocatable';

use aliased 'Epitafio::UI::ViewPort::UserBar';

# set up inner viewports
my @inner_vps = qw(header);
has $_ => (
  isa => 'Reaction::UI::ViewPort',
  is => 'ro',
  required => 1
) for @inner_vps;

# declare inner viewports as event handlers
override child_event_sinks => sub {super(), shift->inner_vps};
sub inner_vps {map {$_[0]->$_} @inner_vps}

sub BUILD { shift->reset_child_locations }

1;
