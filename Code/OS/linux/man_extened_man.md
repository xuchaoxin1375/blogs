# 获取完整的man(manpages)linux参考手册/中文man的下载和使用

- 默认安装的man(sudo apt install man)不能够涵盖所有命令
- 为了获得完整的手册,(来支持一些shell内建命令/posix命令);我们需要进行额外的按需安装

## 为man着色

- [How to Display man Pages in Color on Linux (howtogeek.com)](https://www.howtogeek.com/683134/how-to-display-man-pages-in-color-on-linux/)

- [How to View Colored Man Pages in Linux (tecmint.com)](https://www.tecmint.com/view-colored-man-pages-in-linux/)

  - 查看系统默认阅读器(pager):

    - `echo $PAGER`

      - ```bash
        # cxxu_kali @ CxxuWin11 in ~ [8:35:49]
        $ echo $PAGER
        less
        
        ```

      - 下载`most`阅读工具,并且将默认阅读器修改为`most`

        - ` export PAGER="most"`
        - 如果需要长期有效,那么可以将其写入配置文件(譬如 .bashrc)

  - 修改颜色变量(仍然使用less作为默认阅读器)

    - 关于颜色的参考

      - [terminal - Documentation on LESS_TERMCAP_* variables? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/108699/documentation-on-less-termcap-variables)
      - `man termcap`
      - `man terminfo`
      - `man terminal-colors.d`
      - `man dircolors`

    - ```bash
      man() {
          # LESS_TERMCAP_md=$'\e[01;31m' \
          # LESS_TERMCAP_me=$'\e[0m' \
          # LESS_TERMCAP_se=$'\e[0m' \
          # LESS_TERMCAP_so=$'\e[45;93m' \
          # LESS_TERMCAP_ue=$'\e[0m' \
          # LESS_TERMCAP_us=$'\e[01;32m' \
          export LESS_TERMCAP_mb=$'\e[1;32m'
          export LESS_TERMCAP_md=$'\e[01;31m'
          export LESS_TERMCAP_me=$'\e[0m'
          export LESS_TERMCAP_se=$'\e[0m'
          export LESS_TERMCAP_so=$'\e[45;93m'
          export LESS_TERMCAP_ue=$'\e[0m'
          export LESS_TERMCAP_us=$'\e[01;32m'
          command man "$@"
      }
      ```

    - >  可以将上述参数别名写入配置文件(譬如.bashrc)来永久生效

## linux 命令选项分类

- ```
          several kinds of options:
  
         1   UNIX options, which may be grouped and must be preceded by a dash.(单横杠选项)
         2   BSD options, which may be grouped and must not be used with a dash.(无横杠选项)
         3   GNU long options, which are preceded by two dashes.(双横杠选项)
  ```

  - 

## 搜索manpages 相关package

- `apt search manpages | more`
- `apt-cache search manpages`

## 安装扩展man

## references

- https://www.cyberciti.biz/faq/how-to-add-install-man-pages-on-ubuntu-linux/
- 在线可搜索文档[Linux man pages online (man7.org)](https://www.man7.org/linux/man-pages/index.html)
  - [Linux manual pages: all pages, by section (man7.org)](https://www.man7.org/linux/man-pages/dir_all_by_section.html)
  - [Linux manual pages: alphabetic list of all pages (man7.org)](https://www.man7.org/linux/man-pages/dir_all_alphabetic.html)

### man 分类

- `apt-cache search manpages | egrep 'manpages-(dev|posix)'`

  - ```
    # cxxu_kali @ CxxuWin11 in ~ [16:05:29]
    $ apt-cache search manpages | egrep 'manpages-(dev|posix)'
    manpages-dev - Manual pages about using GNU/Linux for development
    manpages-posix - Manual pages about using POSIX system
    manpages-posix-dev - Manual pages about using a POSIX system for development
    ```

### 安装manpages-posix

```bash
sudo apt update
#更新完源后,安装两个package:man-db 以及manpages-posix
sudo apt install man-db manpages-posix
```

#### 默认安装的man(manpages)手册工具包

```
# cxxu_kali @ CxxuWin11 in ~ [16:18:09]
$ apt info manpages
Package: manpages
Version: 5.10-1
Priority: standard
Section: doc
Maintainer: Dr. Tobias Quathamer <toddy@debian.org>
Installed-Size: 1,709 kB
Suggests: man-browser
Breaks: attr (<< 1:2.4.47-3), keyutils (<< 1.6-1), manpages-dev (<< 5.09-2)
Replaces: attr (<< 1:2.4.47-3), keyutils (<< 1.6-1), manpages-dev (<< 5.09-2)
Homepage: https://www.kernel.org/doc/man-pages/
Tag: made-of::man, role::documentation
Download-Size: 1,412 kB
APT-Manual-Installed: no
APT-Sources: http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling/main amd64 Packages

# 该工具包是linux系统的使用手册
Description: Manual pages about using a GNU/Linux system
 This package contains GNU/Linux manual pages for these sections:
  4 = Devices (e.g. hd, sd).
  5 = File formats and protocols, syntaxes of several system
      files (e.g. wtmp, /etc/passwd, nfs).
  7 = Conventions and standards, macro packages, etc.
      (e.g. nroff, ascii).
 .
 Sections 1, 6 and 8 are provided by the respective applications. This
 package only includes the intro man page describing the section.
 .
 The man pages describe syntaxes of several system files.

```

#### 该manPage的description

- `apt info manpages-posix`
- 如下描述可见,其适用范围比linux更广(可以用在满足posix标准规范的操作系统上(unix/linux/macOs))

```
...
Description: Manual pages about using POSIX system
 This package contains manual pages for POSIX utilities
 and keeps them in section 1 (with 1posix extension) of the
 on-line manual.

```

### 安装中文man(manpages-zh)

- `sudo apt install manpages-zh`

#### 检查安装

查看路径 `cd /usr/share/man/zh_CN`

```
# cxxu_kali @ CxxuWin11 in ~ [16:30:06] C:130
$ cd /usr/share/man/zh_CN

# cxxu_kali @ CxxuWin11 in /usr/share/man/zh_CN [16:30:13]
$ ls
man1  man2  man3  man4  man5  man6  man7  man8

# cxxu_kali @ CxxuWin11 in /usr/share/man/zh_CN [16:30:15]
$

```

#### 利用man来检索内容中文man(manpages-zh)

- `man -M /usr/share/man/zh_CN <keyword>`
  - 譬如检索中文ls 文档 ` man -M /usr/share/man/zh_CN ls`

#### 配置中文man别名

> 可以将中文man 配置别名 `cman`或者自己喜欢的名字

- ```
  # cxxu_kali @ CxxuWin11 in /usr/share/man/zh_CN [16:33:44]
  $ alias cman=" man -M /usr/share/man/zh_CN "
  #体验简写
  # cxxu_kali @ CxxuWin11 in /usr/share/man/zh_CN [16:34:36]
  $ cman ls
  ```
