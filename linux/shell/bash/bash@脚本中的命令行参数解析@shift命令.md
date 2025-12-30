[toc]



## bash脚本中处理命令行选项和参数

这很大程度上取决于你想用它们做什么。通常有两种方法，各有优缺点。

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

## 选项处理循环的两种方案

编写**选项处理循环**有两种基本方法：一种是**从头开始编写循环**（我们称之为“**手动循环**”(Manual loop )），另一种是使用 shell 的 `getopts` 命令来辅助选项拆分。第一种更加灵活和强大.

我们将介绍这两种方法。

> 这里讨论的是`getopts`,而不是`getopt`,两者不同.
>
> **请勿使用 getopt(1)。本页不讨论 getopt。** 请前往 [ComplexOptionParsing](https://mywiki.wooledge.org/ComplexOptionParsing) 了解更多信息。



### Manual loop

手动解析选项是**最灵活的方法**。实际上，它也是*最佳*方法，因为它允许你做任何你想做的事情：你可以处理**单字母选项和长选项**，也可以处理**带或不带选项参数的选项**。这就是我们首先介绍它的原因。

> 如果你想处理 `GNU` 风格的 `--long-options` 或 Tcl 风格的 `-longopts` ，**手动循环是你的唯一选择**。 `getopts` 不支持这些风格。

在这个例子中，请注意 `--file FILE` 和 `--file=FILE` 是如何处理的。(空格和`=`分隔选项和参数的两种风格)

```bash
#!/bin/sh
# POSIX

die() {
    printf '%s\n' "$1" >&2
    exit 1
}
#初始化可能要用到的选项变量,防止环境中已有的同名变量对其产生干扰
# Initialize all the option variables.
# This ensures we are not contaminated by variables from the environment.
file=
verbose=0
# 编写选项处理的循环:手动循环
while :; do
    case $1 in
        -h|-\?|--help)
            show_help    # Display a usage synopsis.
            exit
            ;;
        -f|--file)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                file=$2
                shift
            else
                die 'ERROR: "--file" requires a non-empty option argument.'
            fi
            ;;
        --file=?*)
            file=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --file=)         # Handle the case of an empty --file=
            die 'ERROR: "--file" requires a non-empty option argument.'
            ;;
        -v|--verbose)
            verbose=$((verbose + 1))  # Each -v adds 1 to verbosity.
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

# if --file was provided, open it for writing, else duplicate stdout
if [ "$file" ]; then
    exec 3> "$file"
else
    exec 3>&1
fi

# Rest of the program here.
# If there are input files (for example) that follow the options, they
# will remain in the "$@" positional parameters.
```



此例中的选项**解析器**无法处理**连接在一起的单字母选项**（例如将 `-xvf` 解析为 `-x -v -f` ）尽管这不是必须支持的功能

> 我们可以通过一些努力添加此功能，但这里留给读者作为练习。

实际上，**处理长选项**的 shell 脚本**很少会同时处理单字母选项拆分**。这样做并不值得。

大多数情况下，你编写的 shell 脚本无需担心单字母选项拆分，因为只有你自己会用到它们。**只有当你打算将程序公开发布时，才需要进行复杂的选项处理，而这种情况在实际应用中几乎*不会*发生**。

此外，支持**单字母选项合并**的选项风格还会阻止使用 **Tcl 风格的长参数**（例如 `-foo` ），而某些命令（如 [find(1)](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/find.html) 、 [gcc(1)](https://linux.die.net/man/1/gcc) 和 [star(1)）](https://linux.die.net/man/1/star) 会使用这种参数。

> 两种风格的冲突是显然的,如果同时支持,那么`-foo`就还可能被解释为`-f -o -o`,除非做更加复杂的处理
>
> > **Tcl**（读作 “**tickle**”，全称 **Tool Command Language**）是一种**轻量级、解释型的脚本语言**



### getopts



`getopts` 的**主要优点是允许单字母选项拆分**（ `-xvf` 的处理方式与 `-x -v -f` 相同）。

但缺点是**不能使用任何类型的长参数**（例如 GNU 风格的 `--foo` 或 Tcl 风格的 `-foo` ），也**不能使用带有可选参数的选项**（例如 `mysql` 的 `-p[password]` 选项）。

`getopts` 适用于**简单的脚本**。选项解析需求越复杂，就越不可能使用 `getopts` 。

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



[getopts 有一个教程 ](https://web.archive.org/web/20230324055145/https://wiki.bash-hackers.org/howto/getopts_tutorial)，解释了所有语法和变量的含义。在 bash 中，还有 `help getopts` 。

### 对比两种方式

`getopts` 相对于手动循环的优势：

1. 它可以按照 Unix 的预期方式自动处理诸如 `-xvf filename` 之类的东西。
2. 它确保选项像任何标准命令一样被解析（最低公分母），避免出现意外情况。
3. 在某些实现方式中，错误消息将**以用户的语言进行本地化**。

`getopts` 的缺点：

1. （除了 ksh93）它只能处理短选项（ `-h` ，而不是 `--help` ）。
2. 它无法处理带有可选参数的选项，例如 `mysql` 的 `-p[password]` 。
3. 它并不存在于bash shell中。
4. *它只*允许以“标准方式”（最低公分母）解析选项。
5. 选项至少在 2 个地方编码，可能在 3 个地方编码——在对 `getopts` 的调用中，在处理它们的 case 语句中，以及在记录它们的帮助/用法消息中。

有关其他更复杂的选项解析方法，请参阅 [ComplexOptionParsing](https://mywiki.wooledge.org/ComplexOptionParsing) 。