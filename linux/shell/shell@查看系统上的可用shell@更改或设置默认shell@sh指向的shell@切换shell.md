[toc]

## abstract

要在 Linux 或 macOS 系统中查看当前可用的 Shell，最直接的方法是查看系统配置文件 `/etc/shells`。这个文件记录了系统管理员允许用户使用的合法 Shell 路径。

你可以通过以下几种方式进行查看：

### 1. 查看所有可用的 Shell

打开终端并输入以下命令：



```bash
cat /etc/shells
```

这会列出系统中安装的所有 Shell 路径，输出通常如下所示：

```bash
$ cat /etc/shells
# Pathnames of valid login shells.
# See shells(5) for details.

/bin/sh
/bin/bash
/bin/rbash
/usr/bin/sh
/usr/bin/bash
/usr/bin/rbash
/bin/zsh
/usr/bin/zsh
/usr/bin/git-shell
```

或者带有计数的方式查看(grep查看)

```bash
$ grep -E '^/.*'  /etc/shells |nl
     1  /bin/sh
     2  /bin/bash
     3  /bin/rbash
     4  /usr/bin/sh
     5  /usr/bin/bash
     6  /usr/bin/rbash
     7  /bin/zsh
     8  /usr/bin/zsh
     9  /usr/bin/git-shell
```



------

### 2. 查看当前正在使用的 Shell

如果你想知道**当前会话**正在运行哪一个 Shell，可以使用以下命令：

- **使用环境变量：**

  ```bash
  echo $SHELL
  ```

- **查看当前进程（更准确）：**

  ```bash
  ps -p $$
  ```

------

```bash
# root @ CxxuColorfulWin10 in /usr/sbin [21:33:17]
$ echo $SHELL
/usr/bin/zsh

# root @ CxxuColorfulWin10 in /usr/sbin [21:34:18]
$ ps -p $$
    PID TTY          TIME CMD
  36809 pts/0    00:00:02 zsh
```



### 3. 查看当前用户的默认 Shell

如果你想确认账号登录时默认加载的 Shell，可以使用 `finger` 命令或者查看 `passwd` 文件：



```bash
grep ^$USER /etc/passwd
```

输出结果的最后一列即为你的默认 Shell。

------

## 查看当前运行的shell是什么shell

通过`echo $0`查询,无论是`dash`,`bash`,`zsh`都支持此用法

```bash
CxxuDesk:~# echo $0
-sh
```

上例表明当前的shell是`sh`

> 输出 `-sh` 意味着你当前运行的是一个**作为登录 Shell (Login Shell) 启动的 `sh`**。
>
> 那个横杠 `-` 是 Unix/Linux 的惯例，表示该 Shell 是在用户登录时直接加载的（读取了 `/etc/profile` 等初始化文件），而不是在进入系统后手动输入 `sh` 启动的子进程。

| **系统类型**               | **sh 指向的真身** | **特点**                                            |
| -------------------------- | ----------------- | --------------------------------------------------- |
| **Debian / Ubuntu**        | **Dash**          | 极简、执行脚本速度极快，不支持数组。                |
| **Alpine Linux / 嵌入式**  | **Ash** (BusyBox) | 极其轻量，常用于容器和路由器。                      |
| **RHEL / CentOS / Fedora** | **Bash**          | 功能最全，但在被当作 `sh` 调用时会进入 POSIX 模式。 |

## 查看当前系统的sh是什么shell

在 Linux 和 macOS 系统中，`/bin/sh` 通常不是一个独立的 Shell，而是一个指向系统默认 POSIX Shell 的**软链接（Symbolic Link）**。

使用`type sh` 查看`sh`链接到哪里

```bash
$ type sh
sh is /usr/sbin/sh
```

也可能是:

```bash
$ type sh
sh is /usr/bin/sh
```

这样还看不出sh到底是什么shell.

下面给出一些方案可供尝试

