package Automail::Host;

sub new {
    my $class=shift;
    my $name=shift;
    my $os=shift;

    $class=ref($class) || $class;
    my $self={};
    bless $self, $class;

    $self->{Name}=$name;
    $self->{OS}=$os;

    return $self;
}

1;
