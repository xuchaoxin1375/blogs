[toc]



## 一键创建共享文件夹(Server)👺

### 简单操作步骤

如果您对共享文件夹创建细节不感兴趣,可以直接执行以下操作

- **管理员权限**打开一个`powershell`窗口

- 复制粘贴以下内容(如果需要,根据注释您可以手动修改相关变量来符合自己的需要)

  ```powershell
  #功能:快速创建一个可用的共享文件夹,能够让局域网内的用户访问您的共享文件夹
  # 使用前提要求:需要使用管理员权限窗口运行powershell命令行窗口
  
  #启用文件共享功能以及网络发现功能(后者是为了方便我们免ip访问,不是必须的)
  
  #对于中文系统
  netsh advfirewall firewall set rule group="文件和打印机共享" new enable=Yes
  netsh advfirewall firewall set rule group="网络发现" new enable=Yes
  #对于英文系统
  netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
  netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
  
  # 指定一个目录作为共享文件夹
  $p = 'C:\Share' #推荐尽可能短的目录(可以自定义,但是层级不宜深)
  $ShareName = 'Share' #如果您之前有过共享文件夹,并且名字也是Share,那么就需要修改名字
  $Permission = 'Change' #合法的值有:Read,Change,Full 权限从低到高 分别是只读(Read),可读可写(change),完全控制(full)
  # 指定专门用来访问共享文件夹的用户(这不是必须的,您可以用自己的用户和密码,但是不适合把自己的私人账户密码给别人访问,所以推荐建立一个专门的用户角色用于访问共享文件夹)
  $SmbUser = 'SmbUser' #如果本地已经有该用户，那么建议改名
  $password = '1' #密码可以改,但是建议尽可能简单,默认为1
  
  
  $exist = (Test-Path $p)
  if (! $exist)
  {
      mkdir $p
  }
  # 创建说明文件
  @'
  Files,folders,and links(symbolicLinks,JunctionLinks,HardLinks are supported to be shared )
  Others' can modify and read contents in the folder by defualt,you can change it 
  See more detail in https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbshare
  '@ > "$p\A Readme File@This is a shared folder! Place anything here to share with others.txt"
  
  
  # 创建共享文件夹
  "New-SmbShare -Name $ShareName -Path $p -${Permission}Access 'Everyone'" | Invoke-Expression #这里赋予任意用户修改权限(包含了可读权限和修改权限)
  $res = glu -Name "$SmbUser" -ErrorAction Ignore
  if (! $res)
  {
      # 权限要求:需要使用管理员权限窗口运行命令
      #方案1:使用net user 命令来创建带密码新用户(不要求安全性的共享凭证账户)
      net user $SmbUser $password /add /expires:never #这里添加的用户是永不过期的，更多参数查看官网文档
  
      #方案2:使用powershell方案来创建带密码新用户(
      # $password = Read-Host "Enter password For $SmbUser" -AsSecureString
      # 使用windows自带的powershell执行New-LocalUser不会报错,部分windows版本可能会报错,所以这里添加了一个导入语句,根据需要来添加或者移除(注释掉)这一行导入语句)
      # Import-Module microsoft.powershell.localaccounts -UseWindowsPowerShell
      # New-LocalUser -Name $SmbUser -Password $password -AccountNeverExpires 
  
  }
  


Note:上述脚本非常适合电脑小白,如果您的计算机没有用过相关功能,那么执行完上述脚本,您的`C:\`下有一个`Share`目录,并且里面有一个说明文档

## 访问共享文件夹(Client)

执行完上述脚本,现在,您所在的网络(局域网)内的其他设备就可以通过专用的账户`SmbUser`及其密码`1`来访问您创建的共享文件夹了

访问共享文件夹的方式有**两大类**,一种是直接用资源管理器访问,相当于访问一个文件夹;一种是挂载成网络驱动器,可以为命令行访问提供方便,而且某些情况下直接访问文件夹会失败,这时候就需通过挂载方式来访问,挂载有GUI方案,也可以用命令行(适合自动化)

并且通常而且不会遇到**权限**问题(如果有应该是NTFS权限的问题,而不是共享权限,此时需要右键您所共享的文件夹属性进行调整),也不需要把自己私人的账户密码告诉给别人就可以让对方访问您的共享文件夹(这个对方也可以是您的其他设备,比如手机(需要软件支持,比如ES文件浏览器,Cx文件管理器等))



### 直接打开共享文件夹而不挂载到资源管理器

如果不打算挂载,可以仅打开共享文件夹

首先Server上powershell命令行中输入以下内容执行

```powershell
#powershell中输入
$express="start \\$env:ComputerName";$express|scb;gcb

```

或者使用您前面设定的`$ShareName`变量值,这里字符串变成 `start \\$env:ComputerName\Share`

执行后会返回一串表示打开共享文件夹的命令行字符串,不妨称为**访问命令行**,例如`start \\COLORFULCXXU`;并且会自动复制到剪切板,在其他设备上执行命令

```powershell
PS> $express="start \\$env:ComputerName";$express|scb;gcb
start \\COLORFULCXXU
```

其他设备执行**访问命令行**通常需要输入凭证,也就是前面指定的`SmbUser`和密码`1`

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
    $res =
    @'
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

当同一个网络内的其他设备(比如windows)运行了上述产生的脚本(都是powershell脚本)之一

两个脚本文件可能都能运行,也可能只有一个能用,一般用`xxx@ip.ps1`成功率更高,`xxx@ServerName`可能依赖于访问共享文件夹的客户端也启用网络发现功能)

#### FAQ:无法执行脚本?

然而,windows会默认阻止用户执行powershell脚本文件,这时候需要在powershell中执行安全策略修改语句` Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser`,然后再双击执行脚本文件

这一点直接复制粘贴运行挂载或直接访问代码就没有这个问题

### 补充

#### 挂载检查

客户机运行时使用**普通权限即可**(这是默认的,所以通常不会出现问题),但我还是强调:**不要**使用**管理员**权限的命令行窗口来运行脚本内容(管理员挂载后非Administrator内置账户看不到挂载结果!)



## 如何访问共享文件夹的一般方法

另见它文:[windows@资源管理器中的地址栏@访问共享文件夹的各种方法@管理共享文件夹-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/140139320)

