#!/bin/sh

# This will build a PC server system on FreeBSD 10.3 with all the necessary Hackery Funk

# cd /usr/src && svn up -Pd OR cvsup /etc/cvsupfile-10_3 OR freebsd-update fetch install
# script /var/tmp/mw.out
# chflags -R noschg /usr/obj/*
# rm -rf /usr/obj
# cd /usr/src
# make buildworld
# make buildkernel
# make installkernel
# reboot -s
# cd /usr/src
# mergemaster -p
# make installworld
# mergemaster -iF
# make delete-old
# reboot
# make delete-old-libs

export ARCHI="i386"
export CONFIGS_COMMON="/configs/common"
export PORTS_OPTIONS="/var/db/ports"
export PORTSNAP="/usr/sbin/portsnap"
export HOSTNAME=`hostname -s |tr [a-z] [A-Z]`
export PWW="/usr/sbin/pw"
export FETCH="/usr/bin/fetch"
export DISTFILES_LOC="/usr/ports/distfiles"
export CPY="/bin/cp"
export RMM="/bin/rm"
#export MVV="/bin/mv"
export MDD="/bin/mkdir"
export CUT="/usr/bin/cut"
export SED="/usr/bin/sed"
export PING="/sbin/ping"
export BASH="/usr/local/bin/bash"
export SCP="/usr/bin/scp"
export CHOWN="/usr/sbin/chown"
export CHGRP="/usr/bin/chgrp"
export CHMOD="/bin/chmod"
export HOME_BASE="/home"
#export USERS=""
export TMP="/tmp"
export WGET="/usr/local/bin/wget"
export CURL="/usr/local/bin/curl"
export MAKEWHATIS="/usr/bin/makewhatis"
export PORTS_DIR="/usr/ports"
export PORTUPGRADE="/usr/local/sbin/portupgrade"
export PORTINSTALL="/usr/local/sbin/portinstall"
export MAKER="/usr/bin/make"
export ECHO="/bin/echo"
export TOUCH="/usr/bin/touch"
export WORK="work"
export SLEEP="/bin/sleep"
export NULL_DEV="/dev/null"
export CPU_TYPE=`dmesg |grep CPU: |head -1 |sed 's/(R)//g' |sed 's/CPU: Intel //g' |awk  '{print $1$2 }' |sed 's/P/p/g' |sed 's/III/3/g'`
export PORTS="sysutils/munin-node \
              sysutils/cmdwatch \
              sysutils/tmux \
              sysutils/daemontools \
              sysutils/ucspi-tcp \
              editors/vim \
              ftp/curl \
              ftp/wget \
              www/lynx \
              mail/qmail \
              converters/unix2dos \
              archivers/unzip \
              net/rsync \
              security/nmap \
              security/gnupg \
              shells/bash-completion \
              shells/zsh \
              shells/zsh-navigation-tools \
              devel/subversion"
export PORTS_MAIL="mail/mutt \
                   mail/qmHandle \
                   mail/qmailanalog \
                   mail/isoqlog \
                   mail/qmqtool \
                   sysutils/qlogtools"
export PORTS_CLISERVER="security/openvpn"
export PORTS_OPTS="mail/queue-repair mail/qmailmrtg7"
export JAIL_CHECK=`/sbin/md5 /etc/fstab | cut -f 4 -d\ `
export FSTAB_SUM="2cfe202ba5d7cdad78af2bf76b340c6d"
export VER=`uname -r |cut -f 1 -d- |sed 's/\./_/'`
  touch $TMP/$VER

if [ -z $ADMIN ]; then
  echo "Please enter YOUR username"
  read ADMIN
fi

if [ -z $SYSADMIN ]; then
  echo "Please enter a Sysadmin username"
  read SYSADMIN
fi

export REPO="/home/${ADMIN}/sysadmin"

if [ $JAIL_CHECK != $FSTAB_SUM ]; then
  export JAIL=false

  if [ -f /usr/ports/.portsnap.INDEX ]; then
    $PORTSNAP fetch update
   else
    $PORTSNAP fetch extract
  fi
fi

VER=`ls ${TMP}/*_* 2> /dev/null` ; export VERSION=`${ECHO} ${VER} | ${CUT} -f3 -d\/`

if [ -f ${TMP}/${VERSION} ]
 then
  echo "Using version $VERSION"
 else
  echo "What FreeBSD Version are you Installing? 9_1 or Higher TYPE IT NOW:"
  read VERSION
  touch ${TMP}/${VERSION}
fi

