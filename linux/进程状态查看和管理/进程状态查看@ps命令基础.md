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

不同类型的选项可以自由混合使用，但可能会出现冲突。
 由于 `ps` 命令兼容多种标准和不同实现版本（implementations），其中有一些选项是同义的（synonymous options），它们在功能上是完全相同的。

经验上看,由于BSD风格的ps用选项简洁,而且内容详细,用的最多

**解释：**
 `ps` 命令（process status，进程状态查看工具）在不同 UNIX 系统（如 BSD、System V、GNU）中有不同的选项格式，比如：

- BSD 风格：不带 `-`，如 `ps aux`
- System V 风格：带 `-`，如 `ps -ef`

这些风格可以混合使用，但有时会导致输出或选项逻辑冲突。某些选项是“别名”（synonymous），意思是不同写法但效果相同。

默认情况下，`ps` 会选择与当前用户具有相同有效用户 ID（effective user ID，euid=EUID），并且与执行命令的终端相同的所有进程。
 默认显示的字段包括：

- 进程 ID（pid=PID）
- 进程所属终端（tname=TTY）
- 累计 CPU 时间（time=TIME），格式为 `[DD-]hh:mm:ss`
- 可执行文件名（ucmd=CMD）
   输出默认不排序。

**解释：**
 也就是说，直接执行 `ps`（不带参数）时，只会显示当前终端下、当前用户启动的进程，比如：

```
$ ps
  PID TTY          TIME CMD
 4321 pts/0    00:00:00 bash
 4355 pts/0    00:00:01 ps
```

此时不显示其他终端或其他用户的进程。

使用 BSD 风格的选项时，**默认输出会增加进程状态（stat=STAT）列**，并显示命令的完整参数（args=COMMAND），而不是仅显示**可执行文件名**。
 你可以通过**环境变量** `PS_FORMAT` 来覆盖这种默认格式。
 此外，使用 BSD 风格的选项还会**改变进程的选择范围**：它会包含属于**当前用户、但运行在其他终端（TTY）上的进程**。
 换句话说，这种选择等价于：**显示当前用户的所有进程**，排除那些属于其他用户或不在终端上的进程。
 在后文描述某些选项为“相同”（identical）时，不考虑这些行为差异，因此例如 `-M` 会被视为与 `Z` 等价。

**解释：**
 当使用 BSD 风格的 `ps`（例如 `ps aux`）时，会：

- 显示更多列（包括 STAT、COMMAND）
- 显示所有你自己的进程（而不是仅当前终端）

例如：

```
$ ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
alice     1203  0.0  0.1  11240  3040 pts/0    Ss   09:23   0:00 bash
alice     1345  0.0  0.0  10620  2200 pts/1    S+   09:24   0:00 vim
```

而默认 `ps`（System V 风格）只显示当前终端。

除非后文另有说明，进程选择选项（process selection options）是“可累加”的（additive）。
 默认的进程选择会被丢弃(用户自定义了进程选择查看参数,覆盖默认参数)，然后将满足条件的进程加入到要显示的进程集合中。
 因此，如果一个进程符合任意给定的选择条件，它就会被显示出来。

**解释：**
 这段说明了“进程选择逻辑”。
 例如：

```
ps -u alice -p 1234
```

表示选择属于用户 `alice` 的所有进程，加上进程号为 1234 的进程。
 这两个条件是“并集关系”（additive），不是互斥的。

**process selection options（进程选择选项）**
 指的是用来指定“要显示哪些进程”的选项，比如：

- `-u <user>`：按用户名筛选；
- `-p <pid>`：按进程号筛选；
- `-t <tty>`：按终端筛选；
- `-C <command>`：按命令名筛选。

**additive（可累加的）**
 表示多个条件之间是“并集关系”（logical OR），即： 只要某个进程符合其中**任意一个**条件，就会显示出来。 并不是“交集”或“覆盖”的关系。

