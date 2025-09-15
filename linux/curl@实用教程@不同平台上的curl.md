[toc]

------

## curl 简介

官网链接:[curl](https://curl.se/)

`curl`（Client URL）是一个功能强大的命令行工具，用于发送 HTTP/HTTPS、FTP 等协议的请求，可以下载文件、与 API 交互、上传数据等。
 Windows 10/11 自带 `curl.exe`，Linux/macOS 也通常预装。

在 PowerShell 中要注意：

- `curl` 在 PowerShell 里是 `Invoke-WebRequest` 的别名，如果要用真正的 curl，请输入 `curl.exe`
- 参数区分大小写（`-O` ≠ `-o`）

## 获取curl

通常linux系统上的curl功能更比较完整

而windows平台有的版本(尤其是系统自带的)功能可能不完整,主要体现在支持的协议较少,比如

```
PS> C:\Windows\System32\curl.exe -V
curl 8.7.1 (Windows) libcurl/8.7.1 Schannel zlib/1.3 WinIDN
Release-Date: 2024-03-27
Protocols: dict file ftp ftps http https imap imaps ipfs ipns mqtt pop3 pop3s smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS HSTS HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM SPNEGO SSL SSPI threadsafe Unicode UnixSockets
```

> 不支持sftp,scp等协议

较新版本获取完整的协议支持

```bash
PS> curl.exe -V
curl 8.16.0 (x86_64-w64-mingw32) libcurl/8.16.0 LibreSSL/4.1.0 zlib/1.3.1.zlib-ng brotli/1.1.0 zstd/1.5.7 WinIDN libpsl/0.21.5 libssh2/1.11.1 nghttp2/1.67.0 ngtcp2/1.15.1 nghttp3/1.11.0
Release-Date: 2025-09-10
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns ldap ldaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp ws wss
Features: alt-svc AsynchDNS brotli CAcert HSTS HTTP2 HTTP3 HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM PSL SPNEGO SSL SSLS-EXPORT SSPI threadsafe UnixSockets zstd
```



#### 官网获取最新版本

[curl - Download](https://curl.se/download.html)

#### 其他方案

windows:可以使用scoop获取较新版本

linux:可以通过brew(linuxbrew)等工具获取较新版本

---

### 在线文档和教程

[curl - Tool Documentation](https://curl.se/docs/tooldocs.html)

The main tool to know and learn here is of course curl. Read the full reference [man page](https://curl.se/docs/manpage.html), read the [tutorial](https://curl.se/docs/tutorial.html) or learn how to do [HTTP scripting](https://curl.se/docs/httpscripting.html) with curl.
这里需要了解和学习的主要工具当然是 curl。阅读完整的参考[手册页 ](https://curl.se/docs/manpage.html)、阅读[教程 ](https://curl.se/docs/tutorial.html)，或者学习如何使用 curl 进行 [HTTP 脚本编写 ](https://curl.se/docs/httpscripting.html)。

[When were each command line option added](https://curl.se/docs/optionswhen.html) to curl.
[每个命令行选项是什么时候添加](https://curl.se/docs/optionswhen.html)到 curl 的。

See how [curl compares to alternative tools](https://curl.se/docs/comparison-table.html).
看看 [curl 与其他工具相比](https://curl.se/docs/comparison-table.html)如何。

[mk-ca-bundle](https://curl.se/docs/mk-ca-bundle.html) is a separate tool, used to get a CA bundle.
[mk-ca-bundle](https://curl.se/docs/mk-ca-bundle.html) 是一个单独的工具，用于获取 CA 包。

### 用法

```bash
PS> curl --help
Usage: curl [options...] <url>
 -d, --data <data>           HTTP POST data
 -f, --fail                  Fail fast with no output on HTTP errors
 -h, --help <category>       Get help for commands
 -i, --include               Include response headers in output
 -o, --output <file>         Write to file instead of stdout
 -O, --remote-name           Write output to file named as remote file
 -s, --silent                Silent mode
 -T, --upload-file <file>    Transfer local FILE to destination
 -u, --user <user:password>  Server user and password
 -A, --user-agent <name>     Send User-Agent <name> to server
 -v, --verbose               Make the operation more talkative
 -V, --version               Show version number and quit

This is not the full help, this menu is stripped into categories.
Use "--help category" to get an overview of all categories.
For all options use the manual or "--help all".
```

从基本用法可以看出,curl主要将选项放在`url`之前,但是也允许部分参数放在url之后,有的用法也可以交替出现选项和url

------

### 基本下载

#### 单文件下载

```powershell
curl.exe -O https://example.com/file.zip
```

- `-O`（大写 O）：使用 URL 的文件名保存
- 下载后文件名就是 `file.zip`

#### 指定保存文件名

```powershell
curl.exe -o myfile.zip https://example.com/file.zip
```

- `-o`（小写 o）：自定义保存路径和文件名

------

#### 防 403 Forbidden 技巧

很多网站限制“非浏览器访问”，解决办法就是伪装成浏览器：



写在同一行(不同shell基本都兼容)

```powershell
curl.exe -L -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0 Safari/537.36" -H "Referer: https://esd.equipment/" "https://esd.equipment/media/catalog/product/c/q/cq2_12-100-dmz_301.jpg" -o "cq2_12-100-dmz_301.jpg"

```

- `-L`：跟随 301/302 重定向
- `-H`：添加 HTTP 请求头
- 常用头：
  - `User-Agent`：伪装成浏览器
  - `Referer`：防盗链伪造来源
  - `Cookie`：带上登录信息

## 长命令行换行排版

换行书写提高可读性(但是不同shell中写法略有不同,主要是换行标记)

#### bash

bash中(最典型),其他大多linux shell也支持,换行标记使用`\`

```bash
curl -L \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0 Safari/537.36" \
  -H "Referer: https://esd.equipment/" \
  "https://esd.equipment/media/catalog/product/c/q/cq2_12-100-dmz_301.jpg" \
  -o cq2_12-100-dmz_301.jpg
```

#### powershell

powershell中使用curl.exe,换行标记使用(`)号

```powershell
curl.exe -L `
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0 Safari/537.36" `
  -H "Referer: https://example.com/" `
  "https://example.com/image.jpg" `
  -o "image.jpg"
```

#### cmd

cmd中写法(换行标记使用`^`)

```cmd
curl -L ^
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0 Safari/537.36" ^
  -H "Referer: https://esd.equipment/" ^
  "https://esd.equipment/media/catalog/product/c/q/cq2_12-100-dmz_301.jpg" ^
  -o cq2_12-100-dmz_301.jpg

```



------

## 基本应用

### 文件传输

以sftp协议为例

> ### SFTP / SCP
>
> This is similar to FTP, but you can use the `--key` option to specify a private key to use instead of a password. Note that the private key may itself be protected by a password that is unrelated to the login password of the remote system; this password is specified using the `--pass` option. Typically, curl automatically extracts the public key from the private key file, but in cases where curl does not have the proper library support, a matching public key file must be specified using the `--pubkey` option.
> 这和 FTP 类似，但你可以使用 `--key` 选项来指定一个私钥来代替密码。请注意，私钥本身可能由一个与远程系统登录密码无关的密码保护；这个密码是使用 `--pass` 选项指定的。通常，curl 会自动从私钥文件中提取公钥，但在 curl 没有适当的库支持的情况下，必须使用 `--pubkey` 选项指定匹配的公钥文件。

例如使用curl查看服务器上的某个文件(通常用于文本文件),如果要下载使用`-O,-o`中的一个来保存为文件

```powershell
curl -u root sftp://"$env:DF_SERVER2":22022/www/wwwroot/functions.php 
```

执行后这需要输入密码

curl也支持指定ssh私钥文件来代替密码验证

```powershell
curl -u root: --key C:\Users\Administrator\.ssh\id_ed25519  sftp://"$host":$port/www/wwwroot/functions.php
```

此外,如果私钥带有额外的密钥保护,则使用`--pass private_key_password`方式来指定私钥的密码

当然,可以指定`-O`保存为文件,或者`-o`指定文件名(路径)保存

### 批量下载

假设 `urls.txt` 里有多行 URL：

```
https://site.com/file1.jpg
https://site.com/file2.jpg
https://site.com/file3.jpg
```

PowerShell 一行下载：

```powershell
Get-Content urls.txt | ForEach-Object {
    curl.exe -L -O $_
}
```

批量加防 (可以简单尝试绕过基于UA防护的403)：

```powershell
Get-Content urls.txt | ForEach-Object {
    curl.exe -L `
      -H "User-Agent: Mozilla/5.0" `
      -H "Referer: https://site.com/" `
      -O $_
}
```

------

### 下载并断点续传

```powershell
curl.exe -C - -O https://example.com/largefile.zip
```

- `-C -`：从已下载部分续传，适合大文件和断网续传

------

### 限速下载（节省带宽）

```powershell
curl.exe --limit-rate 500k -O https://example.com/file.zip
```

- 限速 500 KB/s

------

### 上传文件（HTTP POST）

```powershell
curl.exe -F "file=@C:\path\to\myfile.txt" https://example.com/upload
```

- `-F`：表单方式上传文件

------

### API 调用（JSON 请求）

```powershell
curl.exe -X POST `
  -H "Content-Type: application/json" `
  -d '{"name": "Tom", "age": 30}' `
  https://api.example.com/users
```

- `-X`：指定请求方法（GET、POST、PUT、DELETE）
- `-d`：请求体数据（POST/PUT）

------

### 保存 HTTP 响应头

```powershell
curl.exe -D headers.txt -o page.html https://example.com
```

- `-D`：保存响应头到文件
- `-o`：保存响应内容

------

### 显示请求过程（调试）

```powershell
curl.exe -v https://example.com
```

- `-v`：verbose 模式，显示请求和响应详情
- `-i`：在输出中包含 HTTP 响应头

------

### 常用组合示例

**下载图片并防 403：**

```powershell
curl.exe -L -H "User-Agent: Mozilla/5.0" -H "Referer: https://site.com/" -O https://site.com/image.jpg
```

**批量下载并保存到指定文件夹：**

```powershell
Get-Content urls.txt | ForEach-Object {
    curl.exe -L -O $_ -o "C:\Downloads\$(Split-Path $_ -Leaf)"
}
```

**下载大文件且可续传：**

```powershell
curl.exe -L -C - -O https://site.com/largefile.iso
```

------

