## abstract

- 适合中国用户一键部署加速过的scoop包管理器：[scoop-cn/Deploy-ScoopForCNUser at master · xuchaoxin1375/scoop-cn (github.com)](https://github.com/xuchaoxin1375/scoop-cn/tree/master/Deploy-ScoopForCNUser)
- 脚本参考了多个相关的项目，做了整合，相关参考链接放到函数文档中

## 脚本说明

- 以下脚本对原脚本的扩展和改进,提供更多的灵活性和安装方案,以及更加详细的注释
- 对于某些精简版或修改版系统默认将用户权限提到Administrator的情况提供安装支持选项
- 关于脚本的稳定性和部署速度,这主要取决于加速镜像,`Get-AvailableGithubMirros`列出一些常见的镜像,它们当中在不同时段加速表现可能各不相同,如果你发现默认镜像或者你挑选的镜像加速效果不佳,那么请更换镜像
- 在更换镜像后,部署脚本重新执行可能会报错(也可能顺利执行),如果报错,可能是因为之前的错误或者不完整的安装执行操作污染了安装环境,可以尝试scoop清理缓存,提升到管理员权限等措施再重试安装
- 脚本版本说明(建议参考代码仓库以获取最新版本的部署脚本:[PS/Deploy/deploy.psm1 · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/PS/Deploy/deploy.psm1)) 或者下载此文件导入到powershell后调用
- 相关基础软件的我建议用`scoop install -g`选项全局安装,让windows上的所有用户都可以使用而不需要重复安装

### 权限说明

- 通常普通权限用户就可以利用此脚本安装scoop
- 个别情况下会出现安装失败,那么请使用管理员身份启动一个powershell窗口,然后在其中运行此部署脚本
  - 在管理员窗口下运行此脚本,脚本中提问你是否使用管理员权限安装时选择`y`才有效

### 下载或安装脚本

- 下载或者安装下面的脚本，然后用powershell执行（导入）
- 当然，您也可以直接复制下面的代码，然后粘贴到powershell中（推荐powershell v7+)
- 相关函数共有5个,其中是`Deploy-ScoopForCNUser`是主函数

```powershell

function Get-AvailableGithubMirrors
{
    <# 
.SYNOPSIS
列出流行的或可能可用的github加速镜像站
列表中的镜像站可能会过期,可用性不做稳定性和可用性保证

.DESCRIPTION
推荐使用aria2等多线程下载工具来加速下载,让镜像加速效果更加明显
    #>
    [CmdletBinding()]
    param(
        [switch]$ListView,
        [switch]$PassThru
    )

    $m1 = 'https://mirror.ghproxy.com'
    $m2 = 'https://ghproxy.cc'
    $m3 = 'https://github.moeyy.xyz/'
    $m4 = 'https://ghproxy.net/'
    $m5 = 'https://gh.ddlc.top/'
 
    Write-Host 'Available mirrors:'
    $mirrors = @($m1, $m2, $m3, $m4, $m5) 
    

    $s = { 
        $mirrors | ForEach-Object { 
            $i = [array]::IndexOf($mirrors, $_)
            Write-Host " ${i}: $_"
        }
    }

    $s.Invoke()
     
    if ($PassThru)
    {

        return $mirrors
    }
    
}

function Deploy-ScoopByGithubMirrors
{
    
    [CmdletBinding()]
    param (
        
        [switch]$InstallBasicSoftwares,
        $ScriptsDirectory = "$home/Downloads",
        [switch]$InstallForAdmin
    )
    $mirrors = Get-AvailableGithubMirrors -PassThru
    $numOfMirrors = $mirrors.Count
    $range = "[0~$($numOfMirrors-1)]"
    $num = Read-Host -Prompt "Select the number of the mirror you want to use $range ?(default: 0)"
    # $mirror = 'https://mirror.ghproxy.com'
    $n = $num -as [int] #可能是数字或者空$null
    Write-Host "`$n=$n"
    Write-Host "`$num=$num"
    Write-Host "`$numOfMirrors=$numOfMirrors"
    #  如果输入的是空白字符,则默认设置为0
    if ( $num.trim().Length -eq 0)
    {
        Write-Host 'choose the Default 0'
    }
    elseif ($n -notin 0..($numOfMirrors - 1))
    {
        Throw " Input a number within the range! $range"
    }
    else
    {
        # 用户选择了一个合法的数值
        Write-Host "You Selected mirror:[$n : $($mirrors[$n])]"
    }
    $mirror = $mirrors[$n]
    ## 加速下载scoop原生安装脚本
    $script = (Invoke-RestMethod $mirror/https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1)
 
    $installer = "$ScriptsDirectory/scoop_installer.ps1"
    $installer_cn = "$ScriptsDirectory/scoop_cn_installer.ps1"
    # 利用字符串的Replace方法，将 https://github.com 替换为 $mirror/https://github.com加速
    $script> $installer
    $script.Replace('https://github.com', "$mirror/https://github.com") > $installer_cn
 
    # 根据scoopd官方文档,管理员(权限)安装scoop时需要添加参数 -RunAsAdmin参数,否则会无法安装
    # 或者你可以直接将上述代码下载下来的家目录scoop_installer_cn文件中的相关代码片段注释掉(Deny-Install 调用语句注释掉)
    # $r = Read-Host -Prompt 'Install scoop as Administrator Privilege? [Y/n]'
    # if ($r)
    # {
    #     #必要时请手动打开管理员权限的powershell,然后运行此脚本
    #     Invoke-Expression "& $installer_cn -RunAsAdmin"
    # }
    # else
    # {
 
    #     Invoke-Expression "& $installer_cn"
    # }
    if ($InstallForAdmin)
    {
        #必要时请手动打开管理员权限的powershell,然后运行此脚本
        Invoke-Expression "& $installer_cn -RunAsAdmin"
    }
    else
    {
        Invoke-Expression "& $installer_cn"
    }
 
    # 将 Scoop 的仓库源替换为代理的
    scoop config scoop_repo $mirror/https://github.com/ScoopInstaller/Scoop
 
    
    
    # 可选部分
    ## 如果没有安装 Git等常用工具,可以解开下面的注释
    ## 先下载几个必需的软件的 JSON，组成一个临时的应用仓库
    if ($InstallBasicSoftwares)
    {
        New-Item -ItemType 'directory' -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket"
        New-Item -ItemType 'directory' -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip"
        New-Item -ItemType 'directory' -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git"
        # 7zip软件资源
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/7zip.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\7zip.json"
        #注册7-zip的右键菜单等操作
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/install-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip\install-context.reg"
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/uninstall-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip\uninstall-context.reg"

        # git软件资源
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/git.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\git.json"
     
        #注册git右键菜单等操作
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\install-context.reg"
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\uninstall-context.reg"
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-file-associations.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\install-file-associations.reg"
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-file-associations.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\uninstall-file-associations.reg"
        #注册aria2
        Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/aria2.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\aria2.json"
 
        # 安装时注意顺序是 7-Zip, Git, Aria2
        # 基础软件可以考虑全局安装(所有用户可以用,这需要管理员权限)
        scoop install scoop-cn/7zip -g
        scoop install scoop-cn/git -g
        scoop install scoop-cn/aria2 -g
        # 推荐使用aria2,设置多路下载
        # scoop config aria2-split 16
        scoop config aria2-options '-s 16 -x 16 -k 1M --retry-wait=2 --async-dns false'
    }
     
 
    # 将 Scoop 的 main 仓库源替换为代理加速过的
    if (Test-Path -Path "$env:USERPROFILE\scoop\buckets\main")
    {
        # 先移除默认的源，然后添加同名bucket和加速后的源
        scoop bucket rm main
    }
    Write-Host 'Adding speedup main bucket...'+" powered by： [$mirror]"
    scoop bucket add main $mirror/https://github.com/ScoopInstaller/Main
 
    # 之前的scoop-cn 库是临时的,还不是来自Git拉取的完整库，删掉后，重新添加 Git 仓库
    Write-Host 'remove Temporary scoop-cn bucket...'
    if (Test-Path -Path "$env:USERPROFILE\scoop\buckets\scoop-cn")
    {
        scoop bucket rm scoop-cn
    }
    Write-Host 'Adding scoop-cn bucket (from git repository)...'
    scoop bucket add scoop-cn $mirror/https://github.com/duzyn/scoop-cn
 
    # Set-Location "$env:USERPROFILE\scoop\buckets\scoop-cn"
    # git config pull.rebase true
 
    Write-Host 'scoop and scoop-cn was installed successfully!'
     
}
function Deploy-ScoopByGitee
{
    param (
        [switch]$InstallForAdmin,
        [switch]$InstallBasicSoftwares
    )
    # 脚本执行策略更改
    Set-ExecutionPolicy -ExecutionPolicy bypass -Scope CurrentUser
    #如果询问, 输入Y或A，同意
    
    # 执行安装命令（默认安装在用户目录下，如需更改请执行“自定义安装目录”命令）
    
    ## 自定义安装目录（注意将目录修改为合适位置)
    if ($InstallForAdmin)
    {
        $Script = "$home\Downloads\install.ps1"
        Invoke-RestMethod scoop.201704.xyz -OutFile $script #'install.ps1'
        # .\install.ps1 -ScoopDir 'D:\Scoop' -ScoopGlobalDir 'D:\GlobalScoopApps'
        & $Script -RunAsAdmin
    }
    else
    {

        Invoke-WebRequest -useb scoop.201704.xyz | Invoke-Expression
    }
    #添加包含国内软件的的scoopcn bucket,其他bucket可以自行添加
    # 更换scoop的repo地址
    scoop config SCOOP_REPO 'https://gitee.com/scoop-installer/scoop'
    # 拉取新库地址
    scoop update
    scoop bucket add extras
    scoop bucket add scoopcn https://gitee.com/scoop-installer/scoopcn
    if ($InstallBasicSoftwares)
    {
        scoop install 7zip git aria2 -g
    }
}
function Add-ScoopBuckets
{
    <# 
    .SYNOPSIS
    基本上，添加spc这个bucket就够了,软件数量很丰富
    .DESCRIPTION
    可以根据自己的需要往里面修改或添加更多的bucket
    .NOTES
    建议在Deploy-ScoopForCNUser调用时就指定相应的参数,不推荐单独调用(需要传入加速镜像地址参数)
    .EXAMPLE
    Add-ScoopBuckets -mirror  'https://mirror.ghproxy.com'
    #>
    #>
    [CmdletBinding()]
    param (
        # [parameter(Mandatory = $true)]    
        $mirror
    )
    if ($mirror)
    {

        Write-Verbose "The mirror is: $mirror"    
    }
    else
    {
        Write-Verbose 'The mirror is not specified!'
    }
    Write-Host 'Adding more buckets...(It may take a while, please be patient!)'
    $spc = "$mirror/https://github.com/lzwme/scoop-proxy-cn"
    Write-Verbose "The spc bucket is: $spc"
    scoop bucket add spc $spc  
            
}
function Deploy-ScoopForCNUser
{
 
    # & "$PSScriptRoot\scoopDeploy.ps1"
    
    <# 
.SYNOPSIS
国内用户部署scoop
.Description
允许用户在一台没有安装git等软件的windows电脑上部署scoop包管理工具
如果你事先安装好了git,那么可以选择不安装(默认行为)

脚本会通过github镜像站加速各个相关链接进行达到提速的目的
    通过加速站下载原版安装脚本
    通过替换原版安装脚本中的链接为加速链接来加速安装scoop
    根据需要创建临时的bucket,让用户可以通过scoop来安装git等软件
针对某些Administrator用户,scoop默认拒绝安装,这里根据官方指南,做了修改,允许用户选择仍然安装

使用gitee方案的,默认的bucket main 是加速过的,安装 7z,git等软件比较方便,不像镜像加速方案需要先自行建立临时的bucket提供初始下载
所以这里InstallBasicSoftwares参数是工给加速镜像方案的,不为gitee方案使用,让不同方案内体验更一致
.NOTES
代码来自git/gitee上的开源项目(感谢作者的相关工作和贡献)
.EXAMPLE
deploy-ScoopForCNUser
# 采用默认镜像加速方案部署scoop,并且安装基础软件(7z,git,aria2等),适合于新电脑环境下使用(如果需要为管理员权限安装,请追加-InstallForAdmin参数)
deploy-ScoopForCNUser -InstallBasicSoftwares

deploy-ScoopForCNUser -InstallBasicSoftwares -AddScoopBuckets #部署的时候一并添加常用的bucket

# 简洁用法:已经安装了7z git等软件,直接部署镜像加速的scoop
deploy-ScoopForCNUser #不需要参数
# 部署Gitee上的scoop爱好者贡献的加速仓库资源项目加速(最方便,但是可能比消耗资源)
例如,这里选择以管理员权限安装scoop,并且安装基础软件(7z,git,aria2等),使用了一下选项
deploy-ScoopForCNUser -UseGiteeForkAndBucket -InstallBasicSoftwares -InstallForAdmin 
# 

.DESCRIPTION
使用镜像加速下载scoop原生安装脚本并做一定的修改提供加速安装(但是稳定性和可靠性不做保证)
此脚本参考了多个开源方案,为提供了更多的灵活性和备用方案的选择,尤其是可以添加spc这个大型bucket,以提供更多的软件包
.LINK
镜像加速参考
https://github.akams.cn/ 
.LINK
https://gitee.com/twelve-water-boiling/scoop-cn
.LINK
# 提供 Deploy-ScoopByGitee 实现资源
https://gitee.com/scoop-installer/scoop
.LINK
# 提供 Deploy-scoopbyGithubMirrors 实现方式
https://lzw.me/a/scoop.html#2%20%E5%AE%89%E8%A3%85%20Scoop
.LINK
# 提供 大型bucket spc 资源
https://github.com/lzwme/scoop-proxy-cn
.LINK
相关博客
#提供 Deploy-ScoopForCNUser 整合与改进
https://cxxu1375.blog.csdn.net/article/details/121067836

在这里搜索scoop相关笔记
https://gitee.com/xuchaoxin1375/blogs/blob/main/windows 

#>
    # [CmdletBinding(DefaultParameterSetName = 'Manual')]
    param(
       
        # 是否仅查看内置的候选镜像列表
        # [switch]$CheckMirrorsBuildin,
        # 从镜像列表中选择镜像
        # [switch]$SelectMirrorFromList,
        # 是否安装基础软件，比如git等（考虑到有些用户已经安装过了，我们可以按需选择）
        # [parameter(ParameterSetName = 'Manual')]
        [switch]$InstallBasicSoftwares,
        [parameter(ParameterSetName = 'Gitee')]
        [switch]$UseGiteeForkAndBucket,
        # 是否添加一个大型的bucket
        [switch]$AddMoreBuckets,
        # 管理员权限下安装
        [switch]$InstallForAdmin,
        # 延迟启动安装,给用户一点时间反悔
        $delay = 2
    )
    
    
    # return $mirror

    # 安装 Scoop
    # Gitee方案(简短,执行完后自动退出)
    if ($UseGiteeForkAndBucket)
    {
        Write-Host 'UseGiteeForkAndBucket scheme...'
        Start-Sleep $delay
        Deploy-ScoopByGitee -InstallBasicSoftwares:$InstallBasicSoftwares -InstallForAdmin:$InstallForAdmin 

 
    }
    # 手动配置镜像方案
    else
    {
        Write-Host 'Use manual scheme...'
        # Start-Sleep $delay
        Deploy-ScoopByGithubMirrors -InstallBasicSoftwares:$InstallBasicSoftwares -InstallForAdmin:$InstallForAdmin

    }

    if ($AddMoreBuckets)
    {
        # 添加bucket,包含很多软件包(几乎scoop bucket known列出的bucket的软件都能够在spc中找到)
        Add-ScoopBuckets -mirror $mirror
    }

    #检查用户安装了哪些bucket,以及对应的bucket源链接
    scoop bucket list

}

