package Automail::Mail::Section::Compare::DiskStatus;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::DiskStatus::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();
    if($#$tbody != $#$wbody) {
	return ($self->makeError("Different number of lines"));
    }

    my ($ttitle, $wtitle);
    ($ttitle = $tbody->[0]) =~ s|\s+| |g;
    ($wtitle = $wbody->[0]) =~ s|\s+| |g;
    if($ttitle ne $wtitle) {
	return ($self->makeError("Title lines don't match"));
    }

    my @errors;
    for(my $n=1 ; $n <= $#$tbody ; ++$n) {
	my ($tdevice,$tsize,$tused,$tavail,$tcapacity,$tmount)=
	    $tbody->[$n]=~/(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)%\s+(\S+)/;
	my ($wdevice,$wsize,$wused,$wavail,$wcapacity,$wmount)=
	    $wbody->[$n]=~/(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)%\s+(\S+)/;
	if(!defined $tmount) {
	    push @errors,$self->makeError("Can't parse '$tbody->[$n]' in template");
	    next;
	}
	if(!defined $wmount) {
	    push @errors,$self->makeError("Can't parse '$wbody->[$n]' in mail");
	    next;
	}
	if($tdevice ne $wdevice) {
	    push @errors,$self->makeError("Device $wdevice should be $tdevice");
	    next;
	}
	if($tsize ne $wsize) {
	    push @errors,$self->makeError("Device $tdevice has changed size");
	    next;
	}
	push @errors,$self->makeError("Device $tdevice has exceeded the maximum capacity (used $wcapacity, max $tcapacity)")
	    if $wcapacity > $tcapacity;
	push @errors,$self->makeError("Device $tdevice has changed mountpoint (now $wmount, should be $tmount)")
	    if $wmount ne $tmount;
    }

    return @errors;
}

1;
