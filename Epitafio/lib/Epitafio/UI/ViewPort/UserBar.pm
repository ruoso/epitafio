package Epitafio::UI::ViewPort::UserBar;
use Reaction::Class;
use namespace::autoclean;
extends 'Reaction::UI::ViewPort';

use Moose::Util::TypeConstraints qw(duck_type);

has authentication_provider => (
    isa => duck_type([qw(authenticate)]),
    is => 'rw',
    required => 1,
    handles => [qw(authenticate)]
);

has identity => (
    isa => duck_type([qw(logout name)]),
    is => 'rw',
    required => 0,
    clearer => 'clear_identity'
);

override accept_events => sub {
    super(),
    shift->current_events
};

sub logout {
    my $self = shift;
    return unless $self->has_identity;
    $self->identity->logout;
    $self->clear_identity;
};

sub name {
    my $self = shift;
    return unless $self->has_identity;
    $self->identity->name;
};

sub current_events {
    my($self) = @_;
    my @events = qw(authenticate help contact); # always display help and contact
    unshift @events, 'logout' if $self->has_identity;
    return @events;
}

1;
