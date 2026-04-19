[toc]

## zsh 版本查看

- `zsh --version`

- ```bash
  ┌─[cxxu@ubt22] - [~] - [2024-04-10 02:38:02]
  └─[0] <> zsh --version
  zsh 5.8.1 (x86_64-ubuntu-linux-gnu)
  ```

  

## 安装zsh

### install zsh

- [Installing ZSH · ohmyzsh/ohmyzsh Wiki (github.com)](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)



#### 方案一(自动化)

- [Build Zsh from sources on Ubuntu (github.com)](https://gist.github.com/ptrv/1070757/7fa178a4fa954f9a8a0201ee8e7dfa5611812bb0)

- 上面获取zsh原码的方式可到官网下载压缩包解压来代替

```bash
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

- 我从5.4.1->5.8.1

```
#( 04/12/22@ 1:50PM )( cxxu@cxxuAli ):~
   type zsh
zsh is /usr/bin/zsh
#( 04/12/22@ 1:51PM )( cxxu@cxxuAli ):~
   /usr/bin/zsh --version
zsh 5.8.1 (x86_64-pc-linux-gnu)
```

