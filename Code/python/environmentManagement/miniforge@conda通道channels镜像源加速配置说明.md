[toc]

## abstract

在使用 Miniforge 时，配置国内镜像源可以极大地提升下载网络速度。Miniforge 默认使用的是 **Conda-forge** 渠道，并且它内置了 **Mamba**（一个用 C++ 重写的更快的高性能包管理器）。

因为 Miniforge 同时支持 `conda` 和 `mamba` 命令，它们的配置文件是**完全共用**的（都读取 `~/.condarc`）。

- [conda config — conda 25.1.1 文档 - Conda 包管理器](https://docs.conda.org.cn/projects/conda/en/stable/commands/config.html) 
- [Using the .condarc conda configuration file — conda 26.5.1.dev6 documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html)
- [Managing channels — conda documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-channels.html)

### 关于channels

Conda 通道(channels)是**存储软件包的位置**，也是**托管和管理软件包的基础**。

Conda 软件包从远程通道下载，这些**通道**是**指向包含 Conda 软件包的目录的 URL**。

conda 命令会搜索一组**默认通道**，软件包会自动从 [默认通道](https://repo.anaconda.com/pkgs/)下载和更新。

> 了解更多信息 [conda 频道](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/channels.html)及其各种使用服务条款。

不同的通道可以拥有相同的软件包，因此 conda 必须处理这些通道冲突。

- 如果您只使用**默认通道**，就不会出现通道冲突。
- 如果您使用的所有通道都只包含列表中其他通道中不存在的软件包，也不会出现通道冲突。

只有当您的通道列表中有**多个通道托管同一个软件包**时，conda 解决这些冲突的方式才会起作用。

默认情况下，conda 会**优先选择优先级更高的通道中的软件包**，而不是优先级更低的通道中的任何版本。

因此，现在您可以**放心地将通道放在通道列表的底部**，以**提供默认通道中未包含的额外软件包**，并且仍然可以确信这些通道不会覆盖核心软件包集。

### 优先级

Conda 会收集所有**已列出渠道中同名的所有软件包**，并按如下方式处理它们：

1. 按**通道优先级**从高到低对包裹进行排序。
2. 对**优先级相同**的软件包（即通道优先级相同的软件包）**按版本号从高到低排序**。例如，如果通道 A 包含 NumPy 1.12.0 和 1.13.1，则 NumPy 1.13.1 的排名更高。
3. 对优先级相同且版本相同的软件包（通道优先级相同）**按构建号从高到低排序**。例如，如果通道 A 同时包含 NumPy 1.12.0 的构建号 1 和构建号 2，则构建号 2 排在第一位。通道 B 中的所有软件包都将排在通道 A 中的软件包之后。
4. 安装排序列表中第一个满足安装要求的软件包

---

### conda-forge通道

conda `conda-forge` 通道可供所有人免费使用。您可以修改自动搜索的远程通道；此功能在维护私有或内部通道时非常有用。有关详细信息，请参阅如何 [修改通道列表 ](https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/settings.html#config-channels)。

我们以 conda-forge 通道为例进行说明。

 [Conda-forge](https://conda-forge.org/) 是一个由数千名贡献者组成的社区平台。Conda-forge 本身类似于 PyPI，但它拥有统一的自动化构建基础设施，并且对代码库进行更严格的同行评审。

## 安装软件包时指定通道

- 从命令行使用 `--channel`指定通道

```shell
$ conda install scipy --channel conda-forge
```

您可以通过多次传递参数来指定多个通道：

```shell
$ conda install scipy --channel conda-forge --channel bioconda
```

> 优先级从左到右递减——第一个参数的优先级高于第二个参数。

- 在命令行中使用 `--override-channels` 参数 ，可以**仅搜索指定的通道，而不会搜索 `.condarc` 文件中配置的任何通道**。此操作也会**忽略 conda 的默认通道**。

```shell
$ conda search scipy --channel file:/<path to>/local-channel --override-channels
```

- 在 `.condarc` 文件中，使用键 `channels` 可以查看 conda 要搜索软件包的通道列表。

```shell
 conda config --show channels
channels:
  - conda-forge
```

其他:

`default_channels`

```SHELL
 conda config --show default_channels
default_channels:
  - https://repo.anaconda.com/pkgs/main
  - https://repo.anaconda.com/pkgs/r
  - https://repo.anaconda.com/pkgs/msys2
```

`custom_channels`

```shell
 conda config --show custom_channels
custom_channels:
  pkgs/main: https://repo.anaconda.com
  pkgs/r: https://repo.anaconda.com
  pkgs/msys2: https://repo.anaconda.com
  pkgs/pro: https://repo.anaconda.com
```

## 配置channels的参考文档(字段说明)

[config-channels -- Settings — conda  documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/settings.html#config-channels)

## 配置国内镜像

### 了解channels镜像

了解channels镜像服务提供需要满足的条件,以及通道镜像用户要怎么使用.:

[镜像通道 — Mirroring channels — conda documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/mirroring.html)

### channels

在 `.condarc` 文件中列出频道位置会覆盖 conda 的默认设置， conda 只按给定的顺序搜索其中列出的频道。

使用 `defaults` 可**自动包含所有默认频道**。

> 非 URL 频道会被解析为 Anaconda.org 用户或组织名称。您可以通过修改 `channel_alias` 来更改此设置，具体方法请参见 [channel_alias：设置频道别名 ](https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/settings.html#set-ch-alias)。默认值为 `defaults` 。

例如(最常见的就是一个`defaults`,其他形式比较少.)

```yaml
channels:
  - <anaconda_dot_org_username>
  - http://some.custom/channel
  - file:///some/local/directory
  - defaults
```

> 通过添加 `nodefaults` 这个特殊channel来排除默认频道;
>
> 在这种情况下,就不需要指定`default_channels`,如同ustc提供的配置方案,只需要`custom_channels`

### channel_alias

```shell
 conda config --show channel_alias
channel_alias: https://conda.anaconda.org
```



### default_channels

使用 `default_channels` 可以覆盖[默认配置 ](https://docs.conda.io/projects/conda/en/latest/configuration.html)。例如：

```yaml
default_channels:
    - https://my-mirror.com/pkgs/main
    - https://my-mirror.com/pkgs/r
    - https://my-mirror.com/pkgs/msys2
```

### custom_channels

如：

```yaml
custom_channels:
    conda-forge: https://my-mirror.com/conda-forge
```

通过此配置，使用`conda-forge`通道时, 将从 `https://my-mirror.com/conda-forge` 查找。

### 对比 channels和custom_channels

| **配置项**             | **核心功能**                                                 | **相当于**                                                   |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **`channels:`**        | **默认的搜索路径列表**。当你没有在命令行指定 `-c` 参数时，Conda/Mamba 会**严格按照从上到下的顺序**去这些通道里找包。 | 你的**默认购物清单**（先去A店，再去B店）。                   |
| **`custom_channels:`** | **别名通道的重定向规则**。它本身**不会**增加默认搜索路径，只有当你显式指定了某个通道（如 `-c conda-forge`）时，它才会把原本指向国外的官方地址，偷偷**拦截并转发**到国内镜像。 | 你的**地图重定向手册**（如果你要去海外的“X商店”，它帮你自动导航到国内的“X商店分店”）。 |

------

### 匹配与运行逻辑对比

我们可以通过一个具体的安装命令，来看看它们是如何各司其职的：

假设你的配置如下：

```yaml
channels:
  - defaults

custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

场景 A：你运行 `mamba install numpy`（不加任何参数）

1. Mamba 发现你没指定通道，于是去查 `channels:`。
2. 看到里面有 `- defaults`，于是它去 `defaults` 仓库里找 `numpy`。
3. 此时，它**完全不会理会** `custom_channels` 下面的 `conda-forge`，因为你根本没调用它。

场景 B：你运行 `mamba install numpy -c conda-forge`（显式指定通道）

1. Mamba 看到你指定了 `-c conda-forge`。
2. 它**不会**去 `channels:` 列表里按顺序找，而是直接去查 `custom_channels:` 规则。
3. 它发现里面有一条：`conda-forge: https://mirrors.tuna...`。
4. 于是，它立刻把原本要发往国外官方 `anaconda.org/conda-forge` 的请求，拦截并发送给清华源。

------

### 3. 为什么不直接把所有地址写进 `channels:`？

你可能会想：*“既然 `custom_channels` 只是为了加速，那我为什么不直接把清华源的 `conda-forge` 地址直接写进 `channels:` 列表里呢？”*

像这样写：

```yaml
# 这种写法也可以，但不够优雅
channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
  - defaults
```

这样做虽然能用，但使用 `custom_channels:` 有以下两个无可比拟的优势：

- **保持命令的兼容性（最关键）**：许多开源项目的官方文档、GitHub 教程或自动化脚本中，都会写明 `conda install xxx -c conda-forge`。如果你配置了 `custom_channels`，你直接复制运行这行命令，它就能在后台自动享受国内加速。如果你没配 `custom_channels`，这条命令依然会顽固地跑去连接国外的官方服务器，导致卡死或报错。
- **配置更加整洁清晰**：`custom_channels` 只需要写到 `anaconda/cloud` 这一级根目录，Conda 就会自动在后面拼接 `conda-forge/win-64`、`pytorch/noarch` 等具体子目录，不需要你在 `channels:` 里把每一个长网址都罗列一遍。

### 总结建议

对于使用 **Miniforge** 的用户，最佳的实践是**两手都要抓**：

1. 在 `channels:` 中将 `conda-forge` 设为第一默认（因为 Miniforge 社区包最全）。
2. 在 `custom_channels:` 中为 `conda-forge` 和 `pytorch` 配置国内镜像路标。

这样既能保证不加 `-c` 参数时默认走国内最快的社区源，又能保证在复制别人带 `-c conda-forge` 的命令时绝不踩坑踩慢。

## 修改通道地址（Channels）

Miniforge 的核心是 `conda-forge` 通道，这与传统的 Anaconda（依赖 `defaults` 通道）不同。

因此，配置镜像时**最关键的是替换 `conda-forge` 的地址**。

国内主流的镜像源（如ustc,nju,tuna）都提供了对应的镜像。

以**清华源 (TUNA)** 为例，你需要配置以下几个主要通道：

- **`conda-forge`**：Miniforge 的核心仓库（必须配置）。
- **`msys2`**：Windows 环境下部分依赖包需要。
- **`bioconda`**：生物信息学相关（可选）。

### 默认通道说明

通过`mamba info`可以看到

```shell
# [pwsh][cxxu@CXXUCOLORFULWIN][~\Desktop][21:26:27]
 mamba info --no-rc

       libmamba version : 2.6.0
          mamba version : 2.6.0
           curl version : libcurl/8.20.0 Schannel zlib/1.3.2 libssh2/1.11.1 WinLDAP
     libarchive version : libarchive 3.8.7 zlib/1.3.2 liblzma/5.8.3 bz2lib/1.0.8 liblz4/1d
       envs directories : C:\Users\cxxu\.local\share\mamba\envs
          package cache : C:\Users\cxxu\.local\share\mamba\pkgs
                          C:\Users\cxxu\.mamba\pkgs
                          C:\Users\cxxu\AppData\Roaming\.mamba\pkgs
            environment : base
           env location : C:\Users\cxxu\.local\share\mamba
      user config files : C:\Users\cxxu\.mambarc
 populated config files :
       virtual packages : __win=10.0.19044=0
                          __archspec=1=x86_64_v3
               channels : https://conda.anaconda.org/conda-forge/noarch
                          https://conda.anaconda.org/conda-forge/win-64
       base environment : C:\Users\cxxu\.local\share\mamba
               platform : win-64
```

其中的俩个channels:

```http
https://conda.anaconda.org/conda-forge/noarch
https://conda.anaconda.org/conda-forge/win-64
```

其实就是 **Conda-forge 官方源（位于国外）** 针对不同操作系统架构的具体细分下载地址。

在 Conda 的底层逻辑中，一个完整的“通道（Channel）”会根据计算机的平台划分为不同的子目录：

- **`win-64`**：专门存放适用于 **Windows 64位系统** 的二进制包（包含编译好的 `.dll` 或 `.exe` 等平台相关文件）。
  - 如果你使用的是 Mac 或 Linux，这里对应的就会变成 `osx-64`、`osx-arm64` 或 `linux-64`。
- **`noarch`**：代表 **无架构相关（No Architecture）**。这里存放的是纯 Python 编写的包、文档或跨平台的配置，它们不需要针对特定操作系统进行编译，任何系统（Windows/Mac/Linux）下载的都是完全相同的包。

当你把官方源替换为国内镜像（如清华源、阿里源）时，**你不需要在配置文件里手动把 `win-64` 或 `noarch` 挨个写出来**。

因为 Conda/Mamba 非常智能，你只需要给它一个**根目录地址**，它会自动根据你当前的系统在网址后面加上 `/win-64` 或 `/noarch` 去匹配下载。

## channels配置案例解读

这份配置是一份非常经典且标准的 **Conda/Mamba 国内镜像源配置文件**（通常位于 `.condarc`）。

> tuna提供的conda(channels)镜像源配置示例

```yaml
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

>  由于商用问题,`defaults`通道在miniforge中不再是默认通道,而是`conda-forge`作为新的默认通道.

它的核心设计逻辑是：**表面上保留官方通道名称，底层全部悄悄替换为清华大学的国内镜像服务器。**

------

### 1. `channels` 模块

```yaml
channels:
  - defaults
```

- **解析**：`channels` 定义了 Conda 下载软件时的**最高优先级通道列表**。

- **含义**：这里只写了一个 `- defaults`(别名)，意思是让 Conda 默认去寻找官方的 `defaults`（基础）通道。

  > 使用 `defaults` 可自动包含所有默认频道。非 URL 频道会被**解析为 Anaconda.org 用户或组织名称**。您可以通过修改 `channel_alias` 来更改此设置，具体方法请参见 [channel_alias：设置频道别名 ](https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/settings.html#set-ch-alias)。默认值为 `defaults` 。

- **重点**：你可能会问，“只写 defaults，那不是全走国外官方了吗？” 别急，配合后面的 `default_channels` 设置，这里的 `defaults` 已经被**偷梁换柱**成国内清华源了。

  > 通常，**默认频道**会指向 `repo.anaconda.com` 仓库中的几个频道，但是如果 `default_channels` 已定义，用于设置**新的默认通道列表**。

------

### 2. `show_channel_urls` 模块

```yaml
show_channel_urls: true
```

- **解析**：是否显示通道的完整 URL 地址。
- **含义**：设置为 `true` 后，当你用 `mamba install` 或 `conda install` 安装包时，终端的提示列表里会明确显示每一个包是从哪个网址（例如清华源还是官方源）下载的。这非常有助于你**肉眼监控镜像源是否真的生效**。

------

### 3. `default_channels` 模块（核心修改 1）

```yaml
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
```

- **解析**：重定向第一步中 `defaults` 所包含的具体子通道。
- **含义**：官方的 `defaults` 实际上是由 `main`（核心官方包）、`r`（R语言相关包）和 `msys2`（Windows 补丁工具）等多个仓库组合而成的。
- **结果**：这段配置直接把这三个官方仓库的下载请求，全部拦截并重定向到清华大学的镜像服务器。

------

### 4. `custom_channels` 模块（核心修改 2）

```yaml
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

- **解析**：自定义第三方别名通道的重定向规则。
- **含义**：
  - **`conda-forge`**：使用 Miniforge，绝大多数包都来自 `conda-forge`。这行配置的意思是，只要系统或者你手动指定了 `-c conda-forge`，它就会自动去 `https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/` 下载。
  - **`pytorch`**：专门用于深度学习框架 PyTorch 的通道。当你要安装 GPU 版本的 PyTorch 并指定 `-c pytorch` 时，它会自动映射到清华的 PyTorch 镜像专区。

------

### 总结与针对 Miniforge 的使用建议

这份配置整体非常优秀，但对于 **Miniforge** 用户来说，有一个潜在的**小陷阱**需要注意：

Miniforge 的设计初衷是以 `conda-forge` 为核心，而不是官方的 `defaults`。

```yaml
channels:
  - defaults
```

这意味着 Mamba 每次会优先去清华的 `defaults`（也就是 Anaconda 官方同步过来的包）里面找。如果找不到，它才会根据 `custom_channels` 去找 `conda-forge`。

**优化建议：**

如果你希望完全发挥 Miniforge 的特性（以 `conda-forge` 社区包为主），建议将 `channels` 部分调整为 `conda-forge` 优先：

```yaml
channels:
  - conda-forge
  - defaults
```

这样配合你的 `custom_channels` 设置，Mamba 就会**第一优先级**速度飞快地去清华源下载 `conda-forge` 的包了！

------

##  配置方式

你有两种方式来应用这些国内镜像(本节简述,后面会再展开)：

### 直接修改配置文件

直接打开或创建用户目录下的 `.condarc` 文件（Windows 通常在 `C:\Users\用户名\.condarc`，Linux/Mac 在 `~/.condarc`）

> `~/.condarc`不是唯一的配置文件位置,但通常用户修改的配置就是这个文件

例如,通过`conda config --show-sources`列出所有配置文件及其有效配置项:

```shell
 conda config --show-sources
==> C:\scoop\apps\miniforge\current\.condarc <==
auto_activate: False
channels:
  - conda-forge

==> C:\Users\cxxu\.condarc <==
auto_activate: False
envs_dirs:
  - ~/.conda/envs
channels:
  - nodefaults
custom_channels:
  conda-forge: https://mirrors.ustc.edu.cn/anaconda/cloud
  bioconda: https://mirrors.ustc.edu.cn/anaconda/cloud
show_channel_urls: True
```



### 命令行方式

如果你不想手动改文件，也可以在终端执行以下命令：

```bash
# 添加清华的 conda-forge 镜像
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/

# 显示下载包时的来源网址（方便确认是否成功走镜像）
conda config --set show_channel_urls yes
```

------



## 配置conda/mamba国内源👺

- [Anaconda - USTC Mirror Help](https://mirrors.ustc.edu.cn/help/anaconda.html)(推荐)

- [anaconda | 镜像站使用帮助 | 北京外国语大学开源软件镜像站 | BFSU Open Source Mirror](https://mirrors.bfsu.edu.cn/help/anaconda/)
- [anaconda | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/)

最新的配置方法参考上述链接,下面的片段可能是过时的,仅供参考;

> miniforge用户优先按照mamba方案配置,速度较快.



### 科大源(ustc)

#### conda源

也可供mamba命令使用

```ini
channels:
  - nodefaults
custom_channels:
  conda-forge: https://mirrors.ustc.edu.cn/anaconda/cloud
  bioconda: https://mirrors.ustc.edu.cn/anaconda/cloud
show_channel_urls: true
```

> 通过添加 `nodefaults` 来排除默认频道.

#### mamba源

此外科大源还提供单独的`mamba`源简化版配置

> 这个mamba专用配置仅适用于mamba创建和管理的环境
>
> 如果混用conda命令,**可能会跳转其他域下导致错误**(比如403阻止下载).

适用于mamba的专用配置:

> `mirrored_channels:`字段是mamba专用的,conda不识别这个配置!

> ```ini
> channels:
>   - conda-forge
> mirrored_channels:
>   conda-forge:
>     - https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge
> ```



### 清华源(tuna)

> 部分ip可能属于限流ip,清华源可能遇到403阻止你下载包,具体自行尝试或更换其他源

- conda用户可以用清华源,
- 如果是mamba,清华源(tuna)可能不是很合适(容易报错,考虑科大源(ustc))

## `conda/mamba` 命令可在任何终端中使用

[GitHub - conda-forge/miniforge: A conda-forge distribution. · GitHub](https://github.com/conda-forge/miniforge#condamamba-usable-in-any-terminals)

Miniforge 为 [`conda`](https://conda.io/) 命令提供了安装程序， [`mamba`](https://github.com/mamba-org/mamba) 。一旦适用于您的操作系统和架构的安装程序运行完毕，您应该能够在终端中使用这些命令。

### windows

然而，在 Windows 安装程序的默认设置下，这些命令仅在“Miniforge 提示符”中可用。

要在其他终端中使用这些命令，有两种方案:

方案1:

在 Miniforge 提示符中运行命令来初始化 shell 的 conda。

```shell
conda init
```

方案2:

也可以直接添加 `C:\Users\myusername\miniforge3\condabin\` 文件夹 添加到路径环境变量，在任何命令提示符下都可以更方便地使用 `conda` 和 `mamba` ，并且软件冲突的可能性很小。

### *nix系统

在 Unix 系统上使用非交互式安装时也会出现同样的情况。可以通过调用 conda 并传入完整路径来完成初始化，

例如：

```shell
~/miniforge3/bin/conda init
```

## 配置源的方法

你可以通过修改 Conda 的配置文件 `.condarc` 来实现这个配置。这里有两种最常用的方法：**直接使用命令添加**（推荐，不易出错）或**直接编辑配置文件**。



### 使用 `conda config`或`mamba config` 命令

打开你的终端（Terminal 或 Anaconda Prompt），依次运行以下命令：

**添加官方的 `conda-forge` 渠道：**(conda和mamba都支持)

```shell
conda config --add channels conda-forge
# 或mamba config(语法不同)
mamba config append channels conda-forge
```

mamba config命令当前的功能有限,`libmamba` 使用纯 C++ 实现的配置系统，**`mamba config` 的 `append`/`set` 子命令只支持顶层扁平 key**（如 `channels`、`channel_priority` 等），不支持嵌套点语法（`mirrored_channels.conda-forge`）来访问深层结构。

`mirrored_channels` 是一个嵌套的 map-of-lists，CLI 目前无法直接用点语法操作其子键,需要其他方法(比如重定向写入内容)或者用文本编辑器直接编辑文件.

```powershell
# 将mamba专属配置写入到`~/.mambarc`中
# 移除旧值,防止重叠
mamba config get mirrored_channels #移除前看一眼
mamba config remove-key mirrored_channels #移除
# 添加
@"
mirrored_channels:
  conda-forge:
    - https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge
"@ | Add-Content "$env:USERPROFILE/.mambarc"
# end
```

### mamba检查所有配置及其来源

`config list --sources` 会显示每个配置项的值及其来源（如 `'CLI'`、`'~/.mambarc'` 等）。

```shell
 mamba config list --sources
envs_dirs:
  - C:\Users\cxxu\.conda\envs  # '~\.condarc'
  - C:\scoop\apps\miniforge\26.3.2-2\envs  # '~\.condarc'
channels:
  - conda-forge  # 'C:\scoop\apps\miniforge\current\.condarc'
mirrored_channels:
  conda-forge:
    - https://mirrors.bfsu.edu.cn/anaconda/cloud/conda-forge/  # '~\.mambarc'
    - https://conda.anaconda.org/conda-forge  # 'C:\scoop\apps\miniforge\current\.condarc'
    - https://prefix.dev/conda-forge  # 'C:\scoop\apps\miniforge\26.3.2-2\.condarc'
```



**小提示**：`conda config` 命令会自动创建或修改你的 `.condarc` 配置文件，并保证格式正确。

------

### 直接修改 `.condarc` 配置文件

如果你希望直接把这段内容复制进去，可以手动编辑配置文件：

1. **找到配置文件路径：**

   通常该文件位于你的用户家目录下:`~/.condarc`

2. **用文本编辑器打开并写入：**

   如果文件不存在，可以直接新建一个名为 `.condarc` 的文件。然后将镜像内容写入配置,注意如果原配置中有对应的字段,则应该注释掉或者覆盖相应片段!

#### 覆盖式配置

一键配置:(适用于bash,zsh),如果有其他配置,可以修改下面的命令然后再执行.

> 覆盖式执行原来的配置文件(如果有的话)会被覆盖.

```bash
# 以ustc提供的conda源为例(mamba源自行修改.)
cat << EOF > ~/.condarc
# create at $(date +%F-%T)
channels:
  - nodefaults
custom_channels:
  conda-forge: https://mirrors.ustc.edu.cn/anaconda/cloud
  bioconda: https://mirrors.ustc.edu.cn/anaconda/cloud
show_channel_urls: true
# end.
EOF
```



------

### 验证配置是否成功

配置完成后，你可以运行以下命令来查看当前的 Conda 配置，确认是否已经成功写入：

```shell
conda config --show channels
conda config --show mirrored_channels
```

或者直接查看完整的配置文件内容：

```shell
conda config --show-sources
```

## 清理旧索引

换源后务必执行一次：**强制清理旧索引** 

```shell
mamba clean -i
```



##  验证配置是否成功

配置完成后，你可以尝试安装一个包，观察打印出来的 URL 是否已经变成了国内镜像地址：

```bash
mamba install notebook
```

或者创建一个环境,使用详细模式输出中间过程,包括使用的通道链接(镜像)

` conda create -n scrapling python=3.13 -vvv`

```shell
...
DEBUG conda.gateways.repodata.zstd:download_repodata(84): https://mirrors.ustc.edu.cn/ana}
/ INFO conda.gateways.repodata.zstd:download_repodata(104): Download 34505348 bytes {'User-Agent': 'conda/26.3.2 requests/2.34.1 CPython/3.13.13 Windows/10 Windows/10.0.19044 solver/li}
DEBUG conda.gateways.repodata.zstd:timeme(52): Download complete https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/win-64/repodata.json Took 21.41s
DEBUG conda.gateways.repodata:__setitem__(494): Replaced non-str RepodataState[cache_control] with ""conda.org/nodefaults/win-64, prio: 3 : 1
DEBUG conda.conda_libmamba_solver.index:_set_repo_priorities(748): Channel: https://conda.anaconda.org/nodefaults/noarch, prio: 3 : 1
DEBUG conda.conda_libmamba_solver.index:_set_repo_priorities(748): Channel: https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/win-64, prio: 2 : 1
DEBUG conda.conda_libmamba_solver.index:_set_repo_priorities(748): Channel: https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/noarch, prio: 2 : 1
DEBUG conda.conda_libmamba_solver.index:_set_repo_priorities(748): Channel: installed, prio: 1 : 1
done
```



## FAQ

### 配置文件中注释引起的错误

尽量不要在配置中写注释,尤其是中文,容易引起配置解析失败

### Shard Index导致进度卡死问题(mamba源)

> 国内源用户需要注意,在较新版本的miniforge中,mamba的机制发生大的变换,如果使用的国内源没有更新`Shard Index`,则可能导致mamba操作卡住,消耗大量cpu却无法停止.

```shell
 mamba create -n main python
 
⚠ Shard Index for conda-forge/noarch not available, falling back to flat repodata
Using Flat Repodata for conda-forge/noarch                                                ✔ Done (5.7 sec)
⚠ Shard Index for conda-forge/win-64 not available, falling back to flat repodata
Using Flat Repodata for conda-forge/win-64                                                      ✔ Starting...

```

这种情况在我们考虑移除国内源的channels相关配置,走官方源反而更加快速.

或者不要用mamba,而是使用conda,兼容性更好,也采用了`libmamba`求解器.

## 备用源方案

## 自动降级方案

```yaml
channels:
  - https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/       # 首选：科大镜像
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/  # 备用：清华镜像（极速）
  - conda-forge                                                   #  兜底：官方源
```

> **原理：** Mamba 会优先请求清华源，如果清华源返回 404 或超时，它会立刻转向科大源，若还不行，则走官方 `conda-forge`。

## 临时强制使用官方源（不修改配置文件）

如果你发现平时用的国内源突然报错，你不想去改动配置文件，只想临时拉取一个包，可以直接在命令行中使用 `--channel` (或 `-c`) 参数，并加上 `--override-channels`（强制忽略配置文件中的国内源）。

```shell
# 使用 mamba 临时从官方源下载
mamba install numpy -c conda-forge --override-channels

# 或者使用 conda
conda install numpy -c conda-forge --override-channels
```

### `-c, --channel CHANNEL`

> 用于搜索包的额外通道（Channel）。
>
> Conda 会按照输入的先后顺序依次检索这些 **URL**（支持使用 `file://` 语法的本地目录，或诸如 `/home/conda/mychan`、`../mychan` 的直接路径）。
>
> 随后，Conda 会继续检索默认通道或 `.condarc` 配置文件中固化的通道`channels`（除非指定了 `--override-channels` 参数）。
>
> 你可以使用 `'defaults'` 来获取 Conda 的默认宏包。你也可以直接使用任何通道名称，Conda 会自动在其前面拼接 `.condarc` 中配置的 `channel_alias`（通道别名'`channel_alias`'）前缀。
>
> 默认的通道别名为 `https://conda.anaconda.org/`。
