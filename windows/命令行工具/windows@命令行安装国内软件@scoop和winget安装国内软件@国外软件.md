[toc]

## abstract

- 本文介绍scoop安装国内软件的推荐方式和用例

### 前提要求

- 为了获取更好的scoop使用体验,请部署scoop for Chinese User,网络上有一键部署加速的版本
  - [国内用户快速部署Scoop@一键加速安装scoop@Deploy-ScoopForCNUser_scoop 安装-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/141385998)

## scoop 安装国内软件

- scoop 安装命令行软件一般很方便,尤其是英文名的软件
- scoop同样可以安装很多国内的软件,但是需要一些技巧来获得更好的效果
- 本文介绍了一些安装案例,以及可能遇到的错误

### 搜索软件scoop search

- ```powershell
  PS> scoop search -h
  Usage: scoop search <query>
  
  Searches for apps that are available to install.
  
  If used with [query], shows app names that match the query.
    - With 'use_sqlite_cache' enabled, [query] is partially matched against app names, binaries, and shortcuts.
    - Without 'use_sqlite_cache', [query] can be a regular expression to match against app names and binaries.
  Without [query], shows all the available apps.
  ```

- 说明scoop search 支持正则表达式匹配软件,对于国内软件很有用

  - 例如我希望下载百度网盘,我们推测其名字为`baidu...disk`,那么可以尝试`baidu.*disk`来搜

  - ```powershell
    PS> scoop search baidu.*disk
    Results from local buckets...
    
    Name             Version  Source      Binaries
    ----             -------  ------      --------
    BaiduNetdisk     7.44.5.2 aki
    baidunetdisk     7.36.0.3 echo
    BaiduNetdisk     7.44.5.2 scoop-zapps
    baidudisk        7.33.0.7 scoopcn
    baidunetdisk     7.44.5.2 scoopet
    baidu-net-disk   7.0.13.2 spc
    baidudisk        7.33.0.7 spc
    baidunetdisk-cvp 7.2.8.9  spc
    BaiduNetdisk     7.44.5.2 spc
    ```

- 但是实际上为了避免错过,我更推荐更简洁的关键词,直接搜`baidu`

### scoop-search

- 除了自带的`scoop search`命令可以搜索软件,还可以使用`scoop-search`这个第三方工具来加速(这是一个可以通过`scoop install scoop-search`来安装的高性能搜索软件)

- 后者比较时候少量关键词来搜,并且速度很快,例如:

  ```bash
  PS> scoop-search baidu
  'aki' bucket:
      BaiduNetdisk (7.44.5.2)
  
  'echo' bucket:
      baidunetdisk (7.36.0.3)
  
  'lemon' bucket:
      baidupcs-go (3.9.5)
  
  'scoop-zapps' bucket:
      BaiduNetdisk (7.44.5.2)
  
  'scoopcn' bucket:
      baidudisk (7.33.0.7)
  
  'scoopet' bucket:
      baidunetdisk (7.44.5.2)
  
  'spc' bucket:
      BaiduNetdisk (7.44.5.2)
      baidu-net-disk (7.0.13.2)
      baidudisk (7.33.0.7)
      baidunetdisk-cvp (7.2.8.9)
      baidupanfilestransfers (2.8.0)
      baidupcs-go (3.9.5)
      potplayer-ext-translate-baidu (0.2022.07.29)
  ```

当然,我们可以结合文本过滤软件来筛选结果

- ```
  PS> scoop-search baidu|sls disk
  
      BaiduNetdisk (7.44.5.2)
      baidunetdisk (7.36.0.3)
      BaiduNetdisk (7.44.5.2)
      baidudisk (7.33.0.7)
      baidunetdisk (7.44.5.2)
      BaiduNetdisk (7.44.5.2)
      baidu-net-disk (7.0.13.2)
      baidudisk (7.33.0.7)
      baidunetdisk-cvp (7.2.8.9)
  ```

- 如你所见,我们筛选出来所有bucket关于百度...的网盘最新可用版本,从这个列表中选择最新的版本,并且记住它的名字然后安装即可

- 甚至可以分组去重整理:

  ```powershell
  PS> scoop-search baidu|sls disk|group |select Name
  
  Name
  ----
      baidu-net-disk (7.0.13.2)
      baidudisk (7.33.0.7)
      baidunetdisk (7.36.0.3)
      BaiduNetdisk (7.44.5.2)
      baidunetdisk-cvp (7.2.8.9)
  ```

  

## scoop安装软件的多版本(新旧共存)👺

- 获取软件的最新版本可以通过浏览器搜索软件官网获取版本号
- 也可以借助winget获取(一般来说可以获取最新版,但是也不保证,甚至有些软件官网更新不及时也不一定是最新版)

### 借助winget辅助查询软件版本

scoop的软件版本可能是滞后的,但是也可以借助scoop安装旧版本软件

另一个问题scoop主要支持软件的英文名称,有些国内软件(中文名)我们不方便直接用scoop搜,即便scoop上存在相应的软件

这种情况下我们可以借助winget来用中文搜索(winget的使用:建议用国内源来替换默认原提高搜索速度,详情另见它文),以便获取软件的更多信息,有时会给出包名

比如夸克网盘这个软件,我们可以看到winget给出两条信息,其中有一条给出了包名:`Alibaba.QuarkCloudDrive`及其版本(供我们参考当前较新版本的情况)

```powershell
PS> winget search 夸克网盘
Name     Id                      Version Source
-------------------------------------------------
夸克网盘 XPDC09VHV21246          Unknown msstore
夸克网盘 Alibaba.QuarkCloudDrive 3.9.1   winget

```

我们也可以利用winget获取更详细信息

```powershell
PS> winget show Alibaba.QuarkCloudDrive
Found 夸克网盘 [Alibaba.QuarkCloudDrive]
Version: 3.9.1
Publisher: Quark
Publisher Url: https://www.myquark.cn/
Author: 广州市动景计算机科技有限公司
Description: 夸克网盘是夸克推出的一款云服务产品,功能包括云存储、高清看剧、文件在线解压、PDF 一键转换等。
License: 专有软件
Privacy Url: https://terms.alicdn.com/legal-agreement/terms/suit_bu1_uc/suit_bu1_uc202002251416_20839.html
Copyright: Copyright © 2024 Quark
Release Notes:
  持续优化网盘端内体验
  1. 优化网盘内搜索分享链接体验:搜索框搜索夸克网盘分享链接,支持一键快速保存
  2. 提供更便捷的文件预览和管理体验:支持鼠标悬停预览视频播放进度,并增加文件打开(Enter)/重命名(F2)和调起搜索框(Ctrl/Cmd+F)的快捷键
  3. 欢迎大家后续继续提建议,如果遇到体验问题,可以通过夸克网盘-设置-客服咨询反馈,或者联系: 400-109-8622
Tags:
  上传
  下载
  云
  云盘
  共享
  分享
  同步
  备份
  文件
  网盘
Installer:
  Installer Type: inno
  Installer Url: https://pdds.quark.cn/download/stfile/ggmkinhjkghkgioie/QuarkCloudDrive_v3.9.1_release_(Build1888502-20240820181133).exe
  Installer SHA256: 446adda45d7c8073daf8e1b0bb66ea3ec4690f10823ab0532eac2a6739c015fc
  Release Date: 2024-08-21
  Offline Distribution Supported: true
```



## 用scoop安装常用软件

### 安装sudo命令

```
PS C:\Users\cxxu> scoop search sudo
Results from local buckets...

Name    Version      Source Binaries
----    -------      ------ --------
gsudo   2.5.1        main
psutils 0.2023.06.28 main   sudo.ps1
sudo    0.2020.01.26 main
nsudo   8.2          extras
```

使用默认方式安装（国内用户比较慢，不推荐）

使用加速方案的话需要根据你采用的加速方案中指出的使用方法才能确定用法

例如某个方案添加了`scoop-cn`这个buket,那么你安装软件时,就在软件名称或id前加上`scoop-cn/`,有的方案是别的buket名来加速,比如`spc`

```
scoop install scoop-cn/gsudo
```

### 安装国内软件示例

#### 百度网盘

可以利用winget获取国内软件的英文名(可能藏在id中)

```bash
PS> winget search 百度网盘
Name        Id                   Version Match         Source
--------------------------------------------------------------
百度网盘    XP9CXM3N2B06J1       Unknown               msstore
百度网盘UWP 9NBLGGH4VB0D         Unknown               msstore
百度网盘    Baidu.BaiduNetdisk   7.44.5                winget
BaiduPCS-Go qjfoidnh.BaiduPCS-Go 3.9.5   Tag: 百度网盘 winget

```

