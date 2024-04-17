[toc]

#  

##  abstract

### 安装node

- [Downloading and installing Node.js and npm | npm Docs (npmjs.com)](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
  - linux系统上安装:nodeSourceDistributions(github)
    - [nodesource/distributions: NodeSource Node.js Binary Distributions (github.com)](https://github.com/nodesource/distributions#installation-instructions)
  - 包管理器安装
    - [nvm-sh/nvm: Node Version Manager - POSIX-compliant bash script to manage multiple active node.js versions (github.com)](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)
    - [Node.js — Download Node.js® (nodejs.org)](https://nodejs.org/en/download/package-manager/)


- node官方下载页面,但是直接下载的并不多[ Node.js (nodejs.org)|download](https://nodejs.org/en/download/)

### node(nodejs)@npm

**Node.js**
Node.js 是一个开源、跨平台的 JavaScript 运行环境，用于在服务器端执行 JavaScript 代码。

它并非一种编程语言，而是由谷歌 Chrome 浏览器中的 V8 JavaScript 引擎提供的一个平台。

Node.js 使用事件驱动、非阻塞I/O模型，特别适合构建可扩展的数据密集型实时应用程序，如网络应用、API服务器、实时聊天系统等。

Node.js 提供了丰富的标准库，以及对文件系统、网络（HTTP/HTTPS）、TCP/UDP套接字、进程间通信（IPC）等多种操作系统服务的API支持，使得开发者能用JavaScript编写服务器端程序，并且得益于异步处理能力，Node.js 在高并发场景下具有较高的性能表现。

**npm**
npm（Node Package Manager）是Node.js的默认包管理器，也是一个巨大的软件仓库，拥有世界上最大的开源库生态系统。npm允许开发人员轻松地共享和重用代码，通过它，开发者可以：

- 发布自己的模块或应用程序包供他人使用；
- 搜索并安装其他开发者的模块；
- 管理项目依赖关系，即在项目中指定所需的特定版本的库，并自动解决它们之间的依赖冲突；
- 执行自动化任务，如构建、测试和部署流程，通过定义`package.json`中的`scripts`字段来运行各种命令。

**三者之间的关系**
- Node.js 为 JavaScript 提供了在服务器端运行的能力。
- npm 是内置在 Node.js 中的一个组件，当安装 Node.js 时通常会一同安装 npm。
- nvm（Node Version Manager）则是用于管理和切换不同版本的 Node.js 的工具，它可以独立于 Node.js 安装，并帮助开发者在同一台机器上安装和切换多个 Node.js 版本，同时也方便管理与各个 Node.js 版本捆绑的 npm 版本。

### 总结

- Node.js 是 JavaScript 运行环境。
- npm 是基于 Node.js 的包管理和分发工具。
- nvm 是用于管理不同版本 Node.js 的工具，它并不直接属于 Node.js 生态的核心部分，但对开发者而言是非常实用的辅助工具。

## 下载和安装

- ```bash
  curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - &&\
  sudo apt-get install -y nodejs
  ```

### linux安装node

#### nvm安装和管理node

- [nvm-sh/nvm: Node Version Manager - POSIX-compliant bash script to manage multiple active node.js versions (github.com)](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)

#### 直接安装实操

- 下面的例子是ubunt server 22上试验,源是阿里源(清华源类似),源配置要正确,否则要么速度慢,要么执行不成功

  ```bash
  # cxxu @ ubt22 in ~ [1:38:03]
  $ curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - &&\
  sudo apt-get install -y nodejs
  [sudo] password for cxxu:
  2024-04-17 02:03:17 - Installing pre-requisites
  Hit:1 https://mirrors.aliyun.com/ubuntu jammy InRelease
  Hit:2 https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye InRelease
  Get:3 http://security.ubuntu.com/ubuntu jammy-security InRelease [110 kB]
  Hit:4 https://mirrors.aliyun.com/ubuntu jammy-updates InRelease
  Hit:5 https://mirrors.aliyun.com/ubuntu jammy-backports InRelease
  Fetched 110 kB in 3s (37.0 kB/s)
  ...
  Selecting previously unselected package nodejs.
  (Reading database ... 112601 files and directories currently installed.)
  Preparing to unpack .../nodejs_21.7.3-1nodesource1_amd64.deb ...
  Unpacking nodejs (21.7.3-1nodesource1) ...
  Setting up nodejs (21.7.3-1nodesource1) ...
  Processing triggers for man-db (2.10.2-1) ...
  Scanning processes...
  Scanning candidates...
  Scanning linux images...
  
  Running kernel seems to be up-to-date.
  
  Restarting services...
   /etc/needrestart/restart.d/systemd-manager
   systemctl restart fwupd.service packagekit.service polkit.service rsyslog.service systemd-journald.service systemd-resolved.service systemd-timesyncd.service systemd-udevd.service udisks2.service
  Service restarts being deferred:
   systemctl restart ModemManager.service
   systemctl restart networkd-dispatcher.service
   systemctl restart systemd-logind.service
   systemctl restart unattended-upgrades.service
   systemctl restart user@1000.service
  
  No containers need to be restarted.
  
  No user sessions are running outdated binaries.
  
  No VM guests are running outdated hypervisor (qemu) binaries on this host.
  
  
  ```
  

### windows安装node

- 可以到官网下载安装包直接安装,也可以选择免安装的便携版
  - [Node.js — Download Node.js® (nodejs.org)](https://nodejs.org/en/download/)
- 如果需要多个npm,则可以考虑用nvm for windows安装和管理
  - [coreybutler/nvm-windows: A node.js version management utility for Windows. Ironically written in Go. (github.com)](https://github.com/coreybutler/nvm-windows)

#### FAQ

- 执行`nvm install`等命令报错:`ERROR open \settings.txt: The system cannot find the file specified.`
- 那么请关闭所有powershell窗口,然后重新启动,看看问题是否得到解决(估计是环境变量问题)

### 版本检查

- ```bash
  # cxxu @ ColorfulCxxu in /etc/apt [11:19:43]
  $ npm -v;node -v
  10.5.0
  v21.7.3
  ```

  

- 也可以分开检查

  ```bash
  
  # cxxu @ ubt22 in ~ [2:04:58]
  $ npm --version
  10.5.0
  
  # cxxu @ ubt22 in ~ [2:05:44] C:130
  $ node --version
  v21.7.3
  ```

## npm 配置😊

- 如果有需要,可以配置npm

- ```bash
  
  # cxxu @ ColorfulCxxu in /etc/apt [11:28:45] C:130
  $ npm config -h
  Manage the npm configuration files
  
  Usage:
  npm config set <key>=<value> [<key>=<value> ...]
  npm config get [<key> [<key> ...]]
  npm config delete <key> [<key> ...]
  npm config list [--json]
  npm config edit
  npm config fix
  
  Options:
  [--json] [-g|--global] [--editor <editor>] [-L|--location <global|user|project>]
  [-l|--long]
  
  alias: c
  
  Run "npm help config" for more info
  ```

  

### npm加速😊

- npm（Node Package Manager）在下载和安装依赖时，默认会连接到官方的npm registry，由于网络原因，对于中国地区的开发者来说，可能会遇到速度较慢的问题。为了加速npm的安装过程，可以采取以下几种策略：

  1. **使用国内镜像源**：
     - 淘宝 NPM 镜像（cnpm）：
       ```shell
       npm config set registry https://registry.npm.taobao.org
       ```
     - 华为云 NPM 镜像：
       ```shell
       npm config set registry https://mirrors.huaweicloud.com/repository/npm/
       ```
     - 中国科学技术大学 NPM 镜像：
       ```shell
       npm config set registry https://registry.npmjs.org/
       ```

  2. **临时指定镜像源**：
     在运行 `npm install` 或其他npm命令时直接指定registry：
     ```shell
     npm install --registry=https://registry.npm.taobao.org <package-name>
     ```

  3. **修改全局或局部 `.npmrc` 文件**：
     编辑用户目录下的全局`.npmrc`文件（通常是 `~/.npmrc`），添加镜像源配置：

     ```
     registry=https://registry.npm.taobao.org
     ```

  4. **使用Yarn并配置镜像源**：
     对于Yarn用户，可以通过类似方式配置：
     ```shell
     yarn config set registry https://registry.npm.taobao.org
     ```


#### 其他

1. **使用缓存代理服务**：
   有些开发环境或者团队会选择搭建私有的npm缓存服务器，如Verdaccio，它可以作为本地或局域网内的npm代理，从而减少对外部网络的依赖。

2. **升级npm版本**：
   更新npm至最新版本通常能带来性能上的改进和优化。例如，npm v5.1.0版本提升了速度。

3. **使用 LazyNPM 或其他工具**：
   根据提及的“探索 LazyNPM”，这类工具可能是针对npm安装效率问题提出的新解决方案，通过智能缓存或其他机制提高安装速度。
4. 以上策略可以根据实际需求进行选择，其中更换为国内镜像是最为常见且效果显著的方法之一。
5. 使用非官方镜像可能在某些情况下导致与官方registry同步存在延迟，因此在发布新包时应谨慎选择镜像源。

### npm代替品😂

Node.js生态系统中的包管理和执行相关

**npm** (Node Package Manager)：

- 是Node.js的默认包管理器，用于JavaScript项目中安装、共享和管理依赖包。npm可以创建、发布和安装Node.js模块（软件包）。它还提供了生命周期脚本、版本管理、依赖关系解决等功能。

1. **yarn**：
   - 是一个与npm类似的包管理器，由Facebook等公司开发。Yarn通过引入锁定文件(`yarn.lock`)确保了跨机器和跨团队的一致性，并采用了高效的请求处理和缓存策略，提升了依赖安装速度和稳定性。此外，yarn也强化了安全性和协作流程。

2. **cnpm**：
   - 是npm在中国的镜像站点，由阿里巴巴团队维护。由于网络原因，直接使用npm从国外官方仓库下载可能速度较慢或者不稳定，cnpm通过镜像同步npm的全部资源，供国内开发者快速、稳定地下载Node.js依赖包。
   - [npmmirror 镜像站](https://npmmirror.com/)

3. **pnpm**：
   - 是另一种高性能的Node.js包管理器，其特色在于利用硬盘上的磁盘空间实现全局缓存，并通过硬链接技术避免重复安装同一依赖的不同版本。这不仅节省存储空间，同时也提高了安装和更新依赖的速度，尤其是在大型项目中表现优秀。

4. **npx**：
   - 自npm 5.2.0版本开始内置的一个命令行工具，它允许开发者在不全局安装的情况下运行npm包中的可执行文件。npx可以根据当前项目环境临时下载并执行所需要的npm包，简化了一次性使用某个包或执行特定脚本的过程。

- 总的来说，这些工具都服务于Node.js生态系统的不同需求
  - npm作为基础包管理工具，其他工具如yarn、pnpm则是在此基础上针对特定痛点优化或扩展而来；
  - cnpm着重于解决国内开发者访问npm资源的问题；
  - npx则是为了方便临时执行npm包中的命令而设计。

## 老版本下载安装(deprecated)

- [How to Install Latest NodeJS and NPM in Linux (tecmint.com)](https://www.tecmint.com/install-nodejs-npm-in-centos-ubuntu/)

  - 本方式将nodejs 和 npm 一同下载

  

  









