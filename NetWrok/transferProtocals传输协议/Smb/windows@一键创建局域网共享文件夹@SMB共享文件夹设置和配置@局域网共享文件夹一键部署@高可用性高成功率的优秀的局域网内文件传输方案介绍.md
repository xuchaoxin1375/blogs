[toc]



## abstract

- windows@一键创建局域网共享文件夹@SMB共享文件夹设置和配置@局域网共享文件夹一键部署@高可用性高成功率的优秀的局域网内文件传输方案介绍

- 本文介绍如何一键创建共享文件和访问共享文件夹的专用用户(凭证)
- 如何访问创建好的共享文件夹
- 其他文件共享方案

## 基本概念

- 利用Smb协议(共享文件夹)共享文件的方案中有两类角色
  - 一类是共享文件夹的创建者或者提供者,对应的机器可以称为服务端或服务器(Server),负责控制共享内容以及共享权限
  - 一类是共享文件夹的访问者,对应的机器称为客户端(Client)
- Server设置合适的权限,Client就可以按需读取(预览或者下载)文件,或者上传文件给Server
  - Server无法主动访问Client,除非两台设备都创建对方可以访问的共享文件夹,互为Client,Server,才能实现双主动访问
- 也就是说一般情况下,互传逻辑为:
  - Server想要传文件给Client,就先把文件放到共享文件夹中,再叫Client主动到Server的共享文件夹里去自取文件
  - Client想传文件给Server,直接把文件传到共享文件中即可

## 创建共享文件夹(Server)👺

windows自带的共享文件夹的创建方式也算简单,可以右键文件夹设置共享进行创建,对于小白来说还是需要点击和设置一些权限

下面的两种方案都可以更加方便的设置,尤其是脚本方案

### 基于GUI图形软件的一键创建共享文件夹方案

