[toc]

# zsh check

> 最近感觉zsh+oh my zsh 有点bug,`ctrl+c`无法结束输入,而且容易卡死,遂打算更新以下zsh

### zsh version

- `zsh --version`

#### oh my zsh update config

- [ohmyzsh/ohmyzsh: update config](https://github.com/ohmyzsh/ohmyzsh#getting-updates)

> 手动更新

- `omz update`

#### 

### oh my zsh document

- [Home · ohmyzsh/ohmyzsh Wiki (github.com)](https://github.com/ohmyzsh/ohmyzsh/wiki)

### install zsh

- [Installing ZSH · ohmyzsh/ohmyzsh Wiki (github.com)](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)

#### oh my zsh basic usage and help

- `omz`command
  - `omz -h`get help

```bash
#( 04/12/22@ 2:04PM )( cxxu@cxxuAli ):~
   omz -h
Usage: omz <command> [options]

Available commands:

  help                Print this help message
  changelog           Print the changelog
  plugin <command>    Manage plugins
  pr     <command>    Manage Oh My Zsh Pull Requests
  reload              Reload the current zsh session
  theme  <command>    Manage themes
  update              Update Oh My Zsh
  version             Show the version
```

#### 二级帮助

```
#( 04/12/22@ 2:04PM )( cxxu@cxxuAli ):~
   omz version
master (846f417e)
#( 04/12/22@ 2:05PM )( cxxu@cxxuAli ):~
   omz plugin
Usage: omz plugin <command> [options]

Available commands:

  disable <plugin> Disable plugin(s)
  enable <plugin>  Enable plugin(s)
  info <plugin>    Get information of a plugin
  list             List all available Oh My Zsh plugins
  load <plugin>    Load plugin(s)
```



## z shell通用方案安装/更新到最新版zsh:Install zsh by source code(general method)

### referneces

#### 方案一(自动化)



- [Build Zsh from sources on Ubuntu (github.com)](https://gist.github.com/ptrv/1070757/7fa178a4fa954f9a8a0201ee8e7dfa5611812bb0)
  - 整合脚本

```bash
#!/bin/sh​
# Build Zsh from sources on Ubuntu
# From http://zsh.sourceforge.net/Arc/git.html and sources INSTALL file.

git clone git://zsh.git.sf.net/gitroot/zsh/zsh

cd zsh

```

> #上面获取zsh原码的方式可到官网下载压缩包解压来代替

```
# Some packages may be missing
sudo apt-get install -y git-core gcc make autoconf yodl libncursesw5-dev texinfo

./Util/preconfig

# Options from Ubuntu Zsh package rules file (http://launchpad.net/ubuntu/+source/zsh)
./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --bindir=/bin \
            --infodir=/usr/share/info \
            --enable-maildir-support \
            --enable-max-jobtable-size=256 \
            --enable-etcdir=/etc/zsh \
            --enable-function-subdirs \
            --enable-site-fndir=/usr/local/share/zsh/site-functions \
            --enable-fndir=/usr/share/zsh/functions \
            --with-tcsetpgrp \
            --with-term-lib="ncursesw" \
            --enable-cap \
            --enable-pcre \
            --enable-readnullcmd=pager \
            --enable-custom-patchlevel=Debian \
            LDFLAGS="-Wl,--as-needed -g"

make

make check

sudo make install

sudo make install.info
```



#### 方案二(手动操作)

- [ZSH - THE Z SHELL (sourceforge.io)](https://zsh.sourceforge.io/)

- [ZSH - Source download (sourceforge.io)](https://zsh.sourceforge.io/Arc/source.html)
  - 官方下载/介绍
  - 安装包(zsh-xxx.tar.xz)中的`INSTALL`中介绍了安装要求和方法,较为冗长

### 手动操作提取官方包的文件(解压拆包)

- ` tar xvf zsh-5.8.1.tar.xz zsh-5.8.1/`
  - 根据自己的版本切换数字
  - 根据`INSTALL`文件描述安装

### 安装完毕检查版本

> 我从5.4.1->5.8.1

```
#( 04/12/22@ 1:50PM )( cxxu@cxxuAli ):~
   type zsh
zsh is /usr/bin/zsh
#( 04/12/22@ 1:51PM )( cxxu@cxxuAli ):~
   /usr/bin/zsh --version
zsh 5.8.1 (x86_64-pc-linux-gnu)
```

