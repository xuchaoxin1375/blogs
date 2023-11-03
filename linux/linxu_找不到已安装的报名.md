[toc]

@[toc]

# linux_apt/apt-cache/dpkg:软件包版本查看/软件包可用版本列表/安装指定版本/查找已安装的包的调用名称/已安装包的二进制可执行文件位置

## references

- [software installation - How to install specific version of some package? - Ask Ubuntu](https://askubuntu.com/questions/428772/how-to-install-specific-version-of-some-package)

## 显示包的详细信息

### apt-cache & version table

#### apt-cache policy

- `sudo apt-cache policy <packageName>`

```
#( 04/13/22@ 2:25PM )( cxxu@u12 ):~
   sudo apt-cache policy firefox
firefox:
  Installed: 31.0+build1-0ubuntu0.12.04.1
  Candidate: 66.0.3+build1-0ubuntu0.14.04.1
  Version table:
     66.0.3+build1-0ubuntu0.14.04.1 0
        500 http://mirrors.163.com/ubuntu/ trusty-security/main i386 Packages
        500 http://mirrors.163.com/ubuntu/ trusty-updates/main i386 Packages
 *** 31.0+build1-0ubuntu0.12.04.1 0
        100 /var/lib/dpkg/status
     28.0+build2-0ubuntu2 0
        500 http://mirrors.163.com/ubuntu/ trusty/main i386 Packages
```

- 可见 version table列出了可选择的版本(三个)

- 我们可以安装可用的版本

  - 先复制版本号,粘贴`sudo apt install firefox=66.0.3+build1-0ubuntu0.14.04.1`

  - ```
    #( 04/13/22@ 3:11PM )( cxxu@u12 ):~
       sudo apt install firefox=66.0.3+build1-0ubuntu0.14.04.1
    Reading package lists... Done
    ```

#### 检查安装后的相关软件列表

- `sudo apt list --installed|grep <packageName>`

```
#( 04/13/22@ 3:15PM )( cxxu@u12 ):~
   sudo apt list --installed|grep firefox

WARNING: apt does not have a stable CLI interface yet. Use with caution in scripts.

firefox/trusty-security,trusty-updates,now 66.0.3+build1-0ubuntu0.14.04.1 i386 [installed]
firefox-gnome-support/now 22.0+build2-0ubuntu0.12.04.2 i386 [installed,local]
firefox-locale-en/now 31.0+build1-0ubuntu0.12.04.1 i386 [installed,upgradable to: 66.0.3+build1-0ubuntu0.14.04.1]

```

#### 检查方式2: `dpkg -l`

```
#( 04/13/22@ 3:20PM )( cxxu@u12 ):~
   dpkg -l firefox*
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name             Version       Architecture  Description
+++-================-=============-=============-======================================
ii  firefox          66.0.3+build1 i386          Safe and easy web browser from Mozilla
ii  firefox-gnome-su 22.0+build2-0 i386          Safe and easy web browser from Mozilla
ii  firefox-locale-e 31.0+build1-0 i386          English language pack for Firefox
un  firefox-ubufox   <none>        <none>        (no description available)
```


####  apt show:显示包详细信息
```bash
┌─[cxxu@CxxuWin11] - [/mnt/d/repos/blogs] - [2022-05-05 12:43:09]
└─[0] <git:(main 7b33a7b✗✱✈) > apt show exa
Package: exa
Version: 0.10.1-2
Built-Using: rustc (= 1.54.0+dfsg1-3)
Priority: optional
Section: utils
Source: rust-exa
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Installed-Size: 867 kB
Depends: libc6 (>= 2.32), libgcc-s1 (>= 4.2)
Homepage: https://the.exa.website/
X-Cargo-Built-Using: rust-ansi-term (= 0.12.1-1), rust-byteorder (= 1.4.3-2), rust-cfg-if-0.1 (= 0.1.10-2), rust-datetime (= 0.5.2-5), rust-glob (= 0.3.0-1), rust-lazy-static (= 1.4.0-1), rust-libc (= 0.2.103-1), rust-locale (= 0.2.2-1), rust-log (= 0.4.11-2), rust-natord (= 1.0.9-1), rust-num-cpus (= 1.13.0-1), rust-number-prefix (= 0.4.0-1), rust-pad (= 0.1.6-1), rust-scoped-threadpool (= 0.1.9-1), rust-term-grid (= 0.1.7-1), rust-term-size (= 0.3.1-2), rust-unicode-width (= 0.1.8-1), rust-users (= 0.11.0-1), rust-zoneinfo-compiled (= 0.5.1-2), rustc (= 1.54.0+dfsg1-3)
Download-Size: 297 kB
APT-Manual-Installed: yes
APT-Sources: http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling/main amd64 Packages
Description: Modern replacement for ls
 exa is an improved file lister with more features and better defaults.
 It uses colours to distinguish file types and metadata. It knows about
 symlinks, extended attributes, and Git. And it’s small, fast, and just
 one single binary.
```
####  dpkg -s (dpkg-query)
>  dpkg-query actions
>         See dpkg-query(1) for more information about the following actions, and other
>         actions and options not exposed by the dpkg front-end.

           -l, --list package-name-pattern...
               List packages matching given pattern.
    
           -s, --status package-name...
               Report status of specified package.
    
           -L, --listfiles package-name...
               List files installed to your system from package-name.
    
           -S, --search filename-search-pattern...
               Search for a filename from installed packages.
    
           -p, --print-avail package-name...
               Display details about package-name, as found in /var/lib/dpkg/available.
               Users of APT-based frontends should use apt show package-name instead.

##### dpkg -s 示例
```bash
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-05-05 12:45:03]
└─[0] <> dpkg -s exa
Package: exa
Status: install ok installed
Priority: optional
Section: utils
Installed-Size: 847
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Architecture: amd64
Multi-Arch: allowed
Source: rust-exa
Version: 0.10.1-2
Depends: libc6 (>= 2.32), libgcc-s1 (>= 4.2)
Description: Modern replacement for ls
 exa is an improved file lister with more features and better defaults.
 It uses colours to distinguish file types and metadata. It knows about
 symlinks, extended attributes, and Git. And it’s small, fast, and just
 one single binary.
Built-Using: rustc (= 1.54.0+dfsg1-3)
Homepage: https://the.exa.website/
X-Cargo-Built-Using: rust-ansi-term (= 0.12.1-1), rust-byteorder (= 1.4.3-2), rust-cfg-if-0.1 (= 0.1.10-2), rust-datetime (= 0.5.2-5), rust-glob (= 0.3.0-1), rust-lazy-static (= 1.4.0-1), rust-libc (= 0.2.103-1), rust-locale (= 0.2.2-1), rust-log (= 0.4.11-2), rust-natord (= 1.0.9-1), rust-num-cpus (= 1.13.0-1), rust-number-prefix (= 0.4.0-1), rust-pad (= 0.1.6-1), rust-scoped-threadpool (= 0.1.9-1), rust-term-grid (= 0.1.7-1), rust-term-size (= 0.3.1-2), rust-unicode-width (= 0.1.8-1), rust-users (= 0.11.0-1), rust-zoneinfo-compiled (= 0.5.1-2), rustc (= 1.54.0+dfsg1-3)
```

### 获取deb软件包文件的信息(dpkg --info)
- [reference link][dpkg examples]
  

[dpkg examples]: https://www.golinuxcloud.com/dpkg-command-in-linux/#7_dpkg_command_to_get_the_information_of_deb_package "dpkg command to get the information of deb package"

# linxu_找不到已安装的包/查找已安装的包的调用名称

> - 有些时候,我们apt 包管理工具安装名字和调用名字不同
> - 有若干方法可以查出来调用名

### whatis -w:通配符方案

#### 通配符搜索安装完毕的7zip可执行文件

```bash
#( 05/10/22@ 1:08PM )( cxxu@CxxuWin11 ):~
   whatis -w 7*
7zz (1)              - 7-Zip file archiver with a high compression ratio
```

### 根据安装时的名称搜索

- 我们利用前面说的`apt show <packageName>`来查找到该包的描述
- 然后利用`apropos '<description>'`来根据包的描述反向查找

例如,我通过`sudo apt install 7zip`安装了7zip工具

- 然而,7zip不是可执行文件的名字

- 我通apt对已安装过的包:7zip查询其详情

- 得到描述

- ```bash
  #( 05/10/22@ 1:10PM )( cxxu@CxxuWin11 ):~
     apt show 7zip
  [sudo] password for cxxu:
  Package: 7zip
  Version: 21.07+dfsg-4
  Priority: optional
  Section: utils
  Maintainer: YOKOTA Hiroshi <yokota.hgml@gmail.com>
  Installed-Size: 2,449 kB
  Depends: libc6 (>= 2.33), libgcc-s1 (>= 3.0), libstdc++6 (>= 5)
  Homepage: https://www.7-zip.org/
  Download-Size: 889 kB
  APT-Manual-Installed: yes
  APT-Sources: http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling/main amd64 Packages
  
  Description: 7-Zip file archiver with a high compression ratio
   7-Zip is a file archiver with a high compression ratio. The main features
   of 7-Zip are:
    * High compression ratio in 7z format with LZMA and LZMA2 compression
  ```

- 看到简短的功能描述`7-Zip file archiver with a high compression ratio`

- 配合`apropos`进行查找:

  - ```bash
    ┌─[cxxu@CxxuWin11] - [~] - [2022-05-10 01:17:22]
    └─[130] <> apropos '7-Zip file archiver with a high compression ratio'
    7zz (1)              - 7-Zip file archiver with a high compression ratio
    ```

    查出可执行文件名称为`7zz`

  - `whereis 7zz`

    - ```bash
      ┌─[cxxu@CxxuWin11] - [~] - [2022-05-10 01:17:29]
      └─[0] <> whereis 7zz
      7zz: /usr/bin/7zz /usr/share/man/man1/7zz.1.gz
      ```

    - 