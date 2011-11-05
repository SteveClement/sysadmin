#!/usr/local/bin/bash

cd ~apache/logs
export sites=`ls |grep -v .sh|grep -v .log |grep -v mirrors |grep -v old`

function pack_error_logs {
for a in $sites; do
	cd $a/www
	export needed=`/usr/local/sbin/nedlogerr.sh`
	if [ -z "$needed" ]
	then
	  echo "No error logs for $a"
	else
	  mv $needed old_logs/ && cd old_logs/ && tar cfz old_error_logs.`date +%d%m%y`.tgz error* && rm error* && cd ~apache/logs
	  echo "$a DONE!"
	  cd ~apache/logs
	fi
	cd ~apache/logs && unset needed
done
	exit
}

function parse_error_logs {
for a in $sites; do
	cd $a/www
	ls error.log* 2> /dev/null > /dev/null && cat error.log* |gsed -r 's/.*] (.*)/\1/' |sort |uniq |grep -v favicon |grep -v robots |mail -E -s "$a apache errors" -c steve@ion.lu marc@ion.lu && cd ../../
	cd ~apache/logs
done
	exit
}

function check_stats {
for a in $sites; do
	cd ~apache/hosts
	cd $a/www
	##ls _stats/index.html 2> /dev/null > /dev/null || echo "$a no_stats"
	export stats_to_date=`find _stats/index.html -ctime 1 2> /dev/null > /dev/null`
	if [ -z "$stats_to_date" ]

	then
		(printf "Site Comment\n" \
		; echo "$a no_uptodate_stats!!!") | column -t

	fi

	cd ~apache/hosts
done
	exit
}

function check_old_logs {
for a in $sites; do
	cd $a/www
	ls old_logs > /dev/null || echo "$a failed"
	cd ~apache/logs
done
	exit
}

function favicon {
for a in $sites; do
	cd $a/www
	ls error.log* 2> /dev/null > /dev/null && cat error.log* |grep favicon |sort |uniq |mail -E -s "$a favicon.ico errors" -c steve@ion.lu marc@ion.lu && cd ../../
	cd ~apache/logs
done
	exit
}

function robots {
for a in $sites; do
	cd $a/www
	ls error.log* 2> /dev/null > /dev/null && cat error.log* |grep robots |sort |uniq |mail -E -s "$a robots.txt errors" -c steve@ion.lu marc@ion.lu && cd ../../
	cd ~apache/logs
done
	exit
}

if [ -z "$1" ]
then
	echo "Please give: pack_error_logs || parse_error_logs || check_old_logs || robots ||| favicon AS PARAM"
else
	$1
fi
