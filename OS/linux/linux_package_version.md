# linux_软件包版本查看/软件包可用版本列表/安装指定版本

## references

- [software installation - How to install specific version of some package? - Ask Ubuntu](https://askubuntu.com/questions/428772/how-to-install-specific-version-of-some-package)
- [exa-linux-x86_64-musl-v0.10.1.zip](https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-musl-v0.10.1.zip)

### apt-cache & version table

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
###  显示包的详细信息

####  `apt show`显示包详细信息
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
           See dpkg-query(1) for more information about the following actions, and other
           actions and options not exposed by the dpkg front-end.

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

### 获取deb软件包文件的信息
- [reference link][dpkg examples]
  
[dpkg examples]: https://www.golinuxcloud.com/dpkg-command-in-linux/#7_dpkg_command_to_get_the_information_of_deb_package "dpkg command to get the information of deb package"
