[toc]

## windows系统下的简单共享文件方案👺



windows系统下局域网内传输文件的简单方法有2中,其中最简单的是NearBy Sharing(就近共享)

另一种是共享文件夹,更加通用和强大,支持老系统,和非windows系统访问资源

### 就近共享

支持单个和多个文件共享,配置最简单,但是要求传输文件的机器都是windows10以上的设备,而且不能直接共享文件夹目录,也没法直接点播和预览常见格式,比如视频和音乐等

- 不过,有相关的android软件能够让android设备也支持就近共享

  - [ NearShare (shortdev.de)](https://nearshare.shortdev.de/docs/download/) 软件体积不小,可以用镜像加速链接后下载,或者论坛下载
  - [Setup — NearShare (shortdev.de)](https://nearshare.shortdev.de/docs/setup/)

  - 实际体验下来还可以,操作简单
    - 注意手机端发送比较容易,但是接收需要获取蓝牙Mac地址,您需要先打开手机蓝牙开关(否则地址不可用),然后到系统设置里找到(状态信息里的蓝牙Mac地址);这个地址比较长,您可以
      - 如果手机支持长按复制,则直接复制即可
      - 也可以先截图,然后用ocr文字提取识别
      - 或者支持屏幕提取文字的功能也可以直接提取
    - 填写后点击下一步即可
  - 此外,也支持两个android设备之间进行互传文件(都需要安装好并启动设置NearShare app,没有广告,没不需要验证密码等操作)

好处就是配置少,开个开关就行,成功率高,可以用wifi,也可以用蓝牙传输,不要求有路由器

[在 Windows 中与附近的设备共享内容 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/在-windows-中与附近的设备共享内容-0efbfe40-e3e2-581b-13f4-1a0e9936c2d9)

### 设置共享文件夹(推荐)

- 官方文档,列举出了问题清单和相应的解决办法和步骤,已经给出了**最佳实践**,这里补充一些细节(整合其他设置方案)

  - [在 Windows 中通过网络共享文件 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/在-windows-中通过网络共享文件-b58704b2-f53a-4b82-7bc1-80f9994725bf)
  - [File sharing over a network in Windows - Microsoft Support](https://support.microsoft.com/en-us/windows/file-sharing-over-a-network-in-windows-b58704b2-f53a-4b82-7bc1-80f9994725bf)

- 这是一份更加完整的官方培训资料:[Configure and manage shared folders - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/configure-manage-shared-folders/)
- 更多参考:[Windows 文件夹共享指南：轻松分享文件和资料 - 系统极客 (sysgeek.cn)](https://www.sysgeek.cn/sharing-folders-windows-11/)

## 配置共享文件夹准备工作👺

为了更好的理解windows的共享文件夹及其相关功能,可以阅读一下准备工作,尽管这不是必须的

[windows@文件高级共享设置@网络发现功能@从资源管理器网络中访问远程桌面-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/139990609?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"139990609"%2C"source"%3A"xuchaoxin1375"})

### 选择一个合适的目录创建共享文件夹

- 为了避免共享文件夹创建完成后,其他用户无法访问(尽管登录成功,但内容是空的),建议把共享文件夹建立或选择在非用户目录下,例如,`C:\share`这类简短的目录;而`C:\User\UserX\...`这类目录(这个目录是用户`Userx`的家目录下的某个目录,不妨记为目录P)则容易与到权限问题,比如您创建了一个普通用`smb`分发给需要的设备访问共享文件夹P,可能会读取不到内容,除非您使用`UserX`的身份访问才可以读取目录P里的内容





## 创建共享文件夹

windows上创建共享文件夹的方式有好几种,有命令行方式,也有GUI方式

下面分别介绍这两大类方法,每大类里又细分两种方法

为了提高易用性,降低操作成本,我创建了一个脚本,可以直接运行实现基本的共享文件夹创建和使用,如果您有兴趣,可以看后面的章节

### 一键创建共享文件夹👺

- 参考[windows@一键创建共享文件夹@优秀的局域网内文件传输方案](https://blog.csdn.net/xuchaoxin1375/article/details/140099769?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"140099769"%2C"source"%3A"xuchaoxin1375"})

### 使用命令行net share方式创建和管理

[Net share | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh750728(v=ws.11))

建议在win10之前的系统中使用,虽然截至win11为止还通用,但这类方法不在被维护,新系统用powershell的方法

```cmd
net share <ShareName>
net share <ShareName>=<drive>:<DirectoryPath> [/grant:<user>,{read | change |full}] [/users:<number> | /unlimited] [/remark:<text>] [/cache:{manual | documents | programs | BranchCache |none} ]
net share [/users:<number> | /unlimited] [/remark:<text>] [/cache:{manual | documents | programs | BranchCache |none} ]
net share {<ShareName> | <DeviceName> | <drive>:<DirectoryPath>} /delete
net share <ShareName> \\<ComputerName> /delete
```

示例:

- 用**管理员身份**打开一个命令行窗口

- 假设我的机器上有一个目录`C:\sharePlus`,那么我执行以下语句`net share DemoShareNew=C:\shareNew /remark:"demo share new"`可以创建一个名为`DemoShare`的共享文件夹;

  - 注意到,我们可以不暴露被共享的文件夹的真实名字,而可以取一个便于共享的简单别名

  - ```cmd
    PS> net share DemoShare=C:\sharePlus /remark:"demo share"
    DemoShare was shared successfully.
    ```

  - 此时其他计算机可以访问`Demoshare`这个名字来访问该目录中的内容
    - 例如,创建共享文件夹的机器名为`colorfulcxxu`,并且启用了网络发现,在另一台也启用了网络发现的windows中执行`start \\colorfulcxxu\demoshare`,就可以访问共享文件夹`demoshare`了
  - Note
    - 被共享的文件夹路径结尾不要有`\`,而且参数是`/`,否则会无法识别(解析错误)
    - 如果无法访问或读取内容,请检查并设置共享文件夹的权限控制,参考文档或者下节中的介绍

#### 三种共享文件夹的访问权限对比🎈

权限对比总结

- **read（读取）**：仅允许查看和读取文件，适用于需要只读访问权限的用户。
- **change（更改）**：允许创建、修改和删除文件和文件夹，但不能更改共享设置，适用于需要对文件进行操作但不需要更改权限的用户。
- **full（完全控制）**：允许所有操作，包括更改共享设置，适用于需要完全管理文件和文件夹的用户。

选择适当的权限级别取决于用户的需求和安全性要求。合理分配权限可以有效地保护文件安全，同时满足用户的使用需求。

#### 指定共享权限

上述方法创建共享文件夹的方式十分简单,通常使用共享文件夹的主人(拥有者)身份访问不会遇到权限问题,但是必要时需要再设置访问控制权限,简单期间,可以设置为everyone 拥有访问权限

| 语法                                  | 用法说明                                                     |
| ------------------------------------- | ------------------------------------------------------------ |
| `/grant:<user>,{read | change |full}` | Creates the share with a security descriptor that gives the requested permissions to the specified user. <br />The permissions that can be granted to a user are: read, change or full. <br />This option may be used more than once to give share permissions to multiple users. |

##### 简单授权共享文件夹示例

```powershell

PS☀️[BAT:70%][MEM:40.4% (12.81/31.71)GB][19:52:23]
#⚡️[cxxu@COLORFULCXXU][C:\]
PS> net share DemoShareFC=C:\share1 /remark:"share folder grant everyone" /grant:everyone,full
DemoShareFC was shared successfully.

#查看创建结果
PS> net share

Share name   Resource                        Remark

-------------------------------------------------------------------------------
IPC$                                         Remote IPC
DemoShare    C:\sharePlus                    demo share
DemoShareFC  C:\share1                       share folder grant everyone
share        C:\share                        ColorfulCxxuShare
Users        C:\Users
The command completed successfully.
```

##### 为不同用户分别指定权限



实操示例:为用户`smb`仅分配只读权限,为用户`cxxu`分配完全控制的权限

```powershell
PS> net share DemoShareMultipleGrant=C:\share1 /grant:smb,read /grant:cxxu,full
DemoShareMultipleGrant was shared successfully.
```



### windows文件夹的访问控制权限和共享权限设置👺

- 另见它文,这里面有一些关键的设置,在遇到共享文件夹被访问时内容读取问题一般要做访问权限的修改

### 使用powershell中的SmbShare模块命令

[SmbShare Module | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/smbshare/?view=windowsserver2022-ps)

这个模块中命令众多,适合于windows10以及之后的系统使用

后面单独开一节介绍常用的几个命令

### 使用shrpubw程序引导创建

- 使用共享文件夹引导程序`shrpubw.exe`,这是一个windows系统自带的一个使用程序

  - 打开windows命令行,输入`shrpubw.exe`即可启动

- `shrpubw.exe` 是一个在 Microsoft Windows 操作系统中用于帮助用户创建和配置共享文件夹的向导程序。这个可执行文件（.exe）是系统自带的一部分，由 Microsoft Corporation 开发，主要用于简化网络共享设置过程。

  当用户需要在网络上共享本地计算机上的某个文件夹，以便其他网络用户可以访问时，可以通过运行 `shrpubw.exe` 启动“创建共享文件夹向导”。该向导提供了图形化界面，引导用户完成以下步骤：

  1. 选择要共享的文件夹路径。
  2. 设置共享名，即网络上其他用户看到的共享资源的名称。
  3. 配置共享权限，包括哪些用户或组可以访问此共享，并确定他们的读写权限级别。

- 该引导软件支持它会更改防火墙使得共享文件夹能够生效(通常不需要我们自己再去设置防火墙)

- 总的来说这是个很方便的程序,但是注意,windows为了安全,匿名访问可能是不被允许的,如果需要匿名,可能要改注册表策略组等,我的建议是创建一个名为smb的用户专门用来访问共享文件夹就可以了(不需要登录该用户桌面),既安全又高效,如果要匿名的体验,可以把密码设置简单点即可

### 使用资源管理器图形界面创建和管理

1. 设置防火墙(参考准备工作一节)

2. 选择文件或文件夹进行共享

   - 打开资源管理器,右键进行共享设置

     - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/59a7f585925246f3a8f895b7979dca1b.png)

     - 可以指定对那些人共享(进入设置可以允许任何用户访问,但是不保证匿名访问可行,可能需要进一步设置)
       - 对于启用了SMB1功能的及其可能默认允许匿名访问

     - 包括选择哪些用户能够访问被共享的文件或目录

     


#### 匿名访问问题@创建一个专门用来访问共享文件夹的凭证用户

- 为了安全考虑,windows逐渐禁止匿名访问smb服务,对于较新的系统,即使在设置网络中允许免密访问共享文件夹(文件),但是仍然需要登录某个账户才可以访问(来宾(Guest)匿名不再能轻易访问共享文件夹)

  - 这里建议创建一个专门共享文件的账户,来供其他设备验证身份来访问本机的提供的共享文件价

  - 新建的用户可以是普通用户,我们甚至不需要登录这个用户,例如设置本地用户`smb_share`,密码随意,不介意安全性时尽可能简单,毕竟在可信的局域网内,默认是安全的,特别是真个局域网只有自己用,自己用来传输文件,我们甚至不需要创建这个新用户,直接用已有的账户登录就行

  - 创建新用户:命令行中或者**win+r**输入:`lusrmgr.msc`启动新用户创建面板

    - | 普通的通用界面创建新用户                                     | 设置共享文件夹时在选择授权用户时会提供创建新用户的入口       |      |
      | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
      | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/63416859f7ca4ee38567a5aaa92ed23c.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/164f7469f4514539a33ade12e4dfc8a5.png) |      |
      | 步骤简单                                                     | 设置步骤较多                                                 |      |

    - 此外,也可以用命令行创建新用户,对于仅仅用于公开访问的凭证用途的用户,可以执行一下命令直接创建一个普通用户

      - ```owershell
        net user smb 1 /add
        ```

        该用户名为`smb`,密码为`1`

      - 删除:`net user smb /delete`,这会删除`smb`这个用户

  - 创建新用户的相关参考:

    - [Local Users and Groups | Microsoft Learn](https://learn.microsoft.com/zh-cn/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc753942(v=ws.11)?redirectedfrom=MSDN)
    - [Net user | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/cc771865(v=ws.11))
    - [windows@添加本地用户账户等操作](https://blog.csdn.net/xuchaoxin1375/article/details/112854717)

### 查看共享文件夹的网络路径👺

事实上您可以通过右键被共享的文件夹,查看其属性,其中的sharing部分给出了网络路径(NetWork Path)

其中`\\`后面跟的第一个字段(截止于`\`前)的是当前共享文件夹的主机名(但是需要您启用网络发现才可以直接使用此路径访问,否则需要用ip地址代替主机名)

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/3fd9aa1df0b44259a3430ff5198bdb79.png)



## 使用powershell管理共享文件夹👺

在PowerShell中，可以使用`New-SmbShare`、`Set-SmbShare`和`Remove-SmbShare`等命令来创建、修改和删除共享文件夹。这些命令提供了更强大的功能和灵活性来管理共享资源。

### 常用命令

#### 基础命令

- [New-SmbShare (SmbShare) | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/smbshare/new-smbshare?view=windowsserver2022-ps)
- [Get-SmbShare (SmbShare) | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/smbshare/get-smbshare?view=windowsserver2022-ps)
- [Remove-SmbShare (SmbShare) | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/smbshare/remove-smbshare?view=windowsserver2022-ps)

#### 挂载类的命令

- [New-SmbMapping (SmbShare) | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/smbshare/new-smbmapping?view=windowsserver2022-ps) 默认挂载只对powershell可见,资源管理器中是看不到的
  - 同理有`Get-SmbMapping`,`Remove-SmbMapping`
  - 在powershell中挂载共享文件夹的地址为盘符,可以方便命令行访问共享文件夹中的内容而不需要打开资源管理器
  - 当然,您也可以选择使用合适的命令先挂载到资源管理器,然后任何命令行(比如`net use`或`new-psdrive`)就可以访问挂载后的盘符了
- [New-PSDrive (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/new-psdrive?view=powershell-7.4)
  - 如果需要挂载到资源管理器,那么可以考虑用`New-PSdrive`命令
  - 这里直接用被挂载的文件夹所在主机名,需要启用系统的**网络发现**功能才可以

```powershell
PS C:\Users\cxxu\Desktop> New-PSDrive -Name "Z" -PSProvider "FileSystem" -Root "\\redmibookpc\share" -Persist

Name           Used (GB)     Free (GB) Provider      Root
----           ---------     --------- --------      ----
Z                 114.17        361.79 FileSystem    \\redmibookpc\share

PS C:\Users\cxxu\Desktop>
```

而直接用ip导致报错,将来可能会改进

```powershell
PS C:\Users\cxxu\Desktop> New-PSDrive -Name "Q" -PSProvider "FileSystem" -Root "\\192.168.1.158\share"
New-PSDrive: The specified drive root "\\192.168.1.158\share" either does not exist, or it is not a folder.
```



###  创建共享文件夹

使用 `New-SmbShare` 命令可以创建新的共享文件夹。下面是创建共享文件夹的基本示例：

```powershell
# 创建共享文件夹
New-SmbShare -Name "Share" -Path "C:\Share" -ChangeAccess "Everyone" #这里赋予任意用户修改权限(包含了可读权限和修改权限)
```

#### 参数解释

- `-Name`：指定共享的名称。
- `-Path`：指定要共享的文件夹路径。
- `-FullAccess`：指定具有完全访问权限的用户或组。

如果需要设置“读取”或“更改”权限，可以使用 `-ReadAccess` 和 `-ChangeAccess` 参数,并且这三个参数可以同时出现

###  修改共享文件夹

使用 `Set-SmbShare` 命令可以修改现有的共享文件夹设置。例如，修改共享文件夹的权限：

```powershell
# 修改共享文件夹的权限
Set-SmbShare -Name "Share" -ChangeAccess "Everyone"
```

### 删除共享文件夹

使用 `Remove-SmbShare` 命令可以删除共享文件夹：

```powershell
# 删除共享文件夹
Remove-SmbShare -Name "Share" -Force
```



### 查看现有共享文件夹(推荐方法)

使用 `Get-SmbShare` 命令可以查看现有的共享文件夹：

```powershell
# 查看所有共享文件夹
Get-SmbShare

# 查看特定共享文件夹
Get-SmbShare -Name "Share"
```

```powershell
PS> get-smbshare

Name                   ScopeName Path      Description
----                   --------- ----      -----------
DemoShareCC            *         C:\share1 share folder grant everyone
DemoShareFC            *         C:\share1 share folder grant everyone
DemoShareMultipleGrant *         C:\share1
DemoShareRC            *         C:\share1 share folder grant everyone
IPC$                   *                   Remote IPC
share                  *         C:\share  ColorfulCxxuShare
Users                  *         C:\Users

PS> get-smbshare -Name share

Name  ScopeName Path     Description
----  --------- ----     -----------
share *         C:\share ColorfulCxxuShare
```

通过上述命令，您可以在PowerShell中有效地管理共享文件夹，包括创建、修改和删除共享文件夹。合理设置权限和管理共享资源，可以提高网络资源的安全性和使用效率。

### 示例：完整的创建和配置共享文件夹过程

假设我们要创建一个名为 `ReportsShare` 的共享文件夹，路径为 `D:\Documents\Reports`，并赋予用户组 `Everyone` “读取”权限，下面是完整的过程：

```powershell
# 创建共享文件夹并设置读取权限
New-SmbShare -Name "ReportsShare" -Path "D:\Documents\Reports" -ReadAccess "Everyone"

# 查看已创建的共享
Get-SmbShare -Name "ReportsShare"

# 修改权限为更改权限
Set-SmbShare -Name "ReportsShare" -ChangeAccess "Everyone"

# 最后删除共享文件夹
Remove-SmbShare -Name "ReportsShare" -Force
```

## 管理和监视共享文件夹🎈

- 使用winodws自带的程序`fsmgmt.msc`可以管理和监视本机建立的共享文件夹,以及查看共享文件夹被哪些其他设备和所访问
- 这个程序有些卡顿,可以考虑用命令行来管理
- powershell中SmbShare模块中提供了相关命令,前面介绍了创建/删除/挂载(映射),其他监视用的命令有
  - [Get-SmbConnection (SmbShare) | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/smbshare/get-smbconnection?view=windowsserver2022-ps)
  - [Get-SmbSession (SmbShare) | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/smbshare/get-smbsession?view=windowsserver2022-ps)
  - [Get-SmbOpenFile (SmbShare) | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/smbshare/get-smbopenfile?view=windowsserver2022-ps)

### 示例

`Get-SmbConnection`命令可以轻松检索出当前设备连接(访问)到那个主机的那个共享文件夹:Retrieves the connections established from the SMB client to the SMB servers.

```powershell
PS C:\Users\cxxu\Desktop> Get-SmbConnection

ServerName   ShareName UserName           Credential         Dialect NumOpens
----------   --------- --------           ----------         ------- --------
cxxucolorful share     CXXUREDMIBOOK\cxxu CXXUREDMIBOOK\cxxu 3.1.1   1

PS C:\Users\cxxu\Desktop> Get-SmbConnection|select *

SmbInstance           : Default
ContinuouslyAvailable : False
Credential            : CXXUREDMIBOOK\cxxu
Dialect               : 3.1.1
Encrypted             : False
NumOpens              : 1
Redirected            : False
ServerName            : cxxucolorful
ShareName             : share
Signed                : True
UserName              : CXXUREDMIBOOK\cxxu
PSComputerName        :
CimClass              : ROOT/Microsoft/Windows/SMB:MSFT_SmbConnection
CimInstanceProperties : {ContinuouslyAvailable, Credential, Dialect, Encrypted…}
CimSystemProperties   : Microsoft.Management.Infrastructure.CimSystemProperties
```

`Get-SmbSession`:Retrieves information about the SMB sessions that are currently established between the SMB server and the associated clients.

```powershell
PS C:\Users\cxxu\Desktop> Get-SmbSession

SessionId    ClientComputerName          ClientUserName    NumOpens
---------    ------------------          --------------    --------
687194767433 [fe80::8018:384d:bc37:92f1] CxxuColorful\cxxu 0
687194767441 192.168.1.165               CXXUCOLORFUL\smb  1
```

- 上面的例子可看出,当前设备共享的文件夹被其他两个设备(`fe80::8018:3843:bc...`(是一个ipv6地址)和`192.168.1.165`所访问;并且两个会话分别是用服务器`CxxuColorful`上的`cxxu`账户和`smb`账户作为凭证访问(建立的会话)),注意,这里显示的`ClientUserName`是Smb Server提供给Smb Client访问共享文件夹用的账户,而Smb client自己的账户如何是无从知晓的,只知道它的ClinetComputerName(一般是一个ip地址,可能是ipv4,ipv6)

## 访问共享文件夹及其相关操作

另见它文 [windows@资源管理器中的地址栏@访问共享文件夹的各种方法@管理共享文件夹-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/140139320?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"140139320"%2C"source"%3A"xuchaoxin1375"})
