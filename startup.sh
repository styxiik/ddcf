#!/bin/sh
zone=$1
dnsrecord=$2
cloudflare_auth_key=$3
HOURS=$4
echo > /run.log
echo > /etc/crontabs/root
echo "30 */$HOURS * * * nohup /bin/bash /run.sh $ZONE $DNSRECORD $CLOUDFLARE_AUTH_KEY > /run.log" >> /etc/crontabs/root
/bin/bash /run.sh $ZONE $DNSRECORD $CLOUDFLARE_AUTH_KEY
tail -f /run.log
