[toc]





## 磁盘占用|文件夹目录体积统计|相关软件👺

- Onecommander [OneCommander - Modern files manager for Windows 11 and Windows 10](https://onecommander.com/)
  - 是一款扩展了windows资源管理器(explorer)的软件,可以启用目录占用大小的功能(这会引起高的cpu占用,灵活性不如单独计算指定目录的供,windows自带的资源管理器虽然默认计算文件夹大小,但是可以右键属性单独查看指定目录占用大小)

- eza [eza-community/eza: A modern alternative to ls (github.com)](https://github.com/eza-community/eza)

### 类Unix系du衍生发展出来的跨平台工具

- 这些系统在linux下都可用,其中部分支持或适配了windows(有相应的发行版),但是少数平台特性的功能可能有阉割,总得来说下面几个工具或者类似工具还是值得使用的
- 这类工具在windows下通常可以考虑通过`scoop`安装(推荐使用国内加速版),或者在github上手动下载

#### dust

- [bootandy/dust: A more intuitive version of du in rust (github.com)](https://github.com/bootandy/dust)
- 高性能直观易用的命令行工具,跨平台

Download

- Download Linux/Mac binary from [Releases](https://github.com/bootandy/dust/releases)
- unzip file: `tar -xvf "_downloaded_file.tar.gz"`
- move file to executable path: `sudo mv dust /usr/local/bin/`

```bash
cd ~
# cxxu @ CxxuDesk in ~ [9:01:15]
$ wget https://github.com/bootandy/dust/releases/download/v1.2.1/du-dust_1.2.1-1_amd64.deb
#等待下载完成(很小),如果下不动可以用代理下载或者github加速镜像下载


# cxxu @ CxxuDesk in ~ [9:01:39]
$ uname -m #可选,查看当前系统架构
x86_64

# cxxu @ CxxuDesk in ~ [9:06:49] C:130
$ ls *dust*
du-dust_1.2.1-1_amd64.deb

# cxxu @ CxxuDesk in ~ [9:02:35]
$ sudo dpkg -i du-dust_1.2.1-1_amd64.deb
[sudo] password for cxxu:
Selecting previously unselected package du-dust.
(Reading database ... 66354 files and directories currently installed.)
Preparing to unpack du-dust_1.2.1-1_amd64.deb ...
Unpacking du-dust (1.2.1-1) ...
Setting up du-dust (1.2.1-1) ...
Processing triggers for man-db (2.12.0-4build2) ...

# cxxu @ CxxuDesk in ~ [9:03:20]
```

### 在ubuntu上直接安装dust

dust的安装方式有多种,直接安装可以下载二进制文件,找到对应的软件包下载解压并安装

```
cd ~
# 下载链接请到项目的release页面获取最新链接,下面的链接作为例子,下载后保存为dust.deb文件
wget -O dust.deb https://github.com/bootandy/dust/releases/download/v1.2.1/du-dust_1.2.1-1_amd64.deb
sudo dpkg -i dust.deb
rm dust.deb -v #移除安装包
#简单用例
dust .

```



#### gdu

- [dundee/gdu: Fast disk usage analyzer with console interface written in Go (github.com)](https://github.com/dundee/gdu)
- 这是交互式的命令行工具,支持查询容量以外的功能,比如浏览子目录,删除指定文件(夹)等功能,是高性能软件



### windows专属软件

#### everything

- 利用**everything**排序(高性能),文件索引完毕后,指定目录,选择size排序
  - 软件官网https://www.voidtools.com/

#### du (sysinternals du)

- sysinternals工具集有Microsoft开发维护,里面的磁盘相关的工具或许能够满足您更多的需要
  - [磁盘使用情况 - Sysinternals | Microsoft Learn](https://learn.microsoft.com/zh-cn/sysinternals/downloads/du)
  - [文件和磁盘实用工具 - Sysinternals | Microsoft Learn](https://learn.microsoft.com/zh-cn/sysinternals/downloads/file-and-disk-utilities)

- 此工具较为原始,建议使用其他工具,比如`dust`,`gdu`,更加现代化和通用

##### 用例

- 查看指定目录下所有子目录下文件的大小,可以配合管道符进行排序

```powershell
PS> du -v|sort -Descending
Processing...

Totals:
Sysinternals - www.sysinternals.com
Size:         578,286 bytes
Size on disk: 1,462,272 bytes
Files:        112
DU v1.62 - Directory disk usage reporter
Directories:  58
Copyright (C) 2005-2018 Mark Russinovich
          82  C:\repos\scripts\PS\Deploy
          78  C:\repos\scripts\PS\Basic
          52  C:\repos\scripts\PS\Pwsh
          40  C:\repos\scripts\PS\TaskSchdPwsh
          27  C:\repos\scripts\PS\Deprecated
          24  C:\repos\scripts\PS\PwshVar
          21  C:\repos\scripts\PS\EnvVar
          20  C:\repos\scripts\PS\Search
  ....
```

#### WizTree

- 专业的磁盘占用分析工具,直观易用
  - [WizTree - The Fastest Disk Space Analyzer (diskanalyzer.com)](https://diskanalyzer.com/?ref=wiztree)

- 其他类似的工具有spacesniffer,windirstat等(速度可能较慢)