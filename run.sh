#!/bin/bash

zone=$1
dnsrecord=$2
cloudflare_auth_key=$3
use_proxy=false

rm -f /result.csv && \
/CloudflareST -tl 200 -tll 8 -sl 5 -p 1 -f ip.txt && \
current_ip=$(grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" /result.csv| head -n 1) && \
echo "Current IP is $current_ip" && \

if [[ "$use_proxy" != "true" ]] && [[ $(host $dnsrecord 1.1.1.1 | grep "has address" | grep "$current_ip") ]]; then
        echo "$dnsrecord is currently set to $current_ip; no changes needed"
        exit
fi && \

cloudflare_zone_id=$(curl --resolve "api.cloudflare.com:443:$current_ip" -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone&status=active" \
  -H "Authorization: Bearer $cloudflare_auth_key" \
  -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id') && \

cloudflare_dnsrecord=$(curl --resolve "api.cloudflare.com:443:$current_ip" -s -X GET "https://api.cloudflare.com/client/v4/zones/$cloudflare_zone_id/dns_records?type=A&name=$dnsrecord" \
  -H "Authorization: Bearer $cloudflare_auth_key" \
  -H "Content-Type: application/json") && \

cloudflare_dnsrecord_ip=$(echo $cloudflare_dnsrecord|jq -r '{"result"}[] | .[0] | .content') && \
cloudflare_dnsrecord_proxied=$(echo $cloudflare_dnsrecord|jq -r '{"result"}[] | .[0] | .proxied') && \

if [[ "$current_ip" == "$cloudflare_dnsrecord_ip" ]] && [[ "$cloudflare_dnsrecord_proxied" == "$use_proxy" ]];then
        echo "DNS record is up to date"
        exit
else
        cloudflare_dnsrecord_id=$(echo $cloudflare_dnsrecord| jq -r '{"result"}[] | .[0] | .id')
        # update the record
        curl --resolve "api.cloudflare.com:443:$current_ip" -s -X PUT "https://api.cloudflare.com/client/v4/zones/$cloudflare_zone_id/dns_records/$cloudflare_dnsrecord_id" \
          -H "Authorization: Bearer $cloudflare_auth_key" \
          -H "Content-Type: application/json" \
          --data "{\"type\":\"A\",\"name\":\"$dnsrecord\",\"content\":\"$current_ip\",\"ttl\":1,\"proxied\":$use_proxy}" | jq
fi && \
exit 0
