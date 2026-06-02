[toc]



# HTTP 验证方案

## 概述

- [HTTP 身份验证 - HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Authentication)

HTTP 提供了一套**通用的访问控制和身份验证**框架，允许**服务器对客户端请求进行质询（challenge）**，**客户端则提供凭据（credentials）来证明身份**。

这套框架定义在 RFC 7235 中，具体的验证逻辑由不同的"验证方案"（Authentication Scheme）来实现。

## 通用验证流程

质询与响应的工作流程如下：

1. 服务器端向客户端返回 [`401`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Status/401)（Unauthorized，未被授权的）响应状态码，并在 [`WWW-Authenticate`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/WWW-Authenticate) 响应标头提供如何进行验证的信息，其中至少包含有一种质询方式。
2. 之后，想要使用服务器对自己身份进行验证的客户端，可以通过包含凭据的 [`Authorization`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Authorization) 请求标头进行验证。
3. 通常，客户端会向用户显示密码提示，然后发送包含正确的 `Authorization` 标头的请求。

```mermaid
sequenceDiagram
    participant C as 客户端
    participant S as 服务器

    C->>S: 请求受保护资源
    S-->>C: 401 Unauthorized<br>WWW-Authenticate: scheme realm="xxx"
    C->>C: 用户输入凭据
    C->>S: 请求 + Authorization: scheme credentials
    alt 验证成功
        S-->>C: 200 OK（返回资源）
    else 验证失败
        S-->>C: 401 Unauthorized 或 403 Forbidden
    end
```

核心要点：

- **服务器**通过 `WWW-Authenticate` 响应头发起质询，告知客户端需要哪种**验证方案**以及适用的保护域（realm）。
- **客户端**通过 `Authorization` 请求头携带凭据。
- 对于代理服务器，对应的头部是 `Proxy-Authenticate` 和 `Proxy-Authorization`，状态码为 407。



## 关键头部字段

| 头部                  | 方向            | 用途                     |
| --------------------- | --------------- | ------------------------ |
| `WWW-Authenticate`    | 服务器 → 客户端 | 声明所需的验证方案和参数 |
| `Authorization`       | 客户端 → 服务器 | 携带身份凭据             |
| `Proxy-Authenticate`  | 代理 → 客户端   | 代理要求验证             |
| `Proxy-Authorization` | 客户端 → 代理   | 向代理提供凭据           |

头部的通用语法：

```http
WWW-Authenticate: <scheme> realm=<realm> [, param=value ...]
Authorization: <scheme> <credentials>
```

`realm` 用于划分保护空间——同一服务器上不同的 realm 可以有不同的用户数据库和访问策略。

### WWW-Authenticate 与 Proxy-Authenticate 标头

[`WWW-Authenticate`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/WWW-Authenticate) 与 [`Proxy-Authenticate`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Proxy-Authenticate) 响应标头指定了为获取资源访问权限而进行身份验证的方法。它们需要明确要进行验证的方案，这样希望进行授权的客户端就知道该如何提供凭据。

这两个标头的语法形式如下：

```http
WWW-Authenticate: <type> realm=<realm>
Proxy-Authenticate: <type> realm=<realm>
```

在这里，`<type>` 指的是验证的方案（“Basic”是最常见的验证方案）。

### realm

**realm** 用来描述进行保护的区域，或者指代保护的范围。它可以是类似于“Access to the staging site”的消息，这样用户就可以知道他们正在试图访问哪一空间。

简单来说，它是服务器用来告诉浏览器：**“你现在访问的是一个受保护的特定区域，请输入该区域对应的用户名和密码。”**

### Authorization 与 Proxy-Authorization 标头

[`Authorization`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Authorization) 与 [`Proxy-Authorization`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Proxy-Authorization) 请求标头包含有用来向（代理）服务器证明用户代理身份的凭据。这里同样需要指明验证的 `<type>`，其后跟有凭据信息，该凭据信息可以被编码或者加密，取决于采用的是哪种验证方案。

```http
Authorization: <type> <credentials>
Proxy-Authorization: <type> <credentials>
```

## 主要验证方案一览

