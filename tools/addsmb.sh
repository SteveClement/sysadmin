#!/bin/sh
/usr/sbin/pw useradd $1
/usr/local/bin/smbpasswd -a $1
/bin/mkdir /home/$1
/usr/sbin/chown $1:$1 /home/$1
/bin/chmod 700 /home/$1