```

### Notes

- 上述脚本经过测试,可以正常工作
- 可以新建一个本地账户(利用语句`net user tester 1 /add`创建一个测试用户`tester`,密码是`1`);登陆`tester`来验证其是否能工作

## 获取脚本文件及其使用

### 导入

- 方案1：从脚本文件导入powershell

  - 可以复制粘贴上述代码到文本文件,然后修改后缀为`.ps1`


  - 也从仓库的`Deploy-ScoopForCNUser`中保存脚本文件


  - 然后打开powershell执行这个脚本文件,会导入其中的函数

- 方案2：通过复制粘贴到powershell中回车导入

### 执行方案

- 导入完毕后，选择执行方案

  - 这里提供了多个函数,其中主要函数是`deploy-ScoopForCNUser `,有两大类调用语法(对应两类部署方案,默认使用第一种)

    - ```powershell
      PS C:\repos\scoop-cn> gcm Deploy-ScoopForCNUser -Syntax
      
      Deploy-ScoopForCNUser [-InstallBasicSoftwares] [-AddMoreBuckets] [-delay <Object>] [<CommonParameters>]
      
      Deploy-ScoopForCNUser [-UseGiteeForkAndBucket] [-AddMoreBuckets] [-delay <Object>] [<CommonParameters>]
      ```


- 如果用户事先安装过`Git`,那么可以直接执行`Deploy-ScoopForCNUser`,其他参数可选

- 对于没有安装过`Git`的用户,建议使用(否则会因为确实Git而无法添加Bucket等操作)

  ```powrershell
  deploy-ScoopForCNUser -InstallBasicSoftwares
  ```

- 或者使用另一种Gitee方案安装

  ```powershell
  deploy-ScoopForCNUser -UseGiteeForkAndBucket
  ```



### FAQ

- 对于脚本文件方案，如果执行失败,可以设置执行策略:

  ```powershell
  set-executionPolicy -Scope CurrentUser -ExecutionPolicy bypass
  ```

  - 然后重新尝试

## 演示记录

```powershell
PS C:\Users\cxxu> deploy-ScoopForCNUser -InstallBasicSoftwares
Use manual scheme...
Available mirrors:
 0: https://mirror.ghproxy.com
 1: https://ghproxy.cc
 2: https://github.moeyy.xyz/
 3: https://ghproxy.net/
 4: https://gh.ddlc.top/
