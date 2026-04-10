[toc]



# grep 完全指南

grep 是 Unix/Linux 系统中最强大、最常用的文本搜索工具之一。它的名字来源于 ed 编辑器中的命令 `g/re/p`（global / regular expression / print），意为"全局正则表达式打印"。

------

## 第一章：基础概念

### 1.1 grep 是什么

grep 是一个命令行工具，用于在文件或输入流中搜索匹配特定模式的行。它逐行读取输入，检查每一行是否包含指定的模式，如果匹配则输出该行。这个看似简单的功能，配合正则表达式的强大能力，使 grep 成为文本处理的瑞士军刀。

### 1.2 grep 家族

现代系统中通常包含三个 grep 变体，它们在正则表达式语法上有所不同：

**grep** 使用基本正则表达式（BRE），这是默认模式。在 BRE 中，元字符如 `?`、`+`、`{}`、`|`、`()` 需要用反斜杠转义才能表示特殊含义，否则它们被视为普通字符。

**egrep** 等同于 `grep -E`，使用扩展正则表达式（ERE）。ERE 中上述元字符直接具有特殊含义，语法更接近现代编程语言中的正则表达式，书写更简洁。

**fgrep** 等同于 `grep -F`，使用固定字符串匹配。它不解释任何正则表达式语法，所有字符都被视为字面值。当搜索包含特殊字符的固定文本时，fgrep 更快且更安全。

### 1.3 基本语法

grep 的基本调用形式如下：

```bash
grep [选项] 模式 [文件...]
```

如果不指定文件，grep 从标准输入读取数据，这使它能够与管道配合使用。

------

## 第二章：基础用法

### 2.1 最简单的搜索

在文件中搜索包含特定单词的行：

```bash
grep "error" /var/log/syslog
```

这条命令会输出 syslog 文件中所有包含 "error" 的行。搜索是大小写敏感的，所以 "Error" 或 "ERROR" 不会被匹配。

### 2.2 忽略大小写

使用 `-i` 选项进行大小写不敏感的搜索：

```bash
grep -i "error" /var/log/syslog
```

现在 "error"、"Error"、"ERROR"、"eRrOr" 等所有大小写组合都会被匹配。

### 2.3 显示行号

使用 `-n` 选项在每行输出前显示行号：

```bash
grep -n "TODO" main.py
```

输出可能如下：

```
23:    # TODO: implement error handling
45:    # TODO: add unit tests
```

这在定位代码中的特定内容时非常有用。

### 2.4 统计匹配行数

使用 `-c` 选项只输出匹配的行数，而不是匹配的内容：

```bash
grep -c "import" *.py
```

这会显示每个 Python 文件中包含 "import" 的行数，帮助快速了解代码结构。

### 2.5 反向匹配

使用 `-v` 选项输出不匹配模式的行：

```bash
grep -v "^#" config.txt
```

这会输出所有不以 `#` 开头的行，常用于过滤掉配置文件中的注释。

### 2.6 多文件搜索

grep 可以同时搜索多个文件：

```bash
grep "function" *.js
```

搜索多文件时，输出会自动包含文件名前缀：

```
app.js:function init() {
utils.js:function formatDate(date) {
```

如果想在单文件搜索时也显示文件名，可以使用 `-H` 选项。相反，使用 `-h` 可以在多文件搜索时隐藏文件名。

### 2.7 递归搜索

使用 `-r` 或 `-R` 选项递归搜索目录中的所有文件：

```bash
grep -r "API_KEY" /path/to/project
```

这会搜索指定目录及其所有子目录中的文件。`-R` 与 `-r` 的区别在于 `-R` 会跟随符号链接，而 `-r` 不会。

### 2.8 只显示文件名

当只关心哪些文件包含匹配内容，而不关心具体内容时，使用 `-l` 选项：

```bash
grep -l "deprecated" *.py
```

这只输出包含匹配内容的文件名，每个文件名占一行。与之相反，`-L` 选项输出不包含匹配内容的文件名。

------

## 第三章：正则表达式

正则表达式是 grep 强大功能的核心。理解正则表达式是掌握 grep 的关键。

### 3.1 基本元字符

**点号（.）** 匹配任意单个字符（除了换行符）。例如 `h.t` 可以匹配 "hat"、"hot"、"hit" 等。

**星号（\*）** 匹配前面的元素零次或多次。例如 `ab*c` 匹配 "ac"、"abc"、"abbc"、"abbbc" 等。

