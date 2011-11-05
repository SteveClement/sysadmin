package Automail::Mail;

use Automail::Mail::Section;
use Automail::Hosts;
use Carp;
use IO::Scalar;
use Automail::Util;
use Sys::Syslog;

%Automail::Mail::Frequencies=
    (
     '@@host@@ daily run output' => 'daily',
     '@@host@@ security check output' => 'daily',
     '@@host@@ daily output' => 'daily',
     '@@host@@ daily insecurity output' => 'daily',
     '@@host@@ weekly run output' => 'weekly',
     '@@host@@ weekly output' => 'weekly',
     '@@host@@ monthly run output' => 'monthly',
     '@@host@@ monthly output' => 'monthly',
     );

sub new {
    my $class=shift;
    my $config=shift;

    $class=ref($class) || $class;
    my $self={};
    bless $self, $class;

    $self->{Config}=$config;
    $self->{AlternateHostnames}=[];

    return $self;
}

sub readMail {
    my $self=shift;
    my $tf=shift;
    my $ofile=shift;
    # N.B. errors is only used if $isTemplate
    my $errors=shift;
    my $isTemplate=shift;

    my $str=join '',<$ofile>;

    $self->{Original}=$str;

# This bit of jiggery-pokery is so that we don't commit things that look
# just like mails, which causes some mail software to treat them as seperate
# messages
    nonFatal($errors,"From line not escaped in $tf")
	if $isTemplate && $str!~/^\*From/;

    $str=~s/^\*From/From/;

    my $file=IO::Scalar->new_tie(\$str);

    $self->{Headers}=new Mail::Header;
# work around problem - Mail::Header won't read the IO::Scalar if it is
# passed to the constructor
    $self->{Headers}->read($file);


    my $type;
    if($isTemplate) {
	$type=$self->getHeader('X-Automail-Type');
    } else {
	openlog('automail', 'cons,pid', 'mail');
	syslog('info', 'new mail from '.$self->getFrom().' subject: '.
	               $self->getSubject());
	closelog();

	my $template=$self->{Config}->findTemplate($self);
	$type=$template && $template->getHeader('X-Automail-Type');
    }

    return if defined($type) && $type eq 'muppet';

    while(1) {
	my $section=
	    new Automail::Mail::Section($self,$file,$tf,$type,$errors);
	last if $section->isNull();
	push @{$self->{Sections}},$section;
	last if $section->isMonolith();
    }
}

sub readTemplate {
    my $self=shift;
    my $tf=shift;
    my $errors=shift;

    $self->{TemplateFile}=$tf;

    open(F,$tf) || croak "Can't open $tf: $!";

    $self->readMail($tf,\*F,$errors,1);

    $self->{Frequency}=$self->_getFrequency();
    if(!defined $self->{Frequency}) {
	nonFatal($errors,
		 "Frequency not known for '".$self->getSubject()."'");
    }

    close F;
    return 1;
}

sub getTemplateFileName {
    my $self=shift;

    croak "getTemplateFileName called on non-template!"
	if !exists $self->{TemplateFile};

    return $self->{TemplateFile}
}

sub getPrevSectionBody {
    my $self=shift;
    my $section=shift;

    my (undef,$body)=$::DB->getTemplateSection($self->getTemplateFileName(),$section);

    return $body;
}

sub storePrevSectionBody {
    my $self=shift;
    my $section=shift;
    my $body=shift;

    $::DB->storeTemplateSection($self->getTemplateFileName(),$section,$body);
}

sub hasSectionChanged {
    my $self=shift;
    my $section=shift;
    my $body=shift;

    use FreezeThaw qw(cmpStr);

    my $prev=$self->getPrevSectionBody($section);
    $self->storePrevSectionBody($section,$body);

    return 1 if !defined $prev;

    my $result=cmpStr($prev,$body);

    use Data::Dumper;
    print ::T "",Data::Dumper->Dump([\$prev,\$body,\$result],['*prev','*body',
							   '*result']);
    return $result;
}

