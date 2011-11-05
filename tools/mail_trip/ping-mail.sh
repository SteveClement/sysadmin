#!/usr/local/bin/bash
INIT_TICKS=`date +%s`
RECIP="ping@113.lu"
(cat<<EOF
Return-Path: <pong@victor-buck.com>
From: Pong Account <pong@victor-buck.com>
Organization: VBS
User-Agent: Mozilla Thunderbird 1.0 (X11/20050105)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To:  $RECIP
Subject: Ping me sent: $INIT_TICKS

Ping successfull

EOF
)|/var/qmail/bin/qmail-inject || die "Bad error. qmail-inject died"

# Cleanup all mailboxes
fetchmail -f .fetchmailrc-local --silent
fetchmail -f .fetchmailrc-remote --silent
fetchmail -f .fetchmailrc-remoteG --silent
rm /tmp/*_delivery 2> /dev/null
done=0

while [ $done -ne 1 ]; do
 if [ -e /tmp/remote_delivery ]; then
  #echo "Remote mail received now checking local delivery"

  if [ -e /tmp/local_delivery ]; then
   #echo "Local mail received exiting"
   done=1
   rm /tmp/*_delivery
   TAKEN_TO=`echo "$REMOTE_TICKS - $INIT_TICKS" |bc `
   TAKEN_FROM=`echo "$LOCAL_TICKS - $REMOTE_TICKS" |bc `
   TAKEN_LOOP=`echo "$LOCAL_TICKS - $INIT_TICKS" |bc `
   rrdupdate rrd/to.rrd N:$TAKEN_TO
   rrdupdate rrd/from.rrd N:$TAKEN_FROM
   rrdupdate rrd/loop.rrd N:$TAKEN_LOOP
   rrdupdate rrd/summary.rrd N:$TAKEN_TO:$TAKE_FROM:$TAKEN_LOOP
   rrdupdate rrd/tofrom.rrd N:$TAKEN_TO:$TAKE_FROM
   echo "<head>" > ~apache/hosts/victor-buck.com/ivb/bsd-steve/mail_trip/index.html
   echo "<meta http-equiv=\"refresh\" content=\"30; URL=https://sysadmin/mail_trip/\">" >> ~apache/hosts/victor-buck.com/ivb/bsd-steve/mail_trip/index.html
   echo "</head>" >> ~apache/hosts/victor-buck.com/ivb/bsd-steve/mail_trip/index.html
   echo "<html>" >> ~apache/hosts/victor-buck.com/ivb/bsd-steve/mail_trip/index.html
   echo "Date of current run: `date `<br />" >> ~apache/hosts/victor-buck.com/ivb/bsd-steve/mail_trip/index.html
   echo "To Outside Address   : $TAKEN_TO seconds<br />" >> ~apache/hosts/victor-buck.com/ivb/bsd-steve/mail_trip/index.html
   echo "From Outside Address : $TAKEN_FROM seconds<br />" >>~apache/hosts/victor-buck.com/ivb/bsd-steve/mail_trip/index.html
   echo "Loop Back            : $TAKEN_LOOP seconds<br />" >>~apache/hosts/victor-buck.com/ivb/bsd-steve/mail_trip/index.html
   echo "</html>" >> ~apache/hosts/victor-buck.com/ivb/bsd-steve/mail_trip/index.html
   echo "You can CTRL-C I am sleeping"
   sleep 10
   clear
   echo "Running"
   #echo "Initial ticks: $INIT_TICKS "
   #echo "Remote ticks: $REMOTE_TICKS "
   #echo "Local ticks: $LOCAL_TICKS "
  else
   #echo "no local mail yet"
   fetchmail -f .fetchmailrc-local --silent
   LOCAL_TICKS=`date +%s`
   sleep 1
  fi
else
 #echo "no remote mail yet"
 fetchmail -f .fetchmailrc-remote --silent
 REMOTE_TICKS=`date +%s`
 sleep 1
fi

done
