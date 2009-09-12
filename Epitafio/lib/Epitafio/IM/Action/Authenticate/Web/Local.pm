package Epitafio::IM::Action::Authenticate::Web::Local;
use Reaction::Class;
use namespace::autoclean;
extends 'Reaction::InterfaceModel::Action';
use Reaction::Types::Core qw(SimpleStr Password);

has '+target_model' => (weak_ref => 1);

has username => (isa => SimpleStr, is => 'rw', lazy_fail => 1);
has password => (isa => Password, is => 'rw', lazy_fail => 1);

has field_map => (
    isa => 'HashRef',
    is => 'ro',
    default => sub {{}},
    metaclass => 'Reaction::Meta::Attribute'
);

override error_for_attribute => sub { 'invalid username or password' };

sub auth_info {
    my($self) = @_;

    my %params = %{$self->parameter_hashref};

    # map field names to match storage if needed
    if(my %map = %{$self->field_map}) {
        @params{ values %map } = delete @params{ keys %map };
    }

    return \%params;
}

override can_apply => sub {
    my($self) = @_;
    super() && $self->target_model->find_user($self->auth_info)
};

sub do_apply  {
    my($self) = @_;
    $self->target_model->authenticate($self->auth_info)
}

1;
