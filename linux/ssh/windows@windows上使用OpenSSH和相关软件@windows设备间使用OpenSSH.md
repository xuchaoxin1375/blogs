[toc]

## abstract

- 本文介绍和实验了windows设备之间使用ssh连接远程控制
- 实验平台为windows10,windows11

## SSH方案相关链接

windows上需要手动安装ssh server软件(拓展模块),并且配置防火墙和服务自启动等设置

### 适用于win10之后的系统

[OpenSSH for Windows 概述 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_overview)

[Get started with OpenSSH for Windows | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=gui#connect-to-openssh-server)

此外，官方文档还介绍了更多连接以及可以自定义配置的方案

[Key-based authentication in OpenSSH for Windows | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)

[OpenSSH Server configuration for Windows | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_server_configuration)

中文文档:

[适用于 Windows 的 OpenSSH 服务器配置 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_server_configuration)

### 更通用方案


- 更一般的ssh方案(基于powershell)
  - [运行远程命令(相关协议) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/security/remoting/running-remote-commands?view=powershell-7.4)
  - [通过 SSH 进行 PowerShell 远程处理 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/security/remoting/ssh-remoting-in-powershell?view=powershell-7.4)
  - 相关软件仓库[PowerShell/Win32-OpenSSH: Win32 port of OpenSSH (github.com)](https://github.com/PowerShell/Win32-OpenSSH)
- 适用于win7及以上的系统(至少有windows powershell ),更加通用(安装方式也有多种)
  - [Install Win32 OpenSSH Using MSI · PowerShell/Win32-OpenSSH Wiki · GitHub](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH-Using-MSI)
    - 这种方式最简单,最推荐,可以选择仅安装Client或者Server(默认都安装),对于win7也很友好
  - [Install Win32 OpenSSH · PowerShell/Win32-OpenSSH Wiki · GitHub](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH)
    - 我为这种安装方法整合了一个脚本,让win10以及之后的系统也可以很简单安装OpenSSH
    - 并且包含了对服务端的基本设置(防火墙,立即启动sshd服务,设置开机自启,设置登录的默认shell)
    - 您可以参考后面的章节



## 软件安装和配置

主要介绍服务端(客户端win10后自带,对于win7也可以使用win32 openssh,这边不赘述)

### win10之后的安装配置方法

- 在server端安装必要的ssh服务软件

  - 管理员方式运行powershell执行以下内容:

    ```powershell
    # Install the OpenSSH Server
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    ```

  - 详情另见它文(防火墙配置等) [适用于 Windows 的 OpenSSH 入门 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell#install-openssh-for-windows)


- 这种方式是面向当前的主流系统的安装方式,但不一定是最快的方式,特别是国内用户,下载windows功能的途径比较受限,默认方法下载速度慢

### 兼容性方案安装

有多种安装方式,都挺方便的

### 使用scoop安装

- 默认的scoop很慢,建议使用国内优化版的scoop加速下载和部署

- [SSH on Windows · ScoopInstaller/Scoop Wiki (github.com)](https://github.com/ScoopInstaller/Scoop/wiki/SSH-on-Windows)

#### 使用msi包安装

he MSI must be run in any command prompt (cmd.exe & pwsh.exe both work), as it does not yet have a UI (coming soon).
The MSI will install OpenSSH to the `ProgramFiles\OpenSSH` folder.
The commands to run, are as follows:

- To install both the SSH Client & the SSH Server (default behavior)
  `msiexec /i <path to openssh.msi>`

如此的简单,一条语句就可以(最新版本可能可以双击进行安装,但是命令行安装可能会报错)

##### others

- To install only the SSH Client
  `msiexec /i <path to openssh.msi> ADDLOCAL=Client`
- To install only the SSH Server
  `msiexec /i <path to openssh.msi> ADDLOCAL=Server`
- To uninstall only the SSH Client
  `msiexec /i <path to openssh.msi> REMOVE=Client`
- To uninstall only the SSH Server
  `msiexec /i <path to openssh.msi> REMOVE=Server`

##### Examples:

- Installing SSH Client & openssh.msi is in the working directory:
  `msiexec /i openssh.msi ADDLOCAL=Client`
- Installing SSH Server & openssh.msi is in C:\users\public\downloads:
  `msiexec /i C:\users\public\downloads\openssh.msi ADDLOCAL=Server`
- Uninstalling SSH Client & openssh.msi is in the working directory:
  `msiexec /i openssh.msi REMOVE=Client`
- Uninstalling SSH Server & openssh.msi is in C:\users\public\downloads:
  `msiexec /i C:\users\public\downloads\openssh.msi REMOVE=Server`

#### 脚本方式安装方法

下面给出的是通过脚本离线安装的方案

Install Win32 OpenSSH (test release) 

这个离线包只有几MB,所以不会下载太久(github release镜像加速下载也可以)

1. Win32-OpenSSH Github releases can be installed on Windows 7 and up.
2. Note [these considerations](https://github.com/PowerShell/Win32-OpenSSH/wiki/Various-Considerations) and [project scope](https://github.com/PowerShell/Win32-OpenSSH/wiki/Project-Scope) first.
3. Download the [latest](https://github.com/PowerShell/Win32-OpenSSH/releases/latest) build of OpenSSH. To get links to latest downloads [this wiki page](https://github.com/PowerShell/Win32-OpenSSH/wiki/How-to-retrieve-links-to-latest-packages).
4. Extract contents of the latest build to `C:\Program Files\OpenSSH` (Make sure binary location has the Write permissions to just to SYSTEM, Administrator groups. Authenticated users should and only have Read and Execute.)
5. Modify the following Powershell Script(if you download the file in the user home download directory,just paste and run directly)

##### 整合脚本👺

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

Expand-Archive -Path $file -DestinationPath $OpenSSH_home  -Verbose
Get-ChildItem $OpenSSH_home

#$install_script = "$OpenSSH_Home/install-sshd.ps1"
$install_script_dir=(ls "$OpenSSH_Home/Openssh-win*/")[0]
$install_script="$install_script_dir/install-sshd.ps1"
powershell.exe -ExecutionPolicy Bypass -File $install_script

```

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

    #To config default shell (use powershell as default):
    New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -PropertyType String -Force
    New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShellCommandOption -Value '/c' -PropertyType String -Force
```

此时这台设备既可以充当ssh服务端,也可以作为客户端

包装成powershell函数,详情参考:[modulesByCxxu/SSH/SSH.psm1 · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/modulesByCxxu/SSH/SSH.psm1) 中的`Deploy-SSHVersionWin32Zip `函数

##### 其他可选配置

1. Optional
   - To configure a default shell, see [here](https://github.com/PowerShell/Win32-OpenSSH/wiki/DefaultShell)
   - To migrate sshd configuration from older versions (0.0.X.X), see [here](https://github.com/PowerShell/Win32-OpenSSH/wiki/Migrate-sshd_config-from-older-versions)

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

  - 如果两个设备都开启了网络发现,那么可以用以下格式连接:``ssh user@serverName`

    - 对于小型网络通常不用关心域,完整格式其实是`ssh domain\username@servername`,而经常省略掉`domain\`这部分内容

    - ```powershell
      PS C:\Users\cxxu> ssh cxxu@redmibookpc
      #如果是初次连接,会有一段安全询问,通常输入yes即可
      cxxu@redmibookpc's password:
      Microsoft Windows [版本 10.0.19045.4529]
      (c) Microsoft Corporation。保留所有权利。
      
      cxxu@REDMIBOOKPC C:\Users\cxxu>
      ```

  - 否则用`ssh user@serverIp`来连接

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



### 免密自动登录👺

- 如果您不想了解细节,可以直接跳转到下面的 **傻瓜式配置免密登录** 一节,开门见山的提供配置步骤;以下是细节步骤
- 和linux server类似,但是windows 中需要修改的`ssh`服务器端的配置文件位置和linux不同(毕竟文件系统不同)
  - 一般在`C:\ProgramData\ssh`目录下面的`sshd_config`文件中
  - 这里给出简单的过程,完善的文档参考前面列出的参考文档链接

#### 修改Server配置文件

- 为了获得配置文件,你需要在安装openssh ssh server 后启动它

  - ```powershell
    function Set-SSHServerInit
    {
        # Start the sshd service
        Start-Service sshd
    
        # OPTIONAL but recommended:
        Set-Service -Name sshd -StartupType 'Automatic'
    
        # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
        if (!(Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue | Select-Object Name, Enabled))
        {
            Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
            New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
        }
        else
        {
            Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
        }
    }
    
    Set-SSHServerInit #调用定义的函数
    
    ```

    

- 您可以尝试用`type C:\ProgramData\ssh\sshd_config`命令行来查看配置文件中的内容

- 默认情况下的配置文件无法直接免密登录,您需要修改部分内容(其实默认文件中大多都是注释语句,有些需要我们解开注释,有些需要我们转为注释)

  - 参考:[在Windows Server 之间配置SSH 免密登录 - LearningAlbum - 博客园 (cnblogs.com)](https://www.cnblogs.com/deepinnet/p/15228378.html)

- 这里直接给出我已经修改过的一个可以免密登录ssh的配置文件(sshd_config)

  ```cmd
  # This is the sshd server system-wide configuration file.  See
  # sshd_config(5) for more information.
  
  # The strategy used for options in the default sshd_config shipped with
  # OpenSSH is to specify options with their default value where
  # possible, but leave them commented.  Uncommented options override the
  # default value.
  
  #Port 22
  #AddressFamily any
  #ListenAddress 0.0.0.0
  #ListenAddress ::
  
  #HostKey __PROGRAMDATA__/ssh/ssh_host_rsa_key
  #HostKey __PROGRAMDATA__/ssh/ssh_host_dsa_key
  #HostKey __PROGRAMDATA__/ssh/ssh_host_ecdsa_key
  #HostKey __PROGRAMDATA__/ssh/ssh_host_ed25519_key
  
  # Ciphers and keying
  #RekeyLimit default none
  
  # Logging
  #SyslogFacility AUTH
  #LogLevel INFO
  
  # Authentication:
  
  #LoginGraceTime 2m
  #PermitRootLogin prohibit-password
  #StrictModes yes
  #MaxAuthTries 6
  #MaxSessions 10
  
  PubkeyAuthentication yes
  
  # The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
  # but this is overridden so installations will only check .ssh/authorized_keys
  AuthorizedKeysFile	.ssh/authorized_keys
  
  #AuthorizedPrincipalsFile none
  
  # For this to work you will also need host keys in %programData%/ssh/ssh_known_hosts
  #HostbasedAuthentication no
  # Change to yes if you don't trust ~/.ssh/known_hosts for
  # HostbasedAuthentication
  #IgnoreUserKnownHosts no
  # Don't read the user's ~/.rhosts and ~/.shosts files
  #IgnoreRhosts yes
  
  # To disable tunneled clear text passwords, change to no here!
  #PasswordAuthentication yes
  #PermitEmptyPasswords no
  
  # GSSAPI options
  #GSSAPIAuthentication no
  
  #AllowAgentForwarding yes
  #AllowTcpForwarding yes
  #GatewayPorts no
  #PermitTTY yes
  #PrintMotd yes
  #PrintLastLog yes
  #TCPKeepAlive yes
  #UseLogin no
  #PermitUserEnvironment no
  #ClientAliveInterval 0
  #ClientAliveCountMax 3
  #UseDNS no
  #PidFile /var/run/sshd.pid
  #MaxStartups 10:30:100
  #PermitTunnel no
  #ChrootDirectory none
  #VersionAddendum none
  
  # no default banner path
  #Banner none
  
  # override default of no subsystems
  Subsystem	sftp	sftp-server.exe
  
  # Example of overriding settings on a per-user basis
  #Match User anoncvs
  #	AllowTcpForwarding no
  #	PermitTTY no
  #	ForceCommand cvs server
  
  # Match Group administrators
  #        AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
  
  ```

  其实总共就保留了三条配置,其余都是注释掉:(不同版本的openssh server可能有所不同)

  ```cmd
  PubkeyAuthentication yes
  AuthorizedKeysFile	.ssh/authorized_keys
  Subsystem	sftp	sftp-server.exe
  ```

##### 一键脚本修改👺

- 为了方便一键操作,执行以下pwsh脚本(需要**管理员权限**👺)

  - ```powershell
    function Enable-SSHPubkeyAuthentication
    {
    
        <# 
        .SYNOPSIS
        在SSH server端运行本代码
        启用公钥认证和AuthorizedKeysFile指定,从而允许授权公钥文件指定的公钥拥有者登录到ssh Server
        
        本函数需要配合其他代码才能达到预期的免密登录效果(需要客户端的公钥文件,无法整合到此脚本中)
    
        .DESCRIPTION
        这是一个简易版的配置sshd_config文件的脚本,如果达不到预期效果,请查阅其他文档资料
        本函数在修改原sshd_config文件前执行了备份,因此您可以找回默认值
        .NOTES
        ssh server除了运行本代码,还需要创建或修改 authorized_keys 文件(通常在ssh server端的某个用户家目录下.ssh中)
        #>
        
        $sch = 'C:\ProgramData\ssh' #sshd_config文件所在目录
        $sshd_config = "$sch\sshd_config" #原配置文件
        Get-Content $sshd_config #看一眼源文件内容
        Copy-Item $sshd_config $sch\sshd_config.bak #备份配置文件,以防万一
        
        $config = @'
        PubkeyAuthentication  yes
        AuthorizedKeysFile 	.ssh/authorized_keys
        Subsystem	 sftp 	sftp-server.exe
    '@ #向sshd_config文件写入新的内容(覆盖性)
        $config > $sshd_config
        #重新检查新内容(特别是行内配置项目的空格)
        Get-Content $sshd_config 
        #重启ssh服务以生效配置
        Restart-Service sshd
    }
    
    #调用本函数
    Enable-SSHPubkeyAuthentication
    
    ```

    

#### 向ssh server端上传或创建支持免密登录的公钥文件

- 默认情况下,这个文件为`~/.ssh/authorized_keys`

  - 不妨记该文件为**授权公钥文件**为变量,方便引用

    - ```powershell
      $authorized_keys='~/.ssh/authorized_keys'
      ```


  - 确定Client端的授权公钥文件位置(您需要实现创建好密钥对,详情另见它文)

    - ```powershell
      $pubkey="$home\.ssh\id_*pub" #为公钥文件路径创建易于引用的变量
      ```

    - 其中`id_*pub`可能需要您补全(比如`id_ed25519.pub`),特别是您创建了多个不同的ssh key时,如果仅创建过一个,那么通常可以不修改直接执行


##### 预执行命令👺

```powershell
function Get-SSHPreRunPubkeyVarsScript
{
    <# 
    .SYNOPSIS
    生成一段预执行脚本,创建相关文件(公钥等)的路径变量,便于后续引用
    .EXAMPLE
    PS> Get-SSHPreRunScript|iex #将脚本输出并调用执行
    #>
    $script = @'
    #ssh Client端执行
    $authorized_keys = '~/.ssh/authorized_keys'
    $authorized_keys = "$env:userprofile/.ssh/authorized_keys"
    $pubkeys = "$home\.ssh\id_*pub"
    #查看公钥文件
    $pubkeys = Get-ChildItem $pubkeys
    $pubkeys
    #兼容多个的情况,默认选择其中的第一个
    $pubkey = $pubkeys[0]

    write-host $pubkey
    
'@
    # Write-Host $script -ForegroundColor Blue
    # $script | Invoke-Expression -Verbose #外部脚本无法访问
    return $script

}
Get-SSHPreRunScript|iex #将脚本输出并调用执行 #我觉得这里利用iex命令整合的就比较巧妙,解决了局部变量外部无法访问的问题
```

无论选择下面的哪一种方式,都请先执行预执行命令



##### 方式1

- 推荐的通用方法👺

- 也可以复制公钥到剪切板,然后登录到server中创建相应文件

  - 查看**ssh client**的公钥

  - 复制输出的内容

- 在**ssh server**上创建或追加公钥到授权公钥文件中

  - 此前,我们现在Client端执行以下逻辑

  

  ```powershell
  #在Client 端运行,会输出一段脚本,再复制到server端运行所得到的脚本
  function Get-SSHPubKeysAdderScripts
  {
      if (!$pubkeys)
      {
          Write-Error 'Please run pre-executing above commands first!'
          Write-Error '请先执行预执行命令,然后重试'
          return
      }
      $pubkey_content = Get-Content $pubkey #该值同上述指定
  
  
      $script='$pubkey=' + "'$pubkey_content'" + @'
  
  $authorized_keys='~/.ssh/authorized_keys'
  if(Test-Path $authorized_keys){
  
  type $authorized_keys #查看修改前的授权公钥文件
  }else{
      new-item -Path $authorized_keys -ItemType File -force
      Write-Verbose "No $authorized_keys exist, create it!"
  }
  $pubkey >> $authorized_keys
  type $authorized_keys #查看修改后的授权公钥文件
  #重启ssh服务以生效配置
  Restart-Service sshd
  '@ 
  	write-host $script -ForegroundColor Blue
     # return $script
  }
  #调用并执行上述逻辑
  Get-SSHPubKeysAdderScripts
  
  ```

  

##### 方式2

- 针对仅授权单台设备免密或者还原备份的授权公钥文件的情况

- 创建或编辑方式有多种,以下方案提供的命令行直接在ssh client的命令行中执行(powershell)

- 可以从而ssh **client**端上传到server

  - ```powershell
    function Get-SSHPubKeysPushScripts{
    	#适用于仅对一台主机进行免密登录的情况;否则其他方法更合适
        if(!$pubkeys){
            write-error 'Please run pre-executing above commands first!'
            write-error '请先执行预执行命令,然后重试'
            return
        }
    
        $s="$env:userprofile/desktop/script.txt"
    
        @'
        #填写server:
        #局域网内启用网络发现的话可以直接用server计算机名(server上执行hostname获取),比较方便,但是更通用的是使用server的ip地址(执行ipconfig,可能有好几个地址,找出ip地址,通常是192开头的)
        #如果是云服务器,一般具有公网ip,可以直接用ip地址即可
    
        $user='    ' #ssh client要以 ssh server 上的哪一个用户身份登录(例如server上有个UserDemo用户)
        $server='    '  #例如192.168.1.111或者'redmibookpc'
        $user=$user.trim()
        $server=$server.trim()
        scp $pubkey $user@${Server}:$authorized_keys
    	
        #查看执行的scp命令行内容
        "scp $pubkey $user@${Server}:$authorized_keys"
        #重启ssh服务以生效配置
        Restart-Service sshd
    '@ > $s
        notepad $s
    }
    Get-SSHPubKeysPushScripts
    
    
    ```

    - 执行上述命令行,会弹出一个记事本窗口,修改必要的内容(前几行都是注释,后面2行改改即可),然后复制到命令行中执行



##### 重启服务以生效👺

- ```powershell
  #重启ssh服务以生效配置
  restart-service sshd
  
  ```

  - 如果执行失败,请手动打开`service.msc`,然后找到`OpenSSH SSH Server`进行重启(停止后重新启用)

### 傻瓜式配置免密自动登录👺👺

#### 准备

上述两种方法都是powershell命令行,都算简单可行,任选一种即可,能够为两台windwos计算机建创建免密码ssh链接公钥文件

此外,ssh server 端还需要进一步配置`sshd_config`文件(可以在创建公钥之前就完成配置)

您可以将上述提供的各个powershell函数分别在ssh client 和ssh server上导入(不是直接运行),为了方便这一点,可以从gitee仓库复制整合好的脚本:[modulesByCxxu/SSH/SSH.psm1 · xuchaoxin1375/scripts - 码云 - 开源中国 (gitee.com)](https://gitee.com/xuchaoxin1375/scripts/blob/main/modulesByCxxu/SSH/SSH.psm1)

### 流程👺

- 复制后分别粘贴到客户端和服务端的**管理员权限**的**powershell**窗口

- 然后就只需要按照以下指示在ssh客户端(client)或服务端(server)上调用或执行相关命令即可


流程如下(按顺序执行):

1. server端执行

   - ```powershell
     Set-SSHServerInit
     Enable-SSHPubkeyAuthentication
     ```

   - server上**粘贴**并运行上述复制的脚本即可(这会创建服务端上的authorized_keys文件,并且会重启ssh server)

2. client端执行

   - ```powershell
     Get-SSHPreRunPubkeyVarsScript|iex 
     #client 再执行以下两个函数中的一个即可,以获得一段创建**授权公钥文件**(authorized_keys)的脚本
     Get-SSHPubKeysAdderScripts #方案1
     # Get-SSHPubKeysPushScripts #方案2
     ```

   - Note:

     1. 方案1是输出在终端上,直接复制即可;
     2. 方案2会打开一个记事本,在其中做必要的填写或修改;然后复制其中内容

3. server端粘贴运行client输出的脚本

4. 如果sshd服务重启失败(报错),请手动到`services.msc`中找到`Openssh ssh server`手动重启它

#### 操作示例



服务端上执行的记录(**管理员权限**)

```powershell
#管理员权限窗口运行
#如果没有安装ssh server,这里先安装,如果已经安装,则跳过
PS C:\Users\cxxu> Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Path          :
Online        : True
RestartNeeded : False

#初始化服务端
PS C:\Users\cxxu> Set-SSHServerInit
WARNING: Waiting for service 'OpenSSH SSH Server (sshd)' to start...
Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists.
#启用免密登录
PS C:\Users\cxxu> Enable-SSHPubkeyAuthentication
# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.
.....(原配置的一大堆内容,不用管它)
.....

# override default of no subsystems
Subsystem       sftp    sftp-server.exe

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server

Match Group administrators
       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys

    PubkeyAuthentication  yes
    AuthorizedKeysFile  .ssh/authorized_keys
    Subsystem    sftp   sftp-server.exe
    
#此时前往客户端执行任务,复制其输出的脚本粘贴进来回车执行



```



客户端上执行的记录

```powershell
#预执行指令(创建必要变量等方便引用)
PS C:\Users\cxxu\Desktop> Get-SSHPreRunPubkeyVarsScript|iex

    Directory: C:\Users\cxxu\.ssh

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            2024/3/8    16:40             99 id_ed25519.pub
-a---           2024/7/13    21:28            743 id_rsa.pub
C:\Users\cxxu\.ssh\id_ed25519.pub

#执行下一条命令,会输出一段脚本,复制其输出
PS C:\Users\cxxu\Desktop> Get-SSHPubKeysAdderScripts
$pubkey='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPM/U3hKGVFJsqDdW8ydffoDlL79PrBQhycgFnZn3DVo 838808930@qq.com'
$authorized_keys='~/.ssh/authorized_keys'
if(Test-Path $authorized_keys){

type $authorized_keys #查看修改前的授权公钥文件
}else{
    new-item -Path $authorized_keys -ItemType File -force
    Write-Verbose "No $authorized_keys exist, create it!"
}
$pubkey >> $authorized_keys
type $authorized_keys #查看修改后的授权公钥文件
#重启ssh服务以生效配置
Restart-Service sshd

# 现在离开客户端,回去服务端操作

```

回到server端操作(粘贴并回车运行前面复制的脚本)

```powershell
PS C:\Users\cxxu> $pubkey='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPM/U3hKGVFJsqDdW8ydffoDlL79PrBQhycgFnZn3DVo 838808930@qq.com'
PS C:\Users\cxxu> $authorized_keys='~/.ssh/authorized_keys'
PS C:\Users\cxxu> if(Test-Path $authorized_keys){
>>
>> type $authorized_keys #查看修改前的授权公钥文件
>> }else{
>>     new-item -Path $authorized_keys -ItemType File -force
>>     Write-Verbose "No $authorized_keys exist, create it!"
>> }

    Directory: C:\Users\cxxu\.ssh

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2024/7/19     9:46              0 authorized_keys

PS C:\Users\cxxu> $pubkey >> $authorized_keys
PS C:\Users\cxxu> type $authorized_keys #查看修改后的授权公钥文件
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPM/U3hKGVFJsqDdW8ydffoDlL79PrBQhycgFnZn3DVo 838808930@qq.com
PS C:\Users\cxxu> #重启ssh服务以生效配置
PS C:\Users\cxxu> Restart-Service sshd
PS C:\Users\cxxu>
```

不出意外客户端现在就可以免密登录了

#### 尝试免密登录

```powershell
PS> ssh cxxu@redmibookpc
Microsoft Windows [版本 10.0.19045.4529]
(c) Microsoft Corporation。保留所有权利。
```

如果顺利的话,就可以登录到远程windows server (ssh),默认命令行shell是cmd

输入`powershell`或`pwsh`可以切换shell

### 配置默认shell 👺

- [适用于 Windows 的 OpenSSH 服务器配置 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_server_configuration#configuring-the-default-shell-for-openssh-in-windows)

- windows ssh server默认的shell是cmd,这是一个过时的shell

- 我们可以更改为powershell或其他shell


#### 准备工作

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


#### 一键修改命令行👺

- 首先登录到windows  ssh server,确保shell处于**管理员模式**

- 然后选择以下一个语句进行执行

  - 修改为自带的powershell版本

    ```powershell
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
    ```

  - 修改为powershell7

    ```powershell
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\powershell\7\pwsh.exe" -PropertyType String -Force
    
    ```
  
  - scoop版安装的powershell作为默认的ssh链接的shell👺
  
    ```powershell
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\ProgramData\scoop\shims\pwsh.exe" -PropertyType String -Force
    
    ```
  
    

#### 修改实操

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

