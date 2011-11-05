package Automail::Util;

use Carp;
use Exporter;

@Automail::Util::ISA=qw(Exporter);
@Automail::Util::EXPORT=qw(nonFatal);

sub nonFatal {
    my $errors=shift;
    my $error=shift;

    confess $error if !$::Options{nofatal};
    push @$errors,$error if $::Options{daily};
# obviously, if this returns, then the error is non-fatal...
    return 0;
}

1;
