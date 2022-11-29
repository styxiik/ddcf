#!/bin/sh
TOKEN=$1
DOMAIN_ID=$2
SUB_DOMAIN=$3
MAIN_DOMAIN=$4
HOURS=$5
echo > /run.log
echo > /etc/crontabs/root
rm -f /result.csv
echo "30 */$HOURS * * * nohup /run.sh $TOKEN $DOMAIN_ID $SUB_DOMAIN $MAIN_DOMAIN > /run.log 2>&1" >> /etc/crontabs/root
/usr/sbin/crond -b
/bin/bash /run.sh $TOKEN $DOMAIN_ID $SUB_DOMAIN $MAIN_DOMAIN
tail -f /run.log
