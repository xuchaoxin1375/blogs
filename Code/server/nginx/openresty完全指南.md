[toc]

# OpenResty 系统学习指南

OpenResty 是一个基于 Nginx 和 LuaJIT 的高性能 Web 平台，它将 Nginx 的高并发能力与 Lua 的灵活性完美结合，使开发者能够在 Nginx 内部直接编写复杂的业务逻辑。本指南将从基础到高级，全面系统地介绍 OpenResty。

------

## 第一章：OpenResty 概述与核心架构

### 1.1 什么是 OpenResty

OpenResty 由章亦春（agentzh）于 2011 年创建，其核心理念是将 Nginx 从一个静态的 Web 服务器和反向代理转变为一个可编程的 Web 应用服务器。它通过 ngx_lua 模块将 LuaJIT 嵌入 Nginx，使得开发者可以用 Lua 脚本控制请求处理的每个阶段。

OpenResty 的核心价值在于：它保留了 Nginx 的高性能和低资源消耗特性，同时提供了动态编程能力。传统的 Nginx 配置是静态的，修改后需要 reload；而 OpenResty 允许在运行时动态改变行为，无需重启服务。

### 1.2 架构设计原理

OpenResty 的架构建立在 Nginx 的事件驱动模型之上。Nginx 使用 epoll（Linux）或 kqueue（BSD）等高效的 I/O 多路复用机制，单个 worker 进程可以处理数万并发连接。OpenResty 在此基础上引入了协程（coroutine）概念，将异步非阻塞编程转化为同步风格的代码。

当一个请求到达时，Nginx 将其分配给某个 worker 进程。在 OpenResty 中，每个请求对应一个 Lua 协程。当协程执行到 I/O 操作（如访问数据库或调用外部 API）时，它会自动让出执行权，Nginx 继续处理其他请求。当 I/O 操作完成后，协程被唤醒继续执行。这种机制使得代码看起来是同步的，但实际执行是非阻塞的。

```
┌─────────────────────────────────────────────────────────────┐
│                      OpenResty 架构                          │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐    │
│  │                    Nginx Core                        │    │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐            │    │
│  │  │ Worker 1 │ │ Worker 2 │ │ Worker N │  ...       │    │
│  │  └────┬─────┘ └────┬─────┘ └────┬─────┘            │    │
│  └───────┼────────────┼────────────┼──────────────────┘    │
│          │            │            │                        │
│  ┌───────▼────────────▼────────────▼──────────────────┐    │
│  │                  ngx_lua 模块                        │    │
│  │  ┌─────────────────────────────────────────────┐   │    │
│  │  │              LuaJIT VM                       │   │    │
│  │  │  ┌─────────┐ ┌─────────┐ ┌─────────┐       │   │    │
│  │  │  │协程 1   │ │协程 2   │ │协程 N   │  ...  │   │    │
│  │  │  └─────────┘ └─────────┘ └─────────┘       │   │    │
│  │  └─────────────────────────────────────────────┘   │    │
│  └────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    Lua 库生态                         │   │
│  │  lua-resty-redis │ lua-resty-mysql │ lua-resty-http │   │
│  │  lua-resty-limit │ lua-resty-lrucache │ ...         │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 1.3 Nginx 处理阶段与 OpenResty 指令

Nginx 将 HTTP 请求处理分为多个阶段，OpenResty 为每个阶段提供了相应的 Lua 钩子指令。理解这些阶段是掌握 OpenResty 的关键。

请求处理按以下顺序经过各个阶段：

**init_by_lua** 阶段在 Nginx 启动时执行，且只执行一次。它在 master 进程中运行，适合加载 Lua 模块、初始化全局配置、预编译正则表达式等。此阶段不能访问请求相关的 API。

**init_worker_by_lua** 阶段在每个 worker 进程启动时执行。它适合建立与后端服务的连接池、启动后台定时任务（timer）、初始化 worker 级别的共享数据等。

**ssl_certificate_by_lua** 阶段在 SSL/TLS 握手时执行，用于动态选择证书、实现 SNI 等高级 SSL 功能。

**set_by_lua** 阶段在 Nginx 变量设置阶段执行，用于动态计算变量值。此阶段是阻塞的，应避免执行耗时操作。

**rewrite_by_lua** 阶段在 URL 重写阶段执行，可用于实现复杂的重写逻辑、请求预处理等。

**access_by_lua** 阶段在访问控制阶段执行，适合实现认证授权、IP 黑白名单、请求频率限制等安全相关功能。

**content_by_lua** 阶段是内容生成阶段，是最常用的阶段。在这里可以生成响应内容、调用后端服务、处理业务逻辑等。

**header_filter_by_lua** 阶段用于修改响应头，可以添加、删除或修改 HTTP 响应头。

**body_filter_by_lua** 阶段用于处理响应体，可以实现响应内容的修改、压缩、加密等。

**log_by_lua** 阶段在请求处理完成后执行，用于日志记录、统计分析等。此阶段不能影响响应内容。

**balancer_by_lua** 阶段用于实现自定义的负载均衡策略。

```
┌──────────────────────────────────────────────────────────────┐
│                    请求处理流程                               │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│   请求到达                                                    │
│      │                                                       │
│      ▼                                                       │
│   ┌──────────────────┐                                       │
│   │ ssl_certificate  │ ← SSL/TLS 握手（如果是 HTTPS）         │
│   └────────┬─────────┘                                       │
│            ▼                                                 │
│   ┌──────────────────┐                                       │
│   │    set_by_lua    │ ← 设置变量                             │
│   └────────┬─────────┘                                       │
│            ▼                                                 │
│   ┌──────────────────┐                                       │
│   │  rewrite_by_lua  │ ← URL 重写、请求预处理                  │
│   └────────┬─────────┘                                       │
│            ▼                                                 │
│   ┌──────────────────┐                                       │
│   │  access_by_lua   │ ← 认证授权、访问控制                    │
│   └────────┬─────────┘                                       │
│            ▼                                                 │
│   ┌──────────────────┐                                       │
│   │ content_by_lua   │ ← 生成响应内容                         │
│   └────────┬─────────┘                                       │
│            ▼                                                 │
│   ┌──────────────────┐                                       │
│   │header_filter_lua │ ← 修改响应头                           │
│   └────────┬─────────┘                                       │
│            ▼                                                 │
│   ┌──────────────────┐                                       │
│   │ body_filter_lua  │ ← 处理响应体                           │
│   └────────┬─────────┘                                       │
│            ▼                                                 │
│   ┌──────────────────┐                                       │
│   │    log_by_lua    │ ← 日志记录                             │
│   └────────┬─────────┘                                       │
│            ▼                                                 │
│      响应发送                                                 │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

------

## 第二章：安装与基础配置

### 2.1 安装方式

OpenResty 提供多种安装方式，推荐使用官方预编译包以获得最佳兼容性。

对于 Ubuntu/Debian 系统，首先添加官方仓库：

```bash
# 安装依赖
sudo apt-get install -y gnupg ca-certificates

# 导入 GPG 密钥
curl https://openresty.org/package/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/openresty.gpg

# 添加官方仓库（以 Ubuntu 22.04 为例）
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/openresty.list > /dev/null

# 更新并安装
sudo apt-get update
sudo apt-get install -y openresty
```

对于 CentOS/RHEL 系统：

```bash
# 添加官方仓库
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo

# 安装
sudo yum install -y openresty
```

对于 macOS 系统，使用 Homebrew：

```bash
brew install openresty/brew/openresty
```

如果需要定制功能，可以从源码编译：

```bash
# 安装编译依赖
sudo apt-get install -y build-essential libpcre3-dev libssl-dev zlib1g-dev

# 下载源码
wget https://openresty.org/download/openresty-1.25.3.1.tar.gz
tar -xzf openresty-1.25.3.1.tar.gz
cd openresty-1.25.3.1

# 配置编译选项
./configure --prefix=/opt/openresty \
            --with-luajit \
            --with-pcre-jit \
            --with-http_v2_module \
            --with-http_ssl_module \
            --with-http_realip_module \
            --with-http_stub_status_module \
            -j4

# 编译安装
make -j4
sudo make install
```

### 2.2 目录结构

安装完成后，OpenResty 的典型目录结构如下：

```
/usr/local/openresty/              # 默认安装目录
├── bin/                           # 可执行文件
│   ├── openresty                  # 主程序（指向 nginx）
│   ├── opm                        # 包管理器
│   └── resty                      # 命令行工具
├── luajit/                        # LuaJIT
│   ├── bin/
│   ├── include/
│   └── lib/
├── lualib/                        # Lua 库
│   ├── cjson.so                   # JSON 编解码
│   ├── resty/                     # resty 系列库
│   │   ├── core.lua
│   │   ├── redis.lua
│   │   ├── mysql.lua
│   │   └── ...
│   └── ngx/                       # ngx 系列库
├── nginx/                         # Nginx
│   ├── conf/                      # 配置文件
│   ├── html/                      # 静态文件
│   ├── logs/                      # 日志
│   └── sbin/nginx                 # Nginx 可执行文件
└── pod/                           # 文档
```

### 2.3 基础配置结构

一个典型的 OpenResty 配置文件结构如下：

```nginx
# nginx.conf

# worker 进程数，通常设置为 CPU 核心数
worker_processes auto;

# 错误日志
error_log logs/error.log info;

# 事件模块配置
events {
    # 单个 worker 最大连接数
    worker_connections 10240;
    
    # 使用 epoll（Linux）
    use epoll;
    
    # 允许同时接受多个连接
    multi_accept on;
}

http {
    # 基础配置
    include       mime.types;
    default_type  application/octet-stream;
    
    # 日志格式
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for" '
                    'rt=$request_time uct="$upstream_connect_time" '
                    'uht="$upstream_header_time" urt="$upstream_response_time"';
    
    access_log logs/access.log main;
    
    # 性能优化
    sendfile        on;
    tcp_nopush      on;
    tcp_nodelay     on;
    keepalive_timeout 65;
    
    # Gzip 压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript;
    gzip_min_length 1024;
    
    # Lua 配置
    lua_package_path "/usr/local/openresty/lualib/?.lua;/opt/app/lua/?.lua;;";
    lua_package_cpath "/usr/local/openresty/lualib/?.so;;";
    
    # 共享内存区域
    lua_shared_dict shared_data 10m;
    lua_shared_dict cache_zone 100m;
    lua_shared_dict rate_limit 10m;
    
    # 初始化脚本
    init_by_lua_file /opt/app/lua/init.lua;
    init_worker_by_lua_file /opt/app/lua/init_worker.lua;
    
    # 包含其他配置
    include /opt/app/conf.d/*.conf;
    
    # 默认服务器
    server {
        listen 80 default_server;
        server_name _;
        
        location / {
            content_by_lua_block {
                ngx.say("Welcome to OpenResty!")
            }
        }
        
        # 健康检查
        location /health {
            content_by_lua_block {
                ngx.say("OK")
            }
        }
    }
}
```

### 2.4 启动与管理

OpenResty 的管理命令与 Nginx 一致：

```bash
# 启动
openresty

# 停止
openresty -s stop

# 优雅停止（等待请求处理完成）
openresty -s quit

# 重新加载配置
openresty -s reload

# 测试配置文件
openresty -t

# 显示版本和编译信息
openresty -V

# 指定配置文件
openresty -c /path/to/nginx.conf
```