**锚点** 用于指定位置。`^` 匹配行首，`$` 匹配行尾。例如 `^Hello` 只匹配以 "Hello" 开头的行，`world$` 只匹配以 "world" 结尾的行。

```bash
# 查找空行
grep "^$" file.txt

# 查找只包含数字的行
grep "^[0-9]*$" file.txt
```

### 3.2 字符类

字符类使用方括号定义，匹配其中的任意一个字符：

```bash
# 匹配 gray 或 grey
grep "gr[ae]y" file.txt

# 匹配任意小写字母
grep "[a-z]" file.txt

# 匹配任意数字
grep "[0-9]" file.txt

# 匹配任意非数字字符（^ 在方括号内表示取反）
grep "[^0-9]" file.txt
```

POSIX 字符类提供了更可读的预定义字符集：

| 字符类      | 含义       |
| ----------- | ---------- |
| `[:alpha:]` | 字母       |
| `[:digit:]` | 数字       |
| `[:alnum:]` | 字母和数字 |
| `[:space:]` | 空白字符   |
| `[:upper:]` | 大写字母   |
| `[:lower:]` | 小写字母   |
| `[:punct:]` | 标点符号   |

使用示例：

```bash
# 匹配以大写字母开头的行
grep "^[[:upper:]]" file.txt
```

### 3.3 扩展正则表达式

使用 `-E` 选项启用扩展正则表达式，可以使用更多元字符而无需转义：

**问号（?）** 匹配前面的元素零次或一次：

```bash
# 匹配 color 或 colour
grep -E "colou?r" file.txt
```

**加号（+）** 匹配前面的元素一次或多次：

```bash
# 匹配一个或多个数字
grep -E "[0-9]+" file.txt
```

**花括号（{}）** 指定精确的重复次数：

```bash
# 匹配恰好 3 个数字
grep -E "[0-9]{3}" file.txt

# 匹配 2 到 4 个数字
grep -E "[0-9]{2,4}" file.txt

# 匹配至少 2 个数字
grep -E "[0-9]{2,}" file.txt
```

**竖线（|）** 表示或的关系：

```bash
# 匹配 cat 或 dog
grep -E "cat|dog" file.txt

# 匹配 error 或 warning 或 critical
grep -E "error|warning|critical" /var/log/syslog
```

**分组（()）** 用于将多个元素组合在一起：

```bash
# 匹配重复的单词 the the
grep -E "(the) \1" file.txt

# 匹配 gray 或 grey（另一种写法）
grep -E "gr(a|e)y" file.txt
```

### 3.4 词边界

`\b` 匹配单词边界，这在避免部分匹配时非常有用：

```bash
# 只匹配独立的单词 "the"，不匹配 "there" 或 "other"
grep -E "\bthe\b" file.txt
```

也可以使用 `-w` 选项达到相同效果：

```bash
grep -w "the" file.txt
```

### 3.5 实际正则表达式示例

搜索 IP 地址的模式（简化版）：

```bash
grep -E "\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b" access.log
```

搜索电子邮件地址的模式（简化版）：

```bash
grep -E "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b" contacts.txt
```

搜索日期格式（YYYY-MM-DD）：

```bash
grep -E "\b[0-9]{4}-[0-9]{2}-[0-9]{2}\b" logs.txt
```

------

## 第四章：高级选项

### 4.1 上下文控制

有时候只看匹配行是不够的，需要查看其前后的上下文：

**-A（After）** 显示匹配行之后的若干行：

```bash
# 显示匹配行及其后 3 行
grep -A 3 "Exception" error.log
```

**-B（Before）** 显示匹配行之前的若干行：

```bash
# 显示匹配行及其前 2 行
grep -B 2 "Exception" error.log
```

**-C（Context）** 显示匹配行前后各若干行：

```bash
# 显示匹配行及其前后各 5 行
grep -C 5 "Exception" error.log
```

这些选项在分析日志文件时特别有用，可以看到错误发生的上下文环境。

### 4.2 只输出匹配部分

默认情况下，grep 输出整行。使用 `-o` 只输出匹配的部分：

```bash
# 提取所有 IP 地址
grep -oE "\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b" access.log
```

这在提取特定数据时非常有用。

### 4.3 从文件读取模式

当需要搜索多个模式时，可以将它们放在文件中，使用 `-f` 选项：

```bash
# patterns.txt 文件内容：
# error
# warning
# critical

grep -f patterns.txt /var/log/syslog
```

每行一个模式，它们之间是"或"的关系。

