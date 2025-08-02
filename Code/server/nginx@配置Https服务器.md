[toc]



## Configuring HTTPS servers 配置 HTTPS 服务器



To configure an HTTPS server, the `ssl` parameter must be enabled on [listening sockets](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) in the [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block, and the locations of the [server certificate](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) and [private key](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate_key) files should be specified:
要配置 HTTPS 服务器， `ssl` 参数 在[服务器](https://nginx.org/en/docs/http/ngx_http_core_module.html#server)块中必须启用 [监听套接字 ](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen)， 以及指定 [服务器证书](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) 和 [私钥](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate_key)文件：

> ```nginx
>     # 与https相关的配置
> server {
>     listen              443 ssl; #启用ssl监听套接字
>     server_name         www.example.com;
> 	# 配置ssl证书和密钥
>     ssl_certificate     www.example.com.crt;
>     ssl_certificate_key www.example.com.key;
> 
>     # 证书版本(默认配合,一般可以不写)
>     ssl_protocols       TLSv1.2 TLSv1.3;
>     ssl_ciphers         HIGH:!aNULL:!MD5;
>     ...
> }
> ```

The server certificate is a public entity. It is sent to every client that connects to the server. The private key is a secure entity and should be stored in a file with restricted access, however, it must be readable by nginx’s master process. The private key may alternately be stored in the same file as the certificate:
服务器证书(crt)是一个**公共实体**，它**会发送给连接到服务器的每个客户端**。私钥(key)是一个**安全实体**，应该存储在一个访问权限受限的文件中，但必须能够被 nginx 的主进程读取。

私钥也可以与证书存储在同一个文件中：

> ```nginx
>     ssl_certificate     www.example.com.cert;
>     ssl_certificate_key www.example.com.cert;
> ```

in which case the file access rights should also be restricted. Although the certificate and the key are stored in one file, only the certificate is sent to a client.
在这种情况下，文件**访问权限也应该受到限制**。尽管证书和密钥存储在一个文件中，**但只有证书会被发送给客户端**。

The directives [ssl_protocols](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) and [ssl_ciphers](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ciphers) can be used to limit connections to include only the strong versions and ciphers of SSL/TLS. By default nginx uses “`ssl_protocols TLSv1.2 TLSv1.3`” and “`ssl_ciphers HIGH:!aNULL:!MD5`”, so configuring them explicitly is generally not needed. Note that default values of these directives were [changed](https://nginx.org/en/docs/http/configuring_https_servers.html#compatibility) several times.
指令 [ssl_protocols](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) 和 [ssl_ciphers](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ciphers) 可用于**限制连接仅包含 SSL/TLS 的强版本和密码**。默认情况下，nginx 使用“ `ssl_protocols TLSv1.2 TLSv1.3` ”和“ `ssl_ciphers HIGH:!aNULL:!MD5` ”。 因此**通常不需要明确配置它们**。 

> 请注意，这些指令的默认值是 [改变了](https://nginx.org/en/docs/http/configuring_https_servers.html#compatibility)好几次。



### HTTPS server optimization HTTPS 服务器优化

SSL operations consume extra CPU resources. On multi-processor systems several [worker processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes) should be run, no less than the number of available CPU cores. The most CPU-intensive operation is the SSL handshake. There are two ways to minimize the number of these operations per client:

-  the first is by enabling **[keepalive](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout) connections** to send several requests via one connection
-  and the second is to **reuse SSL session parameters** to avoid SSL handshakes for parallel and subsequent connections. 

The sessions are stored in an SSL session cache shared between workers and configured by the [ssl_session_cache](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache) directive. One megabyte of the cache contains about 4000 sessions. The default cache timeout is 5 minutes. It can be increased by using the [ssl_session_timeout](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_timeout) directive. Here is a sample configuration optimized for a multi-core system with 10 megabyte shared session cache:

- SSL 操作会消耗额外的 CPU 资源。 在多处理器系统上， [工作进程](https://nginx.org/en/docs/ngx_core_module.html#worker_processes) 应该运行， 不少于可用的 CPU 核心数。 

**最耗费 CPU 的操作是 SSL 握手**。 有两种方法可以最大限度地减少每个客户端的这些操作的数量：

- 第一个是通过启用 [保持连接](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout)(keepalive) ,通过一个连接发送多个请求
- 另一个重用 SSL 会话参数以避免并行和后续连接的 SSL 握手。 

会话存储在工作人员共享的 SSL 会话缓存中 并由配置 [ssl_session_cache](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache) 指示。 一兆字节的缓存包含大约 4000 个会话。 默认缓存超时时间为 5 分钟。 

可以通过使用 [ssl_session_timeout](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_timeout) 指令增加时间。

以下是针对具有 10 MB 共享会话缓存的多核系统优化的示例配置：

> ```nginx
> worker_processes auto;
> 
> http {
>     ssl_session_cache   shared:SSL:10m;
>     ssl_session_timeout 10m;
> 
>     server {
>         listen              443 ssl;
>         server_name         www.example.com;
>         keepalive_timeout   70;
> 
>         ssl_certificate     www.example.com.crt;
>         ssl_certificate_key www.example.com.key;
>         ssl_protocols       TLSv1.2 TLSv1.3;
>         ssl_ciphers         HIGH:!aNULL:!MD5;
>         ...
> ```

#### 补充

TCP链接复用和SSL会话参数复用

启用 **Keep-Alive 连接**，这样可以在一个连接上连续发送多个请求，避免频繁建立和关闭 TCP 连接带来的开销。

HTTP 1.1 默认开启 Keep-Alive，它允许**多个 HTTP 请求复用同一个 TCP 连接**，从而：

- 降低连接建立延迟（TCP 三次握手）；
- 减少 CPU 和内存资源消耗；
- 更适合移动设备或慢连接环境。

 **复用 SSL 会话参数**，即启用 SSL 会话复用机制，避免每次连接都进行完整的 SSL 握手（SSL handshake）。

启用会话复用后，客户端可以使用之前协商好的 Session ID 或 Session Ticket 来快速建立 TLS 连接，大幅降低延迟。

示例

```nginx
server {
    listen 443 ssl;

    ssl_session_cache shared:SSL:10m;    # 启用缓存
    ssl_session_timeout 10m;             # 会话缓存过期时间

    ssl_session_tickets on;              # 启用 Session Tickets（建议搭配 Key rotation 使用）
}

```



### SSL certificate chains SSL 证书链

Some browsers may complain about a certificate signed by a well-known certificate authority, while other browsers may accept the certificate without issues. This occurs because the issuing authority has signed the server certificate using an intermediate certificate that is not present in the certificate base of well-known trusted certificate authorities which is distributed with a particular browser. In this case the authority provides a bundle of chained certificates which should be concatenated to the signed server certificate. The server certificate must appear before the chained certificates in the combined file:
某些浏览器可能会对知名证书颁发机构签名的证书产生抱怨，而其他浏览器可能会顺利接受该证书。这是因为颁发机构使用中间证书签署了服务器证书，而该证书并不存在于特定浏览器分发的知名可信证书颁发机构的证书库中。

在这种情况下，颁发机构会提供一组链式证书，这些证书应与已签名的服务器证书连接起来。在合并文件中，**服务器证书必须出现在链式证书之前**：

> ```bash
> $ cat www.example.com.crt bundle.crt > www.example.com.chained.crt
> ```

The resulting file should be used in the [ssl_certificate](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) directive:
生成的文件应该在 [ssl_certificate](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) 指令：

> ```nginx
> server {
>     listen              443 ssl;
>     server_name         www.example.com;
>     ssl_certificate     www.example.com.chained.crt;
>     ssl_certificate_key www.example.com.key;
>     ...
> }
> ```

If the server certificate and the bundle have been concatenated in the wrong order, nginx will fail to start and will display the error message:
如果服务器证书和捆绑包的连接顺序错误，nginx 将无法启动并显示错误消息：

> ```nginx
> SSL_CTX_use_PrivateKey_file(" ... /www.example.com.key") failed
>    (SSL: error:05800074:x509 certificate routines::key values mismatch)
> ```

because nginx has tried to use the private key with the bundle’s first certificate instead of the server certificate.
因为 nginx 尝试使用捆绑包的第一个证书的私钥而不是服务器证书。

Browsers usually store intermediate certificates which they receive and which are signed by trusted authorities, so actively used browsers may already have the required intermediate certificates and may not complain about a certificate sent without a chained bundle. To ensure the server sends the complete certificate chain, the `openssl` command-line utility may be used, for example:
浏览器通常会存储收到的、由受信任的机构签名的中间证书，因此经常使用的浏览器可能已经拥有所需的中间证书，并且可能不会对发送的证书不包含证书链的情况产生任何抱怨。为了确保服务器发送完整的证书链，可以使用 `openssl` 命令行实用程序，例如：

> ```bash
> $ openssl s_client -connect www.godaddy.com:443
> ...
> Certificate chain
>  0 s:/C=US/ST=Arizona/L=Scottsdale/1.3.6.1.4.1.311.60.2.1.3=US
>      /1.3.6.1.4.1.311.60.2.1.2=AZ/O=GoDaddy.com, Inc
>      /OU=MIS Department/CN=www.GoDaddy.com
>      /serialNumber=0796928-7/2.5.4.15=V1.0, Clause 5.(b)
>    i:/C=US/ST=Arizona/L=Scottsdale/O=GoDaddy.com, Inc.
>      /OU=http://certificates.godaddy.com/repository
>      /CN=Go Daddy Secure Certification Authority
>      /serialNumber=07969287
>  1 s:/C=US/ST=Arizona/L=Scottsdale/O=GoDaddy.com, Inc.
>      /OU=http://certificates.godaddy.com/repository
>      /CN=Go Daddy Secure Certification Authority
>      /serialNumber=07969287
>    i:/C=US/O=The Go Daddy Group, Inc.
>      /OU=Go Daddy Class 2 Certification Authority
>  2 s:/C=US/O=The Go Daddy Group, Inc.
>      /OU=Go Daddy Class 2 Certification Authority
>    i:/L=ValiCert Validation Network/O=ValiCert, Inc.
>      /OU=ValiCert Class 2 Policy Validation Authority
>      /CN=http://www.valicert.com//emailAddress=info@valicert.com
> ...
> ```

In this example the subject (“*s*”) of the `www.GoDaddy.com` server certificate #0 is signed by an issuer (“*i*”) which itself is the subject of the certificate #1, which is signed by an issuer which itself is the subject of the certificate #2, which signed by the well-known issuer *ValiCert, Inc.* whose certificate is stored in the browsers’ built-in certificate base (that lay in the house that Jack built).
在这个例子中 *，* `www.GoDaddy.com` 服务器证书 #0 由颁发者（“”）签名，而该颁发者本身是证书 #1 的主体，证书 #1 由颁发者签名，而证书 #2 又由知名颁发者 *ValiCert, Inc.* 签名。 其证书存储在浏览器的内置 证书底座（位于杰克建造的房子里）。

If a certificate bundle has not been added, only the server certificate #0 will be shown.
如果尚未添加证书包，则只会显示服务器证书#0。



### A single HTTP/HTTPS server 单个 HTTP/HTTPS 服务器

It is possible to configure a single server that handles both HTTP and HTTPS requests:
可以配置一个同时处理 HTTP 和 HTTPS 请求的服务器：

> ```nginx
> server {
>     listen              80;
>     listen              443 ssl;
>     server_name         www.example.com;
>     ssl_certificate     www.example.com.crt;
>     ssl_certificate_key www.example.com.key;
>     ...
> }
> ```



> Prior to 0.7.14 SSL could not be enabled selectively for individual listening sockets, as shown above. SSL could only be enabled for the entire server using the [ssl](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl) directive, making it impossible to set up a single HTTP/HTTPS server. The `ssl` parameter of the [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive was added to solve this issue. The use of the [ssl](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl) directive in modern versions is thus discouraged; it was removed in 1.25.1.
> 在 0.7.14 之前，无法选择性地启用 SSL 单独的监听套接字，如上所示。 SSL 只能使用 [ssl](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl) 指令，因此无法设置 `ssl` HTTP/HTTPS 服务器。 [监听](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen)指令 已添加以解决此问题。 使用 因此，不鼓励在现代版本中使用 [ssl](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl) 指令；它在 1.25.1 中被删除。





### Name-based HTTPS servers 基于名称的 HTTPS 服务器

A common issue arises when configuring two or more HTTPS servers listening on a single IP address:
配置两个或多个**[监听单个 IP 地址]的 HTTPS 服务器**时，会出现一个常见问题：

> ```nginx
> server {
>     listen          443 ssl;
>     server_name     www.example.com;
>     ssl_certificate www.example.com.crt;
>     ...
> }
> 
> server {
>     listen          443 ssl;
>     server_name     www.example.org; #.com->.org
>     ssl_certificate www.example.org.crt;
>     ...
> }
> ```

With this configuration a browser receives the default server’s certificate, i.e. `www.example.com` regardless of the requested server name. This is caused by SSL protocol behaviour. The SSL connection is established before the browser sends an HTTP request and nginx does not know the name of the requested server. Therefore, it may only offer the default server’s certificate.
通过此配置，浏览器将接收**默认服务器的证书**， 例如，无论请求的服务器名称是什么，都会返回 `www.example.com` 。这是由 **SSL 协议行为引起的**。

SSL 连接是在浏览器发送 HTTP 请求之前建立的，而 nginx **并不知道所请求服务器的名称**。因此，它可能**只提供默认服务器的证书**。

The oldest and most robust method to resolve the issue is to assign a separate IP address for every HTTPS server:
解决该问题的最古老、最强大的方法是为每个 HTTPS 服务器**分配一个单独的 IP 地址**：(修改`listen`参数)

> ```nginx
> server {
>     listen          192.168.1.1:443 ssl;
>     server_name     www.example.com;
>     ssl_certificate www.example.com.crt;
>     ...
> }
> 
> server {
>     listen          192.168.1.2:443 ssl;
>     server_name     www.example.org;
>     ssl_certificate www.example.org.crt;
>     ...
> }
> ```





### An SSL certificate with several names具有多个名称的 SSL 证书

There are other ways that allow sharing a single IP address between several HTTPS servers. However, all of them have their drawbacks.

One way is to use a certificate with several names in the SubjectAltName certificate field, for example, `www.example.com` and `www.example.org`. However, the SubjectAltName field length is limited.
还有其他方法可以在多个 HTTPS 服务器之间**共享单个 IP 地址**。 然而，它们**都有各自的缺点**。 

一种方法是使用包含多个名称的 `SubjectAltName` **证书字段**，例如， `www.example.com` 和 `www.example.org` 。但是，SubjectAltName 字段长度受到限制。

Another way is to use a certificate with a wildcard name, for example, `*.example.org`. A wildcard certificate secures all subdomains of the specified domain, but only on one level. This certificate matches `www.example.org`, but does not match `example.org` and `www.sub.example.org`. These two methods can also be combined. A certificate may contain exact and wildcard names in the SubjectAltName field, for example, `example.org` and `*.example.org`.
另一种方法是使用**带有通配符名称的证书**，例如， `*.example.org` 。通配符证书可**保护指定域名的所有子域名**，但仅限于**一级**。此证书与 `www.example.org` 匹配，但不匹配 `example.org` 和 `www.sub.example.org` 。 

这两种方法也可以结合起来。 证书可能在SubjectAltName 字段中包含**精确名称**和**通配符名称** ，例如， `example.org` 和 `*.example.org` 。

It is better to place a certificate file with several names and its private key file at the *http* level of configuration to inherit their single memory copy in all servers:
最好将具有多个名称的**证书文件及其私钥文件**放置在 *http* 级别的配置中，以便在所有服务器中继承它们的单一内存副本：

> ```nginx
> ssl_certificate     common.crt;
> ssl_certificate_key common.key;
> 
> server {
>     listen          443 ssl;
>     server_name     www.example.com;
>     ...
> }
> 
> server {
>     listen          443 ssl;
>     server_name     www.example.org;
>     ...
> }
> ```





### Server Name Indication 服务器名称指示(SNI)

A more generic solution for running several HTTPS servers on a single IP address is [TLS Server Name Indication extension](http://en.wikipedia.org/wiki/Server_Name_Indication) (SNI, RFC 6066), which allows a browser to pass a requested server name during the SSL handshake and, therefore, the server will know which certificate it should use for the connection. SNI is currently [supported](http://en.wikipedia.org/wiki/Server_Name_Indication#Support) by most modern browsers and is a mandatory-to-implement extension in TLSv1.3, though may not be used by some old or special clients.
在单个服务器IP 地址上运行多个 HTTPS 服务器的**更通用的解决方案** 是 [TLS 服务器名称指示扩展 ](http://en.wikipedia.org/wiki/Server_Name_Indication)（SNI，RFC 6066）， 允许浏览器在 SSL 握手期间传递请求的服务器名称 

因此，服务器将知道应该使用哪个证书 用于连接。 SNI 目前 大多数现代浏览器都[支持](http://en.wikipedia.org/wiki/Server_Name_Indication#Support)它，并且是 TLSv1.3 中强制实现的扩展，但某些旧的或特殊的客户端可能不会使用它。

> Only domain names can be passed in SNI, however some browsers may erroneously pass an IP address of the server as its name if a request includes literal IP address. One should not rely on this.
> SNI 中只能传递**域名**，但是如果请求中包含文字 IP 地址，某些浏览器可能会错误地将服务器的 IP 地址作为其名称传递。不应依赖此方法。

#### 支持的版本构建

In order to use SNI in nginx, it must be supported in both the OpenSSL library with which the nginx binary has been built as well as the library to which it is being dynamically linked at run time. OpenSSL supports SNI since 0.9.8f version if it was built with config option “--enable-tlsext”. Since OpenSSL 0.9.8j this option is enabled by default. If nginx was built with SNI support, then nginx will show this when run with the “-V” switch:
为了在 nginx 中使用 SNI，它必须同时支持 nginx 二进制文件所使用的 OpenSSL 库以及运行时动态链接到的库。 OpenSSL 自 0.9.8f 版本起支持 SNI（如果使用配置选项构建） “`--enable-tlsext`”。

 自 OpenSSL 0.9.8j 版本起，此选项默认启用。如果 nginx 构建时支持 SNI，则在使用“-V”开关运行时，nginx 将显示以下内容：

> ```bash
> $ nginx -V
> ...
> TLS SNI support enabled
> ...
> ```

However, if the SNI-enabled nginx is linked dynamically to an OpenSSL library without SNI support, nginx displays the warning:
但是，如果启用 SNI 的 nginx 动态链接到不支持 SNI 的 OpenSSL 库，则 nginx 会显示警告：

> ```
> nginx was built with SNI support, however, now it is linked
> dynamically to an OpenSSL library which has no tlsext support,
> therefore SNI is not available
> ```