------

## 第三章：Lua 语言基础

### 3.1 Lua 语法要点

Lua 是一门简洁而强大的脚本语言。对于 OpenResty 开发者来说，掌握以下核心概念至关重要。

**变量与作用域**

Lua 的变量默认是全局的，这在 OpenResty 中是一个重要的陷阱。在高并发环境下，全局变量会在多个请求间共享，导致数据污染。因此，应始终使用 local 关键字声明局部变量。

```lua
-- 错误：全局变量，会在所有请求间共享
user_count = 0

-- 正确：局部变量，仅在当前作用域有效
local user_count = 0

-- 模块级局部变量
local _M = {}  -- 标准的模块定义方式
```

**数据类型**

Lua 有八种基本类型：nil、boolean、number、string、function、userdata、thread 和 table。在 OpenResty 中最常用的是 string、number、table 和 function。

```lua
-- nil 表示"无"或"不存在"
local value = nil

-- boolean
local is_valid = true

-- number（Lua 5.1/LuaJIT 中统一为双精度浮点数）
local count = 42
local price = 99.99

-- string
local name = "OpenResty"
local long_text = [[
这是多行字符串，
可以包含换行符和"引号"
]]

-- table（Lua 唯一的复合数据结构，可作为数组或字典）
local array = {1, 2, 3, 4, 5}  -- 数组，索引从 1 开始
local dict = {name = "test", age = 18}  -- 字典
local mixed = {
    "first",
    name = "mixed",
    [100] = "sparse"
}

-- function
local function greet(name)
    return "Hello, " .. name
end

-- 或者使用匿名函数
local greet = function(name)
    return "Hello, " .. name
end
```

**控制结构**

```lua
-- if-elseif-else
local score = 85
local grade
if score >= 90 then
    grade = "A"
elseif score >= 80 then
    grade = "B"
elseif score >= 70 then
    grade = "C"
else
    grade = "D"
end

-- for 循环（数值型）
for i = 1, 10 do
    print(i)
end

-- for 循环（倒序）
for i = 10, 1, -1 do
    print(i)
end

-- for 循环（遍历数组，ipairs 用于连续数字索引）
local fruits = {"apple", "banana", "orange"}
for index, value in ipairs(fruits) do
    print(index, value)
end

-- for 循环（遍历表，pairs 用于所有键值对）
local user = {name = "John", age = 30}
for key, value in pairs(user) do
    print(key, value)
end

-- while 循环
local n = 1
while n <= 10 do
    print(n)
    n = n + 1
end

-- repeat-until 循环（至少执行一次）
local n = 1
repeat
    print(n)
    n = n + 1
until n > 10
```

**函数高级特性**

```lua
-- 多返回值
local function get_user()
    return "John", 30, "john@example.com"
end
local name, age, email = get_user()

-- 可变参数
local function sum(...)
    local args = {...}
    local total = 0
    for _, v in ipairs(args) do
        total = total + v
    end
    return total
end
print(sum(1, 2, 3, 4, 5))  -- 输出 15

-- 闭包
local function counter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

local c1 = counter()
print(c1())  -- 1
print(c1())  -- 2

local c2 = counter()
print(c2())  -- 1（独立的计数器）

-- 尾调用优化（Lua 会优化尾调用，不会增加调用栈）
local function factorial(n, acc)
    acc = acc or 1
    if n <= 1 then
        return acc
    end
    return factorial(n - 1, n * acc)  -- 尾调用
end
```

**表操作**

```lua
-- 表的基本操作
local t = {}
t.name = "test"
t["key with spaces"] = "value"
t[1] = "first"

-- 获取数组长度（只计算连续数字索引）
local arr = {1, 2, 3}
print(#arr)  -- 3

-- 表连接
local parts = {"hello", "world", "lua"}
local result = table.concat(parts, ", ")  -- "hello, world, lua"

-- 表排序
local numbers = {3, 1, 4, 1, 5, 9}
table.sort(numbers)  -- 原地排序

-- 自定义排序
local users = {
    {name = "Bob", age = 25},
    {name = "Alice", age = 30},
    {name = "Charlie", age = 20}
}
table.sort(users, function(a, b)
    return a.age < b.age
end)

-- 表插入和删除
local list = {1, 2, 3}
table.insert(list, 4)       -- 在末尾插入
table.insert(list, 1, 0)    -- 在位置1插入
table.remove(list)          -- 删除末尾元素
table.remove(list, 1)       -- 删除位置1的元素
```

**字符串操作**

```lua
-- 字符串连接
local greeting = "Hello, " .. "World!"

-- 字符串长度
local len = #greeting

-- 字符串方法
local s = "Hello, World!"
print(string.upper(s))           -- "HELLO, WORLD!"
print(string.lower(s))           -- "hello, world!"
print(string.sub(s, 1, 5))       -- "Hello"
print(string.find(s, "World"))   -- 8, 12（起始和结束位置）
print(string.gsub(s, "World", "Lua"))  -- "Hello, Lua!"

-- 字符串格式化
local formatted = string.format("Name: %s, Age: %d", "John", 30)

-- 模式匹配（Lua 模式不是正则表达式，但足够强大）
local email = "user@example.com"
local user, domain = string.match(email, "(.+)@(.+)")
print(user, domain)  -- "user", "example.com"

-- 常用模式字符：
-- .   任意字符
-- %a  字母
-- %d  数字
-- %s  空白字符
-- %w  字母数字
-- *   零次或多次
-- +   一次或多次
-- ?   零次或一次
-- -   最短匹配
```

### 3.2 模块化编程

在 OpenResty 中，代码应该组织成模块以便复用和维护：

```lua
-- lib/utils.lua
local _M = {}
_M._VERSION = "1.0.0"

-- 私有函数
local function internal_helper(x)
    return x * 2
end

-- 公开函数
function _M.add(a, b)
    return a + b
end

function _M.multiply(a, b)
    return internal_helper(a) * b
end

-- 公开常量
_M.PI = 3.14159

return _M
```

使用模块：

```lua
-- 在其他文件中使用
local utils = require "lib.utils"

print(utils.add(1, 2))        -- 3
print(utils.PI)               -- 3.14159
print(utils._VERSION)         -- "1.0.0"
```

### 3.3 错误处理

Lua 使用 pcall 和 xpcall 进行错误处理：

```lua
-- pcall：受保护调用
local function risky_function(x)
    if x < 0 then
        error("x cannot be negative")
    end
    return math.sqrt(x)
end

local ok, result = pcall(risky_function, -1)
if ok then
    print("Result:", result)
else
    print("Error:", result)
end

-- xpcall：带错误处理函数的保护调用
local function error_handler(err)
    return debug.traceback("Error: " .. tostring(err))
end

local ok, result = xpcall(function()
    return risky_function(-1)
end, error_handler)

if not ok then
    print(result)  -- 包含堆栈跟踪
end
```

------

## 第四章：OpenResty 核心 API

### 4.1 ngx 全局表

ngx 是 OpenResty 提供的核心 API 表，包含了几乎所有与 Nginx 交互的功能。

**请求信息获取**

```lua
-- 获取请求方法
local method = ngx.req.get_method()  -- GET, POST, PUT, DELETE 等

-- 获取 URI
local uri = ngx.var.uri              -- 不含查询参数
local request_uri = ngx.var.request_uri  -- 含查询参数

-- 获取 URI 参数（GET 参数）
local args = ngx.req.get_uri_args()
-- 对于 /path?name=john&age=30
-- args.name = "john", args.age = "30"

-- 获取单个参数（更高效）
local name = ngx.var.arg_name

-- 获取 POST 参数
ngx.req.read_body()  -- 必须先读取请求体
local post_args = ngx.req.get_post_args()

-- 获取请求头
local headers = ngx.req.get_headers()
local host = headers["host"]
local user_agent = headers["user-agent"]

-- 或者获取单个头
local content_type = ngx.var.http_content_type

-- 获取请求体
ngx.req.read_body()
local body = ngx.req.get_body_data()

-- 大请求体可能被存储到临时文件
local body_file = ngx.req.get_body_file()
if body_file then
    local f = io.open(body_file, "r")
    local body = f:read("*all")
    f:close()
end
```

**响应控制**

```lua
-- 设置响应状态码
ngx.status = 200
ngx.status = ngx.HTTP_OK

-- 常用状态码常量
-- ngx.HTTP_OK (200)
-- ngx.HTTP_CREATED (201)
-- ngx.HTTP_MOVED_PERMANENTLY (301)
-- ngx.HTTP_MOVED_TEMPORARILY (302)
-- ngx.HTTP_BAD_REQUEST (400)
-- ngx.HTTP_UNAUTHORIZED (401)
-- ngx.HTTP_FORBIDDEN (403)
-- ngx.HTTP_NOT_FOUND (404)
-- ngx.HTTP_INTERNAL_SERVER_ERROR (500)

-- 设置响应头
ngx.header["Content-Type"] = "application/json"
ngx.header["X-Custom-Header"] = "custom-value"
ngx.header["Cache-Control"] = "no-cache"

-- 删除响应头
ngx.header["X-Powered-By"] = nil

-- 发送响应
ngx.say("Hello, World!")    -- 自动添加换行符
ngx.print("Hello, World!")  -- 不添加换行符

-- 发送多个参数
ngx.say("Name: ", name, ", Age: ", age)

-- 刷新输出缓冲区
ngx.flush()

-- 结束请求处理
ngx.exit(ngx.HTTP_OK)
```

**重定向与内部跳转**

```lua
-- 外部重定向（发送 302 响应）
return ngx.redirect("/new-path")
return ngx.redirect("/new-path", ngx.HTTP_MOVED_PERMANENTLY)  -- 301

-- 内部跳转（不改变 URL，服务器端跳转）
ngx.exec("/internal-location")

-- 注意：ngx.exec 后的代码不会执行
```

### 4.2 共享内存字典

lua_shared_dict 提供了跨 worker 进程共享数据的能力，是 OpenResty 中最重要的数据共享机制之一。

```nginx
# nginx.conf 中定义
http {
    lua_shared_dict cache 100m;
    lua_shared_dict locks 1m;
    lua_shared_dict stats 10m;
}
-- 获取共享字典
local cache = ngx.shared.cache

-- 设置值
local success, err, forcible = cache:set("key", "value")
-- success: 是否成功
-- err: 错误信息
-- forcible: 是否因内存不足而强制淘汰了其他键

-- 设置带过期时间的值（秒）
cache:set("session:abc123", user_data, 3600)  -- 1小时后过期

-- 设置带标志的值
cache:set("key", "value", 3600, 1)  -- 第四个参数是用户自定义标志

-- 获取值
local value, flags = cache:get("key")
if value == nil then
    -- 键不存在或已过期
end

-- 删除键
cache:delete("key")

-- 原子递增
local new_val, err = cache:incr("counter", 1)
if not new_val then
    cache:set("counter", 1)
    new_val = 1
end

-- 带初始值的递增（如果键不存在则初始化为指定值）
local new_val, err = cache:incr("counter", 1, 0)  -- 初始值为0

-- 原子递增带过期时间
local new_val, err = cache:incr("rate:192.168.1.1", 1, 0, 60)

-- 添加（仅当键不存在时设置）
local success, err = cache:add("key", "value", 3600)

-- 替换（仅当键存在时设置）
local success, err = cache:replace("key", "new_value")

-- 获取所有键（注意：性能开销大，仅用于调试）
local keys = cache:get_keys(0)  -- 0 表示获取所有键

-- 获取共享内存使用情况
local capacity = cache:capacity()
local free_space = cache:free_space()
```

