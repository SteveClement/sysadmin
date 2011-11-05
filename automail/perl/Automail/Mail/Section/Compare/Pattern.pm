package Automail::Mail::Section::Compare::Pattern;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::Pattern::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();
    if($#$tbody != $#$wbody) {
	return ($self->makeError("Different number of lines"));
    }

    my @errors;
    for(my $n=0 ; $n <= $#$tbody ; ++$n) {
	if($wbody->[$n]!~/$tbody->[$n]/) {
	    push @errors,$self->makeError("Line '$wbody->[$n]' doesn't match '$tbody->[$n]'");
	}
    }

    return @errors;
}

1;