**default selection discarded（默认选择被丢弃）**
 表示一旦你使用了这些选择选项（如 `-u`、`-p` 等），
 `ps` 不再只显示当前用户、当前终端的默认进程集合，而是以这些选项为准。

### 不建议混用场景

不建议使用诸如 `ps -aux` 之类的命令选项，因为这会混淆两种不同的标准。
根据 POSIX 和Unix 标准，上述命令要求显示所有进程带有 TTY（通常是用户正在运行的命令）以及所有名为 x 的用户拥有的进程。如果该用户不存在，那么 ps 会假定您真正想要的是“ps aux”。

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

### 简单的进程选择选项

| 选项              | 含义简述                                                     | 是否含无TTY进程 | 是否含Session Leader | 典型用途                        |
| ----------------- | ------------------------------------------------------------ | --------------- | -------------------- | ------------------------------- |
| `-A`, `-e`        | 显示所有进程（All processes）                                | ✅ 是            | ✅ 是                 | 查看整个系统的所有进程（常用）  |
| `-a`              | 有TTY的所有进程，并且排除**Session Leader**                  | ❌ 否            | ❌ 否                 | 查看用户前台任务                |
| `a`               | 有TTY的所有进程，包括其他用户(取消了BSD风格中仅自己进程的限制),Session Leader进程会被列出 | ❌ 否            | ✅ 是                 | 查看所有用户的终端进程          |
| `-d`              | 所有非Session Leader进程(比`-a`选项看到的更多一些,包括了系统进程) | ✅ 是            | ❌ 否                 | 查看除登录shell外的**系统进程** |
| `-N`/`--deselect` | **反选**，不显示匹配条件的进程                               | ⚙️ 取决于条件    | ⚙️ 取决于条件         | 排除特定进程（如排除bash）      |
| `r`               | 仅显示“运行中”的进程(适合用来分析和排查资源占用高的进程)     | ✅ 是            | ✅ 是                 | 监控当前活动任务                |
| `T`               | 当前终端（TTY）上的所有进程                                  | ❌ 否            | ✅ 是                 | 仅看当前shell的任务             |
| `x`               | 选择无TTY的进程（后台/守护）                                 | ✅ 是            | ✅ 是                 | 查看后台daemon或systemd任务     |

> **Session leader**（会话领导进程）通常是 shell 或 login 程序。
>  排除它们意味着只看用户直接运行的命令。



## 常见用法与参数详解🎈

| 命令               | 作用                        | 说明                                                         |
| ------------------ | --------------------------- | ------------------------------------------------------------ |
| `ps`               | 显示当前终端下的进程        | 只列出和当前 shell 相关的进程                                |
| `ps -e` 或 `ps -A` | 显示系统中所有进程          | （e = every）                                                |
| `ps -f`            | 显示完整格式（full format） | 包含 PPID、启动时间、命令等,但是实际上,这个`-f`选项并不会显示`STAT`进程状态列,使用BSD风格的选项时会影响这个列的显示, |
| `ps -ef`           | 显示所有进程详细信息        | Linux 常用组合                                               |
| `ps aux`           | BSD 风格，显示所有进程信息  | 与 `-ef` 类似,但是在`STAT`列上有区别,`f`选项没有此列; <br />其中的`a`,`x`,两个选项合用时,相当于`-e`(显示所有进程)<br />其中的选项`u`影响输出的格式和内容:使用用户导向格式（user-oriented format） |
| `ps -u <user>`     | 查看指定用户的进程          | 如 `ps -u root`                                              |
| `ps -p <pid>`      | 查看特定进程                | 如 `ps -p 1`                                                 |
| `ps -o`            | 自定义输出格式              | 例：`ps -eo pid,ppid,cmd,%mem,%cpu`                          |
| `ps --forest`      | 树状显示进程层级            | 方便查看父子进程关系                                         |
| `ps --sort`        | 按字段排序                  | 如 `ps -eo pid,cmd,%mem --sort=-%mem`（按内存降序）          |

