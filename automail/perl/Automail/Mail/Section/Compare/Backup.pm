package Automail::Mail::Section::Compare::Backup;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::Backup::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;
    my $info=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();

    my @errors;
    my $wblocks;
    my $wblocks2;

    my $n;
    for($n=0 ; $n <= $#$wbody ; ++$n) {
print "n=$n\n";
	next if $wbody->[$n] eq '';
	if($wbody->[$n]=~/^(\d+) blocks$/
	   || $wbody->[$n]=~/^Total bytes written: (\d+)/) {
	    push @errors,$self->makeError("Blocks line occurs more than twice")
		if defined $wblocks2;
	    $wblocks2=$1 if defined $wblocks;
	    $wblocks=$1 if !defined $wblocks;
	    next;
	}
	if($wbody->[$n]!~/^cpio: (\.\/)?(proc|var\/spool|var\/run)\/.*: No such file or directory/) {
	    for(my $t=1 ; $t <= $#$tbody ; ++$t) {
		next if $tbody->[$t]=~/^\s*$/;
		goto OK if $wbody->[$n]=~/^$tbody->[$t]$/;
	    }
	    push @errors,$self->makeError("Unexpected: $wbody->[$n]");
	  OK:
	}
    }

    $tbody->[0]=~/(\d+) blocks/ || $tbody->[0]=~/^Total bytes written: (\d+)/;
    my $tblocks=$1;

    print ::T "tbody=$tbody->[0] tblocks=$tblocks\n";

    if(!defined($wblocks) || $wblocks == 0) {
	my $date=$info->{Mail}->getDate();
	my ($day)=localtime($date)=~/^(\S+)/;
	my $off=$info->{Template}->getHeader('X-Automail-Backup-Days-Off');

	if(!defined($off) || $off!~/$day/) {
	    @errors=($self->makeError("Backup appeared not to run"));
	} else {
	    @errors=();
	}
    } else {
	if($tblocks*1.2 < $wblocks || $tblocks*.8 > $wblocks) {
	    push @errors,$self->makeError("$wblocks is more than 20% different from $tblocks");
	}
	push @errors,$self->makeError("Block counts disagree ($wblocks and $wblocks2)")
	    if defined($wblocks2) && $wblocks != $wblocks2;
    }

    return @errors;
}

1;
