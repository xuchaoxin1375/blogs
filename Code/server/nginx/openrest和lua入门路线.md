[toc]



如果目标是 **用 OpenResty 做实用功能**（如 API 网关、鉴权、WAF、动态路由、灰度发布等），其实**不需要成为 Lua 语言专家**。
重点是掌握三层知识：

```
Lua语言基础
    ↓
OpenResty API (ngx.*)
    ↓
lua-resty-* 生态库
```

下面给出一个 **最实用导向的学习路线**（约 2–4 周可以上手）。

------

# 第一阶段：Lua基础（1–2天）

目标：能看懂和写简单 Lua。

重点只需要掌握 **10个核心语法**。

| 语法   | Lua关键字  | 对应概念        | 示例                |
| ------ | ---------- | --------------- | ------------------- |
| 变量   | `local`    | 局部变量        | `local a = 10`      |
| 字符串 | string     | 字符串          | `"hello"`           |
| 表     | `table`    | 类似 dict / map | `{a=1,b=2}`         |
| 函数   | `function` | 函数定义        | `function add(a,b)` |
| 条件   | `if`       | 条件判断        | `if a > 1 then`     |
| 循环   | `for`      | 循环            | `for i=1,10`        |
| nil    | `nil`      | 空值            | `a=nil`             |
| 模块   | `require`  | 模块加载        | `require "cjson"`   |
| return | `return`   | 返回值          | `return x`          |
| 注释   | `--`       | 注释            | `-- hello`          |

例子：

```lua
local user = {
    name = "tom",
    age = 20
}

if user.age > 18 then
    print("adult")
end
```

Lua最重要结构是：

```
table
```

Lua里：

| 语言       | 数据结构 |
| ---------- | -------- |
| Python     | dict     |
| JavaScript | object   |
| Lua        | table    |

例如：

```lua
local conf = {
    host = "127.0.0.1",
    port = 6379
}
```

------

# 第二阶段：Lua模块系统（1天）

OpenResty大量使用模块。

学习两个概念：

| 概念    | 英文    | 说明     |
| ------- | ------- | -------- |
| 模块    | module  | Lua文件  |
| require | require | 加载模块 |

例子：

```lua
-- util.lua

local M = {}

function M.add(a,b)
    return a+b
end

return M
```

调用：

```lua
local util = require "util"

local r = util.add(1,2)
```

------

# 第三阶段：OpenResty核心API（最关键）

OpenResty通过 `ngx` 对象暴露 Nginx 能力。

| API          | 作用          |
| ------------ | ------------- |
| `ngx.say()`  | 输出HTTP响应  |
| `ngx.var`    | 读取nginx变量 |
| `ngx.req`    | 请求信息      |
| `ngx.header` | 设置header    |
| `ngx.exit()` | 结束请求      |
| `ngx.log()`  | 写日志        |

例子：

```nginx
location /hello {
    content_by_lua_block {
        ngx.say("hello openresty")
    }
}
```

Lua代码：

```lua
ngx.say("hello")
```

------

# 第四阶段：请求处理

理解 HTTP 请求信息。

| API                       | 作用          |
| ------------------------- | ------------- |
| `ngx.req.get_uri_args()`  | 获取URL参数   |
| `ngx.req.get_headers()`   | 获取header    |
| `ngx.req.get_body_data()` | 获取POST body |

例子：

```lua
local args = ngx.req.get_uri_args()

local id = args["id"]

ngx.say(id)
```

访问：

```
/user?id=10
```

返回：

```
10
```

------

# 第五阶段：OpenResty阶段机制

Nginx有多个处理阶段（phase）。

| 阶段    | 指令           | 作用     |
| ------- | -------------- | -------- |
| rewrite | rewrite_by_lua | URL处理  |
| access  | access_by_lua  | 权限控制 |
| content | content_by_lua | 返回内容 |
| log     | log_by_lua     | 日志     |

例子：IP封禁

```nginx
location /api {

    access_by_lua_block {

        local ip = ngx.var.remote_addr

        if ip == "1.2.3.4" then
            ngx.exit(403)
        end
    }

    proxy_pass http://backend;
}
```

------

# 第六阶段：lua-resty生态

OpenResty真正强大的是 **lua-resty-\*库**。

常用库：

| 库                        | 作用        |
| ------------------------- | ----------- |
| `lua-resty-redis`         | Redis客户端 |
| `lua-resty-http`          | HTTP请求    |
| `lua-resty-mysql`         | MySQL       |
| `lua-resty-limit-traffic` | 限流        |
| `lua-resty-jwt`           | JWT认证     |

例如 Redis：

```lua
local redis = require "resty.redis"

local red = redis:new()

red:connect("127.0.0.1",6379)

red:set("foo","bar")
```

------

# 第七阶段：实战功能（建议练习）

建议做 **5个小项目**。

### 1 IP黑名单

```lua
local ip = ngx.var.remote_addr

if ip == "1.1.1.1" then
    ngx.exit(403)
end
```

------

### 2 动态路由

根据 header 选择 upstream。

------

### 3 Redis缓存

```
request
   ↓
redis
   ↓
cache miss
   ↓
backend
```

------

### 4 API鉴权

```lua
local token = ngx.req.get_headers()["token"]

if token ~= "abc123" then
    ngx.exit(401)
end
```

------

### 5 限流

用：

```
lua-resty-limit-traffic
```

实现：

```
100 req/s
```

------

# 推荐学习顺序

| 阶段 | 内容      | 时间 |
| ---- | --------- | ---- |
| 1    | Lua语法   | 1天  |
| 2    | Lua模块   | 1天  |
| 3    | ngx API   | 2天  |
| 4    | 请求处理  | 2天  |
| 5    | 阶段机制  | 2天  |
| 6    | lua-resty | 3天  |
| 7    | 实战项目  | 1周  |

大概 **2–3周可以熟练使用 OpenResty**。

------

# 推荐资料

官方文档：

- OpenResty 官方文档
- lua-nginx-module README

重点看：

```
ngx.var
ngx.req
ngx.say
ngx.exit
ngx.timer
```

------

如果你愿意，我可以给你一份 **“OpenResty工程师最常用20个Lua代码模板”**（直接复制就能用，比如限流、Redis缓存、JWT认证、灰度发布）。
这套模板基本是 **生产环境最常见的功能**。