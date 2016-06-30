#!/usr/bin/perl -w

use strict;

my $blank=1;

while(<STDIN>) {
    chomp;
    if($_ eq '') {
	$blank=1;
    } elsif($blank) {
	$blank=0;
	if(/^From /) {
	    close P;
	    print "$_\n";
	    open P,"|./run_automail";
	}
    }
    print P "$_\n";
}

close P;
