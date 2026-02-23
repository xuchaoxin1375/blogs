[toc]

## abstract

介绍bash命令本身的可用选项(bash本身是一个可执行程序)以及bash内置的命令(用于bash交互模式和脚本的功能)

将bash视为可执行程序的场景,比如用户当前使用其他shell,例如zsh,且该用户想要临时运行一个bash命令或者bash脚本,那么可以通过如下用法实现.

```bash
Usage:  bash [GNU long option] [option] ...
        bash [GNU long option] [option] script-file ...
...
Shell options:
        -ilrsD or -c command or -O shopt_option         (invocation only)
        -abefhkmnptuvxBCEHPT or -o option
Type `bash -c "help set"' for more information about shell options.
Type `bash -c help' for more information about shell builtin commands.
```

> 方括号 `[]` 表示“可选”，`...` 表示“可重复或带参数”
>
> 这里提到两类用法,第一类是`[option] ...`,此用法实际上包含了第二种用法
>
> 而第二类是`[option] script-file ...`表示可以添加1个脚本文件,`...`是脚本文件的参数,作为第一种用法的一个典型特例
>
> 

创建脚本`demo2.sh`

> ```bash
>echo "current args number:${#}; args: ${@}"
> ```
>
> 使用第二类用法:
>
> ```bash
>bash ./demo2.sh 1 2 3                         
> current args number:3; args: 1 2 3
>```
> 

`"-ilrsD" or "-c command" or "-O shopt_option"`这三种情况是仅启动时有效(invocation only)

> 该行解释 Bash 启动（invocation）时可以使用的命令行选项,仅在 **启动 Bash 时** 有效(把bash当做一个命令)
>
> 例如,该行中的`-c command`,说明的是`bash -c command`这个用法,可以快捷调用bash运行一条bash命令,例如
>
> ```bash
> # root@CxxuColorfulWin10 21:52:33> <~>
> $ bash -c pwd
> /root
> # root@CxxuColorfulWin10 21:52:40> <~>
> $ bash -c 'cat ~/file'
> I am a proud sentence.
> ```
>

`-abefhkmnptuvxBCEHPT or -o option`（可用 `set` 控制）

> 这些选项 **既可以在启动时指定，也可以在脚本或交互 shell 中用 `set` 命令动态开启/关闭**。
>
> 它们对应 `set` 的单字母选项或 `-o longname` 形式。
>
> | 短选项 | 对应 `-o` 长选项 | 作用                                         |
> | ------ | ---------------- | -------------------------------------------- |
> | `-a`   | `allexport`      | 自动导出后续定义的变量                       |
> | `-b`   | `notify`         | 后台作业结束立即通知（不等提示符）           |
> | `-e`   | `errexit`        | 任一命令失败（非0退出）则退出脚本            |
> | `-f`   | `noglob`         | 禁用路径名展开（glob，如 `*` 不展开）        |
> | `-h`   | `hashall`        | 记住命令位置以加速查找（默认开启）           |
> | `-k`   | `keyword`        | 将所有赋值语句视为关键字参数（很少用）       |
>| `-m`   | `monitor`        | 启用作业控制（job control）                  |
> | `-n`   | `noexec`         | **只检查语法，不执行命令**                   |
>| `-p`   | `privileged`     | 启用特权模式（用于 setuid 脚本，安全相关）   |
> | `-t`   | `onecmd`         | 执行完一个命令后退出（类似单命令模式）       |
>| `-u`   | `nounset`        | 使用未定义变量时报错（防错）                 |
> | `-v`   | `verbose`        | 打印读取的每一行输入（包括未执行的）         |
>| `-x`   | `xtrace`         | 打印执行的命令及展开后的参数（调试神器）     |
> | `-B`   | `braceexpand`    | 启用花括号展开（如 `echo a{1,2}` → `a1 a2`） |
> | `-C`   | `noclobber`      | 禁止 `>` 覆盖已有文件                        |
> | `-E`   | `errtrace`       | ERR 信号在函数/子 shell 中继承               |
> | `-H`   | `histexpand`     | 启用历史扩展（如 `!!`、`!$`，交互式默认开）  |
> | `-P`   | `physical`       | `cd` 使用物理路径（不跟踪符号链接）          |
> | `-T`   | `functrace`      | 调试时跟踪函数调用                           |
> 
> > 例如：`set -e` 等价于 `set -o errexit`

