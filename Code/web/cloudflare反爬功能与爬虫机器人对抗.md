[toc]

# 多 WordPress 站点的 Cloudflare 防护方案

## 场景分析

```
你的情况：
├── 1 台服务器
├── N 个 WordPress 站点
├── 每个站点可能有不同域名
└── 需要统一管理 + 成本控制
```

---

## 一、方案对比

| 方案                           | 成本      | 管理复杂度 | 防护效果 | 适合场景           |
| ------------------------------ | --------- | ---------- | -------- | ------------------ |
| A. 每站点独立 Cloudflare 账户  | 免费      | 高         | ⭐⭐⭐⭐     | 站点少（<5个）     |
| B. 一个账户管理所有站点        | 免费      | 中         | ⭐⭐⭐⭐     | 站点中等（5-20个） |
| C. Cloudflare + 统一 OpenResty | 免费      | 低         | ⭐⭐⭐⭐⭐    | 站点多（20+）      |
| D. Cloudflare Pro 账户         | $20/站/月 | 低         | ⭐⭐⭐⭐⭐    | 高价值站点         |

---

## 二、推荐方案：B + C 混合

### 架构图

```
                         ┌─────────────────────────────────────┐
                         │         Cloudflare (免费)           │
                         │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐   │
                         │  │site1│ │site2│ │site3│ │ ... │   │
                         │  └──┬──┘ └──┬──┘ └──┬──┘ └──┬──┘   │
                         │     │       │       │       │       │
                         │     └───────┴───────┴───────┘       │
                         │              │                       │
                         │     Bot Fight + WAF + Turnstile     │
                         └──────────────┬──────────────────────┘
                                        │
                         ┌──────────────▼──────────────────────┐
                         │     OpenResty (统一防护层)           │
                         │  ┌─────────────────────────────┐    │
                         │  │  通用防护配置（所有站点共享）  │    │
                         │  │  - 速率限制                  │    │
                         │  │  - 通用 WAF 规则             │    │
                         │  │  - Turnstile 验证            │    │
                         │  └─────────────────────────────┘    │
                         └──────────────┬──────────────────────┘
                                        │
                    ┌───────────────────┼───────────────────┐
                    │                   │                   │
             ┌──────▼──────┐     ┌──────▼──────┐     ┌──────▼──────┐
             │  WordPress  │     │  WordPress  │     │  WordPress  │
             │   Site 1    │     │   Site 2    │     │   Site N    │
             └─────────────┘     └─────────────┘     └─────────────┘
```

---

## 三、Cloudflare 统一管理配置

### Step 1：添加所有站点到同一账户

```
Cloudflare Dashboard → Add a Site → 逐个添加域名
```

**批量添加技巧：**
- 使用 Cloudflare API 批量添加
- 使用 Terraform 管理（推荐）

```bash
# 使用 API 批量添加站点
for domain in site1.com site2.com site3.com; do
  curl -X POST "https://api.cloudflare.com/client/v4/zones" \
    -H "Authorization: Bearer YOUR_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"name\":\"$domain\",\"account\":{\"id\":\"YOUR_ACCOUNT_ID\"}}"
done
```

### Step 2：创建通用配置模板

**使用 Cloudflare Ruleset API 批量应用规则：**

```bash
# 创建账户级规则（应用到所有站点）
curl -X POST "https://api.cloudflare.com/client/v4/accounts/YOUR_ACCOUNT_ID/rulesets" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "name": "WordPress Protection",
    "kind": "custom",
    "phase": "http_request_firewall_custom",
    "rules": [
      {
        "action": "block",
        "expression": "(http.request.uri.path contains \"/xmlrpc.php\")",
        "description": "Block XMLRPC"
      },
      {
        "action": "managed_challenge",
        "expression": "(http.request.uri.path contains \"/wp-login.php\") and (cf.threat_score gt 5)",
        "description": "Protect WP Login"
      }
    ]
  }'
```

### Step 3：创建共享 Turnstile Widget

```
Cloudflare Dashboard → Turnstile → Add Widget

配置：
- Name: WordPress Sites Protection
- Domains: 添加所有域名
  - site1.com
  - site2.com
  - site3.com
  - ...
- Mode: Managed
```

**一个 Turnstile Widget 可以关联多个域名！**

---

## 四、OpenResty 统一配置

### 目录结构

```
/www/server/nginx/conf/
├── nginx.conf                      # 主配置
├── common/
│   ├── cloudflare_ips.conf         # Cloudflare IP 白名单
│   ├── security_common.conf        # 通用安全配置
│   ├── turnstile.conf              # Turnstile 验证
│   └── rate_limit.conf             # 速率限制
├── sites/
│   ├── site1.com.conf
│   ├── site2.com.conf
│   └── ...
└── lua/
    ├── turnstile.lua
    └── security.lua
```

### 1. 主配置 nginx.conf

```nginx
# /www/server/nginx/conf/nginx.conf

http {
    # ============================================
    # 共享字典（所有站点共用）
    # ============================================
    lua_shared_dict turnstile_cache 10m;      # Turnstile 验证缓存
    lua_shared_dict rate_limit 50m;           # 速率限制
    lua_shared_dict bot_cache 20m;            # Bot 验证缓存
    
    # Lua 模块路径
    lua_package_path "/www/server/nginx/conf/lua/?.lua;;";
    
    # ============================================
    # 通用变量
    # ============================================
    
    # Turnstile 密钥（所有站点共享）
    lua_shared_dict config 1m;
    init_by_lua_block {
        local config = ngx.shared.config
        config:set("turnstile_secret", "你的Turnstile密钥")
    }
    
    # 包含 Cloudflare IP
    include /www/server/nginx/conf/common/cloudflare_ips.conf;
    
    # 包含各站点配置
    include /www/server/nginx/conf/sites/*.conf;
}
```

### 2. Cloudflare IP 配置

```nginx
# /www/server/nginx/conf/common/cloudflare_ips.conf

# Cloudflare IPv4
set_real_ip_from 103.21.244.0/22;
set_real_ip_from 103.22.200.0/22;
set_real_ip_from 103.31.4.0/22;
set_real_ip_from 104.16.0.0/13;
set_real_ip_from 104.24.0.0/14;
set_real_ip_from 108.162.192.0/18;
set_real_ip_from 131.0.72.0/22;
set_real_ip_from 141.101.64.0/18;
set_real_ip_from 162.158.0.0/15;
set_real_ip_from 172.64.0.0/13;
set_real_ip_from 173.245.48.0/20;
set_real_ip_from 188.114.96.0/20;
set_real_ip_from 190.93.240.0/20;
set_real_ip_from 197.234.240.0/22;
set_real_ip_from 198.41.128.0/17;

# Cloudflare IPv6
set_real_ip_from 2400:cb00::/32;
set_real_ip_from 2606:4700::/32;
set_real_ip_from 2803:f800::/32;
set_real_ip_from 2405:b500::/32;
set_real_ip_from 2405:8100::/32;
set_real_ip_from 2c0f:f248::/32;
set_real_ip_from 2a06:98c0::/29;

real_ip_header CF-Connecting-IP;
```

### 3. 通用安全配置

```nginx
# /www/server/nginx/conf/common/security_common.conf

# ============================================
# WordPress 通用安全规则
# ============================================

# 阻止直接访问敏感文件
location ~* ^/(wp-config\.php|readme\.html|license\.txt) {
    deny all;
}

# 阻止 PHP 执行在上传目录
location ~* /wp-content/uploads/.*\.php$ {
    deny all;
}

# 阻止访问隐藏文件
location ~ /\. {
    deny all;
}

# XMLRPC 阻止（Cloudflare 可能已阻止，这是备用）
location = /xmlrpc.php {
    deny all;
}

# ============================================
# 速率限制区域定义
# ============================================
limit_req_zone $binary_remote_addr zone=wp_login:10m rate=5r/m;
limit_req_zone $binary_remote_addr zone=wp_admin:10m rate=30r/m;
limit_req_zone $binary_remote_addr zone=wc_checkout:10m rate=10r/m;
limit_req_zone $binary_remote_addr zone=general:50m rate=50r/s;

# ============================================
# Cloudflare 验证状态
# ============================================
map $http_cf_verified_bot $is_verified_bot {
    default 0;
    "true"  1;
}
```

### 4. Turnstile 验证模块