------

### 通过参数列表选择进程的选项

PROCESS SELECTION BY LIST

这些选项（These options）接受一个参数(列表)，该参数的形式可以是**以空格分隔**或**以逗号分隔**的列表（blank-separated or comma-separated list）。
 它们可以被多次使用。例如：

```bash
ps -p "1 2" -p 3,4
```

这会选中进程 ID 为 1、2、3、4 的进程。

接下来是不同数字写法的含义：

- `123`：等价于 `--pid 123`，即按**进程 ID（PID）**选择进程。
- `+123`：等价于 `--sid 123`，即按**会话 ID（SID, session ID）**选择进程。
- `-123`：表示按**进程组 ID（PGID, process group ID）**选择进程。

| 选项                  | 含义 / 功能说明                                              | 显示字段（等价于 `-o` 格式）                                 | 备注说明                                                     |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **-c**                | 与 `-l` 一起使用时显示不同的调度器信息（scheduler info）。   | `cls, pri`                                                   | “cls”=**调度类别**(class)，“pri”=**优先级**（priority）。    |
| **--context**         | 显示 SELinux 的安全上下文（security context）。              | `pid, context, cmd`                                          | 仅在启用 SELinux 时有用。                                    |
| **-f**                | 显示“完整格式（full-format）”的进程列表。打印命令参数（args）。与 `-L` 一起用时会增加线程列。 | `uid, pid, ppid, c, stime, tty, time, cmd`                   | 常用的详细格式；显示父进程、CPU使用等。                      |
| **-F**                | “扩展完整格式（extra full format）”，隐含 `-f`，显示更多列。(但仍然不是全部,仍然只是其中的一小部分,更多字段需要配合自定义字段来显示) | `uid, pid, ppid, c, sz, rss, psr, stime, tty, time, cmd`     | 包含内存信息（SZ、RSS）与CPU号（PSR）。                      |
| **--format <format>** | 用户自定义输出格式。这不是一个开关,而是需要指定参数的选项,`--format`与 `-o`、`o` 相同。 | -                                                            | 与 `-o` 等价，可自定义输出列。                               |
| **j**                 | BSD 风格“作业控制（job control）”格式。                      | `ppid, pid, pgid, sid, tty, tpgid, stat, uid, time, cmd`     | BSD 专用输出格式。                                           |
| **-j**                | Unix 风格“作业格式”。                                        | `pid, pgid, sid, tty, time, ucmd`                            | 类似于 `j`，但字段略不同。                                   |
| **l**                 | BSD 长格式（long format）。                                  | `f, uid, pid, ppid, pri, ni, vsz, rss, wchan, stat, tty, time, cmd` | BSD 风格的详细输出。                                         |
| **-l**                | Unix 长格式。通常配合 `-y` 使用。                            | `f, uid, pid, ppid, c, pri, ni, addr, sz, wchan, tty, time, ucmd` | System V 风格的长列表。                                      |
| **-M**                | 添加 SELinux 安全数据列。与 `Z` 相同。                       | `context, pid, tty, time, ucmd`                              | SELinux 环境下有效。                                         |
| **O format**          | BSD 的 `O` 选项：可表示输出格式或排序。启发式判断用途。      | 等价于 `-O format`                                           | 若要确定行为，请使用 `--sort` 或 `-O`。                      |
| **-O format**         | 类似 `-o`，但预设一些常见列。                                | `pid, format, state, tname, time, command`                   | 预加载基本字段后再加自定义列。                               |
| **o format**          | 自定义输出格式。与 `-o`、`--format` 相同。                   | 用户指定                                                     | BSD 风格语法，等价于 `-o`。                                  |
| **-o format**         | 用户自定义输出格式。可以指定多个列并重命名标题。             | 用户指定                                                     | 支持空格或逗号分隔，可用多次 `-o`。如：`ps -o pid,ruser=RealUser -o comm=Command`。 |
| **-P**                | 增加显示 “psr”（CPU核心号）。                                | `pid, psr, s, tty, time, ucmd`                               | 查看进程所在 CPU 核。                                        |
| **s**                 | 显示信号相关格式（signal format）。                          | `uid, pid, pending, blocked, ignored, caught, stat, tty, bsdtime, cmd` | 显示信号屏蔽和捕获信息。                                     |
| **u**                 | 用户导向格式（user-oriented format）。                       | `user, pid, pcpu, pmem, vsz, rss, tty, stat, start_time, bsdtime, args` | 常用格式，显示CPU/MEM使用。即 `ps u`。                       |
| **v**                 | 虚拟内存格式（virtual memory format）。                      | `pid, tty, stat, bsdtime, majflt, trs, drs, rss, pmem, args` | 关注内存与缺页信息。                                         |
| **X**                 | 寄存器格式（register format）。                              | `pid, stackp, esp, eip, tmout, alarm, stat, tty, bsdtime, args` | 显示低层CPU寄存器信息。                                      |
| **-y**                | 不显示 flags，用 RSS 替换 addr。仅用于 `-l`。                | -                                                            | 优化长格式输出，使 RSS 更直观。                              |
| **Z**                 | 添加 SELinux 安全上下文列。与 `-M` 相同。                    | `context, pid, tty, time, ucmd`                              | 与 `-M` 完全等价。                                           |