更详细的说明通过`bash --help`获取,但这不是最完整的,例如可用的短选项(option)没有展开说明,这可以通过查看bash 内置命令之一的`set`的帮助来获取(` help set`和`set --help`均可)

```bash
$ set --help
set: set [-abefhkmnptuvxBCEHPT] [-o option-name] [--] [-] [arg ...]
    Set or unset values of shell options and positional parameters.

    Change the value of shell attributes and positional parameters, or
    display the names and values of shell variables.
    ...
```

更完整的说明查看其他资料,例如`man bash`.

bash作为shell提供的功能(内置命令和语法(关键字)),可以通过`bash -c help`获取,如果已经处于bash的交互模式,则可以直接运行`help`命令获取bash内置功能的简要帮助



## bash本身的可用选项与set命令的选项

Bash 中的 `set` 命令是一个非常强大的内置工具，主要用于 **显示 shell 变量**、**修改 Shell 特性** 以及 **配置脚本执行环境**。

在编写 Bash 脚本时，合理使用 `set` 可以极大提高脚本的健壮性和可调试性。

```bash
$ help set
set: set [-abefhkmnptuvxBCEHPT] [-o option-name] [--] [-] [arg ...]
    Set or unset values of shell options and positional parameters.

    Change the value of shell attributes and positional parameters, or
    display the names and values of shell variables.
    ...
     The remaining n ARGs are positional parameters and are assigned, in order, to $1, $2, .. $n.  If no ARGs are given, all shell variables are printed.
```

## bash -n 检查bash语法

`set -n` **不能捕获运行时错误**（如变量未定义、文件不存在、命令未找到等），只检查**语法结构**。

例如

```bash
# demo.sh
for i in {1..5}
do
    echo "$i"
done

```



```bash
#( 12/25/25@10:13PM )( root@CxxuColorfulWin10 ):~
   bash  ./demo.sh 
1
2
3
4
5
#( 12/25/25@10:13PM )( root@CxxuColorfulWin10 ):~
   bash -n ./demo.sh
```

也可以配合`-c`直接在命令行中检查指定bash语法语句

```bash
# 故意把done写成donee
   bash -nc 'for i in {1..5} ;do echo "$i" ;donee'
bash: -c: line 2: syntax error: unexpected end of file from `for' command on line 1
# 修正并重新检查
   bash -nc 'for i in {1..5} ;do echo "$i" ;done' 
