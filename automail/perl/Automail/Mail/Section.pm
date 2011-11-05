package Automail::Mail::Section;

use Carp;
use Automail::Mail::Section::Compare::Vanilla;
use Automail::Mail::Section::Compare::Ignore;
use Automail::Mail::Section::Compare::DiskStatus;
use Automail::Mail::Section::Compare::NetworkInterface;
use Automail::Mail::Section::Compare::LocalSystem;
use Automail::Mail::Section::Compare::MailQueue;
use Automail::Mail::Section::Compare::LoginAccounting;
use Automail::Mail::Section::Compare::Pattern;
use Automail::Mail::Section::Compare::PatternOptional;
use Automail::Mail::Section::Compare::Backup;
use Automail::Mail::Section::Compare::Firewall;
use Automail::Mail::Section::Compare::OpenPorts;
use Automail::Mail::Section::Compare::Amanda;
use Automail::Mail::Section::Compare::Mergesort;
use Automail::Mail::Section::Compare::Vinum;
use Automail::Mail::Section::Compare::MysqlBackup;
use Automail::Util;

%Automail::Mail::Section::Comparers=
    (
     'Disk status' => 'DiskStatus',
     'disks' => 'DiskStatus',
     'Network interface status' => 'NetworkInterface',
     'network' => 'NetworkInterface',
     'Local system status' => 'LocalSystem',
     'Mail in local queue' => 'MailQueue',
     'Mail in submit queue' => 'MailQueue',
     'mail' => 'MailQueue',
     'Doing login accounting' => 'LoginAccounting',
     '***monolith-pattern***' => 'Pattern',
     '***monolith-pattern-optional***' => 'PatternOptional',
     '***monolith-backup***' => 'Backup',
     '***monolith-block***' => 'Vanilla',
     'Last dump(s) done (Dump \'>\' file systems)' => 'Ignore',
     '@@host@@ denied packets' => 'Firewall',
     '@@host@@ ipfw denied packets' => 'Firewall',
     'ipfw log limit reached' => 'Firewall',
     '@@host@@ refused connections' => 'PatternOptional',
     '@@host@@ kernel log messages' => 'PatternOptional',
     'Checking setuid/setgid files and devices' => 'PatternOptional',
     'Open ports' => 'OpenPorts',
     '***monolith-amanda***' => 'Amanda',
     '***monolith-mergesort***' => 'Mergesort',
     '***monolith-mysqlbackup***' => 'MysqlBackup',
     'Vinum status' => 'Vinum',

     'Removing stale files from /var/preserve' => 'Vanilla',
     'Cleaning out old system announcements' => 'Vanilla',
     'Removing stale files from /var/rwho' => 'Vanilla',
     'Backup passwd and group files' => 'Vanilla',
     'Verifying group file syntax' => 'Vanilla',
     'Backing up mail aliases' => 'Vanilla',
     'UUCP status' => 'Vanilla',
     'uucp' => 'Vanilla',
     'Security check' => 'Vanilla',
     'Checking for rejected mail hosts' => 'Vanilla',
     'checking setuid files and devices' => 'PatternOptional',
     'Checking setuid files and devices' => 'PatternOptional',
     'checking for uids of 0' => 'Vanilla',
     'Checking for uids of 0' => 'Vanilla',
     'checking for passwordless accounts' => 'Vanilla',
     'Checking for passwordless accounts' => 'Vanilla',
     '@@host@@ login failures' => 'Vanilla',
     'Checking the /etc/master.passwd file' => 'Vanilla',
     'Checking the /etc/group file' => 'Vanilla',
     'Subject' => 'Vanilla',
     'Removing scratch and junk files' => 'Vanilla',
     'Running calendar in the background' => 'Vanilla',
     'Running calendar' => 'Vanilla',
     'Checking subsystem status' => 'Vanilla',
     'Rotating mail log' => 'Vanilla',
     'ruptime: no hosts in /var/rwho' => 'Vanilla',
     'Rotating messages' => 'Vanilla',
     'Checking special files and directories' => 'Vanilla',
     'Rebuilding locate database' => 'Vanilla',
     'Rebuilding whatis database' => 'Vanilla',
     'Cleaning up kernel database files' => 'Vanilla',
     'Rotating cron log' => 'Vanilla',
     'Purging accounting records' => 'Vanilla',
     '@@host@@ setuid diffs' => 'Vanilla',
     'Rotating log files' => 'Vanilla',
     'Nothing to do' => 'Vanilla',
     '@@host@@ checking for denied secondary zone transfers' => 'Vanilla',
     'Possible core dumps' => 'Vanilla',
     'Checking for denied zone transfers (AXFR and IXFR)' => 'Vanilla',
     'Checking root sh paths, umask values' => 'Vanilla',
     'Running /etc/daily.local' => 'Vanilla',
     'ntp messages' => 'Vanilla',
     '-- End of daily output --' => 'Vanilla',
     '-- End of security output --' => 'Vanilla',
     '-- End of weekly output --' => 'Vanilla',
     '-- End of monthly output --' => 'Vanilla',
    );

