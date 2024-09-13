[toc]



## abstract

- 本文假设你已经在windows上顺利安装了openssh
  - [windows@windows上使用OpenSSH和相关软件@windows设备间使用OpenSSH_openssh windows客户端-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/140308691)
- windows上openssh配置免密登陆
- 提供基于powershell脚本的快速配置方案

### 免密自动登录配置介绍👺

- 如果您不想了解细节,可以直接跳转到下面的 **傻瓜式配置免密登录** 一节,开门见山的提供配置步骤;以下是细节步骤
- 和linux server类似,但是windows 中需要修改的`ssh`服务器端的配置文件位置和linux不同(毕竟文件系统不同)
  - 一般在`C:\ProgramData\ssh`目录下面的`sshd_config`文件中
  - 这里给出简单的过程,完善的文档参考前面列出的参考文档链接

#### 修改Server配置文件

- 为了获得配置文件,你需要在安装openssh ssh server 后启动它,这会生成一份配置文件

  - 无论是从win10+系统中的系统设置中的可选功能安装openssh server 还是通过win32 openssh或者scoop 安装的openssh,启动sshd后都将在相应目录下生成一个配置文件`sshd_config`

    - > 编辑位于 `$env:ProgramData\ssh` 的 `sshd_config` 文件。

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
  function Get-SSHPubKeysAdderScripts
  {
      param(
          [switch]$PassThru
      )
      if (!$pubkeys)
      {
          Write-Error 'Please run pre-executing above commands first!'
          Write-Error '请先执行预执行命令,然后重试'
          return
      }
      $pubkey_content = Get-Content $pubkey #该值同上述指定
  
  
      $script = '$pubkey=' + "'$pubkey_content'" + @'
  
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
      Write-Host $script -ForegroundColor Blue
      if ($PassThru)
      {
  
          return $script
      }
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

您可以将上述提供的各个powershell函数分别在ssh client 和ssh server上导入(不是直接运行),为了方便这一点,可以从gitee仓库复制整合好的脚本:[modulesByCxxu/SSH/SSH.psm1 · xuchaoxin1375/scripts - 码云 - 开源中国 (gitee.com)](https://gitee.com/xuchaoxin1375/scripts/blob/main/modulesByCxxu/SSH/SSH.psm1) 如果仓库被误报违规,请克隆或下载仓库压缩包解压使用其中的对应文件

## 操作流程👺

- 复制相关powershell代码,分别粘贴到客户端和服务端的**管理员权限**的**powershell**窗口
  - 或者下载脚本文件,导入到powershell后调用

- 然后就只需要按照以下指示在ssh客户端(client)或服务端(server)上调用或执行相关命令即可


流程如下(按顺序执行):

1. server端执行

   - ```powershell
     Set-SSHServerInit
     Enable-SSHPubkeyAuthentication
     # Set-SSHPubkeyAuthentication #虽然名字更贴切,但是也可以考虑一致性可以用set-...开头
     ```

   - server上**粘贴**并运行上述复制的脚本即可(这会创建服务端上的authorized_keys文件,并且会重启ssh server)

2. client端执行

   - ```powershell
     Get-SSHPreRunPubkeyVarsScript|iex 
     #client 再执行以下两个函数中的一个即可,以获得一段创建**授权公钥文件**(authorized_keys)的脚本
     Get-SSHPubKeysAdderScripts -PassThru|scb #方案1(自动将脚本复制到剪切板)
     # Get-SSHPubKeysPushScripts #方案2
     ```

   - Note:

     1. 方案1是输出在终端上,直接复制即可;
     2. 方案2会打开一个记事本,在其中做必要的填写或修改;然后复制其中内容

3. server端粘贴运行client输出的脚本

4. 如果sshd服务重启失败(报错),请手动到`services.msc`中找到`Openssh ssh server`手动重启它

### 操作示例(仅供参考)

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

### 尝试免密登录

```powershell
PS> ssh cxxu@redmibookpc
Microsoft Windows [版本 10.0.19045.4529]
(c) Microsoft Corporation。保留所有权利。
```

如果顺利的话,就可以登录到远程windows server (ssh),默认命令行shell是cmd

输入`powershell`或`pwsh`可以切换shell,如果要更换默认的ssh登陆使用的shell,参考本文开头列出的链接