# 没有输出,表示没有语法错误
```



`bash -c` 是 Linux/Unix 中一个极其强大的选项。它的核心作用是：**从字符串中读取并执行命令**。

通常我们运行脚本是 `bash script.sh`，而使用 `-c` 后，你可以直接在命令行里“拼”出一个临时脚本来执行。

------

## bash -c

这里的`-c`中的`c`是`command`的意思,command可以包含多个命令

其基本格式如下：

```bash
bash -c "command1; command2;..."
#或
bash -c '
command1
command2
...
'
```

它会启动一个**新的子 Shell（Subshell）**，执行双引号内的所有指令，执行完后子 Shell 退出，回到当前终端。

最简单的例子:`bash -c "help set"` 查看bash中`set`命令的帮助信息,相当于在bash中执行`help set`

------

###  核心应用场景

#### A. 在 `sudo` 中执行复杂逻辑

这是最常见的用法。`sudo` 默认只对紧随其后的第一个命令提权。如果你想用重定向写入受保护文件，直接写会失败：

- ❌ `sudo echo "hello" > /etc/config` （重定向符号 `>` 是由当前无权限的用户执行的）
- ✅ `sudo bash -c 'echo "hello" > /etc/config'` （整个 Shell 进程都拥有 root 权限）

#### B. 与 `find` 或 `xargs` 配合

当你需要对找到的每个文件执行**多条**命令时，`bash -c` 是必不可少的。

```bash
find . -name "*.log" -exec bash -c 'mv "$1" "${1%.log}.txt"' _ {} \;
```

这里 `bash -c` 像是一个“匿名函数”，为每个文件开启一个小环境来处理逻辑。

------

###  高阶重点：参数传递（The Dummy Argument）

在使用 `bash -c` 时，你可以向脚本传递参数。其语法规则稍微有点“怪”：

```bash
bash -c 'script' [inline_name] [arg1] [arg2] ...
```

- **`inline_name`**：对应脚本内部的 **`$0`**。
- **`arg1`**：对应脚本内部的 **`$1`**。
- `arg2`:对应脚本内部的`$2`
- ...

为什么通常在`inline_name`的位置放一个下划线 `_`(实际上可以是其他非空白字符,不过按照惯例使用`_`的语义是比较合适的选择)？

看下面这个例子：

```bash
bash -c 'echo "Hello, $1"' _ "World"
```

- `_` 填充了 `$0`。
- `"World"` 填充了 `$1`。
- **输出**：`Hello, World`

也不是必须要用`_`做占位符,还可以用别的词,例如`placeholder`,`anonymous_script`,`tmp_script`

```bash
$ bash -c 'echo "Hello, $1"' placeholder  "World"
Hello, World
```

如果你漏掉了那个 `_`，`"World"` 就会变成 `$0`，而脚本里打印的是 `$1`（此时为空），结果就会变成 `Hello, `。

利用`bash -c`执行一段命令(script)时,bash也是按照执行一个bash脚本的方式处理,不过`bash -c`会将传入script包装成一个临时脚本,但是和bash交互模式下脚本名是自动设置(`$0`自动设置为脚本名)的情况不同有所不同,在`bash -c script`方式下,用户可以(如果需要访问位置参数时,是必须要)指定script的临时脚本名,也就是`script`后的第一个参数,并且在`script`中可以访问这个临时脚本名(用`$0`访问)

```bash
$ bash -c 'echo "$0:Hello, $1"' tmp_script  "World"
tmp_script:Hello, World
```



------

###  `bash -c` vs `sh -c`

在大多数现代 Linux 系统（如 Ubuntu）中：

- `sh` 通常指向 `dash`（一个轻量级 Shell），它不支持 **Bash 特定语法**（如 `[[ ]]` 双括号判断或 `${var%suffix}` 字符串处理）。
- 如果你写的脚本逻辑包含 Bash 特有的高级特性，必须明确使用 `bash -c`;但是如果仅仅是简单的外部程序调用,则`sh`更加快速轻量

------

###  使用建议与安全提醒

1. **引号嵌套**：外面用单引号 `'...'` 包裹脚本，内部变量用双引号 `"$1"`，可以防止文件名中的空格导致崩溃。
2. **变量注入风险**：尽量通过参数（即 `$1`, `$2`）传递变量，**不要**直接把外部变量拼进字符串里，否则容易遭受“命令注入”攻击。

**举例安全风险：**

> - 危险：`bash -c "echo Hello $input"`（如果输入是 `; rm -rf /` 就惨了）
>- 安全：`bash -c 'echo "Hello $1"' _ "$input"`(这里使用`''`来包裹script部分,这意味着`$1`不会被当前shell进程解释!这是安全的基本原因)

对于第一种写法的危险性我们容易理解.

```bash
# (base) cxxu@CxxuDesk 08:29:50> <~>
$ input=";echo in"