sub new {
    my $class=shift;
    my $mail=shift;
    my $file=shift;
    my $tf=shift;
    my $type=shift;
    my $errors=shift;

    $class=ref($class) || $class;
    my $self={};
    bless $self, $class;

    $self->{Mail}=$mail;
    $self->{TemplateFile}=$tf;

    if(!defined $type) {
	$self->readHeadedSection($file,$errors);
    } elsif($type=~/^monolith-/) {
	if(!$file->eof()) {
	    $self->readWholeFile($file);
	} else {
	    push @{$self->{Body}},'';
	}
	$self->{Title}="***$type***";
    } else {
	confess "Unknown type: $type";
    }

    return $self;
}

sub readHeadedSection {
    my $self=shift;
    my $file=shift;
    my $errors=shift;

    my $section;
    while(<$file>) {
	chomp;
	next if $_ eq '';
	$section=$_;
	last;
    }

    return if !defined $section;

    # work around a bug where the subject line is included in the file...
    my $subject=$self->{Mail}->getSubject();
    $subject=~s/daily/daily run/;
    $section="Subject:" if $section=~/^Subject: $subject$/;

    # Special case for now (FIXME)
    if($section=~/^Rotating log files: (.*)$/) {
	$self->{Title}='Rotating log files';
	push @{$self->{Body}},$1;
	return;
    }

    my $title;
    if ($section=~m|^(.*)[:.!]$|) {
	# foo:
	$title=$1;
    } elsif ($section=~m|^\[.*\]\s*(.*)$|) {
	# [bar] foo
	$title=$1;
    } elsif ($section=~m|(-- End of \S+ output --)$|) {
	# -- End of foo output --
	$title=$1;
    } else {
        nonFatal($errors,"Bad section in $self->{TemplateFile}: '$section'");
        print ::T "Bad section in $self->{TemplateFile}: '$section'";
        print "Bad section in $self->{TemplateFile}: '$section'";
    }


    $title=~/^(<([^=]*)=?(.*)>)?(.*)$/;
    my $value=defined($3) && $3 ne '' ? $3 : 1;
    $self->{Options}->{$2}=$value if defined $2;
    $self->{Title}=$4;

    while(<$file>) {
	chomp;
	last if $_ eq '';

	push @{$self->{Body}},$_;
    }
}

sub readWholeFile {
    my $self=shift;
    my $file=shift;

    while(<$file>) {
	chomp;

	push @{$self->{Body}},$_;
    }
}

sub skippable {
    my $self=shift;
    my $with=shift;

    return $self->{Options}->{'skip-if-empty'}
      && (!defined($with->{Title}) || $self->{Title} ne $with->{Title});
}

sub getOption {
    my $self=shift;
    my $option=shift;

    return exists($self->{Options}->{$option}) && $self->{Options}->{$option};
}

sub isNull {
    my $self=shift;

    return !exists $self->{Title};
}

sub isMonolith {
    my $self=shift;

    return $self->{Title}=~/^\*\*\*monolith-/;
}

sub compare {
    my $self=shift;
    my $with=shift;
    my $info=shift;

    if($self->{Title} ne $with->{Title}) {
	return ("Section titles don't match: Expected '$self->{Title}', got '$with->{Title}'");
    }
    my $comparer=$self->findComparer();
    if(!defined $comparer) {
	return ("Unknown section type: '$self->{Title}'");
    }
    return $comparer->compare($with,$info);
}

sub findComparer {
    my $self=shift;

    my $title=$self->{Mail}->replaceHostname($self->{Title});
    print ::T "findComparer($title)\n";
    my $sref=$Automail::Mail::Section::Comparers{$title};
    # we have a machine called mail that has a section called mail - natch
    # we end up searching for @@host@@, which fails, so also check the raw
    # title
    $sref=$Automail::Mail::Section::Comparers{$self->{Title}}
        if !defined $sref;
    # if all else fails, then try and guess the hostname and try again...
    if(!defined $sref) {
	$title=$self->{Mail}->replaceGuessHostname($self->{Title});
	$sref=$Automail::Mail::Section::Comparers{$title};
    }
    return undef if !defined $sref;
    my $code="Automail::Mail::Section::Compare::$sref->new(\$self)";
    my $comparer=eval $code;
    croak "Can't instantiate comparer: $sref ($code): $@" if $@;
    return $comparer;
}

sub getBody {
    my $self=shift;

    return $self->{Body};
}

sub getTitle {
    my $self=shift;

    return $self->{Title};
}

sub getHost {
    my $self=shift;

    return $self->{Mail}->getHost();
}

sub hasSectionChanged {
    my $self=shift;
    my $body=shift;

    return $self->{Mail}->hasSectionChanged($self->getTitle(),$body);
}

sub getFrequency {
    my $self=shift;

    return $self->{Mail}->getFrequency();
}

1;
