[toc]

# Cloudflare API 免费功能完全指南

> 面向初级开发者的系统性教程

---

## 第一章 引言与概述

### 1.1 什么是 Cloudflare

Cloudflare 是全球领先的云服务提供商，其核心业务围绕内容分发网络（CDN）、网络安全、域名服务等领域展开。对于开发者而言，Cloudflare 的独特价值在于它提供了大量慷慨的免费额度，使得个人开发者和小型团队能够以零成本构建专业级的网络应用。

### 1.2 为什么选择 Cloudflare API

传统的网站管理需要登录控制台手动操作，这种方式在管理少量资源时尚可接受，但当你需要管理数十个域名、自动化部署流程、或者构建复杂的 DevOps 工作流时，API 就成为必不可少的工具。

Cloudflare API 采用 RESTful 设计风格，这意味着它遵循一套标准化的设计原则：使用 HTTP 方法（GET、POST、PUT、DELETE）来表达操作意图，使用 URL 路径来定位资源，使用 JSON 格式来传输数据。如果你曾经使用过任何主流的 Web API，你会发现 Cloudflare API 的设计非常直观。

### 1.3 免费套餐包含哪些功能

[Free Plan Overview | Cloudflare](https://www.cloudflare.com/plans/free/)

Cloudflare 的免费套餐在业界以慷慨著称。以下是免费套餐中最有价值的功能清单：

**完全免费的核心功能**包括：无限制的 DNS 托管服务，支持任意数量的域名；全球 CDN 加速，无带宽限制；基础的 DDoS 防护；SSL/TLS 证书自动签发与续期；基础的 WAF（Web 应用防火墙）规则。

| 功能类别               | 免费版是否包含    | 说明                       |
| ---------------------- | ----------------- | -------------------------- |
| DNS 托管               | ✅                 | Cloudflare DNS 完全免费    |
| CDN 全球加速           | ✅                 | 全球边缘节点缓存静态资源   |
| SSL 证书               | ✅                 | Universal SSL 自动签发     |
| HTTP/2                 | ✅                 | 支持                       |
| HTTP/3                 | ✅                 | 支持                       |
| IPv6                   | ✅                 | 支持                       |
| DDoS 防护              | ✅                 | L3/L4/L7 基础防护          |
| WAF 防火墙             | ✅                 | 免费托管规则集             |
| Bot 防护               | ⚠️ 基础版          | 高级 Bot Management 需付费 |
| 缓存规则               | ✅                 | 基础缓存控制               |
| 页面规则（Page Rules） | ⚠️ 已被 Rules 替代 | 免费额度有限               |
| 重定向规则             | ✅                 | 有数量限制                 |
| Rate Limiting          | ⚠️ 有限            | 高级功能需付费             |
| Analytics 分析         | ✅                 | 基础流量分析               |
| Zero Trust             | ✅                 | 小规模免费                 |
| Workers                | ✅                 | 每日 100,000 请求          |
| Pages 静态托管         | ✅                 | 免费                       |
| R2 对象存储            | ⚠️ 免费额度        | 超出计费                   |
| Argo Smart Routing     | ❌                 | 付费                       |
| APO（WordPress）       | ❌                 | 免费版需额外购买           |
| Load Balancer          | ❌                 | 付费                       |
| Cache Reserve          | ❌                 | 付费                       |
| 企业级 WAF             | ❌                 | Business/Enterprise        |

---

## 第二章 API 基础架构与认证

基于 HTTPS 请求和 JSON 响应的 RESTful API。

- [创建 API 令牌 · Cloudflare 基础知识文档 --- Create API token · Cloudflare Fundamentals docs](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)了解如何使用api的准备;

  - 认证方式分两种,token(令牌)和key(密钥),前者更安全且无需使用邮箱,填写更简单(但是要准确配置权限),后者更统一(包含全部权限,需要填写账号邮箱配合key使用)

- [Cloudflare API ](https://developers.cloudflare.com/api/overview/) 了解可用的api以及详情

- [发起 API 调用 · Cloudflare 基础知识文档 --- Make API calls · Cloudflare Fundamentals docs](https://developers.cloudflare.com/fundamentals/api/how-to/make-api-calls/)

  - 每个 Cloudflare API 元素都固定对应一个版本号。最新版本为版本 4。所有版本 4 HTTPS 端点的稳定基本 URL 为： `https://api.cloudflare.com/client/v4/`

  - [API Reference | Cloudflare API](https://developers.cloudflare.com/api/) 通用api描述

    - python库[Cloudflare Python API library | Cloudflare API](https://developers.cloudflare.com/api/python)

  - 根据用户选择的认证方案(token or key)的不同,api的使用方式也有所不同.但主要体现在http标头中的传递认证信息的部分.

    - token模式

      - 标头:`"Authorization: Bearer $CLOUDFLARE_API_TOKEN"`,其中`Authoerization`是http的标准标头

      ```shell
      curl "https://api.cloudflare.com/client/v4/zones?account.id=$ACCOUNT_ID" \
      --header "Authorization: Bearer $CLOUDFLARE_API_TOKEN"
      ```

      

    - email+key模式示例

      - 标头:(`X-Auth...`标头是非标准的HTTP标头,下面两个标头可以理解为cloudflare自定义的扩展标头.)

        - `"X-Auth-Email: <EMAIL>"`

        - ` "X-Auth-Key: <API_KEY>" `

      ```shell
      curl --request PATCH "https://api.cloudflare.com/client/v4/user/invites/{id}" --header "X-Auth-Email: <EMAIL>" --header "X-Auth-Key: <API_KEY>" --data "{""status"": ""accepted""}"
      ```

    
    对比可以看出,前者调用方式更加简洁.默认get不需要指定请求方式(`--request PATCH`),且`--header`只需要指定一个`Authorizatioin`

### 2.1 API 端点与版本

Cloudflare API 的基础 URL 是 `https://api.cloudflare.com/client/v4/`。这里的 `v4` 表示当前的 API 主版本号。Cloudflare 承诺在同一主版本内保持向后兼容，这意味着你今天编写的代码在未来仍然能够正常工作，除非 Cloudflare 发布新的主版本并废弃旧版本（这种情况会提前很长时间通知）。

所有 API 请求都必须通过 HTTPS 协议发送，这确保了数据在传输过程中的安全性。不支持 HTTP 协议是一个安全设计决策，防止敏感的 API 凭证在网络传输中被窃取。

### 2.2 认证方式详解

API 认证是确保只有授权用户才能访问和修改资源的机制。Cloudflare 提供两种主要的认证方式，各有其适用场景。

**API Token（推荐方式）**是一种细粒度的认证凭证。你可以为每个 Token 配置精确的权限范围，例如只允许读取 DNS 记录、只允许操作特定的域名等。这种方式遵循最小权限原则，即每个凭证只拥有完成其任务所需的最少权限。

创建 API Token 的步骤如下：首先登录 Cloudflare 控制台，进入"我的个人资料"页面，选择"API Tokens"选项卡，点击"创建 Token"按钮。系统会提供多个预定义模板，例如"编辑区域 DNS"模板会自动配置 DNS 编辑所需的所有权限。你也可以选择"自定义 Token"来手动配置权限。

使用 API Token 时，需要在 HTTP 请求头中添加 Authorization 字段：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

这里的 `Bearer` 是一种标准的认证方案名称，它告诉服务器后面跟着的是一个令牌（token）。

**API Key + Email（传统方式）**是早期的认证方式，它使用你的账户邮箱和一个全局 API 密钥进行认证。这种方式的缺点是权限粒度太粗——这个密钥拥有你账户的全部权限。虽然 Cloudflare 仍然支持这种方式，但强烈建议新项目使用 API Token。

使用 API Key 的请求格式如下：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/user" \
     -H "X-Auth-Email: your@email.com" \
     -H "X-Auth-Key: YOUR_GLOBAL_API_KEY" \
     -H "Content-Type: application/json"
```

### 2.3 响应格式解析

Cloudflare API 的所有响应都采用统一的 JSON 结构，这种一致性让客户端代码的编写变得更加简单。一个典型的成功响应看起来像这样：

```json
{
  "success": true,
  "errors": [],
  "messages": [],
  "result": {
    "id": "023e105f4ecef8ad9ca31a8372d0c353",
    "name": "example.com"
  },
  "result_info": {
    "page": 1,
    "per_page": 20,
    "total_count": 1,
    "total_pages": 1
  }
}
```

让我逐一解释这些字段的含义。`success` 是一个布尔值，表示请求是否成功处理。即使 HTTP 状态码是 200，你也应该检查这个字段，因为某些业务逻辑错误可能返回 200 状态码但 success 为 false。

`errors` 数组包含发生的错误列表。每个错误对象包含 `code`（错误代码）和 `message`（人类可读的错误描述）。`messages` 数组包含非错误性的提示信息，例如警告或建议。

`result` 是请求的实际返回数据。对于查询单个资源的请求，它是一个对象；对于列表查询，它是一个数组。

`result_info` 在分页查询时出现，包含分页的元数据。`page` 是当前页码，`per_page` 是每页的记录数，`total_count` 是符合条件的总记录数，`total_pages` 是总页数。

当请求失败时，响应结构保持一致，但内容会有所不同：

```json
{
  "success": false,
  "errors": [
    {
      "code": 6003,
      "message": "Invalid request headers"
    }
  ],
  "messages": [],
  "result": null
}
```

### 2.4 速率限制

为了保护 API 基础设施的稳定性，Cloudflare 对 API 请求实施速率限制。免费账户的默认限制是每 5 分钟 1200 个请求，平均每秒 4 个请求。这个限制对于大多数应用场景来说是足够的。

当你超过速率限制时，API 会返回 429 状态码（Too Many Requests）。响应头中会包含以下有用信息：`X-RateLimit-Limit` 表示限制的总请求数，`X-RateLimit-Remaining` 表示剩余的可用请求数，`X-RateLimit-Reset` 表示限制重置的 Unix 时间戳。

处理速率限制的最佳实践是实现指数退避算法。当收到 429 响应时，先等待一段时间再重试，每次重试都将等待时间加倍：

```python
import time
import requests

def make_request_with_retry(url, headers, max_retries=5):
    for attempt in range(max_retries):
        response = requests.get(url, headers=headers)
        
        if response.status_code == 429:
            wait_time = (2 ** attempt) + 1  # 指数退避：2, 4, 8, 16, 32 秒
            print(f"速率限制触发，等待 {wait_time} 秒后重试...")
            time.sleep(wait_time)
            continue
        
        return response
    
    raise Exception("超过最大重试次数")
```

---

## 第三章 DNS 管理 API

### 3.1 DNS 基础概念

在深入 API 之前，让我们先理解 DNS（域名系统）的基本概念。DNS 是互联网的"电话簿"，它将人类可读的域名（如 www.example.com）转换为机器可识别的 IP 地址（如 192.0.2.1）。

DNS 记录是存储在 DNS 服务器上的信息条目。不同类型的记录服务于不同的目的：

**A 记录**将域名指向 IPv4 地址。例如，`www.example.com → 192.0.2.1` 就是一条 A 记录。

**AAAA 记录**是 A 记录的 IPv6 版本，将域名指向 IPv6 地址。

**CNAME 记录**将一个域名指向另一个域名，而不是直接指向 IP 地址。这在使用 CDN 服务时特别有用，因为 CDN 提供商可能会更改其服务器的 IP 地址，但域名保持不变。

**MX 记录**指定处理域名邮件的邮件服务器。MX 记录包含优先级值，数值越小优先级越高。

**TXT 记录**存储任意文本信息，常用于域名验证、SPF/DKIM 邮件安全配置等场景。

**NS 记录**指定域名的权威 DNS 服务器。当你将域名托管到 Cloudflare 时，需要在域名注册商处更新 NS 记录。

### 3.2 获取区域信息

在 Cloudflare 的术语中，"区域"（Zone）对应一个域名。在操作 DNS 记录之前，你需要先获取目标域名的区域 ID。

列出账户下所有区域的 API 调用如下：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

响应中的每个区域对象包含多个重要字段。`id` 是区域的唯一标识符，后续所有针对该域名的操作都需要使用这个 ID。`name` 是域名本身。`status` 表示区域的激活状态，可能的值包括 `active`（已激活）、`pending`（等待 NS 记录更新）、`initializing`（初始化中）等。

你也可以通过域名直接查找区域：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones?name=example.com" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

### 3.3 DNS 记录的增删改查

理解了基础概念后，让我们来看具体的 API 操作。

**列出所有 DNS 记录**：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

这个请求会返回该区域下的所有 DNS 记录。如果记录很多，响应会分页返回，你可以通过添加 `page` 和 `per_page` 查询参数来控制分页：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records?page=2&per_page=50" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

**创建新的 DNS 记录**：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "type": "A",
       "name": "www",
       "content": "192.0.2.1",
       "ttl": 3600,
       "proxied": true
     }'
```

让我解释请求体中各字段的含义。`type` 是记录类型，如前面介绍的 A、AAAA、CNAME 等。`name` 是子域名部分，如果你要创建 www.example.com 的记录，这里填写 `www`；如果是根域名，填写 `@` 或完整域名。`content` 是记录的值，对于 A 记录就是 IP 地址。`ttl` 是生存时间（Time To Live），单位是秒，它决定了 DNS 解析结果在客户端缓存中保留多长时间。`proxied` 是一个布尔值，决定流量是否通过 Cloudflare 的代理网络，启用代理后可以享受 CDN 加速和安全防护。

**更新现有记录**：

```bash
curl -X PUT "https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records/{record_id}" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "type": "A",
       "name": "www",
       "content": "192.0.2.2",
       "ttl": 3600,
       "proxied": true
     }'
```

注意这里使用的是 PUT 方法，并且需要在 URL 中提供具体的记录 ID。PUT 方法要求提供完整的记录信息，即使只修改一个字段也需要包含所有其他字段。

**删除记录**：

```bash
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records/{record_id}" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

### 3.4 实战案例：动态 DNS 更新脚本

动态 DNS（DDNS）是一个非常实用的应用场景。许多家庭宽带用户的公网 IP 地址会定期变化，通过 DDNS 脚本可以自动更新 DNS 记录，确保域名始终指向正确的 IP 地址。

以下是一个完整的 Python 脚本示例：

```python
#!/usr/bin/env python3
"""
Cloudflare DDNS 更新脚本
功能：自动检测公网 IP 变化并更新 DNS 记录
"""

import requests
import json
import logging

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# 配置信息
CONFIG = {
    'api_token': 'YOUR_API_TOKEN',
    'zone_id': 'YOUR_ZONE_ID',
    'record_name': 'home.example.com',  # 要更新的完整域名
    'record_type': 'A',
    'proxied': False,  # DDNS 通常不需要代理
    'ttl': 120  # 较短的 TTL 使变更更快生效
}

BASE_URL = 'https://api.cloudflare.com/client/v4'

def get_public_ip():
    """获取当前公网 IP 地址"""
    # 使用多个服务作为备份
    services = [
        'https://api.ipify.org?format=json',
        'https://ipinfo.io/json',
        'https://api.ip.sb/ip'
    ]
    
    for service in services:
        try:
            response = requests.get(service, timeout=10)
            if response.status_code == 200:
                # 处理不同服务的响应格式
                if 'json' in service:
                    data = response.json()
                    return data.get('ip') or data.get('query')
                else:
                    return response.text.strip()
        except requests.RequestException as e:
            logger.warning(f"无法从 {service} 获取 IP: {e}")
            continue
    
    raise Exception("无法从任何服务获取公网 IP")

def get_headers():
    """构建请求头"""
    return {
        'Authorization': f"Bearer {CONFIG['api_token']}",
        'Content-Type': 'application/json'
    }

def find_dns_record():
    """查找现有的 DNS 记录"""
    url = f"{BASE_URL}/zones/{CONFIG['zone_id']}/dns_records"
    params = {
        'type': CONFIG['record_type'],
        'name': CONFIG['record_name']
    }
    
    response = requests.get(url, headers=get_headers(), params=params)
    data = response.json()
    
    if not data['success']:
        raise Exception(f"查询 DNS 记录失败: {data['errors']}")
    
    records = data['result']
    if records:
        return records[0]
    return None

def create_dns_record(ip):
    """创建新的 DNS 记录"""
    url = f"{BASE_URL}/zones/{CONFIG['zone_id']}/dns_records"
    payload = {
        'type': CONFIG['record_type'],
        'name': CONFIG['record_name'],
        'content': ip,
        'ttl': CONFIG['ttl'],
        'proxied': CONFIG['proxied']
    }
    
    response = requests.post(url, headers=get_headers(), json=payload)
    data = response.json()
    
    if data['success']:
        logger.info(f"成功创建 DNS 记录: {CONFIG['record_name']} -> {ip}")
        return True
    else:
        logger.error(f"创建 DNS 记录失败: {data['errors']}")
        return False

def update_dns_record(record_id, ip):
    """更新现有的 DNS 记录"""
    url = f"{BASE_URL}/zones/{CONFIG['zone_id']}/dns_records/{record_id}"
    payload = {
        'type': CONFIG['record_type'],
        'name': CONFIG['record_name'],
        'content': ip,
        'ttl': CONFIG['ttl'],
        'proxied': CONFIG['proxied']
    }
    
    response = requests.put(url, headers=get_headers(), json=payload)
    data = response.json()
    
    if data['success']:
        logger.info(f"成功更新 DNS 记录: {CONFIG['record_name']} -> {ip}")
        return True
    else:
        logger.error(f"更新 DNS 记录失败: {data['errors']}")
        return False

def main():
    """主函数"""
    try:
        # 获取当前公网 IP
        current_ip = get_public_ip()
        logger.info(f"当前公网 IP: {current_ip}")
        
        # 查找现有记录
        record = find_dns_record()
        
        if record is None:
            # 记录不存在，创建新记录
            logger.info("DNS 记录不存在，正在创建...")
            create_dns_record(current_ip)
        elif record['content'] != current_ip:
            # IP 已变化，更新记录
            logger.info(f"检测到 IP 变化: {record['content']} -> {current_ip}")
            update_dns_record(record['id'], current_ip)
        else:
            # IP 未变化
            logger.info("IP 地址未变化，无需更新")
            
    except Exception as e:
        logger.error(f"执行失败: {e}")
        raise

if __name__ == '__main__':
    main()
```

这个脚本可以通过 cron 定时任务定期执行。在 Linux 系统上，编辑 crontab 添加以下行可以实现每 5 分钟检查一次：

```bash
*/5 * * * * /usr/bin/python3 /path/to/ddns_update.py >> /var/log/ddns.log 2>&1
```

---

## 第四章 CDN 与缓存控制

### 4.1 CDN 工作原理

内容分发网络（CDN）的核心思想是将内容缓存到离用户更近的边缘服务器上。当用户访问你的网站时，请求会被路由到地理位置最近的边缘节点，这大大减少了网络延迟。

Cloudflare 在全球拥有超过 300 个数据中心，形成了一个庞大的边缘网络。当你的域名使用 Cloudflare 并启用代理（橙色云图标）后，所有流量都会经过这个网络。

缓存的工作流程如下：首次请求时，边缘节点发现自己没有缓存这个资源，会向你的源服务器请求内容，这称为"回源"。边缘节点获取内容后，会在本地保存一份副本，然后返回给用户。后续的请求会直接从边缘节点的缓存返回，无需再次回源，这称为"缓存命中"。

### 4.2 缓存规则配置

Cloudflare 提供了灵活的缓存控制机制。默认情况下，Cloudflare 会根据文件扩展名和响应头来决定缓存策略。静态资源（如图片、CSS、JavaScript）通常会被自动缓存，而 HTML 页面默认不缓存。

通过 API 可以创建自定义的缓存规则：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/rulesets" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "name": "自定义缓存规则",
       "kind": "zone",
       "phase": "http_request_cache_settings",
       "rules": [
         {
           "expression": "(http.request.uri.path contains \"/api/\")",
           "action": "set_cache_settings",
           "action_parameters": {
             "cache": false
           },
           "description": "API 路径不缓存"
         },
         {
           "expression": "(http.request.uri.path contains \"/static/\")",
           "action": "set_cache_settings",
           "action_parameters": {
             "cache": true,
             "edge_ttl": {
               "mode": "override_origin",
               "default": 86400
             }
           },
           "description": "静态资源缓存24小时"
         }
       ]
     }'
```

这里的 `expression` 使用 Cloudflare 的表达式语言来匹配请求。常用的匹配字段包括：`http.request.uri.path` 匹配 URL 路径，`http.request.uri.query` 匹配查询字符串，`http.host` 匹配主机名，`http.request.method` 匹配 HTTP 方法。

### 4.3 缓存清除

当你更新了网站内容但缓存尚未过期时，就需要手动清除缓存。Cloudflare 提供了多种缓存清除方式。

**清除所有缓存**会删除该区域的所有缓存内容。这是最彻底的方式，但也会导致短期内所有请求都需要回源，可能增加服务器负载：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/purge_cache" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything": true}'
```

**按 URL 清除**更加精确，只清除指定的资源：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/purge_cache" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "files": [
         "https://example.com/styles.css",
         "https://example.com/script.js",
         "https://example.com/images/logo.png"
       ]
     }'
```

免费账户每次最多可以清除 30 个 URL。如果需要清除更多，可以分批调用。

**按前缀清除**可以清除某个目录下的所有缓存（此功能需要付费套餐）：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/purge_cache" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "prefixes": [
         "https://example.com/images/"
       ]
     }'
```

### 4.4 实战案例：部署后自动清除缓存

在持续集成/持续部署（CI/CD）流程中，自动清除相关缓存是一个常见需求。以下是一个集成到 GitHub Actions 的示例：

```yaml
name: 部署并清除缓存

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: 构建项目
        run: npm run build
      
      - name: 部署到服务器
        run: rsync -avz ./dist/ user@server:/var/www/html/
      
      - name: 清除 Cloudflare 缓存
        env:
          CF_API_TOKEN: ${{ secrets.CF_API_TOKEN }}
          CF_ZONE_ID: ${{ secrets.CF_ZONE_ID }}
        run: |
          # 收集已更改的文件
          CHANGED_FILES=$(git diff --name-only HEAD~1 HEAD | grep -E '\.(css|js|html)$' || true)
          
          if [ -z "$CHANGED_FILES" ]; then
            echo "没有需要清除缓存的文件"
            exit 0
          fi
          
          # 构建 URL 列表
          URLS=""
          for file in $CHANGED_FILES; do
            URLS="$URLS\"https://example.com/$file\","
          done
          URLS="[${URLS%,}]"  # 移除最后的逗号并添加括号
          
          # 调用 API 清除缓存
          curl -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/purge_cache" \
               -H "Authorization: Bearer $CF_API_TOKEN" \
               -H "Content-Type: application/json" \
               --data "{\"files\": $URLS}"
```

---

## 第五章 Workers 无服务器计算

### 5.1 Workers 简介

Cloudflare Workers 是一个运行在边缘网络上的无服务器计算平台。与传统的无服务器平台（如 AWS Lambda）不同，Workers 的代码运行在离用户最近的边缘节点，而不是集中的数据中心。这带来了极低的延迟——通常在 50 毫秒以内。

Workers 使用 V8 引擎（Chrome 浏览器使用的 JavaScript 引擎）运行代码，支持 JavaScript、TypeScript、Rust、C/C++（通过 WebAssembly）等语言。每个请求都在一个隔离的沙箱环境中执行，确保安全性和隔离性。

**免费额度**包括每天 100,000 个请求（每个请求最多消耗 10 毫秒 CPU 时间），这对于轻量级应用和原型开发来说非常充足。

### 5.2 Workers 运行时环境

Workers 的运行时环境与浏览器环境和 Node.js 环境都有所不同。它实现了 Web Workers API 的一个子集，加上一些 Cloudflare 特有的扩展。

可用的 Web API 包括：Fetch API 用于发起 HTTP 请求，URL 和 URLSearchParams 用于 URL 解析，TextEncoder 和 TextDecoder 用于文本编码，crypto.subtle 用于加密操作，Cache API 用于缓存控制等。

不可用的 API 包括：DOM 相关的 API（因为没有浏览器环境），某些 Node.js 特有的模块（如 fs、path 等），WebSocket 客户端（但可以作为 WebSocket 服务器）。

### 5.3 使用 Wrangler CLI

Wrangler 是 Cloudflare 官方提供的命令行工具，用于创建、开发、测试和部署 Workers。

安装 Wrangler：

```bash
npm install -g wrangler
```

登录到 Cloudflare 账户：

```bash
wrangler login
```

创建新项目：

```bash
wrangler init my-worker
cd my-worker
```

这会创建一个包含基本文件结构的项目。`wrangler.toml` 是配置文件，`src/index.js`（或 `src/index.ts`）是主要的代码文件。

本地开发时可以启动开发服务器：

```bash
wrangler dev
```

开发完成后部署到生产环境：

```bash
wrangler deploy
```

### 5.4 Workers API 管理

除了使用 Wrangler，你也可以通过 REST API 直接管理 Workers。

**列出所有 Workers**：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/accounts/{account_id}/workers/scripts" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

**上传 Worker 脚本**：

```bash
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/{account_id}/workers/scripts/{script_name}" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/javascript" \
     --data-binary @worker.js
```

**设置路由**：Workers 需要绑定到特定的路由才能处理请求。

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/workers/routes" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "pattern": "example.com/api/*",
       "script": "my-api-worker"
     }'
```

`pattern` 使用通配符 `*` 匹配任意字符。例如，`example.com/api/*` 会匹配所有以 `/api/` 开头的路径。

### 5.5 经典 Worker 示例

**示例一：简单的 API 代理**

这个 Worker 作为 API 代理，可以解决跨域问题，或者对请求进行预处理：

```javascript
export default {
  async fetch(request, env, ctx) {
    // 解析请求 URL
    const url = new URL(request.url);
    
    // 定义目标 API
    const targetUrl = 'https://api.example.com' + url.pathname + url.search;
    
    // 复制原始请求的方法、头部和正文
    const modifiedRequest = new Request(targetUrl, {
      method: request.method,
      headers: request.headers,
      body: request.body,
      redirect: 'follow'
    });
    
    // 发起请求
    const response = await fetch(modifiedRequest);
    
    // 添加 CORS 头部
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization'
    };
    
    // 创建新响应，添加 CORS 头部
    const modifiedResponse = new Response(response.body, {
      status: response.status,
      statusText: response.statusText,
      headers: {
        ...Object.fromEntries(response.headers),
        ...corsHeaders
      }
    });
    
    return modifiedResponse;
  }
};
```

**示例二：A/B 测试路由**

这个 Worker 随机将用户路由到不同版本的页面，用于 A/B 测试：

```javascript
export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    
    // 从 Cookie 读取现有的测试分组
    const cookies = request.headers.get('Cookie') || '';
    const abTestCookie = cookies.match(/ab_test_group=([AB])/);
    
    let testGroup;
    if (abTestCookie) {
      testGroup = abTestCookie[1];
    } else {
      // 首次访问，随机分配分组
      testGroup = Math.random() < 0.5 ? 'A' : 'B';
    }
    
    // 根据分组修改请求路径
    if (testGroup === 'B' && url.pathname === '/landing') {
      url.pathname = '/landing-v2';
    }
    
    // 获取原始响应
    const response = await fetch(url.toString(), request);
    
    // 设置分组 Cookie（如果是新用户）
    if (!abTestCookie) {
      const newResponse = new Response(response.body, response);
      newResponse.headers.set('Set-Cookie', 
        `ab_test_group=${testGroup}; Path=/; Max-Age=604800; SameSite=Lax`
      );
      return newResponse;
    }
    
    return response;
  }
};
```

**示例三：请求限流**

这个 Worker 实现简单的请求限流功能：

```javascript
// 使用 Durable Objects 或 KV 可以实现更精确的分布式限流
// 这里展示一个基于内存的简化版本（注意：每个边缘节点独立计数）

const rateLimiter = new Map();
const RATE_LIMIT = 100;  // 每分钟最多 100 个请求
const WINDOW_SIZE = 60 * 1000;  // 1 分钟窗口

export default {
  async fetch(request, env, ctx) {
    const clientIP = request.headers.get('CF-Connecting-IP');
    const now = Date.now();
    
    // 获取或初始化该 IP 的计数器
    let clientData = rateLimiter.get(clientIP);
    if (!clientData || now - clientData.windowStart > WINDOW_SIZE) {
      clientData = { count: 0, windowStart: now };
    }
    
    // 检查是否超过限制
    if (clientData.count >= RATE_LIMIT) {
      return new Response(JSON.stringify({
        error: '请求过于频繁，请稍后再试',
        retryAfter: Math.ceil((clientData.windowStart + WINDOW_SIZE - now) / 1000)
      }), {
        status: 429,
        headers: {
          'Content-Type': 'application/json',
          'Retry-After': String(Math.ceil((clientData.windowStart + WINDOW_SIZE - now) / 1000))
        }
      });
    }
    
    // 增加计数
    clientData.count++;
    rateLimiter.set(clientIP, clientData);
    
    // 继续处理请求
    return fetch(request);
  }
};
```

---

## 第六章 Pages 静态站点部署

### 6.1 Pages 概述

Cloudflare Pages 是一个专门用于部署静态网站和 JAMstack 应用的平台。与 Workers 不同，Pages 专注于托管静态资源（HTML、CSS、JavaScript、图片等），同时也支持通过 Functions 添加服务器端逻辑。

**免费套餐**非常慷慨：无限的站点数量，无限的请求数量，无限的带宽，每月 500 次构建，每次构建最长 20 分钟执行时间。这使得 Pages 成为托管个人博客、文档站点、作品集的理想选择。

Pages 支持直接与 GitHub、GitLab 集成，每当你推送代码时自动触发构建和部署。它也支持直接上传构建好的文件。

### 6.2 项目创建与配置

通过 API 创建新的 Pages 项目：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/accounts/{account_id}/pages/projects" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "name": "my-blog",
       "production_branch": "main",
       "build_config": {
         "build_command": "npm run build",
         "destination_dir": "dist",
         "root_dir": ""
       },
       "source": {
         "type": "github",
         "config": {
           "owner": "your-username",
           "repo_name": "my-blog",
           "production_branch": "main",
           "pr_comments_enabled": true,
           "deployments_enabled": true
         }
       }
     }'
```

让我解释配置中的关键字段。`build_config` 定义了构建过程：`build_command` 是执行构建的命令，`destination_dir` 是构建输出目录，`root_dir` 是项目根目录（如果代码在仓库子目录中）。

`source` 定义了代码来源。这里使用 GitHub 作为示例，需要提前在 Cloudflare 控制台中授权 GitHub 访问。`pr_comments_enabled` 开启后，每个 Pull Request 都会自动获得一个预览部署链接的评论。

### 6.3 直接上传部署

如果你的构建过程在其他地方完成（如本地或其他 CI 系统），可以使用直接上传 API 进行部署。这个过程分为三步：创建上传令牌、上传文件、创建部署。

**步骤一：创建上传会话**

```bash
curl -X POST "https://api.cloudflare.com/client/v4/accounts/{account_id}/pages/projects/{project_name}/deployments" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

响应会包含一个 `upload_token` 和 `id`（部署 ID）。

**步骤二：上传文件**

使用 wrangler 工具可以简化上传过程：

```bash
wrangler pages deploy ./dist --project-name=my-blog
```

如果需要使用纯 API，上传单个文件的格式如下：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/accounts/{account_id}/pages/projects/{project_name}/deployments/{deployment_id}/files" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -F "file=@./dist/index.html;filename=/index.html"
```

**步骤三：完成部署**

```bash
curl -X POST "https://api.cloudflare.com/client/v4/accounts/{account_id}/pages/projects/{project_name}/deployments/{deployment_id}/finalize" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

### 6.4 Pages Functions

Pages Functions 允许你在静态站点中添加服务器端逻辑。函数代码放在项目的 `functions` 目录中，文件路径决定了 API 路由。

例如，`functions/api/hello.js` 会处理 `/api/hello` 路径的请求。函数格式与 Workers 类似：

```javascript
// functions/api/hello.js
export async function onRequestGet(context) {
  return new Response(JSON.stringify({
    message: 'Hello, World!',
    timestamp: new Date().toISOString()
  }), {
    headers: { 'Content-Type': 'application/json' }
  });
}

export async function onRequestPost(context) {
  const body = await context.request.json();
  return new Response(JSON.stringify({
    received: body,
    processed: true
  }), {
    headers: { 'Content-Type': 'application/json' }
  });
}
```

动态路由使用方括号表示。例如，`functions/api/users/[id].js` 会匹配 `/api/users/123` 这样的路径，其中 `123` 可以通过 `context.params.id` 访问。

```javascript
// functions/api/users/[id].js
export async function onRequestGet(context) {
  const userId = context.params.id;
  
  // 这里可以从数据库获取用户信息
  const user = {
    id: userId,
    name: `用户 ${userId}`,
    createdAt: '2024-01-01'
  };
  
  return new Response(JSON.stringify(user), {
    headers: { 'Content-Type': 'application/json' }
  });
}
```

### 6.5 环境变量管理

Pages 项目可以配置环境变量，这些变量可以在构建过程和 Functions 运行时使用。

通过 API 设置环境变量：

```bash
curl -X PATCH "https://api.cloudflare.com/client/v4/accounts/{account_id}/pages/projects/{project_name}" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "deployment_configs": {
         "production": {
           "env_vars": {
             "API_KEY": {
               "type": "plain_text",
               "value": "your-api-key"
             },
             "DATABASE_URL": {
               "type": "secret_text",
               "value": "postgres://..."
             }
           }
         },
         "preview": {
           "env_vars": {
             "API_KEY": {
               "type": "plain_text",
               "value": "your-dev-api-key"
             }
           }
         }
       }
     }'
```

`type` 可以是 `plain_text`（明文，会在 API 响应中显示）或 `secret_text`（密文，一旦设置就无法读取，只能覆盖）。

---

## 第七章 安全防护功能

### 7.1 免费安全功能概览

Cloudflare 的免费套餐包含了相当强大的安全功能。这些功能对于保护个人网站和小型应用来说绑绑有余，某些功能甚至是企业级的。

**DDoS 防护**：Cloudflare 的网络会自动检测和缓解分布式拒绝服务攻击。这个功能完全自动化，无需任何配置。当检测到异常流量时，恶意请求会在边缘节点被拦截，只有合法流量会到达你的源服务器。

**SSL/TLS 加密**：Cloudflare 会自动为你的域名签发免费的 SSL 证书，并处理证书的续期。你可以选择不同的加密模式：Flexible（边缘加密）、Full（边缘到源站加密，源站证书可以自签名）、Full Strict（边缘到源站加密，源站需要有效证书）。

**基础 WAF 规则**：Web 应用防火墙可以拦截常见的攻击，如 SQL 注入、XSS（跨站脚本）、目录遍历等。

**Bot 管理**：Cloudflare 可以识别和管理机器人流量，区分善意爬虫（如搜索引擎）和恶意机器人。

### 7.2 防火墙规则管理

WAF（Web 应用防火墙）规则允许你根据请求特征决定是允许、阻止还是质询请求。

创建自定义防火墙规则：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/rulesets" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "name": "自定义安全规则",
       "kind": "zone",
       "phase": "http_request_firewall_custom",
       "rules": [
         {
           "expression": "(ip.geoip.country eq \"XX\")",
           "action": "block",
           "description": "阻止特定国家的访问"
         },
         {
           "expression": "(http.request.uri.path contains \"/admin\" and not ip.src in {192.168.1.0/24})",
           "action": "block",
           "description": "只允许内网访问管理后台"
         },
         {
           "expression": "(cf.threat_score gt 50)",
           "action": "managed_challenge",
           "description": "对高威胁评分的请求进行人机验证"
         }
       ]
     }'
```

常用的表达式字段包括：`ip.src` 是请求的源 IP 地址；`ip.geoip.country` 是 IP 地址对应的国家代码（ISO 3166-1 alpha-2）；`ip.geoip.asnum` 是自治系统号码（ASN）；`cf.threat_score` 是 Cloudflare 计算的威胁评分，范围是 0-100，数值越高表示威胁越大；`http.request.uri.path` 是请求路径；`http.request.method` 是 HTTP 方法；`http.user_agent` 是用户代理字符串。

可用的动作包括：`block` 直接阻止请求；`managed_challenge` 显示验证码或 JavaScript 质询；`js_challenge` 执行 JavaScript 质询来验证浏览器环境；`bypass` 跳过后续规则；`log` 只记录不执行任何动作。

### 7.3 速率限制规则

速率限制可以防止暴力破解、爬虫滥用等行为。免费套餐允许创建基础的速率限制规则。

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/rulesets" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "name": "速率限制规则",
       "kind": "zone",
       "phase": "http_ratelimit",
       "rules": [
         {
           "expression": "(http.request.uri.path contains \"/api/login\")",
           "action": "block",
           "ratelimit": {
             "characteristics": ["ip.src"],
             "period": 60,
             "requests_per_period": 5,
             "mitigation_timeout": 600
           },
           "description": "登录接口限流：每分钟最多5次请求，超过后封禁10分钟"
         }
       ]
     }'
```

`characteristics` 定义了如何识别不同的请求来源。常用的选项包括：`ip.src` 按 IP 地址限流，`cf.colo.id` 按 Cloudflare 数据中心限流，`http.request.headers["api-key"]` 按自定义头部限流。

### 7.4 页面规则（经典功能）

页面规则是 Cloudflare 的传统功能，用于配置特定 URL 模式的行为。虽然新的规则集（Rulesets）API 更加强大，但页面规则仍然适用于某些场景。

免费套餐允许创建 3 条页面规则：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/pagerules" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "targets": [
         {
           "target": "url",
           "constraint": {
             "operator": "matches",
             "value": "example.com/admin/*"
           }
         }
       ],
       "actions": [
         {
           "id": "security_level",
           "value": "high"
         },
         {
           "id": "browser_check",
           "value": "on"
         }
       ],
       "priority": 1,
       "status": "active"
     }'
```

常用的动作包括：`always_use_https` 强制 HTTPS；`forwarding_url` 配置重定向；`cache_level` 设置缓存级别；`security_level` 设置安全级别（essentially_off、low、medium、high、under_attack）；`browser_check` 启用浏览器完整性检查。

---

## 第八章 分析与监控

### 8.1 Analytics API 概述

Cloudflare Analytics API 提供了丰富的流量分析数据。免费套餐可以获取最近 24 小时的详细数据，以及最近 7 天的汇总数据。

分析数据分为多个维度：流量分析（请求数、带宽、访问者）、安全分析（威胁、防火墙事件）、性能分析（页面加载时间、TTFB）、DNS 分析（查询数、响应时间）等。

### 8.2 GraphQL Analytics API

Cloudflare 的现代分析 API 使用 GraphQL，这是一种查询语言，允许你精确指定需要的数据字段，避免获取不需要的数据。

基本的 GraphQL 查询格式：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/graphql" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "query": "query { viewer { zones(filter: {zoneTag: \"YOUR_ZONE_ID\"}) { httpRequests1hGroups(limit: 24, filter: {datetime_gt: \"2024-01-01T00:00:00Z\"}) { dimensions { datetime } sum { requests pageViews threats } } } } }"
     }'
```

为了可读性，让我将上面的 GraphQL 查询格式化：

