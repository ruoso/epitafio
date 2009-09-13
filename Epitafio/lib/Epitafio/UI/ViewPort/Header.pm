package Epitafio::UI::ViewPort::Header;
use Reaction::Class;
extends 'Reaction::UI::ViewPort';
with 'Epitafio::UI::ViewPort::Role::Relocatable';

=head1 NAME

C<Epitafio::UI::ViewPort::Header> - Header viewport for Epitáfio

=head1 DESCRIPTION

This viewport contains the several viewports that compose the Epitáfio page header

=head1 INNER VIEWPORTS

=head2 userbar

This viewport controls the links in the upper right corner of the page, related to
user login and help.

=head2 navbar

This viewport controls the links below the application top banner

=cut

# set up inner viewports
my @inner_vps = qw(userbar);
has $_ => (
  isa => 'Reaction::UI::ViewPort',
  is => 'ro',
  required => 1,
  lazy_build => 1
) for @inner_vps;

# declare inner viewports as event handlers
override child_event_sinks => sub {super(), shift->inner_vps};
sub inner_vps {map {$_[0]->$_} @inner_vps}

1;
