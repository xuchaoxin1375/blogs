[toc]

## 快速linux命令行美化指南

- 主要适配于Debian系的linux发行版
- 由于不同发行版换源的动作各有差异,这里就不展开了(默认用户都搞定了,最好还搞定了ssh链接)
- 主要介绍利用Oh my zsh来美化,并且在国内网络环境下也能够快速下载安装的开门见山的脚本集合
- 理想情况下,不需要太多时间就可以完成部署
- 我在 ubuntu,linux Mint两个发行版上试验过,都可以良好运行(windows wsl 子系统也没问题)



## 环境准备:换国内源加速

如果是国外服务器,通常不需要此环节,直接跳转到"**基础软件**"开始

先更换软件镜像源(不同发行版有不同的源,另见它文),然后执行下列任务

### ubuntu 22

```bash
#  ubuntu 更换国内镜像源(清华源为例)
# 备份:backup the origin source.list(or just rename(use move command))
# 注意sources.list 不要拼错(带s)
cd /etc/apt
sudo mv sources.list sources.list.bak_bySh
# 切换到家目录,写入国内镜像源到一个文件中(文件名为sources.list),采用多行输入的方式写入
#这里以阿里源为例
cd ~
# 多行输入
sudo tee >sources.list <<EOF
#换源内容粘贴在这里面

# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse


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
#可选的升级
#sudo apt upgrade

```



### ubuntu 24ltsc

#### 传统格式

以ubuntu 24 ltsc为例的一键换源脚本(模板)

```bash
#  ubuntu 更换国内镜像源(清华源为例)
# 备份:backup the origin source.list(or just rename(use move command))
# 注意sources.list 不要拼错(带s)
cd /etc/apt
sudo mv sources.list sources.list.bak_bySh
# 切换到家目录,写入国内镜像源到一个文件中(文件名为sources.list),采用多行输入的方式写入
#这里以阿里源为例
cd ~
# 多行输入
sudo tee >sources.list <<EOF
#换源内容粘贴在这里面

# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://security.ubuntu.com/ubuntu/ noble-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ noble-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-proposed main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-proposed main restricted universe multiverse

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
#可选的升级
#sudo apt upgrade

```

#### deb格式



```bash
cd /etc/apt/sources.list.d
#sudo vim tuna.sources
# 多行输入
sudo tee tuna.sources <<EOF

Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
# Types: deb-src
# URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
# Suites: noble noble-updates noble-backports
# Components: main restricted universe multiverse
# Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# Types: deb-src
# URIs: http://security.ubuntu.com/ubuntu/
# Suites: noble-security
# Components: main restricted universe multiverse
# Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# 预发布软件源，不建议启用

# Types: deb
# URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
# Suites: noble-proposed
# Components: main restricted universe multiverse
# Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# # Types: deb-src
# # URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
# # Suites: noble-proposed
# # Components: main restricted universe multiverse
# # Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

#结束文档
EOF

# 最后将原来的`ubuntu.sources`移动到备份目录
cd /etc/apt/sources.list.d

sudo mkdir /etc/apt/sources.list.d/bak
sudo mv ubuntu.sources ./bak

#执行刷新
sudo apt update
```





### kali-linux

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

## 基础软件🎈

### apt系列

```bash
# 工作目录设定为用户家目录
cd ~
sudo apt update
sudo apt install zsh curl git  man wget -y
```

### pacman系列

可以分别检查以下软件包,如果已经安装过的,就从列表中删除,避免重复按装浪费资源

> windows上msys2也使用pacman来管理软件包,pacman可以获取很新的软件包,并且换源简单,而且安装速度很快

```bash
cd ~
pacman -S zsh curl git man wget 
```



## Oh my zsh

- https://github.com/ohmyzsh/ohmyzsh
- 镜像加速站:[Gitee 极速下载/oh-my-zsh](https://gitee.com/mirrors/oh-my-zsh)

- [Oh My Zsh - a delightful & open source framework for Zsh](https://ohmyz.sh/#install)
- 以下两种安装方式,如果网络环境不好,容易失败
  - `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
  - `sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"`

### 国外环境直接安装

如果服务器在国外,那么访问github比较快,可以不用更改源

[ohmyzsh/ohmyzsh basic installation](https://github.com/ohmyzsh/ohmyzsh?tab=readme-ov-file#basic-installation)

```
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```



### 国内推荐安装方式一键安装👺

ubuntu/debian

```bash
sudo apt update
sudo apt install zsh curl git  man wget -y
```

archlinux

```bash
 pacman -S --needed --noconfirm  zsh curl git man wget
```



```bash
# 工作目录设定为用户家目录
cd ~
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





## oh-my-zsh 插件🎈



这里推荐2个插件

- [zsh-users/zsh-autosuggestions: Fish-like autosuggestions for zsh (github.com)](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-users/zsh-syntax-highlighting: Fish shell like syntax highlighting for Zsh.](https://github.com/zsh-users/zsh-syntax-highlighting)

1. 下载插件到对应的目录(`.oh-my-zsh`)

   - 使用浅克隆加速
     
     ```bash
     # 将两个插件下载到指定目录下:(git 已经指定好了目录)
     git clone --depth 1 https://gitee.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
     
     git clone --depth 1 https://gitee.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
     
     ```

2. 在**bash**下调用sed来配置.zshrc文件,将相关插件配置到zsh插件(plugins)中

   - ```bash
     #bash
     #将工作目录转移到家目录
     cd ~
     path=.zshrc
     sed '/(^plugins)/ s/^#*/#/;
     /^#*plugins/ a\
     plugins=(\
         git\
         z\
         zsh-syntax-highlighting\
         zsh-autosuggestions\
         # 注意,sed命令的后续不能换行\
     )' -r -iE $path
     
     #检查配置文件是否有相应的行
     cat ~/.zshrc|grep  -e zsh-syntax-highlighting -e zsh-autosuggestions
     
     
     ```

3. 进入到**zsh**刷新`~/.zshrc`,让zsh的配置生效(直接输入zsh即可)

   ```bash
   #zsh(可选)
   source ~/.zshrc
   
   ```

4.现在到下一节配置oh my zsh主题


## 配置oh my zsh主题

- 进入`zsh`,然后执行以下内容
  
  ```bash
  zshrc=~/.zshrc
  echo $zshrc
  # 利用sed并启用扩展正则原地修改,将Zsh主题设置为随机
  sed -Ei 's/(^ZSH_THEME=)(.*)/\1"random"/' $zshrc
  #设置随机选择的主题的列表为ys,junkfood,rkj-repos;具体可以改成自己喜欢的主题
  sed -Ei.bak 's/(^#*\s*)(ZSH_THEME_RANDOM.*=)(.*)/\2("ys" "junkfood" )/' $zshrc
  #检查修改结果
  cat   ~/.zshrc|grep -E  '^[^#]'|grep -e random -e THEME -e RANDOM|cat -n
  #刷新配置结果
  source $zshrc
  
  
  ```
  

## 其他

针对ubuntu

### 修改系统时间

修改为北京时间

```bash
sudo timedatectl set-timezone Asia/Shanghai
```



### 主机名

```bash
sudo hostnamectl set-hostname 新主机名
```

然后启动一个新shell查看变化

## 配置fzf

- 安装fzf(建议用brew来安装,版本比较新,apt安装的版本比较老)
- 绑定shell
  
  
