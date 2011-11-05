use strict;

package Automail::Config;

use Automail::Host;
use Automail::Mail;
use Automail::Hosts;
use Automail::Canonical;
use Automail::DB;
use Automail::Sysadmin;
use Carp;

sub new {
    my $class=shift;
    my $file=shift;
    my $errors=shift;

    $class=ref($class) || $class;
    my $self={};
    bless $self, $class;

    $self->readConfig($file,$errors);

    return $self;
}

sub readConfig {
    my $self=shift;
    my $file=shift;
    my $errors=shift;

    open(C,$file) || croak "Can't open $file: $!";

    while(<C>) {
	chomp;

	next if /^#/;

	my @row=split /:/;

	my $type=$row[0];
	if(!defined($type)) {
	    next if /^\s*$/;
	    croak "Bad config line: $_";
	}

	if($type eq 'host') {
	    my ($name,$os)=@row[1..2];
	    $self->{Hosts}->{$name}=new Automail::Host($name,$os);
	} elsif($type eq 'template') {
	    my $tdir=$row[1];
	    $self->catalogueTemplates($tdir,$errors);
	} elsif($type eq 'store') {
	    $self->{FilingDirectory}=$row[1];
	} elsif($type eq 'mail') {
	    $self->{MailTo}=$row[1];
	} elsif($type eq 'db') {
	    $::DB=new Automail::DB($row[1]);
	} elsif($type eq 'sysadmin') {
	    push @{$self->{Sysadmin}},new Automail::Sysadmin($row[1],$row[2]);
	} else {
	    croak "Unknown record type $type!";
	}
    }
    close C;
}

sub countAdmins {
    my $self=shift;

    return $#{$self->{Sysadmin}}+1;
}

sub getAdmin {
    my $self=shift;
    my $n=shift;

    return $self->{Sysadmin}->[$n];
}

sub getAdminsNotOnHoliday {
    my $self=shift;

    return grep {!$_->onHoliday()} @{$self->{Sysadmin}};
}

sub getFilingDirectory {
    my $self=shift;

    croak "Store not set!" if !defined $self->{FilingDirectory};
    return $self->{FilingDirectory};
}

sub findTemplate {
    my $self=shift;
    my $mail=shift;

    my $sender=Automail::Hosts::canonicalize($mail->getFrom());

    my $subject=$mail->getSubject();
    $subject=Automail::Canonical::subject($subject);

    print ::T "Looking for template for $sender/$subject\n";
    my $template=$self->{Senders}->{$sender}->{Subjects}->{$subject};
#    use Data::Dumper; print Data::Dumper->Dump([\$self->{Senders}->{$sender}],
#					       ['*senders']);

    return $template;
}

sub _doSend {
    my $self=shift;
    my $mail=shift;

# Add a header so we can detect loops...
    $mail="X-Automail-Loop: oops\n$mail";
    open(MAIL, "|/usr/sbin/sendmail -t") || croak "Unable to send the Email - $!";
    print MAIL $mail;
    close MAIL;

    croak "mail send failed, error $?" if $?;
}

sub sendMail {
    my $self=shift;
    my $title=shift;
    my $msg=shift;
    my $attachment=shift;

    use MIME::Entity;

    my $to=$self->{MailTo};
    my $reply=(split /,/,$to)[0];
    my $mime=MIME::Entity->build(To => $to,
				 Subject => $title,
				 Data => $msg,
				 'Reply-To' => $reply);
    if(defined $attachment) {
	if($attachment =~ /X-Automail-Loop: oops/) {
	    $mime->attach(Data => "Loop detected, attachment not attached\n");
	} else {
	    $mime->attach(Data => $attachment, Type => 'message/rfc822');
	}
    }

    if($::Options{trace}) {
	print ::T "Sending:\n\n";
	$mime->print(\*::T);
    }

    $self->_doSend($mime->as_string()) if !$::Options{nomail};
}

sub catalogueTemplates {
    my $self=shift;
    my $tdir=shift;
    my $errors=shift;

    opendir(D,$tdir) || croak "Can't open template directory $tdir: $!";
    while(my $ftail=readdir D) {
	next if $ftail=~/^\./;
	next if $ftail=~/~$/;
	my $fname="$tdir/$ftail";
	next if ! -f $fname;

	print ::T "Template: $fname\n";

	my $template=new Automail::Mail($self);
	next if !$template->readTemplate($fname,$errors);
	push @{$self->{Templates}},$template;
	my $sender=Automail::Hosts::canonicalize($template->getFrom());

	my $subject=$template->getSubject();
	$subject=Automail::Canonical::subject($subject);

	print ::T "Add template $sender/$subject\n";
	$self->{Senders}->{$sender}->{Subjects}->{$subject}=$template;
    }
}

sub checkTemplateFrequency {
    my $self=shift;
    my $date=shift;
    my $errors=shift;

    use POSIX;

    my $store=$self->getFilingDirectory();
    my @Mails;
    for(my $day=0 ; $day < 31 ; ++$day) {
	my @t=localtime(time-$day*24*60*60);
	my $daystr=strftime("%Y.%m.%d",@t);
	my $dir="$store/$daystr";
	if(!opendir D,$dir) {
	    push @$errors,"Can't open $dir: $!";
	    next;
	}

	while(my $fn=readdir D) {
	    next if $fn=~/^\./;
	    my ($host,$time,$subject)=$fn=~/(.*)-(.*)-(.*)/;
	    if(!defined $subject) {
		push @$errors,"Unparseable filename: $dir/$fn";
		next;
	    }
	    $subject=Automail::Canonical::subject($subject);
	    $host=Automail::Hosts::canonicalize($host);
	    print ::T "mail: host=$host subject=$subject\n";
	    push @{$Mails[$day]->{$host}->{$subject}},"$dir/$fn";
	}
	closedir D;
    }

    my @ok;
    foreach my $template (@{$self->{Templates}}) {
	$template->checkFrequency(\@Mails,$errors,\@ok);
    }

#    use Data::Dumper;
#    print Data::Dumper->Dump([\@Mails],['*Mails']);

    @ok=sort @ok;
    @$errors=sort @$errors;

    $self->sendMail("[AutoMail] Daily check",join("\n",@$errors)."\n\n=====\n\n".join("\n",@ok)."\n",undef);

    return @$errors;
}

1;
