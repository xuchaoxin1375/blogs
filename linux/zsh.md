@[toc]


##  references
- [git - github: server certificate verification failed - Stack Overflow](https://stackoverflow.com/questions/35821245/github-server-certificate-verification-failed)
#  信息检查和预备工作



## 查看发行版和内核版本号相关主题命令

### 查看自己的发行版以及版本号

第一种为通用方法

- `cat /etc/issue`
- `lsb_release -a`

```bash
cxxu@iZ2zef3tpqffm5ydjqi4zsZ:/etc/apt$ cat /etc/issue
Ubuntu 18.04.6 LTS \n \l

cxxu@iZ2zef3tpqffm5ydjqi4zsZ:/etc/apt$ lsb_release -a
LSB Version:    core-9.20170808ubuntu1-noarch:security-9.20170808ubuntu1-noarch
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.6 LTS
Release:        18.04
Codename:       bionic
```

### 内核号(optional)
- `uname -a`
- `cat /proc/version`

```bash
 cat /proc/version
Linux version 4.15.0-169-generic (buildd@lcy02-amd64-015) (gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)) #177-Ubuntu SMP Thu Feb 3 10:50:38 UTC 2022
```
### 发行版相关主题(optional)

```bash
$ apropos distribution
debian-distro-info (1) - provides information about Debian's distributions
distro-info (1)      - provides information about the distributions' releases
dpkg-vendor (1)      - queries information about distribution vendors
iptables-extensions (8) - list of extensions in the standard iptables distribution
lsb_release (1)      - print distribution-specific information
ubuntu-distro-info (1) - provides information about Ubuntu's distributions
# cxxu @ cxxuAli in ~ [19:21:03]
$ apropos distribution |grep information
debian-distro-info (1) - provides information about Debian's distributions
distro-info (1)      - provides information about the distributions' releases
dpkg-vendor (1)      - queries information about distribution vendors
lsb_release (1)      - print distribution-specific information
ubuntu-distro-info (1) - provides information about Ubuntu's distributions
```

### 内核版本相关主题(optional)

```bash
# cxxu @ cxxuAli in ~ [19:08:31]
$ apropos kernel|grep version
linux-version (1)    - operate on Linux kernel version strings
# cxxu @ cxxuAli in ~ [19:15:16] C:16
$ whatis uname
uname (1)            - print system information
uname (2)            - get name and information about current kernel
```

#  自动化脚本部署/美化🎈


##  下面自动化脚本使用方式
- 将脚本复制,并粘贴到新建文本文件中(可以用 vim/gedit/任意编辑器)
  然后再该文件目录下执行
  - 直接复制粘贴可能导致各种异常
    `source yourFileName.sh`
    具体而言,比如您创建文件名为 `replaceAptSource.sh`
    那么运行:
    `source replaceAptSource.sh`

## 更换国内镜像源(Part1:optional)🎈

- 使用前提:

  - 适配于debian系发行版

  - 确保当前用户 `sudo`命令可用


### 换源脚本模板

- 不要直接使用
- 以kali-linux 更换国内镜像源(阿里源为例)
- 只提供流程参考
- 如果要使用,请打开编辑器,将[国内源部分]替换为自己的发行版的国内源

```bash
# 备份:backup the origin source.list(or just rename(use move command))
# 注意sources.list 不要拼错(带s)
cd /etc/apt
sudo mv sources.list sources.list.bak_bySh
# 切换到家目录,写入国内镜像源到一个文件中(文件名为sources.list),采用多行输入的方式写入
#这里以阿里源为例
cd ~
# 多行输入[国内源]
cat >sources.list <<EOF

deb https://mirrors.aliyun.com/kali kali-rolling main non-free contrib 
deb-src https://mirrors.aliyun.com/kali kali-rolling main non-free contrib

EOF

#上面的EOF间的内容不要写入其他与源无关的内容(除了注释和源,其他命令不要写在里头)
# 检查写入的内容:
echo "check the conetent of the file 'source.list'"
## 将家目录下的sources.list 转移到/etc/apt目录下(sodu可以作用与mv/cp等命令,
## 但好像不可以直接作用与cat,所以没有直接在/etc/apt目录下创建新文件)
sudo mv sources.list /etc/apt
cat /etc/apt/sources.list
# 更新并使得apt配置文件生效
echo "updating the apt..."
sudo apt update


# 其他写法:探索中

# sourceCN="
# deb https://mirrors.aliyun.com/kali kali-rolling main non-free contrib 
# deb-src https://mirrors.aliyun.com/kali kali-rolling main non-free contrib
# "
# echo $sourceCN
# sudo cat>>source.list<<EOF
# echo $sourceCN
# EOF

```



### ubuntu 换源

- [ubuntu | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirror.tuna.tsinghua.edu.cn/help/ubuntu/)
- [ubuntu源by阿里](https://developer.aliyun.com/mirror/ubuntu?spm=a2c6h.13651102.0.0.3e221b11gszrk6)
- 版本较多,操作类似,可以按阿里源那样一步步做,也可以将上述脚本中的源地址更换位对应版本的ubuntu源即可
- 这里以清华源的 `21.10`版本为例
- 其他版本将源地址群换为对应版本
####  通用版脚本

```bash
#  ubuntu 21.10更换国内镜像源(清华源为例)
# 备份:backup the origin source.list(or just rename(use move command))
# 注意sources.list 不要拼错(带s)
cd /etc/apt
sudo mv sources.list sources.list.bak_bySh
# 切换到家目录,写入国内镜像源到一个文件中(文件名为sources.list),采用多行输入的方式写入
#这里以阿里源为例
cd ~
# 多行输入
sudo tee >sources.list <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish-proposed main restricted universe multiverse

#结束文档
EOF

#上面的EOF间的内容不要写入其他与源无关的内容(除了注释和源,其他命令不要写在里头)
# 检查写入的内容:
echo "check the conetent of the file 'source.list'"
## 将家目录下的sources.list 转移到/etc/apt目录下(sodu可以作用与mv/cp等命令,
## 但好像不可以直接作用于cat,所以没有直接在/etc/apt目录下创建新文件)
sudo mv sources.list /etc/apt
cat /etc/apt/sources.list
# 更新并使得apt配置文件生效
echo "updating the apt..."
sudo apt update

```
#### 简化版(从默认源替换为国内源)

###  将source.list 文件修改为清华源ubutun22

- (清华源为例,使用sed处理`/etc/apt/sources.list`文件)
- 仍然建议事先备份`sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak`文件

```bash
sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
```

- 执行刷新操作`sudo apt update`

### kali

- [kali源by阿里](https://developer.aliyun.com/mirror/kali?spm=a2c6h.13651102.0.0.3e221b11gszrk6)
- 清华源kali

```bash
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free

deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free

```

### 云服务器的源

- 阿里云服务器自己的源是配置的阿里自己的源
- 可以不做换源操作
  - 但仍然应该做一次 `sudo apt update`,否则很多工具将无法install.
- ESC ubuntu实例创建的普通用户可能无法直接使用 `sudo`,这会导致脚本出错
  - 幸运的是,解决这个问题不负责,只需要切换到root用户补增执行 `sudo adduser <userName> sudo`(大致流程如下)

```bash
cxxu@iZ2zef3tpqffm5sdfaydsjqi4zsdsZ:/etc/apt$ su -
Password:
root@iZ2zef3tpqffsdfm5ysdfgdjdfsfqi4zsZ:~# sudo addusr cxxu sudo
sudo: addusr: command not found
root@iZ2zef3tpsdfqffasdm5ydjqi4zsZ:~# sudo adduser cxxu sudo
Adding user `cxxu' to group `sudo' ...
Adding user cxxu to group sudo
Done.

```

## zsh:oh my zsh(part2)🎈🎈

```bash
# 工作目录设定为用户家目录
cd ~
sudo apt update
sudo apt install zsh curl git  man wget -y
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
# 由于国内网络问题,可能需要多尝试几次一下source 命令才可以安装成功.(我将其注释掉,采用换源后再执行clone
#source install.sh
#本段代码将修改install.sh中的拉取源,以便您能够冲gitee上成功将需要的文件clone下来.


# 本段代码会再修改前做备份(备份文件名为install.shE)
sed '/(^remote)|(^repo)/I s/^#*/#/ ;
/^#*remote/I a\
REPO=${REPO:-mirrors/oh-my-zsh}\
REMOTE=${REMOTE:-https://gitee.com/${REPO}.git} ' -r ~/install.sh > gitee_install.sh
# 执行安装
source gitee_install.sh


#返回到脚本所在目录(以便执行新的脚本)
cd -
```

### zsh安装失败?

- 一般来说,重试一两次即可clone(install)成功
- 若始终无法clone下来,可以修改 `install.sh`中的特定几行,使其去拉取gitee上的文件

#### 修改方案一(sed 修改)

```bash
#本段代码将修改install.sh中的拉取源,以便您能够冲gitee上成功将需要的文件clone下来.
# 本段代码会再修改前做备份(备份文件名为install.shE)
sed '/(^remote)|(^repo)/I s/^#*/#/ ;
/^#*remote/I a\
REPO=${REPO:-mirrors/oh-my-zsh}\
REMOTE=${REMOTE:-https://gitee.com/${REPO}.git} ' -r  -iE ~/install.sh
# 执行安装
source install.sh
```

#### 修改方案二(手工修改)

- 打开 `install.sh`文件修改如下部分:
  
  - 大概在40多行
  - 推荐做法是,注释掉原来的两行
  - 将下面的两行粘贴进去
  
  - ```bash
    REPO=${REPO:-mirrors/oh-my-zsh}
    REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}
    ```

###  拉取报错

- 对于某些环境(譬如我在ubuntu12 老版本上操作的时候,遇到安全设置问题)

- 错误如下:

  - ```bash
    Cloning Oh My Zsh...
    fatal: unable to access 'https://gitee.com/mirrors/oh-my-zsh.git/': server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
    /home/cxxu
    Error: git clone of oh-my-zsh repo failed
    ```

- `git config --global http.sslverify false`
- 尝试执行上述语句解决

## uninstall oh-my-zsh🎈

- 如果你的`oh-my-zsh`出现异常想要重装,可以尝试:

- [ohmyzsh/ohmyzsh:uninstall ](https://github.com/ohmyzsh/ohmyzsh#uninstalling-oh-my-zsh)

### 直接卸载

- 执行命令 `uninstall_oh_my_zsh`

### 手动卸载ohmyzsh

- 某些情况下(例如安装失败/错误/不完整安装),容易导致上述命令无法顺利运行

- 下方指令可以帮助您卸载


- ```bash
  cd ~/.oh-my-zsh/tools
  source uninstall.sh -y
  # rm /home/.oh-my-zsh
  ```




## oh-my-zsh 插件篇🎈

- [oh my zsh插件:命令动态提示和自动增量补全命令incr/自动补全zsh-autosuggestion安装/命令行命令高亮插件zsh-syntax-highlighting/_xuchaoxin1375的博客-CSDN博客_zsh 自动提示](https://blog.csdn.net/xuchaoxin1375/article/details/111940783?ops_request_misc=%7B%22request%5Fid%22%3A%22166342185816800192228396%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=166342185816800192228396&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-1-111940783-null-null.nonecase&utm_term=zsh插件&spm=1018.2226.3001.4450)

## 安装/修复vim(optional)

- 某些自带(vi/vim)会和vim 冲突,可以先卸载vi再安装vim

- `sudo apt remove vi;sudo apt install vim`

### vim/vi卸载与更新异常

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/141ce0f07fa2401e9ffce596ca95914f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)


- 执行 `sudo apt remove vim-common`再次移除造成问题的原组件
- 重新执行安装 `sudo apt install vim`

## for centOS install oh-my-zsh

```bash
# 工作目录设定为用户家目录
cd ~
sudo yum update
sudo yum install zsh curl git vim man wget -y
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
# 由于国内网络问题,可能需要多尝试几次一下source 命令才可以安装成功.
source install.sh
#返回到脚本所在目录(以便执行新的脚本)
cd -
```

## 去除绿色背景(wsl)🎈

```bash

# dirColorSetting.sh
# remove the background color to improve the reading experience.
cat>> ~/.bashrc<<EOF
# remove the background color to improve the reading experience.
eval "$(dircolors -p | \
    sed 's/ 4[0-9];/ 01;/; s/;4[0-9];/;01;/g; s/;4[0-9] /;01 /' | \
    dircolors /dev/stdin)"

EOF
# 使得修改生效:
source ~/.bashrc
# 如果您使用zsh的话,请解开这一段注释,反之,则将其注释掉,防止错误

cat>> ~/.zshrc<<EOF
# remove the background color to improve the reading experience.
eval "$(dircolors -p | \
    sed 's/ 4[0-9];/ 01;/; s/;4[0-9];/;01;/g; s/;4[0-9] /;01 /' | \
    dircolors /dev/stdin)"

EOF
#使得修改生效
source ~/.zshrc


```

## oh My zsh 文档目录

* [Getting Started](https://github.com/ohmyzsh/ohmyzsh#getting-started)
  * [Prerequisites](https://github.com/ohmyzsh/ohmyzsh#prerequisites)
  * [Basic Installation](https://github.com/ohmyzsh/ohmyzsh#basic-installation)
    * [Manual inspection](https://github.com/ohmyzsh/ohmyzsh#manual-inspection)
* [Using Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh#using-oh-my-zsh)
  * [Plugins](https://github.com/ohmyzsh/ohmyzsh#plugins)
    * [Enabling Plugins](https://github.com/ohmyzsh/ohmyzsh#enabling-plugins)
    * [Using Plugins](https://github.com/ohmyzsh/ohmyzsh#using-plugins)
  * [Themes](https://github.com/ohmyzsh/ohmyzsh#themes)
    * [Selecting a Theme](https://github.com/ohmyzsh/ohmyzsh#selecting-a-theme)
  * [FAQ](https://github.com/ohmyzsh/ohmyzsh#faq)
* [Advanced Topics](https://github.com/ohmyzsh/ohmyzsh#advanced-topics)
  * [Advanced Installation](https://github.com/ohmyzsh/ohmyzsh#advanced-installation)
    * [Custom Directory](https://github.com/ohmyzsh/ohmyzsh#custom-directory)
    * [Unattended install](https://github.com/ohmyzsh/ohmyzsh#unattended-install)
    * [Installing from a forked repository](https://github.com/ohmyzsh/ohmyzsh#installing-from-a-forked-repository)
    * [Manual Installation](https://github.com/ohmyzsh/ohmyzsh#manual-installation)
  * [Installation Problems](https://github.com/ohmyzsh/ohmyzsh#installation-problems)
  * [Custom Plugins and Themes](https://github.com/ohmyzsh/ohmyzsh#custom-plugins-and-themes)
* [Getting Updates](https://github.com/ohmyzsh/ohmyzsh#getting-updates)
  * [Manual Updates](https://github.com/ohmyzsh/ohmyzsh#manual-updates)
* [Uninstalling Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh#uninstalling-oh-my-zsh)
* [How do I contribute to Oh My Zsh?](https://github.com/ohmyzsh/ohmyzsh#how-do-i-contribute-to-oh-my-zsh)
  * [Do NOT send us themes](https://github.com/ohmyzsh/ohmyzsh#do-not-send-us-themes)
* [Contributors](https://github.com/ohmyzsh/ohmyzsh#contributors)
* [Follow Us](https://github.com/ohmyzsh/ohmyzsh#follow-us)
* [Merchandise](https://github.com/ohmyzsh/ohmyzsh#merchandise)
* [License](https://github.com/ohmyzsh/ohmyzsh#license)
* [About Planet Argon](https://github.com/ohmyzsh/ohmyzsh#about-planet-argon)