```lua
-- /www/server/nginx/conf/lua/turnstile.lua

local _M = {}

local http = require "resty.http"
local cjson = require "cjson.safe"

-- 验证 Turnstile token
function _M.verify(token, ip)
    if not token or token == "" then
        return false, "missing token"
    end
    
    -- 检查缓存
    local cache = ngx.shared.turnstile_cache
    local cache_key = ngx.md5(token)
    local cached = cache:get(cache_key)
    if cached == "1" then
        return true
    elseif cached == "0" then
        return false, "cached failure"
    end
    
    -- 获取密钥
    local config = ngx.shared.config
    local secret = config:get("turnstile_secret")
    if not secret then
        return false, "missing secret"
    end
    
    -- 调用 API 验证
    local httpc = http.new()
    httpc:set_timeout(5000)
    
    local res, err = httpc:request_uri("https://challenges.cloudflare.com/turnstile/v0/siteverify", {
        method = "POST",
        body = ngx.encode_args({
            secret = secret,
            response = token,
            remoteip = ip or ngx.var.remote_addr
        }),
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded"
        }
    })
    
    if not res then
        return false, "api error: " .. (err or "unknown")
    end
    
    local data = cjson.decode(res.body)
    if data and data.success then
        cache:set(cache_key, "1", 1800)  -- 缓存30分钟
        return true
    end
    
    cache:set(cache_key, "0", 60)  -- 失败缓存1分钟
    return false, "verification failed"
end

-- 设置验证 Cookie
function _M.set_cookie(domain)
    local base = domain:match("([^.]+%.[^.]+)$")
    local domain_attr = ""
    if base and base ~= domain then
        domain_attr = "; Domain=." .. base
    end
    
    local cookie = string.format(
        "cf_verified=1; Path=/; HttpOnly; SameSite=Lax; Max-Age=1800%s",
        domain_attr
    )
    
    if ngx.var.scheme == "https" then
        cookie = cookie .. "; Secure"
    end
    
    ngx.header["Set-Cookie"] = cookie
end

-- 检查是否已验证
function _M.is_verified()
    return ngx.var.cookie_cf_verified == "1"
end

return _M
```

### 5. 通用安全处理模块

```lua
-- /www/server/nginx/conf/lua/security.lua

local _M = {}

local turnstile = require "turnstile"

-- 速率限制检查
function _M.check_rate_limit(zone_name, limit, window)
    local dict = ngx.shared.rate_limit
    local key = zone_name .. ":" .. ngx.var.remote_addr
    
    local count, err = dict:incr(key, 1, 0, window)
    if count and count > limit then
        return false, count
    end
    return true, count
end

-- WordPress 敏感路径保护
function _M.protect_wp_path()
    local uri = ngx.var.request_uri
    local method = ngx.req.get_method()
    
    -- WP Login 保护
    if uri:find("/wp%-login%.php") then
        -- 速率限制
        local ok, count = _M.check_rate_limit("wp_login", 5, 60)
        if not ok then
            ngx.log(ngx.WARN, "Rate limit exceeded for wp-login: ", ngx.var.remote_addr)
            return ngx.exit(429)
        end
        
        -- POST 请求需要额外验证
        if method == "POST" and not turnstile.is_verified() then
            -- 允许正常登录流程，但记录
            ngx.log(ngx.INFO, "WP login attempt: ", ngx.var.remote_addr)
        end
    end
    
    -- WP Admin 保护
    if uri:find("/wp%-admin/") and not uri:find("/wp%-admin/admin%-ajax%.php") then
        local ok, count = _M.check_rate_limit("wp_admin", 60, 60)
        if not ok then
            return ngx.exit(429)
        end
    end
    
    return true
end

-- WooCommerce 保护
function _M.protect_wc_path()
    local uri = ngx.var.request_uri
    
    -- Checkout 保护
    if uri:find("/checkout") then
        -- 必须验证
        if not turnstile.is_verified() then
            -- 重定向到验证页
            local redirect = ngx.escape_uri(ngx.var.request_uri)
            return ngx.redirect("/security-check?redirect=" .. redirect)
        end
        
        -- 速率限制
        local ok = _M.check_rate_limit("wc_checkout", 20, 60)
        if not ok then
            return ngx.exit(429)
        end
    end
    
    return true
end

-- 验证页面
function _M.challenge_page()
    local redirect = ngx.var.arg_redirect or "/"
    
    ngx.header["Content-Type"] = "text/html; charset=utf-8"
    ngx.header["Cache-Control"] = "no-store"
    
    ngx.say(string.format([[
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>安全验证</title>
    <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            text-align: center;
            max-width: 400px;
            width: 100%%;
        }
        .icon { font-size: 48px; margin-bottom: 20px; }
        h1 { color: #333; font-size: 24px; margin-bottom: 10px; }
        p { color: #666; margin-bottom: 30px; line-height: 1.6; }
        .cf-turnstile { display: flex; justify-content: center; }
        .loading { color: #999; font-size: 14px; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">🔒</div>
        <h1>安全验证</h1>
        <p>请完成以下验证以继续访问<br>这有助于保护网站免受恶意访问</p>
        <form action="/security-verify" method="POST" id="verify-form">
            <input type="hidden" name="redirect" value="%s">
            <div class="cf-turnstile" 
                 data-sitekey="你的Turnstile站点密钥" 
                 data-callback="onVerify"
                 data-theme="light"></div>
        </form>
        <p class="loading" id="loading" style="display:none;">验证中，请稍候...</p>
    </div>
    <script>
        function onVerify(token) {
            document.getElementById('loading').style.display = 'block';
            document.getElementById('verify-form').submit();
        }
    </script>
</body>
</html>
    ]], redirect))
end

-- 验证回调处理
function _M.verify_callback()
    if ngx.req.get_method() ~= "POST" then
        return ngx.exit(405)
    end
    
    ngx.req.read_body()
    local args = ngx.req.get_post_args()
    local token = args["cf-turnstile-response"]
    local redirect = args["redirect"] or "/"
    
    -- 安全检查 redirect
    if not redirect:match("^/") then
        redirect = "/"
    end
    
    local ok, err = turnstile.verify(token)
    if ok then
        turnstile.set_cookie(ngx.var.host)
        return ngx.redirect(redirect)
    end
    
    ngx.log(ngx.WARN, "Turnstile verification failed: ", err)
    ngx.status = 403
    ngx.header["Content-Type"] = "text/html; charset=utf-8"
    ngx.say([[
        <html><body style="text-align:center;padding:50px;">
        <h1>验证失败</h1>
        <p>请<a href="javascript:history.back()">返回重试</a></p>
        </body></html>
    ]])
end

return _M
```

