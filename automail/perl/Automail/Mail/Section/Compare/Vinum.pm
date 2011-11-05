package Automail::Mail::Section::Compare::Vinum;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::Vinum::ISA=
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
	goto ok if $body->[$n] =~ m|$section:$|;
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
    my $n=$self->findSection($wbody,0,'drives','mail',\@errors);
    my $t=$self->findSection($tbody,0,'drives','template',\@errors);

    return @errors if !defined($t) || !defined($n);

    # drives
    my %drives;
    for(++$t; $t <= $#$tbody ; ++$t) {
	my $str=$tbody->[$t];
	last if $str =~ m|volumes:$|;
	my($drive,$device)
	    = $str =~ m|^D\s+(\S+)\s+State:\s+\S+\s+Device\s+(\S+)|;
	if(!defined $drive) {
	    push @errors,
	      $self->makeError("bad drive in template - '$str'");
	    next;
	}
	$drives{"$drive:$device"} = 1;
    }

    for(++$n ; $n <= $#$wbody ; ++$n) {
	my $str=$wbody->[$n];
	last if $str =~ m|volumes:$|;
	my($drive,$device)
	    = $str =~ m|^D\s+(\S+)\s+State:\s+\S+\s+Device\s+(\S+)|;
	if(!defined $drive) {
	    push @errors,$self->makeError("bad drive - '$str'");
	    next;
	}
	if(!defined $drives{"$drive:$device"}) {
	    push @errors,$self->makeError("unexpected drive - '$str'");
	    next;
	}
        if($str !~ m|up|) {
            push @errors,$self->makeError("drive not ok - '$str'");
	    delete $drives{"$drive:$device"};
            next;
        }
	delete $drives{"$drive:$device"};
    }

    foreach my $key (keys %drives) {
	my($drive,$device) = split /:/, $key;
	push @errors,$self->makeError("drive $drive ($device) missing");
    }

    # volumes
    my %volumes;
    for(++$t; $t <= $#$tbody ; ++$t) {
	my $str=$tbody->[$t];
	last if $str =~ m|plexes:$|;
	my($volume,$plexes) 
	    = $str =~ m|^V\s+(\S+)\s+State:\s+\S+\s+Plexes:\s+(\S+)|;
	if(!defined $volume) {
	    push @errors,
	      $self->makeError("bad volume in template - '$str'");
	    next;
	}
	$volumes{"$volume:$plexes"} = 1;
    }

    for(++$n; $n <= $#$wbody ; ++$n) {
	my $str=$wbody->[$n];
	last if $str =~ m|plexes:$|;
	my($volume,$plexes) 
	    = $str =~ m|^V\s+(\S+)\s+State:\s+\S+\s+Plexes:\s+(\S+)|;
	if(!defined $volume) {
	    push @errors,$self->makeError("bad volume - '$str'");
	    next;
	}
	if(!defined $volumes{"$volume:$plexes"}) {
	    push @errors,$self->makeError("unexpected volume - '$str'");
	    next;
	}
        if($str !~ m|up|) {
            push @errors,$self->makeError("volume not ok - '$str'");
	    delete $volumes{"$volume:$plexes"};
            next;
        }
	delete $volumes{"$volume:$plexes"};
    }

    foreach my $key (keys %volumes) {
	my($volume,$device) = split /:/, $key;
	push @errors,$self->makeError("volume $volume ($plexes) missing");
    }

    # plexes
    my %plexes;
    for(++$t; $t <= $#$tbody ; ++$t) {
	my $str=$tbody->[$t];
	last if $str =~ m|subdisks:$|;
	my($plex,$subdisk) = $str =~ m|^P\s+(\S+).*Subdisks:\s+(\S+)|;
	if(!defined $plex) {
	    push @errors,
	      $self->makeError("bad plex in template - '$str'");
	    next;
	}
	$plexes{"$plex:$subdisk"} = 1;
    }

    for(++$n; $n <= $#$wbody ; ++$n) {
	my $str=$wbody->[$n];
	last if $str =~ m|subdisks:$|;
	my($plex,$subdisk) = $str =~ m|^P\s+(\S+).*Subdisks:\s+(\S+)|;
	if(!defined $plex) {
	    push @errors,$self->makeError("bad plex - '$str'");
	    next;
	}
	if(!defined $plexes{"$plex:$subdisk"}) {
	    push @errors,$self->makeError("unexpected plex - '$str'");
	    next;
	}
        if($str !~ m|up|) {
            push @errors,$self->makeError("plex not ok - '$str'");
	    delete $plexes{"$plex:$subdisk"};
            next;
        }
	delete $plexes{"$plex:$subdisk"};
    }

    foreach my $key (keys %plexes) {
	my($plex,$subdisk) = split /:/, $key;
	push @errors,$self->makeError("plex $plex ($subdisk) missing");
    }

    # subdisks
    my %subdisks;
    for(++$t; $t <= $#$tbody ; ++$t) {
	my $str=$tbody->[$t];
	my($subdisk) = $str =~ m|^S\s+(\S+)|;
	if(!defined $subdisk) {
	    push @errors,
	      $self->makeError("bad subdisk in template - '$str'");
	    next;
	}
	$subdisks{"$subdisk"} = 1;
    }

    for(++$n; $n <= $#$wbody ; ++$n) {
	my $str=$wbody->[$n];
	my($subdisk) = $str =~ m|^S\s+(\S+)|;
	if(!defined $subdisk) {
	    push @errors,$self->makeError("bad subdisk - '$str'");
	    next;
	}
	if(!defined $subdisks{"$subdisk"}) {
	    push @errors,$self->makeError("unexpected subdisk - '$str'");
	    next;
	}
        if($str !~ m|up|) {
            push @errors,$self->makeError("subdisk not ok - '$str'");
	    delete $subdisks{"$subdisk"};
            next;
        }
	delete $subdisks{"$subdisk"};
    }

    foreach my $key (keys %subdisks) {
	push @errors,$self->makeError("subdisk $key missing");
    }

    # done
    return @errors;
}

1;
