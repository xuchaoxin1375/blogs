[toc]



## bash脚本中处理命令行选项和参数

命令行参数到解析方式很大程度上取决于你想用它们做什么。bash中至少有两种方法，各有优缺点。

> 在一众脚本语言中,bash的命令行参数解析支持力度有限,对于编程人员要求较高,由于bash比较古老
>
> 尽管bash作为一门shell语言,在这方面的易用性和其他shell语言相比并不出众.尤其是powershell这类现代shell语言,对命令行参数的解析支持可谓是极好.
>
> 1. ✅ 声明式，一目了然
> 2. ✅ 自动类型验证
> 3. ✅ 自动生成 `-?` 帮助
> 4. ✅ 支持 Tab 补全
> 5. ✅ 内置必填/默认值/验证

但是这里我们主要讨论的是bash.

bash中关于命令行参数解析主要用到bash内置的命令,包括`getopts`,`while read`组合以及`shift`命令.

###  概述

Unix 命令通常具有如下的**参数语法**：以典型且常用的`tar`命令为例

```bash
tar -x -f archive.tar -v -- file1 file2 file3
```

**请注意这里的约定和顺序，因为它们*很重要* ，而且确实会产生影响**。

此命令有一些***参数*** （`file1 file2 file3`）和一些***选项*** （`-x -f archive.tar -v`），以及传统的*选项结束指示符* “`--`”。

**选项**会出现在**非选项参数*之前* ，不会出现在之后，也不会出现在命令中的任何随机位置**。

有的选项要带参数,有的选项则不带参数,例如开关型选项就不带参数

- 有些选项（`-x、-v`）是**独立的**，要么存在，要么不存在,不需要为这些选项指定参数。

- 有些选项（`-f`）则**需要一个单独的*参数*** 。

### 选项处理循环

在**所有情况**下，**选项处理都涉及编写一个循环**。

- 理想情况下，该循环会**遍历参数列表*一次*** ，依次检查每个参数，并**设置相应的 shell 变量**，以便脚本**记住哪些选项生效**。
- 最终，它**会*丢弃*所有选项**，使**参数列表仅包含*非选项参数* （file1 file2 file3）**。
- 然后，**脚本的其余部分就可以直接开始处理这些参数**，并在需要时引用**选项处理器设置的变量**。
- 选项处理器会在遇到 `--` 参数或**不以连字符开头的参数**时识别**选项结束**。（ 注意,上例中的*选项参数* `archive.tar` 并不表示选项结束，因为它与 `-f` 选项一起处理。）

## shift命令

处理位置参数的一种常见方法是**在使用后逐个删除它们**。为此，bash程序内置了一个名为 `shift` 的**特殊命令**。

`shift` 是一个 Bash 内置命令，用于**移动位置参数**，**将参数列表向左移动指定的位数**。

`shift` 是处理命令行参数的核心工具，特别适合**选项解析**和**参数逐个处理**场景.

(将位置参数序列视为存储在队列中,通过`shift n`命令可以出队队首开始的`n`个元素)

当您发出 `shift` 命令时(默认`n=1`)，第一个位置参数（ `$1` ）会被删除。并使得第二个参数变为 `$1` ，第三个参数变为 `$2` ，依此类推。注意此时位置参数序列中的元素数量会相应减少,运行`shift n`,就会减少`n`个.

因此，如果您愿意，可以编写一个循环，不断重复使用 `$1` ,而不需要关心当前处理到第几个位置参数。

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

```bash
执行 shift 前:
$1    $2    $3    $4    $5
"a"   "b"   "c"   "d"   "e"    $# = 5

执行 shift 后 (n=1):
$1    $2    $3    $4
"b"   "c"   "d"   "e"           $# = 4
 ↑     ↑     ↑     ↑
原$2  原$3  原$4  原$5          (原$1 "a" 被丢弃)

上一步的基础上继续执行 shift 2 后:
$1    $2
"d"   "e"                       $# = 2
```

### 基础示例

示例1：基本使用

```bash
#!/bin/bash
# test_shift.sh

echo "初始参数: $@"
echo "参数个数: $#"
echo "\$1 = $1"

shift

echo "--- shift 后 ---"
echo "剩余参数: $@"
echo "参数个数: $#"
echo "\$1 = $1"
```

**运行结果：**

```bash
$ ./test_shift.sh a b c d
初始参数: a b c d
参数个数: 4
$1 = a
--- shift 后 ---
剩余参数: b c d
参数个数: 3
$1 = b
```

示例2：指定移动位数

```bash
#!/bin/bash

echo "原始参数: $@"
shift 3
echo "shift 3 后: $@"
```

```bash
$ ./script.sh 1 2 3 4 5
原始参数: 1 2 3 4 5
shift 3 后: 4 5
```

---

常见应用场景

场景1：遍历所有参数

```bash
#!/bin/bash
# 逐个处理所有参数(使用shift会修改参数列表)

count=1
while [ $# -gt 0 ]; do
    echo "参数 $count: $1"
    shift
    ((count++))
done
```

遍历所有参数的方案还有其他的

```bash
#!/bin/bash
count=1
for arg in "$@";do
    echo "参数 $count: $arg"
    ((count++))
done

# 遍历序列索引,并借助间接引用访问对应的位置参数值
#!/bin/bash
for i in $(seq 1 $#); do
    echo "参数 $i: ${!i}"
done
# 或
#!/bin/bash
for ((i=1;i<=$#;i++)); do
    echo "参数 $i: ${!i}"
done


# 将命令行参数保存到数组中再处理
#!/bin/bash
args=("$@")
for i in "${!args[@]}"; do
    echo "参数 $i: ${args[i]}"
done

# 如果不需要打印参数序号，可以简化为：
for i in "$@"; do
    echo "参数 $i"
done
```

