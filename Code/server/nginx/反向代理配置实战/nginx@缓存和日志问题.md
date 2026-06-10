[toc]

## abstract

观察nginx日志发现某个间接访问`webp`的请求:

```log

38.92.27.172 [10/Jun/2026:11:02:57 +0800] [GET] "/wp-content/uploads/2026/demo-0.webp" status=200 bytes=19594 UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0" referer="https://www.domain.com/product/toy-machine-monster-face-8-0-skateboard-deck24724/" conn_reqs=1 X-Real-IP: - X-Forwarded-For: 38.92.27.172 CF-IPCountry: US 

```

> 但是如果直接访问图片路径,则没有日志生成.

这其实是一个非常有意思且非常典型的 **Nginx 匹配逻辑** 与 **CDN / 防盗链机制** 交织在一起的现象。

根据你提供的日志，里面有一个非常关键的线索：`CF-IPCountry: US`。这说明你的网站使用了 **Cloudflare (CF)** 作为 CDN。

结合“直接访问图片没日志，但从商品页面访问有日志”的现象，原因可以锁定在以下两个方面：

### 原因一：Cloudflare 的缓存机制与“边缘响应”（最可能的原因）

当用户通过浏览器“直接访问”图片 URL 时，和从商品页面加载图片，在 Cloudflare 看来是两种不同的请求场景。

####  为什么直接访问没有 Nginx 日志？

当你直接把图片 URL 粘贴到浏览器地址栏访问时，Cloudflare 的边缘节点（Edge Server）发现这张图片已经被缓存了（HIT）。

- Cloudflare 直接把缓存的图片返回给了用户。
- **这个请求压根没有到达你的源站服务器（Nginx）**，所以你的 Nginx 绝对不会生成任何日志。

####  为什么从商品页面访问**有**日志？

当用户在浏览商品页面（`https://www.domain.com/product/...`）时，浏览器在后台异步加载图片。由于带有 `referer`（来源网址），Cloudflare 可能会触发不同的缓存规则，或者当时该节点的缓存刚好过期（MISS/EXPIRED），或者触发了 Cloudflare 的某些安全质询。

- 这时 Cloudflare 决定向你的源站（Nginx）发起请求获取图片。
- 请求到了 Nginx，Nginx 处理并返回 200，于是成功记录了这条日志。

### 原因二：Nginx 配置中对 `Referer`（来源）做了判断

检查一下你的 Nginx 配置文件，看看图片相关的 `location` 块里有没有类似 `valid_referers` 的防盗链配置。

很多网站会这样配置：

```nginx
location ~* \.(webp|jpg|png)$ {
    valid_referers none blocked server_names *.domain.com;
    if ($invalid_referer) {
        # 如果没有 referer（比如直接访问），或者 referer 不对
        # 有些配置会重定向到另一个专门的错误处理块，或者走另一个不记录日志的逻辑
    }
}
```

- **直接访问时**：`referer` 为空（`-`）。

- **商品页面访问时**：`referer="https://www.domain.com/..."`。

  不同的 `referer` 状态可能让 Nginx 走进了不同的分支代码，导致一个记日志，一个不记。

### 🛠️ 如何验证和排查？

#### 步骤 1：在 Cloudflare 开启“开发模式”

进入 Cloudflare 控制台，把你的网站开启 **Development Mode（开发模式）**。这会强制 Cloudflare 绕过缓存，所有请求直接回源到你的 Nginx。

- 开启后，你再“直接访问”图片。如果此时 Nginx 出现日志了，说明完全是 **Cloudflare 缓存** 导致的。

#### 步骤 2：使用 `curl` 命令行伪造请求测试

在本地电脑终端运行以下两个命令，观察 Nginx 是否都会生成日志：

**测试 A（模拟直接访问，不带 referer）：**

```bash
curl -I https://www.domain.com/wp-content/uploads/2026/SK0011621-UK20260607-154638-0.webp
```

**测试 B（模拟从商品页访问，带 referer）：**

```bash
curl -I -H "Referer: https://www.domain.com/product/test" https://www.domain.com/wp-content/uploads/2026/SK0011621-UK20260607-154638-0.webp
```

如果测试 A 在 Nginx 没日志，测试 B 有日志，那就要仔细去翻看 Nginx 配置文件里是不是针对 `$http_referer` 做了什么特殊的 `if` 判断或跳转。
