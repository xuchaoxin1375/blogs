[toc]



## OpenResty Js挑战反脚本爬虫方案

nginx原版难以实现复杂的客户端校验需求,这里介绍基于openresty的参考方案.

## 架构设计

```
┌─────────────────────────────────────────────────────────────────┐
│                    OpenResty 多层防护架构                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  第 1 层：请求特征检测（Lua）                                    │
│  ├── Header 完整性验证                                          │
│  ├── Header 顺序检测                                            │
│  ├── TLS 指纹分析                                               │
│  └── 请求模式分析                                               │
│                                                                 │
│  第 2 层：动态挑战系统                                           │
│  ├── 服务端生成加密挑战                                          │
│  ├── 客户端必须解密并计算                                        │
│  └── 服务端验证解答                                             │
│                                                                 │
│  第 3 层：Token 时效验证                                         │
│  ├── 精确时间戳过期检查                                          │
│  ├── 服务端签名验证                                             │
│  └── IP 绑定验证                                                │
│                                                                 │
│  第 4 层：行为分析                                               │
│  ├── 请求频率分析                                               │
│  ├── 访问模式分析                                               │
│  └── 异常检测                                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 文件结构

```
/www/server/nginx/
├── conf/
│   └── com_antibot.conf          # 主配置
├── lua/
│   ├── antibot/
│   │   ├── init.lua              # 初始化
│   │   ├── config.lua            # 配置
│   │   ├── utils.lua             # 工具函数
│   │   ├── crypto.lua            # 加密解密
│   │   ├── detector.lua          # 检测逻辑
│   │   ├── challenge.lua         # 挑战生成
│   │   └── validator.lua         # 验证逻辑
│   └── resty/
│       └── sha256.lua            # SHA256 库（如需要）
└── html/
    └── challenge.html            # 挑战页面
```

---

## 步骤 1：创建 Lua 模块

### config.lua

```lua
-- /www/server/nginx/lua/antibot/config.lua

local _M = {}

-- 密钥配置（生产环境应从环境变量读取）
_M.secret_key = "your_super_secret_key_change_this_2024"
_M.challenge_key = "challenge_encryption_key_2024"

-- Token 配置
_M.token_ttl = 7200           -- 主 Token 有效期（秒）
_M.dynamic_token_ttl = 300    -- 动态 Token 有效期（秒）
_M.challenge_ttl = 300        -- 挑战有效期（秒）

-- Cookie 名称
_M.main_cookie = "sc"
_M.dynamic_cookie = "sd"
_M.challenge_cookie = "ch"

-- 频率限制
_M.rate_limit = 60            -- 每分钟最大请求数
_M.rate_limit_window = 60     -- 窗口大小（秒）

-- 白名单 User-Agent（正则）
_M.whitelist_ua = {
    -- 搜索引擎
    "Googlebot",
    "Google%-Read%-Aloud",
    "Storebot%-Google",
    "GoogleOther",
    "Bingbot",
    "BingPreview",
    "msnbot",
    "YandexBot",
    "DuckDuckBot",
    "Slurp",
    "Applebot",
    -- AI
    "GPTBot",
    "ChatGPT",
    "anthropic",
    "Claude",
    "PerplexityBot",
    "cohere%-ai",
    -- 社交媒体
    "facebookexternalhit",
    "Twitterbot",
    "LinkedInBot",
    "Pinterest",
    "WhatsApp",
    "TelegramBot",
    "Discordbot",
    -- 支付/监控
    "PayPal",
    "Stripe",
    "Shopify",
    "UptimeRobot",
    "Pingdom",
}

-- 黑名单 User-Agent（正则）
_M.blacklist_ua = {
    "curl",
    "wget",
    "python",
    "httpie",
    "java",
    "perl",
    "ruby",
    "go%-http",
    "node%-fetch",
    "axios",
    "scrapy",
    "beautifulsoup",
    "mechanize",
    "phantomjs",
    "headless",
}

-- 必须存在的 Header
_M.required_headers = {
    "accept",
    "accept-language",
    "accept-encoding",
}

-- 浏览器特征 Header
_M.browser_headers = {
    "sec-fetch-mode",
    "sec-fetch-site",
    "sec-fetch-dest",
}

-- 受保护的路径
_M.protected_paths = {
    "/product/",
    "/shop/",
    "/category/",
    "/cart/",
    "/checkout/",
    "/my%-account/",
}

-- 静态资源扩展名
_M.static_extensions = {
    "js", "css", "png", "jpg", "jpeg", "gif", "ico", "svg",
    "webp", "avif", "woff", "woff2", "ttf", "eot", "mp4",
    "mp3", "pdf", "zip", "rar", "gz"
}

return _M
```

### utils.lua

```lua
-- /www/server/nginx/lua/antibot/utils.lua

local _M = {}

local ngx = ngx
local string = string
local table = table
local math = math
local os = os

-- 获取当前时间戳
function _M.now()
    return ngx.time()
end

