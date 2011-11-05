package Automail::Mail::Section::Compare::PatternOptional;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::PatternOptional::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();

    my @errors;
    OUTER: for(my $n=0 ; $n <= $#$wbody ; ++$n) {
	for(my $i=0 ; $i <= $#$tbody ; ++$i) {
	    next OUTER if $wbody->[$n]=~/^$tbody->[$i]$/;
	}
	push @errors,$self->makeError("Line '$wbody->[$n]' doesn't have a match");
    }

    return $self->checkDuplicateErrors($wbody,\@errors);
}

1;
