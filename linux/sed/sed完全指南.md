[toc]



# sed 命令行工具完全指南

sed（Stream Editor，流编辑器）是 Unix/Linux 系统中最强大的文本处理工具之一。它以非交互式的方式对文本流进行转换，是每个系统管理员和开发者必备的技能。

------

## 第一章：理解 sed 的核心思想

### 什么是流编辑器

传统的文本编辑器（如 Vim、Nano）需要你打开文件、手动修改、保存退出。

sed 的工作方式完全不同——**它像一条流水线，文本从一端流入，经过你定义的规则处理后，从另一端流出**。你不需要打开文件，不需要交互操作，只需要告诉 sed "遇到什么就做什么"。

这种设计使 sed 特别适合三个场景：**自动化脚本中的文本处理、管道命令中的数据转换、以及批量修改大量文件**。

### sed 的处理模型

理解 sed 的内部工作机制对于掌握它至关重要。sed 维护两个**数据缓冲区**：

**模式空间（Pattern Space）** 是 sed 的**主工作区**。当 sed 读取输入时，**它每次将一行文本放入模式空间**，然后**对这行应用所有的编辑命令**。处理完毕后，**模式空间的内容被输出，然后清空，读入下一行，如此循环直到输入结束**。

**保持空间（Hold Space）** 是一个**辅助缓冲区**，初始为空。你可以把**模式空间的内容暂存到保持空间，稍后再取回**。这在需要**跨行操作**时非常有用，比如交换相邻两行的内容。

整个处理流程可以概括为：读取一行 → 放入模式空间 → 执行命令序列 → 输出模式空间 → 清空模式空间 → 读取下一行。

------

## 第二章：基础语法与调用方式

### 命令行语法

sed 的基本调用格式如下：

```bash
sed [选项] '命令' 输入文件
sed [选项] -e '命令1' -e '命令2' 输入文件
sed [选项] -f 脚本文件 输入文件
```

**当不指定输入文件时，sed 从标准输入读取**，这使它可以作为管道的一部分使用。

### 常用选项详解

**-n（静默模式）** 是最常用的选项之一。**默认情况下，sed 会输出模式空间中的每一行，无论是否被修改**。加上 -n 后，sed 只输出你明确要求打印的行。例如 `sed -n '5p' file` 只会打印第五行，而不是打印全部内容并在第五行重复一次。

```bash
#不使用sed -n,会重复输出第5行
$ cat demo4.sh -n|sed '5p'
     1  #!/bin/bash
     2  # :开头,启用静默错误模式（silent error reporting）
     3  # h 不需要参数，f 需要一个参数
     4  while getopts ":hf:" opt; do
     5    case $opt in
     5    case $opt in
     6      h)
#使用sed -n 
$ cat demo4.sh -n|sed -n '5p'
     5    case $opt in
```

**-i（原地编辑）** 让 sed 直接修改文件而不是输出到标准输出。这是一个"危险"的选项，因为修改是不可逆的。在 macOS 上，-i 选项必须带一个备份后缀参数，即使是空字符串也要显式给出：`sed -i '' 's/old/new/' file`。在 Linux 上可以直接使用 `sed -i 's/old/new/' file`。如果想保留备份，可以用 `sed -i.bak 's/old/new/' file`，这会创建一个 file.bak 备份文件。

**-e（多命令）** 允许你在一次调用中执行多个编辑命令。每个 -e 后面跟一条命令。这等价于用分号分隔多个命令或使用换行。

**-E 或 -r（扩展正则表达式）** 启用扩展正则表达式语法。在基本正则表达式中，你需要转义 `+`、`?`、`|`、`()`、`{}` 等元字符；在扩展正则表达式中，这些字符直接具有特殊含义。例如，匹配一个或多个数字，基本正则写作 `[0-9]\+`，扩展正则写作 `[0-9]+`。现代实践中推荐始终使用 -E 选项，因为扩展正则表达式更直观、更易读。

------

## 第三章：地址与范围

sed 命令可以限定只作用于特定的行，这通过"地址"来实现。地址是 sed 中极其灵活的机制。

### 行号地址

最简单的地址是行号。`3d` 删除第三行，`1,5d` 删除第一到第五行。特殊符号 `$` 代表最后一行，所以 `$d` 删除最后一行，`1,$p` 打印所有行（等价于不加地址）。