**共享内存的最佳实践**

```lua
-- lib/cache_helper.lua
local _M = {}

local cache = ngx.shared.cache

-- 获取或设置（带回源函数）
function _M.get_or_set(key, fetch_func, ttl)
    local value = cache:get(key)
    if value ~= nil then
        return value
    end
    
    -- 缓存未命中，调用回源函数
    local data, err = fetch_func()
    if err then
        return nil, err
    end
    
    -- 存入缓存
    cache:set(key, data, ttl or 300)
    return data
end

-- 带锁的获取或设置（防止缓存击穿）
local locks = ngx.shared.locks
local resty_lock = require "resty.lock"

function _M.get_or_set_locked(key, fetch_func, ttl)
    local value = cache:get(key)
    if value ~= nil then
        return value
    end
    
    -- 获取锁
    local lock, err = resty_lock:new("locks")
    if not lock then
        return nil, "failed to create lock: " .. err
    end
    
    local lock_key = "lock:" .. key
    local elapsed, err = lock:lock(lock_key)
    if not elapsed then
        return nil, "failed to acquire lock: " .. err
    end
    
    -- 双重检查
    value = cache:get(key)
    if value ~= nil then
        lock:unlock()
        return value
    end
    
    -- 获取数据
    local data, err = fetch_func()
    if err then
        lock:unlock()
        return nil, err
    end
    
    cache:set(key, data, ttl or 300)
    lock:unlock()
    
    return data
end

return _M
```

### 4.3 cosocket：非阻塞网络通信

cosocket 是 OpenResty 的核心特性，它提供了同步风格的 API 来执行非阻塞 I/O 操作。

```lua
-- 创建 TCP socket
local sock = ngx.socket.tcp()

-- 设置超时
sock:settimeout(1000)  -- 1秒超时
-- 或分别设置
sock:settimeouts(1000, 2000, 3000)  -- 连接、发送、读取超时

-- 连接服务器
local ok, err = sock:connect("127.0.0.1", 6379)
if not ok then
    ngx.log(ngx.ERR, "failed to connect: ", err)
    return
end

-- 发送数据
local bytes, err = sock:send("PING\r\n")
if not bytes then
    ngx.log(ngx.ERR, "failed to send: ", err)
    return
end

-- 接收数据
local line, err = sock:receive()  -- 读取一行
if not line then
    ngx.log(ngx.ERR, "failed to receive: ", err)
    return
end

-- 其他接收方式
local data, err = sock:receive(10)      -- 读取指定字节数
local data, err = sock:receive("*a")    -- 读取所有数据（直到连接关闭）
local data, err = sock:receive("*l")    -- 读取一行（不含换行符）

-- 连接复用（放入连接池）
sock:setkeepalive(60000, 100)  -- 60秒空闲超时，池大小100

-- 关闭连接
sock:close()
```

**UDP socket**

```lua
local udp = ngx.socket.udp()

udp:settimeout(1000)

local ok, err = udp:setpeername("8.8.8.8", 53)
if not ok then
    ngx.log(ngx.ERR, "failed to set peer: ", err)
    return
end

local ok, err = udp:send("hello")
if not ok then
    ngx.log(ngx.ERR, "failed to send: ", err)
    return
end

local data, err = udp:receive()
if not data then
    ngx.log(ngx.ERR, "failed to receive: ", err)
    return
end

udp:close()
```

### 4.4 子请求与 location 捕获

子请求允许在 Lua 中调用其他 location：

```lua
-- 发起单个子请求
local res = ngx.location.capture("/api/user", {
    method = ngx.HTTP_GET,
    args = { id = 123 }
})

print(res.status)   -- HTTP 状态码
print(res.body)     -- 响应体
print(res.header["Content-Type"])  -- 响应头

-- 发起 POST 请求
local res = ngx.location.capture("/api/user", {
    method = ngx.HTTP_POST,
    body = "name=john&age=30"
})

-- 发起多个并发子请求
local res1, res2, res3 = ngx.location.capture_multi({
    { "/api/user", { args = { id = 1 } } },
    { "/api/order", { args = { user_id = 1 } } },
    { "/api/product", { args = { id = 100 } } }
})

-- 处理多个响应
if res1.status == 200 and res2.status == 200 then
    -- 合并数据
end
```

**子请求的选项**

```lua
local res = ngx.location.capture("/internal", {
    method = ngx.HTTP_POST,  -- 请求方法
    body = "request body",    -- 请求体
    args = { key = "value" }, -- 查询参数
    ctx = { custom = "data" }, -- 传递给子请求的上下文
    copy_all_vars = true,     -- 复制所有 Nginx 变量
    vars = { foo = "bar" },   -- 设置 Nginx 变量
    always_forward_body = true  -- 转发原始请求体
})
```

### 4.5 定时器

ngx.timer 允许在后台执行异步任务：

```lua
-- 一次性定时器（延迟执行）
local function my_task(premature, arg1, arg2)
    if premature then
        -- worker 正在关闭
        return
    end
    
    -- 执行任务
    ngx.log(ngx.INFO, "Task executed with args: ", arg1, ", ", arg2)
end

-- 延迟 5 秒执行
local ok, err = ngx.timer.at(5, my_task, "hello", "world")
if not ok then
    ngx.log(ngx.ERR, "failed to create timer: ", err)
end

-- 立即执行（在当前请求之后）
ngx.timer.at(0, my_task, "immediate")
```

**周期性定时器**

```lua
-- init_worker_by_lua 中设置周期性任务
local function periodic_task(premature)
    if premature then
        return
    end
    
    -- 执行任务
    ngx.log(ngx.INFO, "Periodic task running")
    
    -- 调度下一次执行
    local ok, err = ngx.timer.at(10, periodic_task)
    if not ok then
        ngx.log(ngx.ERR, "failed to create timer: ", err)
    end
end

-- 启动周期性任务
ngx.timer.at(0, periodic_task)
```

**使用 ngx.timer.every（OpenResty 1.11.2.1+）**

```lua
-- 更简洁的周期性定时器
local ok, err = ngx.timer.every(10, function(premature)
    if premature then
        return
    end
    -- 每 10 秒执行一次
    ngx.log(ngx.INFO, "Running every 10 seconds")
end)

if not ok then
    ngx.log(ngx.ERR, "failed to create timer: ", err)
end
```

**定时器的限制与注意事项**

```nginx
# 限制运行中的定时器数量
lua_max_running_timers 256;

# 限制等待执行的定时器数量
lua_max_pending_timers 1024;
```

------

## 第五章：常用 lua-resty 库

### 5.1 lua-resty-redis

lua-resty-redis 是与 Redis 通信的高性能客户端：

```lua
local redis = require "resty.redis"

local red = redis:new()

-- 设置超时
red:set_timeout(1000)  -- 1秒

-- 连接 Redis
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.log(ngx.ERR, "failed to connect: ", err)
    return
end

-- 认证（如果需要）
local res, err = red:auth("password")
if not res then
    ngx.log(ngx.ERR, "failed to authenticate: ", err)
    return
end

-- 选择数据库
red:select(0)

-- 基本操作
red:set("key", "value")
local value, err = red:get("key")

-- 哈希操作
red:hset("user:1", "name", "john")
red:hset("user:1", "age", "30")
local name = red:hget("user:1", "name")
local user = red:hgetall("user:1")

-- 列表操作
red:lpush("queue", "task1")
red:rpush("queue", "task2")
local task = red:lpop("queue")

-- 集合操作
red:sadd("tags", "lua", "openresty", "nginx")
local members = red:smembers("tags")

-- 有序集合
red:zadd("leaderboard", 100, "player1")
red:zadd("leaderboard", 200, "player2")
local top10 = red:zrevrange("leaderboard", 0, 9, "WITHSCORES")

-- 设置过期时间
red:setex("session:abc", 3600, session_data)
red:expire("key", 300)

-- 管道（Pipeline）批量操作
red:init_pipeline()
for i = 1, 100 do
    red:set("key" .. i, "value" .. i)
end
local results, err = red:commit_pipeline()

-- 事务
red:multi()
red:incr("counter")
red:set("last_update", ngx.now())
local results, err = red:exec()

-- 连接放回连接池
local ok, err = red:set_keepalive(60000, 100)
if not ok then
    ngx.log(ngx.ERR, "failed to set keepalive: ", err)
end
```

**Redis 操作封装**

```lua
-- lib/redis_helper.lua
local redis = require "resty.redis"
local cjson = require "cjson.safe"

local _M = {}

local function get_connection()
    local red = redis:new()
    red:set_timeout(1000)
    
    local ok, err = red:connect("127.0.0.1", 6379)
    if not ok then
        return nil, err
    end
    
    return red
end

local function close_connection(red)
    if not red then
        return
    end
    local ok, err = red:set_keepalive(60000, 100)
    if not ok then
        ngx.log(ngx.ERR, "failed to set keepalive: ", err)
    end
end

-- 获取并自动反序列化 JSON
function _M.get_json(key)
    local red, err = get_connection()
    if not red then
        return nil, err
    end
    
    local value, err = red:get(key)
    close_connection(red)
    
    if not value or value == ngx.null then
        return nil
    end
    
    return cjson.decode(value)
end

-- 设置并自动序列化 JSON
function _M.set_json(key, value, ttl)
    local red, err = get_connection()
    if not red then
        return nil, err
    end
    
    local json = cjson.encode(value)
    local ok, err
    if ttl then
        ok, err = red:setex(key, ttl, json)
    else
        ok, err = red:set(key, json)
    end
    
    close_connection(red)
    return ok, err
end

-- 分布式锁
function _M.acquire_lock(key, ttl)
    local red, err = get_connection()
    if not red then
        return nil, err
    end
    
    local lock_key = "lock:" .. key
    local identifier = ngx.var.request_id or tostring(ngx.now())
    
    -- SET key value NX EX ttl
    local ok, err = red:set(lock_key, identifier, "NX", "EX", ttl)
    close_connection(red)
    
    if ok == ngx.null then
        return nil, "lock is held by another process"
    end
    
    return identifier
end

function _M.release_lock(key, identifier)
    local red, err = get_connection()
    if not red then
        return nil, err
    end
    
    local lock_key = "lock:" .. key
    
    -- Lua 脚本确保原子性
    local script = [[
        if redis.call("get", KEYS[1]) == ARGV[1] then
            return redis.call("del", KEYS[1])
        else
            return 0
        end
    ]]
    
    local ok, err = red:eval(script, 1, lock_key, identifier)
    close_connection(red)
    
    return ok, err
end

return _M
```

### 5.2 lua-resty-mysql

lua-resty-mysql 提供了 MySQL/MariaDB 的非阻塞客户端：

