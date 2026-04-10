[toc]



# net use的命令使用指南

## abstract

在Windows系统管理中,net use命令是一个强大的工具。(虽然有点过时了,但是未来一段时间内还是很有用,兼容老一些的windows系统)

[Net use | Microsoft Learn](https://learn.microsoft.com/zh-cn/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/gg651155(v=ws.11))

这个手册已经在2016年停止维护(更新)

### 语法手册

#### 在线手册

- net use在线手册中共有三种用法

```cmd
net use [{<DeviceName> | *}] [\\<ComputerName>\<ShareName>[\<volume>]] [{<Password> | *}]] [/user:[<DomainName>\]<UserName>] [/user:[<DottedDomainName>\]<UserName>] [/user: [<UserName@DottedDomainName>] [/savecred] [/smartcard] [{/delete | /persistent:{yes | no}}]

net use [<DeviceName> [/home[{<Password> | *}] [/delete:{yes | no}]]

net use [/persistent:{yes | no}]
```

可以看到,第一种用法十分冗长

#### 本地手册

##### win7

net use命令行的帮助选项`/?`的输出和在线版有所不同

在win7老系统中输出如下内容

```
PS C:\Users\cxxu> net use /h
此命令的语法是:

NET USE
[devicename | *] [\\computername\sharename[\volume] [password | *]]
        [/USER:[domainname\]username]
        [/USER:[dotted domain name\]username]
        [/USER:[username@dotted domain name]
        [/SMARTCARD]
        [/SAVECRED]
        [[/DELETE] | [/PERSISTENT:{YES | NO}]]

NET USE {devicename | *} [password | *] /HOME

NET USE [/PERSISTENT:{YES | NO}]                                                                                        
NET USE 将计算机连接到共享资源或将计算机与共享资源断开。使用时如果没有选项，
它列出计算机的连接。

devicename       分配一个名称以连接到资源或指定断开的设备。有两种设备名称: 磁
                 盘驱动器(D: 至 Z:)和打印机(LPT1: 至 LPT3:)。键入星号替代指定
                 设备名称以分配下一种可用设备名称。
\\computername   为控制共享资源的计算机名称。如果该计算机名包含空白字符，则用
                 引号(" ")将双反斜杠(\\)和计算机名括起来。计算机名的长度可以
                 为 1 至 15 个字符。
\sharename       为共享资源的网络名称。
\volume          指定服务器上的 NetWare 卷。必须已安装了并正在运行 Netware
                 客户端服务(Windows Workstations)或 Netware 网关服务(Windows
                 Server)以连接到 NetWare 服务器。
password         为访问共享资源所需的密码。
*                产生密码提示。当在密码提示处键入密码时不显示它。
/USER            指定进行连接的另一个用户名。
domainname       指定其他域。如果忽略域，则使用当前已登录的域。
username         指定登录用的用户名。
/SMARTCARD       指定连接将使用智能卡上的凭据。
/SAVECRED        指定要保存用户名和密码。该开关被忽略，除非命令提示用户名和密
                 码。/HOME            将用户连接到他们的主目录。
/DELETE          取消网络连接并从持续连接列表中删除该连接。
/PERSISTENT      控制持续网络连接的使用。默认为上次使用的设置。
YES              进行连接时将它们保存，并在下次登录时将它们恢复。
NO               不保存进行的连接或随后的连接；下次登录将恢复现有连接。使用
                 /DELETE 开关删除持续连接。

NET HELP 命令 | MORE 显示帮助，一次显示一屏。
```

##### win10

在win10中

```cmd
PS C:\Users\cxxu\Desktop> net use /?
此命令的语法是:

NET USE
[devicename | *] [\\computername\sharename[\volume] [password | *]]
        [/USER:[domainname\]username]
        [/USER:[dotted domain name\]username]
        [/USER:[username@dotted domain name]
        [/SMARTCARD]
        [/SAVECRED]
        [/REQUIREINTEGRITY]
        [/REQUIREPRIVACY]
        [/WRITETHROUGH]
        [[/DELETE] | [/PERSISTENT:{YES | NO}]]

NET USE {devicename | *} [password | *] /HOME

NET USE [/PERSISTENT:{YES | NO}]

```

##### win11

在win11中执行时,输出以下内容

```
PS [C:\Users\cxxu\Desktop]> net use /?|scb
The syntax of this command is:

NET USE
[devicename | *] [\\computername\sharename[\volume] [password | *]]
        [/USER:[domainname\]username]
        [/USER:[dotted domain name\]username]
        [/USER:[username@dotted domain name]
        [/SMARTCARD]
        [/SAVECRED]
        [/REQUIREINTEGRITY]
        [/REQUIREPRIVACY]
        [/WRITETHROUGH]
        [/TCPPORT:{0-65535}]
        [/QUICPORT:{0-65535}]
        [/RDMAPORT:{0-65535}]
        [/TRANSPORT:{TCP | QUIC} [/SKIPCERTCHECK]]
        [/REQUESTCOMPRESSION:{YES | NO}]
        [/BLOCKNTLM]
        [/GLOBAL]
        [[/DELETE] [/GLOBAL]]]

NET USE {devicename | *} [password | *] /HOME

NET USE [/PERSISTENT:{YES | NO}]
```

可以看到,随着系统的发展,`net use`命令的语法也发生了一定的改变,但总体上差不多

## 1. 连接或断开网络驱动器

这是net use最常用的功能之一,允许你将网络共享映射为本地驱动器。

### 基本语法

```
net use [设备名] [\\计算机名\共享名] [密码] [/user:[域名\]用户名] [/persistent:{yes | no}]
```

让我们逐一解析这个语法:

- `[设备名]`: 通常是一个驱动器号,如Z:
- `[\\计算机名\共享名]`: 网络共享的UNC路径
- `[密码]`: 访问共享所需的密码(如果有)
- `[/user:[域名\]用户名]`: 指定用于连接的用户账户
- `[/persistent:{yes | no}]`: 决定连接是否在重启后保持

### 自动重连和记住凭证

| 选项                     | 说明                                                         |
| ------------------------ | ------------------------------------------------------------ |
| /savecred                | Stores the provided credentials for reuse.                   |
| /persistent: {yes \| no} | Controls the use of persistent network connections.<br /> The **default** is **the setting used last**. <br />Deviceless connections are not persistent.<br /><br />The **Yes** saves **all connections as they are made**, and **restores** them at next logon.<br />The **No** does not save the connection **being made or subsequent connections**. **Existing connections are restored at the next logon**. <br />Use **/delete** to remove persistent connections.<br />也就是说,已经建立连接的盘符不会受`/persistent:no`的影响,只有正在创建的以及后续的连接才会生效(也就是不作自动重连,这样之前设定好的(或者默认最后建立的)要自动重连的连接就不会被覆盖掉)<br />一个net use 命令行中可能有三类情况:1.未使用`/persistent`选项(此时创立的连接到底会不会被重启自动重连取决于该连接是否是重启前的最后一个连接);2.使用了`/persistent:yes`选项,会记住创建成功的连接;3.使用`/persistent:no`创建连接,不会被记住,后续也不会,防止覆盖 |

例如向共享文件夹`\\server\share`创建的连接,最后一条成功创建的连接默认重启自动重连

`/persistent`选项在**在线文档**中的第一种语法和第三语法中都出现了

### 实例演示

####  基本连接

```
net use Z: \\server\share
```

这个命令将`\\server\share`映射到本地的Z:驱动器。如果共享不需要密码,这就足够了。

####  使用凭据连接

```
net use Z: \\server\share mypassword /user:mydomain\myusername
```

这个命令不仅映射了驱动器,还指定了访问共享所需的用户名和密码。

这里密码`mypassword`可以写在`/user:mydomain\myusername`之前或者之后,



####  断开连接

```
net use Z: /delete
```

当你不再需要某个网络驱动器时,可以使用这个命令断开连接。

####  非持久性连接

```
net use Z: \\server\share /persistent:no
```

这个命令创建一个非持久性连接,意味着在系统重启后,这个映射将不会自动重新建立。

### 高级技巧

1. 使用星号代替明文密码:
   ```
   net use Z: \\server\share * /user:mydomain\myusername
   ```
   这会提示你安全地输入密码,而不是在命令行中显示密码。

2. 连接到家目录:
   ```
   net use H: /home
   ```
   这个命令会自动连接到你的网络家目录(如果已在网络中配置)。

## 2. 显示网络连接信息

net use不仅用于创建连接,还可以用来查看现有的网络连接。

### 基本语法

```
net use [设备名 | *]
```

### 实例演示

####  显示所有连接

```
net use
```

这个命令会列出所有当前的网络连接,包括驱动器号、UNC路径和连接状态。

####  查看特定连接

```
net use F:
```

这会显示F:驱动器的详细连接信息。例如

```powershell
PS [C:\Users\cxxu\Desktop]> net use f:
Local name        F:
Remote name       \\front\share
Resource type     Disk
Status            OK
# Opens           2
# Connections     3
The command completed successfully.

```



### 输出解析

当你运行`net use`命令时,你会看到类似这样的输出:

```
状态       本地     远程                    网络

-------------------------------------------------------------------------------
OK           Z:     \\server\share          Microsoft Windows Network
OK                  \\server\printers       Microsoft Windows Network
```

这个输出告诉你:
- 连接的状态(OK表示正常)
- 本地驱动器号(如果已分配)
- 远程路径
- 使用的网络类型

## 3. 控制本地资源共享

除了连接到远程共享,net use还可以用于管理本地资源的共享。

### 基本语法

```
net use [\\计算机名\共享名 [密码 | *]] [/user:[域名\]用户名] [/home] [/delete] [{/persistent | /savecred}]
```

### 实例演示

####  连接共享而不分配驱动器

```
net use \\server\share
```

这个命令连接到网络共享,但不分配驱动器号。这在只需临时访问某些文件时很有用。

####  保存凭据

```
net use \\server\share /savecred
```

这个命令不仅连接到共享,还保存了凭据,使得future连接更容易。

####  删除所有连接

```
net use * /delete
```

这是一个强大的命令,它会断开所有网络连接。使用时要小心!

### 安全考虑

1. 避免在脚本中使用明文密码。使用`*`来提示输入密码,或使用更安全的方法如凭据管理器。

2. 定期review你的网络连接,删除不再需要的连接以减少安全风险。

3. 在共享公共场所的计算机上,使用`/persistent:no`选项来prevent自动重连。

