PEEPS="steve jedi claudio nuno steves kwisatz"
REPO="/home/steve/work/plumbum-ion-sysadmin/trunk"

mkdir -p 700 /root/.ssh

for LUSER in `echo $PEEPS`; do
	mkdir -p -m 700 /home/${LUSER}/.ssh && chown -R ${LUSER}:${LUSER} /home/${LUSER}/ && chmod -R 700 /home/${LUSER}/
	cp $REPO/ssh-pub-keys/${LUSER}.pub2 /home/${LUSER}/.ssh/authorized_keys
	chmod 600  /home/${LUSER}/.ssh/authorized_keys
	chown ${LUSER} /home/${LUSER}/.ssh/authorized_keys
	cat /home/${LUSER}/.ssh/authorized_keys >> /root/.ssh/authorized_keys
	chmod 600  /root/.ssh/authorized_keys
done
