#!/bin/sh

# Define ~vpopmail and DSPAM's install Directory
VPOPDIR=/home/vpopmail
DSPAMDIR=/usr/local

# No args, bail
if [ $# -ne 2 ]; then
   echo Usage: $0 domainname username
   exit 1
fi

# Go to the E-Mail Addresses .Spam directory and re-train the dspam Database, afterwards delete the Spam
cd $VPOPDIR/domains/$1/$2/Maildir/.Spam/cur
TOTALSPAM=`ls -1`
SPAMCOUNT=`echo $TOTALSPAM |wc -w |sed 's/ //g'`
i=0
for NAME in `echo $TOTALSPAM`; do
   ##cat $NAME | $DSPAMDIR/bin/dspam --user $2@$1 --mode=teft --class=spam --source=corpus
   cat $NAME | $DSPAMDIR/bin/dspam --user $2@$1 --mode=teft --class=spam --source=error
   rm -f $NAME
   i=`expr $i + 1`
   echo "$NAME Deleted - $i of $SPAMCOUNT"
done
