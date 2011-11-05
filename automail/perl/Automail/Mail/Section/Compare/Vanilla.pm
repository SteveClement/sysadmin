package Automail::Mail::Section::Compare::Vanilla;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::Vanilla::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;

    my $wbody=$with->getBody();
    my $tbody=$self->{Template}->getBody();

    my @errors;
    if($#$tbody != $#$wbody) {
	return ($self->makeError("Different number of lines"));
    } else {
	for(my $n=0 ; $n <= $#$tbody ; ++$n) {
	    if($tbody->[$n] ne $wbody->[$n]) {
		push @errors,$self->makeError("'$tbody->[$n]' doesn't match '$wbody->[$n]'");
	    }
	}
    }

    return $self->checkDuplicateErrors($wbody,\@errors);
}

1;
