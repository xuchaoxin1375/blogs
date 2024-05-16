[toc]

# 常用的文件共享下载协议和下载工具

## 磁力下载链接

磁力链接（Magnet URI scheme）是一种特殊的**链接格式**，广泛应用于点对点（P2P）文件共享网络中，用于标识和下载文件。

与传统的HTTP或FTP等**基于位置**的链接不同，磁力链接不依赖于文件所在的特定服务器或地址，而是通过文件内容的哈希值（一个独特的数字指纹）来识别和定位文件。

这种方式使得磁力链接非常适合**分布式网络环境**，特别是那些没有中心服务器的对等网络（如BitTorrent网络）。

### 磁力链接的组成和原理

磁力链接通常由一系列参数组成，其中最重要的参数是基于文件内容计算出的哈希值，这个哈希值通常是通过一种叫做“BitTorrent Infohash”的散列函数计算出来的。一个典型的磁力链接格式如下：

```
magnet:?xt=urn:btih:哈希值[&dn=文件名][&tr=tracker地址][&xl=文件大小][...]
```

- `xt`=urn:btih: 后面跟着的就是文件内容的哈希值，这是磁力链接的核心部分，用于唯一标识文件。
- `dn`=文件名，可选参数，用来指示磁力链接对应的文件名。
- `tr`=tracker地址，可选参数，指出跟踪器的地址，帮助用户找到文件的其他下载源，但在DHT和PEX技术普及后，这个参数变得不是必须。
- `xl`=文件大小，也是一个可选参数，指示文件的大小。

### 例

- 例如windows 10 LTSC的某个镜像的磁力链接

  ```bash
  magnet:?xt=urn:btih:366ADAA52FB3639B17D73718DD5F9E3EE9477B40&dn=SW_DVD9_WIN_ENT_LTSC_2021_64BIT_ChnSimp_MLF_X22-84402.ISO&xl=5044211712
  ```

  

### 磁力链接的特点和优势

1. **去中心化**：磁力链接不依赖于中心服务器，即使种子文件的原始来源不可用，只要网络中还有其他拥有该文件的用户，文件就能继续被分享和下载。
2. **易于分享**：用户只需复制磁力链接的文本即可分享文件，而无需上传或下载任何种子文件。
3. **隐私性**：使用磁力链接下载文件时，除非连接到公共Tracker，否则下载活动不经过中央服务器，提高了隐私保护。
4. **适应性**：即使某个Tracker服务器不可用，DHT（分布式哈希表）和PEX（Peer Exchange，对等交换）等技术也能帮助用户找到其他下载源。

### 应用场景

磁力链接常用于BitTorrent等P2P文件分享平台，用户可以在各种BT客户端软件中直接粘贴磁力链接开始下载文件。此外，许多在线论坛、社交媒体和即时通讯软件中也会使用磁力链接分享资源，因为它便于传播且不受传统下载链接失效的影响。

在实际应用中，磁力链接最普及和最知名的用途仍然是与BitTorrent协议结合使用，这是因为BitTorrent网络的普及度和成熟度较高，且许多流行的下载工具和客户端都内置了对磁力链接的支持。

## ed2k(eMule)和BT(BitTorrent)协议

ed2k (eDonkey2000 network) 和 BT (BitTorrent) 是两种不同的P2P（点对点）文件共享协议和网络。

