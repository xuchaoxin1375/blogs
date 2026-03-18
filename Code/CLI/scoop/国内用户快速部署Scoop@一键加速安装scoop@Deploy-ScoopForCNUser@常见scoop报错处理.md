[toc]



## abstract

- 本文在线链接: [国内用户快速部署Scoop@一键加速安装scoop@Deploy-ScoopForCNUser_scoop 安装-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/141385998)

- [Scoop: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理](https://gitee.com/scoop-installer/scoop)
- 适合中国用户一键部署加速过的scoop包管理器：[scoop-cn/Deploy-ScoopForCNUser at master · xuchaoxin1375/scoop-cn (github.com)](https://github.com/xuchaoxin1375/scoop-cn/tree/master/Deploy-ScoopForCNUser)
- 脚本参考了多个相关的项目，做了整合，相关参考链接放到函数文档中
- 直奔本文重点请跳转到 [下载和安装脚本]一节



## 下载脚本👺

### 脚本版本更新

- 脚本版本说明(建议参考代码仓库以获取最新版本的部署脚本:[PS/Deploy/deploy.psm1 · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/PS/Deploy/Deploy.psm1)) 或者下载此文件导入到powershell后调用
  - 仓库代码可能会被误报违规,如果无法直接查看,你有如下选择
    - 无法在线查看,但是可以下载/克隆本仓库离线查看
    - 将链接中的`gitee.com`修改为`github.com`再尝试访问源代码(从github导入gitee的仓库)

- 相关基础软件的我建议用`scoop install -g`选项全局安装,让windows上的所有用户都可以使用而不需要重复安装

### 权限说明

- 通常普通权限用户就可以利用此脚本安装scoop
- 个别情况下会出现安装失败,那么请使用管理员身份启动一个powershell窗口,然后在其中运行此部署脚本
- 在管理员窗口下运行此脚本,脚本中提问你是否使用管理员权限安装时选择`y`才有效

### 在线下载脚本并安装🎈

打开powershell窗口,有两类安装:**管理员模式和普通用户模式**(处于安全性,scoop默认是拒绝管理员方式,但是可以通过参数来启用管理员模式安装)

- 如果是普通权限用户,则可以直接运行安装脚本(使用)
- 如果是管理员账户,例如`Administrator`,或者当前用户属于Administrators组的用户,可以右键powershell以管理员方式运行,在shell中

```powershell
irm https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/Deploy.psm1 |iex
gcm *scoop* #查看关于scoop的可用命令
#部署scoop for Chinese User
## 查看基本语法
gcm Deploy-ScoopForCNUser -syntax

#默认部署方案(下面两种方式中,可以选的使用-InstallBasicSoftwares,这会预先帮你安装一些常用的工具)
# 下面两个方案二选一(不要都跑!)
# 方案1:普通用户方式方案(根据自己的安装条件和偏好使用)
Deploy-ScoopForCNUser -UseGiteeForkAndBucket

# 方案2:管理员方式安装方案(按需使用!要求管理员权限!)
Deploy-ScoopForCNUser -UseGiteeForkAndBucket  -InstallForAdmin
```

> 对于管理员窗口,需要你追加参数,`[-InstallForAdmin]`
>

可用选项可能有`Deploy-ScoopForCNUser [-InstallBasicSoftwares] [-UseGiteeForkAndBucket] [-InstallForAdmin] [-delay <Object>] [<CommonParameters>]`

如果你后悔了使用默认安装方案,可以进入到你的用户家目录,将`scoop`文件夹重命名为其他名字或者直接移除

> 要谨慎使用`scoop uninstall scoop`,除非你的scoop刚才第一次安装,或者你想彻底移除以前scoop 安装的任何东西,包括全局安装的内容甚至双系统安装的软件复用部分(如果有的话)

然后重新使用`Deploy-ScoopforCnUser`配合不同的安装参数即可

### Notes

- 上述脚本经过测试,可以正常工作
  - 可以将`scoop`家目录重命名为`scoop.bak`(包括用户家目录下的`scoop`和通过全局安装软件产生的`C:\programdata\scoop`目录(如果有的话,也都重命名));然后重新测试此`scoop`部署方案
  - 也可以新建一个本地账户(利用语句`net user tester 1 /add`创建一个测试用户`tester`,密码是`1`);登陆`tester`来验证其是否能工作

## 脚本说明

- 以下脚本对原脚本的扩展和改进,提供更多的灵活性和安装方案,以及更加详细的注释
- 对于某些精简版或修改版系统默认将用户权限提到Administrator的情况提供安装支持选项
- 关于脚本的稳定性和部署速度,这主要取决于加速镜像,`Get-AvailableGithubMirros`列出一些常见的镜像,它们当中在不同时段加速表现可能各不相同,如果你发现默认镜像或者你挑选的镜像加速效果不佳,那么请更换镜像

### 可能出现的报错问题👺

- 在更换镜像后,部署脚本重新执行**可能会报错**(也可能顺利执行),如果报错,可能是因为之前的错误或者不完整的安装执行操作污染了安装环境,可以尝试scoop清理缓存,提升到管理员权限等措施再重试安装

  - 直接复制粘贴脚本内容到windows powershell(v5)直接运行容易出问题,建议保存脚本到文本文件中,然后修改后缀为`.ps1`
  - 然后用管理员权限打开powershell,通过`. <ScriptFilePath>`的方式导入其中的函数,最后调用部署函数即可
  - 如果安装途中报错,请卸载掉scoop(使用命令`scoop uninstall scoop`),然后重新安装(重新调用部署函数)
  - 如果你之前没有用过`git`这类工具,部署scoop要加上`-installbasicsoftwares`

- 另一类报错是安装完毕而在使用过程中报错

- 其中gitee方案部分时候会报错,比如代理服务器代理过程中发生错误(500系列的错误),我们可以选择重试

  ```powershell
  PS> sudo pwsh -c scoop install gdb -g
  Installing 'gdb' (14.1) [64bit] from 'main' bucket
  proxy: https://nuwen.net/files/mingw/components-19.0.7z
  The remote server returned an error: (530) Server Error.
  URL https://nuwen.net/files/mingw/components-19.0.7z is not valid
  ```

  ```powershell
  PS> sudo pwsh -c scoop install gdb -g
  #自动清理之前的不成功安装
  WARN  Purging previous failed installation of gdb.
  ERROR 'gdb' isn't installed correctly.
  Removing older version (14.1).
  'gdb' was uninstalled.
  
  Installing 'gdb' (14.1) [64bit] from 'main' bucket
  proxy: https://nuwen.net/files/mingw/components-19.0.7z
  components-19.0.7z (58.6 MB) [===================================================] 100%
  Checking hash of components-19.0.7z ... ok.                                                                             
  Extracting components-19.0.7z ... done.
  Running pre_install script...done.
  Linking C:\ProgramData\scoop\apps\gdb\current => C:\ProgramData\scoop\apps\gdb\14.1
  Creating shim for 'gdb'.
  Creating shim for 'gdbserver'.                                                                                          
  'gdb' (14.1) was installed successfully!
  ```

### 还有其他类型的错误👺

#### 下载阶段发生报错或失败

- 从默认bucket或者指定bucket下载失败,可以考虑更换其他bucket(如果其他bucket也有的话)
- 启用aria2下载可能会被拒绝,尤其还不恰当的aria2参数配置,可能导致下载出错,考虑禁用(可以临时禁用)掉aria2
- 中断和恢复
  - 假设你的buckets中(可能是同一个bucket但是分别用不同的镜像加速成不同名字的bucket,例如`extras`,`extras1`,`extras2`,...)有多个提供了你想要的包`Pkgx`.那么你可以从中选择一个或者默认不指定由scoop为你选择一个bucket下载并安装
  - 这时候你可能发现它下载的比较慢或者不够快,于是你尝试手动指定bucket换一个下载来源,这种情况下建议第二次安装时使用`-g`选项,这样会忽略掉之前下载的部分,否则可能因为之前下载的文件因为打断有错误或者版本有差异导致aria2下不动它

#### 下载成功但是安装时报错

- 未能够通过hash校验,可以尝试`scoop install`时重新下载`-k`,或者跳过校验`-s`选项
- 全局安装权限不足可能报错
- 安装过程中由于安装脚本和软件版本适配问题而报错,这种情况就比较复杂,考虑不用scoop安装,采用其他方式安装(这种情况比较少)
- 需要的bucket未安装,例如spc bucket中有个包`quarkpan`,但是安装的时候提示你没有`aki`这个bucket,scoop提示你安装添加`aki` bucket,我们可以网络搜`scoop bucket add aki`,获取`aki`链接(可以配合加速镜像),或者找国内的加速项目获取加速的链接,例如`scoop bucket add aki https://gitee.com/scoop-installer/aki-apps`

## 部署方案说明👺

- 一般来说,使用`Gitee`方案部署对于许多来自非github但是国内又不容易下载的资源来说是更合适的Scoop安装方案
- 而`Mirror`方案则主要针对github上的资源
- 为了方便切换,我提供了`Update-ScoopMirror`这个函数,允许用户灵活切换`Scoop_repo`,并且更新scoop

- 例如

```powershell
 Update-ScoopMirror -UseGiteeScoop #切换当前scoop为gitee版
```

- 使用不带参数的`Update-ScoopMirror`来从新选择一个镜像切换为`Mirror`版scoop
- 还支持更新基础`Buckets`或者更新指定bucket的source所使用的加速Mirror,详情查看`Update-ScoopMirror`文档

### 用例

下载typora,这个软件不是放在github上的,而且国内网络难以直接下载,需要借助代理下载,github的加速镜像也下不动,需要使用proxy模式下载

为了使用通用proxy下载,需要切换到`gitee`方案的scoop(这不是说gitee方案一定更好,有时gitee的scoop做出的决策不一定最好,可能会选用慢速的Mirror来代理,导致指定不同`bucket`还下不动,这种情况需要借助`update-ScoopMirror`将scoop版本切换到官方版本Mirror加速的方案;或者直接指定自己的代理资源)

- 这里我指定从`spc1`这个bucket下载typora

  - ```powershell
    PS> scoop download spc1/typora
    INFO  Downloading 'typora' [64bit] from spc1 bucket
    proxy: https://download.typora.io/windows/typora-setup-x64-1.9.5.exe
    Starting download with aria2 ...
    Download: Download Results:
    Download: gid   |stat|avg speed  |path/URI
    Download: ======+====+===========+=======================================================
    Download: 9fc611|OK  |   7.1MiB/s|C:/Users/cxxu/scoop/cache/typora#1.9.5#2505486.exe
    Download: Status Legend:
    Download: (OK):download completed.
    Checking hash of typora-setup-x64-1.9.5.exe ... ok.
    'typora' (1.9.5) was downloaded successfully!
    ```

- 这里虽然也是gitee版,但是默认从`extras`bucket下载,没有触发非CN代理方案,所以还是下不动

  ```powershell
  PS> scoop download typora
  INFO  Downloading 'typora' [64bit] from extras bucket
  direct (Not in CN): https://download.typora.io/windows/typora-setup-x64-1.9.5.exe
  Starting download with aria2 ...
  Download: [#fa59b5 0B/0B CN:1 DL:0B]
  ```

  

## 获取脚本文件及其使用

### 导入

- 方案1：从脚本文件导入powershell

  - 可以复制粘贴上述代码到文本文件,然后修改后缀为`.ps1`


  - 也从仓库的`Deploy-ScoopForCNUser`中保存脚本文件


  - 然后打开powershell执行这个脚本文件,会导入其中的函数

- 方案2：通过复制粘贴到powershell中回车导入

### 执行方案

- 导入完毕后，选择执行方案，调用语法查看` gcm Deploy-ScoopForCNUser -Syntax`

  - ```powershell
    PS C:\repos\scoop-cn> gcm Deploy-ScoopForCNUser -Syntax
    
    Deploy-ScoopForCNUser [-InstallBasicSoftwares] [-UseGiteeForkAndBucket] [-InstallForAdmin] [-delay <Object>] [<CommonParameters>]
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

- 可以追加`-InstallForAdmin`支持管理员安装


### FAQ

- 对于脚本文件方案，如果执行失败,可以设置执行策略:

  ```powershell
  set-executionPolicy -Scope CurrentUser -ExecutionPolicy bypass
  ```

  - 然后重新尝试

## 测试部署脚本

- 修改和更新此部署脚本时,为了不影响已有的scoop环境及其安装的软件,有多重隔离方法
  - 将原来的scoop家目录重命名,然后执行部署脚本
  - 新建一个测试用户tester,登录到tester在执行部署脚本
  - 用虚拟机或者另一台设备进行测试
- 上面几种方法由简单到复杂,但是隔离效果也越好,通常第一种就够用了

## 演示记录

### 使用gitee方案部署

```
PS> deploy-scoopForCNUser -UseGiteeForkAndBucket -Verbose
UseGiteeForkAndBucket scheme...
VERBOSE: Requested HTTP/1.1 GET with 0-byte payload
VERBOSE: Received HTTP/1.1 response of content type text/plain of unknown size
VERBOSE: -------- PSBoundParameters --------
VERBOSE: -------- Environment Variables --------
VERBOSE: $env:USERPROFILE: C:\Users\cxxu
VERBOSE: $env:ProgramData: C:\ProgramData
VERBOSE: $env:SCOOP:
VERBOSE: $env:SCOOP_CACHE:
VERBOSE: $env:SCOOP_GLOBAL:
VERBOSE: -------- Selected Variables --------
VERBOSE: SCOOP_DIR: C:\Users\cxxu\scoop
VERBOSE: SCOOP_CACHE_DIR: C:\Users\cxxu\scoop\cache
VERBOSE: SCOOP_GLOBAL_DIR: C:\ProgramData\scoop
VERBOSE: SCOOP_CONFIG_HOME: C:\Users\cxxu\.config
Initializing...
Downloading...
VERBOSE: Cloning https://gitee.com/scoop-installer/scoop.git to C:\Users\cxxu\scoop\apps\scoop\current
VERBOSE: Cloning https://gitee.com/scoop-installer/Main.git to C:\Users\cxxu\scoop\buckets\main
Creating shim...
Scoop was installed successfully!
Type 'scoop help' for instructions.
'SCOOP_REPO' has been set to 'https://gitee.com/scoop-installer/scoop'
Updating Scoop...
Updating Buckets...
Scoop was updated successfully!
VERBOSE: Scoop add more buckets(this process may failed to perform!You can retry to add buckets manually later!
VERBOSE: Requested HTTP/1.1 GET with 0-byte payload
VERBOSE: Received HTTP/1.1 468-byte response of content type application/json
direct: https://gitee.com/scoop-installer/Extras
Checking repo... OK
The extras bucket was added successfully.
VERBOSE: Requested HTTP/1.1 GET with 0-byte payload
VERBOSE: Received HTTP/1.1 468-byte response of content type application/json
direct: https://gitee.com/scoop-installer/scoopcn
Checking repo... OK
The scoopcn bucket was added successfully.

Name    Source                                     Updated            Manifests
----    ------                                     -------            ---------
main    https://gitee.com/scoop-installer/Main.git 2024/8/29 8:33:52       1338
extras  https://gitee.com/scoop-installer/Extras   2024/8/29 10:45:29      2062
scoopcn https://gitee.com/scoop-installer/scoopcn  2024/8/28 16:34:02        30
```

### 使用github镜像加速部署

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
 
PS C:\Users\cxxu> add-ScoopBuckets -mirror  'https://ghproxy.cc' -Verbose
VERBOSE: The mirror is: https://ghproxy.cc
Adding more buckets...(It may take a while, please be patient!)
VERBOSE: The spc bucket is: https://ghproxy.cc/https://github.com/lzwme/scoop-proxy-cn
Checking repo... OK
The spc bucket was added successfully.
```

### 添加额外buckets👺

```powershell
PS🌙[BAT:100%][MEM:30.2% (2.37/7.85)GB][11:19:24]
# [cxxu@CXXUREDMIBOOK][<以:192.168.1.198>][~]
PS> Add-ScoopBuckets
Available mirrors:
 0: Use No Mirror
 1: https://mirror.ghproxy.com
 2: https://ghproxy.cc
 3: https://github.moeyy.xyz
 4: https://ghproxy.net
 5: https://gh.ddlc.top
Select the number of the mirror you want to use [0~5] ?(default: 1): 3
You Selected mirror:[3 : https://github.moeyy.xyz]
Adding more buckets...(It may take a while, please be patient!)
direct (Proxy by other URLs): https://github.moeyy.xyz/https://github.com/lzwme/scoop-proxy-cn
Checking repo... OK
The spc bucket was added successfully.

```

## 提高可用性的措施👺spc bucket

- 为大型仓库spc提供多个镜像加速bucket

- 例如为`spc`这个大型仓库提供更多的冗余bucket(镜像加速)

  - ```bash
    
    scoop bucket add spc https://github.moeyy.xyz/https://github.com/lzwme/scoop-proxy-cn
    scoop bucket add spc1 https://ghproxy.cc/https://github.com/lzwme/scoop-proxy-cn 
    scoop bucket add spc2 https://ghproxy.net/https://github.com/lzwme/scoop-proxy-cn
    scoop bucket add spc3 'https://mirror.ghproxy.com/https://github.com/lzwme/scoop-proxy-cn'
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