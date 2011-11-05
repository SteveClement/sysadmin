uname -a

MAILER_MD5=`md5 -q /etc/mail/mailer.conf`
MAILER_SUM=`md5 -q /home/steve/work/kierbiischt-ion-sysadmin/configs/common/mailer.conf`

if [ $MAILER_MD5 == $MAILER_SUM ]; then
echo mailer.conf OK
else
echo Sendmail??? :
ps -auxww |grep sendm
echo QMAIL??? :
ps -auxww |grep qm
cat /etc/mail/mailer.conf
cp -i /home/steve/work/kierbiischt-ion-sysadmin/configs/common/mailer.conf /etc/mail/
fi


portupgrade sysutils/portupgrade
portupgrade sysutils/rc_subr
portupgrade shells/bash2
portupgrade devel/cvsd
portupgrade editors/vim
portupgrade devel/automake14