```graphql
query {
  viewer {
    zones(filter: { zoneTag: "YOUR_ZONE_ID" }) {
      httpRequests1hGroups(
        limit: 24
        filter: { datetime_gt: "2024-01-01T00:00:00Z" }
      ) {
        dimensions {
          datetime
        }
        sum {
          requests
          pageViews
          threats
        }
      }
    }
  }
}
```

这个查询返回过去 24 小时内每小时的请求数、页面浏览数和威胁数。

**常用的数据集**包括：

`httpRequests1hGroups` 提供按小时汇总的 HTTP 请求数据。可用的聚合字段有 `requests`（请求数）、`bytes`（传输字节数）、`pageViews`（页面浏览数）、`threats`（威胁数）等。可用的维度有 `datetime`、`clientCountryName`（客户端国家）、`clientDeviceType`（设备类型）等。

`firewallEventsAdaptiveGroups` 提供防火墙事件数据，可以了解哪些请求被拦截以及原因。

`healthCheckEventsGroups` 提供源站健康检查数据（如果配置了健康检查）。

### 8.3 实战案例：构建监控仪表板

以下是一个使用 Python 获取分析数据并生成简单报告的示例：

```python
#!/usr/bin/env python3
"""
Cloudflare 流量分析报告生成器
"""

import requests
import json
from datetime import datetime, timedelta, timezone

CONFIG = {
    'api_token': 'YOUR_API_TOKEN',
    'zone_id': 'YOUR_ZONE_ID'
}

def fetch_analytics():
    """获取过去24小时的流量分析数据"""
    
    # 计算时间范围
    now = datetime.now(timezone.utc)
    yesterday = now - timedelta(days=1)
    
    query = """
    query {
      viewer {
        zones(filter: {zoneTag: "%s"}) {
          httpRequests1hGroups(
            limit: 24
            orderBy: [datetime_ASC]
            filter: {datetime_geq: "%s", datetime_lt: "%s"}
          ) {
            dimensions {
              datetime
            }
            sum {
              requests
              pageViews
              bytes
              threats
              cachedRequests
              cachedBytes
            }
            uniq {
              uniques
            }
          }
          
          httpRequests1hGroups(
            limit: 10
            orderBy: [sum_requests_DESC]
            filter: {datetime_geq: "%s", datetime_lt: "%s"}
          ) {
            dimensions {
              clientCountryName
            }
            sum {
              requests
            }
          }
          
          firewallEventsAdaptiveGroups(
            limit: 10
            orderBy: [count_DESC]
            filter: {datetime_geq: "%s", datetime_lt: "%s"}
          ) {
            dimensions {
              action
              ruleId
            }
            count
          }
        }
      }
    }
    """ % (
        CONFIG['zone_id'],
        yesterday.isoformat(), now.isoformat(),
        yesterday.isoformat(), now.isoformat(),
        yesterday.isoformat(), now.isoformat()
    )
    
    response = requests.post(
        'https://api.cloudflare.com/client/v4/graphql',
        headers={
            'Authorization': f"Bearer {CONFIG['api_token']}",
            'Content-Type': 'application/json'
        },
        json={'query': query}
    )
    
    return response.json()

def format_bytes(bytes_value):
    """将字节数格式化为人类可读的格式"""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes_value < 1024:
            return f"{bytes_value:.2f} {unit}"
        bytes_value /= 1024
    return f"{bytes_value:.2f} PB"

def generate_report(data):
    """生成文本格式的报告"""
    
    zones_data = data['data']['viewer']['zones'][0]
    hourly_data = zones_data['httpRequests1hGroups']
    
    # 汇总统计
    total_requests = sum(h['sum']['requests'] for h in hourly_data)
    total_page_views = sum(h['sum']['pageViews'] for h in hourly_data)
    total_bytes = sum(h['sum']['bytes'] for h in hourly_data)
    total_threats = sum(h['sum']['threats'] for h in hourly_data)
    total_cached_requests = sum(h['sum']['cachedRequests'] for h in hourly_data)
    total_cached_bytes = sum(h['sum']['cachedBytes'] for h in hourly_data)
    total_unique_visitors = sum(h['uniq']['uniques'] for h in hourly_data)
    
    cache_hit_rate = (total_cached_requests / total_requests * 100) if total_requests > 0 else 0
    bandwidth_saved = (total_cached_bytes / total_bytes * 100) if total_bytes > 0 else 0
    
    report = []
    report.append("=" * 60)
    report.append("Cloudflare 流量分析报告")
    report.append(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    report.append(f"统计周期: 过去 24 小时")
    report.append("=" * 60)
    report.append("")
    
    report.append("【总体统计】")
    report.append(f"  总请求数: {total_requests:,}")
    report.append(f"  页面浏览: {total_page_views:,}")
    report.append(f"  独立访客: {total_unique_visitors:,}")
    report.append(f"  总带宽: {format_bytes(total_bytes)}")
    report.append(f"  威胁拦截: {total_threats:,}")
    report.append("")
    
    report.append("【缓存效率】")
    report.append(f"  缓存命中率: {cache_hit_rate:.1f}%")
    report.append(f"  节省带宽: {format_bytes(total_cached_bytes)} ({bandwidth_saved:.1f}%)")
    report.append("")
    
    # 按国家统计（复用相同的查询数据，这里简化处理）
    report.append("【访问来源 TOP 10】")
    country_data = zones_data.get('httpRequests1hGroups', [])
    # 注意：实际使用中需要单独的查询来获取按国家分组的数据
    report.append("  (需要额外的按国家分组查询)")
    report.append("")
    
    report.append("=" * 60)
    
    return "\n".join(report)

def main():
    print("正在获取分析数据...")
    data = fetch_analytics()
    
    if 'errors' in data and data['errors']:
        print(f"获取数据失败: {data['errors']}")
        return
    
    report = generate_report(data)
    print(report)
    
    # 可选：保存报告到文件
    with open(f"cf_report_{datetime.now().strftime('%Y%m%d')}.txt", 'w') as f:
        f.write(report)
    print("\n报告已保存到文件")

if __name__ == '__main__':
    main()
```

