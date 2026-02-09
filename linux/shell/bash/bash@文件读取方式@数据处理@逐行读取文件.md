[toc]



## 逐行（以及/或逐字段）读取一个文件（数据流、变量）

- [BashFAQ/001 - Greg's Wiki](https://mywiki.wooledge.org/BashFAQ/001)
- [不要尝试使用 "for"读取文件行](https://mywiki.wooledge.org/DontReadLinesWithFor)。

使用bash内置的语法和命令读取文件行的基本方案是使用`while` 循环和 `read` 命令最后配合文件输入重定向`< file`。

下面是一个基本模板；另外,有许多变体将要讨论： 

```bash
while IFS= read -r line || [[ -n "$line" ]]; do
  printf '%s\n' "$line"
done < "$file"
```

`line` 是一个变量名，由你自行选择。你可以使用任何有效的 shell 变量名； 

`< "$file"` **将循环的输入重定向到一个文件**，该文件的名称存储在变量中；请参见下面的 [输入源选择 ](https://mywiki.wooledge.org/BashFAQ/001#source)。

如果你想将文件中的行读入到一个 [数组 ](https://mywiki.wooledge.org/BashFAQ/005)中，请参见 [FAQ 5](https://mywiki.wooledge.org/BashFAQ/005)。

### read -r

>  -r        do not allow backslashes to escape any characters
>
> `-r`（raw mode）：禁止反斜杠 `\` 作为转义字符，将其视为普通字面字符。

如果没有这个选项，**输入中的任何未转义的反斜杠都会被丢弃**(而不是对转义序列做解释)。

在使用 read 时，**您几乎总是应该使用 `-r` 选项**。

我们使用herestring来做read命令的小实验

```bash
# 不使用 -r（反斜杠被解释为转义字符）
$ read line <<< 'hello\nworld';echo "$line"
hellonworld    # \被直接丢弃,且没有将\n解释换行符处理

# 使用 -r（保留原始反斜杠）
$ read -r line <<< 'hello\nworld';echo "$line"
hello\nworld   # \ 原样保留,\n也没有被解释为换行符
```



> 这个规则(使用`-r`)最常见的**例外情况**是当使用 `-e` 时，它通过 `Readline` 从交互式 shell 中获取行。
>
> `-e`选项`(use Readline to obtain the line)`
>
> 在这种情况下，**tab 补全会添加反斜杠来转义空格等字符**，而您不希望这些反斜杠被字面量地包含在变量中(不适用`-r`就可以移除这些`\`字符)。
>
> 不过，当逐行读取内容时，这绝不会被使用，而且在这种情况下应该始终使用 `-r`。

`IFS=`作用于`read`命令,让read文件行的时候不要执行任何行内分隔,确保行到完整性

`[[ -n "$line" ]]`是为了防止结尾不是换行符的文件的处理出错.

注意,如果只是出于判断文件末尾(最后一个回车符后的内容)是否为空,没有双引号也不影响结论,但是出于良好的变量引用习惯,不要漏掉双引号`""`(防止不必要的字段分割并忽略**通配符模式**展开,尤其是后者)

### 判断变量是否为空的表达式

#### `[[ $line ]]`和`[[ -n $line ]]`,`[[ -n "$line" ]]`

`[[ $line ]]`这是 `[[ -n $line ]]` 的简写形式。在 Bash 内部，如果变量名单独出现在 `[[ ]]` 中，它会测试该字符串是否非空。

- **优点**：由于 `[[` 是 Bash 的内置关键字，它不会进行单词拆分（Word Splitting）。即使不加双引号，包含空格的字符串也不会报错。
- **注意**：虽然简洁，但对于初学者来说，语义不如 `-n` 明确。

 `[[ -n $line ]]`或`[[ -n "$line" ]]`这是 **Bash 环境下最推荐** 的写法。

- **原理**：`-n` 表示 "Non-zero length"（长度不为零）。
- **优点**：同样受 Bash 关键字`[[`保护，不需要担心 `$line` 为空或含有**空格**导致的语法崩塌。不过`[[ -n "$line" ]]`也是正确的.
- **示例**：即使 `line="a b c"`，它也会被当作一个整体处理，而不会像 `[` 那样报错。

#### `[ -n "$line" ]`

这是传统的 POSIX 标准写法（也称为 `test` 命令）。

- **致命陷阱**：如果不加双引号，写成 `[ -n $line ]`，当 `$line` 为空时，命令会变成 `[ -n ]`。在很多 Shell 实现中，`[ -n ]` 会被判定为 **True**（因为它认为你要测试的是 "-n" 这个字符串是否存在），这会导致逻辑错误。
- **空格问题**：如果不加双引号且变量含空格，会报 `too many arguments` 错误。
- **使用场景**：只有当你编写需要兼容纯 `sh`（非 Bash）的脚本时，才使用这种写法，且**必须严格加双引号**。

## read命令

read命令是bash内置的于用户交互的重要命令.

`read` 是 Bash 的内置命令，主要用于从**标准输入 (stdin)** 或 **文件描述符** 中读取一行数据，并将其拆分为字段赋值给变量。它是编写交互式脚本和处理文本文件的核心工具。

------

### `read` 的工作原理

1. **读取**：从输入流中获取一行。
2. **拆分**：根据 `IFS` (内部字段分隔符，默认是空格、Tab、换行符) 的定义，将行内容拆分成多个片段。
3. **赋值**：将片段按顺序赋给指定的变量。如果片段多于变量，剩下的所有内容都会赋给最后一个变量。

```bash
read: read [-Eers] [-a array] [-d delim] [-i text] [-n nchars] [-N nchars] [-p prompt] [-t timeout] [-u fd] [name ...]
    Read a line from the standard input and split it into fields.


```

> Reads a single line from the standard input, or from file descriptor FD if the -u option is supplied.  
>
> The line is **split into fields** as with **word splitting**, and the first word is assigned to the `first NAME`, the second word to the `second NAME`, and so on,with any **leftover words**(剩余单词) assigned to the `last NAME`. 
>
>  Only the characters found in `$IFS` are recognized as word **delimiters**. By default, the backslash character escapes delimiter characters and newline. 
>
> **If no NAMEs are supplied, the line read is stored in the `REPLY` variable.**

| **参数** | **全称**      | **功能描述**                                 | **常用场景**                                   |
| -------- | ------------- | -------------------------------------------- | ---------------------------------------------- |
| **`-r`** | **Raw**       | **最常用**。禁用反斜杠转义，按原样读取内容。 | 处理包含路径（`\`）的文件。                    |
| **`-p`** | **Prompt**    | 指定提示字符串，显示在输入行之前。           | 交互式脚本，如 `read -p "请输入姓名: " name`。 |
| **`-a`** | **Array**     | 将读取的内容存入一个数组中。                 | 解析一行不确定数量的单词。                     |
| **`-s`** | **Silent**    | 静默模式，不回显输入内容。                   | 输入密码或敏感信息。                           |
| **`-n`** | **Number**    | 读取指定数量的字符后立即结束，无需按回车。   | “按任意键继续”或单字符确认（Y/N）。            |
| **`-t`** | **Timeout**   | 设置等待输入的超时时间（秒）。               | 脚本自动运行时的超时保护。                     |
| **`-u`** | **Unit**      | 指定从某个文件描述符（FD）中读取。           | 同时读取多个不同的文件流。                     |
| **`-d`** | **Delimiter** | 指定结束定界符（默认是换行符）。             | 读取到特定的结束符号为止。                     |

将输入读取到一个普通变量中保存

```bash
# cxxu@CxxuDesk 11:24:12> <~>
$ read -p "input 3 words(separate by IFS chars):" narr2
input 3 words(separate by IFS chars):b1 b2 b3,b4
# cxxu@CxxuDesk 11:24:41> <~>
$ declare -p narr2
declare -- narr2="b1 b2 b3,b4"
```

读取输入为数组(单词分割)

```bash
# cxxu@CxxuDesk 11:20:28> <~>
$ read -a narr
a1 a2 a3
# cxxu@CxxuDesk 11:20:39> <~>
$ declare -p narr
declare -a narr=([0]="a1" [1]="a2" [2]="a3")
```

使用`-p ... -a ...`组合

```bash
# cxxu@CxxuDesk 11:24:43> <~>
$ read -a -p "input 3 words(separate by IFS chars):"  narr3
bash: read: `input 3 words(separate by IFS chars):': not a valid identifier
# cxxu@CxxuDesk 11:25:38> <~>
$ read -p "input 3 words(separate by IFS chars):" -a  narr3
input 3 words(separate by IFS chars):c1 c2 c3
# cxxu@CxxuDesk 11:26:00> <~>
$ declare -p narr3
declare -a narr3=([0]="c1" [1]="c2" [2]="c3")
```

```bash
$ read -p "input password(demo):" -s pwddemo
input password(demo):
# cxxu@CxxuDesk 11:32:16> <~>
$ echo "$pwddemo"
1234
```

```bash
$ read -n 3 -p "input 3 chars to continue:" w3
input 3 chars to continue:135
$ echo "$w3"
135
```

```bash
# cxxu@CxxuDesk 11:47:19> <~>
$ read -t 2 -p "input in 2 seconds(auto close):" w3
input in 2 seconds(auto close):
# cxxu@CxxuDesk 11:47:22> <~>
```



### read默认保存读取的值到REPLY环境变量

```bash
# cxxu@CxxuDesk 11:02:36> <~>
$ read -r
abc123
# cxxu@CxxuDesk 11:13:45> <~>
$ echo "$REPLY"
abc123
```



### read的退出码

>  `Read` a line from the standard input and split it into fields.
>
> Exit Status:
>     The return code is zero, **unless end-of-file is encountered**, read times out  (in which case it's greater than 128), a variable assignment error occurs, or an invalid file descriptor is supplied as the argument to -u.
>
> | 返回码 | 含义                      |
> | ------ | ------------------------- |
> | 0      | 成功读取一行              |
> | 1      | 遇到 EOF（end-of-file）   |
> | >128   | 超时（timeout）           |
> | 1 或 2 | 变量赋值错误              |
> | 1      | 无效的文件描述符（-u fd） |

#### EOF

> 一般来说,EOF **不是错误**，但返回码不为 0.
>
> **EOF（End Of File，文件结束）**
>  当输入流已耗尽，`read` 无法再读到任何数据。
>
> 常见场景：
>
> - 从文件读取并读到末尾
> - 管道输入结束
> - 标准输入被关闭

## read -u

相比其他简单的选项,`-u`相对复杂

> -u fd     read from file descriptor FD instead of the standard input.

在 Bash 中，`-u` (Unit/File Descriptor) 选项非常强大，它允许你指定一个特定的**文件描述符 (File Descriptor, FD)** 来读取数据。

默认情况下，`read` 从文件描述符 `0`（即标准输入 `stdin`）读取。

但在复杂的脚本中，你可能需要**同时读取多个文件**，或者在循环中需要保持 `stdin` 被其他命令占用。

以下是 `-u` 选项的三个典型实战案例：

### 案例 1：同时读取两个不同的文件

这是 `-u` 最经典的用法。假设你有两个文件 `names.txt` 和 `ages.txt`，你想把它们合并输出。



```bash
#!/bin/bash

# 分别为两个文件分配文件描述符 3 和 4
exec 3< names.txt
exec 4< ages.txt

# 使用 -u 显式指定从哪个 FD 读取
while read -u 3 -r name && read -u 4 -r age; do
    echo "姓名: $name, 年龄: $age"
done

# 关闭文件描述符
exec 3<&-
exec 4<&-
```

------

### 案例 2：解决循环内交互冲突（最实用的场景）

如果你在 `while read` 循环内部需要执行一个也会占用标准输入的命令（如 `ssh` 或手动 `read` 确认），会导致逻辑混乱。使用 `-u` 可以将文件流与标准输入分离。

**错误示范（不用 -u）：**

Bash

```bash
while read -r line; do
    # 这里的 read 会因为标准输入被文件占用而直接读取下一行，或者导致循环中断
    read -p "确认处理 $line 吗? [y/n]: " ans < /dev/tty
done < file.txt
```

**正确示范（使用 -u）：**

Bash

```bash
# 将文件重定向到 FD 3，避免占用默认的 stdin
while read -u 3 -r line; do
    echo "正在处理项目: $line"
    # 此时 stdin 是空闲的，可以直接用于用户交互
    read -p "是否继续? [y/n]: " ans
    [[ "$ans" != "y" ]] && break
done 3< file.txt
```

------

### 案例 3：在循环中通过 SSH 执行远程命令

`ssh` 命令默认会读取整个标准输入。如果你在一个普通的 `while read` 循环里写 `ssh`，它会把你的文件内容全部“吸走”，导致循环只运行一次。



```bash
#!/bin/bash

# 使用 FD 3 读取服务器列表，防止 ssh 吸走 stdin 中的后续行
while read -u 3 -r host; do
    echo "=== 检查服务器: $host ==="
    # ssh 现在不会干扰循环的读取流
    ssh "$host" "uptime"
done 3< servers.list
```

------

### 为什么使用 3-9 之间的数字？

- `0`: 标准输入 (stdin)
- `1`: 标准输出 (stdout)
- `2`: 标准错误 (stderr)
- **`3-9`**: 是 Bash 留给用户自定义使用的临时文件描述符。

### 总结表格：`-u` 选项的优势

| **特性**   | **说明**                                              |
| ---------- | ----------------------------------------------------- |
| **独立性** | 让 `read` 摆脱对标准输入（FD 0）的依赖。              |
| **并行性** | 允许在一个循环内同时处理多个数据流。                  |
| **稳定性** | 防止循环体内部的外部命令（ssh, ffmpeg等）误读数据流。 |
| **清晰度** | 在复杂脚本中明确数据来源。                            |

**你是否遇到了循环只跑一次就退出的情况？通常那就是因为没有使用 `-u` 分离输入流导致的。**

## IFS

IFS基本作用

```bash
# 构造数组
# cxxu@CxxuDesk 10:34:47> <~>
$ fa=(*)
# cxxu@CxxuDesk 10:35:02> <~>
$ declare -p fa
declare -a fa=([0]="afile" [1]="archived" [2]="ble.sh" [3]="err.log" [4]="file" [5]="file2" [6]="file.txt" [7]="output.log" [8]="proud2.log" [9]="proud.log" [10]="sh")

# 指定IFS为`:`
# cxxu@CxxuDesk 10:35:09> <~>
$ IFS=:
# 用':'作为分隔符链接数组中的元素
# cxxu@CxxuDesk 10:39:54> <~>
$ echo "${fa[*]}"
afile:archived:ble.sh:err.log:file:file2:file.txt:output.log:proud2.log:proud.log:sh
```

```bash
$ IFS='|'; echo "${fa[*]}"
afile|archived|ble.sh|err.log|file|file2|file.txt|output.log|proud2.log|proud.log|sh
# cxxu@CxxuDesk 10:47:35> <~>
$ IFS=';'; echo "${fa[*]}"
afile;archived;ble.sh;err.log;file;file2;file.txt;output.log;proud2.log;proud.log;sh

# cxxu@CxxuDesk 10:47:47> <~>
$ IFS='|' echo "${fa[*]}"
afile;archived;ble.sh;err.log;file;file2;file.txt;output.log;proud2.log;proud.log;sh
```

独立赋值语句（前两个例子）**动作**：先修改了当前 Shell 环境中的 `IFS` 变量，**然后**执行 `echo`。

**结果**：`IFS` 的改变是永久性的（直到下次修改），所以 `echo` 时数组会按新 `IFS` 连接。

命令前缀赋值（第三个例子）**动作**：这是一个**“临时环境变量”语法**。它本意是：**仅在执行后面那个命令的过程中**改变环境变量。

**失效原因**：

1. **解析顺序**：Bash 在真正执行 `echo` 之前，会先进行 **参数扩展（Parameter Expansion）**。
2. 也就是说，在 `IFS='|'` 生效之前，`${fa[*]}` 已经被当前环境（此时 `IFS` 还是上一步设置的 `;`）解析成了 `afile;archived;...`。
3. 当 `echo` 拿到解析好的字符串准备运行时，临时修改的 `IFS='|'` 才进入 `echo` 的环境，但此时已经晚了，字符串已经生成。

使用子shell可以解决此问题(其实是在子shell中使用`VAR=var;`的语法而不是`VAR=var command`的语法,子shell中更改`IFS`不会影响到父shell,以此模拟临时环境变量更改)

```bash
# 括号会创建一个子进程，里面的 IFS 修改不会泄露到外面
(IFS='|'; echo "${fa[*]}")

# 此时验证，全局 IFS 依然没变
echo "$IFS"
```

### 临时环境变量

临时变量语法在以下两种场景中非常强大：

A. 影响命令的内部行为（最常用）

B. 影响内置命令读取数据的行为

虽然 `echo` 这样的命令无效，但像 `read` 这种在**执行阶段**才处理数据的命令是有效的

> ```bash
> # cxxu@CxxuDesk 11:24:49> <~>
> $ IFS=':' read -r user pass uid gid <<< "root:x:0:0"
> # cxxu@CxxuDesk 11:25:06> <~>
> $ echo $user
> root
> ```
>
> 然而下面的写法不能达到上述预期,因为使用了管道符,开辟了子shell,父shell无法访问user等变量
>
> ```bash
> # cxxu@CxxuDesk 11:20:40> <~>
> $ echo "root:x:0:0" | IFS=':' read -r user pass uid gid
> 
> ```
>
> 

当你输入 `VAR=val command` 时(例如`IFS='|' echo ...`，Bash 的处理顺序如下：

1. **参数扩展（Expansion）**：Bash 先扫描命令行，执行参数扩展,例如把 `${var}` 或 `$(cmd)` 替换为具体的值。
2. **环境变量设置**：Bash 为即将运行的命令创建一个新的环境（Environment），并在其中设置 `VAR=val`。
3. **命令执行**：运行 `command`。

```bash
# cxxu@CxxuDesk 10:47:35> <~>
$ IFS=';'; 
# cxxu@CxxuDesk 10:47:47> <~>
$ IFS='|' echo "${fa[*]}"
afile;archived;ble.sh;err.log;file;file2;file.txt;output.log;proud2.log;proud.log;sh
```

因为 `${fa[*]}` 的展开发生在第 1 步，而 `IFS` 的临时赋值发生在第 2 步。当数组被展开时，它使用的是当前 Shell 的全局 `IFS`

### IFS清空

默认情况下， `read` 会修改每行读取的内容，通过 [删除所有前导和尾随的空白字符 ](https://mywiki.wooledge.org/BashFAQ/067)（如果有 spaces 和 tabs 存在于 [IFS](https://mywiki.wooledge.org/IFS) 中）。

如果不需要这种处理，可以**将 `IFS` 变量清空(执行`IFS=`)，如上面的例子所示**。如果您想要进行修剪(或者不在意空格)，请保留 `IFS`,让读入的内容更紧凑 ：

```bash
# Leading/trailing whitespace trimming.
while read -r line; do
  printf '%s\n' "$line"
done < "$file"
```



如果字段分隔符不是空白字符，您可以设置 [IFS（内部字段分隔符）](https://mywiki.wooledge.org/IFS)：

```bash
# Extract the username and its shell from /etc/passwd:
while IFS=: read -r user pass uid gid gecos home shell; do
  printf '%s: %s\n' "$user" "$shell"
done < /etc/passwd
```

### 遍历行时解析字段

如果您想对每行中的各个字段进行操作，可以向 `read` 提供额外的变量：

```bash
# Input file has 3 columns separated by white space (space or tab characters only).
while read -r first_name last_name phone; do
  # Only print the last name (second column)
  printf '%s\n' "$last_name"
done < "$file"
```

具体的例子:

准备一个文本文件`table-s1.conf`,里面包含若干行内容

```bash
$ cat -n ./table-s1.conf 
     1  d1.com  user1   4.es
     2  d2.com      user2       6.us
     3  d3.com      john        6.us
```

我们尝试使用`while read -r... < file`的方式读取其中的每一行

```bash
$ while read -r site owner template ;do printf '%s->%s\n' "$site" "$owner" ;done < ./table-s1.conf 
#output:发现最后一行没有被解析输出
d1.com->user1
d2.com->user2
```



使用更加健壮的方式处理`|| [[ -n "$site" ]]`

```bash
$ while read -r site owner template || [[ -n "$site" ]]; do
    printf '%s->%s\n' "$site" "$owner"
done < table-s1.conf
d1.com->user1
d2.com->user2
d3.com->john
```

这里选择判断read列出的变量中的第一个变量`site`,而不是其他变量

如果读取的行包含非空字符,则bash分隔后优先会分配非空字符给第一个变量,如果连第一个变量都是空的,那么该行就是空的.

而如果是其他变量,就无法具此代表性.

### 自定义IFS

对于**制表符分隔**的文件，使用 [IFS=$'\t'](https://mywiki.wooledge.org/Quotes)，不过要注意的是，输入中的多个制表符会被视为 **一个** 分隔符

> （并且 Ksh93/Zsh 中的 `IFS=$'\t\t'` 巧妙解决方法在 Bash 中不起作用）。

你不一定需要知道每一行输入包含多少个字段。

- **如果你提供的变量数量多于字段数，多余的变量将为空**。
- 如果你提供的变量数量少于字段数，最后一个变量将获得前面变量满足后**剩下的所有字段**。

例如，

```bash
# Bash
IFS=$' \t\n'
read -r first last junk <<< 'Bob Smith 123 Main Street Elk Grove Iowa 123-555-6789'
printf "%s\n%s\n%s\n" "$first" "$last" "$junk"
# first will contain "Bob", and last will contain "Smith".
# junk holds everything else.
```

```bash
$ IFS=$' \t\n'
read -r first last junk <<< 'Bob Smith 123 Main Street Elk Grove Iowa 123-555-6789'
$ printf " first=%s\n last=%s\n junk=%s\n" "$first" "$last" "$junk"

#output:
 first=Bob
 last=Smith
 junk=123 Main Street Elk Grove Iowa 123-555-6789

```

### 丢弃变量`_`(throwaway variable /junk variable)

有些人使用丢弃变量 `_` 作为“垃圾变量”来忽略字段。

它（或者任何其他变量）也可以在单个 `read` 命令中使用多次，如果我们不关心它接收的内容：

 

```bash
# Bash
read -r _ _ first middle last _ <<< "$record"

# We skip the first two fields, then read the next three.
# Remember, the final _ can absorb any number of fields.
# It doesn't need to be repeated there.
```



请注意，这种 `_` 的使用方式**只在 Bash 中得到保证**。许多其他 shell 将 `_` 用于其他目的，这可能会导致此方法达不到预期效果，甚至完全破坏脚本。即使 `_` 是 Bash 中常见的惯例，最好还是选择一个在脚本其他地方未被使用的独特变量。

### 跳过`#`开头的行

如果希望避免以 `#` 开头的注释，你可以在循环中简单地跳过它们：

```bash
# Bash/
while read -r line; do
  [[ $line = \#* ]] && continue
  printf '%s\n' "$line"
done < "$file"
```

上面 `read` 会移除行首和行尾的空格或制表符（假设 `IFS` 未被修改为默认值），因此我们只需要在（现在已修剪过的）行的开头查找 `#` 。为了保留空格：

 

```bash
# Bash
while IFS= read -r line; do
  [[ $line = *([[:blank:]])\#* ]] && continue
  printf '%s\n' "$line"
done < "$file"
```



在较旧版本的 Bash 中，你需要 `shopt -s extglob` 以便 `*(...)` [扩展通配符 ](https://mywiki.wooledge.org/glob#extglob)可用。在较新的版本中，它们始终可用，用于 `=` / `==` / `!=` 模式匹配操作符的 `[[ ... ]]` 构造。



### 输入源选择



重定向 [redirection](https://mywiki.wooledge.org/BashGuide/InputAndOutput#Redirection) `< "$file"` 告诉 `while` 循环从变量 `file` 中存储的文件名读取。如果你更倾向于使用字面路径名而不是变量，你也可以这样做。如果你的输入源是脚本的标准输入，那么根本不需要任何重定向。

如果你的输入源是变量/参数的内容，bash 可以使用 [here string](https://mywiki.wooledge.org/BashGuide/InputAndOutput#Heredocs_And_Herestrings) 来迭代其行：



 

```bash
while IFS= read -r line; do
  printf '%s\n' "$line"
done <<< "$var"
```



在任何 Bourne 类型的 shell 中，都可以使用 "here document"（尽管 `read -r` 是 POSIX，而不是 Bourne）来实现相同的功能。



 

```bash
while IFS= read -r line; do
  printf '%s\n' "$line"
done <<EOF
$var
EOF
```



也可以从命令而不是普通文件中读取：



 

```bash
some command | while IFS= read -r line; do
  printf '%s\n' "$line"
done
```



此方法对于处理使用一组命令对 [find](https://mywiki.wooledge.org/UsingFind) 的输出特别有用：



 

```bash
   1 find . -type f -print0 | while IFS= read -r -d '' file; do
   2     dir=${file%/*} base=${file##*/}
   3     mv "$file" "$dir/${base// /_}"
   4 done
```



这会从 `find` 命令中每次读取一个文件名，并 [重命名文件 ](https://mywiki.wooledge.org/BashFAQ/030)，将其基础名中的空格替换为下划线。

注意在 `find` 命令中使用 `-print0` 的方式，该命令使用空字节作为文件名分隔符；在 `read` 命令中使用 `-d ''` 来指示它将所有文本读入 `file` 变量，直到遇到空字节为止。默认情况下， `find` 和 `read` 使用换行符来分隔其输入；然而，由于文件名本身可能包含换行符，这种默认行为会在换行处分割文件名，导致循环体失败。此外，还需要将 `IFS` 设置为空字符串，否则 `read` 仍会去除首尾的空白（使用 `IFS` 的默认值）。如需更多细节，请参见 [FAQ #20](https://mywiki.wooledge.org/BashFAQ/020)。

使用管道将 `find` '的输出传入一个 `while` 循环中，会使循环处于一个子 shell 中，这意味着你在循环中所做的任何状态更改（改变变量、 `cd` 、打开和关闭[文件](https://mywiki.wooledge.org/FileDescriptor)等）在循环结束后都会丢失。为了避免这种情况，你可以使用进程替换：[ProcessSubstitution](https://mywiki.wooledge.org/ProcessSubstitution)：



 

```bash
linecount=0

while IFS= read -r line; do
  linecount=$((linecount + 1))
done < <(some command)

printf 'total lines: %d\n' "$linecount"
```



参见 [FAQ 24](https://mywiki.wooledge.org/BashFAQ/024) 了解更多讨论。



### 文件末尾缺少换行符的情况

可以在while的条件语句部分使用`|| [[ -n "$line" ]]`兼容文件末尾缺少换行的情况.

```bash
while IFS= read -r line || [[ -n "$line" ]]; do
  printf '%s\n' "$line"
done < "$file"
```

也可以考虑将额外的判断放到循环体后面,但是不够紧凑

```bash
# Emulate cat
while IFS= read -r line; do
   printf '%s\n' "$line"
done < "$file"
[[ -n "$line" ]] && printf %s "$line"
```

记得使用引号包裹行变量有关原因的解释，请参见 [引号 ](https://mywiki.wooledge.org/Quotes)或 [参数 ](https://mywiki.wooledge.org/Arguments)。

> 特别是 [参数 ](https://mywiki.wooledge.org/Arguments)页面，是非常重要的总结。

其他方案:

> 简单起见,使用`printf`模拟文件内容传递包含`\n`(多行字符串,但是结尾不以`\n`结束)的字符串
>
> 下面到两个示例都是用了`|`来接受`printf`的输出,作为read的输入(但是注意管道符会引起子shell的开辟,使得子shell中的变量在结束/退出子shell后无法被引用)

```bash
# This does not work:
printf 'line 1\ntruncated line 2' | while read -r line; do
  echo $line
done
#output:
line1

# This does not work either:(这个例子对read告知IFS清空)
printf 'line 1\ntruncated line 2' | while IFS= read -r line; do
  echo "$line"
done
#仍只是打印line1
#且由于管道符开辟的子shell在while结束后无法获取有效的line变量内容,此时line是未定义的.
[[ $line ]] && echo -n "$line"
# output:如果$line在当前shell进程之前定义过,则打印的是之前的内容,否则为空

```

对于上述第二个示例为何不符合预期的讨论，请参见 [子shell变量问题](https://mywiki.wooledge.org/BashFAQ/024)。

> 我在一个管道中的循环里设置了变量。为什么这些变量在循环结束后就消失了？或者，为什么我不能将数据通过管道传递给 read 命令？在大多数 shell 中，管道中的每个命令都会在独立的 [SubShell](https://mywiki.wooledge.org/SubShell) 中执行,每个 [SubShell](https://mywiki.wooledge.org/SubShell) 都会引入一个新的变量上下文和环境。

```bash
# This works:(这里也是使用了管道符,但是我们把[[ ]]判断语句移动到了管道符中的命令分组中,使得$line可以被最后的语句所访问)
printf 'line 1\ntruncated line 2' | {
  while IFS= read -r line; do
    echo "$line"
  done
  [[ $line ]] && echo "$line"
}
```

当然,最简单的方案是在 while 测试中添加一个逻辑或运算符：

 

```bash
while IFS= read -r line || [[ -n $line ]]; do
  printf '%s\n' "$line"
done < "$file"
```

例如

```bash
printf 'line 1\ntruncated line 2' | while IFS= read -r line || [[ -n $line ]]; do
  echo "$line"
done

# output
line 1
truncated line 2
```



### 如何防止其他命令“消耗”输入



有些命令会贪婪地读取标准输入中的所有可用数据。上面的例子没有防范这类程序。例如，

 

```bash
   1 while IFS= read -r line; do
   2   cat > ignoredfile
   3   printf '%s\n' "$line"
   4 done < "$file"
```



只会打印第一行的内容，其余内容则被送往"ignoredfile"，因为 `cat` 会读取所有可用输入。

一个变通的方法是使用一个数字 [FileDescriptor](https://mywiki.wooledge.org/FileDescriptor) 而不是标准输入：

 

```bash
# Bash
while IFS= read -r -u 9 line; do
  cat > ignoredfile
  printf '%s\n' "$line"
done 9< "$file"

# Note that read -u is not portable to every shell.
# Use a redirect to ensure it works in any POSIX compliant shell:
while IFS= read -r line <&9; do
  cat > ignoredfile
  printf '%s\n' "$line"
done 9< "$file"
```



或者：

 

```bash
exec 9< "$file"
while IFS= read -r line <&9; do
  cat > ignoredfile
  printf '%s\n' "$line"
done
exec 9<&-
```



这个例子会在每次循环中等待用户在文件 `ignoredfile` 中输入内容，而不是一次性读取循环的输入。

例如，当你使用 `mencoder` 时，如果存在用户输入，它会接受输入，否则会静默继续。其他具有类似行为的命令包括 `ssh` 和 `ffmpeg` 。关于此问题的更多解决方法，请参见 [FAQ #89](https://mywiki.wooledge.org/BashFAQ/089)。

在使用 `while read` 循环处理文件或字符串时，由于 Bash 的一些特性（如空白字符处理、反斜杠转义、子 Shell 作用域等），如果不注意细节，经常会导致逻辑错误。

## while read 总结

以下是使用 `while read` 的核心注意事项和最佳实践,尤其注意while read在读取其他平台创建的**文本文件最后一行丢失**的问题.

### 1. 始终使用 `-r` 参数

这是最常见的坑。默认情况下，`read` 会把反斜杠 `\` 当作转义字符。

- **现象**：如果文件中有一行是 `C:\Windows`，不加 `-r` 会变成 `C:Windows`。
- **对策**：除非你真的需要转义，否则永远使用 `while read -r line`。

### 2. 谨慎处理行首位空白（IFS 变量）

`read` 命令默认会根据环境变量 `IFS`（Internal Field Separator）修剪掉行首和行尾的空格或 Tab。

- **现象**：原文件行是 `"  hello  "`，读取后变量变成了 `"hello"`。

- **对策**：如果需要保留原样，在 `read` 前将 `IFS` 置为空：

  ```bash
  while IFS= read -r line; do
      echo "$line"
  done < file.txt
  ```

### 3. 避免“最后一行丢失”问题🎈

标准的 Linux 文件应该以换行符（Newline）结尾，但很多 **Windows 产生**的文件或**手动编辑**的文件**最后一行可能没有换行符**。

- **现象**：`while read` 循环在读到最后一行时，因为没有发现 `\n`，`read` 会**返回非零状态码**，导致循环直接跳出，**最后一行没被处理**。(但是此时最后一行也被读取到read指定的变量中了)

- **对策**：在 `read` 失败后检查变量是否有内容,配合`||`,当`read -r line`返回非零状态码时(异常退出)继续检查刚才所读取的行是否非空,如果非空,继续处理(比如打印)：

  ```bash
  while read -r line || [[ -n "$line" ]]; do
      echo "$line"
  done < file.txt
  ```

`[[ -n "$string" ]]`可以检查string是否为空

### 4. 优先使用重定向而非管道（作用域问题）

这是你在处理变量时最容易遇到的逻辑错误。

- **错误做法（管道）**：

  

  ```bash
  count=0
  cat file.txt | while read -r line; do
      ((count++))
  done
  echo $count  # 结果为 0！因为管道创建了子 Shell，变量无法传回。
  ```

- **正确做法（重定向）**：

  ```bash
  count=0
  while read -r line; do
      ((count++))
  done < file.txt
  echo $count  # 结果正确。
  ```

### 5. 处理结构化数据（如 CSV）

`read` 可以直接通过 `IFS` 将一行数据拆分到多个变量中。

- **技巧**：

  ```bash
  # 假设文件内容是：user:password:uid
  while IFS=':' read -r username password uid; do
      echo "用户 $username 的 ID 是 $uid"
  done < /etc/passwd
  ```

### 6. 循环内的标准输入冲突

如果 `while` 循环在读取文件的同时，循环体内部也有命令需要读取标准输入（如 `ssh`, `ffmpeg`, `read` 确认提示），会导致竞争。

- **现象**：循环只运行了一次就莫名其妙退出了，因为内部的命令把文件的后续内容全部“吸走”了。

- **对策**：

  - **方法 A**：给内部命令重定向输入 `/dev/null`，例如 `ssh user@host "cmd" < /dev/null`。

  - **方法 B**：给文件读取**分配独立的文件描述符**：

    ```bash
    while read -u 3 -r line; do
        read -p "确认处理 $line 吗? (y/n)" user_input < /dev/tty
    done 3< file.txt
    ```

## 将文件内容读取到变量中

对于读取文件为一个字符串,使用`cat`是最常见的方法.不过bash本身也可以直接读取一整个文件,借助于`$(<file)`语法.

对于逐行读取的需求,除了使用`while read` 组合命令,使用`mapfile` 也是一种常见的读取文件的方法.

两种方法各有优缺点.

| **特性**     | **while read 循环**            | **mapfile 命令**                       |
| ------------ | ------------------------------ | -------------------------------------- |
| **执行速度** | 较慢（适合小文件或复杂逻辑）   | 极快（批量 I/O）                       |
| **内存占用** | 极低（逐行读取）               | 高（取决于文件大小）                   |
| **适用场景** | **需要边读边处理，且文件巨大** | **快速加载配置、名单或处理中小型文件** |
| **代码量**   | 较多                           | 极少                                   |

### 读取为单个字符串

使用cat命令,这是最直观的方法，但在处理大文件时略慢，因为它会开启一个子进程。

```bash
content=$(cat test.txt)
echo "$content"
```

这是 Bash 的内置技巧，比 `cat` 更快，因为它不产生子进程。

```bash
# < 符号直接将文件内容读入变量
content=$(<test.txt)
echo "$content"
```

### 读取文件的第一行

如果你只需要获取文件的首行内容（例如读取版本号或配置文件首行），可以使用 `read` 命令。

```bash
# 从 test.txt 中读取第一行并赋值给变量 line
read -r line < test.txt
echo "第一行内容是: $line"
```

### 逐行读取

如果文件非常大，一次性存入变量会消耗大量内存。此时应使用 `while` 循环配合 `read` 逐行处理。

```bash
while IFS= read -r line; do
    echo "当前行内容: $line"
    # 你可以在这里对每一行进行操作
done < test.txt
```

`IFS=`：防止行首和行尾的空格被过滤掉。

`read -r`：防止反斜杠转义(斜杠丢弃),原样读取输入。

### 读取各行到数组中(mapfile)🎈

如果你想把文件的每一行分别存为数组的一个元素，可以使用 `mapfile`。

`mapfile`（也称为 `readarray`）是 Bash 4.0 版本引入的一个非常强大的内置命令。它的核心作用是：**将文件的内容或命令的输出直接读入到一个 Bash 数组中**。

相比于传统的 `while read` 循环，`mapfile` 的执行速度极快，因为它是内置处理，大大减少了在 Shell 中循环迭代的开销。

```bash
# 将 test.txt 的每一行读入名为 my_array 的数组
mapfile -t my_array < test.txt

# 访问数组
echo "第一行: ${my_array[0]}"
echo "第二行: ${my_array[1]}"
```

```bash
$ help mapfile
mapfile: mapfile [-d delim] [-n count] [-O origin] [-s count] [-t] [-u fd] [-C callback] [-c quantum] [array]
    Read lines from the standard input into an indexed array variable.

    Read lines from the standard input into the indexed array variable ARRAY, or
    from file descriptor FD if the -u option is supplied.  The variable MAPFILE is the default ARRAY.
```

| **参数**        | **描述**                                                     |
| --------------- | ------------------------------------------------------------ |
| **`-t`**        | **最常用**。移除每行末尾的换行符。如果不加，数组每个元素末尾都会带一个 `\n`。 |
| **`-n count`**  | 限制读取的行数（例如只读取前 10 行）。                       |
| **`-s count`**  | 跳过开头的指定行数。                                         |
| **`-O origin`** | 指定从数组的哪个索引开始写入（默认为 0）。                   |
| **`-u fd`**     | 从指定的文件描述符中读取。                                   |
| **`-d delim`**  | 指定行分隔符（默认是换行符，Bash 4.4+ 支持）。               |

分块处理 (Callback)

`mapfile` 还有一个独特的功能 `-C` 和 `-c`，可以每读取一定行数就执行一个回调函数。



```bash
# 每读取 3 行执行一次 echo 命令
callback() {
    echo "--- 已处理 3 行 ---"
}

mapfile -t -c 3 -C callback < big_file.txt
```

#### mapfile读取windows平台创建的文件(CRLF)文件

如果需要移除`\r`,可以使用如下方法

```bash
mapfile -t BLACKLIST < <(tr -d '\r' < "$BLACKLIST_FILE")
```



## 总结模板

建议在编写脚本时，直接套用这个“最稳健”的模板：

```bash
while IFS= read -r line || [[ -n "$line" ]]; do
    # 你的逻辑
done < "filename.txt"
```

如果你需要处理非常庞大的文件（GB级别），这种原生的 Bash 循环可能会比较慢，届时我们可以讨论如何结合 `awk` 来提升效率。