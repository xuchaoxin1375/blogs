[toc]



## abstract

- 局域网传输这一需求在生活中是很常见的,特别是无线传输,比很多质量一般的有线传输要快
- 更不用提需要多用户共享的情形(比如10个人以上),用数据线或者优盘拷贝的繁琐可想而知
- 本文介绍应用最广泛,操作最方便的文件共享传输协议(smb)及其软件实现方案推荐
- 部分老牌文件管理器提供了相应协议的支持,并且有相应的使用文档,例如ES文件管理器,也可以供用户参考和使用(客户端推荐一节介绍)

## smb server

- windows 默认和推荐的局域网传输协议,windows不强调其提供的共享功能是基于smb协议,但是功能背后的协议是smb协议
- smb协议迭代了多个版本,现在已经是`SMBv3`,即第3个版本
- 对于windows系统而言,基于smb配置简单(用户甚至不需要知道smb协议就可以完成配置),且传输较为安全高效
- 本文主要介绍windows下如何使用smb(共享文件夹);linux系统另见它文

## linux Samba(smb)

### 命令行操作

#### smbserver

- 这一份教程是关于linux ubuntu上配置smb(samba)服务器和共享共享文件夹设置的教程[Install and Configure Samba | Ubuntu](https://ubuntu.com/tutorials/install-and-configure-samba#1-overview)

- 可以将其编制成一份脚本,来一键配置

- 创建一个目录用来存放需要共享的内容

  - ```bash
    mkdir ~/sambashare
    ```

- 配置samba server 的行为

  - ```bash
    # cxxu @ ColorfulCxxu in ~/sambashare [21:04:32] 
    $ sudo vim /etc/samba/smb.conf
    
    ```

  - ```bash
    #末尾追加内容示例
    [sambashare]
            comment=Samba on linux ubt
            path=/home/cxxu/sambashare
            read only=no
            browsable=yes
    ```

- 重启服务和刷新

  - ```
    # cxxu @ ColorfulCxxu in ~/sambashare [21:04:38]
    $ sudo service smbd restart
    
    # cxxu @ ColorfulCxxu in ~/sambashare [21:04:52]
    $ sudo ufw allow samba
    Skipping adding existing rule
    Skipping adding existing rule (v6)
    ```

    

- 创建samba用户,用于登录samba服务器

  ```bash
  # cxxu @ ColorfulCxxu in ~ [20:52:29] C:1
  $ sudo smbpasswd -a cxxu
  New SMB password:
  Retype new SMB password:
  Added user cxxu.
  
  #参数说明(-a 表示添加用户,从系统用户中选择一个名字,比如我这里就是cxxu)
  # cxxu @ ColorfulCxxu in ~ [20:51:47]
  $ smbpasswd -h
  When run by root:
      smbpasswd [options] [username]
  otherwise:
      smbpasswd [options]
  
  options:
    -L                   local mode (must be first option)
    -h                   print this usage message
    -s                   use stdin for password prompt
    -c smb.conf file     Use the given path to the smb.conf file
    -D LEVEL             debug level
    -r MACHINE           remote machine
    -U USER              remote username (e.g. SAM/user)
  extra options when run by root or in local mode:
    -a                   add user
    -d                   disable user
    -e                   enable user
  
  ```

- 查询ip

  - ```
    # cxxu @ ColorfulCxxu in ~ [20:55:14] C:100
    $ ip -4 addr show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1492 qdisc mq state UP group default qlen 1000
        inet 172.27.30.244/20 brd 172.27.31.255 scope global eth0
           valid_lft forever preferred_lft forever
    ```

  - 结果为`172.27.30.244`

- 开始尝试链接:

  - 比如windows上链接过去

  - ```bash
    [BAT:79%][MEM:35.17% (11.15/31.70)GB][21:06:54]
    [~]
    PS>start \\172.27.30.244\sambashare
    #顺利的话会弹出一个窗口让你输入用户名和密码,然后资源管理器就能够看到samba server共享的目录
    ```


#### smbclient

- 在后面的访问smb共享文件夹中会详谈
  
  ```bash
  
  # 使用smbclient连接到Windows共享文件夹
  smbclient //hostname/sharename -U username%password
  
  示例：
  # 连接到IP地址为192.168.1.100的主机上名为"Public"的共享文件夹，用户名为"user"，密码为"password"
  smbclient //192.168.1.100/Public -U user%password
  
  # 或者，如果Windows共享允许匿名访问：
  smbclient //hostname/sharename
  ```
  
- 查看帮助

  ```
  # cxxu @ ColorfulCxxu in ~/sambashare [21:34:19] C:130
  $ man smbclient
  ```


#### 实操

- ```bash
  # cxxu @ ColorfulCxxu in ~/sambashare [21:35:52]
  $ smbclient //192.168.1.178/share -U smb%1
  Try "help" to get a list of possible commands.
  smb: \> ls
    .                                  DA        0  Tue Apr 16 16:05:25 2024
    ..                               DAHS        0  Tue Apr 16 18:02:09 2024
    Downloads                          Dr        0  Tue Apr 16 16:05:25 2024
    exes                               Dr        0  Tue Apr 16 13:53:02 2024
    IMG_20240414_201127.jpg             A  5919488  Sun Apr 14 20:17:04 2024
    IMG_20240414_201149.jpg             A  2255117  Sun Apr 14 20:17:04 2024
    IMG_20240414_201232.jpg             A  3024236  Sun Apr 14 20:17:03 2024
    MK                                  D        0  Tue Apr  2 10:16:01 2024
    Thumbs.db                        AHSn   152576  Tue Apr 16 15:40:55 2024
  ```

- 不把密码输入在命令中,而是交互行中

  ```bash
  (base) ┌─[cxxu@ColorfulCxxu] - [/mnt/c/exes/edgep/App] - [2024-05-30 10:01:44]
  └─[0] <> smbclient //192.168.1.178/share -U smb
  Password for [WORKGROUP\smb]:
  Try "help" to get a list of possible commands.
  smb: \> ls
    .                                  DA        0  Mon May 27 23:25:32 2024
    ..                               DAHS        0  Thu May 30 20:13:35 2024
    base (2).apk                        A 35476837  Sat May 25 21:27:51 2024
    base (3).apk                        A  2837839  Sat May 25 22:06:04 2024
    base (4).apk                        A 14238970  Sat May 25 22:09:03 2024
    base.apk                            A    85711  Sat May 25 21:26:31 2024
    base.apk.1                          A 31115770  Sat May 25 20:30:08 2024
  ```

  

### linux 桌面版 资源管理器访问smb 共享文件夹

- 使用smbclient 命令行界面不是太美观
- 对于有图形界面的linux系统,用其资源管理器可以通过`smb://ip-address/sambashare`的格式来访问
- 经过实验,无论发出共享的服务器端系统是windows还是linux,都可以用上述格式的链接用文件管理器的地址栏进行浏览(但么有桌面的linux就只能用命令行访问)

## windows系统下的共享文件夹👺

### 设置共享文件夹

- 官方文档,列举出了问题清单和相应的解决办法和步骤,已经给出了最佳实践,这里补充一些细节(整合其他设置方案)

  - [在 Windows 中通过网络共享文件 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/在-windows-中通过网络共享文件-b58704b2-f53a-4b82-7bc1-80f9994725bf)
  - [File sharing over a network in Windows - Microsoft Support](https://support.microsoft.com/en-us/windows/file-sharing-over-a-network-in-windows-b58704b2-f53a-4b82-7bc1-80f9994725bf)




#### 方法1

- 使用共享文件夹引导程序`shrpubw.exe`,这是一个windows系统自带的一个使用程序

  - 打开windows命令行,输入`shrpubw.exe`即可启动

- `shrpubw.exe` 是一个在 Microsoft Windows 操作系统中用于帮助用户创建和配置共享文件夹的向导程序。这个可执行文件（.exe）是系统自带的一部分，由 Microsoft Corporation 开发，主要用于简化网络共享设置过程。

  当用户需要在网络上共享本地计算机上的某个文件夹，以便其他网络用户可以访问时，可以通过运行 `shrpubw.exe` 启动“创建共享文件夹向导”。该向导提供了图形化界面，引导用户完成以下步骤：

  1. 选择要共享的文件夹路径。
  2. 设置共享名，即网络上其他用户看到的共享资源的名称。
  3. 配置共享权限，包括哪些用户或组可以访问此共享，并确定他们的读写权限级别。

- 该引导软件支持它会更改防火墙使得共享文件夹能够生效(通常不需要我们自己再去设置防火墙)

- 总的来说这是个很方便的程序,但是注意,windows为了安全,匿名访问可能是不被允许的,如果需要匿名,可能要改注册表策略组等,我的建议是创建一个名为smb的用户专门用来访问共享文件夹就可以了(不需要登录该用户桌面),既安全又高效,如果要匿名的体验,可以把密码设置简单点即可

#### 方法2



1. 配置网络(由多种方式,任选一种即可)

   - 命令行方式

     - ```bash
       netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
       netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
       ```

     - 以管理员方式启动cmd(或powershell)运行上述命令(回车执行)

       - ```bash
         PS C:\Users\cxxu\Desktop> netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
         
         Updated 48 rule(s).
         Ok.
         
         PS C:\Users\cxxu\Desktop> netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
         
         Updated 62 rule(s).
         Ok.
         ```

   - 使用图形界面方式配置

     - | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/8aa14dc0000c4c96a3275899009d68f2.png) | windows11下的设备可扫描设置 |      |
       | ------------------------------------------------------------ | --------------------------- | ---- |
       | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/ed4449c0117945a5820a561e6be9e577.png) | windows10下的设置           |      |

   - 如此局域网内的其他设备才能够扫描到当前设备,并且当前设备的文件或目录能够被其他设备访问

