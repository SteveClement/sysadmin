#!/bin/sh
#
#

#Pipe into bash if it's present

if [ "`bash --version 2>&1|grep 'GNU bash'`" != "" -a "$BASH_VERSION" = "" ]; then
    exec bash $0 $*
    exit
fi

if [ "$1" != "-doit" ]; then
    cat<<EOF

Usage: ./test_installation.sh -doit

This will simply send 4 Email messages to "root".

The first will be a "normal" message, which should be received untouched.

The second contains the EICAR.COM test virus, and the in-built perlscan
module should catch that.

The third also contains the EICAR.COM test virus - but the filename is 
different. Therefore it will bypass the perlscan module, but should still
be caught by any commercial virus scanners linked in.

The forth is a SPAM message. If you are running SpamAssassin AND Qmail-Scanner
successfully recongised it, then this message should be tagged (look for
X-Spam-Status: header) as being spam. Obviously if you filter your root mail,
this won't end up in your inbox...

If your Qmail-Scanner installation is correct, this will result in the
2nd and 3rd Emails being blocked. If you are using
SpamAssassin, the 4th should be marked as spam.

As far as who receives the e-mail alerts - that's very specific to your install. 
You may have configured Q-S not to notify anyone, or your Q-S "admin" address
may be "postmaster" - in which case notifications won't be sent anyway (as it
appears to be a mailing-list style address). Just look at the logs instead - they
will definitively tell you if Q-S is working correctly. Yet another good reason to
use "--log-details syslog"

If you are logging to syslog, you can just run (as root)

egrep " qmail-scanner\[.* Qmail-Scanner_" /var/log/messages #or appropriate filename

to see the status of those particular messages (maybe "tail -10000" if your syslog 
file is huge)

To run, execute this script again with "-doit" option.

EOF
    exit
fi

RECIP="steve@localhost.lu"

PATH="/var/qmail/bin:$PATH"
export PATH

QS_DESC="Qmail-Scanner Test"
QS_SENDER="`cat /var/qmail/control/defaultdomain 2>/dev/null`"
if [ "$RECIP" = "" -o "$QS_DESC" = "" -o "$QS_SENDER" = "" ]; then
    cat<<EOF

An error has occured.

Cannot find any reference to the Q-S administrator Email address in 
$QMAILQUEUE on your system!

Exiting....

EOF
    exit
fi

RECIP="steve@localhost.lu"
echo ""
echo "Sending standard test message - no viruses... "

(cat<<EOF
From: Qmail-Scanner Test <$QS_SENDER>
To: Root Account <$RECIP>
Subject: Qmail-Scanner test (1/4): inoffensive message

Message 1/4

This is a test message. It should arrive unaffected.


EOF
)|qmail-inject -a -f "" $RECIP || die "Bad error. qmail-inject died"

echo "done!"

echo ""
echo "Sending eicar test virus - should be caught by perlscanner module..."

(
cat<<EOF
From: Qmail-Scanner Test <$QS_SENDER>
To: Qmail-Scanner Test <$RECIP>
Subject: Qmail-Scanner viral test (2/4): checking perlscanner...
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Message 2/4

This is an example of an Email message containing a virus. It should
trigger the Qmail-Scanner system, and as such not be delivered to it's
intended recipient - root.

Instead, the Qmail-Scanner administrator should receive an Email alerting
him/her to the presence of the test virus.



--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Eicar.com"

00000000000000000000000000000000000000000000000000000000000000000000

--gKMricLos+KVdGMg--

EOF
)|qmail-inject -a -f "" $RECIP || die "Bad error. qmail-inject died"

echo "done!"

echo ""
echo "Sending eicar test virus with altered filename - should only be caught by commercial anti-virus modules (if you have any)..."

(
cat<<EOF
From: Qmail-Scanner Test <$QS_SENDER>
To: Qmail-Scanner Test <$RECIP>
Subject: Qmail-Scanner viral test (3/4): checking non-perlscanner AV...
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Message 3/4

This is an example of an Email message containing a virus. It should
trigger the Qmail-Scanner system IF you have an anti virus scanner
installed. Note that this may fail on some AV packages if they decide
that the EICAR test virus must have a filename of "eicar.com".  This
test virus will not be caught by perlscanner as it has the wrong
filename.

If it is caught by AV software, it will not be delivered to it's
intended recipient. Instead, the Qmail-Scanner administrator should
receive an Email alerting him/her to the presence of the test virus.


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sneaky.txt"

X5O!P%@AP[4\PZX54(P^)7CC)7}\$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!\$H+H*

--gKMricLos+KVdGMg--

EOF
)|qmail-inject -a -f "" $RECIP || die "Bad error. qmail-inject died"

QS_SPAMASSASSIN="on"
export QS_SPAMASSASSIN
echo ""
echo "Sending bad spam message for anti-spam testing - In case you are using SpamAssassin..."
(cat<<EOF
Return-Path: sb55sb55@yahoo.com
Delivery-Date: Mon, 14 Aug 2005 13:57:29 +0000
Return-Path: <sb55sb55@yahoo.com>
Delivered-To: jm@netnoteinc.com
Received: from webnote.net (mail.webnote.net [193.120.211.219])
	by mail.netnoteinc.com (Postfix) with ESMTP id 09C18114095
	for <jm7@netnoteinc.com>; Mon, 19 Feb 2001 13:57:29 +0000 (GMT)
Received: from netsvr.Internet (USR-157-050.dr.cgocable.ca [24.226.157.50] (may be forged))
	by webnote.net (8.9.3/8.9.3) with ESMTP id IAA29903
	for <jm7@netnoteinc.com>; Sun, 18 Feb 2001 08:28:16 GMT
From: sb55sb55@yahoo.com
Received: from R00UqS18S (max1-45.losangeles.corecomm.net [216.214.106.173]) by netsvr.Internet with SMTP (Microsoft Exchange Internet Mail Service Version 5.5.2653.13)
	id 1429NTL5; Sun, 18 Feb 2001 03:26:12 -0500
DATE: 16 Aug 01 12:29:13 AM
Message-ID: <9PS291LhupY>
Subject: Qmail-Scanner anti-spam test (4/4): checking SpamAssassin [if present] (There yours for FREE!)
To: undisclosed-recipients:;

Congratulations! You have been selected to receive 2 FREE 2 Day VIP Passes to Universal Studios!

Click here http://209.61.190.180

As an added bonus you will also be registered to receive vacations discounted 25%-75%!



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
This mailing is done by an independent marketing co.
We apologize if this message has reached you in error.
Save the Planet, Save the Trees! Advertise via E mail.
No wasted paper! Delete with one simple keystroke!
Less refuse in our Dumps! This is the new way of the new millennium
To be removed please reply back with the word "remove" in the subject line.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

EOF
)|qmail-inject -a -f "" $RECIP || die "Bad error. qmail-inject died"

echo "Done!"

echo ""
echo "Finished test. Now go and check Email for $RECIP"
echo ""
