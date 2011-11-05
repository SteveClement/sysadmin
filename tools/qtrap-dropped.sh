## This mails the qtrap.log to the Admin...
cat /home/vpopmail/spamcheck/logs/qtrap.log |mail rootmails@ion.lu
rm /home/vpopmail/spamcheck/logs/qtrap.log
touch /home/vpopmail/spamcheck/logs/qtrap.log
chown vpopmail:vchkpw /home/vpopmail/spamcheck/logs/qtrap.log
chmod 750 /home/vpopmail/spamcheck/logs/qtrap.log