### 8.4 日志分析

Cloudflare 的实时日志（Logpush）功能可以将请求日志推送到外部存储，如 R2、S3、Azure Blob 等。虽然完整的 Logpush 需要企业套餐，但你可以使用 Workers 来实现简化版的日志记录：

```javascript
// 使用 Worker 记录请求日志
export default {
  async fetch(request, env, ctx) {
    const start = Date.now();
    
    // 收集请求信息
    const logEntry = {
      timestamp: new Date().toISOString(),
      method: request.method,
      url: request.url,
      headers: Object.fromEntries(request.headers),
      cf: {
        country: request.cf?.country,
        city: request.cf?.city,
        colo: request.cf?.colo,
        asn: request.cf?.asn
      }
    };
    
    // 处理请求
    const response = await fetch(request);
    
    // 记录响应信息
    logEntry.response = {
      status: response.status,
      duration: Date.now() - start
    };
    
    // 异步写入日志（使用 waitUntil 不阻塞响应）
    ctx.waitUntil(
      env.LOGS_KV.put(
        `log:${Date.now()}:${Math.random().toString(36).slice(2)}`,
        JSON.stringify(logEntry),
        { expirationTtl: 86400 }  // 24小时后过期
      )
    );
    
    return response;
  }
};
```

---

## 第九章 R2 对象存储

