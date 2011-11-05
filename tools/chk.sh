echo Checking hadron connectivity on: `uname -n`
mount |grep hadron
echo ...
echo Checking if VIM install:
pkg_info vim* > /dev/null
if [ $? = 0 ]; then
echo VIM Installed
else
echo VIM NOT Installed, installling from ports:
##rootdo portinstall editors/vim
fi
##rootdo portupgrade vim
##rootdo cd / ; tar xfvpj /hadron/distfiles/syntax.tbz
if [ -d /home/steve/work ]; then  if [ -d /home/steve/work/kierbiischt-ion-sysadmin ]; then   echo "Repo there, cvs upping tools";   cd /home/steve/work/kierbiischt-ion-sysadmin;   cvs up -Pd;  else   echo "Repo NOT there, grabbin now";   cd /home/steve/work;   cvs co kierbiischt-ion-sysadmin/tools;  fi; else  echo "NO WORK DIR Buuuhuuhuh";  mkdir /home/steve/work;  echo "RESTART SCRIPT"; fi
