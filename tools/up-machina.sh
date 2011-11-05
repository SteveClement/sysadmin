#!/bin/sh

echo "Checking if VIM install:"
pkg_info vim* > /dev/null
if [ $? = 0 ]; then
 echo VIM Installed
else
 echo VIM NOT Installed, installling from ports:
 portinstall editors/vim
fi

cd /etc/

if [ -f /etc/ntp.conf ]; then
 echo ntp.conf there, backing up and installing new one...
 mv ntp.conf ntp.conf-`date +%d%m%y`
 cp /home/steve/work/kierbiischt-ion-sysadmin/configs/common/ntp.conf .
else
 echo ntp.conf DOES NOT Exist, copying now, check rc.conf for ntpdate, xntpd
 cp /home/steve/work/kierbiischt-ion-sysadmin/configs/common/ntp.conf .
fi


mv profile profile-`date +%d%m%y`
patch < /home/steve/work/kierbiischt-ion-sysadmin/configs/common/rc.diff 
cat /home/steve/work/kierbiischt-ion-sysadmin/configs/common/rc.conf >> rc.conf 
cp /home/steve/work/kierbiischt-ion-sysadmin/configs/common/profile .
cp /home/steve/work/kierbiischt-ion-sysadmin/configs/common/rc.firewall-ion .
cp /home/steve/work/kierbiischt-ion-sysadmin/configs/common/vimrc /usr/local/share/vim/
mv /usr/bin/vi /usr/bin/vi-`date +%d%m%y`
ln -s /usr/local/bin/vim /usr/bin/vi