### 方案1

简单查询:`ls -l /bin/sh`

```bash
$ ls -l /bin/sh
lrwxrwxrwx 1 root root 4 Aug  2 03:56 /bin/sh -> bash
```

或者使用`readlink`代替`ls -l`查询sh指向的shell路径

```bash
cxxu@CxxuColorfulWin10:~$ readlink -f /bin/sh
/usr/bin/dash
```

对于alpine linux,可能是

```bash
CxxuDesk:~# ls -l /bin/sh
ls -l /bin/sh
lrwxrwxrwx 1 root root 12 Feb 13  2025 /bin/sh -> /bin/busybox
```



### 方案2

如果不想要依赖于手动指定的`/bin/sh`查询,可以尝试用`type sh`配合`read`读取`sh`指向的路径,然后使用`ls -l`或者`readlink`解析出sh对应的shell路径

执行语句:` read -r _ _ shpath <<<"$(type sh)" && ls -l "$shpath"`

archilinux上查到(bash)

```bash
$ read -r _ _ shpath <<<"$(type sh)" && ls -l "$shpath"
lrwxrwxrwx 1 root root 4 Aug  2 03:56 /usr/sbin/sh -> bash
```

另一个debian系统上查到(dash)

```bash
cxxu@CxxuColorfulWin10:~$  read -r _ _ shpath <<<"$(type sh)" && ls -l "$shpath"
lrwxrwxrwx 1 root root 4 Feb  4  2025 /usr/bin/sh -> dash
```

### 常见情况总结

| **命令**             | **如果是 Bash**    | **如果是 Dash** | **如果是 Ash (BusyBox)**                |
| -------------------- | ------------------ | --------------- | --------------------------------------- |
| `echo $BASH_VERSION` | 有版本号           | 为空            | 为空                                    |
| `type local`         | 显示是 builtin     | 显示是 builtin  | **报错**（部分旧版 Ash 不支持 `local`） |
| `help`               | 输出极其详细的列表 | 输出简短列表    | 输出 BusyBox 帮助信息                   |

### 查看sh版本信息

这里是一个不是很准确的方案.

有些系统下的 `sh` 虽然是 Bash，但它会以“POSIX 模式”运行。你可以尝试让它自我介绍：

```bash
sh --version
```

- 如果输出包含 `GNU bash`，那么你的 `sh` 就是 **Bash**。
- 如果报错或显示 `dash: 0: Illegal option --`，那么大概率是 **Dash**（因为它不支持 `--version` 参数）。

### 常见 Shell 简介

| **Shell 名称** | **特点**                                                     |
| -------------- | ------------------------------------------------------------ |
| **Bash**       | 大多数 Linux 发行版的默认 Shell，功能强大，兼容性好。        |
| **Zsh**        | 具有强大的补全功能和插件支持（如 Oh My Zsh），macOS 目前的默认 Shell。 |
| **Sh**         | 最基础的 POSIX 标准 Shell，通常用于编写极简的系统脚本。      |
| **Fish**       | 以交互性见长，开箱即用，支持语法高亮和智能建议。             |

## 切换shell

切换 Shell 的方法主要分为**临时切换**和**永久切换**两种。

------

### 1. 临时切换 (仅对当前终端窗口有效)

如果你只是想体验一下其他的 Shell，或者在特定环境下运行脚本，可以直接输入该 Shell 的名称：

- **操作方法**：直接在终端输入 `zsh`、`bash` 或 `fish` 等。
- **退出方法**：输入 `exit` 即可退回到之前的 Shell。

> **提示**：这就像是在当前的 Shell 进程中又开启了一个子进程。

------

### 2. 永久切换 (修改默认配置)

如果你希望以后每次打开终端都使用某个特定的 Shell，需要修改用户的默认配置。

####  `chsh` 命令 (最简单)

`chsh` (change shell) 是最标准的修改方式：