sub findAlternateHostnames {
    my $self=shift;
    my $str=shift;

    print ::T "findAlternateHostnames($str)\n";
    my $host=$self->getHost();
    foreach my $name ($str=~/([^ ]+\.[^ ]+)/g) {
	print ::T "Checking alternate $name -> $host...";
	if($name.'.' eq $host) {
	    print ::T "just a trailing dot";
	    push @{$self->{AlternateHostnames}},$name;
	    next;
	}
	if($name eq $host) {
	    print ::T "primary\n";
	    next;
	}
	if($self->isAlternateHostname($name)) {
	    print ::T "already known\n";
	    next;
	}
	my $h2=$host;
	$h2=~s/^([^.]+)/$1.inv/;
	if($name eq $h2) {
	    print ::T "assume inventory domain\n";
	    push @{$self->{AlternateHostnames}},$name;
	    next;
	}
	my ($n2,$aliases,$addrtype,$length,@addrs)=
	  Automail::Hosts::cachedgethostbyname($name);
	if(defined($n2)) {
	    if($n2 eq $host) {
		print ::T "added\n";
		push @{$self->{AlternateHostnames}},$name;
		next;
	    }
	    print ::T "rejected (n2=$n2)\n";
	} else {
	    print ::T "rejected\n";
	}
    }
}

sub replaceHostname {
    my $self=shift;
    my $str=shift;

    $self->findAlternateHostnames($str);
    foreach my $host ($self->getAllHostnames()) {
	$str=~s/\Q$host\E/\@\@host\@\@/;
    }

    foreach my $host ($self->getAllHostnames()) {
	($host)=$host=~/^(.*?)\./;
	next if !defined $host;
	$str=~s/\Q$host\E/\@\@host\@\@/;
    }
    return $str;
}

sub replaceGuessHostname {
    my $self=shift;
    my $str=shift;

    my $subject=$self->getSubject();
    my($guess)=$subject=~/^(\S+) security check output$/;
    return $str if !defined $guess;
    $str=~s/\Q$guess\E/\@\@host\@\@/;
    return $str;
}

sub _getFrequency {
    my $self=shift;

    my $freq=$self->getHeader('X-Automail-Frequency');
    return $freq if defined $freq;

    my $subject=$self->replaceHostname($self->getSubject());

    print ::T "Checking subject $subject\n";
    return $Automail::Mail::Frequencies{$subject};
}

sub getFrequency {
    my $self=shift;

    return $self->{Frequency};
}

sub getHeader {
    my $self=shift;
    my $hdr=shift;

    my $header=$self->{Headers}->get($hdr);
    return undef if !defined $header;
    chomp $header;
    return $header;
}

sub getAddress {
    my $self=shift;
    my $hdr=shift;

    my @addr=Mail::Address->parse($self->getHeader($hdr));
    return $addr[0];
}

sub getFrom {
    my $self=shift;

    return $self->getAddress('From')->address();
}

sub getHost {
    my $self=shift;

#    return $self->getAddress('From')->host();
    my $id=$self->getHeader('Message-Id');
    my($host)=$id=~/\@(.+)>$/;

    return $host;
}

sub getDate {
    my $self=shift;

    use Time::ParseDate;

    my $date=$self->getHeader('Date');
    my $seconds=parsedate($date);

    return $seconds;
}

sub isAlternateHostname {
    my $self=shift;
    my $name=shift;

    return scalar grep { $name eq $_ } $self->{AlternateHostnames};
}

sub getAllHostnames {
    my $self=shift;

    return ($self->getHost(),@{$self->{AlternateHostnames}});
}

sub getSubject {
    my $self=shift;

    return $self->getHeader('Subject');
}

sub getEscapedSubject {
    my $self=shift;

    my $subject=$self->getSubject();
    $subject=~s/[\/<>\s\-]+/_/g;
    return $subject;
}

sub getCanonicalEscapedSubject {
    my $self=shift;

    return Automail::Canonical::subject($self->getEscapedSubject());
}

sub getSection {
    my $self=shift;
    my $n=shift;

    return $self->{Sections}->[$n];
}

sub sendMail {
    my $self=shift;
    my $title=shift;
    my $msg=shift;
    my $mail=shift;

    return $self->{Config}->sendMail($title,$msg,$mail);
}

