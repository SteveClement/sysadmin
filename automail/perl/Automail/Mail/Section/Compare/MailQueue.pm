package Automail::Mail::Section::Compare::MailQueue;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::MailQueue::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();

    return () if $self->{Template}->getOption('ignore');

    if($#$wbody == 0 && $wbody->[0] eq 'Mail queue is empty') {
	return ();
    }

    my $max=$self->{Template}->getOption('max');
    if($max) {
	if($#$wbody <= $max) {
	    return $self->checkSanity($wbody);
	}
	return ($self->makeError("$#$wbody exceeds maximum of $max"));
    }

    if($#$tbody != $#$wbody) {
	return ($self->makeError("Different number of lines"));
    }

    if($tbody->[0] ne $wbody->[0]) {
      my ($ttitle) = $tbody->[0] =~ m|(.*)\s+\(|;
      my ($wtitle) = $wbody->[0] =~ m|(.*)\s+\(|;

      if ($ttitle ne $wtitle) {
	return ($self->makeError("Title lines don't match\n$tbody->[0]\n$wbody->[0]"));
      }
    }

    if($#$tbody > 0 && $tbody->[1] ne $wbody->[1]) {
	return ($self->makeError("Secondary title lines don't match:\n$tbody->[1]\n$wbody->[1]"));
    }

    my @errors;
    for(my $n=2 ; $n <= $#$tbody ; ++$n) {
	my ($tnum)=$tbody->[$n]=~/(.*)\*? \(no control file\)/;
	my ($wnum)=$wbody->[$n]=~/(.*)\*? \(no control file\)/;

	return ($self->makeError("Template beyond my ken"))
	    if !defined $tnum;

	return ($self->makeError("Mail beyond my ken"))
	    if !defined $wnum;
    }
    return @errors;
}

sub checkSanity {
    my $self=shift;
    my $wbody=shift;

    my @errors;

    my $noctl=0;
    for(my $n=0 ; $n <= $#$wbody ; ++$n) {
	my $l=$wbody->[$n];

# sendmail
	next if $l=~/^\s+Mail Queue \(\d+ requests?\)$/;
	next if $l=~/^\s+\/var\/spool\/mqueue \(\d+ requests?\)$/;
	next if $l eq '/var/spool/mqueue is empty';
	next if $l =~ m|^-+Q-ID-+ -+Size-+ -+Q-Time-+ -+Sender/Recipient-+$|;
	next if $l=~/^[A-Za-z0-9]+\*?\s+\d+ \w{3} \w{3} {1,2}\d{1,2} \d\d:\d\d /;
	next if $l=~/^\s+\(\S+\@\S+\.\.\. reply: read error from .*\)$/;
	next if $l=~/^\s+\(Deferred: Operation timed out with \S+\)$/;
	next if $l=~/^\s+\(Deferred: Connection reset by \S+\)$/;
	next if $l=~/^\s+\(Deferred: Connection refused by \S+\)$/;
# should be this, but can get truncated...
#	next if $l=~/^\s+\(Deferred: Name server: \S+: host name lookup failure\)$/;
	next if $l=~/^\s+\(Deferred: Name server: \S+: host name.*\)$/;
	next if $l=~/^\s+8BITMIME\s+\(Deferred: Operation timed out with \S+\)$/;
	next if $l=~/^\s+8BITMIME\s+\(Deferred: Connection reset by \S+\)$/;
	next if $l=~/^\s+8BITMIME\s+\(Deferred: Connection refused by \S+\)$/;
# should be this, but can get truncated...
#	next if $l=~/^\s+8BITMIME\s+\(Deferred: Name server: \S+: host name lookup failure\)$/;
	next if $l=~/^\s+\(host map: lookup \(\S+\): deferred\)$/;
	next if $l=~/^\s+\(Warning: could not send message for past 4 hours\)$/;
	next if $l=~m|\s+\(Name service error for name=\S+ type=MX: Host not found, try again\)$|;

# postfix
	next if $l eq '-Queue ID- --Size-- ----Arrival Time---- -Sender/Recipient-------';
	next if $l=~/^[A-F0-9]+\*?\s+\d+ \w{3} \w{3} {1,2}\d{1,2} \d\d:\d\d:\d\d /;
	next if $l=~/^\s*\(connect to \S+: Connection refused\)/;
	next if $l=~/^\s*\(connect to \S+: server dropped connection\)/;
	next if $l=~/^\s*\(connect to \S+: Operation timed out\)/;
	next if $l=~/^\s*\(Name service error for domain \S+: Host not found, try again\)/;
	next if $l=~/^-- \d+ Kbytes in \d+ Requests?\.$/;
	next if $l=~/^\s*\(host \S+ refused to talk to me: 421 .*\)$/;
	next if $l=~/^\s*\(connect to \S+: server refused mail service\)$/;
	next if $l=~/^\s*\(Name service error for \S+: Host not found, try again\)$/;
	next if $l=~/^\s*\(Name service error for \S+: Host not found\)$/;
	next if $l=~/^\s*\(connect to \S+: read timeout\)$/;
	next if $l=~/^\s*\(host \S+ said: 450 .*\)$/;
	next if $l=~/^\s*\(host \S+ said: 451 .*\)$/;
	next if $l=~/^\s*\(host \S+ said: 452 .*\)$/;
	next if $l=~/^\s*\(connect to \S+: No route to host\)$/;
# both
	next if $l=~/^\s+\S+\@\S+$/;
# qmail
#                    15 Sep 2002 01:26:28 GMT  #654839  6691  <> 
	next if $l=~/^\d+\s\w+\s\d+\s[\d:]+\s\w+\s+#\d+\s+\d+\s+<.*?>/;
#                    remote	root@leevan.thebunker.net
#             done   remote	root@leevan.thebunker.net
#                    local	root@leevan.thebunker.net
	next if $l=~/^\s+remote\s+\S+/;
	next if $l=~/^\s+done\s+remote\s+\S+/;
	next if $l=~/^\s+local\s+\S+/;

	if($l=~/^[A-Z]+\d+\* \(no control file\)$/) {
	    if(++$noctl > 2) {
		push @errors,"Too many mails with no control file: $l";
	    }
	    next;
	}

	push @errors,"Unexpected line in mail queue: $l";
    }

    return @errors;
}
	    
