#!/bin/bash

# Fetch-only update script <- will download automagically updated pkg's
## 0 2 * * * /bin/bash /root/bin/up2date.sh >/dev/null 2>&1

export opts="-auv"
export email="steve@ion.lu"
export log="/tmp/emerge_sync-daily.log"
export err="/tmp/emerge_sync-daily.err"
export subject="`hostname` emerge world report"
export emerge="/usr/bin/emerge"

$emerge sync
$emerge -u portage
$emerge ${opts} --pretend world >${log} 2>${err}
[ ${email} ] && cat ${log} ${err} \
| mail -s ${subject} ${email} && $emerge ${opts} --fetchonly world \
##| mail -s ${subject} ${email} && $emerge ${opts} --fetchonly world && $emerge ${opts} world \
|| tail /var/log/emerge.log \
| mail -s "`hostname` emerge world err"