Select the number of the mirror you want to use [0~4] ?(default: 0): 0
$n=0
$num=0
$numOfMirrors=5
You Selected mirror:[0 : https://mirror.ghproxy.com]
Install scoop as Administrator Privilege? [Y/n]: n
Initializing...
Scoop is already installed. Run 'scoop update' to get the latest version.
Abort.
'scoop_repo' has been set to 'https://mirror.ghproxy.com/https://github.com/ScoopInstaller/Scoop'
New-Item: An item with the specified name C:\Users\cxxu\scoop\buckets\scoop-cn\bucket already exists.
New-Item: An item with the specified name C:\Users\cxxu\scoop\buckets\scoop-cn\scripts\7-zip already exists.
New-Item: An item with the specified name C:\Users\cxxu\scoop\buckets\scoop-cn\scripts\git already exists.
WARN  Purging previous failed installation of 7zip.
ERROR '7zip' isn't installed correctly.
Removing older version (24.08).
'7zip' was uninstalled.
Installing '7zip' (24.08) [64bit] from 'scoop-cn' bucket
7z2408-x64.msi (1.9 MB) [=====================================================================================] 100%
Checking hash of 7z2408-x64.msi ... ok.
Extracting 7z2408-x64.msi ... done.
Linking ~\scoop\apps\7zip\current => ~\scoop\apps\7zip\24.08
Creating shim for '7z'.
Creating shim for '7zFM'.
Making C:\Users\cxxu\scoop\shims\7zfm.exe a GUI binary.
Creating shim for '7zG'.
Making C:\Users\cxxu\scoop\shims\7zg.exe a GUI binary.
Creating shortcut for 7-Zip (7zFM.exe)
Persisting Codecs
Persisting Formats
Running post_install script...done.
'7zip' (24.08) was installed successfully!
Notes
-----
Add 7-Zip as a context menu option by running: "C:\Users\cxxu\scoop\apps\7zip\current\install-context.reg"
Installing 'git' (2.46.0) [64bit] from 'scoop-cn' bucket
PortableGit-2.46.0-64-bit.7z.exe (58.6 MB) [==================================================================] 100%
Checking hash of PortableGit-2.46.0-64-bit.7z.exe ... ok.
Extracting PortableGit-2.46.0-64-bit.7z.exe ... done.
Linking ~\scoop\apps\git\current => ~\scoop\apps\git\2.46.0
Creating shim for 'sh'.
Creating shim for 'bash'.
Creating shim for 'git'.
Creating shim for 'gitk'.
Making C:\Users\cxxu\scoop\shims\gitk.exe a GUI binary.
Creating shim for 'git-gui'.
Making C:\Users\cxxu\scoop\shims\git-gui.exe a GUI binary.
Creating shim for 'scalar'.
Creating shim for 'tig'.
Creating shim for 'git-bash'.
Making C:\Users\cxxu\scoop\shims\git-bash.exe a GUI binary.
Creating shortcut for Git Bash (git-bash.exe)
Creating shortcut for Git GUI (git-gui.exe)
Running post_install script...done.
'git' (2.46.0) was installed successfully!
Notes
-----
Set Git Credential Manager Core by running: "git config --global credential.helper manager"

To add context menu entries, run 'C:\Users\cxxu\scoop\apps\git\current\install-context.reg'

To create file-associations for .git* and .sh files, run
'C:\Users\cxxu\scoop\apps\git\current\install-file-associations.reg'
Installing 'aria2' (1.37.0-1) [64bit] from 'scoop-cn' bucket
aria2-1.37.0-win-64bit-build1.zip (2.4 MB) [==================================================================] 100%
Checking hash of aria2-1.37.0-win-64bit-build1.zip ... ok.
Extracting aria2-1.37.0-win-64bit-build1.zip ... done.
Linking ~\scoop\apps\aria2\current => ~\scoop\apps\aria2\1.37.0-1
Creating shim for 'aria2c'.
'aria2' (1.37.0-1) was installed successfully!
'aria2-options' has been set to '-s 16 -x 16 -k 1M --retry-wait=2 --async-dns false'
The main bucket was removed successfully.
Adding speedup main bucket... + powered by： [https://mirror.ghproxy.com]
Checking repo... OK
The main bucket was added successfully.
remove Temporary scoop-cn bucket...
The scoop-cn bucket was removed successfully.
Adding scoop-cn bucket (from git repository)...
Checking repo... OK
The scoop-cn bucket was added successfully.
scoop and scoop-cn was installed successfully!

Name     Source                                                            Updated            Manifests
----     ------                                                            -------            ---------
main     https://mirror.ghproxy.com/https://github.com/ScoopInstaller/Main 2024/8/26 12:29:00      1339
scoop-cn https://mirror.ghproxy.com/https://github.com/duzyn/scoop-cn      2024/8/26 9:41:36       5675

PS C:\Users\cxxu> Add-ScoopBuckets -mirror  'https://ghproxy.cc' -Verbose
VERBOSE: The mirror is: https://ghproxy.cc
Adding more buckets...(It may take a while, please be patient!)
VERBOSE: The spc bucket is: https://ghproxy.cc / https://github.com/lzwme/scoop-proxy-cn
Checking repo... ERROR 'https://ghproxy.cc / https://github.com/lzwme/scoop-proxy-cn' doesn't look like a valid git repository

Error given:
fatal: unable to access 'https://ghproxy.cc / https://github.com/lzwme/scoop-proxy-cn/': URL rejected: Malformed input to a URL function
PS C:\Users\cxxu> add-ScoopBuckets -mirror  'https://ghproxy.cc' -Verbose^C
PS C:\Users\cxxu>
PS C:\Users\cxxu> function Add-ScoopBuckets
>> {
>>     <#
>>     .SYNOPSIS
>>     基本上，添加spc这个bucket就够了,软件数量很丰富
>>     .DESCRIPTION
>>     可以根据自己的需要往里面修改或添加更多的bucket
>>     .EXAMPLE
>>     Add-ScoopBuckets -mirror  'https://mirror.ghproxy.com'
>>     #>
>>     #>
>>     [CmdletBinding()]
>>     param (
>>         $mirror
>>     )
>>     if($mirror){
>>
>>         Write-Verbose "The mirror is: $mirror"
>>     }else{
>>         Write-Verbose "The mirror is not specified!"
>>     }
>>     Write-Host 'Adding more buckets...(It may take a while, please be patient!)'
>>     $spc="$mirror/https://github.com/lzwme/scoop-proxy-cn"
>>     Write-Verbose "The spc bucket is: $spc"
>>     scoop bucket add spc $spc
>>
>> }
PS C:\Users\cxxu> add-ScoopBuckets -mirror  'https://ghproxy.cc' -Verbose
VERBOSE: The mirror is: https://ghproxy.cc
Adding more buckets...(It may take a while, please be patient!)
VERBOSE: The spc bucket is: https://ghproxy.cc/https://github.com/lzwme/scoop-proxy-cn
Checking repo... OK
The spc bucket was added successfully.
```



## refs

.LINK
镜像加速参考
https://github.akams.cn/ 
.LINK
https://gitee.com/twelve-water-boiling/scoop-cn
.LINK

提供 Deploy-ScoopByGitee 实现资源

https://gitee.com/scoop-installer/scoop
.LINK

提供 Deploy-scoopbyGithubMirrors 实现方式

https://lzw.me/a/scoop.html#2%20%E5%AE%89%E8%A3%85%20Scoop
.LINK

提供 大型bucket spc 资源

https://github.com/lzwme/scoop-proxy-cn
.LINK
相关博客
#提供 Deploy-ScoopForCNUser 整合与改进
https://cxxu1375.blog.csdn.net/article/details/121067836

在这里搜索scoop相关笔记
https://gitee.com/xuchaoxin1375/blogs/blob/main/windows 