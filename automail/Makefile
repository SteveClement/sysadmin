transfer: checkin transfer2

handoff:
	tar --exclude '.svn*' --exclude '*CVS*' --exclude '*~' --exclude '*/#*' --exclude '*/.*' -zcvf /tmp/automail.tgz perl conf templates

checkin:
	svn update
	@echo
	@echo "Did the update produce conflicts? If so kill me and fix them."
	@echo "Otherwise, hit return."
	@read x
	svn ci

transfer1: handoff
	scp /tmp/automail.tgz automail@scuzzy:.
	ssh -l automail scuzzy "cd automail; tar xvfz ../automail.tgz"

transfer2: handoff
	scp /tmp/automail.tgz linion.ion.lu:.
	ssh linion.ion.lu 'H=`pwd`; rootdo "cd ~automail/automail ; rm templates/*; tar xvfz $$H/automail.tgz ; chgrp -R vchkpw *"'

transfer_utils:
	scp get_mails.pl womble.aldigital.co.uk:
	ssh womble.aldigital.co.uk "scp get_mails.pl mailgate-fw.algroup.co.uk:"
	scp rerun.pl male.aldigital.co.uk:
