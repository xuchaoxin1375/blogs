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
curl -s https://ifconfig.me
# 或
curl -s https://ipinfo.io/ip
```

返回值即为当前被外部网站看到的 IP（IPv4 或 IPv6）

## 详细说明

下面按“和 ipinfo.io 类似的 IP 查询/定位服务”来整理，重点放免费可用、接口友好、国内可落地。

## 国内推荐组合

**国内生产环境：IPIP.NET 商用库/API + 高德/百度地图 IP 定位兜底 + 本地缓存。**
IPIP.NET 更像专业 IP 库厂商，主打 BGP/ASN 数据、全球监测点、24 小时准实时更新，国内 IP 归属、省市/区县、运营商、风控场景更适合商用；但它的免费接口每天只有 50 次，基本只能测试。([IPIP](https://www.ipip.net/?utm_source=chatgpt.com))

**国内免费/低成本项目：ip2region 本地库 + 百度/高德 API 校验。**
ip2region 是开源离线 IP 定位库，支持 IPv4/IPv6、XDB 文件、多语言客户端，查询速度很快；但它自己也说明内置数据更新不固定，高精度/高频更新场景建议用商业数据。([GitHub](https://github.com/lionsoul2014/ip2region?utm_source=chatgpt.com))

**只做页面展示“用户来自哪个城市”：百度地图普通 IP 定位或高德普通 IP 定位更省事。**
百度普通 IP 定位现在文档写明支持 IPv4 和 IPv6，返回大致位置，通常城市级，坐标一般是城市中心点；高德普通 IP 定位接口更简单，但普通版仅支持 IPv4，且不支持国外 IP 解析，高级版才支持 IPv4/IPv6 和国外 IP，需要商务咨询。([百度地图](https://lbs.baidu.com/docs/webapi?title=locationip%2Fip-api&utm_source=chatgpt.com))

------

## 国外免费 IP 查询/API 服务

| 服务                        | 免费情况                                                     | 适合做什么                                         | 注意点                                                       |
| --------------------------- | ------------------------------------------------------------ | -------------------------------------------------- | ------------------------------------------------------------ |
| **IPinfo Lite**             | 新版 Lite 要 token，但官方说明免费 Lite 是 unlimited；旧免费 API 50,000/月；无账号公共 API 约 1,000/天 | 替代 ipinfo.io 本体的轻量方案，查国家、ASN、组织等 | 免费 Lite 与旧接口字段不同，迁移要改 endpoint 和字段结构 ([IPinfo](https://support.ipinfo.io/hc/en-us/articles/34121895556242-Legacy-Free-API-vs-IPinfo-Lite?utm_source=chatgpt.com)) |
| **ip-api.com**              | 免费、免 key、非商业；45 次/分钟/IP                          | 开发测试、小工具、非商业站点                       | 免费端点不支持 HTTPS，且不允许商业使用 ([IP-API](https://ip-api.com/?lang=en&utm_source=chatgpt.com)) |
| **ipapi.co**                | 30,000/月，1,000/天；偏“free trial”                          | 快速查城市、国家、ASN、组织、时区、货币等          | 官方表述是试用性质，生产要看付费计划 ([ipapi](https://ipapi.co/free/?utm_source=chatgpt.com)) |
| **ipgeolocation.io**        | 1,000 credits/天，永久免费                                   | 字段比较丰富，含位置、国家元数据、ASN 基础、时区等 | 免费够小项目，规模化要付费 ([免费 IP 定位 API](https://ipgeolocation.io/pricing.html?utm_source=chatgpt.com)) |
| **IP2Location.io**          | 50,000 次/月，需 attribution                                 | 免费额度较高，适合中小 Demo；还带基础代理检测      | 免费字段较少，高级代理/VPN/移动数据在付费层 ([IP2Location](https://www.ip2location.io/pricing?utm_source=chatgpt.com)) |
| **DB-IP Free API**          | 500 次/天                                                    | 原型、小站点，查国家/省市                          | 免费 API 字段有限；更推荐本地 Lite 库做低成本离线查询 ([DB-IP](https://db-ip.com/api/free?utm_source=chatgpt.com)) |
| **MaxMind GeoLite2**        | Web Service 1,000 次/天；Country/City 库每天可下载多次       | 离线部署、日志分析、国家/城市级判断                | GeoLite City 免费版精度低于商业版，不应用于精确地址/住户识别 ([MaxMind](https://www.maxmind.com/en/geolitecountry?utm_source=chatgpt.com)) |
| **Abstract IP Geolocation** | 1,000 次/月，1 次/秒                                         | 小型项目，查位置、ASN、时区、安全信息              | 免费额度偏小 ([Abstract API](https://www.abstractapi.com/api/ip-geolocation-api?utm_source=chatgpt.com)) |
| **BigDataCloud**            | 不同包 10k–50k/月免费                                        | 位置、反向地理编码、网络情报组合使用               | 字段丰富，但要看具体 API 包的免费额度 ([BigDataCloud](https://www.bigdatacloud.com/?utm_source=chatgpt.com)) |
| **GeoJS**                   | 官方写 “No rate limits yet”，支持 IPv4/IPv6、CORS、JSON/JSONP | 前端直接获取用户 IP 和简单 Geo 信息                | 数据来源于 MaxMind GeoLite，适合轻量用途 ([GeoJS](https://www.geojs.io/?utm_source=chatgpt.com)) |
| **ifconfig.co**             | 免费网页/API 风格工具                                        | 查自己的公网 IP、User-Agent、GeoLite2 地理信息     | 更偏“我是谁/我的 IP 是什么”，不是重型 IP 情报 API ([ifconfig](https://ifconfig.co/?utm_source=chatgpt.com)) |
| **ipify**                   | 免费、无认证、支持 HTTPS/CORS                                | 只查“我的公网 IP”                                  | 不提供地理位置，本质是 IP echo 服务 ([开放公共API](https://openpublicapis.com/api/ipify?utm_source=chatgpt.com)) |
| **FindIP**                  | 官方宣称免费、无限、无速率限制                               | 查位置、ISP、VPN/代理/Tor/恶意标记                 | 新兴服务，生产前要压测和验证准确率 ([FindIP.Net](https://www.findip.net/?utm_source=chatgpt.com)) |
| **IPWho / IPWho.org**       | 免费、无限、无需 key                                         | 免费查位置、ASN、ISP、时区、货币                   | 数据来自 MaxMind + IP2Location Lite，适合备选/测试 ([IPWho](https://ipwho.org/?utm_source=chatgpt.com)) |
| **IPBot**                   | 免费、无需 key                                               | IP 地理位置、ASN、风险评分、VPN/代理检测           | 新兴服务，建议只作为辅助验证源 ([IPBot](https://ipbot.com/?utm_source=chatgpt.com)) |
| **ipregistry**              | 注册送 100,000 free lookups                                  | 公司、运营商、VPN、User-Agent 解析等较全           | 免费是注册送额度，不是无限免费 ([Ipregistry](https://ipregistry.co/pricing?utm_source=chatgpt.com)) |
| **IP-Atlas**                | 2,000 次/月 + 一次免费 MMDB 下载                             | 位置、ASN、组织、数据中心/VPN 检测                 | 免费额度小，但字段不锁高级层 ([IP Atlas](https://ip-atlas.io/?utm_source=chatgpt.com)) |
| **ipdata.co**               | 1,500 次/天，非商业                                          | 位置、ASN、OSINT blocklists、公司/风险字段         | 免费层限制非商业使用 ([IPData](https://ipdata.co/pricing.html?utm_source=chatgpt.com)) |

------

## 可自建/离线 IP 库

| 数据库                      | 免费情况                                                     | 推荐程度                                                     |
| --------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **ip2region**               | 开源，Apache-2.0，支持 IPv4/IPv6、多语言、XDB                | **国内免费首选**，适合后台本地查询、低延迟、隐私友好；但要注意数据更新频率 ([GitHub](https://github.com/lionsoul2014/ip2region?utm_source=chatgpt.com)) |
| **MaxMind GeoLite2**        | 免费数据库 + 免费 Web Service                                | 全球通用，生态成熟；城市级不要过度相信 ([MaxMind](https://www.maxmind.com/en/geolitecountry?utm_source=chatgpt.com)) |
| **DB-IP Lite**              | CSV/MMDB，每月更新，CC BY 4.0                                | 免费离线全球库，必须 attribution；精度低于商业版 ([DB-IP](https://db-ip.com/db/lite.php?utm_source=chatgpt.com)) |
| **IP2Location LITE**        | 注册后免费下载 LITE 数据库，含 IP2Location/IP2Proxy/ASN LITE | 适合需要位置 + 基础代理/VPN/Tor/ASN 的本地库方案 ([IP2Location](https://www.ip2location.com/database/lite?utm_source=chatgpt.com)) |
| **IPLocate Free Databases** | 免费 IP-to-Country、IP-to-ASN，CSV/MMDB，日更新，CC BY-SA 4.0 | 适合只需要国家和 ASN 的高性能离线查询 ([IPLocate](https://www.iplocate.io/free-databases?utm_source=chatgpt.com)) |

------

## 国内免费/半免费方案

### 1. IPIP.NET

国内 IP 库专业度高，适合“商用 IP 归属地、运营商、风控、爬虫识别、画像”等场景。官网显示它有 IPv4 地级市库、国内区县库、国内高精度定位、IPv6 地理位置库、代理风险识别等产品；免费接口仅 IPv4、每天 50 次，只适合测试。([IPIP](https://www.ipip.net/?utm_source=chatgpt.com))

**推荐场景：** 正式业务、用户画像、风控、反作弊、日志归属地统计。
**不推荐场景：** 纯免费高并发项目。

### 2. 百度地图普通 IP 定位

适合网页/APP 后端根据 IP 得到大致省市和坐标。当前文档说明支持 IPv4 和 IPv6，返回省、市、经纬度等，位置通常是城市级，坐标只是大致位置/城市中心点。([百度地图](https://lbs.baidu.com/docs/webapi?title=locationip%2Fip-api&utm_source=chatgpt.com))

**推荐场景：** 国内站点初始化城市、天气城市、内容推荐、表单省市预填。
**注意：** 不适合“精确定位某个人”。

### 3. 高德地图 IP 定位

普通 IP 定位接口简单，HTTP GET，返回 JSON/XML；但普通版明确写着仅支持 IPv4、不支持国外 IP 解析。高级 IP 定位支持 IPv4、IPv6、国外 IP，但属于高级服务，需要商务咨询。([高德开放平台](https://lbs.amap.com/api/webservice/guide/api/ipconfig?utm_source=chatgpt.com))

**推荐场景：** 国内 IPv4 用户城市识别、地图生态里使用。
**注意：** 海外 IP、IPv6、精度要求高时不要用普通版。

### 4. 腾讯位置服务 IP 定位

腾讯位置服务也有 IP 定位接口，常见接口形态是 `ws/location/v1/ip`，第三方收录显示免费额度较高、支持 HTTPS；但我这次没有抓到腾讯官方文档页的完整内容，所以建议你实际接入前以腾讯位置服务控制台的额度和协议为准。([免费API](https://www.free-api.com/doc/349?utm_source=chatgpt.com))

**推荐场景：** 已经在用腾讯地图/腾讯位置服务生态的项目。
**注意：** 正式上线前核实 key 限额、并发、商用许可。

### 5. 太平洋网络 PConline IP 接口

PConline 的 whois 页面公开列了多个接口，包括 `ip.jsp`、`ipJson.jsp`、`ipAreaCoordJson.jsp` 等，支持传入 IP、设置输出精度等级。([电脑在线 Whois](https://whois.pconline.com.cn/?utm_source=chatgpt.com))

**推荐场景：** 手工查询、临时脚本、测试对照。
**不推荐场景：** 商业生产依赖。它更像公开工具接口，SLA、限流、商用授权都不如专业 API 清晰。

### 6. 纯真 CZ88

纯真 IP 库在国内历史很长，常见于离线库和工具生态；不过目前公开搜索结果里更容易看到第三方介绍和工具封装，而不是清晰的官方免费 API 文档。可以作为对照源或离线库候选，但正式商用要确认授权。([IP77](https://ip77.net/czip/?utm_source=chatgpt.com))

### mihomo客户端或网页版中的ip查询接口

- ip.sb
- ipapi.is
- whoip.i

------

## 推荐排序

### 国内

**国内免费自建：**

1. ip2region
2. MaxMind GeoLite2 / DB-IP Lite / IP2Location LITE 作为海外补充
3. PConline、IPIP 免费接口只做抽样校验

**国内商用：**

1. IPIP.NET 商业库/API
2. 高德/百度/腾讯位置服务做地图坐标、城市初始化兜底
3. 本地缓存，避免每次请求都打外部 API

### 国际

**国外免费 API 替代 ipinfo.io：**

1. IPinfo Lite：最像 ipinfo.io 的官方免费路线
2. ip-api.com：最省事，但免费不支持 HTTPS、非商业
3. IP2Location.io：免费额度高
4. ipgeolocation.io：字段丰富，免费 1,000/天
5. GeoJS / ifconfig.co / ipify：适合查“我的 IP”和轻量信息

------

## 接入建议

不要每个请求都实时查 IP。建议按 IP 或 `/24` 网段缓存 7–30 天；登录、风控、内容推荐等场景可以短一点，普通访问统计可以长一点。IP 归属地本来就不是精确定位，尤其移动网络、代理、VPN、CDN、企业出口、校园网会经常偏移。近期研究也指出，移动网络的 IP 定位误差显著高于固定网络，且不同地区、不同数据库的失败率差异很大。([arXiv](https://arxiv.org/abs/2605.21937?utm_source=chatgpt.com))

**最终建议：** 你如果是国内项目，预算为 0，就用 **ip2region + 百度/高德校验**；如果是正式商用，就用 **IPIP.NET 商业数据 + 本地缓存 + 百度/高德/腾讯兜底**。

## 低频使用

你一天只查几次、主要在 **shell 里看出口 IP/归属地**，我推荐这几个就够了：

### 最推荐：国内用 IPIP.NET 的 myip

```bash
curl -s http://myip.ipip.net
```

优点是中文输出、国内线路友好、结果直接显示“当前 IP、国家/省市、运营商”。IPIP 官方也说明这个服务就是给个人或小规模用户获取当前 IP 归属地用的，但不承诺稳定 SLA。([IPIP](https://www.ipip.net/myip.html?utm_source=chatgpt.com))

### 第二推荐：cip.cc

```bash
curl -s cip.cc
```

查指定 IP：

```bash
curl -s cip.cc/8.8.8.8
```

优点是输出很适合终端看，会给出地址、运营商、多组数据来源，中文可读性很好。官网也直接提供了 `curl cip.cc` 的命令行用法。([CIP](https://www.cip.cc/?utm_source=chatgpt.com))

### 只想看公网 IP：ipify / ifconfig.co

```bash
curl -s https://api.ipify.org
```

或者：

```bash
curl -s ifconfig.co
```

`ipify` 只返回纯 IP，适合脚本；`ifconfig.co` 也支持 JSON、ASN、城市等信息，但官方建议自动化请求控制在 1 次/分钟以内。([开放公共API](https://openpublicapis.com/api/ipify?utm_source=chatgpt.com))

### 查国外 IP/ASN：ip-api.com

```bash
curl -s "http://ip-api.com/json/8.8.8.8?lang=zh-CN" | jq
```

它免 key，字段多，免费端点限 45 次/分钟，但免费版不允许商业使用，而且免费端点是 HTTP，不是 HTTPS。你自己一天查几次问题不大。([IP-API](https://ip-api.com/?utm_source=chatgpt.com))

------

我建议你直接加两个 alias：

```bash
alias myip='curl -s http://myip.ipip.net'
alias ipq='f(){ curl -s cip.cc/$1; }; f'
```

用法：

```bash
myip
ipq 8.8.8.8
```

更省事一点，可以写成函数：

```bash
ipq() {
  if [ -z "$1" ]; then
    curl -s http://myip.ipip.net
  else
    curl -s "cip.cc/$1"
  fi
}
```

然后：

```bash
ipq
ipq 1.1.1.1
```

**最终推荐：**
国内日常终端查询就用 **`curl http://myip.ipip.net` + `curl cip.cc/<ip>`**。够简单、够直观，不需要注册账号。

## FAQ:不同服务平台查询结果不同

可能原因很多，核心是：**你看到的“当前 IP”不一定是同一条网络路径的出口 IP**。即使在 PowerShell 里设置了：

```powershell
$env:http_proxy="..."
$env:https_proxy="..."
```

不同 `curl` 查询服务返回不同 IP，常见原因如下。

> 通常应该先考虑是否在代理软件中设置了自动分流(例如故障转移等,如果curl请求国内网站,可能就是自动走直连)
>
> 其次考虑客户端的问题,但通常来讲使用相同的客户端(命令)调用的是相同的客户端.

### 1. `curl` 请求并不一定都走了代理

PowerShell 里的 `$env:http_proxy` / `$env:https_proxy` 是给当前进程及其子进程的环境变量。一般 `curl.exe` 会读取它们，但要注意：

```powershell
curl
```

在 PowerShell 里有时可能是 `Invoke-WebRequest` 的别名，而不是真正的 `curl.exe`。建议用：

```powershell
curl.exe https://api.ipify.org
```

检查是否走代理：

```powershell
curl.exe -v https://api.ipify.org
```

看输出里有没有类似：

```text
Uses proxy env variable https_proxy == ...
Trying 127.0.0.1:7890...
CONNECT api.ipify.org:443 HTTP/1.1
```

