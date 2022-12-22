#!/bin/sh

TOKEN=$1
DOMAIN_ID=$2
SUB_DOMAIN=$3
MAIN_DOMAIN=$4
DOMAIN=${SUB_DOMAIN}.${MAIN_DOMAIN}
rm -f /root/result.csv && \
/root/CloudflareST -tl 200 -tll 8 -sl 5 -p 1 -f /root/ip.txt && \
target_ip=`grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" /root/result.csv| head -n 1` && \
if [ ! -n "$target_ip" ]; then
   echo "fail to found a target ip"
   exit
else
   echo "find a target IP $target_ip"
fi && \
RECORD_ID=`curl -X POST https://dnsapi.cn/Record.List -d 'login_token='"${TOKEN}"'&format=json&domain_id='"${DOMAIN_ID}"'&sub_domain='"${SUB_DOMAIN}"'&offset=0&length=3' | jq -r '.records' | grep -E -o '[0-9]{5,15}'`
if [ $? -ne 0 ]; then
    echo "docker can't connect to internet, check your iptables or restart the docker program(not only this container) especially when you had restart other proxy process"
    exit
else
    echo "RECORD_ID is $RECORD_ID"
fi && \

NOW_IP=`dig ${DOMAIN} @114.114.114.114 | awk -F "[ ]+" '/IN/{print $1}' | awk 'NR==2 {print $5}'` && \
echo "Now ip of ${DOMAIN} is ---${NOW_IP}---" && \

if [ "${target_ip}" = "${NOW_IP}" ]; then
   echo "Domain IP not changed."
   exit 
fi && \

echo "start ddns refresh" && \
curl -X POST https://dnsapi.cn/Record.Ddns -d 'login_token='"${TOKEN}"'&format=json&domain_id='"${DOMAIN_ID}"'&record_id='"${RECORD_ID}"'&record_line_id=0&value='"${target_ip}"'&sub_domain='"${SUB_DOMAIN}"'' | jq && \
exit 0
