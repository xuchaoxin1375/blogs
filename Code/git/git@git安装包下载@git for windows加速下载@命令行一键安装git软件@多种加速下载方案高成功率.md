[toc]

## abstract

- git是一个基础软件,应用十分广泛,但是它的官网下载速度却让国内用户感到不快 
- git for windows 是一个git在windows平台的客户端,除了官网下载,本文列举了多种可以提高下载速度的方案,可靠性由高到低,成功率几乎百分之百



## 镜像下载

可以下载到较新版本,并且速度较快

- [Index of /github-release/git-for-windows/git/ | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/github-release/git-for-windows/git/)

- [Index of git-for-windows-local (huaweicloud.com)](https://mirrors.huaweicloud.com/git-for-windows/)

- [CNPM Binaries Mirror (npmmirror.com)](https://registry.npmmirror.com/binary.html?path=git-for-windows/)
  - 淘宝二进制文件镜像站,域名变过过,许多老教程提供的链接已经失效了,更新记录:[NPM镜像域名解析变更](https://developer.aliyun.com/mirror/NPM?spm=a2c6h.13651102.J_4121707010.1.6f521b11F8VdAd)

### 从github release配合github加速站下载

- 这种方法对于github上的资源下载加速是通用的,加速站点可以参考:
  - [gh-proxy - Search (bing.com)](https://cn.bing.com/search?q=gh-proxy&cvid=6e3c98f73b8e420abe0c55b7d83bff80&aqs=edge.0.69i59l2j0l4j69i65j69i60l2.4910j0j4&FORM=ANAB01&PC=U531)
  - 这类加速站点大多基于github开源项目`gh-proxy`进行搭建
  - [【镜像站点搜集】 · Issue #116 · hunshcn/gh-proxy (github.com)](https://github.com/hunshcn/gh-proxy/issues/116)
- 下面是github上git for windows客户端软件的下载地址,配合上面的加速站点来使用
  - [Releases · git-for-windows/git (github.com)](https://github.com/git-for-windows/git/releases/)

### 从应用商店下载

- 比如国内的联想应用商店,火绒应用商店
  - [Git-联想应用商店 (lenovo.com)](https://lestore.lenovo.com/detail/22693)
- 这些商店下载到的版本数量有限,而且往往不是最新版本,但是下载成功率高,并且git这类软件可以几年更新一次也不太影响使用

### 使用包管理工具下载

- windows上也是有包管理工具
  - scoop :国内许多爱好者为其制作了加速镜像和临时bucket,以提供scoop部署,并且带有git软件
  - x-cmd:[Windows | x-cmd get-started](https://cn.x-cmd.com/start/windows) 为用户提供的bat脚本包含了git安装服务(调用系统自带的C:\Windows\System32\curl.exe 在命令行中下载所需文件)

### 使用代理服务器下载

- 代理服务器是比较通用的加速服务资源,不用多说
- 有些站点提供国外资源加速下载的服务,不过速度上限一般不会太快

## 一键安装(便携版Git)

借助于以下开源项目来一键安装Git(安装的是便携版)

### 方案1

- [Scoop: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理。内置加速站有调用次数限制，请勿提取滥用。  (gitee.com)](https://gitee.com/scoop-installer/scoop)

- ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  
  Invoke-WebRequest -useb scoop.201704.xyz | Invoke-Expression
  
  scoop install git  #为当前用户安装,如果全局需要管理员权限
  
  ```

- 将上述代码复制粘贴到powershell中回车执行即可
  - 成功率总体较高,不保证一次性成功,如果失败可以多试一次
  - 此方案会自动为你配置环境变量(由scoop统一管理)
  - 安装过程中,会先安装`7z.exe`,然后安装`Git-for-windows`
- 安装完后要不要使用过scoop取决于你

#### 执行记录(参考)

```powershell

PS C:\Users\cxxu>         Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
PS C:\Users\cxxu>
PS C:\Users\cxxu>         Invoke-WebRequest -useb scoop.201704.xyz | Invoke-Expression
Initializing...
Downloading...
Extracting...
Creating shim...
Scoop was installed successfully!
Type 'scoop help' for instructions.
PS C:\Users\cxxu>
PS C:\Users\cxxu>         scoop install git  #为当前用户安装,如果全局需要管理员权限
Installing '7zip' (24.07) [64bit] from 'main' bucket
proxy: https://www.7-zip.org/a/7z2407-x64.msi
7z2407-x64.msi (1.9 MB) [=====================================================================================] 100%
Checking hash of 7z2407-x64.msi ... ok.
Extracting 7z2407-x64.msi ... done.
Linking ~\scoop\apps\7zip\current => ~\scoop\apps\7zip\24.07
Creating shim for '7z'.
Creating shim for '7zFM'.
Making C:\Users\cxxu\scoop\shims\7zfm.exe a GUI binary.
Creating shim for '7zG'.
Making C:\Users\cxxu\scoop\shims\7zg.exe a GUI binary.
Creating shortcut for 7-Zip (7zFM.exe)
Persisting Codecs
Persisting Formats
Running post_install script...done.
'7zip' (24.07) was installed successfully!
Notes
-----
Add 7-Zip as a context menu option by running: "C:\Users\cxxu\scoop\apps\7zip\current\install-context.reg"
Installing 'git' (2.45.2) [64bit] from 'main' bucket
proxy: https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/PortableGit-2.45.2-64-bit.7z.exe
PortableGit-2.45.2-64-bit.7z.exe (60.1 MB) [==================================================================] 100%
Checking hash of PortableGit-2.45.2-64-bit.7z.exe ... ok.
Extracting PortableGit-2.45.2-64-bit.7z.exe ... done.
Linking ~\scoop\apps\git\current => ~\scoop\apps\git\2.45.2
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
'git' (2.45.2) was installed successfully!
Notes
-----
Set Git Credential Manager Core by running: "git config --global credential.helper manager"

To add context menu entries, run 'C:\Users\cxxu\scoop\apps\git\current\install-context.reg'

To create file-associations for .git* and .sh files, run
'C:\Users\cxxu\scoop\apps\git\current\install-file-associations.reg'
```

### 方案2

- 会一并安装powershell实用模块集
- [PS/Deploy/Deploy-CxxuPsModules.ps1 · xuchaoxin1375/scripts - 码云 - 开源中国 (gitee.com)](https://gitee.com/xuchaoxin1375/scripts/blob/main/PS/Deploy/Deploy-CxxuPsModules.ps1)

```powershell
$url = 'https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/Deploy-CxxuPsModules.ps1'
$scripts = Invoke-RestMethod $url
$scripts | Invoke-Expression
# Deploy-CxxuPsModules 
Deploy-GitForwindows #安装git for windows

```

- 不保证一次成功,合并了方案1

## 其他方案

- 这些方案不推荐

### 国内代码托管平台

- 这些平台在导入github一般不会导入release,因此对于二进制文件下载也没有太大帮助,只有靠部分用户上传二进制包,但是往往缺少更新和维护,所以导致版本会比较老旧
  - [git-for-windows: git-for-windows 安装包国内镜像 (gitee.com)](https://gitee.com/mirror-cn/git-for-windows)

### 云盘分享

- 部分平台或公众号或论坛有人分享软件的安装包,有些不限速的链接可以用
- 安全性欠缺