2. 选择文件或文件夹进行共享

   - 打开资源管理器,右键进行共享设置

   - 包括选择哪些用户能够访问被共享的文件或目录

   - 为了安全考虑,windows逐渐禁止匿名访问smb服务,对于较新的系统,即使在设置网络中允许免密访问共享文件夹(文件),但是仍然需要登录某个账户才可以访问(来宾(Guest)匿名不再能轻易访问共享文件夹)

     - 这里建议创建一个专门共享文件的账户,来供其他设备验证身份来访问本机的提供的共享文件价

     - 新建的用户可以是普通用户,我们甚至不需要登录这个用户,例如设置本地用户`smb_share`,密码随意,不介意安全性时尽可能简单,毕竟在可信的局域网内,默认是安全的,特别是真个局域网只有自己用,自己用来传输文件,我们甚至不需要创建这个新用户,直接用已有的账户登录就行

     - 创建新用户:命令行中或者**win+r**输入:`lusrmgr.msc`启动新用户创建面板

       - | 通用界面创建新用户                                           | 新系统在选择授权用户时会提供创建入口                         |      |
         | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
         | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/63416859f7ca4ee38567a5aaa92ed23c.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/164f7469f4514539a33ade12e4dfc8a5.png) |      |
         | 步骤简单                                                     | 设置步骤较多                                                 |      |

     - 创建新用户的相关参考:

       - [Local Users and Groups | Microsoft Learn](https://learn.microsoft.com/zh-cn/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc753942(v=ws.11)?redirectedfrom=MSDN)
       - [windows@添加本地用户账户](https://blog.csdn.net/xuchaoxin1375/article/details/112854717)

#### 右键设置共享文件夹

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/59a7f585925246f3a8f895b7979dca1b.png)

- 可以指定对那些人共享(进入设置可以允许任何用户访问,但是不保证匿名访问可行,可能需要进一步设置)
  - 对于启用了SMB1功能的及其可能默认允许匿名访问

### 查看所有已经共享的文件夹👺

- 有如下方式可以检查

  - 在资源管理器中的地址栏输入`\\localhost`
  - 或者命令行中输入`start \\localhost`

  

### 停止某个文件的共享

- 方法1:图形界面操作

  - |                                                              |                                                              |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/3bd52fc15c50499b8615f8231e2a12bd.png) | 右键目标文件夹,选择高级设置,将取消勾选分享次文件夹(share this folder);把保存修改即可 |

