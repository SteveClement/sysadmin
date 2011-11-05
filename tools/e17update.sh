#!/bin/sh
Ebuilds="eet dev-db/edb evas ecore embryo imlib2 edje e etk epeg \
media-libs/epsilon esmart entrance emotion eclair ewl engrave \
e_utils e_modules etox erss entice engage evidence exhibit"
if [ "$1" == "debug" ]; then
      DEBUG="USE=\"$USE debug\" FEATURES=\"$FEATURES nostrip\""
fi
set $Ebuilds
while [ $# != 0 ]; do
      while !($DEBUG emerge $1); do
              echo ""
              echo "emerge $1 failed! Trying again in 10 seconds..."
              echo "still "$#" packages left..."
              echo ""
              sleep 10
      done
      shift
done
echo ""
echo "All done!"
exit 0
