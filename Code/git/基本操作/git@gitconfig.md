[toc]

## abstract

- `git config` 是 Git 中用于配置 Git 工作环境参数的重要命令，它可以用来设置、查看和编辑 Git 的各种配置信息。

##  文档

- 中文[Git - git-config Documentation (git-scm.com)](https://git-scm.com/docs/git-config/zh_HANS-CN)

- 英文[git:git-config document](https://git-scm.com/docs/git-config?msclkid=9eadf23ad0eb11ec8e24a9f7ba0777ee)

### 基本格式

```bash
git config [--global | --system | --local] [key] [value]
```

- `--global`: 设置适用于用户主目录下的全局配置文件（通常是 `~/.gitconfig`），影响的是你在这个机器上所有的 Git 仓库。
- `--system`: 设置系统的全局配置文件（例如 `/etc/gitconfig`），影响的是所有登录此系统的用户的所有仓库。
- `--local`: 设置针对当前工作目录下的特定仓库的配置（`.git/config` 文件），只对当前仓库有效。
- `--worktree`:比较少用,详情参考文档

## 常用操作

### git config 命令行方式配置

#### 设置配置项

```bash
git config key value
```
例如，设置全局用户的姓名和电子邮件：
```bash
git config --global user.name "Your Name"
git config --global user.email you@example.com
```

#### 查看配置项

```bash
git config key
#例如
PS>git config http.proxy
http://localhost:10801
```
或者**查看某个层级的所有配置**

```bash
git config --list [--global | --system | --local]
```

- 查看全局层级内的gitconfig配置

  - ```bash
    PS>git config --list --global
    user.email=838808930@qq.com
    user.name=cxxu
    credential.helperselector.selected=wincred
    credential.https://gitee.com.provider=generic
    credential.https://github.com.provider=generic
    init.defaultbranch=main
    
    ```

- 查看系统范围内的gitconfig所有项目

  ```bash
  PS>git config --list --system
  diff.astextplain.textconv=astextplain
  filter.lfs.clean=git-lfs clean -- %f
  filter.lfs.smudge=git-lfs smudge -- %f
  filter.lfs.process=git-lfs filter-process
  filter.lfs.required=true
  http.sslbackend=openssl
  http.sslcainfo=C:/Program Files/Git/mingw64/ssl/certs/ca-bundle.crt
  core.autocrlf=true
  core.fscache=true
  core.symlinks=false
  pull.rebase=false
  credential.helper=manager
  credential.https://dev.azure.com.usehttppath=true
  init.defaultbranch=master
  ```

- 如果`.gitconfig`文件(通常是用户家目录)不存在或者被删除,则会报错

  - ```bash
    PS>git config --list --global
    fatal: unable to read config file 'C:/Users/<username>/.gitconfig': No such file or directory
    ```

    

#### 删除配置项

```bash
git config --unset [--global | --system | --local] key
```
例如，取消全局配置的用户名：
```bash
git config --global --unset user.name
```

#### 查找配置项来源

```bash
git config --get-regexp pattern

#例
[BAT:79%][MEM:34.44% (10.92/31.70)GB][21:18:19]
[~\Music]
PS>git config --get-regexp http*
http.sslbackend openssl
http.sslcainfo C:/Program Files/Git/mingw64/ssl/certs/ca-bundle.crt
credential.https://dev.azure.com.usehttppath true
credential.https://gitee.com.provider generic
credential.https://github.com.provider generic
http.proxy http://localhost:10801
https.proxy http://localhost:10801

[BAT:79%][MEM:35.58% (11.28/31.70)GB][21:28:20]
[~\Music]
PS>git config --get-regexp user*
credential.https://dev.azure.com.usehttppath true
user.email 838808930@qq.com
user.name cxxu
```
或
```bash
git config --show-origin key

#例
[BAT:79%][MEM:35.25% (11.17/31.70)GB][21:28:45]
[~\Music]
PS>git config --show-origin user.name
file:C:/Users/cxxu/.gitconfig   cxxu
```
这两个命令可以帮助你查找符合给定模式或特定键的配置项在哪里被定义。

#### 编辑配置文件😊

```bash
git config --edit [--global | --system | --local]
```
这会打开相应的配置文件供您直接编辑。



#### 示例

- 设置颜色输出：

  ```bash
  git config --global color.ui true
  ```

- 查看当前使用的 Git 版本：

  ```bash
  git config --get core.version
  ```

- 设置文本编辑器：

  ```bash
  git config --global core.editor "vim"
  ```

- 添加代理设置：

  ```bash
  git config --global http.proxy http://proxy.example.com:prot
  ```

- 删除代理设置：

  ```bash
  git config --global --unset http.proxy
  ```



### 直接编辑配置文件

- 直接编辑配置文件.config时,需要注意语法
  - [Git - git-config Documentation (git-scm.com)](https://git-scm.com/docs/git-config/zh_HANS-CN#_配置文件)

## 可配置的变量项目

- [Variables|Git - git-config Documentation (git-scm.com)](https://git-scm.com/docs/git-config/en#_variables)

### 配置代理😊

- [Configure Git to use a proxy (github.com)](https://gist.github.com/evantoli/f8c23a37eb3558ab8765) 

#### 全局代理设置

- 要在 Git 中配置代理，你可以使用 `git config` 命令来设置 HTTP(S) 代理。以下是具体的命令格式：

  全局设置（对所有仓库生效）：
  ```shell
  # 设置 HTTP 代理
  git config --global http.proxy 'http://proxy-user:proxy-password@proxy-host:proxy-port'
  # 或者，如果你不需要认证信息
  git config --global http.proxy 'http://proxy-host:proxy-port'
  
  # 设置 HTTPS 代理
  git config --global https.proxy 'https://proxy-user:proxy-password@proxy-host:proxy-port'
  # 或者，如果你不需要认证信息
  git config --global https.proxy 'https://proxy-host:proxy-port'
  ```

- 这里的 `proxy-user`、`proxy-password`、`proxy-host` 和 `proxy-port` 分别代表代理服务器的用户名、密码、主机地址和端口号。如果你的代理不需要身份验证，可以省略用户名和密码部分。

#### 全局取消代理设置

如果你想取消全局的代理设置，可以使用以下命令：
```shell
git config --global --unset http.proxy
git config --global --unset https.proxy
```

#### 局部设置（仅对当前仓库生效）

```shell
# 设置 HTTP 代理（局部）
git config --local http.proxy 'http://proxy-host:proxy-port'

# 设置 HTTPS 代理（局部）
git config --local https.proxy 'https://proxy-host:proxy-port'

# 取消局部设置
git config --local --unset http.proxy
git config --local --unset https.proxy
```


- 务必替换上述命令中的占位符为实际的代理服务器详细信息。同时，根据实际情况选择全局或局部配置。

  

### powershell和gitconfig代理间的冲突

- 如果没有设置过powershell代理,则无需关心这部分
  - 先关闭代理服务器(或到代理服务器的连接)
  - 可以打开cmd,然后执行git clone/pull/push 等操作,如果能够顺利进行,而powershell同样的命令无法进行而报端口错误,则考虑powershell移除2个环境变量:`$env:https_proxy`以及`$env:http_proxy`

- 经过实验,powershell中通过设置环境变量`$env:https_proxy`以及`$env:http_proxy`可以让许多cmdlet走代理,例如`Invoke-WebRequset`

- 而git 的许多命令,比如`pull`,`clone`,`push`可能会也会受到相应的影响

- ```bash
  #当前处于powershell,设置了$env:https_proxy和$env:http_proxy
  
  [BAT:100%][MEM:54.05% (4.22/7.80)GB][7:49:03 PM]
  [~\Desktop]
  PS>$env:https_proxy
  http://localhost:10801 #本地主机运行了模拟代理服务器的软件
  
  #检查gitconfig是否配置了代理(这里没有配置代理)
  [BAT:100%][MEM:60.48% (4.72/7.80)GB][8:17:07 PM]
  [~\Desktop]
  PS>git config --global --list
  credential.https://gitee.com.provider=generic
  
  #为了验证上述powershell环境变量对git 动作的影响,现在关闭该模拟软件,可以看到git clone动作失败,并且指出通过端口10801无法连接到服务器
  [BAT:100%][MEM:60.37% (4.71/7.80)GB][8:16:58 PM]
  [~\Desktop]
  PS>git clone https://gitee.com/xuchaoxin1375/configs.git
  Cloning into 'configs'...
  fatal: unable to access 'https://gitee.com/xuchaoxin1375/configs.git/': Failed to connect to localhost port 10801 after 2279 ms: Couldn't connect to server
  
  
  ```

现在关闭powershell的代理(两个环境变量移除)

- ```bash
  
  
  [BAT:100%][MEM:58.39% (4.55/7.80)GB][8:24:10 PM]
  [~\Desktop]
  PS>remove-item Env:\http_proxy
  
  [BAT:100%][MEM:58.44% (4.56/7.80)GB][8:24:27 PM]
  [~\Desktop]
  PS>remove-item Env:\https_proxy
  
  [BAT:100%][MEM:58.40% (4.55/7.80)GB][8:24:42 PM]
  [~\Desktop]
  PS>git clone https://gitee.com/xuchaoxin1375/configs.git
  Cloning into 'configs'...
  remote: Enumerating objects: 90, done.
  remote: Counting objects: 100% (90/90), done.
  remote: Compressing objects: 100% (79/79), done.
  ...
  ```



## 补充

### XDG

- [freedesktop.org - Wikipedia](https://en.wikipedia.org/wiki/Freedesktop.org)
  - freedesktop.org (fd.o)，以前称为 X Desktop Group (XDG)， 是一个致力于 X Window 系统 (X11) 和 Wayland 的自由软件桌面环境的互操作性和共享基础技术的项目在 Linux 和其他类 Unix 操作系统上。尽管 freedesktop.org 制定了互操作性规范，但它并不是一个正式的标准机构。
  - 该项目由为 Red Hat 工作的 GNOME 开发人员 Havoc Pennington 于 2000 年 3 月创立。广泛使用的基于 X 的开源桌面项目，例如 GNOME、KDE 的 Plasma Desktop 和 Xfce，正在与 freedesktop.org 项目合作。 2006 年，该项目发布了 Portland 1.0 (xdg-utils)，这是一组桌面环境的通用接口。  freedesktop.org 于 2019 年加入 X.Org 基金会。该项目的一些服务器由波特兰州立大学托管。

- XDG 是 "X Desktop Group" 或者后来称为 "XDG Desktop Specifications" 的缩写，它是一个标准化组织制定的一系列规范，用于指导桌面环境以及在 Unix-like 操作系统上运行的应用程序如何正确地组织用户的配置文件、数据文件和缓存文件等。

- XDG Base Directory Specification 是其中一项重要的规范，它建议应用程序应将用户数据按照以下结构存放：

  - **配置文件**：通过 `XDG_CONFIG_HOME` 指定，默认路径是 `${HOME}/.config`。
  - **数据文件**：通过 `XDG_DATA_HOME` 指定，默认路径是 `${HOME}/.local/share`。
  - **缓存文件**：通过 `XDG_CACHE_HOME` 指定，默认路径是 `${HOME}/.cache`。

  这样做的好处包括：

  1. 用户的数据和配置更加集中且易于管理。
  2. 应用之间不互相干扰，因为每个应用都在自己独立的子目录下保存数据。
  3. 用户可以在不同的系统或者重新安装时轻松备份和恢复自己的个性化设置和数据。

  这个规范旨在提高跨不同Linux发行版和其他遵循此规范的操作系统的可移植性和一致性。

### XDG_CONFIG_HOME

- `XDG_CONFIG_HOME` 是一个在 Linux 和类 Unix 操作系统中遵循 XDG Base Directory Specification（XDG 基础目录规范）的环境变量。

- 这个规范旨在定义用户特定配置文件和目录的标准放置位置，以保持用户主目录的整洁，并使得应用程序数据管理更为统一。

  `XDG_CONFIG_HOME` 变量指定了用户个人的配置文件目录。如果没有设置 `XDG_CONFIG_HOME`，则默认值通常是 `${HOME}/.config`。对于 Git 而言，如果设置了 `XDG_CONFIG_HOME`，Git 将在这个目录下查找其配置文件，而不是默认的 `~/.gitconfig`。

- 例如，如果你设置了 `XDG_CONFIG_HOME` 为 `/home/user/myconfigs`，Git 将会在 `/home/user/myconfigs/git/config` 寻找全局配置文件。不过要注意的是，Git 默认的行为并不直接使用 `XDG_CONFIG_HOME`，而是通过 `--global` 标志来指定全局配置文件路径，通常位于 `~/.gitconfig`。



###  powershell 开关脚本(函数)

```powershell

function Set-GitProxy
{
    <# 
    .synopsis
    打开或者关闭gitconfig的关于http,https的proxy的全局配置;操作完成后查看配置文件
    这里主要配置不需要认证信息的情况
    .DESCRIPTION
    # 设置 HTTP 代理
    git config --global http.proxy 'http://proxy-user:proxy-password@proxy-host:proxy-port'
    # 或者，如果你不需要认证信息
    git config --global http.proxy 'http://proxy-host:proxy-port'

    # 设置 HTTPS 代理
    git config --global https.proxy 'https://proxy-user:proxy-password@proxy-host:proxy-port'
    # 或者，如果你不需要认证信息
    git config --global https.proxy 'https://proxy-host:proxy-port'
    .example
     Set-GitProxy -status off
    .example
     Set-GitProxy -status on
    .example
    Set-GitProxy -status on -port 1099
    #>
    param(
        [ValidateSet('on', 'off')]    
        $status = 'on',
        $port = '10801',
        $serverhost = 'http://localhost'

    )
    $socket = "$serverhost`:$port"
    if ($status -eq 'on')
    {

        git config --global http.proxy $socket
        git config --global https.proxy $socket
    }
    elseif ($status -eq 'off')
    {   
        git config --global --unset http.proxy
        git config --global --unset https.proxy
    }
    
    Get-Content "$home/.gitconfig" | Select-String  "[http|https].proxy"
    # write-host (git config --global http.proxy)

}
```

