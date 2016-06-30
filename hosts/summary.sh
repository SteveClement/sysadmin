echo This creates a printable summary for our hosts
echo 
printf Hostname\\t\\tFQDN\\t\\t\\tIP\\n

EXCLUDES0="skelleton.example.com"
EXCLUDES1="summary.sh"
EXCLUDES2="home"
for fqdn in `ls |grep [.*]\.|grep -v $EXCLUDES0 |grep -v $EXCLUDES1 |grep -v $EXCLUDES2` ; do
HOST=`echo $fqdn |cut -f1 -d.`
HOSTCHAR=`echo $HOST |wc -m`
IP=`dig $fqdn |grep -1 "ANSWER SECTION" |grep $fqdn|cut -f2 -dA`
REVERSE=`dig -x $IP |grep PTR |grep -v \; |awk {'print $1'}`


if [ $HOSTCHAR -gt 9 ]; then
 printf $HOST\\t\\t
 printf $IP\\t\\t
 printf $fqdn\\t
else
 printf $HOST\\t\\t\\t
 printf $IP\\t\\t
 printf $fqdn\\t\\t
fi
if [ -z $REVERSE ]; then
 printf "Reverse lookup failed"
else
 printf "Reverse lookup OK"
fi
printf \\n
done

