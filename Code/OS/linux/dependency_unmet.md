@[toc]

# ubuntu_apt install安装某些软件包出现的大量的依赖包版本不满足条件的问题(以ssh服务的安装为例)/软件包安装状态检查

##  问题案例

```bash
#( 08/20/21@ 6:13AM )( cxxu@ubuntu ):~
   sudo apt install openssh-server 
[sudo] password for cxxu: 
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 libbsd0:i386 : Depends: libc6:i386 (>= 2.25) but it is not installable
 libcbor0.6:i386 : Depends: libc6:i386 (>= 2.4) but it is not installable
 libcom-err2:i386 : Depends: libc6:i386 (>= 2.28) but it is not installable
 libedit2:i386 : Depends: libc6:i386 (>= 2.28) but it is not installable
 libfido2-1:i386 : Depends: libc6:i386 (>= 2.25) but it is not installable
 libgssapi-krb5-2:i386 : Depends: libc6:i386 (>= 2.27) but it is not installable
 libk5crypto3:i386 : Depends: libc6:i386 (>= 2.28) but it is not installable
 libkeyutils1:i386 : Depends: libc6:i386 (>= 2.7) but it is not installable
 libkrb5-3:i386 : Depends: libc6:i386 (>= 2.28) but it is not installable
 libkrb5support0:i386 : Depends: libc6:i386 (>= 2.8) but it is not installable
 libssl1.1:i386 : Depends: libc6:i386 (>= 2.28) but it is not installable
 libtinfo6:i386 : Depends: libc6:i386 (>= 2.16) but it is not installable
 libtirpc3 : Depends: libgssapi-krb5-2 (>= 1.17) but it is not installable
 libudev1:i386 : Depends: libc6:i386 (>= 2.30) but it is not installable
 openssh-client:i386 : Depends: dpkg:i386 (>= 1.7.0)
                       Depends: libc6:i386 (>= 2.28) but it is not installable
                       Depends: libselinux1:i386 (>= 1.32) but it is not installable
                       Recommends: xauth:i386
 openssh-server : Depends: dpkg (>= 1.9.0)
                  Depends: openssh-sftp-server
                  Depends: procps
                  Depends: libcom-err2 (>= 1.43.9) but it is not installable
                  Depends: libgssapi-krb5-2 (>= 1.17) but it is not installable
                  Depends: libkrb5-3 (>= 1.13~alpha1+dfsg) but it is not installable
                  Depends: libssl1.1 (>= 1.1.1) but it is not installable
                  Depends: zlib1g (>= 1:1.1.4) but it is not installable
                  Recommends: default-logind or
                              logind or
                              libpam-systemd but it is not going to be installed
                  Recommends: xauth
                  Recommends: ssh-import-id but it is not going to be installed
 perl-base : PreDepends: dpkg (>= 1.17.17)
 zlib1g:i386 : Depends: libc6:i386 (>= 2.4) but it is not installable
E: Unable to correct problems, you have held broken packages.

```
##  排查/解决

- 一般是所要安装的软件包依赖其他软件,同时该软件已经安装,但是版本不满足当前所要安装软件的依赖,
- 可以考虑将当前的被依赖包卸载,然后在执行当前包的安装

### apt-cache 包检查

` sudo apt-cache policy <packageName>`

###  检查openssh-server/openssh-client的安装情况

- > 对比openssh-client 和openssh-server的版本

- `sudo apt-cache policy openssh-client openssh-server`
  - 发现,目前时client以经安装,但是server还没有安装(意味着该主机无法被ssh连接)

```bash
#( 08/20/21@10:56PM )( cxxu@ubuntu ):~
   sudo apt-cache policy openssh-client openssh-server
openssh-client:
  Installed: 1:8.4p1-5ubuntu1
  Candidate: 1:8.4p1-5ubuntu1
  Version table:
 *** 1:8.4p1-5ubuntu1 100
        100 /var/lib/dpkg/status
     1:8.2p1-4ubuntu0.3 500
        500 http://mirrors.aliyun.com/ubuntu focal-updates/main amd64 Packages
     1:8.2p1-4ubuntu0.2 500
        500 http://mirrors.aliyun.com/ubuntu focal-security/main amd64 Packages
     1:8.2p1-4 500
        500 http://mirrors.aliyun.com/ubuntu focal/main amd64 Packages
        
        
openssh-server:
  Installed: (none)
  Candidate: 1:8.2p1-4ubuntu0.3
  Version table:
     1:8.2p1-4ubuntu0.3 500
        500 http://mirrors.aliyun.com/ubuntu focal-updates/main amd64 Packages
     1:8.2p1-4ubuntu0.2 500
        500 http://mirrors.aliyun.com/ubuntu focal-security/main amd64 Packages
     1:8.2p1-4 500
        500 http://mirrors.aliyun.com/ubuntu focal/main amd64 Packages

```
###  卸载已有的openssh-client:

`sudo apt remove openssh-client  `

###  重新尝试

`	 sudo apt install openssh-server
`

###  重新检查安装情况

```bash
#( 08/20/21@11:14PM )( cxxu@ubuntu ):~
   sudo apt-cache policy openssh-client openssh-server
openssh-client:
  Installed: 1:8.2p1-4ubuntu0.3
  Candidate: 1:8.2p1-4ubuntu0.3
  Version table:
 *** 1:8.2p1-4ubuntu0.3 500
        500 http://mirrors.aliyun.com/ubuntu focal-updates/main amd64 Packages
        100 /var/lib/dpkg/status
     1:8.2p1-4ubuntu0.2 500
        500 http://mirrors.aliyun.com/ubuntu focal-security/main amd64 Packages
     1:8.2p1-4 500
        500 http://mirrors.aliyun.com/ubuntu focal/main amd64 Packages
openssh-server:
  Installed: 1:8.2p1-4ubuntu0.3
  Candidate: 1:8.2p1-4ubuntu0.3
  Version table:
 *** 1:8.2p1-4ubuntu0.3 500
        500 http://mirrors.aliyun.com/ubuntu focal-updates/main amd64 Packages
        100 /var/lib/dpkg/status
     1:8.2p1-4ubuntu0.2 500
        500 http://mirrors.aliyun.com/ubuntu focal-security/main amd64 Packages
     1:8.2p1-4 500
        500 http://mirrors.aliyun.com/ubuntu focal/main amd64 Packages
````
从installled可知,版本匹配上了.

## 使用aptitude 工具来解决依赖问题

### references

- [ubuntu - How do I resolve `The following packages have unmet dependencies` - Stack Overflow](https://stackoverflow.com/questions/26571326/how-do-i-resolve-the-following-packages-have-unmet-dependencies)

### 安装aptitude工具

- `sudo apt-get install aptitude`

### 使用aptitude安装指定包

- `sudo aptitude install <package-name>`





