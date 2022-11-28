# ddcf

使用XIU2/CloudflareSpeedTest项目，自动检测cf的本地优选ip，并通过ddns修改域名的dns解析记录。

只支持在amd64和arm64(armv8)平台部署，其他平台不用，cloudflare官方api不支持freenom域名，eu.org可用

需要先申请cloudflare的token，自行生成，建议先为需要解析的二级域名随便设置一个解析，如sub.example.com:120.120.120.120, 避免token无法访问api的问题，还是不行就生成一个有全部权限的token

有时日志出现筛选到目标ip，但无法更新ip的情况，这是因为使用该优选ip也无法访问cloudflare api,说明无可用ip

# 使用方法

```
docker run -d \
  --name="DDCF" \
  -e ZONE="example.com" \
  -e DNSRECORD="sub.example.com" \
  -e CLOUDFLARE_AUTH_KEY="dhsaihdiuah" \
  -e HOURS="12" \
  --restart unless-stopped \
  ghcr.io/styxiik/ddcf:main
```

*自行替换以下参数

*ZONE是cloudflare托管域名的主域名

*DNSRECORD是需要修改dns的二级域名

*CLOUDFLARE_AUTH_KEY，cloudflare token

*HOURS,自动更新ip时间间隔,单位h

*以上参数都属必填项

*默认丢弃延迟超出8-200ms上下限的结果，丢弃速度低于5mb/s的结果，不支持ipv6

*需要避免docker走代理，防止出错,一般代理软件都有不代理ip段的设置

*建议docker bridge的ip段不走代理，或者可以在部署前创建专属网段

```
docker network create --subnet=172.18.0.0 /16 mynetwork
```



在启动容器时添加以下参数

```
--net mynetwork --ip 172.18.0.2 \
```

达到docker容器为固定ip,再设置172.18.0.2不走代理

# 声明
保证自用，不保证其他人可用，有bug请PR不要BB


# Thanks
https://github.com/XIU2/CloudflareSpeedTest
