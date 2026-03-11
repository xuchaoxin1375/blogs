[toc]



## abstract

- [Nginx 防火墙 | 宝塔面板文档](https://docs.bt.cn/purchase-guides/package-service/nginx-firewall)
  - [Nginx防火墙 - 宝塔面板](https://www.bt.cn/new/product_nginx_firewall.html)
  - [demo机演示](https://demo.bt.cn/home)

宝塔有时做活动赠送专业版体验时长,我试用了一下,发现若干需要注意的问题;

**nginx waf**(btwaf)收费版插件提供:访问控制(防御,限流,反爬,人机验证),流量统计分析,等功能

> 作为收费插件,核心nginx规则经过加密;
>
> 对于新手服务器管理员有一定使用价值,但是对于已经有大量应用的生产环境来说,要小心使用,安装该插件会更改已有的nginx配置文件(尤其是主配置文件)

### 注意事项

waf插件安装后自动启动防火墙,默认可能会禁止国外ip访问,如果你的业务面向海外,请及时关闭相关开关;

### waf相关路径

方便起见,后面提到的nginx waf插件(收费版)统一简称称为waf插件

主要插件目录:(python为主)

- `/www/server/panel/plugin/btwaf`

nginx规则位置:

- `/www/server/panel/vhost/nginx/btwaf.conf`(配置加载入口文件)

其他相关目录:(lua文件为主)

- `/www/server/btwaf`

## 宝塔如何加载nginx waf中的规则

> 这里的分析可能具有时效性,但可供参考;

waf安装完毕会发现主nginx配置文件发生更改:

`lua_package_path`指令被移除(转到`/www/server/panel/vhost/nginx/btwaf.conf`中)

```nginx
 lua_package_path "/www/server/nginx/lib/lua/?.lua;;";
```



新的`lua_package_path`指令参考如下:

```bash
lua_package_path "/www/server/btwaf/?.lua;/www/server/btwaf/public/?.lua;/www/server/btwaf/lib/?.lua";
```

这里我们看到,有3个waf(`lua`文件)相关目录被包括进去:

- `/www/server/btwaf/`
- `/www/server/btwaf/public/`
- `/www/server/btwaf/lib/`

显著的特点是,他们都是`/www/server/btwaf/`开头的,尤其是`btwaf`,

原先`/www/server/nginx/lib/lua/`不再被使用;

在nginx.conf这个主配置文件中,` include /www/server/panel/vhost/nginx/*.conf;`可以在不指定具体的规则文件名的情况下,将`/www/server/panel/vhost/nginx/btwaf.conf`导入nginx规则中;

### 冲突风险

如果你的服务器上已经运行了一套nginx规则,尤其复杂规则(比如使用openresty+lua配置),很可能和waf的`lua`产生冲突(即便`nginx -t`检查语法能够通过,但是有些页面在有些设备UA或ip访问同一个页面时会出现不同的结果,例如真人浏览器访问可以通过,但是google爬虫却会遇到500系列错误)

务必仔细检查日志,而不是仅仅单一的方式测试误以为没有问题,否则可能导致流量的损失;

如果遇到这种情况,有两类方案:

- 停用waf,并且清理调用相关导入文件(比如重命名`/www/server/panel/vhost/nginx/btwaf.conf`)
- 调整原有的nginx规则,使其兼容waf插件(需要充分测试和观察)

## nginx 和 lua的关系

Nginx 和 Lua 本身**没有直接内置关系**。

[OpenResty](https://github.com/openresty)

 [lua-nginx-module](https://github.com/openresty/lua-nginx-module) 

> Embed the Power of Lua into NGINX HTTP servers
>
> `ngx_http_lua_module` - Embed the power of Lua into Nginx HTTP Servers.
>
> This module is a core component of [OpenResty](https://openresty.org/). If you are using this module, then you are essentially using OpenResty :)
>
> *This module is not distributed with the Nginx source.* See [the installation instructions](https://github.com/openresty/lua-nginx-module#installation).

 它们的关系主要是通过一个中间模块建立的，例如：

- ngx_http_lua_module
- 或更常见的发行版：OpenResty

简单理解：

| 组件                                          | 作用                              |
| --------------------------------------------- | --------------------------------- |
| Nginx                                         | 高性能 Web Server / Reverse Proxy |
| Lua                                           | 轻量级脚本语言                    |
| ngx_http_lua_module(lua-nginx-module项目提供) | 让 Nginx 可以执行 Lua 脚本        |
| OpenResty                                     | 集成 Nginx + LuaJIT + 一堆 Lua 库 |

**`ngx_http_lua_module` 和 `lua-nginx-module` 本质上是同一个东西，只是名字不同**。

> | 名称                | 类型         | 说明                |
> | ------------------- | ------------ | ------------------- |
> | lua-nginx-module    | GitHub项目名 | 模块源码项目        |
> | ngx_http_lua_module | Nginx模块名  | 编译进Nginx后的模块 |
>
> `lua-nginx-module` 是由 Yichun Zhang（OpenResty作者）开发的项目。
>
> 项目通常叫：
>
> ```
> lua-nginx-module
> ```
>
> 但当它被编译进 Nginx 时，模块名称会变成：
>
> ```
> ngx_http_lua_module
> ```
>
> 这是 **Nginx模块命名规则**。

Nginx 的模块命名规范通常是：

```
ngx_<module_type>_<name>_module
```

例如：

| 模块                  | 说明      |
| --------------------- | --------- |
| ngx_http_ssl_module   | SSL模块   |
| ngx_http_gzip_module  | gzip模块  |
| ngx_http_proxy_module | proxy模块 |

**Nginx + Lua = 在 Web Server 内嵌脚本逻辑，实现动态处理能力。**

## ngx_http_lua_module

`ngx_http_lua_module` 是为 Nginx 提供 Lua 脚本支持的模块，它通过嵌入 LuaJIT 或标准 Lua 5.1 解释器，使开发者能在 Nginx 配置中直接编写 Lua 代码。该模块由 OpenResty 维护，被广泛用于实现高性能、非阻塞的动态逻辑与反向代理功能。

关键事实

- **主要作者**：章亦春（Yichun “agentzh” Zhang）
- **初始发布**：约 2011 年，隶属 OpenResty 项目
- **支持语言**：Lua 5.1 / LuaJIT 2.0+
- **运行模式**：完全事件驱动、非阻塞 I/O
- **常见集成**：OpenResty、Cloudflare、Fastly 平台

### 工作原理

模块将 Lua 虚拟机嵌入到 Nginx 的事件循环中，允许使用 `*_by_lua` 指令（如 `content_by_lua_block`）在请求处理阶段执行 Lua 脚本。通过其专用 API（`ngx.*` 命名空间），Lua 代码可安全地访问请求与响应对象、发起子请求、或调用上游服务（如 MySQL、Redis、HTTP）。所有网络操作均为协程驱动的异步调用。

### 应用与生态

该模块是 OpenResty 框架的核心组件，使 Nginx 可作为轻量级应用平台使用。生态系统包含大量扩展库（例如 `lua-resty-mysql`、`lua-resty-redis`、`lua-resty-core`）以及子模块（如 `ngx_stream_lua_module`、`lua-ssl-nginx-module`），支持 HTTP、TCP/UDP、SSL/TLS 等多层场景。

### 部署lua模块与兼容性

`ngx_http_lua_module` 并未默认包含于 Nginx 源码中。

- **推荐通过 OpenResty 安装，以获得优化过的 LuaJIT 与补丁内核**。[openresty/lua-nginx-module: Embed the Power of Lua into NGINX HTTP servers](https://github.com/openresty/lua-nginx-module)
- 亦可通过 `--add-module` 或 `--add-dynamic-module` 参数在手动编译 Nginx 时启用。该模块与 Nginx 1.13.6 及以上版本兼容，常用于负载均衡、API 网关及安全防护脚本。

### 常见版本示例

宝塔编译的版本(通常已经添加了lua模块)

```bash
$ nginx -V
nginx version: nginx/1.28.0
built by gcc 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.2)
built with OpenSSL 1.1.1q  5 Jul 2022
TLS SNI support enabled
configure arguments: --user=www --group=www --prefix=/www/server/nginx --add-module=/www/server/nginx/src/ngx_devel_kit --add-module=/www/server/nginx/src/lua_nginx_module ...
```

`--add-module=/www/server/nginx/src/lua_nginx_module`表明其可以运行`lua`

而openresty

```bash
 openresty.exe -V
nginx version: openresty/1.29.2.1
built by gcc 7.3.0 (Rev1, Built by MSYS2 project)
built with OpenSSL 3.5.4 30 Sep 2025
TLS SNI support enabled
configure arguments: --prefix=. --with-cc-opt='-O2 -DFD_SETSIZE=1024' --add-module=../ngx_devel_kit-0.3.4 --add-module=../echo-nginx-module-0.63 --add-module=../xss-nginx-module-0.06 --add-module=../ngx_coolkit-0.2 --add-module=../set-misc-nginx-module-0.33 --add-module=../form-input-nginx-module-0.12 --add-module=../encrypted-session-nginx-module-0.09 --add-module=../srcache-nginx-module-0.33 --add-module=../ngx_lua-0.10.29R2 --add-module=../ngx_lua_upstream-0.07 --add-module=../headers-more-nginx-module-0.39 --add-module=../array-var-nginx-module-0.06 --add-module=../memc-nginx-module-0.20 --add-module=../redis2-nginx-module-0.15 --add-module=../redis-nginx-module-0.41 --add-module=../ngx_stream_lua-0.0.17R4 --with-cc=gcc --sbin-path=nginx.exe --with-pcre-jit --with-ipv6 --with-stream --with-stream_ssl_module --with-stream_ssl_preread_module --with-http_v2_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --with-http_stub_status_module --with-http_realip_module --with-http_addition_module --with-http_auth_request_module --with-http_secure_link_module --with-http_random_index_module --with-http_gzip_static_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-select_module --with-pcre=/home/agentzh/work/openresty-1.29.2.1/objs/lib/pcre2-10.46 --with-zlib=/home/agentzh/work/openresty-1.29.2.1/objs/lib/zlib-1.3.1 --with-openssl=/home/agentzh/work/openresty-1.29.2.1/objs/lib/openssl-3.5.4 --with-openssl-opt=-g --with-pcre-opt=-g --with-zlib-opt=-g --with-stream --with-http_ssl_module
```

```ini
--add-module=../ngx_lua-0.10.29R2
--add-module=../ngx_lua_upstream-0.07
--add-module=../ngx_stream_lua-0.0.17R4 
--with-ld-opt='-Wl,-rpath,/www/server/nginx/luajit/lib -Wl,-E -ljemalloc' 
```

| 项目      | 第一个版本         | 第二个版本      |
| --------- | ------------------ | --------------- |
| nginx版本 | openresty/1.27.1.2 | nginx/1.28.0    |
| 类型      | OpenResty发行版    | 原生Nginx       |
| Lua生态   | 完整OpenResty生态  | 只编译了lua模块 |
| Lua库     | 自带lua-resty-*    | 需要自己装      |
| Lua性能   | LuaJIT官方集成     | 不一定完整      |

这些模块属于 OpenResty核心组件。

| 模块           | 作用            |
| -------------- | --------------- |
| ngx_lua        | HTTP Lua        |
| ngx_stream_lua | TCP/UDP Lua     |
| ngx_devel_kit  | Lua依赖工具模块 |

`ngx_devel_kit`（NDK）是很多Lua模块的基础。

| 编译参数                                                     | 模块名称                | 类型          | 主要作用                                         | 典型使用场景                         | 依赖               |
| ------------------------------------------------------------ | ----------------------- | ------------- | ------------------------------------------------ | ------------------------------------ | ------------------ |
| `--add-module=../ngx_lua-0.10.29R2`                          | ngx_http_lua_module     | HTTP 模块     | 在 HTTP 请求处理阶段运行 Lua 脚本                | API网关、WAF、防盗链、鉴权、动态路由 | 依赖 LuaJIT 和 NDK |
| `--add-module=../ngx_lua_upstream-0.07`                      | ngx_lua_upstream_module | upstream 模块 | 用 Lua 动态控制 upstream（后端服务器）           | 动态负载均衡、灰度发布、智能路由     | 依赖 ngx_http_lua  |
| `--add-module=../ngx_stream_lua-0.0.17R4`                    | ngx_stream_lua_module   | Stream 模块   | 在 TCP/UDP 层运行 Lua 脚本                       | MySQL代理、Redis代理、四层负载均衡   | 依赖 LuaJIT        |
| `--with-ld-opt='-Wl,-rpath,/www/server/nginx/luajit/lib -Wl,-E -ljemalloc'` | LuaJIT + jemalloc       | 编译优化      | 指定 LuaJIT 运行库路径并启用 jemalloc 内存分配器 | 提高 Lua 执行速度、减少内存碎片      | 系统动态库         |

```ini
             Lua Script
                  │
          ngx_http_lua_module
                  │
         ngx_lua_upstream_module
                  │
HTTP request →  Nginx  → upstream
                  │
          ngx_stream_lua_module
                  │
           TCP / UDP proxy
```