- 方法2:从资源管理器中找到目标文件夹,右键更改访问权限,选择移除访问权限(remove access),但是不一定所有文件夹都能找到移除按钮

## 访问smb共享文件夹👺



### Windows 系统

在 Windows 系统中，你可以使用 `net use` 命令来映射网络共享文件夹，并在此过程中提供用户名和密码。

以下是一个访问格式(推荐现代windows系统使用)：

```bash
net use X: \\服务器地址\共享文件夹名称 /user:用户名 密码
```

例如：

```bash
net use X: \\192.168.1.100\SharedFolder /user:John Doe MyPassword123
```

这条命令会将 `\\192.168.1.100\SharedFolder` 映射为本地 X: 驱动器，并使用指定的用户名和密码进行身份验证。

实操:

```bash
PS C:\Users\cxxu> net use x: \\192.168.1.178\share /user:smb 1
命令成功完成。
```

检查挂载结果

```bash
PS C:\Users\cxxu>  net use
会记录新的网络连接。


状态       本地        远程                      网络

-------------------------------------------------------------------------------
OK           X:        \\192.168.1.178\share     Microsoft Windows Network
命令成功完成。

```

注意,提示您成功执行后,打开资源管理器刷新一下,可以找到网络驱动器(网络位置)中有一个`x`盘

