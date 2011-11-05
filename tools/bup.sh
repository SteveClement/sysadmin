### Client Config Starts here, tweak whatever.

export BUP_AGE="-atime +5" # Means: File was last accessed n*24 hours ago. Where n=5

#### Variable BUP_AGE can be one of the following too:
##export BUP_AGE="-cmin n" # File's status was last changed n minutes ago.
##export BUP_AGE="-ctime n" # File's status was __last changed__ n*24 hours ago.
##export BUP_AGE="-empty"  #File is empty and is either a regular file or a directory.


### Client Config Stops here, whatever is done past here is on your own risk.
export MYSQLSHOW="/usr/bin/mysqlshow"
export MYSQLDUMP="/usr/bin/mysqldump"
export CUT="/bin/cut"
export TAR="/bin/tar"
export GREP="/bin/grep"
export MV="/bin/mv"
export DU="/usr/bin/du"
export CP="/bin/cp"
export DATE="/bin/date"
export FIND="/usr/bin/find"
export SERVER="spack"
export BUP_BASE="/home/bup"
export TMP="/tmp"
export REP_LOG="$TMP/report-bup.tmp"
export EXCLUDE1="REPLACE_ME"
export EXCLUDE2="BUT_DONT"
export EXCLUDE3="BLANK_ME"
export SPLIT="/usr/sbin/split"
export REMY_MOUNT=`mount |grep backup_spack |awk '{ print $3 }'`

echo "Time before backup: `$DATE`" >> $REP_LOG
echo "" >> $REP_LOG
echo "Base Backup Directory: $BUP_BASE" >> $REP_LOG
echo "Temp Directory: $TMP" >> $REP_LOG
echo "Report Location: $REP_LOG" >> $REP_LOG
echo "" >> $REP_LOG
echo "Mysql Backup" >> $REP_LOG
echo "------------" >> $REP_LOG

if [ $REMY_MOUNT == "" ]; then
echo "REMY NOT MOUNTED MOUNTING NOW!!!"
mount -t smbfs -o username=spack,password=backup23 //192.168.254.12/backup_spack /remy/backup_spack
export REMY_MOUNT=`mount |grep backup_spack |awk '{ print $3 }'`
else
echo "Remy IS mounted"
fi

export BUP_TYPE="sql"

mv $BUP_BASE/$BUP_TYPE/yesterday/* $BUP_BASE/$BUP_TYPE/archive
mv $BUP_BASE/$BUP_TYPE/today/* $BUP_BASE/$BUP_TYPE/yesterday

 echo "Backing up databases:" >> $REP_LOG
 echo "---------------------" >> $REP_LOG
 echo "" >> $REP_LOG

for a in `$MYSQLSHOW |$CUT -f2 -d\| |$GREP -v "\-\-\-\-\-\-\-" |$GREP -v Databases |$GREP -v $EXCLUDE1 |$GREP -v $EXCLUDE2 |$GREP -v $EXCLUDE3`; do

 export CURR_FILE="$BUP_BASE/$BUP_TYPE/today/$a-$SERVER-`$DATE +%d%m%y`.sql"
 $MYSQLDUMP -e -q -a $a > $CURR_FILE
 echo `$DU -h $CURR_FILE` >> $REP_LOG
 echo "Copying $CURR_FILE to $REMY_MOUNT" >> $REP_LOG
 $CP $CURR_FILE $REMY_MOUNT
 unset CURR_FILE

done
unset $BUP_TYPE

echo "" >> $REP_LOG

export BUP_TYPE="fs"
export BUP_DIRS="/var /home /etc /root"
export EXCLUDE1="/home/apache/logs"
export EXCLUDE2="/var/log"
export EXCLUDE3="/home/bup"
export EXCLUDE4="/home/software"
export EXCLUDE5="/home/apache/hosts/docs.lxcom.lu"


echo "$TYPE Backup" >> $REP_LOG
echo "---------" >> $REP_LOG
echo "" >> $REP_LOG
echo "Now Backing up: $BUP_DIRS BUT NO LOGS" >> $REP_LOG

for a in `echo $BUP_DIRS`; do
 
 export DIR=`echo $a |$CUT -f2 -d\/`
 export CURR_FILE="$BUP_BASE/$BUP_TYPE/$DIR/today/$DIR-$SERVER-`$DATE +%d%m%y`.tgz"

mv $BUP_BASE/$BUP_TYPE/$DIR/today/* $BUP_BASE/$BUP_TYPE/$DIR/yesterday/
mv $BUP_BASE/$BUP_TYPE/$DIR/yesterday/* $BUP_BASE/$BUP_TYPE/$DIR/archives/

 $TAR --exclude /var/spool/ttysnoop/ttyp0 --exclude /var/lib/mysql/mysql.sock --exclude /var/imap/socket/lmtp --exclude /home/apache/gcache/spack.lxcom.lu.socket --exclude $EXCLUDE1 --exclude $EXCLUDE2 --exclude $EXCLUDE3 --exclude $EXCLUDE4 --exclude $EXCLUDE5 -c -p -z -f $CURR_FILE $a
 echo -n "ExitCode=$? )" >> $REP_LOG
 
 echo `$DU -h $CURR_FILE` >> $REP_LOG
 echo "Copying $CURR_FILE to $REMY_MOUNT" >> $REP_LOG
 $CP $CURR_FILE $REMY_MOUNT
 unset CURR_FILE
 unset DIR

done

echo "Size of excludes:" >> $REP_LOG
echo "`$DU -sh $EXCLUDE1`" >> $REP_LOG
echo "`$DU -sh $EXCLUDE2`" >> $REP_LOG
echo "`$DU -sh $EXCLUDE3`" >> $REP_LOG
echo "`$DU -sh $EXCLUDE4`" >> $REP_LOG
echo "`$DU -sh $EXCLUDE5`" >> $REP_LOG
##echo "`$DU -sh $EXCLUDE5`" >> $REP_LOG

##echo "$$$Error come ere Backup had erros please mail your systems administrator. <steve@ion.lu>" >> $REP_LOG

echo "Deleting Backups old than 5Days: " >> $REP_LOG
cd /home/bup
$FIND . $BUP_AGE -type f -exec rm -v {} \; >> $REP_LOG
echo "" >> $REP_LOG

echo "(Sysadmin use: Exit Code=$? ProcessID=$$)" >> $REP_LOG
echo "Time after backup: `$DATE`" >> $REP_LOG

cat $REP_LOG | mail -s "[Spack Backup]" steve@ion.lu support@lxcom.lu

rm $REP_LOG
