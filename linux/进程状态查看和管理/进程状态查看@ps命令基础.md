## abstract

`ps`（process status）是 **Linux/Unix 系统中用于查看进程信息** 的最基本命令之一，它能展示当前系统中正在运行的进程、它们的状态、资源占用、所属用户、父进程关系等。

### 在线指南

- [ps(1) - Linux manual page](https://www.man7.org/linux/man-pages/man1/ps.1.html)

------

### ps 的核心概念

`ps` 是 “**process status**” 的缩写，用来列出系统中当前的进程（processes）。
 进程是操作系统运行的基本单位，每个程序（program）运行后都会变成一个进程（带有唯一 PID = Process ID）。

`ps` 实际上是通过读取 `/proc` 目录下的虚拟文件（如 `/proc/<pid>/status`）来显示进程信息的。

------

### 基本语法

```bash
ps [options]
```

为了照顾不同用户的使用习惯,它有三种参数语法风格：

| 风格                 | 示例                           | 来源                 |
| -------------------- | ------------------------------ | -------------------- |
| BSD 风格（不加 `-`） | `ps aux`                       | BSD 系统（如 macOS） |
| Unix 风格（需 `-`）  | `ps -ef`                       | BSD / System V 风格  |
| GNU 长选项风格(`--`) | `ps --pid 1 --ppid 2 --forest` | GNU/Linux            |

------

### ps基本帮助和语法

```bash
$ ps --help

Usage:
 ps [options]

 Try 'ps --help <simple|list|output|threads|misc|all>'
  or 'ps --help <s|l|o|t|m|a>'
 for additional help text.

For more details see ps(1).
```

由于ps命令的用法很多,ps的`--help`选项给出了几个可供选择了解的模块或部分,其中最基础的是`simple`模块(简写为`s`模块),是ps命令最核心和实用的部分

```bash
$ ps --help simple

Usage:
 ps [options]

Basic options:
 -A, -e               all processes
 -a                   all with tty, except session leaders
  a                   all with tty, including other users
 -d                   all except session leaders
 -N, --deselect       negate selection
  r                   only running processes
  T                   all processes on this terminal
  x                   processes without controlling ttys

For more details see ps(1).
```

这几个选项的详细说明版本(man ps查看)

```bash

SIMPLE PROCESS SELECTION
       a      Lift  the BSD-style "only yourself" restriction, which is imposed upon the set of all processes when some BSD-style (without "-") options are used or when the ps
              personality setting is BSD-like.  The set of processes selected in this manner is in addition to the set of processes selected  by  other  means.   An  alternate
              description is that this option causes ps to list all processes with a terminal (tty), or to list all processes when used together with the x option.

       -A     Select all processes.  Identical to -e.

       -a     Select all processes except both session leaders (see getsid(2)) and processes not associated with a terminal.

       -d     Select all processes except session leaders.

       --deselect
              Select all processes except those that fulfill the specified conditions (negates the selection).  Identical to -N.

       -e     Select all processes.  Identical to -A.

       g      Really  all,  even session leaders.  This flag is obsolete and may be discontinued in a future release.  It is normally implied by the a flag, and is only useful
              when operating in the sunos4 personality.

       -N     Select all processes except those that fulfill the specified conditions (negates the selection).  Identical to --deselect.

       T      Select all processes associated with this terminal.  Identical to the t option without any argument.

       r      Restrict the selection to only running processes.

       x      Lift the BSD-style "must have a tty" restriction, which is imposed upon the set of all processes when some BSD-style (without "-") options are used or  when  the
              ps  personality  setting is BSD-like.  The set of processes selected in this manner is in addition to the set of processes selected by other means.  An alternate
              description is that this option causes ps to list all processes owned by you (same EUID as ps), or to list all processes when used together with the a option.
```



| 选项              | 含义简述                                                     | 是否含无TTY进程 | 是否含Session Leader | 典型用途                       |
| ----------------- | ------------------------------------------------------------ | --------------- | -------------------- | ------------------------------ |
| `-A`, `-e`        | 显示所有进程（All processes）                                | ✅ 是            | ✅ 是                 | 查看整个系统的所有进程（常用） |
| `-a`              | 有TTY的所有进程，并且排除**Session Leader**                  | ❌ 否            | ❌ 否                 | 查看用户前台任务               |
| `a`               | 有TTY的所有进程，包括其他用户(取消了BSD风格中仅自己进程的限制),Session Leader进程会被列出 | ❌ 否            | ✅ 是                 | 查看所有用户的终端进程         |
| `-d`              | 所有非Session Leader进程                                     | ✅ 是            | ❌ 否                 | 查看除登录shell外的系统进程    |
| `-N`/`--deselect` | 反选，不显示匹配条件的进程                                   | ⚙️ 取决于条件    | ⚙️ 取决于条件         | 排除特定进程（如排除bash）     |
| `r`               | 仅显示“运行中”的进程                                         | ✅ 是            | ✅ 是                 | 监控当前活动任务               |
| `T`               | 当前终端（TTY）上的所有进程                                  | ❌ 否            | ✅ 是                 | 仅看当前shell的任务            |
| `x`               | 无TTY的进程（后台/守护）                                     | ✅ 是            | ✅ 是                 | 查看后台daemon或systemd任务    |

> **Session leader**（会话领导进程）通常是 shell 或 login 程序。
>  排除它们意味着只看用户直接运行的命令。



### 常见用法与参数详解

| 命令               | 作用                        | 说明                                                         |
| ------------------ | --------------------------- | ------------------------------------------------------------ |
| `ps`               | 显示当前终端下的进程        | 只列出和当前 shell 相关的进程                                |
| `ps -e` 或 `ps -A` | 显示系统中所有进程          | （e = every）                                                |
| `ps -f`            | 显示完整格式（full format） | 包含 PPID、启动时间、命令等,但是实际上,这个`-f`选项并不会显示`STAT`进程状态列,使用BSD风格的选项时会影响这个列的显示, |
| `ps -ef`           | 显示所有进程详细信息        | Linux 常用组合                                               |
| `ps aux`           | BSD 风格，显示所有进程信息  | 与 `-ef` 类似,但是在`STAT`列上有区别,`f`选项没有此列         |
| `ps -u <user>`     | 查看指定用户的进程          | 如 `ps -u root`                                              |
| `ps -p <pid>`      | 查看特定进程                | 如 `ps -p 1`                                                 |
| `ps -o`            | 自定义输出格式              | 例：`ps -eo pid,ppid,cmd,%mem,%cpu`                          |
| `ps --forest`      | 树状显示进程层级            | 方便查看父子进程关系                                         |
| `ps --sort`        | 按字段排序                  | 如 `ps -eo pid,cmd,%mem --sort=-%mem`（按内存降序）          |

------

### 示例

```bash
$ ps
    PID TTY          TIME CMD
   9754 pts/2    00:00:00 zsh
   9821 pts/2    00:00:00 ps
```

下面是wsl2中的查看所有进程的输出示例

> PID   → 进程 ID（Process ID）
> TTY   → 关联的终端（? 表示无终端，比如系统服务）
> TIME  → 进程累计占用 CPU 时间
> CMD   → 启动命令或程序名

```bash
# cxxu @ CxxuFirebat in ~ [11:17:37] C:130
$ ps -A
    PID TTY          TIME CMD
      1 ?        00:00:01 systemd
      2 ?        00:00:00 init-systemd(ar
      6 ?        00:00:00 init
     43 ?        00:00:00 systemd-journal
     71 ?        00:00:00 systemd-nsresou
     72 ?        00:00:00 systemd-userdbd
     84 ?        00:00:00 systemd-resolve
     94 ?        00:00:00 systemd-udevd
     95 ?        00:00:00 systemd-network
    151 ?        00:00:00 dbus-broker-lau
    152 ?        00:00:00 dbus-broker
    153 ?        00:00:00 systemd-homed
    154 ?        00:00:00 systemd-logind
    175 ?        00:00:00 login
    180 ?        00:00:00 systemd
    182 ?        00:00:00 (sd-pam)
    193 pts/1    00:00:00 bash
   5629 ?        00:00:00 SessionLeader
   5630 ?        00:00:00 Relay(5632)
   5632 pts/0    00:00:01 zsh
   5884 hvc0     00:00:00 agetty
   6186 pts/0    00:00:00 man
   6194 pts/0    00:00:00 less
   9751 ?        00:00:00 SessionLeader
   9752 ?        00:00:00 Relay(9754)
   9754 pts/2    00:00:00 zsh
   9952 ?        00:00:00 systemd-nsresou
  10008 ?        00:00:00 systemd-nsresou
  10009 ?        00:00:00 systemd-nsresou
  10010 ?        00:00:00 systemd-userwor
  10011 ?        00:00:00 systemd-userwor
  10012 ?        00:00:00 systemd-nsresou
  10013 ?        00:00:00 systemd-userwor
  10014 ?        00:00:00 systemd-nsresou
  10029 pts/2    00:00:00 ps
```

#### 一号PID进程

| PID  | CMD     | 说明                                                         |
| ---- | ------- | ------------------------------------------------------------ |
| 1    | systemd | Linux 用户空间的**初始化进程**（init system）。它是所有进程的“祖先”。 |

### 全部进程和多用户进程查看

为了便于区分,本节总是使用`ps`的`-f`选项查看进程更为详细的信息

```bash
#( 10/07/25@ 9:21PM )( cxxu@CxxuFirebat ):~
   ps -f -a
UID          PID    PPID  C STIME TTY          TIME CMD
cxxu         579     176  0 21:33 pts/0    00:00:00 ps -f -a
```

下面的例子中,将选项`-a`替换为`a`,输出的内容多了不少,不仅把当前用户cxxu的进程列出,还把root用户的进程也列出了

尽管如此,仍然可以看到所有被列出的进程都是有明确TTY值的,并且显然一些低位id进程(没有tty值)没有被列出,如果要连同这些特殊进程一起列出,则需要`-e`或者`-A`

可以发现,即便是cxxu用户的进程,`a`选项列出的比`-a`要多,因为Session Leader进程也会被列出,比如`zsh`

```bash
#( 10/07/25@ 9:33PM )( cxxu@CxxuFirebat ):~
   ps -f a
UID          PID    PPID  C STIME TTY      STAT   TIME CMD
root         167       1  0 21:18 hvc0     Ss+    0:00 /sbin/agetty --noreset --nocle
root         168       1  0 21:18 tty1     Ss+    0:00 /sbin/agetty --noreset --nocle
cxxu         176     175  0 21:18 pts/0    Ss     0:00 -zsh
cxxu         195     177  0 21:18 pts/1    Ss+    0:00 -zsh
root         344     343  0 21:20 pts/2    Ss+    0:00 -zsh
root         369     345  0 21:20 pts/3    Ss+    0:00 -zsh
cxxu         600     176  0 21:33 pts/0    R+     0:00 ps -f a
```

关于`STAT`列,下一节说明

### 输出字段说明

常见的输出列（columns）解释如下：

| 列名     | 含义                                                     |
| -------- | -------------------------------------------------------- |
| PID      | 进程 ID（Process ID）                                    |
| PPID     | 父进程 ID（Parent Process ID）                           |
| USER     | 进程所有者                                               |
| %CPU     | 占用 CPU 百分比                                          |
| %MEM     | 占用内存百分比                                           |
| VSZ      | 虚拟内存大小（**V**irtual Memory **S**i**z**e，单位 KB） |
| RSS      | 实际占用物理内存（Resident Set Size）                    |
| TTY      | 关联的终端（Terminal）                                   |
| **STAT** | 进程状态（State）                                        |
| START    | 启动时间                                                 |
| TIME     | 累积 CPU 时间                                            |
| COMMAND  | 启动进程的命令及参数                                     |

------

这其中比较复杂的列是`STAT`,进程的状态标记含义需要了解

### STAT（进程状态）常见取值

```bash
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process:

               D    uninterruptible sleep (usually I/O)
               I    idle kernel thread
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since Linux 2.6)
               X    dead (should never be seen)
               Z    defunct  (“zombie”)  process, terminated but not reaped by
                    its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory  (for  real-time  and  custom
                    I/O)
               s    is a session leader
               l    is  multi-threaded (using CLONE_THREAD, like NPTL pthreads
                    do)
               +    is in the foreground process group
```

| Code | description                                                  | 描述                                     |
| ---- | ------------------------------------------------------------ | ---------------------------------------- |
| D    | uninterruptible sleep (usually I/O)                          | 不可中断睡眠（通常处于 I/O 操作中）      |
| I    | idle kernel thread                                           | 空闲的内核线程                           |
| R    | running or runnable (on run queue)                           | 正在运行或可运行（位于运行队列中）       |
| S    | interruptible sleep (waiting for an event to complete)       | 可中断睡眠（正在等待某个事件完成）       |
| T    | stopped by job control signal                                | 被作业控制信号停止（例如 Ctrl+Z）        |
| t    | stopped by debugger during the tracing                       | 在调试跟踪（tracing）过程中被调试器停止  |
| W    | paging (not valid since Linux 2.6)                           | 正在换页（自 Linux 2.6 起已无效）        |
| X    | dead (should never be seen)                                  | 已终止（“死亡”状态，正常情况下不应看到） |
| Z    | defunct (“zombie”) process, terminated but not reaped by its parent | 僵尸进程（已终止但尚未被父进程回收）     |

| 附加标记 | description                                                  | 描述                                                         |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <        | high-priority (not nice to other users)                      | 高优先级（对其他用户不“友好”，即 not nice）                  |
| N        | low-priority (nice to other users)                           | 低优先级（对其他用户“友好”，即 nice 值较高）                 |
| L        | has pages locked into memory (for real-time and custom I/O)  | 有内存页被锁定在内存中（用于实时应用或自定义 I/O）           |
| s        | is a session leader                                          | 是会话首进程（session leader）                               |
| l        | is multi-threaded (using CLONE_THREAD, like NPTL pthreads do) | 是多线程进程（使用了 `CLONE_THREAD`，例如 NPTL 的 pthreads） |
| +        | is in the foreground process group                           | 属于前台进程组                                               |

> ℹ️ 注：`STAT` 字段通常由多个字符组合而成，例如 `Ss+` 表示：可中断睡眠（S）、会话首进程（s）、前台进程组（+）。

#### 状态字母

| 状态字母 | 含义                  | 说明                     |
| -------- | --------------------- | ------------------------ |
| R        | Running               | 运行中或可运行（就绪）   |
| S        | Sleeping              | 休眠中（可被唤醒）       |
| D        | Uninterruptible Sleep | 不可中断（等待 I/O）     |
| Z        | Zombie                | 僵尸进程（父进程未回收） |
| T        | Stopped               | 暂停（被信号或调试）     |
| X        | Dead                  | 已终止（很少见）         |

#### 附加标志

| 标志 | 含义                           |
| ---- | ------------------------------ |
| `<`  | 高优先级（higher priority）    |
| `N`  | 低优先级（nice）               |
| `L`  | 页面锁定（real memory locked） |
| `+`  | 属于前台进程组                 |

------

```
Ss+
```

- `S` = 可中断睡眠（Sleeping）
- `s` = 会话 leader（session leader）
- `+` = 前台进程组（在当前终端前台运行）

```
R+
```

- `R` = 正在运行或可运行（Running）
- `+` = 前台进程组（你的 `ps -f a` 命令本身）

详细状态码含义可通过 `man ps` 查看 "PROCESS STATE CODES" 部分。 

### 常见实用示例

#### 查看所有进程（系统级）

```bash
ps -ef
```

或

```bash
ps aux
```

输出示例：

```
UID   PID  PPID  C STIME TTY          TIME CMD
root    1     0  0 08:00 ?        00:00:02 /sbin/init
user 1234  1220  1 08:05 pts/0    00:00:00 python3 script.py
```

------

#### 查看某个程序（用 grep 过滤）

```bash
ps -ef | grep python
```

或

```bash
ps aux | grep nginx
```

常用于查找程序是否在运行。

------

#### 查看进程树结构（父子关系）

```bash
ps -ef --forest
```

输出类似：

```
systemd─┬─NetworkManager───dhclient
        ├─sshd───bash───ps
        └─cron
```

------

#### 查看内存或 CPU 占用最高的进程

```bash
ps -eo pid,comm,%mem,%cpu --sort=-%mem | head
```

或

```bash
ps -eo pid,comm,%cpu --sort=-%cpu | head
```

------

#### 查看某用户的所有进程

```bash
ps -u username
```

------

#### 自定义输出字段

```bash
ps -eo pid,ppid,user,%cpu,%mem,cmd
```

这对调试进程状态非常有用。

------

### ps 与 top/htop 的区别

| 工具   | 特点                 | 用途                       |
| ------ | -------------------- | -------------------------- |
| `ps`   | 静态快照（snapshot） | 一次性查看当前进程状态     |
| `top`  | 动态刷新（实时监控） | 实时查看 CPU/内存占用      |
| `htop` | top 的增强图形界面版 | 支持彩色显示、交互式杀进程 |

通常开发者会先用：

```bash
ps aux | grep <keyword>
```

定位目标进程，再用：

```bash
top -p <pid>
```

实时观察其资源占用。

------

### 在 WSL 环境下的特殊说明

在 WSL（Windows Subsystem for Linux）中：

- `ps` 只能看到 Linux 子系统内的进程；
- 无法直接看到 Windows 原生进程；
- 但其性能和行为与原生 Linux 基本一致；
- WSL 环境下的 `ps` 结果可能与 Windows 的 `tasklist` 命令不同步。

------

### 小结

| 特性     | ps                                       |
| -------- | ---------------------------------------- |
| 全称     | process status                           |
| 主要功能 | 查看进程信息（静态）                     |
| 核心参数 | -e, -f, -u, -p, -o, --forest, --sort     |
| 输出信息 | PID、PPID、用户、CPU、内存、状态、命令等 |
| 优势     | 简洁、通用、稳定                         |
| 缺点     | 静态输出，不实时刷新                     |
| 常见搭配 | `ps + grep`、`ps + sort`、`ps + awk`     |

------



