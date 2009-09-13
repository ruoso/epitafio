package Epitafio::UI::Widget::UserBar;
use Reaction::UI::WidgetClass;
use namespace::autoclean;

extends 'Reaction::UI::Widget::Container';

implements fragment links {
    render link => over [$_{viewport}->current_events];
};

implements fragment link {
    arg label => $_{_};
    arg uri => event_uri { $_{_} => 1 };
};

1;
