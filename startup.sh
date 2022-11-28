#!/bin/sh
zone=$1
dnsrecord=$2
cloudflare_auth_key=$3
HOURS=$4
echo > /run.log
echo > /etc/crontabs/root
rm -f /result.csv
echo "30 */$HOURS * * * /bin/bash /run.sh $ZONE $DNSRECORD $CLOUDFLARE_AUTH_KEY > /run.log 2>&1" >> /etc/crontabs/root
/usr/sbin/crond -b
/bin/bash /run.sh $ZONE $DNSRECORD $CLOUDFLARE_AUTH_KEY
tail -f /run.log
