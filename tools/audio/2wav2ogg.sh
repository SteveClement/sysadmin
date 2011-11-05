#!/bin/sh -v
# 2wav2ogg - create stereo ogg out of two mono wav-files
# source files will be deleted
#
# 2005 05 23 dietmar zlabinger http://www.zlabinger.at/asterisk
# 2006 09 26 Modified by Cherebrum & utsl to do ogg instead of mp3
#
# usage: 2wav2ogg <wave1> <wave2> <ogg>
# designed for Asterisk Monitor(file,format,option) where option is "e" and
# the variable
# MONITOR_EXEC/usr/local/bin/2wav2ogg


# location of SOX and SOXMIX
# (set according to your system settings, eg. /usr/bin)
SOX=/usr/bin/sox
SOXMIX=/usr/bin/soxmix


# command line variables
LEFT="$1"
RIGHT="$2"
OUT=`echo $3|sed s/.wav//`

echo $1 $2 $3 >>/tmp/2wav2ogg.log

#test if input files exist
test ! -r $LEFT && exit
test ! -r $RIGHT && exit

# convert mono to stereo, adjust balance to -1/1
# left channel
/usr/bin/nice -n 10 $SOX $LEFT -c 2 -t wav $LEFT-tmp.wav pan -1
# right channel
/usr/bin/nice -n 10 $SOX $RIGHT -c 2 -t wav $RIGHT-tmp.wav pan 1


# mix and encode to ogg vorbis
/usr/bin/nice -n 10 $SOXMIX -v 1 -t wav $LEFT-tmp.wav -v 1 -t wav $RIGHT-tmp.wav -v 1 -t vorbis $OUT.ogg

#remove temporary files
test -w $LEFT-tmp.wav && rm $LEFT-tmp.wav
test -w $RIGHT-tmp.wav && rm $RIGHT-tmp.wav
test -w $OUT.wav && rm $OUT.wav

#remove input files if successfull
test -r $OUT.ogg && rm $LEFT $RIGHT
# eof
