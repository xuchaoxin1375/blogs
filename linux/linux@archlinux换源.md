[toc]



## abstract

国内镜像源(archlinux)

- [archlinux | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/archlinux/)
- [archlinux镜像_archlinux下载地址_archlinux安装教程-阿里巴巴开源镜像站](https://developer.aliyun.com/mirror/archlinux)
- [Arch Linux - USTC Mirror Help](https://mirrors.ustc.edu.cn/help/archlinux.html)

## 配置镜像源

archlinux配置镜像十分简单,比ubuntu要简单

只需要修改 `/etc/pacman.d/mirrorlist`文件,在文件的最顶端添加合适的国内镜像：

例如清华源:

```ini
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```

又比如阿里源

```ini
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```

更新软件包缓存：

```
pacman -Syyu
```

两次 `y` 能避免从**损坏的**镜像切换到**正常的**镜像时出现的问题。

如果您从一个较新的镜像切换到较旧的镜像，以下命令可以降级部分包，以避免系统的部分更新。

```
pacman -Syyuu
```

## pacman的基本使用

我们为什么学习使用pacman?
在windows上安装ubuntu虚拟机或者使用wsl(默认选项是ubuntu)是常见操作,ubuntu使用apt,我们学习apt的使用这很合适

在windows上,使用Msys2模拟linux环境也是常见的操作,而msys2使用pacman,因此我们学习pacman的使用

> MSYS2 是一个轻量级的开发环境，主要用于为 Windows 提供类 Unix 环境。它是通过 MinGW-w64 和 Pacman 包管理器来构建的，Pacman 是 Arch Linux 的包管理工具。
>
> **Pacman** 是 **Arch Linux** 的原生包管理器，而 Arch Linux 本身以简洁、高效、灵活为特点。Pacman 的设计目标是提供快速的包管理和极简的系统更新流程，能够高效处理包的安装、升级、删除以及依赖管理。因此，MSYS2 选择 Pacman 作为包管理器，继承了 Arch Linux 强大的包管理机制。

比起apt,pacman通常可以轻易安装到最新版本的软件包,而且安装软件的速度比apt快速,深受许多用户的喜爱,但也由于软件包比较新,稳定性方面可能有不足,总体上流行程度不如apt,但是对于用户来说,两个包管理器都值得学习和掌握.

- **包管理器**：Pacman
  - 安装命令：`pacman -S <package>`
  - 更新命令：`pacman -Syu`
  - Pacman 让 MSYS2 成为一个强大的工具，适合需要使用 C/C++ 等开发工具的用户。

### pacman功能划分

```bash
# cxxu @ CxxuDesk in ~ [19:55:31]
$ pacman --help
usage:  pacman <operation> [...]
operations:
    pacman {-h --help}
    pacman {-V --version}
    pacman {-D --database} <options> <package(s)>
    pacman {-F --files}    [options] [file(s)]
    pacman {-Q --query}    [options] [package(s)]
    pacman {-R --remove}   [options] <package(s)>
    pacman {-S --sync}     [options] [package(s)]
    pacman {-T --deptest}  [options] [package(s)]
    pacman {-U --upgrade}  [options] <file(s)>

use 'pacman {-h --help}' with an operation for available options
```



## pacman -S管理软件

pacman最常用的选项是`-S`系列选项,用于 **安装软件包** 或 **更新现有软件包**,很多子选项可以同时使用

当然也可以搜索(`-s`)或查看某个包是否可用以及版本信息(`-i`)

安装/更新:

- 安装/更新软件包:`-S`默认行为就是安装软件包,如果已经安装则尝试更新
- 更新软件包数据库(软件列表):`-y, --refresh`
- 更新所有软件包版本`-u, --sysupgrade`(`-uu`是降级)

```bash
# cxxu @ CxxuDesk in ~ [19:55:35]
$ pacman -S -h
usage:  pacman {-S --sync} [options] [package(s)]
options:
  -b, --dbpath <path>  set an alternate database location
  -c, --clean          remove old packages from cache directory (-cc for all)
  -d, --nodeps         skip dependency version checks (-dd to skip all checks)
  -g, --groups         view all members of a package group
                       (-gg to view all groups and members)
  -i, --info           view package information (-ii for extended information)
  -l, --list <repo>    view a list of packages in a repo
  -p, --print          print the targets instead of performing the operation
  -q, --quiet          show less information for query and search
  -r, --root <path>    set an alternate installation root
  -s, --search <regex> search remote repositories for matching strings
  -u, --sysupgrade     upgrade installed packages (-uu enables downgrades)
  -v, --verbose        be verbose
  -w, --downloadonly   download packages but do not install/upgrade anything
  -y, --refresh        download fresh package databases from the server
                       (-yy to force a refresh even if up to date)
      --arch <arch>    set an alternate architecture
      --asdeps         install packages as non-explicitly installed
      --asexplicit     install packages as explicitly installed
      --assume-installed <package=version>
                       add a virtual package to satisfy dependencies
      --cachedir <dir> set an alternate package cache location
      --color <when>   colorize the output
      --config <path>  set an alternate configuration file
      --confirm        always ask for confirmation
      --dbonly         only modify database entries, not package files
      --debug          display debug messages
      --disable-download-timeout
                       use relaxed timeouts for download
      --disable-sandbox
                       disable the sandbox used for the downloader process
      --gpgdir <path>  set an alternate home directory for GnuPG
      --hookdir <dir>  set an alternate hook location
      --ignore <pkg>   ignore a package upgrade (can be used more than once)
      --ignoregroup <grp>
                       ignore a group upgrade (can be used more than once)
      --logfile <path> set an alternate log file
      --needed         do not reinstall up to date packages
      --noconfirm      do not ask for any confirmation
      --noprogressbar  do not show a progress bar when downloading files
      --noscriptlet    do not execute the install scriptlet if one exists
      --overwrite <glob>
                       overwrite conflicting files (can be used more than once)
      --print-format <string>
                       specify how the targets should be printed
      --sysroot        operate on a mounted guest system (root-only)

```



### 基本命令结构

```
pacman -S <package_name>
```

- `pacman`: Pacman 包管理器的命令行工具。
- `-S`: 这个选项表示要 **安装** 或 **更新** 软件包。
- `<package_name>`: 要安装的软件包名称，可以是一个或多个。

### 主要功能

#### 1. 安装软件包

```bash
pacman -S <package_name>
```

这条命令将会从仓库中下载并安装指定的软件包。如果包已安装，`pacman` 会检查是否有更新，若有更新，会将其更新到最新版本。

- 例如，安装 `vim` 编辑器：

  ```bash
  pacman -S vim
  ```

  这会安装 `vim` 编辑器及其所有依赖包。

#### 2. 安装多个软件包

```bash
pacman -S <package1> <package2> <package3>
```

你可以一次性安装多个软件包，Pacman 会依次安装每个包，并确保安装所需的所有依赖包。

- 例如，安装 `git` 和 `curl`：

  ```bash
  pacman -S git curl
  ```

#### 3. 安装特定版本的包🎈

通过指定版本号，你可以安装特定版本的软件包。Pacman 支持包的版本管理，可以通过 `pacman -S` 命令安装某个版本的包。

- 例如，安装 `vim` 的某个特定版本：

  ```bash
  pacman -S vim=8.2.1234-1
  ```

  注意：这种方式依赖于软件包仓库中是否存在该版本。

#### 4. 安装包时解决依赖关系

当安装一个软件包时，Pacman 会自动解决和安装软件包的依赖关系。依赖包会自动下载并安装，不需要用户手动干预。

- 例如，安装一个软件包 `nodejs`，其可能依赖一些库文件，Pacman 会自动安装这些依赖项：

  ```bash
  pacman -S nodejs
  ```

#### 5. 安装本地软件包（从文件安装）

如果你有一个 `.pkg.tar.zst` 格式的本地软件包，可以使用 `-S` 选项来安装它。例如：

```bash
pacman -S /path/to/package.pkg.tar.zst
```

这种方式适用于安装从其他地方下载的包，或者从源码编译后打包的本地包。

#### 6. 更新所有已安装的包

如果你想更新所有已经安装的软件包，可以使用 `-Syu` 选项。它会同步仓库列表并更新所有包：

```bash
pacman -Syu
```

- `-y`: 更新软件包数据库，确保包列表是最新的。
- `-u`: 更新所有已安装的包。

#### 7. 安装包时避免自动安装某些依赖（不推荐）

Pacman 允许你通过 `--assume-installed` 参数指定一些已经手动安装或已经存在的依赖包，来避免自动安装它们。例如：

```bash
pacman -S --assume-installed <dependency> <package>
```

这对于某些特殊场景（比如你已经手动安装了某些库）是有用的，但通常不建议使用此选项。

### 搜索软件包

使用`-Ss`搜索软件包名

```bash
pacman -Ss <package>
```

但这会出现很多相关性不高的结果

```bash
$ pacman -Ss neovim
extra/bob 4.1.5-1
    A version manager for neovim
extra/neovide 0.15.2-2
    No Nonsense Neovim Client in Rust
extra/neovim 0.11.5-1 [installed]
    Fork of Vim aiming to improve user experience, plugins, and GUIs
extra/neovim-decasify 0.11.2-1
    cast strings to title-case according to locale specific style guides including Turkish (Neovim plugin)
extra/neovim-lspconfig 2.5.0-1 (neovim-plugins)
    Collection of common configurations for Neovim’s built-in language server client
extra/neovim-qt 0.2.19-1
    GUI for Neovim
extra/python-pynvim 0.6.0-1
    Python client for Neovim
```

通常我们想要的只有`extra/neovim 0.11.5-1`这样信息,表明neovim在仓库`extra`可用,并且版本为`0.11.5-1`

#### 提高搜索相关性

配合grep过滤出高相关性的结果

```bash
# cxxu @ CxxuDesk in ~ [20:27:07]
$ pacman -Ss vim|grep '/vim '
extra/vim 9.1.1908-1

# cxxu @ CxxuDesk in ~ [20:27:16]
$ pacman -Ss nginx|grep '/nginx '
extra/nginx 1.28.0-4
```

### 包信息查看

```bash
pacman -Si <package>
```

例如

```bash
$ pacman -Si neovim
Repository      : extra
Name            : neovim
Version         : 0.11.5-1
Description     : Fork of Vim aiming to improve user experience, plugins, and GUIs
Architecture    : x86_64
URL             : https://neovim.io
Licenses        : Apache-2.0  LicenseRef-vim
Groups          : None
Provides        : nvim  vim-plugin-runtime
Depends On      : libluv  libutf8proc  libuv  libvterm>=0.3.3  lua51-lpeg  luajit  msgpack-c  tree-sitter  tree-sitter-c  tree-sitter-lua  tree-sitter-markdown  tree-sitter-query  tree-sitter-vim  tree-sitter-vimdoc  unibilium
Optional Deps   : python-pynvim: for Python plugin support (see :help python)
                  xclip: for clipboard support on X11 (or xsel) (see :help clipboard)
                  xsel: for clipboard support on X11 (or xclip) (see :help clipboard)
                  wl-clipboard: for clipboard support on wayland (see :help clipboard)
Conflicts With  : None
Replaces        : None
Download Size   : 6.84 MiB
Installed Size  : 28.85 MiB
Packager        : Caleb Maclennan <alerque@archlinux.org>
Build Date      : Tue 04 Nov 2025 12:40:45 AM CST
Validated By    : SHA-256 Sum  Signature
```



### 常见用法

- 安装一个包：

  ```bash
  pacman -S vim
  ```

- 安装多个包：

  ```bash
  pacman -S vim git curl
  ```

- 安装软件包并解决依赖：

  ```bash
  pacman -S nodejs
  ```

- 安装本地包：

  ```bash
  pacman -S /path/to/package.pkg.tar.zst
  ```

## pacman -R 移除或卸载软件包

```bash
 pacman {-R --remove}   [options] <package(s)>
```

```bash
$ pacman -R -h
usage:  pacman {-R --remove} [options] <package(s)>
options:
  -b, --dbpath <path>  set an alternate database location
  -c, --cascade        remove packages and all packages that depend on them
  -d, --nodeps         skip dependency version checks (-dd to skip all checks)
  -n, --nosave         remove configuration files
  -p, --print          print the targets instead of performing the operation
  -r, --root <path>    set an alternate installation root
  -s, --recursive      remove unnecessary dependencies
                       (-ss includes explicitly installed dependencies)
  -u, --unneeded       remove unneeded packages
  -v, --verbose        be verbose
      --arch <arch>    set an alternate architecture
      --assume-installed <package=version>
                       add a virtual package to satisfy dependencies
      --cachedir <dir> set an alternate package cache location
      --color <when>   colorize the output
      --config <path>  set an alternate configuration file
      --confirm        always ask for confirmation
      --dbonly         only modify database entries, not package files
      --debug          display debug messages
      --disable-download-timeout
                       use relaxed timeouts for download
      --disable-sandbox
                       disable the sandbox used for the downloader process
      --gpgdir <path>  set an alternate home directory for GnuPG
      --hookdir <dir>  set an alternate hook location
      --logfile <path> set an alternate log file
      --noconfirm      do not ask for any confirmation
      --noprogressbar  do not show a progress bar when downloading files
      --noscriptlet    do not execute the install scriptlet if one exists
      --print-format <string>
                       specify how the targets should be printed
      --sysroot        operate on a mounted guest system (root-only)
```

其中的常用选项

```bash
-n, --nosave         remove configuration files
-s, --recursive      remove unnecessary dependencies
                       (-ss includes explicitly installed dependencies)
```



### 小结

- **`pacman -R <package_name>`**: 移除指定软件包，不删除未使用的依赖。
- **`pacman -Rn <package_name>`**: 移除软件包，保留配置文件。
- **`pacman -Rns <package_name>`**: 移除软件包及其不再被其他包依赖的依赖包。(最常用)
- **`pacman -Rdd <package_name>`**: 强制移除软件包及所有依赖，忽略依赖关系。