```bash
# 只打印第10行
sed -n '10p' file.txt

# 打印第5到第15行
sed -n '5,15p' file.txt

# 打印从第100行到文件末尾
sed -n '100,$p' file.txt
```

### 正则表达式地址

你可以用正则表达式匹配特定内容的行。正则表达式用斜杠包围。`/error/d` 删除包含 "error" 的所有行，`/^#/d` 删除以 # 开头的行（即注释行）。

```bash
# 打印包含 "ERROR" 的所有行
sed -n '/ERROR/p' logfile.log

# 删除空行（只包含行首紧接行尾的行）
sed '/^$/d' file.txt

# 删除以空白字符开头的行
sed '/^[[:space:]]/d' file.txt
```

### 范围地址

范围地址由两个地址组成，用逗号分隔，表示从匹配第一个地址的行开始，到匹配第二个地址的行结束。

```bash
# 打印从 "BEGIN" 到 "END" 之间的所有行（包含边界）
sed -n '/BEGIN/,/END/p' file.txt

# 从第5行到遇到空行为止
sed -n '5,/^$/p' file.txt

# 从包含 "start" 的行开始，再往后10行
sed -n '/start/,+10p' file.txt
```

### 步进地址

步进地址的格式是 `first~step`，表示从第 first 行开始，每隔 step 行选中一行。这是 GNU sed 的扩展功能。

```bash
# 打印所有奇数行（第1、3、5、7...行）
sed -n '1~2p' file.txt

# 打印所有偶数行（第2、4、6、8...行）
sed -n '2~2p' file.txt

# 每隔5行打印一次，从第1行开始
sed -n '1~5p' file.txt
```

### 地址取反

在地址后加感叹号 `!` 表示对不匹配的行执行命令。

```bash
# 删除不包含 "keep" 的行（等价于只保留包含 keep 的行）
sed '/keep/!d' file.txt

# 对除了第一行以外的所有行执行替换
sed '1!s/old/new/g' file.txt
```

------

## 第四章：替换命令（s 命令）

替换命令是 sed 中使用频率最高的命令，其完整语法为：

```
s/正则表达式/替换字符串/标志
```

### 基础替换

```bash
# 将每行第一个 "cat" 替换为 "dog"
sed 's/cat/dog/' file.txt

# 将所有 "cat" 替换为 "dog"（g 标志表示全局）
sed 's/cat/dog/g' file.txt

# 只替换每行第2个匹配
sed 's/cat/dog/2' file.txt

# 从每行第2个匹配开始，替换后面所有的
sed 's/cat/dog/2g' file.txt
```

### 分隔符的选择

斜杠不是唯一可用的分隔符。当你的模式或替换字符串中包含斜杠时，可以换用其他字符，任何字符都可以作为分隔符，只要保持一致。

```bash
# 处理路径时，用 # 或 | 作为分隔符更清晰
sed 's#/usr/local/bin#/opt/bin#g' file.txt
sed 's|/home/user|/home/admin|g' file.txt

# 用 @ 作为分隔符
sed 's@http://@https://@g' file.txt
```

### 替换标志详解

**g（global）** 替换行内所有匹配，而不只是第一个。这可能是最常用的标志。

**i 或 I（ignore case）** 匹配时忽略大小写。`s/error/WARNING/gi` 会匹配 error、Error、ERROR 等各种形式。

**p（print）** 如果发生了替换，就打印该行。通常与 -n 选项配合使用，只显示被修改的行。

**w 文件名（write）** 如果发生了替换，把该行写入指定文件。

```bash
# 替换并只显示被修改的行
sed -n 's/error/ERROR/gp' logfile.log

# 替换并将修改的行同时保存到另一个文件
sed 's/TODO/DONE/gw completed.txt' tasks.txt
```

### 反向引用

在替换字符串中，你可以引用正则表达式中捕获的内容。用 `\(` 和 `\)` 在模式中定义捕获组（使用 -E 时直接用括号），然后用 `\1`、`\2` 等引用它们。特殊符号 `&` 代表整个匹配的内容。

```bash
# 给所有数字加上方括号
sed 's/[0-9]\+/[&]/g' file.txt

# 交换两个单词的顺序
sed -E 's/(\w+) (\w+)/\2 \1/' file.txt

# 将 "名 姓" 格式转换为 "姓, 名" 格式
sed -E 's/^([A-Za-z]+) ([A-Za-z]+)$/\2, \1/' names.txt

# 在每行开头添加行号（结合其他命令）
sed = file.txt | sed 'N;s/\n/\t/'
```

