[toc]

## abstract

本文假设读者已经了解了bash和进程的基本概念.

主要介绍bash中的作业控制基础(交互是shell中作业的控制,包括快捷键控制作业以及对应的信号发送);

进程管理和后台作业并发管理的进阶内容,尤其是在脚本中执行的更复杂控制,另见它文;

### 参考资料

- [BashGuide/JobControl - Greg's Wiki](https://mywiki.wooledge.org/BashGuide/JobControl)
- [流程管理 - Greg 的维基百科 --- ProcessManagement - Greg's Wiki](https://mywiki.wooledge.org/ProcessManagement)

## 作业控制



虽然脚本中通常不使用作业控制，但它**在交互式 shell 中非常重要**。作业控制允许您**与后台作业交互、暂停前台作业**等等。

> 许多初学者在交互式shell中可能会有意或无意输入某个组合快捷键,导致某些进程被挂到后台或者终止;了解这部分内容可以帮助用户从容应对这些意外.

在 POSIX 系统中，**作业**以“**进程组**”的形式实现，每个进程组由一个进程担任组长(leader)。

每个终端 (tty) 都**只有一个“前台进程组”(Foreground Process Group)可以与该终端交互**。所有其他**与该终端共享同一控制终端的进程组**都被视为**后台作业**，它们可以处于**运行或挂起**状态。

## 进程组

在 POSIX 系统中，作业控制（Job Control）的底层逻辑是一套严密的**三级层级结构**：会话（Session） > 进程组（Process Group） > 进程（Process）。

> 这种设计是为了解决一个核心矛盾：**一个终端（键盘/屏幕）在同一时间只能交给一个逻辑任务处理，即使这个任务由多个进程组成。**
>

每个“作业”在内核层面都被抽象为一个**进程组**。

> - **组长 (Leader)**：当你运行一个管道命令时（如 `cat file | grep "pattern" | sort`），第一个进程通常成为组长。
>- **PGID (Process Group ID)**：整个进程组的标识符，等于组长的 PID。
> - **原子操作**：信号（如 `SIGINT`）可以一次性发送给整个 PGID。这意味着当你按 `Ctrl+C` 时，内核不是只杀掉 `cat`，而是给这一组的所有进程都发信号，确保它们同步退出。

在 Linux 的世界里，**作业 (Job)** 和 **进程 (Process)** 经常被混为一谈，但从操作系统的管理维度来看，它们其实是“管理视角”与“执行实体”的区别。

简单来说：**进程是内核（Kernel）看你的方式，而作业是 Shell 看你的方式。**

------

### 1. 核心定义与区别

| **维度**     | **进程 (Process)**                                 | **作业 (Job)**                                              |
| ------------ | -------------------------------------------------- | ----------------------------------------------------------- |
| **定义**     | 正在执行的一个程序实例，是系统资源分配的最小单位。 | 用户在 Shell 中输入的一个命令行序列（包含一个或多个进程）。 |
| **管理者**   | **操作系统内核** (Kernel)。                        | **Shell 解释器** (如 Bash, Zsh)。                           |
| **生命周期** | 由 PID (进程 ID) 标识，直到程序结束。              | 由 Job ID 标识，仅在当前终端会话有效。                      |
| **组成**     | 一个独立的执行流。                                 | 可以由**一个或多个**通过管道线连接                          |

------

### 2. 它们的关系：父子与集群

你可以把“作业”看作是一个容器或集合。当你输入一条简单的命令时，作业里只有一个进程；当你使用管道符时，一个作业就包含了多个进程。

场景 A：一对一

```bash
$ sleep 100
```

- **作业 1**：包含 1 个进程 (`sleep`)。

场景 B：一对多

```bash
$ cat access.log | grep "404" | sort
```

- **作业 1**：包含 3 个并行的进程 (`cat`, `grep`, `sort`)。
- 虽然有三个 PID，但在 Shell 看来，它们是一个整体，受同一个作业信号控制（比如你按下 `Ctrl+C`，这三个进程都会停止）。

------

### 3. 前台与后台管理

作业的概念存在，主要是为了让用户能在一个终端里同时处理多个任务。

- **前台作业 (Foreground)：** 占据当前终端，用户必须等它运行完才能输入下一条命令。
- **后台作业 (Background)：** 在命令末尾加 `&`，命令在后台运行，终端立即返回提示符。

#### 常用管理命令

- `jobs`：列出当前 Shell 下的所有作业及其状态。
- `fg %1`：将 1 号作业调回**前台**（Foreground）。
- `bg %1`：将挂起的作业在**后台**（Background）唤醒继续运行。
- `Ctrl+Z`：将当前前台进程**挂起**（暂停）并转入后台作业。

------

### 4. 关键点总结

1. **范围限制**：作业只属于创建它的那个 Shell 终端。如果你关掉终端，该作业（及其下的进程）通常会收到 `SIGHUP` 信号而退出（除非使用了 `nohup` 或 `disown`）。
2. **标识符**：进程用 **PID**（全局唯一），作业用 **Job ID**（在该终端内唯一，通常是个小数字如 `[1]`, `[2]`）。
3. **包含关系**：一个作业是进程组（Process Group）的一种体现。

## 作业控制信号

当进程组长收到信号 `SIGSTOP` 、 `SIGTSTP` 、 `SIGTTIN` 或 `SIGTTOU` 时，作业将被暂停。

linux系统上可用的信号很多,但是和作业控制相关的常用信号主要是如下几个:

| **信号**    | **编号** | **缩写来源 (Full Name)**                    | **触发方式**                     | **在作业管理中的角色**       | **能否捕获**                     |
| ----------- | -------- | ------------------------------------------- | -------------------------------- | ---------------------------- | -------------------------------- |
| **SIGHUP**  | 1        | **SIG**nal **H**ang **UP**                  | 终端关闭/断开                    | 终端退出时发给所有关联作业   | ✅ 可以                           |
| **SIGINT**  | 2        | **SIG**nal **INT**errupt                    | `Ctrl + C`                       | 中断前台作业                 | ✅ 可以                           |
| **SIGQUIT** | 3        | **SIG**nal **QUIT**                         | `Ctrl + \`                       | 退出前台作业并生成 core dump | ✅ 可以                           |
| **SIGKILL** | 9        | **SIG**nal **KILL**                         | `kill -9`                        | 强制杀死作业                 | ❌ **不可以**                     |
| **SIGTERM** | 15       | **SIG**nal **TERM**inate                    | `kill %n` / `kill PID`           | 优雅终止作业（默认信号）     | ✅ 可以                           |
| **SIGCHLD** | 17       | **SIG**nal **CH**i**LD**                    | 子进程终止/停止/恢复             | Shell 收到后更新 `jobs` 列表 | ✅ 可以                           |
| **SIGCONT** | 18       | **SIG**nal **CONT**inue                     | `fg` / `bg` / `kill -CONT`       | 恢复 Stopped 的作业继续运行  | ✅ 可以（但内核无论如何都会恢复） |
| **SIGSTOP** | 19       | **SIG**nal **STOP**                         | `kill -STOP`                     | 强制暂停作业                 | ❌ **不可以**                     |
| **SIGTSTP** | 20       | **SIG**nal **T**erminal **ST**o**P**        | `Ctrl + Z`                       | 挂起前台作业 → Stopped 状态  | ✅ 可以                           |
| **SIGTTIN** | 21       | **SIG**nal **T**erminal **T**ext **IN**put  | 后台进程读终端                   | 自动暂停后台作业             | ✅ 可以                           |
| **SIGTTOU** | 22       | **SIG**nal **T**erminal **T**ext **OU**tput | 后台进程写终端（`tostop`开启时） | 自动暂停后台作业             | ✅ 可以                           |



简要说明:

- SIGTERM:它是系统管理员和自动化脚本关闭进程的首选工具，因为它体现了 Linux 的“契约精神”：**文明请求，有序退出**。(**软终止**。给进程留出时间进行清理（Save & Exit）。信号15)
- SIGCONT:让一个处于“停止状态（Stopped）”的进程重新恢复运行,即使进程忽略此信号，**内核**依然会把进程状态从 `Stopped` 改回 `Running`。它通常作为 `SIGSTOP` 或 `SIGTSTP` 的“解药”出现：当进程收到 `SIGSTOP` 或 `SIGTSTP`（Ctrl+Z）时，它进入 `T` (Stopped) 状态，不再占用 CPU。
- SIGSTOP:由内核或用户（kill）发起，进程不可忽略。

### 典型终止信号值

| **信号名称** | **信号值** | **全称**      | **可否捕获/忽略** | **效果**                 | **形象比喻**                           |
| ------------ | ---------- | ------------- | ----------------- | ------------------------ | -------------------------------------- |
| **SIGTERM**  | 15         | **TERM**inate | **是**            | 优雅地请求进程自行关闭。 | “下班时间到了，请保存好工作关灯离开。” |
| **SIGSTOP**  | 19/17/23   | **STOP**      | **否**            | 暂停进程执行，但不销毁。 | “按下暂停键，原地待命，不准动。”       |
| **SIGKILL**  | 9          | **KILL**      | **否**            | 内核强行立即抹除进程。   | “你被开除了，立刻消失，东西都不准带。” |

 **SIGKILL (9)** 和 **SIGSTOP (19)** 的本质区别在于：一个是**“终点”**，一个是**“暂停键”**。

它们共同的特殊之处在于：**进程无法捕获（Catch）、阻塞（Block）或忽略（Ignore）这两个信号。** 内核握有绝对控制权。

| **特性**     | **SIGKILL (9)**                                | **SIGSTOP (19)**                         | SIGTSTP(20)                        |
| ------------ | ---------------------------------------------- | ---------------------------------------- | ---------------------------------- |
| **最终状态** | **Terminated (终止)**                          | **Stopped (停止/挂起)**                  |                                    |
| **资源释放** | 立即释放所有内存、文件描述符等资源。           | **保留**所有资源，进程状态保存在内存中。 | 保留                               |
| **能否恢复** | **不能**。进程已彻底消失（退出码通常为 137）。 | **能**。发送 `SIGCONT` 即可原地“复活”。  | 能                                 |
| **类似操作** | 拔掉电脑电源。                                 | 按下视频播放器的“暂停”。                 | 请求暂停                           |
| **典型用途** | 强行结束卡死的、无响应的进程。                 | 暂时让出 CPU 给其他任务，或进行调试。    | 前台任务暂时挂到后台并暂时停止运行 |

**SIGKILL 的副作用**：由于进程没机会进行“善后工作”，可能会导致**文件损坏**或**共享内存未释放**。它是最后的手段，你应该先尝试 `kill -15` (SIGTERM)。

**SIGSTOP 的副作用**：如果一个进程持有某个排他锁（Lock）时被 `SIGSTOP` 了，其他等待该锁的进程会一直卡死，直到你恢复这个进程。

**SIGSTOP** 的强大之处在于它的**可逆性**。在以下场景中它是不可替代的：

- **调试 (Debugging)**：当你用 `gdb` 调试程序时，调试器会发送 `SIGSTOP` 让程序在断点处停下，这样你才能检查内存变量。
- **前后台切换**：你在终端按 `Ctrl+Z` 时，发送的是 `SIGTSTP`（可以被程序捕获的停止信号），如果程序不理你，你可以手动发 `SIGSTOP` 强制它进入后台挂起。
- **限制 CPU 占用**：如果你运行了一个极其耗费 CPU 的任务，又不想关掉它，可以先 `SIGSTOP` 它，等半夜 CPU 空闲了再发 `SIGCONT` 让它继续跑。

`SIGTSTP`（Terminal Stop）的设计初衷是**“优雅地挂起”**。

很多复杂的终端程序（如 **Vim**, **Emacs**, **Less**）在用户按下 `Ctrl + Z` 时，不能直接原地“死掉”。它们需要执行以下动作：

1. **重置终端设置**：恢复光标位置，关闭反色显示，把终端控制权还给 Shell。
2. **保存状态**：记录当前的编辑位置。
3. **自我挂起**：在处理完这些杂事后，程序才会发送一个 `SIGSTOP` 给自己，进入休眠。

如果 `SIGTSTP` 是强制的，Vim 会直接卡在屏幕上，你的终端窗口可能会因为没有正确恢复设置而变得乱码或无法输入。

对于普通信号（如 `SIGTERM` 或 `SIGINT`），内核会像递信员一样把信号交给进程，进程可以决定是“拆信执行”还是“直接扔掉”。

但对于 **SIGKILL** 和 **SIGSTOP**：

1. 内核直接拦截该信号。
2. 内核查找进程控制块（PCB）。
3. 内核直接修改进程状态（变为 `EXIT_ZOMBIE` 或 `TASK_STOPPED`）。
4. **进程完全没有机会执行任何代码**（包括清理临时文件、关闭数据库连接等）。

### 信号名缩写

1. SIGTSTP 中的 "T" (Terminal)

这里的 `T` 指的是 **Terminal（终端）**。

- 与 `SIGSTOP` 的“上帝视角”强制停止不同，`SIGTSTP` 是专门为终端交互设计的。
- 程序可以“捕获”这个信号。例如 **Vim**。当你按下 `Ctrl+Z`，Vim 捕获到 `SIGTSTP`，它会先保存终端的原始状态（重置光标、颜色等），然后再让自己进入停止状态。如果没有这个 `T` 的处理逻辑，你的终端在回到 Shell 后可能会出现光标丢失或乱码。

2. SIGTTIN / SIGTTOU 中的 "TT" (Teletype / Terminal)

这里的 `TT` 源自 **TTY（Teletypewriter）**，在 Unix 历史上代表终端设备。

- **IN** = **Input**（输入）：后台进程“进”不去终端读数据。
- **OU** = **Output**（输出）：后台进程“出”不到终端写数据。

3. `SIGSTOP` 就是最纯粹的、系统级的“暂停键”。

- 它不带任何前缀（如 Terminal），因为**它不关心你是否在终端运行**。
- 它就像是进程调度器的“定身术”，直接修改进程在内核中的状态位（从 `TASK_RUNNING` 变为 `TASK_STOPPED`）。

每当**后台作业**尝试从终端读取或写入时，都会自动发送信号 `SIGTTIN` （如果用户发出信号 `stty tostop` ，则还会发送信号 `SIGTTOU` ）——这就是为什么 `cat &` 会立即暂停而不是在后台运行的原因。

### 前台作业管理快捷键

终端上的某些按键操作会向**前台进程组中的所有进程发送信号**。

这些信号可以用 `stty` 进行配置，但通常设置为默认值：

- Ctrl-Z 向前台作业发送 `SIGTSTP` （通常会**暂停该作业**(terminal stop)）。
- Ctrl-C 向前台作业发送 `SIGINT` （通常是**终止该作业**(interrupt）。
- Ctrl-\ 向前台作业发送 `SIGQUIT` （通常会导致其**崩溃并中止**(quit)）



### 完整信号列表

- 通过`man 7 signal`查阅完整信号介绍.在线版本:[signal(7) - Linux manual page](https://man7.org/linux/man-pages/man7/signal.7.html)
- `kill -l`列出可用的信号列表

### stty命令

stty - change and print terminal line settings

`stty` 是 **S**et **T**ty 的缩写，它是类 Unix 系统中用于显示和修改 **终端行设置（Terminal Line Settings）** 的核心工具。stty不是shell的内置命令.

简单来说，`stty` 决定了你的键盘输入如何变成系统指令，以及系统的输出如何显示在你的屏幕上。它是用户、终端（TTY 驱动）和程序之间的“翻译官”。

| **功能分类**   | **常用参数**         | **描述**                                      |
| -------------- | -------------------- | --------------------------------------------- |
| **状态查询**   | `stty -a`            | 显示**所有**当前的终端设置。                  |
| **回显控制**   | `echo` / `-echo`     | 控制输入是否显示在屏幕上（常用于隐藏密码）。  |
| **特殊键设置** | `erase` / `intr`     | 定义删除键、中断键等快捷键。                  |
| **作业控制**   | `tostop` / `-tostop` | 禁止/允许后台进程向终端输出。                 |
| **行编辑模式** | `icanon` / `-icanon` | 开启/关闭标准模式（行缓冲 vs 字符实时响应）。 |
| **保存与恢复** | `g`                  | 以可读格式保存设置，用于后续恢复。            |

#### A. 隐藏密码输入 (`echo`)

当你编写 Shell 脚本需要用户输入敏感信息时，这是最常用的命令

```bash
stty -echo          # 关闭回显
read -p "请输入密码: " password
stty echo           # 重新开启回显
echo -e "\n密码已记录"
echo "$password"
```

#### B. 解决“按 Backspace 出现 ^H”的问题

有时候在某些服务器或 Docker 容器里，按删除键会显示 `^H`。你可以通过 `stty` 重新定义：

```bash
stty erase '^H'     # 将 ^H 绑定为删除操作
```

#### C. 修改中断快捷键 (`intr`)

如果你觉得 `Ctrl+C` 太容易误触，想改成 `Ctrl+K`：

```bash
stty intr '^k'
```



##  启用作业控制



交互式 shell 中**默认启用作业控制**。可以通过 `set -m` 或 `set -o monitor` **为脚本启用作业控制**。

可以通过按 Ctrl-Z 暂停前台作业。

在 `bash` 中**无法引用前台作业**：如果存在**除 bash 之外的前台作业**，则 bash 会等待该作业终止，因此无法执行任何代码（即使是陷阱也会延迟到前台作业终止后才会执行）。

因此，以下命令仅**适用于后台（和已暂停的）作业**。



## 作业标识符(job specification)

在 Bash 和类 Unix 系统的作业控制（Job Control）中，**jobspec** 是 **Job Specification** 的缩写，意为**“作业标识符”**。

作业标识符或“`jobspec`”是指引用作业所组成的进程的一种方式。

简单来说，当你在终端后台运行一个或多个任务时，系统会给**每个任务分配一个编号**，这个以 `%` 开头的编号就是 **jobspec**。

> 使用`%...`的表达式来引用作业

**它是除了进程 ID（PID）之外，另一种引用和操作后台进程的方式。**

------

### 1. jobspec 的常见引用形式

| **形式**             | **含义**                                                     | **示例**      |
| -------------------- | ------------------------------------------------------------ | ------------- |
| **`%n`**             | **引用**作业表示符(编号)为 `n` 的作业。                      | `fg %1`       |
| **`%+`** 或 **`%%`** | 引用**最后进入后台**或**被停止的作业**,`jobs`列出的作业中被`+`标记的作业）。如果没有指定作业标识符， `fg` 和 `bg` 将作用于这个作业。 | `kill %%`     |
| **`%-`**             | 引用**前一个**作业（当前作业之前的那个）。                   | `bg %-`       |
| **`%string`**        | 引用命令行以 `string` 开头的作业。                           | `fg %vim`     |
| **`%?string`**       | 引用命令行中包含 `string` 的作业。                           | `kill %?test` |

------

### 2. 为什么要用 jobspec 而不是 PID

1. **更短、更易记**：PID 通常是五位数字（如 `28451`），而 jobspec 通常只是个位数字（如 `%1`）。
2. **更直观**：jobspec 直接对应你在**当前终端启动的任务顺序**。
3. **支持模糊匹配**：你可以通过 `%name` 直接找到任务，而不需要先用 `ps` 命令去查 PID。

------

### 3. 实战场景演示

假设你在终端执行了以下操作：

- `vim file.txt` -> 按下 `Ctrl+Z` 挂起。
- `sleep 500 &` -> 后台运行。

```bash
# cxxu@CxxuDesk 18:10:47> <~>
$ vim file.txt

[1]+  Stopped                    nvim file.txt

# cxxu@CxxuDesk 18:10:50> <~>
$ sleep 500 &
[2] 4048

# 查看现有作业
# cxxu@CxxuDesk 18:10:57> <~>
$ jobs
[1]+  Stopped                    nvim file.txt
[2]-  Running                    sleep 500 &
```

执行`fg`(将后台作业移动到前台,本例中`[1]`被移动到前台)

```bash
# cxxu@CxxuDesk 18:11:02> <~>
$ fg
nvim file.txt
# cxxu@CxxuDesk 18:13:10> <~>
$ jobs
[2]+  Running                    sleep 500 &
```



- **`[1]` 和 `[2]`** 就是 jobspec 的编号。
- **`+`** 代表当前作业（Default Job）。
- **`-`** 代表前一个作业。



### jobspec应用

当你想要对特定的后台任务发送信号时，通过jobspec 非常方便。结合我们之前讨论的 `SIGSTOP` 等信号：

- **挂起后再运行**：`bg %1`（给作业 1 发送 `SIGCONT` 并放入后台运行）。
- **带回前台**：`fg %vim`（根据命令名将 vim 任务带回前台）。
- **强行终止**：`kill -9 %2`（给作业 2 发送 `SIGKILL`）。



------

### 总结：jobspec vs PID

| **维度**   | **jobspec (%)**            | **PID**                |
| ---------- | -------------------------- | ---------------------- |
| **范围**   | 仅限于**当前终端会话**。   | **全系统**唯一。       |
| **生存期** | 任务结束或关闭终端即消失。 | 进程运行期间始终存在。 |
| **便利性** | 极高，适合交互式操作。     | 较低，适合自动化脚本。 |

### 高级用法

通过使用 `jobs -x '命令 参数...'`，可以**针对特定的作业（jobspec）运行任意命令**。该功能会将参数中看起来像 jobspec 的部分替换为对应进程组组长（process group leader）的 **PID**，然后执行该命令。

> 例如，执行 `jobs -x strace -p %%` 将会把 `strace` 追踪工具附加到当前作业上（这在作业处于**后台运行状态**而非暂停状态时最为有用）。
>
> `strace` 是 Linux 环境下最强大的诊断、调试和教学工具之一。它的全称是 **S**ystem **Trace**，专门用来监视进程与操作系统内核之间的“对话”——即 **系统调用（System Calls）** 和 **信号（Signals）**。
>
> - strace - trace system calls and signals
>
> 如果你把进程看作一个黑盒，`strace` 就像是一台 **X光机**，能让你看到程序每一步是在读哪个文件、连哪个网络端口、或者在哪一步卡住了。
>
> 在 Linux 中，用户态的程序（如 `ls`, `vim`, `python`）无法直接操作硬件或读写磁盘，必须通过内核提供的“中转站”（系统调用）来发出请求。`strace` 通过内核的 `ptrace` 机制拦截这些请求并将其打印出来。
>
> **`strace -p <pid>`**附加（Attach）到已经运行的进程上。例如`strace -p 1234`,`strace -p %%`

最后，**单独的 jobspec 也可以直接当作命令使用**：例如直接输入 `%1` 等同于执行 `fg %1`（调回前台），而输入 `%1 &` 则等同于执行 `bg %1`（放入后台运行）。

## 作业控制的综合用例

### 演示用的shell函数

使用方法:不要直接在当前shell中调用,而建议使用`()`包裹函数名调用

```bash
# 将一个每秒钟打印1个数字,可以指定最多打印的次数(从1开始打印)
demo_job() {
    local max=${1:-60}  # 默认运行 60 秒
    local i=1
    echo "--- 作业开始 (PID: $$, 预计运行 ${max}s)  (输入 Ctrl+Z 挂起此任务)---"
    while [ $i -le $max ]; do
        # 打印当前秒数和进程 ID
        printf "[$(date +%F-%T)]任务进度: [%2d/%2d] \n" $i $max
        sleep 1
        ((i++))
    done
    echo "--- 作业完成 ---"
}
```



### bg命令恢复运行被挂起的后台

```bash

# (base) cxxu@CxxuDesk 10:04:41> <~>
$ (demo_job 20 )
--- 作业开始 (PID: 4439, 预计运行 20s)  (输入 Ctrl+Z 挂起此任务)---
[2026-03-01-10:04:52]任务进度: [ 1/20]
[2026-03-01-10:04:54]任务进度: [ 2/20]
[2026-03-01-10:04:55]任务进度: [ 3/20]
^Z
[1]+  Stopped                    ( demo_job 20 )

# (base) cxxu@CxxuDesk 10:04:55> <~>
$ %1
( demo_job 20 )
[2026-03-01-10:04:59]任务进度: [ 4/20]
[2026-03-01-10:05:00]任务进度: [ 5/20]
[2026-03-01-10:05:01]任务进度: [ 6/20]
^Z
[1]+  Stopped                    ( demo_job 20 )

# (base) cxxu@CxxuDesk 10:05:02> <~>
$ jobs
[1]+  Stopped                    ( demo_job 20 )


```

使用`bg`命令恢复被挂起到后台的作业,让其继续执行:

> 可以发现,bg命令执行完后,shell提示`[1]+ ( demo_job 20 ) &`
>
> 这表明后台任务(`%1`)被继续执行(`&`表示后台执行)
>
> 不过可以发现,后台继续执行,由于触发打印语句,当前终端会接收到输出,并且执行结束后,shell提示符不会自动刷新,需要用户输入回车,此时会返回`[1]+  Done                       ( demo_job 20 )`表示后台作业执行完毕(done).

```bash

# (base) cxxu@CxxuDesk 10:08:17> <~>
$ bg
[1]+ ( demo_job 20 ) &

# (base) cxxu@CxxuDesk 10:08:20> <~>
$ [2026-03-01-10:08:20]任务进度: [ 7/20]
[2026-03-01-10:08:21]任务进度: [ 8/20]
[2026-03-01-10:08:22]任务进度: [ 9/20]
...
[2026-03-01-10:08:31]任务进度: [18/20]
[2026-03-01-10:08:32]任务进度: [19/20]
[2026-03-01-10:08:33]任务进度: [20/20]
--- 作业完成 ---

[1]+  Done                       ( demo_job 20 )

# (base) cxxu@CxxuDesk 10:08:41> <~>
```



### 使用子shell演示作业

将一个每秒钟打印1个数字的任务放入子shell进程中运行

这里使用的for循环实现,而for语句被shell解释为一系列重复执行的命令序列,本例中是一些打印语句和sleep命令;

> 为了演示效果,我们不在当前shell中直接执行for循环,是为了保护此任务的进程组执行流,例如`sleep`命令恢复过来原来的执行流不被打断

```bash

$ (for i in {1..20};do { echo "$i.";sleep 1; } done)
1.
2.
^Z #输入ctrl+z (sigtstp(20))将作业挂起到后台暂停执行
[1]+  Stopped                    ( for i in {1..20};...)

# fg命令尝试将作业1调回"前台"继续运行(从3开始继续打印)
# cxxu@CxxuDesk 19:17:03> <~>
$ fg %1
( for i in {1..20};
do
    { echo "$i."; sleep 1; };
done )
3.
4.
5.
6.
^Z
[1]+  Stopped                    ( for i in {1..20};...)

#直接使用jobspec来恢复作业(%1相当于fg %1)
# cxxu@CxxuDesk 19:17:14> <~>
$ %1
( for i in {1..20};
do
    { echo "$i."; sleep 1; };
done )
7.
8.
9.
10.
```

当你使用小括号时，Shell 会启动一个**子 Shell (Subshell)** 来运行括号内的所有命令。

- **挂起 (`Ctrl + Z`)**：整个**子 Shell 进程组**被挂起。作为一个“作业”，它的状态被保存在作业列表中。
- **恢复 (`fg`)**：整个子 Shell 被唤醒。它会从刚才 `sleep` 停止的地方继续，**跑完剩下的循环**。
- **结果**：你按 `fg` 后，它会继续打印 `i+1, i+2...` 直到 20。

如果不使用`()`开辟新到shell进程,则效果如下:

```bash
$ for i in {1..20};do { echo "$i.";sleep 1; } done
1.
2.
^Z
[1]+  Stopped                    sleep 1
# cxxu@CxxuDesk 19:14:45> <~>
$ fg %1
sleep 1
```

现象是：**原本运行的是一个 `for` 循环，但当你按下 `Ctrl+Z` 并用 `fg` 恢复时，它似乎变成了只运行 `sleep 1`。**

> 注意到shell在接收到ctrl+z后打印的[1]+  Stopped                    sleep 1 
>
> 表明被挂起的是`sleep 1`这个命令.

**信号的传递**：`Ctrl+Z` 发送的是 `SIGTSTP` 信号。信号会发送给**当前前台进程组**。

- `sleep 1` 是当前正在运行的外部命令（子进程），它接收到信号并停止了。
- **关键点**：`for` 循环本身是由父进程（Bash Shell）解释执行的逻辑结构，它不是一个独立的外部命令。

**Bash 的作业创建**：在执行循环体内部的外部命令时，Bash 会将这个具体的命令（即 `sleep 1`）放入作业列表。

**作业标识的改变**：

- 当你按下 `Ctrl+Z`，Bash 认为你想要挂起的是当前正在阻塞 Shell 的那个任务。
- 由于 `sleep 1` 被挂起了，Bash 会显示 `[1]+ Stopped sleep 1`。此时，**父进程中的 `for` 循环其实还在继续尝试运行**（或者说由于子进程停止，它处于一种逻辑中断状态）。

当你执行 `fg %1` 时，你只是在告诉 Bash：“把刚才停止的那个 `sleep 1` 带回前台运行。”

- **结果**：`sleep 1` 跑完那一秒钟后，命令就退出了。
- **循环丢失了**：因为在你的语法结构中，`for` 循环是在当前的 Shell 进程中直接解析的。当你挂起了子进程，Bash 的执行流被破坏了。在某些复杂的交互环境下，Bash 无法自动恢复整个复杂的 `for` 循环上下文，导致循环剩余的部分（3 到 20）被丢弃或失效。

------

## 作业管理命令

| **命令**      | **全称/含义**  | **主要功能**                                                | **常用示例**              |
| ------------- | -------------- | ----------------------------------------------------------- | ------------------------- |
| **`jobs`**    | **Jobs**       | 列出当前 Shell 会话中所有的后台及停止的任务。               | `jobs -l` (显示 PID)      |
| **`bg`**      | **BackGround** | 将挂起（Stopped）的任务在**后台**重新运行。                 | `bg %1`                   |
| **`fg`**      | **ForeGround** | 将后台或挂起的任务转到**前台**运行。                        | `fg %2`                   |
| **`kill`**    | **Kill**       | 向指定作业发送信号（默认 `SIGTERM`）。                      | `kill %1` 或 `kill -9 %1` |
| **`wait`**    | **Wait**       | 等待后台作业完成，完成后才继续执行后续命令。                | `wait %1`                 |
| **`disown`**  | **Disown**     | 从 Shell 的作业列表中**移除**作业（使其不受 SIGHUP 影响）。 | `disown %1`               |
| **`suspend`** | **Suspend**    | 暂停**当前 Shell** 自身的执行（需 `fg` 恢复）。             | `suspend -f`              |
| **`stop`**    | **Stop**       | 停止（暂停）一个后台作业（某些系统内建）。                  | `stop %1`                 |

- **`fg` (ForeGround)**：
  1. 向后台作业发送 `SIGCONT`。
  2. 将该作业设置为控制终端的前台进程组。
- **`bg` (BackGround)**：
  1. 向作业发送 `SIGCONT`。
  2. 让作业在后台继续运行。

作业控制功能启用以下命令：

- `jobs`:列出作业状态,可以指定多个具体作业,如果不使用选项,则所有活跃的作业都被显示出来

  **`jobs`** [ *选项* ] [ *作业规范* ...]：**列出已挂起和后台作业**。选项包括 `-p` （仅列出进程 ID）、 `-s` （仅列出已挂起的作业）和 `-r` （仅列出**正在运行的后台作业**）。如果指定了一个或多个作业规范，则所有其他作业都将被忽略。

  ```bash
  $ help jobs
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

  

  ```bash
  $ jobs
  [1]   Running                    sleep 500 &
  [2]   Running                    sleep 400 &
  [3]-  Running                    sleep 300 &
  [4]+  Running                    sleep 350 &
  # 带上作业对应的进程ID
  $ jobs -l
  [1]   4074 Running                    sleep 500 &
  [2]   4076 Running                    sleep 400 &
  [3]-  4078 Running                    sleep 300 &
  [4]+  4081 Running                    sleep 350 &
  ```

  

- **`fg`** [ *jobspec* ]: 将**后台作业移至前台**。

  ```bash
  $ help fg
  fg: fg [job_spec]
      Move job to the foreground.
  
      Place the job identified by JOB_SPEC in the foreground, making it the
      current job.  If JOB_SPEC is not present, the shell's notion of the
      current job is used.
  
      Exit Status:
      Status of command placed in foreground, or failure if an error occurs.
  ```

  将指定作业标识符对应的作业移动到前台,如果没有指定作业标识符,则shell标记为当前作业(`+`号标记)的对应作业会被移动到前台

- **`bg`** [ *jobspec* ...]: 在后台运行已挂起的作业。

  ```bash
  $ help bg
  bg: bg [job_spec ...]
      Move jobs to the background.
  
      Place the jobs identified by each JOB_SPEC in the background, as if they
      had been started with `&'.  If JOB_SPEC is not present, the shell's notion
      of the current job is used.
  
      Exit Status:
      Returns success unless job control is not enabled or an error occurs.
  ```

  允许指定多个jobspec,也可以省略指定jobspec(此时作用于当前spec)

- **`suspend`** ：暂停 shell（当父进程是具有作业控制的 shell 时，这非常有用）。

  ```bash
  $ help suspend
  suspend: suspend [-f]
      Suspend shell execution.
  
      Suspend the execution of this shell until it receives a SIGCONT signal.
      Unless forced, login shells and shells without job control cannot be
      suspended.
  
      Options:
        -f        force the suspend, even if the shell is a login shell or job
                  control is not enabled.
  
      Exit Status:
      Returns success unless job control is not enabled or an error occurs.
  ```

  

其他用于与作业交互的命令包括：

- **`kill`** 可以接受**作业标识符**(jobspec)而不仅仅是进程 ID(both PID and JOBSPEC)。

  ```bash
  $ help kill
  kill: kill [-s sigspec | -n signum | -sigspec] pid | jobspec ... or kill -l [sigspec]
      Send a signal to a job.
  
      Send the processes identified by PID or JOBSPEC the signal named by
      SIGSPEC or SIGNUM.  If neither SIGSPEC nor SIGNUM is present, then
      SIGTERM is assumed.
  
      Options:
        -s sig    SIG is a signal name
        -n sig    SIG is a signal number
        -l        list the signal names; if arguments follow `-l' they are
                  assumed to be signal numbers for which names should be listed
        -L        synonym for -l
  
      Kill is a shell builtin for two reasons: it allows job IDs to be used
      instead of process IDs, and allows processes to be killed if the limit
      on processes that you can create is reached.
  
      Exit Status:
      Returns success unless an invalid option is given or an error occurs.
  ```

  用例

  ```bash
  $ jobs
  [1]-  Running                    sleep 300 &
  [2]+  Running                    sleep 400 &
  # cxxu@CxxuDesk 18:31:54> <~>
  $ kill %1
  [1]-  Terminated                 sleep 300
  # cxxu@CxxuDesk 18:31:58> <~>
  $ jobs
  [2]+  Running                    sleep 400 &
  ```

  如果没有指定`SIGSPEC`和`SIGNUM`中的任何一个,则会默认发送`SIGTERM`信号

- **`disown`** 指示 `bash` 忽略一个已存在的作业。这可以防止 bash 自动向该作业中的进程发送 `SIGHUP` ，但也意味着该作业无法再通过 jobspec 引用。

## 后台作业的意义

作业控制允许你**在单个终端会话中同时运行多个程序**。（这在过去非常重要，因为那时你的桌面上只有一个终端，而且无法创建虚拟终端来添加更多终端。）

> 在现代系统和硬件上，你有了更多选择——例如，你可以在终端中运行 `screen` 或 `tmux` 来创建虚拟终端。
>
> 或者，在 X 会话中，你可以打开更多 `xterm` 或类似的终端模拟器（你也可以将两者混合使用）。

但有时候，一个简单的任务控制功能“暂停并后台运行”就非常实用。

比如，你启动了一个备份任务，但**它耗时比预期要长**。你可以**使用 Ctrl-Z 暂停备份，然后使用 `bg` 将其置于后台运行，这样你就可以返回到 shell 提示符**，在同一个终端会话中处理其他任务，同时备份仍在进行。

