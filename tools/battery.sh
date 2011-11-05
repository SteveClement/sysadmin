#!/usr/local/bin/bash

# Setting the variables via sysctl
batt_level=`sysctl hw.acpi.battery.time |cut -f 2 -d:`
batt_state=`sysctl hw.acpi.battery.state |cut -f 2 -d:`

# If Laptop is hook to mains, do nothing, else tell the user how much Battery Time is left.
if [ "${batt_state}" -eq "1" ]; then
        echo "Battery time remaining:`sysctl hw.acpi.battery.time |cut -f 2 -d:` minutes" |osd_cat -p middle -A right -o 1 -c red -f lucidasanstypewriter-24 -d 7

# If we run out of battery, make some noise (audible/and Visual)
if [ "${batt_level}" -lt "10" ]; then
 offset=$[${offset}+1]
 for color in `echo "white yellow red black red"`; do
        mplayer -msglevel all=-1 -really-quiet -quiet /tmp/batterie-critical1.ogg > /dev/null
        echo "Battery time remaining:`sysctl hw.acpi.battery.time |cut -f 2 -d:` minutes" |osd_cat -p middle -A left -o ${offset} -c white -f lucidasanstypewriter-24 -d 1
 done
fi

fi