```lua
local mysql = require "resty.mysql"

local db, err = mysql:new()
if not db then
    ngx.log(ngx.ERR, "failed to instantiate mysql: ", err)
    return
end

db:set_timeout(1000)

local ok, err, errcode, sqlstate = db:connect({
    host = "127.0.0.1",
    port = 3306,
    database = "myapp",
    user = "root",
    password = "password",
    charset = "utf8mb4",
    max_packet_size = 1024 * 1024
})

if not ok then
    ngx.log(ngx.ERR, "failed to connect: ", err, ": ", errcode, " ", sqlstate)
    return
end

-- 查询
local res, err, errcode, sqlstate = db:query("SELECT * FROM users WHERE id = 1")
if not res then
    ngx.log(ngx.ERR, "bad result: ", err, ": ", errcode, ": ", sqlstate)
    return
end

-- 结果是一个数组
for _, row in ipairs(res) do
    ngx.say("id: ", row.id, ", name: ", row.name)
end

-- 使用参数化查询（防止 SQL 注入）
local function quote_sql_str(str)
    return ngx.quote_sql_str(str)
end

local user_input = "john'; DROP TABLE users; --"
local safe_input = quote_sql_str(user_input)
local sql = "SELECT * FROM users WHERE name = " .. safe_input
local res, err = db:query(sql)

-- 插入数据
local sql = string.format(
    "INSERT INTO users (name, email) VALUES (%s, %s)",
    quote_sql_str("John"),
    quote_sql_str("john@example.com")
)
local res, err = db:query(sql)
if res then
    ngx.say("insert id: ", res.insert_id)
    ngx.say("affected rows: ", res.affected_rows)
end

-- 事务
db:query("START TRANSACTION")

local ok1, err = db:query("UPDATE accounts SET balance = balance - 100 WHERE id = 1")
local ok2, err = db:query("UPDATE accounts SET balance = balance + 100 WHERE id = 2")

if ok1 and ok2 then
    db:query("COMMIT")
else
    db:query("ROLLBACK")
end

-- 连接池
local ok, err = db:set_keepalive(60000, 100)
```

**MySQL 连接池封装**

```lua
-- lib/mysql_helper.lua
local mysql = require "resty.mysql"
local cjson = require "cjson.safe"

local _M = {}

local config = {
    host = os.getenv("MYSQL_HOST") or "127.0.0.1",
    port = tonumber(os.getenv("MYSQL_PORT")) or 3306,
    database = os.getenv("MYSQL_DATABASE") or "myapp",
    user = os.getenv("MYSQL_USER") or "root",
    password = os.getenv("MYSQL_PASSWORD") or "",
    charset = "utf8mb4",
    max_packet_size = 4 * 1024 * 1024,
    pool_size = 100,
    pool_timeout = 60000
}

local function get_connection()
    local db, err = mysql:new()
    if not db then
        return nil, err
    end
    
    db:set_timeout(5000)
    
    local ok, err, errcode, sqlstate = db:connect({
        host = config.host,
        port = config.port,
        database = config.database,
        user = config.user,
        password = config.password,
        charset = config.charset,
        max_packet_size = config.max_packet_size,
        pool = "mysql_pool:" .. config.host .. ":" .. config.database
    })
    
    if not ok then
        return nil, err .. " (" .. (errcode or "") .. ")"
    end
    
    return db
end

local function close_connection(db)
    if not db then return end
    local ok, err = db:set_keepalive(config.pool_timeout, config.pool_size)
    if not ok then
        ngx.log(ngx.WARN, "failed to set keepalive: ", err)
    end
end

function _M.query(sql)
    local db, err = get_connection()
    if not db then
        return nil, err
    end
    
    local res, err, errcode, sqlstate = db:query(sql)
    close_connection(db)
    
    if not res then
        return nil, err .. " (" .. (errcode or "") .. ")"
    end
    
    return res
end

function _M.execute(sql)
    return _M.query(sql)
end

-- 查询单行
function _M.query_one(sql)
    local res, err = _M.query(sql .. " LIMIT 1")
    if not res then
        return nil, err
    end
    return res[1]
end

-- 带参数的查询
function _M.query_with_params(sql, params)
    for i, param in ipairs(params) do
        local safe_param
        if type(param) == "string" then
            safe_param = ngx.quote_sql_str(param)
        elseif param == nil then
            safe_param = "NULL"
        else
            safe_param = tostring(param)
        end
        sql = sql:gsub("%?", safe_param, 1)
    end
    return _M.query(sql)
end

-- 事务支持
function _M.transaction(callback)
    local db, err = get_connection()
    if not db then
        return nil, err
    end
    
    local res, err = db:query("START TRANSACTION")
    if not res then
        close_connection(db)
        return nil, err
    end
    
    local ok, result = pcall(callback, db)
    
    if ok and result then
        db:query("COMMIT")
    else
        db:query("ROLLBACK")
    end
    
    close_connection(db)
    
    if not ok then
        return nil, result
    end
    
    return result
end

return _M
```

### 5.3 lua-resty-http

lua-resty-http 是一个功能完整的 HTTP 客户端：

```lua
local http = require "resty.http"

local httpc = http.new()

-- 设置超时
httpc:set_timeout(5000)

-- 简单的 GET 请求
local res, err = httpc:request_uri("http://api.example.com/users", {
    method = "GET",
    headers = {
        ["Accept"] = "application/json",
        ["Authorization"] = "Bearer token123"
    },
    query = {
        page = 1,
        limit = 10
    }
})

if not res then
    ngx.log(ngx.ERR, "request failed: ", err)
    return
end

ngx.say("Status: ", res.status)
ngx.say("Body: ", res.body)

-- POST 请求（JSON）
local cjson = require "cjson.safe"

local res, err = httpc:request_uri("http://api.example.com/users", {
    method = "POST",
    headers = {
        ["Content-Type"] = "application/json"
    },
    body = cjson.encode({
        name = "John",
        email = "john@example.com"
    })
})

-- POST 请求（表单）
local res, err = httpc:request_uri("http://api.example.com/login", {
    method = "POST",
    headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded"
    },
    body = ngx.encode_args({
        username = "john",
        password = "secret"
    })
})

-- 流式请求（适用于大响应）
local res, err = httpc:request_uri("http://api.example.com/large-file", {
    method = "GET"
})

if res then
    local reader = res.body_reader
    repeat
        local chunk, err = reader(8192)
        if chunk then
            -- 处理分块数据
            ngx.print(chunk)
        end
    until not chunk
end

-- HTTPS 请求
local res, err = httpc:request_uri("https://api.example.com/secure", {
    method = "GET",
    ssl_verify = true  -- 验证 SSL 证书
})

-- 连接复用
httpc:set_keepalive(60000, 100)
```

**HTTP 客户端封装**

```lua
-- lib/http_client.lua
local http = require "resty.http"
local cjson = require "cjson.safe"

local _M = {}

local default_timeout = 10000
local default_keepalive = 60000
local default_pool_size = 100

function _M.request(url, options)
    options = options or {}
    
    local httpc = http.new()
    httpc:set_timeout(options.timeout or default_timeout)
    
    local method = options.method or "GET"
    local headers = options.headers or {}
    local body = options.body
    
    -- 自动序列化 JSON
    if type(body) == "table" then
        body = cjson.encode(body)
        headers["Content-Type"] = headers["Content-Type"] or "application/json"
    end
    
    local res, err = httpc:request_uri(url, {
        method = method,
        headers = headers,
        body = body,
        query = options.query,
        ssl_verify = options.ssl_verify
    })
    
    if not res then
        return nil, err
    end
    
    -- 连接复用
    httpc:set_keepalive(default_keepalive, default_pool_size)
    
    local response = {
        status = res.status,
        headers = res.headers,
        body = res.body
    }
    
    -- 自动解析 JSON
    local content_type = res.headers["Content-Type"] or ""
    if content_type:find("application/json") then
        local json_body, err = cjson.decode(res.body)
        if json_body then
            response.json = json_body
        end
    end
    
    return response
end

function _M.get(url, options)
    options = options or {}
    options.method = "GET"
    return _M.request(url, options)
end

function _M.post(url, body, options)
    options = options or {}
    options.method = "POST"
    options.body = body
    return _M.request(url, options)
end

function _M.put(url, body, options)
    options = options or {}
    options.method = "PUT"
    options.body = body
    return _M.request(url, options)
end

function _M.delete(url, options)
    options = options or {}
    options.method = "DELETE"
    return _M.request(url, options)
end

return _M
```

### 5.4 lua-resty-template

lua-resty-template 是一个快速的模板引擎：

```lua
local template = require "resty.template"

-- 编译并渲染模板字符串
local html = template.compile([[
<!DOCTYPE html>
<html>
<head>
    <title>{{ title }}</title>
</head>
<body>
    <h1>{{ greeting }}</h1>
    <ul>
    {% for _, item in ipairs(items) do %}
        <li>{{ item }}</li>
    {% end %}
    </ul>
    
    {% if show_footer then %}
    <footer>{{ footer_text }}</footer>
    {% end %}
</body>
</html>
]])({
    title = "My Page",
    greeting = "Hello, World!",
    items = {"Apple", "Banana", "Orange"},
    show_footer = true,
    footer_text = "© 2024"
})

ngx.say(html)

-- 从文件加载模板
template.render("views/index.html", {
    user = { name = "John", email = "john@example.com" },
    posts = posts
})

-- 模板继承
-- views/base.html
--[[
<!DOCTYPE html>
<html>
<head>
    <title>{% block title %}Default Title{% endblock %}</title>
</head>
<body>
    {% block content %}{% endblock %}
</body>
</html>
]]

-- views/page.html
--[[
{% extends "views/base.html" %}

{% block title %}{{ page_title }}{% endblock %}

{% block content %}
<h1>{{ heading }}</h1>
<p>{{ content }}</p>
{% endblock %}
]]

template.render("views/page.html", {
    page_title = "My Page",
    heading = "Welcome",
    content = "This is the content"
})
```

### 5.5 lua-cjson

cjson 是高性能的 JSON 编解码库：

```lua
local cjson = require "cjson"
local cjson_safe = require "cjson.safe"  -- 不抛异常的版本

-- 编码（Lua 表 -> JSON 字符串）
local data = {
    name = "John",
    age = 30,
    hobbies = {"reading", "gaming"},
    address = {
        city = "Beijing",
        country = "China"
    }
}

local json_str = cjson.encode(data)
ngx.say(json_str)
-- {"name":"John","age":30,"hobbies":["reading","gaming"],"address":{"city":"Beijing","country":"China"}}

-- 解码（JSON 字符串 -> Lua 表）
local json_str = '{"name":"John","age":30}'
local data = cjson.decode(json_str)
ngx.say(data.name)  -- John

-- 安全版本（不会抛异常）
local data, err = cjson_safe.decode(invalid_json)
if not data then
    ngx.log(ngx.ERR, "JSON decode error: ", err)
end

-- 处理空数组和空对象
local cjson = require "cjson"
cjson.encode_empty_table_as_object(false)  -- {} 编码为 []

-- 或使用 cjson.array_mt
local data = setmetatable({}, cjson.array_mt)
cjson.encode(data)  -- []

-- 处理稀疏数组
cjson.encode_sparse_array(true, 2, 10)

-- 处理 null 值
local json_str = '{"name":null}'
local data = cjson.decode(json_str)
if data.name == cjson.null then
    ngx.say("name is null")
end
```

------

## 第六章：实战应用开发

### 6.1 RESTful API 网关

