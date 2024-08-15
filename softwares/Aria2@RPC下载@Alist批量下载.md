[toc]

## abstract

Aria2 是一款轻量级、多协议、多源的命令行下载工具，其强大的功能使得它在开发者和高级用户中备受推崇。

本文探讨 Aria2 的远程控制功能——RPC（Remote Procedure Call），并演示如何使用它来远程管理下载任务。



## Aria2 RPC 概述

### RPC 的主要功能

- **添加、暂停、删除下载任务**：可以通过 RPC 动态管理任务。
- **获取任务状态**：可以实时查询任务的下载进度、速度和状态。
- **修改下载选项**：支持在下载过程中修改下载参数，比如最大连接数、速度限制等。
- **事件通知**：可以通过 RPC 接口获取下载完成或出错的通知。

### 在线文档

- [Aria2 中文文档 — aria2 1.37.0 documentation](https://aria2.document.top/zh/)
- [rpc-interface|aria2c(1) — aria2 1.37.0 documentation](https://aria2.github.io/manual/en/html/aria2c.html#rpc-interface)

Aria2 提供了一个远程控制接口（RPC），可以通过 JSON-RPC 协议对 Aria2 进行操作。这意味着你可以通过网络，从远程服务器或本地脚本控制 Aria2 的下载任务。

### aria2的配置文件与启动选项

- 默认情况下,aria2会检查`$home/.aria2/aria2.conf`文件(aria2的配置文件)

  - 如果存在该文件,那么启动时会根据该文件内的配置项目启动或者设置相应的功能服务

  - 如果找不到该文件,并且没有指定其他位置的存在的配置文件,那么aria2 会认为你只是想要使用最基本下载功能,如果你不提供下载链接(源),那么会提示你

    ```cmd
    PS> aria2c
    Specify at least one URL.
    Usage: aria2c [OPTIONS] [URI | MAGNET | TORRENT_FILE | METALINK_FILE]...
    See 'aria2c -h'.
    ```

  - 你可以使用`--conf-path`选项来临时指定aria2的功能配置文件路径

- `--conf-path=<PATH>`[¶](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-conf-path)

  Change the configuration file path to PATH. Default: `$HOME/.aria2/aria2.conf` if present, otherwise `$XDG_CONFIG_HOME/aria2/aria2.conf`

### 使用配置文件设置aria2 rpc功能

- 虽然配置文件不是必须的,但是使用配置文件可以让aria2的服务调用更加优雅和方便
- 例如,我们可以在aria2的配置文件中设置是否启用rpc功能,以及是否使用密钥保护

### Aria2关于rpc的离线文档

- 在命令行中执行`aria2c -h#rpc`获取文档

```cmd
PS C:\Users\cxxu\Desktop> aria2c -h#rpc
Usage: aria2c [OPTIONS] [URI | MAGNET | TORRENT_FILE | METALINK_FILE]...
Printing options tagged with '#rpc'.
See 'aria2c -h#help' to know all available tags.
Options:
 --enable-rpc[=true|false]    Enable JSON-RPC/XML-RPC server.
                              It is strongly recommended to set secret
                              authorization token using --rpc-secret option.
                              See also --rpc-listen-port option.

                              Possible Values: true, false
                              Default: false
                              Tags: #rpc

 --rpc-listen-port=PORT       Specify a port number for JSON-RPC/XML-RPC server
                              to listen to.

                              Possible Values: 1024-65535
                              Default: 6800
                              Tags: #rpc



 --rpc-max-request-size=SIZE  Set max size of JSON-RPC/XML-RPC request. If aria2
                              detects the request is more than SIZE bytes, it
                              drops connection.

                              Possible Values: 0-*
                              Default: 2M
                              Tags: #rpc

 --rpc-listen-all[=true|false] Listen incoming JSON-RPC/XML-RPC requests on all
                              network interfaces. If false is given, listen only
                              on local loopback interface.

                              Possible Values: true, false
                              Default: false
                              Tags: #rpc

...

 --rpc-secret=TOKEN           Set RPC secret authorization token.

                              Tags: #rpc
...

Refer to man page for more information.
```



## Aria2 RPC 重要和常用选项

 

### 1. `enable-rpc`
- **作用**: 启用或禁用 Aria2 的 RPC 功能。
- **默认值**: `false`
- **配置**: `enable-rpc=true`
- **说明**: 这是启动 RPC 的关键选项。如果不启用 RPC，所有其他与 RPC 相关的配置都会被忽略。

### 2. `rpc-listen-port`
- **作用**: 指定 RPC 服务监听的端口号。
- **默认值**: `6800`
- **配置**: `rpc-listen-port=6800`
- **说明**: 指定 Aria2 的 RPC 服务端口，客户端（如 Web UI、脚本等）通过此端口与 Aria2 进行通信。如果该端口被占用，可以更改为其他端口号。

### 3. `rpc-secret`
- **作用**: 设置 RPC 连接的授权令牌（token）。
- **默认值**: 无（不设置时不需要认证）
- **配置**: `rpc-secret=your_secret_token`
- **说明**: 为了提高安全性，建议设置一个 RPC 授权令牌(用户自行定义,可以设得很简单,但是对于重要资料,建议设得复杂)。客户端在发起 RPC 请求时，需要使用此令牌进行认证。

### 4. `rpc-listen-all`
- **作用**: 是否允许 RPC 在所有网络接口上监听。
- **默认值**: `false`（仅在本地回环地址上监听）
- **配置**: `rpc-listen-all=true`
- **说明**: 默认情况下，RPC 只在本地监听（即只能从本机访问）。如果你希望从其他设备访问 Aria2 的 RPC 服务，则需要启用此选项。

### 5. `rpc-allow-origin-all`
- **作用**: 是否允许所有来源的跨域请求（CORS）。
- **默认值**: `false`
- **配置**: `rpc-allow-origin-all=true`
- **说明**: 如果需要从不同的域名或 IP 地址访问 Aria2（如从 Web UI 管理界面），可以启用此选项以允许跨域请求。

### 6. `rpc-max-request-size`
- **作用**: 设置 RPC 请求的最大允许大小（单位：字节）。
- **默认值**: `2097152`（2MB）
- **配置**: `rpc-max-request-size=2097152`
- **说明**: 此选项用于限制单个 RPC 请求的大小。默认值通常够用，但在处理大数据量或复杂请求时可以适当增加。

### 7. `rpc-save-upload-metadata`
- **作用**: 控制是否保存上传的种子文件元数据。
- **默认值**: `true`
- **配置**: `rpc-save-upload-metadata=true`
- **说明**: 当你通过 RPC 上传种子文件时，Aria2 会保存这些元数据。启用此选项可以防止数据丢失，但会占用一些存储空间。

### 总结👺

Aria2 RPC 是一个非常强大和灵活的工具，通过这些配置选项，你可以定制化 RPC 的行为，以满足各种场景的需求。

- **核心配置**: `enable-rpc`、`rpc-listen-port` 是必不可少的，它们决定了 RPC 是否可用以及如何访问。
- **安全配置**: `rpc-secret` 提供了简单有效的认证机制，确保只有授权用户可以访问 RPC 服务。
- **访问配置**: `rpc-listen-all` 和 `rpc-allow-origin-all` 则控制了 RPC 的访问范围和跨域请求的处理，非常适合在多设备环境中使用。
- **性能配置**: `rpc-max-request-size` 和 `rpc-save-upload-metadata` 则影响 RPC 的性能和数据处理，适合根据具体需求进行调整。

### aria2 rpc 安全性配置选项

非常好，我很高兴为您详细解释aria2的`--rpc-secret`选项的使用。这个选项对于提高aria2 RPC服务的安全性非常重要。

#### aria2 --rpc-secret选项介绍

`--rpc-secret`选项用于设置RPC服务的密钥，为aria2的RPC接口添加一层安全保护。当设置了这个选项后，客户端在连接到aria2 RPC服务时需要提供正确的密钥才能进行操作。

#### 如何使用--rpc-secret

1. 在配置文件中设置

   在aria2的配置文件（通常是`aria2.conf`）中添加以下行：

   ```
   rpc-secret=YOUR_SECRET_KEY
   ```

   将`YOUR_SECRET_KEY`替换为你想使用的密钥。

2. 通过命令行参数设置

   如果你是通过命令行启动aria2，可以这样设置：

   ```
   aria2c --enable-rpc --rpc-listen-all --rpc-secret=YOUR_SECRET_KEY
   ```

### 安全性建议

1. 选择强密钥：使用长且复杂的密钥，包含大小写字母、数字和特殊字符。

2. 定期更换：定期更换你的RPC密钥可以提高安全性。

3. 使用HTTPS：如果可能，考虑配置aria2使用HTTPS来加密RPC通信。

4. 限制IP：如果可能，限制只有特定IP可以访问RPC服务。



## 启用和配置 Aria2 RPC👺

在使用 RPC 功能之前，你需要确保 Aria2 的 RPC 已正确配置。

###  配置文件设置
首先，你需要修改 Aria2 的配置文件（通常是 `aria2.conf`），添加以下内容来启用 RPC：

```bash
#允许rpc
enable-rpc=true
#允许非外部访问
rpc-listen-all=true
#RPC端口, 仅当默认端口被占用时修改
rpc-listen-port=6800
# 设置 RPC 授权令牌（提高安全性）
rpc-secret=1

# 允许跨域请求（可选，适用于 Web 前端）
rpc-allow-origin-all=true


#最大同时下载数(任务数), 路由建议值: 3
max-concurrent-downloads=32
#断点续传
continue=true
#同服务器连接数
max-connection-per-server=16
#最小文件分片大小, 下载线程数上限取决于能分出多少片, 对于小文件重要
min-split-size=10M
#单文件最大线程数
#split=64
#下载速度限制
max-overall-download-limit=0
#单文件速度限制
max-download-limit=0
#上传速度限制
max-overall-upload-limit=0
#单文件速度限制
max-upload-limit=0

#文件保存路径, 默认为当前启动位置
#dir="./"
#使用代理
# all-proxy=localhost:1080

```

###  启动 Aria2
配置完成后，可以通过命令行启动 Aria2：

```bash
aria2c --conf-path=/path/to/aria2.conf
```

例如`aria2c --conf-path=C:\repos\configs\aria2.conf`

这样，Aria2 的 RPC 功能就启用了，监听的端口为 6800。

```cmd
PS C:\Users\cxxu\Desktop> aria2c --conf-path=C:\repos\configs\aria2.conf

08/15 19:51:05 [NOTICE] IPv4 RPC: listening on TCP port 6800

08/15 19:51:05 [NOTICE] IPv6 RPC: listening on TCP port 6800

08/15 20:17:06 [NOTICE] Download complete: C:/Users/cxxu/Desktop/Cpp/StarsPrinter.exe

08/15 20:17:06 [NOTICE] Download complete: C:/Users/cxxu/Desktop/Cpp/TheOfYear.c

08/15 20:17:06 [NOTICE] Download complete: C:/Users/cxxu/Desktop/Cpp/a.exe

08/15 20:17:06 [NOTICE] Download complete: C:/Users/cxxu/Desktop/Cpp/anni.cpp
```

- 上述例子中我利用Alist调用aria2 rpc下载了某个文件夹(通过勾选文件夹,发送到aria2下载)
- 下载的每个文件都被记录和输出在了终端
- 如果需要后台运行,和alist自启脚本一起设置后台启动或开机后台自启

## 使用 Aria2 RPC

使用 Aria2 RPC 控制 Aria2 需要发送 HTTP POST 请求，其中请求内容为 JSON 格式的数据。你可以使用 `curl` 或编程语言的 HTTP 客户端来发送请求。

### aria2 rpc客户端:使用设置了rpc-secret的aria2

#### 使用在线web UI👺

打开以下网页,填写本地aria2 rpc服务地址和密钥(如果有设置的话),可以通过UI来管理本地aria2下载任务

- [ Aria2 WebUI (ziahamza.github.io)](https://ziahamza.github.io/webui-aria2/)

- [  AriaNg (mayswind.net)](http://ariang.mayswind.net/latest/#!/settings/ariang)

在RPC设置中，你需要在密钥（Secret）字段填入你设置的密钥。

#### 使用API直接连接

如果你是通过编程方式直接调用aria2的RPC API，你需要在每个JSON-RPC请求中添加`token:`前缀和你的密钥。例如：

```json
{
  "jsonrpc":"2.0",
  "method":"aria2.addUri",
  "id":"qwer",
  "params":["token:YOUR_SECRET_KEY",["http://example.com/file.zip"]]
}
```

#### 使用aria2客户端库

很多编程语言的aria2客户端库都支持设置RPC密钥。你通常需要在创建客户端时提供这个密钥。

## Alist配置aria2 rpc实现批量下载或文件夹下载

- 知道aria2 rpc是怎么回事,我们就可以用它来配置alist的批量下载或文件夹下载

  - 假设有两台设备S,C(分别是服务器server以及客户端Client)
  - 试验之前,确保你的客户端上下载器aria2 rpc服务启动成功并处于运行状态(假设aria2 rpc地址`http://localhost:6800/jsonrpc`,这是默认地址);密钥如果你设置了,就需要填写，如果没有设置,那么不需要填写
  - 在设备C上打开了S的Alist链接,想要下载上面的某些个文件夹
    - 这时候可以先在网页前端填写上述rpc地址(如果有密钥需要一并填写),填写位置可以找找右下角的齿轮,展开它,点击到设置填写
    - 选择启用复选框,这样方便选取需要下载的文件后文件夹
  - 然后选择好下载对象后,网页下方中间位置有下载按钮,点击其中的发送到Aria2选项,顺利的话会提示你发送成功,可以查看下载日志,或者你配置在aria2 配置文件中指定的保存目录(没有指定的话,则默认下载到启动aria2 rpc的工作目录下)

- 相关文档

  - alist网页中的功能布局和按钮:[侧边栏|设置 | AList文档 (nn.ci)](https://alist.nn.ci/zh/config/side.html)
  - [离线下载|其他设置 | AList文档 (nn.ci)](https://alist.nn.ci/zh/config/other.html)

  - [Alist中的Aria2的应用|为什么 | AList文档 (nn.ci)](https://alist.nn.ci/zh/faq/why.html#两个aria2有什么不同)

- 虽然批量下载的问题解决了,但是这要求客户端上安装了aria2(或者将来其他支持的软件),并且启动了aria2 rpc服务,便捷性还是有所欠缺(不如挂webdav来的直接)

## 命令行客户端(TODO)

### 添加下载任务

下面的示例展示了如何通过 RPC 添加一个下载任务：

```bash
curl -X POST -H "Content-Type: application/json" -d '{
    "jsonrpc": "2.0",
    "method": "aria2.addUri",
    "id": "qwer",
    "params": [
        "token:your_secret_token",
        ["http://example.com/file.zip"]
    ]
}' http://localhost:6800/jsonrpc
```

#### 解释：
- **method**：`aria2.addUri` 表示添加下载任务的操作。
- **params**：第一个参数为 `token:your_secret_token`（RPC 授权令牌），第二个参数是下载链接的数组。
- **id**：可选，用于标识请求，可以是任意字符串。

### 暂停下载任务

要暂停一个正在下载的任务，可以使用以下 RPC 请求：

```bash
curl -X POST -H "Content-Type: application/json" -d '{
    "jsonrpc": "2.0",
    "method": "aria2.pause",
    "id": "qwer",
    "params": [
        "token:your_secret_token",
        "task_gid"
    ]
}' http://localhost:6800/jsonrpc
```

其中 `task_gid` 是任务的全局唯一标识符，可以从添加任务的返回结果或任务查询中获取。

### 查询任务状态

你可以通过以下请求查询当前正在进行的所有任务：

```bash
curl -X POST -H "Content-Type: application/json" -d '{
    "jsonrpc": "2.0",
    "method": "aria2.tellActive",
    "id": "qwer",
    "params": [
        "token:your_secret_token"
    ]
}' http://localhost:6800/jsonrpc
```

返回结果将包含所有活跃任务的详细信息，包括下载速度、已下载大小、剩余时间等。

