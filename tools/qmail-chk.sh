if [ `/bin/ps -wwuax |grep qmail-lspawn |wc -l` -lt 1 ]; then
 echo Qmail dead, alert the police and then restart...;
 /usr/local/etc/rc.d/qmail.sh &
fi