```lua
-- lib/router.lua
local _M = {}

local routes = {}

local function match_path(pattern, path)
    -- 将路由模式转换为正则表达式
    -- /users/:id -> /users/([^/]+)
    local regex = pattern:gsub(":([%w_]+)", "([^/]+)")
    regex = "^" .. regex .. "$"
    
    local captures = { path:match(regex) }
    if #captures > 0 then
        -- 提取参数名
        local param_names = {}
        for name in pattern:gmatch(":([%w_]+)") do
            table.insert(param_names, name)
        end
        
        local params = {}
        for i, value in ipairs(captures) do
            params[param_names[i]] = value
        end
        return true, params
    end
    
    return false, nil
end

function _M.register(method, pattern, handler)
    table.insert(routes, {
        method = method:upper(),
        pattern = pattern,
        handler = handler
    })
end

function _M.get(pattern, handler)
    _M.register("GET", pattern, handler)
end

function _M.post(pattern, handler)
    _M.register("POST", pattern, handler)
end

function _M.put(pattern, handler)
    _M.register("PUT", pattern, handler)
end

function _M.delete(pattern, handler)
    _M.register("DELETE", pattern, handler)
end

function _M.dispatch()
    local method = ngx.req.get_method()
    local uri = ngx.var.uri
    
    for _, route in ipairs(routes) do
        if route.method == method then
            local matched, params = match_path(route.pattern, uri)
            if matched then
                ngx.ctx.params = params
                return route.handler()
            end
        end
    end
    
    ngx.status = 404
    ngx.say('{"error": "Not Found"}')
    return ngx.exit(404)
end

return _M
-- lib/response.lua
local cjson = require "cjson.safe"

local _M = {}

function _M.json(data, status)
    ngx.status = status or 200
    ngx.header["Content-Type"] = "application/json"
    ngx.say(cjson.encode(data))
end

function _M.success(data, message)
    _M.json({
        code = 0,
        message = message or "success",
        data = data
    })
end

function _M.error(message, code, status)
    ngx.status = status or 400
    ngx.header["Content-Type"] = "application/json"
    ngx.say(cjson.encode({
        code = code or -1,
        message = message or "error",
        data = nil
    }))
end

return _M
-- api/users.lua
local router = require "lib.router"
local response = require "lib.response"
local mysql = require "lib.mysql_helper"
local cjson = require "cjson.safe"

-- 获取用户列表
router.get("/api/users", function()
    local page = tonumber(ngx.var.arg_page) or 1
    local limit = tonumber(ngx.var.arg_limit) or 10
    local offset = (page - 1) * limit
    
    local sql = string.format(
        "SELECT id, name, email, created_at FROM users LIMIT %d OFFSET %d",
        limit, offset
    )
    
    local users, err = mysql.query(sql)
    if not users then
        return response.error("Database error: " .. err, 500, 500)
    end
    
    -- 获取总数
    local count_result = mysql.query_one("SELECT COUNT(*) as total FROM users")
    local total = count_result and count_result.total or 0
    
    return response.success({
        items = users,
        pagination = {
            page = page,
            limit = limit,
            total = total,
            pages = math.ceil(total / limit)
        }
    })
end)

-- 获取单个用户
router.get("/api/users/:id", function()
    local user_id = ngx.ctx.params.id
    
    local user, err = mysql.query_one(
        "SELECT id, name, email, created_at FROM users WHERE id = " .. ngx.quote_sql_str(user_id)
    )
    
    if not user then
        return response.error("User not found", 404, 404)
    end
    
    return response.success(user)
end)

-- 创建用户
router.post("/api/users", function()
    ngx.req.read_body()
    local body = ngx.req.get_body_data()
    local data, err = cjson.decode(body)
    
    if not data then
        return response.error("Invalid JSON: " .. err, 400)
    end
    
    -- 验证输入
    if not data.name or not data.email then
        return response.error("Name and email are required", 400)
    end
    
    local sql = string.format(
        "INSERT INTO users (name, email, created_at) VALUES (%s, %s, NOW())",
        ngx.quote_sql_str(data.name),
        ngx.quote_sql_str(data.email)
    )
    
    local result, err = mysql.execute(sql)
    if not result then
        return response.error("Failed to create user: " .. err, 500, 500)
    end
    
    return response.success({
        id = result.insert_id,
        name = data.name,
        email = data.email
    }, "User created successfully")
end)

-- 更新用户
router.put("/api/users/:id", function()
    local user_id = ngx.ctx.params.id
    
    ngx.req.read_body()
    local body = ngx.req.get_body_data()
    local data, err = cjson.decode(body)
    
    if not data then
        return response.error("Invalid JSON", 400)
    end
    
    local updates = {}
    if data.name then
        table.insert(updates, "name = " .. ngx.quote_sql_str(data.name))
    end
    if data.email then
        table.insert(updates, "email = " .. ngx.quote_sql_str(data.email))
    end
    
    if #updates == 0 then
        return response.error("No fields to update", 400)
    end
    
    local sql = string.format(
        "UPDATE users SET %s WHERE id = %s",
        table.concat(updates, ", "),
        ngx.quote_sql_str(user_id)
    )
    
    local result, err = mysql.execute(sql)
    if not result then
        return response.error("Failed to update user: " .. err, 500, 500)
    end
    
    if result.affected_rows == 0 then
        return response.error("User not found", 404, 404)
    end
    
    return response.success(nil, "User updated successfully")
end)

-- 删除用户
router.delete("/api/users/:id", function()
    local user_id = ngx.ctx.params.id
    
    local sql = "DELETE FROM users WHERE id = " .. ngx.quote_sql_str(user_id)
    local result, err = mysql.execute(sql)
    
    if not result then
        return response.error("Failed to delete user: " .. err, 500, 500)
    end
    
    if result.affected_rows == 0 then
        return response.error("User not found", 404, 404)
    end
    
    return response.success(nil, "User deleted successfully")
end)

return router
```

### 6.2 JWT 认证中间件

```lua
-- lib/jwt.lua
local cjson = require "cjson.safe"
local resty_sha256 = require "resty.sha256"
local resty_string = require "resty.string"

local _M = {}

local secret_key = os.getenv("JWT_SECRET") or "your-secret-key"

-- Base64 URL 编码
local function base64_url_encode(input)
    local b64 = ngx.encode_base64(input)
    -- 替换标准 Base64 字符
    b64 = b64:gsub("+", "-"):gsub("/", "_"):gsub("=", "")
    return b64
end

-- Base64 URL 解码
local function base64_url_decode(input)
    -- 补齐填充
    local padding = 4 - #input % 4
    if padding ~= 4 then
        input = input .. string.rep("=", padding)
    end
    -- 还原标准 Base64 字符
    input = input:gsub("-", "+"):gsub("_", "/")
    return ngx.decode_base64(input)
end

-- HMAC-SHA256 签名
local function hmac_sha256(data, key)
    local hmac = require "resty.hmac"
    local h = hmac:new(key, hmac.ALGOS.SHA256)
    h:update(data)
    return h:final()
end

-- 生成 JWT
function _M.encode(payload, exp_seconds)
    -- Header
    local header = {
        alg = "HS256",
        typ = "JWT"
    }
    
    -- 添加过期时间
    payload.iat = ngx.time()
    payload.exp = ngx.time() + (exp_seconds or 3600)
    
    -- 编码 header 和 payload
    local header_b64 = base64_url_encode(cjson.encode(header))
    local payload_b64 = base64_url_encode(cjson.encode(payload))
    
    -- 创建签名
    local signing_input = header_b64 .. "." .. payload_b64
    local signature = hmac_sha256(signing_input, secret_key)
    local signature_b64 = base64_url_encode(signature)
    
    return signing_input .. "." .. signature_b64
end

-- 验证 JWT
function _M.decode(token)
    if not token then
        return nil, "token is required"
    end
    
    -- 分割 token
    local parts = {}
    for part in token:gmatch("[^%.]+") do
        table.insert(parts, part)
    end
    
    if #parts ~= 3 then
        return nil, "invalid token format"
    end
    
    local header_b64, payload_b64, signature_b64 = parts[1], parts[2], parts[3]
    
    -- 验证签名
    local signing_input = header_b64 .. "." .. payload_b64
    local expected_signature = base64_url_encode(hmac_sha256(signing_input, secret_key))
    
    if signature_b64 ~= expected_signature then
        return nil, "invalid signature"
    end
    
    -- 解码 payload
    local payload_json = base64_url_decode(payload_b64)
    local payload, err = cjson.decode(payload_json)
    
    if not payload then
        return nil, "invalid payload: " .. err
    end
    
    -- 验证过期时间
    if payload.exp and payload.exp < ngx.time() then
        return nil, "token expired"
    end
    
    return payload
end

return _M
-- lib/auth.lua
local jwt = require "lib.jwt"
local response = require "lib.response"

local _M = {}

-- 从请求中提取 token
local function extract_token()
    -- 优先从 Authorization header 获取
    local auth_header = ngx.req.get_headers()["Authorization"]
    if auth_header then
        local token = auth_header:match("Bearer%s+(.+)")
        if token then
            return token
        end
    end
    
    -- 其次从 query 参数获取
    local token = ngx.var.arg_token
    if token then
        return token
    end
    
    -- 最后从 cookie 获取
    local cookie_token = ngx.var.cookie_token
    if cookie_token then
        return cookie_token
    end
    
    return nil
end

-- 认证中间件
function _M.authenticate()
    local token = extract_token()
    
    if not token then
        response.error("Unauthorized: No token provided", 401, 401)
        return ngx.exit(401)
    end
    
    local payload, err = jwt.decode(token)
    
    if not payload then
        response.error("Unauthorized: " .. err, 401, 401)
        return ngx.exit(401)
    end
    
    -- 将用户信息存入请求上下文
    ngx.ctx.user = payload
end

-- 可选认证（不强制，但有 token 则解析）
function _M.optional_authenticate()
    local token = extract_token()
    
    if token then
        local payload, err = jwt.decode(token)
        if payload then
            ngx.ctx.user = payload
        end
    end
end

-- 角色检查
function _M.require_role(...)
    local allowed_roles = {...}
    
    return function()
        _M.authenticate()
        
        local user = ngx.ctx.user
        if not user or not user.role then
            response.error("Forbidden: No role assigned", 403, 403)
            return ngx.exit(403)
        end
        
        for _, role in ipairs(allowed_roles) do
            if user.role == role then
                return
            end
        end
        
        response.error("Forbidden: Insufficient permissions", 403, 403)
        return ngx.exit(403)
    end
end

return _M
```

### 6.3 请求频率限制

