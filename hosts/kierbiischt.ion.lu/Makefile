cvs:
	cvs update -Pd
	@echo
	@echo "Any conflicts? any non checked in stuff?"
	@echo "If so FIX IT NOW!!!"
	@echo "If not continue with either RTeturn Key"
	@read x

handoff:
	tar --exclude '*CVS*' -zcvf /tmp/dns-update-primary.tgz chroot/

transfer: checkin transfer2

transfer1: handoff
	scp /tmp/dns-update-primary.tgz kierbiischt.ion.lu:/tmp/
	ssh kierbiischt.ion.lu "rootdo tar cfvpz /tmp/chroot.tgz /chroot/ ;echo don"

transfer2: handoff
        scp /tmp/automail.tgz male.aldigital.co.uk:.
#       ssh male.aldigital.co.uk "cd ~automail/automail; rm templates/*; tar xvfz ~/automail.tgz"
        ssh male.aldigital.co.uk 'H=`pwd`; rootdo -1 "cd ~automail/automail ; rm templates/*; tar xvfz $$H/automail.tgz ; chgrp -R automail *"'

transfer_utils:
        scp get_mails.pl womble.aldigital.co.uk:
        ssh womble.aldigital.co.uk "scp get_mails.pl mailgate-fw.algroup.co.uk:"
        scp rerun.pl male.aldigital.co.uk:
