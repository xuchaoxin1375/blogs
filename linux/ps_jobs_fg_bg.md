 

@[toc]
# linux_任务/进程管理/进程查看/服务查看ps/进程前后台切换(jobs/bg/fg/ps)

## reference

- [Linux / Unix: fg Command Examples - nixCraft (cyberciti.biz)](https://www.cyberciti.biz/faq/unix-linux-fg-command-examples-usage-syntax/)
- [HowTo: Use ps, kill, nice, and killall To Manage processes in FreeBSD and OS X Unix Operating System - nixCraft (cyberciti.biz)](https://www.cyberciti.biz/faq/howto-use-ps-kill-nice-killall-to-manage-processes-in-freebsd-unix/)
- [Linux and Unix ps command tutorial with examples | George Ornbo (shapeshed.com)](https://shapeshed.com/unix-ps/)
- [How to use the bg command in Linux? - LinuxForDevices](https://www.linuxfordevices.com/tutorials/linux/bg-command-in-linux)
- [shell - Include header in the 'grep' result - Stack Overflow](https://stackoverflow.com/questions/12920317/include-header-in-the-grep-result)

### 总览

- [Linux Process Management | Five Types of Process in Linux Management (educba.com)](https://www.educba.com/linux-process-management/)

## 进程查看ps

> ps 命令用法众多,是一个复杂命令,此处仅涉及基本用法
>
> - 有特别需求的用google搜一下
> - 常用的就一小部分
>
> - `man ps`

#### man列出的表格表头解释

> - `STANDARD FORMAT SPECIFIERS`
>
> - ```
>    man ps|grep 'STANDARD FORMAT SPECIFIERS' -n
>   231:              The recognized keywords are described in the STANDARD FORMAT SPECIFIERS section below.  Headers may be renamed (ps -o pid,ruser=RealUser -o comm=Command) as desired.
>   280:       k spec Specify sorting order.  Sorting syntax is [+|-]key[,[+|-]key[,...]].  Choose a multi-letter key from the STANDARD FORMAT SPECIFIERS section.  The "+" is optional since
>   312:              Specify sorting order.  Sorting syntax is [+|-]key[,[+|-]key[,...]].  Choose a multi-letter key from the STANDARD FORMAT SPECIFIERS section.  The "+" is optional since
>   449:STANDARD FORMAT SPECIFIERS
>      
>   ```
>
> - 大致在第449行;使用`449G`指令可以快速跳转

#### 进程状态码取值含义(两种风格)

```
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process:

               D    uninterruptible sleep (usually IO)
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group
```



> ps命令自带使用示例以及说明
>
> -        This version of ps accepts several kinds of options:
>       
>          1   UNIX options, which may be grouped and must be preceded by a dash.
>          2   BSD options, which may be grouped and must not be used with a dash.
>          3   GNU long options, which are preceded by two dashes.
>
> - 从中可以得知,ps 的选项的形式是多样的(三类)
>
>   > - Options of different types may be freely mixed, but conflicts can appear.  
>   > - There are some synonymous options, which are functionally identical,
>   > -  due to the many standards and   ps implementations that this ps is compatible with.
>
> - 不同风格的参数效果可能是一样的

```
EXAMPLES
       To see every process on the system using standard syntax:
          ps -e
          ps -ef
          ps -eF
          ps -ely

       To see every process on the system using BSD syntax:
          ps ax
          ps axu

       To print a process tree:
          ps -ejH
          ps axjf

       To get info about threads:
          ps -eLf
          ps axms

       To get security info:
          ps -eo euser,ruser,suser,fuser,f,comm,label
          ps axZ
          ps -eM

       To see every process running as root (real & effective ID) in user format:
          ps -U root -u root u

       To see every process with a user-defined format:
          ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm
          ps axo stat,euid,ruid,tty,tpgid,sess,pgrp,ppid,pid,pcpu,comm
          ps -Ao pid,tt,user,fname,tmout,f,wchan

       Print only the process IDs of syslogd:
          ps -C syslogd -o pid=

       Print only the name of PID 42:
          ps -q 42 -o comm=
```

### PSD style options(often use)

- ```
      a      Lift the BSD-style "only yourself" restriction, which is imposed upon the set of all
                processes when some BSD-style (without "-") options are used or when the ps
                personality setting is BSD-like.  
                
                The set of processes selected in this manner is in addition(as an extra thing, or circumstance.) to the set of processes selected by other means. 以这种方式选择的进程集信息是对通过其他方式选择的进程集的补充。 
                
                An alternate description
                is that this option causes ps to list all processes with a terminal (tty), or to
                list all processes when used together with the x option(x option could show the processes without a tty(terminal).
  ```

#### ps a

- `ps a`可以移除默认的`only yourself`进程信息输出规则限制

  - 可以列出所有(直接/间接)绑定了某个terminal的进程(包括通过具有启动该进程的terminal(tty)的进程创建的子进程)
  - (包括其他用户/其他terminal上执行的进程)

  - 但是某些特殊的用户的进程(譬如mysql以及相关服务)不具有启动的terminal,所以`ps a`仍然不会列出

    > - The `a` option tells `ps` to display the processes of all users. 
    >   - Only the processes that `not associated with a terminal `and processes of group leaders are not shown.
    >
    > -  TTY       controlling tty (terminal).  (alias tt, tty).
    >
    > 

  - ![image-20220407141737019](https://img-blog.csdnimg.cn/img_convert/fdac41eca0008395388eb1df32a39c3b.png)

    - 可以看到TTY这一栏,各条进程信息在此栏上都为 非`?`值
    - `--forest`(GNU style)和`f`(BSD style)选项在功能上是等价的

#### ps x

- `ps x`可以移除默认的`must have a tty`输出限制

  > 一般来说,`x`可以用来查看系统进程和服务(tty值为`?`)(但是不限于系统进程,当前(指定)用户的前台进程也可以被列出来)
  >
  > - The `x` option instructs `ps` to list the processes without a controlling terminal. Those are mainly processes that are started on boot time and [running in the background](https://linuxize.com/post/how-to-run-linux-commands-in-background/) .

  效果是查看当前用户(如果没有配合a选项),的所有进程(包括不是有在tty(terminal)直接创建(initiate)的进程)

  - 而如果要看到其他用户的进程,就需要配合另一个BSD 选项`a`

  ```
  x      Lift the BSD-style "must have a tty" restriction, which is imposed upon the set of all processes when some BSD-style (without "-") options are used or when the ps personality setting is BSD-like.  
  The set of processes selected in this manner is in addition to the set of processes selected by other means.  
  - An alternate description is that this option causes ps to list all processes owned by you (same EUID as ps), or to list all processes when used together with the a option.
  ```

  - 譬如,你使用man,查看某个命令的帮助,`man`会隐式调用系统的默认阅读器($PAGER)所定义的.
  - ![image-20220407140807782](https://img-blog.csdnimg.cn/img_convert/87d7d21105de2b0df9db51bb2a090642.png)
    - 使用`--forest`选项可以更加清楚的看到继承关系
    - ![image-20220407141033802](https://img-blog.csdnimg.cn/img_convert/c188ac2c5ad380d43c824fee90ce065a.png)
    - sshd(d:daemon)是系统的进程(我通过ssh服务链接到linux)

  

#### ps u

- 让ps 把process 的所属用户一并显示出来

- 但其实不单单是将是显示一列userName(PID),而是让显示格式以详细的格式显示

  - `u      Display user-oriented format.`

  - `u  -- output in resource usage format`显示

    

> - 总之`ps a`和`ps x`的显示结果一般是由重叠的部分(特别是当前用户的进程)
> - 两者配合,就可以看到所有的进程(而且还有进程状态`STAT`)
> - `a`&`x`下的每一条记录都是基本信息,只有显示格式上没有区别
>   - 如果使用`u`,就可以显示详细的信息

####  进程和用户信息`ps --user/ps -u/ps U`

> - `--user`是一个GNU style选项(等价于`-u` Unix styel;还等价于`U`BSD style) 
> - 类似的`--User`(等价于`-U`)
>
> ```bash
>    U userlist
>           Select by effective user ID (EUID) or name.  This selects the processes whose effective user name or ID is in userlist.  The effective user ID describes the user whose
>           file access permissions are used by the process (see geteuid(2)).  Identical to -u and --user.
> 
>    -U userlist
>           Select by real user ID (RUID) or name.  It selects the processes whose real user name or ID is in the userlist list.  The real user ID identifies the user who created
>           the process, see getuid(2).
> 
>    -u userlist
>           Select by effective user ID (EUID) or name.  This selects the processes whose effective user name or ID is in userlist.
> 
>           The effective user ID describes the user whose file access permissions are used by the process (see geteuid(2)).  Identical to U and --user.
> 
>    --User userlist
>           Select by real user ID (RUID) or name.  Identical to -U.
> 
>    --user userlist
>           Select by effective user ID (EUID) or name.  Identical to -u and U.
> ```
>
> - ```
>   --user        -u                    -- select processes by effective user
>   --User        -U                    -- select processes by real user
>   ```

- 指定某个用户,列出所有相关进程

- 

  ```bash
  $ ps --user cxxu
    PID TTY          TIME CMD
  13142 ?        00:00:00 sshd
  13143 pts/1    00:00:00 zsh
  15920 ?        00:00:00 sshd
  15921 pts/3    00:00:02 zsh
  19197 pts/1    00:00:00 man
  19208 pts/1    00:00:00 less
  20665 ?        00:00:00 sshd
  20666 pts/2    00:00:00 zsh
  22798 ?        00:00:00 sshd
  22799 pts/0    00:00:00 zsh
  22845 pts/0    00:00:00 man
  22856 pts/0    00:00:00 less
  22930 ?        00:00:00 sshd
  22931 pts/4    00:00:00 zsh
  23036 ?        00:00:00 sshd
  23039 pts/5    00:00:00 zsh
  25347 ?        00:00:00 sshd
  25348 pts/6    00:00:01 zsh
  26118 pts/6    00:00:00 ps
  30066 ?        00:00:00 systemd
  30067 ?        00:00:00 (sd-pam)
  ## 获取详细信息
  
  # cxxu @ cxxuAli in ~ [16:00:03]
  $ ps -u cxxu -U cxxu uf
  USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
  cxxu     27394  0.0  0.1 107992  3424 ?        S    15:31   0:00 sshd: cxxu@pts/7
  cxxu     27395  0.0  0.3  60772  7280 pts/7    Ss   15:31   0:00  \_ -zsh
  cxxu     25347  0.0  0.1 107992  3608 ?        S    15:07   0:00 sshd: cxxu@pts/6
  cxxu     25348  0.0  0.3  61084  7672 pts/6    Ss   15:07   0:02  \_ -zsh
  cxxu     29710  0.0  0.1  37376  3300 pts/6    R+   16:00   0:00      \_ ps -u cxxu -U cxxu uf
  cxxu     23036  0.0  0.1 107992  3520 ?        S    14:33   0:00 sshd: cxxu@pts/5
  cxxu     23039  0.0  0.3  58256  6808 pts/5    Ss+  14:33   0:00  \_ -zsh
  cxxu     22930  0.0  0.1 107992  3460 ?        S    14:33   0:00 sshd: cxxu@pts/4
  cxxu     22931  0.0  0.3  58172  6596 pts/4    Ss+  14:33   0:00  \_ -zsh
  cxxu     22798  0.0  0.1 107992  3612 ?        S    14:32   0:00 sshd: cxxu@pts/0
  cxxu     22799  0.0  0.3  58180  6744 pts/0    Ss   14:32   0:00  \_ -zsh
  cxxu     22845  0.0  0.1  21384  3928 pts/0    S+   14:32   0:00      \_ man ps
  cxxu     22856  0.0  0.0   9856   976 pts/0    S+   14:32   0:00          \_ less
  cxxu     20665  0.0  0.1 107992  3496 ?        S    14:04   0:00 sshd: cxxu@pts/2
  cxxu     20666  0.0  0.3  60628  7216 pts/2    Ss   14:04   0:00  \_ -zsh
  cxxu     15920  0.0  0.1 107992  3432 ?        S    13:08   0:00 sshd: cxxu@pts/3
  cxxu     15921  0.0  0.3  58484  7172 pts/3    Ss+  13:08   0:02  \_ -zsh
  cxxu     13142  0.0  0.1 107992  3492 ?        S    12:29   0:00 sshd: cxxu@pts/1
  cxxu     13143  0.0  0.3  60940  7432 pts/1    Ss   12:29   0:00  \_ -zsh
  cxxu     19197  0.0  0.1  21384  3832 pts/1    S+   13:49   0:00      \_ man ps
  cxxu     19208  0.0  0.1   9856  2472 pts/1    S+   13:49   0:00          \_ less
  cxxu     30066  0.0  0.3  76520  7328 ?        Ss   09:15   0:00 /lib/systemd/systemd --user
  cxxu     30067  0.0  0.1 111644  2364 ?        S    09:15   0:00  \_ (sd-pam)
  ```

  配合BSD 选项`u`该命令也可以列出详细信息(带`STAT`)

- ```
  # cxxu @ cxxuAli in ~ [15:15:21]
  $ ps u --user cxxu
  USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
  cxxu     13142  0.0  0.1 107992  3492 ?        S    12:29   0:00 sshd: cxxu@pts/1
  cxxu     13143  0.0  0.3  60940  7432 pts/1    Ss   12:29   0:00 -zsh
  cxxu     15920  0.0  0.1 107992  3432 ?        S    13:08   0:00 sshd: cxxu@pts/3
  cxxu     15921  0.0  0.3  58484  7172 pts/3    Ss+  13:08   0:02 -zsh
  cxxu     19197  0.0  0.1  21384  3832 pts/1    S+   13:49   0:00 man ps
  cxxu     19208  0.0  0.1   9856  2472 pts/1    S+   13:49   0:00 less
  cxxu     20665  0.0  0.1 107992  3496 ?        S    14:04   0:00 sshd: cxxu@pts/2
  cxxu     20666  0.0  0.3  60628  7216 pts/2    Ss   14:04   0:00 -zsh
  cxxu     22798  0.0  0.1 107992  3612 ?        S    14:32   0:00 sshd: cxxu@pts/0
  cxxu     22799  0.0  0.3  58180  6744 pts/0    Ss   14:32   0:00 -zsh
  cxxu     22845  0.0  0.1  21384  3928 pts/0    S+   14:32   0:00 man ps
  cxxu     22856  0.0  0.0   9856   976 pts/0    S+   14:32   0:00 less
  cxxu     22930  0.0  0.1 107992  3460 ?        S    14:33   0:00 sshd: cxxu@pts/4
  cxxu     22931  0.0  0.3  58172  6596 pts/4    Ss+  14:33   0:00 -zsh
  cxxu     23036  0.0  0.1 107992  3520 ?        S    14:33   0:00 sshd: cxxu@pts/5
  cxxu     23039  0.0  0.3  58256  6808 pts/5    Ss+  14:33   0:00 -zsh
  cxxu     25347  0.0  0.1 107992  3608 ?        S    15:07   0:00 sshd: cxxu@pts/6
  cxxu     25348  0.2  0.3  60740  7304 pts/6    Ss   15:07   0:01 -zsh
  cxxu     26204  0.0  0.1  37376  3344 pts/6    R+   15:15   0:00 ps u --user cxxu
  cxxu     30066  0.0  0.3  76520  7328 ?        Ss   09:15   0:00 /lib/systemd/systemd --user
  cxxu     30067  0.0  0.1 111644  2364 ?        S    09:15   0:00 (sd-pam)
  ```

#### real user & effective user

- The real user ID identifies the user who `created the process`, see getuid(2).

  - > 进程是谁创建出来的

-  The effective user ID describes the user ([whose file access permissions] `are used by the process`)

  - 创建user1专属文件,user2借助root权限进行访问?
    - RUID:user2
    - EUID:root?

  

### 获取(匹配指定名称)PID

> ps命令的一下两个选项比较常用(类似于`ps axu`);是UNIX风格的选项
>
> - -e
> - -f

#### 查看所有进程(ps -e选项)

- ps `-e`可以获取所有进程信息

#### 仅仅获取pid

> On many systems the `pgrep` command also exists that supports a number of ways to search for a process id. This is very useful if you are just interested in process id rather than other information. To search for all processes for an executable the `pgrep` command can be used.

- `pgrep`

```
# cxxu @ cxxuAli in ~ [11:09:41]
$ ping zhihu.com
PING zhihu.com (103.41.167.234) 56(84) bytes of data.
64 bytes from 103.41.167.234 (103.41.167.234): icmp_seq=1 ttl=49 time=13.8 ms
64 bytes from 103.41.167.234 (103.41.167.234): icmp_seq=2 ttl=49 time=13.8 ms
64 bytes from 103.41.167.234 (103.41.167.234): icmp_seq=3 ttl=49 time=13.8 ms
^Z
[4]  + 2678 suspended  ping zhihu.com

# cxxu @ cxxuAli in ~ [11:09:59] C:148
$ pgrep ping
2678
28415
```

#### 进程信息过滤/筛选(查找):grep with header

> grep 本身似乎没有办法保留列表的项目栏(属性字段名称)
>
> - 借助`head -1`来拿到表头项目栏

```sh
some-command | { head -1; grep some-stuff; }
```

- 譬如,将some-command 用实际命令`ps -ef`来替代

- ```bash
  # cxxu @ cxxuAli in ~ [12:51:52]
  $ ps -ef|{head -1;grep ping}
  UID        PID  PPID  C STIME TTY          TIME CMD
  cxxu      2678 26714  0 11:09 pts/0    00:00:00 ping zhihu.com
  cxxu     28415 26714  0 10:03 pts/0    00:00:00 ping baidu.com
  ```

#### 获取指定进程名称的详细信息(ps -f(-F)选项)

- `ps`:` -f`选项可以获得详细信息

  - `-F`会获取更加丰富的信息
  - `u `(BSD style)最丰富

- 宽松匹配

  - 

  ```bash
  psh(){
      # ps -ef|grep '.*CMD$|pattern'
      ps -ef|{head -1;grep "$1"}
  }
  ```

- 严格匹配

  - 

  ```
  psh(){
      # ps -ef|grep '.*CMD$|pattern'
      ps -ef|{head -1;grep "$1\b"}
  }
  ```

  

  > 可以将上述代码写入到配置文件中

- 利用参数化别名来代替`pgrep`获取详细信息(而不仅仅是指定进程名称的PID字段信息)

- 用法:`psh <ProcessName>|<PID>`

  - ```
    # cxxu @ cxxuAli in ~ [13:12:34]
    $ psh ping
    UID        PID  PPID  C STIME TTY          TIME CMD
    cxxu      2678 26714  0 11:09 pts/0    00:00:00 ping zhihu.com
    cxxu     28415 26714  0 10:03 pts/0    00:00:00 ping baidu.com
    
    ```

  - 

#### 查看进程树(进程继承派生关系:ps --forest)

```
# cxxu_kali @ CxxuWin11 in ~ [22:07:34] C:1
$ ps -e --forest
  PID TTY          TIME CMD
    1 ?        00:00:00 init
    9 tty1     00:00:00 init
   10 tty1     00:00:06  \_ zsh
 1046 tty1     00:00:00      \_ man
 1057 tty1     00:00:00          \_ less
  884 tty2     00:00:00 init
  885 tty2     00:00:01  \_ zsh
 1312 tty2     00:00:00      \_ man
 1323 tty2     00:00:00          \_ less
 1341 tty3     00:00:00 init
 1342 tty3     00:00:10  \_ zsh
 4414 tty3     00:00:00      \_ ps
 3742 tty5     00:00:00 init
 3743 tty5     00:00:02  \_ zsh
 3911 tty4     00:00:00 init
 3912 tty4     00:00:00  \_ zsh
```



## 资源占用排序

- The `ps` command also allows you to sort the output. 
  - For example, to sort the output based on the [memory usage](https://linuxize.com/post/check-memory-linux/) , you would use:

### 内存资源占用排序

```bash
ps aux --sort=-%mem|less
```
```bash

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
mysql     1557  0.0 17.9 1145052 366240 ?      Sl   Mar29  10:22 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --user=mysql --log-error=cxxuAli.err --open-files-limit=65535 --pid-file=/www/server/data/cxxuAli.pid --socket=/tmp/mysql.sock --port=3306
root       245  0.0  3.3 193228 68552 ?        S<s  Mar29   0:11 /lib/systemd/systemd-journald
root     30947  0.0  2.5 289240 52300 ?        Sl   Apr02   0:02 /www/server/panel/pyenv/bin/python /www/server/panel/BT-Panel
root      1533  0.0  1.9 774340 39560 ?        Sl   Mar29  10:36 /www/server/panel/pyenv/bin/python /www/server/panel/BT-Task
```
可见,mysql占用最多内存
### cpu资源占用排序
` ps axu --sort=-%cpu|less`

- ```bash
  USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
  root      1112  1.1  1.1 149104 23372 ?        S<sl Mar29 147:39 /usr/local/aegis/aegis_client/aegis_11_19/AliYunDun
  cxxu     25348  0.1  0.3  60860  7404 pts/6    Ss   15:07   0:01 -zsh
  root         1  0.0  0.3  77664  7512 ?        Ss   Mar29   0:05 /sbin/init noibrs splash
  root         2  0.0  0.0      0     0 ?        S    Mar29   0:00 [kthreadd]
  root         4  0.0  0.0      0     0 ?        I<   Mar29   0:00 [kworker/0:0H]
  ```
- 可见,阿里云盾(AliyunDun)占用最多cpu资源


### 自定义ps显示格式(字段)

#### User-defined Format

- The `o` option allows you to specify which columns are displayed when running the `ps` command.

- For example, to print information only about the `PID` and `COMMAND`, you would run one of the following commands:
- 自定义时最好不要用`u`(BSD),容易造成冲突(u尝试显示所有字段),导致自定义字段相互冲突而失败(error:conflicting format options)!

```bash
# version1:UNIX standard style
ps -efo pid,comm

# version2:BSD style
ps axo pid,comm 

# cxxu @ cxxuAli in ~ [16:20:47]
$ ps af o euser,ruser,comm
EUSER    RUSER    COMMAND
cxxu     cxxu     zsh
cxxu     cxxu      \_ man
cxxu     cxxu          \_ less
root     root     bash
root     root      \_ vim
cxxu     cxxu     zsh
cxxu     cxxu     zsh
cxxu     cxxu      \_ ps
cxxu     cxxu     zsh
cxxu     cxxu     zsh
cxxu     cxxu     zsh
cxxu     cxxu      \_ man
cxxu     cxxu          \_ less
cxxu     cxxu     zsh
cxxu     cxxu     zsh
root     root     agetty
root     root     agetty
```

## 进程切换/任务查看

### 关于job_id

- [process - How to get the Job ID? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/110911/how-to-get-the-job-id)

### jobs:Display status of jobs

查看当前shell 会话的任务状态及信息

- `jobs`列出后台进程

```bash
help jobs
jobs: jobs [-lnprs] [jobspec ...] or jobs -x command [args]
    Display status of jobs.

    Lists the active jobs.  JOBSPEC restricts output to that job.
    Without options, the status of all active jobs is displayed.

    Options:
      -l        lists process IDs in addition to the normal information
      -n        lists only processes that have changed status since the last
                notification
      -p        lists process IDs only
      -r        restrict output to running jobs
      -s        restrict output to stopped jobs

    If -x is supplied, COMMAND is run after all job specifications that
    appear in ARGS have been replaced with the process ID of that job's
    process group leader.

    Exit Status:
    Returns success unless an invalid option is given or an error occurs.
    If -x is used, returns the exit status of COMMAND.
```

- `jobs -l`可以看到PID(进程号)

### fg:Move job to the foreground.



- 将指定job调到前台运行

```bash
$ help fg
fg: fg [job_spec]
    Move job to the foreground.

    Place the job identified by JOB_SPEC in the foreground, making it the
    current job.  
    - If JOB_SPEC is not present, the shell's notion of the
    current job is used.

    Exit Status:
    Status of command placed in foreground, or failure if an error occurs.
```

- 将`jobs`查询到的job代号作为`fg`的参数(带上前缀`%`)(最优先推荐的方式)

- 也可以将`job对应的命令名`称作为参数

  - 如果想要通过job名称更好的方式是`%Command`的方式来唤醒

    - 譬如,我将web (django)服务从后台suspend状态调到其前台(通过`%py`)(py是该命令的第一个字段)

  - ```
    # cxxu @ cxxuAli in ~/djangoProjects/ela [19:04:12] C:148
    $ fg %py
    [1]  + 6859 continued  py manage.py runserver 0:8080
    [06/Apr/2022 11:06:07] "GET /polls/ HTTP/1.1" 200 74
    [06/Apr/2022 11:06:07] "GET /polls/ HTTP/1.1" 200 74
    [06/Apr/2022 11:06:11] "GET /polls/ HTTP/1.1" 200 74
    ```

  - 

###  & : 有预期的将某个任务挂在后台运行

- 在命令后面加上`&`
- 这种情况下,和使用`ctrl+z`不同,任务挂到后台是处于运行状态(`running`),而不是被`suspend`
- 例如
  - `sleep 300 &`
  - `vim &`

```
# cxxu @ cxxuAli in ~/djangoProjects/ela [10:06:43] C:16
$ vim &
[4] 28951

# cxxu @ cxxuAli in ~/djangoProjects/ela [10:09:08]
$
[4]  + 28951 suspended (tty output)  vim

# cxxu @ cxxuAli in ~/djangoProjects/ela [10:09:08]
$ jobs
[1]  - suspended  py manage.py runserver 0:8080
[2]    suspended (signal)  top
[3]    suspended  ping baidu.com
[4]  + suspended (tty output)  vim

```

```
# cxxu_kali @ CxxuWin11 in ~ [22:11:02]
$ vim file &
[1] 4455
[1]  + 4455 suspended (tty output)  vim file

# cxxu_kali @ CxxuWin11 in ~ [22:13:59]
$ jobs
[1]  + suspended (tty output)  vim file

```



### ctrl+z:挂起当前进程(suspend current process)

>  当某个进程占据了您的shell,您可以使用`ctrl+z`将该进程挂起,转到后台(一般就处于suspended状态)

- 处于挂起(suspended)的程序其任务不在被cpu执行,当我们用`fg`将其调到前台(continued),继续执行

```bash
# cxxu_kali @ CxxuWin11 in ~ [21:02:41] C:148
$ jobs
[1]  + suspended  sleep 30

# cxxu_kali @ CxxuWin11 in ~ [21:02:43]
$ bg %1
[1]  + 3274 continued  sleep 30

# cxxu_kali @ CxxuWin11 in ~ [21:02:51]
$ jobs
[1]  + running    sleep 30
```

### bg:让挂起的后台运行起来

- 您可以对被挂起的进程(譬如被`ctrl+z`挂起)执行`bg`操作(用`jobs`查询到被挂起在后台的进程(譬如查到它的job_id))

- ```
  # cxxu_kali @ CxxuWin11 in ~ [21:09:20] C:148
  $ jobs
  [1]  + suspended  sleep 130
  [2]  - running    sleep 300
  
  
  # cxxu_kali @ CxxuWin11 in ~ [21:09:28] C:1
  $ bg %1
  [1]  - 3468 continued  sleep 130
  ## 查询操作结果.
  # cxxu_kali @ CxxuWin11 in ~ [21:09:35]
  $ jobs
  [1]  - running    sleep 130
  [2]  + running    sleep 300
  ```

- 但是不可以对正在运行的后台任务执行有效的`bg`

  - ```
    # cxxu_kali @ CxxuWin11 in ~ [21:09:23]
    $ bg %2
    bg: job already in background
    
    ```



### Difference Between the bg Command and the “&” sign

- As you notice above that the ‘&’ sign can do the job of sending a process to the background too. So what’s the use of the bg command then?

> The major difference is that the bg command in Linux can be used on processes that are already running on the foreground. The ‘&’ sign works only when you’re starting the process and cannot be used for processes that are already running.

- So for processes that you haven’t started up yet, the bg command and the ‘&’ sign will behave in the same way.

### nohup:关闭/退出shell后任然运行

> To run a process in the background without getting impacted by the closing of the terminal.
>
> ```
> nohup sleep 100 &
> ```

- `nohup <simpleCommand>`



## 进程终止

### kill家族命令

```
       kill(2), killall(1), nice(1), pkill(1), renice(1), signal(7), skill(1)
```

### references of terminate a process

- [How to force kill process in Linux using kill and killall - nixCraft (cyberciti.biz)](https://www.cyberciti.biz/faq/how-force-kill-process-linux/)

### kill by  pid series

#### 获取进程号

- `ps aux|grep <name>` 
- `pgrep`/`pidof

#### kill

- 根据进程号来杀死(若干)进程

- ```
  NAME
         kill - send a signal to a process
  
  SYNOPSIS
         kill [options] <pid> [...]
  
  DESCRIPTION
         The  default  signal  for  kill is TERM.  Use -l or -L to list available signals.
         Particularly useful signals include HUP, INT, KILL, STOP, CONT, and 0. 
         Alternatesignals may be specified in three ways: -9, -SIGKILL or -KILL.  Negative PID val‐
         ues may be used to choose whole process groups;
         		see the PGID column in ps command output.
         - A  PID  of  -1  is  special; (it indicates all processes except the kill
         process itself and init.)
  ```

#### 默认的kill行为(弱杀)

```
To kill process on Linux use the kill command:
kill pid
kill -SIGKILL pid
kill 27707

By default signal 15, named SIGTERM, is sent to kill process. Hence all of the following are doing same things:
kill -15 27707
kill -SIGTERM 27707
kill 27707
```



#### 结束所有你可以终止的进程

- 从上述描述中可以看出,`kill -9 -1`可以满足需求

#### 强杀(必杀)

```
How to Kill a Process in Linux using SIGKILL
Sometime -SIGTERM (-15) fails, the stronger signal 9, called SIGKILL, should be used for force killing of process. For example, the following command would guarantee that process 27707 would be killed:
kill -9 27707
kill -SIGKILL 27707
```



#### 查询信号名

> `kill -l`
>
> ```
>  -l, --list [signal]
>               List  signal names.  This option has optional argument, which will convert
>               signal number to signal name, or other way round.
> ```
>
> 

```
# cxxu @ cxxuAli in ~ [17:59:41]
$ kill -l
HUP INT QUIT ILL TRAP ABRT BUS FPE KILL USR1 SEGV USR2 PIPE ALRM TERM 16 CHLD CONT STOP TSTP TTIN TTOU URG XCPU XFSZ VTALRM PROF WINCH POLL 30 SYS

# cxxu @ cxxuAli in ~ [18:04:16]
$ kill -l 11
SEGV

# cxxu @ cxxuAli in ~ [18:04:27]
$ kill -l 9
KILL
```

### kill by processName series

#### killall&pkill

> Linux force kill process using killall/pkill commands

- killall

  - ```
    NAME
           killall - kill processes by name	
    DESCRIPTION
           killall sends a signal to all processes running any of  the  specified  commands.
           If no signal name is specified, SIGTERM is sent.
    
           Signals  can  be  specified  either  by name (e.g.  -HUP or -SIGHUP) or by number
           (e.g.  -1) or by option -s.
    ```

- pkill&pgrep

  - 两者有相同的选项

  - ```
    DESCRIPTION
           - pgrep  looks  through  the  currently running processes and lists the process IDs
           which match the selection criteria to stdout.  All the criteria  have  to  match.
           For example,
    
                  $ pgrep -u root sshd
    
           will only list the processes called sshd AND owned by root.  On the other hand,
    
                  $ pgrep -u root,daemon
    
           will list the processes owned by root OR daemon.
    
           pkill will send the specified signal (by default SIGTERM) to each process instead
           of listing them on stdout.
    ```

  - 

- 可以根据进程名字来杀死进程(常见情况)

- 如果某个程序运行了多个实例,可以根据名字一同杀死

  > - If we already know the process we want to kill is named chrome, we can make use of the killall command and send the same signal the process l.
  >
  > - Instead of using PID one can kill any process by name using the killall or pkill command. The syntax is:
  >
  >   - `killall -9 app`
  >   - `pkill -9 app`
  >
  > - > eg kill chrome
  >
  >   - `killall -9 chrome`

#### 终止其他用户的进程(root privileges)

> You may want to run the [killall command](https://www.cyberciti.biz/faq/unix-linux-killall-command-examples-usage-syntax/) as root user to kill process of all users on Linux:
> `sudo killall -9 nginx`
> It is also possible to kill process with confirmation:
>
> ```
> # cxxu @ cxxuAli in ~ [18:49:57]
> $ killall -9 -i vim
> Signal vim(11341) ? (y/N) y
> [2]  + 11341 killed     vim fileOfRoot
> ```
>
> 

- The only caveat to the above command is that it may not catch all of the running chrome processes. 

  - 上述默认情况并不是发送`KILL`强杀,所以某些情况下可能失败(仍然有相关进程运行)

  - `killall -9 <pid>`

  - > If, after running the above command, you issue the ps aux|grep chrome command and see remaining processes running, your best bet is to go back to the *kill* command and send signal 9 to terminate the process by PID.

#### How to kill only process(es) running as USER(specific user)

> killall
>
>  -u, --user
>               Kill only processes the specified user owns.  Command names are optional.

- Say you want to kill vim process that in running as vivek user, run:(for examples:)
  - `killall -u {userName(UID)} -9 [processName(s)]`
  - ``killall -u cxxu -9 vim`





