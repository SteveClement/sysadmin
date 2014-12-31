#!/usr/bin/env bash

for pkg in `cat new.txt`; do
	ls ${pkg} 2> /dev/null > /dev/null
	if [ $? = 0 ]; then
		echo "vi ${pkg}/options"
		echo "echo 'cat ${pkg}/options' >> server.txt"
	else
		old_pkg=`echo ${pkg} | cut -f2 -d_`
		ls ${old_pkg} 2> /dev/null > /dev/null
		if [ $? = 0 ]; then
			echo "echo 'cat ${pkg}/options' >> server.txt"
			echo "git mv ${old_pkg} ${pkg}"
			echo "vi ${pkg}/options"
		else
			echo "echo 'cat ${pkg}/options' >> server.txt"
			echo "echo -n ${pkg} >> build.sh"
			echo "mkdir ${pkg}"
			echo "vi ${pkg}/options"
		fi
	fi
done