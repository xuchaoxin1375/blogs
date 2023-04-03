[toc]

-  ssh远程连接@远程文件传输scp@sftp@Linux查看ip地址的若干种方式

# 远程文件传输scp@sftp

## GUI方案

- 有VNC Viewer,mobaXterm等



### VNC Viewer

- VNC Viewer:[Download VNC Viewer | VNC® Connect (realvnc.com)](https://www.realvnc.com/en/connect/download/viewer/)
  - [RealVNC Help Center](https://help.realvnc.com/hc/en-us)
- VNC Viewer是一款远程桌面客户端软件，它可以连接到运行了VNC Server的计算机，从而实现远程桌面控制。VNC（Virtual Network Computing）是一种远程桌面协议，它可以让用户在本地计算机上通过网络连接远程计算机的桌面环境，从而实现远程控制。VNC Viewer是VNC协议的客户端实现，它可以在Windows、Linux、macOS等操作系统上运行。使用VNC Viewer，用户可以在本地计算机上查看并控制远程计算机的桌面环境，就好像自己坐在远程计算机前一样。
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210619185553211.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


## CLI通用方案

- 详见后文

# OpenSSH

- [OpenSSH官方文档](https://www.openssh.com/manual.html)：https://www.openssh.com/manual.html

## ssh连接👌🎈

- ssh方式连接到主机很有用,特别是远程主机没有安装图形界面的时候(节约云服务器的资源占用)

### vscode ssh

- 可以通过vscode提供的 `remote-ssh`插件,来利用本地可视化编辑器(其他IDE可能也有其自己的远程编程支持)来编辑远程代码

  - 这不是必须的,但是有时可以提供便利

  - [Connect over SSH with Visual Studio Code](https://code.visualstudio.com/docs/remote/ssh-tutorial)

### CLI ssh

- [ssh(1) - OpenBSD manual pages](https://man.openbsd.org/ssh)

- SSH（Secure Shell）是一种安全的远程登录协议，可以在本地计算机和远程计算机之间建立加密的通信连接。SSH协议支持多种功能，包括远程登录、文件传输、远程命令执行等。以下是SSH命令的语法简介：

  - `ssh [options] [user@]hostname [command]`

  - 其中，“ssh”是SSH命令，options是可选的参数，user是远程计算机的用户名，hostname是远程计算机的IP地址或主机名，command是要在远程计算机上执行的命令。如果没有指定命令，SSH会默认打开一个远程登录会话，让用户可以在远程计算机上执行命令和操作。

- 常用的SSH命令选项包括：

  - -p：指定SSH连接的端口号，默认为22；
  - -i：指定SSH连接的私钥文件；
  - -A：开启SSH代理转发，用于在远程计算机上访问本地计算机的网络资源；
  - -X：开启X11转发，允许在远程计算机上运行图形界面应用程序；
  - -v：输出详细的调试信息，用于排除连接问题和故障。

- 除了SSH命令本身，还有其他相关的命令和工具，如scp、sftp、ssh-keygen等，用于在SSH协议下进行文件传输、密钥管理等操作。

- Notes:

  - 购买的云主机也是类似的方式链接
  - 注意,如果仅仅指定ip而不指定远程主机上的用户名,将无法以用户的形式登录控制远程主机

### ssh链接局域网主机@本地虚拟机

- 以本地linux虚拟机为例
- 登录虚拟机,查看虚拟机的相关信息(ip地址或者用户名都可以,通常ip地址更加通用!):

#### 查询登录目标信息(IP地址@用户名@主机名)

- 查询**ip地址**:

  - ```bash
    #( 03/23/23@ 9:21PM )( cxxu@u20 ):   ifconfig
    ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 192.168.128.129  netmask 255.255.255.0  broadcast 192.168.128.255
            inet6 fe80::2d84:3ce5:ee20:b4c0  prefixlen 64  scopeid 0x20<link>
            ether 00:0c:29:64:82:39  txqueuelen 1000  (Ethernet)
            RX packets 43955  bytes 54388626 (54.3 MB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 9135  bytes 1122451 (1.1 MB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
    
    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 1000  (Local Loopback)
            RX packets 586  bytes 54327 (54.3 KB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 586  bytes 54327 (54.3 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
    
    ```

- 查询**用户名**:

  - 可以使用以下命令来查看当前登录的用户名和主机名：

    ```
    whoami    # 查看当前登录的用户名
    hostname  # 查看当前主机名
    ```

  - 如果需要同时查看用户名和主机名，可以使用以下命令：🎈

    ```
    echo $(whoami)@$(hostname)
    ```

    该命令会输出当前登录的用户名和主机名，中间以“@”符号连接，例如：`cxxu@u20`

    ```
    # cxxu @ u20 in ~ [21:38:43]
    $ echo $(whoami)@$(hostname)
    cxxu@u20
    ```

    其中，“john”为当前登录的用户名，“ubuntu”为当前主机名。

- 采用用户名方式连接示例

  - ```bash
    PS C:\Users\cxxu\.ssh> ssh cxxu@u20
    The authenticity of host 'u20 (fe80::2d84:3ce5:ee20:b4c0%14)' can't be established.
    ED25519 key fingerprint is SHA256:p/oni09I0Sum5zERb7myYMUS1ywRs+ZvI7LXogpWCT0.
    This key is not known by any other names
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    Warning: Permanently added 'u20' (ED25519) to the list of known hosts.
    cxxu@u20's password:
    Welcome to Ubuntu 21.10 (GNU/Linux 5.13.0-46-generic x86_64)
    
     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage
    Last login: Sun Sep 11 03:51:20 2022 from fe80::c1f1:349f:8708:b1fd%ens33
    ...
    [oh-my-zsh] Random theme 'ys' loaded
    # cxxu @ u20 in ~ [21:36:16]
    $
    ```

## config文件

- SSH客户端在连接远程主机时，可以使用配置文件来管理SSH连接选项和主机别名，这个配置文件就是.ssh/config文件。在该文件中，可以为每个远程主机指定不同的SSH连接选项和别名，以便于快速连接和管理远程主机。

  .ssh/config文件位于用户主目录下的.ssh目录中，如果该目录或文件不存在，可以使用以下命令创建：

  ```
  mkdir -p ~/.ssh && touch ~/.ssh/config
  ```

- .ssh/config文件的格式如下：

  ```bash
  Host <Alias>
      HostName <RemoteHostName>
      User <RemoteUserName>
      Port <RemotePort>
      IdentityFile <PrivateKeyFile>
      ForwardAgent yes
      # Other options
  ```

  其中，<Alias>是主机别名，<RemoteHostName>是远程主机的IP地址或主机名，<RemoteUserName>是远程主机的用户名，<RemotePort>是SSH连接的端口号（默认为22），<PrivateKeyFile>是SSH连接的私钥文件路径，ForwardAgent选项表示是否开启代理转发。

- 可以使用以下命令为远程主机添加别名和其他连接选项：

  ```http
  Host <Alias>
      HostName <RemoteHostName>
      User <RemoteUserName>
      Port <RemotePort>
      IdentityFile <PrivateKeyFile>
      ForwardAgent yes
  ```

  例如，为远程主机example.com添加别名为“myhost”，可以在.ssh/config文件中添加以下内容：

  ```http
  Host myhost
      HostName example.com
      User myusername
      Port 2222
      IdentityFile ~/.ssh/id_rsa
      ForwardAgent yes
  ```

  这样，可以通过“ssh myhost”命令快速连接到远程主机example.com，并自动使用指定的SSH连接选项。

### ssh连接过程可能的意外情况@config权限

- ```bash
  PS C:\Users\cxxu\Desktop> ssh cxxu@u20
  Bad permissions. Try removing permissions for user: CXXUWN11\\maintainer (S-1-5-21-1862010897-3831421347-3551306287-1002) on file C:/Users/cxxu/.ssh/config.
  Bad owner or permissions on C:\\Users\\cxxu/.ssh/config
  ```

  - 可以根据提示,查看`config`文件内容
    - powershell下执行:`cat $home/.ssh/config`
  - 如果没有重要内容,可以备份后删除`config`文件

- 然后尝试重新执行ssh连接

## scp传输协议

- [scp(1) - OpenBSD manual pages](https://man.openbsd.org/scp)

- SCP（Secure Copy）是一个基于SSH协议的加密文件传输协议，可以在本地计算机和远程计算机之间进行安全的文件传输。如果你需要详细了解SCP的使用方法和参数选项，可以参考以下官方文档

  OpenSSH是一个广泛使用的SSH实现，也是SCP命令的实现者之一。在OpenSSH的官方文档中，有详细的SCP命令说明和示例，以及其他相关命令的说明和使用方法。你可以根据自己的需求，查找相关的文档和示例，以便更好地使用SCP进行文件传输。

  此外，还有一些第三方的SCP客户端和服务器软件，它们也可能有自己的文档和使用说明。如果你使用的是特定的SCP软件，可以在该软件的官方网站或社区中查找相关文档和示例，以便更好地了解和使用该软件。

- 查看本地文档:
  - 在linux(或者windows wsl)下执行 `man scp`获取帮助

### 基本使用方式

- SCP（Secure Copy）是一种在网络上进行加密文件传输的协议。它基于SSH（Secure Shell）协议，可以在不暴露文件内容的情况下，将文件从一个远程计算机复制到另一个远程计算机或本地计算机。

  使用SCP命令进行文件传输时，需要指定源文件和目标文件的路径，以及源文件所在的远程计算机和目标文件所在的远程计算机或本地计算机。例如：

  ```
  scp user@remote:/path/to/source/file /path/to/target/directory
  ```

  该命令会将远程计算机上的“/path/to/source/file”文件复制到本地计算机的“/path/to/target/directory”目录下。其中，“user”为远程计算机的用户名，“remote”为远程计算机的IP地址或主机名，也可以使用远程计算机的别名，例如“myserver”，“/path/to/source/file”为源文件的路径。

- 如果要将本地计算机上的文件复制到远程计算机上，可以使用以下命令：

  ```
  scp /path/to/local/file user@remote:/path/to/target/directory
  ```

  该命令会将本地计算机上的“/path/to/local/file”文件复制到远程计算机的“/path/to/target/directory”目录下。

  SCP命令还支持递归复制目录，以及指定端口号、传输速度等选项。使用SCP命令进行文件传输时，需要保证远程计算机已经安装了SSH服务，并且当前用户拥有SSH访问权限。

- 如果局域网内有多台同名主机,比如都叫`raspberry`时,将 `userName@RaspberrypiHostName`作
  `userName@<RaspberrryIP>`,来区别这些同名主机

### powershell中主机变量名引用变量的方式

- powershell中,使用双引号引住变量名来引用主机名,例如:
  - ` cxxu@"$RemoteHostIP"`

- 但是无法将`userName@hostName`整个的用变量来代替
但可以编写函数:
```powershell
function scp_ali {
    <# 
    .Example
    scp_ali .\pets.txt ~
    _____
    PS D:\repos\blogs\linuxCommandsTutor> scp_ali .\pets.txt ~
    cxxu@12x.xx.x.7's password:
    pets.txt
    #>
    param (
        $source,
        $TargetPath
    )
    scp $source "$cxxuAli`:$TargetPath"
}
```


## sftp传输协议
- sftp功能比较强大

- [SFTP - SSH - Connectors | Microsoft Docs](https://docs.microsoft.com/en-us/connectors/sftpwithssh/)
	- SFTP (SSH File Transfer Protocol) is a network protocol that provides file access, file transfer, and file management over any reliable data stream.
	- It was designed by the Internet Engineering Task Force (IETF) as an extension of the Secure Shell protocol (SSH) version 2.0 to ` provide secure file transfer capabilities`.

### sftp相关工具(mobaXterm)

- [MobaXterm free Xserver and tabbed SSH client for Windows (mobatek.net)](https://mobaxterm.mobatek.net/)
	- 算是一款功能丰富的终端工具
	- 免费版一般够用:下载[MobaXterm Xserver with SSH, telnet, RDP, VNC and X11 - Download (mobatek.net)](https://mobaxterm.mobatek.net/download.html)
	- 支持文件拖曳进行双向传输,记住密码等管理功能

## 对比SCP和SFTP

- SCP和SFTP都是在SSH协议下进行安全文件传输的方式，但是它们的实现方式和使用方法有所不同。
- SCP（Secure Copy）是一个基于SSH协议的加密文件传输协议，它使用的是SSH的SCP命令，可以在本地计算机和远程计算机之间进行安全的文件传输。SCP的使用方法与Linux系统的cp命令类似，可以使用类似“scp source_file destination”这样的命令来进行文件传输，也可以使用通配符进行批量传输。SCP的优点是传输速度快，但是不支持文件和目录的压缩和解压缩。
- SFTP（SSH File Transfer Protocol）是一个基于SSH协议的安全文件传输协议，它使用的是SSH的SFTP子系统，可以在本地计算机和远程计算机之间进行安全的文件传输和管理。SFTP的使用方法与FTP类似，可以使用put、get、ls等命令进行文件的上传、下载和查看，同时支持文件和目录的压缩和解压缩。SFTP的优点是支持多种文件操作，但是传输速度相对较慢。
- 因此，如果你只需要进行单纯的文件传输，可以选择SCP；如果需要进行文件的上传、下载和管理，可以选择SFTP。当然，这两种方式都是安全的，具体使用方法可以根据自己的需求来选择。

# 附

## 查看linux的ip地址方法

- `ip addr show`和`ipconfig`类似

  - ```bash
       ip addr show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host 
           valid_lft forever preferred_lft forever
    2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether 00:0c:29:64:82:39 brd ff:ff:ff:ff:ff:ff
        altname enp2s1
        inet 192.168.128.129/24 brd 192.168.128.255 scope global dynamic noprefixroute ens33
           valid_lft 1398sec preferred_lft 1398sec
        inet6 fe80::2d84:3ce5:ee20:b4c0/64 scope link noprefixroute 
           valid_lft forever preferred_lft forever
    
    ```

    

  - 该命令会输出当前系统的网络接口信息，包括每个接口的IP地址、MAC地址、状态等。

- 如果只需要查看IP地址，可以使用以下命令：🎈

  - `ip addr show | grep inet`

    - 该命令会只输出包含“inet”关键字的行，即IP地址所在的行。

  - 或`ip addr show | grep 192`

  - ```bash
       ip addr show | grep inet
        inet 127.0.0.1/8 scope host lo
        inet6 ::1/128 scope host 
        inet 192.168.128.129/24 brd 192.168.128.255 scope global dynamic noprefixroute ens33
        inet6 fe80::2d84:3ce5:ee20:b4c0/64 scope link noprefixroute 
      
    ```

  - ```bash
    ip addr show | grep 192 
        inet 192.168.128.129/24 brd 192.168.128.255 scope global dynamic noprefixroute ens33
    ```

    

- 如果想要只显示IPv4或IPv6地址，可以使用以下命令：

  - ```
    ip -4 addr show   # 只显示IPv4地址
    ip -6 addr show   # 只显示IPv6地址
    ```

  - ```bash
    # cxxu @ u20 in ~ [21:39:51]
    $ ip -4 addr show   # 只显示IPv4地址
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
    2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        altname enp2s1
        inet 192.168.128.129/24 brd 192.168.128.255 scope global dynamic noprefixroute ens33
           valid_lft 1468sec preferred_lft 1468sec
    ```

    