### 实用替换示例

```bash
# 删除每行开头的空白字符
sed 's/^[[:space:]]*//' file.txt

# 删除每行末尾的空白字符
sed 's/[[:space:]]*$//' file.txt

# 删除首尾空白（trim）
sed 's/^[[:space:]]*//;s/[[:space:]]*$//' file.txt

# 将多个连续空格压缩为单个空格
sed 's/  */ /g' file.txt

# 将 DOS 换行符转换为 Unix 换行符（删除 \r）
sed 's/\r$//' file.txt

# 给 HTML 标签添加 class 属性
sed -E 's/<div>/<div class="container">/g' file.html
```

------

## 第五章：其他核心命令

### 删除命令（d）

删除命令将当前行从模式空间中清除，立即开始下一个循环，不再执行后续命令。

```bash
# 删除第3行
sed '3d' file.txt

# 删除最后一行
sed '$d' file.txt

# 删除第2到第4行
sed '2,4d' file.txt

# 删除包含 "debug" 的行
sed '/debug/d' file.txt

# 删除空行
sed '/^$/d' file.txt

# 删除注释行和空行
sed '/^#/d;/^$/d' file.txt

# 删除从某个模式到文件末尾的所有内容
sed '/CUTOFF/,$d' file.txt
```

### 打印命令（p）

打印命令输出当前模式空间的内容。通常与 -n 选项配合使用，因为默认情况下 sed 已经会打印每一行。

```bash
# 只打印第5行（相当于 head + tail 的组合）
sed -n '5p' file.txt

# 打印第1到10行（相当于 head -10）
sed -n '1,10p' file.txt

# 打印匹配行
sed -n '/pattern/p' file.txt

# 打印匹配行及其行号
sed -n '/pattern/{=;p}' file.txt
```

### 插入、追加与更改（i、a、c）

**i（insert）** 在指定行之前插入文本。
 **a（append）** 在指定行之后追加文本。
 **c（change）** 将指定行替换为新文本。

```bash
# 在第1行之前插入一行
sed '1i\This is the new first line' file.txt

# 在最后一行之后追加一行
sed '$a\This is appended at the end' file.txt

# 在匹配行之后追加
sed '/pattern/a\This line follows the pattern' file.txt

# 将匹配行替换为新内容
sed '/old content/c\new content' file.txt

# 在文件开头添加版权声明（多行）
sed '1i\
# Copyright 2024\
# All rights reserved\
' script.sh
```

### 转换命令（y）

转换命令类似于 `tr` 命令，进行字符级别的一对一替换。它没有正则表达式功能，只是简单的字符映射。

```bash
# 将小写字母转换为大写
sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' file.txt

# 将数字替换为对应的汉字
sed 'y/0123456789/零一二三四五六七八九/' file.txt

# ROT13 加密
sed 'y/abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM/' file.txt
```

### 读写文件命令（r、w）

**r（read）** 在指定位置读入另一个文件的内容。
 **w（write）** 将匹配的行写入另一个文件。

```bash
# 在第5行之后插入另一个文件的内容
sed '5r insert.txt' main.txt

# 在匹配行之后插入文件内容
sed '/PLACEHOLDER/r content.txt' template.txt

# 将匹配的行写入新文件
sed -n '/ERROR/w errors.txt' logfile.log

# 分流：将匹配不同模式的行写入不同文件
sed -n '/ERROR/w errors.txt; /WARN/w warnings.txt; /INFO/w info.txt' logfile.log
```

### 退出命令（q、Q）

**q** 立即退出，打印当前模式空间内容。
 **Q**（GNU 扩展）立即退出，不打印当前模式空间。

```bash
# 打印前10行后退出（比 head 更灵活）
sed '10q' file.txt

# 找到第一个匹配后退出
sed '/pattern/q' file.txt

# 打印到某个模式出现为止
sed '/END_MARKER/q' file.txt
```

------

## 第六章：多行处理

单行处理是 sed 的默认模式，但有时我们需要处理跨越多行的模式。sed 提供了一组专门的多行命令。

### N 命令：追加下一行

N 命令读取下一行，追加到模式空间，两行之间用换行符 `\n` 连接。