### 9.1 R2 简介

Cloudflare R2 是一个与 S3 兼容的对象存储服务。"R2" 这个名字暗示它是 S3 的替代品——在字母表中，R 在 S 之前，2 在 3 之前。

R2 的最大卖点是零出口费用。传统云存储服务（如 AWS S3）在你读取数据时会收取出口带宽费用，而 R2 完全免费。这对于需要频繁读取的应用（如 CDN 源站、公开文件托管）来说是巨大的成本优势。

**免费额度**包括：每月 10 GB 存储空间，每月 1000 万次 A 类操作（写入、列举），每月 1000 万次 B 类操作（读取），无出口带宽费用。

### 9.2 存储桶管理

R2 使用"存储桶"（Bucket）的概念来组织对象。每个存储桶是一个独立的命名空间。

**创建存储桶**：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/accounts/{account_id}/r2/buckets" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "name": "my-bucket",
       "locationHint": "apac"
     }'
```

`locationHint` 是可选的，用于指定存储桶的首选位置。可用的值包括 `wnam`（北美西部）、`enam`（北美东部）、`weur`（欧洲西部）、`eeur`（欧洲东部）、`apac`（亚太地区）。如果不指定，Cloudflare 会自动选择。

**列出所有存储桶**：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/accounts/{account_id}/r2/buckets" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

**删除存储桶**（必须为空）：

```bash
curl -X DELETE "https://api.cloudflare.com/client/v4/accounts/{account_id}/r2/buckets/{bucket_name}" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