- [局域网共享一键通 v2.0.9.8 – 杏雨梨云启动维护系统 (xyboot.com)](https://www.xyboot.com/lanshare_onekey_ok/)
  - 这个软件支持直接设置匿名可访问的共享文件夹,共享局域网内的打印机设备
  - 但是软件细节我并不清楚,有次设置匿名访问共享文件夹时翻车了,导致原来可以访问的共享文件夹无法访问了;也导致设备上的用户无法被远程登录,使用有一定风险(内部应该会修改组策略,注册表等)
  - 一定要匿名访问,考虑系统功能中启用smb1.0,它支持匿名访问，但是引入了许多安全漏洞,并不值得
  - 如果发生这种情况,使用该软件重新设置一个有密码的专用账户来登录
- 如果您不关心匿名登录,追求更加可控的一键设置,那么使用下面的脚本创建共享文件夹会更加方便和直接

### 基于Powershell脚本方案的简单操作步骤

如果您对共享文件夹创建细节不感兴趣,可以直接执行以下操作

- **管理员权限**打开一个`powershell`窗口(不妨记为`窗口1`)

- 复制粘贴以下内容(你可以将脚本粘贴到记事本或其他编辑器再**手动修改相关变量**来符合自己的需要)

  - 也可以查看在线的版本(最新版本,浏览器内搜索同名函数):[modulesByCxxu/deploy/deploy.psm1 · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/modulesByCxxu/deploy/deploy.psm1)

- 下面的脚本包含了多个powershell函数,其中`Deploy-SmbSharing`是主函数,其他为辅助函数

  ```powershell
  #下面这四个函数是用来启用网络共享和网络发现的并部署带有使用说明文档的共享文件夹
  function Grant-PermissionToPath
  {
      <# 
      .SYNOPSIS
      可以清除某个目录的访问控制权限,并设置权限,比如让任何人都可以完全控制的状态
      这是一个有风险的操作;建议配合其他命令使用,比如清除限制后再增加约束
      .DESCRIPTION
      设置次函数用来清理发生权限混乱的文件夹,可以用来做共享文件夹的权限控制强制开放
      .EXAMPLE
      PS [C:\]> Grant-PermissionToPath -Path C:/share1 -ClearExistingRules
      True
      True
      已成功将'C:/share1'的访问权限设置为允许任何人具有全部权限。
      .PARAMETER Path
      需要执行访问控制权限修改的目录
      .PARAMETER Group
      指定文件夹要授访问权限给那个组,结合Permission参数,指定该组对Path具有则样的访问权限
      默认值为:'Everyone'
      .PARAMETER Permission
      增加/赋于新的访问控制权限,可用的合法值参考:https://learn.microsoft.com/zh-cn/dotnet/api/system.security.accesscontrol.filesystemrights?view=net-8.0
      .PARAMETER ClearExistingRules
      清空原来的访问控制规则
      .NOTES
      需要管理员权限,相关api参考下面连接
      .LINK
       相关AIP文档:https://learn.microsoft.com/zh-cn/dotnet/api/system.security.accesscontrol.filesystemaccessrule?view=net-8.0
      #>
      [CmdletBinding()]
      param(
          [string]$Path,
          $Group = 'Everyone',
          # 指定下载权限
          $permission = 'FullControl',
  
          [switch]$ClearExistingRules
  
      )
  
      try
      {
          # 获取目标目录的当前 ACL
          $acl = Get-Acl -Path $Path
  
          # 创建允许“任何人（Everyone）”具有“完全控制”权限的新访问规则
          $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
              $Group,
              $permission, 
              'ContainerInherit, ObjectInherit',
              'None',
              'Allow'
          )
  
          if ($ClearExistingRules)
          {
              # 如果指定了清除现有规则，则先移除所有现有访问规则
              $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }
          }
  
          # 添加新规则到 ACL
          $acl.SetAccessRule($rule)
  
          # 应用修改后的 ACL 到目标目录
          Set-Acl -Path $Path -AclObject $acl
  
          
      }
      catch
      {
          Write-Error "设置权限时出错: $_"
      }
  }
  
  function Enable-NetworkDiscoveyAndSharing
  {
      <# 
      .SYNOPSIS
      启用共享文件夹和网络发现
      这里通过防火墙设置来实现,可以指定中英文系统语言再执行防火墙设置
      .EXAMPLE
      PS C:\> Enable-NetworkDiscoveyAndSharing
      No rules match the specified criteria.
      No rules match the specified criteria.
      Updated 30 rule(s).
      Ok.
      Updated 62 rule(s).
      Ok.
      PS C:\> Enable-NetworkDiscoveyAndSharing -Language Chinese
      No rules match the specified criteria.
      No rules match the specified criteria.
      PS C:\> Enable-NetworkDiscoveyAndSharing -Language English
      Updated 30 rule(s).
      Ok.
      Updated 62 rule(s).
      Ok.
      #>
      param (
          [validateset('Chinese', 'English', 'Default')]$Language = 'Default'
      )
      #对于中文系统
      $c = { netsh advfirewall firewall set rule group="文件和打印机共享" new enable=Yes
          netsh advfirewall firewall set rule group="网络发现" new enable=Yes }
      #对于英文系统
      $e = { netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
          netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes }
      switch ($Language)
      {
          'Chinese' { & $c ; break }
          'English' { & $e ; break }
          Default { & $c; & $e }
      }
  }
  function New-SmbSharingReadme
  {
      <# 
      .SYNOPSIS
      创建共享文件夹说明文件,一般不单独使用,请把此函数当作片段,需要在其他脚本或函数内部调用以填充字符串内部的变量
      .DESCRIPTION
      下面的分段字符串内引用了此函数没有定义的变量
      而在配合其他函数(Deploy-Smbsharing内部调用)则是可以访问Deploy-SmbSharing内部定义的局部变量
      因此这里无需将变量搬动到这里来,甚至可以放空
      #>
      param (
          # 也可以把这组参数复制到Deploy-Smbsharing内部,而在这里设置为空, 在Deploy-SmbSharing 内部以显式传参的方式调用此函数;
          $readmeFile = "$Path\readme.txt",
          $readmeFileZh = "$Path\readme_zh-cn(本共享文件夹使用说明).txt"
      )
      # 创建说明文件(默认为英文说明)
      @'
  Files,folders,and links(symbolicLinks,JunctionLinks,HardLinks are supported to be shared )
  Others' can modify and read contents in the folder by defualt,you can change it 
  
  The Default UserName and password to Access Smb Sharing folder is :
  '@+
      @"
  Server(ComputerName): $env:COMPUTERNAME 
  UserName: $smbUser
  Password: $SmbUserKey
  
  (if Server(ComputerName) is not available, please use IP address(use `ipconfig` to check))
  
  "@+ 
      @"
  The Permission of this user is : $Permission (one of Read,Change,Full)
  
  "@+ 
      @'
  
  You can consider using the other sharing solutions such as CHFS,Alist,TfCenter
  These softwares support convenient http and webdav sharing solutions;
  Especially Alist, which supports comprehensive access control permissions and cloud disk mounting functions
  This means that Users have no need to install other softwares which support smb protocol,just a web browser is enough.
  
  See more detail in https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbshare
  '@ > "$readmeFile"
  
  
      #添加中文说明
      @'
  支持共享文件、文件夹以及链接（包括符号链接、联合链接和硬链接）。
  默认情况下，其他人可以修改和读取文件夹中的内容，您可以更改此设置。
  
  访问 SMB 共享文件夹的默认用户名和密码是：
  
  '@+
      @"
  Server(ComputerName): $env:COMPUTERNAME 
  用户名: $smbUser
  密码: $SmbUserKey
  
  （如果服务器主机名（ComputerName）不可用，请使用IP地址（使用ipconfig检查））
  
  "@+ 
      @"
  该用户的权限是：$Permission （可选权限有：Read,Change,Full）
  
  "@+ 
      @'
  您可以考虑使用其他共享解决方案，如 CHFS、Alist、TfCenter，
  这些软件支持便捷的 HTTP 和 WebDAV 共享方案，尤其是Alist,支持完善的访问控制权限和网盘挂载功能
  这意味着用户无需安装支持 SMB 协议的其他软件，仅需一个网络浏览器即可。
  
  更多信息请参阅 https://docs.microsoft.com/zh-cn/powershell/module/smbshare/new-smbshare
  '@ > "$readmeFileZh"
  
  }
  
  function Deploy-SmbSharing
  {
      <# 
      .SYNOPSIS
      #功能:快速创建一个可用的共享文件夹,能够让局域网内的用户访问您的共享文件夹
      # 使用前提要求:需要使用管理员权限窗口运行powershell命令行窗口
      
      .DESCRIPTION
      如果这个目录将SmbUser的某个权限(比如读/写)设置为Deny，那么纵使设置为FullControl,也会被Deny的项覆盖,SmbUser就会确实相应的权限,甚至无法访问),
      因此,这里会打印出来目录的NTFS权限供用户判断是否设置了Deny
      反之,如果某个用户User1处于不同组内,比如G1,G2组,分别有读权限和写权限,那么最终User1会同时具有读/写权限,除非里面有一个组设置了Deny选项
      注意:没有显式地授予某个组的某个权限不同于设置Deny
  
      一个思路是新建一个SMB组,设置其拥有对被共享文件夹的权限,然后新建一个目录将其加入到SMB组中
      .EXAMPLE
      # 指定共享名称为ShareDemo，其他参数默认:共享目录为C:\Share，权限为Change，用户为ShareUser，密码为1
      PS> Deploy-SmbSharing -ShareName ShareDemo -SmbUser ShareUser -password 1
      .EXAMPLE
      完整运行过程(逃过次要信息)
      使用强制Force参数修改被共享文件夹的权限(默认为任意用户完全控制,如果需要进一步控制,需要开放更多参数,为了简单起见,这里就默认选项)
      PS C:\> Deploy-SmbSharing -Path C:\share -SmbUser smb2 -SmbUserkey 1 -Force
  
      No rules match the specified criteria.
      No rules match the specified criteria.
      Updated 30 rule(s).
      Ok.
      Updated 62 rule(s).
      Ok.
      文件夹已存在：C:\share
      Share name        Share
      Path              C:\share
      Remark
      Maximum users     No limit
      Users
      Caching           Manual caching of documents
      Permission        Everyone, CHANGE
  
      The command completed successfully.
  
      The command completed successfully.
  
      已成功将'C:\share'的访问权限设置为允许任何人具有全部权限。
      Name  ScopeName Path     Description
      ----  --------- ----     -----------
      Share *         C:\share
      共享已创建：Share
      共享专用用户已创建：smb2
      True
  ...
      True
      已为用户 smb2 设置文件夹权限
  
  
      PSPath                  : Microsoft.PowerShell.Core\FileSystem::C:\share
    ...
      CentralAccessPolicyId   :
      Path                    : Microsoft.PowerShell.Core\FileSystem::C:\share
      Owner                   : CXXUCOLORFUL\cxxu
      Group                   : CXXUCOLORFUL\None
      Access                  : {System.Security.AccessControl.FileSystemAccessRule}
      Sddl                    : O:S-1-5-21-1150093504-2233723087-916622917-1001G:S-1-5-21-1150093504-22337230
                              87-916622917-513D:PAI(A;OICI;FA;;;WD)
      AccessToString          : Everyone Allow  FullControl
      AuditToString           :
  
      .NOTES
      访问方式共享文件夹的方式参考其他资料 https://cxxu1375.blog.csdn.net/article/details/140139320
      #>
      param (
          
          # 定义共享文件夹路径和共享名称
          $Path = 'C:\Share',
          $ShareName = 'Share',
          [ValidateSet('Read', 'Change', 'Full')]$Permission = 'Change', #合法的值有:Read,Change,Full 权限从低到高 分别是只读(Read),可读可写(change),完全控制(full)
          
           #指定是否不创建新用户(仅使用已有用户凭证访问smb文件)
          # 这里的Mandatory=$true不能轻易移除,本函数用了参数集,并且基本上都用默认参数来使配置更简单;为了让powershell能够在不提供参数的情况下分辨我们调用的是哪个参数集，这里使用了Mandatory=$true来指定一个必须显式传递的参数,让函数能够不提供参数可调用
          [parameter(Mandatory=$true ,ParameterSetName = 'NoNewUser')]
          [switch]$NoNewUserForSmb,
  
          # [parameter(ParameterSetName = 'SmbUser')]
          # [switch]$NewUserForSmb,
  
          # 指定专门用来访问共享文件夹的用户(这不是必须的,您可以用自己的用户和密码,但是不适合把自己的私人账户密码给别人访问,所以推荐建立一个专门的用户角色用于访问共享文件夹)
          [parameter(ParameterSetName = 'SmbUser')]
          $SmbUser = 'Smb', #如果本地已经有该用户，那么建议改名
          #密码可以改,但是建议尽可能简单,默认为1(为了符合函数设计的安全规范,这里不设置明文默认密码)
          [parameter(ParameterSetName = 'SmbUser')]
          $SmbUserkey = '1',
          # 设置宽松的NTFS权限(但是仍然不一定会生效),如果可以用,尽量不要用Force选项
          [switch]$Force
      )
      #启用文件共享功能以及网络发现功能(后者是为了方便我们免ip访问,不是必须的)
  
      Enable-NetworkDiscoveyAndSharing
  
      # 检查文件夹是否存在，如果不存在则创建
      if (-Not (Test-Path -Path $Path))
      {
          New-Item -ItemType Directory -Path $Path
          Write-Output "文件夹已创建：$Path"
      }
      else
      {
          Write-Output "文件夹已存在：$Path"
      }
  
      # 创建共享
      # New-SmbShare -Name $ShareName -Path $Path -FullAccess Everyone
      # 创建共享文件夹(允许任何(带有凭证的)人访问此共享文件夹)
      "New-SmbShare -Name $ShareName -Path $Path -${Permission}Access 'Everyone'" | Invoke-Expression #这里赋予任意用户修改权限(包含了可读权限和修改权限)
      Write-Output "共享已创建：$ShareName"
  
      #显示刚才创建的(或者已有的)$ShareName共享信息
      net share $ShareName #需要管理员权限才可以看到完整信息
  
      if ($PSCmdlet.ParameterSetName -eq 'SmbUser'  )
      {
  
          $res = glu -Name "$SmbUser" -ErrorAction Ignore
          if (! $res)
          {
              # 定义新用户的用户名和密码
              $username = $SmbUser
  
              # 创建新用户(为了规范起见,最好在使用本地安全策略将Smb共享账户设置为禁止本地登录(加入本地登录黑名单,详情另见它文,这个步骤难以脚本化))
              net user $username $SmbUserKey /add /fullname:"Shared Folder User" /comment:"User for accessing shared folder" /expires:never 
              # 由于New-LocalUser在不同windows平台上可能执行失败,所以这里用net user,而不是用New-LocalUser
              # New-LocalUser -Name $username -Password $SmbUserKey -FullName 'Shared Folder User' -Description 'User for accessing shared folder'
              # 将新用户添加到Smb共享文件夹的用户组,这不是必须的(默认是没有SMB组的)
              # Add-LocalGroupMember -Group 'SMB' -Member $username
              Write-Output "共享专用用户已创建：$username"
          }
          else
          {
              Write-Error '您指定的用户名已经被占用,更换用户名或者使用已有的账户而不再创建新用户'
              return
          }
      }
      else
      {
          Write-Host '您未选择创建专门用于访问Smb共享文件夹的用户,请使用已有的用户账户及密码(不是pin码)作为访问凭证' -ForegroundColor Blue
      }
      if ($force)
      {
          # 设置共享文件夹权限(NTFS权限)
          Grant-PermissionToPath -Path $Path -ClearExistingRules
          Write-Output "已为用户 $username 设置文件夹权限"
      }
      # 查看目录的权限列表,如果需要进一步确认,使用windows自带的effective Access 查看
      Get-Acl $Path | Format-List *
  
      # 创建Smb共享文件夹的README
      New-SmbSharingReadme
      
  }
  
  #调用:
  #无参数默认调用
  Deploy-SmbSharing
  #自定义参数举例
  # Deploy-SmbSharing -Path C:\share -SmbUser smb2 -SmbUserkey 1 -Force

Note:上述脚本非常适合电脑小白,如果您的计算机没有用过相关功能,那么执行完上述脚本,您的`C:\`下有一个`Share`目录,并且里面有说明文档

### 本方案的特点

使用上述提供的一键创建共享文件夹脚本创建的共享文件夹在被访问时通常不会遇到**权限**不足被拒绝的问题(如果有应该是NTFS权限的问题,而不是共享权限,此时你使用`-ClearExistingRules`来清空权限限制(其实可通过`Deploy-SmbSharing `启用`-Force`选项来间接重置权限)或者通过GUI右键您所共享的文件夹属性进行调整)

也不需要把自己私人的账户密码告诉给别人就可以让对方访问您的共享文件夹(这个对方也可以是您的其他设备,比如手机(需要软件支持,比如ES文件浏览器,Cx文件管理器等))

脚本中启用了网络发现，对方在局域网或者虚拟局域网内访问时无需知道对方的IP,手机上支持SMB的软件访问同样可以扫描到共享文件夹服务器(自动获取ip),不需要手动输入IP地址

在创建好的共享文件夹内生成两份共享文件夹使用文档,包含了公开给局域网用户的登陆凭证(用户名,密码等信息),共享文件夹使用注意事项等

## 访问共享文件夹(Client)

执行完上述脚本,现在,您所在的网络(局域网)内的其他设备就可以通过专用的账户`$SmbUser`及其密码`$SmbUserkey`来访问您创建的共享文件夹了,访问  共享文件夹一般也很简单,但是由于访问形式的多样性和共享文件夹拥有着对文件夹的权限设置(包括共享权限和NTFS权限控制),用户可能会在访问时遇到问题

访问共享文件夹的方式有**两大类**

- 一种是直接用资源管理器访问,相当于访问一个文件夹;
- 一种是挂载成网络驱动器,可以为命令行访问提供方便

某些情况下直接访问文件夹会失败,这时候就需通过**映射(挂载)**方式来访问,挂载有GUI方案,也可以用命令行(适合自动化)



### 直接打开共享文件夹而不挂载到资源管理器

如果不打算挂载,可以仅打开共享文件夹

#### 使用服务器名访问

步骤:

1. 查看服务器计算机名,记为`$Server`
2. 在需要访问的设备上执行命令行` start \\$Server`即可

自动化:

首先`Server`上powershell命令行中输入以下内容执行

```powershell
#powershell中输入
$express="start \\$env:ComputerName";$express|scb;gcb

```

> 或者使用您前面设定的`$ShareName`变量值,这里字符串变成 `start \\$env:ComputerName\Share`

执行后会返回一串表示打开共享文件夹的命令行字符串,不妨称为**访问命令行**,例如`start \\COLORFULCXXU`;并且会自动复制到剪切板,在其他设备上执行命令

##### 演示操作

```powershell
PS> $express="start \\$env:ComputerName";$express|scb;gcb
start \\COLORFULCXXU #这一行是输出的用来访问共享文件夹的命令行,把这一行分享给其他设备用户使用(比较短,看一眼也可以自己手打这个命令行)
```

其他设备执行**访问命令行**通常需要输入凭证,也就是前面指定的`SmbUser`和密码`1`



#### 使用服务器ip地址访问

步骤:

1. 查询服务器的ip地址,记为`$server` (例如192.168.1.111)
2. 在需要访问的设备上执行命令行` start \\$Server`即可

#### 其他

仅在命令行中访问而不打开资源管理器也可以,考虑到这是给不熟悉命令行用户使用的,就不展开,详情另见它文



### 将共享文件夹挂载到资源管理器中(可选)

为了方便使用,在其他设备上使用您刚才创建的共享文件,这里给出一个命令行脚本来打开或者挂载该共享文件夹

#### 使用命令行挂载

如果你对知道一些命令行用法,并且你的小伙伴知道命令行窗口是什么,powershell怎么打开和运行,就可以将以下代码发给对方(注意,将其中的`$server`变量的值做填写)

```powershell
#挂载共享文件夹
$Letter='X' #这里默认将磁盘挂载位盘符X,这通常可以,但不保证,您可以选择自己喜欢的盘符,但是要避开已经被占用的盘符,例如C盘,是不可以用的
$server='请server提供者填写这个值后再发给其他设备去运行,比如192.168.1.177或者计算机名Desktop-xxx' 

$DriveLetter="${Letter}:"
net use $DriveLetter "\\$server\share" /user:SmbUser 1
# taskkill /f /im explorer.exe #重启资源管理器(如果没有在资源管理器中看到挂载盘符的话)
explorer $DriveLetter


```

> 注意:这个$server变量改为服务器的ip地址或者计算机名 
>
> 填写server端的计算机名或者ip地址(这里可以是计算机名,依赖于网络内的设备都开启网络发现功能,此外,手机上有些app支持共享文件夹一般能够扫描网络内的启用了网络发现的设备)

如果你的小伙伴不知道命令行,也不愿意了解,那么采用下面的方案

#### 生成脚本文件给其他设备执行挂载

上面的方案中我们需要手动查找ip或服务器名填写`$server`然后发给其他设备或小伙伴运行

为了更加自动化地填写上述脚本中的`$server`,获取共享文件夹的服务器`ip`地址的命令行:

```powershell
# windows 自带的powershell(v5)需要各个语句更严格的排版才能够正确解释和执行（不如powershell7之后的shell那么鲁棒，这个脚本在windows powershell上测试和调整过了）
$str = arp -a | Select-String '---' | Select-Object -First 1
# eg:$str = 'Interface: 192.168.1.178 --- 0x3'

# 使用正则表达式匹配IP地址模式
$ipAddress = [regex]::Match($str, '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b').Value
# 输出提取出的IP地址
return $ipAddress

$ScriptsFolder = "$home\desktop" #指定生成的脚本保存的目录,默认保存在桌面

$servername = $env:computerName

foreach ($scheme in 'ip', 'ServerName')
{
    if ($scheme -eq 'ip')
    {
        $schemeValue = $ipAddress 
    }
    else
    {
        $schemeValue = $env:ComputerName
    }
    #将下面的内容写入到一个文本文件中,后缀保存为.ps1格式,双击运行是选择使用powershell运行
    #如果运行失败,请使用这个命令行: Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass
    #==========================
    $res =@'
    #挂载共享文件夹
    $Letter='X' #这里默认将磁盘挂载位盘符X,如果失败,请尝试其他字母
    $server=
'@+ "'" + $schemeValue + "'" + @'
     #请将这个server字符串改为服务器的ip地址或者计算机名
    $DriveLetter="${Letter}:"
    net use $DriveLetter "\\$server\share" /user:SmbUser 1
    # taskkill /f /im explorer.exe #重启资源管理器(如果没有在资源管理器中看到挂载盘符的话)
    explorer $DriveLetter
    sleep 5 #等待5秒后关闭,此前可以观察脚本运行情况
'@ 
    Write-Host $res -ForegroundColor Blue
    Write-Host '#~~~~~~~~Scheme Separator~~~~~~~~~' -foreground Green
    $res > "$ScriptsFolder\MountShareFolderBy${env:username}@$scheme.ps1"

    #================================
}
explorer $ScriptsFolder #资源管理器中打开两个脚本所在目录
#如果顺利执行,终端内会打印出两段内容,并且在指定目录有2个文件;其他情况都是没有执行成功,比如只打印了一个ip地址,那就是有个别语句没有被正确执行
```

>  Note:如果没有得到正确ip地址内容,可以手动用`ipconfig /all`或直接点击任务栏上的网络图标进入属性查看`ip`地址

执行顺利的话,在您指定的目录(比如桌面)会产生两个文件,我的例子是

```powershell
PS> ls *share*ps1

        Directory: C:\Users\cxxu\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---          2024/7/7     21:59            455 󰞷  MountShareFolderBycxxu@ip.ps1
-a---          2024/7/7     21:59            454 󰞷  MountShareFolderBycxxu@ServerName.ps1

```

#### 使用生成的脚本

生成的脚本是`.ps1`后缀的文件,如果您的资源管理器没有设置**显示扩展名**,则可能看不到扩展名(这不是重点,用命令行`ls $ScriptsFolder\*.ps1`也可以查看)

两个脚本文件可能都能运行,也可能只有一个能用,一般用`xxx@ip.ps1`成功率更高,`xxx@ServerName`可能依赖于访问共享文件夹的客户端也启用网络发现功能)

您可以使用微信等工具将脚本发送到其他设备,然后其他设备运行脚本就可以自动挂载(然而情况并没有想象的那么简单)

- 当同一个网络内的其他设备(比如windows)没有安装powershell v7 ,那么双击运行了上述产生的脚本,并不会直接运行,而是会询问您要用什么方式打开,或者直接用记事本打开
- 这种情况下,就不得不用命令行,在开始菜单中找到powershell并打开;然后用户在用记事本打开脚本文件(右键脚本文件,选择打开方式,用记事本打开,根据需要可选择修改值),再复制全部内容,粘贴到powershell窗口中回车执行即可
- 或者您复制脚本文件中的内容(在命令行窗口内直接复制或者记事本打开脚本文件复制其中内容),用聊天工具发送给对方;然后对方在运行复制的命令行



#### FAQ:无法执行脚本?

windows为了安全起见会默认阻止用户执行powershell脚本文件,这时候需要在powershell中执行安全策略修改语句` Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser`,然后再双击执行脚本文件

这一点直接复制粘贴运行挂载或直接访问代码就没有这个问题

### 补充

#### 挂载检查

客户机运行时使用**普通权限即可**(这是默认的,所以通常不会出现问题),但我还是强调:**不要**使用**管理员**权限的命令行窗口来运行脚本内容(管理员挂载后非Administrator内置账户看不到挂载结果!)



## 拓展阅读:访问共享文件夹的一般方法

另见它文:[windows@资源管理器中的地址栏@访问共享文件夹的各种方法@管理共享文件夹-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/140139320)

## 总结

- 上面介绍的方法主要对于windows设备之间文件互传,并且不需要安装任何软件,同时有了脚本的帮忙,用户通常不需要修改权限等操作;
  - 而创建共享文件只是第一步,我们还分配了一个专门用来访问共享文件夹的专用账户,作为其他设备访问共享文件夹的凭证,提供了一定的安全性
  - 为了进一步提高安全性,我们还需要到**本地安全策略**配置一下共享凭证用户(smb)禁止登录到桌面的**用户权限分配**,设置**禁止本地登录**,将共享文件夹用户(smb)加入到该黑名单中,将权限限制都更合理的范围
- 最后就是其他设备如何利用之前提供的凭证访问到共享文件夹,通常可以直接访问(无密码用户访问可能会失败),也可以挂载到资源管理器中访问(命令行中给出凭证,成功率高)

## 拓展

- 除了共享文件的方法,还可以利用Alist或chfs等方法创建共享中心,其他设备可以用浏览器打开http链接来传输文件,预览一般格式的音频视频图片文本文件也是没问题的
- Alist+aria2rpc chfs  SMB  甚至 tfcenter 我同时再用相互补充，各有独自的优势
  - Alist 网页端的遗憾在于打包下载麻烦，aria2rpc 和打包下载还是差别的。
  - chfs 就做的很好，网页端操作符合直觉，配置简单，特别易用，但是符号链接和挂载网盘，权限管理方面又不如 Alist 
  - SMB共享文件夹挂载容易，比 webdav 尤其是 http 地链接更容易挂载，毕竟是系统功能，稳定性更好
  - 至于移动端设备上使用 Alist ，考虑到批量打包下载网页端不给力，手机端的话基本上还得下软件挂载 webdav 和 SMB 殊途同归。(chfs是可以打包xia'zai)