### 6. 站点配置模板

```nginx
# /www/server/nginx/conf/sites/site1.com.conf

server {
    listen 80;
    listen 443 ssl http2;
    server_name site1.com www.site1.com;
    
    root /www/wwwroot/site1.com;
    index index.php index.html;
    
    # SSL 配置
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    # 包含通用安全配置
    include /www/server/nginx/conf/common/security_common.conf;
    
    # ============================================
    # 安全验证入口
    # ============================================
    
    # 验证页面
    location = /security-check {
        content_by_lua_block {
            local security = require "security"
            security.challenge_page()
        }
    }
    
    # 验证回调
    location = /security-verify {
        content_by_lua_block {
            local security = require "security"
            security.verify_callback()
        }
    }
    
    # ============================================
    # WordPress 保护
    # ============================================
    
    location ~ ^/wp-login\.php$ {
        limit_req zone=wp_login burst=3 nodelay;
        
        access_by_lua_block {
            local security = require "security"
            security.protect_wp_path()
        }
        
        include fastcgi_params;
        fastcgi_pass unix:/tmp/php-cgi.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
    
    # ============================================
    # WooCommerce 保护（如果是电商站）
    # ============================================
    
    location ~ ^/(checkout|cart|my-account)/ {
        access_by_lua_block {
            local security = require "security"
            security.protect_wc_path()
        }
        
        try_files $uri $uri/ /index.php?$args;
    }
    
    # ============================================
    # 产品页保护（可选）
    # ============================================
    
    location ~ ^/(product|shop|category)/ {
        access_by_lua_block {
            -- 已验证的 bot 放行
            if ngx.var.http_cf_verified_bot == "true" then
                return
            end
            
            -- 其他正常处理
            local security = require "security"
            local ok = security.check_rate_limit("general", 100, 1)
            if not ok then
                return ngx.exit(429)
            end
        }
        
        try_files $uri $uri/ /index.php?$args;
    }
    
    # ============================================
    # 静态资源
    # ============================================
    
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|webp|woff|woff2)$ {
        expires 30d;
        access_log off;
        add_header Cache-Control "public, immutable";
    }
    
    # ============================================
    # PHP 处理
    # ============================================
    
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/tmp/php-cgi.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_intercept_errors on;
    }
    
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
}
```

---

## 五、批量管理脚本

### 1. 新站点快速部署脚本