# (base) cxxu@CxxuDesk 08:30:10> <~>
$ bash -c "echo Hello $input;"
Hello
in
```

对于第二种,为什么是安全的?

```bash
$ bash -c 'echo "Hello $1"' _ "$input"
Hello ;echo in
```

**当前 Shell 预处理**：因为脚本部分被**单引号** `' '` 包裹，当前 Shell **不会**解析其中的内容。它只看到两个参数：

- 参数 A（代码）：`echo "Hello $1"`
- 参数 B（数据）：`$input` 的值（即 `; echo in`）

**子 Shell 启动**：Bash 启动后，将参数 A 作为要执行的脚本，将参数 B 放入自己的内存空间，并命名为变量 `$1`。

**子 Shell 执行**：Bash 执行 `echo "Hello $1"`。此时，`$1` 的值仅仅被视为 `echo` 命令的一个**普通的字符串参数**。

- **本质**：`; echo in` 永远只是 `echo` 要打印的对象，它没有机会被当作“指令”去触发。

另外,还有一种错误写法需要避免:

```bash
$ bash -c "echo \"Hello $1\"" _ "$input"
Hello
```

这种写法会在当前的shell进程把`$1`解释为空串,子shell启动后看不到此位置参数,导致`input`无论是什么取值都没有作用了.

------

## set基本用法

`set` 命令主要有三种用途：

1. **不带参数**：列出当前所有的 Shell 变量和函数（包括本地变量和环境变量）。
2. **改变 Shell 选项**：控制脚本的运行行为（如报错即停止）。
3. **重置位置参数**：手动设置 `$1`, `$2` 等位置变量。

------

## 常用参数详解（脚本调试与健壮性）

在脚本开头使用 `set -[选项]` 可以改变脚本的全局行为。**注意：** 在 `set` 命令中，减号 `-` 表示开启选项，加号 `+` 表示关闭选项。

### 常见的选项：

| **选项**          | **简写**  | **描述**                                           |
| ----------------- | --------- | -------------------------------------------------- |
| `set -e`          | `errexit` | 如果任何命令返回非零值（执行失败），脚本立即退出。 |
| `set -u`          | `nounset` | 使用未定义的变量时，报错并退出。                   |
| `set -x`          | `xtrace`  | 在执行命令前先打印该命令。常用于代码调试。         |
| `set -o pipefail` | 无        | 只要管道中任何一个命令失败，整个管道就视为失败。   |
| `set -n`          | `noexec`  | 只检查语法错误，不实际执行命令。                   |



- **`set -x` (调试模式)**：它会显示脚本实际执行的每一行，并把变量替换为具体的值。
- **`set -e` (报错即停)**：默认情况下，Bash 脚本即使某行报错也会继续往下运行，这可能导致连锁反应。开启此项后，脚本会更安全。

------

##  手动设置位置参数

你可以使用 `set` 来重新定义当前环境的 `$1`, `$2` 等参数。

```bash
# 例子
set -- apple banana cherry

