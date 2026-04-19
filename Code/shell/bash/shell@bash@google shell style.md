[toc]





# Shell 样式指南

[google shell style(bash) 风格指南](https://google.github.io/styleguide/)

由多位谷歌员工撰写、修订和维护。

## 使用bash脚本

可执行文件必须以 `#!/bin/bash` 开头，并包含最少的标志。使用 `set` 来设置 shell 选项，这样即使以 `bash script_name` 形式调用脚本，也不会破坏其功能。

将所有可执行 shell 脚本限制为 *bash* ，可以确保所有机器上都安装一致的 shell 语言。尤其重要的是，这意味着我们通常无需追求 POSIX 兼容性或避免其他“bash 特有的行为”。

上述情况的唯一例外是，当你的代码目标环境迫使你这样做时。例如，某些旧版操作系统或受限的执行环境可能要求某些脚本使用纯 Bourne shell。



### 何时使用 Shell

Shell 应该只用于小型实用程序或简单的包装脚本。

虽然 shell 脚本并非开发语言，但它被广泛用于 Google 内部的各种实用脚本编写。本风格指南更多的是对其用途的认可，而非建议将其广泛部署。

一些指导原则：

- 如果你主要调用其他实用程序，并且很少进行数据操作，那么 shell 是完成这项任务的可接受的选择。
- 如果性能很重要，请使用 shell 以外的其他工具。
- **如果你编写的脚本超过 100 行，或者使用了复杂的控制流逻辑， *那么现在*就应该用更结构化的语言重写它。记住，脚本会不断增长。尽早重写脚本，可以避免日后耗费更多时间进行重写**。
- 在评估代码的复杂性时（例如，决定是否切换语言），请考虑代码是否易于由其作者以外的人维护。



## Shell 文件和解释器调用



### 文件扩展名

可执行文件要么带有 `.sh` 扩展名，要么不带扩展名。

- 如果可执行文件将包含一个用于重命名源文件的构建规则，则最好使用 `.sh` 扩展名。这样，您就可以使用推荐的命名约定，例如源文件为 `foo.sh` ，构建规则名为 `foo` 。
- 如果可执行文件将直接添加到用户的 `PATH` 中，则最好不要使用文件扩展名。执行程序时无需知道程序是用什么语言编写的，而且 shell 也不要求文件扩展名，因此对于用户直接调用的可执行文件，我们建议不要使用扩展名。同时，也要考虑部署构建规则的输出是否比直接部署源文件更合适。
- 如果以上两种情况都不适用，那么两种选择都可以接受。

库文件必须具有 `.sh` 扩展名，并且不应是可执行文件。



### SUID/SGID

shell 脚本中*禁止使用* SUID 和 SGID。

shell 存在太多安全问题，几乎不可能做到足够安全以允许使用 SUID/SGID。虽然 bash 确实增加了运行 SUID 的难度，但在某些平台上仍然可行，因此我们明确禁止使用 shell。

如果需要提升访问权限，请使用 `sudo` 。



## 环境



### 标准输出与标准错误

所有错误信息都应该输出到 `STDERR` 。

这样更容易将正常状态与实际问题区分开来。

建议添加一个能够打印错误信息以及其他状态信息的功能。

```bash
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

if ! do_something; then
  err "Unable to do_something"
  exit 1
fi
```



## 注释🎈



### 文件头

每个文件开头都要附上内容描述。

每个文件都必须包含顶级注释，简要概述其内容。版权声明和作者信息为可选内容。

例子：

```bash
#!/bin/bash
#
# Perform hot backups of Oracle databases.
```



### 函数注释

任何不够简洁明了的函数都必须添加函数头注释。

库中的任何函数，无论其长度或复杂程度如何，都必须添加函数头注释。

其他人应该能够通过阅读注释（以及提供的自助帮助）而无需阅读代码，就能学会如何使用你的程序或你的库中的函数。

所有函数头注释都应使用以下方式描述预期的 API 行为：

1. 功能描述。
2. 全局变量：已使用和已修改的全局变量列表。
3. 参数: 函数接收的参数说明。
4. 输出：输出到 STDOUT 或 STDERR。
5. 返回值：除上次命令运行的默认退出状态之外的返回值。

例子：

```bash
#######################################
# Cleanup files from the backup directory.
# Globals:
#   BACKUP_DIR
#   ORACLE_SID
# Arguments:
#   None
#######################################
function cleanup() {
  …
}

#######################################
# Get configuration directory.
# Globals:
#   SOMEDIR
# Arguments:
#   None
# Outputs:
#   Writes location to stdout
#######################################
function get_dir() {
  echo "${SOMEDIR}"
}

#######################################
# Delete a file in a sophisticated manner.
# Arguments:
#   File to delete, a path.
# Returns:
#   0 if thing was deleted, non-zero on error.
#######################################
function del_thing() {
  rm "$1"
}
```



### 实施说明

对代码中那些棘手、不明显、有趣或重要的部分进行注释。

这遵循谷歌代码注释的一般规范。不要什么都注释。如果遇到复杂的算法或者你做了一些非常规的操作，那就添加简短的注释。



### 待办事项 注释

对于临时代码、短期解决方案或足够好但不完美的代码，请使用 TODO 注释。

这与 [C++ 指南](https://google.github.io/styleguide/cppguide.html#TODO_Comments)中的约定一致。

`TODO` 应包含全部大写的字符串 `TODO` ，后跟最了解 `TODO` 所指问题的人员的姓名、电子邮件地址或其他标识符。主要目的是保持一致性。 `TODO` ：可通过搜索了解如何根据要求获取更多详细信息。 `TODO` 并不代表被提及的人一定会解决问题。因此，创建 `TODO` 时，几乎总是会写上你的名字。

例如：

```bash
# TODO(mrmonkey): Handle the unlikely edge cases (bug ####)
```



## 格式化

对于正在修改的文件，您应该遵循已有的样式；但对于任何新代码，以下是必需的。



### 缩进

缩进 2 个空格，不要使用制表符。

为了提高可读性，请在代码块之间使用空行。缩进为两个空格。切勿使用制表符。对于现有文件，请保持原有的缩进格式。

**例外：** 使用制表符的唯一例外情况是 `<<-` 的正文。 制表符缩进 [here-doc ](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Here-Documents)。



### 行长和长字符串(Line Length and Long Strings)

行长度上限为 80 个字符。

如果你需要编写长度超过 80 个字符的字符串字面量，那么…… 应该用……来完成 [here-doc](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Here-Documents) 如果可以的话，最好是嵌入换行符。

长度超过 80 个字符且无法合理拆分的单词是可以接受的，但应尽可能将它们单独放在一行，或将其放入变量中。例如文件路径和 URL，尤其是在使用字符串匹配（例如 `grep` ）进行维护时非常有用的情况下。

```bash
# DO use 'here document's
cat <<END
I am an exceptionally long
string.
END

# Embedded newlines are ok too
long_string="I am an exceptionally
long string."

long_file="/i/am/an/exceptionally/loooooooooooooooooooooooooooooooooooooooooooooooooooong_file"

long_string_with_long_file="i am including an exceptionally \
/very/long/file\
 in this long string."

# Long file converted into a shorter variable name with cleaner line breaking.
long_string_alt="i am an including an exceptionally ${long_file} in this long\
 string"
# Just because a line contains an exception doesn't mean the rest of the
# line shouldn't be wrapped like usual.

bad_long_string_with_long_file="i am including an exceptionally /very/long/file in this long string."
```



### 管道

如果管道不能全部放在一条线上，则应将管道分成几条，每条管道放在一条线上。

如果管道的所有部件都能放在一行上，那就应该放在一行上。

否则，应将文本分割成每行一个竖线段，竖线段位于新行，下一段竖线段缩进 2 个空格。应始终使用 `\` 来表示行的延续。这适用于使用 `|` 组合的命令链，以及使用 `||` 和 `&&` 逻辑复合。

```bash
# All fits on one line
command1 | command2

# Long commands
command1 \
  | command2 \
  | command3 \
  | command4
```

这有助于区分管道和常规长命令延续，尤其是在该行同时使用两者的情况下，从而提高可读性。

注释需要位于整个流程之前。如果注释和流程都很庞大且复杂，那么可以考虑使用辅助函数将它们的底层细节放在一边。





### 控制流

将 `; then` 和 `; do` 与 `if` 、 `for` 或 `while` 放在同一行。

shell 中的控制流语句略有不同，但声明函数时遵循与使用花括号相同的原则。也就是说： `; then` 和 `; do` 应该与 `if` / `for` / `while` / `until` / `select` 语句在同一行。 `else` 应该单独占一行，结束语句（ `fi` 和 `done` ）应该单独占一行，与开头语句垂直对齐。

例子：

```bash
# If inside a function remember to declare the loop variable as
# a local to avoid it leaking into the global environment:
local dir
for dir in "${dirs_to_cleanup[@]}"; do
  if [[ -d "${dir}/${SESSION_ID}" ]]; then
    log_date "Cleaning up old files in ${dir}/${SESSION_ID}"
    rm "${dir}/${SESSION_ID}/"* || error_message
  else
    mkdir -p "${dir}/${SESSION_ID}" || error_message
  fi
done
```

虽然有可能 [`in "$@"`](https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html#index-for) 为了清晰起见，我们建议在 for 循环中始终包含它。

```bash
for arg in "$@"; do
  echo "argument: ${arg}"
done
```



### 案例陈述

- 将备选方案缩进 2 个空格。
- 单行替代方案需要在模式的右括号后和分号 `;;` 前留一个空格。
- 较长的命令或多命令选项应分成多行，模式、操作和分号 `;;` 分别放在不同的行上。

匹配表达式比 `case` 和 `esac` 缩进一级。多行操作比 case 和 esac 缩进一级。通常情况下，匹配表达式无需加引号。模式表达式前面不应加左括号。避免使用 `;&` 和 `;;&` 符号。

```bash
case "${expression}" in
  a)
    variable="…"
    some_command "${variable}" "${other_expr}" …
    ;;
  absolute)
    actions="relative"
    another_command "${actions}" "${other_expr}" …
    ;;
  *)
    error "Unexpected expression '${expression}'"
    ;;
