[toc]



## github加速下载辅助函数(powershell)👺

- 在powershell命令行获取加速后的链接(可以获取多个加速链接,提高可用性)
- 使用合适的下载方式下载链接资源

### 公益站

- [GitHub文件加速](https://yishijie.gitlab.io/ziyuan/)
- [【镜像站点搜集】 · Issue #116 · hunshcn/gh-proxy](https://github.com/hunshcn/gh-proxy/issues/116)

### 安装powershell模块

获取github资源的加速链接文件/仓库加速

为了便于用户使用,我将相关功能组织成了一个powershell模块集合,您可以通过gitee来一键部署(仓库很小)

- [PwshModuleByCxxu.md · xuchaoxin1375/scripts - 码云 - 开源中国 (gitee.com)](https://gitee.com/xuchaoxin1375/scripts/blob/main/PwshModuleByCxxu.md#自动部署一键运行脚本)

然后直接调用相关函数即可(命令内调用了其他多个函数,不便在此粘贴源代码)

### 相关命令

- `Get-SpeedUpUrl` (获取加速后的github资源下载链接)
- ` Get-AvailableGithubMirrors`
- `Invoke-GithubResourcesSpeedup` (可以用来直接下载github资源)

下面给出用例

### 使用示例

```powershell

PS🌙[BAT:98%][MEM:52.39% (8.05/15.37)GB][22:35:01]
# [cxxu@BEFEIXIAOXINLAP][<W:192.168.1.77>][~\Desktop]
PS> Get-SpeedUpUrl https://github.com/rayenghanmi/RyTuneX/releases/download/v0.8.2/RyTuneX.Setup.zip -LinkNumber 6 -Silent |Tee-Object $home/downloads/speedlinks
Mode:Silent $LinkNumber=6
Checking available Mirrors...
         https://gh.con.sh
         https://cf.ghproxy.cc
         https://github.moeyy.xyz
         https://gh.ddlc.top.
         https://ghproxy.net
         https://ghps.cc
         https://sciproxy.com
         https://github.ur1.fun
         https://hub.gitmirror.com
         https://mirror.ghproxy.com
         https://ghproxy.cc
         https://ghproxy.homeboyc.cn
         https://slink.ltd
         https://gh-proxy.com.
         https://gh.noki.icu.

Available Mirrors:
 0: Use No Mirror
 1: https://gh.con.sh
 2: https://cf.ghproxy.cc
 3: https://github.moeyy.xyz
 4: https://ghproxy.net
 5: https://ghps.cc
 6: https://sciproxy.com
 7: https://github.ur1.fun
 8: https://hub.gitmirror.com
 9: https://mirror.ghproxy.com
 10: https://ghproxy.cc
 11: https://ghproxy.homeboyc.cn
 12: https://slink.ltd
https://gh.con.sh/https://github.com/rayenghanmi/RyTuneX/releases/download/v0.8.2/RyTuneX.Setup.zip
https://cf.ghproxy.cc/https://github.com/rayenghanmi/RyTuneX/releases/download/v0.8.2/RyTuneX.Setup.zip
https://github.moeyy.xyz/https://github.com/rayenghanmi/RyTuneX/releases/download/v0.8.2/RyTuneX.Setup.zip
https://ghproxy.net/https://github.com/rayenghanmi/RyTuneX/releases/download/v0.8.2/RyTuneX.Setup.zip
https://ghps.cc/https://github.com/rayenghanmi/RyTuneX/releases/download/v0.8.2/RyTuneX.Setup.zip
https://sciproxy.com/https://github.com/rayenghanmi/RyTuneX/releases/download/v0.8.2/RyTuneX.Setup.zip

```

- 可以看到,命令返回了6个可选用的加速过的下载链接,您可以使用其中的任意一个链接尝试下载该资源

### 检查加速后的链接是否可用

```powershell
PS> get-availableGithubMirrors -Mirrors (Get-SpeedUpUrl https://github.com/hellzerg/optimizer/releases/download/16.7/Optimizer-16.7.exe -Silent -LinkNumber 8) -TimeOutSec 5
Mode:Silent $LinkNumber=8
Checking available Mirrors...
         https://gh.ddlc.top.
         https://cf.ghproxy.cc
         https://github.moeyy.xyz
         https://gh.con.sh
         https://ghproxy.cc
         https://ghproxy.net
         https://ghproxy.homeboyc.cn
         https://ghps.cc
         https://hub.gitmirror.com
         https://gh-proxy.com
         https://sciproxy.com
         https://gh.noki.icu.
         https://github.ur1.fun.
         https://mirror.ghproxy.com.
         https://slink.ltd

Available Mirrors:
 0: Use No Mirror
 1: https://cf.ghproxy.cc
 2: https://github.moeyy.xyz
 3: https://gh.con.sh
 4: https://ghproxy.cc
 5: https://ghproxy.net
 6: https://ghproxy.homeboyc.cn
 7: https://ghps.cc
 8: https://hub.gitmirror.com
 9: https://gh-proxy.com
 10: https://sciproxy.com
 11: https://slink.ltd
Checking available Mirrors...
 
Available Mirrors:
 0: Use No Mirror
 1: https://github.moeyy.xyz/https://github.com/hellzerg/optimizer/releases/download/16.7/Optimizer-16.7.exe
 2: https://ghproxy.net/https://github.com/hellzerg/optimizer/releases/download/16.7/Optimizer-16.7.exe
```

- 上述试验表明众多镜像加速后的下载链接中,反应较快的只有2个

### 直接加速下载指定链接👺

模块提供了`Invoke-githubResourcesSpeedup `,接受链接参数(默认尝试调用`aria2c`进行多线程下载)

```powershell
Invoke-githubResourcesSpeedup https://github.com/hellzerg/optimizer/releases/download/16.7/Optimizer-16.7.exe -Verbose
```

```
....
Select the number(s) of the mirror you want to use [0~11] ?(default: 1): 7
Selected mirror:[
        https://ghproxy.net
]
VERBOSE: https://ghproxy.net/https://github.com/hellzerg/optimizer/releases/download/16.7/Optimizer-16.7.exe
Download from: https://ghproxy.net/https://github.com/hellzerg/optimizer/releases/download/16.7/Optimizer-16.7.exe
VERBOSE: aria2c  https://ghproxy.net/https://github.com/hellzerg/optimizer/releases/download/16.7/Optimizer-16.7.exe -d C:\Users\cxxu/Downloads  -s 16 -x 16 -k 1M

09/21 23:20:31 [NOTICE] Downloading 1 item(s)
[#c82bd6 0B/0B CN:1 DL:0B]
09/21 23:20:33 [NOTICE] File already exists. Renamed to C:/Users/cxxu/Downloads/Optimizer-16.7.3.exe.

09/21 23:20:33 [NOTICE] Removed the defunct control file C:/Users/cxxu/Downloads/Optimizer-16.7.3.exe.aria2 because the download file C:/Users/cxxu/Downloads/Optimizer-16.7.3.exe doesn't exist.
[#c82bd6 1.8MiB/2.4MiB(73%) CN:1 DL:411KiB ETA:1s]
```



## 选择下载方式👺

- 即使加速镜像返回的链接比原链接要快,但是想要更好的下载速度还需要一款多线程下载工具
  - 您可以用得到的链接使用专业的下载工具下载,例如IDM等,或者跨平台的其他下载器,当然更方便的是使用aria2(c)下载
  - 下载器可以使用aria2c,idm,或者powershell自带的`invoke-webrequest`也是可以的,甚至使用浏览器下载链接资源也是可以的


### FAQ

- 注意,多线程下载工具不总是最推荐的方式,有时候服务器对多线程有限制,可能导致下不动,这时候可以更换为单线程下载
  - 例如`aria2`,有时候会预处理挺长一段时间然后才开始下载,甚至直接下不动
  - 因此Scoop这类包下载工具虽然在安装了aria2后默认启用,但是会给出警告
  - 在windows terminal这类现代还工具中,访问终端内的链接很方便,按住ctrl
- 如果还是不行,那么更换其他加速后的链接试试



## 其他加速

### 特定资源加速👺（外网资源加速下载)

- [加速下载 (serctl.com)](https://d.serctl.com/?dl_start)

### 克隆加速

- 克隆github仓库的加速资源有很多,比如使用cgit克隆
- [cgit: cgit是一个github快速下载器，使用国内镜像，clone速度可达 (gitee.com)](https://gitee.com/killf/cgit)
- [网达极客社区 (gitclone.com)](https://www.gitclone.com/)
  - [Speed up github - 网达极客社区 (gitclone.com)](https://www.gitclone.com/docs/howto/howto_github)

- 使用gitee,gitcode等托管站导入github加速代码仓库(但是release等文件不容易下载)

### 综合加速

[【镜像站点搜集】 · Issue #116 · hunshcn/gh-proxy (github.com)](https://github.com/hunshcn/gh-proxy/issues/116)

