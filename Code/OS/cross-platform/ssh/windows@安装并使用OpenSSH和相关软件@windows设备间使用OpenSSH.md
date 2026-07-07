[toc]

## abstract

- 本文介绍和实验了windows设备之间使用ssh连接远程控制
- 实验平台为windows10,windows11

## windows上使用openSSH方案参考资料

windows上需要手动安装ssh server软件(拓展模块),并且配置防火墙和服务自启动等设置

本节仅列出参考连接,**具体的操作方法,见下一章节**

### 适用于win10的方案

以下方案对系统有要求,并且依赖于图形界面的操作,不适合大规模部署

推荐使用通用方案来配置openssh

[OpenSSH for Windows 概述 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_overview)

[Get started with OpenSSH for Windows | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=gui#connect-to-openssh-server)

此外，官方文档还介绍了更多连接以及可以自定义配置的方案

[Key-based authentication in OpenSSH for Windows | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)

[OpenSSH Server configuration for Windows | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_server_configuration)

中文文档:

[适用于 Windows 的 OpenSSH 服务器配置 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_server_configuration)

### 更通用方案(脚本化配置)


- 更一般的ssh方案(基于powershell)
  - [运行远程命令(相关协议) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/security/remoting/running-remote-commands?view=powershell-7.4)
  - [通过 SSH 进行 PowerShell 远程处理 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/security/remoting/ssh-remoting-in-powershell?view=powershell-7.4)
  - 相关软件仓库[PowerShell/Win32-OpenSSH: Win32 port of OpenSSH (github.com)](https://github.com/PowerShell/Win32-OpenSSH)
- 适用于win7及以上的系统(至少有windows powershell ),更加通用(安装方式也有多种)

  - 提示:对于windows 7可以安装系统更新补丁将powershell版本升级到powershell5.1,并且可选的可以安装powershell7.2
  - [Install Win32 OpenSSH Using MSI · PowerShell/Win32-OpenSSH Wiki · GitHub](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH-Using-MSI)
    - 这种方式最简单,最推荐,可以选择仅安装Client或者Server(默认都安装),对于win7也很友好
  - [Install Win32 OpenSSH · PowerShell/Win32-OpenSSH Wiki · GitHub](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH)
    - 我为这种安装方法整合了一个脚本,让win10以及之后的系统也可以很简单安装OpenSSH
    - 并且包含了对服务端的基本设置(防火墙,立即启动sshd服务,设置开机自启,设置登录的默认shell)
  - 您可以参考后面的章节,命令行方式部署还有scoop方案,也很方便



## 软件安装和配置方案🎈

这里主要介绍**服务端**的配置

客户端win10后自带,对于win7也可以使用win32 openssh,这边不赘述



### 新系统方案:win10之后的安装配置方法


- 下面这种方式是面向当前的主流系统的安装方式,只需要一条命令;
- 但是国内网络环境下，不一定是最快的方式,特别是国内用户,下载windows功能的途径比较受限,默认方法下载速度慢;代理软件可能需要使用虚拟网卡模式才能代理加速;

- 在server端安装必要的ssh服务软件

  - 管理员方式运行powershell执行以下内容:

    ```powershell
    # Install the OpenSSH Server
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    ```

  - 这一节不是本文的重点:详情另见它文(防火墙配置等) [适用于 Windows 的 OpenSSH 入门 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell#install-openssh-for-windows)

### 兼容性方案安装(重点)👺

- 有多种安装方式,都挺方便的,兼容win7及以上的系统;
- 这里现介绍openssh 的下载和安装
- 然后介绍注册`sshd`服务(如果你需要将某台windows设备设置为ssh server)

#### 使用scoop安装openssh👺

- win7无法直接使用scoop,需要安装更新补丁,将windows powershell5.1才行;

- 但如果scoop可用,且配置了可用代理,那么scoop安装openssh服务可能是最快且最可控的方案了!

- 因此在win7上酌情考虑是否仍然使用scoop安装(推荐win7用户安装更新补丁到windows powershell5.1,并且安装powershell7(最高支持powershell7.2 更高版本要求win8.1以上系统))

- 此外,默认的scoop也很慢,建议使用国内优化版的scoop加速下载和部署

  - [SSH on Windows · ScoopInstaller/Scoop Wiki (github.com)](https://github.com/ScoopInstaller/Scoop/wiki/SSH-on-Windows)

  - 这个文档介绍如何使用用scoop安装openssh,并且连接到已有的ssh server;配置windows ssh server 需要另见它文

  - 下面简述以下scoop安装了openssh后,如何安装(注册)`sshd`服务,成为windows openssh server:

    ```powershell
    scoop install openssh # -g 可以选择全局安装,需要管理员权限
    $p=scoop which sshd ;$dir=Split-Path $p;cd $dir; & .\install-sshd.ps1
    #END
    ```
  
- scoop安装openssh如果下载顺利的话使用很方便,相关环境变量都不用配置了

##### 注册sshd为服务

不同方式安装的ssh-server 注册服务脚本可能不一样;

对于scoop安装的情况,将sshd安装(注册为)服务的过程输出记录示例

```powershell
  [*] C:\ProgramData\scoop\apps\openssh\current\moduli
Inheritance is removed from 'C:\ProgramData\scoop\apps\openssh\current\moduli'.
'BUILTIN\Users' now has Read access to 'C:\ProgramData\scoop\apps\openssh\current\moduli'.
      Repaired permissions

[SC] SetServiceObjectSecurity 成功
[SC] ChangeServiceConfig2 成功
[SC] ChangeServiceConfig2 成功
sshd and ssh-agent services successfully installed
```

后续执行配置:

- 验证/启用sshd服务;
- 设置服务启动类型
- 设置防火墙

详情参考后续章节

#### 官方下载安装

官网提供了主要的两类方式安装

##### msi包安装

下载msi包,然后用命令行或双击包文件安装
The MSI will install OpenSSH to the `ProgramFiles\OpenSSH` folder.

默认会一并安装ssh客户段和ssh server端

The commands to run, are as follows:

- To install both the `SSH Client & the SSH Server` (default behavior)
  
  ```cmd
  msiexec /i <path to openssh.msi>
  ```

- 如果命令行安装过程中报错,尝试双击打开`.msi`包文件安装


###### others

- To install only the SSH Client
  `msiexec /i <path to openssh.msi> ADDLOCAL=Client`
- To install only the SSH Server
  `msiexec /i <path to openssh.msi> ADDLOCAL=Server`
- To uninstall only the SSH Client
  `msiexec /i <path to openssh.msi> REMOVE=Client`
- To uninstall only the SSH Server
  `msiexec /i <path to openssh.msi> REMOVE=Server`

###### Examples:

- Installing SSH Client & openssh.msi is in the working directory:
  `msiexec /i openssh.msi ADDLOCAL=Client`
- Installing SSH Server & openssh.msi is in C:\users\public\downloads:
  `msiexec /i C:\users\public\downloads\openssh.msi ADDLOCAL=Server`
- Uninstalling SSH Client & openssh.msi is in the working directory:
  `msiexec /i openssh.msi REMOVE=Client`
- Uninstalling SSH Server & openssh.msi is in C:\users\public\downloads:
  `msiexec /i C:\users\public\downloads\openssh.msi REMOVE=Server`

##### 脚本方式安装方法

下面给出的是通过脚本离线安装的方案

Install Win32 OpenSSH (test release) 

这个离线包只有几MB,所以不会下载太久(github release镜像加速下载也可以)

1. Win32-OpenSSH Github releases can be installed on Windows 7 and up.
2. Note [these considerations](https://github.com/PowerShell/Win32-OpenSSH/wiki/Various-Considerations) and [project scope](https://github.com/PowerShell/Win32-OpenSSH/wiki/Project-Scope) first.
3. Download the [latest](https://github.com/PowerShell/Win32-OpenSSH/releases/latest) build of OpenSSH. To get links to latest downloads [this wiki page](https://github.com/PowerShell/Win32-OpenSSH/wiki/How-to-retrieve-links-to-latest-packages).
4. Extract contents of the latest build to `C:\Program Files\OpenSSH` (Make sure binary location has the Write permissions to just to SYSTEM, Administrator groups. Authenticated users should and only have Read and Execute.)
5. Modify the following Powershell Script(if you download the file in the user home download directory,just paste and run directly)

###### 脚本解压安装文件到指定位置👺

- 以下脚本为win10以上的设备部署OpenSSH(win32版本)
  - 虽然win32版本的openssh支持win7,但是由于win7上的powershell版本太低,所以无法执行本脚本(无法直接解压压缩包)
  - 因此本脚本仅在powershell7(支持win8.1以上)做过测试,其他版本powershell支持情况未知(应该也支持powershell 5,防火墙那里可以使用传统命令`netsh advfirewall firewall`配置)
  - 所以如果您的系统是win7,请前面提到的参考连接给出的步骤手动设置
- 执行下面第一个脚本(第一个路径变量做必要的修改),将ssh clinent,ssh server文件释放和安装
  - 其中的`$Openssh_home`目录位置可以稍微灵活一点,只是推荐的位置是放在`C:\program files`下面的某个子目录里面,深一点也可以

```powershell
# 使用管理员权限powershell窗口执行以下命令#In an elevated Powershell console, run the following
$file = '~/downloads/Openssh*.zip' #这个目录改为您自己下载的ssh包路径
$OpenSSH_home = 'C:\program files\OpenSSH'

# $OpensshZip = "$($file.Directory)/OpenSSH.zip"
# Move-Item $file $opensshZip
#释放文件
Expand-Archive -Path $file -DestinationPath $OpenSSH_home  -Verbose
Get-ChildItem $OpenSSH_home


```

###### 注册sshd为系统服务🎈

```powershell
#找到sshd安装脚本,注册sshd为系统服务
#$install_script = "$OpenSSH_Home/install-sshd.ps1"
$install_script_dir=(ls "$OpenSSH_Home/Openssh-win*/")[0]
$install_script="$install_script_dir/install-sshd.ps1"
powershell.exe -ExecutionPolicy Bypass -File $install_script

```



## sshd服务设置和基本防火墙配置🎈

额外设置:对于服务端(基本防火墙配置和服务启用),继续执行以下内容

```powershell
#Open the firewall for sshd.exe to allow inbound SSH connections

# New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

#Note: New-NetFirewallRule is for Windows 2012 and above servers only. If you're on a client desktop machine (like Windows 10) or Windows 2008 R2 and below, try:

netsh advfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22

#Start sshd (this will automatically generate host keys under %programdata%\ssh if they don't already exist)

net start sshd
#To setup this service to auto-start:
Set-Service sshd -StartupType Automatic

# (可选)设置默认shell为powershell;
#To config default shell (use powershell as default):
New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -PropertyType String -Force
# 又比如:
New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value 'C:\scoop\apps\powershell\current\pwsh.exe' -PropertyType String -Force

# (可选设置 OpenSSH 在执行“远程命令”时传给默认 Shell 的参数。(需要注意：/c 更适合 cmd.exe，不太适合 pwsh)
New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShellCommandOption -Value '/c' -PropertyType String -Force
```

现在,此时这台设备既可以充当ssh服务端,也可以作为客户端

包装成powershell函数,详情参考:[PS/SSH/SSH.psm1 · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/PS/SSH/SSH.psm1)

其中的`Deploy-SSHVersionWin32Zip `函数,如果误报违规,请下载仓库再查看

### 服务状态检查

```powershell
 Get-Service ssh*

Status   Name               DisplayName
------   ----               -----------
Stopped  ssh-agent          OpenSSH Authentication Agent
Stopped  sshd               OpenSSH SSH Server
```

如果你无法启动sshd服务,请进入到执行`sshd -d`以调试模式执行查看输入打印的问题;

如果是端口占用问题,尤其是系统上是否安装了**wsl**并启用了相关端口(默认22),网络模式如果是`mirror`会影响windows系统(默认绑定22端口,导致服务启动失败，这种情况在，考虑修改`sshd_config`配置文件,不要都用22端口即可)

```powershell
#⚡️[opcxxu@OP-XCX][<以:192.168.1.32>][~\scoop\apps\openssh\current]
.\sshd.exe -d
debug1: sshd version OpenSSH_for_Windows_10.0 Win32-OpenSSH-GitHub, LibreSSL 4.2.0
debug1: private host key #0: ssh-rsa SHA256:agHkCoyX5dQ8C04PAGXTafodGwPP5VHO+XsZDBZb4lE
debug1: private host key #1: ecdsa-sha2-nistp384 SHA256:HUaGbhtS7ydGmFg142F8GT6jZ0n749z6Oc+YF5StGM8
debug1: private host key #2: ssh-ed25519 SHA256:Z5ODfSITzOLTk32Vfcl2r1+RLVJwk04+MORpkALHbl0
debug1: get_passwd: lookup_sid() failed: 1332.
debug1: rexec_argv[1]='-d'
debug1: Bind to port 22 on ::.
Bind to port 22 on :: failed: Permission denied.
debug1: Bind to port 22 on 0.0.0.0.
Bind to port 22 on 0.0.0.0 failed: Permission denied.
Cannot bind any address.
```



### 其他

Optional
- To configure a default shell, see [here](https://github.com/PowerShell/Win32-OpenSSH/wiki/DefaultShell)
- To migrate sshd configuration from older versions (0.0.X.X), see [here](https://github.com/PowerShell/Win32-OpenSSH/wiki/Migrate-sshd_config-from-older-versions)

### 配置文件sshd_config🎈

在 Windows 中，sshd 默认从 `%programdata%\ssh\sshd_config` 中读取配置数据。 

如果使用powershell,可以通过如下路径访问`$env:programdata\ssh\sshd_config`:

```powershell

PS> gi $env:programdata\ssh\sshd_config

 Directory: C:\ProgramData\ssh

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          2025/10/22    20:09           2230 sshd_config
```



可以通过使用`sshd.exe`参数运行`-f`来指定其他配置文件。 如果该文件缺失，sshd 会在服务启动时生成一个具有默认配置的文件。

以下部分介绍可通过sshd_config中的条目实现的特定于 Windows 的配置设置。 还有其他可能的配置选项未在此列出。 [Win32 OpenSSH 文档中](https://github.com/powershell/win32-openssh/wiki)详细介绍了它们。

 提示

OpenSSH 服务器（sshd）在服务启动时读取配置文件。 对配置文件所做的任何更改都需要重启服务。

### 配置环境变量以便捷启动

- 按上面的方式安装后必须进入到`ssh.exe`所在目录中才能使用`ssh.exe`命令,或者每次输入`ssh.exe`的完整路径来调用,这十分不方便,为了改进这一点,需要配置环境变量

  - 先检查目录例如,我的`ssh.exe`所在目录为`C:\program files\OpenSSH\OpenSSH-Win64`,那么就将这个目录添加到环境变量`Path`中

  - 添加方法很简单,有图形化操作添加,也有命令行方式添加,都可以做到永久添加,如有不懂自行查阅资料

    ```powershell
    PS C:\program files\OpenSSH\OpenSSH-Win64> ls
    
    
        目录: C:\program files\OpenSSH\OpenSSH-Win64
    
    
    Mode                LastWriteTime     Length Name
    ----                -------------     ------ ----
    d----          2024/8/3     22:36            _manifest
    -----        2023/12/13     16:42      16775 FixHostFilePermissions.ps1
    -----        2023/12/13     16:42      15805 FixUserFilePermissions.ps1
    -----        2023/12/13     16:42      20527 install-sshd.ps1
    -----        2023/12/13     16:44    1885752 libcrypto.dll
    -----        2023/12/13     16:38      18934 LICENSE.txt
    ```

## 基础连接和使用

- Client连接Server

  - 一般的连接命令行格式`ssh user@server`

  - 如果两个设备都开启了**网络发现**,那么可以用以下格式连接:`ssh user@serverName`(也就是用主机名代替内网ip地址)

    - > 对于小型网络通常不用关心域,完整格式其实是`ssh domain\username@servername`,而经常省略掉`domain\`这部分内容

    - ```powershell
      PS C:\Users\cxxu> ssh cxxu@redmibookpc
      #如果是初次连接,会有一段安全询问,通常输入yes即可
      cxxu@redmibookpc's password:
      Microsoft Windows [版本 10.0.19045.4529]
      (c) Microsoft Corporation。保留所有权利。
      
      cxxu@REDMIBOOKPC C:\Users\cxxu>
      ```

  - 或者用`ssh user@serverIp`的格式来连接

    - ```powershell
      PS> ssh cxxu@192.168.1.198
      #如果是初次连接,会有一段安全询问,通常输入yes即可(这里演示第一次连接的询问)
      The authenticity of host '192.168.1.198 (192.168.1.198)' can't be established.
      ED25519 key fingerprint is SHA256:+iQOIn71iEoPaKOzM8PXC7vyqCY3QC8yGolnxdN2ncs.
      This host key is known by the following other names/addresses:
          C:\Users\cxxu/.ssh/known_hosts:13: redmibookpc
      Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
      Warning: Permanently added '192.168.1.198' (ED25519) to the list of known hosts.
      cxxu@192.168.1.198's password:
      Microsoft Windows [版本 10.0.19045.4529]
      (c) Microsoft Corporation。保留所有权利。
      
      cxxu@REDMIBOOKPC C:\Users\cxxu>
      
      ```

如果设置了非默认端口,那么登录命令中要使用`-p <port>`来指定端口号

使用`-v`可以在链接不上时显示详细信息,有助于诊断问题;

## 配置免密登陆ssh

- 另见它文 [windows@openssh免密登陆配置@基于powershell快速配置脚本-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/142217418?sharetype=blogdetail&sharerId=142217418&sharerefer=PC&sharesource=xuchaoxin1375&spm=1011.2480.3001.8118)

## 配置默认shell 👺

- [适用于 Windows 的 OpenSSH 服务器配置 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_server_configuration#configuring-the-default-shell-for-openssh-in-windows)

- windows ssh server默认的shell是cmd,这是一个过时的shell

- 我们可以更改为powershell或其他shell


### 准备工作

- 首先查看openssh是否安装在默认路径:

  ```powershell
  $env:path -split ';'|sls ssh
  ```

  例如

  ```powershell
  PS> $env:path -split ';'|sls ssh
  
  C:\WINDOWS\System32\OpenSSH\
  
  ```

- 然后需要修改注册表,并且可以通过一个一句就可以实现修改

### 一键修改命令行👺

- 首先登录到**windows  ssh server**,确保shell处于**管理员模式**

- 然后选择以下一个语句进行执行

  - 修改为自带的powershell版本

    ```powershell
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
    ```

  - 修改为powershell7(注意路径(pwsh.exe的路径)要修改为你实际的安装路径,建议使用绝对路径防止出错)

    ```powershell
    $pwshPath="C:\Program Files\powershell\7\pwsh.exe" #典型路径,scoop安装的路径可能形如:C:\scoop\apps\powershell\current\pwsh.exe
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $pwshPath -PropertyType String -Force
    
    ```
  
  - scoop版安装的powershell作为默认的ssh链接的shell👺
  
    ```powershell
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\ProgramData\scoop\shims\pwsh.exe" -PropertyType String -Force
    
    ```
  
    

### 修改实操

- 示例:修改为powershell7

  ```powershell
  PS☀️[BAT:71%][MEM:33.23% (10.54/31.71)GB][21:51:41]
  #⚡️[cxxu@COLORFULCXXU][~]
  PS> New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\powershell\7\pwsh.exe" -PropertyType String -Force
  
  DefaultShell : C:\Program Files\powershell\7\pwsh.exe
  PSPath       : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\OpenSSH
  PSParentPath : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE
  PSChildName  : OpenSSH
  PSDrive      : HKLM
  PSProvider   : Microsoft.PowerShell.Core\Registry
  ```

  从ssh Client 建立ssh连接,可以看到,默认shell为powershell7

  ```powershell
  PS> ssh cxxu@redmibookpc
  PowerShell 7.4.3
  PS C:\Users\cxxu> 
  ```


### FAQ:免密登陆失效

- 正确设置默认的ssh server shell对于ssh登陆很重要,尤其是免密登陆,依赖于正确设置登陆shell
- 否则之前成功免密登陆,错误配置后可能就不行了

## 补充:公钥文件

`authorized_keys` 文件是 SSH 公钥认证机制的核心部分，它存储在用户的 `.ssh` 目录下，并且对于每个 SSH 用户都可能是独一无二的。这个文件包含了一系列的公钥，用于认证 SSH 客户端发起的连接请求。当一个 SSH 客户端尝试使用私钥登录时，服务器会检查 `authorized_keys` 文件中的公钥，以验证客户端提供的密钥是否匹配。

下面是一些关于 `authorized_keys` 文件的重要细节：

### 文件格式

`authorized_keys` 文件中的每一行通常包含四个主要部分，它们由空格分隔：

1. **密钥类型**：例如 RSA、DSA、ECDSA 或 ED25519。
2. **公钥**：这是实际的公钥字符串。
3. **可选的选项**：例如 `command=`、`no-port-forwarding` 等，用于限制该密钥的使用方式。
4. **可选的评论**：通常为用户的电子邮件地址或描述，方便识别密钥来源。

示例：

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZwKU... [options] comment
```

### 文件权限

为了安全起见，`authorized_keys` 文件必须具有严格的权限设置。通常，文件应该只对拥有者可读，即权限应设置为 `600`。如果权限设置不正确，SSH 服务可能拒绝使用该文件进行认证。

### 选项

`authorized_keys` 文件中的选项允许你对每个密钥进行定制化的访问控制。一些常见的选项包括：

- `command="..."`：指定当使用此密钥登录时要执行的命令。
- `no-agent-forwarding`：禁止代理转发。
- `no-port-forwarding`：禁止端口转发。
- `permitopen="hostname:port"`：允许从该 SSH 连接开放特定主机的端口。
- `from="..."` 和 `to="..."`：限制连接源 IP 地址和时间范围。

### 公钥添加与管理

公钥可以手动添加到 `authorized_keys` 文件中，也可以使用 `ssh-copy-id` 命令自动添加。管理这些公钥时，确保定期审查并删除不再需要或已过期的密钥，以维护系统的安全性。

### 多个公钥

用户可以有多个公钥，每行一个，这样可以从不同的设备或账户进行认证。每个公钥可以有不同的选项，以适应不同的登录场景。

总之，`authorized_keys` 文件是 SSH 认证过程中的关键组件，正确配置和维护它是保持 SSH 服务安全的重要环节。

