[toc]

## abstract

既然提到了 `X-Auth-`，那么 **`X-Forwarded-For`（简称 XFF）** 绝对是 `X-` 系列自定义标头中**知名度最高、使用最广泛、同时也是最经典**的一个。

它和 `X-Auth-` 的性质一样，最初都是非标准的自定义标头，但它的主要职责不是为了“认证身份”，而是为了“追踪真实的客户端 IP”。

### 1. 为什么需要 `X-Forwarded-For`？

在现代 Web 架构中，客户端（你的浏览器或 `curl`）很少直接连接到最终的业务服务器。请求通常会先经过一堆中间件，比如 **Cloudflare（CDN）、Nginx（反向代理）、负载均衡器（Load Balancer）**。

这就带来了一个问题：

当请求到达最后一层业务服务器时，服务器如果通过底层 TCP 连接去获取 IP，它拿到的**永远是上一级代理服务器的 IP**（比如 Nginx 或 Cloudflare 的节点 IP），而不是坐在电脑前的你的真实 IP。

为了解决这个“盲区”，`X-Forwarded-For` 应运而生。

### 2. 它是如何工作的？（经典的三层接力）

代理服务器在转发请求时，会把客户端的真实 IP 塞进 `X-Forwarded-For` 标头里，像传接力棒一样往后传。

假设你的真实 IP 是 `1.1.1.1`，中间经历了 CDN 和反向代理：

1. **你（1.1.1.1）** 发起请求给 CDN。

2. **CDN（2.2.2.2）** 收到请求。它知道你是 `1.1.1.1`，于是在转发给下一级代理时，加上标头：

   HTTP

   ```
   X-Forwarded-For: 1.1.1.1
   ```

3. **Nginx 反向代理（3.3.3.3）** 收到 CDN 的请求。它发现已经有 XFF 标头了，于是把**上一步的来源 IP（CDN 的 2.2.2.2）** 追加到后面，用逗号隔开，转发给源站：

   HTTP

   ```
   X-Forwarded-For: 1.1.1.1, 2.2.2.2
   ```

4. **最终业务服务器** 收到请求。通过看 `X-Forwarded-For` 的**第一个 IP**，它就知道最初发起请求的客户端其实是 `1.1.1.1`。

> **标准格式：**
>
> ```
> X-Forwarded-For: client, proxy1, proxy2
> ```

### 3. XFF 的亲戚们（常见的转发标头）

除了 `X-Forwarded-For`，在代理和 CDN 链路中经常一起出现的还有这几个标头：

- **`X-Forwarded-Proto`**：记录客户端原本用的是 HTTP 还是 HTTPS。因为很多时候 CDN/Nginx 会把 HTTPS 解密，用普通的 HTTP 转发给后端，后端需要这个标头来判断用户访问时是否安全。
- **`X-Forwarded-Host`**：记录客户端原本访问的域名是什么。
- **`CF-Connecting-IP`**：这是 **Cloudflare 专属**的标头。因为 XFF 可能会有一长串 IP，Cloudflare 会直接把用户的真实 IP 单独塞进这个标头里，方便后端一目了然地读取。

### ⚠️ 安全警告：IP 伪造漏洞（IP Spoofing）

作为开发者或系统管理员，处理 `X-Forwarded-For` 时必须非常小心，因为 **HTTP 标头是由客户端发送的，它可以被任意伪造**。

如果你在终端执行：



```
curl https://your-website.com --header "X-Forwarded-For: 8.8.8.8"
```

如果你的 Nginx 或后端程序没有做防范，直接读取了 XFF 的第一个 IP，你的程序就会误以为请求来自 `8.8.8.8`（谷歌 DNS）。如果你的系统有“基于 IP 限制访问频率”或“基于 IP 允许登录后台”的功能，此时就会被轻松绕过。

**💡 正确的安全实践：**

- 永远不要盲目信任不受控制的代理传过来的 XFF 标头。
- 在 Nginx 中，应当配置 `real_ip_header X-Forwarded-For;` 并配合 `set_real_ip_from`，**明确指定只有来自你信任的代理 IP（如 Cloudflare 的 IP 段或自建负载均衡 IP）传过来的 XFF 标头才予以采纳**，其余的一律过滤掉或重写。