for PORT in `echo devel_ruby \
                  databases_ruby22-bdb \
                  sysutils_daemontools \
                  sysutils_tmux \
                  devel_libevent2 \
                  mail_qmail \
                  sysutils_ucspi-tcp \
                  archivers_unzip \
                  net_rsync \
                  editors_vim \
                  lang_tcl86 \
                  devel_cscope \
                  ftp_wget \
                  security_nmap \
                  devel_pcre \
                  security_gnupg \
                  security_gnutls \
                  security_nettle \
                  math_gmp \
                  security_trousers \
                  devel_cmake \
                  devel_py-Jinja2 \
                  textproc_py-docutils \
                  textproc_py-snowballstemmer \
                  archivers_libarchive \
                  archivers_lzo2 \
                  security_pinentry \
                  security_pinentry-curses \
                  sysutils_munin-node \
                  net_p5-Net-Server \
                  www_p5-libwww \
                  databases_p5-DBI \
                  databases_postgresql93-client \
                  dns_p5-Net-DNS \
                  shells_zsh`; do
  mkdir -p ${PORTS_OPTIONS}/${PORT}
  cp ${REPO}${CONFIGS_COMMON}${PORTS_OPTIONS}/${PORT}/options ${PORTS_OPTIONS}/${PORT}
done

cd $DISTFILES_LOC
$FETCH http://www.localhost.lu/software/analog-6.0.tar.gz > $NULL_DEV

if [ $? = 0 ]
 then
  $ECHO "Internet Detected :=)"
 else
  $ECHO "No NeT!!! Breaking in 3"
  $SLEEP 3
  break
fi


