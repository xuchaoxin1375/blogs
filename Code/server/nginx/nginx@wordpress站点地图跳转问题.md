[toc]

我使用nginx+wordpress搭建网站(yoast seo插件生成woocommerce站点地图),网站site_url和home_url设置为https://www.domain.com,发现https://domain.com访问后可以跳转到www.domain.com
但是https://domain.com/sitemap.xml会404,而https://www.domain.com/sitemap.xml可以正确跳转?

这是一个**很典型的 Nginx + WordPress + Yoast SEO（WooCommerce）组合问题**，本质是：

👉 **裸域（non-www）和 www 的重定向规则没有完全覆盖到 sitemap 路由**

下面我帮你拆开讲清楚原理 + 给你最稳的解决方案。

---

## 现象本质分析

你现在的情况：

| URL                                  | 结果                      |
| ------------------------------------ | ------------------------- |
| `https://domain.com`                 | ✅ 跳转到 `www.domain.com` |
| `https://domain.com/sitemap.xml`     | ❌ 404                     |
| `https://www.domain.com/sitemap.xml` | ✅ 正常                    |

说明：

👉 **首页跳转正常，但带路径的请求没有正确进入 WordPress 处理流程**

---

## 核心原因（重点）

### 1️⃣ Yoast sitemap 不是“真实文件”

Yoast SEO 的 sitemap：

```
/sitemap.xml
```

实际上并不是一个物理文件，而是通过：

* WordPress rewrite（重写规则）
* PHP 动态生成

👉 所以必须进入 WordPress 的 `index.php` 才能正常返回

---

### 2️⃣ 你的 Nginx 配置问题

很可能你现在是这样：

```nginx
server {
    server_name domain.com;
    return 301 https://www.domain.com;
}
```

👉 这个写法的问题是：

* 只对 **根路径 `/` 有效**
* 带路径时（如 `/sitemap.xml`）没有正确拼接

---

## 正确写法（关键）

你必须使用 `$request_uri`：

```nginx
server {
    listen 80;
    server_name domain.com;

    return 301 https://www.domain.com$request_uri;
}
```

如果是 HTTPS：

```nginx
server {
    listen 443 ssl;
    server_name domain.com;

    return 301 https://www.domain.com$request_uri;
}
```

---

## 为什么这一步关键？

### 错误写法：

```
https://domain.com/sitemap.xml
→ https://www.domain.com   ❌（路径丢失）
→ WordPress 没有 sitemap → 404
```

---

### 正确写法：

```
https://domain.com/sitemap.xml
→ https://www.domain.com/sitemap.xml ✅
→ WordPress 正常处理
```

---

## 3️⃣ 还需要检查 WordPress rewrite

确保你的 Nginx 有标准 WordPress规则：

```nginx
location / {
    try_files $uri $uri/ /index.php?$args;
}
```

否则：

👉 `/sitemap.xml` 也可能无法被转发给 WordPress

---

## 4️⃣ Yoast sitemap 特殊点

Yoast 实际 sitemap 通常是：

```
/sitemap_index.xml   ← 入口
/post-sitemap.xml
/product-sitemap.xml
```

👉 `/sitemap.xml` 有时只是兼容跳转

建议测试：

```
https://www.domain.com/sitemap_index.xml
```

---

## 排查 checklist（建议按顺序）

### ✔ 1. 测试 curl

```bash
curl -I https://domain.com/sitemap.xml
```

看是否：

* 返回 301
* Location 是否带 `/sitemap.xml`

---

### ✔ 2. 检查 Nginx redirect

是否使用了：

```
$request_uri
```

---

### ✔ 3. 检查 WordPress rewrite

确保有：

```nginx
try_files $uri $uri/ /index.php?$args;
```

---

### ✔ 4. 刷新 WP rewrite

后台：

```
设置 → 固定链接 → 保存（无需修改）
```

👉 强制刷新 rewrite 规则

---

## 最推荐的完整 Nginx 结构（现代写法）

```nginx
# 非 www → www
server {
    listen 80;
    server_name domain.com;
    return 301 https://www.domain.com$request_uri;
}

server {
    listen 443 ssl;
    server_name domain.com;

    ssl_certificate ...
    ssl_certificate_key ...

    return 301 https://www.domain.com$request_uri;
}

# 主站
server {
    listen 443 ssl;
    server_name www.domain.com;

    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php/php-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

---

## 一句话总结

👉 你的问题本质是：

> **裸域跳转时丢失了 URI，导致 Yoast sitemap 无法被 WordPress 接管**

---