如果您在挂载此共享文件夹之前已经占用了`x`盘符,则需要修改命令行中的`x:`,未被占用的英文字母都可以

也可以在命令行中访问,例如`cd x:\`

### Powershell函数挂载网络盘👺

一个颇为可用的用来映射共享文件夹的powershell函数,支持共享文件夹(smb)和webdav(局域网内http)

或者使用完整链接参数(Comp指定,覆盖Mode参数

```powershell

function Mount-NetDrive
{
    <# 
	.SYNOPSIS
    挂载http链接形式的网络驱动器,通常用于局域网挂载
    这里是对net use 的一个封装,而Powershell 的New-PSDrive命令并不那么好用,链接识别有一定问题
    $HostAddress =$iqoo10pro
    .DESCRIPTION
    为了方便省事,这里记住密码，不用每次都输入密码
    net use W: "http://$HostAddress:5244/dav" /p:yes /savecred 
    目前已知New-PSDrive有挂载问题是,报错如下
    New-PSDrive: The specified drive root "\\192.168.1.178:5244\dav" either does not exist, 	or it is not a folder.

    .EXAMPLE
    # 挂载共享文件夹
    PS C:\repos\scripts> mount-NetDrive -HostAddress 127.0.0.1 -DriveLetter V  -Mode Smb -Remember
    Net Drive Mode: Smb
    Enter shared folder(Directory) BaseName(`share` is default): share
    \\127.0.0.1\share
    The command completed successfully.

    Drive V: successfully mapped to \\127.0.0.1\share
    New connections will be remembered.


    Status       Local     Remote                    Network

    -------------------------------------------------------------------------------
    Unavailable  M:        http://192.168.1.165:5244/dav
                                                    Web Client Network
                Q:        \\127.0.0.1@5244\dav      Web Client Network
    OK           V:        \\127.0.0.1\share         Microsoft Windows Network
    Unavailable  W:        http://localhost:5244/dav Web Client Network
    The command completed successfully.
    .EXAMPLE
    #挂载webdav(之前已经记录过凭证)
    PS C:\repos\scripts> mount-NetDrive -HostAddress 127.0.0.1 -DriveLetter V  -Mode Webdav -Remember
    Net Drive Mode: Webdav
    http://127.0.0.1:5244/dav
    The command completed successfully.

    Drive V: successfully mapped to http://127.0.0.1:5244/dav
    New connections will be remembered.


    Status       Local     Remote                    Network

    -------------------------------------------------------------------------------
    Unavailable  M:        http://192.168.1.165:5244/dav
                                                    Web Client Network
                Q:        \\127.0.0.1@5244\dav      Web Client Network
                V:        \\127.0.0.1@5244\dav      Web Client Network
    Unavailable  W:        http://localhost:5244/dav Web Client Network
    The command completed successfully.
    
    #>
    param(
        # 可以用于webdav链接中ip地址填充,也可以用于共享文件夹
        [string]$HostAddress = 'localhost',
        # 比如用于共享文件夹的链接,比如\\192.168.1.178\share
        [string]$CompleteUri = '',
        [ValidateSet('Smb', 'Webdav', 'Others')]$Mode = 'Smb',
        # 挂载的分区盘符
        [string]$DriveLetter = 'M',
        # Alist 默认端口库
        [string]$Port = '5244',
        # 用户名是可选的,如果您使用匿名登录不上,则考虑使用次参数,密码会在执行后要求你填入,这样密码不会明文显示在命令行中
        [string]$UserName = '',
        #是否记住凭证(和 -UserName 一起使用时可能会有冲突!)
        [switch]$Remember

    )

    Write-Host "Net Drive Mode: $Mode" -ForegroundColor Magenta

    $credString = ''#默认没有凭证,匿名访问/挂载
    # 如果提供了用户,则要求用户输入密码(这样密码不会在命令行中明文显示)
    if ($UserName)
    {
        $password = Read-Host "Enter password For $UserName" -AsSecureString
        $credential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)
        $plainCred = $credential.GetNetworkCredential()

        $credString = $plainCred.UserName + ' ' + $plainCred.Password
    }
    # 构造URI(if语句可以类似于三元运算符来使用)
    $Uri = if ($CompleteUri)
    {
        $CompleteUri 
    }
    else
    {  

        switch ($Mode)
        {
            # 记得使用break来退出switch
            'Webdav'
            { 
                
                "http://${HostAddress}:${Port}/dav"; break
            }
            'Smb'
            {
                $ShareDir = Read-Host 'Enter shared folder(Directory) BaseName(`share` is default)'
                $ShareDir = if ($ShareDir) { $ShareDir } else { 'share' }
                "\\${HostAddress}\$ShareDir" ; break
            }
            Default { '' }
        }
    } 

    Write-Host -ForegroundColor Blue $Uri

    # 构造net use命令参数
    $netUseArguments = "${DriveLetter}: $uri"
    #考虑到可能需要用户名和密码,必要时添加凭据字符串
    if ($credString -ne '')
    {
        $netUseArguments += " /user:$credString"
    }

    # 是否记住凭据
    if ($Remember)
    {
        $netUseArguments += ' /persistent:yes /savecred'
    }

    # 映射网络驱动器
    $expression = "net use $netUseArguments"
    #debug
    # Write-Host $expression -BackgroundColor Green

    Invoke-Expression $expression

    # 检查映射结果
    if ($LASTEXITCODE -eq 0)
    {
        Write-Host "Drive ${DriveLetter}: successfully mapped to $uri"
    }
    else
    {
        Write-Error "Failed to map drive ${DriveLetter}: with error code $LASTEXITCODE"
    }

    # 显示现有映射
    net use
}

