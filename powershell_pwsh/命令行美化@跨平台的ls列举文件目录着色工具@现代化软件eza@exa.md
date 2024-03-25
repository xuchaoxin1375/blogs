[toc]

## abstract

- **eza** is a modern, maintained replacement for the venerable file-listing command-line program `ls` that ships with Unix and Linux operating systems, giving it more features and better defaults. It uses colours to distinguish file types and metadata. It knows about symlinks, extended attributes, and Git. And it’s **small**, **fast**, and just **one single binary**.

  By deliberately making some decisions differently, eza attempts to be a more featureful, more user-friendly version of `ls`.

## eza项目地址

- [eza-community/eza: A modern, maintained replacement for ls (github.com)](https://github.com/eza-community/eza)
  - 是exa的后继项目

## 下载和安装

- [eza/INSTALL.md at main · eza-community/eza (github.com)](https://github.com/eza-community/eza/blob/main/INSTALL.md)

### linux

#### refs

- [Rust 下载安装加速指南  (zhihu.com)](https://zhuanlan.zhihu.com/p/126201430)

- [linux - How do I fix the Rust error "linker 'cc' not found" for Debian on Windows 10? - Stack Overflow](https://stackoverflow.com/questions/52445961/how-do-i-fix-the-rust-error-linker-cc-not-found-for-debian-on-windows-10)

### Notes

- linux不同发行版可以有不同的安装方法
- 其中Cargo是通用的linux安装方式,但是需要提前安装Rust Cargo 环境

### FAQ

- 对于deb/ubuntu系的,先预备安装`sudo apt install build-essential`,以免后续编译失败

- 安装Cargo的时候先设置两个环境变量换为国内源加速:

  - ```bash
    export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
    export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
    ```

- 详情查看上述refs中的第一个链接

## windows

- 安装比较简单,使用winget,scoop 都可以(可能需要代理)

## 效果👺

- ```powershell
  PS>eza --icons -ghilTL 2
  Mode  Size Date Modified Name
  d----    - 18 Mar 19:34   .
  -a--- 331k 18 Mar 18:59  ├──  20240318_185950.mp4
  -a--- 1.2M 18 Mar 19:10  ├──  20240318_191010.mp4
  d----    - 10 Mar 23:22  ├──  ansel
  d-r--    - 18 Mar 19:34  ├── 󰉌 Contacts
  d-r--    - 18 Mar 19:36  ├──  Desktop
  -a--- 1.4k 17 Jan 10:31  │  ├──  blogs_home.lnk
  -a--- 1.4k 19 Jan 14:15  │  ├──  EM.lnk
  -a--- 1.4k 19 Jan 14:14  │  ├──  math.lnk
  -a--- 1.4k 17 Jan 10:33  │  ├──  neep.lnk
  -a---  44k 15 Mar 20:13  │  └──  四边形加固为刚性结构.ggb
  d-r--    - 18 Mar 19:34  ├──  Documents
  d----    - 18 Mar 18:22  │  ├──  Apowersoft
  d----    - 18 Mar 18:03  │  ├──  Captura
  ```

  

- ```bash
  /mnt/c/Users/cxxu/Desktop  $ eza --icons -ghilTL 2                   
             inode Permissions Size User    Group   Date Modified Name
  1125899907235745 drwxrwxrwx     - ubtcxxu ubtcxxu 18 Mar 19:36   .
   281474976901038 .rwxrwxrwx  1.4k ubtcxxu ubtcxxu 17 Jan 10:31  ├──  blogs_home.lnk
   844424930203848 .rwxrwxrwx   282 ubtcxxu ubtcxxu 18 Mar 19:34  ├──  desktop.ini
   281474976901039 .rwxrwxrwx  1.4k ubtcxxu ubtcxxu 19 Jan 14:15  ├──  EM.lnk
   281474976901040 .rwxrwxrwx  1.4k ubtcxxu ubtcxxu 19 Jan 14:14  ├──  math.lnk
   281474976901041 .rwxrwxrwx  1.4k ubtcxxu ubtcxxu 17 Jan 10:33  ├──  nee
  ```

## 其他项目

### exa(deprecated)

- [How to install and use Exa, a modern replacement for the ls command in Ubuntu 16.04 | Our Code World](https://ourcodeworld.com/articles/read/832/how-to-install-and-use-exa-a-modern-replacement-for-the-ls-command-in-ubuntu-16-04)

  - 快速安装

- [Install exa on Ubuntu 20.04 | Lindevs](https://lindevs.com/install-exa-on-ubuntu/)

  - 本方案更加完整:(安装+清理+卸载)


#### 较新版本的linux发行版上安装exa

- `sudo apt install exa`
  - 譬如 ubuntu 21/kali rolling

#### 安装流程(手动通用安装:包括较老版本)

```bash
curl https://sh.rustup.rs -sSf | sh

# Till the date of publication of this article, the latest available download version is the 0.8.0

wget -c https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
#upzip the tool
unzip exa-linux-x86_64-0.8.0.zip

# Move the unziped binary with the name "exa-linux-x86_64" to "/usr/local/bin/" with the exa name
# so that we can use the program name`exa`directly
sudo mv exa-linux-x86_64 /usr/local/bin/exa
```
###  ls-icons
- [sebastiencs/ls-icons: ls command with files icons (github.com)](https://github.com/sebastiencs/ls-icons)
  - 这个开源工具安装比较麻烦
    - 需要许多依赖
    - 对网络环境要求较高(耗时)
- [athityakumar/colorls: A Ruby gem that beautifies the terminal's ls command, with color and font-awesome icons. (github.com)](https://github.com/athityakumar/colorls#installation)
  - 老牌项目,需要ruby/字体 等依赖
  - 注意ruby版本



### powershell上的其他ls美化工具

- [powershell@Get-ChildItem美化@ls文件列表文件图标样式和配色@Terminal-icons.md_powershell ls 着色-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/120933098)



