FROM alpine:latest
WORKDIR /root
COPY *.sh /root
ENV TOKEN $TOKEN
ENV DOMAIN_ID $DOMAIN_ID
ENV SUB_DOMAIN $SUB_DOMAIN
ENV MAIN_DOMAIN $MAIN_DOMAIN
ENV HOURS $HOURS
RUN apk add --no-cache wget jq grep curl tar gzip bind-tools \
 && rm -rf /var/cache/apk/* \
 && touch run.log && chmod 777 run.log \
 && newarch=$(arch | sed s/aarch64/arm64/ | sed s/armv8/arm64/ | sed s/x86_64/amd64/) \
 && latest=$(curl -sSL "https://api.github.com/repos/XIU2/CloudflareSpeedTest/releases/latest" | grep "tag_name" | head -n 1 | cut -d : -f2 | sed 's/[ \"v,]//g') \
 && wget -O CloudflareST.tar.gz https://github.com/XIU2/CloudflareSpeedTest/releases/download/v$latest/CloudflareST_linux_$newarch.tar.gz \
 && gzip -d CloudflareST*.tar.gz && tar -vxf CloudflareST*.tar && rm CloudflareST*.tar \
 && chmod +x CloudflareST run.sh startup.sh

CMD /root/startup.sh $TOKEN $DOMAIN_ID $SUB_DOMAIN $MAIN_DOMAIN $HOURS
