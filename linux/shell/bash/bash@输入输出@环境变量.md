[toc]





## 输入和输出



Bash 脚本中的输入输出是一个**复杂的主题，因为它的实现方式非常灵活**。本章仅对其中的可能性进行浅尝辄止的介绍。

### 输入

*输入*指的是程序接收（或读取）的任何信息。

Bash 脚本的输入可以来自多个不同的地方：

1. 命令行参数（放置在[位置参数](https://mywiki.wooledge.org/BashGuide/Parameters)中）
2. 环境变量，继承自启动脚本的进程。
3. 文件
4. *文件描述符*还可以指向其他任何内容（**管道、终端、套接字**等）。这将在下文中讨论。

### 输出

*输出*指的是程序生成（或写入）的任何信息。Bash 脚本的输出也可以发送到许多不同的位置：

1. 传递给其他程序的命令行参数
2. 传递给其他程序的环境变量
3. 文件
4. 文件描述符可以指向的其他任何内容

在 shell 脚本编程中，输入和输出至关重要。几乎所有脚本的核心要求都是：弄清楚输入来自哪里、输入是什么格式，以及为了产生所需的输出，必须对输入进行哪些处理。



## bash中文件重定向的默认设置

在 Bash 中，重定向默认会**覆盖**目标文件（使用 `>`），而不会追加。

如果你希望**禁止覆盖现有文件**以防止意外数据丢失，可以使用 `set -C`（或 `set -o noclobber`）来启用“noclobber”模式。

### 1. 启用 noclobber（禁止覆盖）
```bash
set -C
# 或
set -o noclobber
```
启用后，如果使用 `>` 重定向到一个**已存在的文件**，Bash 会报错，拒绝覆盖：
```bash
echo "test" > existing_file.txt
# 若 existing_file.txt 已存在，会提示：-bash: existing_file.txt: cannot overwrite existing file
```

### 2. 强制覆盖（即使启用了 noclobber）
如果已启用 `noclobber`，但仍想覆盖文件，可以使用 `>|`（或 `>!`，在某些 Shell 中）：
```bash
echo "test" >| existing_file.txt
```
这会**强制覆盖**，无视 `noclobber` 设置。

### 3. 临时禁用 noclobber（仅当前命令）
你也可以用子 shell 或命令前加 `set +C` 来临时关闭：
```bash
(set +C; echo "test" > existing_file.txt)
```

### 4. 查看当前是否启用 noclobber
```bash
set -o | grep noclobber
```
输出为 `noclobber on` 或 `noclobber off`。

---

### 小结
| 操作                       | 命令             |
| -------------------------- | ---------------- |
| 默认覆盖                   | `echo x > file`  |
| 禁止覆盖（安全模式）       | `set -C`         |
| 强制覆盖（即使 noclobber） | `echo x >| file` |
| 关闭 noclobber             | `set +C`         |

如果你在写脚本并重视数据安全，建议在脚本开头加上 `set -C`。

## 1. 命令行参数



对于许多脚本来说，我们最关心的（或者说唯一关心的）输入是脚本从命令行接收的参数。正如我们在 [“参数”](https://mywiki.wooledge.org/BashGuide/Parameters) 章节中看到的，每个脚本都有一些***特殊参数***可以用来存储这些参数。这些参数被称为***位置参数*** 。它们是一个非常简单的**字符串数组**，以数字索引排列（实际上，在 POSIX shell 中，它们是 shell *唯一的*数组,bash是）。

> - **POSIX Shell**
>   - 是 **POSIX 标准**（Portable Operating System Interface，可移植操作系统接口）中定义的 **Shell 命令语言规范**（详见 POSIX.1-2017 第二章）。
>   - 它规定了一个**最小、可移植**的 Shell 行为标准。
>   - 符合 POSIX 的 Shell 有：`dash`、`ash`、`ksh`（在 POSIX 模式下）、`bash`（当以 `sh` 方式启动或启用 **POSIX 模式**时）。
> - **Bash（Bourne-Again SHell）**
>   - 是 GNU 项目开发的一个**具体的 Shell 实现**，基于经典的 Bourne Shell（`sh`）。
>   - 提供了大量**扩展功能**，但**默认不完全遵循 POSIX 标准**。
>   - 可通过 `set -o posix` 或以 `sh` 名称调用（如 `/bin/sh -> bash`）进入 POSIX 兼容模式。
> - **Bash 是 POSIX Shell 的超集**（几乎兼容）：
>   - 大多数 POSIX 脚本可以在 Bash 中运行。
>   - 但 **Bash 特有的语法**（如 `[[ ]]`、数组、`{1..5}` 等）**在纯 POSIX Shell（如 `dash`）中会报错**。
> - **POSIX 脚本更通用**：
>   - 所有符合 POSIX 的系统（Linux、macOS、BSD 等）都必须提供一个 POSIX 兼容的 `/bin/sh`。
>   - 因此，用 `#!/bin/sh` 编写的脚本**可移植性更强**。

第一个位置参数用 `$1` 表示；第二个用 `$2` 表示；依此类推。从第九个位置参数开始，必须使用花括号来引用它们： `${10}` 、 `${11}` 等。但在实践中，你几乎不需要这样做，因为有更好的方法来批量处理它们。

除了逐个引用位置参数之外，您还可以使用 ` "$@"` 替换来**引用所有位置参数**。这里的双引号**至关重要** 。如果不使用双引号，每个位置参数都会被拆分成单词并进行通配符匹配。这是您不希望看到的。

使用双引号可以告诉 Bash，您希望**将每个参数保留为一个单独的单词**,不要试图分割它们。
在开始编写脚本之前，先确定输入数据的来源。如果可以自行设计脚本中的数据流，那么请选择一种适合所处理数据类型的方式。**如果需要传递文件名，将其作为参数传递是一个绝佳的方法，因为每个文件名都被封装成一个单词，可以直接使用**。

- **常见问题解答中：
  [如何轻松地处理脚本的命令行参数（选项）？](https://mywiki.wooledge.org/BashFAQ/035)**

> 初学者可以跳过细节,继续查看其他输入输出的内容
>

------

### shift命令

处理位置参数的另一种方法是**在使用后逐个删除它们**。

为此，程序内置了一个名为 `shift` 的**特殊命令**。当您发出 `shift` 命令时，第一个位置参数（ `$1` ）会被删除。第二个参数变为 `$1` ，第三个参数变为 `$2` ，依此类推。因此，如果您愿意，可以编写一个循环，不断重复使用 `$1` 。

在实际脚本中，通常会结合使用这些技术。循环处理以 `-` 开头的 `$1` ，以此来处理选项。

然后，当所有选项都被处理并移出后，剩下的内容（在 `"$@"` 中）很可能就是我们要处理的**文件名**。

```bash
$ help shift
shift: shift [n]
    Shift positional parameters.

    Rename the positional parameters $N+1,$N+2 ... to $1,$2 ...  If N is
    not given, it is assumed to be 1.

    Exit Status:
    Returns success unless N is negative or greater than $#.
```



## 2. 环境



每个程序都会从**其父进程继承某些信息、资源、权限和限制**。（有关此主题的更深入讨论，请参阅[进程管理 ](https://mywiki.wooledge.org/ProcessManagement#theory)。）其中一种资源是一组称为***环境变量***的变量。

在 Bash 中，**环境变量的工作方式与我们常用的 shell 变量非常相似**。唯一的区别在于，它们**在脚本启动时就已经设置好了**；我们无需手动设置。

**传统上，环境变量的名称全部由大写字母组成，例如 `PATH` 或 `HOME`** 。这有助于避免创建与环境变量冲突的变量；只要你的变量都至少包含一个小写字母，就无需担心会意外地与环境变量发生冲突。

> （Bash 的**特殊变量**也全部由大写字母组成，例如 `PIPESTATUS` 。这样做也是出于完全相同的原因——为了避免你的变量被 Bash 覆盖。）

通过环境变量向程序传递信息在很多情况下都很有用。其中之一就是**用户偏好**信息的传递。

> 在类 Unix 系统上，并非每个用户对应用程序都有相同的喜好，而且在某些情况下，他们可能使用的语言也不尽相同。因此，如果用户能够告诉他们运行的*每个*应用程序他们最喜欢的编辑器（ `EDITOR` 环境变量）或他们使用的语言（构成用户[区域](https://mywiki.wooledge.org/locale)设置的各种环境变量），那就非常有用。
>
> 环境变量可以设置在每个用户的 [DotFiles 文件](https://mywiki.wooledge.org/DotFiles)中，然后它们会自动传递给用户从登录会话开始运行的每个程序。

环境变量也可以非常方便地进行**动态调整**（比将相同信息存储在文件中要容易得多）。在 Bash 中运行命令时，您可以选择指定一个仅在该命令执行期间生效的**临时环境变量更改**。这可以通过在命令前加上 `VAR=value` 来实现。以下是一个示例：



```bash
$ ls /tpm
ls: no se puede acceder a /tpm: No existe el fichero o el directorio
$ LANG=C ls /tpm
ls: cannot access /tpm: No such file or directory
```



`LANG=C` 临时环境**不会导致用户的区域设置发生改变，只会影响输入该环境的命令**。

在脚本中，如果您知道某些信息存储在环境变量中，就可以像使用其他变量一样使用它：



```bash
if [[ $DISPLAY ]]; then
    xterm -e top
else
    top
fi
```



如果设置了环境变量 `DISPLAY` （且不为空），则运行 `xterm -e top` ；否则，运行 `top` 。

### 环境变量继承(export)

如果要将信息放入环境中供**子进程继承**，可以使用 `export` 命令：

```bash
export MYVAR=something
```



棘手之处在于，你对环境所做的更改只会传递给你的**子程序** 。**你无法更改正在运行的程序或未运行的程序的环境**。

### 包装脚本(包装器)

**切换环境后再运行其他程序是非常常见的做法**。专门执行此操作的脚本称为[包装脚本（WrapperScript](https://mywiki.wooledge.org/WrapperScript) ）。

*包装脚本*是 shell 脚本**最常见的用途之一**。包装脚本的作用不是重新实现现有工具的功能，而是**稍作修改后将输入传递给其他工具**。这可以节省大量人力。

包装器常用的命令是`exec`

### **最基本**的包装脚本

```bash
#!/bin/sh
exec /some/weird/place/toolname ${1+"$@"}
```

#### `exec`

- `exec` 是 shell 内建命令，它的作用是**用指定的程序替换当前 shell 进程**。

  ```bash
  $ help exec
  exec: exec [-cl] [-a name] [command [argument ...]] [redirection ...]
      Replace the shell with the given command.
  
      Execute COMMAND, replacing this shell with the specified program.
      ARGUMENTS become the arguments to COMMAND.  If COMMAND is not specified,
      any redirections take effect in the current shell.
      
        Options:
        -a name   pass NAME as the zeroth argument to COMMAND
        -c        execute COMMAND with an empty environment
        -l        place a dash in the zeroth argument to COMMAND
  ```

  

- 换句话说，执行 `exec` 后，当前 shell 脚本进程会直接变成 `/some/weird/place/toolname`，不会 fork 新进程。

- 这样做有几个好处：

  - 节省系统资源（少一个进程）；
  - 信号、退出码等会直接由实际程序处理和返回，行为更“透明”；
  - 父进程看到的是 `toolname` 的 PID，而不是这个 wrapper 的 PID。

当你运行 `exec` 后接一个命令时，系统**不会**创建一个新的进程，而是用新程序的代码**替换掉**当前正在运行的进程。

- **PID（进程 ID）不变**：虽然程序的内容变了，但在系统任务管理器里看到的身份证号（PID）还是原来的那个。
- **没有回头路**：一旦 `exec` 成功执行，原来的脚本或程序就不复存在了。新程序运行结束后，整个进程就直接退出了，不会返回执行原脚本的下一行。

#### `${1+"$@"}`

- 这是一个**向后兼容的参数传递写法**，用于安全地传递所有命令行参数。
- `$@` 表示脚本接收到的所有位置参数（即 `$1`, `$2`, ...），每个参数保持为独立的“单词”（即使包含空格）。
- 但某些非常老的 shell（如老版本的 Bourne shell）在 `$@` 为空时（即没有传入参数）会出错或行为异常。
- `${1+"$@"}` 的含义是：
  - 如果 `$1` 存在（即至少有一个参数），就展开为 `"$@"`；
  - 如果 `$1` 不存在（即没有参数），就展开为空（不传任何参数）。
- 这样可以**避免在无参数时 `$@` 被错误展开为空字符串或导致语法问题**。
- 在现代 shell（如 bash、dash、zsh）中，直接用 `"$@"` 通常是安全的，但为了最大兼容性，很多脚本仍保留 `${1+"$@"}` 这种写法。

通常，编写**包装器**时，我们会尽可能使用**最具可移植性的语法**。如果只是将输入传递给其他程序，通常不需要编写复杂的、特定于 shell 或平台的代码。实际上，上面的代码很可能可以用**符号链接代替**。

一个更实际的包装脚本可能如下所示：



```bash
#!/bin/sh
CDR_SECURITY=8:dvd,clone,....
#export 环境变量传递给子进程
export CDR_SECURITY
exec cdrecord-prodvd ${1+"$@"}
```



该包装器设置一个**环境变量**`CDR_SECURITY`，然后使用与包装器脚本接收到的相同的参数和输入**调用另一个程序**。

使用 `#!/bin/sh` shebang 是因为我们不需要任何 Bourne shell 默认功能之外的东西。我们坚持使用最具可移植性的语法，因此这个包装器可以在我们可能遇到的任何 Unix 系统上运行。

所以， `export` 单独一行， *位于它所导出的变量被赋值之后* 。

`exec` 会使**我们封装的工具与我们自身的进程 ID (PID) 相同**。这一点很重要，因为如果进程由某个程序[管理 ](https://mywiki.wooledge.org/ProcessManagement)，而该程序需要与其保持父子关系以便发送信号，或者仅仅是为了记录进程的 PID。

此外，无需在内存中保留 shell 实例； `exec` 可以**节省一次进程 fork，因此效率很高**。

之所以使用 `${1+"$@"}` 而不是 `"$@"` ，是因为某些**旧版本的 Bourne shell 存在一个 bug**：当参数列表为空时， `"$@"` 会展开成一个长度为 0 的**字符串**（即 `''` ），而不是一个空的**参数列表**。

> **“长度为空的字符串”（empty string）** 与 **“空的参数列表”（no arguments）** 在行为上有本质区别。
>
> | 类型                                 | 含义说明                                                     | 示例                     |
> | ------------------------------------ | ------------------------------------------------------------ | ------------------------ |
> | **空的参数列表**（no arguments）     | 调用命令时 **根本没有提供任何参数**，`$# = 0`                | `mycmd`                  |
> | **长度为空的字符串**（empty string） | 调用命令时 **提供了一个参数，但其值是空字符串**，`$# = 1`，`$1 = ""` | `mycmd ""` 或 `mycmd ''` |
>
> 对于示例脚本`demo.sh`
>
> ```bash
> #!/bin/bash
> # demo.sh
> echo "参数个数: $#"
> echo "所有参数: [$@]"
> for i in "$@"; do
>     echo "参数: [$i],长度:[${#i}]"
> done
> ```
>
> 
>
> ```bash
> 
> # cxxu @ CxxuDesk in ~/sh [11:23:25] 
> $ bash ./demo.sh a1 b2 3 ""
> 参数个数: 4
> 所有参数: [a1 b2 3 ]
> 参数: [a1],长度:[2]
> 参数: [b2],长度:[2]
> 参数: [3],长度:[1]
> 参数: [],长度:[0]
> 
> # cxxu @ CxxuDesk in ~/sh [11:23:33] 
> $ bash ./demo.sh ""        
> 参数个数: 1
> 所有参数: []
> 参数: [],长度:[0]
> 
> # cxxu @ CxxuDesk in ~/sh [11:23:56] 
> $ bash ./demo.sh           
> 参数个数: 0
> 所有参数: []
> ```
>
> 



 `${1+...}` 语法通过**首先检查参数列表是否*为*空**来规避这个问题。如果为空，则使用 `"$@"` 将其传递；**否则，不传递任何内容**。你会经常看到这种结构。（更多高级参数展开示例，请参阅 [Bash FAQ #73](https://mywiki.wooledge.org/BashFAQ/073) 。）

对比两种写法：

不安全写法（在某些老 shell 中）：

```bash
exec /tool "$@"
```

- 在**某些老 Bourne shell** 中：当 `$# = 0` 时，`"$@"` 可能被错误地展开为一个**空字符串**(而不是空)，导致 `/tool ""` ❌

✅ 安全写法：

```bash
exec /tool "${1+"$@"}"
```

- 如果 `$1` 未设置（即没有参数），整个表达式展开为空 → `/tool`（无参数）
- 如果有参数（哪怕 `$1` 是空字符串），就展开为 `"$@"` → 正确传递所有参数（包括空字符串）

> 所以 `${1+"$@"}` 精确保留了“无参数”和“有参数（含空字符串）”的语义。

请注意， `"${1+"$@"}"` 、 `"$1"` 、 `"${a[0]}"` 等等，**即使未设置双引号，在双引号内也会展开成至少一个单词**。这就是为什么 `${1+"$@"}` 周围的双引号被*省略的*原因。

---

### 基于daemontools的包装脚本示例

另一种更复杂的包装脚本例子是 [daemontools](http://cr.yp.to/daemontools.html) *运行脚本* 。由 daemontools 管理的服务依赖于一个程序（通常由系统管理员用 Bourne shell 编写）来**设置环境**并**执行被管理的进程**。

> `daemontools` 是由著名程序员 **Daniel J. Bernstein（djb）** 开发的一套 Unix/Linux **服务监督与管理系统**，其核心设计哲学是：**简单、可靠、可组合、永不失败**。它不依赖传统的 init 脚本或 systemd，而是通过“监督进程（supervisor）”来确保服务持续运行。
>
> - 每个服务由一个**常驻的监督进程（`supervise`）** 管理。
> - 服务本身是一个普通程序（不需要自己 fork 后台、写 pid 文件）。
> - 监督进程负责：
>   - 启动服务
>   - 捕获退出状态
>   - 崩溃后自动重启（可配置重启策略）
>   - 提供状态查询、日志收集、信号控制等

以下是一个（略微简化的）示例：

```bash
#!/bin/sh
exec /usr/local/bin/softlimit -m 3000000 \
    /usr/local/bin/tcpserver -v -x /etc/tcp.smtp.cdb -u 10092 -g 10098 0 smtp \
    /usr/local/bin/rblsmtpd -r zen.spamhaus.org \
    /var/qmail/bin/qmail-smtpd 2>&1
```



这个例子很有意思，因为它实际上是一个类似洋葱的层级结构。（ [DJB](http://cr.yp.to/djb.html) 的所有软件都是这样设计的。）我们的运行脚本是一个 **Bourne shell**(sh) 脚本，它执行名为 `softlimit` 的程序。

> 这段命令是一个典型的 **qmail** 邮件服务器启动脚本中的一行，主要用于启动 SMTP 服务并增加安全限制。它像串糖葫芦一样，把几个不同的程序按顺序嵌套在一起工作。
>
> 我们可以把这一长串命令拆解为四个核心部分：
>
> 1. 资源限制 (`softlimit`)
>
> ```bash
> softlimit -m 3000000
> ```
>
> - **作用**：给后续运行的程序设置“内存天花板”。
> - **含义**：`-m 3000000` 表示限制该进程及其子进程最多只能使用约 **3MB** 的内存。这是为了防止由于恶意攻击或程序 Bug 导致内存耗尽，保障系统稳定。
>
> 2. 网络监听 (`tcpserver`)
>
> ```bash
> tcpserver -v -x /etc/tcp.smtp.cdb -u 10092 -g 10098 0 smtp
> ```
>
> - **作用**：守在大门口（25端口）监听进来的连接。
> - **参数解释**：
>   - `-v`: 显示详细日志（Verbose）。
>   - `-x ...cdb`: 引用一个规则库（黑白名单），决定哪些 IP 可以连接，哪些需要拒绝。
>   - `-u 10092 -g 10098`: 以特定的用户 ID 和组 ID 运行，提高安全性。
>   - `0 smtp`: 在本地所有网卡的 `smtp` 端口（通常是 25 端口）监听。
>
> 3. 反垃圾邮件过滤 (`rblsmtpd`)
>
> ```
> rblsmtpd -r zen.spamhaus.org
> ```
>
> - **作用**：在邮件进门前，先看对方是不是“黑名单”上的惯犯。
> - **原理**：它会拿着对方的 IP 去 **Spamhaus**（一个著名的实时黑名单数据库）查询。如果对方被标记为发垃圾邮件的源，这个程序直接就把它拒之门外，不会浪费后面邮件服务器的资源。
>
> 4. 邮件接收核心 (`qmail-smtpd`)
>
> ```
> /var/qmail/bin/qmail-smtpd
> ```
>
> - **作用**：真正的邮件接收程序。
> - **逻辑**：只有通过了前面**内存检查、IP 规则检查和黑名单检查的连接**，最后才会交给它来处理真正的邮件接收和存储。
>
> ------
>
> 总结：处理流程
>
> 1. **限制内存** (softlimit) $\rightarrow$
> 2. **监听端口并检查本地白名单** (tcpserver) $\rightarrow$
> 3. **在线核实是否为垃圾邮件 IP** (rblsmtpd) $\rightarrow$
> 4. **接收邮件内容** (qmail-smtpd)

`softlimit` 的作用很简单，就是设置进程资源限制（参见 GNU/Linux 上的 `setrlimit(2)` ）。

> bash中我们可以使用 shell 的 `ulimit` 或 `limit` 命令来完成同样的操作，但请记住，我们使用的是 Bourne shell(sh而非bash)，它*没有这些命令* ！
>
> 因此，DJB 编写了 `softlimit` 作为包装程序（用 C 语言编写），它设置限制，然后执行链中的下一个进程。
>
> （如果我们用 bash 而不是 Bourne shell 编写运行脚本，那么调用 `ulimit` 将是一种**高效且理想的选择**。）
>
> `exec softlimit` 命令末尾的 `2>&1` 将**标准错误和标准输出绑定在一起**，因为另一个进程（未显示）正在记录所有这些内容。

`tcpserver`:链中的下一个进程是 DJB 的 [ucspi-tcp](http://cr.yp.to/ucspi-tcp.html) 套件中的 `tcpserver` 。它继承了链中前面元素已设置的限制。

> 然后，它读取 `/etc/tcp.smtp.cdb` 文件，并开始监听网络接口 `0` （所有接口）的 `smtp` 端口。当接收到连接时，它会派生并执行 `rblsmtpd` 程序，UID 为 10092，GID 为 10098。（它还会设置几个不同的环境变量，但这超出了本页的讨论范围。）

`rblsmtpd` 程序检查其环境变量（继承自进程链的前面部分），并根据这些变量决定是否对连接的源 IP 地址进行 DNS 查询，或者跳过这些查询。

> 如果执行查询并发现“垃圾邮件发送者”的结果，则会写入错误信息，并且 `rblsmtpd` 程序退出。否则， `rblsmtpd` 程序将执行链中的下一个进程 `exec` 。

最后，如果一切顺利， `qmail-smtpd` 实际上会收到发件人的电子邮件，并将其放入处理队列中。

**良好做法：
脚本中不要使用全大写变量名，除非是环境变量。为了避免出错，请使用小写或大小写混合的变量名。**

- **常见问题解答中：
  [我正在尝试编写一个脚本来更改目录（或设置变量），但是脚本执行完毕后，我又回到了起点（或者我的变量没有被设置）！](https://mywiki.wooledge.org/BashFAQ/060)**



## 3. 文件描述符和标准输入输出



*文件描述符* （简称 FD）是程序**引用文件或其他类似文件资源（例如管道、设备、套接字或终端）的方式**。

FD 类似于指向数据源或数据写入位置的**指针**。当程序读取或写入某个 FD 时，数据实际上是从该 FD 所指向的**资源**读取或写入的。

默认情况下，每个**新进程启动时**都会打开**三个文件描述符**：

- *标准输入* （ `stdin` ）：文件描述符 0
- *标准输出* （ `stdout` ）：文件描述符 1
- *标准误差* （ `stderr` ）：文件描述符 2

在交互式 shell 或终端运行的脚本中:

- *标准输入 (Standard Input)* 用于接收 bash **从键盘输入的字符**。
-  *标准输出 (Standard Output)* 用于发送程序的**大部分常规信息**，以便用户查看； 
- *标准错误 (Standard Error* ) 用于发送**程序的错误信息**。

> 图形用户界面 (GUI) 应用程序也有这些文件描述符 (FD)，但它们通常无法直接使用。
>
> 通常情况下，它们的所有用户交互都通过 GUI 完成，这使得 [BASH](https://mywiki.wooledge.org/BASH) 很难控制它们。

因此，我们将只使用简单的终端应用程序进行说明。

对于这些应用程序，我们可以轻松地**通过标准输入向其输入数据**，并通过**标准输出和标准错误读取数据**。

### 案例

让我们把这些定义更具体地说明一下。下面演示一下标准输入和标准输出是如何工作的：

`read` 是一个命令bash内置的命令，它从 `stdin` 读取信息并将其存储在一个变量中。使用`-p`选项打印提示输入的语句,并指定一个名字(变量名),所读取的内容会保存到该变量中.



```bash
$ read -p "What is your name? " name; 
echo "Good day, $name.  Would you like some tea?"
# 运行示例:
What is your name? lhunath
Good day, lhunath.  Would you like some tea?
```



我们指定 `name` 为保存输入的变量。 `read` 从 `stdin` 读取一行信息后，它会停止工作，并让 `echo` 显示一条消息。 

`echo` 将其输出发送给 `stdout` 。 `stdin` 和 `stdout` 连接到您的终端。当程序从终端读取数据时，它会接收来自您键盘的按键；当程序向终端写入数据时，字符会显示在您的显示器上。

因此，您可以输入您的名字，然后在显示器上看到一条友好的消息，例如邀请您喝杯茶。

那么 `stderr` 是什么呢？我们来演示一下：



```bash
$ rm secrets
rm: cannot remove `secrets': No such file or directory
```



除非当前目录下存在名为 `secrets` 的文件，否则 `rm` 命令将会失败，并显示一条错误信息解释出错原因。按照惯例，这类错误信息会显示在 `stderr` 中。

那么 `stderr` 是什么呢？我们来演示一下：



```
$ rm secrets
rm: cannot remove `secrets': No such file or directory
```



除非当前目录下存在名为 `secrets` 的文件，否则 `rm` 命令将会失败，并显示一条错误信息解释出错原因。按照惯例，这类错误信息会显示在 `stderr` 中。

`stderr` 也像 `stdout` **一样连接到终端的输出设备**。因此，错误信息会像 `stdout` 上的信息一样显示在您的显示器上。但是， `stdout` 和 `stderr` 之间的区别使得将**错误信息与应用程序的正常信息分开变得容易**。

例如，脚本可能希望将 `stderr` 上的信息**记录到特定位置以便长期保存**。有些人还喜欢使用包装器将 `stderr` 上的所有输出都**设置为红色，以便更清楚地查看错误信息**。（这种方法的效果可能不如预期，但有些人觉得它足以满足某些任务的需求。）

在 shell 脚本中，文件描述符 (FD) 总是**通过编号来引用**。

下一节我们将介绍一些**使用编号来操作文件描述符**的方法。

- **手册中：[ read命令](http://www.gnu.org/software/bash/manual/bashref.html#index-read-142)**

**良好做法：
记住，创建脚本时，应该将自定义错误消息发送到 `stderr` 描述符。这是一种约定俗成的做法，应用程序遵循此约定会非常方便。因此，你也应该这样做！**

**很快就会学习重定向，但让我先快速演示一下它是如何实现的：**

```bash
 echo "Uh oh.  Something went really bad.." >&2
```

- *文件描述符* ：**指向进程打开的文件之一的数字索引**。

### 基本描述符

每个命令至少有三个基本描述符：FD 0 为 `stdin` ，FD 1 为 `stdout` ，FD 2 为 `stderr` 。

## 4. 重定向



BASH 中**最基本**的输入/输出操作形式是***重定向*** 。 *重定向*用于**更改程序文件描述符 (FD) 的数据源或目标**。这样，您可以将输出发送到**文件**而不是终端，或者让应用程序**从文件中读取数据而不是从键盘读取**。

重定向由 BASH（或任何其他 shell）执行，在 shell 运行要应用重定向的命令*之前*执行。

- **手册中：[ 重定向](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Redirections)**

***重定向*** ：将文件描述符 (FD) 的输入**从不同的位置读取，或输出发送到不同的位置**。

重定向有几种类型:

### 4.1 文件重定向



*文件重定向*是指将**单个文件描述符** (FD) 指向**另一个文件**。我们先来看**输出重定向**：

#### 输出重定向

```bash
$ echo "It was a dark and stormy night.  Too dark to write." > story
$ cat story
It was a dark and stormy night.  Too dark to write.
```



`>` 运算符表示*输出重定向* 。此重定向仅应用于一个命令（在本例中为 `echo` 命令）。

它告诉 BASH，当 BASH 运行该命令时， `stdout` 应该指向一个文件，而不是它之前指向的任何位置。

因此， `echo` 命令不会将其输出发送到终端；相反， `> story` 重定向**会更改 `stdout` 文件描述符的目标** ，使其指向名为 `story` 的文件。

请注意，**此重定向发生在 `echo` 命令执行之前**。

默认情况下，Bash 不会先检查文件 `story` 是否存在；它只是打开该文件，如果已存在同名文件，则其原有内容将被丢失。

如果该文件不存在，则会创建一个空文件，以便文件描述符可以指向它。此行为可以通过 *Shell 选项*进行切换（详见后文）。

需要注意的是，此重定向仅对应用此重定向的**单个** `echo` 命令有效。之后执行的其他命令将继续将其输出发送到脚本的 `stdout` 位置。

然后我们使用应用程序 `cat` 来打印该文件的内容。 `cat` 是一个应用程序，它会读取你作为参数传递给它的所有文件的内容。然后，它将每个文件的内容依次写入 `stdout` 。本质上，它会将你作为参数传递给它的所有文件的内容**连接**起来。

> **警告：** 读取文件内容可以使用 `cat` 。 但是这是没有必要的！
>
> `cat`主要适用于将**多个文件连接在一起**，或者作为 shell 提示符下**快速查看文件内容的工具**。
>
> 管道符和重定向
>
> - 你**不**应该使用 `cat` 将**文件**通过**管道**传递给脚本中的命令。你应该使用**重定向**。请记住这个警告。
> - 无谓地使用 `cat` 会**导致创建额外的进程**，而且使用**管道代替重定向会使应用程序无法在输入文件内部来回跳转**。

当我们使用 `cat` 而不传递任何参数时，它显然不知道要读取哪些文件。

在这种情况下， `cat` 将直接从 `stdin` 读取数据，而不是从文件中读取（就像 `read` 一样）。由于 `stdin` 通常**不是一个常规文件**，因此不带任何参数启动 `cat` 似乎不会执行任何操作：



```bash
$ cat
```



它甚至都没给你返回 shell 提示符！这是怎么回事？

 `cat` 仍然在从 `stdin` （也就是你的终端）读取数据。你现在在键盘上输入的任何内容，都会在你按下*回车*键后立即发送到 `cat` 。

你输入的每一行， `cat` 都会像往常一样：在 `stdout` 上**显示它读取的内容**，就像之前在 `stdout` 上显示我们的故事一样。



```bash
 $ cat
test?
test?
```



为什么现在出现了两次 `test?` ？首先，终端实际上比看起来要复杂得多；它们有不同的操作模式。

我们在这个例子中使用的是***规范模式*** ，在这种模式下，终端会在你**输入时显示每个字符**，并允许你对输入的内容进行极其简单的(有限的)编辑（例如使用退格键);输入的一般字符不会将内容发送到应用程序,它们仅仅暂存在标准输入中.而输入回车键就不一样了.

**你输入的内容实际上只有在你按下回车键后才会发送到应用程序**。

当你输入 `test?` 时，终端会在屏幕上回显它。(这是第一个`test?`显式的原因,如果你从键盘逐个收入字符,则它不是一下子显示,而是跟随输入逐个字符显示,除非利用复制粘贴一下子输入)

按下回车键后，整行内容就会被读取终端的应用程序 ( `cat` ) 读取。 `cat` 从 `stdin` 读取该行内容，然后将其显示在 `stdout` 上，也就是你的终端(就像cat查看文件将文件内容输出到stdout上一样)；因此，出现了第二行： `test?` 。

你可以按 *Ctrl+D* 向终端发送***文件结束***符。这会让 `cat` 认为 `stdin` 已经关闭，停止读取并终止。

BASH 会检测到 `cat` 已终止，并将你返回到提示符。

#### 输入重定向

现在让我们使用***输入重定向***将文件附加到 `stdin` ，这样 `stdin` 就不再从键盘读取内容，而是从文件中读取内容：



```bash
$ cat < story
The story of William Tell.

It was a cold december night.  Too cold to write.
```



其结果与之前的 `cat story` 完全相同；只是这次`cat < story`的**工作方式略有不同**。

在第一个例子中， `cat` 打开了一个指向文件 `story` 的文件描述符 (FD)，并通过该 FD 读取其内容。

在第二个例子(回显`test?`中)， `cat` 直接从 `stdin` 读取数据，就像之前从键盘读取数据一样。

然而，这次 `< story` 操作**修改了** `cat` 的 `stdin` ，使其数据源从键盘变为文件 `story` 。

重定向运算符前面可以加一个数字。该数字表示要更改的函数描述符 (FD)。

让我们用一些例子来总结一下：

- **`command > file`** ：将命令 `stdout` 发送给 `file` 。
- **`command 1> file`** ：将命令的 `stdout` 发送给 `file` 。由于 `stdout` 是**文件描述符 1**，因此我们将该数字放在重定向运算符前面。这与前面的示例相同，因为文件描述符 1 是 **> 运算符的默认值**。
- **`command < file`** ：当 `command` 从 `stdin` 读取时，使用 `file` 的内容。
- **`command 0< file`** ：当 `command` 从 `stdin` 读取时，使用 `file` 的内容，与前面的示例完全相同，因为 FD 0 ( `stdin` ) 是 **<** 运算符的默认值。

`stderr` 文件描述符的编号是 2。那么，我们来尝试向文件发送 `stderr` ：



```bash
for homedir in /home/*
do rm "$homedir/secret"
done 2> errors
```



在这个例子中，我们遍历 `/home` 中的每个目录（或文件）。然后，我们尝试删除每个目录中的文件 `secret` 。

某些 `homedir` 可能不包含密钥，或者我们可能没有删除权限。因此， `rm` 操作将失败，并在 `stderr` 上发送错误消息。

您可能已经注意到，我们的**重定向操作符不在 `rm` 上，而是在 `done` 上**。

这是为什么呢？这样做是为了**确保重定向能够应用于整个循环中所有输出到 `stderr` 的操作**。

具体来说，BASH 会在**循环开始前打开名为 `errors` 的文件**，并将 `stderr` 指向它，**然后在循环结束时关闭该文件**。循环内运行的任何命令（例如 `rm` ） 都会继承 **BASH 打开的文件描述符**。

让我们看看循环的结果是什么：



```bash
$ cat errors
rm: cannot remove `/home/axxo/secret': No such file or directory
rm: cannot remove `/home/lhunath/secret': No such file or directory
```



我们的错误日志文件中有两条错误信息。有两个人的家目录中没有 `secret` 文件。

#### 非覆盖重定向选项

说明的不是 `echo` 有问题，而是 **当前 Bash 会话启用了“禁止覆盖重定向”机制**。

核心原因是：
 **开启了 `noclobber` 选项（no clobbering）**。



#### 屏蔽文件描述符和比特桶(`/dev/null`)

如果你正在编写脚本，**并且预料到某个命令偶尔可能会失败，但又不希望脚本用户受到该命令可能产生的错误信息的干扰，你可以屏蔽文件描述符 (FD)**。屏蔽 FD 的操作与普通的*文件重定向*一样简单。我们只需将**该 FD 的所有输出都发送到系统的黑洞(`/dev/null`)即可**：



```bash
$ for homedir in /home/*
> do rm "$homedir/secret"
> done 2> /dev/null
```



无论你向文件 `/dev/null` 写入什么或从中读取什么，它**始终**为空。

因此，当我们向其中写入错误消息时，它们**会直接消失**。文件 `/dev/null` 也始终保持为空。这是因为它**不是一个普通的文件，而是一个*虚拟*设备**。有些人称 `/dev/null` 为 *“**比特桶**”* 。

#### 追加重定向

关于*文件重定向，* 还有最后一点需要了解。有趣的是，你可以像这样**创建错误日志文件来保存错误信息**；但正如我之前提到的，Bash **在重定向到某个文件时会销毁该文件的现有内容**。因此，每次我们运行循环删除敏感文件时，日志文件都会被清空，然后我们才能再次填充新的错误信息。

如果我们想要保留循环生成的任何错误信息记录呢？如果我们不想每次启动循环时文件都被清空呢？解决方法是使用2个连续的重定向运算符。即, `>` 变为 `>>` 。 `>>` 不会清空文件；它只会将新数据追加到文件末尾！

当然,对于标准错误也可以追加重定向(`2>`变为`2>>`)

```bash
$ for homedir in /home/*
> do rm "$homedir/secret"
> done 2>> errors
```

顺便一提，**重定向运算符和文件名之间的空格是可选的**。有些人写成 `> file` ，有些人写成 `>file` 。两种写法都正确。



#### 小结

当应用程序需要文件数据且其设计目的是从 `stdin` 读取数据时，使用重定向是一个好主意。

网上有很多糟糕的例子，教你把 `cat` 的输出通过管道（稍后会讲到）传递给其他进程；但这绝对是一个非常糟糕的做法。
在设计一个**可以从各种不同来源获取数据的应用程序时**，通常最好的做法是**让应用程序直接从 `stdin` 读取数据**；这样，用户就可以使用**重定向来提供任何用户想要的数据**。以**通用方式读取标准输入**的应用程序称为\*过滤器\* (filter)。

### 4.2 文件描述符操作

**文件描述符 (FD) 的源和目标可以更改，使其指向文件或从文件指向文件。**

**也可以将一个文件描述符复制到另一个文件描述符**。

让我们准备一个简单的测试环境：

```bash
echo "I am a proud sentence." > file
```

我们创建了一个名为 `file` 的文件，并在其中写入了一句自豪的句子。然后我们将使用`grep`命令使用此`file`文件.

#### grep命令

grep命令简介(详情另见它文),这是一个在文件中搜索指定匹配模式的工具.

```bash
$ grep --help
Usage: grep [OPTION]... PATTERNS [FILE]...
Search for PATTERNS in each FILE.
Example: grep -i 'hello world' menu.h main.c
PATTERNS can contain multiple patterns separated by newlines.
```

`grep`命令基本上以***搜索模式***作为第一个参数，并可能以**文件名作为额外的参数**。与 `cat` 类似，如果您没有指定任何文件， `grep` 也会使用 `stdin` 。

>  `grep` 会读取文件（如果没有提供文件，则使用 `stdin` ），并搜索您提供的*搜索模式* 。
>
> 大多数版本的 `grep` 甚至支持 `-r` 开关，该开关允许它将目录以及文件作为额外的参数，然后在您提供的目录中搜索所有文件和目录。

以下是 `grep` 的工作示例：

```bash
$ ls house/
drawer  closet  dustbin  sofa
$ grep -r socks house/
house/sofa:socks
```

在这个简单的例子中，我们有一个名为 `house` 的目录，里面存放着几件家具的文件。

> 这里的`PATTERN`就是`socks`,命令`grep -r socks house/`表示递归查找目录`house/`(及其子目录)中所有文件中可能存在的`socks`字符串.

如果我们想在每个文件中查找 `socks` ，就需要发送 `grep` 去搜索目录 `house/` 。 `grep` 会搜索目录 `house/` 中的所有内容，打开每个文件并查看其内容。

在我们的例子中， `grep` 在文件 `house/sofa` 中找到了 `socks` ；

想要一个更实际的例子？

```bash
$ grep "$HOSTNAME" /etc/*
/etc/hosts:127.0.0.1       localhost Lyndir
```



这里我们指示 `grep` 在 `/etc/*` 展开成的任何文件中搜索 `$HOSTNAME` 展开成的任何内容。它在文件 `/etc/hosts` 中找到了我的主机名 `Lyndir` ，并显示了该文件中包含*搜索模式的*行。

好了，既然你已经理解了 `grep` ，我们继续进行*文件描述符操作* 。还记得我们创建了一个名为 `file` 的文件，并在其中写入了一条 proud 语句吗？现在，让我们使用 `grep` 来查找这条 proud 语句所在的位置：



```bash
$ grep proud *
file:I am a proud sentence.
```



很好！ `grep` 在 `file` 中找到了我们的句子。它将运算结果写入 `stdout` ，并在终端上显示出来。

现在让我们看看是否也能让 `grep` 发送错误信息：



```bash
$ grep proud file 'not a file'
file:I am a proud sentence.
grep: not a file: No such file or directory
```



这次，我们指示 `grep` 在文件 ' `file` ' 和 ' `not a file` ' 中搜索字符串 `proud` 。

文件 `file` 存在，并且该字符串就在其中，因此 `grep` 顺利地将结果写入 `stdout` 。

它继续扫描下一个文件 ' `not a file` '。 `grep` 无法打开此文件读取其内容，因为它不存在。因此， `grep` 向仍然连接到我们终端的 `stderr` 发出错误消息。

那么，如何才能**完全屏蔽这条 `grep` 语句**呢？我们希望将终端上显示的所有输出都发送到一个文件中；我们称之为 `proud.log` ：

下面的写法有点瑕疵,不是很对.

```bash
# Not quite right....
$ grep proud file 'not a file' > proud.log 2> proud.log
```

这样看起来对吗？我们首先使用 `>` 将 `stdout` 发送给 `proud.log` ，然后使用 `2>` 将 `stderr` 发送给 `proud.log` 。差不多，但还不完全对。

如果您运行此命令（至少在某些计算机上是这样），然后查看 `proud.log` ，您会发现其中**只有错误消息，而不是 `stdout` 的输出**。我们在这里创建了一个非常糟糕的情况。我们创建了两个文件描述符 (FD)，它们都指向同一个文件，彼此独立。这会导致不确定的结果。根据操作系统处理文件描述符的方式，通过一个文件描述符写入的信息可能会覆盖通过另一个文件描述符写入的信息。



```bash
$ echo "I am a very proud sentence with a lot of words in it, all for you." > file2
$ grep proud file2 'not a file' > proud.log 2> proud.log
$ cat proud.log
grep: not a file: No such file or directory
of words in it, all for you.
```



这里发生了什么？ `grep` 首先打开了 `file2` ，找到了我们指定要查找的内容，然后将我们引以为豪的句子写入了 `stdout` （文件描述符 1）。文件描述符 1 指向 `proud.log` ，因此信息被写入了该文件。然而，我们还有另一个文件描述符（文件描述符 2）指向同一个文件，并且具体来说，指向了该文件的*开头* 。当 `grep` 尝试打开 `not a file` 读取内容时，却失败了。然后，它将一条错误消息写入了 `stderr` （文件描述符 2），而 `stderr` 指向的是 `proud.log` 的开头。结果，第二次写入操作覆盖了第一次写入操作的信息！

我们需要防止两个独立的文件描述符（FD）访问同一个目标或源。我们可以通过*复制*文件描述符来实现这一点：



```bash
$ grep proud file 'not a file' > proud.log 2>&1
```



为了理解这些，你需要记住：始终从左到右读取文件重定向。这是 Bash 处理它们的顺序。首先， `stdout` 被修改，使其指向我们的 `proud.log` 。然后，我们使用 `>&` 语法复制文件描述符 1，并将副本放入文件描述符 2。

重复的文件描述符（FD）与两个指向同一位置的独立文件描述符的工作方式不同。通过其中任何一个文件描述符进行的写入操作完全相同。不会出现一个文件描述符指向文件开头而另一个已经移动到文件末尾的情况。

注意不要把顺序搞混：



```bash
$ grep proud file 'not a file' 2>&1 > proud.log
```



这将复制指向终端的 `stdout` ，并将副本放入 `stderr` ，然后将 `stdout` 重定向到 `proud.log` 。结果， `stdout` 的消息将被记录，但错误消息仍会发送到终端。 *糟糕。*

**笔记：
为了方便起见，Bash 还提供了另一种重定向方式。 `&>` 重定向运算符实际上只是我们这里所做操作的简化版本；它将 `stdout` 和 `stderr` 都重定向到一个文件：**



```bash
$ grep proud file 'not a file' &> proud.log
```



这与 `> proud.log 2>&1` 相同，但无法移植到 [BourneShell](https://mywiki.wooledge.org/BourneShell) 。虽然不推荐这样做，但如果你在别人的脚本中看到它，应该能够识别出来。

***TODO：移动 FD 和打开 FD RW。***



------



- **常见问题解答：
  [如何一次性重定向多个命令的输出？](https://mywiki.wooledge.org/BashFAQ/014)**
- **[如何将“time”的输出重定向到变量或文件？](https://mywiki.wooledge.org/BashFAQ/032)**
- **[如何使用对话框获取用户输入？](https://mywiki.wooledge.org/BashFAQ/040)**
- **[如何将标准错误输出重定向到管道？](https://mywiki.wooledge.org/BashFAQ/047)**
- **[请详细解释一下 2>&1——2>&1 >foo 和 >foo 2>&1 有什么区别，什么时候该用哪个？](https://mywiki.wooledge.org/BashFAQ/055)**



------





### 4.3. Heredoc 和 Herestrings



有时候把数据存储在文件中是多余的。我们可能只需要一点点数据——刚好够放在脚本里。或者我们可能想把变量的内容重定向到命令中，而不需要先把它写入文件。



```bash
$ grep proud <<END
> I am a proud sentence.
> END
I am a proud sentence.
```



这是一个 *Heredoc* （或 *Here 文档* ）。如果您想在脚本中嵌入多行数据的小块， *Heredoc* 非常有用。（嵌入较大的数据块是一种不好的做法。您应该将逻辑（代码）和输入（数据）分开，最好放在不同的文件中，除非数据集很小。）

在 *Heredoc* 中，我们选择一个词作为哨兵词。它可以是任何词；在本例中我们使用了 `END` 。选择一个不会出现在数据集中的词。从哨兵词*第*一次出现到*第二*次出现的所有行都将成为命令的 `stdin` 。哨兵词的第二次出现必须单独成行。

*Heredocs* 提供了几种不同的选项。通常情况下，您无法缩进它们——脚本中用于缩进的任何空格都会出现在 `stdin` 中。终止符（在本例中为 `END` ）必须位于行首。



```bash
echo "Let's test abc:"
if [[ abc = a* ]]; then
    cat <<END
        abc seems to start with an a!
END
fi
```



结果将：



```bash
Let's test abc:
        abc seems to start with an a!
```



你可以暂时移除 *Heredoc* 文档行的缩进来避免这个问题。但是，这样做会破坏你美观且一致的缩进。还有另一种方法。如果你使用 `<<-END` 而不是 `<<END` 作为 *Heredoc* 操作符，Bash 会在将 *Heredoc* 内容发送给命令之前，移除每行开头的 `tab` 字符。这样，你仍然可以使用制表符（但不能使用空格）来缩进 *Heredoc* 内容，使其与其余代码保持一致。这些制表符不会被发送给接收 *Heredoc* 的命令。你也可以使用制表符来缩进你的哨兵字符串。

默认情况下，Bash 会对 *Heredoc* 的内容进行替换。但是，如果您将用于分隔 *Heredoc* 的单词用引号括起来，Bash 将不会对其内容进行任何替换。请尝试使用和不使用引号字符来查看以下示例，以了解区别：

```bash
$ cat <<'XYZ'
> My home directory is $HOME
> XYZ
My home directory is $HOME
```



*Heredocs* 最常见的用途是向用户输出文档：

```bash
usage() {
    cat <<EOF
usage: foobar [-x] [-v] [-z] [file ...]
A short explanation of the operation goes here.
It might be a few lines long, but shouldn't be excessive.
EOF
}
```



现在让我们来看看非常相似但更简洁的 *Herestring* ：



```bash
$ grep proud <<<"I am a proud sentence"
I am a proud sentence.
```



这次， `stdin` 直接从 `<<<` 运算符后面的字符串读取信息。这对于将变量中的数据发送到进程非常方便：



```bash
$ grep proud <<<"$USER sits proudly on his throne in $HOSTNAME."
lhunath sits proudly on his throne in Lyndir.
```



*Herestring* 比笨重的 *Heredoc* 更短、更不碍事，总体来说也更方便。但是，它们无法移植到 Bourne 船体上。

稍后，您将学习管道以及如何使用管道将一个命令的输出发送到另一个命令的 `stdin` 中。许多人使用管道将变量的输出作为 `stdin` 发送到命令中。但是，对于此目的，应该优先使用 *Herestring* 。它们不会创建子 shell，并且对 shell 和 shell 脚本的风格都更轻量级：



```bash
$ echo 'Wrap this silly sentence.' | fmt -t -w 20
Wrap this silly
   sentence.
$ fmt -t -w 20 <<< 'Wrap this silly sentence.'
Wrap this silly
   sentence.
```



从技术上讲， *Heredoc* 和 *Herestring* 本身也和其他重定向一样。因此，同一行可以出现多个重定向，所有重定向都按通常的顺序执行。

```bash
$ cat <<EOF > file
> My home dir is $HOME
> EOF
$ cat file
My home dir is /home/greg
```





------



- **良好做法：
  过长的 heredoc 通常不是个好主意，因为脚本应该包含逻辑，而不是数据。如果脚本需要用到大型文档，应该将其放在单独的文件中，并与脚本一起发送。不过，herestring 经常派上用场，尤其是在向 `grep` 或 `sed` 之类的过滤器发送变量内容（而不是文件）时。**



------





## 5. 管道



既然您可以轻松地操作*文件描述符* ，将特定类型的输出定向到特定文件，那么是时候学习一些通过 I/O 重定向实现的更巧妙的技巧了。

你可以使用*文件重定向*将输出写入文件或从文件中读取输入。但如果你想将一个应用程序的输出直接连接到另一个应用程序的输入呢？这样，你就可以构建一个链式结构来处理输出。如果你已经了解 `FIFO` ，你可以使用类似这样的方法来实现：



```bash
$ ls
$ mkfifo myfifo; ls
myfifo
$ grep bea myfifo &
[1] 32635
$ echo "rat
> cow
> deer
> bear
> snake" > myfifo
bear
```



我们使用 `mkfifo` 命令在当前目录下创建一个名为“ `myfifo` ”的新文件。但这并非普通文件，而是一个 `FIFO` 文件（ *先进先出* ）。 `FIFO` 文件是特殊的文件，它以 `First In, First Out` 的方式提供数据。当你从 `FIFO` 文件读取数据时，只有当另一个进程写入它时，你才能接收到数据。因此， `FIFO` 文件实际上永远不会包含任何数据。只要没有进程写入它，对 `FIFO` 文件的任何读取操作都会**阻塞** ，因为它需要等待数据可用。对 `FIFO` 文件进行写入操作也是如此——它们会阻塞，直到另一个进程从 `FIFO` 文件读取数据。

在我们的示例中， `grep` 从 `FIFO` （即 `myfifo` ）读取数据。 `grep` 等待 `FIFO` 上的数据可用。这就是为什么我们在 grep 命令后附加 `&` 运算符，使其在后台运行。这样，我们可以在 `grep` 运行并等待数据时继续输入和执行命令。我们的 `echo` 语句将数据传递给 `FIFO` 。一旦数据可用，正在运行的 `grep` 命令就会读取并处理它。结果显示出来。我们已成功将数据从 `echo` 命令发送到 `grep` 命令。

但这些临时文件确实很烦人。您可能没有写入权限。您需要记住清理您创建的所有临时文件。您需要确保数据能够正常进出，否则 `FIFO` 可能会无缘无故地阻塞。

出于这些原因，我们提供了另一个特性： *管道（Pipes）* 。管道本质上就是将一个进程的 `stdout` 连接到另一个进程的 `stdin` ，从而有效地将数据从一个进程*传递*到另一个进程。所有通过管道连接在一起的命令集合称为*管道（pipeline）* 。让我们再次尝试上面的例子，但这次使用管道：



```
$ echo "rat
> cow
> deer
> bear
> snake" | grep bea
bear
```



该管道是通过连接两个命令的 `|` 运算符创建的。前一个命令的 `stdout` 连接到后一个命令的 `stdin` 。因此， `grep` 可以读取 `echo` 的输出并显示其运算结果，即 `bear` 。

管道广泛用于应用程序输出的后处理。 `FIFO` 实际上也称为 `named pipes` 。它们与管道运算符的功能相同，但通过文件名来实现。

**笔记：
管道运算符会为每个命令创建一个子 shell 环境。了解这一点很重要，因为在第二个命令中修改或初始化的任何变量，在子命令外部都会保持不变。举例来说：**



```
$ message=Test
$ echo 'Salut, le monde!' | read message
$ echo "The message is: $message"
The message is: Test
$ echo 'Salut, le monde!' | { read message; echo "The message is: $message"; }
The message is: Salut, le monde!
$ echo "The message is: $message"
The message is: Test
```



一旦管道终止，为其创建的子 shell 也会终止。同时，对这些子 shell 所做的任何修改都会丢失。所以务必小心！



------



- **良好做法：
  管道是处理应用程序输出的一种非常便捷的方式。但是，您应该注意不要过度使用管道。如果您最终创建的管道包含三个或更多应用程序，那么您应该反思一下自己的做法是否明智。您或许可以利用管道中先前使用的某个后处理应用程序的更多功能。管道中的每个新命令都会导致加载一个新的子 shell 和一个新的应用程序。这也会使您的脚本逻辑变得难以理解！**



------



- **手册内容：[ 管道](http://www.gnu.org/software/bash/manual/bashref.html#Pipelines)**



------



- **常见问题解答中：
  [我在循环中设置了变量。为什么循环结束后它们会突然消失？或者，为什么我无法通过管道读取数据？](https://mywiki.wooledge.org/BashFAQ/024)**
- **[两个进程如何使用命名管道（FIFO）进行通信？](https://mywiki.wooledge.org/BashFAQ/027)**
- **[如何将标准错误输出重定向到管道？](https://mywiki.wooledge.org/BashFAQ/047)**
- **[如何逐行读取文件？](https://mywiki.wooledge.org/BashFAQ/001)**
- **[请详细解释一下 2>&1——2>&1 >foo 和 >foo 2>&1 有什么区别，什么时候该用哪个？](https://mywiki.wooledge.org/BashFAQ/055)**



------





## 6. 其他操作员



除了标准的 I/O 操作符之外，bash 还提供了一些更高级的操作符，使 shell 的使用体验更加愉快。



### 6.1 工艺替代



管道的“近亲”是*进程替换运算*符，它有两种形式： `<(cmd)` 和 `>(cmd)` 。这是一种便捷的方式，无需自行创建临时文件或命名管道，即可享受它们带来的好处。每当您需要使用临时文件来完成某些操作时，进程替换可能是一种更好的选择。

`>()` 形式比较少见，我们这里就不赘述了，因为它只会让人更加困惑。一旦你理解了 `<()` 的工作原理， `>()` 就只是反向操作（写入而不是读取）。

`<()` 的作用是运行括号内的命令，并生成一个临时文件名，你可以使用该文件名来读取命令的输出。相比管道，它的优势在于你可以将该文件名作为参数传递给需要文件名的命令。

例如，假设你有两个文件想要进行排序，但它们尚未排序。你可以生成两个临时文件，分别存放原始文件的排序版本，然后对这两个临时文件运行排序操作。或者，你也可以使用进程替换：



```
$ diff <(sort file1) <(sort file2)
```



使用 `<()` 操作符，命令的输出会通过 bash 创建的命名管道（或其他类似机制）发送出去。命令中的操作符本身会被替换为该文件的文件名。整个命令执行完毕后，该文件会被清理。

对于任何你想将输出传递给 `diff` 的命令，都可以执行相同的操作。假设你想查看两个命令输出之间的差异。通常，你需要将这两个输出分别放在两个文件中，然后使用 `diff` 将它们传递给 `diff`：



```
$ head -n 1 .dictionary > file1
$ tail -n 1 .dictionary > file2
$ diff -y file1 file2
Aachen                                                        | zymurgy
$ rm file1 file2
```



使用进程替换运算符，我们可以用一行代码完成所有这些操作，而无需手动清理：



```
$ diff -y <(head -n 1 .dictionary) <(tail -n 1 .dictionary)
Aachen                                                        | zymurgy
```



`<(..)` 部分被 bash 创建的临时 FIFO 替换，因此 `diff` 实际上看到的是这样的：



```
$ diff -y /dev/fd/63 /dev/fd/62
```



这里我们可以看到，在使用进程替换时，bash 如何运行 `diff` 命令。它运行 `head` 和 `tail` 命令，并将它们的输出分别发送到文件 `/dev/fd/63` 和 `/dev/fd/62` 。然后，它运行 `diff` 命令，并将这些文件名传递到我们最初放置进程替换运算符的位置。

实际实现方式因系统而异。实际上，您可以通过在命令前加上 `echo` 来查看上述命令在您的系统上对 `diff` 的实际执行效果：



```
box1$ echo diff -y <(head -n 1 .dictionary) <(tail -n 1 .dictionary)
diff -y /dev/fd/63 /dev/fd/62
```





```
box2$ echo <(cat /dev/null)
/var/tmp//sh-np-605454726
```



有关使用 `>()` 形式的示例，请参阅 [ProcessSubstitution](https://mywiki.wooledge.org/ProcessSubstitution) 和 [Bash FAQ 106](https://mywiki.wooledge.org/BashFAQ/106) 。



------



**良好做法：
进程替换功能提供了一种简洁的方式来自动创建临时 FIFO。虽然它们不如手动创建命名管道灵活，但对于像 `diff` 这样需要文件名作为输入源的常见短命令来说，它们非常理想。**

