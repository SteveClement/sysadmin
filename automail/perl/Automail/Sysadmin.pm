use strict;

package Automail::Sysadmin;

sub new {
    my $class=shift;
    my $name=shift;
    my $holiday=shift;

    $class=ref($class) || $class;
    my $self={};
    bless $self, $class;

    $self->{Name}=$name;
    $self->{Holiday}=$holiday;

    return $self;
}

sub getName {
    my $self=shift;

    return $self->{Name};
}

sub onHoliday {
    my $self=shift;

    return $self->{Holiday};
}

1;