esac
```

简单的命令可以与模式*和*分号 `;;` 放在同一行，只要表达式仍然可读即可。这通常适用于单字母选项的处理。当操作无法在一行内显示时，将模式单独放在一行，然后是操作，最后分号 `;;` 也单独放在一行。如果与操作在同一行，请在模式的右括号后加一个空格，并在分号 `;;` ) 前加一个空格。

```bash
verbose='false'
aflag=''
bflag=''
files=''
while getopts 'abf:v' flag; do
  case "${flag}" in
    a) aflag='true' ;;
    b) bflag='true' ;;
    f) files="${OPTARG}" ;;
    v) verbose='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done
```



### 变量扩展

按优先级顺序：保持结果一致；引用变量；优先使用 `"${var}"` 而不是 `"$var"` 。

这些是强烈建议遵循的指导原则，但并非强制性规定。尽管如此，建议而非强制性规定并不意味着可以轻视或忽视它们。

它们按优先级顺序排列。

- 与你找到的现有代码保持一致。
- 引用变量，请参见[下面的“引用”部分 ](https://google.github.io/styleguide/shellguide.html#quoting)。
- 除非绝对必要或避免造成严重混淆，否则不要用花括号分隔单个字符的 shell 特殊字符/位置参数。

建议用花括号分隔所有其他变量。

```bash
# Section of *recommended* cases.

