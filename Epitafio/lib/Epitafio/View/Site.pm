package Epitafio::View::Site;
use Reaction::Class;
extends 'Reaction::UI::View::TT';
use namespace::autoclean;

has  '+skin_name' => ( default => 'main' );

__PACKAGE__->meta->make_immutable;

1;
