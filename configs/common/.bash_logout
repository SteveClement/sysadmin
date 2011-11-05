OS=`uname -s`
HOST=`uname -n`
MASTER_HOST="fucker.ion.lu"
SLAVE_HOST="vaion"
SYNC_HOST="terbium.ion.lu"
SSHKEY_IS_LOADED_TMP=`/usr/bin/ssh-add -l ; echo "Return=$?"`
SSHKEY_IS_LOADED=`echo $SSHKEY_IS_LOADED_TMP |cut -f 2 -d=`
CRYPT_BASE="/crypt"

## Following check has been implemented to avoid deletion of identities and other non-master host stuff
if [ $HOST == $MASTER_HOST ]; then
ON_MASTER_HOST=1
else
ON_MASTER_HOST=0
fi

if [ $HOST == $SLAVE_HOST ]; then
ON_SLAVE_HOST=1
else
ON_SLAVE_HOST=0
fi

if [ $HOST == $SYNC_HOST ]; then
ON_SYNC_HOST=1
else
ON_SYNC_HOST=0
fi

## Skippey if on sync host...
if [ $ON_SYNC_HOST == 0 ]; then


        if [ $OS == "Linux" ]; then
                TERBIUM_UP=`ping -w1 terbium.ion.lu >/dev/null; echo $?`
                CRYPTED_AREA=`ls -l ~/.ssh |awk {' print $11 '} |cut -f3 -d\/`
        fi
        if [ $OS == "FreeBSD" ]; then
                TERBIUM_UP=`ping -c1 terbium.ion.lu >/dev/null; echo $?`
                CRYPTED_AREA=`ls -l ~/.ssh |awk {' print $11 '} |cut -f3 -d\/`
        fi

if [ $ON_MASTER_HOST == 1 ] || [ $ON_SLAVE_HOST == 1 ]; then
ssh-add -D
fi

	cdetach $CRYPTED_AREA

if [ $TERBIUM_UP = 0 ]; then
	echo "Invoking rsync with --delete!!! so file will be delete on remote server if deleted locally..."
	echo "don't forget that you are on:"
	uname -n
	sleep 3
	rsync -n --exclude-from /home/steve/.exclude --delete -azv --progress ~/ terbium::steve && touch ~/.ion-rsync-update && rsync --password-file /home/steve/.sensitive/ion-rsync-passwd -q --exclude-from /home/steve/.exclude --delete -az ~/ terbium::steve || rm -f ~/.ion-rsync-update
	echo "Hope the above is ok, press the RETURN key"
	read
fi

fi