如果没有，说明这个请求可能没走代理。

------

### 2. HTTP 和 HTTPS 代理变量配置不同或代理协议不对

例如你设置的是：

```powershell
$env:https_proxy="https://127.0.0.1:7890"
```

但很多本地代理端口实际是 **HTTP 代理**，即使代理的是 HTTPS 网站，也应该写：

```powershell
$env:https_proxy="http://127.0.0.1:7890"
```

因为这里的 `https_proxy` 表示“访问 HTTPS 目标时用哪个代理”，不一定表示“代理连接本身使用 HTTPS”。

------

### 3. 某些 IP 查询服务返回 IPv4，某些返回 IPv6

这是最常见原因之一。

例如：

```powershell
curl.exe https://api.ipify.org
curl.exe https://api64.ipify.org
curl.exe https://ifconfig.me
curl.exe https://icanhazip.com
```

有些服务优先返回 IPv4，有些支持 IPv6，有些会根据连接类型返回你访问它时使用的地址。

可以强制测试：

```powershell
curl.exe -4 https://api.ipify.org
curl.exe -6 https://api64.ipify.org
```

如果 `-4` 和 `-6` 结果不同，这是正常的。

------

### 4. 代理服务本身有多个出口节点

很多代理客户端或节点并不保证固定出口 IP。可能出现：