IANA 维护着一份[官方注册表](https://www.iana.org/assignments/http-authschemes/http-authschemes.xhtml)，以下是实践中最常见的方案：

| 方案      | 凭据传输方式                                | 安全性                              | 典型场景                      |
| --------- | ------------------------------------------- | ----------------------------------- | ----------------------------- |
| Basic     | Base64 编码的用户名:密码                    | 低（明文等价，必须配合 HTTPS）      | 内部工具、快速原型            |
| Bearer    | 不透明令牌（通常是 OAuth 2.0 access token） | 取决于令牌管理                      | API 认证、OAuth 2.0/OIDC      |
| Digest    | 基于摘要（MD5/SHA-256）的质询-响应          | 中（不传明文密码，但 MD5 已不安全） | 遗留系统                      |
| HOBA      | 基于数字签名的绑定认证                      | 高                                  | 无密码场景（实验性）          |
| Mutual    | 双向 TLS 认证                               | 高                                  | 服务间通信                    |
| Negotiate | SPNEGO（Kerberos/NTLM）                     | 高                                  | 企业内网 SSO                  |
| SCRAM     | 盐化质询-响应机制                           | 高                                  | 现代协议（较少直接用于 HTTP） |
| vapid     | 自愿应用服务器标识                          | 中                                  | Web Push 推送服务             |

## 各方案详解

### Basic 方案

最简单的验证方案。客户端将 `用户名:密码` 用 Base64 编码后放入 Authorization 头。

```http
# 服务器质询
WWW-Authenticate: Basic realm="Admin Area", charset="UTF-8"

# 客户端响应（假设用户名 admin，密码 123456）
Authorization: Basic YWRtaW46MTIzNDU2
```

工作原理：

1. 将用户名和密码用冒号拼接：`admin:123456`
2. 对拼接结果进行 Base64 编码：`YWRtaW46MTIzNDU2`
3. 服务器解码后验证

安全注意事项：

- Base64 不是加密，**任何人截获请求都能还原出明文密码**。
- **必须在 HTTPS 下使用**，这是硬性要求而非建议。
- 浏览器通常会缓存凭据直到会话结束，没有标准的"登出"机制。
- `charset="UTF-8"` 参数解决了非 ASCII 用户名/密码的编码问题（RFC 7617）。



### Bearer 方案(主流)

OAuth 2.0 框架中最常用的令牌传递方式（RFC 6750）。客户端持有一个不透明的访问令牌（access token），在请求中出示即可。

```http
# 服务器质询
WWW-Authenticate: Bearer realm="api",
  error="invalid_token",
  error_description="The access token expired"

# 客户端请求
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

Bearer 令牌的特点：

- "持有者即所有者"——任何拿到令牌的人都能使用它，类似现金。
- 令牌本身可以是任意格式，但 JWT（JSON Web Token）是最流行的选择。
- 令牌通常有过期时间，配合 refresh token 实现续期。

```mermaid
sequenceDiagram
    participant U as 用户
    participant C as 客户端应用
    participant AS as 授权服务器
    participant RS as 资源服务器

    U->>C: 发起操作
    C->>AS: 请求令牌（携带凭据或授权码）
    AS-->>C: 返回 access_token + refresh_token
    C->>RS: GET /resource<br>Authorization: Bearer access_token
    RS->>RS: 验证令牌（签名、过期、权限）
    RS-->>C: 200 OK + 资源数据
```

最佳实践：

- 令牌必须通过 HTTPS 传输。
- 设置合理的过期时间（access token 通常 5-60 分钟）。
- 使用 scope 限制令牌权限，遵循最小权限原则。
- 服务端验证令牌签名、过期时间和受众（audience）。
- 不要将令牌存储在 localStorage 中（XSS 风险），优先使用 HttpOnly cookie 或内存。

### Digest 方案(淘汰)

为解决 Basic 方案的明文传输问题而设计。

服务器发送一个随机数（nonce），客户端用它和密码一起计算摘要值。

```http
# 服务器质询
WWW-Authenticate: Digest realm="api@example.com",
  qop="auth",
  algorithm=SHA-256,
  nonce="7ypf/xlj9XXwfDPE",
  opaque="FQhe/qaU925kfnzjCev0ciny7QMkPqMAFRtzCUYo5tdS"

# 客户端响应
Authorization: Digest username="admin",
  realm="api@example.com",
  uri="/api/data",
  algorithm=SHA-256,
  nonce="7ypf/xlj9XXwfDPE",
  nc=00000001,
  cnonce="f2/wE4q74E6zIJEt",
  qop=auth,
  response="753927fa0e85d155564e2e272a28d1802ca10daf4496794697cf8db5856cb6c1",
  opaque="FQhe/qaU925kfnzjCev0ciny7QMkPqMAFRtzCUYo5tdS"

```

```mermaid
sequenceDiagram
    participant C as 客户端
    participant S as 服务器

    S-->>C: 401 + nonce, realm, qop, algorithm
    C->>C: 计算 HA1 = H(username:realm:password)
    C->>C: 计算 HA2 = H(method:uri)
    C->>C: 计算 response = H(HA1:nonce:nc:cnonce:qop:HA2)
    C->>S: Authorization: Digest response=...
    S->>S: 用相同算法验证 response
```



关键参数说明：

| 参数        | 含义                                                   |
| ----------- | ------------------------------------------------------ |
| `nonce`     | 服务器生成的一次性随机数，防止重放攻击                 |
| `cnonce`    | 客户端生成的随机数，防止选择明文攻击                   |
| `nc`        | nonce 计数器，检测重放                                 |
| `qop`       | 保护质量：`auth`（仅认证）或 `auth-int`（认证+完整性） |
| `algorithm` | 摘要算法，推荐 SHA-256（RFC 7616）                     |
| `opaque`    | 服务器状态数据，客户端原样返回                         |

现代评价：

- 比 Basic 好——密码不以明文传输。
- 但服务器仍需存储明文密码（或等价的 HA1 值）。
- MD5 已被认为不安全，即使用 SHA-256 也不如 TLS + Bearer 方案。
- **实际部署中已逐渐被淘汰，新项目不建议使用**。



### Negotiate 方案（SPNEGO）

用于 Windows 集成认证和 Kerberos 环境，实现企业内网的单点登录（SSO）。

```http
WWW-Authenticate: Negotiate
Authorization: Negotiate YIIJvwYGKwYBBQUCoIIJ...
```

工作方式：

- 基于 SPNEGO（Simple and Protected GSSAPI Negotiation Mechanism）。
- 客户端和服务器协商使用 Kerberos 或 NTLM。
- 浏览器自动使用当前登录的域凭据，用户无感知。
- **主要用于企业内网环境，不适合公网应用**。

## 方案选型指南

```mermaid
flowchart TD
    A[需要 HTTP 认证] --> B{应用场景?}
    B -->|公网 API| C{有 OAuth 基础设施?}
    C -->|是| D[Bearer + OAuth 2.0]
    C -->|否| E{需要简单快速?}
    E -->|是| F[Basic over HTTPS]
    E -->|否| D
    B -->|企业内网| G{有 AD/Kerberos?}
    G -->|是| H[Negotiate]
    G -->|否| F
    B -->|服务间通信| I{双向信任?}
    I -->|是| J[Mutual TLS]
    I -->|否| D
    B -->|Web Push| K[VAPID]
```

决策要点总结：

| 场景              | 推荐方案                 | 理由                   |
| ----------------- | ------------------------ | ---------------------- |
| 现代 Web/移动 API | Bearer (OAuth 2.0 + JWT) | 标准化、灵活、生态成熟 |
| 快速原型/内部工具 | Basic over HTTPS         | 实现简单，调试方便     |
| 企业内网 SSO      | Negotiate (Kerberos)     | 用户无感知，集中管理   |
| 微服务间调用      | Mutual TLS 或 Bearer     | 强身份绑定，无需密码   |
| 遗留系统兼容      | Digest (SHA-256)         | 不推荐新建，仅维护用   |

## 安全最佳实践

**传输层保护**

所有验证方案都应在 HTTPS 下运行。即使 Digest 方案不传输明文密码，中间人仍可篡改响应或降级攻击。

**凭据存储**

- 服务端永远不要明文存储密码，使用 bcrypt、scrypt 或 Argon2 进行哈希。
- 令牌应加密存储，支持撤销机制。
- 客户端避免将凭据持久化到不安全的存储中。

**防御常见攻击**

| 攻击类型 | 防御措施                       |
| -------- | ------------------------------ |
| 重放攻击 | 使用 nonce、时间戳、短期令牌   |
| 暴力破解 | 速率限制、账户锁定、渐进延迟   |
| CSRF     | SameSite cookie、CSRF token    |
| 令牌泄露 | 短过期时间、令牌绑定、撤销列表 |
| 降级攻击 | HSTS、禁用弱方案               |

**响应头配置**

```http
Strict-Transport-Security: max-age=31536000; includeSubDomains
Cache-Control: no-store
```

对包含凭据的请求/响应禁用缓存，防止敏感信息被中间代理存储。

## X-开头的非标准标头

在这两个 `curl` 命令中，**“标头”指的是 `—header`（或简写为 `-H`）后面携带的键值对**。它们统称为 **HTTP Headers（HTTP 请求头）**，作用是向服务器传递元数据（比如身份验证信息、数据类型等）。

以cloudflare的api请求的两个示例命令中的标头为例说明:

```shell
curl "https://api.cloudflare.com/client/v4/zones?account.id=$ACCOUNT_ID" \
--header "Authorization: Bearer $CLOUDFLARE_API_TOKEN"
```

- **标头内容：** `"Authorization: Bearer $CLOUDFLARE_API_TOKEN"`
- **它的作用：** * **键 (Key)：** `Authorization`（授权）
  - **值 (Value)：** `Bearer $CLOUDFLARE_API_TOKEN`
  - **解释：** 这是最常见的 **API Token 认证方式**。它告诉 Cloudflare 服务器：“我是持有这个令牌（Token）的人，请验证我的权限并允许我查看区域（Zones）列表。”

```shell
curl --request PATCH "https://api.cloudflare.com/client/v4/user/invites/{id}" \
--header "X-Auth-Email: <EMAIL>" \
--header "X-Auth-Key: <API_KEY>" \
--data "{""status"": ""accepted""}"
```

这个命令里包含了**两个**标头：

1. **第一个标头：** `"X-Auth-Email: <EMAIL>"`
   - **键：** `X-Auth-Email`
   - **值：** `<EMAIL>`（你的 Cloudflare 账户邮箱）
2. **第二个标头：** `"X-Auth-Key: <API_KEY>"`
   - **键：** `X-Auth-Key`
   - **值：** `<API_KEY>`（你的 Cloudflare 全局 API 密钥，通常在后台 Global API Key 处获取）

- **它们的作用：**
  - 这是 Cloudflare 的**传统认证方式（Global API Key 认证）**。它需要将你的“账号邮箱”和“全局密钥”组合在一起发送，服务器才会允许你执行接受邀请（PATCH）的操作。

💡 核心区别小结

| **认证方式**            | **使用的标头 (Headers)**        | **安全性建议**                                               |
| ----------------------- | ------------------------------- | ------------------------------------------------------------ |
| **第一种 (API Token)**  | `Authorization: Bearer <TOKEN>` | **更安全**。权限是受限的（比如只能读，不能写），推荐使用。   |
| **第二种 (Global Key)** | `X-Auth-Email` 和 `X-Auth-Key`  | **风险较高**。这个 Key 拥有你账户的最高全权，一旦泄露等于整个账号失控，非必要不推荐使用。 |

以 `X-Auth-` 开头的标头（例如 `X-Auth-Email`、`X-Auth-Key`、`X-Auth-Token`）属于**自定义的、非标准的 HTTP 认证标头**。

为了让你彻底明白它的来龙去脉，我们可以从以下几个维度来解构：

### 1. 名字里的 “X-” 是什么意思？

在过去的 HTTP 协议传统中，**`X-` 代表 “Extension”（扩展）或 “Experimental”（实验性）**。

- **标准标头：** 像 `Authorization`、`Content-Type`、`User-Agent` 这些是 IETF（互联网工程任务组）官方定义的标准标头，全世界通用。
- **自定义标头：** 如果某个公司（比如 Cloudflare、GitHub 等）想在 HTTP 请求中传递一些自己特有的数据，官方标准里又没有这个字段，他们就会自己发明一个以 `X-` 开头的标头。

> ⚠️ **时代变迁：** > 尽管 RFC 6648 官方文档在多年前就已经**不推荐**新开发的系统再使用 `X-` 前缀（主张直接命名，如直接叫 `Auth-Token`），但由于历史惯性和兼容性，许多像 Cloudflare 这样的大厂依然在沿用 `X-Auth-` 系列标头。

### 2. `X-Auth-` 的工作原理

官方的标准认证通常使用 `Authorization` 标头（如 `Authorization: Bearer <token>`），它有严格的格式规范。

而 `X-Auth-` 则是 API 开发者**自己制定规则**的产物。服务器端的校验流程如下：

1. **客户端发送：** 你的 `curl` 命令把 `X-Auth-Email: user@example.com` 和 `X-Auth-Key: 123456` 塞进请求头发送出去。
2. **网关/服务器拦截：** Cloudflare 的服务器收到请求，专门去读取这两个自定义标头的值。
3. **数据库比对：** 服务器检查这个邮箱和 Key 是否匹配。如果匹配成功，放行请求；如果失败，返回 `401 Unauthorized`（未授权）或 `403 Forbidden`（拒绝访问）。

### 3. 常见的 `X-Auth-` 变体与大厂应用

除了你提到的 Cloudflare，很多著名的 API 服务都在使用类似的自定义认证标头：

| **标头名称**       | **常见使用场景 / 巨头案例**    | **作用**                                               |
| ------------------ | ------------------------------ | ------------------------------------------------------ |
| **`X-Auth-Email`** | Cloudflare                     | 传递用户的登录邮箱账户                                 |
| **`X-Auth-Key`**   | Cloudflare                     | 传递全局专用的 API 密钥                                |
| **`X-Auth-Token`** | OpenStack / 各种私有云 API     | 传递一个临时生成的身份令牌                             |
| **`X-API-Key`**    | AWS API Gateway / 多数现代 API | 虽然没带 Auth，但性质一样，用于传递应用专用的 API 密钥 |

### 总结

`X-Auth-` 标头就像是某些大型网站**自己家里定的“暗号”**。它不是国际通用的标准标准，但只要你用的是他们家的服务（比如 Cloudflare），你就必须按照他们的规矩，在请求头里带上这个“暗号”才能开门。

## 401 与 403 的区别

这两个状态码经常被混淆：

| 状态码           | 含义                         | 何时使用             |
| ---------------- | ---------------------------- | -------------------- |
| 401 Unauthorized | 未认证——不知道你是谁         | 缺少凭据或凭据无效   |
| 403 Forbidden    | 未授权——知道你是谁但你没权限 | 身份已确认但权限不足 |

401 响应**必须**包含 `WWW-Authenticate` 头，告诉客户端如何认证。

403 则不需要，因为再次认证也不会改变结果。

## 多方案协商

服务器可以在一个响应中**声明支持多种验证方案**：

```http
WWW-Authenticate: Bearer realm="api", Negotiate, Basic realm="api"
```

客户端应选择自己支持的**最安全的方案**。浏览器通常按照自身偏好顺序选择，而非服务器列出的顺序。

## 小结

HTTP 验证框架是一个可扩展的**质询-响应体系**。理解它的核心在于把握三点：

- **质询**：服务器通过 `WWW-Authenticate` 告知"我需要什么"。
- **响应**：客户端通过 `Authorization` 回答"这是我的凭据"。
- **方案**：具体的验证逻辑由方案定义，从简单的 Basic 到复杂的 Negotiate，各有适用场景。

对于新项目，**Bearer + OAuth 2.0/OIDC 是绝大多数场景的首选**。它将认证逻辑外置到专门的授权服务器，应用本身只需验证令牌，职责清晰且易于扩展。