```bash
# 将每两行合并为一行（换行符替换为空格）
sed 'N;s/\n/ /' file.txt

# 在相邻两行中搜索跨行模式
sed 'N;s/end\nstart/middle/g' file.txt

# 给文件添加行号（先用 = 生成行号，再合并）
sed = file.txt | sed 'N;s/\n/: /'
```

### P 和 D 命令：多行打印和删除

**P** 打印模式空间中第一个换行符之前的内容。
 **D** 删除模式空间中第一个换行符之前的内容，然后重新开始循环（不读取新行）。

```bash
# 删除连续的重复行（类似 uniq）
sed '$!N;/^\(.*\)\n\1$/!P;D' file.txt

# 反转文件行序（tac 的 sed 实现）
sed '1!G;h;$!d' file.txt
```

### 保持空间操作（h、H、g、G、x）

**h** 将模式空间复制到保持空间（覆盖）。
 **H** 将模式空间追加到保持空间（用换行符连接）。
 **g** 将保持空间复制到模式空间（覆盖）。
 **G** 将保持空间追加到模式空间（用换行符连接）。
 **x** 交换模式空间和保持空间的内容。

```bash
# 反转文件行序的经典实现
# 原理：每行追加到保持空间，最后取出
sed -n '1!G;h;$p' file.txt

# 在每行后面添加空行
sed 'G' file.txt

# 交换相邻两行
sed -n 'h;n;p;g;p' file.txt

# 在匹配行之前插入分隔线
sed '/pattern/{x;p;x}' file.txt
```

------

## 第七章：分支与流程控制

sed 支持标签和分支，可以实现复杂的流程控制逻辑。

### 标签和跳转（: 和 b）

用 `:label` 定义标签，用 `b label` 跳转到标签处。不带标签的 `b` 跳转到脚本末尾。

```bash
# 将所有连续空格替换为单个空格（循环直到没有变化）
sed ':loop; s/  / /g; t loop' file.txt

# 跳过某些行的处理
sed '/skip/b; s/process/PROCESSED/g' file.txt
```

### 条件分支（t 和 T）

**t** 如果自上次读入新行后发生过替换，则跳转。
 **T**（GNU 扩展）如果自上次读入新行后没有发生替换，则跳转。

```bash
# 持续替换直到没有变化
sed ':a; s/pattern/replacement/; t a' file.txt

# 删除多余的空行（将多个连续空行压缩为一个）
sed '/^$/{N;/^\n$/D}' file.txt

# 更复杂的版本：删除开头的空行，压缩中间的空行
sed '/./,/^$/!d' file.txt
```

------

## 第八章：正则表达式深入

sed 使用正则表达式进行模式匹配，掌握正则是用好 sed 的前提。

### 基本正则 vs 扩展正则

在基本正则表达式（BRE）中，`?`、`+`、`|`、`()`、`{}` 是普通字符，要表示特殊含义必须加反斜杠。在扩展正则表达式（ERE，使用 -E 选项启用）中，这些字符直接具有特殊含义。

```bash
# 基本正则：匹配一个或多个数字
sed 's/[0-9]\+/NUMBER/' file.txt

# 扩展正则：同样的效果
sed -E 's/[0-9]+/NUMBER/' file.txt

# 基本正则：分组
sed 's/\(foo\)\(bar\)/\2\1/' file.txt

# 扩展正则：分组
sed -E 's/(foo)(bar)/\2\1/' file.txt
```

### 常用正则表达式元素

```bash
# 锚点
^          # 行首
$          # 行尾
\<         # 单词开头
\>         # 单词结尾
\b         # 单词边界（GNU 扩展）

# 字符类
.          # 任意单个字符
[abc]      # a、b、c 中的任意一个
[^abc]     # 除了 a、b、c 以外的任意字符
[a-z]      # a 到 z 之间的任意字符
[[:alpha:]] # 任意字母
[[:digit:]] # 任意数字
[[:space:]] # 任意空白字符
[[:alnum:]] # 任意字母或数字

# 量词
*          # 零次或多次
\+         # 一次或多次（BRE）或 +（ERE）
\?         # 零次或一次（BRE）或 ?（ERE）
\{n\}      # 恰好 n 次
\{n,\}     # 至少 n 次
\{n,m\}    # n 到 m 次
```

### 实用正则表达式示例