### 9.3 S3 兼容 API

R2 提供与 AWS S3 兼容的 API，这意味着你可以使用现有的 S3 客户端库和工具来操作 R2。

首先需要创建 R2 API Token：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/user/tokens" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "name": "R2 Access Token",
       "policies": [
         {
           "effect": "allow",
           "resources": {
             "com.cloudflare.api.account.YOUR_ACCOUNT_ID": "*"
           },
           "permission_groups": [
             {"id": "r2_token_write_permission_group_id"}
           ]
         }
       ]
     }'
```

然后可以使用 AWS CLI 或任何 S3 客户端：

```bash
# 配置 AWS CLI 使用 R2
aws configure set aws_access_key_id YOUR_R2_ACCESS_KEY_ID
aws configure set aws_secret_access_key YOUR_R2_SECRET_ACCESS_KEY
aws configure set region auto

# 上传文件
aws s3 cp ./myfile.txt s3://my-bucket/myfile.txt \
    --endpoint-url https://YOUR_ACCOUNT_ID.r2.cloudflarestorage.com

# 列出文件
aws s3 ls s3://my-bucket/ \
    --endpoint-url https://YOUR_ACCOUNT_ID.r2.cloudflarestorage.com

# 下载文件
aws s3 cp s3://my-bucket/myfile.txt ./downloaded.txt \
    --endpoint-url https://YOUR_ACCOUNT_ID.r2.cloudflarestorage.com
```

使用 Python boto3 库的示例：

```python
import boto3
from botocore.config import Config

# 创建 R2 客户端
r2 = boto3.client(
    's3',
    endpoint_url=f'https://YOUR_ACCOUNT_ID.r2.cloudflarestorage.com',
    aws_access_key_id='YOUR_R2_ACCESS_KEY_ID',
    aws_secret_access_key='YOUR_R2_SECRET_ACCESS_KEY',
    config=Config(signature_version='s3v4'),
    region_name='auto'
)

# 上传文件
r2.upload_file('./local_file.txt', 'my-bucket', 'remote_file.txt')

# 上传带有自定义元数据
r2.upload_file(
    './image.jpg',
    'my-bucket',
    'images/photo.jpg',
    ExtraArgs={
        'ContentType': 'image/jpeg',
        'Metadata': {
            'author': 'John Doe',
            'description': 'A beautiful photo'
        }
    }
)

# 列出对象
response = r2.list_objects_v2(Bucket='my-bucket', Prefix='images/')
for obj in response.get('Contents', []):
    print(f"{obj['Key']} - {obj['Size']} bytes")

# 生成预签名 URL（用于临时授权访问）
url = r2.generate_presigned_url(
    'get_object',
    Params={'Bucket': 'my-bucket', 'Key': 'images/photo.jpg'},
    ExpiresIn=3600  # URL 有效期 1 小时
)
print(f"临时下载链接: {url}")

# 删除对象
r2.delete_object(Bucket='my-bucket', Key='remote_file.txt')
```

### 9.4 公开访问配置

如果你希望存储桶中的内容可以公开访问（例如作为 CDN 源站），需要配置公开访问。

**启用公开访问**：

```bash
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/{account_id}/r2/buckets/{bucket_name}/policy" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "statement": [
         {
           "effect": "allow",
           "action": ["s3:GetObject"],
           "principal": "*",
           "resource": ["my-bucket/*"]
         }
       ]
     }'
