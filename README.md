# ddcf

使用XIU2/CloudflareSpeedTest项目，自动检测cf的本地优选ip，并通过ddns修改域名的dns解析记录。

只支持在amd64和arm64(armv8)平台部署，其他平台不用

需要先申请cloudflare的token，自行生成，建议先为需要解析的二级域名随便设置一个解析，如sub.example.com:120.120.120.120, 避免token无法访问api的问题，还是不行就生成一个有全部权限的token


# 使用方法

docker run -d \
  --name="DDCF" \
  -e ZONE="example.com" \
  -e DNSRECORD="sub.example.com" \
  -e CLOUDFLARE_AUTH_KEY="dhsaihdiuah" \
  -e HOURS="12" \
  --restart unless-stopped \
  ghcr.io/styxiik/ddcf:main
  
*ZONE是cloudflare托管域名的主域名


*DNSRECORD是需要修改dns的二级域名
*CLOUDFLARE_AUTH_KEY，cloudflare token

*自动更新ip时间间隔,单位h

*以上参数都属必填项

*默认丢弃延迟超出8-200ms上下限的结果，丢弃速度低于5mb/s的结果，不支持ipv6

*需要避免docker走代理，防止出错

# 声明
保证自用，不保证其他人可用，有bug请PR不要BB


# Thanks
https://github.com/XIU2/CloudflareSpeedTest
