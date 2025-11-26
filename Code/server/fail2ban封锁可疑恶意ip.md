[toc]



## abstract

项目主页:[GitHub - fail2ban/fail2ban: Daemon to ban hosts that cause multiple authentication errors](https://github.com/fail2ban/fail2ban)

archwiki:[Fail2ban - ArchWiki - Arch Linux 百科](https://wiki.archlinux.org.cn/title/Fail2ban)

- fail2bain-client(1):[fail2ban-client(1) — fail2ban — Debian testing — Debian Manpages](https://manpages.debian.org/testing/fail2ban/fail2ban-client.1.en.html)
- fail2bain(1):[fail2ban(1) — fail2ban — Debian experimental — Debian Manpages](https://manpages.debian.org/experimental/fail2ban/fail2ban.1.en.html)
- jail.conf(5):[jail.conf(5) — Arch 手册页 --- jail.conf(5) — Arch manual pages](https://man.archlinux.org/man/jail.conf.5#CONFIGURATION_FILES_FORMAT)
- fail2bain-regex(1):[fail2ban-regex(1) — fail2ban — Debian testing — Debian Manpages](https://manpages.debian.org/testing/fail2ban/fail2ban-regex.1.en.html)

## 测试工具

- itdog:[网站测速_网站速度诊断_HTTP速度测速_WEB速度测试_CDN测速_API测速_多线路速度测试_多地区速度测试](https://www.itdog.cn/http/)

## 安装

许多发行版的包管理器可以直接安装,例如archlinux

```bash
   pacman -S fail2ban
```

完整安装后,可以获得如下基本组件

```bash
#( 11/23/25@ 9:26PM )( cxxu@CxxuDesk ):/usr/bin
   ll fail2ban-*
-rwxr-xr-x 1 root root 1.4K Nov 17  2024 fail2ban-client
-rwxr-xr-x 1 root root  15K Nov 17  2024 fail2ban-python
-rwxr-xr-x 1 root root 1.3K Nov 17  2024 fail2ban-regex
-rwxr-xr-x 1 root root 1.4K Nov 17  2024 fail2ban-server
-rwxr-xr-x 1 root root 2.3K Nov 17  2024 fail2ban-testcases
```

有些不是必须的,例如宝塔面板安装的可能只有`fail2ban-client `以及`fail2ban-server`,其他组件可选,甚至man手册也是

另外,可选择手动安装方案,详见官方文档

### 创建别名

由于fail2ban(后面简称为f2b)提供的相关命令名字比较长,例如`fail2ban-client`,为了执行方便,可以参考配置如下别名

```bash
alias f2bc='fail2ban-client'
alias f2bcs='fail2ban-client status'
```

如果要持久化,请写入到对应shell的`rc`配置中

## Configuration(配置文档)

下面提到的文档可以在线查阅

You can configure Fail2Ban using the files in `/etc/fail2ban`. It is possible to configure the server using commands sent to it by `fail2ban-client`. 

The available commands are described in the `fail2ban-client(1)` manpage. Also see `fail2ban(1)` and `jail.conf(5)` manpages for further references.

## 简介

fail2ban——一套用于限制暴力破解身份验证尝试的服务器和客户端程序。

Fail2ban 的工作原理是监控日志文件 （例如 /var/log/auth.log、/var/log/apache/access.log 等） 中的特定条目，并根据这些条目运行相应的脚本。  最常见的用途是阻止可能属于试图入侵系统安全的特定主机的 IP 地址 。它可以封禁在管理员设定的时间范围内进行过多登录尝试或执行任何其他恶意操作的主机 IP 地址。它同时支持 IPv4 和 IPv6。

对于屡次作案的“惯犯”，可以自定义配置更长的封禁时间。  Fail2Ban 通常设置为在一定时间内解除被封禁主机的封禁，以避免“锁定”任何可能暂时配置错误的正常连接。然而，**几分钟的解封时间通常足以阻止恶意连接对网络连接的泛洪 ，并降低字典攻击成功的可能性**。

当检测到滥用 IP 地址时，Fail2Ban 可以执行多种操作：  更新 Netfilter / iptables 或 PF 防火墙规则、 TCP Wrapper 的 hosts.deny 表，以拒绝滥用者的 IP 地址；发送电子邮件通知；或任何用户定义的、可通过 Python 脚本执行的操作。

标准配置包含常用的过滤器，例如 Apache 、 Lighttpd 、 sshd 、 vsftpd 、 qmail 、 Postfix 和 Courier Mail Server 。  

**过滤器由 Python 正则表达式定义**，熟悉正则表达式的管理员可以方便地对其进行自定义。  

### 隔离区

**过滤器和操作的组合称为“隔离区”**，它可以阻止恶意主机访问指定的网络服务。  

除了软件附带的示例之外，还可以为**任何会生成访问日志文件的网络进程创建“隔离区”**。 

Fail2ban 与 DenyHosts 类似 但与专注于 SSH 的 DenyHosts 不同，fail2ban 可以配置为监控任何将登录尝试写入日志文件的服务，并且 fail2ban 不仅可以使用 /etc/hosts.deny 来阻止 IP 地址/主机，还可以使用 Netfilter/iptables 和 TCP Wrappers /etc/hosts.deny 。

### 基本组成

Fail2Ban 由**客户端、服务器和配置文件**组成(三大部分)，用于限制暴力破解身份验证尝试。

服务器程序 **fail2ban-server** 负责监控日志文件并发出封禁/解封命令。它通过 **fail2ban-client** 的简单协议进行配置，**fail2ban-client** 还可以读取配置文件并向服务器发出相应的配置命令。

### 详情

有关 fail2ban 配置的详细信息，请参阅 `jail.conf(5)` 手册页。一个 jail（如 jail.conf 中所述）将过滤器和操作定义结合起来，用于监控任何给定的文件列表。

有关 fail2ban-server 的命令行选项的详细信息，请参阅 `fail2ban-server(1)` 手册页。

有关通过 fail2ban-client 配置服务器的命令行选项和命令的详细信息，请参阅 `fail2ban-client(1)` 手册页。

对于测试过滤器中指定的正则表达式，可以使用 `fail2ban-regex` 程序，其手册页为 `fail2ban-regex(1)`。



### 局限性

Fail2Ban 可以降低错误身份验证尝试的次数，**但无法消除弱身份验证带来的风险**。如果真的想保护服务，请将服务配置为仅使用双因素身份验证或公钥/私钥身份验证机制。

本地用户能够向系统日志 (syslog) 中注入消息，并利用读取系统日志的 Fail2Ban jail，**有效地对任何 IP 地址发起拒绝服务 (DoS) 攻击**。请务必了解此风险，并相应地配置 Fail2Ban 或授予 shell 访问权限。



## 基本概念

1. **什么是 Fail2ban**
    Fail2ban 是一个开源的 入侵预防 (intrusion prevention) 框架，用 Python 编写，可以在 Linux/类 Unix 系统上运行。它通过监控日志文件 (log files) 来检测可疑活动（如暴力破解、重复错误请求等），然后执行某些动作 (actions)，比如封禁 IP。 

2. **核心思想**

   1. Fail2ban 会扫描指定日志 (**logpath**) 中是否有与 “过滤规则 (**filter**)” 匹配 (**match**) 的条目；
   2. 如果某个 IP 地址在单位时间内 (**findtime**) 多次触发这些规则 (超过 **maxretry**)，就认为是可疑行为；
   3. 然后 Fail2ban 执行一个或多个 动作 (**action**)，**最常见**的是通过防火墙 (iptables、nftables 等) 封禁该 IP 一段时间 (**bantime**)。 

3. **Jail (监狱)**
    在 Fail2ban 中，**jail** 是一个非常重要的概念，它表示一个 “**监控单元 (unit)**” — 也就是一种策略 (policy)，由三部分组成：

   一个名称 (jail name)、一个 filter (过滤规则)、一个 action (动作)，还有其他配置如日志路径、重试次数等。 

4. **Filter(过滤器)**
    Filter 是一组**正则表达式** (regular expressions, regex)，用于**在日志中匹配可疑条目**。Fail2ban 会将日志中的每一行与 filter 中定义的 `failregex` (失败正则) 对比，还可以定义 `ignoreregex` 来忽略某些日志。

   > 所谓"失败正则(failregex)"中的"失败"是指可疑的恶意请求或验证失败的行为,即failregex是用于匹配**失败尝试**的正则表达式 。

5. **Action (动作)**
    当某个 IP 被判定为“违反规则”时，Fail2ban 会执行一个 action，例如发邮件 (notification)、写日志、通过防火墙 (`iptables`, `nftables`) 来封禁 IP。不同的 action 可以组合使用。  

### **主要参数**

- `bantime`：封禁 (ban) 的时间长度。可以使用秒 (s)、分钟 (m)、天 (d) 等单位。  
- `findtime`：时间窗口，在这个时间范围内如果失败次数超过 `maxretry` 就会触发封禁。 
- `maxretry`：单位时间窗口内，最大允许失败 (match) 次数。  
- `ignoreip`：白名单 IP，Fail2ban 不会封禁这些 IP。  
- `backend`：用于读取日志的后端方式 (如 `auto`)。

### 配套常用工具

1. **fail2ban-client**
    这是 Fail2ban 提供的命令行工具 (client)，用于管理和查看 Fail2ban 服务。可以查看状态 (status)、列出已封禁 IP、解封 (unban) IP、重新加载配置等。 
2. **fail2ban-regex**
    这是一个非常有用的工具，用来测试一个 filter (正则) 在给定日志文件上的匹配效果。你可以通过 `fail2ban-regex <日志路径> <filter 文件>` 来验证你的规则是否能正确地识别可疑条目。 

### jail配置文件分布

- 默认配置文件是 `/etc/fail2ban/jail.conf`。但不建议直接修改这个文件，因为升级时可能被覆盖。 
- 推荐创建 `jail.local` (通常在 `/etc/fail2ban/jail.local`) 来进行自定义配置。这样升级时更安全。  
- 还可以在 `/etc/fail2ban/jail.d/` 里创建单独的 `.local` 文件，更细粒度地组织 jail。 

------

## 工作原理 (流程)

下面是 Fail2ban 的基本工作流程 (workflow)，帮助你理解它是如何从日志到封禁 IP 的：

1. **启动服务**
    系统中启动 `fail2ban` 守护进程 (daemon)，持续运行。
2. **加载配置**
    Fail2ban 读取其配置文件 (jail.conf、jail.local 及其他 `.local/.conf`) 来确定哪些 jail 启用，以及每个 jail 的行为 (filter, action, logpath, bantime 等)。
3. **监控日志**
    对于每一个启用 (enabled) 的 jail，Fail2ban 会监控其 `logpath` 指定的日志文件。使用 `backend` 参数确定监控方式 (例如 `auto`、轮询 (polling) 等)。
4. **匹配规则**
    每当日志文件有新的条目 (new lines)，Fail2ban 会将这些条目跟相应 jail 的 filter (`failregex` 和 `ignoreregex`) 进行正则匹配。
5. **计数失败**
    如果一个 IP 地址在 `findtime` 时间窗口内，通过 filter 匹配到失败条目的次数超过 `maxretry`，Fail2ban 就认为这个 IP 是可疑的。
6. **执行封禁动作**
    当条件满足时，Fail2ban 执行该 jail 定义的 action，如通过防火墙 (iptables, nftables) 封禁该 IP，或者发送通知邮件。
7. **解封 (可选)**
    一旦 `bantime` 到期，这个 IP 会被自动解封 (unban)。也可以手工通过 `fail2ban-client` 解封。
8. **管理操作**
   - `fail2ban-client status <jail>`：查看某个 jail 的状态 (失败次数、封禁 IP 等)  
   - `fail2ban-client banned`：列出所有已经被封禁的 IP。  
   - `fail2ban-client set <jail> unbanip <IP>`：解封某个 IP。  
   - `fail2ban-client reload`：重新加载配置 (比如你修改了 jail.local 后)。 

------



## fail2ban-client的基本使用

介绍一些基本的常用选项,详情参考:[fail2ban-client(1) — fail2ban — Debian testing — Debian Manpages](https://manpages.debian.org/testing/fail2ban/fail2ban-client.1.en.html)

这个工具的功能被划分了大致以下几块内容,可以看到功能还是比较完善

1. BASIC
2. LOGGING
3. DATABASE
4. JAIL CONTROL
5. JAIL CONFIGURATION
6. COMMAND ACTION CONFIGURATION
7. GENERAL ACTION CONFIGURATION
8. JAIL INFORMATION
9. COMMAND ACTION INFORMATION
10. GENERAL ACTION INFORMATION

了解相关选项,可以方便自动化

- 关于重启fail2ban,有两组命令
- 关于重载fail2ban配置,也有两组命令

重载和重启主要是ip计数器以及对已封ip是否解禁上有所区别,共同点是可以更新配置,让修改生效,当然重载速度会快些

重启会清空计数器,配合选项`--unban`可以解封ip

而重载一般不清空计数器也不解封(但是可以配合相关选项`--restart`,`--unban`)

### **`restart` (重启服务器)**

- **`restart`**: **重启**整个 **Fail2ban 服务器**。这意味着 Fail2ban 服务将完全停止然后重新启动，所有配置和状态（包括当前的封禁列表）都会被重置并从头开始加载。



### **`restart <JAIL>` (重启/重载特定监狱)**

- **`restart [--unban] [--if-exists] <JAIL>`**:
  - 这是一个用于重启指定 **监狱 (Jail)** 的命令。
  - 它实际上是命令 `reload --restart ... <JAIL>` 的**别名**，它的核心功能是通过重载（reload）来实现对特定监狱的完全重启。
  - **`<JAIL>`**: 你想要重启的**监狱的名称**（例如 `sshd`、`nginx-http-auth` 等）。
  - **`--unban`**: 如果指定此选项，在重启该监狱时，所有**当前被该监狱封禁的 IP 地址将被解封**。
  - **`--if-exists`**: 仅在指定的 **`<JAIL>` 存在**时才执行操作。

------



### **`reload` (重载配置 - 不重启服务器)**



**`reload [--restart] [--unban] [--all]`**:

- **`reload`** 的基本功能是**重载** Fail2ban 的配置文件，而**不重启整个 Fail2ban 服务器进程**。这通常用于应用对配置文件（如 `jail.local` 或过滤器文件）的更改。
- **`--all`**: 重载**所有**活动的监狱的配置。
- **`--restart`**: 如果指定此选项，它会激活所有受配置更改影响的**监狱的完全重启**。如果没有配置更改，或者没有指定 `--all`，它的行为可能因版本而异，但通常意味着让受影响的监狱进入“完全重启”状态以应用更改。
- **`--unban`**: 必须与 `--restart` 一起使用。如果在 `--restart` 模式下重启监狱，此选项将**解封**这些受影响监狱当前封禁的 IP 地址。

### `reload <JAIL>` (重载/重启特定监狱)

**`reload [--restart] [--unban] [--if-exists] <JAIL>`**:

- **`<JAIL>`**: 你想要重载或重启的**监狱的名称**。
- **`reload <JAIL>` (无其他选项)**: 仅重载指定监狱的配置，通常是为了让新的配置生效，而**不重置**其当前的封禁状态或计数。
- **`--restart`**: 如果指定此选项，则该命令会**完全重启**指定的监狱（而不是仅仅重载配置）。重启意味着监狱的状态（例如 IP 计数器）会被重置。
- **`--unban`**: 仅在 `--restart` 模式下有效，将**解封**该监狱当前封禁的所有 IP 地址。

------



### 🚀 **总结与区别**



| **命令**               | **作用目标**          | **效果**                                                  | **状态重置/IP解封**                |
| ---------------------- | --------------------- | --------------------------------------------------------- | ---------------------------------- |
| **`restart`**          | **整个服务器**        | 停止并启动 Fail2ban 服务                                  | **是**（所有监狱）                 |
| **`restart <JAIL>`**   | **特定监狱**          | 完全重启指定的监狱（是 `reload --restart <JAIL>` 的别名） | **是**（可配合 `--unban` 解封 IP） |
| **`reload`**           | **整个服务器配置**    | 应用新的配置文件，不停止服务器                            | 否（除非配合 `--restart`）         |
| **`reload --restart`** | **所有/受影响的监狱** | 重启受配置更改影响的监狱                                  | **是**（可配合 `--unban` 解封 IP） |

简而言之：

- 使用 **`restart`** 来重启**整个 Fail2ban 服务**。
- 使用 **`reload`** 来应用**配置更改**，**通常更快速且影响较小**。
- 使用 **`reload --restart <JAIL>`** 或其别名 **`restart <JAIL>`** 来**完全重置并重启**单个监狱，通常用于排除故障或在需要时重置监狱的内部状态。



## 配置文件🎈

认识fail2ban的配置文件是使用fail2ban的核心,对应于fail2ban工作流程中的3个基本概念

Fail2ban has four configuration file types:
Fail2ban 有四种配置文件类型：

- [*fail2ban.conf*](https://manpages.debian.org/experimental/fail2ban/jail.conf.5.en.html#fail2ban.conf)

  Fail2Ban global configuration (such as logging) 

  Fail2Ban 全局配置（例如日志记录）

- [*filter.d/\*.conf*](https://manpages.debian.org/experimental/fail2ban/jail.conf.5.en.html#filter.d/*.conf)

  Filters specifying how to detect authentication failures 

  用于指定如何检测身份验证失败的过滤器

- [*action.d/\*.conf*](https://manpages.debian.org/experimental/fail2ban/jail.conf.5.en.html#action.d/*.conf)

  Actions defining the commands for banning and unbanning of IP address 

  Actions定义 IP 地址封禁和解封命令的操作

- [*jail.conf*](https://manpages.debian.org/experimental/fail2ban/jail.conf.5.en.html#jail.conf)

  Jails defining combinations of **Filters** with **Actions**. 

  监狱(jail)定义了**过滤器(filter)**与**操作(actions)**的组合。换句话说,定义一个满足特定需要的监狱需要指定合适的filter和action

  用户可以实现创建一些filter和actions,然后组合特定的filter和action,构成一个jail

  总之,“监狱”（jail）配置，把 filter 和 action 组合起来，并**指定监控哪些日志、封禁策略等**。

### 自定义配置文件(conf文件)

配置文件中，`.conf` 文件是 Fail2Ban 自带的、默认提供的，不建议直接修改。推荐方式是通过 `.local` 文件来做定制化。这样升级时更安全(不被新版本的默认conf文件所覆盖,但是也要注意更新方式)

例如，如果您想启用 jail.conf 中指定的 `[ssh-iptables-ipset] jail`，请创建包含以下内容的 `jail.local` 文件。

```conf
[ssh-iptables-ipset]
enabled = true

```

在 `.local` 文件中，**只需指定要更改的设置，其余配置将首先从相应的 .conf 文件中解析**。(例如`a.local`继承`a.conf`中的配置)

#### 实现更复杂的配置(.d目录)

`jail.d/` 和 `fail2ban.d/`

除了 .local 目录外，对于 jail.conf 或 fail2ban.conf 文件，还可以有一个对应的 *.d/* 目录，其中包含其他 .conf 文件。

例如， *jail* 配置的顺序如下：

- `jail.conf`（主配置）
- `jail.d/*.conf`（按字母顺序）
- `jail.local`（用户覆盖）
- `jail.d/*.local`（按字母顺序） 

也就是说，所有 `.local` 文件都会在原始配置文件中的 .conf 文件和 .d 目录下的文件之后进行解析。

后解析的文件中的设置会优先于先前解析的文件中相同的条目。文件按字母顺序排列，

例如：

- *fail2ban.d/01_custom_log.conf* - 使用不同的日志路径
- *jail.d/01_enable.conf* - 用于启用特定的 jail
- *jail.d/02_custom_port.conf* - 更改 jail 的端口。

### 配置文件结构语法

f2b的四种配置文件具有相同的基本语法

包含多个节（section），节以 `[section name]` 的形式指定，并且包含 `name = value` 键值对。

对于可以接受多个值的 name 项，请用空格分隔值，或者将值放在单独的行中，并在第二个值之前的行首缩进一个空格。

#### includes|配置文件引入和包含🎈

配置文件可以包含其他配置文件（定义公共变量），**这通常用于过滤器(filter)和操作(action)**。此类包含关系在名为 `[INCLUDES]` 的部分中定义：(可以指定解析顺序)

before
表示指定的文件将在当前文件之前解析。

after
表示指定的文件将在当前文件之后解析。

> 与action引用不同,这里插入需要指定文件名及其扩展名

例如:

```ini
[INCLUDES]

before = paths-common.conf

after  = paths-overrides.local

```



#### 变量插值（interpolation）🎈

- 支持 Python 风格字符串插值(string interpolation)：`%(name)s`。 使用 Python 的“字符串插值”机制，允许其他定义，并且以后可以在其他定义中使用 `%(name)s`。
- 支持跨节引用：`%(section/parameter)s`。  
- `%(known/parameter)s`：引用 “已知的、最后一次定义”的值，这个机制让你在 `.local` 文件里扩展已有设置，而不是完全覆盖。 
- 对于 filter 或 action 的 “init” 参数（初始设置），也可以使用 `<known/parameter>` 语法进行扩展。 

#### 注释

- 使用 `#` 开始整行注释。  
- 使用 `; `（分号后加空格）作行内注释。但在某些老版本 Python 环境中（Python2.x），`; ` 只能用于第一行，因为库有 bug。

例如

```bash
#nginx-START
#[nginx]
[nginx-warn]
enabled = true
filter = nginx-warn                      ; 对应我们创建的 filter 名称（不带 .conf)
#action = iptables-multiport[name=nginx-404, port="http,https"] ;对于不使用cdn的网站,可以使用 iptables-multiport 动作
action = cloudflare ; 如果网站使用了cloudflare cdn,则使用 Cloudflare 动作或者其改版才能让ip封禁生效,否则系统防火墙看到的只有cdn节点ip,无法封禁真实攻击ip,即便nginx中的日志是解析后的真实ip
logpath = /www/wwwlogs/warn.log     ; 替换成你的 access.log 路径
maxretry = 2                             ; 设置n次失败触发封禁
findtime = 60                            ; 60 秒内统计次数
bantime = 30m                             ; 封禁时间(m分钟)
#nginx-END
```

更完整的说明另见它文或参考原文档,还可以参考fail2ban自带的过滤器的一些写法

### fail2ban中预设的.conf

fail2ban安装完自带一些实用的filter和action,分别存放在`filter.d`和`action.d`

进入到`/etc/fail2ban/filter.d`目录,里面存在许多常用规则,针对不同服务的`.conf`文件,可以拿来改造或参考配置的写法

------

### 失败正则(failregex)

failregex是用于**匹配失败尝试的正则表达式** 。

匹配可以日志的关键是编写正确的failregex,此正则并非普通正则,有fail2ban专用的一些占位符,称为**标准替换标签**(standard replacement tags),相关指南如下

[failregex@jail.conf(5) — fail2ban — Debian experimental — Debian Manpages](https://manpages.debian.org/experimental/fail2ban/jail.conf.5.en.html#failregex~2)

**标准替换标签**可以用作正则表达式的一部分：

```bash
<HOST> - IP 地址和主机名的常用正则表达式（如果 usedns 已启用）。Fail2Ban 将确定究竟是哪一个。
<ADDR> - IP 地址（包括所有系列）的正则表达式。
<IP4> - IPv4 地址的正则表达式。
<IP6> - IPv6 地址的正则表达式。
<DNS> - 用于匹配主机名的正则表达式。
<CIDR> - 用于匹配 CIDR（网络掩码的简单整数形式）的辅助正则表达式。
<SUBNET> - 用于匹配子网地址的正则表达式（IP/CIDR 格式，也匹配单个 IP，因此 /CIDR 部分是可选的）。
<F-ID>...</F-ID> - 用于捕获组目标标识符的自由正则表达式，用于禁止（而不是 IP 地址或主机名）。
<F-*>...</F-*> - 捕获命名组的自由正则表达式 存储在票据中，可在操作中使用。
```

## 配置jail

通常在jail.local文件中配置自定义监狱,每个监狱一个小节

jail.local中每个小节都可以引用或覆盖一些定义在jail.conf

### jail.conf文件

好的，我可以为您解释 **Fail2ban** 中 `jail.conf` 文件的作用以及它通常定义的内容。

🔒 Fail2ban 的 `jail.conf` 文件

`jail.conf` 是 Fail2ban **最主要的配置文件之一**，用于定义 Fail2ban 的核心功能，即 **Jail (监狱)**。

📄 文件作用

`jail.conf` 文件定义了 **Jail (监狱)**，它负责将 **过滤器 (filter)** 和 **动作 (action)** 关联起来，从而实现针对特定服务日志的监控和响应。

简而言之，它的作用就是：**告诉 Fail2ban 应该监控哪些服务的日志，以及在发现恶意行为时应该采取什么行动。**



📝 `jail.conf` 中定义的主要内容

一个 Jail 的定义通常包含以下几个关键部分：

| **定义项**           | **作用描述**                                                 | **示例值/说明**                                     |
| -------------------- | ------------------------------------------------------------ | --------------------------------------------------- |
| **`[DEFAULT]`**      | **默认设置。** 定义适用于所有 Jail 的通用配置。              | `bantime`, `findtime`, `maxretry` 等。              |
| **`ignoreip`**       | **排除 IP 地址列表。** 这些 IP 不会被 Fail2ban 封禁（例如本地网络或您的固定 IP）。 | `127.0.0.1/8 192.168.0.0/24`                        |
| **`bantime`**        | **封禁时长。** 一个 IP 地址被封禁的时间长度（秒）。          | `10m` (10分钟), `1h` (1小时), `-1` (永久)           |
| **`findtime`**       | **时间窗口。** 在此时间窗口内（秒），如果达到最大重试次数，则触发封禁。 | `10m` (10分钟)                                      |
| **`maxretry`**       | **最大重试次数。** 在 `findtime` 期间，允许的最大失败次数。  | `5` (5次)                                           |
| **`destemail`**      | **通知邮件地址。** 用于接收 Fail2ban 警报邮件的地址。        | `admin@example.com`                                 |
| **`action`**         | **封禁动作。** 定义在触发封禁时执行的操作（如使用 `iptables` 阻挡 IP，或发送邮件）。 | `%(action_mw)s` (封禁并发送邮件)                    |
| **`[service_name]`** | **特定的 Jail 定义。** 针对某一具体服务（如 SSH、Apache、FTP）的配置块。 | `[sshd]`, `[apache-auth]`, `[vsftpd]`               |
| **`enabled`**        | **是否启用此 Jail。**                                        | `true` (启用) 或 `false` (禁用)                     |
| **`port`**           | **服务端口号。**                                             | `ssh` 或 `22`                                       |
| **`logpath`**        | **日志文件路径。** 此 Jail 监控的日志文件位置。              | `/var/log/auth.log` 或 `/var/log/apache2/error.log` |
| **`filter`**         | **使用的过滤器名称。** 引用 `filter.d/` 目录中定义的规则。   | `sshd` (对应 `filter.d/sshd.conf`)                  |

> **💡 最佳实践:**
>
> - 为了避免在 Fail2ban 升级时覆盖您的自定义设置，**强烈建议** 不要直接修改 `jail.conf`。
> - 正确的做法是创建一个名为 **`jail.local`** 的文件，并仅在此文件中定义您的自定义配置和启用的 Jail，这会覆盖 `jail.conf` 中的同名设置。

------



Action shortcuts

```bash
#
# Action shortcuts. To be used to define action parameter

# Default banning action (e.g. iptables, iptables-new,
# iptables-multiport, shorewall, etc) It is used to define
# action_* variables. Can be overridden globally or per
# section within jail.local file
#banaction = iptables-multiport
#banaction_allports = iptables-allports

# The simplest action to take: ban only
action_ = %(banaction)s[port="%(port)s", protocol="%(protocol)s", chain="%(chain)s"]

# ban & send an e-mail with whois report to the destemail.
action_mw = %(action_)s
            %(mta)s-whois[sender="%(sender)s", dest="%(destemail)s", protocol="%(protocol)s", chain="%(chain)s"]

# ban & send an e-mail with whois report and relevant log lines
# to the destemail.
action_mwl = %(action_)s
             %(mta)s-whois-lines[sender="%(sender)s", dest="%(destemail)s", logpath="%(logpath)s", chain="%(chain)s"]
...
```



### jail配置中对action配置的引用



action(s) from `/etc/fail2ban/action.d/` without the `.conf`/`.local` extension. 

从 `/etc/fail2ban/action.d/`目录中引用定义了action的文件(名),注意引用名不带有 `.conf/.local` 扩展名。 

Arguments can be passed to actions to override the default values from the `[Init]` section in the action file. Arguments are specified by: 

可以**向操作传递参数**，以覆盖操作文件中 `[Init]` 部分中的**默认值**。参数指定方式如下：

`[name=value,name2=value,name3="values,values"]`

Values can also be quoted (required when value includes a ","). More that one action can be specified (in separate lines).
值也可以用引号括起来（当值包含“,”时必须使用引号）。可以指定多个操作（分行指定）。

例如,fail2ban中自带的一个基础的action配置为`iptables.conf`,里面有一个部分是`[Init]`,这里定义的字段有详细的注释说明,包括取值类型和默认值

```ini

[Init]

# Option:  chain
# Notes    specifies the iptables chains to which the Fail2Ban rules should be
#          added. May be a single chain (e.g. INPUT) or a comma separated list
#          (e.g. INPUT, FORWARD)
# Values:  STRING  Default: INPUT
chain = INPUT

# Default name of the chain
#
name = default

# Option:  port
# Notes.:  specifies port to monitor
# Values:  [ NUM | STRING ]  Default:
#
port = ssh

# Option:  protocol
# Notes.:  internally used by config reader for interpolations.
# Values:  [ tcp | udp | icmp | all ] Default: tcp
#
protocol = tcp

# Option:  blocktype
# Note:    This is what the action does with rules. This can be any jump target
#          as per the iptables man page (section 8). Common values are DROP
#          REJECT, REJECT --reject-with icmp-port-unreachable
# Values:  STRING
blocktype = REJECT --reject-with icmp-port-unreachable

# Option:  returntype
# Note:    This is the default rule on "actionstart". This should be RETURN
#          in all (blocking) actions, except REJECT in allowing actions.
# Values:  STRING
returntype = RETURN

# Option:  lockingopt
# Notes.:  Option was introduced to iptables to prevent multiple instances from
#          running concurrently and causing erratic behavior.  -w was introduced
#          in iptables 1.4.20, so might be absent on older systems
#          See https://github.com/fail2ban/fail2ban/issues/1122
# Values:  STRING
lockingopt = -w

# Option:  iptables
# Notes.:  Actual command to be executed, including common to all calls options
# Values:  STRING
iptables = iptables <lockingopt>

```



## fail2ban-regex 测试filter规则🎈

使用`fail2ban`配套的规则检查工具

命令用法和帮助

- `fail2ban-regex [OPTIONS] <LOG> <REGEX> [IGNOREREGEX]`

```bash
   fail2ban-regex -h                                                                                              Usage: /usr/bin/fail2ban-regex [OPTIONS] <LOG> <REGEX> [IGNOREREGEX]
   ...
```

简单用例:

```bash
 fail2ban-regex ./demolog.log '^<HOST> - .*(?:GET|POST) .*(([.](css|png|jpg|jpeg|gif|ico))|/sitemap_.*xml|/product/) .*$'
```

如果能够对日志文件中的内容匹配成功,则会返回详细信息报告

### 简单用例

```bash
#( 11/25/25@10:07PM )( root@s1 ):/www/server/panel/vhost/nginx
   fail2ban-regex ./demolog.log '^<HOST> - .*(?:GET|POST) .*(([.](css|png|jpg|jpeg|gif|ico))|/sitemap_.*xml|/product/) .*$'

Running tests
=============

Use   failregex line : ^<HOST> - .*(?:GET|POST) .*(([.](css|png|jpg|jpeg|...
Use      single line : ./demolog.log


Results
=======

Failregex: 0 total

Ignoreregex: 0 total

Date template hits:

Lines: 1 lines, 0 ignored, 0 matched, 1 missed
[processed in 0.03 sec]

|- Missed line(s):
|  ./demolog.log
```

也可以通过文件提供过滤规则,下面给出一个更加复杂的针对性的测试

首先准备demo.log内容,摘自nginx日志

```nginx
66.249.69.161 - - [26/Nov/2025:08:25:32 +0800] "GET /product/meditub-53-fiberglass-whirlpool-walk-in-tub-for-alcove-installations-with-left-drain-drain-assembly-overflow-and-7-extension-panel-white-126334/ HTTP/1.1" 404 548 "-" "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
4.233.91.203 - - [26/Nov/2025:08:25:41 +0800] "GET /postnews.php HTTP/1.1" 404 31 "www.google.com" "Mozlila/5.0 (Linux; Android 7.0; SM-G892A Bulid/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/60.0.3112.107 Moblie Safari/537.36"
68.221.75.31 - - [26/Nov/2025:08:26:03 +0800] "GET /product/test-404/activilong-acticurl-curl-activator-gel-101400/ HTTP/1.1" 404 0 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ChatGPT-User/1.0; +https://openai.com/bot"
68.221.75.31 - - [26/Nov/2025:08:26:03 +0800] "GET /product/test-499/activilong-acticurl-curl-activator-gel-101400/ HTTP/1.1" 499 0 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ChatGPT-User/1.0; +https://openai.com/bot"
17.246.23.124 - - [26/Nov/2025:08:20:29 +0800] "GET /sitemap_more.xml HTTP/1.1" 404 146 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)"
68.221.75.31 - - [26/Nov/2025:08:26:03 +0800] "GET /product_404/activilong-acticurl-curl-activator-gel-101400/ HTTP/1.1" 404 0 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ChatGPT-User/1.0; +https://openai.com/bot"
68.221.75.31 - - [26/Nov/2025:08:26:03 +0800] "GET /product_499/activilong-acticurl-curl-activator-gel-101400/ HTTP/1.1" 499 0 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ChatGPT-User/1.0; +https://openai.com/bot"
66.249.81.129 - - [26/Nov/2025:06:13:14 +0800] "GET /wp-content/uploads/2025/SK0041026-IT20250915-083215-0-1757896339-img_340_057676.webp HTTP/1.1" 404 138 "-" "Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko Firefox/11.0 (via ggpht.com GoogleImageProxy)"
```

再看看针对404请求的封禁过滤器规则文件

```bash
# /etc/fail2ban/filter.d/nginx-warn.conf
[Definition]

# failregex: 匹配包含 404 的 Nginx 日志行，并提取 IP
# 可以借助fail2ban-regex 命令来测试正则表达式是否正确

# 下面的正则是一个比较通用示例，可能需要根据你的日志格式调整
# 默认的combined 日志格式参考如下
# 74.125.151.39 - - [23/Nov/2025:21:55:29 +0800] "GET /favicon.ico HTTP/1.1" 404 138 "https://www.domain.com/product/2306/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Safari/537.36"

failregex = ^<HOST> - .* ".*" 404 .*$

# 忽略某些正则 (可选)，比如静态资源文件，图片,css,sitemap以及产品链接 则不封禁
# ignoreregex = ^<HOST> - .* (?:GET|POST) .*\.(css|png|jpg|jpeg|gif|ico) .*$
# ignoreregex = ^<HOST> - .*(?:GET|POST) .*(([.](css|png|jpg|jpeg|gif|ico))|/sitemap_.*xml) .*$
# 如果检测到访问产品页面的404也忽略封禁(但是酌情使用,如果此路径规律被滥用,则启用上面的规则,严格程度依次递增,最严格情况下就是取消ignoreregex这个键值对的设立)
ignoreregex = ^<HOST> - .*(?:GET|POST) .*(([.](css|png|jpg|jpeg|gif|ico))|/sitemap_.*xml|/product/.*) .*$
```

利用`fail2ban-regex`(方便起见,我设置别名`alias fbregex=fail2ban-regex`)针对日志文件demo.log测试过滤器规则

```bash
$ fbregex demo.log /etc/fail2ban/filter.d/nginx-warn.conf

Running tests
=============

Use      filter file : nginx-warn, basedir: /etc/fail2ban
Use         log file : demo.log
Use         encoding : UTF-8


Results
=======

Failregex: 3 total
|-  #) [# of hits] regular expression
|   1) [3] ^<HOST> - .* ".*" 404 .*$
`-

Ignoreregex: 3 total
|-  #) [# of hits] regular expression
|   1) [3] ^<HOST> - .*(?:GET|POST) .*(([.](css|png|jpg|jpeg|gif|ico))|/sitemap_.*xml|/product/.*) .*$
`-

Date template hits:
|- [# of hits] date format
|  [8] Day(?P<_sep>[-/])MON(?P=_sep)ExYear[ :]?24hour:Minute:Second(?:\.Microseconds)?(?: Zone offset)?
`-

Lines: 8 lines, 3 ignored, 3 matched, 2 missed
[processed in 0.04 sec]

|- Ignored line(s):
|  66.249.69.161 - - [26/Nov/2025:08:25:32 +0800] "GET /product/meditub-53-fiberglass-whirlpool-walk-in-tub-for-alcove-installations-with-left-drain-drain-assembly-overflow-and-7-extension-panel-white-126334/ HTTP/1.1" 404 548 "-" "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
|  68.221.75.31 - - [26/Nov/2025:08:26:03 +0800] "GET /product/test-404/activilong-acticurl-curl-activator-gel-101400/ HTTP/1.1" 404 0 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ChatGPT-User/1.0; +https://openai.com/bot"
|  17.246.23.124 - - [26/Nov/2025:08:20:29 +0800] "GET /sitemap_more.xml HTTP/1.1" 404 146 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)"
`-
|- Missed line(s):
|  68.221.75.31 - - [26/Nov/2025:08:26:03 +0800] "GET /product/test-499/activilong-acticurl-curl-activator-gel-101400/ HTTP/1.1" 499 0 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ChatGPT-User/1.0; +https://openai.com/bot"
|  68.221.75.31 - - [26/Nov/2025:08:26:03 +0800] "GET /product_499/activilong-acticurl-curl-activator-gel-101400/ HTTP/1.1" 499 0 "-" "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ChatGPT-User/1.0; +https://openai.com/bot"
`-
```

如果过滤器没有语法上的错误(但要注意逻辑错误,比如缩写的正则能否符合预期效果,这是测试的重点),那么输出内容详细总结了过滤器的工作结果

其中的

```bash
# root @ s2 in /etc/fail2ban [9:07:15]
$ fbregex demo.log /etc/fail2ban/filter.d/nginx-warn.conf

Running tests
=============

Use      filter file : nginx-warn, basedir: /etc/fail2ban
Use         log file : demo.log
Use         encoding : UTF-8


Results
=======

Failregex: 3 total
|-  #) [# of hits] regular expression
|   1) [3] ^<HOST> - .* ".*" 404 .*$
`-

Ignoreregex: 3 total
|-  #) [# of hits] regular expression
|   1) [3] ^<HOST> - .*(?:GET|POST) .*(([.](css|png|jpg|jpeg|gif|ico))|/sitemap_.*xml|/product/).*
`-

Date template hits:
|- [# of hits] date format
|  [8] Day(?P<_sep>[-/])MON(?P=_sep)ExYear[ :]?24hour:Minute:Second(?:\.Microseconds)?(?: Zone offset)?
`-

Lines: 8 lines, 3 ignored, 3 matched, 2 missed
[processed in 0.04 sec]
```

表明,此次测试读取了demo.log文件中8行内容,其中有3行被`failregex`命中并且没有被忽略,而有3行被`failregex`命中但是被`ignoreregex`所忽略

```bash
Lines: 8 lines, 3 ignored, 3 matched, 2 missed
```

这里做最后的数量统计,顺便指出了没有被`failregex`匹配到的行有2行(`missed`)



## 封禁效果排查

虽然f2b的配置文件和规则细节不少,但是常见的标准需求需要改动或编写的f2b配置文件是很少的,一次性配置成功的概率很高

### 预排查

排查故障主要分为以下几个方面:

- filter的规则是否能够匹配日志文件中的日志
- action执行操作后ip是否封禁
- 查看日志` /var/log/fail2ban.log`中的关键动作

动态追踪f2b工作日志:

```bash
 tail -f /var/log/fail2ban.log
```

默认的内容格式示例

```bash
0:01
2025-11-24 15:10:02,032 fail2ban.actions        [174335]: NOTICE  [nginx-404] Ban 160.224.50.2
2025-11-24 15:10:02,077 fail2ban.filter         [174335]: INFO    [nginx-404] Found 202.76.187.176 - 2025-11-24 15:10:02
2025-11-24 15:10:06,008 fail2ban.filter         [174335]: INFO    [nginx-404] Found 45.90.61.71 - 2025-11-24 15:10:06
2025-11-24 15:10:07,219 fail2ban.filter         [174335]: INFO    [nginx-404] Found 89.104.110.143 - 2025-11-24 15:10:07
2025-11-24 15:10:07,678 fail2ban.filter         [174335]: INFO    [nginx-404] Found 176.53.220.194 - 2025-11-24 15:10:07
2025-11-24 15:10:12,087 fail2ban.filter         [174335]: INFO    [nginx-404] Found 202.76.183.251 - 2025-11-24 15:10:12
```

如果出现` already banned`这种记录就要警惕,是否是因为封禁无效导致所谓被禁ip仍然能够发送过来请求打到服务器这里

```bash
$ cat /var/log/fail2ban.log|grep already|tail
2025-11-24 08:11:39,360 fail2ban.actions        [174335]: NOTICE  [nginx-404] 91.92.243.58 already banned
2025-11-24 08:11:41,364 fail2ban.actions        [174335]: NOTICE  [nginx-404] 91.92.243.58 already banned
2025-11-24 08:35:44,437 fail2ban.actions        [174335]: NOTICE  [nginx-404] 146.70.198.93 already banned
```

一种常见的情况是配置的action忽视了cdn

使用 CDN 代理保护您的网站时，使用 **Fail2ban** 来监控 **Nginx 服务器日志**需要特别注意，因为 CDN 改变了客户端 IP 地址的来源。

最大的问题是：**Nginx 日志中记录的客户端 IP 不再是真实的访问者 IP，而是 CDN 节点的 IP。**

如果您不进行调整，Fail2ban 会错误地封禁 **CDN 节点的 IP**，导致**所有**通过该 CDN 节点访问的用户都被拦截，这会造成大规模的服务中断。

这里面细节比较多,这里仅提几个注意点

当使用 CDN 时，真实的客户端 IP 地址通常通过特定的 HTTP 请求头传递给您的源站服务器。最常见的是 `X-Forwarded-For` 或 `CF-Connecting-IP` (如果使用 Cloudflare) 等。

1. **配置 Nginx Real IP 模块：** 信任 CDN 的 IP 段，并使用如 `X-Forwarded-For` 头部将 `$remote_addr` 替换为真实客户端 IP。
2. **验证 Nginx 日志：** 确保日志中记录的 IP 是真实的访问者 IP。
3. **将 CDN IP 加入白名单：** 在 `ignoreip` 中添加 CDN 所有的 IP 段，防止误封。
4. 对接fail2ban到cdn相关api(例如cloudflare),由于fail2ban的依靠系统的iptables封禁ip,系统看到的ip是cdn的回源ip而不是真实用户的ip,即便nginx中解析出来真实的客户ip,但是这个ip是对nginx可见,而对系统iptables不可见,系统iptables始终只能看到cdn回源节点发转发来的请求;为了让封禁生效还必须将被封的ip对接到cdn,在cdn层面对黑名单ip进行封锁,关于这一点细节,另见其他章节展开

您必须修改 Nginx 配置，使其将真实的客户端 IP 记录到日志中，而不是记录 CDN 节点的 IP。

确保您的 Nginx 安装了 `http_realip_module` 模块（通常默认已安装，如果没有需要重新编译或安装）。

在您的 Nginx 配置（通常在 `http` 块或包含文件）中，指定 CDN 代理服务器的 IP 地址段，并告诉 Nginx 使用正确的头部替换客户端 IP。

确保您的 `log_format` 使用 `$remote_addr` 或 `$http_x_forwarded_for`，并且在上面的 `real_ip` 配置生效后，`$remote_addr` 变量会**被替换为真实的客户端 IP**。

**⚠️ 验证：** 在完成 Nginx 配置更改后，重启 Nginx 并查看日志文件，确保日志中的客户端 IP 字段现在显示的是您自己的 IP 地址，而不是 CDN 节点的 IP。

为了保险起见，**您应该将所有 CDN 节点的 IP 地址段添加到 Fail2ban 的白名单 (`ignoreip`) 中。**

### 手动封禁和解封指定ip测试方案

这部分讨论封禁实测,即尝试真实触发ip封禁(通常需要你有这个被测试ip的使用权,方便验证),然后用被封禁ip再次访问,看看会不会被禁止

这部分又分为两类:

- 使用`fail2ban-client`命令行手动直接封禁指定ip,然后验证封禁效果,最后同样可以使用此命令行工具解开封禁
- 通过登录到指定ip主机或者使用代理的方式使用指定ip,利用此ip刻意发送请求相关导致失败的请求(fail to ban),看看打到封禁条件后能否触发封禁,以及如果封禁后能否接着请求

如果您的网站对接了cdn(比如使用了cloudflare,还可以登录对应的账号,然后点击一个可用合适的域名,查看"安全性"模块下的安全规则,看看是否有fail2ban中设置的jail名称以及触发封禁的ip)

此外,如果服务器对接用到了多个cloudflare账号,需要仔细找到对应的账号再查看,关于如何在同一个服务器上对接多个cloudflare的fail2ban规则(主要是action定义和jail中对相应action的引用,详情另见它文)

## 案例: 封禁大量可疑404请求的 IP（Nginx 日志）

下面我们做一个完整示例：监控 Nginx 的 access 日志，当同一个 IP 连续请求导致 404 (Not Found) 错误时，每分钟封禁这个 IP。

### 1. 前提假设

- 你的 Nginx access 日志路径是 `/var/log/nginx/access.log`（或根据实际情况替换）；
- 你使用的是 Linux 防火墙 (iptables 或者 nftables)，且 Fail2ban 已安装；
- 你有权限编辑 `/etc/fail2ban` 下的配置文件。

### 2. 创建 Filter 规则

在 `/etc/fail2ban/filter.d/` 目录下，创建一个新的 filter，比如 `nginx-404.conf`：

```ini
# /etc/fail2ban/filter.d/nginx-404.conf
[Definition]

# failregex: 匹配包含 404 的 Nginx 日志行，并提取 IP
# 下面的正则是一个比较通用示例，可能需要根据你的日志格式调整
failregex = ^<HOST> - .* ".*" 404 .*$

# 忽略某些正则 (可选)，比如静态资源文件，图片、js、css 则不封禁
ignoreregex = ^<HOST> - .* "(GET|POST) .*\.(js|css|png|jpg|jpeg|gif|ico) .*$"
```

解释：

- `<HOST>` 是 Fail2ban 中一个特殊占位符，表示 “主机 (IP)”；
- `failregex` 匹配所有状态码是 404 的请求；
- `ignoreregex` 是可选的，用来排除某些请求 (比如请求静态文件)，避免误封。

### 3. 配置 Jail

配置jail时,需要注意你的网站是否走cdn,比如cloudflare,明确这一点很重要,需要据此选择或编写合适的action

#### 无cdn

编辑你的 `jail.local`（或在 `jail.d/nginx-404.local`）：

```ini
# /etc/fail2ban/jail.d/nginx-404.local
[nginx-404]

enabled = true
filter = nginx-404                      ; 对应上面我们创建的 filter 名称（不带 .conf）
action = iptables-multiport[name=nginx-404, port="http,https"]
logpath = /var/log/nginx/access.log     ; 替换成你的 access.log 路径
maxretry = 5                             ; 比如 5 次失败 (404) 触发封禁
findtime = 60                            ; 60 秒内统计次数
bantime = 1m                             ; 封禁时间 1 分钟
```

说明：

- `enabled = true` 表示启用这个 jail；
- `action = iptables-multiport[...]` 指定使用 iptables 来封禁 (如果你用 nftables，也可以配置成 nftables)；
- `maxretry = 5` + `findtime = 60` 意味着一个 IP 如果在一分钟内有 5 次 404，就会被封禁；
- `bantime = 1m` 意味着封禁 1 分钟。

你可以根据具体情况 (日志量、误报率) 调整 `maxretry`、`findtime` 与 `bantime`。

此`action`使用 iptables 封禁 IP，同时作用于多个端口：
`name=nginx-404`：规则链名称
`port="http,https"`：封禁**80 和 443 端口**（等价于 port=80,443）

#### 有cdn

这里以cloudflare提供的代理保护为例

重点是action属性的取值

```ini
#nginx-START
#[nginx]
[nginx-404]
enabled = true
filter = nginx-404                      ; 对应我们创建的 filter 名称（不带 .conf）
#action = iptables-multiport[name=nginx-404, port="http,https"]
action = cloudflare
logpath = /www/wwwlogs/warn.log     ; 替换成你的 access.log 路径
maxretry = 2                             ; 设置n次失败触发封禁
findtime = 60                            ; n 秒内统计次数
bantime = 5m                             ; 封禁时间(后缀m表示分钟),不带后缀默认单位是秒
#nginx-END
```



### 4. 测试你的 Filter

使用 `fail2ban-regex` 来验证你的正则是否工作：

```bash
sudo fail2ban-regex /var/log/nginx/access.log /etc/fail2ban/filter.d/nginx-404.conf
```

该命令会输出匹配 (matched) 和未匹配 (missed) 的日志行数。如果发现你的 filter 没有匹配到你预期的 404 日志，可能需要调整正则 (例如因为日志格式不同)。

### 5. 启动 / 重载 Fail2ban

- 启动或重启 Fail2ban 服务：

  ```bash
  sudo systemctl restart fail2ban
  ```

- 让 Fail2ban 重新加载配置 (如果你只是修改了 jail.local 或 filter)：

  ```bash
  sudo fail2ban-client reload
  ```

### 6. 检查状态和封禁情况

- 查看所有正在运行的 jail：

  ```bash
  sudo fail2ban-client status
  ```

- 查看 `nginx-404` 这个 jail 的状态：

  ```bash
  sudo fail2ban-client status nginx-404
  ```

  你会看到类似：

  ```
  Status for the jail: nginx-404
   |- Filter
   |  |- Currently failed: X
   |  `- Total failed: Y
   `- Actions
      |- Currently banned: Z
      `- Banned IP list: <some IPs>
  ```

- 若要解封某个 IP：

  ```bash
  sudo fail2ban-client set nginx-404 unbanip 1.2.3.4
  ```

------

## 小贴士与注意事项

- **不要修改默认的 `jail.conf`**：如上所说，应创建 `jail.local` 或 `.local` 文件，这样更安全，且避免升级覆盖。 ([ArchWiki](https://wiki.archlinux.org.cn/title/Fail2ban?utm_source=chatgpt.com))
- **避免误封**：根据你的真实流量情况调整 `maxretry`、`findtime`、`bantime`。过于严苛可能封禁正常用户 (false positives)。
- **排除静态资源**：通过 `ignoreregex` 排除图片、CSS、JS、图标等请求，可以减少误触发。
- **日志轮转 (logrotate)**：如果你的 Nginx 日志有轮转 (logrotate)，要确保 Fail2ban 能正确跟踪新的日志文件。通常 `backend = auto` 能帮助处理，但在某些环境下需要特别配置。
- **权限**：Fail2ban 需要读取日志文件 (logpath) 的权限，并且执行封禁动作 (如 iptables) 需要 root 权限。
- **监控和报警**：你可以配置 action，使封禁时发送邮件 (或使用其他通知方式)，及时知道哪些 IP 被封了。