```

启用后，可以通过 `https://YOUR_ACCOUNT_ID.r2.cloudflarestorage.com/bucket-name/object-key` 访问对象。

更好的做法是将 R2 存储桶绑定到自定义域名，享受 Cloudflare CDN 的加速：

```bash
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/{account_id}/r2/buckets/{bucket_name}/custom_domain" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "zone_id": "YOUR_ZONE_ID",
       "hostname": "cdn.example.com"
     }'
```

### 9.5 与 Workers 集成

R2 可以与 Workers 深度集成，实现复杂的文件处理逻辑。

首先在 `wrangler.toml` 中绑定 R2：

```toml
name = "my-worker"
main = "src/index.js"

[[r2_buckets]]
binding = "MY_BUCKET"
bucket_name = "my-bucket"
```

然后在 Worker 代码中使用：

```javascript
export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const key = url.pathname.slice(1);  // 移除开头的斜杠
    
    switch (request.method) {
      case 'GET':
        // 获取对象
        const object = await env.MY_BUCKET.get(key);
        
        if (object === null) {
          return new Response('Object Not Found', { status: 404 });
        }
        
        // 设置响应头
        const headers = new Headers();
        object.writeHttpMetadata(headers);
        headers.set('etag', object.httpEtag);
        headers.set('Cache-Control', 'public, max-age=86400');
        
        return new Response(object.body, { headers });
      
      case 'PUT':
        // 上传对象
        const contentType = request.headers.get('Content-Type') || 'application/octet-stream';
        await env.MY_BUCKET.put(key, request.body, {
          httpMetadata: { contentType }
        });
        
        return new Response(`Object ${key} uploaded successfully`, { status: 201 });
      
      case 'DELETE':
        // 删除对象
        await env.MY_BUCKET.delete(key);
        return new Response(`Object ${key} deleted`, { status: 200 });
      
      default:
        return new Response('Method Not Allowed', { status: 405 });
    }
  }
};
```

---

## 第十章 KV 键值存储

### 10.1 KV 简介

Workers KV 是一个全球分布式的键值存储系统，专门为边缘计算场景设计。它的特点是读取速度极快（因为数据会被复制到全球所有边缘节点），但写入具有最终一致性（更新可能需要最多 60 秒才能在所有节点生效）。

这种特性使 KV 非常适合存储不频繁更新但需要频繁读取的数据，如配置信息、静态资源、用户会话等。

**免费额度**包括：每天 100,000 次读取操作，每天 1,000 次写入、删除、列举操作，1 GB 存储空间。

### 10.2 命名空间管理

KV 使用"命名空间"来组织数据，每个命名空间是一个独立的键值集合。

**创建命名空间**：

```bash
curl -X POST "https://api.cloudflare.com/client/v4/accounts/{account_id}/storage/kv/namespaces" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"title": "my-kv-namespace"}'
```

**列出所有命名空间**：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/accounts/{account_id}/storage/kv/namespaces" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

**删除命名空间**：

```bash
curl -X DELETE "https://api.cloudflare.com/client/v4/accounts/{account_id}/storage/kv/namespaces/{namespace_id}" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

### 10.3 键值操作

**写入键值对**：

```bash
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/{account_id}/storage/kv/namespaces/{namespace_id}/values/{key_name}" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: text/plain" \
     --data "这是值内容"
```

可以添加过期时间：

```bash
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/{account_id}/storage/kv/namespaces/{namespace_id}/values/{key_name}?expiration=1700000000" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: text/plain" \
     --data "临时数据"
```

`expiration` 是 Unix 时间戳（秒），也可以使用 `expiration_ttl` 指定从现在开始的秒数。

**读取值**：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/accounts/{account_id}/storage/kv/namespaces/{namespace_id}/values/{key_name}" \
     -H "Authorization: Bearer YOUR_API_TOKEN"
```

**批量写入**：

```bash
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/{account_id}/storage/kv/namespaces/{namespace_id}/bulk" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '[
       {"key": "key1", "value": "value1"},
       {"key": "key2", "value": "value2", "expiration_ttl": 3600},
       {"key": "key3", "value": "dmFsdWUz", "base64": true}
     ]'
```

**列出键**：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/accounts/{account_id}/storage/kv/namespaces/{namespace_id}/keys" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

可以使用 `prefix` 参数过滤键，使用 `limit` 和 `cursor` 参数分页：

```bash
curl -X GET "https://api.cloudflare.com/client/v4/accounts/{account_id}/storage/kv/namespaces/{namespace_id}/keys?prefix=user:&limit=100" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json"
```

### 10.4 在 Workers 中使用 KV

首先在 `wrangler.toml` 中绑定 KV 命名空间：

```toml
name = "my-worker"
main = "src/index.js"

[[kv_namespaces]]
binding = "MY_KV"
id = "YOUR_NAMESPACE_ID"
```

然后在代码中使用：

```javascript
export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    
    // 简单的键值 API
    if (url.pathname.startsWith('/kv/')) {
      const key = url.pathname.slice(4);
      
      if (request.method === 'GET') {
        // 读取值
        const value = await env.MY_KV.get(key);
        if (value === null) {
          return new Response('Key not found', { status: 404 });
        }
        return new Response(value);
      }
      
      if (request.method === 'PUT') {
        // 写入值
        const value = await request.text();
        await env.MY_KV.put(key, value);
        return new Response('OK', { status: 201 });
      }
      
      if (request.method === 'DELETE') {
        // 删除键
        await env.MY_KV.delete(key);
        return new Response('Deleted');
      }
    }
    
    // 读取 JSON 数据
    if (url.pathname === '/config') {
      const config = await env.MY_KV.get('app_config', { type: 'json' });
      return Response.json(config || {});
    }
    
    // 读取带元数据的值
    if (url.pathname === '/with-metadata') {
      const { value, metadata } = await env.MY_KV.getWithMetadata('some_key');
      return Response.json({ value, metadata });
    }
    
    return new Response('Not Found', { status: 404 });
  }
};
```

### 10.5 实战案例：访问计数器

```javascript
export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const page = url.pathname;
    
    // 获取当前计数
    const countKey = `pageview:${page}`;
    let count = await env.MY_KV.get(countKey, { type: 'json' }) || 0;
    
    // 增加计数
    count++;
    
    // 使用 waitUntil 异步写入，不阻塞响应
    ctx.waitUntil(
      env.MY_KV.put(countKey, JSON.stringify(count))
    );
    
    // 返回包含计数的响应
    const response = await fetch(request);
    
    // 如果是 HTML 响应，注入访问计数
    const contentType = response.headers.get('Content-Type') || '';
    if (contentType.includes('text/html')) {
      let html = await response.text();
      
      // 在页面底部注入计数器
      const counterHtml = `
        <div style="position: fixed; bottom: 10px; right: 10px; 
                    background: #333; color: #fff; padding: 10px; 
                    border-radius: 5px; font-size: 14px;">
          本页访问次数: ${count}
        </div>
      `;
      
      html = html.replace('</body>', `${counterHtml}</body>`);
      
      return new Response(html, {
        status: response.status,
        headers: response.headers
      });
    }
    
    return response;
  }
};
```

---

## 第十一章 最佳实践与常见问题

### 11.1 API Token 安全最佳实践

API Token 是访问你 Cloudflare 资源的钥匙，必须妥善保管。以下是一些安全建议：

**最小权限原则**：每个 Token 只授予完成其任务所需的最少权限。如果一个脚本只需要读取 DNS 记录，就不要给它写入权限。如果只需要操作特定域名，就不要授权访问所有域名。

**Token 轮换**：定期更换 Token，特别是在团队成员离开、怀疑泄露或者长时间未使用后。创建新 Token 后确认新 Token 正常工作，然后再删除旧 Token。

**环境隔离**：为开发、测试、生产环境使用不同的 Token。这样即使开发环境的 Token 泄露，也不会影响生产环境。

**安全存储**：不要将 Token 硬编码在代码中或提交到版本控制系统。使用环境变量、密钥管理服务（如 Vault、AWS Secrets Manager）或 CI/CD 平台的 Secrets 功能。

**监控和审计**：定期检查 Token 的使用情况。Cloudflare 提供了 Audit Logs 功能，可以查看 API 调用记录。

### 11.2 错误处理模式

健壮的错误处理是生产级代码的必要组成部分。以下是一个完整的错误处理示例：

