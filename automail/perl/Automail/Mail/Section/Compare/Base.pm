package Automail::Mail::Section::Compare::Base;

sub new {
    my $class=shift;
    my $section=shift;

    $class=ref($class) || $class;
    my $self={};
    bless $self, $class;

    $self->{Template}=$section;

    return $self;
}

sub makeError {
    my $self=shift;
    my $error=shift;

    return "$error in '".$self->{Template}->getTitle()."'";
}

sub compareError {
    my $self=shift;
    my $name=shift;
    my $t=shift;
    my $w=shift;

    return ($self->makeError("$name has changed from $t to $w")) if $t ne $w;
    return ();
}

sub gtError {
    my $self=shift;
    my $name=shift;
    my $t=shift;
    my $w=shift;

    return ($self->makeError("w is null in $name")) if !defined $w;
    return ($self->makeError("t is null in $name")) if !defined $t;
    return ($self->makeError("$name exceeds limit (current $w, max $t)"))
	if $t < $w;
    return ();
}

sub checkDuplicateErrors {
    my $self=shift;
    my $wbody=shift;
    my $errors=shift;

    return @$errors if $#$errors == -1
	|| $self->{Template}->getFrequency() ne 'daily'
	|| $self->{Template}->hasSectionChanged($wbody);

# show repeats on Mondays
    if((localtime(time))[6] == 1) {
	push @$errors,$self->makeError("Repeating error, suppressed for the rest of the week");
	return @$errors;
    }

    return ();
}

1;