sub sendYourself {
    my $self=shift;
    my $subject=shift;
    my $message=shift;

    return $self->sendMail("[AutoMail] $subject: ".$self->getSubject(),
			   $message,$self->getMailText());
}

sub getMailText {
    my $self=shift;

    return $self->{Original};
}

sub fileYourself {
    my $self=shift;

    use POSIX;

    my $host=$self->getHost();
    my @t=localtime(time);
    my $datestr=strftime("%Y.%m.%d.%H.%M.%S",@t);
    my $daystr=strftime("%Y.%m.%d",@t);
    my $base=$self->{Config}->getFilingDirectory();
    my $subject=$self->getEscapedSubject();
    mkdir "$base/$daystr",0775;
    my $filename="$base/$daystr/$host-$datestr-$subject";

    my $count=0;
    for( ; ; ) {
	my $extra=$count ? "-$count" : '';
	my $fn="$filename$extra";
	if(!sysopen(F,$fn,O_EXCL|O_CREAT|O_WRONLY,0666)) {
	    print "err=$!\n";
	    if($! eq 'File exists') {
		++$count;
	    } else {
		croak "Can't create $fn: $!";
	    }
	} else {
	    $self->{Filename}=$fn;
	    last;
	}
    }
    print F $self->getMailText();
    close F;
}
    
sub getFilename {
    my $self=shift;

    exists $self->{Filename} ? $self->{Filename} : '(not filed)';
}

sub compare {
    my $self=shift;
    my $mail=shift;

    my $info={Template => $self, Mail => $mail};

    my $t=0;
    my $m=0;

    my @errors;
    for( ; $t <= $#{$self->{Sections}} ; ++$t) {
	my $tsection=$self->getSection($t);
	my $msection=$mail->getSection($m);
	next if $tsection->skippable($msection);
	push @errors,$tsection->compare($msection,$info);
	++$m;
    }
    while($m <= $#{$mail->{Sections}}) {
	my $title=$mail->getSection($m++)->getTitle();
	push @errors,"Unexpected section: $title";
    }
    if(@errors) {
	my($admin,$admin2)=$self->responsibleSysadmin();
#	my $errstr="Sysadmin in charge: $admin\n";
#	$errstr.="Holiday standin   : $admin2\n" if defined $admin2;
#	$errstr.="\n";
	my $errstr='';
	$errstr.="\n".join("\n",@errors)."\n\n".$mail->getFilename()."\n";
	$self->sendMail('[AutoMail] '.$mail->getSubject(),$errstr,
			$mail->getMailText());
    }
    return scalar @errors;
}

sub responsibleSysadmin {
    my $self=shift;

    use Digest::MD5 qw(md5_hex);
    my $host=Automail::Hosts::canonicalize($self->getHost());
    my $num=hex(substr(md5_hex($host.(localtime(time))[4]),0,7));

    my $admins=$self->{Config}->countAdmins();
    my $chosen=$num%$admins;

    my $admin=$self->{Config}->getAdmin($chosen);

    my $name=$admin->getName();
    print ::T "Responsible sysadmin=$name ($chosen of $admins)\n";

    my $standin_name;
    if($admin->onHoliday()) {
	my @standins=$self->{Config}->getAdminsNotOnHoliday();
  	my $count=$#standins+1;
	my $standin=$standins[$num%$count];
	$standin_name=$standin->getName();
	print ::T "Standin sysadmin=$standin_name (of $count)\n";
    }

    return ($name,$standin_name);
}

sub findRecentAge {
    my $self=shift;
    my $mails=shift;
    my $host=shift;
    my $subject=shift;

    $host=Automail::Hosts::canonicalize($host);
    for(my $n=0 ; $n < 31 ; ++$n) {
	if(exists $mails->[$n]->{$host}->{$subject}) {
	    return $n;
	}
    }
    return -1;
}

sub findRecent {
    my $self=shift;
    my $mails=shift;
    my $host=shift;
    my $subject=shift;

    print ::T "find: host=$host subject=$subject\n";
    my $n=$self->findRecentAge($mails,$host,$subject);
    return "not seen in the last 31 days" if $n < 0;
    return "last seen $n day(s) ago";
}

