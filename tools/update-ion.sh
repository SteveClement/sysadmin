## This script will update a FreeBSD-ion Machine 6_1 and Later required!

portsnap fetch update


## Filelist:
       for PORT in `echo gettext qmail portupgrade ucspi-tcp openvpn mrtg bash-completion rsync`; do
                echo "mkdir -p $PORTS_OPTIONS/$PORT"
                echo "cp $REPO$CONFIGS_COMMON$PORTS_OPTIONS/$PORT/options $PORTS_OPTIONS/$PORT"
        done

 cp $REPO$CONFIGS_COMMON/cvsupfile /etc/
        cp $REPO$CONFIGS_COMMON/cvsupfile-$VERSION /etc/


        $CVSUP /etc/cvsupfile-$VERSION &
        $PORTINSTALL $PORTS
        /var/qmail/scripts/enable-qmail
     if [ -f /etc/ntp.conf ]; then
         echo ntp.conf there, backing up and installing new one...
         mv ntp.conf ntp.conf-`date +%d%m%y`
         cp $REPO$CONFIGS_COMMON/ntp.conf .
        else
         echo ntp.conf DOES NOT Exist, copying now, check rc.conf for ntpdate, xntpd
         cp $REPO$CONFIGS_COMMON/ntp.conf .
        fi
         mv profile profile-`date +%d%m%y`
  cp $REPO$CONFIGS_COMMON/sshd_localhost /etc/rc.d/
        ln -s /usr/sbin/sshd /usr/sbin/sshd_localhost
  cat $REPO$CONFIGS_COMMON/rc.conf >> rc.conf
        cp $REPO$CONFIGS_COMMON/profile .
        cp $REPO$CONFIGS_COMMON/rc.firewall-ion .
        cp $REPO$CONFIGS_COMMON/vimrc /usr/local/share/vim/
        mv /usr/bin/vi /usr/bin/vi-`date +%d%m%y`
        ln -s /usr/local/bin/vim /usr/bin/vi

        chmod 755 /var/qmail/rc
/var/qmail/bin/qmailctl

   cp /usr/local/etc/isoqlog.conf-dist /usr/local/etc/isoqlog.conf
        cp /usr/local/etc/isoqlog.domains-dist /usr/local/etc/isoqlog.domains
        pkgdb -F && $PORTUPGRADE -Rra

if [ -f /usr/src/sys/i386/conf/$HOSTNAME ]; then
 echo "Kernel config present..."
else
 echo "NO KERNEL CONFIG COPYING DEFAULT..."
 cp /usr/src/sys/i386/conf/GENERIC /usr/src/sys/i386/conf/$HOSTNAME
fi

 cd /usr/src && make buildworld && make buildkernel KERNCONF=$HOSTNAME && make installkernel KERNCONF=$HOSTNAME && echo "COMPILED KERNEL AND INSTALLED WITH SUCCESS REBOOT NOW... (BUILDWORLD DONE TOO)"
  cat $REPO$CONFIGS_COMMON/manpath.config >> /etc/manpath.config
  $MAKEWHATIS &
  cat $REPO$CONFIGS_COMMON/make.conf |$SED 's/$VERSION/'${VERSION}'/g' > /tmp/ma.conf
  cat /tmp/ma.conf |$SED 's/$HOSTNAME/'${HOSTNAME}'/g' > /tmp/mak.conf
  cat /tmp/mak.conf |$SED 's/$CPU_TYPE/'${CPU_TYPE}'/g' > /tmp/make.conf
  cat /tmp/make.conf >> /etc/make.conf
  rm /tmp/ma*.conf
 cp $REPO$CONFIGS_COMMON/loader.conf /boot/
  cat $REPO$CONFIGS_COMMON/daily.local |$SED 's/$VERSION/'${VERSION}'/g' >> /etc/daily.local
  $ECHO .


  cp $REPO/tools/root* /usr/local/bin/
/etc/ssh/ssh_config
/etc/ssh/sshd_config
$HOME_BASE/$ADMIN/.ssh
$HOME_BASE/$USERS/.ssh/authorized_keys2
