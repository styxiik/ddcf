# ddcf

使用XIU2/CloudflareSpeedTest项目，自动检测cf的本地优选ip，并通过dnspod大陆版ddns修改域名的dns解析记录。

只支持在amd64和arm64(armv8)平台部署，其他平台不用，支持eu.org主域名

需要先申请dnspod的token，自行生成，先为需要解析的二级域名随便设置一个解析，如sub.example.com:120.120.120.12

由于api.cloudflare.com在大陆被屏蔽域名，且该docker需要运行在无代理环境下，所以切换为dnspod,阿里云不支持eu.org

# 使用方法

```
docker run -d \
  --name="DDCF" \
  -e TOKEN="123456,123456789abcde" \
  -e DOMAIN_ID="123456" \
  -e SUB_DOMAIN="sub" \
  -e MAIN_DOMAIN="example.com" \
  -e HOURS="12" \
  --restart unless-stopped \
  styxiik/ddcf:latest
```

*TOKEN:DNSPOD的token,格式为"id,key",可在dnspod右上角头像-API密钥-DNSPOD TOKEN生成，注意不是腾讯云api密钥

*DOMAIN_ID：可在已挂靠dnspod的域名-域名设置获得domain id

*SUB_DOMAIN:如需要解析ddns的域名为sub.example.com,此处填入sub

*MAIN_DOMAIN:如需要解析ddns的域名为sub.example.com,此处填入example.com

*HOURS,自动更新ip时间间隔,单位h

*以上参数都属必填项

*默认丢弃延迟超出8-200ms上下限的结果，丢弃速度低于5mb/s的结果，不支持ipv6

*如运行几天后出现 curl: (7) Failed to connect to dnsapi.cn port 443 after 4 ms: Couldn't connect to server，请重启docker(不是重启容器)

*需要避免容器的bridge ip走代理，防止出错,一般代理软件都有不代理ip段的设置。不可设置经代理软件走direct模式，可能会全部ip延迟低于8ms，特别是clash。

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
