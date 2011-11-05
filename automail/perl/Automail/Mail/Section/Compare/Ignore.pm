package Automail::Mail::Section::Compare::Ignore;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::Ignore::ISA=
    qw(Automail::Mail::Section::Compare::Base);

# Note this doesn't totally ignore - it still wants the same number of lines.

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();
    if($#$tbody != $#$wbody) {
	return ($self->makeError("Different number of lines"));
    }
    return @errors;
}

1;