echo "第一个参数: $1" # 输出 apple
echo "所有参数: $@"  # 输出 apple banana cherry
```

> **注意**：`--` 符号表示 `set` 命令选项的结束，之后的任何内容都会被视为位置参数，即使它们以 `-` 开头。

------

##  最佳实践：Bash 严格模式

许多高级开发者在编写生产环境脚本时，习惯在脚本开头添加以下这行“魔法代码”，以确保脚本尽可能安全地运行：

```bash
#!/bin/bash
set -euo pipefail
```

**这行代码的作用是：**

1. **`-e`**: 任何一行失败就停。
2. **`-u`**: 变量没定义就停（防止 `rm -rf $VAR/` 在 `$VAR` 为空时删掉根目录）。
3. **`-o pipefail`**: 确保如 `false | true` 这样的管道连接也会被识别为失败。

------

##  如何查看当前设置？

如果你想知道当前 Shell 开启了哪些选项,有多种方法

set -o 或 set +o 查看详细bash选项启用情况

### set +o

> If `+o` is supplied with no option-name, set prints a series of set commands to **recreate the current option settings**.
>
> 以可重用的方式打印当前的bash选项设置

```bash
# root@CxxuColorfulWin10 21:38:42> <.../cxxu/Desktop>
$ set +o
set +o allexport
set -o braceexpand
set -o emacs
set +o errexit
set +o errtrace
set +o functrace
set -o hashall
set -o histexpand
set -o history
set +o ignoreeof
set -o interactive-comments
set +o keyword
set -o monitor
set -o noclobber
set +o noexec
set +o noglob
set +o nolog
set +o notify
set +o nounset
set +o onecmd
set +o physical
set +o pipefail
set +o posix
set +o privileged
set +o verbose
set +o vi
set +o xtrace
```



> Using `+` rather than `-` causes these **flags to be turned off**.  
> The flags can also be used upon invocation of the shell.  

### `$-`

> The current set of flags may be found in `$-`.  

```bash
echo $-
```

输出通常类似于 `himBHs`，每个字母代表一个已激活的选项。

### set -o

`set -o`不跟参数时,会打印shell的所有选项设置,相比`set +o`更加直观,但是不可重用

>  If `-o` is supplied with no option-name, set prints the current shell  option settings. 

```bash
$ set -o
allexport       off
braceexpand     on
emacs           on
errexit         off
errtrace        off
functrace       off
hashall         on
histexpand      on
history         on
ignoreeof       off
interactive-comments    on
keyword         off
monitor         on
noclobber       on
noexec          off
noglob          off
nolog           off
notify          off
nounset         off
onecmd          off
physical        off
pipefail        off
posix           off
privileged      off
verbose         off
vi              off
xtrace          off
```

### 选项切换

例如关闭noclobber行为,则使用`set +C`或者

```bash
set +C
```

或者

```bash
set +o noclobber
```



## set和declare命令的比较

简单来说，`set` 和 `declare` 的核心区别在于：**`set` 侧重于配置 `Shell` 的“运行行为”和“全局环境”，而 `declare` 侧重于定义变量的“属性”和“作用域”。**

以下是它们的详细对比：

------

##  核心功能对比

| **特性**     | **set 命令**                                                 | **declare 命令**                                             |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **主要用途** | 修改 **Shell 选项**（如报错停止）或重置 **位置参数**（$1, $2）。 | 声明 **变量属性**（如整型、数组、只读）和控制 **作用域**。   |
| **作用范围** | 影响整个 Shell 会话或脚本的运行方式。                        | 影响具体的变量或函数。                                       |
| **变量定义** | **不能** 直接用于定义新变量（变量定义通常直接用 `VAR=val`）。 | **可以** 定义变量并同时赋予其特殊属性。                      |
| **可移植性** | **POSIX 标准**，在几乎所有 Shell（sh, dash, zsh）中通用。    | **Bash 特有**（在 zsh 中可用），在纯 `sh` 或 `dash` 中不可用。 |

------

##  关键用法差异

### `set` 的典型场景：控制脚本行为

`set` 更多是作为脚本的“开关”。

- **调试与安全**：`set -e`（出错即停）、`set -x`（打印执行过程）。
- **处理参数**：`set -- arg1 arg2` 重新定义脚本的输入参数。

#### `set -- arg1 ...`

 Bash 中，`set --` 主要用于**重新设置当前 Shell 环境（或函数内）的“位置参数”（Positional Parameters）**。

简单来说，它的作用是：**“清除旧的 `$1`, `$2`...，并将后面的内容设为新的 `$1`, `$2`...”**。

------

1. 拆解分析

- **`set`**: Bash 的内置命令，用于设置或取消设置 Shell 选项和位置参数。
- **`--`**: 这是一个 **“信号量”**。它告诉 `set` 命令：“后面的一切内容都只是参数，即使它们以横杠 `-` 开头，也不要按命令选项（Options）来解析”。
- **`arg1 arg2`**: 这里的具体值。

执行完 `set -- arg1 arg2` 后：

- **`$1`** 的值变为 `arg1`
- **`$2`** 的值变为 `arg2`
- **`$#`** (参数个数) 变为 `2`
- **`$@`** 或 **`$\*`** (所有参数列表) 包含这两个值。

这是一个安全防范措施。如果没有 `--`，且你的变量内容以 `-` 开头，`set` 会报错。

**对比示例：**

```bash
# 场景：你想把 -e 设为第一个参数
set -e     # 危险！这会激活 Bash 的 "errexit" 模式（出错立即退出脚本）
set -- -e  # 正确！$1 现在是 "-e"，且不会触发 Shell 选项
```

场景 A：解析字符串并转换为位置参数

这是最常见的用法。当你有一个变量字符串，想利用 Shell 的分词功能快速提取每一项时：