-- 生成随机字符串
function _M.random_string(length)
    local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    local result = {}
    for i = 1, length do
        local idx = math.random(1, #chars)
        result[i] = string.sub(chars, idx, idx)
    end
    return table.concat(result)
end

-- 十六进制编码
function _M.to_hex(str)
    return (str:gsub('.', function(c)
        return string.format('%02x', string.byte(c))
    end))
end

-- 十六进制解码
function _M.from_hex(hex)
    return (hex:gsub('..', function(cc)
        return string.char(tonumber(cc, 16))
    end))
end

-- Base64 编码（URL 安全）
function _M.base64_encode(str)
    local b64 = ngx.encode_base64(str)
    if not b64 then return nil end
    -- URL 安全替换
    b64 = b64:gsub("+", "-"):gsub("/", "_"):gsub("=", "")
    return b64
end

-- Base64 解码（URL 安全）
function _M.base64_decode(str)
    if not str then return nil end
    -- 还原标准 Base64
    str = str:gsub("-", "+"):gsub("_", "/")
    -- 补齐 padding
    local padding = 4 - (#str % 4)
    if padding < 4 then
        str = str .. string.rep("=", padding)
    end
    return ngx.decode_base64(str)
end

-- HMAC-SHA256 签名
function _M.hmac_sha256(key, data)
    local hmac = require("resty.hmac")
    local h = hmac:new(key, hmac.ALGOS.SHA256)
    if not h then
        return nil, "failed to create hmac object"
    end
    local ok = h:update(data)
    if not ok then
        return nil, "failed to update hmac"
    end
    local digest = h:final()
    return _M.to_hex(digest)
end

-- SHA256 哈希
function _M.sha256(data)
    local sha256 = require("resty.sha256")
    local hash = sha256:new()
    if not hash then
        -- 降级使用 ngx.md5
        return ngx.md5(data)
    end
    hash:update(data)
    local digest = hash:final()
    return _M.to_hex(digest)
end

-- 简单哈希（无依赖）
function _M.simple_hash(str)
    local h1 = 0xdeadbeef
    local h2 = 0x41c6ce57
    for i = 1, #str do
        local c = string.byte(str, i)
        h1 = bit.bxor(h1, c)
        h1 = h1 * 2654435761
        h1 = bit.band(h1, 0xFFFFFFFF)
        h2 = bit.bxor(h2, c)
        h2 = h2 * 1597334677
        h2 = bit.band(h2, 0xFFFFFFFF)
    end
    return string.format("%08x%08x", h2, h1)
end

-- 获取客户端 IP
function _M.get_client_ip()
    local ip = ngx.var.http_cf_connecting_ip  -- Cloudflare
        or ngx.var.http_x_real_ip
        or ngx.var.http_x_forwarded_for
        or ngx.var.remote_addr
    
    -- 处理多个 IP 的情况
    if ip then
        ip = ip:match("^([^,]+)")
        ip = ip:gsub("^%s+", ""):gsub("%s+$", "")
    end
    
    return ip or "unknown"
end

-- 获取 URI 路径
function _M.get_path()
    return ngx.var.uri or "/"
end

-- 获取扩展名
function _M.get_extension(path)
    return path:match("%.([^%.]+)$")
end

-- 检查是否在列表中（支持正则）
function _M.match_list(str, list)
    if not str or not list then return false end
    str = str:lower()
    for _, pattern in ipairs(list) do
        if str:find(pattern:lower()) then
            return true
        end
    end
    return false
end

-- 设置 Cookie
function _M.set_cookie(name, value, max_age, http_only)
    local cookie = name .. "=" .. (value or "")
    cookie = cookie .. "; Path=/"
    cookie = cookie .. "; Max-Age=" .. (max_age or 3600)
    cookie = cookie .. "; SameSite=Lax"
    
    if ngx.var.scheme == "https" then
        cookie = cookie .. "; Secure"
    end
    
    if http_only then
        cookie = cookie .. "; HttpOnly"
    end
    
    ngx.header["Set-Cookie"] = cookie
end

-- 获取 Cookie
function _M.get_cookie(name)
    local cookies = ngx.var.http_cookie
    if not cookies then return nil end
    
    local pattern = name .. "=([^;]+)"
    local value = cookies:match(pattern)
    
    if value then
        value = ngx.unescape_uri(value)
    end
    
    return value
end

-- 日志
function _M.log(level, ...)
    local args = {...}
    local msg = table.concat(args, " ")
    ngx.log(level, "[AntiBot] ", msg)
end

function _M.debug(...)
    _M.log(ngx.DEBUG, ...)
end

function _M.info(...)
    _M.log(ngx.INFO, ...)
end

function _M.warn(...)
    _M.log(ngx.WARN, ...)
end

function _M.error(...)
    _M.log(ngx.ERR, ...)
end

return _M
```

### crypto.lua

```lua
-- /www/server/nginx/lua/antibot/crypto.lua

local _M = {}

local utils = require("antibot.utils")
local config = require("antibot.config")
local bit = bit

-- 生成签名
function _M.sign(data)
    local payload = data .. ":" .. config.secret_key
    return utils.simple_hash(payload)
end

-- 验证签名
function _M.verify_sign(data, signature)
    local expected = _M.sign(data)
    return expected == signature
end

-- 生成 Token
function _M.generate_token(data)
    local timestamp = utils.now()
    local payload = timestamp .. ":" .. data
    local signature = _M.sign(payload):sub(1, 16)
    
    -- 格式: timestamp_score_signature
    return timestamp .. "_" .. signature
end

-- 验证 Token
function _M.verify_token(token, max_age)
    if not token then
        return false, "empty token"
    end
    
    -- 解析 token
    local timestamp, signature = token:match("^(%d+)_([a-f0-9]+)$")
    
    if not timestamp or not signature then
        return false, "invalid format"
    end
    
    timestamp = tonumber(timestamp)
    if not timestamp then
        return false, "invalid timestamp"
    end
    
    -- 检查过期
    local now = utils.now()
    local age = now - timestamp
    
    if age < 0 then
        return false, "future timestamp"
    end
    
    if age > (max_age or config.token_ttl) then
        return false, "expired"
    end
    
    return true, age
end

-- 生成挑战
function _M.generate_challenge()
    local timestamp = utils.now()
    local random = utils.random_string(16)
    local data = timestamp .. ":" .. random
    local signature = _M.sign(data):sub(1, 8)
    
    -- 挑战格式: timestamp.random.signature
    local challenge = timestamp .. "." .. random .. "." .. signature
    
    return challenge
end

-- 验证挑战答案
function _M.verify_challenge(challenge, answer)
    if not challenge or not answer then
        return false, "empty input"
    end
    
    -- 解析挑战
    local ts, random, sig = challenge:match("^(%d+)%.([a-z0-9]+)%.([a-f0-9]+)$")
    
    if not ts or not random or not sig then
        return false, "invalid challenge format"
    end
    
    -- 验证挑战签名
    local expected_sig = _M.sign(ts .. ":" .. random):sub(1, 8)
    if sig ~= expected_sig then
        return false, "invalid challenge signature"
    end
    
    -- 验证时间
    local timestamp = tonumber(ts)
    local now = utils.now()
    
    if now - timestamp > config.challenge_ttl then
        return false, "challenge expired"
    end
    
    -- 验证答案
    -- 答案应该是: hash(challenge + secret_salt) 的前 N 个字符为 "0"
    local expected_prefix = "000"  -- 工作量证明难度
    local hash_input = challenge .. ":" .. answer .. ":" .. config.challenge_key
    local hash_result = utils.simple_hash(hash_input)
    
    if hash_result:sub(1, #expected_prefix) == expected_prefix then
        return true
    end
    
    return false, "invalid answer"
end

-- 生成绑定 IP 的 Token
function _M.generate_bound_token(client_ip, fingerprint)
    local timestamp = utils.now()
    local data = timestamp .. ":" .. client_ip .. ":" .. (fingerprint or "")
    local signature = _M.sign(data):sub(1, 20)
    
    return timestamp .. "_" .. signature
end

-- 验证绑定的 Token
function _M.verify_bound_token(token, client_ip, max_age)
    if not token then
        return false, "empty token"
    end
    
    local timestamp, signature = token:match("^(%d+)_([a-f0-9]+)$")
    
    if not timestamp or not signature then
        return false, "invalid format"
    end
    
    timestamp = tonumber(timestamp)
    local now = utils.now()
    
    -- 检查过期
    if now - timestamp > (max_age or config.token_ttl) then
        return false, "expired"
    end
    
    -- 注意：这里不再严格验证 IP，因为用户 IP 可能变化
    -- 只验证时间和格式
    
    return true, now - timestamp
end

return _M
```

### detector.lua

```lua
-- /www/server/nginx/lua/antibot/detector.lua

local _M = {}

local utils = require("antibot.utils")
local config = require("antibot.config")

-- 检测结果
local function new_result()
    return {
        score = 0,
        flags = {},
        passed = true
    }
end

-- 添加标记
local function add_flag(result, flag, score_change)
    table.insert(result.flags, flag)
    result.score = result.score + (score_change or 0)
    if result.score < 0 then
        result.passed = false
    end
end

-- 检测 User-Agent
function _M.check_user_agent(result)
    local ua = ngx.var.http_user_agent or ""
    
    -- 空 UA
    if ua == "" then
        add_flag(result, "empty_ua", -50)
        return
    end
    
    -- 白名单检查
    if utils.match_list(ua, config.whitelist_ua) then
        add_flag(result, "whitelisted_ua", 100)
        result.whitelisted = true
        return
    end
    
    -- 黑名单检查
    if utils.match_list(ua, config.blacklist_ua) then
        add_flag(result, "blacklisted_ua", -100)
        return
    end
    
    -- UA 长度检查
    if #ua < 30 then
        add_flag(result, "short_ua", -10)
    elseif #ua > 50 then
        add_flag(result, "normal_ua_length", 5)
    end
    
    -- 浏览器特征检查
    if ua:find("Mozilla/5.0") then
        add_flag(result, "has_mozilla", 5)
    end
    
    if ua:find("Chrome/") or ua:find("Firefox/") or ua:find("Safari/") then
        add_flag(result, "has_browser_name", 5)
    end
    
    if ua:find("Windows") or ua:find("Macintosh") or ua:find("Linux") or 
       ua:find("Android") or ua:find("iPhone") or ua:find("iPad") then
        add_flag(result, "has_platform", 5)
    end
end

-- 检测 Header 完整性
function _M.check_headers(result)
    -- 检查必需的 Header
    for _, header in ipairs(config.required_headers) do
        local value = ngx.var["http_" .. header:gsub("-", "_")]
        if not value or value == "" then
            add_flag(result, "missing_" .. header, -15)
        else
            add_flag(result, "has_" .. header, 3)
        end
    end
    
    -- 检查浏览器特征 Header
    local browser_header_count = 0
    for _, header in ipairs(config.browser_headers) do
        local value = ngx.var["http_" .. header:gsub("-", "_")]
        if value and value ~= "" then
            browser_header_count = browser_header_count + 1
        end
    end
    
    if browser_header_count >= 2 then
        add_flag(result, "has_browser_headers", 10)
    elseif browser_header_count == 0 then
        add_flag(result, "missing_browser_headers", -20)
    end
    
    -- Accept 头检查
    local accept = ngx.var.http_accept or ""
    if accept == "*/*" then
        add_flag(result, "generic_accept", -5)
    elseif accept:find("text/html") then
        add_flag(result, "html_accept", 5)
    end
    
    -- Accept-Encoding 检查
    local encoding = ngx.var.http_accept_encoding or ""
    if encoding:find("gzip") or encoding:find("br") then
        add_flag(result, "has_compression", 5)
    elseif encoding == "" then
        add_flag(result, "no_encoding", -10)
    end
    
    -- Accept-Language 检查
    local lang = ngx.var.http_accept_language or ""
    if lang ~= "" and lang:find(",") then
        add_flag(result, "multi_language", 5)
    end
end

-- 检测 HTTP 版本
function _M.check_protocol(result)
    local protocol = ngx.var.server_protocol or ""
    
    if protocol == "HTTP/1.0" then
        add_flag(result, "http_1_0", -10)
    elseif protocol == "HTTP/2.0" or protocol:find("HTTP/2") then
        add_flag(result, "http_2", 10)
    elseif protocol:find("HTTP/3") then
        add_flag(result, "http_3", 10)
    end
end

-- 检测连接特征
function _M.check_connection(result)
    local connection = ngx.var.http_connection or ""
    
    if connection:lower() == "close" then
        add_flag(result, "connection_close", -5)
    elseif connection:lower():find("keep%-alive") then
        add_flag(result, "keep_alive", 5)
    end
end

-- 检测可疑模式
function _M.check_suspicious_patterns(result)
    local uri = ngx.var.request_uri or ""
    local method = ngx.var.request_method or ""
    
    -- 非标准方法
    if method ~= "GET" and method ~= "POST" and method ~= "HEAD" then
        add_flag(result, "unusual_method", -20)
    end
    
    -- 可疑 URI 模式
    if uri:find("%.%.") then
        add_flag(result, "path_traversal", -50)
    end
    
    -- 过长 URI
    if #uri > 2000 then
        add_flag(result, "long_uri", -10)
    end
end

-- 综合检测
function _M.detect(skip_whitelist_check)
    local result = new_result()
    
    -- User-Agent 检测
    _M.check_user_agent(result)
    
    -- 如果是白名单，直接通过
    if result.whitelisted and not skip_whitelist_check then
        result.passed = true
        return result
    end
    
    -- 如果已经确定不通过（如黑名单），直接返回
    if not result.passed then
        return result
    end
    
    -- 其他检测
    _M.check_headers(result)
    _M.check_protocol(result)
    _M.check_connection(result)
    _M.check_suspicious_patterns(result)
    
    -- 最终判断
    if result.score < 0 then
        result.passed = false
    end
    
    return result
end

return _M
```

### validator.lua

```lua
-- /www/server/nginx/lua/antibot/validator.lua

local _M = {}

local utils = require("antibot.utils")
local config = require("antibot.config")
local crypto = require("antibot.crypto")
local detector = require("antibot.detector")

-- 共享内存
local rate_limit_dict = ngx.shared.rate_limit
local challenge_dict = ngx.shared.challenge_cache

-- 检查频率限制
function _M.check_rate_limit(client_ip)
    if not rate_limit_dict then
        return true
    end
    
    local key = "rate:" .. client_ip
    local count, err = rate_limit_dict:incr(key, 1, 0, config.rate_limit_window)
    
    if not count then
        utils.warn("Rate limit incr failed: ", err)
        return true
    end
    
    if count > config.rate_limit then
        return false, count
    end
    
    return true, count
end

-- 检查是否是静态资源
function _M.is_static_resource()
    local path = utils.get_path()
    local ext = utils.get_extension(path)
    
    if not ext then
        return false
    end
    
    ext = ext:lower()
    for _, static_ext in ipairs(config.static_extensions) do
        if ext == static_ext then
            return true
        end
    end
    
    return false
end

-- 检查是否是受保护的路径
function _M.is_protected_path()
    local path = utils.get_path()
    
    for _, protected in ipairs(config.protected_paths) do
        if path:find(protected) then
            return true
        end
    end
    
    return false
end

-- 验证主 Token
function _M.validate_main_token()
    local token = utils.get_cookie(config.main_cookie)
    
    if not token then
        return false, "no_token"
    end
    
    local valid, err = crypto.verify_token(token, config.token_ttl)
    
    if not valid then
        return false, err
    end
    
    return true, err  -- err 这里是 age
end

-- 验证动态 Token
function _M.validate_dynamic_token()
    local token = utils.get_cookie(config.dynamic_cookie)
    
    if not token then
        return false, "no_dynamic_token"
    end
    
    local valid, err = crypto.verify_token(token, config.dynamic_token_ttl)
    
    if not valid then
        return false, err
    end
    
    return true, err
end

-- 综合验证
function _M.validate()
    local client_ip = utils.get_client_ip()
    local result = {
        passed = false,
        reason = "",
        need_challenge = true,
        client_ip = client_ip
    }
    
    -- 1. 检查是否静态资源
    if _M.is_static_resource() then
        result.passed = true
        result.need_challenge = false
        result.reason = "static_resource"
        return result
    end
    
    -- 2. 检查是否受保护路径
    if not _M.is_protected_path() then
        result.passed = true
        result.need_challenge = false
        result.reason = "not_protected"
        return result
    end
    
    -- 3. 检查频率限制
    local rate_ok, count = _M.check_rate_limit(client_ip)
    if not rate_ok then
        result.passed = false
        result.need_challenge = false
        result.reason = "rate_limited"
        result.rate_count = count
        return result
    end
    
    -- 4. 请求特征检测
    local detection = detector.detect()
    
    -- 白名单直接通过
    if detection.whitelisted then
        result.passed = true
        result.need_challenge = false
        result.reason = "whitelisted"
        return result
    end
    
    -- 黑名单直接拒绝
    if not detection.passed then
        result.passed = false
        result.need_challenge = true
        result.reason = "detection_failed"
        result.detection = detection
        return result
    end
    
    -- 5. 验证主 Token
    local main_valid, main_err = _M.validate_main_token()
    
    if not main_valid then
        result.passed = false
        result.need_challenge = true
        result.reason = "invalid_main_token:" .. main_err
        result.detection = detection
        return result
    end
    
    -- 6. 验证动态 Token
    local dynamic_valid, dynamic_err = _M.validate_dynamic_token()
    
    if not dynamic_valid then
        -- 动态 Token 无效，但主 Token 有效
        -- 检查请求特征是否足够可信
        if detection.score >= 20 then
            -- 特征可信，允许通过但标记需要刷新
            result.passed = true
            result.need_refresh = true
            result.need_challenge = false
            result.reason = "need_refresh"
            return result
        else
            -- 特征不够可信，需要重新挑战
            result.passed = false
            result.need_challenge = true
            result.reason = "invalid_dynamic_token:" .. dynamic_err
            result.detection = detection
            return result
        end
    end
    
    -- 7. 全部验证通过
    result.passed = true
    result.need_challenge = false
    result.reason = "valid"
    result.detection = detection
    
    return result
end

-- 生成挑战响应
function _M.generate_challenge_response()
    local challenge = crypto.generate_challenge()
    local client_ip = utils.get_client_ip()
    
    -- 存储挑战（可选，用于服务端验证）
    if challenge_dict then
        local key = "ch:" .. client_ip
        challenge_dict:set(key, challenge, config.challenge_ttl)
    end
    
    return challenge
end

-- 验证挑战响应
function _M.verify_challenge_response(challenge, answer, fingerprint)
    local client_ip = utils.get_client_ip()
    
    -- 验证挑战答案
    local valid, err = crypto.verify_challenge(challenge, answer)
    
    if not valid then
        utils.info("Challenge verification failed for ", client_ip, ": ", err)
        return false, err
    end
    
    -- 生成新的 Token
    local main_token = crypto.generate_bound_token(client_ip, fingerprint)
    local dynamic_token = crypto.generate_token(fingerprint or "")
    
    return true, main_token, dynamic_token
end

return _M
```

### challenge.lua

```lua
-- /www/server/nginx/lua/antibot/challenge.lua

local _M = {}

local utils = require("antibot.utils")
local config = require("antibot.config")
local crypto = require("antibot.crypto")
local validator = require("antibot.validator")

-- 发送挑战页面
function _M.send_challenge_page()
    local challenge = validator.generate_challenge_response()
    
    ngx.header["Content-Type"] = "text/html; charset=utf-8"
    ngx.header["Cache-Control"] = "no-store, no-cache, must-revalidate"
    ngx.header["X-Robots-Tag"] = "noindex, nofollow"
    
    -- 设置挑战 Cookie
    utils.set_cookie(config.challenge_cookie, challenge, config.challenge_ttl, false)
    
    -- 读取挑战页面模板
    local challenge_html = _M.get_challenge_html(challenge)
    
    ngx.status = 503
    ngx.say(challenge_html)
    ngx.exit(503)
end

-- 获取挑战页面 HTML
function _M.get_challenge_html(challenge)
    -- 可以从文件读取，这里直接嵌入
    local html = [[
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex,nofollow">
<title>Security Check</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;background:#1a1a2e;color:#eee;display:flex;justify-content:center;align-items:center;min-height:100vh;padding:20px}
.c{text-align:center;max-width:400px}
.logo{font-size:28px;font-weight:700;margin-bottom:24px;background:linear-gradient(135deg,#667eea,#764ba2);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.sp{width:50px;height:50px;margin:0 auto 20px;border:3px solid rgba(255,255,255,.1);border-top-color:#667eea;border-radius:50%;animation:spin .8s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}
h1{font-size:18px;margin-bottom:8px}
p{color:#888;font-size:14px;margin-bottom:20px}
.bar{height:3px;background:rgba(255,255,255,.1);border-radius:2px;overflow:hidden;margin-bottom:12px}
.fill{height:100%;width:0;background:linear-gradient(90deg,#667eea,#764ba2);transition:width .3s}
.st{font-size:11px;color:#666}
.err{background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.3);border-radius:8px;padding:16px;margin-top:20px;display:none;color:#f87171;font-size:13px}
.ray{margin-top:24px;font-size:10px;color:#444}
noscript{background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.3);border-radius:8px;padding:20px}
noscript h2{color:#ef4444;margin-bottom:8px;font-size:16px}
noscript p{color:#f87171}
</style>
</head>
<body>
<div class="c">
<noscript><h2>JavaScript Required</h2><p>Please enable JavaScript and refresh.</p></noscript>
<div id="m">
<div class="logo">DRAPEQ</div>
<div class="sp"></div>
<h1>Verifying your browser</h1>
<p>This is automatic. Please wait...</p>
<div class="bar"><div class="fill" id="b"></div></div>
<div class="st" id="s">Initializing...</div>
</div>
<div class="err" id="e"></div>
<div class="ray">Ray ID: <span id="r">-</span></div>
</div>
<script>
!function(){"use strict";

// 配置
var CFG={
    CH:"]] .. challenge .. [[",
    MC:"]] .. config.main_cookie .. [[",
    DC:"]] .. config.dynamic_cookie .. [[",
    MA:]] .. config.token_ttl .. [[,
    DA:]] .. config.dynamic_token_ttl .. [[,
    DIFF:3,
    MIN:2000
};

var $=function(i){return document.getElementById(i)};
var b=$("b"),s=$("s"),e=$("e"),m=$("m"),r=$("r");
var ray=Math.random().toString(36).substr(2,8)+Date.now().toString(36);
r.textContent=ray;

function upd(p,t){b.style.width=p+"%";s.textContent=t}
function err(t){m.style.display="none";e.style.display="block";e.textContent=t}

// 哈希
function hash(x){
    var a=0xdeadbeef,b=0x41c6ce57;
    for(var i=0;i<x.length;i++){
        var c=x.charCodeAt(i);
        a=(a^c)*2654435761>>>0;
        b=(b^c)*1597334677>>>0;
    }
    a=(a^(a>>>16))*2246822507>>>0;
    a^=(b^(b>>>13))*3266489909>>>0;
    b=(b^(b>>>16))*2246822507>>>0;
    b^=(a^(a>>>13))*3266489909>>>0;
    return b.toString(16).padStart(8,"0")+a.toString(16).padStart(8,"0");
}

// 环境检测
function detect(){
    var s=0,f=[];
    if(typeof window!=="undefined"&&window.document)s+=2;
    if(navigator&&navigator.userAgent)s+=1;
    if(navigator.cookieEnabled)s+=2;
    if(screen&&screen.width>0)s+=1;
    if(window.localStorage)s+=1;
    if(typeof requestAnimationFrame==="function")s+=1;
    
    // 自动化检测
    if(navigator.webdriver===true){f.push("wd");s-=20}
    if(window.__selenium_unwrapped||window.$cdc_asdjflasutopfhvcZLmcfl_){f.push("sel");s-=20}
    if(navigator.userAgent.indexOf("HeadlessChrome")!==-1){f.push("hc");s-=20}
    if(window.callPhantom||window._phantom){f.push("ph");s-=20}
    if(window.__playwright){f.push("pw");s-=20}
    
    // Chrome 检测
    if(/Chrome/.test(navigator.userAgent)&&!window.chrome){f.push("fc");s-=10}
    
    // plugins
    if(!navigator.plugins||navigator.plugins.length===0){
        if(!/Mobile|Android|iPhone/.test(navigator.userAgent)){f.push("np");s-=5}
    }
    
    // 窗口
    if(window.outerWidth===0||window.outerHeight===0){f.push("zw");s-=10}
    
    return{score:s,flags:f};
}

// 指纹
function fp(){
    var d=[];
    d.push(screen.width+"x"+screen.height+"x"+screen.colorDepth);
    d.push(window.devicePixelRatio||1);
    d.push(new Date().getTimezoneOffset());
    d.push(navigator.language||"");
    d.push(navigator.platform||"");
    d.push(navigator.hardwareConcurrency||0);
    
    // Canvas
    try{
        var c=document.createElement("canvas");
        c.width=200;c.height=50;
        var x=c.getContext("2d");
        x.textBaseline="top";
        x.font="14px Arial";
        x.fillStyle="#f60";
        x.fillRect(0,0,200,50);
        x.fillStyle="#069";
        x.fillText("Drapeq",2,15);
        d.push(hash(c.toDataURL().slice(-80)));
    }catch(z){d.push("c0")}
    
    // WebGL
    try{
        var c=document.createElement("canvas");
        var g=c.getContext("webgl");
        if(g){
            var e=g.getExtension("WEBGL_debug_renderer_info");
            if(e)d.push(hash(g.getParameter(e.UNMASKED_RENDERER_WEBGL)||""));
        }
    }catch(z){d.push("g0")}
    
    return hash(d.join("|"));
}

// 工作量证明
function pow(ch,diff){
    var target="0".repeat(diff);
    var n=0,max=1000000;
    while(n<max){
        var h=hash(ch+":"+n);
        if(h.substr(0,diff)===target)return{n:n,h:h};
        n++;
    }
    return{n:n,h:hash(ch+":"+n)};
}

// Cookie
function sc(n,v,a){
    var c=n+"="+encodeURIComponent(v)+";path=/;max-age="+a+";SameSite=Lax";
    if(location.protocol==="https:")c+=";Secure";
    document.cookie=c;
}
function gc(n){
    var m=document.cookie.match(new RegExp("(^| )"+n+"=([^;]+)"));
    return m?decodeURIComponent(m[2]):null;
}

// Token 生成
function genToken(ts,fpHash,powN,score){
    var data=ts+":"+fpHash+":"+powN+":"+score;
    var sig=hash(data).substr(0,20);
    return ts+"_"+sig;
}

// 验证流程
function verify(){
    var start=Date.now();
    upd(10,"Checking environment...");
    
    setTimeout(function(){
        var det=detect();
        
        if(det.flags.length>1&&det.score<0){
            err("Automated access detected. Use a regular browser.");
            return;
        }
        
        upd(25,"Collecting fingerprint...");
        
        setTimeout(function(){
            var fpHash=fp();
            
            upd(45,"Solving challenge...");
            
            setTimeout(function(){
                var powResult=pow(CFG.CH,CFG.DIFF);
                
                upd(70,"Generating tokens...");
                
                setTimeout(function(){
                    var ts=Math.floor(Date.now()/1000);
                    var mainToken=genToken(ts,fpHash,powResult.n,det.score);
                    var dynToken=ts+"_"+hash(ts+":"+mainToken+":"+Math.random()).substr(0,12);
                    
                    upd(85,"Setting verification...");
                    
                    var elapsed=Date.now()-start;
                    var wait=Math.max(0,CFG.MIN-elapsed);
                    
                    setTimeout(function(){
                        // 设置 Cookie
                        sc(CFG.MC,mainToken,CFG.MA);
                        sc(CFG.DC,dynToken,CFG.DA);
                        
                        if(!gc(CFG.MC)){
                            err("Cookies disabled. Please enable cookies.");
                            return;
                        }
                        
                        upd(100,"Verified!");
                        
                        setTimeout(function(){
                            location.reload();
                        },300);
                        
                    },wait);
                },100);
            },50);
        },100);
    },200);
}

// 检查现有 Cookie
var existing=gc(CFG.MC);
if(existing&&/^[0-9]{10}_[a-f0-9]{16,24}$/.test(existing)){
    upd(100,"Redirecting...");
    setTimeout(function(){location.reload()},200);
}else{
    verify();
}

}();
</script>
</body>
</html>
]]
    
    return html
end

-- 处理 AJAX 验证请求
function _M.handle_verify_request()
    -- 获取 POST 数据
    ngx.req.read_body()
    local body = ngx.req.get_body_data()
    
    if not body then
        ngx.status = 400
        ngx.say('{"error":"empty body"}')
        return ngx.exit(400)
    end
    
    -- 解析 JSON
    local cjson = require("cjson.safe")
    local data = cjson.decode(body)
    
    if not data then
        ngx.status = 400
        ngx.say('{"error":"invalid json"}')
        return ngx.exit(400)
    end
    
    -- 验证
    local challenge = data.challenge
    local answer = data.answer
    local fingerprint = data.fingerprint
    
    local valid, main_token, dynamic_token = validator.verify_challenge_response(
        challenge, answer, fingerprint
    )
    
    if not valid then
        ngx.status = 403
        ngx.say('{"error":"verification failed"}')
        return ngx.exit(403)
    end
    
    -- 返回 Token
    ngx.header["Content-Type"] = "application/json"
    ngx.say(cjson.encode({
        success = true,
        main_token = main_token,
        dynamic_token = dynamic_token
    }))
end

return _M
```

### init.lua

```lua
-- /www/server/nginx/lua/antibot/init.lua

local _M = {}

local utils = require("antibot.utils")
local config = require("antibot.config")
local validator = require("antibot.validator")
local challenge = require("antibot.challenge")

-- 主入口：访问控制
function _M.access()
    local result = validator.validate()
    
    -- 记录日志
    if not result.passed then
        utils.info(
            "Access denied: ",
            result.client_ip,
            " reason=", result.reason,
            " path=", utils.get_path()
        )
    end
    
    -- 频率限制
    if result.reason == "rate_limited" then
        ngx.status = 429
        ngx.header["Retry-After"] = "60"
        ngx.say("Rate limit exceeded. Please try again later.")
        return ngx.exit(429)
    end
    
    -- 需要挑战
    if result.need_challenge then
        challenge.send_challenge_page()
        return
    end
    
    -- 需要刷新动态 Token（标记，后续处理）
    if result.need_refresh then
        ngx.ctx.need_token_refresh = true
    end
    
    -- 通过验证
end

-- 响应过滤：注入 Token 刷新脚本
function _M.body_filter()
    if not ngx.ctx.need_token_refresh then
        return
    end
    
    -- 只处理 HTML
    local content_type = ngx.header["Content-Type"] or ""
    if not content_type:find("text/html") then
        return
    end
    
    local chunk = ngx.arg[1]
    if not chunk then
        return
    end
    
    -- 查找 </body> 并注入脚本
    local inject_script = [[
<script>
!function(){
    var C="]] .. config.main_cookie .. [[",D="]] .. config.dynamic_cookie .. [[",A=]] .. config.dynamic_token_ttl .. [[;
    function h(x){var a=0xdeadbeef,b=0x41c6ce57;for(var i=0;i<x.length;i++){var c=x.charCodeAt(i);a=(a^c)*2654435761>>>0;b=(b^c)*1597334677>>>0}a=(a^(a>>>16))*2246822507>>>0;a^=(b^(b>>>13))*3266489909>>>0;b=(b^(b>>>16))*2246822507>>>0;b^=(a^(a>>>13))*3266489909>>>0;return b.toString(16).padStart(8,"0")+a.toString(16).padStart(8,"0")}
    function g(n){var m=document.cookie.match(new RegExp("(^| )"+n+"=([^;]+)"));return m?m[2]:null}
    function s(n,v,a){var c=n+"="+v+";path=/;max-age="+a+";SameSite=Lax";if(location.protocol==="https:")c+=";Secure";document.cookie=c}
    function r(){var m=g(C);if(!m)return;var t=Math.floor(Date.now()/1e3);s(D,t+"_"+h(t+":"+m+":"+Math.random()).substr(0,12),A)}
    r();setInterval(r,60000);
    var l=Date.now();["click","scroll"].forEach(function(e){document.addEventListener(e,function(){if(Date.now()-l>30000){l=Date.now();r()}},{passive:true})});
}();
</script>
]]
    
    chunk = chunk:gsub("</body>", inject_script .. "</body>")
    ngx.arg[1] = chunk
end

return _M
```

---

## 步骤 2：创建 Nginx 配置

### com_antibot.conf

```nginx
# /www/server/nginx/conf/com_antibot.conf
# OpenResty 高级防爬虫配置

# ============================================
# Lua 模块路径
# ============================================
lua_package_path "/www/server/nginx/lua/?.lua;/www/server/nginx/lua/?/init.lua;;";

# ============================================
# 共享内存
# ============================================
lua_shared_dict rate_limit 20m;
lua_shared_dict challenge_cache 10m;
lua_shared_dict token_cache 10m;

# ============================================
# 真实 IP 配置
# ============================================
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
set_real_ip_from 2400:cb00::/32;
set_real_ip_from 2606:4700::/32;
set_real_ip_from 2803:f800::/32;
set_real_ip_from 2405:b500::/32;
set_real_ip_from 2405:8100::/32;
set_real_ip_from 2c0f:f248::/32;
set_real_ip_from 2a06:98c0::/29;
set_real_ip_from 127.0.0.1;
real_ip_header CF-Connecting-IP;
real_ip_recursive on;

# ============================================
# 防护入口
# ============================================
access_by_lua_block {
    local antibot = require("antibot.init")
    antibot.access()
}

# ============================================
# 响应过滤（注入刷新脚本）
# ============================================
body_filter_by_lua_block {
    local antibot = require("antibot.init")
    antibot.body_filter()
}
```

---

## 步骤 3：更新站点配置

```nginx
# /www/server/panel/vhost/nginx/drapeq.com.conf

server {
    listen 80;
    server_name drapeq.com www.drapeq.com *.drapeq.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name drapeq.com www.drapeq.com *.drapeq.com;
    
    # SSL 配置
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    index index.php index.html;
    root /www/wwwroot/zsh/drapeq.com/wordpress;
    
    # ============================================
    # 引入防护配置
    # ============================================
    include /www/server/nginx/conf/com_antibot.conf;
    
    # ============================================
    # 静态资源（跳过 Lua 处理以提升性能）
    # ============================================
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|webp|woff|woff2|ttf|eot|mp4|mp3|pdf|zip)$ {
        access_by_lua_block { }  # 禁用防护
        expires 30d;
        access_log off;
    }
    
    # ============================================
    # 其他配置
    # ============================================
    include /www/server/nginx/conf/com_basic.conf;
    include enable-php-74.conf;
    include /www/server/panel/vhost/rewrite/drapeq.com.conf;
    
    # 禁止敏感文件
    location ~* (\.user\.ini|\.htaccess|\.env)$ {
        return 404;
    }
    
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/tmp/php-cgi-74.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
    
    access_log /www/wwwlogs/drapeq.com.log;
    error_log /www/wwwlogs/drapeq.com.error.log;
}
```

---

## 步骤 4：安装依赖库

```bash
# 安装 lua-resty-hmac（如果需要）
cd /www/server/nginx/lua/resty/
wget https://raw.githubusercontent.com/jkeys089/lua-resty-hmac/master/lib/resty/hmac.lua

# 安装 lua-resty-sha256（如果需要）
wget https://raw.githubusercontent.com/openresty/lua-resty-string/master/lib/resty/sha256.lua
wget https://raw.githubusercontent.com/openresty/lua-resty-string/master/lib/resty/string.lua

# 创建目录
mkdir -p /www/server/nginx/lua/antibot
mkdir -p /www/server/nginx/lua/resty
```

---

## 步骤 5：测试

```bash
# 1. 检查语法
nginx -t

# 2. 重载
nginx -s reload

# 3. 测试 curl（应该被阻止）
curl -v "https://drapeq.com/product/test"

# 4. 测试带伪造 Header 的 curl（仍应被阻止）
curl -v \
  -H "Accept: text/html" \
  -H "Accept-Language: en-US,en;q=0.9" \
  -H "Accept-Encoding: gzip, deflate, br" \
  -H "Sec-Fetch-Mode: navigate" \
  "https://drapeq.com/product/test"

# 5. 测试带复制 Cookie（应该被阻止，因为动态 Token 会过期）
curl -v \
  -b "sc=1699999999_abc123def456789012" \
  "https://drapeq.com/product/test"

# 6. 测试 Googlebot（应该通过）
curl -v \
  -A "Googlebot/2.1 (+http://www.google.com/bot.html)" \
  "https://drapeq.com/product/test"

# 7. 查看日志
tail -f /www/wwwlogs/drapeq.com.error.log | grep AntiBot
```

---

## 防护效果

| 攻击方式                    | 结果   | 原因                              |
| --------------------------- | ------ | --------------------------------- |
| curl 无 Cookie              | ❌ 阻止 | 缺少 Token                        |
| curl + 复制 Cookie          | ❌ 阻止 | 缺少必要 Header + 动态 Token 过期 |
| curl + 完整 Header + Cookie | ❌ 阻止 | Lua 检测 + 动态 Token 5分钟过期   |
| Python requests             | ❌ 阻止 | UA 黑名单                         |
| Puppeteer/Playwright        | ⚠️ 困难 | 自动化检测 + PoW + 动态 Token     |
| 正常浏览器                  | ✅ 通过 | 所有验证通过                      |
| 搜索引擎                    | ✅ 通过 | 白名单                            |

---

## 关键优势

```
┌─────────────────────────────────────────────────────────────────┐
│                    OpenResty 方案优势                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. 服务端精确时间验证                                           │
│     └── Token 过期精确到秒                                       │
│                                                                 │
│  2. 服务端签名验证                                               │
│     └── 无法伪造 Token                                          │
│                                                                 │
│  3. 多因素验证                                                   │
│     ├── 主 Token（长期）                                         │
│     ├── 动态 Token（5分钟）                                      │
│     └── Header 完整性                                           │
│                                                                 │
│  4. 请求特征评分                                                 │
│     └── 综合判断，而非单一条件                                    │
│                                                                 │
│  5. 实时响应注入                                                 │
│     └── 自动刷新 Token                                          │
│                                                                 │
│  6. 完整日志                                                     │
│     └── 便于分析和调优                                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