### 4.4 排除文件和目录

在递归搜索时，可能需要排除某些文件或目录：

```bash
# 排除 .git 目录
grep -r --exclude-dir=".git" "TODO" .

# 排除多个目录
grep -r --exclude-dir={.git,node_modules,vendor} "pattern" .

# 排除特定类型的文件
grep -r --exclude="*.log" "pattern" .

# 只搜索特定类型的文件
grep -r --include="*.py" "import" .
```

### 4.5 二进制文件处理

默认情况下，grep 会检测并跳过二进制文件。可以通过以下选项控制这一行为：

```bash
# 将二进制文件视为文本文件
grep -a "pattern" binary_file

# 完全忽略二进制文件（默认行为）
grep -I "pattern" *

# 显示二进制文件匹配信息
grep --binary-files=binary "pattern" *
```

### 4.6 静默模式

使用 `-q` 选项运行 grep 不产生任何输出，只设置退出状态码。这在脚本中非常有用：

```bash
if grep -q "error" logfile.txt; then
    echo "Found errors in the log"
fi
```

退出状态码的含义：0 表示找到匹配，1 表示未找到匹配，2 表示发生错误。

### 4.7 颜色高亮

使用 `--color` 选项可以高亮显示匹配的部分：

```bash
grep --color=auto "pattern" file.txt
```

大多数现代系统的 grep 默认启用颜色。可以设置环境变量使其永久生效：

```bash
export GREP_OPTIONS='--color=auto'
# 或者在 .bashrc 中设置别名
alias grep='grep --color=auto'
```

------

## 第五章：与其他命令配合

grep 的真正威力在于与其他命令通过管道配合使用。

### 5.1 与 find 配合

在特定文件中搜索：

```bash
# 在所有 Python 文件中搜索 "import os"
find . -name "*.py" -exec grep -l "import os" {} \;

# 更高效的写法
find . -name "*.py" -print0 | xargs -0 grep -l "import os"
```

### 5.2 与 ps 配合

查找特定进程：

```bash
# 查找 nginx 进程
ps aux | grep nginx

# 排除 grep 自身
ps aux | grep nginx | grep -v grep

# 更优雅的写法
ps aux | grep "[n]ginx"
```

第三种写法利用了正则表达式的特性：`[n]ginx` 匹配 "nginx"，但 grep 命令本身包含的是 "[n]ginx" 而不是 "nginx"，因此不会匹配到自己。

### 5.3 与 tail/head 配合

实时监控日志中的错误：

```bash
tail -f /var/log/syslog | grep --line-buffered "error"
```

`--line-buffered` 确保每匹配一行就立即输出，而不是等待缓冲区填满。

### 5.4 与 cut/awk 配合

提取特定字段：

```bash
# 查找包含 error 的行，并提取第一个字段
grep "error" access.log | cut -d' ' -f1

# 使用 awk 进行更复杂的处理
grep "error" access.log | awk '{print $1, $4}'
```

### 5.5 与 sort/uniq 配合

统计和去重：

```bash
# 统计不同 IP 地址的访问次数
grep -oE "\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b" access.log | sort | uniq -c | sort -rn
```

### 5.6 与 xargs 配合

对匹配的文件执行操作：

```bash
# 删除包含 "deprecated" 的文件
grep -l "deprecated" *.txt | xargs rm

# 安全处理包含空格的文件名
grep -lZ "deprecated" *.txt | xargs -0 rm
```

------

## 第六章：性能优化

### 6.1 使用固定字符串

当不需要正则表达式时，使用 `-F` 选项可以显著提高速度：

```bash
grep -F "exact string" largefile.txt
```

### 6.2 限制输出

当只需要知道是否存在匹配时：

```bash
# 找到第一个匹配就停止
grep -m 1 "pattern" largefile.txt

# 静默模式用于脚本
grep -q "pattern" file.txt && echo "Found"
```

### 6.3 避免不必要的选项

某些选项会显著影响性能。例如，`-i`（忽略大小写）比大小写敏感的搜索慢。如果可能，明确指定大小写：

```bash
# 比较慢
grep -i "error" largefile.txt

# 更快（如果知道确切的大小写组合）
grep -E "[Ee]rror" largefile.txt
```

### 6.4 本地化设置

设置 `LC_ALL=C` 可以加速 grep，因为它使用简单的字节比较而不是复杂的 Unicode 排序规则：

```bash
LC_ALL=C grep "pattern" largefile.txt
```

