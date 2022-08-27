[toc]

# linux_status_process/threads_checker:htop&ps&glances内核信息/进程信息/线程信息/硬件信息查看

## 查看发行版和内核版本号相关主题命令

### 查看自己的发行版以及版本号(系统自带工具查看)

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

### 内核号

- `uname -a`
- `cat /proc/version`

```bash
 cat /proc/version
Linux version 4.15.0-169-generic (buildd@lcy02-amd64-015) (gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)) #177-Ubuntu SMP Thu Feb 3 10:50:38 UTC 2022
```
### 发行版相关主题

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
##  其他工具包
###  系统信息查看
- `sudo apt install neofetch`
![在这里插入图片描述](https://img-blog.csdnimg.cn/7b079b116e7a462c9212731f044bab8d.png)
###  动态信息查看(进程/网络/ip)
####  综合系统状态信息glances
- `sudo apt install glances`
![在这里插入图片描述](https://img-blog.csdnimg.cn/7f8423b6ba1940c495551d2fc88cbe19.png)

###  动态进程/线程查看/管理工具htop

#### 安装和使用htop

- `sudo apt install htop`

- 获取帮助(输入`h`)
	- > 空格分割等效按键
	
- 例如,
    - `F6`
    - `>`
    - `.`
    
- 效果一样(选择列排序)
	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/92db1db1fc874a39afd5ec1855a0f476.png)

## 查看线程

- [htop & ps | Baeldung on Linux](https://www.baeldung.com/linux/htop-ps-more-processes#why-the-number-of-processes-is-different)

> htop显示的进程数量更多(htop会将线程一并显示!)
>
> - It turns out that both *htop* and *ps* read the details about the number of the running processes and threads from the [*/proc*](https://man7.org/linux/man-pages/man5/proc.5.html) filesystem. 
>   - More specifically, the */proc/<pid>* directory and the subdirectories */proc/<pid>/task/<tid>* found underneath.
>
> - Let's list and count the subdirectories under */proc/<pid>/task/,* replacing *<pid>* with the running MariaDB Server *PID*:

- [Why Does htop Show More Processes Than ps | Baeldung on Linux](https://www.baeldung.com/linux/htop-ps-more-processes#why-the-number-of-processes-is-different)

  - ```
    # cxxu @ cxxuAli in ~ [9:22:49]
    $ ls /proc/$(pidof mysqld)/task
    10749  14460  1553  1563  1571  1577  1582  1600  1604  2049   24547  30455
    10750  1537   1554  1564  1572  1578  1583  1601  1605  2088   27182
    12323  1551   1557  1565  1573  1579  1598  1602  1607  22668  27187
    12407  1552   1562  1566  1576  1581  1599  1603  1608  23739  27938
    
    # cxxu @ cxxuAli in ~ [9:22:50]
    $  ls -1 /proc/$(pidof mysqld)/task | wc -l
    45
    
    ```

- > We deduce from the above output that, **unlike \*ps\***, **the \*htop\* command displays the running processes and their corresponding individual threads by default**.
  >
  > *htop* was designed to provide as much information as possible about what's going on in the system. As a result, it displays the user threads instead of hiding them. For example, system administrators can spot a problem in a multithreaded application while monitoring the CPU usage of its related threads. Yet, some Linux users prefer to disable this setting as they find it less useful to show all the threads in the *htop* output.

### hotp: Threads Using  htop

In Linux, we have user-space and kernel-space [threads](https://www.baeldung.com/linux/process-vs-thread). The user threads are associated with a user application, and the kernel threads are created and managed by the OS.

htop, by default, displays the user threads and hides the kernel threads**. Next, let's check how we can modify this behavior.

![在这里插入图片描述](https://img-blog.csdnimg.cn/60ba603a9463433ba67d15e85d35d3b3.png)

### ps -L 查看线程

- ![image-20220429101949568](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220429101949568.png)

- ```bash
  UID        PID  PPID   LWP  C NLWP STIME TTY          TIME CMD
  ┌─[cxxu@cxxuAli] - [~] - [2022-04-29 10:23:13]
  └─[1] <> ps -fL -C mysqld
  UID        PID  PPID   LWP  C NLWP STIME TTY          TIME CMD
  mysql     1537   757  1537  0   45 Apr11 ?        00:00:00 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --
  mysql     1537   757  1551  0   45 Apr11 ?        00:00:00 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --
  mysql     1537   757  1552  0   45 Apr11 ?        00:00:00 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --
  mysql     1537   757  1553  0   45 Apr11 ?        00:00:00 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --
  mysql     1537   757  1554  0   45 Apr11 ?        00:00:00 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --
  mysql     1537   757  1557  0   45 Apr11 ?        00:00:31 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --
  mysql     1537   757  1562  0   45 Apr11 ?        00:00:21 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --
  mysql     1537   757  1563  0   45 Apr11 ?        00:02:04 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --
  mysql     1537   757  1564  0   45 Apr11 ?        00:02:04 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --
  mysql     1537   757  1565  0   45 Apr11 ?        00:02:11 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --
  ```

- 可以搭配`|grep`使用

  - `ps -C 不支持通配符`