### 解析命令行选项

如果脚本的某个选项时

> - 选项带有参数(比如`--file f1`),则在使用`shift`命令时,访问选项的参数值`f1`可以通过`$2`获取(并且通常要将此值保存到对应的变量中便于使用),并且通过`shift 2`移除掉已经解析的参数组(如果某个选项接受超过1个参数,则shift位数相应增加);为了提高代码的健壮性,通常还应该做**选项参数检查处理**,在参数缺失时及时返回准确的提示.
> - 选项不带参数(例如`--verbose`),则在使用`shift`命令时,没有对应的选项参数需要获取,解析完直接将选项本身`shift`掉即可(使用`shift 1`,简写为`shift`)

不过利用循环解析命令行选项的`shift`位置和时机可以灵活安排,不一定上方所述的那样.例如,将`shift`语句放一个到`while`循环`done`之前,这样任何内部的case解析结束后都会自动执行一次`shift`.

(但是共同规律是选项带参数是shift的位数比不带参数的shift位数至少多1)

```bash
#!/bin/bash
# 简单的选项解析器(这里为了突出shift,暂时不做选项参数检查处理)

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            echo "显示帮助信息"
            shift # 不带参数的选项,使用shift
            ;;
        -f|--file)
            FILE="$2"          # $2 是选项的值
            echo "文件: $FILE"
            shift 2            # 同时移除选项和它的值,要用shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            echo "启用详细模式"
            shift
            ;;
        --)
            shift
            break              # -- 后面的都是普通参数,使用break结束选项参数的解析.
            ;;
        -*)                    # 使用*作为通配模式,捕获所有未被其他选项匹配的选项,通常放在最后
            echo "未知选项: $1"
            exit 1
            ;;
        *)
            break              # 非选项参数,执行和--相似的行为(break)，停止解析
            ;;
    esac
    # 可以在循环的这个位置统一shift ,这种策略下,无参数选项就可以不用写shift,而带参数选项通常就是shift 1;
    # shift
done

echo "剩余参数: $@"
```

**运行示例：**

```bash
$ ./parser.sh -v -f config.txt --help arg1 arg2
启用详细模式
文件: config.txt
显示帮助信息
剩余参数: arg1 arg2
```

场景3：分离第一个参数和其余参数

```bash
#!/bin/bash
# 第一个参数是命令，其余是该命令的参数

command="$1"
shift
# 剩下的参数"$@"存入args
args="$*"

echo "执行命令: $command"
echo "命令参数: $args"

```



---

### 注意事项

```bash
# ⚠️ shift 不影响 $0 (脚本名称)
echo "$0"    # 始终是脚本名

# ⚠️ shift 后参数无法恢复，如需保留请先备份
all_args=("$@")
shift 2
# 恢复: set -- "${all_args[@]}"
```

---



## 选项处理循环的两种方案

编写**选项处理循环**有两种基本方法：一种是**从头开始编写循环**（我们称之为“**手动循环**”(Manual loop )），另一种是使用 shell 的 `getopts` 命令来辅助选项拆分。第一种更加灵活和强大.

我们将介绍这两种方法。

