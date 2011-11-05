#!/bin/sh
/usr/local/bin/rrdtool graph /home/apache/hosts/victor-buck.com/ivb/bsd-steve/mail_trip/loop.png -a PNG -h 125 -s -129600 -v "Time Taken" \
    'DEF:to=loop.rrd:to:AVERAGE' \
    'CDEF:secto=to' \
    'AREA:to#00FF00:Time Taken'  \
    'GPRINT:secto:LAST:Time for Last Mail\:    %lf Seconds' \
    'GPRINT:secto:AVERAGE:Average Time Taken\: %lf Seconds' 
