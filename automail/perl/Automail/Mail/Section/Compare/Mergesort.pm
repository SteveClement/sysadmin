package Automail::Mail::Section::Compare::Mergesort;

use Automail::Mail::Section::Compare::Base;

@Automail::Mail::Section::Compare::Mergesort::ISA=
    qw(Automail::Mail::Section::Compare::Base);

sub findSection {
    my $self=shift;
    my $body=shift;
    my $start=shift;
    my $section=shift;
    my $type=shift;
    my $errors=shift;

    return undef if !defined $start;
    my $n;
    for($n=$start ; $n <= $#$body ; ++$n) {
	goto ok if $body->[$n] =~ /^$section:/;
    }
#   don't error, just return undef
#   push @$errors,$self->makeError("Can't find section $section in $type");
    return undef;
  ok:
    return $n;
}

sub compare {
    my $self=shift;
    my $with=shift;

    my $tbody=$self->{Template}->getBody();
    my $wbody=$with->getBody();

    my @errors;
    my $n=0;
    while (defined ($n=$self->findSection($wbody,$n,'Final status','mail',\@errors))) {
        my $str=$wbody->[$n];
        if ($str!~/OK$/) {
            push @errors, $self->makeError("'$str' - not OK");
        }
	$n++;
    }
    return @errors;
}

1;