- 同一个节点背后有多个出口 IP；
- IPv4 和 IPv6 出口不同；
- 不同域名走了不同规则；
- 负载均衡导致每次连接出口不同；
- `api.ipify.org` 和 `ifconfig.me` 被规则分流到不同代理节点。

如果你的代理软件启用了规则模式、分流、负载均衡、自动选择节点，这种情况很常见。

------

### 5. 某些请求被代理，某些请求被直连

代理工具通常有规则，例如：

- 国内网站直连；
- 国外网站代理；
- 特定域名直连；
- DNS 查询走代理或不走代理；
- fake-ip / tun / system proxy 规则影响路径。

不同 IP 查询服务的域名可能命中不同规则，所以结果会不一样。

建议用几个明确的命令测试：

```powershell
curl.exe --proxy http://127.0.0.1:7890 https://api.ipify.org
curl.exe --noproxy "*" https://api.ipify.org
```

第一个强制走代理，第二个强制不走代理。两者结果如果不同，说明代理确实生效。

------

### 6. `NO_PROXY` / `no_proxy` 环境变量绕过了代理

检查：

```powershell
Get-ChildItem Env:*proxy*
```

如果有：

```powershell
no_proxy
NO_PROXY
```

其中包含某些域名、通配规则或网段，部分请求可能绕过代理。