> 这里讨论的是`getopts`,而不是`getopt`,两者不同.
>
> **请勿使用 getopt(1)。本页不讨论 getopt。** 请前往 [ComplexOptionParsing](https://mywiki.wooledge.org/ComplexOptionParsing) 了解更多信息。



## Manual loop

手动解析选项是**最灵活的方法**。实际上，它也是*最佳*方法，因为它允许你做任何你想做的事情：你可以处理**单字母选项和长选项**，也可以处理**带或不带选项参数的选项**。这就是我们首先介绍它的原因。

在这个例子中，请注意 `--file FILE` 和 `--file=FILE` 是如何处理的。(空格和`=`分隔选项和参数的两种风格)

```bash
#!/bin/sh

die() {
    printf '%s\n' "$1" >&2
    exit 1
}
#初始化可能要用到的选项变量,防止环境中已有的同名变量对其产生干扰
# Initialize all the option variables.
# This ensures we are not contaminated by variables from the environment.
file= #默认文件名为空
verbose=0
# 编写选项处理的循环:手动循环
# 这里我们在while内部,esac后面放置一个shift语句,让各个选项解析分支内,少写或者不写shift,尤其是不带参数的命令行选项.
while :; do
    case $1 in
        -h|-\?|--help)
            show_help    # Display a usage synopsis.
            exit
            ;;
        -f|--file)
            if [[ -n "$2" && "$2" != -* ]]; then
                file="$2"
                shift
            else
                die 'ERROR: "--file" requires a non-empty option argument.'
            fi
            ;;
        -f=*|--file=*)
        	# 将等号以及前面的部分移除,剩下的就是文件名(路径)了
            file=${1#*=} # Delete everything up to "=" and assign the remainder.
            # 为了防止用户传入的文件名是空的,这里做检查
            [[ -z "$file" ]] && die 'ERROR: "--file" requires an argument.'
            shift
            ;;
        -v|--verbose)
        	# 将日志的详细信息设置为多级,并且允许叠加使用此选项来增加详细程度(数值),-v -v 就是2级
            verbose=$((verbose + 1))  # Each -v adds 1 to verbosity.
            ;;
        -vv*)
            # 提取 - 后面的部分
            flags="${1#-}"
            
            # 检查flags是否全为 v
            if [[ "$flags" =~ ^v+$ ]]; then
                # 计算 v 的数量
                verbose=$((verbose + ${#flags}))
            else
                echo "未知选项: $1"
                exit 1
            fi
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)               # Default case: No more options, so break out of the loop.
            break
    esac

    shift
done



# Rest of the program here.
# If there are input files (for example) that follow the options, they
# will remain in the "$@" positional parameters.
```

这里检查选项是否全是`v`还可以用下面的方法

```bash
check_all_v() {
    local str="$1"
    local removed="${str//v/}"  # 删除所有 v
    # 删除所有v后为空,且原str非空,则说明str由且仅由1个或多个v构成的选项名.
    if [[ -z "$removed" && -n "$str" ]]; then
        echo "全是 v"
        return 0
    else
        echo "不全是 v"
        return 1
    fi
}
```

此例中的选项**解析器**无法处理一般的**连接在一起的单字母选项**（例如将 `-xvf` 解析为 `-x -v -f` ）尽管这不是必须支持的功能

> 我们可以通过一些努力添加此功能，但这里留给读者作为练习。

实际上，**处理长选项**的 shell 脚本**很少会同时处理单字母选项拆分**。这样做并不值得。

大多数情况下，你编写的 shell 脚本无需担心单字母选项拆分，因为只有你自己会用到它们。**只有当你打算将程序公开发布时，才需要进行复杂的选项处理，而这种情况在实际应用中几乎*不会*发生**。

此外，支持**单字母选项合并**的选项风格还会阻止使用 **Tcl 风格的长参数**（例如 `-foo` ），而某些命令（如 [find(1)](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/find.html) 、 [gcc(1)](https://linux.die.net/man/1/gcc) 和 [star(1)）](https://linux.die.net/man/1/star) 会使用这种参数。

> 两种风格的冲突是显然的,如果同时支持,那么`-foo`就还可能被解释为`-f -o -o`,除非做更加复杂的处理
>
> > **Tcl**（读作 “**tickle**”，全称 **Tool Command Language**）是一种**轻量级、解释型的脚本语言**



## getopts

> getopts: Parse option arguments.
>
> Getopts is used by shell procedures to **parse positional parameters as options**.

通常认为,`getopts` 适用于**简单的脚本**。选项解析需求越复杂，就越不应该使用 `getopts` (实际上bash相比于其他现代化脚本语言并不那么适合用于编写复杂脚本,如果条件允许,考虑python等脚本语言来构建可读性和可维护性更强的脚本）

[getopts 有一个教程 ](https://web.archive.org/web/20230324055145/https://wiki.bash-hackers.org/howto/getopts_tutorial)，解释了所有语法和变量的含义。在 bash 中，还有 `help getopts` 。

和手动循环解析选项参数类似,此命令也通常配合`while`循环和`case`语法使用.

作为bash内置命令,[bash手册对此也有描述.|getopts](https://www.gnu.org/software/bash/manual/bash.html#index-getopts)

------

###  基本语法

```bash
getopts optstring name [arg ...]
```

成分说明:(记住这几个单词,后续讨论中将直接使用`optstring`,`name`(也经常命名为`opt`)这些名字来表示`getopts`的语法中的成分,他们的含义在这里声明过了,后续遇到不要觉得莫名奇妙,尤其是初学者.)

- **`optstring`**：定义脚本可以接受哪些选项字母,选项有参数时应该放在哪里（如 `ab:c`,`:ab:c`）。
- **`name`**：一个变量名，用于**存储当前捕获到的选项字母**(这个名字可以自定义,不一定名为`name`)。
- **`[arg ...]`**：可选，默认解析**脚本**收到的参数（`$@`），也可以手动指定解析特定字符串。`getopts` 通常解析**位置参数**(用户传递进来的命令行参数)，但如果以 `arg` 值(序列)提供了更多的参数， `getopts` 会解析这些参数。

### 工作机制

每次调用时，`getopts` 命令会：

1. 将**下一个选项**放入 shell 变量 `$name` 中（如果 name 不存在则初始化它）
2. 将**下一个待处理参数**的**索引**放入 shell 变量 `OPTIND` 中

**注意：** 每次调用 shell 或 shell 脚本时，`OPTIND` 都会被初始化为 1。

当某个选项需要参数时，getopts 会将该参数放入 shell 变量 `OPTARG` 中。

在标准的完整选项参数解析应用中,`case`语句是在选项被解析后要执行对应的**变量赋值语句**和其他可能的语句.

`getopts`每解析一个选项,都会临时地将选项字母记录到`name`变量中,如果这个变量要求接受参数,则还会将解析到的参数临时存入`OPTARG`变量中.程序员应该及时使用这些临时存储的值,否则下一轮解析会有新的值覆盖.

------

###  核心概念和相关变量

`getopts` 通过几个预定义的 Shell 变量来工作：

| **变量**     | **描述**                                                     |
| ------------ | ------------------------------------------------------------ |
| **`OPTARG`** | 选项值变量,存储当前选项的**参数值**（如果该选项需要参数）。在错误报告模式是静默模式时,也可能保存到是当前未被正确处理的选项的名字(字母) |
| **`OPTIND`** | 选项索引变量,存储下一个要处理的**参数**(命令行中传递给脚本的参数)的**索引值**（从 1 开始按需增加）。 |
| **`OPTERR`** | 选项错误变量,控制是否显示错误信息（默认为 1 开启，设为 0 关闭）。如果变量 OPTERR 的值为 0，getopts 会禁止打印错误信息，即使 OPTSTRING 的第一个字符不是冒号(非静默模式)。 |

------

> `OPTIND`指的不是`optstring`中的字符索引,而是命令行中传递给脚本的参数的索引,`$1,$2,...`
>
> **the index of the next argument** to be processed into **the shell variable `OPTIND`**.
>
>   `OPTIND` is initialized to 1 each time the shell or a shell script is invoked. 
>
> `getopts`命令会自动管理`OPTIND`的变化,不同的命令行参数输入可能会有不同的`OPTIND`取值变化过程,可以确定的是,在同一次脚本调用中,`OPTIND`的值不会变小(但是也不保证增大)

事实上,我们可以在bash中检索出相应变量并打印他们的值(如果可用的话),在交互模式中也可以操作.

```bash
$ echo "${!OPT*}"
OPTERR OPTIND

$ for opti in "${!OPT@}";do  echo "$opti=${!opti}"; done
OPTERR=1
OPTIND=1
```

换一种方式重新描述(帮助手册风格)

`getopts optstring name [arg ...]`
用于解析选项参数（option arguments）。

> getopts 被 shell 过程（shell procedures，通常指 shell 函数或脚本）用来将位置参数（positional parameters，如 `$1 $2 ...`）解析为选项（options）。

- `OPTSTRING` 包含需要被识别的**选项字母**（option letters）；如果某个字母后面跟着一个冒号（colon, `:`），表示该选项需要一个参数（argument），这个参数应当通过空白字符（white space）与选项本身分隔。每次调用 getopts 时，它会将下一个选项放入 shell 变量 `$name` 中；如果该变量不存在，则会先初始化它。
- 同时，把**下一个将要处理的参数索引**（index）存入 shell 变量 `OPTIND`。`OPTIND` 在每次 shell 或 shell 脚本启动时都会被**初始化为 1**。
- 当某个`选项`需要`参数`时，`getopts` 会把该参数放入 shell 变量 `OPTARG` 中。

#### 最简单的用例

```bash
#!/bin/bash
 
while getopts ":a" opt; do
  case $opt in
    a)
    # 将消息打印到stdout指向stderr,默认都输出到屏幕上
      echo "-a was triggered!" 
      ;;
    \?)
    # 例如使用选项-b,由于未在optstring中定义，会触此分支(非法选项b会被记录到变量OPTARG中)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done
```

这里将`getopts`命令放在`while`的条件测试部分.

- `optstring`设置为`:a`
- `name`变量设置为`opt` 

`while`循环每次运行条件测试都会运行到`getopts`命令,而`optstring`被解析到那个选项(字母),则由`OPTIND`变量维护(记录),这个变量记录这下一个要处理的参数的**索引值**

上述例子中,第一次进入while循环时,`opt`变量被设置为了`a`(注意`:`不会被分配给`opt`)

```bash
# (base) cxxu@CxxuDesk 15:28:18> <~>
$ bash test_getopts.sh -a
-a was triggered!

# 错误处理:
# (base) cxxu@CxxuDesk 15:31:23> <~>
$ bash test_getopts.sh -b
Invalid option: -b

$ bash test_getopts.sh -b -c
Invalid option: -b
Invalid option: -c
```

这里的错误提示是我自定义的:`Invalid option...`,并且通过读取`$OPTARG`来报告在解析那个选项时出的错误.

如果将`getopts`中的`optstring`开头的`:`移除(变成`a`),此时选项解析错误处理如下:(getopts内置的错误报告被打印出来,我们自定义的错误也被打印出来,不过由于非静默模式,`$OPTARG`被置空(变量被移除),我们的自定义语句访问`OPTARG`就已经空了.)

```bash
$ bash test_getopts.sh -b
test_getopts.sh: illegal option -- b
Invalid option: -
```

继续改版(在学习阶段,不建议使用`:`静默`optstring`)

```bash
#!/bin/bash
optstring=":a:x"
echo "optstring=[$optstring]"
while getopts "$optstring" opt; do
  case $opt in
    a)
      # 将消息打印到stdout指向stderr,默认都输出到屏幕上
      echo " (opt=$opt) with value was triggered! value=[$OPTARG]"
      ;;
    x)
      echo " (opt=$opt) was triggered!"
      ;;
    \?)
      # 例如使用选项-b,由于未在optstring中定义，会触此分支
      # 在optstring中启用静默错误模式时,非法选项b会被记录到变量OPTARG中;如果不静默,则不会存到OPTARG中中
      echo "Invalid option: (opt=$opt) [OPTARG=$OPTARG]" 
      ;;
  esac
  echo "[OPTIND=$OPTIND] (opt=$opt) [OPTARG=$OPTARG]" 
done

```

正确调用示例:

```bash
$ bash test_getopts.sh -a v1 -x
-a (opt=a) with value was triggered! value=[v1]
-x (opt=x) was triggered!
```

接下来,我们故意将`-a`期望的参数漏传,而紧跟`-x`

```bash
$ bash test_getopts.sh -a -x
-a (opt=a) with value was triggered! value=[-x]
```

可以发现,`-a`选项被找到,但是该选项参数变成了`-x`,这和我们预期的不符(`-x`应该是单独的选项.)

因此,在使用带参数选项和不带参数选项混用时要小心.

如果仅使用参数`-a`而缺失选项参数,则getopts会报告相应的错误.

```bash
$ bash test_getopts.sh -a
test_getopts.sh: option requires an argument -- a
Invalid option: -
```

使用未定义(未知)选项,效果如下:

在optstring中启用静默错误模式时:

```bash
$ bash test_getopts.sh  -q
optstring=[:a:x]
Invalid option: (opt=?) [OPTARG=q]
```

非静默

```bash
$ bash test_getopts.sh  -q
optstring=[a:x]
test_getopts.sh: illegal option -- q
Invalid option: (opt=?) [OPTARG=]
```

非静默,且选项`a`参数缺失时

```bash
$ bash test_getopts.sh  -a
optstring=[a:x]
test_getopts.sh: option requires an argument -- a
Invalid option: (opt=?) [OPTARG=]
```

#### 展示更多细节的版本

```bash
#!/bin/bash
optstring=":a:x"
# echo "optstring=[$optstring]"
# 第一个参数是模式，其余分配给getopts处理
mode=$1
shift
if [ "$mode" == "silent" ]; then
  echo "silent mode."
else
  echo "normal mode."
  # 去掉optstring开头的:
  optstring="${optstring#:}"
fi
# 检查剩余参数.
echo "args for getopts: [$*]"
cnt=1
for arg in "$@"; do
  echo "arg $cnt: $arg"
  cnt=$((cnt+1))
done

echo "optstring=[$optstring]"
echo
# echo "[OPTIND=$OPTIND] before getopts." #如果需要观察OPTIND的变化规律时可以解开注释
# 主要选项和参数解析部分
while getopts "$optstring" opt; do
  case $opt in
    a)
      # 将消息打印到stdout指向stderr,默认都输出到屏幕上
      echo " (opt=$opt) with value was triggered! value=[$OPTARG]"
      ;;
    x)
      echo " (opt=$opt) was triggered!"
      ;;
    \?)
      # 例如使用选项-b,由于未在optstring中定义，会触此分支
      # 在optstring中启用静默错误模式时,非法选项b会被记录到变量OPTARG中;如果不静默,则不会存到OPTARG中中
      echo "Invalid option: (opt=$opt) [OPTARG=$OPTARG]" >&2 #将错误信息输出到标准错误流,是标准做法
      ;;
  esac
  # echo -n "[OPTIND=$OPTIND] "
  echo "(opt=$opt) [OPTARG=$OPTARG]" 
done

 

```

主要观察一下错误处理

在使用非静默模式(`normal`)的情况下:

```bash

# (base) cxxu@CxxuDesk 17:53:26> <~>
$ bash ./test_getopts.sh normal -a
normal mode.
args for getopts: [-a]
arg 1: -a
optstring=[a:x]

./test_getopts.sh: option requires an argument -- a
Invalid option: (opt=?) [OPTARG=]
(opt=?) [OPTARG=]


```

非静默且使用了非法选项(`-k`),此时非法选项被直接打印出来,而不存储到`OPTARG`中

```bash
# (base) cxxu@CxxuDesk 17:57:48> <~>
$ bash ./test_getopts.sh normal -k
normal mode.
args for getopts: [-k]
arg 1: -k
optstring=[a:x]

./test_getopts.sh: illegal option -- k
Invalid option: (opt=?) [OPTARG=]
(opt=?) [OPTARG=]
```

接下来是静默模式.

选项合法(`-a`),但是缺失选项参数的情况

```bash

# (base) cxxu@CxxuDesk 17:57:49> <~>
$ bash ./test_getopts.sh silent -a
silent mode.
args for getopts: [-a]
arg 1: -a
optstring=[:a:x]

(opt=:) [OPTARG=a]


```

可以看到`opt`在静默模式下,对于选项`a`参数缺失时,会将`opt`设置为`:`,且`OPTARG`被设置为此缺失参数的选项`a`

静默模式在,使用非法选项`-k`,发现`OPTARG`会保存非法选项`k`,供自定义错误处理.

```bash
# (base) cxxu@CxxuDesk 17:58:27> <~>
$ bash ./test_getopts.sh silent -k
silent mode.
args for getopts: [-k]
arg 1: -k
optstring=[:a:x]

Invalid option: (opt=?) [OPTARG=k]
(opt=?) [OPTARG=k]
```



###  错误报告模式

`getopts` 有两种处理错误（如输入了未知选项或缺失参数）的方式：

#### 1. 静默模式 (Silent Mode)

- **触发方式**：`optstring` 的第一个字符是冒号（例如 `:ab:c`）。
- **表现**：不打印报错(`illegal option -- ...`这类消息)。
- **无效选项**：变量 `name` 被设为 `?`，`OPTARG` 存储发现的**无效字符**。
- **缺失参数**：变量 `name` 被设为 `:`，`OPTARG` 存储该选项字符。

| 错误类型     | NAME 的值  | OPTARG 的值 |
| ------------ | ---------- | ----------- |
| 无效选项     | 该选项字符 | 该选项字符  |
| 缺少必需参数 | `:`        | 该选项字符  |

#### 2. 普通模式|详细模式 (Verbose Mode)

> 注意:**如果变量 OPTERR 的值为 0，getopts 会禁止打印错误信息，即使 OPTSTRING 的第一个字符不是冒号(非静默模式)。**
> OPTERR 的默认值为 1。

- **触发方式**：`optstring` 开头不是冒号（默认）。
- **表现**：打印诊断错误信息。
- **无效选项**：变量 `name` 被设为 `?`，`OPTARG` 被取消定义,这一点和静默模式不同。
- **缺失参数**：变量 `name` 被设为 `?`，`OPTARG` 被取消定义。



| 错误类型     | NAME 的值 | OPTARG 的值 | 其他行为     |
| ------------ | --------- | ----------- | ------------ |
| 无效选项     | `?`       | 未设置      | -            |
| 缺少必需参数 | `?`       | 未设置      | 打印诊断信息 |

------

### 退出状态 (Exit Status)

- **成功 (0)**：只要找到了一个合法的选项，就返回成功。
- **失败 (非 0)**：当遇到选项结束（即遇到不以 `-` 开头的参数，或遇到 `--` 分隔符）或者发生错误时，返回失败。这通常用于结束 `while` 循环。

------

### OPTIND的含义

事实上我们在使用`getopts`时通常不用太在意`OPTIND`,这个变量有getopts自动管理和使用,用户通常关注的是`name`(即getopts用法手册中定义`name`占位符),它保存选项字母(名字)和`OPTARG`(保存选项的参数,如果有的话.)

但为了知识的完整性,这里也做详细介绍.

> 在发生报错的情况在,`name`还会被设置为`?`或`:`
>
> `OPTIND`是内置的bash变量,即便没有运行`getopts`,仍然尤其默认取值(1),每次运行`getopts`,`OPTIND`可能有三种状态
>
> - 不增加(如果多个选项连写,而不是分开)
> - 可能+1(如果选项没有连写,且不需要带参数)
> - 可能+2(如果遇到选项需要参数的话).

在介绍完整用例之前,为了突出重点(例如观察`OPTIND`,`OPTARG`变量的变化规律),有些例子并不涉及`case`语句,仅分析`getopts`是如何解析选项和参数的,以及会做些什么事情.

```bash
#!/bin/bash
# 实验1: 基础观察
# 保存为 getopts_ind.sh

# 根据需要将第一个参数移除,观察getopts变化
#shift && echo "shift:移除第一个参数"

optstring="abc"
# optstring=":abc"
# optstring="a:bc"
# 检查输入的参数.
echo "args for getopts: [$*]"
cnt=1
for arg in "$@"; do
  echo "arg $cnt: $arg"
  cnt=$((cnt+1))
done
echo "optstring=[$optstring]"
echo

echo "初始 OPTIND = $OPTIND"

while getopts "$optstring" opt; do
    echo "当前选项: opt=$opt, OPTIND = $OPTIND,OPTARG=[$OPTARG]"
done

echo "循环结束后 OPTIND = $OPTIND"
```

#### 观察shift移除参数的影响

不移除第一个参数时

```bash
$ bash ./getopts_ind.sh -a -b -c
args for getopts: [-a -b -c]
arg 1: -a
arg 2: -b
arg 3: -c
optstring=[abc]

初始 OPTIND = 1
当前选项: opt=a, OPTIND = 2,OPTARG=[]
当前选项: opt=b, OPTIND = 3,OPTARG=[]
当前选项: opt=c, OPTIND = 4,OPTARG=[]
循环结束后 OPTIND = 4
```

移除第一个参数时(启用`shift`语句)

```bash
$ bash ./getopts_ind.sh -a -b -c
shift:移除第一个参数
args for getopts: [-b -c]
arg 1: -b
arg 2: -c
optstring=[abc]

初始 OPTIND = 1
当前选项: opt=b, OPTIND = 2,OPTARG=[]
当前选项: opt=c, OPTIND = 3,OPTARG=[]
循环结束后 OPTIND = 3
```

对比发现,是否借助shift移除第一个参数,`getopts`命令的执行效果基本一致,`OPTIND`的取值没有出乎预期的情况.

#### 观察optstring中`:`的影响

在`optstring`中`a`选项字母后增加`:`,变成`optstring="a:bc"`

> 暂时不讨论开头添加`:`的情况,这是对getopts错误处理模式设置.

仅启用一个参数(带有选项)

```bash
$ bash ./getopts_ind.sh -a va 
args for getopts: [-a va]
arg 1: -a
arg 2: va
optstring=[a:bc]

初始 OPTIND = 1
当前选项: opt=a, OPTIND = 3,OPTARG=[va] -n
循环结束后 OPTIND = 3
```

注意,离开循环时,`OPTIND-1`恰好是最后一个被处理的命令行参数`$2`的索引(即便`$2`不是选项字母而是选项`a`的参数)

使用全部参数

```bash
$ bash ./getopts_ind.sh -a va -b -c
args for getopts: [-a va -b -c]
arg 1: -a
arg 2: va
arg 3: -b
arg 4: -c
optstring=[a:bc]

初始 OPTIND = 1
当前选项: opt=a, OPTIND = 3,OPTARG=[va]
当前选项: opt=b, OPTIND = 4,OPTARG=[]
当前选项: opt=c, OPTIND = 5,OPTARG=[]
循环结束后 OPTIND = 5

```



发现此例子`OPTIND`跳过了2(没有观察到取值为2的时候).

`getopts`命令运行前(处理`optstring`字符串的第1个字符前)取值是1,这个值此时并不是由`getopts`设置的,而是bash设置的默认值.

> bash中,一个可执行文件(包括可执行脚本文件)在命令行中,位置参数`$0`表示脚本,`$1`开始才是脚本的参数,`OPTIND`的默认值设置为1而不是0是合理的.

为了便于讨论,为本例中的命令行参数编号:(并且将`arg i`用`$i`等价代指,例如`arg 1`就是`$1`)

- arg 1: -a

- arg 2: va
- arg 3: -b
- arg 4: -c

在`getopts`第一次被执行时,检查位置参数`$1=-a`,发现参数中第一个字母`a`同时也是最后一个字母,`OPTIND`需要+1,且`a`在`optstring`串(`a:bc`)中有定义,而且`a`还跟随`:`,这意味着后续的`OPTARG`会被赋予值,`OPTIND`更新时会额外+1,`opt`(name)被设置为选项名`a`,并且设置`OPTARG=va`备用,这是用户为`-a`选项传递的参数,然后更新`OPTIND`到3(1+2=3),表明下一个需要被解析的命令行参数应该是`$3`

> getopts每次解析参数时有2个机会可能使得`OPTIND`增加1,也就是每轮最终可能增加的数值是2,1,0中的一个
>
> 如果`optstring`中字母后带有1个`:`就要在更新`OPTIND`时额外+1
>
> 另一个可能引起`OPTIND`+1的机会取决于用户传参时是否使用了选项连写有关,可以归纳为,如果当前解析的字母是选项的最后一个字母,则需要对`OPTIND`+1.

> 在遇到需要接受参数的选项,getopts需要执行此设置`OPTARG`变量的步骤,否则会置空掉`OPTARG`变量(但是不会被unset掉,可以通过在循环中打印`${!OPT*}`或用`declare -p OPTARG`验证),避免选项参数混淆.)
>

接着,借助循环,再次执行了一次`getopts`,根据此时`OPTIND`取值为3,而`$3=-b`;getopts命令检查`optstring`发现定义中存在`b`字母,并且`b`后面不跟随`:`,从而getopts认为选项`b`不需要参数,`OPTARG`被尝试置空;根据getopts的工作机制,设置完`opt`的值后`opt=b`,就会计算新的`OPTIND`取值为4(3+1=4),并且将`OPTIND`设置为正式值4;

此时命令行参数解析尚未结束,同理,循环将再次执行,getopts将检查第4个参数`-c`,其在`optstring`中有定义,并且此时没有下一个字母(所有optstring的字符解析完毕),设置本轮的`opt=c`,`OPTARG`就被尝试置空(如果之前`OPTARG`已经置空或者从来没有此变量也没有副作用),而`OPTIND`在所有参数被解析完毕后依然会被更新,并设置为新值5(4+1=5);

最后注意,离开循环时,`OPTIND-1`恰好是最后一个被处理的命令行参数`$4`的索引

---



最后再看一个选项连写(选项合并写)的用例,这里将出现`OPTIND`在getopts命令运行一次后不增加的情况.

启用所有参数,并且最后两个选项合并写:得益于`getopts`的设计,天然支持选项合并(但是这种合并写法不允许选项带有参数,除非写在合并项的最后一个字母,就像tar命令的`-f`选项那样)

```bash
$ bash ./getopts_ind.sh -a va -bc
args for getopts: [-a va -bc]
arg 1: -a
arg 2: va
arg 3: -bc
optstring=[a:bc]

初始 OPTIND = 1
当前选项: opt=a, OPTIND = 3,OPTARG=[va]
当前选项: opt=b, OPTIND = 3,OPTARG=[]
当前选项: opt=c, OPTIND = 4,OPTARG=[]
循环结束后 OPTIND = 4
```

解析到`va`参数(`$2`)为止和上一种的情况是相同的,区别在于解析`$3`;由于`$3=-bc`,这里有2个选项字母,`getopts`可以识别出该参数不止1个字母,会暂缓更新`OPTIND`(或者说更新后的值会当前的值一样,都是3),需要对此参数执行多轮(2轮)解析;

首先会遇到字母`b`,其在`optstring`中有定义,并且定义中`b`后面不带`:`,`b`也不是该参数(`$3`)的最后一个字母,所以本轮`OPTIND`不会增加,仍然为3;(设置本轮的`opt=b`,并`OPTARG`置空;)

下一轮`getopts`仍然解析`$3`,不过现在到了字母`c`,同样发现在`optstring`中有`c`定义,并且没有跟随`:`,而`c`是当前参数`$3`的最后一个选项字母,需要`OPTIND`+1,更新到4;(设置本轮的`opt=c`,`OPTARG`为空)

最后注意,离开循环时,`OPTIND-1`恰好是最后一个被处理的命令行参数`$3`的索引

---

调整顺序,下面这种写法也是合法的,getopts可以正确识别和解析.

```bash
$ bash ./getopts_ind.sh -ca va -b
args for getopts: [-ca va -b]
arg 1: -ca
arg 2: va
arg 3: -b
optstring=[a:bc]

初始 OPTIND = 1
当前选项: opt=c, OPTIND = 1,OPTARG=[]
当前选项: opt=a, OPTIND = 3,OPTARG=[va]
当前选项: opt=b, OPTIND = 4,OPTARG=[]
循环结束后 OPTIND = 4
```

这个例子这里就不解释`OPTIND`的变化,留作练习.

> 提示:解析到参数`$1`中的`a`时,发现`a`在optstring中有定义,`a`是`$1`的最后一个字母,要`OPTIND`+1,并且optstring中的`a`跟随`:`,需要对`OPTIND`+1,使得`OPTIND=3`

### getopts和shift命令

截止目前,我们已经讨论了getopts的核心功能和工作机制.但这不是全部.

**手动解析**和 **`getopts`** 在处理参数时，对 `shift` 命令的依赖程度和使用逻辑有显著区别。

手动解析的典型做法是借助`shift`移动命令行的参数,每解析一个选项都要关注对shift的调用.

而`getopts` 是 Bash 内置的解析器。它不需要你手动移动参数队列，因为它内部维护了一个指针变量 `$OPTIND`。

在 `getopts` 的 `while` 循环内部，**绝对不要使用 `shift`**。`getopts` 会自动递增 `$OPTIND` 来读取下一个参数。

`shift` 仅在 `getopts` 循环**结束后**使用一次，用来移除所有已解析的选项，留下剩下的“非选项”参数（位置参数）。

在前面的讨论中,我们知道在退出`while getopts optstring ...`循环的时候,有两种情况:

- 用户传递的命令行参数已经全部解析完毕.
- 用户传递了不符合预期或非法的参数导致解析失败而退出循环.

无论是哪种情况,`OPTIND`都表示下一个待处理的参数到索引,换句话说,`OPTIND-1`表示最后一个处理好的参数索引(无论是不是选项.)

循环结束后，一次性切掉所有已处理的选项的命令语句如下:

```bash
shift $((OPTIND - 1))
```

> 注意不是`shift OPTIND-1`,需要用`$(())`来计算`OPTIND-1`

### getopts典型用例和静默错误处理



本例演示在静默模式下,错误处理的标准做法:

- 将错误信息的打印通过`>&2`重定向到标准错误
- 在静默模式下
  - 选项无效时,`opt`(name)会被设置为`?`,`OPTARG`保存当前未被正确处理的选项名,因此可以针对此做检查,当发现`opt=?`,(在case中需要转义写成`\?`)那么提示当前选项(`OPTARG`是无效的(不可识别/未定义的))
  - 选项参数缺失的情况下,`opt`(name)变量会被设置为`:`(不是`?`,以表示解析的选项是合法互有定义的,但是该选项需要参数,缺失了)同上,`OPTARG`保存当前未被正确处理的选项名,因此可以针对此做检查,当发现`opt=:`那么提示当前选项(`OPTARG`缺失必要参数.)

```bash
# h 不需要参数，f 需要一个参数
while getopts ":hf:" opt; do
  case $opt in
    h)
      echo "显示帮助"
      ;;
    f)
      echo "文件参数值: $OPTARG"
      ;;
    \?)
      echo "无效的选项: -$OPTARG" >&2
      ;;
    :)
      echo "选项 -$OPTARG 需要一个参数" >&2
      ;;
  esac
done

# 处理完选项后，移除它们，保留剩余的普通参数
shift $((OPTIND-1))
```



以下是一个 `getopts` 示例：

```bash
#!/bin/sh

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [-f OUTFILE] [FILE]...
Do stuff with FILE and write the result to standard output. With no FILE
or when FILE is -, read standard input.

    -h          display this help and exit
    -f OUTFILE  write the result to OUTFILE instead of standard output.
    -v          verbose mode. Can be used multiple times for increased
                verbosity.
EOF
}

# Initialize our own variables:
output_file=""
verbose=0

OPTIND=1
# Resetting OPTIND is necessary if getopts was used previously in the script.
# It is a good idea to make OPTIND local if you process options in a function.

while getopts hvf: opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        v)  verbose=$((verbose+1))
            ;;
        f)  output_file=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"   # Discard the options and sentinel --

# Everything that's left in "$@" is a non-option.  In our case, a FILE to process.
printf 'verbose=<%d>\noutput_file=<%s>\nLeftovers:\n' "$verbose" "$output_file"
printf '<%s>\n' "$@"

# End of file
```



## 总结getopts

getopts 有**两种错误报告方式**（error reporting）：

如果 `OPTSTRING` 的第一个字符是冒号（`:`），`getopts` 将使用**静默错误报告**（silent error reporting）。在这种模式下，不会打印任何错误信息。

- 如果遇到**无效选项**（invalid option），`getopts` 会把**发现的选项字符放入 `OPTARG`**。
- 如果**找不到必需的参数**（required argument），`getopts` 会把冒号 `:` 放入 `NAME` 变量中，并把发现的选项字符放入 `OPTARG`。

如果 getopts 不在静默模式下：

- 当遇到无效选项时，`getopts` 会把 `?` 放入 `NAME` 中，并取消设置 `OPTARG`（置空 OPTARG）。
- 当找不到必需的参数时，`NAME` 中会放入 `?`，`OPTARG` 会被取消设置，同时会打印一条诊断信息（diagnostic message）。

### getopts的优点

使用`getopts`来设计脚本的命令行参数,有如下优点.

- `getopts` 的**主要优点是允许单字母选项拆分**,而无需做额外的处理（使得 `-xvf` 的处理方式与 `-x -v -f` 相同）。

- 相较于外部命令行解析程序`getopt`而言,有如下优点
  - 无需将位置参数传递给外部程序
  - 作为内置函数， `getopts` 可以设置用于解析的 shell 变量（ *外部*进程无法做到这一点！）

`getopts` 相对于手动循环的优势：

1. 它确保选项像任何标准命令一样被解析（最低公分母），避免出现意外情况。
2. 在某些实现方式中，错误消息将**以用户的语言进行本地化**。

### `getopts` 的缺点

1. （除了 ksh93）它只能处理短选项（ `-h` ，而不是 `--help` ）。
2. 它无法处理带有可选参数的选项，例如 `mysql` 的 `-p[password]` 。
3. 它并不存在于Bourne shell中。
4. *它只*允许以“标准方式”（最低公分母）解析选项。
5. 选项至少在 2 个地方编码，可能在 3 个地方编码——在对 `getopts` 的调用中，在处理它们的 case 语句中，以及在记录它们的帮助/用法消息中。

> 关于第一个缺点,更准确的说是**不能方便地解析长选项参数**（例如 GNU 风格的 `--foo` 或 Tcl/XF86/powershell风格的 `-foo` ）
>
> bash手册中也没有写死说`getopts`不能用于长选项解析.
>
> 只是bash内置的 `getopts` 不原生支持这些风格,需要额外的处理才能借此长选项,同时还会影响段选项连写的解析。预期费劲让getopts支持长选项,倒不如让getopts保持简单并且支持短选项连写.
>
> 总之,在不脱离bash的情况下设计长选项 ，**优先考虑手动循环解析**。

有关其他更复杂的选项解析方法，请参阅 [ComplexOptionParsing](https://mywiki.wooledge.org/ComplexOptionParsing) 。