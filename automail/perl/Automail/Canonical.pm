package Automail::Canonical;

sub subject {
    my $subject=shift;

    # Replace dates... "/etc/localtime" weirdness is for braindead Linuxes that
    # seem to like to put that into date instead of anything sensible.
    $subject=~s/(Mon|Tue|Wed|Thu|Fri|Sat|Sun)( |_)(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)( |_)( ?\d|\d\d)( |_)\d\d:\d\d:\d\d( |_)([A-Z][A-Z][A-Z]|\/?etc(\/|_)localtime)( |_)\d{4}/\@\@date\@\@/;
    $subject=~s/(January|February|March|April|May|June|July|August|September|October|November|December) \d+, \d+/\@\@date\@\@/;

    return $subject;
}

1;
