[toc]



`sub_filter` 和 `rewrite` 是 NGINX 中两个功能完全不同但容易混淆的指令。它们都可用于修改 HTTP 请求或响应的行为，但作用对象、执行时机和使用场景有本质区别。

---

## 🔍 对比概览

| 特性                 | `sub_filter`                                        | `rewrite`                      |
| -------------------- | --------------------------------------------------- | ------------------------------ |
| **作用对象**         | 响应体（Response Body）                             | 请求（Request URI）            |
| **修改内容**         | HTML、文本等响应内容中的字符串                      | 客户端请求的 URI               |
| **执行阶段**         | 输出过滤阶段（response body filter）                | 接入阶段早期（rewrite phase）  |
| **是否改变请求路径** | ❌ 否                                                | ✅ 是（可内部跳转或外部重定向） |
| **典型用途**         | 替换返回页面中的文本、链接                          | URL 重写、跳转、参数处理       |
| **是否影响代理内容** | ✅ 可用于 `proxy_pass` 后的内容替换                  | ✅ 可在代理前修改请求 URI       |
| **是否支持正则**     | ✅ 支持正则匹配（`sub_filter ~pattern replacement`） | ✅ 支持正则匹配                 |

---

## 📌 详细说明

### 1. `sub_filter` —— 内容替换（响应体过滤）

#### 功能：
在 NGINX 返回给客户端的 **响应体内容** 中，查找并替换指定的字符串。

#### 语法：
```nginx
sub_filter <string_to_find> <replacement>;
sub_filter_once on|off;  # 是否只替换第一个匹配项
sub_filter_types <MIME types>;  # 指定哪些 Content-Type 的响应体参与替换
```

#### 示例：替换后端返回页面中的旧域名
```nginx
location / {
    proxy_pass http://backend;
    sub_filter 'old-site.com' 'new-site.com';
    sub_filter_once off;
    sub_filter_types text/html text/css text/javascript;
}
```

> ✅ 效果：如果后端返回的 HTML 中包含 `https://old-site.com/logo.png`，会被自动替换为 `https://new-site.com/logo.png`。

#### 注意事项：
- 必须确保响应体是完整文本（不压缩），否则无法替换。  
  → 通常需关闭压缩：`proxy_set_header Accept-Encoding "";`
- 仅作用于响应体，不影响请求流程。
- 常用于：CDN 内容替换、前端资源路径迁移、多租户页面定制等。

---

### 2. `rewrite` —— 请求重写（URI 修改）

#### 功能：
修改客户端发起的 **请求 URI**，可以是内部重写（不跳转）或外部重定向（返回 301/302）。

#### 语法：
```nginx
rewrite <regex> <replacement> [flag];
```

常用 flag：
- `last`：内部重写，停止当前 `location` 并重新匹配（类似内部跳转）
- `break`：内部重写，停止重写但不重新匹配
- `redirect`：返回 302 临时重定向
- `permanent`：返回 301 永久重定向

#### 示例 1：将旧路径跳转到新路径
```nginx
location /old-page {
    rewrite ^/old-page$ /new-page permanent;
}
```
> 浏览器地址栏变为 `/new-page`，HTTP 状态码 301。

#### 示例 2：内部重写（透明）
```nginx
location /api/ {
    rewrite ^/api/(.*)$ /v1/$1 break;
    proxy_pass http://backend;
}
```
> 请求 `/api/users` 实际转发为 `/v1/users`，客户端无感知。

#### 注意事项：
- `rewrite` 在请求早期执行，影响后续 `location` 匹配。
- 常用于：URL 规范化、版本迁移、SEO 跳转、参数提取等。

---

## ✅ 典型使用场景对比

| 场景                                          | 推荐指令                | 说明                     |
| --------------------------------------------- | ----------------------- | ------------------------ |
| 将页面中 `http://` 链接替换为 `https://`      | `sub_filter`            | 修改响应内容中的链接     |
| 把 `/user/123` 改为 `/v2/user/123`            | `rewrite`               | 修改请求路径，转发给后端 |
| 实现 `example.com` → `www.example.com` 跳转   | `rewrite ... permanent` | 301 重定向               |
| 后端返回的 JS 文件中包含错误域名，需替换      | `sub_filter`            | 透明替换响应内容         |
| 清除 URL 中的跟踪参数（如 `?utm_source=...`） | `rewrite` + `return`    | 重写并跳转               |

---

## ⚠️ 常见误区

| 误解                                | 正确理解                                     |
| ----------------------------------- | -------------------------------------------- |
| `sub_filter` 可以修改请求路径       | ❌ 它只修改响应体，不改请求                   |
| `rewrite` 可以替换 HTML 内容        | ❌ 它只改请求 URI，不影响响应体               |
| `sub_filter` 能处理压缩内容（gzip） | ❌ 需关闭压缩才能生效                         |
| `rewrite` 的 `last` 和 `break` 一样 | ❌ `last` 会重新匹配 `location`，`break` 不会 |

---

## 🧩 组合使用示例

```nginx
server {
    listen 80;
    server_name example.com;

    # 1. 外部重定向：强制加 www
    if ($host = example.com) {
        rewrite ^(.*)$ https://www.example.com$1 permanent;
    }

    location / {
        proxy_pass http://backend;

        # 2. 关闭压缩以便 sub_filter 生效
        proxy_set_header Accept-Encoding "";

        # 3. 替换响应内容中的测试域名
        sub_filter 'test-api.local' 'api.example.com';
        sub_filter_once off;
    }
}
```

> ✅ 该配置实现了：
> - 请求 `example.com` → 跳转到 `www.example.com`
> - 所有响应内容中的 `test-api.local` → 替换为 `api.example.com`

---

## ✅ 总结

| 指令         | 用在哪儿   | 改什么         | 典型用途                         |
| ------------ | ---------- | -------------- | -------------------------------- |
| `sub_filter` | 响应返回前 | 响应体中的文本 | 替换 HTML/JS/CSS 中的字符串      |
| `rewrite`    | 请求接入时 | 请求 URI       | URL 跳转、内部路径重写、SEO 优化 |

> 💡 简单记：  
> - **`rewrite` 改“请求”** → 客户端看到或 NGINX 内部处理的路径  
> - **`sub_filter` 改“返回”** → 页面内容里的文字或链接

