[toc]



## abstract

nginx如何处理请求

### Name-based virtual servers 基于名称的虚拟服务器

nginx first decides which *server* should process the request. Let’s start with a simple configuration where all three virtual servers listen on port :80:
nginx 首先决定哪个*服务器*应该处理请求。让我们从一个简单的配置开始，其中三个虚拟服务器都监听端口 :80：

> ```nginx
> server {
>     listen      80;
>     server_name example.org www.example.org;
>     ...
> }
> 
> server {
>     listen      80;
>     server_name example.net www.example.net;
>     ...
> }
> 
> server {
>     listen      80;
>     server_name example.com www.example.com;
>     ...
> }
> ```



In this configuration nginx tests only the request’s header field “Host” to determine which server the request should be routed to. If its value does not match any server name, or the request does not contain this header field at all, then nginx will route the request to the default server for this port. In the configuration above, the default server is the first one — which is nginx’s standard default behaviour. It can also be set explicitly which server should be default, with the `default_server` parameter in the [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive:
在此配置中，nginx **仅测试请求的标头字段“Host”**来确定应将请求路由到哪个服务器。如果其值与任何服务器名称都不匹配，或者请求根本不包含此标头字段，则 nginx 会将请求路由到此端口的默认服务器。

在上述配置中，默认服务器是第一个服务器——这是 nginx 的标准默认行为。也可以使用 [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) 指令中的 `default_server` 参数明确设置哪个服务器应为默认服务器：

> ```
> server {
>     listen      80 default_server;
>     server_name example.net www.example.net;
>     ...
> }
> ```



> The `default_server` parameter has been available since version 0.8.21. In earlier versions the `default` parameter should be used instead.
> `default_server` 参数自 0.8.21 版本起可用。在早期版本中，应使用 `default` 参数。

Note that the default server is a property of the listen port and not of the server name. More about this later.
请注意，**默认服务器是监听端口的属性**(listen)，而不是**服务器名称**的属性(server_name)。稍后会详细介绍。



How to prevent processing requests with undefined server names
如何防止处理未定义服务器名称的请求

If requests without the “Host” header field should not be allowed, a server that just drops the requests can be defined:
如果不允许没有“Host”标头字段的请求，则可以定义一个**仅丢弃请求的服务器**：

> ```nginx
> server {
>     listen      80;
>     server_name "";
>     return      444;
> }
> ```

Here, the server name is set to an empty string that will match requests without the “Host” header field, and a special nginx’s non-standard code 444 is returned that closes the connection.
这里，服务器名称设置为一个空字符串，将匹配没有“Host”头字段的请求，并返回一个特殊的 nginx 非标准代码 444 来关闭连接。

> Since version 0.8.48, this is the default setting for the server name, so the `server_name ""` can be omitted. In earlier versions, the machine’s *hostname* was used as a default server name.
> 从 0.8.48 版本开始，这是服务器名称的默认设置，因此可以省略 `server_name ""` 。在早期版本中，计算机的*主机名*被用作默认服务器名称。



### Mixed name-based and IP-based virtual servers 混合基于名称和基于 IP 的虚拟服务器

Let’s look at a more complex configuration where some virtual servers listen on different addresses:
让我们看一个更复杂的配置，其中一些虚拟服务器**监听不同的地址**：

> ```nginx
> server {
>     listen      192.168.1.1:80;
>     server_name example.org www.example.org;
>     ...
> }
> 
> server {
>     listen      192.168.1.1:80;
>     server_name example.net www.example.net;
>     ...
> }
> 
> server {
>     listen      192.168.1.2:80;
>     server_name example.com www.example.com;
>     ...
> }
> ```

In this configuration, nginx first tests the IP address and port of the request against the [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directives of the [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) blocks. It then tests the “Host” header field of the request against the [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) entries of the [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) blocks that matched the IP address and port. If the server name is not found, the request will be processed by the default server. For example, a request for `www.example.com` received on the 192.168.1.1:80 port will be handled by the default server of the 

在此配置中，nginx 首先根据服务器块的 listen 指令测试请求的 IP 地址和端口。然后，它会根据与 IP 地址和端口匹配的服务器块的 server_name 条目测试请求的“Host”标头字段。

如果未找到服务器名称，则该请求将由默认服务器处理。例如，在 192.168.1.1:80 端口上收到的对 www.example.com 的请求将由 192.168.1.1:80 端口的默认服务器（即第一个服务器）处理，因为该端口没有定义 www.example.com的server_name

As already stated, a default server is a property of the listen port, and different default servers may be defined for different ports:
前面已经说过，默认服务器是监听端口的一个属性，可以**为不同的[端口]定义不同的默认服务器**：

> ```nginx
> server {
>     listen      192.168.1.1:80;
>     server_name example.org www.example.org;
>     ...
> }
> 
> server {
>     listen      192.168.1.1:80 default_server;
>     server_name example.net www.example.net;
>     ...
> }
> 
> server {
>     listen      192.168.1.2:80 default_server;
>     server_name example.com www.example.com;
>     ...
> }
> ```

### A simple PHP site configuration简单的 PHP 站点配置

Now let’s look at how nginx chooses a *location* to process a request for a typical, simple PHP site:
现在让我们看看 nginx 如何选择一个*位置*来处理一个典型的、简单的 PHP 站点的请求：

> ```nginx
> server {
>     listen      80;
>     server_name example.org www.example.org;
>     root        /data/www;
> 
>     location / {
>         index   index.html index.php;
>     }
> 
>     location ~* \.(gif|jpg|png)$ {
>         expires 30d;
>     }
> 
>     location ~ \.php$ {
>         fastcgi_pass  localhost:9000;
>         fastcgi_param SCRIPT_FILENAME
>                       $document_root$fastcgi_script_name;
>         include       fastcgi_params;
>     }
> }
> ```



nginx first searches for the most specific prefix location given by literal strings regardless of the listed order. In the configuration above the only prefix location is “`/`” and since it matches any request it will be used as a last resort. Then nginx checks locations given by regular expression in the order listed in the configuration file. The first matching expression stops the search and nginx will use this location. If no regular expression matches a request, then nginx uses the most specific prefix location found earlier.
nginx 首先搜索由**文字字符串给出的最具体的前缀位置，而不考虑列出的顺序**。在上面的配置中，唯一的前缀位置是“ `/` ”，由于它匹配任何请求，因此将作为最后的手段。

然后，nginx 按照配置文件中**列出的顺序**检查由**正则表达式**给出的位置。一旦找到第一个匹配的表达式,**搜索停止**，nginx 将使用此位置。

如果没有正则表达式匹配请求，则 nginx 将使用先前找到的**最具体的前缀位置**。

Note that locations of all types test only a URI part of request line without arguments. This is done because arguments in the query string may be given in several ways, for example:
请注意，所有类型的位置信息仅测试请求行中**不带参数的 URI 部分**。这样做是因为查询字符串中的参数可能以多种方式提供，例如：

> ```
> /index.php?user=john&page=1
> /index.php?page=1&user=john
> ```

Besides, anyone may request anything in the query string:
此外，任何人都可以在查询字符串中请求任何内容：

> ```
> /index.php?page=1&something+else&user=john
> ```



Now let’s look at how requests would be processed in the configuration above:
现在让我们看看上面的配置中如何处理请求：

- A request “`/logo.gif`” is matched by the prefix location “`/`” first and then by the regular expression “`\.(gif|jpg|png)$`”, therefore, it is handled by the latter location. Using the directive “`root /data/www`” the request is mapped to the file `/data/www/logo.gif`, and the file is sent to the client.
  请求“ `/logo.gif` ”首先与前缀位置“ `/` ”匹配，然后与正则表达式“ `\.(gif|jpg|png)$` ”匹配，因此由后者处理。使用指令“ `root /data/www` ”将请求映射到文件 `/data/www/logo.gif` ，并将该文件发送到客户端。
- A request “`/index.php`” is also matched by the prefix location “`/`” first and then by the regular expression “`\.(php)$`”. Therefore, it is handled by the latter location and the request is passed to a FastCGI server listening on localhost:9000. The [fastcgi_param](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_param) directive sets the FastCGI parameter `SCRIPT_FILENAME` to “`/data/www/index.php`”, and the FastCGI server executes the file. The variable `$document_root` is equal to the value of the [root](https://nginx.org/en/docs/http/ngx_http_core_module.html#root) directive and the variable `$fastcgi_script_name` is equal to the request URI, i.e. “`/index.php`”.
  请求“ `/index.php` ”也首先与前缀位置“ `/` ”匹配，然后与正则表达式“ `\.(php)$` ”匹配。 因此，由后者处理 并将请求传递到监听 localhost:9000 的 FastCGI 服务器。 这 [fastcgi_param](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_param) 指令设置 FastCGI 参数 `SCRIPT_FILENAME` 为“ `/data/www/index.php` ”，FastCGI 服务器执行该文件。变量 `$document_root` 等于 的价值 [root](https://nginx.org/en/docs/http/ngx_http_core_module.html#root) 指令，变量 `$fastcgi_script_name` 等于请求 URI，即“ `/index.php` ”。
- A request “`/about.html`” is matched by the prefix location “`/`” only, therefore, it is handled in this location. Using the directive “`root /data/www`” the request is mapped to the file `/data/www/about.html`, and the file is sent to the client.
  请求“ `/about.html` ”仅与前缀位置“ `/` ”匹配，因此会在此位置进行处理。使用指令“ `root /data/www` ”将请求映射到文件 `/data/www/about.html` ，并将该文件发送到客户端。
- Handling a request “`/`” is more complex. It is matched by the prefix location “`/`” only, therefore, it is handled by this location. Then the [index](https://nginx.org/en/docs/http/ngx_http_index_module.html#index) directive tests for the existence of index files according to its parameters and the “`root /data/www`” directive. If the file `/data/www/index.html` does not exist, and the file `/data/www/index.php` exists, then the directive does an internal redirect to “`/index.php`”, and nginx searches the locations again as if the request had been sent by a client. As we saw before, the redirected request will eventually be handled by the FastCGI server.
  处理请求“ `/` ”更加复杂。它仅与前缀 location “ `/` ” 匹配， 因此，由该位置处理。 然后 [index](https://nginx.org/en/docs/http/ngx_http_index_module.html#index) 指令会根据其参数和“ `root /data/www` ”指令来测试索引文件是否存在。如果文件 `/data/www/index.html` 不存在，而文件 `/data/www/index.php` 存在，则该指令会执行内部重定向到“ `/index.php` ”，然后 nginx 会再次搜索这些位置，就像该请求是由客户端发送的一样。正如我们之前所见，重定向的请求最终将由 FastCGI 服务器处理。