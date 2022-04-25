#!/bin/bash

# Export some ENV variables so you don't have to type anything
source /root/config.sh

type="incremental"
if [ "$1" = "full" ]; then
	type="full"
fi

# Set up some variables for logging
LOGFILE="/var/log/duplicity/backup.log"
DAILYLOGFILE="/var/log/duplicity/backup.daily.log"
FULLBACKLOGFILE="/var/log/duplicity/backup.full.log"
HOST=`hostname`
DATE=`date +%Y-%m-%d`
TODAY=$(date +%d%m%Y)
back_time=$(date +%Y-%m-%d -d "$DATE -$OLDERTHAN days")

is_running=$(ps -ef | grep duplicity  | grep python | wc -l)

if [ ! -d /var/log/duplicity ];then
    mkdir -p /var/log/duplicity
fi

if [ ! -f $FULLBACKLOGFILE ]; then
    touch $FULLBACKLOGFILE
fi

if [ $is_running -eq 0 ]; then
    # Clear the old daily log file
    cat /dev/null > ${DAILYLOGFILE}

    # Trace function for logging, don't change this
    trace () {
            stamp=`date +%Y-%m-%d_%H:%M:%S`
            echo "$stamp: $*" | tee -a ${DAILYLOGFILE}
    }


    trace "Backup for local filesystem started"

    trace "... removing old backups"

    duplicity remove-older-than  $back_time  s3://s3-$REGION_NAME.amazonaws.com/$bucket/$HOST/ >> ${DAILYLOGFILE} 2>&1
    trace "... backing up filesystem"

    duplicity $type --asynchronous-upload --full-if-older-than $fullifolderthan --include-filelist=/opt/easy-duplicity/include.txt --exclude=/** --s3-region-name=$REGION_NAME --ssl-no-check-certificate  / s3://s3-$REGION_NAME.amazonaws.com/$bucket/$HOST/ >> ${DAILYLOGFILE}

    trace "Backup $type for local filesystem complete"
    trace "------------------------------------"

    # Send the daily log file by email
    cat "$DAILYLOGFILE" | mail -aFrom:$mailfrom -s "Duplicity Backup Log for $HOST - $DATE" $MAILADDR
    BACKUPSTATUS=`cat "$DAILYLOGFILE" | grep Errors | awk '{ print $2 }'`
    if [ "$BACKUPSTATUS" != "0" ]; then
       cat "$DAILYLOGFILE" | mail -aFrom:$mailfrom -s "Duplicity Backup Log for $HOST - $DATE" $MAILADDR
    elif [ "$FULL" = "full" ]; then
        echo "$(date +%d%m%Y_%T) Full Back Done" | tee -a  $FULLBACKLOGFILE
    fi

    # Append the daily log file to the main log file
    cat "$DAILYLOGFILE" | tee -a $LOGFILE

    # Reset the ENV variables. Don't need them sitting around
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset PASSPHRASE
fi

cat: full: No such file or directory
root@uranium:/opt/easy-duplicity# cat ./easy-duplicity-backup.sh
#!/bin/bash

# Export some ENV variables so you don't have to type anything
source /root/config.sh

type="incremental"
if [ "$1" = "full" ]; then
	type="full"
fi

# Set up some variables for logging
LOGFILE="/var/log/duplicity/backup.log"
DAILYLOGFILE="/var/log/duplicity/backup.daily.log"
FULLBACKLOGFILE="/var/log/duplicity/backup.full.log"
HOST=`hostname`
DATE=`date +%Y-%m-%d`
TODAY=$(date +%d%m%Y)
back_time=$(date +%Y-%m-%d -d "$DATE -$OLDERTHAN days")

is_running=$(ps -ef | grep duplicity  | grep python | wc -l)

if [ ! -d /var/log/duplicity ];then
    mkdir -p /var/log/duplicity
fi

if [ ! -f $FULLBACKLOGFILE ]; then
    touch $FULLBACKLOGFILE
fi

if [ $is_running -eq 0 ]; then
    # Clear the old daily log file
    cat /dev/null > ${DAILYLOGFILE}

    # Trace function for logging, don't change this
    trace () {
            stamp=`date +%Y-%m-%d_%H:%M:%S`
            echo "$stamp: $*" | tee -a ${DAILYLOGFILE}
    }


    trace "Backup for local filesystem started"

    trace "... removing old backups"

    duplicity remove-older-than  $back_time  s3://s3-$REGION_NAME.amazonaws.com/$bucket/$HOST/ >> ${DAILYLOGFILE} 2>&1
    trace "... backing up filesystem"

    duplicity $type --asynchronous-upload --full-if-older-than $fullifolderthan --include-filelist=/opt/easy-duplicity/include.txt --exclude=/** --s3-region-name=$REGION_NAME --ssl-no-check-certificate  / s3://s3-$REGION_NAME.amazonaws.com/$bucket/$HOST/ >> ${DAILYLOGFILE}

    trace "Backup $type for local filesystem complete"
    trace "------------------------------------"

    # Send the daily log file by email
    cat "$DAILYLOGFILE" | mail -aFrom:$mailfrom -s "Duplicity Backup Log for $HOST - $DATE" $MAILADDR
    BACKUPSTATUS=`cat "$DAILYLOGFILE" | grep Errors | awk '{ print $2 }'`
    if [ "$BACKUPSTATUS" != "0" ]; then
       cat "$DAILYLOGFILE" | mail -aFrom:$mailfrom -s "Duplicity Backup Log for $HOST - $DATE" $MAILADDR
    elif [ "$FULL" = "full" ]; then
        echo "$(date +%d%m%Y_%T) Full Back Done" | tee -a  $FULLBACKLOGFILE
    fi

    # Append the daily log file to the main log file
    cat "$DAILYLOGFILE" | tee -a $LOGFILE

    # Reset the ENV variables. Don't need them sitting around
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset PASSPHRASE
fi