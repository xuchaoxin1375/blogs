[toc]

## abstract

在GNU/`env` 是一个非常实用且基础的工具。

它主要有两个用途：**查看/修改环境变量**，以及**在指定的运行环境中执行程序**。

最常见的用法之一就是在脚本的第一行（Shebang）看到 `/usr/bin/env`。



## linux上查看环境变量的方法汇总

| **命令**        | **查看范围**       | **是否包含 Shell 函数** | **备注**                                                    |
| --------------- | ------------------ | ----------------------- | ----------------------------------------------------------- |
| **`printenv`**  | 仅环境变量         | 否                      | 最直观,最推荐，支持查看单个变量                             |
| **`env`**       | 仅环境变量         | 否                      | 常用于脚本及临时设置变量运行程序                            |
| **`export`**    | 仅环境变量         | 否                      | 不带参数时打印出所有已导出的变量及其定义方式(`declare`形式) |
| **`echo $VAR`** | 环境变量或本地变量 | 否                      | 简单快速，需加 `$` 符号                                     |
| **`set`**       | 所有变量及函数     | 是                      | 输出内容非常多，通常配合 `grep` 使用                        |

> set是shell内建命令;
>
> env是外部工具,例如GNU/env

- 其中`printenv,env,export`仅查看环境变量
- `echo $VAR`和`set`则可以查看环境变量之外的普通变量



### env vs export

很多初学者会混淆 `env` 和 `export`：

- 两者都支持无参数运行打印环境变量,但是呈现格式不同;
- 设置环境变量时,环境变量的声明周期不同;

| **特性**     | **env**                        | **export**                          |
| ------------ | ------------------------------ | ----------------------------------- |
| **作用范围** | 仅对紧随其后的**一个命令**生效 | 对**当前 Shell 及其所有子进程**生效 |
| **主要用途** | 临时环境运行、脚本解释器定位   | 持久化设置当前会话的环境变量        |

`env [...] command`独有用法(脚本解释器定位工具):

- `env` 会去系统的 `$PATH`（路径列表）里寻找第一个叫 `command` 的程序并**运行它**。(export命令不会去查找PATH也不会运行命令!)



------

##  env 命令的基本用法

分为两方面的功能:

- 环境变量查看
- 指定方式执行命令(能够临时设置环境变量,查找并命令执行)

`env` 命令最直接的用法是**不带任何参数执行**(所有参数都是可选的)，这会列出**当前终端会话中所有的环境变量**。

> “在环境中将每个 NAME（名称）设置为 VALUE（值），并运行 COMMAND（命令）。”
>
> A mere `-` implies` -i`.  (`env`中可以使用`-`代替`-i`)
>
> If no COMMAND, print the resulting environment.

执行后，你会看到类似 `PATH=/usr/bin:/bin`、`USER=root` 等输出。

```bash
$ env --help
Usage: env [OPTION]... [-] [NAME=VALUE]... [COMMAND [ARG]...]
Set each NAME to VALUE in the environment and run COMMAND.
```

### 临时设置变量运行程序

`env` 允许你在不改变当前全局环境的情况下，为某个特定程序设置变量。

语法：

`env 变量名=值 命令`

示例：

假设你想用临时指定的语言运行一个程序：



```bash
env LANG=en_US.UTF-8 date
```

这只会影响 `date` 命令的输出语言，执行完后，你当前终端的 `LANG` 变量依然保持不变。

如果你在终端输入： `env NODE_ENV=production npm start`

这句话的操作流程就是：

1. **Set**: 将变量名 `NODE_ENV` 的值设为 `production`。
2. **Environment**: 这个设置只在本次运行的“环境”中生效，不会改动你的系统全局配置。
3. **Run**: 启动 `npm start` 这个命令。



### 常用参数：

- **`-i` (ignore-environment):** 不带现有的环境变量启动。这允许你**在一个“纯净”的环境中运行程序**。
- **`-u` (unset):** 从环境中删除某个变量。
- **`NAME=VALUE`:** 可选的,在运行命令时临时设置一个环境变量。

- `-S` (或 `--split-string`)

  - **背景：** 在许多 Unix/Linux 系统中，**Shebang 行**后面只能跟**一个**参数。如果你写 `#!/usr/bin/python3 -v -u`，系统可能会把 `-v -u` 整体当成一个文件名，导致报错。

  - **作用：** `-S` 告诉 `env`： “请把我后面这一长串字符串拆分成多个独立的参数。” 这样 `uv`、`run`、`--script` 才能被正确解析为独立的指令。

  - 这是 `env` 命令的一个较新的选项（在较新版本的 GNU coreutils 和 macOS 的 env 中支持），作用是：

    > **将后续参数分割成多个参数传递给真正的命令**。

    如果没有 `-S`，`env` 会把整个 `"uv run --script"` 当作一个参数（即命令名），而不是拆分成 `uv`、`run`、`--script` 三个参数，这会导致找不到名为 `"uv run --script"` 的可执行文件而报错。

示例：

如果你想在一个没有任何预设变量的环境中启动一个 Shell：



```bash
env -i /bin/bash
```

------



## shebang: `#!/usr/bin/env  -S`

这是 `env` 最广为人知的用途。在编写 Python、Node.js 或 Shell 脚本时，我们通常有两种写法：

1. **绝对路径写法：** `#!/usr/bin/python3`
2. **env 写法：** `#!/usr/bin/env python3`

为什么推荐使用 env

- **可移植性 (Portability):** 不同的 Linux 发行版，可执行文件的存放路径可能不同。例如，Python 可能在 `/usr/bin/python3`，也可能在 `/usr/local/bin/python3`。
- **灵活性:** `/usr/bin/env` 会在系统的 `$PATH` 变量所包含的目录中按顺序查找指定的程序。

例如:

当内核看到 `#!/usr/bin/env python3` 时：

1. 它启动 `/usr/bin/env`。
2. `env` 查看当前的 `$PATH`。
3. `env` 找到第一个匹配的 `python3` 并执行它。

例如:

```python
#!/usr/bin/env -S uv run --script
```

在这种场景下，`env` 充当了一个**中介（Proxy）**。

1. 内核看到 `#!`，调用 `/usr/bin/env`。
2. `env` 接收到参数 `python3`。
3. `env` 在当前环境变量 `$PATH` 中检索 `python3` 的真实物理地址。
4. `env` 启动该解释器，并将脚本内容喂给它。



------