```lua
-- lib/rate_limiter.lua
local _M = {}

-- 使用滑动窗口算法
function _M.sliding_window(key, limit, window_seconds)
    local dict = ngx.shared.rate_limit
    local now = ngx.now()
    local window_start = now - window_seconds
    
    -- 使用 key 存储请求时间戳列表（简化实现，生产环境建议用 Redis）
    local timestamps_key = "timestamps:" .. key
    local count_key = "count:" .. key
    
    -- 获取当前计数
    local count = dict:get(count_key) or 0
    
    -- 原子递增
    local new_count, err = dict:incr(count_key, 1, 0, window_seconds)
    if not new_count then
        return nil, err
    end
    
    if new_count > limit then
        -- 超过限制
        local remaining = 0
        local retry_after = window_seconds
        return nil, "rate limit exceeded", remaining, retry_after
    end
    
    local remaining = limit - new_count
    return true, nil, remaining, nil
end

-- 令牌桶算法（基于 Redis）
function _M.token_bucket(key, capacity, fill_rate, redis_instance)
    local red = redis_instance
    local now = ngx.now()
    local bucket_key = "bucket:" .. key
    
    -- Lua 脚本实现令牌桶
    local script = [[
        local key = KEYS[1]
        local capacity = tonumber(ARGV[1])
        local fill_rate = tonumber(ARGV[2])
        local now = tonumber(ARGV[3])
        local requested = tonumber(ARGV[4])
        
        local bucket = redis.call('HMGET', key, 'tokens', 'last_fill')
        local tokens = tonumber(bucket[1]) or capacity
        local last_fill = tonumber(bucket[2]) or now
        
        -- 计算应该补充的令牌
        local elapsed = now - last_fill
        local fill_amount = elapsed * fill_rate
        tokens = math.min(capacity, tokens + fill_amount)
        
        if tokens >= requested then
            tokens = tokens - requested
            redis.call('HMSET', key, 'tokens', tokens, 'last_fill', now)
            redis.call('EXPIRE', key, math.ceil(capacity / fill_rate) * 2)
            return {1, tokens}
        else
            return {0, tokens}
        end
    ]]
    
    local result, err = red:eval(script, 1, bucket_key, capacity, fill_rate, now, 1)
    if not result then
        return nil, err
    end
    
    if result[1] == 1 then
        return true, nil, result[2]
    else
        return nil, "rate limit exceeded", result[2]
    end
end

-- 中间件工厂
function _M.middleware(options)
    options = options or {}
    local key_func = options.key or function()
        return ngx.var.remote_addr
    end
    local limit = options.limit or 100
    local window = options.window or 60
    
    return function()
        local key = key_func()
        local ok, err, remaining, retry_after = _M.sliding_window(key, limit, window)
        
        -- 设置响应头
        ngx.header["X-RateLimit-Limit"] = limit
        ngx.header["X-RateLimit-Remaining"] = remaining or 0
        ngx.header["X-RateLimit-Window"] = window
        
        if not ok then
            ngx.header["Retry-After"] = retry_after
            ngx.status = 429
            ngx.say('{"error": "Too Many Requests", "retry_after": ' .. retry_after .. '}')
            return ngx.exit(429)
        end
    end
end

return _M
# nginx.conf 中使用
location /api/ {
    access_by_lua_block {
        local rate_limiter = require "lib.rate_limiter"
        
        -- 按 IP 限制：每分钟 100 次请求
        rate_limiter.middleware({
            key = function()
                return ngx.var.remote_addr
            end,
            limit = 100,
            window = 60
        })()
        
        -- 或者按用户限制
        --[[
        rate_limiter.middleware({
            key = function()
                local user = ngx.ctx.user
                return user and ("user:" .. user.id) or ngx.var.remote_addr
            end,
            limit = 1000,
            window = 3600
        })()
        ]]
    }
    
    content_by_lua_file /path/to/api_handler.lua;
}
```

### 6.4 分布式会话管理

```lua
-- lib/session.lua
local redis = require "resty.redis"
local cjson = require "cjson.safe"

local _M = {}

local SESSION_PREFIX = "session:"
local SESSION_TTL = 86400  -- 24 小时
local COOKIE_NAME = "session_id"

local function get_redis()
    local red = redis:new()
    red:set_timeout(1000)
    
    local ok, err = red:connect("127.0.0.1", 6379)
    if not ok then
        return nil, err
    end
    
    return red
end

local function close_redis(red)
    red:set_keepalive(60000, 100)
end

-- 生成会话 ID
local function generate_session_id()
    local random = require "resty.random"
    local bytes = random.bytes(32)
    return ngx.encode_base64(bytes):gsub("[+/=]", "")
end

-- 获取当前会话
function _M.get()
    local session_id = ngx.var["cookie_" .. COOKIE_NAME]
    
    if not session_id then
        return nil
    end
    
    local red, err = get_redis()
    if not red then
        ngx.log(ngx.ERR, "failed to get redis: ", err)
        return nil
    end
    
    local data, err = red:get(SESSION_PREFIX .. session_id)
    close_redis(red)
    
    if not data or data == ngx.null then
        return nil
    end
    
    local session = cjson.decode(data)
    session._id = session_id
    
    return session
end

-- 创建新会话
function _M.create(data)
    local session_id = generate_session_id()
    
    local red, err = get_redis()
    if not red then
        return nil, err
    end
    
    data = data or {}
    data.created_at = ngx.now()
    
    local ok, err = red:setex(SESSION_PREFIX .. session_id, SESSION_TTL, cjson.encode(data))
    close_redis(red)
    
    if not ok then
        return nil, err
    end
    
    -- 设置 Cookie
    ngx.header["Set-Cookie"] = string.format(
        "%s=%s; Path=/; HttpOnly; SameSite=Lax; Max-Age=%d",
        COOKIE_NAME, session_id, SESSION_TTL
    )
    
    data._id = session_id
    return data
end

-- 更新会话
function _M.update(data)
    local session_id = ngx.var["cookie_" .. COOKIE_NAME]
    
    if not session_id then
        return nil, "no session"
    end
    
    local red, err = get_redis()
    if not red then
        return nil, err
    end
    
    local ok, err = red:setex(SESSION_PREFIX .. session_id, SESSION_TTL, cjson.encode(data))
    close_redis(red)
    
    return ok, err
end

-- 销毁会话
function _M.destroy()
    local session_id = ngx.var["cookie_" .. COOKIE_NAME]
    
    if not session_id then
        return
    end
    
    local red, err = get_redis()
    if red then
        red:del(SESSION_PREFIX .. session_id)
        close_redis(red)
    end
    
    -- 清除 Cookie
    ngx.header["Set-Cookie"] = string.format(
        "%s=; Path=/; HttpOnly; Max-Age=0",
        COOKIE_NAME
    )
end

-- 刷新会话过期时间
function _M.refresh()
    local session_id = ngx.var["cookie_" .. COOKIE_NAME]
    
    if not session_id then
        return
    end
    
    local red, err = get_redis()
    if not red then
        return
    end
    
    red:expire(SESSION_PREFIX .. session_id, SESSION_TTL)
    close_redis(red)
end

return _M
```

------

## 第七章：性能优化

### 7.1 Lua 代码优化

**局部变量优先**

```lua
-- 慢：每次访问都需要查找全局表
for i = 1, 1000000 do
    table.insert(results, string.format("%d", i))
end

-- 快：使用局部变量缓存
local insert = table.insert
local format = string.format
for i = 1, 1000000 do
    insert(results, format("%d", i))
end
```

**避免创建不必要的表**

```lua
-- 慢：每次请求都创建新表
local function get_config()
    return {
        timeout = 5000,
        retry = 3
    }
end

-- 快：复用表
local config = {
    timeout = 5000,
    retry = 3
}

local function get_config()
    return config
end
```

**字符串拼接优化**

```lua
-- 慢：多次字符串拼接
local result = ""
for i = 1, 10000 do
    result = result .. "line" .. i .. "\n"
end

-- 快：使用 table.concat
local parts = {}
for i = 1, 10000 do
    parts[i] = "line" .. i
end
local result = table.concat(parts, "\n")
```

**预编译正则表达式**

```lua
-- 慢：每次请求都编译正则
local function validate_email(email)
    return ngx.re.match(email, "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", "jo")
end

-- 快：模块加载时编译，使用 "o" 选项缓存
local email_pattern = [[^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$]]
local email_regex

local function init()
    email_regex = ngx.re.compile(email_pattern, "jo")
end

local function validate_email(email)
    return ngx.re.match(email, email_regex)
end
```

### 7.2 连接池最佳实践

```lua
-- lib/pool_manager.lua
local _M = {}

local mysql = require "resty.mysql"
local redis = require "resty.redis"

-- 连接池配置
local pool_config = {
    mysql = {
        size = 100,
        timeout = 60000,  -- 60 秒空闲超时
        backlog = 1000    -- 等待队列长度
    },
    redis = {
        size = 100,
        timeout = 60000
    }
}

-- MySQL 连接获取
function _M.get_mysql(db_name)
    local db, err = mysql:new()
    if not db then
        return nil, err
    end
    
    db:set_timeout(5000)
    
    local ok, err, errcode, sqlstate = db:connect({
        host = "127.0.0.1",
        port = 3306,
        database = db_name,
        user = "root",
        password = "password",
        charset = "utf8mb4",
        pool = "mysql:" .. db_name,
        pool_size = pool_config.mysql.size,
        backlog = pool_config.mysql.backlog
    })
    
    if not ok then
        return nil, err
    end
    
    -- 检查是否是复用的连接
    local reused = db:get_reused_times()
    if reused == 0 then
        -- 新连接，执行初始化
        db:query("SET NAMES utf8mb4")
        db:query("SET time_zone = '+08:00'")
    end
    
    return db
end

function _M.release_mysql(db)
    if not db then return end
    local ok, err = db:set_keepalive(
        pool_config.mysql.timeout,
        pool_config.mysql.size
    )
    if not ok then
        ngx.log(ngx.WARN, "failed to release mysql connection: ", err)
    end
end

-- Redis 连接获取
function _M.get_redis(instance_name)
    instance_name = instance_name or "default"
    
    local red = redis:new()
    red:set_timeout(1000)
    
    local ok, err = red:connect("127.0.0.1", 6379, {
        pool = "redis:" .. instance_name,
        pool_size = pool_config.redis.size
    })
    
    if not ok then
        return nil, err
    end
    
    return red
end

function _M.release_redis(red)
    if not red then return end
    local ok, err = red:set_keepalive(
        pool_config.redis.timeout,
        pool_config.redis.size
    )
    if not ok then
        ngx.log(ngx.WARN, "failed to release redis connection: ", err)
    end
end

return _M
```

### 7.3 缓存策略

```lua
-- lib/cache.lua
local _M = {}

local cjson = require "cjson.safe"
local lrucache = require "resty.lrucache"

-- Worker 级别的 LRU 缓存（不跨 worker 共享，但速度最快）
local worker_cache, err = lrucache.new(1000)
if not worker_cache then
    error("failed to create lru cache: " .. (err or "unknown"))
end

-- 共享内存缓存（跨 worker 共享）
local shared_cache = ngx.shared.cache_zone

-- 多级缓存：Worker LRU -> 共享内存 -> 数据源
function _M.get(key, fetch_func, options)
    options = options or {}
    local l1_ttl = options.l1_ttl or 60        -- Worker 缓存 TTL
    local l2_ttl = options.l2_ttl or 300       -- 共享内存 TTL
    local negative_ttl = options.negative_ttl or 10  -- 空值缓存 TTL
    
    -- L1: Worker LRU 缓存
    local value = worker_cache:get(key)
    if value ~= nil then
        return value ~= ngx.null and value or nil
    end
    
    -- L2: 共享内存缓存
    local shared_value = shared_cache:get(key)
    if shared_value ~= nil then
        local decoded = cjson.decode(shared_value)
        if decoded then
            -- 回填 L1
            worker_cache:set(key, decoded, l1_ttl)
            return decoded
        end
    end
    
    -- 缓存未命中，从数据源获取
    if not fetch_func then
        return nil
    end
    
    local data, err = fetch_func()
    
    if data == nil then
        -- 缓存空值，防止缓存穿透
        worker_cache:set(key, ngx.null, negative_ttl)
        shared_cache:set(key, "null", negative_ttl)
        return nil, err
    end
    
    -- 存入缓存
    local encoded = cjson.encode(data)
    worker_cache:set(key, data, l1_ttl)
    shared_cache:set(key, encoded, l2_ttl)
    
    return data
end

-- 删除缓存
function _M.delete(key)
    worker_cache:delete(key)
    shared_cache:delete(key)
end

-- 批量删除（按前缀）
function _M.delete_by_prefix(prefix)
    -- 共享内存
    local keys = shared_cache:get_keys(0)
    for _, key in ipairs(keys) do
        if key:sub(1, #prefix) == prefix then
            shared_cache:delete(key)
        end
    end
    
    -- 注意：resty.lrucache 不支持遍历，无法按前缀删除
    -- 如需此功能，考虑使用 resty.lrucache.pureffi 或其他方案
end

return _M
```