这在处理纯 ASCII 文本时特别有效。

------

## 第七章：实用案例

### 7.1 日志分析

分析 Nginx 访问日志，找出 404 错误：

```bash
grep " 404 " access.log | awk '{print $7}' | sort | uniq -c | sort -rn | head -20
```

查找特定时间段的日志：

```bash
grep "17/Jan/2026:1[0-2]:" access.log
```

### 7.2 代码审查

查找所有 TODO 和 FIXME 注释：

```bash
grep -rn -E "TODO|FIXME" --include="*.py" .
```

查找可能的安全问题（硬编码密码）：

```bash
grep -rn -i "password\s*=" --include="*.py" .
```

查找未使用的导入（Python）：

```bash
for import in $(grep -oh "^import \w*" *.py | cut -d' ' -f2 | sort -u); do
    count=$(grep -c "\b$import\b" *.py)
    if [ "$count" -eq 1 ]; then
        echo "Possibly unused: $import"
    fi
done
```

### 7.3 系统管理

查找失败的 SSH 登录尝试：

```bash
grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn
```

检查配置文件语法（排除注释和空行）：

```bash
grep -vE "^\s*(#|$)" /etc/nginx/nginx.conf
```

### 7.4 数据处理

从 CSV 文件中提取特定列包含特定值的行：

```bash
grep ",active," users.csv
```

验证数据格式：

```bash
# 找出不符合邮箱格式的行
grep -vE "^[^,]+,[^,]+,[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$" data.csv
```

### 7.5 网络排查

查找配置文件中的 IP 地址：

```bash
grep -rE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" /etc/
```

检查开放端口配置：

```bash
grep -rE "listen\s+[0-9]+" /etc/nginx/
```

------

## 第八章：常见陷阱和注意事项

### 8.1 引号的使用

在 shell 中，引号的选择很重要：

```bash
# 单引号：完全字面处理，变量不会展开
grep 'pattern' file.txt

# 双引号：变量会展开
pattern="error"
grep "$pattern" file.txt

# 不加引号：可能导致问题
grep error* file.txt  # shell 可能会展开 error*
```

推荐始终使用引号包裹模式。

### 8.2 特殊字符转义

当搜索包含正则表达式元字符的文本时，需要转义：

```bash
# 搜索包含 "[error]" 的行
grep "\[error\]" file.txt

# 或者使用 -F 选项
grep -F "[error]" file.txt
```

### 8.3 行尾问题

Windows 和 Unix 系统使用不同的行尾符。如果文件包含 Windows 风格的行尾（CRLF），可能会导致意外的匹配问题：

```bash
# 先转换行尾
dos2unix file.txt

# 或者在正则表达式中处理
grep -E "pattern\r?$" file.txt
```

### 8.4 编码问题

grep 默认假设文件是当前 locale 的编码。处理不同编码的文件时：

```bash
# 强制使用二进制模式
grep -a "pattern" file.txt

# 或者先转换编码
iconv -f gbk -t utf-8 file.txt | grep "pattern"
```

------

## 第九章：ripgrep (rg) 介绍

ripgrep 是由 Andrew Galloway 使用 Rust 编写的现代 grep 替代工具。它保持了与 grep 相似的接口，同时提供了显著的性能提升和更好的默认行为。

### 9.1 安装

```bash
# Ubuntu/Debian
sudo apt install ripgrep

# macOS
brew install ripgrep

# Arch Linux
sudo pacman -S ripgrep

# Cargo (Rust)
cargo install ripgrep
```

### 9.2 主要特性

**极快的速度**：ripgrep 使用 Rust 的正则表达式引擎，采用有限自动机实现，在大多数情况下比 grep 快数倍甚至数十倍。

**智能递归搜索**：默认情况下，rg 递归搜索当前目录，自动忽略 .gitignore 中列出的文件和目录，跳过隐藏文件和二进制文件。

**Unicode 支持**：ripgrep 完整支持 Unicode，包括 Unicode 字符类。

**并行搜索**：ripgrep 自动使用多核 CPU 进行并行搜索。

### 9.3 基本用法对比

| grep                   | ripgrep           | 说明                |
| ---------------------- | ----------------- | ------------------- |
| `grep -r "pattern" .`  | `rg "pattern"`    | 递归搜索            |
| `grep -rn "pattern" .` | `rg "pattern"`    | 行号（rg 默认显示） |
| `grep -ri "pattern" .` | `rg -i "pattern"` | 忽略大小写          |
| `grep -rw "pattern" .` | `rg -w "pattern"` | 全词匹配            |
| `grep -rE "pattern" .` | `rg "pattern"`    | ERE（rg 默认）      |
| `grep -rl "pattern" .` | `rg -l "pattern"` | 只显示文件名        |
| `grep -rc "pattern" .` | `rg -c "pattern"` | 统计匹配数          |

