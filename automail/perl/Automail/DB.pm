use strict;

package Automail::DB;
use DB_File::Lock;
use Carp;
use FreezeThaw qw(freeze thaw);

sub new {
    my $class=shift;
    my $file=shift;

    $class=ref($class) || $class;
    my $self={};
    bless $self, $class;

    my $h=new DB_File::HASHINFO;
    tie(%{$self->{DB}},'DB_File::Lock',$file,O_CREAT|O_RDWR,0666,$h,'write')
	|| croak "Can't open or create db $file: $!";

    return $self;
}

sub getTemplateSection {
    my $self=shift;
    my $template_name=shift;
    my $section=shift;

    print ::T "getTemplateSection: template=$template_name section=$section\n";
    my $value=$self->{DB}->{"section:$template_name:$section"};
    return (undef,undef) if !defined $value;
    my ($time,$body)=$value=~/^(\d+):(.*)$/;
    print ::T "time=$time body=[$body]\n";
    ($body)=thaw($body);

    return ($time,$body);
}

sub storeTemplateSection {
    my $self=shift;
    my $template_name=shift;
    my $section=shift;
    my $body=shift;

    $body=freeze($body);
    print ::T "storeTemplateSection: template=$template_name section=$section body=[$body]\n";
    $self->{DB}->{"section:$template_name:$section"}=time.":$body";
}

1;
