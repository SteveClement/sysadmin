#!/usr/bin/env bash

for pkg in `cat new.txt`; do
	ls ${pkg} 2> /dev/null > /dev/null
	if [ $? = 0 ]; then
		echo "vi ${pkg}/options"
		echo "echo 'clear ; cat ${pkg}/options ; read' >> server.sh"
	else
		old_pkg=`echo ${pkg} | cut -f2 -d_`
		ls ${old_pkg} 2> /dev/null > /dev/null
		if [ $? = 0 ]; then
			echo "echo 'clear ; cat ${pkg}/options ; read' >> server.sh"
			echo "git mv ${old_pkg} ${pkg}"
			echo "vi ${pkg}/options"
		else
			echo "echo 'clear ; cat ${pkg}/options ; read' >> server.sh"
			echo "echo -n '${pkg} ' >> build.sh"
			echo "mkdir ${pkg}"
			echo "vi ${pkg}/options"
		fi
	fi
done