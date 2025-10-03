[toc]



## 在线ip地址查询工具

快速在线查看（最简单）

在浏览器访问外部「回显 IP」服务（只需打开页面即可看到当前对外 IP）

- 常见示例：what is my ip 类网站、ipinfo.io、ifconfig.co、ipleak.net 等。
- 优点：立刻看到公网 IP；缺点：若代理修改了 HTTP 头或透明代理，显示结果会随之变化。

仅列出常用或较好用的一部分

- [iP地址查询--手机号码查询归属地 | 邮政编码查询 | iP地址归属地查询 | 身份证号码验证在线查询网](https://www.ip138.com/)
- [IP Address Lookup / IPv4 / IPv6 - IP.SB](https://ip.sb/)
- [What Is My IP Address? - ifconfig.me](https://ifconfig.me/)
- [What is my IP address? — ifconfig.co](https://ifconfig.co/)

- [IP/DNS Detect - What is your IP, what is your DNS, what informations you send to websites.](https://ipleak.net/)


## 带有ip信息和测速的在线站

- http://speed.do/

### 命令行直接查询你的“对外 IP”

（在任意系统 / 远程 shell 都能用）

- 使用 curl：

```bash
curl -s https://ifconfig.co
# 或
curl -s https://ipinfo.io/ip
```

返回值即为当前被外部网站看到的 IP（IPv4 或 IPv6）