### 7.4 性能监控

```lua
-- lib/metrics.lua
local _M = {}

local shared = ngx.shared.metrics

-- 请求计数
function _M.increment_request_count(path, status)
    local key = "requests:" .. path .. ":" .. status
    local new_val, err = shared:incr(key, 1, 0)
    return new_val
end

-- 响应时间记录
function _M.record_response_time(path, time_ms)
    local key_count = "response_count:" .. path
    local key_sum = "response_sum:" .. path
    
    shared:incr(key_count, 1, 0)
    shared:incr(key_sum, time_ms, 0)
end

-- 获取统计数据
function _M.get_stats()
    local stats = {}
    local keys = shared:get_keys(0)
    
    for _, key in ipairs(keys) do
        stats[key] = shared:get(key)
    end
    
    return stats
end

-- 日志阶段使用的中间件
function _M.log_middleware()
    local request_time = ngx.now() - ngx.req.start_time()
    local path = ngx.var.uri
    local status = ngx.status
    
    _M.increment_request_count(path, status)
    _M.record_response_time(path, request_time * 1000)
end

return _M
# nginx.conf 中配置 metrics 端点
location /metrics {
    content_by_lua_block {
        local metrics = require "lib.metrics"
        local stats = metrics.get_stats()
        
        ngx.header["Content-Type"] = "text/plain"
        
        for key, value in pairs(stats) do
            ngx.say(key, " ", value)
        end
    }
}

# 在所有请求中记录指标
log_by_lua_block {
    local metrics = require "lib.metrics"
    metrics.log_middleware()
}
```

------

## 第八章：安全最佳实践

### 8.1 输入验证

```lua
-- lib/validator.lua
local _M = {}

-- 字符串验证
function _M.is_string(value, options)
    options = options or {}
    
    if type(value) ~= "string" then
        return false, "must be a string"
    end
    
    if options.min_length and #value < options.min_length then
        return false, "must be at least " .. options.min_length .. " characters"
    end
    
    if options.max_length and #value > options.max_length then
        return false, "must be at most " .. options.max_length .. " characters"
    end
    
    if options.pattern then
        if not ngx.re.match(value, options.pattern, "jo") then
            return false, options.pattern_message or "invalid format"
        end
    end
    
    return true
end

-- 邮箱验证
function _M.is_email(value)
    return _M.is_string(value, {
        pattern = [[^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$]],
        pattern_message = "invalid email format"
    })
end

-- 数字验证
function _M.is_number(value, options)
    options = options or {}
    
    local num = tonumber(value)
    if not num then
        return false, "must be a number"
    end
    
    if options.min and num < options.min then
        return false, "must be at least " .. options.min
    end
    
    if options.max and num > options.max then
        return false, "must be at most " .. options.max
    end
    
    if options.integer and num ~= math.floor(num) then
        return false, "must be an integer"
    end
    
    return true
end

-- UUID 验证
function _M.is_uuid(value)
    return _M.is_string(value, {
        pattern = [[^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$]],
        pattern_message = "invalid UUID format"
    })
end

-- 验证对象
function _M.validate(data, schema)
    local errors = {}
    
    for field, rules in pairs(schema) do
        local value = data[field]
        
        -- 必填检查
        if rules.required and (value == nil or value == "") then
            errors[field] = "is required"
            goto continue
        end
        
        if value ~= nil and value ~= "" then
            local validator = rules.type or _M.is_string
            local ok, err = validator(value, rules)
            if not ok then
                errors[field] = err
            end
        end
        
        ::continue::
    end
    
    if next(errors) then
        return false, errors
    end
    
    return true
end

return _M
```

### 8.2 XSS 防护

```lua
-- lib/security.lua
local _M = {}

-- HTML 转义
local html_escape_map = {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;"
}

function _M.html_escape(str)
    if type(str) ~= "string" then
        return str
    end
    return str:gsub("[&<>\"'/]", html_escape_map)
end

-- 安全的 JSON 响应（Content-Type 已设置时自动防护）
function _M.safe_json_response(data)
    ngx.header["Content-Type"] = "application/json; charset=utf-8"
    ngx.header["X-Content-Type-Options"] = "nosniff"
    
    local cjson = require "cjson.safe"
    ngx.say(cjson.encode(data))
end

-- CSP 头部设置
function _M.set_security_headers()
    ngx.header["X-Frame-Options"] = "DENY"
    ngx.header["X-Content-Type-Options"] = "nosniff"
    ngx.header["X-XSS-Protection"] = "1; mode=block"
    ngx.header["Referrer-Policy"] = "strict-origin-when-cross-origin"
    ngx.header["Content-Security-Policy"] = 
        "default-src 'self'; " ..
        "script-src 'self'; " ..
        "style-src 'self' 'unsafe-inline'; " ..
        "img-src 'self' data:; " ..
        "font-src 'self'; " ..
        "connect-src 'self'"
end

return _M
```

### 8.3 CSRF 防护

```lua
-- lib/csrf.lua
local _M = {}

local resty_random = require "resty.random"
local resty_sha256 = require "resty.sha256"

local TOKEN_COOKIE = "csrf_token"
local TOKEN_HEADER = "X-CSRF-Token"
local TOKEN_TTL = 3600

-- 生成 CSRF token
function _M.generate_token()
    local random_bytes = resty_random.bytes(32)
    local token = ngx.encode_base64(random_bytes):gsub("[+/=]", "")
    
    -- 存入 session 或 cookie
    ngx.header["Set-Cookie"] = string.format(
        "%s=%s; Path=/; HttpOnly; SameSite=Strict; Max-Age=%d",
        TOKEN_COOKIE, token, TOKEN_TTL
    )
    
    return token
end

-- 验证 CSRF token
function _M.verify_token()
    -- GET、HEAD、OPTIONS 请求不需要验证
    local method = ngx.req.get_method()
    if method == "GET" or method == "HEAD" or method == "OPTIONS" then
        return true
    end
    
    -- 获取 cookie 中的 token
    local cookie_token = ngx.var["cookie_" .. TOKEN_COOKIE]
    if not cookie_token then
        return false, "CSRF cookie not found"
    end
    
    -- 获取请求中的 token（header 或 body）
    local request_token = ngx.req.get_headers()[TOKEN_HEADER]
    
    if not request_token then
        ngx.req.read_body()
        local args = ngx.req.get_post_args()
        request_token = args._csrf_token
    end
    
    if not request_token then
        return false, "CSRF token not found in request"
    end
    
    -- 比较 token
    if cookie_token ~= request_token then
        return false, "CSRF token mismatch"
    end
    
    return true
end

-- 中间件
function _M.middleware()
    local ok, err = _M.verify_token()
    if not ok then
        ngx.status = 403
        ngx.say('{"error": "CSRF validation failed: ' .. err .. '"}')
        return ngx.exit(403)
    end
end

return _M
```

### 8.4 SQL 注入防护

```lua
-- lib/sql_builder.lua
local _M = {}

-- 参数化查询构建器
function _M.select(table_name)
    return {
        _table = table_name,
        _columns = "*",
        _where = {},
        _params = {},
        _order = nil,
        _limit = nil,
        _offset = nil,
        
        columns = function(self, ...)
            self._columns = table.concat({...}, ", ")
            return self
        end,
        
        where = function(self, column, operator, value)
            table.insert(self._where, column .. " " .. operator .. " ?")
            table.insert(self._params, value)
            return self
        end,
        
        where_in = function(self, column, values)
            local placeholders = {}
            for _, v in ipairs(values) do
                table.insert(placeholders, "?")
                table.insert(self._params, v)
            end
            table.insert(self._where, column .. " IN (" .. table.concat(placeholders, ", ") .. ")")
            return self
        end,
        
        order_by = function(self, column, direction)
            direction = direction or "ASC"
            self._order = column .. " " .. direction
            return self
        end,
        
        limit = function(self, n)
            self._limit = n
            return self
        end,
        
        offset = function(self, n)
            self._offset = n
            return self
        end,
        
        build = function(self)
            local sql = "SELECT " .. self._columns .. " FROM " .. self._table
            
            if #self._where > 0 then
                sql = sql .. " WHERE " .. table.concat(self._where, " AND ")
            end
            
            if self._order then
                sql = sql .. " ORDER BY " .. self._order
            end
            
            if self._limit then
                sql = sql .. " LIMIT " .. self._limit
            end
            
            if self._offset then
                sql = sql .. " OFFSET " .. self._offset
            end
            
            -- 替换占位符
            local param_index = 0
            sql = sql:gsub("%?", function()
                param_index = param_index + 1
                local param = self._params[param_index]
                if type(param) == "string" then
                    return ngx.quote_sql_str(param)
                elseif param == nil then
                    return "NULL"
                else
                    return tostring(param)
                end
            end)
            
            return sql
        end
    }
end

return _M
-- 使用示例
local sql_builder = require "lib.sql_builder"

local sql = sql_builder.select("users")
    :columns("id", "name", "email")
    :where("status", "=", "active")
    :where("age", ">=", 18)
    :where_in("role", {"admin", "moderator"})
    :order_by("created_at", "DESC")
    :limit(10)
    :offset(0)
    :build()

-- 生成的 SQL：
-- SELECT id, name, email FROM users 
-- WHERE status = 'active' AND age >= 18 AND role IN ('admin', 'moderator') 
-- ORDER BY created_at DESC LIMIT 10 OFFSET 0
```

------

## 第九章：部署与运维

### 9.1 生产环境配置