**eDonkey2000 network (ed2k)**:
- **起源与发展**：ed2k 是由 Jed McCaleb 在2000年左右创建的一种文件共享网络协议，通过 eMule、aMule 等客户端软件实现文件共享。
- **工作原理**：ed2k 使用客户端服务器结构和P2P交换相结合的方式，用户既可以从服务器查找文件资源，也可以直接从其他用户的计算机下载部分或全部文件内容。
- **链接形式**：ed2k 链接通常以 `ed2k://` 开头，后面跟着文件的哈希校验值以及文件大小等信息，用于定位网络上的文件资源。
- **特点**：支持断点续传，即可以继续之前未完成的下载；文件完整性检查机制较强，能够确保文件正确无误。
- 电驴协议链接，通常指的是eD2k链接（eDonkey 2000 URI scheme），这是一种专用于电驴（eDonkey）和电骡（eMule）等P2P文件共享网络的链接格式。eD2k链接允许用户直接从电驴网络中添加和下载文件，而不需要通过网页或其他中介。
- 比较常用的支持ed2k的下载工具有迅雷(Thunder),还有某些网盘提供了离线下载此类链接的服务
- 这种链接的典型格式看起来像这样：

  ```
  1ed2k://|file|文件名|文件大小|文件哈希值|/
  ```

  各部分解释如下：

  - `ed2k://` 是协议标识符，表明这是一个电驴协议的链接。
  - `|file|` 是固定标记，表示接下来描述的是一个文件。
  - `文件名` 是文件的名称，可能会经过URL编码。
  - `文件大小` 是文件的大小，通常以字节为单位。
  - `文件哈希值` 是文件内容的唯一标识符，通常是MD4哈希值，用于确保文件的准确性和完整性。
  - 最后的 `|/` 是链接结束标记。
  - 例如,windows 7的某个系统镜像:`ed2k://|file|cn_windows_7_ultimate_with_sp1_x64_dvd_u_677408.iso|3420557312|B58548681854236C7939003B583A8078|/`

**BitTorrent (BT)**:

- **起源与发展**：BT 协议由 Bram Cohen 设计并在2001年推出，其特点是高效地分发大量数据，尤其适合大文件如电影、操作系统镜像等的分享。
- **工作原理**：BT 完全基于P2P模式，每个下载者同时也是上传者（种子），所有参与下载的人都贡献自己的上传带宽以加速整个网络的下载速度。下载时需要一个包含元数据信息的`.torrent`文件，或者磁力链接。
- **链接形式**：BT 种子文件可以通过 `.torrent` 文件或磁力链接 (`magnet:` 开头) 分享，磁力链接除了包含 tracker 信息外，还包含了文件哈希值（Info Hash）。BT链接在此比较独特,其他协议大多以协议名作为链接开头,而BT却不是以`BT://`开头也不是`BitTorrent://`作为开头
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

## BitTorrent(BT协议详解)

考虑到支持BT下载的工具比ed2k的要多,这里拓展介绍BT协议

BitTorrent 是一种广泛使用的点对点（P2P）文件共享协议，由布拉姆·科恩（Bram Cohen）在2001年设计并开发。它特别适合于大文件的高效分发，如高清视频、大型软件安装包等，通过将文件分割成多个小块并利用用户之间的对等连接进行传输，极大地减轻了中心服务器的负担，并能有效提高下载速度。

### 工作原理

1. **文件分割与哈希验证**：当一个用户（称为种子）想要分享一个文件时，BitTorrent客户端会将文件分割成多个小块，并为每个块计算一个哈希值，确保文件的完整性和准确性。

2. **种子与客户端**：最初上传文件的用户被称为种子，下载文件的用户称为客户端（也称为“leechers”）。一旦有足够多的种子开始分享文件，下载过程就会启动。

3. **Tracker与DHT**：BitTorrent 初始版本依赖于Tracker服务器来协调下载者和上传者之间的连接。Tracker维护参与共享的客户端列表，并帮助它们相互发现。后来发展出了DHT（分布式哈希表）和Pex（Peer Exchange）等技术，使得系统更加去中心化，不再完全依赖Tracker。

4. **同时上传与下载**：BitTorrent协议鼓励用户在下载的同时上传他们已经获得的文件块给其他用户，这种模式称为“播种”。这种对等分享大大提升了整个网络的效率和下载速度。

5. **种子文件与磁力链接**：为了开始下载，用户需要一个.torrent文件（种子文件），里面包含了文件的元数据，如文件名、大小、哈希值以及Tracker信息等。近年来，磁力链接的使用越来越普遍，它直接包含了文件的哈希值等必要信息，用户可以直接通过磁力链接启动下载，无需下载种子文件。