```



### Linux/macOS 系统

在 Linux 或 macOS 系统中，你可以使用 `smbclient` 或 `mount` 命令来访问 Windows 共享文件夹。

#### 使用 smbclient

`smbclient` 是一个与 SMB/CIFS 服务（如 Windows 共享）交互的命令行工具。以下是一个示例命令：

```bash
smbclient //服务器地址/共享文件夹名称 -U 用户名 -c "dir"
```

**如果需要输入密码，命令会提示你输入**。这个命令会列出共享文件夹中的内容。如果你需要更复杂的操作，可以查看 `smbclient` 的文档。

#### 使用 mount

在 Linux 中，你也可以通过 `mount` 命令将共享文件夹挂载到本地文件系统。这通常涉及到更复杂的设置，包括安装和配置 cifs-utils 包。以下是一个基本示例：

```bash
sudo mount -t cifs //服务器地址/共享文件夹名称 /本地挂载点 -o username=用户名,password=密码
```

#### 实操

```bash
#我在/mnt/下有一个wsl目录,(也可以自己创建目录,比如share)
(base) ┌─[cxxu@ColorfulCxxu] - [/mnt] - [2024-05-30 10:05:48]
└─[32] <> sudo mount -t cifs //192.168.1.178/share /mnt/wsl -o username=smb,password=1
#检查挂载效果
(base) ┌─[cxxu@ColorfulCxxu] - [/mnt] - [2024-05-30 10:08:07]
└─[0] <> cd /mnt/wsl
(base) ┌─[cxxu@ColorfulCxxu] - [/mnt/wsl] - [2024-05-30 10:08:16]
└─[0] <> ls
 Documents   MKt                               Music      'base (2).apk'  'base (4).apk'   base.apk.1
 Downloads   MYXJ_20240526151015328_fast.jpg   Thumbs.db  'base (3).apk'   base.apk        exes