```nginx
# nginx.conf 生产环境配置

user nginx nginx;
worker_processes auto;
worker_cpu_affinity auto;

error_log logs/error.log warn;
pid logs/nginx.pid;

# 提高文件描述符限制
worker_rlimit_nofile 65535;

events {
    worker_connections 65535;
    use epoll;
    multi_accept on;
    accept_mutex off;
}

http {
    include mime.types;
    default_type application/octet-stream;
    
    # 关闭版本显示
    server_tokens off;
    
    # 日志格式
    log_format json escape=json '{'
        '"time":"$time_iso8601",'
        '"remote_addr":"$remote_addr",'
        '"method":"$request_method",'
        '"uri":"$uri",'
        '"status":$status,'
        '"body_bytes":$body_bytes_sent,'
        '"request_time":$request_time,'
        '"upstream_time":"$upstream_response_time",'
        '"referer":"$http_referer",'
        '"user_agent":"$http_user_agent",'
        '"request_id":"$request_id"'
    '}';
    
    access_log logs/access.log json buffer=64k flush=1s;
    
    # 性能优化
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    
    # 连接超时
    keepalive_timeout 65;
    keepalive_requests 10000;
    
    # 请求限制
    client_max_body_size 10m;
    client_body_buffer_size 128k;
    client_header_buffer_size 1k;
    large_client_header_buffers 4 8k;
    
    # Gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_comp_level 5;
    gzip_types text/plain text/css application/json application/javascript 
               text/xml application/xml application/xml+rss text/javascript;
    
    # Lua 配置
    lua_package_path "/opt/app/lua/?.lua;/usr/local/openresty/lualib/?.lua;;";
    lua_package_cpath "/usr/local/openresty/lualib/?.so;;";
    
    # 共享内存
    lua_shared_dict cache 100m;
    lua_shared_dict locks 10m;
    lua_shared_dict rate_limit 50m;
    lua_shared_dict metrics 10m;
    lua_shared_dict sessions 50m;
    
    # 代码缓存（生产环境必须开启）
    lua_code_cache on;
    
    # 定时器限制
    lua_max_pending_timers 1024;
    lua_max_running_timers 256;
    
    # 初始化
    init_by_lua_file /opt/app/lua/init.lua;
    init_worker_by_lua_file /opt/app/lua/init_worker.lua;
    
    # 上游服务
    upstream backend {
        server 127.0.0.1:8080 weight=5;
        server 127.0.0.1:8081 weight=5;
        
        keepalive 100;
        keepalive_timeout 60s;
        keepalive_requests 1000;
    }
    
    # 主服务器
    server {
        listen 80;
        listen 443 ssl http2;
        server_name api.example.com;
        
        # SSL 配置
        ssl_certificate /etc/ssl/certs/server.crt;
        ssl_certificate_key /etc/ssl/private/server.key;
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
        ssl_prefer_server_ciphers on;
        
        # 安全头部
        add_header X-Frame-Options "DENY" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        
        # 请求 ID
        set $request_id $request_id;
        if ($request_id = '') {
            set $request_id $pid-$connection-$msec;
        }
        
        location / {
            content_by_lua_file /opt/app/lua/main.lua;
        }
        
        location /health {
            access_log off;
            content_by_lua_block {
                ngx.say("OK")
            }
        }
        
        location /metrics {
            allow 10.0.0.0/8;
            deny all;
            content_by_lua_file /opt/app/lua/metrics.lua;
        }
    }
}
```

### 9.2 Docker 部署

```dockerfile
# Dockerfile
FROM openresty/openresty:1.25.3.1-alpine

# 安装依赖
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 安装 OPM 包
RUN opm get ledgetech/lua-resty-http && \
    opm get bungle/lua-resty-template

# 复制应用代码
COPY lua/ /opt/app/lua/
COPY conf/ /usr/local/openresty/nginx/conf/

# 设置权限
RUN chown -R nobody:nobody /opt/app

# 暴露端口
EXPOSE 80 443

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# 启动命令
CMD ["openresty", "-g", "daemon off;"]
# docker-compose.yml
version: '3.8'

services:
  openresty:
    build: .
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./lua:/opt/app/lua:ro
      - ./conf:/usr/local/openresty/nginx/conf:ro
      - ./logs:/usr/local/openresty/nginx/logs
      - ./ssl:/etc/ssl:ro
    environment:
      - MYSQL_HOST=mysql
      - REDIS_HOST=redis
      - JWT_SECRET=${JWT_SECRET}
    depends_on:
      - mysql
      - redis
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '2'
          memory: 2G
    networks:
      - app-network
    restart: unless-stopped

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: myapp
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - app-network
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - app-network
    restart: unless-stopped

volumes:
  mysql_data:
  redis_data:

networks:
  app-network:
    driver: bridge
```

### 9.3 Kubernetes 部署

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: openresty-api
  labels:
    app: openresty-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: openresty-api
  template:
    metadata:
      labels:
        app: openresty-api
    spec:
      containers:
      - name: openresty
        image: your-registry/openresty-api:v1.0.0
        ports:
        - containerPort: 80
        env:
        - name: MYSQL_HOST
          valueFrom:
            secretKeyRef:
              name: db-secrets
              key: host
        - name: JWT_SECRET
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: jwt-secret
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        volumeMounts:
        - name: config
          mountPath: /usr/local/openresty/nginx/conf/nginx.conf
          subPath: nginx.conf
      volumes:
      - name: config
        configMap:
          name: openresty-config
---
apiVersion: v1
kind: Service
metadata:
  name: openresty-api
spec:
  selector:
    app: openresty-api
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: openresty-api
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - api.example.com
    secretName: api-tls
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: openresty-api
            port:
              number: 80
```

### 9.4 日志收集与监控

```lua
-- lib/logging.lua
local cjson = require "cjson.safe"

local _M = {}

local log_levels = {
    DEBUG = ngx.DEBUG,
    INFO = ngx.INFO,
    NOTICE = ngx.NOTICE,
    WARN = ngx.WARN,
    ERR = ngx.ERR,
    CRIT = ngx.CRIT
}

function _M.log(level, message, context)
    local log_level = log_levels[level] or ngx.INFO
    
    context = context or {}
    context.timestamp = ngx.now()
    context.request_id = ngx.var.request_id
    context.uri = ngx.var.uri
    context.method = ngx.var.request_method
    context.remote_addr = ngx.var.remote_addr
    
    local log_entry = {
        level = level,
        message = message,
        context = context
    }
    
    ngx.log(log_level, cjson.encode(log_entry))
end

function _M.debug(message, context)
    _M.log("DEBUG", message, context)
end

function _M.info(message, context)
    _M.log("INFO", message, context)
end

function _M.warn(message, context)
    _M.log("WARN", message, context)
end

function _M.error(message, context)
    _M.log("ERR", message, context)
end

return _M
-- 使用 Prometheus 格式导出指标
-- lib/prometheus.lua
local _M = {}

local shared = ngx.shared.metrics

function _M.collect()
    local metrics = {}
    
    -- 请求计数
    table.insert(metrics, "# HELP http_requests_total Total number of HTTP requests")
    table.insert(metrics, "# TYPE http_requests_total counter")
    
    local keys = shared:get_keys(0)
    for _, key in ipairs(keys) do
        if key:match("^requests:") then
            local parts = {}
            for part in key:gmatch("[^:]+") do
                table.insert(parts, part)
            end
            local path = parts[2]
            local status = parts[3]
            local value = shared:get(key) or 0
            
            table.insert(metrics, string.format(
                'http_requests_total{path="%s",status="%s"} %d',
                path, status, value
            ))
        end
    end
    
    -- 响应时间
    table.insert(metrics, "# HELP http_request_duration_seconds HTTP request duration")
    table.insert(metrics, "# TYPE http_request_duration_seconds summary")
    
    for _, key in ipairs(keys) do
        if key:match("^response_count:") then
            local path = key:gsub("^response_count:", "")
            local count = shared:get(key) or 0
            local sum = shared:get("response_sum:" .. path) or 0
            
            if count > 0 then
                table.insert(metrics, string.format(
                    'http_request_duration_seconds_count{path="%s"} %d',
                    path, count
                ))
                table.insert(metrics, string.format(
                    'http_request_duration_seconds_sum{path="%s"} %.6f',
                    path, sum / 1000
                ))
            end
        end
    end
    
    return table.concat(metrics, "\n") .. "\n"
end

return _M
```

------

## 第十章：故障排查与调试

### 10.1 调试技巧

```lua
-- 开发环境可关闭代码缓存以便实时修改
-- lua_code_cache off;  -- 仅用于开发！

-- 详细日志
ngx.log(ngx.DEBUG, "variable value: ", ngx.var.uri)

-- 使用 ngx.say 输出调试信息
ngx.header["Content-Type"] = "text/plain"
ngx.say("Debug info:")
ngx.say("Method: ", ngx.req.get_method())
ngx.say("URI: ", ngx.var.uri)
ngx.say("Args: ", require("cjson").encode(ngx.req.get_uri_args()))

-- 打印表结构
local function dump(t, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)
    
    if type(t) ~= "table" then
        return tostring(t)
    end
    
    local parts = {"{\n"}
    for k, v in pairs(t) do
        table.insert(parts, prefix .. "  " .. tostring(k) .. " = ")
        if type(v) == "table" then
            table.insert(parts, dump(v, indent + 1))
        else
            table.insert(parts, tostring(v))
        end
        table.insert(parts, ",\n")
    end
    table.insert(parts, prefix .. "}")
    
    return table.concat(parts)
end

ngx.say(dump(ngx.req.get_headers()))
```

### 10.2 常见错误与解决

**错误：API disabled in the context of xxx**

某些 ngx API 只能在特定阶段使用：

```lua
-- 错误：不能在 init_by_lua 中使用 ngx.say
init_by_lua_block {
    ngx.say("hello")  -- 错误！
}

-- 正确：使用 ngx.log
init_by_lua_block {
    ngx.log(ngx.INFO, "initialized")
}
```

**错误：attempt to yield across C-call boundary**

不能在某些回调中使用 yield 的 API：

```lua
-- 错误：在 body_filter 中使用 cosocket
body_filter_by_lua_block {
    local redis = require "resty.redis"
    local red = redis:new()
    red:connect("127.0.0.1", 6379)  -- 错误！
}

-- 解决：使用定时器延迟执行
body_filter_by_lua_block {
    ngx.timer.at(0, function()
        local redis = require "resty.redis"
        -- 这里可以使用 cosocket
    end)
}
```

**错误：no memory / shared_dict full**

共享内存不足：

```lua
-- 检查共享内存使用情况
local dict = ngx.shared.cache
ngx.say("Capacity: ", dict:capacity())
ngx.say("Free space: ", dict:free_space())

-- 设置时处理内存不足
local ok, err, forcible = dict:set("key", "value")
if not ok then
    ngx.log(ngx.ERR, "failed to set: ", err)
end
if forcible then
    ngx.log(ngx.WARN, "LRU eviction occurred")
end
```

### 10.3 性能分析

```lua
-- 使用 ngx.now() 测量执行时间
local function measure(func, ...)
    local start = ngx.now()
    local result = {func(...)}
    local elapsed = ngx.now() - start
    ngx.log(ngx.INFO, "Function took ", elapsed * 1000, " ms")
    return unpack(result)
end

-- 火焰图分析（使用 stapxx）
-- 安装 stapxx 后运行：
-- ./samples/lj-lua-stacks.sxx -x PID --skip-badvars > stacks.out
-- ./stackcollapse-stap.pl stacks.out > stacks.folded
-- ./flamegraph.pl stacks.folded > flamegraph.svg
```

------

## 总结

OpenResty 是一个功能强大的 Web 应用平台，它结合了 Nginx 的高性能和 Lua 的灵活性。

在实际开发中，建议遵循以下原则：始终使用局部变量避免全局变量污染；合理使用连接池提高性能；实施多级缓存减少后端压力；做好错误处理和日志记录；关注安全性，验证所有输入；在生产环境开启 `lua_code_cache`(默认就是开启的)。

OpenResty 的学习曲线相对平缓，但要精通它需要深入理解 Nginx 和 Lua。建议通过实际项目练习，逐步掌握各种高级特性。