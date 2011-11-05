#!/usr/bin/perl -w

use strict;
use Getopt::Long;

my $offset=0;
my $docvs=1;
my $destdir='templates';
my $destfile;

GetOptions("offset=i" => \$offset, "cvs!" => \$docvs, "dest=s" => \$destfile);

$docvs=0 if $destdir ne 'templates';

$offset*=24*60*60;
$docvs=undef if defined $destfile;

my $dest=shift;

my $host='linion.ion.lu';
my $base='/home/automail/store';

my ($p1,$p2)=split /\./,$dest;

my $final;
for(my $n=0 ; $n < 31 ; ++$n) {
    my (undef,undef,undef,$mday,$mon,$year)=localtime(time-$offset);
    my $date=sprintf '%d.%02d.%02d',$year+1900,$mon+1,$mday;

    print "Checking $date\n";

    my @flist=split /\n/,`ssh $host 'ls $base/$date/*$p1*$p2*'`;

    foreach my $file (@flist) {
	$destfile="$destdir/$dest" if !defined $destfile;
	print "WARNING: $destfile exists!!!!\n" if -f "$destfile";
	print "Copy $file to $destfile? ";
	my $answer=<STDIN>;
	chomp $answer;
	if($answer eq 'y') {
	    $file=~s/([&])/\\$1/g;
	    $final=$destfile;
	    my @cmd=('scp',"$host:$file",$final);
	    print join(' ',@cmd),"\n";
	    system @cmd;
	    goto DONE;
	}
    }
    $offset+=24*60*60;
}

DONE:
exit if !defined $final;

my $md5=md5($final);
system "$ENV{EDITOR} $final";
if($md5 eq md5($final)) {
    print STDERR "File unchanged! Not added to CVS!!!\n";
    exit;
}

if(!$docvs) {
    print STDERR "CVS disabled!\n";
    exit;
}

system "svn add $final";

sub md5 {
    my $file=shift;

    use Digest::MD5;
    use Carp;

    my $md5=new Digest::MD5();
    open(F,$file) || croak "Can't open $file: $!";
    $md5->addfile(*F);
    close F;

    return $md5->digest();
}