```bash
# 匹配 IP 地址（简化版）
sed -E 's/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[IP_REDACTED]/g' file.txt

# 匹配邮箱地址（简化版）
sed -E 's/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/[EMAIL]/g' file.txt

# 匹配日期格式 YYYY-MM-DD
sed -E 's/[0-9]{4}-[0-9]{2}-[0-9]{2}/[DATE]/g' file.txt

# 提取引号内的内容
sed -E 's/.*"([^"]+)".*/\1/' file.txt
```

------

## 第九章：实战案例集

### 配置文件处理

```bash
# 修改配置文件中的特定设置
sed -i 's/^max_connections=.*/max_connections=1000/' config.ini

# 取消注释某个配置项
sed -i 's/^#\(ServerName\)/\1/' httpd.conf

# 注释掉某个配置项
sed -i 's/^\(PasswordAuthentication\)/#\1/' sshd_config

# 在配置项后添加新行
sed -i '/\[database\]/a\host=localhost' config.ini

# 删除配置文件中的注释和空行
sed '/^#/d;/^$/d;/^[[:space:]]*$/d' config.file
```

### 日志处理

```bash
# 提取特定时间范围的日志
sed -n '/2024-01-15 10:00/,/2024-01-15 11:00/p' access.log

# 统计错误日志中各类错误的行
sed -n '/ERROR/p' app.log | sort | uniq -c

# 提取日志中的 IP 地址
sed -E 's/.*([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/' access.log

# 删除日志中的敏感信息
sed -E 's/password=[^&]+/password=*****/g' debug.log

# 格式化日志输出
sed 's/^/[LOG] /' application.log
```

### 代码处理

```bash
# 将制表符替换为4个空格
sed 's/\t/    /g' code.py

# 删除行尾的空白字符
sed 's/[[:space:]]*$//' code.js

# 在每个函数定义前添加空行（Python）
sed '/^def /i\\' code.py

# 将 var 声明改为 let（JavaScript）
sed 's/\bvar\b/let/g' code.js

# 给函数添加装饰器
sed '/^def /i\@timer' code.py

# 删除 C 风格的单行注释
sed 's://.*$::' code.c

# 将 print 语句改为 print 函数（Python 2 到 3）
sed -E 's/print ([^(].*)/print(\1)/' old_code.py
```

### 文本格式转换

```bash
# CSV 转 TSV（逗号转制表符）
sed 's/,/\t/g' data.csv

# 将 Markdown 标题转为 HTML
sed -E 's/^### (.*)/<h3>\1<\/h3>/; s/^## (.*)/<h2>\1<\/h2>/; s/^# (.*)/<h1>\1<\/h1>/' doc.md

# 将下划线命名转为驼峰命名
sed -E 's/_([a-z])/\U\1/g' code.txt

# 在每行末尾添加逗号（用于生成数组）
sed 's/$/,/' items.txt

# 将多行转为单行（用逗号分隔）
sed ':a;N;$!ba;s/\n/, /g' list.txt

# 将单个长行按特定分隔符拆分为多行
sed 's/;/\n/g' single_line.txt
```

### 批量文件处理

```bash
# 批量替换多个文件中的内容
sed -i 's/old_api/new_api/g' *.py

# 结合 find 处理子目录中的文件
find . -name "*.txt" -exec sed -i 's/foo/bar/g' {} \;

# 使用 xargs 处理（更高效）
find . -name "*.txt" -print0 | xargs -0 sed -i 's/foo/bar/g'

# 备份并替换
for f in *.conf; do
    sed -i.bak 's/old/new/g' "$f"
done
```

------

## 第十章：性能优化与最佳实践

### 性能考虑

当处理大文件时，以下技巧可以提高效率：

**尽早退出**：如果只需要处理文件的前面部分，使用 q 命令避免读取整个文件。

```bash
# 只处理前1000行
sed '1000q' huge_file.txt | sed 's/pattern/replacement/'

# 找到第一个匹配后退出
sed '/pattern/{s/pattern/replacement/;q}' huge_file.txt
```

**避免不必要的操作**：使用地址限定命令作用范围。

```bash
# 不好：对每一行都尝试匹配
sed 's/pattern/replacement/' file.txt

# 好：只对包含 pattern 的行执行替换
sed '/pattern/s/pattern/replacement/' file.txt
```

**合并多个 sed 调用**：每次调用 sed 都有进程创建开销。

```bash
# 不好：多次调用
cat file.txt | sed 's/a/b/' | sed 's/c/d/' | sed 's/e/f/'

# 好：一次调用
sed 's/a/b/; s/c/d/; s/e/f/' file.txt
```

