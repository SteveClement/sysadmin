clear

### Nasty stupid fucking hack:
##  counting this string: "===>" in the kern build output.
##  Very approximate guess.

##>>> stage 1: configuring the kernel 0
##>>> stage 2.1: cleaning up the object tree 1
##>>> stage 2.2: rebuilding the object tree 417
##>>> stage 2.3: build tools 811
##>>> stage 3.1: making dependencies 1216
##>>> stage 3.2: building everything 1629

if [ -z $1 ] || [ -e /tmp/kern.progress ]; then
echo "Eeeeek no file specified"
exit
fi

ARCH=`uname -m`
SLOWDOWNS=1216_1224
TOTAL_i386=1629
TOTAL_FLUX_i386=1621

TOTAL_amd64=1097

while [ true ]; do 
echo -n "Metering FreeBSD Kernel Build: "
CURRENT=`grep ===\> $1 |wc -l`
echo "$CURRENT/$TOTAL_{$ARCH}"
CURRENT_STAGE=`grep stage $1`
echo "$CURRENT_STAGE ----> $CURRENT" >> /tmp/stages.log
tail /tmp/stages.log |grep -- ---
sleep 3
clear
done
echo "Cleaning up...."
rm -f /tmp/stages.log