可以临时清掉：

```powershell
Remove-Item Env:NO_PROXY -ErrorAction SilentlyContinue
Remove-Item Env:no_proxy -ErrorAction SilentlyContinue
```

------

### 7. IP 查询服务本身识别的是不同层面的 IP

不同服务可能展示：

- TCP 连接源 IP；
- CDN 边缘看到的 IP；
- `X-Forwarded-For`；
- Cloudflare / Fastly / Akamai 后的判断结果；
- IPv4-mapped 或 IPv6 地址；
- 被代理商、云厂商、NAT 网关暴露出来的地址。

靠谱一点的是用多个极简服务对比，例如：

```powershell
curl.exe https://api.ipify.org
curl.exe https://ifconfig.me/ip
curl.exe https://icanhazip.com
curl.exe https://checkip.amazonaws.com
```

------

### 推荐排查顺序

先确认你调用的是真正的 `curl.exe`：

```powershell
Get-Command curl
Get-Command curl.exe
```

然后分别测试：

```powershell
curl.exe -v https://api.ipify.org
curl.exe --proxy http://127.0.0.1:7890 https://api.ipify.org
curl.exe --noproxy "*" https://api.ipify.org
curl.exe -4 --proxy http://127.0.0.1:7890 https://api.ipify.org
curl.exe -6 --proxy http://127.0.0.1:7890 https://api64.ipify.org
```

如果强制代理时仍然不同，大概率是：**代理节点多出口、IPv4/IPv6 出口不同、或代理规则/负载均衡导致不同服务走了不同出口**。