参考名字为`BaiduNetdisk`

或者我们直接用模糊搜索,百度产品:baidu*

```powershell
PS> scoop search baidu
Results from local buckets...

Name                          Version      Source      Binaries
----                          -------      ------      --------
BaiduNetdisk                  7.44.5.2     aki
baidunetdisk                  7.36.0.3     echo
baidupcs-go                   3.9.5        lemon
BaiduNetdisk                  7.44.5.2     scoop-zapps
baidudisk                     7.33.0.7     scoopcn
baidunetdisk                  7.44.5.2     scoopet
baidu-net-disk                7.0.13.2     spc
baidudisk                     7.33.0.7     spc
baidunetdisk-cvp              7.2.8.9      spc
BaiduNetdisk                  7.44.5.2     spc
baidupanfilestransfers        2.8.0        spc
baidupcs-go                   3.9.5        spc
potplayer-ext-translate-baidu 0.2022.07.29 spc

```



#### 夸克网盘

- 例如安装夸克网盘(英文名获取参考winget获取中文软件信息一节)

  ```powershell
  PS☀️[BAT:76%][MEM:28.63% (9.08/31.71)GB][21:39:01]
  #⚡️[cxxu@CXXUCOLORFUL][192.168.1.178][C:\repos\scripts]{Git:main}
  PS> scoop search quark*
  Results from local buckets...
  
  Name              Version Source       Binaries
  ----              ------- ------       --------
  quarkus-cli       3.13.3  main
  quarto            1.4.554 Extras_gitee
  quarto            1.5.56  ExtrasCxxu
  quarkus-cli       3.11.1  main_gitee
  quarkus-cli       3.13.3  scoop-cn
  quarto            1.5.56  scoop-cn
  quardcrt          0.4.8   spc
  quark-cloud-drive 2.5.43  spc
  quarkpan          3.9.1   spc
  quarkus-cli       3.13.3  spc
  quarto-prerelease 1.6.6   spc
  quarto            1.5.56  spc
  
  
  PS☀️[BAT:76%][MEM:28.77% (9.12/31.71)GB][21:39:11]
  #⚡️[cxxu@CXXUCOLORFUL][192.168.1.178][C:\repos\scripts]{Git:main}
  PS> scoop info quarkpan
  
  Name         : quarkpan
  Description  : 夸克网盘
  Version      : 3.9.1
  Bucket       : spc
  Website      : https://pan.quark.cn
  License      : Proprietary
  Dependencies : aki/innounpacker
  Updated at   : 2024/8/22 9:42:43
  Updated by   : github-actions[lzw.me]
  Shortcuts    : QuarkCloudDrive
  
  
  PS☀️[BAT:76%][MEM:28.66% (9.09/31.71)GB][21:39:38]
  #⚡️[cxxu@CXXUCOLORFUL][192.168.1.178][C:\repos\scripts]{Git:main}
  PS> scoop info quark-cloud-drive
  
  Name        : quark-cloud-drive
  Description : 夸克网盘 电脑高效拍档 一键存爽快看
  Version     : 2.5.43
  Bucket      : spc
  Website     : https://pan.quark.cn
  License     : Proprietary
  Updated at  : 2023/8/4 9:38:49
  Updated by  : github-actions[bot]
  Shortcuts   : 夸克网盘
  ```

  通过比较版本号和更新日期,我们可以认为名为`quarkpan`的包是更新的包,而`quark-cloud-drive`是陈旧而过时的包

  安装过程中报了个warning,提示我们要先添加`aki`这个bucket,参考这里添加:点击[scoop-installer](https://gitee.com/scoop-installer#122-其他优秀的镜像库)，有选择性地添加

  ```
  WARN  Bucket 'aki' not added. Add it with 'scoop bucket add aki <repo>'.
  Couldn't find manifest for 'innounpacker' from 'aki' bucket.
  ```

例如`scoop bucket add aki https://gitee.com/scoop-installer/aki-apps`

但是scoop的bucket中的软件包部分安装脚本和安装程序的版本是不匹配的，因此可能无法正确安装

#### 有道词典/有道翻译

```powershell
PS> scoop-search youdao
'aki' bucket:
    yddict (10.0.3.0) --> includes 'YoudaoDict.exe'

'cluttered' bucket:
    UAC.YoudaoDict.Pure (8.9.2)

'spc' bucket:
    UAC.YoudaoDict.Pure (8.9.2)
    YoudaoDict-portable (10.0.0.0)
    yddict (10.0.3.0) --> includes 'YoudaoDict.exe'
    youdaodict (10.2.9.0)

#用winget search 看看什么情况:

PS🌙[BAT:74%][MEM:31.45% (9.97/31.71)GB][16:07:12]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\exes\Edge\Edge113\App]
PS> winget search 有道
Name         Id                      Version  Match     Source
---------------------------------------------------------------
有道云笔记   XP9L2KBG1SBXDK          Unknown            msstore
比译         Biyi.Biyi               0.5.0+18 Tag: 有道 winget
有道云笔记   NetEase.YoudaoNote      8.0.30             winget
有道小班课   NetEase.YoudaoPokeClass 2.14.2             winget
网易有道翻译 Youdao.YoudaoTranslate  10.2.9.0           winget
```

根据这个搜索结果,我推测有道词典(桌面端)应用应该发生名名称上的变换,可能改为了有道翻译

可以检查版本信息及其更新时间

```powershell
PS> scoop info youdaodict

Name        : youdaodict
Description : Youdao Dictionary has typical acoustic translation, smart screen word i
              dentification, real-time synchronization with network up-to-date vocabu
              lary, and other word look-up features.
Version     : 10.2.9.0
Bucket      : spc
Website     : https://cidian.youdao.com
License     : Proprietary
Updated at  : 2024/6/18 9:36:20
Updated by  : github-actions[lzw.me]
Installed   : 10.2.9.0 *global*
Binaries    : YoudaoDict.exe
Shortcuts   : Youdao\Youdao Dict
```

#### qq

```bash
PS> scoop-search qq
'scoop-cn' bucket:
    qq (9.7.23.240423)

'spc' bucket:
    TencentQQNT (9.9.15.240808)
    UAC.QQ_Portable (9.3.7.27301)
    WXQQ_RevokeMsgPatcher (1.8)
    qq (9.7.23.240423)
    qq-dreamcast (9.4.0.27525)
    qq-nt (9.9.11_240606_01)
    qq-patch (0.2021.04.30)
    qqgame (5.59.58195.0_1010000018)
    qqlite (7.9.14314)
    qqlite-patch (0.2021.04.30)
    qqlive (11.101.1526.0)
    qqlive-cvp (11.18.8103)
    qqmusic (1933)
    qqmusic-cvp (18.06)
    qqnt (9.9.15.240826)
    qqplayer (4.6.3.1104)
    wx_qq_revokeMsgPatcher (1.8)
# 我们可能只对其中的新架构nt版本感兴趣,那么进一步过滤

PS> scoop-search qq|sls nt

    TencentQQNT (9.9.15.240808)
    qq-nt (9.9.11_240606_01)
    qqnt (9.9.15.240826)
```

- 可以看到,我们可以通过`TencentQQNT`或者`qqnt`,`qq-nt`来安装nt版本的qq

- 但是进一步观察版本号,一般我们选择最新版,上面的例子是`qqnt (9.9.15.240826)`

- 可以进一步查看版本信息

  - ```bash
    PS> scoop info qqnt
    
    Name        : qqnt
    Description : An instant messaging software service developed by Tencent
    Version     : 9.9.15.240826
    Bucket      : spc
    Website     : https://im.qq.com/pcqq/index.shtml
    License     : Freeware
    Updated at  : 2024/8/27 9:42:53
    Updated by  : github-actions[lzw.me]
    Shortcuts   : QQ
    ```

  - 我执行此查询时是`2024/8/29`可以看到这个版本确实非常新(更新于2天前)

我们尝试安装

```powershell
PS🌙[BAT:100%][MEM:35.35% (2.77/7.85)GB][16:48:35]
# [cxxu@CXXUREDMIBOOK][<以:192.168.1.198>][~]
PS> scoop install -g qqnt
WARN  Scoop uses 'aria2c' for multi-connection downloads.
WARN  Should it cause issues, run 'scoop config aria2-enabled false' to disable it.
WARN  To disable this warning, run 'scoop config aria2-warning-enabled false'.
Installing 'qqnt' (9.9.15.240826) [64bit] from 'spc' bucket
direct: https://dldir1.qq.com/qqfile/qq/QQNT/Windows/QQ_9.9.15_240826_x64_01.exe#/dl.7z
Starting download with aria2 ...
Download: [#03bf7d 145MiB/187MiB(77%) CN:5 DL:11MiB ETA:3Download: [#03bf7d 157MiB/187Download: Download Results:
Download: gid   |stat|avg speed  |path/URI
Download: ======+====+===========+=======================================================
Download: 03bf7d|OK  |    10MiB/s|C:/Users/cxxu/scoop/cache/qqnt#9.9.15.240826#f67d069.7z
Download: Status Legend:
Download: (OK):download completed.
Checking hash of QQ_9.9.15_240826_x64_01.exe ... ok.
Extracting QQ_9.9.15_240826_x64_01.exe ... done.
Linking C:\ProgramData\scoop\apps\qqnt\current => C:\ProgramData\scoop\apps\qqnt\9.9.15.240826
Creating shortcut for QQ (QQ.exe)
'qqnt' (9.9.15.240826) was installed successfully!
```

- 发现确实可以安装

### 安装everything快速搜索工具

- 首先查找软件名`everything`

  ```powershell
  #⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\exes]
  PS> scoop-search everything
  'Extras_gitee' bucket:
      everything (1.4.1.1024)
      everything-lite (1.4.1.1024)
  
  'aki' bucket:
      everything (1.4.1.1026)
      pseverything (3.3.0)
  
  'cluttered' bucket:
      UAC.EverythingToolbar (0.6.1)
  
  'lemon' bucket:
      ibeverythingext (0.5)
  
  'main' bucket:
      everything-cli (1.1.0.27)
  'scoop-zapps' bucket:
      EverythingToolbar (1.3.4)
  
  'spc' bucket:
      EverythingToolbar (1.3.4)
      UAC.EverythingToolbar (0.6.1)
      everything (1.4.1.1026)
      everything-alpha (1.5.0.1383a)
      everything-beta (1.4.1.1025)
      everything-beta-np (1.4.1.1025)
      everything-cli (1.1.0.27)
      everything-lite (1.4.1.1026)
      everything-np (1.4.1.1026)
      everything-powertoys (0.82.1)
      everything-toolbar (1.3.4)
      pseverything (3.3.0)
  ```

  ```powershell
  PS> scoop install everything-cli -g
  WARN  Purging previous failed installation of everything-cli.
  Removing older version (1.1.0.27).
  Installing 'everything-cli' (1.1.0.27) [64bit] from 'main' bucket
  proxy: https://www.voidtools.com/ES-1.1.0.27.x64.zip
  ES-1.1.0.27.x64.zip (92.7 KB) [=============================================] 100%
  Checking hash of ES-1.1.0.27.x64.zip ... ok.
  Extracting ES-1.1.0.27.x64.zip ... done.
  Running pre_install script...done.
  Linking C:\ProgramData\scoop\apps\everything-cli\current => C:\ProgramData\scoop\apps\everything-cli\1.1.0.27
  Creating shim for 'es'.
  Persisting es.ini
  'everything-cli' (1.1.0.27) was installed successfully!
  ```

  

- 查看官网,[Everything 命令行接口 - voidtools](https://www.voidtools.com/zh-cn/downloads/#cli)

  - 可以发现,everything除了主体软件本身,还提供了命令行接口(命令行程序),并且是独立于everything提供的,这个命令行接口程序名为`es`,它依赖于`everything`主体程序,仅提供了命令行的方式来使用everything罢了

- 这里需要用户有点经验,就是能够认识`cli`表示命令行的意思(commandline,管理缩写CLI,与之对应于GUI)

- 安装`everything-cli`后,调用的名字是`es`（安装过程中输出的日志表明了这一点)

- 而且`es`组件本身很小,如果使用aria2分片下载可能会出错

### 文件校验不通过👺

```
Usage: scoop install <app> [options]

Options:
  -g, --global                    Install the app globally
  -i, --independent               Don't install dependencies automatically
  -k, --no-cache                  Don't use the download cache
  -s, --skip-hash-check           Skip hash validation (use with caution!)
  -u, --no-update-scoop           Don't update Scoop before installing if it's outdated
  -a, --arch <32bit|64bit|arm64>  Use the specified architecture, if the app supports it

```



```powershell
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\exes\Edge\Edge113\App]
PS> scoop install -g youdaodict
WARN  Scoop uses 'aria2c' for multi-connection downloads.
WARN  Should it cause issues, run 'scoop config aria2-enabled false' to disable it.
WARN  To disable this warning, run 'scoop config aria2-warning-enabled false'.
Installing 'youdaodict' (10.2.9.0) [64bit] from 'spc' bucket
direct: http://cidian.youdao.com/download/YoudaoDict.exe#/dl.7z
Starting download with aria2 ...
Download: Download Results:
Download: gid   |stat|avg speed  |path/URI
Download: ======+====+===========+=======================================================
Download: 0c67d7|OK  |    69MiB/s|C:/Users/cxxu/scoop/cache/youdaodict#10.2.9.0#15f4922.7z
Download: Status Legend:
Download: (OK):download completed.
#检验hash的时候失败,如果你不关心风险,可以考虑用-s选项来跳过校验,或者清空缓存在试
Checking hash of YoudaoDict.exe ... ERROR Hash check failed!
App:         spc/youdaodict
URL:         http://cidian.youdao.com/download/YoudaoDict.exe#/dl.7z
First bytes: 4D 5A 90 00 03 00 00 00
Expected:    a1801946e300ec6dfe8b8558cdf4a1e00761647fb399dc7e1146ebf08045c082
Actual:      b2c9a3827bfef6866822432d84fed36a972ab7b2eae6ae9be561bd30c641c8e0

Please try again or create a new issue by using the following link and paste your console output:
https://github.moeyy.xyz/https://github.com/lzwme/scoop-proxy-cn/issues/new?title=youdaodict%4010.2.9.0%3a+hash+check+failed
```



### scoop安装软件过程中报错👺

部分软件在安装过程中会报错(可能是安装脚本和软件版本不匹配导致的)

许多GUI软件或者国内软件用scoop安装可能会报错,例如

```powershell
Running pre_install script...Move-Item:
Line |
   3 |  Move-Item -Force -Path "$dir\{code_GetDestDir}\*" -Destination "$dir"
     |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Cannot find path 'C:\ProgramData\scoop\apps\quarkpan\3.9.1\{code_GetDestDir}' because it does not exist.
Remove-Item:
Line |
   4 |  Remove-Item -Force -Recurse -Path "$dir\{code_GetDestDir}"
     |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Cannot find path 'C:\ProgramData\scoop\apps\quarkpan\3.9.1\{code_GetDestDir}' because it does not exist.
Remove-Item:
Line |
   6 |  Remove-Item -Force -Recurse -Path "$dir\{autocf64}"
     |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Cannot find path 'C:\ProgramData\scoop\apps\quarkpan\3.9.1\{autocf64}' because it does not exist.
Remove-Item:
Line |
   8 |  Remove-Item -Force -Recurse -Path "$dir\{usercf}"
     |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Cannot find path 'C:\ProgramData\scoop\apps\quarkpan\3.9.1\{usercf}' because it does not exist.
done.
Linking C:\ProgramData\scoop\apps\quarkpan\current => C:\ProgramData\scoop\apps\quarkpan\3.9.1
Creating shortcut for QuarkCloudDrive (QuarkCloudDrive.exe) failed: Couldn't find C:\ProgramData\scoop\apps\quarkpan\current\QuarkCloudDrive.exe
```

这种情况下安装包是下载好了的,我们可以找到这个包(处于scoop家目录的缓存目录),然后手动安装这个安装包!

进入缓存目录,然后找到对应的安装包,手动安装即可

```powershell
cd ~/scoop/cache;
explorer .
```



### scoop安装软件的脚本

- 有时安装报错是应为脚本问题,可能和软件版本不兼容或者适配不完善
- 软件如果安装失败,其对应的脚本文件一般位于`scoop`目录下的`apps\<appName>\version`例如:`C:\Users\cxxu\scoop\apps\quarkpan\3.9.1\install...`
- 安装成功的情况下目录结构会有所不同

### 查看下载到本地的包

- 一般scoop会把下载好的包放到scoop家目录的`cache`目录
- 经过试验,即便是使用了`-g`选项选择全局安装,也会将包下载缓存到当前用户的家目录中,例如`C:\Users\cxxu\scoop\cache\quarkpan#3.9.1#a03a1cc.exe`是之前下载的包