[toc]

##  检查现有的软件包(apt)
###  apt list 方法
- 对于较新(不太老旧)版本的发新版,可以使用apt 
- `sudo apt list` 可以获取(源/库)所有包列表(包括未安装的)
- `sudo apt list --installed`可以获取已经安装的包列表
```bash
# cxxu @ cxxuAli in ~/cppCodes on git:master o [11:14:18] C:130
$ sudo apt list |wc -l

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

76631

# cxxu @ cxxuAli in ~/cppCodes on git:master o [11:15:13]
$ sudo apt list --installed |wc -l

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

1057
```
####  apt 常用命令
- [apt Command in Linux | Linuxize](https://linuxize.com/post/how-to-use-apt-command/#:~:text=apt%20is%20a%20command-line%20utility%20for%20installing%2C%20updating%2C,distributions.%20Linuxize%20Ubuntu%20Centos%20Debian%20Commands%20Series%20Donate)
####  apt-get 
- 如果没有`apt`命令,但是又`apt-get`您可以先安装`apt`工具,让后再使用上述方法操作
- 可以查看到软件的版本信息
- 字段的大概含义参考`dpkg-query -l`
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/a56b95c59f8021bda7c5324da3afe0ad.png)

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/d6055aca44270d78939ffb99f7803551.png)

- `sudo apt-get install apt`
####  关于`man <searchStr>`命令得到的结果
- 即使您的linux没有安装某个软件包,但是还是可能从man中查询到用法
- 或者说,`man`命令返回的消息不依赖于已安装的包,而在于软件源那里下载过来的信息(个人猜测可能是`apt[-get] update` 所拉取到的信息)
###  dpkg --list 方法(for debian series)
>比较成熟的方法 dpkg
- `dpkg --list `
```bash
 dpkg-query actions
              See dpkg-query(1) for more information about the following actions.

              -l, --list package-name-pattern...
                  List packages matching given pattern.
              -s, --status package-name...
                  Report status of specified package.
              -L, --listfiles package-name...
                  List files installed to your system from package-name.
              -S, --search filename-search-pattern...
                  Search for a filename from installed packages.
              -p, --print-avail package-name...
                  Display details about package-name, as found in
                  /var/lib/dpkg/available. Users of APT-based frontends
                  should use apt-cache show package-name instead.
```
###  dpkg-query 方法
```bash
  dpkg-query

  A tool that shows information about installed packages.
  More information: https://manpages.debian.org/latest/dpkg/dpkg-query.1.html.

  - List all installed packages:
    dpkg-query -l

  - List installed packages matching a pattern:
    dpkg-query -l 'pattern'

  - List all files installed by a package:
    dpkg-query -L package_name

  - Show information about a package:
    dpkg-query -s package_name
```
- 可以查看到相关主题包的状态(详见`man dpkg-query`)
- `dpkg-query -l '*ssh*'`
	- 正则模式需要用引号(单引号)括起来 
	![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/107eb5d8188bfb3b5d0c086375335aa9.png)

####  dpkg 管理工具
```bash
DESCRIPTION
       dpkg is a tool to install, build, remove and manage Debian packages.  The  primary  and  more  user-
       friendly  front-end  for  dpkg  is  aptitude(1). dpkg itself is controlled entirely via command line
       parameters, which consist of exactly one action and zero or more options. The action-parameter tells
       dpkg what to do and options control the behavior of the action in some way.
```
####  检查ssh是否安装
- `sudo apt list --installed|grep ssh`
- `sudo dpkg --list|grep ssh`
```bash
$ sudo apt list --installed|grep ssh

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

openssh-client/bionic-updates,now 1:7.6p1-4ubuntu0.6 amd64 [installed]
openssh-server/bionic-updates,now 1:7.6p1-4ubuntu0.6 amd64 [installed]
openssh-sftp-server/bionic-updates,now 1:7.6p1-4ubuntu0.6 amd64 [installed,automatic]
ssh/bionic-updates,bionic-updates,now 1:7.6p1-4ubuntu0.6 all [installed]
ssh-import-id/bionic-updates,bionic-updates,now 5.7-0ubuntu1.1 all [installed,automatic]
```
- 在确保`软件源(/etc/apt/sources.list)`中的源可用下执行

- `sudo apt install openssh-server`
- 对于老版本的ubuntu `alias apt=apt-get`