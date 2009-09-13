package Epitafio::UI::ViewPort::Role::Relocatable;
use Reaction::Role;

requires 'location';
requires 'inner_vps';

after location => sub { shift->reset_child_locations if @_ > 1 };

sub reset_child_locations {
    my($self) = @_;
    for my $vp ($self->inner_vps) {
        $vp->location(join '-', $self->location, $vp->location);
    }
}

1;