### 9.4 ripgrep 独特功能

**文件类型过滤**：

```bash
# 只搜索 Python 文件
rg -t py "import"

# 排除 JavaScript 文件
rg -T js "function"

# 列出所有支持的文件类型
rg --type-list
```

**智能大小写**：

```bash
# 模式全小写时忽略大小写，包含大写时精确匹配
rg -S "Error"  # 精确匹配 "Error"
rg -S "error"  # 匹配 "error", "Error", "ERROR" 等
```

**替换预览**：

```bash
# 显示替换结果（不实际修改文件）
rg "old" --replace "new"
```

**JSON 输出**：

```bash
# 输出 JSON 格式，便于程序处理
rg --json "pattern"
```

**统计信息**：

```bash
# 显示搜索统计
rg --stats "pattern"
```

### 9.5 性能对比

以下是在一个中等规模代码库（约 10 万个文件）中的典型性能对比：

| 工具    | 搜索时间    |
| ------- | ----------- |
| grep -r | 约 10-30 秒 |
| ripgrep | 约 0.5-2 秒 |

ripgrep 的速度优势来自多个方面：使用内存映射文件、并行搜索、智能跳过不相关文件、高度优化的正则表达式引擎。

### 9.6 何时使用哪个工具

**使用 grep 当**：你在一个没有安装 ripgrep 的系统上工作；你需要 POSIX 兼容性；你在编写需要可移植性的 shell 脚本；你正在处理标准输入管道。

**使用 ripgrep 当**：你在代码库中搜索；你需要最快的搜索速度；你需要 Unicode 支持；你希望自动忽略版本控制忽略的文件；你在日常开发工作中频繁搜索。

### 9.7 让 ripgrep 行为更像 grep

如果需要 ripgrep 搜索所有文件（包括隐藏文件和 .gitignore 忽略的文件）：

```bash
rg --no-ignore --hidden "pattern"
```

或者设置别名：

```bash
alias rga='rg --no-ignore --hidden'
```

------

## 第十章：速查表

### grep 常用选项

```
-i          忽略大小写
-v          反向匹配（显示不匹配的行）
-n          显示行号
-c          只显示匹配行数
-l          只显示匹配的文件名
-L          只显示不匹配的文件名
-w          全词匹配
-x          整行匹配
-r, -R      递归搜索目录
-E          使用扩展正则表达式
-F          使用固定字符串（禁用正则表达式）
-o          只输出匹配的部分
-q          静默模式（不输出，只返回状态码）
-m NUM      最多匹配 NUM 行
-A NUM      显示匹配行之后 NUM 行
-B NUM      显示匹配行之前 NUM 行
-C NUM      显示匹配行前后各 NUM 行
-H          始终显示文件名
-h          不显示文件名
--color     彩色输出
--include   只搜索匹配模式的文件
--exclude   排除匹配模式的文件
--exclude-dir 排除匹配模式的目录
```

### 正则表达式速查

```
.           任意单个字符
*           前一个字符出现 0 次或多次
+           前一个字符出现 1 次或多次（ERE）
?           前一个字符出现 0 次或 1 次（ERE）
^           行首
$           行尾
[abc]       字符类（匹配 a、b 或 c）
[^abc]      否定字符类（匹配非 a、b、c 的字符）
[a-z]       字符范围
\           转义特殊字符
|           或（ERE）
()          分组（ERE）
{n}         恰好 n 次（ERE）
{n,}        至少 n 次（ERE）
{n,m}       n 到 m 次（ERE）
\b          单词边界
\<          单词开头
\>          单词结尾
```

------

## 总结

grep 是 Unix 哲学的完美体现——做好一件事。它专注于文本搜索，并且做得极其出色。掌握 grep 和正则表达式是每个开发者和系统管理员的必备技能。

从简单的字符串搜索开始，逐步学习正则表达式，然后探索与其他命令的组合，你会发现 grep 能够解决各种各样的文本处理问题。当你需要更快的速度和更现代的功能时，ripgrep 是一个优秀的升级选择，它保持了 grep 的精髓，同时带来了显著的性能提升和更好的开发体验。