### 相关术语

| 英文术语                | 中文解释  | 说明                                     |
| ----------------------- | --------- | ---------------------------------------- |
| PID (Process ID)        | 进程 ID   | 唯一标识进程                             |
| PGID (Process Group ID) | 进程组 ID | 用于分组控制（如信号）                   |
| SID (Session ID)        | 会话 ID   | 一组进程组的集合                         |
| argument list           | 参数列表  | 可以用空格或逗号分隔                     |
| personality             | 行为模式  | `ps` 模拟 BSD 或 System V 风格的运行方式 |

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

## 输出字段说明🎈

查看man手册中的 **STANDARD FORMAT SPECIFIERS** 获取完整说明,这是一个很长的列表,其中常用的(预设为`-f,-F`只是一小部分)

常见的输出列（columns）解释如下：(使用`-F`查看SZ,RSS等字段,占用百分比需要使用`-o`选项来指定)

| 列名         | 含义                                                     |
| ------------ | -------------------------------------------------------- |
| PID          | 进程 ID（Process ID）                                    |
| PPID         | 父进程 ID（Parent Process ID）                           |
| USER         | 进程所有者                                               |
| %CPU         | 占用 CPU 百分比                                          |
| %MEM         | 占用内存百分比                                           |
| VSZ(SZ)      | 虚拟内存大小（**V**irtual Memory **S**i**z**e，单位 KB） |
| RSS          | 实际占用物理内存（Resident Set Size）                    |
| TTY          | 关联的终端（Terminal）                                   |
| **STAT**     | 进程状态（State）                                        |
| START        | 启动时间                                                 |
| TIME         | 累积 CPU 时间                                            |
| COMMAND(CMD) | 启动进程的命令及参数                                     |

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

### 内存占用相关字段

| 字段名         | 含义（中文）                                          | 英文解释             | 单位 | 说明与使用示例                                               |
| -------------- | ----------------------------------------------------- | -------------------- | ---- | ------------------------------------------------------------ |
| **RSS**        | 常驻内存集（Resident Set Size）                       | Resident Set Size    | KB   | 实际驻留在物理内存（RAM）中的内存页大小。可理解为“**真正使用的物理内存**”。示例：`ps -o pid,comm,rss` |
| **VSZ**        | 虚拟内存大小（Virtual Memory Size）                   | Virtual Memory Size  | KB   | 进程可访问的虚拟地址空间总量，包括已映射但未实际用的页。示例：`ps -o pid,comm,vsz` |
| **%MEM**(PMEM) | 内存占用百分比(PMEM与 `%MEM` 等价的别名,P表示percent) | Percent Memory Usage | %    | 占系统物理内存（RAM）总量的百分比，计算公式为：`RSS / 总物理内存 × 100`。示例：`ps -eo pid,comm,%mem` |