sub checkDaily {
    my $self=shift;
    my $mails=shift;
    my $errors=shift;
    my $ok=shift;

    my $host=$self->getHost();
    my $subject=$self->getCanonicalEscapedSubject();
    my $today=$mails->[0]->{Automail::Hosts::canonicalize($host)}->{$subject};
    if(! $today) {
	my $recent=$self->findRecent($mails,$host,$subject);
	push @$errors,"$host:".$self->getSubject().": daily run missing ($recent)";
    } elsif($#$today > 0) {
	push @$errors,"$host:".$self->getSubject().": daily run more than once";
    } else {
	push @$ok,"$host:".$self->getSubject().": OK";
    }
}

sub checkPeriod {
    my $self=shift;
    my $mails=shift;
    my $period=shift;
    my $errors=shift;
    my $ok=shift;

    my $host=$self->getHost();
    my $subject=$self->getCanonicalEscapedSubject();
    my $lastseen=$self->findRecentAge($mails,$host,$subject);
    if($lastseen < $period && $#{$mails->[$lastseen]->{$host}->{$subject}} > 0) {
	push @$errors,"$host:".$self->getSubject().": periodic($period) run more than once";
    } elsif($lastseen > $period-1 || $lastseen < 0) {
	my $recent=$self->findRecent($mails,$host,$subject);
	push @$errors,"$host:".$self->getSubject().": periodic($period) run missing ($recent)";
    } else {
	push @$ok,"$host (periodic($period)):".$self->getSubject().": OK";
    }
}

sub checkWeekly {
    my $self=shift;
    my $mails=shift;
    my $errors=shift;
    my $ok=shift;

    my $host=$self->getHost();
    my $subject=$self->getCanonicalEscapedSubject();
    my $lastseen=$self->findRecentAge($mails,$host,$subject);
    if($lastseen < 7 && $#{$mails->[$lastseen]->{$host}->{$subject}} > 0) {
	push @$errors,"$host:".$self->getSubject().": weekly run more than once";
    } elsif($lastseen > 6 || $lastseen < 0) {
	my $recent=$self->findRecent($mails,$host,$subject);
	push @$errors,"$host:".$self->getSubject().": weekly run missing ($recent)";
    } else {
	push @$ok,"$host (weekly):".$self->getSubject().": OK";
    }
}

sub checkMonthly {
    my $self=shift;
    my $mails=shift;
    my $errors=shift;
    my $ok=shift;

    my $host=$self->getHost();
    my $subject=$self->getCanonicalEscapedSubject();
    my $lastseen=$self->findRecentAge($mails,$host,$subject);
    if($lastseen < 28 && $#{$mails->[$lastseen]->{$host}->{$subject}} > 0) {
	push @$errors,"$host:".$self->getSubject().": monthly run more than once";
    } elsif($lastseen > 30 || $lastseen < 0) {
	my $recent=$self->findRecent($mails,$host,$subject);
	push @$errors,"$host:".$self->getSubject().": monthly run missing ($recent)";
    } else {
	push @$ok,"$host (monthly):".$self->getSubject().": OK ($lastseen days ago)";
    }
}

sub checkFrequency {
    my $self=shift;
    my $mails=shift;
    my $errors=shift;
    my $ok=shift;

    my $freq=$self->{Frequency};
    if(!defined $freq) {
	nonFatal($errors,$self->getHost().": No frequency");
	return;
    } elsif($freq eq 'daily') {
	$self->checkDaily($mails,$errors,$ok);
	return;
    } elsif($freq eq 'weekly') {
	$self->checkWeekly($mails,$errors,$ok);
	return;
    } elsif($freq eq 'monthly') {
	$self->checkMonthly($mails,$errors,$ok);
	return;
    } elsif($freq eq 'random') {
	return;
    } elsif($freq=~/periodic (\d+)/) {
	$self->checkPeriod($mails,$1,$errors,$ok);
	return;
    }
    nonFatal($errors,$self->getHost().": Unknown frequency: $freq");
}

1;
