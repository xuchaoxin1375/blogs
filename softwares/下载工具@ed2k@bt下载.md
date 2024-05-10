[toc]

## ed2k和BT协议

ed2k (eDonkey2000 network) 和 BT (BitTorrent) 是两种不同的P2P（点对点）文件共享协议和网络。

**eDonkey2000 network (ed2k)**:
- **起源与发展**：ed2k 是由 Jed McCaleb 在2000年左右创建的一种文件共享网络协议，通过 eMule、aMule 等客户端软件实现文件共享。
- **工作原理**：ed2k 使用客户端服务器结构和P2P交换相结合的方式，用户既可以从服务器查找文件资源，也可以直接从其他用户的计算机下载部分或全部文件内容。
- **链接形式**：ed2k 链接通常以 `ed2k://` 开头，后面跟着文件的哈希校验值以及文件大小等信息，用于定位网络上的文件资源。
- **特点**：支持断点续传，即可以继续之前未完成的下载；文件完整性检查机制较强，能够确保文件正确无误。

**BitTorrent (BT)**:
- **起源与发展**：BT 协议由 Bram Cohen 设计并在2001年推出，其特点是高效地分发大量数据，尤其适合大文件如电影、操作系统镜像等的分享。
- **工作原理**：BT 完全基于P2P模式，每个下载者同时也是上传者（种子），所有参与下载的人都贡献自己的上传带宽以加速整个网络的下载速度。下载时需要一个包含元数据信息的`.torrent`文件，或者磁力链接。
- **链接形式**：BT 种子文件可以通过 `.torrent` 文件或磁力链接 (`magnet:` 开头) 分享，磁力链接除了包含 tracker 信息外，还包含了文件哈希值（Info Hash）。
- **特点**：BT 强调的是资源共享，下载速度与参与分享的用户数量密切相关，人数越多，理论上下载速度越快；同时，当有足够的种子提供完整文件时，即使原始发布者离线，文件仍然可以被下载。

### 总结

1. ed2k 依赖于中心服务器索引服务，但也利用P2P技术传输文件；
2. BT 完全去中心化，仅依靠用户之间互相交换数据；
3. ed2k 的文件定位依赖于特定的链接标识符，BT 则依赖于 torrent 文件或磁力链接；
4. 在实际使用中，BT 通常被认为更利于大文件快速分布，而 ed2k 在某些情况下可能更容易获取较旧或较为罕见的资源。随着互联网环境的变化和技术的发展，这两种方式的流行程度和适用场景也在不断变化。

### 速度比较

ed2k 和 BitTorrent 哪个下载速度更快，并不能一概而论，主要取决于以下几个因素：

1. **网络环境和资源热度**：BT 下载速度在很大程度上取决于“种子”和“同伴”的数量及他们的上传速度。如果一个热门资源有很多活跃的种子和下载者（同伴），那么BT下载速度可能会非常快。而对于ed2k来说，虽然也受服务器和用户在线状况的影响，但只要有足够多且稳定的服务器和提供文件片段的用户，下载速度也能较快。

2. **文件的分割粒度**：BT 把文件分割成多个小块，每个小块都可以独立从不同源下载，这使得BT在充分利用带宽方面具有优势，尤其是对于大文件下载。

3. **地域和网络限制**：实际下载速度还会受到地理位置、ISP（互联网服务提供商）限速、防火墙等因素影响。

- 因此，在实际应用中，无法简单地说哪个更快，需要具体看资源的热度、网络条件和参与者的行为等因素。总体而言，对于热门资源，BT 下载由于其高效的资源共享机制，往往可以获得较高的下载速度。但对于一些冷门资源，ed2k 可能因为有服务器存储信息而更容易找到文件。然而，由于近年来BT的广泛应用和成熟的技术生态，大部分情况下BT的下载速度表现更为优秀。



## 下载工具

### 命令行

- 在命令行环境下，有许多高效且功能丰富的下载工具被广泛使用，尤其在Linux和类UNIX系统中。
- 在windows上有类似的移植工具,比如busybox

