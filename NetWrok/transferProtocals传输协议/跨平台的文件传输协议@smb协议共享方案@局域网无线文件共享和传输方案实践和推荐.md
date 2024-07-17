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



## 访问smb共享文件夹👺



### Windows 系统

可以用`net use`或powershell `New-SmbMapping`来挂载

详情另见它文,详细介绍这一情形:[windows@资源管理器中的地址栏@访问共享文件夹的各种方法@管理共享文件夹_windows 路径中的@-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/140139320?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"140139320"%2C"source"%3A"xuchaoxin1375"})

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

    





