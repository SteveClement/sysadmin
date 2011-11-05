package Automail::Mail::Section::Compare::LocalSystem;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::LocalSystem::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();
    if($#$tbody != $#$wbody) {
	return ($self->makeError("Different number of lines"));
    }

    if($#$tbody ne 0) {
	return ($self->makeError("Arg! Can't handle more than 1 line"));
    }

    my @errors;
    my ($ttime,$tdays,$thours,$tusers,$tave1,$tave2,$tave3)=
	$tbody->[0]=~/\s*(\S+)\s+up\s+(\S+) days?,\s+(\S+)(?: hrs)?, (\S+) users?, load averages: (.*), (.*), (.*)/;
    if(!defined $ttime) {
	($ttime,$thours,$tusers,$tave1,$tave2,$tave3)=
	    $tbody->[0]=~/\s*(\S+)\s+up\s+(\S+)(?: hrs)?, (\S+) users?, load averages: (.*), (.*), (.*)/;
	$tdays=0;
    }

    my ($wtime,$wdays,$whours,$wusers,$wave1,$wave2,$wave3)=
	$wbody->[0]=~/\s*(\S+)\s+up\s+(\S+) days?,\s+(\S+)(?: (?:hrs|mins))?, (\S+) users?, load averages: (.*), (.*), (.*)/;
    if(!defined $wtime) {
	($wtime,$whours,$wusers,$wave1,$wave2,$wave3)=
	    $wbody->[0]=~/\s*(\S+)\s+up\s+(\S+)(?: hrs)?, (\S+) users?, load averages: (.*), (.*), (.*)/;
	$wdays=0;
    }
	
    push @errors,$self->makeError("Recently rebooted") if $wdays < 2;
    push @errors,$self->gtError("Users",$tusers,$wusers);
    push @errors,$self->gtError("Load Average 1",$tave1,$wave1);
    push @errors,$self->gtError("Load Average 2",$tave2,$wave2);
    push @errors,$self->gtError("Load Average 3",$tave3,$wave3);

    return @errors;
}

1;

