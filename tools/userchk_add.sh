LUSER=$1
id $LUSER > /dev/null ; RETURN=`echo $?`

cd && mkdir -p work && cd work && cd /home/steve/work/plumbum-ion-sysadmin/trunk/ssh-pub-keys && svn up && echo "Uptodate" || svn co svn+ssh://plumbum.ion.lu/home/svn/plumbum-ion-sysadmin

if [ ${RETURN} == 0 ]; then
  echo "${LUSER} exists"
else
  echo "pw useradd $LUSER -s /usr/local/bin/bash -G wheel &&  mkdir -p -m 700 /home/claudio/.ssh && chown -R claudio:claudio /home/claudio/ && chmod -R 700 /home/claudio/ && cp /home/steve/work/plumbum-ion-sysadmin/trunk/ssh-pub-keys/claudio.pub2 /home/claudio/.ssh/authorized_keys2 && chmod 600 /home/claudio/.ssh/authorized_keys2 && chown claudio:claudio /home/claudio/.ssh/authorized_keys2 && cat /home/claudio/.ssh/authorized_keys2 >> /root/.ssh/authorized_keys2" > /tmp/addhim.sh

rootdo "sh /tmp/addhim.sh"
rm /tmp/addhim.sh

fi
