if [ -z $1 ]; then
 #HOST="xenon belion zinc kierbiischt hadron snoopy dubnium linion spross.lxcdm.lu beekini.247.lu primetec.247.lu immofriedrich.247.lu jyrom.247.lu"
 HOST="kierbiischt zinc oberon belion linion snoopy"
else
 HOST=$1
fi

for a in $HOST; do
scp chk.sh $a: && ssh $a ./chk.sh
ssh $a "rootdo -t /home/steve/work/kierbiischt-ion-sysadmin/tools/basic_portupgrade.sh ; rm chk.sh"
done