# Preferred style for 'special' variables:
echo "Positional: $1" "$5" "$3"
echo "Specials: !=$!, -=$-, _=$_. ?=$?, #=$# *=$* @=$@ \$=$$ …"

# Braces necessary:
echo "many parameters: ${10}"

# Braces avoiding confusion:
# Output is "a0b0c0"
set -- a b c
echo "${1}0${2}0${3}0"

# Preferred style for other variables:
echo "PATH=${PATH}, PWD=${PWD}, mine=${some_var}"
while read -r f; do
  echo "file=${f}"
done < <(find /tmp)
# Section of *discouraged* cases

# Unquoted vars, unbraced vars, brace-delimited single letter
# shell specials.
echo a=$avar "b=$bvar" "PID=${$}" "${1}"

# Confusing use: this is expanded as "${1}0${2}0${3}0",
# not "${10}${20}${30}
set -- a b c
echo "$10$20$30"
```

注意：在 `${var}` 中使用花括号*并不*等同于引用。必须*同时*使用双引号。



### 引用

- 除非需要仔细地进行未加引号的扩展，或者它是 shell 内部整数（见下一点），否则始终要引用包含变量、命令替换、空格或 shell 元字符的字符串。
- 使用数组可以安全地引用元素列表，尤其是命令行标志。请参阅下文 [“数组”部分 ](https://google.github.io/styleguide/shellguide.html#arrays)。
- （可选）引用 shell 内部只读 [特殊变量](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html) 定义为整数的变量： `$?` 、 `$#` 、 `$$` 、 `$!` 为了保持一致性，建议对“命名”的内部整数变量（例如 PPID 等）使用引号。
- 最好对“单词”字符串（而不是命令选项或路径名称）进行引用。
- 请注意 `[[ … ]]` 中模式匹配的引用规则。参见 [测试、 `[ … \]` 和 `[[ … ]]`](https://google.github.io/styleguide/shellguide.html#tests) 部分如下。
- 除非有特殊原因需要使用 `$*` ，例如只是将参数附加到消息或日志中的字符串，否则请使用 `"$@"` 。

```bash
# 'Single' quotes indicate that no substitution is desired.
# "Double" quotes indicate that substitution is required/tolerated.

# Simple examples

# "quote command substitutions"
# Note that quotes nested inside "$()" don't need escaping.
flag="$(some_command and its args "$@" 'quoted separately')"

# "quote variables"
echo "${flag}"

# Use arrays with quoted expansion for lists.
declare -a FLAGS
FLAGS=( --foo --bar='baz' )
readonly FLAGS
mybinary "${FLAGS[@]}"

# It's ok to not quote internal integer variables.
if (( $# > 3 )); then
  echo "ppid=${PPID}"
fi

# "never quote literal integers"
value=32
# "quote command substitutions", even when you expect integers
number="$(generate_number)"

# "prefer quoting words", not compulsory
readonly USE_INTEGER='true'

# "quote shell meta characters"
echo 'Hello stranger, and well met. Earn lots of $$$'
echo "Process $$: Done making \$\$\$."

# "command options or path names"
# ($1 is assumed to contain a value here)
grep -li Hugo /dev/null "$1"

# Less simple examples
# "quote variables, unless proven false": ccs might be empty
git send-email --to "${reviewers}" ${ccs:+"--cc" "${ccs}"}

# Positional parameter precautions: $1 might be unset
# Single quotes leave regex as-is.
grep -cP '([Ss]pecial|\|?characters*)$' ${1:+"$1"}

# For passing on arguments,
# "$@" is right almost every time, and
# $* is wrong almost every time:
#
# * $* and $@ will split on spaces, clobbering up arguments
#   that contain spaces and dropping empty strings;
# * "$@" will retain arguments as-is, so no args
#   provided will result in no args being passed on;
#   This is in most cases what you want to use for passing
#   on arguments.
# * "$*" expands to one argument, with all args joined
#   by (usually) spaces,
#   so no args provided will result in one empty string
#   being passed on.
#
# Consult
# https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html and
# https://mywiki.wooledge.org/BashGuide/Arrays for more

(set -- 1 "2 two" "3 three tres"; echo $#; set -- "$*"; echo "$#, $@")
(set -- 1 "2 two" "3 three tres"; echo $#; set -- "$@"; echo "$#, $@")
```



## 功能和缺陷



### ShellCheck

[ShellCheck 项目](https://www.shellcheck.net/)可以识别 shell 脚本中的常见错误和警告。建议所有脚本，无论大小，都使用它。



### 命令替代

请使用 `$(command)` 代替反引号。

嵌套的反引号需要用 `\` 转义内部的反引号。 `$(command)` 格式在嵌套时不会改变，而且更易于阅读。

例子：

```bash
# This is preferred:
var="$(command "$(command1)")"
# This is not:
var="`command \`command1\``"
```





### 测试， `[ … ]` ，以及 `[[ … ]]`

`[[ … ]]` 优于 `[ … ]` 、 `test` 和 `/usr/bin/[` 。

`[[ … ]]` 减少了错误，因为 `[[` 和 `]]` 之间不会进行路径名扩展或单词分割。此外， `[[ … ]]` 支持模式和正则表达式匹配，而 `[ … ]` 则不支持。

```bash
# This ensures the string on the left is made up of characters in
# the alnum character class followed by the string name.
# Note that the RHS should not be quoted here.
if [[ "filename" =~ ^[[:alnum:]]+name ]]; then
  echo "Match"
fi

# This matches the exact pattern "f*" (Does not match in this case)
if [[ "filename" == "f*" ]]; then
  echo "Match"
fi
# This gives a "too many arguments" error as f* is expanded to the
# contents of the current directory. It might also trigger the
# "unexpected operator" error because `[` does not support `==`, only `=`.
if [ "filename" == f* ]; then
  echo "Match"
fi
```

详细内容请参见 [Bash FAQ](http://tiswww.case.edu/php/chet/bash/FAQ) 中的 E14。



### 测试字符串

尽量使用引号而不是填充字符。

Bash 足够智能，能够处理测试中的空字符串。因此，考虑到代码更易于阅读，请使用空字符串/非空字符串或空字符串的测试，而不是填充字符的测试。

```bash
# Do this:
if [[ "${my_var}" == "some_string" ]]; then
  do_something
fi

# -z (string length is zero) and -n (string length is not zero) are
# preferred over testing for an empty string
if [[ -z "${my_var}" ]]; then
  do_something
fi

# This is OK (ensure quotes on the empty side), but not preferred:
if [[ "${my_var}" == "" ]]; then
  do_something
fi
# Not this:
if [[ "${my_var}X" == "some_stringX" ]]; then
  do_something
fi
```

为了避免对测试内容产生混淆，请明确使用 `-z` 或 `-n` 。

```bash
# Use this
if [[ -n "${my_var}" ]]; then
  do_something
fi
# Instead of this
if [[ "${my_var}" ]]; then
  do_something
fi
```

为了清晰起见，相等表示应使用 `==` 而不是 。 `=` 两者都有效。前者鼓励使用…… `[[` 后者容易与赋值混淆。但是，使用 `<` 和 `>` 时要小心。 `[[ … ]]` 用于执行字典序比较。使用 `(( … ))` 或 `-lt` 和 `-gt` 进行数值比较。

```bash
# Use this
if [[ "${my_var}" == "val" ]]; then
  do_something
fi

if (( my_var > 3 )); then
  do_something
fi

if [[ "${my_var}" -gt 3 ]]; then
  do_something
fi
# Instead of this
if [[ "${my_var}" = "val" ]]; then
  do_something
fi

# Probably unintended lexicographical comparison.
if [[ "${my_var}" > 3 ]]; then
  # True for 4, false for 22.
  do_something
fi
```



### 文件名通配符扩展

使用通配符扩展文件名时，请使用明确的路径。

由于文件名可能以 `-` 开头，因此使用 `./*` 而不是 `*` 来展开通配符要安全得多。

```bash
# Here's the contents of the directory:
# -f  -r  somedir  somefile

# Incorrectly deletes almost everything in the directory by force
psa@bilby$ rm -v *
removed directory: `somedir'
removed `somefile'
# As opposed to:
psa@bilby$ rm -v ./*
removed `./-f'
removed `./-r'
rm: cannot remove `./somedir': Is a directory
removed `./somefile'
```



### 评估

应避免进行 `eval` 。

Eval 在用于赋值给变量时会篡改输入，并且可以设置变量而不检查这些变量是什么。

```bash
# What does this set?
# Did it succeed? In part or whole?
eval $(set_my_variables)

# What happens if one of the returned values has a space in it?
variable="$(eval some_function)"
```



### 数组

Bash 数组应该用于存储元素列表，以避免引用。 复杂性。这尤其适用于参数列表和数组。 不应用于简化更复杂的数据结构（参见 [何时使用上述 Shell](https://google.github.io/styleguide/shellguide.html#when-to-use-shell) ）。

数组存储有序的字符串集合，可以安全地展开为单个元素以用于命令或循环。

应避免使用单个字符串作为多个命令参数，因为这必然会导致作者使用 `eval` 或者尝试在字符串中嵌套引号，但这不会产生任何结果。 结果不可靠或难以理解，反而导致不必要的复杂性。

```bash
# An array is assigned using parentheses, and can be appended to
# with +=( … ).
declare -a flags
flags=(--foo --bar='baz')
flags+=(--greeting="Hello ${name}")
mybinary "${flags[@]}"
# Don’t use strings for sequences.
flags='--foo --bar=baz'
flags+=' --greeting="Hello world"'  # This won’t work as intended.
mybinary ${flags}
# Command expansions return single strings, not arrays. Avoid
# unquoted expansion in array assignments because it won’t
# work correctly if the command output contains special
# characters or whitespace.

# This expands the listing output into a string, then does special keyword
# expansion, and then whitespace splitting.  Only then is it turned into a
# list of words.  The ls command may also change behavior based on the user's
# active environment!
declare -a files=($(ls /directory))

# The get_arguments writes everything to STDOUT, but then goes through the
# same expansion process above before turning into a list of arguments.
mybinary $(get_arguments)
```



#### 数组专业人士

- 使用数组可以方便地列出事物，而不会造成引用语义上的混乱。相反，不使用数组则会导致在字符串中嵌套引用的错误尝试。
- 数组可以安全地存储任意字符串序列/列表，包括包含空格的字符串。



#### 数组的缺点

使用数组可能会导致脚本复杂度增加。



#### 数组决策

应该使用数组来安全地创建和传递列表。 尤其是在构建一组命令参数时，请使用数组。 避免混淆引用问题。使用带引号的展开式—— `"${array[@]}"` – 用于访问数组。但是，如果需要更高级的数据操作，则应完全避免使用 shell 脚本；请参见[上文 ](https://google.github.io/styleguide/shellguide.html#when-to-use-shell)。



### 管道到

建议使用进程替换或内置的 `readarray` 函数（bash4+），而不是使用管道传递给 `while` 。管道会创建一个子 shell，因此在管道中修改的任何变量都不会传递到父 shell。

`while` 循环中隐式子 shell 可能会引入难以追踪的细微错误。

```bash
last_line='NULL'
your_command | while read -r line; do
  if [[ -n "${line}" ]]; then
    last_line="${line}"
  fi
done

# This will always output 'NULL'!
echo "${last_line}"
```

使用进程替换也会创建一个子 shell。但是，它允许从子 shell 重定向到 `while` 而无需将 `while` （或任何其他命令）放在子 shell 中。

```bash
last_line='NULL'
while read line; do
  if [[ -n "${line}" ]]; then
    last_line="${line}"
  fi
done < <(your_command)

# This will output the last non-empty line from your_command
echo "${last_line}"
```

或者，可以使用内置函数 `readarray` 将文件读取到数组中，然后遍历数组的内容。请注意（原因与上述相同），使用 `readarray` 时需要进行进程替换，而不是使用管道，但这样做的好处是循环的输入生成位于循环之前，而不是之后。

```bash
last_line='NULL'
readarray -t lines < <(your_command)
for line in "${lines[@]}"; do
  if [[ -n "${line}" ]]; then
    last_line="${line}"
  fi
done
echo "${last_line}"
```

> 注意：使用 for 循环遍历输出时要谨慎，例如 `for var in $(...)` ，因为输出是按空格分割的，而不是按行分割。有时，由于输出不会包含任何意外的空格，所以可以确定这样做是安全的。但如果情况并非如此，或者这样做并不能提高代码的可读性（例如， `$(...)` ` 中包含一个很长的命令），那么使用 ` `while read` 循环或 `readarray` 通常更安全、更清晰。



### 算术

始终使用 `(( … ))` 或 `$(( … ))` 而不是 `let` 或 `$[ … ]` 或 `expr` 。

永远不要使用 `$[ … ]` 语法， `expr` 命令，或者使用 `let` 内置命令。

`<` 和 `>` 在 `[[ … ]]` 表达式中不执行数值比较（而是执行字典序比较；参见 [“测试字符串 ](https://google.github.io/styleguide/shellguide.html#testing-strings)”）。建议不要在数值比较中使用 `[[ … ]]` ， *而应使用其他方法* 。 `(( … ))` 反而。

建议避免单独使用 `(( … ))` ，否则需警惕其表达式的计算结果为零。

- 尤其是在启用了 `set -e` 的情况下。例如： `set -e; i=0; (( i++ ))` 将导致 shell 退出。

```bash
# Simple calculation used as text - note the use of $(( … )) within
# a string.
echo "$(( 2 + 2 )) is 4"

# When performing arithmetic comparisons for testing
if (( a < b )); then
  …
fi

# Some calculation assigned to a variable.
(( i = 10 * j + 400 ))
# This form is non-portable and deprecated
i=$[2 * 10]

# Despite appearances, 'let' isn't one of the declarative keywords,
# so unquoted assignments are subject to globbing wordsplitting.
# For the sake of simplicity, avoid 'let' and use (( … ))
let i="2 + 2"

# The expr utility is an external program and not a shell builtin.
i=$( expr 4 + 4 )

# Quoting can be error prone when using expr too.
i=$( expr 4 '*' 4 )
```

撇开风格上的考虑不谈，shell 的内置算术运算速度比 `expr` 快很多倍。

使用变量时， `${var}` （以及 `$var` ）形式在 `$(( … ))` 内不是必需的。shell 会自动查找 `var` ，省略后即可。 使用 `${…}` 可以使代码更简洁。这与之前关于始终使用大括号的规则略有矛盾，因此这只是一个建议。

```bash
# N.B.: Remember to declare your variables as integers when
# possible, and to prefer local variables over globals.
local -i hundred="$(( 10 * 10 ))"
declare -i five="$(( 10 / 2 ))"

# Increment the variable "i" by three.
# Note that:
#  - We do not write ${i} or $i.
#  - We put a space after the (( and before the )).
(( i += 3 ))

# To decrement the variable "i" by five:
(( i -= 5 ))

# Do some complicated computations.
# Note that normal arithmetic operator precedence is observed.
hr=2
min=5
sec=30
echo "$(( hr * 3600 + min * 60 + sec ))" # prints 7530 as expected
```



## 别名

虽然别名在 `.bashrc` 文件中很常见，但在脚本中应该避免使用别名。 作为 [Bash 手册](https://www.gnu.org/software/bash/manual/html_node/Aliases.html) 笔记：

> 几乎在所有情况下，shell 函数都比别名更可取。

别名使用起来很麻烦，因为它们需要仔细引用和转义其内容，而且错误很难被发现。

```bash
# this evaluates $RANDOM once when the alias is defined,
# so the echo'ed string will be the same on each invocation
alias random_name="echo some_prefix_${RANDOM}"
```

函数提供了别名功能的超集，应该始终优先使用函数。

```bash
random_name() {
  echo "some_prefix_${RANDOM}"
}

# Note that unlike aliases function's arguments are accessed via $@
fancy_ls() {
  ls -lh "$@"
}
```



## 命名规则



### 函数名称

全部小写，单词之间用下划线分隔。使用 `::` 分隔不同的库。函数名后必须加括号。关键字 `function` 是可选的，但在整个项目中必须保持一致。

如果编写的是单个函数，请使用小写字母，并用下划线分隔单词。如果编写的是包，请使用 `::` ` 分隔包名。但是，用于交互式使用的函数最好避免使用冒号，因为它可能会干扰 Bash 的自动补全功能。

大括号必须与函数名在同一行（与 Google 的其他语言一样），并且函数名和括号之间不能有空格。

```bash
# Single function
my_func() {
  …
}

# Part of a package
mypackage::my_func() {
  …
}
```

当函数名后出现“()”时， `function` 关键字是多余的，但它有助于快速识别函数。



### 变量名

与函数名称相同。

循环中所有被循环遍历的变量名称应该保持一致。

```bash
for zone in "${zones[@]}"; do
  something_with "${zone}"
done
```



### 常量、环境变量和只读变量

常量和任何导出到环境的内容都应该大写，用下划线分隔，并在文件顶部声明。

```bash
# Constant
readonly PATH_TO_FILES='/some/path'

# Both constant and exported to the environment
declare -xr ORACLE_SID='PROD'
```

为了清晰起见，建议 `readonly` 或 `export` ，而不是等效模式。 `declare` 命令。您可以按顺序执行这些命令，例如：

```bash
# Constant
readonly PATH_TO_FILES='/some/path'
export PATH_TO_FILES
```

在运行时或条件语句中设置常量是可以的，但之后应该立即将其设为只读。

```bash
ZIP_VERSION="$(dpkg --status zip | sed -n 's/^Version: //p')"
if [[ -z "${ZIP_VERSION}" ]]; then
  ZIP_VERSION="$(pacman -Q --info zip | sed -n 's/^Version *: //p')"
fi
if [[ -z "${ZIP_VERSION}" ]]; then
  handle_error_and_quit
fi
readonly ZIP_VERSION
```



### 源文件名

全部小写，如果需要，可以用下划线分隔单词。

这是为了与谷歌其他代码风格保持一致： `maketemplate` 或 `make_template` 但不是 `make-template` 。



### 使用局部变量

使用 `local` 声明函数特定的变量。

通过在声明 `local` 变量时使用 `local`，确保局部变量仅在函数及其子函数内部可见。这样可以避免污染全局命名空间，并防止无意中设置可能在函数外部也起作用的变量。

当声明和转让必须是单独的声明时， 赋值是通过命令替换提供的；因为 `local` 内置函数不会传递命令替换的退出代码。

```bash
my_func2() {
  local name="$1"

  # Separate lines for declaration and assignment:
  local my_var
  my_var="$(my_func)"
  (( $? == 0 )) || return

  …
}
my_func2() {
  # DO NOT do this:
  # $? will always be zero, as it contains the exit code of 'local', not my_func
  local my_var="$(my_func)"
  (( $? == 0 )) || return

  …
}
```



### 功能位置

将所有函数放在常量下方的同一个文件中。不要将可执行代码隐藏在函数之间。这样做会使代码难以理解，并在调试时导致意想不到的麻烦。

如果定义了函数，请将它们全部放在文件顶部附近。只有包含语句、 `set` 语句和常量设置才能在声明函数之前进行。



### 主要的

对于长度足以包含至少一个其他函数的脚本来说，必须有一个名为 `main` 函数。

为了方便找到程序的起始位置，请将主程序放在一个名为 `main` 的函数中，并将其置于文件的最底层。这样可以与其余代码保持一致，并且允许您定义更多 `local` 变量（如果主程序不是一个函数，则无法做到这一点）。文件中最后一行非注释行应该是对 `main` 调用：

```bash
main "$@"
```

显然，对于情节线性发展的短剧本来说， `main` 过于复杂，因此不需要。



## 调用命令



### 检查返回值

务必检查返回值，并提供信息丰富的返回值。

对于未加管道的命令，请使用 `$?` 或直接通过 an 进行检查。 为了简单起见，可以使用 `if` 语句。

例子：

```bash
if ! mv "${file_list[@]}" "${dest_dir}/"; then
  echo "Unable to move ${file_list[*]} to ${dest_dir}" >&2
  exit 1
fi

# Or
mv "${file_list[@]}" "${dest_dir}/"
if (( $? != 0 )); then
  echo "Unable to move ${file_list[*]} to ${dest_dir}" >&2
  exit 1
fi
```

Bash 还提供了 `PIPESTATUS` 变量，允许检查管道所有部分的返回代码。如果只需要检查整个管道的成功或失败，那么以下写法是可以接受的：

```bash
tar -cf - ./* | ( cd "${dir}" && tar -xf - )
if (( PIPESTATUS[0] != 0 || PIPESTATUS[1] != 0 )); then
  echo "Unable to tar files to ${dir}" >&2
fi
```

但是，一旦您……， `PIPESTATUS` 就会被覆盖。 如果需要根据错误采取不同的操作，请执行任何其他命令 你需要确定事故发生在管道的哪个位置。 运行命令后立即将 `PIPESTATUS` 赋值给另一个变量（不要忘记 `[` 是一个命令，会清除 `PIPESTATUS` ）。

```bash
tar -cf - ./* | ( cd "${DIR}" && tar -xf - )
return_codes=( "${PIPESTATUS[@]}" )
if (( return_codes[0] != 0 )); then
  do_something
fi
if (( return_codes[1] != 0 )); then
  do_something_else
fi
```



### 内置命令与外部命令

如果要在调用 shell 内置命令和调用独立进程之间进行选择，请选择内置命令。

我们更倾向于使用内置函数，例如： [*参数扩展*](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html) `bash` 提供的功能更高效、更健壮、更便携（尤其与 `sed` 等工具相比）。另请参阅 [`=~` 运算符 ](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html#index-_005b_005b)。

例如：

```bash
# Prefer this:
addition="$(( X + Y ))"
substitution="${string/#foo/bar}"
if [[ "${string}" =~ foo:(\d+) ]]; then
  extraction="${BASH_REMATCH[1]}"
fi
# Instead of this:
addition="$(expr "${X}" + "${Y}")"
substitution="$(echo "${string}" | sed -e 's/^foo/bar/')"
extraction="$(echo "${string}" | sed -e 's/foo:\([0-9]\)/\1/')"
```



## 犹豫不决时：保持一致

在整个代码库中始终使用同一种风格，可以让我们专注于其他（更重要的）问题。一致性也有利于自动化。很多时候，那些被冠以“保持一致”之名的规则，实际上就是“随便选一个就行了，不用再操心了”；允许在这些方面保持灵活性所带来的潜在价值，远不及人们为此争论不休的成本。

然而，一致性也有其局限性。当没有明确的技术论据或长期发展方向时，一致性可以作为打破僵局的良好依据。但通常不应以一致性为由，在不考虑新风格的优势或代码库随着时间推移向新风格趋同的趋势的情况下，继续沿用旧风格。