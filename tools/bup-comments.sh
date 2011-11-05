####### Comment file for bup.sh ######
## To-Do: More sanity checks (if's a.s.o)
## More flexible exclude syntax
## More switches

# Exporting all necessary variables that might change from platform to platform
export MYSQLSHOW="/usr/local/mysql/bin/mysqlshow"
export MYSQLDUMP="/usr/local/mysql/bin/mysqldump"
export CUT="/bin/cut"
export TAR="/bin/tar"
export GREP="/bin/grep"
export MV="/bin/mv"
export DU="/usr/bin/du"
export DATE="/bin/date"

#### Unix Cours :)))) 
# cut kann en string zerschneiden ann deems een dem cut seet wei een feld ann waat den seperator ass.
# grep ass einfach nemmen fiir no engem string ze sichen
# mv ass den unix equiv. zu move
# du ass disk usage domadder gesait een weivill spaicher en repertoire beleet
# date scheckt den datum ann zait zreck

export SERVER="spack"
export BUP_BASE="/home/bup"
export BUP_TYPE="sql"
export TMP="/tmp"
export REP_LOG="$TMP/report-bup.tmp"

#Excludes for the first backup process which in this case is MySQL db
export EXCLUDE1="REPLACE_ME"
export EXCLUDE2="BUT_DONT"
export EXCLUDE3="BLANK_ME"

# Some nice logging to know where stuff is
echo "Time before backup: `$DATE`" >> $REP_LOG
echo "" >> $REP_LOG
echo "Base Backup Directory: $BUP_BASE" >> $REP_LOG
echo "Temp Directory: $TMP" >> $REP_LOG
echo "Report Location: $REP_LOG" >> $REP_LOG
echo "" >> $REP_LOG
echo "Mysql Backup" >> $REP_LOG
echo "------------" >> $REP_LOG

# Moving the backups to the appropriate folders...
#mv /home/bup/sql/yesterday/* /home/bup/sql/archive
#mv /home/bup/sql/today/* /home/bup/sql/yesterday

 echo "Backing up databases:" >> $REP_LOG
 echo "---------------------" >> $REP_LOG
 echo "" >> $REP_LOG

for a in `$MYSQLSHOW |$CUT -f2 -d\| |$GREP -v "\-\-\-\-\-\-\-" |$GREP -v Databases |$GREP -v $EXCLUDE1 |$GREP -v $EXCLUDE2 |$GREP -v $EXCLUDE3`; do

 export CURR_FILE="$BUP_BASE/$BUP_TYPE/today/$a-$SERVER-`$DATE +%d%m%y`.sql"
#Dump of the current processed db
 $MYSQLDUMP -e -q -a $a > $CURR_FILE
 echo `$DU -h $CURR_FILE` >> $REP_LOG

 unset CURR_FILE

done
#unsetting the type of backup it was: sql
unset $BUP_TYPE

echo "" >> $REP_LOG

export BUP_TYPE="fs"
export BUP_DIRS="/var /home /etc /root"
export EXCLUDE1="/home/apache/logs"
export EXCLUDE2="/var/log"
export EXCLUDE3="/home/bup"
export EXCLUDE3="/home/bup"
export EXCLUDE3="/home/bup"


echo "$TYPE Backup" >> $REP_LOG
echo "---------" >> $REP_LOG
echo "" >> $REP_LOG
echo "Now Backing up: $BUP_DIRS BUT NO LOGS" >> $REP_LOG

for a in `echo $BUP_DIRS`; do
 
 export DIR=`echo $a |$CUT -f2 -d\/`
 export CURR_FILE="$BUP_BASE/$BUP_TYPE/$DIR/today/$DIR-$SERVER-`$DATE +%d%m%y`.tgz"

## mv $BUP_BASE/$BUP_TYPE/$DIR/today/* $BUP_BASE/$BUP_TYPE/$DIR/yesterday/
## mv $BUP_BASE/$BUP_TYPE/$DIR/yesterday/* $BUP_BASE/$BUP_TYPE/$DIR/archives/

#Main tar with excludes
 $TAR --exclude $EXCLUDE1 --exclude $EXCLUDE2 --exclude $EXCLUDE3 -c -p -z -f $CURR_FILE $a
 echo -n "ExitCode=$? )" >> $REP_LOG
 
 echo `$DU -h $CURR_FILE` >> $REP_LOG
 unset CURR_FILE
 unset DIR

done

echo "Size of excludes:" >> $REP_LOG
echo "`$DU -sh $EXCLUDE1`" >> $REP_LOG
echo "`$DU -sh $EXCLUDE2`" >> $REP_LOG
echo "`$DU -sh $EXCLUDE3`" >> $REP_LOG

##echo "$$$Error come ere Backup had erros please mail your systems administrator. <steve@ion.lu>" >> $REP_LOG
echo "(Sysadmin use: Exit Code=$? ProcessID=$$)" >> $REP_LOG
echo "Time after backup: `$DATE`" >> $REP_LOG

cat $REP_LOG | mail -s "[Spack Backup]" steve@ion.lu support@lxcom.lu

rm $REP_LOG


