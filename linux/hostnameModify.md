
## references


## hostname相关命令
想要了解更多,以下命令是相关主题
`apropos hostname`

```bash
root@cxxuAli:~# apropos hostname
freehostent (3)      - get network hostnames and addresses
gethostname (2)      - get/set hostname
getipnodebyaddr (3)  - get network hostnames and addresses
getipnodebyname (3)  - get network hostnames and addresses
hostname (1)         - show or set the system's host name
hostname (5)         - Local hostname configuration file
hostname (7)         - hostname resolution description
hostnamectl (1)      - Control the system hostname
hosts (5)            - static table lookup for hostnames
sethostname (2)      - get/set hostname
ssh-argv0 (1)        - replaces the old ssh command-name as hostname handling
Sys::Hostname::Long (3pm) - Try every conceivable way to get full hostname
systemd-hostnamed (8) - Host name bus mechanism
systemd-hostnamed.service (8) - Host name bus mechanism

root@cxxuAli:~# whatis hostname
hostname (1)         - show or set the system's host name
hostname (5)         - Local hostname configuration file
hostname (7)         - hostname resolution description
root@cxxuAli:~# whereis hostname
hostname: /bin/hostname /etc/hostname /usr/share/man/man1/hostname.1.gz /usr/share/man/man5/hostname.5.gz /usr/share/man/man7/hostname.7.gz
root@cxxuAli:~# which hostname
/bin/hostname
root@cxxuAli:~# man 5 hostname


```

## 本次会话有效的临时修改

```bash

root@cxxuAli:~# hostname testNew
root@cxxuAli:~# hostname
testNew
root@cxxuAli:~#
#可以看到,这种修改会临时变更hostname的返回值,但是提示符上的主机名仍然是旧的主机名

```

## 长期有效的修改
### 使用 hostnamectl
```bash
HOSTNAMECTL(1)                                                                      hostnamectl                                                                     HOSTNAMECTL(1)

NAME
       hostnamectl - Control the system hostname

SYNOPSIS
       hostnamectl [OPTIONS...] {COMMAND}

DESCRIPTION
       hostnamectl may be used to query and change the system hostname and related settings.

       This tool distinguishes three different hostnames: the high-level "pretty" hostname which might include all kinds of special characters (e.g. "Lennart's Laptop"), the
       static hostname which is used to initialize the kernel hostname at boot (e.g. "lennarts-laptop"), and the transient hostname which is a fallback value received from
       network configuration. If a static hostname is set, and is valid (something other than localhost), then the transient hostname is not used.

       Note that the pretty hostname has little restrictions on the characters and length used, while the static and transient hostnames are limited to the usually accepted
       characters of Internet domain names, and 64 characters at maximum (the latter being a Linux limitation).

       The static hostname is stored in /etc/hostname, see hostname(5) for more information. The pretty hostname, chassis type, and icon name are stored in /etc/machine-info, see
       machine-info(5).

       Use systemd-firstboot(1) to initialize the system host name for mounted (but not booted) system images.
```
### hostnamectl set-hostname选项
>该选项可以修改三个方面的`hostname`
```bash

  set-hostname NAME
           Set the system hostname to NAME. By default, this will alter the pretty, the static, and the transient hostname alike; however, if one or more of --static,
           --transient, --pretty are used, only the selected hostnames are changed. If the pretty hostname is being set, and static or transient are being set as well, the
           specified hostname will be simplified in regards to the character set used before the latter are updated. This is done by removing special characters and spaces. This
           ensures that the pretty and the static hostname are always closely related while still following the validity rules of the specific name. This simplification of the
           hostname string is not done if only the transient and/or static host names are set, and the pretty host name is left untouched.

```
#### syntax

```bash
hostnamectl set-hostname YourNewHostname
```

### 手动修改配置/etc/hostname文件
> 该做法修改`static hostname`
```bash

root@cxxuAli:~# sudo tee /etc/hostname
cxxuAli(输入新主机名)
cxxuAli
##  重启
```
`sudo reboot`

# 检查修改
```bash
root@cxxuAli:~# nl /etc/hostname
     1  cxxuAli
```
