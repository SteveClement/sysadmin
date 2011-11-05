RECIP="steve@ion.lu"
(cat<<EOF
From: Steve Clement <steve@localhost.lu>
Organization: localhost.lu
User-Agent: Mozilla Thunderbird 1.0 (X11/20050105)
X-Accept-Language: en-us, en
X-Spam-Status: Yes, score=16.6 required=7.0
MIME-Version: 1.0
To:  $RECIP
Subject: Ping me sent: `date +%s`

Ping successfull

EOF
)|/var/qmail/bin/qmail-inject -a -f "" $RECIP || die "Bad error. qmail-inject died"