```

在linux虚拟机中操作,模拟局域网情况

```bash
#在/mnt/目录下,创建一个share目录,用于挂载共享文件夹
(base) ┌─[cxxu@ubt22] - [/mnt/share] - [2024-05-30 02:25:04]
└─[130] <> cd /mnt
#管理员权限创建
(base) ┌─[cxxu@ubt22] - [/mnt] - [2024-05-30 02:22:17]
└─[1] <> sudo mkdir share
[sudo] password for cxxu:
#开始挂载(这里ip改为自己共享文件夹所在计算机的实际情况)
(base) ┌─[cxxu@ubt22] - [/mnt] - [2024-05-30 02:22:23]
└─[0] <> sudo mount -t cifs //192.168.1.178/share /mnt/share -o username=smb,password=
1

#检查挂载情况
(base) ┌─[cxxu@ubt22] - [/mnt] - [2024-05-30 02:23:25]
└─[0] <> cd share
(base) ┌─[cxxu@ubt22] - [/mnt/share] - [2024-05-30 02:23:27]
└─[0] <> ls
'base (2).apk'   base.apk     Downloads   Music
'base (3).apk'   base.apk.1   exes        MYXJ_20240526151015328_fast.jpg
'base (4).apk'   Documents    MKt         Thumbs.db
```



### 注意事项

- 在命令行中直接包含密码（特别是在多用户环境中）可能存在安全风险。请确保你了解这些风险，并考虑使用更安全的方法来处理认证信息。
- 上述命令中的用户名和密码应替换为你自己的有效凭据。
- 网络共享的具体设置和访问权限可能因你的网络环境和服务器配置而异。如果遇到问题，请检查服务器设置和网络策略。

## FAQ:设置和使用中可能遇到的问题👺

### 登录后无法访问共享文件夹或文件夹内容显示为空

- 这可能共享文件夹的权限设置问题
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/a8605e33e5024499aad86fc3697c5e86.png)

### 账户已锁定且可能无法登录问题

报错示例如下

这里局域网内设置共享文件夹的主机ip为192.168.1.178,被共享的目录名为`share`(这里不需要填写`share`的具体路径)

```powershell
PS C:\Users\cxxu> net use x: \\192.168.1.178\share
发生系统错误 1909。

