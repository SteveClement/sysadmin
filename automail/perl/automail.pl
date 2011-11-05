#!/usr/bin/perl -w 

# Analyse sysadmin mail and look for unusual stuff...
use strict;

use Carp;
use Getopt::Long;
use Data::Dumper;
use Mail::Header;
use Mail::Address;
use Automail::Config;

%::Options=();
GetOptions(\%::Options,'nomail!','nofile!','trace!','trace-stdout!','--daily!','--nofatal!');

# Let our friends read our files...
umask 0027;

if($::Options{'trace-stdout'}) {
    *T=*STDOUT;
    $::Options{trace}=1;
    autoflush T 1;
} elsif($::Options{trace}) {
    open(T,">/tmp/automail.dump") || croak "open failed: $!";
} else {
    open(T,">/dev/null");
}

my $confFile=$ARGV[0];

croak "$0 <config file>" if !defined $confFile;

my @errors;
my $config=new Automail::Config($confFile,\@errors);

if($::Options{daily}) {
    doDaily($config,\@errors);
} else {
    processMail($config);
}

sub doDaily {
    my $config=shift;
    my $errors=shift;

    my $date=time;
    $config->checkTemplateFrequency($date,$errors);
}

sub processMail {
    my $config=shift;

    my $mail=new Automail::Mail($config);
    eval { $mail->readMail('*stdin*',\*STDIN); };
    my $err=$@;

    $mail->fileYourself() if !$::Options{nofile};

    if($err) {
	$mail->sendYourself("Mail parse failed",$mail->getFilename()."\n$err");
	exit 0;
    }

    my $template=$config->findTemplate($mail);
    if(!defined $template) {
	$mail->sendYourself("Missing template",$mail->getFilename());
	exit 0;
    }

    my $failed=$template->compare($mail);
}

