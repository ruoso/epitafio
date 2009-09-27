package Epitafio::Controller::Root;
use Moose;
BEGIN { extends 'Reaction::UI::Controller::Root' }

use aliased 'Reaction::UI::ViewPort::Data';
use aliased 'Reaction::UI::ViewPort::SiteLayout';

# defaults
__PACKAGE__->config(
    view_name => 'Site',
    window_title => 'Epitáfio',
    namespace => ''
);

=head1 NAME

Epitafio::Controller::Root - Root Controller for Epitafio

=head1 DESCRIPTION

This controller handles application-wide code for requests.

=head1 ACTIONS

=cut

=head2 base

Code that runs for every request should be invoked here.

=cut

sub base :Chained('/') PathPart('') CaptureArgs(0) {
}

=head2 not_found

Standard 404 error page.

=cut

sub default :Action {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Render the viewport hierarchy. Inherited from Reaction::UI::Controller::Root.

=head1 AUTHOR

Daniel Ruoso,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
