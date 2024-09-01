[toc]

## alist官网

### alist网站风格说明

- 官网的各个页面大多是以目录列表的形式作为一级界面
- 点击列表中的各个条目打开详情(一个问题是一般的可点击条目(文字)有下划线,或者显示蓝色字体,而alist官网就不按惯例来,需要将鼠标悬停在目录列表上才显示为可点击链接的风格,阅读的时候要注意一下)
- 事实上[手动安装 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/install/manual.html)包含了初次使用,配置,更新,以及加载的基本问题的解释;而从标题上看似乎仅仅介绍如何安装,没想到还包含了开机自启的配置的方法
- 鉴于此,本文对alist的基本使用稍作整理

### alist软件版本

- 对于windows,分为免费的命令行版本和收费的图形界面版本
- 通常使用命令行版本就够用了,稍微懂命令行就可以操作,基础配置算简单
- [安装 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/install/)

## 安装和启动使用必看文档👺

- [手动安装 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/install/manual.html)
  - 介绍不同平台的安装和启动的方法

- [为什么 | AList文档 (nn.ci)](https://alist.nn.ci/zh/faq/why.html)
  - 列出了alist使用常见的问题,包括预览和打包下载等问题

- 其他安装方式

  - windows上可以使用scoop安装(推荐用scoop For CN)来安装,对国内用户友好

    - ```cmd
      scoop install alist #可能需要添加额外 bucket,比如spc
      ```

    - ```
      PS> scoop-search alist #截止2024.8.30
      'main' bucket:
          alist (3.36.0)
      
      'spc' bucket:
          alist (3.36.0)
          alisthelper (0.1.5)
          alisthelper-portable (0.1.5)
          
      PS C:\Users\Administrator> scoop install alist -g
      WARN  Scoop uses 'aria2c' for multi-connection downloads.
      WARN  Should it cause issues, run 'scoop config aria2-enabled false' to disable it.
      WARN  To disable this warning, run 'scoop config aria2-warning-enabled false'.
      Installing 'alist' (3.36.0) [64bit] from 'main' bucket
      proxy: https://github.com/alist-org/alist/releases/download/v3.36.0/alist-windows-amd64.zip
      Starting download with aria2 ...
      Download: Download Results:
      Download: gid   |stat|avg speed  |path/URI
      Download: ======+====+===========+=======================================================
      Download: d33312|OK  |   1.0MiB/s|C:/Users/Administrator/scoop/cache/alist#3.36.0#4a40e72.zip
      Download: Status Legend:
      Download: (OK):download completed.
      Checking hash of alist-windows-amd64.zip ... ok.
      Extracting alist-windows-amd64.zip ... done.
      Linking C:\ProgramData\scoop\apps\alist\current => C:\ProgramData\scoop\apps\alist\3.36.0
      Creating shim for 'alist'.
      Persisting data
      Persisting log
      'alist' (3.36.0) was installed successfully!
      PS C:\Users\Administrator> alist ^C
      PS C:\Users\Administrator> cd alis^C
      PS C:\Users\Administrator> cd C:\exes\
      PS C:\exes> cd ..
      PS C:\> init
      08/30/2024 11:03:36
      Init time: 1.6031589 s
      ```

      

    - 这种情况下会安装到scoop统一目录下,你可以考虑在你喜欢的位置用符号链接创建一个alist.exe,链接到scoop/apps/alist/current/alist

      ```powershell
      mkdir C:\exes\alist -ErrorAction SilentlyContinue
      New-Item -ItemType SymbolicLink -Path C:\exes\alist\alist.exe -Target C:\ProgramData\scoop\apps\alist\current\alist.exe
      
      ```

      


### 推荐操作和基础配置

- 为可执行程序`alist.exe`配置Path变量或者取别名
- 执行`alist server`初始化
- 根据需要可以修改密码:`alist admin set <new_password>` 其中`admin`可以替换为其别名`password`

  - 重置密码示例(设置admin用户的密码为1)

    ```cmd
    PS> alist password set 1
    INFO[2024-08-30 11:10:16] reading config file: data\config.json
    INFO[2024-08-30 11:10:17] config file not exists, creating default config file
    INFO[2024-08-30 11:10:17] load config from env with prefix: ALIST_
    INFO[2024-08-30 11:10:17] init logrus...
    INFO[2024-08-30 11:10:17] Successfully created the admin user and the initial password
     is: Fryz2uxq
    INFO[2024-08-30 11:10:17] admin user has been updated:
    INFO[2024-08-30 11:10:17] username: admin
    INFO[2024-08-30 11:10:17] password: 1
    WARN[2024-08-30 11:10:17] [del_user_cache_online] failed: Post "http://localhost:5244/
    api/admin/user/del_cache?username=admin": dial tcp [::1]:5244: connectex: No connectio
    n could be made because the target machine actively refused it.
    ```
- alist会默认在5244端口启动服务

### alist 命令自动补全设置

精心制作的命令行工具会为不同的现代化shell设计自动补全支持,如果您经常使用alist命令行进行配置操作,那么推荐使用`alist completion`提供的命令行自动补全和提示特性(如果只是偶尔配置一下则是不必要使用这个特性)

```powershell
PS> alist completion powershell -h
Generate the autocompletion script for powershell.

To load completions in your current shell session:

        alist completion powershell | Out-String | Invoke-Expression

To load completions for every new session, add the output of the above command
to your powershell profile.

Usage:
  alist completion powershell [flags]

Flags:
  -h, --help              help for powershell
      --no-descriptions   disable completion descriptions

Global Flags:
      --data string     data folder (default "data")
      --debug           start with debug mode
      --dev             start with dev mode
      --force-bin-dir   Force to use the directory where the binary file is located as data directory
      --log-std         Force to log to std
      --no-prefix       disable env prefix
```

例如windows用户使用powershell可以这么做

```powershell
alist completion powershell |Out-String|iex
```

补全和命令选项实时提示效果举例:

```powershell
PS> alist server --data
--data           --dev            --help           --no-prefix
--debug          --force-bin-dir  --log-std        -h

data folder
```

```powershell
PS> alist password random
random  set     token

Reset admin user's password to a random string

```



### 启动alist服务

```bash
PS> alist server
INFO[2024-08-30 11:27:54] reading config file: data\config.json
INFO[2024-08-30 11:27:54] load config from env with prefix: ALIST_
INFO[2024-08-30 11:27:54] init logrus...
WARN[2024-08-30 11:27:54] init tool aria2 failed: failed get aria2 version: Post "http
://localhost:6800/jsonrpc": dial tcp [::1]:6800: connectex: No connection could be mad
e because the target machine actively refused it.
INFO[2024-08-30 11:27:54] init tool SimpleHttp success: ok
WARN[2024-08-30 11:27:54] init tool qBittorrent failed: Post "http://localhost:8080/ap
i/v2/auth/login": dial tcp [::1]:8080: connectex: No connection could be made because
the target machine actively refused it.
INFO[2024-08-30 11:27:54] init tool pikpak success: ok
INFO[2024-08-30 11:27:54] start HTTP server @ 0.0.0.0:5244
...
```

- 遇到两个warn不用管,他们是和离线下载有关的配置分别是aria2,qbittorrent下载器的下载服务配置,不是所有用户都用得到

### 验证alist服务是否可用

- 根据提示,在浏览器中打开`http://localhost:5244`(对于alist服务器自己)
- 如果你在局域网内使用,我们也可以在其他同局域网的设备的浏览器中输入`http://<serverIp>:5244`来访问alist创建的网页服务(其中`<serverIP>`替换为alist服务器的ip地址),例如链接可能形如`http://192.168.1.6:5244/`

## Alist生态

- [Ecosystem | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/ecosystem.html#community)

### alist for android版本

- [Releases (github.com)](https://github.com/jing332/AListFlutter/releases)
  - FAQ:
    - 如果您发现android端服务启动后,android设备自己可以访问挂载列表网页,但是其他同局域网内的设备却访问不了,这可能是手机上的代理软件干扰导致的
    - 另外,不恰当的修改配置文件,也可能导致其他设备无法访问服务端,手机端一般没有这个问题

  - 加速下载:[下载速度慢？教你如何高速下载 github release！ ](https://zhuanlan.zhihu.com/p/521472595)


### 启动alist网页

- 浏览器中输入:`http:\\localhost:5244`
- 登录刚才命令行给出的用户和账号(账号名`admin`,密码默认是随机密码,可以自行指定)
- 启动配置页面,点击管理(manage),进入配置页面
- 添加存储(storage)

## 挂载云盘或本地存储

- alist可以不仅可以挂载网盘,还可以挂载本地存储

### 本地存储挂载和分享👺

- [本地存储 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/drivers/local.html)
- 挂载本地存储可以方便分享文件给其他人,特别是局域网内的人,在Alist管理页面中,创建一个shareUser用户,分发给需要共享的人或者自己使用,类似于windows下的共享文件夹或SMB服务
- 被共享者(也可以是自己)可以用浏览器也可以用文件资源管理器挂载或着映射成驱动器来访问您共享的文件或者目录,也能够可控制被分享者对相关目录或文件的读写权限)
- [WebDAV | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/webdav.html)

### 挂载式共享方案选择

- 对于windows,挂载为网络磁盘到资源管理器这一目的来说,使用共享文件夹会是更稳定的选择,即使alist也可以提供webdav挂载
- 而通过网页访问的话,就不是共享文件夹可以比的,这种场景alist体验还可以,虽然打包下载没有那么友好,不过有其他类似的webdav软件比如chfs可以通过网页端下载文件夹(打包下载)

### 案例:挂载阿里云盘open

- [阿里云盘 Open | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/drivers/aliyundrive_open.html#刷新令牌)

### 获取阿里云令牌

- [Get Aliyundrive Refresh Token ](https://alist.nn.ci/tool/aliyundrive/request.html)
  - 登录阿里云盘账号,点击授权,可以获得令牌
  - 或者用手机扫码,授权获取令牌



### 主页检查挂载情况

- 本地alist服务器的主页为:http://localhost:5244/
  - 也可以点击配置页面的home(主页)跳转到挂载列表

## 常用页面

### 以配置挂载列表

- [Home | AList](http://localhost:5244/)

### 管理配置页面

- [Profile | AList Manage](http://localhost:5244/@manage)

## 配置文件和alist工作目录👺👺

- 在命令行中,运行`alist server`会检查当前**工作目录**(由`pwd`命令返回的目录)是否存在配置文件(用户密码,已挂载过的网盘等)
- 如果没有,则会在当前工作目录创建`data`目录并初始化创建必要的文件
- 如果每次都在不同的目录上启动alist,会导致数据无法自动恢复,即每次需要登录alist都无法保持上一次的配置
- 如果是通过创建快捷方式,通过快捷方式的方式启动,则可以确保每次alist家目录是一致的
- 如果要在某个脚本中使用alist,建议使用`cd <alist_home>`,使得工作目录定位到alist家目录,然后根据需要可以返回或跳转到其他目录

## 预览设置

- [预览设置 | AList文档 (nn.ci)](https://alist.nn.ci/zh/config/preview.html#iframe-预览)

## FAQ

- 官方文档整理了一份常见问题,值得看:
  - [为什么 | AList文档 (nn.ci)](https://alist.nn.ci/zh/faq/why.html)

### 可能遇到的错误

- `failed get objs: failed to list objs: InvalidParameter.ParentFileId:The input parameter parent_file_id is not valid. for cpp path domain parent_file_id is required`

- 路径问题,考虑删除旧配置重新添加

### 检查服务重启前后alist的动作(自动挂载)

- 初次配置启动服务

  ```bash
  PS C:\Users\cxxu\Desktop> alist server
  INFO[2024-01-13 20:02:54] reading config file: data\config.json
  INFO[2024-01-13 20:02:54] load config from env with prefix: ALIST_
  INFO[2024-01-13 20:02:54] init logrus...
  WARN[2024-01-13 20:02:54] init tool aria2 failed: failed get aria2 version: Post "http://localhost:6800/jsonrpc": dial tcp [::1]:6800: connectex: No connection could be made because the target machine actively refused it.
  INFO[2024-01-13 20:02:54] init tool SimpleHttp success: ok
  WARN[2024-01-13 20:02:54] init tool qBittorrent failed: Post "http://localhost:8080/api/v2/auth/login": dial tcp [::1]:8080: connectex: No connection could be made because the target machine actively refused it.
  INFO[2024-01-13 20:02:54] start HTTP server @ 0.0.0.0:5244
  INFO[2024-01-13 20:25:47] Shutdown server...
  INFO[2024-01-13 20:25:47] Server exit
  
  ```

- 成功挂在某个网盘后(以阿里云盘opne)为例,再次启动服务,输出:

  - ```bash
    
    PS C:\Users\cxxu\Desktop> alist server
    INFO[2024-01-13 20:25:52] reading config file: data\config.json
    INFO[2024-01-13 20:25:52] load config from env with prefix: ALIST_
    INFO[2024-01-13 20:25:52] init logrus...
    WARN[2024-01-13 20:25:52] init tool aria2 failed: failed get aria2 version: Post "http://localhost:6800/jsonrpc": dial tcp [::1]:6800: connectex: No connection could be made because the target machine actively refused it.
    INFO[2024-01-13 20:25:52] init tool SimpleHttp success: ok
    WARN[2024-01-13 20:25:52] init tool qBittorrent failed: Post "http://localhost:8080/api/v2/auth/login": dial tcp [::1]:8080: connectex: No connection could be made because the target machine actively refused it.
    INFO[2024-01-13 20:25:52] start HTTP server @ 0.0.0.0:5244
    INFO[2024-01-13 20:25:52] success load storage: [/AliyunDrive], driver: [AliyundriveOpen]
    ```

  - 可以发现,alist可以自动将上次挂载的云盘重新挂载


### alist token问题

- ```bash
  PS 🕰️18:01:06 [C:\share] 🔋100% alist admin set 1212
  INFO[2024-02-10 18:01:13] reading config file: data\config.json
  INFO[2024-02-10 18:01:13] load config from env with prefix: ALIST_
  INFO[2024-02-10 18:01:13] init logrus...
  INFO[2024-02-10 18:01:13] admin user has been updated:
  INFO[2024-02-10 18:01:13] username: admin
  INFO[2024-02-10 18:01:13] password: 12345...
  ERRO[2024-02-10 18:01:13] [del_user_cache_online] error: that's not even a token
  
  ```

- 尝试关闭所有alist进程

  - 用`ps alist*`检查是否有`alist`进程,如果有,则执行`ps alist|stop`,结束相关进程

- 重新设置`admin`密码

  - ```
    PS 🕰️18:01:13 [C:\share] 🔋100% alist admin set 1212
    INFO[2024-02-10 18:02:07] reading config file: data\config.json
    INFO[2024-02-10 18:02:07] load config from env with prefix: ALIST_
    INFO[2024-02-10 18:02:07] init logrus...
    INFO[2024-02-10 18:02:07] admin user has been updated:
    INFO[2024-02-10 18:02:07] username: admin
    INFO[2024-02-10 18:02:07] password: 1212
    WARN[2024-02-10 18:02:07] [del_user_cache_online] failed: Post "http://localhost:5244/api/admin/user/del_cache?username=admin": dial tcp [::1]:5244: connectex: No connection could be made because the target machine actively refused it.
    ```

  - 抛出了一个`WARN`,可以打开浏览器,刷新`alist`管理网页,检查是否修改成功

### webDav链接和配置👺

[WebDAV | AList文档WebDav (nn.ci)](https://alist.nn.ci/zh/guide/webdav.html#webdav-配置)

- [WebDAV | 获取已添加网盘的webdav链接配置 (nn.ci)](https://alist.nn.ci/zh/guide/webdav.html#webdav-配置)
- [WebDAV |挂载填写实例](https://alist.nn.ci/zh/guide/webdav.html#可以用来挂载webdav的软件)

### 其他设备无法访问的问题👺

- 通常保持默认配置不会出现这个问题,但是如果对配置文件做了不当修改,可能导致此类异常

- 以电脑端(windows为例),修改了config.json中的IP地址

  - 配置文件路径

    ```bash
    # [C:\exes\alist\data]
    PS> cat .\config.json
    ```

    ```json
    ...
    "scheme": 
    {
        "address": "0.0.0.0",#修改为127.0.0.1会导致其他设备无法访问
        "http_port": 5244,
        "https_port": -1,
        "force_https": false,
        "cert_file": "",
        "key_file": "",
        "unix_file": "",
        "unix_file_perm": ""
      },
    ...
    ```

### 文件更新不及时或滞后问题

- [阿里云盘更新内容，alist一直不更新 · alist-org/alist · Discussion #2928 · GitHub](https://github.com/alist-org/alist/discussions/2928)
- 例如,你通过alist提供的复制功能,将本地盘文件复制到挂在的某网盘上(比如123网盘),alist提示你操作成功,但是你进入到相应网盘目录检查发现新文件并不在文件列表中,这种情况下你需要通过alist提供的网页上的三个点按钮展开,点击刷新获取新的内容
- 另一种说法是修改alist配置文件中的过期时间为0,但是可能有封号的风险

### 打包下载和批量下载

- alist的打包下载功能依赖于被挂在的网盘是否支持,如果支持,则对于用户来说,流量器上直接批量下载就比较方便
  - 在**为什么**文档中指出,打包下载需要https+cors的支持
    - 有的网盘,比如123网盘,挂在到alist后,可以选中多个文件或文件夹,然后打包下载
  - 而一般将本地磁盘挂在到alist上不能让打包下载正常工作
- 批量下载,不一定要打包下载,如果客户端平台允许,可以下载并运行aria2 启用rpc服务,这样通过批量选中需要下载的东西发送到aria2下载也是可以的,详情另见它文[Aria2@RPC下载@Alist批量下载-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/141233494?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"141233494"%2C"source"%3A"xuchaoxin1375"})

## 开机自动运行配置(守护进程)👺

windows上实现开机后台运行软件或服务的方式有不少,比如存放快捷方式到`startup`目录,注册计划任务,打包成服务等,还有相关的图形界面软件专门设置alist的自启动服务(但是我认为没有必要)

你可以查看alist的运行日志,来检查某次运行或启动是否有异常,日志文件位置由alist的配置文件`data/config.json`中的`log`段指定 [配置文件 | AList文档 (nn.ci)](https://alist.nn.ci/zh/config/configuration.html)

### 一键配置

 windows用户注册alist(cli版)服务计划任务的注册,实现开机自启动
**使用powershell管理员权限运行**

```powershell

function Register-AlistStartup
{
   <# 
   .SYNOPSIS
   windows用户注册alist(cli版)服务计划任务的注册,实现开机自启动
   使用powershell管理员权限运行👺
   
   .DESCRIPTION
   请根据需要修改下面的$FilePath路径中的alist.exe部分，否则不起作用,其余部分可以不改动
   #>
    param(
        $TaskName='StartupAlist',
        $UserId='System',
        $FilePath = ' C:\exes\alist\alist.exe  ',#修改为自己的alist程序 路径👺
        $Directory #alist的起始目录
    )

    if (!$Directory)
    {

        $Directory = Split-Path -Path $FilePath -Parent
    }
    # 输出目录路径

    $action = New-ScheduledTaskAction -Execute $FilePath -Argument 'server' -WorkingDirectory $Directory
    # 定义触发器
    $trigger = New-ScheduledTaskTrigger -AtStartup
    # 任务执行主体设置(以System身份运行,且优先级最高,无论用户是否登陆都运行,适合于后台服务，如aria2，chfs，alist等)
    $principal = New-ScheduledTaskPrincipal -UserId $UserId -LogonType ServiceAccount -RunLevel Highest
    # 这里的-UserId 可以指定创建者;但是注意,任务创建完毕后,不一定能够立即看Author(创建者)字段的信息,需要过一段时间才可以看到,包括taskschd.msc也是一样存在滞后

    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

    # 创建计划任务
    Register-ScheduledTask -TaskName $TaskName -Action $action `
        -Trigger $trigger -Settings $settings -Principal $principal
    
}

#使用方法
## 注册alist计划任务(默认的计划任务名为StartupAlist，启动角色为System,修改为自己当前用户账户也是可以的)

Register-AlistStartup 



```

### 其他相关命令

- 检查计划任务

  ```powershell
  Get-ScheduledTask -TaskName startupalist
  ```

  

- 立刻执行启动alist服务计划任务：

  ```bash
  Start-scheduledTask -TaskName StartupAlist 
  ```

- 立即暂停Alist计划任务

  ```powershell
  Stop-ScheduledTask -TaskName StartupAlist
  ```

- 检查Alist进程是否正在运行

  ```bash
  ps alist*
  ```

  如果返回结果,表明有相关进程在运行

- 移除计划任务

```powershell
Unregister-ScheduledTask -TaskName startupalist # -Confirm:$false #是否免询问移除计划任务
```



### 相关参考

- [守护进程开机自启动 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/install/manual.html#守护进程)
  - 文档可能移除这一部分(过时的开机自启方式)

- [windows配置开机自启动软件或脚本-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/136098694?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"136098694"%2C"source"%3A"xuchaoxin1375"})

## 挂载到资源管理器(模拟本地磁盘分区)👺

- [windows@允许映射挂载http链接@挂载局域网http链接的webdav磁盘-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/137939514)
  - 这涉及注册表修改
- 也可以考虑用第三方软件挂载,例如RailDrive,rclone等

## 用户和权限管理👺

注意,执行以下配置后,不要以管理员账户登录的状态下查看配置效果(一般是通过管理员账户登录并xiu'gai)

可以在另一个浏览器访问测试,或者另一台设备通过浏览器访问测试配置效果,或者退出当前账号,来测试配置效果

### 权限配置

- 在这个页面里配置和管理用户[Users | AList Manage](http://localhost:5244/@manage/users)
- 当您想要利用Alist提供的webdav服务分享文件给别人,或者自己的朋友,那么创建一个专门用来共享文件的用户是一个好主意
- 我们对这个共享出去的用户配置权限,比如只允许他访问某个目录下的文件,更近一步可以限制对该目录下的文件的操作,比如删除和重命名等



### 起始页面(base path)设置

- alist支持对不同访问用户(账号)设置不同的访问权限以及起始的访问页面(bash path)
- 这对于仅分享一个盘或者本地盘的时候尤其合适