```bash
line="2026-01-25 17:15:47 status=200"

# 使用 set -- 将字符串拆分
set -- $line

echo "日期: $1"  # 输出: 2026-01-25
echo "时间: $2"  # 输出: 17:15:47
echo "状态: $3"  # 输出: status=200
```

场景 B：在函数内部模拟参数传入

参数预处理与默认值分配

在编写复杂的 Bash 函数时，你可以用它来重置函数内部接收到的参数。

```bash
#!/bin/bash

process_deploy() {
    # 假设第一个参数是部署环境，第二个是版本
    local env=$1
    local version=$2

    # 如果没有传版本号，我们通过逻辑获取一个默认版本
    # 然后重置位置参数，方便后续直接用 $@ 传递给其他命令
    if [ -z "$version" ]; then
        version="latest-$(date +%F)"
        # 重新设置参数，这样 $@ 就包含了 environment 和生成的 version
        set -- "$env" "$version"
    fi

    echo "执行部署..."
    echo "当前所有位置参数 (\$@): $@"
    echo "版本号 (\$2): $2"
    
    # 此时可以将更新后的参数整体传给另一个脚本
    # ./remote_deploy.sh "$@"
}

process_deploy "production"
```

场景 C：清空所有位置参数

如果你运行 `set --` 而后面不带任何参数，它会清空当前所有的位置参数（即 `$#` 变为 0）。

> 下面的例子在zsh中效果和bash不同,确保使用bash运行

```bash
#!/bin/bash

# 模拟从某个配置文件读取了一行待处理的参数
while read -r config_line || [[ -n $config_line ]]; do
    #  首先确保环境干净，清空之前的参数
    set -- 
    
    #  如果这行配置不是注释，则解析它
    [[ "$config_line" =~ ^# ]] && continue
    
    # 将配置行拆分为位置参数
    set -- $config_line
    
    #  如果解析后没有参数（空行），跳过
    if [ $# -eq 0 ]; then
        echo "跳过空配置"
        continue
    fi

    echo "正在处理核心任务：主机=$1 端口=$2"
    
done <<EOF
# 这是一个配置文件
192.168.1.1 80
10.0.0.5 443

127.0.0.1 8080
EOF

```

output

```bash
正在处理核心任务：主机=192.168.1.1 端口=80
正在处理核心任务：主机=10.0.0.5 端口=443
跳过空配置
正在处理核心任务：主机=127.0.0.1 端口=8080
```

#### 小结

**`set -- "$@"`**: 实际上保持不变（常用于重新解析某些变量）。

**`set -- "new"`**: 覆盖所有旧参数，现在 `$1` 是 `new`。

**`set --`**: 全部清空，`$#` 归零。

### `declare` 的典型场景：精细化管理变量

`declare` 让 Bash 变量更像“强类型”语言中的变量。

- **类型定义**：

  

  ```bash
  declare -i num=10  # 声明为整数，num+1 会直接进行算术运算
  declare -a list    # 声明为普通数组
  declare -A map     # 声明为关联数组（键值对）
  ```

- **局部变量**：在函数内部使用 `declare`，变量默认是 **局部 (local)** 的，不会污染全局环境。

- **只读属性**：`declare -r VAR="fixed"` 效果等同于 `readonly`。

------

##  它们在哪“长得像”？（显示变量）

当你**不带任何参数**运行它们时，它们的功能会有重叠：

- **`set`**：列出当前 Shell 中定义的所有变量和函数。
- **`declare`**：同样列出所有变量和函数，但它会尝试以“定义命令”的格式（如 `declare -- var="val"`）输出，方便你复制回脚本使用。
- **`declare -p`**：这是最常用的查看方式，它会显示特定变量的定义命令及其实际属性。

------

##  总结：我该选哪个？

- **如果你想让脚本更健壮**（例如：一旦出错就停止执行）：请使用 **`set`** (如 `set -e`)。
- **如果你想在函数里定义一个不影响外部的变量**：请使用 **`declare`**。
- **如果你需要用到数组或整数运算加速**：请使用 **`declare`**。
- **如果你在编写需要兼容各种 Linux 系统的通用脚本 (sh)**：请尽量使用 **`set`**，避免使用 `declare`。

------

 