引用的帐户当前已锁定，且可能无法登录。
```

您可以尝试带上账户密码,例如我有(创建了)一个用于访问共享文件夹的用户名和密码(这是一个本地用户),分别为`smb`,`1`(用户名和密码设置的如此简单就是为了接近匿名访问的便捷,实际上记住密码后也不需要每次都重新输入密码,密码长点也无所谓的

其实,`net use x: \\192.168.1.178\share`和`start \\192.168.1.178\share`都可以用来访问共享文件夹,并且应该在回车执行后进一步提示我们需要输入用户名密码来验证权限,但是有时候却弹不出来

这时我们可以考虑用`net use`的 `/user`参数来解决

```powershell
PS C:\Users\cxxu> net use x: \\192.168.1.178\share /user:smb 1
命令成功完成。
```



### windows默认不允许匿名访问共享文件夹👺

- 较新版本的windows默认不允许匿名登录
- 以windows10访问windows11上创建的共享文件夹为例被锁定问题
- 有时候会弹出一个框让你输入用户名和对应的密码验证访问权限
- 但是我估计是windows的bug,至少windows10上存在这种不提示你输入用户密码验证的情况,而是直接否决,告诉你**引用的账户当前已锁定,无法登录**
- 这种情况下使用上述推荐的命令行方法尝试访问共享文件夹

## 共享文件夹的访问控制补充

### 匿名访问问题😊

免登录访问共享文件夹问题

- [SMB2 和 SMB3 中的来宾访问被禁用 - Windows Server | Microsoft Learn](https://learn.microsoft.com/zh-cn/troubleshoot/windows-server/networking/guest-access-in-smb2-is-disabled-by-default)

  - SMB1默认支持匿名访问,对于较新系统,需要到控制面板中启动相关windows功能
    - 仅当需要兼容老设备或者实在想要匿名登录时考虑这么做(todo)
  - 新系统配置匿名smb访问比较麻烦,我们可以建立一个简单的windows用户(账号密码很短)来逼近匿名访问的体验
  - 事实上,smb协议的客户端通常由保存链接记录的功能,只要设置一次,后续就不需要输入账号密码,如果是一个人或很少人用,就更不用纠结了,配置一次就不需要再输入账号密码了(顶多smb服务器ip发生变换,但如果真的需要改ip无论是否匿名访问都要改,并不会造成更多麻烦,而且提高了一定的安全性)

### 强制启用匿名访问

- 以下设置可能是无效的

  - 修改策略组

  - 或命令行修改注册表

    - ```bash
      PS C:\Users\cxxu\Desktop> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters /v "AllowInsecureGuestAuth" /d 1 /t REG_DWORD
      
      The operation completed successfully.
      
      PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters
      
      HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters
          EnablePlainTextPassword    REG_DWORD    0x0
          EnableSecuritySignature    REG_DWORD    0x1
          RequireSecuritySignature    REG_DWORD    0x0
          ServiceDll    REG_EXPAND_SZ    %SystemRoot%\System32\wkssvc.dll
          ServiceDllUnloadOnStop    REG_DWORD    0x1
          AllowInsecureGuestAuth    REG_DWORD    0x1
      ```

- 可以考虑启用smb v1,似乎可以匿名访问,但不建议使用,可以简单创建一个专门访问共享文件夹的简单用户即可

### 协议相关信息参考

- [使用 Windows Server 中的 SMB 3 协议的文件共享概述 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/storage/file-server/file-server-smb-overview)

## 相关客户端👺

### android客户端推荐

- cx file explorer: [Cx File Explorer Apk Download - Best File Manager for Android!](https://cxfileexplorer.com/)
  - 文档[Cx File Explorer: Settings, Usage and Tips](https://cxfileexplorer.com/how-to-use-cx-file-explorer/)
  - 各种常见的传输协议都支持,并且再传输过程中的速度可以实时显示,比较好
  - 链接记录都保存着,下次链接很方便
  - 即便没有路由器,android端开热点,给计算机或其他设备链接,cx file explorer也能工作
- 其他类似的app(这两个app会扫描局域网的服务器(ftp服务器或smb服务器),虽然不需要自己输入,但是扫描速度比较慢,自己输入往往更加快速)
  - solid explorer
  - es explorer
- cx file explorer传输实例
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/045dd2535d9b4ce7b30c7db819cf0f61.png)

### ES文件浏览器

ES文件浏览器是一款常见的文件管理器软件,对常见的文件传输协议提供了支持

ES文件浏览器提供的文档简要介绍了smb协议及其相关软件的配置和使用方法

- [ES APP GROUP (estrongs.com)](http://www.estrongs.com/helper)
- [ES 文件浏览器使用手册 (estrongs.com)](http://www.estrongs.com/helper)
- 软件下载[ES APP GROUP (estrongs.com)](http://www.estrongs.com/?lang=zh-CN)

### FAQ:检查共享文件夹间的嵌套

- 被共享文件夹可以通过windows资源管理器地址栏中输入`\\localhost`查询
- 该结果仅显示非父子目录的文件夹或文件,如果某两个目录有层次关系,那么仅显示父目录(祖先目录,而不显示子目录或后代目录)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/9d2da7bfb22441cb9e5787e399253766.png)



### 不同用户文件无法访问

- 设某个用户`cxxu`家目录下的某个文件夹被设置为共享文件,那么这个文件夹无法被其他用户访问,哪怕在设置共享文件夹时允许任何人访问,也是无法访问的
- 只有登录`cxxu`的身份,才能有效访问`cxxu`在本机的目录下的且被设置为共享文件夹的目录
- 因此选择共享文件夹是,目的要明确,如果是只为自己服务,那么目录可以设置在自己的家目录下,其他用户用户无法通过smb协议访问到,只有自己能够访问,适合私密文件
- 私密文件也可以放到非家目录位置,我们通过设置共享权限也可以阻止不想要的访问
- 如果希望公开给其他人,那就应该在公共目录,比如非系统盘,或者系统盘的Public目录,否则不容易给其他用户共享
- 其实说到这里,已经超出了纯粹的文件传输的目的,这些额外的权限问题提供了更加精细的控制,自己用的话随便都可以,登录自己的账户就可以愉快的传输文件了,也不用创建一个给大家用的账户,也不用考虑将某些目录其他用户访问不了的问题



## 比较和总结

- ftp和smb协议的共同点

  - 一次性配置:几乎配置一次之后不需要再配置(ftp也不需要反复配置);哪怕重启计算机后,会自动建立服务除非手动停止或移除相关服务
    - 这里建议当不需要的时候停止服务,服务会占用一定资源;
    - 或者经常用的话推荐采用用户登录的方式,而不采用匿名登录,更加安全,毕竟服务一直挂在那里,不太放心)

  - 跨平台

- 通常我会推荐SMB协议

  - 因为它配置上比ftp更简单,特别是一个人自己用的时候,配置起来更加简单,用已有的windows账户就可以登录(比如本地账户的pin作为登录密码)
  - 更安全

### 其他用户访问smb服务器@共享文件夹

- 对于windows系统,访问共享文件夹(smb服务器,不需要写协议名,直接用`\\`代替表示smb协议)

- 可以按下**win+r**启动"运行"窗口(Run),输入`\\ip\FolderName`格式的链接回车运行

#### 小结

- 为了便于说明,设ip地址为`192.168.1.158`;而共享文件为`share`,则输入`\\192.168.1.158\share`进行访问
  - 这里**FolderName**字段直接填写被作为共享文件夹的文件夹名字即可,不需要指出它在哪个盘
  - 因为系统知道当前有哪些文件夹处于被共享状态
    - 可以按下**win+r**启动执行`\\localhost`查看
  - 如果是测试访问当前主机自身的共享文件夹,可以输入`\\127.0.0.1\share`
- 如果是用powershell命令行也可以,输入`start \\ip\FolderName`这种格式的命令,例如`start \\127.0.0.1\share`,这里**start**是**Start-Process**的缩写

#### 补充👺

- windows系统设备作为客户端访问共享文件夹(smb服务器)

  - 方式有好几种:[6 Ways to Access a Shared Folder in Windows 11 (makeuseof.com)](https://www.makeuseof.com/ways-to-access-shared-folders-in-windows-11/)

- 命令行挂载为驱动器

  - [Net use | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/gg651155(v=ws.11))

    - 例如:

      - ```bash
        PS C:\Users\cxxu\Desktop> net use T: \\localhost\share
        The command completed successfully.
        ```

        - 当共享文件夹`share`可以匿名访问时,命令可以执行成功
        - 并且会在资源管理器挂在一个T盘

  - 也可以用图形界面映射smb驱动器

### 传输速率问题

- 至于传输速度上,根据不同设备和环境情况,不一定说哪个更快

  - 有些环境FTP快,有些环境smb快

  - 但如果中间设备性能差,例如某些家用无线路由器比较差,则传输速度很慢,还不如手机开热点建立简单局域网进行传输(这不会消耗流量,放心传输)

  - 另外如果通过wifi路由器构成的局域网,注意信号不能太差,会影响传输速度

    