### 优点

- **高效的大文件分发**：通过多点同时下载，加快了文件传输速度。
- **减轻服务器压力**：文件分发的负担分散到了每一个参与下载的用户身上，降低了对中心服务器的依赖。
- **去中心化**：特别是DHT技术的应用，使得BitTorrent网络更加健壮，即使某个Tracker失效，文件传输仍可继续。
- **适用范围广**：广泛应用于合法的内容分发，如游戏更新、开源软件分发，以及个人文件分享等。

### 缺点与争议

尽管BitTorrent技术本身是中立的，但它常与版权侵犯联系在一起，因为用户可能会非法分享受版权保护的内容。这导致了一些法律风险和道德争议，以及ISP（互联网服务提供商）可能的限速或阻止措施。

## 其他链接

### 迅雷链接

- `thunder://` 类型的链接是迅雷下载软件专用的一种链接格式，用于直接从迅雷的服务器或其P2P网络中下载文件。这种链接格式设计的目的是为了提供更快、更稳定的下载体验，因为它能够利用迅雷的多资源超线程技术以及P2P加速功能。
- 但是这种链接现在不多见了

### MetaLink链接

Metalink链接是一种特殊的链接格式，它不仅仅是一个简单的URL指向一个文件，而是包含了一个文件的多个下载源以及校验信息的元数据文件。

这种链接格式通过使用XML来描述文件的下载信息，包括文件名、大小、哈希值（用于验证文件完整性），以及一个或多个下载URLs。其目的是为了提高文件下载的可靠性和效率，具体体现在以下几个方面：

1. **可靠性**: 通过提供多个下载源，如果某个源不可用，下载工具可以自动切换到其他源继续下载，减少了单点故障的影响。
2. **加速下载**: 支持并行下载，即从多个源同时下载文件的不同部分，可以显著提高下载速度。
3. **完整性验证**: 包含了文件的校验信息（如MD5、SHA-1或SHA-256哈希值），下载后可以验证文件是否完整无误，确保数据的准确性。

Metalink链接被设计为可被多种下载管理器识别和支持，包括Wget、cURL、Aria2等工具，用户只需提供Metalink文件的URL，这些工具就能自动处理其余的下载逻辑，包括选择最快的镜像、校验文件等。

例如，一个简单的Metalink XML示例可能看起来像这样：

```xml
<metalink xmlns="urn:ietf:params:xml:ns:metalink">
  <file name="example.iso">
    <size>5044211712</size>
    <hash type="sha-256">366ADAA52FB3639B17D73718DD5F9E3EE9477B40</hash>
    <url location="server1">http://example.com/files/example.iso</url>
    <url location="server2">http://mirror1.example.net/files/example.iso</url>
  </file>
</metalink>
```

在这个例子中，`example.iso`文件有多个下载URL，并且包含了其SHA-256校验和，下载工具可以根据这个信息智能地进行下载。

# 下载工具👺

## GUI工具

### Motrix

- [agalwood/Motrix: A full-featured download manager. (github.com)](https://github.com/agalwood/Motrix?tab=readme-ov-file)

- 这是一个热门开源跨平台的下载工具,提供了GUI,易于使用,支持大多数协议

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
  
  相关文档和示例

- The project page is located at https://aria2.github.io/.
- 下载可执行程序[Release aria2  aria2/aria2 (github.com)](https://github.com/aria2/aria2/releases/tag/release-1.37.0)
- 文档[Aria2 Manual — aria2 documentation](https://aria2.github.io/manual/en/html/index.html)

- 使用示例:[aria2c(1) Examples documentation](https://aria2.github.io/manual/en/html/aria2c.html#example)

### 配置环境变量以快速启动

- 为了使aria2在任意路径下可以访问,推荐讲aria2所在目录写入到Path环境变量
- 不了解的话可以自行搜索相关教程,不难操作

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

## FAQ:磁力链接下不动

[你的种子磁力为什么下不动了！ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/85652893)



## powershell命令行下载工具

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



