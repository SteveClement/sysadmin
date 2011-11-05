package Automail::Mail::Section::Compare::LoginAccounting;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::LoginAccounting::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();

    my @errors;
    my %tusers;
    my %wusers;
    for(my $n=0 ; $n <= $#$tbody ; ++$n) {
	my ($user,$quota)=$tbody->[$n]=~/(\S+)\s+(\S+)/;
	$tuser{$user}=$quota;
    }
    for(my $n=0 ; $n <= $#$wbody ; ++$n) {
	my ($user,$quota)=$wbody->[$n]=~/(\S+)\s+(\S+)/;
	$wuser{$user}=$quota;
    }

    foreach my $user (keys %wuser) {
	if(!exists $tuser{$user}) {
	    push @errors,$self->makeError("Unexpected user $user");
# we don't care about quota
#	} elsif($tuser{$user} < $wuser{$user}) {
#	    push @errors,$self->makeError("User $user exceeded quota ($wuser{$user}/$tuser{$user})");
	}
    }

    return @errors;
}

1;
