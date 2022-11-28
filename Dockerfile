FROM alpine:latest
COPY *.sh /
ENV TZ Asia/Shanghai
ENV ZONE $ZONE
ENV DNSRECORD $DNSRECORD
ENV CLOUDFLARE_AUTH_KEY $CLOUDFLARE_AUTH_KEY
ENV HOURS $HOURS
RUN apk add --no-cache tzdata wget jq curl tar bash gzip bind-tools \
 && cp /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone && apk del tzdata \
 && rm -rf /var/cache/apk/* \
 && touch run.log && chmod 777 run.log \
 && newarch=$(arch | sed s/aarch64/arm64/ | sed s/armv8/arm64/ | sed s/x86_64/amd64/) \
 && latest=$(curl -sSL "https://api.github.com/repos/XIU2/CloudflareSpeedTest/releases/latest" | grep "tag_name" | head -n 1 | cut -d : -f2 | sed 's/[ \"v,]//g') \
 && wget -O CloudflareST.tar.gz https://github.com/XIU2/CloudflareSpeedTest/releases/download/v$latest/CloudflareST_linux_$newarch.tar.gz \
 && gzip -d CloudflareST*.tar.gz && tar -vxf CloudflareST*.tar && rm CloudflareST*.tar \
 && chmod +x /CloudflareST /run.sh /startup.sh

CMD /startup.sh $ZONE $DNSRECORD $CLOUDFLARE_AUTH_KEY $HOURS