#### 流行的命令行下载工具

1. **wget**
   - **简介**: `wget` 是一个非常普及的命令行下载工具，它支持HTTP、HTTPS和FTP协议。使用它可以轻松下载互联网上的文件或整个网站。`wget` 支持断点续传、限速、时间戳比较以避免重新下载未修改的文件等功能。
2. **curl**
   - **简介**: `curl` 是另一个广为人知的命令行工具，它不仅能够下载文件，还能上传数据（包括FTP上传），支持HTTP、HTTPS、FTP等多种协议。`curl` 提供了高度的灵活性，通过丰富的命令行选项可以实现复杂的下载需求和数据传输任务。
4. **aria2**
   - **简介**: `aria2` 是一个高度灵活且高效的下载工具，支持多协议（包括HTTP/HTTPS、FTP、SFTP、BitTorrent等）和多源下载。它具备多线程下载、断点续传、下载队列管理以及速度限制等功能，非常适合大规模文件下载或需要高效率下载的场景。

#### 其他

1. **lftp**
   - **简介**: `lftp` 是一个强大的文件传输程序，不仅支持FTP，还支持HTTP、HTTPS等协议。它拥有shell-like的交互界面，支持Tab补全、书签、队列、镜像下载、断点续传等多种高级功能，适合需要进行复杂文件传输管理的用户。

   

### aria2👺

- [aria2/aria2: aria2 is a lightweight multi-protocol & multi-source, cross platform download utility operated in command-line. It supports HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink. (github.com)](https://github.com/aria2/aria2)

  - The project page is located at https://aria2.github.io/.
  - 下载可执行程序[Release aria2  aria2/aria2 (github.com)](https://github.com/aria2/aria2/releases/tag/release-1.37.0)

- Aria2是一款高效、开源的命令行下载工具，它支持多协议和多来源下载，适用于Linux、macOS、Windows等操作系统，甚至可以在树莓派、NAS设备和路由器等平台上运行。Aria2的主要特点和功能包括：

  - **多协议支持**：Aria2能够处理HTTP/HTTPS、FTP、SFTP、BitTorrent和Metalink协议，这使得它成为一个非常通用的下载解决方案。

  - **轻量级与高效**：它以其轻量级著称，平均内存使用量低（通常在4-9MB之间），即使在高速下载时（如BitTorrent下载速度达到2.8MiB/s），CPU占用率也仅为约6%，这使得它成为资源敏感环境的理想选择。

  - **多线程下载**：通过分割文件成多个部分并使用多个连接同时下载，Aria2显著提高了下载速度，特别是对于大文件而言。

  - **断点续传**：支持断点续传功能，允许从之前中断的地方继续下载，无需重新开始。

  - **BitTorrent特性**：全面支持BitTorrent协议，包括DHT（分布式哈希表）、PEX（Peer Exchange）、UDP跟踪器和磁力链接，使得BT下载同样高效。

  - **命令行界面**：作为命令行工具，Aria2可以通过各种命令行参数进行精细控制，适合脚本自动化和集成到其他系统中。

  - **可扩展性**：Aria2可以通过JSON-RPC接口与其他应用程序或Web前端进行交互，这促进了许多第三方前端（如AriaNG）的开发，提供了更友好的图形用户界面。

  - **开源**：作为开源软件，Aria2的源代码托管在GitHub上，允许任何人查看、修改和贡献代码，确保了透明度和安全性。

  由于其灵活性、高效性和广泛的协议支持，Aria2常被用来优化下载体验，特别是在需要大量文件下载、高速下载或是需要在服务器环境中自动执行下载任务的场景中。

## powershell命令行下载工具

- 要在 PowerShell 中下载在线资源，比如文件，您可以使用 Invoke-WebRequest 或者更为现代的 Invoke-RestMethod cmdlet。
- 它们主要用于下载http/https协议的链接资源

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