1. **输入命令**：

   ```bash
   chsh -s /bin/zsh
   ```

   *(这里的 `/bin/zsh` 是你想切换到的 Shell 路径，如果不确定路径，可以先用 `which zsh` 查看)*

2. **输入密码**：系统会提示你输入当前用户的登录密码。

3. **重新登录**：设置完成后，通常需要**注销并重新登录**，或者重启终端才能生效。


#### 手动更改配置文件法

在 Alpine Linux 中，更改默认 Shell 的操作与常见的 Ubuntu 或 CentOS 略有不同，因为 Alpine 为了追求极简，默认并没有安装 `chsh`（change shell）工具。

Alpine 中最常用的方法，不需要额外安装工具。

1. 使用编辑器打开文件（例如 `vi`）：

   ```bash
   vi /etc/passwd
   ```

2. 找到你用户的那一行（通常是第一行或最后一行），你会看到类似： `root:x:0:0:root:/root:/bin/sh`

3. 将结尾的 `/bin/sh` 改为 `/bin/bash`： `root:x:0:0:root:/root:/bin/bash`

4. 保存并退出（在 vi 中输入 `:wq`）。

------

### 3. 注意事项 (必读)

- **路径合法性**：你切换到的 Shell 必须列在 `/etc/shells` 文件中。如果不在（例如你自己编译安装的新版 Shell），需要先用 `sudo vi /etc/shells` 将其路径手动添加进去，然后再执行 `chsh`。
- **不要轻易修改 root 的 Shell**：除非你非常专业，否则建议只修改普通用户的 Shell。如果 root 的 Shell 配置出错，可能会导致系统维护时无法登录。

------

### 快速检查命令汇总

| **需求**                  | **命令**                    |
| ------------------------- | --------------------------- |
| 查看所有可用 Shell        | `cat /etc/shells`           |
| 查看当前正在用的 Shell    | `echo $SHELL`               |
| 查找某个 Shell 的安装路径 | `which zsh` 或 `which bash` |

## 配置文件的自动加载问题

在部分老系统或极简系统(例如 Alpine Linux) 中，即使你通过 `chsh` 或修改 `/etc/passwd` 将默认 Shell 改为了 Bash，登录时依然可能“感觉”没有加载 `.bashrc`。

这背后的原因是 Bash 的**两种启动模式**对配置文件的读取规则逻辑不同：

 核心原因：登录 Shell vs 非登录 Shell

当你通过 SSH 或控制台登录系统时，启动的是 **Login Shell**。

- **Login Shell（登录模式）**：它会寻找 `/etc/profile`、`~/.bash_profile`、`~/.bash_login` 或 `~/.profile`，但**不会直接读取 `~/.bashrc`**。
- **Interactive Non-login Shell（交互式非登录模式）**：比如你在终端里输入 `bash` 再次启动一个子 Shell，它才会读取 `~/.bashrc`。

在很多发行版（如 Ubuntu/CentOS）中，默认的 `~/.profile` 里已经写好了调用 `.bashrc` 的脚本，但 **Alpine 的默认用户目录通常是空的**，没有这些初始化文件。

### 解决方案：建立“桥接”

你只需要确保你的登录脚本（`.bash_profile` 或 `.profile`）手动去调用 `.bashrc` 即可。

#### 创建/修改 `~/.bash_profile` (推荐)

在你的用户根目录下执行以下命令：(如果`~/.bash_profile`文件不存在,则会自动创建)覆盖`~/.bash_profile`内容

```bash
if ! [ -f ~/.bash_profile ];then
cat << 'EOF' > ~/.bash_profile
# 如果存在 .bashrc，则加载它
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF
fi
```

#### 修改全局配置 (如果你希望所有用户都生效)

如果你希望所有使用 Bash 的用户登录时都自动加载各自的 `.bashrc`，可以修改 `/etc/profile`，但更标准的做法是确保 `~/.bash_profile` 存在。
