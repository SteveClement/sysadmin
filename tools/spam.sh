RECIP="mib@ion.lu"
(cat<<EOF
Subject: TEST_MAIL
To:  $RECIP
EOF
)|/var/qmail/bin/qmail-inject -a -f "" $RECIP || die "Bad error. qmail-inject died"
