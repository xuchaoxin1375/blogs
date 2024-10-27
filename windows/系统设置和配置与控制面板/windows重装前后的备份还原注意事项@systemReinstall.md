[toc]

# 备份

- 用到的powershell脚本:
  - [modulesByCxxu  (gitee.com)](https://gitee.com/xuchaoxin1375/scripts/tree/main/modulesByCxxu)

## 桌面快捷方式

- 调用`backup_deploy_shortcuts_lnk`进行备份或者还原(使用deploy参数指定`$True`还原)

## 符号链接备份

- 推荐的备份方式是备份创建符号链接的命令,而不是直接复制这些符号链接

### 扫描

- 调用powershell函数`backupSymbolicLinks`

## 系统环境变量

- 调用`backupEnvs_regeditPrintPath`

## 家目录中的配置文件

- 例如`.condarc`,`.git`

### 驱动

- 根据自己的习惯是否备份或者重装完再安装

## 软件数据

- wechat
- qq
- office 自定义配置
- ...

## 文档和下载数据

- 比如`$env:userprofile\downloads`
- `$env:userprofile\documents\`

# 备份恢复👺

## 第一批恢复

- 环境变量还原
  - `cd $configs\env`
  - 选择合适的版本进行还原(也可以双击文件还原),这是通过修改注册表还原
  - 重启终端
- 代理软件
  - 注意端口修改为惯用的端口号,例如`10801`,否则浏览器在导入的配置不匹配导致浏览器访问网络卡顿等问题
- 浏览器配置
  - 某些代理插件中导入配置后需要分别在代理列表和代理服务器点保存，例如
    - proxy switchomega（推荐）
    - SmartProxy

### 系统更新检查@驱动

- 刚安装的系统可能也会检查更新,这些行为不仅会占用带宽,而且会占用cpu资源
- 更新包括驱动下载(windows现在将驱动下载放到了更新中,因此除了自己到官网下载驱动还可以看看system update)傻等着可能不会自动给你装上
- 类似于显卡驱动,声卡驱动(以及DTS音效),都可以在windows update更新得到

### 部署powershell7和CxxuPsModule模块集合

```powershell
irm 'https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/Deploy-CxxuPsModules.ps1'|iex
```

但是加速链接用`invoke-webrequest`直接下载可能下不动,需要用浏览器访问一下链接后才能下得动

#### 独立安装pwsh7

上述命令不顺利,则尝试独立安装powershell7

[powershell7下载和安装@pwsh一键部署@powershell下载加速@国内镜像加速下载安装包 - xuchaoxin1375 - 博客园 (cnblogs.com)](https://www.cnblogs.com/xuchaoxin1375/p/18505385)

- ```
  irm 'https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/Deploy-Pwsh7Portable.ps1'|iex
   
  ```

  

## 第二批恢复

### 字体

- hack nerd font
- LiterationMonoFont兼容性更好(注意，字体包名为Liberation...，但内部字体文件名却为Literation...)

  - 可以使用scoop安装

    ```cmd
    scoop install liberationMono-NF -g
    ```

    


### 编辑器

- vscode 注意下载system版的而不是user版[Download Visual Studio Code - Mac, Linux, Windows](https://code.visualstudio.com/Download)

  - user版仅限当前用户使用，同时设备其他系统难以使用
  - 类似的原因，scoop 安装vscode也不是那么合适

- 这里可以使用winget来安装（如果精简版或ltsc版没有winget,可以借助scoop安装winget)，注意先对winget进行换源

- 全局安装需要管理员权限命令行窗口

  - ```cmd
    winget install Microsoft.VisualStudioCode --scope machine
    ```

    

  - ```cmd
    PS> winget install Microsoft.VisualStudioCode --scope machine
    Found Microsoft Visual Studio Code [Microsoft.VisualStudioCode] Version 1.94.2
    This application is licensed to you by its owner.
    Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
    Downloading https://vscode.download.prss.microsoft.com/dbazure/download/stable/384ff7382de624fb94dbaf6da11977bba1ecd427/VSCodeSetup-x64-1.94.2.exe
      ██████████████████████████████  95.7 MB / 95.7 MB
    Successfully verified installer hash
    Starting package install...
    Successfully installed
    ```

    


### 命令行工具👺

- winget
  - [使用 winget 工具安装和管理应用程序 | Microsoft Learn](https://learn.microsoft.com/zh-CN/windows/package-manager/winget/)
- powershell

- scoop
  
  - 可以先试试`iwr -useb get.scoop.sh | iex`,不行的话开代理`tun`模式
  - [scoopInstaller: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理。 (gitee.com)](https://gitee.com/glsnames/scoop-installer)
  
- python

  - [Download Python | Python.org](https://www.python.org/downloads/)

  - 下载源替换:

    

## 网盘云盘类

不是所有软件支持全局安装，如果支持也需要管理员权限，条件允许的话使用管理员权限命令行窗口来执行winget安装，避免潜在的权限不足问题

- ```cmd
  winget install --id=Alibaba.aDrive -e
  winget install Alibaba.QuarkCloudDrive --scope machine
  ```

  

## 网速问题🎈

- 网速监控软件`trafficMonitor`依赖于:[MS Visual C++ 程序包下载 | Microsoft Learn](https://learn.microsoft.com/zh-CN/cpp/windows/latest-supported-vc-redist?view=msvc-170)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/0f37ffe74f794f4195d83990100a7ad8.png)
  - 默认单位是`Mbps`,不过通常人们更习惯看`MBps`这个单位($MBps=Mbps/8$)

- 如果手机/wifi热点在电脑上很慢(其他设备或热点源本身很快)可能是电脑的问题
  - 比如硬件老化(或受损,可能性较小)等(如果重装前正常,也可能是驱动的问题)
  - 可以考虑手机做USB热点机(现在的手机可以同时链接wifi并作开热点)
  - network band(网络频段)调整(比如从2.4GHz调整到5GHz试试,现在的手机基本都支持)
    - 本人做这个实验的时候在图书馆,各种wifi信号很多,发现切换后确实稳定了不少
  - 另外,热点机本身可能会由于电量过低导致的速率下降的问题,建议电量充足的时候再测试一次.
  - 热点源距离等



## 同设备双系统链接式恢复

- 利用符号链接（symbolicLink）重定向用户家目录
  - 优点是方便，缺点是隔离性较差，容易造成相互影响

### 偷懒式

首先创建一个新用户,并把它加入到管理组中，也就是创建一个名为`maintainer`的维护用途的系统管理员

这种方式适合常态管理员权限的用户(本身双系统就是特殊用途,所以使用管理员权限方便跨分区跨系统版本访问可以理解)

但是注意，这种方式导致edge浏览器等Microsoft账户登录失败！总得来说不是很推荐

```cmd
net user maintainer 1 /add #默认密码为1，如果为了安全起见，可以设置得复杂一些
 net localgroup administrators maintainer /add
```

注销当前账户(假设为`cxxu`,然后切换登录到`maintainer`账户)

修改家目录名字,然后创建对应的符号链接(前面需要注销就是放置家目录被占用,用到第二个管理员账户)

### 正式

#### 预备👺(必须先执行)

```powershell
#使用管理员运行以下内容
#预备
$r = 'C' #一般是C盘,但允许更改
$s = 'D' #可以做必要的修改,比如E盘
$UserName = 'cxxu' #修改此值为你需要修改的用户家目录名字(一般是用户名)
$UserHome = "${r}:\users\$UserName"
$TargetUserHome = "${s}:\Users\$UserName"

$UserHomeBak = "${UserHome}.bak"
Write-Host 'check strings:', $UserName, $UserHome, $UserHomeBak,$TargetUserHome
#常用相关目录
$pf = 'Program Files'
$vscode_home = "${r}:\$pf\Microsoft VS Code"
$vscode_target_home = "${s}:\$pf\Microsoft VS Code"
$vscode_bin = "$vscode_home\bin"
```

#### 系统盘根目录

```powershell
#根目录部署
$items = @(
    'share',
    'repos',
    'exes',
    'Tuba'
     
)
$items | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "${r}:\$_" -Target "${s}:\$_" -Verbose -Force # -WhatIf 
}
```



#### 家目录

```powershell
# 家目录部署

## 偷懒式(不推荐)

Rename-Item -Path $UserHome -NewName"${UserHome}.bak"
New-Item -ItemType SymbolicLink -Path $UserHome -Target $TargetUserHome
```





#### 环境变量

```powershell
Update-PwshEnvIfNotYet
#部署其他环境
$UserEnv = (Get-ChildItem $configs\env\user*)[0]
$SystemEnv = (Get-ChildItem $configs\env\system*)[0]
Deploy-EnvsByPwsh -SourceFile $UserEnv -Scope User
Deploy-EnvsByPwsh -SourceFile $SystemEnv -Scope Machine
```



#### 常用软件安装目录

vscode 建议还是分开安装,否则插件可能无法正常验证登录,例如codeium

但是插件目录或`.vscode`目录可以共用



```powershell

# 需要提前载入Cxxu提供的ps模块👺(否则需要手动添加vscode/bin目录到环境变量)

## 部署命令行vscode,使得code <path> 命令可用
$env:PSModulePath+=";C:\repos\scripts\PS"
Add-EnvVar -EnvVar Path -NewValue $vscode_bin -Scope Machine
## 部署vscode家目录(不推荐,会有一些问题)
#New-Item -ItemType SymbolicLink -Path $vscode_home -Target $vscode_target_home

## 部署插件目录指向其他目录 #使用偷懒模式的话,下面就不需要执行了 
 New-Item -ItemType SymbolicLink -Path "$userHome\.vscode" -Target "$TargetUserHome\.vscode"
```

## 局域网

- 启用网络发现和共享文件夹:`Deploy-Smbsharing`(手机热点的话网络共享可能不好使,需要路由器)

### 常用软件的配置👺

```powershell
#部署常用软件的配置
Deploy-Shortcuts
Deploy-WtSettings
Deploy-Typora
Deploy-GitConfig
# Deploy-PortableGit 如果前面调用了Deploy-EnvsByPwsh,并且备份中保存了正确的PortableGit,就不需要再使用Deploy-PortableGit语句
# 安装7z
#部署ssh
Deploy-SSHVersionWin32Zip -file C:\exes\OpenSSH-Win64.zip
#重启终端检查ssh是否可用
New-SSHKeyPairs
```

浏览器内打开代理插件设置(比如proxyfy)

- typora 设置
  - 自动保存
  - 关闭拼写检查
  - 启用Markdown 代码片段行号显示

### 基础软件安装

- office
  - wps
  - microsoft office(无广告体验好点,但是体积大)

## 次要的系统设置

- 输入法调整
  - 默认英文标点符号
  - 关闭标点符号自动配对(影响代码编辑器中的自动配对功能)
- 系统语言包
- 夜间模式
- 恢复开始菜单固定的程式