if [ -f /usr/local/bin/zip ]
 then

  $ECHO "We have the zip package and can proceed with the final steps..."
  $SLEEP 3

   if [ $1 = "finish" ]
  then

  $ECHO "Installing Ports: $PORTS"
  $ECHO .
  $PORTINSTALL $PORTS
  /var/qmail/scripts/enable-qmail
  /usr/local/sbin/munin-node-configure --shell | sh -x

  cd /etc/

    /etc/rc.d/ntpd stop ; /usr/sbin/ntpdate chronos.cru.fr ; /etc/rc.d/ntpd start
    cat $REPO$CONFIGS_COMMON/rc.conf >> rc.conf

  mv profile profile-`date +%d%m%y`
  cp $REPO$CONFIGS_COMMON/profile .

  cp $REPO$CONFIGS_COMMON/sshd_localhost /etc/rc.d/
  ln -s /usr/sbin/sshd /usr/sbin/sshd_localhost

  cp -p $REPO$CONFIGS_COMMON/pf.conf pf.conf

  ##cp $REPO$CONFIGS_COMMON/vimrc /usr/local/share/vim/
  mv /usr/bin/vi /usr/bin/vi-`date +%d%m%y`
  ln -s /usr/local/bin/vim /usr/bin/vi

  echo "Configuring QMAIL FORWARD ONLY!!!"
  mkdir -p /var/log/qmail/qmail-send
  chown -R qmaill:wheel /var/log/qmail
  chmod -R 750 /var/log/qmail

  mkdir -p /var/qmail/supervise/qmail-send/log
  mkdir /var/service
  chmod +t /var/qmail/supervise/qmail-send
  cp $REPO$CONFIGS_COMMON/var/qmail/alias/.qmail* /var/qmail/alias/
  cp -i $REPO$CONFIGS_COMMON/var/qmail/control/* /var/qmail/control/
  hostname > /var/qmail/control/me
  hostname > /var/qmail/control/rcpthosts
  hostname |cut -f 2- -d. >> /var/qmail/control/rcpthosts
  hostname |cut -f 2- -d. > /var/qmail/control/defaultdomain
  hostname |cut -f 2- -d. > /var/qmail/control/plusdomain
  hostname -s > /var/qmail/control/defaulthost
  ### UPDATE qmail rc
  cp -i $REPO$CONFIGS_COMMON/var/qmail/rc /var/qmail/
  cp -i $REPO$CONFIGS_COMMON/var/qmail/supervise/qmail-send/run /var/qmail/supervise/qmail-send
  cp -i $REPO$CONFIGS_COMMON/var/qmail/supervise/qmail-send/log/run /var/qmail/supervise/qmail-send/log
  cp -i $REPO$CONFIGS_COMMON/var/qmail/bin/qmailctl /var/qmail/bin
  ln -s /var/qmail/alias/.qmail-root /var/qmail/alias/.qmail-anonymous
  chmod 644 /var/qmail/alias/.qmail*
  chmod 755 /var/qmail/rc
  chmod 751 /var/qmail/supervise/qmail-send/run /var/qmail/supervise/qmail-send/log/run
  ln -s /var/qmail/bin/qmailctl /usr/bin
  ln -s /var/qmail/supervise/qmail-send /var/service
  echo "Cat'ting /var/qmail/control/ files sleeping 15"
  cat /var/qmail/control/*
  sleep 15

  svn co svn://svn.freebsd.org/base/releng/10.3 /usr/src
  # htop pulls in lsof, which needs a source tree
  $PORTINSTALL sysutils/htop

if [ "$JAIL" = "false" ]; then
  echo "Compiling NEW Kernel..."


if [ -f /usr/src/sys/$ARCHI/conf/$HOSTNAME ]; then
 echo "Kernel config present..."
else
 echo "NO KERNEL CONFIG COPYING DEFAULT..."
 cp /usr/src/sys/$ARCHI/conf/GENERIC /usr/src/sys/$ARCHI/conf/$HOSTNAME
fi

ls -la /usr/src/UPDATING
echo ""
echo "If the above file seems fairly recent e.g: this month or 3 weeks ago you are up to date..."
echo "Otherwise update you system with cvsup"
sleep 5

 echo "Compiling new kernel with config: $HOSTNAME"
 /usr/sbin/freebsd-update fetch install
 cd /usr/src && make kernel KERNCONF=$HOSTNAME && echo "COMPILED KERNEL AND INSTALLED WITH SUCCESS REBOOT NOW"
fi

##function adduser-ion()
##{
## $PWW useradd $2 -s $BASH -G wheel
## $MDD -p -m 700 $HOME_BASE/$1/.ssh
## $MDD -m 700 $HOME_BASE/$1/$WORK
## $CHOWN $1:$1 $HOME_BASE/$1/$WORK
## $CHOWN $1:$1 $HOME_BASE/$1/.ssh
## $CHOWN $1:$1 $HOME_BASE/$1
## $CHMOD 700 $HOME_BASE/$1
## cp /home/$ADMIN/work/kierbiischt-ion-sysadmin/ssh-pub-keys/$1.pub2 $HOME_BASE/$1/.ssh/authorized_keys
## $ECHO "Now would be a good time to log out and in again to finish install with:"
## $ECHO "build.sh finish"
##}

##for a in `echo $USERS` ;do
##   adduser-ion $a
##done

else
	$ECHO "Argument Missing for final: finish"
  fi

else

$ECHO "there is no zip package, argh fighting with sh and getting system up-to-date"
$TOUCH $TMP/initial
$SLEEP 3


if [ -f $TMP/initial ]
 then
  $ECHO "Initial Install, due to bash lackage $TMP/initial has been touched"
  cat $REPO$CONFIGS_COMMON/manpath.config >> /etc/manpath.config
  $MAKEWHATIS &


  ## Make.conf needs to be Jail adapted
  ## make.conf Generator, this can't generate Xenon spec. stuff (nocona)
  cat $REPO$CONFIGS_COMMON/make.conf |$SED 's/$VERSION/'${VERSION}'/g' > /tmp/ma.conf
  cat /tmp/ma.conf |$SED 's/$HOSTNAME/'${HOSTNAME}'/g' > /tmp/mak.conf
  cat /tmp/mak.conf |$SED 's/$CPU_TYPE/'${CPU_TYPE}'/g' > /tmp/make.conf
  cat /tmp/make.conf >> /etc/make.conf
  rm /tmp/ma*.conf
  echo "Please revise make.conf take care about CPUType VAR"
  sleep 5
  vi /etc/make.conf
  cp $REPO$CONFIGS_COMMON/src.conf /etc/

## jail salveage

if [ "$JAIL" = "false" ]; then
  cp $REPO$CONFIGS_COMMON/loader.conf /boot/
  cat $REPO$CONFIGS_COMMON/daily.local |$SED 's/$VERSION/'${VERSION}'/g' >> /etc/daily.local
  else
  cat $REPO$CONFIGS_COMMON/daily.local_Jail |$SED 's/$VERSION/'${VERSION}'/g' >> /etc/daily.local
fi

  $ECHO .
  cat /etc/daily.local
  $ECHO "All clear? ctrl-z to amend, 5 sec's time"
  $ECHO .
  $SLEEP 5
  cp $REPO/tools/root* /usr/local/bin/
  chmod 050 /usr/local/bin/root*

## ssh_config tweak
 $SED 's/#   ForwardAgent no/ForwardAgent yes/g' /etc/ssh/ssh_config > $TMP/ssh_config
 $CPY $TMP/ssh_config /etc/ssh
## $SED 's/#   ForwardX11 no/ForwardX11 yes/g' /etc/ssh/ssh_config > $TMP/ssh_config
## $CPY $TMP/ssh_config /etc/ssh
 $RMM $TMP/ssh_config

# sshd_config tweak no passwords allowed ere
 $SED 's/#PassworAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config > $TMP/sshd_config
 $CPY $TMP/sshd_config /etc/ssh
 $RMM $TMP/sshd_config

# sshd_config tweak to disable ChallengeResponse which disables PAM auth
 $SED 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config > $TMP/sshd_config
 $CPY $TMP/sshd_config /etc/ssh
 $RMM $TMP/sshd_config

# sshd_config.localhost builder
 $SED 's/#Port 22/Port 222/g' /etc/ssh/sshd_config > $TMP/sshd_config.localhost
 $CPY $TMP/sshd_config.localhost /etc/ssh
 $RMM $TMP/sshd_config.localhost
 $SED 's/#ListenAddress 0.0.0.0/ListenAddress 127.0.0.1/g' /etc/ssh/sshd_config.localhost > $TMP/sshd_config.localhost
 $CPY $TMP/sshd_config.localhost /etc/ssh
 $RMM $TMP/sshd_config.localhost
 $SED 's/#PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config.localhost > $TMP/sshd_config.localhost
 $CPY $TMP/sshd_config.localhost /etc/ssh
 $RMM $TMP/sshd_config.localhost
 $ECHO "PidFile /var/run/sshd_localhost.pid" >> /etc/ssh/sshd_config.localhost


 $MDD -p -m 700 $HOME_BASE/$ADMIN/.ssh
 $MDD -p -m 700 /root/.ssh
 ##$MDD -m 700 $HOME_BASE/$ADMIN/$WORK
 ##$CHOWN $ADMIN:$ADMIN $HOME_BASE/$ADMIN/$WORK
 $CHOWN $ADMIN:$ADMIN $HOME_BASE/$ADMIN/.ssh
 $CHOWN $ADMIN:$ADMIN $HOME_BASE/$ADMIN
 $CHMOD 700 $HOME_BASE/$ADMIN

 cp ${REPO}/ssh-pub-keys/${ADMIN}.pub2 ${HOME_BASE}/${ADMIN}/.ssh/authorized_keys
 chmod 600 ${HOME_BASE}/${ADMIN}/.ssh/authorized_keys && chown ${ADMIN} ${HOME_BASE}/${ADMIN}/.ssh/authorized_keys
 cp ${REPO}/ssh-pub-keys/${ADMIN}.pub2 /root/.ssh/authorized_keys
## cat ${REPO}/ssh-pub-keys/${USERS}.pub2 >> /root/.ssh/authorized_keys
## cat ${REPO}/ssh-pub-keys/${SYSADMIN}.pub2 >> /root/.ssh/authorized_keys
 chmod 600 ${HOME_BASE}/${ADMIN}/.ssh/authorized_keys && chown $ADMIN ${HOME_BASE}/${ADMIN}/.ssh/authorized_keys

 cd /usr/ports/ports-mgmt/portupgrade && make clean install clean

 # $PORTINSTALL shells/bash && \
 $PORTINSTALL archivers/zip
   ##$PWW useradd $USERS -s $BASH -G wheel && mkdir -p -m 700 /home/${USERS}/.ssh && chown -R ${USERS}:${USERS} /home/${USERS}/ && chmod -R 700 /home/${USERS}/ && \
   $PWW usermod root -s $BASH && $PWW usermod $ADMIN -s $BASH
   ##$PWW useradd $SYSADMIN -s $BASH -G wheel && mkdir -p -m 700 /home/${SYSADMIN}/.ssh && chown -R ${SYSADMIN}:${SYSADMIN} /home/${SYSADMIN}/ && chmod -R 700 /home/${SYSADMIN}/

 ##cp $REPO/ssh-pub-keys/$USERS.pub2 $HOME_BASE/$USERS/.ssh/authorized_keys
 ##cp $REPO/ssh-pub-keys/${SYSADMIN}.pub2 $HOME_BASE/${SYSADMIN}/.ssh/authorized_keys
 ##chmod 600 $HOME_BASE/$USERS/.ssh/authorized_keys && chown $USERS $HOME_BASE/$USERS/.ssh/authorized_keys
 ##chown ${SYSADMIN} $HOME_BASE/${SYSADMIN}/.ssh/authorized_keys

  $PORTUPGRADE -Rra


 $RMM $TMP/initial

  fi

fi
