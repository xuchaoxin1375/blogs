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

   

## aria2👺

- [aria2/aria2: aria2 is a lightweight multi-protocol & multi-source, cross platform download utility operated in command-line. It supports HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink. (github.com)](https://github.com/aria2/aria2)

- Aria2是一款高效、开源的命令行下载工具，它支持多协议和多来源下载，适用于Linux、macOS、Windows等操作系统，甚至可以在树莓派、NAS设备和路由器等平台上运行。Aria2的主要特点和功能包括：

  - **多协议支持**：Aria2能够处理HTTP/HTTPS、FTP、SFTP、BitTorrent和Metalink协议，这使得它成为一个非常通用的下载解决方案。(目前不支持ed2k协议,和大多数其他下载一样)

  - **轻量级与高效**：它以其轻量级著称,这使得它成为资源敏感环境的理想选择。

  - **多线程下载**：通过分割文件成多个部分并使用多个连接同时下载，Aria2显著提高了下载速度，特别是对于大文件而言。

  - **断点续传**：支持断点续传功能，允许从之前中断的地方继续下载，无需重新开始。

  - **BitTorrent特性**：全面支持BitTorrent协议，包括DHT（分布式哈希表）、PEX（Peer Exchange）、UDP跟踪器和磁力链接，使得BT下载同样高效。

  - **命令行界面**：作为命令行工具，Aria2可以通过各种命令行参数进行精细控制，适合脚本自动化和集成到其他系统中。

  - **可扩展性**：Aria2可以通过JSON-RPC接口与其他应用程序或Web前端进行交互，这促进了许多第三方前端（如AriaNG）的开发，提供了更友好的图形用户界面。

  - **开源**：作为开源软件，Aria2的源代码托管在GitHub上，允许任何人查看、修改和贡献代码，确保了透明度和安全性。

  由于其灵活性、高效性和广泛的协议支持，Aria2常被用来优化下载体验，特别是在需要大量文件下载、高速下载或是需要在服务器环境中自动执行下载任务的场景中。
  

### 相关文档和示例

- The project page is located at https://aria2.github.io/.
- 下载可执行程序[Release aria2  aria2/aria2 (github.com)](https://github.com/aria2/aria2/releases/tag/release-1.37.0)
- 文档[Aria2 Manual — aria2 documentation](https://aria2.github.io/manual/en/html/index.html)

- 使用示例:[aria2c(1) Examples documentation](https://aria2.github.io/manual/en/html/aria2c.html#example)

### 配置环境变量以快速启动

- 为了使aria2在任意路径下可以访问,推荐讲aria2所在目录写入到Path环境变量
- 不了解的话可以自行搜索相关教程,不难操作

### FAQ:启动失败

由于aria2灵活易于嵌入到应用程序中,许多软件内置了aria2下载器,所以您的计算机上可能有多个aria2程序

如果出现执行失败,或者配置混乱,例如

```bash
PS C:\Users\cxxu\Desktop> aria2c.exe -h
ResourceUnavailable: Program 'aria2c.exe' failed to run: An error occurred trying to start process 'C:\exes\aria2c.exe' with working directory 'C:\Users\cxxu\Desktop'. The specified executable is not a valid application for this OS platform.At line:1 char:1
+ aria2c.exe -h
+ ~~~~~~~~~~~~~.
```

检查一下路径:`where.exe aria2`进行排查

```powershell

PS C:\Users\cxxu\Desktop> where.exe aria2c
C:\exes\aria2c.exe
C:\exes\aria2\aria2c.exe
```



### 本地帮助文档

- ```bash
  PS> aria2 -h
  Usage: aria2c [OPTIONS] [URI | MAGNET | TORRENT_FILE | METALINK_FILE]...
  Printing options tagged with '#basic'.
  See 'aria2c -h#help' to know all available tags.
  Options:
   -v, --version                Print the version number and exit.
  
                                Tags: #basic
  
   -h, --help[=TAG|KEYWORD]     Print usage and exit.
                                The help messages are classified with tags. A tag
                                starts with "#". For example, type "--help=#http"
                                to get the usage for the options tagged with
                                "#http". If non-tag word is given, print the usage
                                for the options whose name includes that word.
  ..
  ```

  

### aria2用例

#### 基础

aria2功能强大,同时又十分易用,例如下载某个https资源,默认情况下,aria2会将文件下载到当前工作目录,并且会统计下载凭据速度和下载结果是否成功

```bash
PS C:\Users\cxxu\Desktop> aria2c https://mirror.ghproxy.com/https://github.com/Exafunction/codeium/releases/download/language-server-v1.8.37/language_server_windows_x64.exe.gz

05/16 11:29:10 [NOTICE] Downloading 1 item(s)
[#3dab18 0B/0B CN:1 DL:0B]
05/16 11:29:11 [NOTICE] Allocating disk space. Use --file-allocation=none to disable it. See --file-allocation option in man page for more details.
[#3dab18 16MiB/28MiB(57%) CN:1 DL:8.4MiB ETA:1s]
05/16 11:29:14 [NOTICE] Download complete: C:/Users/cxxu/Desktop/language_server_windows_x64.exe.gz

Download Results:
gid   |stat|avg speed  |path/URI
======+====+===========+=======================================================
3dab18|OK  |    10MiB/s|C:/Users/cxxu/Desktop/language_server_windows_x64.exe.gz
```

#### 拓展

以下是对[aria2c 文档](https://aria2.github.io/manual/en/html/aria2c.html#example)中“Example”章节的中文总结：

该章节提供了一些使用 `aria2c` 命令行工具的具体示例，帮助用户理解如何在实际操作中应用它。示例涵盖了下载单个文件、多文件、使用 Metalink 和 BitTorrent 等多种情境。以下是一些关键示例及其说明：

1. **下载单个文件**(最常用最基础的功能)：
   
   ```sh
   aria2c http://example.org/file
   ```
   使用 `aria2c` 下载单个文件的基本命令。
   
2. **下载多个文件**：
   ```sh
   aria2c http://example.org/file1 http://example.org/file2
   ```
   一次性下载多个文件。

3. **使用下载列表文件**：
   ```sh
   aria2c -i download-list.txt
   ```
   通过一个包含 URL 的文本文件批量下载文件。

4. **Metalink 下载**：
   ```sh
   aria2c http://example.org/foo.metalink
   ```
   使用 Metalink 文件下载，这种文件可以包含多个 URL、校验和和其它元数据，帮助提高下载可靠性和速度。

5. **BitTorrent 下载**：
   ```sh
   aria2c http://example.org/file.torrent
   ```
   通过 `torrent 文件`下载BT资源。

6. **磁力链接 (Magnet Link) 下载**：
   ```sh
   aria2c "magnet:?xt=urn:btih:..."
   ```
   直接使用`磁力链接`下载 BitTorrent 内容。

7. **控制下载速度**：
   ```sh
   aria2c --max-download-limit=1M http://example.org/file
   ```
   限制下载速度为 1MB/s。

8. **断点续传**：
   ```sh
   aria2c -c http://example.org/file
   ```
   继续上次未完成的下载。

这些示例展示了 `aria2c` 的灵活性和强大功能，帮助用户在不同场景下高效地进行下载任务。

### 使用多个下载参数

- 假设有任务:使用aria2c 下载 `magnet:?xt=urn:btih:366ADAA52FB3639B17D73718DD5F9E3EE9477B40&dn=SW_DVD9_WIN_ENT_LTSC_2021_64BIT_ChnSimp_MLF_X22-84402.ISO&xl=5044211712`

- 使用 `aria2c` 命令行工具下载 Magnet 链接时，可以利用其多线程和断点续传等功能来提高下载效率。以下是一些建议来优化 `aria2c` 的下载性能：

  1. **启用多线程下载**:
     `aria2c` 默认会尝试使用多线程下载，但你可以通过 `-s` 参数明确设置同时下载的连接数。例如，使用 `-s16` 可开启16个连接来下载。

  2. **断点续传**:
     如果下载中断，`aria2c` 会自动尝试从断点继续，无需额外参数。

  3. **设置下载限速**:
     适当限制下载速度可以帮助避免网络拥堵，使用 `-x` 设置上传限速，`-y` 设置下载限速。例如，`-x10m -y10m` 分别限制上传和下载速度为10Mbps。

  4. **使用代理**:
     如果网络环境允许，可以使用代理服务器来提升下载速度或绕过网络限制。使用 `-x` 后跟代理服务器地址和端口。

  5. **文件预分配**:
     使用 `--file-allocation=prealloc` 可以提前分配好文件空间，减少文件写入时的磁盘碎片，适合大文件下载。

  6. **禁用磁盘缓存**:
     对于大文件下载，可以考虑禁用磁盘缓存以减少内存占用，使用 `--disk-cache=0`。

  结合上述建议，一个高效的下载命令可能如下所示：

  ```sh
  aria2c "magnet:?xt=urn:btih:366ADAA52FB3639B17D73718DD5F9E3EE9477B40&dn=SW_DVD9_WIN_ENT_LTSC_2021_64BIT_ChnSimp_MLF_X22-84402.ISO&xl=5044211712" -s16 --file-allocation=prealloc 
  # --disk-cache=0 内存充足的话可以不禁用
  ```

  但是资源冷门的话可能下不动,这时候就要掏出迅雷或其他网盘的离线下载功能来下载了



### 大文件多线程下载👺

多线程下载是通过将一个文件分成多个部分（分片）并同时下载这些部分来加速下载过程的。每个部分使用单独的线程进行下载，这样可以充分利用带宽，尤其是在服务器支持多线程下载的情况下。

### 关键参数

在使用 `aria2` 进行多线程下载时，有几个关键参数需要了解：

1. **`-x` 或 `--max-connection-per-server`**：
   - 这个参数指定每个服务器的最大连接数，即每个文件可以打开多少个线程进行下载。
   - 默认值是 1，最大值是 16。
   - 示例：
     ```sh
     aria2c -x 16 http://example.org/file
     ```

2. **`-s` 或 `--split`**：
   - 这个参数指定文件被分成多少个部分来下载。
   - 默认值是 5，最大值是 16。
   - 示例：
     ```sh
     aria2c -s 16 http://example.org/file
     ```

3. **`--min-split-size`**：
   - 这个参数指定了分片的最小大小。
   - 如果文件很小而分片很多，可能会导致某些分片非常小，效率低下。通过设置 `--min-split-size`，可以确保每个分片至少有一定的大小。
   - 示例：
     ```sh
     aria2c --min-split-size=1M -x 16 http://example.org/file
     ```

### 使用示例

1. **基础多线程下载**：
   ```sh
   aria2c -x 16 -s 16 http://example.org/file
   ```
   这条命令将文件分成 16 个部分，并使用 16 个线程同时下载。

2. **限制最小分片大小**：
   ```sh
   aria2c -x 16 -s 16 --min-split-size=1M http://example.org/file
   ```
   这条命令不仅将文件分成 16 个部分，还确保每个分片至少有 1MB 大小，防止过多小分片降低下载效率。

3. **结合其他参数**：
   ```sh
   aria2c -x 16 -s 16 --max-download-limit=500K http://example.org/file
   ```
   此命令在多线程下载的基础上，限制下载速度为 500KB/s。

### 监控和管理多线程下载

`aria2` 提供了丰富的选项来监控和管理下载过程，包括断点续传、下载速度限制、日志记录等。例如：

- **断点续传**：
  ```sh
  aria2c -c -x 16 -s 16 http://example.org/file
  ```
  使用 `-c` 参数可以在下载中断时继续下载。

- **下载速度限制**：
  ```sh
  aria2c --max-download-limit=500K -x 16 -s 16 http://example.org/file
  ```
  限制整体下载速度以避免占用过多带宽。

- **日志记录**：
  ```sh
  aria2c -l download.log -x 16 -s 16 http://example.org/file
  ```
  将下载过程记录到日志文件 `download.log` 中，方便后续查看和调试。

### 优化建议

1. **合理设置分片数和线程数**：
   - 根据网络条件和服务器支持情况，合理设置 `-x` 和 `-s` 参数。
   - 分片数和线程数并不是越多越好，过多的线程可能会导致服务器拒绝连接或影响稳定性。

2. **使用 `--min-split-size` 控制分片大小**：
   - 避免分片过小，提高下载效率。

3. **结合使用其他优化参数**：
   - 如 `--max-concurrent-downloads` 控制同时下载的任务数，`--max-overall-download-limit` 控制总下载带宽等。

通过合理配置这些参数，`aria2` 的多线程下载功能可以大大提升下载速度和效率。

## FAQ:磁力链接下不动

- [你的种子磁力为什么下不动了！ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/85652893)
- 简单讲,下载磁力链接时,图方便面配置的GUI方式下载,这里推荐使用迅雷或者motrix;也可以考虑使用网盘的离线下载功能
- 虽然aria2本身支持bt下载,但是很多资源没有好的Tracker资源所以可能下不动



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



