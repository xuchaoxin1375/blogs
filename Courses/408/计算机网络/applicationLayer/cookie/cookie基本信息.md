[toc]

## abstract

[HTTP Cookie - HTTP | MDN --- HTTP Cookie - HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Cookies)

Cookie 是一种存储在用户浏览器中的小型文本数据文件，通常用于存储和传递状态信息，以便网站能够记住用户的信息或偏好设置。它在现代网页应用中扮演了重要的角色，尤其是在用户认证、个性化设置和跟踪用户行为等方面。

## HTTP Cookie

HTTP Cookie（也叫 Web Cookie 或浏览器 Cookie）是**服务器发送到用户浏览器**并保存在本地的一**小块数据**。

**浏览器**会存储 cookie 并在**下次向同一服务器再发起请求时携带并发送到服务器上**。

通常，它用于**告知服务端两个请求是否来自同一浏览器**——如保持用户的登录状态。

> Cookie 使基于[无状态](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Overview#http_是无状态，有会话的)的 HTTP 协议记录稳定的状态信息成为了可能。

Cookie 主要用于以下三个方面：

- [会话状态管理](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Cookies#会话状态管理)

  如用户登录状态、购物车、游戏分数或其他需要记录的信息

- [个性化设置](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Cookies#个性化设置)

  如用户自定义设置、主题和其他设置

- [浏览器行为跟踪](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Cookies#浏览器行为跟踪)

  如跟踪分析用户行为等

Cookie 曾一度用于**客户端数据**的存储，因当时并没有其他合适的存储办法而作为唯一的存储手段，但**现在推荐使用现代存储 API**。

> 由于服务器指定 Cookie 后，浏览器的每次请求都会携带 Cookie 数据，会带来额外的性能开销（尤其是在移动环境下）。
>
> 新的浏览器 API 已经允许开发者直接**将数据存储到本地**，如使用 [Web storage API](https://developer.mozilla.org/zh-CN/docs/Web/API/Web_Storage_API)（`localStorage` 和 `sessionStorage`）或 [IndexedDB](https://developer.mozilla.org/zh-CN/docs/Web/API/IndexedDB_API) 。

**备注：**要查看 Cookie 存储（或网页上能够使用其他的存储方式），你可以在开发者工具中启用存储查看器（[Storage Inspector](https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/index.html)）功能，并在存储树上选中 Cookie。



## 创建 Cookie

服务器收到 HTTP 请求后，服务器可以在响应标头里面添加一个或多个 [`Set-Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Set-Cookie) 选项。浏览器收到响应后通常会保存下 Cookie，并将其放在 HTTP [`Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Cookie) 标头内，向同一服务器发出请求时一起发送。你可以指定一个过期日期或者时间段之后，不能发送 cookie。你也可以对指定的域和路径设置额外的限制，以限制 cookie 发送的位置。关于下面提到的头部属性的详细信息，请参考 [`Set-Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Set-Cookie) 文章。

### Cookie的主要组成

一个典型的 Cookie 包含以下几个部分：

1. **名称（Name）**：Cookie的名称，用于标识这个Cookie。
2. **值（Value）**：Cookie的值，通常是与名称相关的数据。
3. **过期时间（Expires/Max-Age）**：Cookie的有效期。过期后，浏览器会自动删除它。若没有指定过期时间，Cookie为“会话Cookie”，即仅在浏览器会话期间有效。
4. **路径（Path）**：指定在哪个路径下，或哪些URL才能访问这个Cookie。如果设置了路径限制，那么只有在这个路径下的请求才能携带这个Cookie。
5. **域（Domain）**：指定Cookie在哪个域下有效。通常，Cookie可以被设置为在子域中也有效。
6. **安全性（Secure）**：如果设置了`Secure`标志，Cookie只能通过HTTPS协议传输，增加了安全性。
7. **HttpOnly**：如果设置了`HttpOnly`标志，JavaScript就不能访问该Cookie，这对防止跨站脚本攻击（XSS）很有帮助。

### Cookie的用途

1. **会话管理（Session Management）**：
   - 用于存储会话信息，如用户登录状态、购物车内容等。
   - 比如，在电子商务网站中，Cookie可以用于记录购物车中的商品，用户在浏览不同页面时购物车内容仍然保持不变。
2. **个性化设置（Personalization）**：
   - 网站可以使用Cookie保存用户的偏好设置，如语言选择、主题颜色等，提供个性化的浏览体验。
   - 例如，如果用户设置了一个网站的语言为中文，下次访问时该网站会自动切换为中文界面。
3. **跟踪与分析（Tracking and Analytics）**：
   - 通过跟踪用户在不同页面和网站上的行为，网站可以分析用户行为，为广告商提供定向广告服务。
   - 例如，Google Analytics和广告服务商通过Cookie跟踪用户的活动，以分析其浏览习惯。

### Cookie的种类

1. **会话Cookie（Session Cookies）**：
   - 这些Cookie在用户关闭浏览器时会被删除。
   - 常用于保存临时会话数据。
2. **持久Cookie（Persistent Cookies）**：
   - 这些Cookie在浏览器关闭后仍然存在，并会在设定的过期时间之前继续保存。
   - 例如，保存用户的登录状态或语言设置等。
3. **第三方Cookie（Third-party Cookies）**：
   - 这些Cookie来自当前访问的网站以外的域，用于跨站点跟踪和广告投放。
   - 比如，广告公司可以在多个不同的网站上通过第三方Cookie来跟踪用户的活动，以提供定向广告。

### Cookie的隐私问题

由于Cookie可以用来跟踪用户的行为，过度依赖Cookie可能会带来隐私泄露的问题。为了解决这些问题，许多国家和地区实施了相关的隐私保护法律，如欧盟的《通用数据保护条例》（GDPR）和加利福尼亚的《消费者隐私法案》（CCPA）。这些法律要求网站在使用Cookie时要获取用户的明确同意，并提供管理Cookie的选项。

### 如何管理Cookie

1. **浏览器设置**：
   - 大多数浏览器允许用户查看、删除或禁用Cookie。通过浏览器的隐私设置，用户可以选择是否接受某些类型的Cookie。
2. **Cookie管理工具**：
   - 许多网站提供Cookie设置界面，允许用户选择是否同意使用Cookie，或管理哪些类型的Cookie可以启用。
3. **无痕模式（Incognito/Private Mode）**：
   - 使用浏览器的无痕模式，可以避免浏览器保存Cookie和历史记录。

### 示例

假设有一个电子商务网站 `example.com`，它使用 Cookie 来保存用户的登录状态和购物车内容。每当用户访问网站时，浏览器会发送存储在 `example.com` 域下的 Cookie 信息，服务器接收后验证用户是否已经登录并恢复购物车内容。

1. **用户登录后，服务器可能会发送一个 Cookie**：

   ```http
   Set-Cookie: sessionID=12345; Expires=Wed, 21 Oct 2025 07:28:00 GMT; Path=/; Domain=example.com; Secure; HttpOnly
   ```

2. **用户下次访问时，浏览器会发送该 Cookie**：

   ```http
   Cookie: sessionID=12345
   ```

服务器使用这个 Cookie 来识别用户并恢复会话状态。

总结来说，Cookie 是一种非常重要的网络技术，广泛应用于会话管理、个性化设置以及用户行为跟踪等方面。了解 Cookie 的工作原理和隐私保护措施，对于提高网络安全性和用户体验至关重要。