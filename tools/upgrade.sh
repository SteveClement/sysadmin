#!/bin/sh

if [ -z $1 ] || [ -z $2 ]; then
 echo "Usage: upgrade.sh 6_2 i386"

else

export VERSION=$1
export ARCH=$2

export HOSTNAME=`hostname -s |tr [a-z] [A-Z]`

echo "Do you want to do the basic portupgrade? (y/n)"
break
read PORTUPGRADE
if [ $PORTUPGRADE = "y" ]; then
 portupgrade -Rr ports-mgmt/portupgrade
 portupgrade shells/bash
 portupgrade editors/vim
fi


if [ -f /usr/src/sys/$ARCH/conf/$HOSTNAME ]; then
 echo "Kernel config present..."
else
 echo "NO KERNEL CONFIG COPYING DEFAULT..."
 cp /usr/src/sys/i386/conf/GENERIC /usr/src/sys/i386/conf/$HOSTNAME
fi

echo "Is your system up to date?"
ls -la /usr/src/UPDATING
echo "If the above file seems fairly recent e.g: this month or 3 weeks ago you are up to date..."
echo "Do you want to cvsup OR cvs up your system (if previously failed say y to resume pull)? y/n"
read CVS_UP

if [ $CVS_UP = "y" ]; then

 if [ -f /etc/cvsupfile-$VERSION ]; then
  echo "/etc/cvsupfile-$VERSION is present, launching cvsup /etc/cvsupfile-$VERSION"
  cvsup /etc/cvsupfile-$VERSION && export CVS_DONE=1
 else
  echo "cvs up'ing the src tree NOT it is SLOW and sucks USE cvsup instead"
  return 999
  cd /usr && mv src/ src-`date +%d%m%y` && cvs -z3 co -rRELENG_$VERSION src && export CVS_DONE=1
   fi
 fi
 

if [ -z $CVS_DONE ]; then
echo "Something went wrong your src tree isnt up to date yet..."
else
echo "Diffing your config file with the new GENERIC one..."
diff -u /usr/src/sys/i386/conf/GENERIC /usr/src/sys/i386/conf/$HOSTNAME > /tmp/diff_old_new.krn
echo "Compiling new kernel with config: $HOSTNAME"
echo "the diff of changes has been written to: /tmp/diff_old_new.krn"
cd /usr/src && make buildkernel KERNCONF=$HOSTNAME && make installkernel KERNCONF=$HOSTNAME && echo COMPILED AND INSTALLED WITH SUCCESS

echo "Do you want to up the ports tree? (y/n)"
read UP_PORTS
if [ $UP_PORTS = "y" ]; then
 cvsup /etc/cvsupfile
fi

fi


fi
