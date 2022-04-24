#!/bin/bash

# Export some ENV variables so you don't have to type anything
source /root/config.sh

if [ $# -ne 0 ]; then
	HOST=$1
else
	HOST=$HOSTNAME
fi

duplicity collection-status  --s3-region-name=$REGION_NAME --ssl-no-check-certificate   s3://s3-$REGION_NAME.amazonaws.com/$bucket/$HOST/

# Reset the ENV variables. Don't need them sitting around
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset PASSPHRASE