```python
import requests
import logging
from dataclasses import dataclass
from typing import Optional, Any, Dict
from enum import Enum

class CloudflareErrorCode(Enum):
    """常见的 Cloudflare 错误代码"""
    AUTHENTICATION_ERROR = 10000
    INVALID_TOKEN = 10001
    ZONE_NOT_FOUND = 1001
    RECORD_NOT_FOUND = 81044
    RATE_LIMITED = 10029

@dataclass
class CloudflareError(Exception):
    """Cloudflare API 错误"""
    code: int
    message: str
    
    def __str__(self):
        return f"CloudflareError {self.code}: {self.message}"

class CloudflareClient:
    """Cloudflare API 客户端"""
    
    def __init__(self, api_token: str):
        self.base_url = "https://api.cloudflare.com/client/v4"
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {api_token}",
            "Content-Type": "application/json"
        })
        self.logger = logging.getLogger(__name__)
    
    def _handle_response(self, response: requests.Response) -> Dict[str, Any]:
        """统一处理 API 响应"""
        try:
            data = response.json()
        except ValueError:
            raise CloudflareError(
                code=-1,
                message=f"Invalid JSON response: {response.text[:200]}"
            )
        
        # 检查 HTTP 状态码
        if response.status_code == 429:
            retry_after = response.headers.get('Retry-After', 60)
            raise CloudflareError(
                code=CloudflareErrorCode.RATE_LIMITED.value,
                message=f"Rate limited. Retry after {retry_after} seconds"
            )
        
        # 检查 API 级别错误
        if not data.get('success', False):
            errors = data.get('errors', [])
            if errors:
                error = errors[0]
                raise CloudflareError(
                    code=error.get('code', -1),
                    message=error.get('message', 'Unknown error')
                )
            raise CloudflareError(code=-1, message='Unknown error occurred')
        
        return data
    
    def get(self, endpoint: str, params: Optional[Dict] = None) -> Dict[str, Any]:
        """发送 GET 请求"""
        url = f"{self.base_url}/{endpoint}"
        self.logger.debug(f"GET {url}")
        
        response = self.session.get(url, params=params)
        return self._handle_response(response)
    
    def post(self, endpoint: str, data: Dict) -> Dict[str, Any]:
        """发送 POST 请求"""
        url = f"{self.base_url}/{endpoint}"
        self.logger.debug(f"POST {url}")
        
        response = self.session.post(url, json=data)
        return self._handle_response(response)
    
    def put(self, endpoint: str, data: Dict) -> Dict[str, Any]:
        """发送 PUT 请求"""
        url = f"{self.base_url}/{endpoint}"
        self.logger.debug(f"PUT {url}")
        
        response = self.session.put(url, json=data)
        return self._handle_response(response)
    
    def delete(self, endpoint: str) -> Dict[str, Any]:
        """发送 DELETE 请求"""
        url = f"{self.base_url}/{endpoint}"
        self.logger.debug(f"DELETE {url}")
        
        response = self.session.delete(url)
        return self._handle_response(response)

# 使用示例
def main():
    logging.basicConfig(level=logging.INFO)
    
    client = CloudflareClient("YOUR_API_TOKEN")
    
    try:
        # 获取区域列表
        zones = client.get("zones")
        print(f"找到 {len(zones['result'])} 个区域")
        
    except CloudflareError as e:
        if e.code == CloudflareErrorCode.AUTHENTICATION_ERROR.value:
            print("认证失败，请检查 API Token")
        elif e.code == CloudflareErrorCode.RATE_LIMITED.value:
            print("请求过于频繁，请稍后重试")
        else:
            print(f"API 错误: {e}")
    except requests.RequestException as e:
        print(f"网络错误: {e}")

if __name__ == '__main__':
    main()
```

### 11.3 性能优化技巧

**批量操作**：当需要执行多个相关操作时，优先使用批量 API 而不是逐个调用。例如，使用 KV 的 `bulk` 端点一次写入多个键值对，而不是多次调用 `values` 端点。

**合理使用缓存**：充分利用 Cloudflare 的缓存能力可以显著减少源站负载和提升响应速度。为静态资源设置适当的缓存控制头，配置缓存规则覆盖更多内容类型。

**异步处理**：在 Workers 中，使用 `ctx.waitUntil()` 将非关键操作（如日志记录、分析统计）放到响应返回之后执行，减少用户感知的延迟。

**减少数据传输**：只请求需要的字段。使用 GraphQL Analytics API 时，只查询需要的数据维度。在请求中使用适当的过滤条件减少返回的数据量。

### 11.4 调试技巧

**使用测试环境**：Cloudflare 的某些功能支持预览/开发模式。Workers 可以使用 `wrangler dev` 在本地测试；Pages 的每个提交都会生成预览 URL。

**启用详细日志**：在开发阶段，可以在 Workers 中添加详细的日志输出：

```javascript
export default {
  async fetch(request, env, ctx) {
    console.log('Request URL:', request.url);
    console.log('Request Headers:', Object.fromEntries(request.headers));
    console.log('CF Properties:', JSON.stringify(request.cf, null, 2));
    
    const response = await fetch(request);
    
    console.log('Response Status:', response.status);
    console.log('Response Headers:', Object.fromEntries(response.headers));
    
    return response;
  }
};
```

这些日志可以在 Workers 仪表板的"日志"标签中查看（实时日志需要在页面打开时才能捕获）。

**使用 curl 调试**：curl 的 `-v` 参数可以显示详细的请求/响应信息，`-w` 参数可以输出时间统计：

```bash
curl -v -X GET "https://api.cloudflare.com/client/v4/user" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     -w "\n\nTime: %{time_total}s\n"
```

### 11.5 常见问题解答

**Q: 为什么我的 DNS 记录更新后没有立即生效？**

DNS 记录的更新需要考虑 TTL（生存时间）。如果之前的记录 TTL 是 3600 秒（1 小时），那么即使你更新了记录，旧的解析结果可能仍会被各级 DNS 服务器缓存最多 1 小时。如果需要频繁更新（如 DDNS 场景），建议设置较短的 TTL，如 120 秒。

**Q: 免费套餐的 Workers 请求限制是如何计算的？**

每天 100,000 个请求是按账户计算的，而不是按单个 Worker。如果你有多个 Workers，它们共享这个配额。这个限制在 UTC 时间 00:00 重置。此外，还有 10ms CPU 时间限制，这是指实际的 CPU 执行时间，不包括等待 I/O（如 fetch 请求）的时间。

**Q: 如何处理跨域请求（CORS）？**

Cloudflare 本身不会自动处理 CORS，但你可以通过 Workers 或 Transform Rules 添加 CORS 头：

```javascript
// Workers 处理 CORS
export default {
  async fetch(request, env, ctx) {
    // 处理预检请求
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Access-Control-Max-Age': '86400'
        }
      });
    }
    
    // 正常请求
    const response = await fetch(request);
    const newResponse = new Response(response.body, response);
    newResponse.headers.set('Access-Control-Allow-Origin', '*');
    return newResponse;
  }
};
```

**Q: R2 和 KV 应该选择哪个？**

这取决于你的使用场景。KV 适合存储小型数据（每个值最大 25 MB）、需要极快读取速度、可以接受最终一致性的场景。典型用例：配置数据、会话信息、缓存。R2 适合存储大型文件（无大小限制）、需要 S3 兼容性、需要强一致性的场景。典型用例：静态资源托管、用户上传文件、数据备份。

**Q: 如何估算我的用量是否会超出免费额度？**

可以使用 Analytics API 获取历史用量数据，然后预测未来需求。关键指标包括每日请求数（对于 Workers）、存储空间使用量（对于 R2/KV）、每月构建次数（对于 Pages）。建议在达到免费额度 80% 时就开始评估是否需要升级。

---

## 总结

本教程全面介绍了 Cloudflare API 中免费或具有免费额度的核心功能。让我们回顾关键要点：

**DNS 管理**是最基础也是最常用的功能，支持无限域名和记录，是自动化域名管理的基础。

**CDN 和缓存**提供免费的全球加速，通过合理配置缓存规则可以显著提升网站性能和减轻服务器负载。

**Workers**将无服务器计算带到边缘网络，每天 100,000 次免费请求足以支撑许多轻量级应用。

**Pages**是托管静态网站和 JAMstack 应用的理想选择，无限站点、无限带宽的配置非常适合个人开发者。

**安全功能**包括免费的 DDoS 防护、SSL 证书和基础 WAF，为你的网站提供企业级保护。

**R2 和 KV**提供了灵活的存储选项，分别适用于大文件存储和快速键值访问场景。

掌握这些 API，你就能够自动化管理云基础设施、构建高效的 DevOps 工作流、开发边缘计算应用，同时将成本控制在最低限度。

作为下一步，建议你从一个简单的项目开始实践，比如为你的个人域名设置自动化 DDNS，或者部署一个静态博客到 Pages。随着经验的积累，逐步探索更复杂的功能组合。

