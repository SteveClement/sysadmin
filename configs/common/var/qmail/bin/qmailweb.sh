/usr/local/bin/mrtg /usr/local/etc/qmail.mrtg.cfg
## Updating isoqlog.domains
ls ~vpopmail/domains/ |grep -v ".dir-control" > /usr/local/etc/isoqlog.domains
/usr/local/bin/isoqlog 1>/dev/null 2>/dev/null
