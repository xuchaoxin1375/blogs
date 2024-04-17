[toc]




### refs

- ES文件浏览器是一款常见的文件管理器软件,对常见的文件传输协议提供了支持
  - 而ES文件浏览器提供的文档简要介绍了配置和使用方法
  - [ES APP GROUP (estrongs.com)](http://www.estrongs.com/helper)文档支持中英文切换(内容有些老旧,但作为参考也没有太大问题)

## ftp server

- windows自带的方式步骤稍微繁琐
  - 该功能系统往往不会默认启用,需要启动windows的功能
  - 配置防火墙(否则可能其他设备无法访问)
  - 但是不失为一种方案(毕竟作为一种基础通信协议,不需要额外安装软件)
- 参考链接
  - [FTP Sites | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831422(v=ws.11)?redirectedfrom=MSDN#SiteInformation)(官方文档)
  - [FTP Directory Browsing | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831403(v=ws.11)?redirectedfrom=MSDN)(官方文档)
  - [How to set up and manage an FTP server on Windows 10 | Windows Central](https://www.windowscentral.com/how-set-and-manage-ftp-server-windows-10)
  - 可供参考的视频:
    - [【教程】4分钟学会电脑开启ftp，手机上传文件到电脑ftp_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1nS4y147pQ/?spm_id_from=333.337.search-card.all.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)
    - [告别繁琐的Windows共享设置，试试搭建一个FTP来共享文件吧 bilibili](https://www.bilibili.com/video/BV1rL4y1V7zF/?spm_id_from=333.337.search-card.all.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

### 下面是核心步骤

- windows控制面板中启用windows相关功能

  - | 启用FTP和WEB功能                                             | 设置防火墙                                                   |      |
    | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
    | ![请添加图片描述](https://img-blog.csdnimg.cn/direct/6b21045a7ce04bcc92dcea42e7284df9.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/52e263ad45ff451cbfecc5e0da2ee775.png) |      |
    | 可以通过windows开始菜单(快捷键**win+s**搜索:**windows功能**或**windows features**快速打开;<br />先按照左侧勾选的那样尝试是否可以工作(都勾选当然没问题,可能会占用更多资源罢了) | 同样可以通过搜索快速打开防火墙设置<br />或者通过命令行输入`Firewall.cpl`快速启动该面板 |      |
    |                                                              |                                                              |      |

- 启动IIS并设置FTP服务站点

  1. 可以在快捷键**win+r**下输入`%windir%\system32\inetsrv\InetMgr.exe`快速启动

     - 或者在**win+s**下输入`IIS`搜索,找到**Internet Information Services (IIS) Manager**,
     - 它的所在目录可能是这样的"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools\IIS Manager.lnk"

  2. 配置站点

     - 站点配置是很灵活的,可以根据自己的需要灵活配置,可以简单配置,也可以精细地配置

     - 简单的**匿名访问**配置

       - |                                                              |                                                              |
         | ------------------------------------------------------------ | ------------------------------------------------------------ |
         | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/e5021b414f0747beb715692a2f4b3727.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/79dffedfba744fa3a222b70df3a310b5.png) |
         | ftp站点绑定的目录如果要作为匿名可访问,则建议设再D盘或其他系统盘之外的盘的某个文件夹或根目录下(C盘的某些和用户相关的目录要求登录用户账户密码,无法支持匿名登录,尽管ftp站点设置为匿名登录,这个要注意一下) | 例如站点目录设置在某个用户的桌面,那么意味着链接该ftp需要账号密码而无法匿名登录,这是为了安全起见 |
         | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/941d9e323968456eb0fb0517a2946970.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/57e59138a16148b6b86017c717427757.png) |
         | 设置为无需SSL                                                | 简单起见,设置为所有用户可以访问                              |

- 其他设置

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/65c54bd898044bfdb194903b0d16df1b.png)
  - 例如停止或重启ftp服务器,也可以移除它
  - 右侧的面版是拓展功能,一般用不上

### FAQ

- 如果使用过程中体验不要,例如容易上传某些文件时会出现权限错误,有的可以传,有的会失败,可以考虑
  - 更改传输失败的文件的文件名,最好时纯英文字母的名字,后期再改回来(或者压缩,更名)
  - 或者更换专业的传输软件(使用更合适的协议)进行传输



## smb server

- windows 默认和推荐的局域网传输协议,windows不强调其提供的共享功能是基于smb协议,但是功能背后的协议是smb协议
- smb协议迭代了多个版本,现在已经是`SMBv3`,即第3个版本
- 对于windows系统而言,基于smb配置简单(用户甚至不需要知道smb协议就可以完成配置),且传输较为安全高效
- 本文主要介绍windows下如何使用smb(共享文件夹);linux系统另见它文

### linux Samba

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

- ```bash
  
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

- 例

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

    

### linux 桌面版 资源管理器访问smb 共享文件夹

- 使用smbclient 命令行界面不是太美观
- 对于有图形界面的linux系统,用其资源管理器可以通过`smb://ip-address/sambashare`的格式来访问
- 经过实验,无论发出共享的服务器端系统是windows还是linux,都可以用上述格式的链接用文件管理器的地址栏进行浏览(但么有桌面的linux就只能用命令行访问)

### windows系统下的共享文件夹



### 设置共享文件夹

- 官方文档,列举出了问题清单和相应的解决办法和步骤,已经给出了最佳实践,这里仅提一下(整合其他设置方案)

  - [在 Windows 中通过网络共享文件 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/在-windows-中通过网络共享文件-b58704b2-f53a-4b82-7bc1-80f9994725bf)
  - [File sharing over a network in Windows - Microsoft Support](https://support.microsoft.com/en-us/windows/file-sharing-over-a-network-in-windows-b58704b2-f53a-4b82-7bc1-80f9994725bf)


### 方法1

- 使用共享文件夹引导程序`shrpubw.exe`,这是一个windows系统自带的一个使用程序

  - 打开windows命令行,输入`shrpubw.exe`即可启动

- `shrpubw.exe` 是一个在 Microsoft Windows 操作系统中用于帮助用户创建和配置共享文件夹的向导程序。这个可执行文件（.exe）是系统自带的一部分，由 Microsoft Corporation 开发，主要用于简化网络共享设置过程。

  当用户需要在网络上共享本地计算机上的某个文件夹，以便其他网络用户可以访问时，可以通过运行 `shrpubw.exe` 启动“创建共享文件夹向导”。该向导提供了图形化界面，引导用户完成以下步骤：

  1. 选择要共享的文件夹路径。
  2. 设置共享名，即网络上其他用户看到的共享资源的名称。
  3. 配置共享权限，包括哪些用户或组可以访问此共享，并确定他们的读写权限级别。

- 该引导软件支持它会更改防火墙使得共享文件夹能够生效(通常不需要我们自己再去设置防火墙)

- 总的来说这是个很方便的程序,但是注意,windows为了安全,匿名访问可能是不被允许的,如果需要匿名,可能要改注册表策略组等,我的建议是创建一个名为smb的用户专门用来访问共享文件夹就可以了(不需要登录该用户桌面),既安全又高效,如果要匿名的体验,可以把密码设置简单点即可

### 方法2



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

### 右键设置共享文件夹

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/59a7f585925246f3a8f895b7979dca1b.png)

- 可以指定对那些人共享(进入设置可以允许任何用户访问,但是不保证匿名访问可行,可能需要进一步设置)
  - 对于启用了SMB1功能的及其可能默认允许匿名访问

### 查看所有已经共享的文件夹

- 有如下方式可以检查

  - 在资源管理器中的地址栏输入`\\localhost`
  - 或者命令行中输入`start \\localhost`

  

### 停止某个文件的共享

- 方法1

  - |                                                              |                                                              |      |
    | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
    | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/f3c0981b9f854e9c81f901eac8bd818d.png) | 右键目标文件夹,选择高级设置,将取消勾选分享次文件夹(share this folder);把保存修改即可 |      |

- 方法2:从资源管理器中找到目标文件夹,右键更改访问权限,选择移除访问权限(remove access),但是不一定所有文件夹都能找到移除按钮

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

### FAQ

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

    





