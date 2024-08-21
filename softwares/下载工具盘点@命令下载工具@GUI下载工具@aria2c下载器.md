[toc]





# 下载工具👺

## GUI工具

### Motrix

[agalwood/Motrix: A full-featured download manager. (github.com)](https://github.com/agalwood/Motrix?tab=readme-ov-file)

这是一个热门开源跨平台的下载工具,提供了GUI,易于使用,支持大多数协议

Motrix本身是一个`aria2`命令行下载工具的一个皮肤,使得aria2更易于非专业人士使用,并且内置了Tracker服务器,因此下载Bt磁力链接会比直接用aria2方便一些;对于配置多线程下载和代理等也会更加友好

Motrix使用的开发技术(Technology Stack)和组件

- Electron
- Vue + VueX + Element
- Aria2

### IDM

- [Internet Download Manager is a powerful download accelerator](https://www.internetdownloadmanager.com/)
- 这个下载器不跨平台也不免费,但是对于常用的下载协议链接有很好的下载效果,因此用的人很多,网络上有很多学习版的可以使用,不支持BT,磁力下载,但是因为其在最常用的情形下有很好的表现,仍然值得推荐
- 还有许多类似的工具,XDM,FDM,NDM等,还是IDM下载最快(但是交互不一定是IDM最好)

### gopeed

- 这个下载器的特点是全平台(包括移动端),利用go协程进行下载,不仅支持GUI,也有命令行可以用(需要下载go,所以没有那么轻量,而且 go install 直接下载东西并不容易,会占用大量磁盘空间,除非您有多个项目使用go,否则不是那么值得使用,GUI可以考虑)
  - [Gopeed: Gopeed 是一款由 Golang+Flutter 开发的高速下载器，支持（HTTP、BitTorrent、Magnet）协议下载，并且支持全平台使用， 目前支持的平台包括： W (gitee.com)](https://gitee.com/mirrors/Gopeed)

- 相关链接(下载来源是github,可以使用镜像加速链接后下载)
  - [Gopeed - A modern download manager](https://gopeed.com/)
  - [GopeedLab/gopeed: A modern download manager that supports all platforms. Built with Golang and Flutter. (github.com)](https://github.com/GopeedLab/gopeed)

## 命令行

- 在命令行环境下，有许多高效且功能丰富的下载工具被广泛使用，尤其在Linux和类UNIX系统中。
- 在windows上有类似的移植工具,比如busybox

### 流行的命令行下载工具

1. **wget**
   - **简介**: `wget` 是一个非常普及的命令行下载工具，它支持HTTP、HTTPS和FTP协议。使用它可以轻松下载互联网上的文件或整个网站。`wget` 支持断点续传、限速、时间戳比较以避免重新下载未修改的文件等功能。
2. **curl**
   - **简介**: `curl` 是另一个广为人知的命令行工具，它不仅能够下载文件，还能上传数据（包括FTP上传），支持HTTP、HTTPS、FTP等多种协议。`curl` 提供了高度的灵活性，通过丰富的命令行选项可以实现复杂的下载需求和数据传输任务。
4. **aria2**
   - **简介**: `aria2` 是一个高度灵活且高效的下载工具，支持多协议（包括HTTP/HTTPS、FTP、SFTP、BitTorrent等）和多源下载。它具备多线程下载、断点续传、下载队列管理以及速度限制等功能，非常适合大规模文件下载或需要高效率下载的场景。

### 其他

- **lftp**

   - **简介**: `lftp` 是一个强大的文件传输程序，不仅支持FTP，还支持HTTP、HTTPS等协议。它拥有shell-like的交互界面，支持Tab补全、书签、队列、镜像下载、断点续传等多种高级功能，适合需要进行复杂文件传输管理的用户。


## Aria2下载器

- 这是非常流行的下载工具,体积小,使用方式灵活,功能强大,被诸多软件所集成或依赖,尤其是windows,你的电脑上可能有好多个aria2(c) 下载器🤣
- 在音视频领域,ffmpeg有类似的地位

## powershell命令行下载工具👺

- 要在 PowerShell 中下载在线资源，比如文件，您可以使用 Invoke-WebRequest 或者更为现代的 Invoke-RestMethod cmdlet。
- 它们主要用于下载http/https协议的链接资源,尽管比不上专业的下载工具,但是如果仅仅临时下载,又刚好是http/https的链接,而不想(不方便)安装软件,则可以考虑用powershell自带的命令下载

### 使用 Invoke-WebRequest

- [Invoke-WebRequest (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.4&viewFallbackFrom=p)

```powershell
# 示例: 下载一个文件
$url = 'https://example.com/somefile.zip'
$outputPath = 'C:\Downloads\somefile.zip'

Invoke-WebRequest -Uri $url -OutFile $outputPath
```

这个命令会从指定的 `$url` 下载文件，并将其保存到 `$outputPath` 指定的位置。

在PowerShell中，`Invoke-WebRequest`是一个非常实用的命令，用于发送HTTP请求并获取响应内容。如果你想要使用它作为一个简易的下载器来下载文件，可以按照以下步骤操作：

#### 基本用法

假设你想从一个URL下载一个文件，可以使用如下命令结构：

```powershell
Invoke-WebRequest -Uri "下载链接" -OutFile "保存的文件路径"
```

- `-Uri` 参数后面跟的是你想要下载的文件的网址。
- `-OutFile` 参数后面跟的是你希望保存下载文件的本地路径及文件名。

#### 示例

比如，你想从互联网上下载一个图片文件并保存到本地的"Downloads"文件夹，可以这样操作：

```powershell
Invoke-WebRequest -Uri "https://example.com/path/to/image.jpg" -OutFile "C:\Users\YourUsername\Downloads\image.jpg"
```

请确保替换示例中的URL为你实际要下载的文件链接，以及将目标文件路径修改为你希望保存的位置。

#### 高级用法

如果你需要处理更复杂的情况，比如需要处理重定向、自定义用户代理或者需要携带cookies等，可以通过更多的参数来实现，例如：

- 使用 `-UserAgent` 参数来指定用户代理字符串。
- 使用 `-Headers` 参数来添加自定义的HTTP头信息，这对于需要特定认证信息的下载很有用。
- 如果遇到重定向问题，可以尝试添加 `-MaximumRedirection 0` 来禁止自动重定向，并手动处理响应中的`Location`头信息来进行重定向。

#### 注意事项

- 确保你有权限下载目标文件，并且遵守相关网站的使用条款。
- 在下载大文件或执行大量下载操作时，考虑使用 `Invoke-WebRequest` 的替代命令 `Invoke-RestMethod` 或者 `.NET` 类库如 `System.Net.WebClient`、`System.Net.Http.HttpClient`，因为它们在处理大文件和性能上可能更有优势。
- 操作前，请确保你的PowerShell环境有足够的权限执行网络请求和写入文件到指定位置。

通过上述方法，你可以灵活地使用`Invoke-WebRequest`作为基础的文件下载工具。

### 使用 Invoke-RestMethod

- [Invoke-RestMethod (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.4)

- 如果你需要与 RESTful API 交互并可能要处理 JSON、XML 等格式的数据，可以使用 `Invoke-RestMethod`。但如果是简单地下载文件，通常还是推荐 `Invoke-WebRequest`。

- 例如

  - ```bash
    
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    
    ```

  - 上述脚本用来下载和执行scoop安装脚本

- 请注意，下载任何在线资源前，请确保你有权访问该资源，并遵守相关版权法律和网站的使用条款。



