CODERS="nuno steves kwisatz"
REPO="/home/steve/work/plumbum-ion-sysadmin/trunk"

for LUSER in `echo $CODERS`; do
	pw useradd ${LUSER} -s /usr/local/bin/bash -G wheel && mkdir -p -m 700 /home/${LUSER}/.ssh && chown -R ${LUSER}:${LUSER} /home/${LUSER}/ && chmod -R 700 /home/${LUSER}/
	cp $REPO/ssh-pub-keys/${LUSER}.pub2 /home/${LUSER}/.ssh/authorized_keys2
	chmod 600  /home/${LUSER}/.ssh/authorized_keys2
	chown ${LUSER} /home/${LUSER}/.ssh/authorized_keys2
	cat /home/${LUSER}/.ssh/authorized_keys2 >> /root/.ssh/authorized_keys2
	chmod 600  /root/.ssh/authorized_keys2
done
