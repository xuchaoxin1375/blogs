## abstract

`ps`（process status）是 **Linux/Unix 系统中用于查看进程信息** 的最基本命令之一，它能展示当前系统中正在运行的进程、它们的状态、资源占用、所属用户、父进程关系等。

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



| 选项              | 含义简述                                | 是否含无TTY进程 | 是否含Session Leader | 典型用途                       |
| ----------------- | --------------------------------------- | --------------- | -------------------- | ------------------------------ |
| `-A`, `-e`        | 显示所有进程（All processes）           | ✅ 是            | ✅ 是                 | 查看整个系统的所有进程（常用） |
| `-a`              | 有TTY的所有进程，排除**Session Leader** | ❌ 否            | ❌ 否                 | 查看用户前台任务               |
| `a`               | 有TTY的所有进程，包括其他用户           | ❌ 否            | ✅ 是                 | 查看所有用户的终端进程         |
| `-d`              | 所有非Session Leader进程                | ✅ 是            | ❌ 否                 | 查看除登录shell外的系统进程    |
| `-N`/`--deselect` | 反选，不显示匹配条件的进程              | ⚙️ 取决于条件    | ⚙️ 取决于条件         | 排除特定进程（如排除bash）     |
| `r`               | 仅显示“运行中”的进程                    | ✅ 是            | ✅ 是                 | 监控当前活动任务               |
| `T`               | 当前终端（TTY）上的所有进程             | ❌ 否            | ✅ 是                 | 仅看当前shell的任务            |
| `x`               | 无TTY的进程（后台/守护）                | ✅ 是            | ✅ 是                 | 查看后台daemon或systemd任务    |

> **Session leader**（会话领导进程）通常是 shell 或 login 程序。
>  排除它们意味着只看用户直接运行的命令。



### 常见用法与参数详解

| 命令               | 作用                        | 说明                                                |
| ------------------ | --------------------------- | --------------------------------------------------- |
| `ps`               | 显示当前终端下的进程        | 只列出和当前 shell 相关的进程                       |
| `ps -e` 或 `ps -A` | 显示系统中所有进程          | （e = every）                                       |
| `ps -f`            | 显示完整格式（full format） | 包含 PPID、启动时间、命令等                         |
| `ps -ef`           | 显示所有进程详细信息        | Linux 常用组合                                      |
| `ps aux`           | BSD 风格，显示所有进程信息  | 与 `-ef` 类似                                       |
| `ps -u <user>`     | 查看指定用户的进程          | 如 `ps -u root`                                     |
| `ps -p <pid>`      | 查看特定进程                | 如 `ps -p 1`                                        |
| `ps -o`            | 自定义输出格式              | 例：`ps -eo pid,ppid,cmd,%mem,%cpu`                 |
| `ps --forest`      | 树状显示进程层级            | 方便查看父子进程关系                                |
| `ps --sort`        | 按字段排序                  | 如 `ps -eo pid,cmd,%mem --sort=-%mem`（按内存降序） |

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

#### 一号进程

| PID  | CMD     | 说明                                                         |
| ---- | ------- | ------------------------------------------------------------ |
| 1    | systemd | Linux 用户空间的**初始化进程**（init system）。它是所有进程的“祖先”。 |

### 输出字段说明

常见的输出列（columns）解释如下：

| 列名    | 含义                                                     |
| ------- | -------------------------------------------------------- |
| PID     | 进程 ID（Process ID）                                    |
| PPID    | 父进程 ID（Parent Process ID）                           |
| USER    | 进程所有者                                               |
| %CPU    | 占用 CPU 百分比                                          |
| %MEM    | 占用内存百分比                                           |
| VSZ     | 虚拟内存大小（**V**irtual Memory **S**i**z**e，单位 KB） |
| RSS     | 实际占用物理内存（Resident Set Size）                    |
| TTY     | 关联的终端（Terminal）                                   |
| STAT    | 进程状态（State）                                        |
| START   | 启动时间                                                 |
| TIME    | 累积 CPU 时间                                            |
| COMMAND | 启动进程的命令及参数                                     |

------

### STAT（进程状态）常见取值

| 状态字母 | 含义                  | 说明                     |
| -------- | --------------------- | ------------------------ |
| R        | Running               | 运行中或可运行（就绪）   |
| S        | Sleeping              | 休眠中（可被唤醒）       |
| D        | Uninterruptible Sleep | 不可中断（等待 I/O）     |
| Z        | Zombie                | 僵尸进程（父进程未回收） |
| T        | Stopped               | 暂停（被信号或调试）     |
| X        | Dead                  | 已终止（很少见）         |

附加标志（第二位）：

| 标志 | 含义                           |
| ---- | ------------------------------ |
| `<`  | 高优先级（higher priority）    |
| `N`  | 低优先级（nice）               |
| `L`  | 页面锁定（real memory locked） |
| `+`  | 属于前台进程组                 |

------

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