### 可移植性注意事项

不同系统的 sed 实现存在差异，编写可移植脚本时需要注意：

**-i 选项**：macOS 的 sed 要求 -i 后面必须有参数（哪怕是空字符串），而 GNU sed 的 -i 可以不带参数。可移植的写法是 `sed -i.bak 's/.../.../' file && rm file.bak`。

**扩展正则**：GNU sed 用 -r 或 -E，BSD/macOS sed 用 -E。使用 -E 是更通用的选择。

**\n 在替换字符串中**：GNU sed 支持在替换字符串中使用 `\n` 表示换行，但这不是 POSIX 标准。可移植的方法是使用字面换行符。

```bash
# 可移植的插入换行方法
sed 's/pattern/replacement\
continuation/' file.txt
```

### 调试技巧

**显示处理过程**：使用 l 命令显示模式空间内容，特殊字符会转义显示。

```bash
sed -n 'l' file.txt  # 显示每行，特殊字符可见
```

**逐步执行**：将复杂命令拆分，逐个添加调试。

```bash
# 先确认地址正确
sed -n '/pattern/p' file.txt

# 再添加实际操作
sed '/pattern/s/old/new/' file.txt
```

------

## 第十一章：sed 与其他工具的协作

### sed 在管道中

sed 最常见的用法是作为管道的一部分：

```bash
# 处理命令输出
ls -l | sed 's/  */ /g' | cut -d' ' -f5,9

# 处理 grep 结果
grep "ERROR" log.txt | sed 's/.*ERROR: //'

# 处理 find 输出
find . -name "*.txt" | sed 's|^\./||'

# 与 awk 配合
cat data.txt | sed '/^$/d' | awk '{sum+=$1} END {print sum}'
```

### 何时选择 sed 或其他工具

**sed** 最适合简单的行级文本转换，特别是查找替换操作。

**awk** 更适合字段处理和数据计算。如果需要按列处理数据或进行数学运算，awk 是更好的选择。

**grep** 更适合纯粹的搜索。如果只需要过滤行而不修改，grep 更直观。

**perl/python** 对于复杂的文本处理逻辑，完整的编程语言提供更好的可读性和可维护性。

```bash
# 简单替换：用 sed
sed 's/old/new/g' file.txt

# 按列求和：用 awk
awk '{sum+=$3} END {print sum}' file.txt

# 简单过滤：用 grep
grep "pattern" file.txt

# 复杂处理：用 perl 或 python
perl -pe 's/(\d+)/sprintf("%04d", $1)/ge' file.txt
```

------

## 附录：速查表

### 常用选项

| 选项   | 说明                 |
| ------ | -------------------- |
| -n     | 静默模式，不自动打印 |
| -i     | 原地编辑文件         |
| -i.bak | 原地编辑并创建备份   |
| -e     | 添加编辑命令         |
| -f     | 从文件读取命令       |
| -E/-r  | 使用扩展正则表达式   |

### 地址类型

| 地址              | 说明                      |
| ----------------- | ------------------------- |
| n                 | 第 n 行                   |
| $                 | 最后一行                  |
| /regex/           | 匹配正则的行              |
| n,m               | 第 n 到 m 行              |
| n,/regex/         | 第 n 行到匹配正则的行     |
| /regex1/,/regex2/ | 两个匹配之间的行          |
| n~step            | 从第 n 行开始每隔 step 行 |
| addr!             | 不匹配的行                |

### 常用命令

| 命令            | 说明                |
| --------------- | ------------------- |
| s/old/new/flags | 替换                |
| d               | 删除行              |
| p               | 打印行              |
| i\text          | 在前面插入          |
| a\text          | 在后面追加          |
| c\text          | 替换整行            |
| y/set1/set2/    | 字符转换            |
| =               | 打印行号            |
| q               | 退出                |
| n               | 读取下一行          |
| N               | 追加下一行          |
| h/H             | 复制/追加到保持空间 |
| g/G             | 从保持空间复制/追加 |
| x               | 交换两个空间        |

### 替换标志

| 标志   | 说明            |
| ------ | --------------- |
| g      | 全局替换        |
| n      | 替换第 n 个匹配 |
| p      | 替换后打印      |
| w file | 替换后写入文件  |
| i/I    | 忽略大小写      |

------