```bash
#!/bin/bash
# /www/server/scripts/add_site.sh

DOMAIN=$1
ROOT_PATH=$2

if [ -z "$DOMAIN" ] || [ -z "$ROOT_PATH" ]; then
    echo "Usage: $0 <domain> <root_path>"
    exit 1
fi

# 创建站点配置
cat > /www/server/nginx/conf/sites/${DOMAIN}.conf << EOF
server {
    listen 80;
    listen 443 ssl http2;
    server_name ${DOMAIN} www.${DOMAIN};
    
    root ${ROOT_PATH};
    index index.php index.html;
    
    # 包含通用安全配置
    include /www/server/nginx/conf/common/security_common.conf;
    
    # 验证页面
    location = /security-check {
        content_by_lua_block {
            local security = require "security"
            security.challenge_page()
        }
    }
    
    location = /security-verify {
        content_by_lua_block {
            local security = require "security"
            security.verify_callback()
        }
    }
    
    # WordPress 保护
    location ~ ^/wp-login\.php\$ {
        limit_req zone=wp_login burst=3 nodelay;
        include fastcgi_params;
        fastcgi_pass unix:/tmp/php-cgi.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
    
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|webp|woff|woff2)\$ {
        expires 30d;
        access_log off;
    }
    
    location ~ \.php\$ {
        include fastcgi_params;
        fastcgi_pass unix:/tmp/php-cgi.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
    
    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }
}
EOF

echo "Site config created: /www/server/nginx/conf/sites/${DOMAIN}.conf"

# 测试配置
nginx -t && nginx -s reload

echo "Done! Don't forget to:"
echo "1. Add ${DOMAIN} to Cloudflare"
echo "2. Add ${DOMAIN} to Turnstile widget domains"
```

### 2. 批量更新 Cloudflare 规则

```python
#!/usr/bin/env python3
# /www/server/scripts/update_cf_rules.py

import requests
import json

API_TOKEN = "your_cloudflare_api_token"
ACCOUNT_ID = "your_account_id"

HEADERS = {
    "Authorization": f"Bearer {API_TOKEN}",
    "Content-Type": "application/json"
}

# 通用 WAF 规则
RULES = [
    {
        "action": "block",
        "expression": '(http.request.uri.path contains "/xmlrpc.php")',
        "description": "Block XMLRPC"
    },
    {
        "action": "managed_challenge",
        "expression": '(http.request.uri.path contains "/wp-login.php") and (cf.threat_score gt 5)',
        "description": "Protect WP Login"
    },
    {
        "action": "block",
        "expression": '(http.user_agent contains "Googlebot") and (not cf.client.bot)',
        "description": "Block Fake Googlebot"
    },
    {
        "action": "managed_challenge",
        "expression": '(http.request.uri.path contains "/checkout") and (not cf.client.bot)',
        "description": "Protect Checkout"
    },
    {
        "action": "block",
        "expression": '(http.request.uri.path contains "/wp-content/uploads/") and (http.request.uri.path contains ".php")',
        "description": "Block PHP in uploads"
    }
]

def get_zones():
    """获取所有域名"""
    resp = requests.get(
        f"https://api.cloudflare.com/client/v4/zones",
        headers=HEADERS,
        params={"account.id": ACCOUNT_ID, "per_page": 50}
    )
    return resp.json().get("result", [])

def update_zone_rules(zone_id, zone_name):
    """更新域名的 WAF 规则"""
    # 获取现有规则集
    resp = requests.get(
        f"https://api.cloudflare.com/client/v4/zones/{zone_id}/rulesets",
        headers=HEADERS
    )
    
    rulesets = resp.json().get("result", [])
    custom_ruleset = None
    
    for rs in rulesets:
        if rs.get("phase") == "http_request_firewall_custom":
            custom_ruleset = rs
            break
    
    if custom_ruleset:
        # 更新现有规则集
        resp = requests.put(
            f"https://api.cloudflare.com/client/v4/zones/{zone_id}/rulesets/{custom_ruleset['id']}",
            headers=HEADERS,
            json={"rules": RULES}
        )
    else:
        # 创建新规则集
        resp = requests.post(
            f"https://api.cloudflare.com/client/v4/zones/{zone_id}/rulesets",
            headers=HEADERS,
            json={
                "name": "WordPress Protection",
                "kind": "zone",
                "phase": "http_request_firewall_custom",
                "rules": RULES
            }
        )
    
    if resp.status_code in [200, 201]:
        print(f"✓ Updated rules for {zone_name}")
    else:
        print(f"✗ Failed to update {zone_name}: {resp.text}")

def main():
    zones = get_zones()
    print(f"Found {len(zones)} zones")
    
    for zone in zones:
        update_zone_rules(zone["id"], zone["name"])

if __name__ == "__main__":
    main()
```



---

## 七、最终推荐配置

```
每个站点配置：
├── Cloudflare (免费)
│   ├── Bot Fight Mode: ✅ 开启
│   ├── Security Level: Medium
│   ├── Browser Integrity Check: ✅ 开启
│   ├── WAF Rules: 5条共享规则
│   └── Turnstile: 共享 Widget
│
└── OpenResty (统一配置)
    ├── 通用安全规则 (include)
    ├── Turnstile 验证 (Lua 模块)
    ├── 速率限制 (共享字典)
    └── 站点配置模板 (快速部署)
```

