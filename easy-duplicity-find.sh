#!/bin/bash

# Export some ENV variables so you don't have to type anything
source /root/config.sh

DATE=`date +%Y-%m-%d`
MAILADDR="gilles.fauvie@gmail.com"
TODAY=$(date +%d%m%Y)

if [ $# -eq 2 ]; then
        HOST=$2
else
        HOST=$HOSTNAME
fi
# --time "2022-04-24T13:22:01"
if [ $# -ne 0 ]; then
        file=$1
	duplicity list-current-files --ssl-no-check-certificate   s3://s3-$REGION_NAME.amazonaws.com/$bucket/$HOST/ | grep $file
else
	duplicity list-current-files --ssl-no-check-certificate   s3://s3-$REGION_NAME.amazonaws.com/$bucket/$HOST/
fi

# Reset the ENV variables. Don't need them sitting around
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset PASSPHRASE