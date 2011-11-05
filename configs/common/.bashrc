#!/bin/bash -x
##if [ -z "$PROMPT_COMMAND" ]; then . /etc/profile; fi
OS=`uname -s`
HOST=`uname -n`
MASTER_HOST="fucker.localhost.lu"
SYNC_HOST="terbium.localhost.lu"
SSHKEY_IS_LOADED_TMP=`/usr/bin/ssh-add -l ; echo "Return=$?"`
SSHKEY_IS_LOADED=`echo $SSHKEY_IS_LOADED_TMP |cut -f 2 -d=`
CRYPT_BASE="/crypt"

## Following check has been implemented to avoid deletion of identities and other non-master host stuff
if [ $HOST == $MASTER_HOST ]; then
ON_MASTER_HOST=1
else
ON_MASTER_HOST=0
fi

if [ $HOST == $SYNC_HOST ]; then
ON_SYNC_HOST=1
else
ON_SYNC_HOST=0
fi

## Skippey if on sync host...
if [ $ON_SYNC_HOST == 0 ]; then

	if [ $OS == "Linux" ]; then
		TERBIUM_UP=`ping -w1 terbium.localhost.lu >/dev/null; echo $?`
		CRYPTED_AREA=`ls -l ~/.ssh |awk {' print $11 '} |cut -f3 -d\/`
                SSH_ASKPASS="/usr/bin/gtk2-ssh-askpass"
	fi
	
	if [ $OS == "FreeBSD" ]; then
		TERBIUM_UP=`ping -c1 terbium.localhost.lu >/dev/null; echo $?`
		CRYPTED_AREA=`ls -l ~/.ssh |awk {' print $10 '} |cut -f3 -d\/`
                SSH_ASKPASS="/usr/X11R6/bin/ssh-askpass-gtk2"
	fi

		if [ -e !$SSH_ASKPASS ]; then SSH_ASKPASS=""; fi

if [ -d $CRYPT_BASE ]; then
	IS_LOADED=`ls /crypt |wc -l`
		if [ $IS_LOADED == 0 ]; then
		 	echo "Crypted FS NOT Loaded!!! Loading now"
		 	cd ~ && cattach crypt $CRYPTED_AREA ; while [ $? != 0 ]; do cattach crypt $CRYPTED_AREA; done && \
			if [ $SSHKEY_IS_LOADED != 0 ] && [ $SSHKEY_IS_LOADED != 2 ]; then 
				sleep 1; ls /crypt > /dev/null ; cd ~ && /usr/bin/ssh-add ~/.ssh/ssh2rsa-openssh.ppk < /dev/null; while [ $? != 0 ]; do sleep 1; /usr/bin/ssh-add ~/.ssh/ssh2rsa-openssh.ppk < /dev/null; done
			fi
		fi
		
		SSHKEY_IS_LOADED_TMP=`/usr/bin/ssh-add -l ; echo "Return=$?"`
		SSHKEY_IS_LOADED=`echo $SSHKEY_IS_LOADED_TMP |cut -f 2 -d=`

		if [ $SSHKEY_IS_LOADED != 0 ] && [ $SSHKEY_IS_LOADED != 2 ]; then 
			sleep 1; cd ~ && /usr/bin/ssh-add ~/.ssh/ssh2rsa-openssh.ppk < /dev/null; while [ $? != 0 ]; do sleep 1; /usr/bin/ssh-add ~/.ssh/ssh2rsa-openssh.ppk < /dev/null; done
		fi
fi


if [ $TERBIUM_UP = 0 ]; then
NEED_UPDATE=`rsync --password-file /home/steve/.sensitive/localhost-rsync-passwd -q terbium::steve/.localhost-rsync-update 2>/dev/null; echo $?`
	if [ $NEED_UPDATE == 0 ]; then
		echo "Rsync update NEEDED, files changed!!! Chances That /crypt changed HIGH!!!"
		echo "Therefor playing safe and login out afterwards, it's for your own good..."
		rsync --exclude-from /home/steve/.exclude --password-file /home/steve/.sensitive/localhost-rsync-passwd -azv --progress terbium::steve ~/ && rm -f ~/.localhost-rsync-update && rsync --exclude-from /home/steve/.exclude --password-file /home/steve/.sensitive/localhost-rsync-passwd --delete -azq ~/ terbium::steve && logout
	fi
fi


fi
