package Automail::Mail::Section::Compare::Amanda;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::Amanda::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub findSection {
    my $self=shift;
    my $body=shift;
    my $start=shift;
    my $section=shift;
    my $type=shift;
    my $errors=shift;

    return undef if !defined $start;
    my $n;
    for($n=$start ; $n <= $#$body ; ++$n) {
	goto ok if $body->[$n] eq "$section:";
    }
    push @$errors,$self->makeError("Can't find section $section in $type");
    return undef;
  ok:
    return $n;
}

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();

    my @errors;
    my $n=$self->findSection($wbody,0,'STATISTICS','mail',\@errors);
    my $t=$self->findSection($tbody,0,'STATISTICS','template',\@errors);
    $n=$self->findSection($wbody,$n,'NOTES','mail',\@errors);
    $t=$self->findSection($tbody,$t,'NOTES','template',\@errors);

    return @errors if !defined($t) || !defined($n);

    for(++$n ; $n <= $#$wbody ; ++$n) {
	my $str=$wbody->[$n];
	last if $str eq '';
	if($str=~/^  planner: Last full dump of /) {
	    push @errors,
	      $self->makeError("'$str' - this needs urgent attention!");
	    next;
	}
	if($str=~/^  planner: Dump too big for tape/) {
	    push @errors,
	      $self->makeError("'$str' - this may fix itself, but isn't great");
	    next;
	}
	if($str=~/^  planner: Dump larger than tape/) {
	    push @errors,
	      $self->makeError("'$str' - this WILL NOT fix itself - the dump size exceeds the tape size");
	    next;
	}
	if($str=~/^  taper: .*: No space left on device$/) {
	    push @errors,
	      $self->makeError("'$str' - a flush may be needed");
	    next;
	}
	next if $str=~/^  planner: Full dump of \S+ promoted/;
	next if $str=~/^  taper: tape \S+ kb \d+ fm \d+ \[OK]$/;
	next if $str=~/^  planner: Incremental of \S+ bumped to level \d+.$/;
	push @errors,$self->makeError("'$str' not understood in NOTES");
    }

    $n=$self->findSection($wbody,$n,'DUMP SUMMARY','mail',\@errors);
    $t=$self->findSection($tbody,$t,'DUMP SUMMARY','template',\@errors);

    return @errors if !defined($t) || !defined($n);

    my %dumps;

    for($t+=4 ; $t <= $#$tbody ; ++$t) {
	my $str=$tbody->[$t];
	last if $str eq '';
	my($host,$disk)=$str=~/^(\S+)\s+(\S+)\s+\d+/;
	if(!defined $disk) {
	    push @errors,
	      $self->makeError("bad dump in template - '$str'");
	    next;
	}
	$dumps{"$host $disk"}++;
    }

    for($n+=4 ; $n <= $#$wbody ; ++$n) {
	my $str=$wbody->[$n];
	last if $str eq '';
	my($host,$disk)=$str=~/^(\S+)\s+(\S+)\s+\d+/;
	if(!defined $disk) {
	    push @errors,$self->makeError("bad dump - '$str'");
	    next;
	}
	if(!defined $dumps{"$host $disk"}) {
	    push @errors,$self->makeError("unexpected disk - '$str'");
	    next;
	}
        if($str=~/FAILED/) {
            push @errors,$self->makeError("dump failed - $host : $disk");
	    delete $dumps{"$host $disk"};
            next;
        }
	$dumps{"$host $disk"}--;
	if (!$dumps{"$host $disk"}) {
	    delete $dumps{"$host $disk"};
	}
    }

    foreach my $key (keys %dumps) {
	my($host,$disk)=$key=~/^(\S+) (\S+)$/;
	push @errors,$self->makeError("$host $disk missing");
    }

    return @errors;
}

1;
