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

## 其他方案

- 这些方案不推荐

### 国内代码托管平台

- 这些平台在导入github一般不会导入release,因此对于二进制文件下载也没有太大帮助,只有靠部分用户上传二进制包,但是往往缺少更新和维护,所以导致版本会比较老旧
  - [git-for-windows: git-for-windows 安装包国内镜像 (gitee.com)](https://gitee.com/mirror-cn/git-for-windows)

### 云盘分享

- 部分平台或公众号或论坛有人分享软件的安装包,有些不限速的链接可以用
- 安全性欠缺