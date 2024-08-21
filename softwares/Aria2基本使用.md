[toc]





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
- 文档
  - 英文文档[Aria2 Manual — aria2 documentation](https://aria2.github.io/manual/en/html/index.html)

  - 中文文档[aria2c(1) — aria2  documentation](https://aria2.document.top/zh/aria2c.html#id1)

- 使用示例:[aria2c(1) Examples documentation](https://aria2.github.io/manual/en/html/aria2c.html#example)

### 本地文档

- 通过`aria2c -h`获取首页帮助(实际上等价于`aria2c -h#basic`)

- ```cmd
  PS C:\Users\cxxu\Desktop> aria2c -h
  Usage: aria2c [OPTIONS] [URI | MAGNET | TORRENT_FILE | METALINK_FILE]...
  Printing options tagged with '#basic'.
  See 'aria2c -h#help' to know all available tags.
  Options:
   -v, --version                Print the version number and exit.
  
                                Tags: #basic
  ....
  ```

  

#### 获取所有Tag帮助主题

```cmd
PS C:\Users\cxxu\Desktop>  aria2c -h#help
Usage: aria2c [OPTIONS] [URI | MAGNET | TORRENT_FILE | METALINK_FILE]...
Printing options tagged with '#help'.
See 'aria2c -h#help' to know all available tags.
Options:
 -h, --help[=TAG|KEYWORD]     Print usage and exit.
                              The help messages are classified with tags. A tag
                              starts with "#". For example, type "--help=#http"
                              to get the usage for the options tagged with
                              "#http". If non-tag word is given, print the usage
                              for the options whose name includes that word.

                              Possible Values: #basic, #advanced, #http, #https, #ftp, #metalink, #bittorrent, #cookie, #hook, #file, #rpc, #checksum, #experimental, #deprecated, #help, #all
                              Default: #basic
                              Tags: #basic, #help

Refer to man page for more information.
```

### 查询特定主题

- `aria2c -h#http`和`aria2c --help=#http`的效果一样

- 一般我们使用第一种,更方便

- ```cmd
  PS C:\Users\cxxu\Desktop> aria2c -h#http 
  Usage: aria2c [OPTIONS] [URI | MAGNET | TORRENT_FILE | METALINK_FILE]...
  Printing options tagged with '#http'.
  See 'aria2c -h#help' to know all available tags.
  Options:
   -t, --timeout=SEC            Set timeout in seconds.
  
                                Possible Values: 1-600
                                Default: 60
                                Tags: #http, #ftp
  ....
  ```

  ```cmd
  PS C:\Users\cxxu\Desktop> aria2c --help=#http
  Usage: aria2c [OPTIONS] [URI | MAGNET | TORRENT_FILE | METALINK_FILE]...
  Printing options tagged with '#http'.
  See 'aria2c -h#help' to know all available tags.
  Options:
   -t, --timeout=SEC            Set timeout in seconds.
  
                                Possible Values: 1-600
                                Default: 60
                                Tags: #http, #ftp
  ....
  ```

#### 分页阅读

- 在powershell中查阅Aria2文档时,可以使用`|out-host -paging`来分页阅读,可以按空格翻页,按回车显示下一行内容

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

## aria2进阶用法

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



## 多线程下载👺

多线程下载是通过将一个文件分成多个部分（分片）并同时下载这些部分来加速下载过程的。每个部分使用单独的线程进行下载，这样可以充分利用带宽，尤其是在服务器支持多线程下载的情况下。

不过有时候有更多的含义

| 分类标准 | 子类型        | 特点                | 多线程应用                | 适用场景              |
| -------- | ------------- | ------------------- | ------------------------- | --------------------- |
| 线程数   | 单线程        | 简单,速度慢         | 不适用                    | 小文件,弱网络         |
|          | 多线程(2-16)  | 速度快,利用带宽好   | 标准应用                  | 大多数下载场景        |
|          | 超多线程(16+) | 速度最快,资源消耗大 | 极限应用                  | 超大文件,无限制服务器 |
| 文件类型 | 单文件        | 简单,易管理         | 文件分割下载              | 常规下载              |
|          | 多文件        | 需要任务管理        | 每个文件多线程或单线程    | 批量下载              |
|          | 压缩文件      | 需要解压,通常较大   | 同单文件,可能需要更多线程 | 大型软件包,数据集     |
| 下载协议 | HTTP/HTTPS    | 通用,支持断点续传   | 通过Range请求实现         | 网页下载,通用文件     |
|          | FTP/SFTP      | 专为文件传输设计    | FTP支持,SFTP通常不支持    | 文件服务器下载        |
|          | BitTorrent    | P2P,多源下载        | 天然多线程                | 大文件,热门内容       |

- 最常见的多线程下载是一个大文件分为N个部分,由多个线程分别下载,最后合并成一个文件

### Aria2c的多线程相关选项详解

**注意事项**: 过多的线程数可能导致服务器拒绝连接或影响下载速度，因此应根据网络条件适当调整。

####  `-s`, `--split=<N>`

- -s, --split=<N>[¶](https://aria2.document.top/zh/aria2c.html#cmdoption-s)

  - 使用 N 个连接下载文件。如果给出的 URI 超过 N 个，将使用前 N 个 URI，其余的用作备用。如果给出的 URI 不到 N 个，那么这些 URI 将被再次使用，以便总共同时建立 N 个连接。
  - 对同一服务器的连接数受 [`--max-connection-per-server`](https://aria2.document.top/zh/aria2c.html#cmdoption-x) 选项的限制。
  -  也请参阅 [`--min-split-size`](https://aria2.document.top/zh/aria2c.html#cmdoption-k) 选项。 
  - 本选项的默认值：`5`

  Note

  一些 Metalink 规定了要连接的服务器数量。aria2 严格遵守这些规定。这意味着如果 Metalink 定义的 `maxconnections` 属性小于 N，则 aria2 将使用该较低值，而不是 N。

- 用法:

  ```
  aria2c --split=8 <url>
  ```
  

####  `-x`, `--max-connection-per-server=<N>`

- **解释**: 每个服务器允许的最大连接数。这可以与`-s`选项结合使用。
  -  -x, --max-connection-per-server=NUM The maximum number of connections to one
                                  server for each download.
  - 有些版本编译出来得到,我们查看它的文档,会提示`-x`的最大链接数是16(默认一般都是1)
  -   Possible Values: 1-16
                              Default: 1
                              Tags: #basic, #http, #ftp

#### `-k`, `--min-split-size=<SIZE>`

**解释**: 设置每个线程下载的最小块大小。如果文件大小小于`<SIZE>`，则不会进一步分割。

-k, --min-split-size=<SIZE>[¶](https://aria2.document.top/zh/aria2c.html#cmdoption-k)

- aria2 不会将文件划分为小于 `2*SIZE` 字节的范围。例如，假设下载 20MiB 文件。如果 SIZE 为 10M，aria2 可以将文件划分为 2 个范围 [0-10MiB) 和 [10MiB-20MiB)，并使用 2 个来源下载它（如果 [`--split`](https://aria2.document.top/zh/aria2c.html#cmdoption-s) >= 2，当然）。如果 SIZE 为 15M，因为 2*15M > 20MiB，aria2 不会划分文件，并使用 1 个来源下载。
- You can append `K` or `M` (1K = 1024, 1M = 1024K). 
- Possible Values: `1M` -`1024M` Default: `20M`(通常的版本我们无法将大小设置小于1M,例如500K是不行的)
- ```
   -k, --min-split-size=SIZE    aria2 does not split less than 2*SIZE byte range.
                                For example, let's consider downloading 20MiB
                                file. If SIZE is 10M, aria2 can split file into 2
                                range [0-10MiB) and [10MiB-20MiB) and download it
                                using 2 sources(if --split >= 2, of course).
                                If SIZE is 15M, since 2*15M > 20MiB, aria2 does
                                not split file and download it using 1 source.
                                You can append K or M(1K = 1024, 1M = 1024K).
  
                                Possible Values: 1048576-1073741824
                                Default: 20M
  ```

  

#### `--enable-http-pipelining`

- **解释**: 启用HTTP管道化以减少网络延迟。这在多个线程从同一服务器下载时尤为有效。

  

### 用例

1. 基本用法

```bash
aria2c -s 5 http://example.com/largefile.zip
```

这个命令将使用5个连接（线程）来下载`largefile.zip`。这是默认行为,适用于大多数单文件下载场景。

2. 增加线程数以提高下载速度

```bash
aria2c -s 16 http://example.com/verylargefile.iso
```

对于非常大的文件,我们可以增加线程数到16,提高下载速度。这适用于超大文件下载场景。

3. 多URL下载(不同源下载同一个文件)

```bash
aria2c -s 3 http://mirror1.com/file.tar.gz http://mirror2.com/file.tar.gz http://mirror3.com/file.tar.gz
```

这里我们提供了3个不同的URL源,并设置3个线程。aria2将从这三个源同时下载,提高可靠性和可能的速度。

4. 备用URL

```bash
aria2c -s 2 http://main-server.com/file.dat http://backup1.com/file.dat http://backup2.com/file.dat
```

虽然我们提供了3个URL,但设置了2个线程。aria2将使用前两个URL进行下载,第三个URL将作为备用。

5. 结合最小分片大小

```bash
aria2c -s 10 --min-split-size=1M http://example.com/largefile.bin
```

这里我们设置10个线程,但也指定了最小分片大小为1MB。这意味着只有当文件大于10MB时,才会使用全部10个线程。

6. 限制每服务器最大连接数

```bash
aria2c -s 8 --max-connection-per-server=4 http://example.com/file1.zip http://example.com/file2.zip
```

我们设置了8个线程,但限制每个服务器最多4个连接。这在下载多个来自同一服务器的文件时很有用。

### 小结

增加线程数不总是会提高速度,有时可能会因为服务器限制而适得其反。因此,需要根据具体情况进行调整和测试。



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

## aria2下载线程数量监视

### 检查 Aria2 日志或控制台输出

在下载过程中，Aria2 的控制台输出或日志中通常会显示使用的分片数 (split count)，这间接反映了使用的线程数。日志文件路径和格式取决于你的 Aria2 配置。

如果启用了详细日志，你可以在日志中查找类似以下的输出：

```plaintext
[#f3a45b 128MiB/512MiB(25%) CN:16 DL:1.2MiB ETA:5m]
```

其中 `CN:16` 表示当前使用了 16 个连接（连接数和线程数通常一致）。

**注意**：在实际应用中，虽然你可以设置线程数，但实际的线程使用量可能会因为服务器端限制或网络条件而有所不同。

## aria2下载优化建议

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