| 指标                       | 含义关系                              | 对比说明                           |
| -------------------------- | ------------------------------------- | ---------------------------------- |
| **VSZ ≥ RSS**              | 虚拟内存总是大于等于物理常驻内存。    | VSZ 包含映射文件、共享库、未用页。 |
| **RSS = 实际占用物理内存** | RSS 更能代表真实“内存使用”。          | 若想估算系统总内存负载，应看 RSS。 |
| **%MEM = RSS / 总RAM**     | 表示进程在系统RAM中占比。             | 实时监控中最常用指标。             |
| **TRS + DRS ≤ RSS**        | RSS 包含代码段 + 数据段 + 堆 + 栈等。 | 用于分析程序结构内存分布。         |

### 适合分析活跃进程和资源占用的ps输出格式🎈

```bash
ps -eo user,pid,%cpu,%mem,rss,vsz,nlwp,stat,start_time,comm --sort=-%cpu
```

与widnows任务管理器中的相关概念对比

| 字段         | 对应 Windows 概念        | 说明                            |
| ------------ | ------------------------ | ------------------------------- |
| `%CPU`       | “CPU 使用率”             | 短时间平均 CPU 占用率（非累积） |
| `%MEM`       | “内存占比”               | 当前占系统 RAM 百分比           |
| `RSS`        | “工作集 (Working Set)”   | 实际驻留物理内存                |
| `VSZ`        | “提交大小 (Commit Size)” | 虚拟内存空间大小                |
| `NLWP`       | “线程数”                 | Lightweight Processes 数量      |
| `STAT`       | “状态”                   | 运行/睡眠/僵尸等状态代码        |
| `TIME`       | “CPU 时间”               | 累积 CPU 使用时间               |
| `START_TIME` | “启动时间”               | 进程启动时刻                    |

可以配合管道符+`head`命令仅列出最活跃或者最占用内存的若干项进程,方便定位问题

为上述输出格式做可读性改进(让内存占用人类友好的方式显示):

```bash
# 进程监控函数
psmon() {
    local sort_field="${1:--%cpu}"
    local lines="${2:-20}"
    
    ps -eo user,pid,%cpu,%mem,rss,vsz,nlwp,stat,start_time,cmd --sort="$sort_field" | head -n "$lines" | awk '
    NR==1 {
        printf "%-12s %-8s %-6s %-6s %-12s %-12s %-6s %-8s %-10s %-s\n",
               $1,$2,$3,$4,"RSS(MB)","VSZ(MB)",$7,$8,$9,"CMD";
        next
    }
    {
        rss_mb=$5/1024; vsz_mb=$6/1024;
        cmd=$10; for(i=11;i<=NF;i++) cmd=cmd" "$i;
        if(length(cmd)>50) cmd=substr(cmd,1,47)"...";
        printf "%-12s %-8s %-6.1f %-6.1f %-12.1f %-12.1f %-6s %-8s %-10s %-s\n",
               $1,$2,$3,$4,rss_mb,vsz_mb,$7,$8,$9,cmd
    }'
}

# 为常用情况创建别名
alias pscpu='psmon -%cpu'
alias psmem='psmon -%mem'
alias pstop='psmon -%cpu 10'  # 只显示前10个
```



## 其他示例🎈

包裹配合其他工具执行更加复杂的任务

### 查看所有进程（系统级）

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

### 查看某个程序（用 grep 过滤）

```bash
ps -ef | grep python
```

或

```bash
ps aux | grep nginx
```

常用于查找程序是否在运行。

### 其他

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



