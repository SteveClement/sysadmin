#!/usr/local/bin/bash

export PW="/usr/sbin/pw"
export CD="/usr/bin/cd"
export CP="/bin/cp"
export RM="/bin/rm"
export MV="/bin/mv"
export MD="/bin/mkdir"
export BASH="/usr/local/bin/bash"
export CHOWN="/usr/sbin/chown"
export CHGRP="/usr/bin/chgrp"
export CHMOD="/bin/chmod"
export HOME_BASE="/home"
export USERS="jedi"
export ADMIN="steve"
export TMP="/tmp"
export CURL="/usr/local/bin/curl"
export ECHO="/bin/echo"
export WORK="work"
export NULL="/dev/null"

function adduser-ion()
{
 $PW useradd $1 -s $BASH -G wheel
 $MD -p -m 700 $HOME_BASE/$1/.ssh
 $MD -m 700 $HOME_BASE/$1/$WORK
 $CHOWN $1:$1 $HOME_BASE/$1/$WORK 
 $CHOWN $1:$1 $HOME_BASE/$1/.ssh
 $CHOWN $1:$1 $HOME_BASE/$1
 $CHMOD 700 $HOME_BASE/$1
 $CURL http://www.ion.lu/.ssh/authorized_keys2-$1 > $HOME_BASE/$1/.ssh/authorized_keys2
 $ECHO "Now would be a good time to log out and in again to finish install with:
"
 $ECHO "build.sh finish"
}

$CHMOD 1777 $TMP
$CHOWN root:wheel $TMP
adduser-ion jedi

 $PW usermod $ADMIN -s $BASH -G wheel
 $MD -p -m 700 $HOME_BASE/$ADMIN/.ssh
 $MD -m 700 $HOME_BASE/$ADMIN/$WORK
 $CHOWN $ADMIN:$ADMIN $HOME_BASE/$ADMIN/$WORK
 $CHOWN $ADMIN:$ADMIN $HOME_BASE/$ADMIN/.ssh
 $CHOWN $ADMIN:$ADMIN $HOME_BASE/$ADMIN
 $CHMOD 700 $HOME_BASE/$ADMIN
 $CURL http://www.ion.lu/.ssh/authorized_keys2-$ADMIN > $HOME_BASE/$ADMIN/.ssh/authorized_keys2
