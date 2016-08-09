#!/bin/bash
# 秒级计划任务#
 
interval=0.5
single_instance=y

pidfile=/var/cron_lock/`basename $0`.pid
 
if [ "$single_instance" == "y" ] ; then
    if [ -f $pidfile ] && [ -e /proc/`cat $pidfile` ] ; then
        exit 1
    fi
fi
 
trap "rm -fr $pidfile ; exit 0" 1 2 3 15
echo $$ > $pidfile
 
function process() {
	ret_bool=`/usr/local/bin/php -f api.php`
	if [ "$ret_bool" == 0 ]
	    then
		#ID=`cat $pidfile`
       		#kill -9 $ID
		echo 'closing...'
		exit
	    else
		current_date=`date "+%Y-%m-%d %H:%M:%S"`
	        echo "$current_date"  >> log.txt
		echo "$current_date" 'running...'
	fi
}
 
while [ 1 ]
do
    process
    sleep $interval
done
