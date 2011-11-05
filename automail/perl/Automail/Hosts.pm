package Automail::Hosts;

sub cachedgethostbyname {
    my $name=shift;

    if(!exists $Automail::Hosts::Cache{$name}) {
	my @result=gethostbyname($name);
	$Automail::Hosts::Cache{$name}=\@result;
    }
    return @{$Automail::Hosts::Cache{$name}};
}

sub canonicalize {
    my $str=shift;

    my $canonical;
    foreach my $part (split /([^a-zA-Z0-9._])/,$str) {
	if($part=~/[^a-zA-Z0-9._]/ || $part!~/\./) {
	    $canonical.=$part;
	} else {
	    print ::T "canonicalize $part";
	    my ($n2,$aliases,$addrtype,$length,@addrs)=cachedgethostbyname($part);
	    if(!defined $n2) {
		print ::T "...unknown\n";
		$canonical.=$part;
	    } elsif($n2 ne $part) {
		print ::T " -> $n2\n";
		$canonical.=$n2;
	    } else {
		print ::T "...primary\n";
		$canonical.=$part;
	    }
	}
    }
    if(defined $canonical) {
	print ::T "$str mapped to $canonical\n";
    } else {
	print ::T "$str not mapped\n";
	$canonical=$str;
    }
    return $canonical;
}

1;
