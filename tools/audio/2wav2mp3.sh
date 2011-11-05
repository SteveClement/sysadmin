#!/bin/sh
# 2wav2mp3 - create stereo mp3 out of two mono wav-files
# source files will be deleted
#
# 2005 05 23 dietmar zlabinger http://www.zlabinger.at/asterisk
#
# usage: 2wav2mp3 <wave1> <wave2> <mp3>
# designed for Asterisk Monitor(file,format,option) where option is "e" and
# the variable
# MONITOR_EXEC/usr/local/bin/2wav2mp3


# location of SOX and SOXMIX
# (set according to your system settings, eg. /usr/bin)
SOX=/usr/local/bin/sox
SOXMIX=/usr/local/bin/soxmix
# lame is only required when sox does not support liblame
#LAME=/usr/local/bin/lame


# command line variables
LEFT="$1"
RIGHT="$2"
OUT="$3"

#test if input files exist
test ! -r $LEFT && exit
test ! -r $RIGHT && exit

# convert mono to stereo, adjust balance to -1/1
# left channel
$SOX $LEFT -c 2 $LEFT-tmp.wav pan -1
# right channel
$SOX $RIGHT -c 2 $RIGHT-tmp.wav pan 1

# combine and compress
# this requires sox to be built with mp3-support.
# To see if there is support for Mp3 run sox -h and
# look for it under the list of supported file formats as "mp3".
$SOXMIX -v 1 $LEFT-tmp.wav -v 1 $RIGHT-tmp.wav -v 1 $OUT.mp3

# in case an old version of sox is used, encoding
# can be done afterwards
#$SOXMIX -v 1 $LEFT-tmp.wav -v 1 $RIGHT-tmp.wav -v 1 $OUT.wav
#$LAME -S -V7 -B24 --tt $OUT --add-id3v2 $OUT.wav $OUT.mp3


#remove temporary files
test -w $LEFT-tmp.wav && rm $LEFT-tmp.wav
test -w $RIGHT-tmp.wav && rm $RIGHT-tmp.wav
test -w $OUT.wav && rm $OUT.wav

#remove input files if successfull
test -r $OUT.mp3 && rm $LEFT $RIGHT
# eof 
