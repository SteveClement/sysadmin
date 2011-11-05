package Automail::Mail::Section::Compare::OpenPorts;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::OpenPorts::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();

    my @errors;
    OUTER: for(my $n=0 ; $n <= $#$wbody ; ++$n) {
	my($proto,$host,$port)=
	  $wbody->[$n]=~/^(\S+)\s+0\s+0\s+(\*|(?:\d+\.\d+\.\d+\.\d+))\.(\d+)\s+\*\.\*\s+LISTEN$/;
	if(!defined $port) {
	    push @errors,
	      $self->makeError("Don't understand '$wbody->[$n]'");
	    next;
	}
	print "looking for $proto/$host/$port\n";
	for(my $m=0 ; $m <= $#$tbody ; ++$m) {
	    my($tproto,$thost,$tport)=
	      $tbody->[$m]=~/^(\S+)\s+0\s+0\s+(\*|(?:\d+\.\d+\.\d+\.\d+))\.(\d+)\s+\*\.\*\s+LISTEN$/;
	    if(!defined $tport) {
		push @errors,
		  $self->makeError("Don't understand template '$tbody->[$m]'")
		    if $n == 0;
		next;
	    }
	    if($proto eq $tproto && $host eq $thost && $port eq $tport) {
		next OUTER;
	    }
	}
	push @errors,$self->makeError("No match for: '$wbody->[$n]'");
    }

    return @errors;
}

1;
