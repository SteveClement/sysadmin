#!/usr/bin/perl -w

use strict;

use Time::ParseDate;
use Carp;

my $start=parsedate($ARGV[0]);
croak "Can't parse $ARGV[0]" if !$start;
my $end=parsedate($ARGV[1]);
croak "Can't parse $ARGV[1]" if !$end;

print STDERR "start=$start end=$end\n";

my $blank=1;
my $echo;

while(<STDIN>) {
    chomp;
    if($_ eq '') {
	$blank=1;
    } elsif($blank) {
	$blank=0;
	if(/^From \S+ (.*)$/) {
	    $echo=0;
#	print STDERR "$_\n";
	    my $date=parsedate($1);
	    croak "can't parse $1" if !$date;
#	print STDERR "date=$1/$date\n";
	    next if $date < $start || $date > $end;
	    print STDERR "$_\n";
	    $echo=1;
	}
    }
    print "$_\n" if $echo;
}
