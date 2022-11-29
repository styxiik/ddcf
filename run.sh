#!/bin/sh

TOKEN=$1
DOMAIN_ID=$2
SUB_DOMAIN=$3
MAIN_DOMAIN=$4
DOMAIN=${SUB_DOMAIN}.${MAIN_DOMAIN}
RECORD_ID=`curl -X POST https://dnsapi.cn/Record.List -d 'login_token='"${TOKEN}"'&format=json&domain_id='"${DOMAIN_ID}"'&sub_domain='"${SUB_DOMAIN}"'&offset=0&length=3' | jq -r '.records' | grep -E -o '[0-9]{5,15}'` && \

rm -f /result.csv && \
/CloudflareST -tl 200 -tll 8 -sl 5 -p 1 -f /ip.txt && \
target_ip=`grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" /result.csv| head -n 1` && \
echo "Need to chang target IP become $target_ip" && \

#get domain ip from common dns
NOW_IP=`dig ${DOMAIN} @114.114.114.114 | awk -F "[ ]+" '/IN/{print $1}' | awk 'NR==2 {print $5}'` && \
echo "Now Ip of ${DOMAIN} is ---${NOW_IP}---" && \

#if domain ip and local ip are identical, dns is ok
if [ "${target_ip}" = "${NOW_IP}" ]; then
   echo "Doman IP not changed."
   exit 
else
   echo "continue"
fi && \

#if dns record is not ok, start ddns refresh
echo "start ddns refresh" && \
curl -X POST https://dnsapi.cn/Record.Ddns -d 'login_token='"${TOKEN}"'&format=json&domain_id='"${DOMAIN_ID}"'&record_id='"${RECORD_ID}"'&record_line_id=0&value='"${target_ip}"'&sub_domain='"${SUB_DOMAIN}"'' | jq && \
exit 0