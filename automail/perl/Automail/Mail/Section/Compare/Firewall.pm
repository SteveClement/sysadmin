package Automail::Mail::Section::Compare::Firewall;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::Firewall::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();

    my @errors;

    OUTER: for(my $n=0 ; $n <= $#$wbody ; ++$n) {
	my($wruleno,$wn1,$wn2,$wrule)=
	    $wbody->[$n]=~/^(?:> )?(\d+)\s+(\d+)\s+(\d+)\s+(.*)$/;
	if(!defined($wrule)) {
	    push @errors,$self->makeError("Can't parse '$wbody->[$n]' in mail");
	    next;
	}
	for(my $m=0 ; $m <= $#$tbody ; ++$m) {
	    my($truleno,$tn1,$tn2,$trule)=
		$tbody->[$m]=~/^(?:> )?(\d+)\s+(\d+)\s+(\d+)\s+(.*)$/;
	    if($truleno == $wruleno) {
		push @errors,$self->makeError("Rule '$wrule' doesn't match '$trule'")
		    if $trule ne $wrule;
		print "YYY matched ($n $m)\n";
		next OUTER;
	    }
	}
	push @errors,"No match for: $wbody->[$n]";
    }

    return @errors;
}

1;
