[toc]



# Nginx JavaScript 挑战验证方案详解

## 核心原理

```
┌─────────────────────────────────────────────────────────────────────┐
│                         工作流程                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  用户/爬虫请求                                                       │
│       │                                                             │
│       ▼                                                             │
│  ┌─────────────┐    无Cookie     ┌──────────────────┐              │
│  │   Nginx     │ ───────────────▶│  返回 JS 挑战页面  │              │
│  │  检查Cookie │                 │  (需浏览器执行JS)  │              │
│  └─────────────┘                 └────────┬─────────┘              │
│       │                                   │                         │
│       │ 有效Cookie                         │ 执行JS                  │
│       │                                   ▼                         │
│       │                          ┌──────────────────┐              │
│       │                          │  计算挑战答案     │              │
│       │                          │  设置验证Cookie   │              │
│       │                          │  自动刷新页面     │              │
│       │                          └────────┬─────────┘              │
│       │                                   │                         │
│       ▼                                   ▼                         │
│  ┌─────────────────────────────────────────────────────┐           │
│  │                正常访问网站内容                       │           │
│  └─────────────────────────────────────────────────────┘           │
│                                                                     │
│  ❌ 爬虫通常无法执行 JavaScript，无法获得 Cookie，被阻止              │
│  ✅ 真实浏览器执行 JS 后获得 Cookie，正常访问                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## 为什么有效？

| 特性            | 真实浏览器 | 简单爬虫 | 高级爬虫             |
| --------------- | ---------- | -------- | -------------------- |
| 执行 JavaScript | ✅          | ❌        | ⚠️ 需 Headless 浏览器 |
| 设置 Cookie     | ✅          | ❌        | ⚠️                    |
| 资源消耗        | 正常       | 低       | 高（需启动浏览器）   |
| 请求速度        | 正常       | 极快     | 慢                   |

---

## 基础版配置详解

```nginx
server {
    listen 80;
    server_name example.com;
    
    # ============================================================
    # 第一步：定义变量，默认需要挑战
    # ============================================================
    set $need_challenge 1;
    # 说明：
    # - set 指令创建变量 $need_challenge
    # - 值为 1 表示"需要进行 JS 挑战"
    # - 值为 0 表示"已通过验证，放行"
    
    # ============================================================
    # 第二步：检查验证 Cookie
    # ============================================================
    if ($cookie_bot_check = "passed_abc123") {
        set $need_challenge 0;
    }
    # 说明：
    # - $cookie_XXX 是 Nginx 内置语法，读取名为 XXX 的 Cookie
    # - $cookie_bot_check 读取名为 "bot_check" 的 Cookie
    # - 如果 Cookie 值匹配预设的密钥或特征规则，则跳过(通过)挑战
    # - "passed_abc123" 是自定义的验证令牌，应该保密
    
    # ============================================================
    # 第三步：搜索引擎白名单（不需要挑战）
    # ============================================================
    if ($http_user_agent ~* "(Googlebot|Bingbot)") {
        set $need_challenge 0;
    }
    # 说明：
    # - $http_user_agent 是请求头中的 User-Agent
    # - ~* 表示不区分大小写的正则匹配
    # - 匹配主流搜索引擎，直接放行
    # - 注意：这可能被伪造，但搜索引擎需要正常抓取
    
    # ============================================================
    # 第四步：静态资源跳过挑战
    # ============================================================
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 30d;
        access_log off;
        # 静态资源不设置 $need_challenge 检查，直接返回
    }
    
    # ============================================================
    # 第五步：主要处理逻辑
    # ============================================================
    location / {
        # 如果需要挑战，返回 JS 验证页面
        if ($need_challenge = 1) {
            # 设置响应类型为 HTML
            add_header Content-Type "text/html; charset=utf-8";
            
            # 返回包含 JS 的 HTML 页面
            return 200 '
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Checking browser...</title>
                </head>
                <body>
                    <h2>Just a moment...</h2>
                    <script>
                        // refresh Cookie
                        document.cookie = "bot_check=passed_abc123; path=/; max-age=86400";
                        // reload page
                        location.reload();
                    </script>
                </body>
                </html>';
        }
        
        # 通过验证后续处理
		# proxy_pass http://127.0.0.1:80;
        try_files $uri $uri/ /index.php?$args;
                
    }
}
```

---

## 增强版配置（带计算挑战）

```nginx
server {
    listen 80;
    server_name example.com;
    
    set $need_challenge 1;
    
    # Cookie 验证（使用更复杂的令牌,例如32个16进制数）
    if ($cookie_security_token ~* "^[a-f0-9]{32}$") {
        set $need_challenge 0;
    }
    
    # 搜索引擎白名单
    if ($http_user_agent ~* "(Googlebot|Bingbot|Baiduspider)") {
        set $need_challenge 0;
    }
    
    location / {
        if ($need_challenge = 1) {
            add_header Content-Type "text/html; charset=utf-8";
            return 200 '
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>安全检查 | Security Check</title>
    <style>
        /* ========== 页面样式 ========== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .container {
            background: white;
            padding: 40px 60px;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            text-align: center;
            max-width: 450px;
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 24px;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }
        
        /* 加载动画 */
        .spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .status {
            color: #888;
            font-size: 14px;
            margin-top: 20px;
        }
        
        .progress-bar {
            width: 100%;
            height: 4px;
            background: #eee;
            border-radius: 2px;
            margin-top: 20px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            width: 0%;
            transition: width 0.3s;
        }
        
        /* 错误状态 */
        .error {
            color: #e74c3c;
            display: none;
        }
        
        /* 成功状态 */
        .success {
            color: #27ae60;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔒 安全验证</h1>
        <p class="subtitle">正在验证您的浏览器，请稍候...</p>
        
        <div class="spinner" id="spinner"></div>
        
        <div class="progress-bar">
            <div class="progress-fill" id="progress"></div>
        </div>
        
        <p class="status" id="status">正在初始化...</p>
        
        <p class="error" id="error">
            ⚠️ 验证失败，请确保您使用的是现代浏览器
        </p>
        
        <p class="success" id="success">
            ✅ 验证通过，正在跳转...
        </p>
    </div>
    
    <script>
        /*
         * ========================================================
         * JavaScript 挑战验证脚本详解
         * ========================================================
         */
        
        (function() {
            "use strict";
            
            // 获取页面元素
            var progress = document.getElementById("progress");
            var status = document.getElementById("status");
            var spinner = document.getElementById("spinner");
            var error = document.getElementById("error");
            var success = document.getElementById("success");
            
            // 更新进度条
            function updateProgress(percent, msg) {
                progress.style.width = percent + "%";
                status.textContent = msg;
            }
            
            // =====================================================
            // 步骤 1：收集浏览器指纹
            // =====================================================
            // 目的：验证是真实浏览器，而非简单脚本
            // 真实浏览器会有完整的 navigator、screen 等对象
            
            updateProgress(20, "正在收集浏览器信息...");
            
            var fingerprint = {
                // 用户代理字符串
                userAgent: navigator.userAgent,
                
                // 浏览器语言
                language: navigator.language || navigator.userLanguage,
                
                // 屏幕信息（爬虫通常没有真实屏幕）
                screen: {
                    width: screen.width,
                    height: screen.height,
                    colorDepth: screen.colorDepth,
                    pixelRatio: window.devicePixelRatio || 1
                },
                
                // 时区（可用于识别地理位置）
                timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
                
                // 时间戳（用于令牌生成）
                timestamp: Date.now(),
                
                // 平台信息
                platform: navigator.platform,
                
                // Cookie 是否启用
                cookieEnabled: navigator.cookieEnabled,
                
                // 是否支持触摸
                touchSupport: "ontouchstart" in window,
                
                // WebGL 渲染器（可识别显卡，爬虫难以伪造）
                webgl: getWebGLRenderer()
            };
            
            // 获取 WebGL 渲染器信息
            function getWebGLRenderer() {
                try {
                    var canvas = document.createElement("canvas");
                    var gl = canvas.getContext("webgl") || 
                             canvas.getContext("experimental-webgl");
                    if (gl) {
                        var debugInfo = gl.getExtension("WEBGL_debug_renderer_info");
                        if (debugInfo) {
                            return gl.getParameter(debugInfo.UNMASKED_RENDERER_WEBGL);
                        }
                    }
                    return "unknown";
                } catch (e) {
                    return "error";
                }
            }
            
            // =====================================================
            // 步骤 2：执行计算挑战
            // =====================================================
            // 目的：增加爬虫的计算成本
            // 简单爬虫无法执行 JS，即使能执行也要消耗资源
            
            setTimeout(function() {
                updateProgress(40, "正在执行安全验证...");
                
                // 计算挑战：生成一个需要计算的任务
                var challenge = generateChallenge();
                var solution = solveChallenge(challenge);
                
                // =====================================================
                // 步骤 3：生成验证令牌
                // =====================================================
                
                setTimeout(function() {
                    updateProgress(60, "正在生成安全令牌...");
                    
                    // 将指纹和解答组合生成令牌
                    var tokenData = {
                        fingerprint: fingerprint,
                        challenge: challenge,
                        solution: solution,
                        timestamp: Date.now()
                    };
                    
                    // 生成最终令牌（简化版 MD5 模拟）
                    var token = generateToken(tokenData);
                    
                    // =====================================================
                    // 步骤 4：设置 Cookie 并跳转
                    // =====================================================
                    
                    setTimeout(function() {
                        updateProgress(80, "正在保存验证状态...");
                        
                        // 设置验证 Cookie
                        // max-age=86400 表示有效期 24 小时
                        // path=/ 表示整个网站有效
                        // SameSite=Strict 增加安全性
                        document.cookie = "security_token=" + token + 
                                          "; path=/; max-age=86400; SameSite=Strict";
                        
                        setTimeout(function() {
                            updateProgress(100, "验证完成！");
                            
                            // 隐藏加载动画，显示成功
                            spinner.style.display = "none";
                            status.style.display = "none";
                            success.style.display = "block";
                            
                            // 刷新页面（带上 Cookie 重新请求）
                            setTimeout(function() {
                                location.reload();
                            }, 500);
                            
                        }, 300);
                    }, 400);
                }, 400);
            }, 500);
            
            // =====================================================
            // 辅助函数：生成挑战
            // =====================================================
            function generateChallenge() {
                // 生成随机挑战字符串
                var chars = "abcdefghijklmnopqrstuvwxyz0123456789";
                var challenge = "";
                for (var i = 0; i < 16; i++) {
                    challenge += chars.charAt(Math.floor(Math.random() * chars.length));
                }
                return challenge;
            }
            
            // =====================================================
            // 辅助函数：解决挑战
            // =====================================================
            function solveChallenge(challenge) {
                // 模拟工作量证明（Proof of Work）
                // 真实场景可以要求找到特定前缀的哈希
                var solution = 0;
                var target = challenge.charCodeAt(0) * 1000;
                
                // 执行一些计算（消耗 CPU）
                for (var i = 0; i < target; i++) {
                    solution += Math.sqrt(i) * Math.sin(i);
                }
                
                return Math.abs(solution).toString(36).substring(0, 8);
            }
            
            // =====================================================
            // 辅助函数：生成令牌
            // =====================================================
            function generateToken(data) {
                // 简化版令牌生成
                // 生产环境应使用更安全的哈希算法
                var str = JSON.stringify(data);
                var hash = 0;
                
                for (var i = 0; i < str.length; i++) {
                    var char = str.charCodeAt(i);
                    hash = ((hash << 5) - hash) + char;
                    hash = hash & hash; // 转换为 32 位整数
                }
                
                // 转换为 16 进制字符串
                var token = Math.abs(hash).toString(16);
                
                // 补齐到 32 位
                while (token.length < 32) {
                    token = "0" + token + Math.random().toString(16).substring(2);
                }
                
                return token.substring(0, 32);
            }
            
        })();
    </script>
</body>
</html>';
        }
        
        # 通过验证后的正常处理
        proxy_pass http://127.0.0.1:8080;
    }
}
```

---



## nginx相关语法

### Nginx 内置变量

```nginx
# ============================================================
# Cookie 相关变量
# ============================================================

$cookie_name          # 读取名为 "name" 的 Cookie 值
$cookie_bot_check     # 读取名为 "bot_check" 的 Cookie
$cookie_session_id    # 读取名为 "session_id" 的 Cookie

# 示例：检查 Cookie 是否存在且匹配
if ($cookie_verified = "secret_value") {
    # Cookie 匹配时执行
}

# ============================================================
# 请求头变量
# ============================================================

$http_user_agent      # User-Agent 请求头
$http_referer         # Referer 请求头
$http_accept          # Accept 请求头
$http_accept_language # Accept-Language 请求头
$http_x_forwarded_for # X-Forwarded-For 请求头（代理场景）

# ============================================================
# 请求信息变量
# ============================================================

$remote_addr          # 客户端 IP 地址
$request_uri          # 完整请求 URI（含参数）
$uri                  # 不含参数的 URI
$args                 # 查询字符串参数
$request_method       # 请求方法（GET/POST等）
$scheme               # 协议（http/https）
$host                 # 请求的主机名
```

### 条件判断语法

```nginx
# ============================================================
# if 指令语法
# ============================================================

# 1. 变量存在性检查
if ($variable) {
    # $variable 非空时执行
}

# 2. 等值比较
if ($variable = "value") {
    # 完全相等时执行
}

if ($variable != "value") {
    # 不相等时执行
}

# 3. 正则匹配
if ($variable ~ "pattern") {
    # 区分大小写的正则匹配
}

if ($variable ~* "pattern") {
    # 不区分大小写的正则匹配
}

if ($variable !~ "pattern") {
    # 正则不匹配
}

# 4. 文件/目录检查
if (-f $filename) {
    # 文件存在
}

if (-d $dirname) {
    # 目录存在
}

if (-e $path) {
    # 路径存在（文件或目录）
}
```

---

### 返回指令详解

```nginx
# ============================================================
# return 指令
# ============================================================

# 语法：return code [text];
#       return code URL;
#       return URL;

# 返回状态码
return 403;           # 返回 403 Forbidden
return 444;           # Nginx 特殊码：直接关闭连接，无响应

# 返回状态码和内容
return 200 "OK";      # 返回 200 和文本内容
return 200 '<html>...</html>';  # 返回 HTML

# 重定向
return 301 https://example.com$request_uri;  # 永久重定向
return 302 /new-page;                         # 临时重定向

# ============================================================
# add_header 指令
# ============================================================

# 语法：add_header name value [always];

add_header Content-Type "text/html; charset=utf-8";
add_header Cache-Control "no-cache, no-store";
add_header X-Frame-Options "DENY";
add_header Set-Cookie "name=value; path=/; max-age=3600";

# always 参数：即使返回错误状态码也添加头
add_header X-Custom "value" always;
```

---

### Cookie 设置详解

```javascript
// ============================================================
// JavaScript 中设置 Cookie
// ============================================================

// 基本语法
document.cookie = "name=value";

// 完整语法
document.cookie = "name=value; " +    // Cookie 名称和值
                  "path=/; " +         // 有效路径
                  "max-age=86400; " +  // 有效期（秒）
                  "domain=.example.com; " +  // 有效域名
                  "secure; " +         // 仅 HTTPS
                  "SameSite=Strict";   // 同站策略

// ============================================================
// 各属性详解
// ============================================================

/*
 * path=/
 * - 指定 Cookie 在哪些路径下有效
 * - path=/ 表示整个网站
 * - path=/admin 表示只在 /admin 下有效
 */

/*
 * max-age=86400
 * - Cookie 有效期，单位：秒
 * - 86400 = 24小时
 * - 不设置则为会话 Cookie（关闭浏览器失效）
 */

/*
 * expires=Thu, 01 Jan 2025 00:00:00 GMT
 * - 指定过期时间（绝对时间）
 * - 与 max-age 二选一
 */

/*
 * domain=.example.com
 * - Cookie 有效的域名
 * - 前缀点号表示包含子域名
 */

/*
 * secure
 * - 仅在 HTTPS 连接时发送
 * - 生产环境建议启用
 */

/*
 * SameSite=Strict|Lax|None
 * - Strict：仅同站请求携带（最安全）
 * - Lax：导航到目标网站时携带（默认）
 * - None：跨站也携带（需要 secure）
 */

/*
 * HttpOnly
 * - 禁止 JavaScript 访问
 * - 只能由服务器设置，无法在 JS 中设置
 */
```

---

## 安全性增强方案

### 服务端令牌验证

```nginx
# 使用 Nginx 变量生成动态令牌
server {
    listen 80;
    
    # 生成基于时间的密钥（每小时变化）
    set_by_lua_block $time_key {
        local hour = os.date("%Y%m%d%H")
        local secret = "your_secret_key"
        -- 简单哈希
        return ngx.md5(hour .. secret)
    }
    
    # 验证 Cookie
    set $valid 0;
    if ($cookie_token = $time_key) {
        set $valid 1;
    }
    
    location / {
        if ($valid = 0) {
            # 返回 JS 挑战页面
            # JS 中需要计算出正确的 $time_key
        }
    }
}
```

### 防止令牌被复制

```javascript
// 绑定浏览器指纹到令牌
function generateBoundToken() {
    var fingerprint = {
        userAgent: navigator.userAgent,
        screen: screen.width + "x" + screen.height,
        timezone: new Date().getTimezoneOffset(),
        language: navigator.language
    };
    
    // 生成指纹哈希
    var fpString = JSON.stringify(fingerprint);
    var fpHash = simpleHash(fpString);
    
    // 令牌 = 时间戳 + 指纹哈希
    var token = Date.now().toString(36) + "_" + fpHash;
    
    return token;
}

// 服务端可以验证令牌中的指纹是否匹配请求头
```

---

## 完整生产配置

```nginx
# /etc/nginx/sites-available/example.com

server {
    listen 80;
    server_name example.com www.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name example.com www.example.com;
    
    # SSL 配置
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    
    # 验证变量
    set $need_challenge 1;
    
    # 有效令牌格式：32位十六进制
    if ($cookie_security_token ~* "^[a-f0-9]{32}$") {
        set $need_challenge 0;
    }
    
    # 搜索引擎白名单
    if ($http_user_agent ~* "(Googlebot|Bingbot|Baiduspider|YandexBot|DuckDuckBot)") {
        set $need_challenge 0;
    }
    
    # 支付回调白名单
    if ($http_user_agent ~* "(PayPal|Stripe|Alipay)") {
        set $need_challenge 0;
    }
    
    # API 端点跳过验证（需要其他认证方式）
    location /api/ {
        # API 使用 Token 认证，不需要 JS 验证
        proxy_pass http://backend;
    }
    
    # 静态资源跳过验证
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|mp4|webp)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
    
    # 健康检查端点
    location /health {
        return 200 "OK";
    }
    
    # 主要位置块
    location / {
        if ($need_challenge = 1) {
            add_header Content-Type "text/html; charset=utf-8" always;
            add_header Cache-Control "no-cache, no-store, must-revalidate" always;
            return 200 '... JS 挑战页面内容 ...';
        }
        
        # 通过验证，代理到后端
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## 调试与测试

```bash
# 测试无 Cookie 的请求（应返回 JS 页面）
curl -v https://example.com/

# 测试带 Cookie 的请求（应返回正常页面）
curl -v -b "security_token=abc123def456789012345678901234" https://example.com/

# 测试搜索引擎（应返回正常页面）
curl -v -A "Googlebot/2.1" https://example.com/

# 使用浏览器开发者工具查看
# 1. 打开 Network 面板
# 2. 观察首次请求返回 JS 页面
# 3. JS 执行后设置 Cookie
# 4. 页面刷新，返回正常内容
# 5. 检查 Application > Cookies 确认 Cookie 已设置
```

