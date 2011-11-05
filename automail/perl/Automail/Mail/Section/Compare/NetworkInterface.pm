package Automail::Mail::Section::Compare::NetworkInterface;

use strict;
use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::NetworkInterface::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();
#    if($#$tbody != $#$wbody) {
#	return ($self->makeError("Different number of lines ($#$tbody/$#$wbody)"));
#    }

    if($tbody->[0] ne $wbody->[0]) {
	return ($self->makeError("Title lines don't match"));
    }

    my @errors;
    my %interfaces;
    for(my $n=1 ; $n <= $#$tbody ; ++$n) {
	my ($tdevice,$tmtu,$tnetwork,$taddress,$tipkts,$tierrs,$topkts,$toerrs,
	    $tcoll)=split ' ',$tbody->[$n];

	if(!defined $tcoll) {
	    ($tdevice,$tmtu,$tnetwork,$tipkts,$tierrs,$topkts,$toerrs,$tcoll)=
		split ' ',$tbody->[$n];
	    $taddress='';
	}
	if(!defined $tcoll) {
	    push @errors,$self->makeError("Can't parse template line: $tbody->[$n]");
	    next;
	}

	# Root nameservers have different opinions about the case of "localhost"
	$taddress='localhost' if lc($taddress) eq 'localhost';

	# IPv6 flaps around for no apparent reason
	$tnetwork='localhost' if $tnetwork eq '::1';

	my $spec="$tdevice/$taddress/$tnetwork";
	push @errors,$self->makeError("Duplicate interface in template: $spec")
	  if exists $interfaces{$spec};

	$interfaces{$spec}=[$tdevice,$tmtu,$tnetwork,$taddress,$tipkts,$tierrs,
			    $topkts,$toerrs,$tcoll];
    }

  OUTER:
    for(my $n=1 ; $n <= $#$wbody ; ++$n) {
	my ($wdevice,$wmtu,$wnetwork,$waddress,$wipkts,$wierrs,$wopkts,$woerrs,
	    $wcoll)=split ' ',$wbody->[$n];
	if(!defined $wcoll) {
	    ($wdevice,$wmtu,$wnetwork,$wipkts,$wierrs,$wopkts,$woerrs,$wcoll)=
		split ' ',$wbody->[$n];
	    $waddress='';
	}
	if(!defined $wcoll) {
	    push @errors,$self->makeError("Can't parse mail line: $wbody->[$n]");
	    next;
	}

	# Root nameservers have different opinions about the case of "localhost"
	$waddress='localhost' if lc($waddress) eq 'localhost';

	# IPv6 flaps around for no apparent reason
	$wnetwork='localhost' if $wnetwork eq '::1';

	my $spec="$wdevice/$waddress/$wnetwork";
	{ # block required to avoid weird scoping issues associated with goto
	    foreach my $interface (keys %interfaces) {
		my $match=$interface;
		$match=~s/^\?//;
		if($match=~/^!(.*)$/) {
		    if($spec=~/$1/) {
			$spec=$interface;
			goto GOT_IF;
		    }
		} else {
		    if($spec eq $match) {
			$spec=$interface;
			goto GOT_IF;
		    }
		}
	    }
	    push @errors,$self->makeError("Extra interface: $spec");
	    next OUTER;
	  GOT_IF:
	}
	my($tdevice,$tmtu,$tnetwork,$taddress,$tipkts,$tierrs,$topkts,$toerrs,
	   $tcoll)=@{$interfaces{$spec}};
	delete $interfaces{$spec};

	push @errors,$self->compareError("MTU ($wdevice)",$tmtu,$wmtu);
    }
    foreach my $spec (keys %interfaces) {
	push @errors,$self->makeError("Missing interface: $spec")
	  if $spec!~/^\?/;
    }

    return @errors;
}
