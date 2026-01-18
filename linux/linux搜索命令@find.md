[toc]



## references

-  [How to Use the find Command in Linux](https://www.howtogeek.com/771399/how-to-use-the-find-command-in-linux/ "How to Use the find Command in Linux")

* [Linux Find Command | How does Linux Find Command work? (educba.com)](https://www.educba.com/linux-find-command/)
* [Mommy, I found it! — 15 Practical Linux Find Command Examples (thegeekstuff.com)](https://www.thegeekstuff.com/2009/03/15-practical-linux-find-command-examples/)

`find` 是 Linux 中强大的文件查找工具，可以基于文件名、类型、大小、时间等多种条件搜索文件，并配合其他命令进行批量处理。

[实用教程find 进阶用法](https://mp.weixin.qq.com/s/4kB-CL7ErMZTCkiUNzmrWA)

现代化版本find竞品fd:[sharkdp/fd: A simple, fast and user-friendly alternative to 'find'](https://github.com/sharkdp/fd)

------

## 命令行语法

`find` 命令的用法如下：

```bash
Usage: find [-H] [-L] [-P] [-Olevel] [-D debugopts] [path...] [expression]
Default path is the current directory; default expression is -print.
```

不使用参数时,默认查找当前工作目录,递归查找

注意,path(路径参数是位置参数,不需要也没有前导的选项来引出path参数),并且根据语法标记`[path...]`可知,find命令允许不传入path或者传入多个path

### 简介

将语法分为三部分:

1. `[-H] [-L] [-P] [-Olevel] [-D debugopts] `(比较少用)
2. `[path...]`指定要查找的目录,可以连续指定多个,空格隔开
3. ` [expression]`指定查找条件表达式,比如指定递归深度,或者要求文件或目录具有特定格式的名字

### 简单查找案例🎈

```bash
find . -maxdepth 1 -name "*.sh"
```



1. 回看语法中选项`[-H] [-L] [-P] [-Olevel] [-D debugopts] `,上述例子中没有启用
2. 例子中第一个参数就是路径`path`,经常是`.`(默认查找路径),它表示当前目录
3. `-maxdepth 1 -name "*.sh"`是对应的`[expression]`,注意通常用`''`或`""`来包裹`-name`参数防止shell识别错误

另一个搜索并删除文件的例子

```
fin
```

expression内容较多,后文解释

### 选项解释：

- `-H`：如果遇到符号链接（symlink），则仅跟随命令行参数中指定的符号链接，而不会跟随 `find` 过程中遇到的符号链接。

- `-L`：跟随符号链接，即 `find` 会解析并进入符号链接指向的目录或文件。

- `-P`：默认行为，不跟随符号链接，`find` 仅按路径名处理符号链接，而不会解析它们。

- `-Olevel`：优化级别，`level` 可选 `0-3`，数值越大，执行速度越快，但占用的资源可能更多。

- ```
  -D debugopts
  ```

  ：启用调试模式，

  ```
  debugopts
  ```

   选项可选：

  - `exec`：显示 `-exec` 或 `-ok` 执行的命令。
  - `tree`：显示 `find` 的目录遍历结构。
  - `stat`：显示 `find` 如何对文件调用 `stat()`。
  - `rates`：显示 `find` 处理文件的速率信息。

- `[path...]`：指定搜索路径，默认是当前目录 (`.`)。

- `[expression]`：指定搜索条件，如 `-name`、`-type`、`-size` 等。



## expressions

```bash


Expression may consist of: operators, options, tests, and actions.

Operators (decreasing precedence; -and is implicit where no others are given):
      ( EXPR )   ! EXPR   -not EXPR   EXPR1 -a EXPR2   EXPR1 -and EXPR2
      EXPR1 -o EXPR2   EXPR1 -or EXPR2   EXPR1 , EXPR2

Positional options (always true):
      -daystart -follow -nowarn -regextype -warn

Normal options (always true, specified before other expressions):
      -depth -files0-from FILE -maxdepth LEVELS -mindepth LEVELS
       -mount -noleaf -xdev -ignore_readdir_race -noignore_readdir_race

Tests (N can be +N or -N or N):
      -amin N -anewer FILE -atime N -cmin N -cnewer FILE -context CONTEXT
      -ctime N -empty -false -fstype TYPE -gid N -group NAME -ilname PATTERN
      -iname PATTERN -inum N -iwholename PATTERN -iregex PATTERN
      -links N -lname PATTERN -mmin N -mtime N -name PATTERN -newer FILE
      -nouser -nogroup -path PATTERN -perm [-/]MODE -regex PATTERN
      -readable -writable -executable
      -wholename PATTERN -size N[bcwkMG] -true -type [bcdpflsD] -uid N
      -used N -user NAME -xtype [bcdpfls]

Actions:
      -delete -print0 -printf FORMAT -fprintf FILE FORMAT -print
      -fprint0 FILE -fprint FILE -ls -fls FILE -prune -quit
      -exec COMMAND ; -exec COMMAND {} + -ok COMMAND ;
      -execdir COMMAND ; -execdir COMMAND {} + -okdir COMMAND ;

Other common options:
      --help                   display this help and exit
      --version                output version information and exit

Valid arguments for -D:
exec, opt, rates, search, stat, time, tree, all, help
Use '-D help' for a description of the options, or see find(1)

Please see also the documentation at https://www.gnu.org/software/findutils/.
You can report (and track progress on fixing) bugs in the "find"
program via the GNU findutils bug-reporting page at
https://savannah.gnu.org/bugs/?group=findutils or, if
you have no web access, by sending email to <bug-findutils@gnu.org>.
```

这段文档是对 `find` 命令表达式的详细说明，描述了它的组成部分、选项、操作符、测试条件、动作以及一些常见的命令行选项。以下是对这段文本的翻译与解释：

------

### **表达式的组成部分**

表达式可以由以下几部分组成：

- 操作符（`operators`）
- 选项（`options`）
- 测试（`tests`）
- 动作（`actions`）

### **操作符**（从高到低优先级；如果没有给定其他操作符，`-and` 被默认隐含）

- `( EXPR )`：括号可以用来组合多个表达式。
- `! EXPR` 或 `-not EXPR`：取反（表示“非”操作），对表达式的结果取反。
- `EXPR1 -a EXPR2` 或 `EXPR1 -and EXPR2`：逻辑与，要求两个子表达式都为真。
- `EXPR1 -o EXPR2` 或 `EXPR1 -or EXPR2`：逻辑或，只需要其中一个子表达式为真。
- `EXPR1 , EXPR2`：按顺序依次执行，先执行 `EXPR1`，然后执行 `EXPR2`。

### **位置选项**（总是为真）

这些选项总是返回 `true`，用于指定全局设置，通常不会影响后续的条件测试。

- `-daystart`：以当前一天的起始时刻作为文件的时间基准，而不是当前时刻。
- `-follow`：跟随符号链接，递归访问符号链接的目标文件。
- `-nowarn`：禁用警告信息。
- `-regextype`：指定正则表达式类型。
- `-warn`：启用警告信息。

### **常规选项**（总是为真，且必须在其他表达式之前指定）

这些选项通常用于控制搜索行为或限制搜索范围。

- `-depth`：深度优先遍历，先处理子目录，再处理父目录。
- `-files0-from FILE`：从指定的文件中读取文件名，文件名以 null 字符 (`\0`) 结束。
- `-maxdepth LEVELS`：限制搜索的最大深度，`LEVELS` 是深度的数量。
- `-mindepth LEVELS`：指定搜索的最小深度。
- `-mount`：限制查找仅在当前挂载点内进行，不跨越文件系统边界。
- `-noleaf`：关闭对文件系统叶子节点优化的假设。
- `-xdev`：限制查找仅在当前文件系统内，避免跨文件系统查找。
- `-ignore_readdir_race`：忽略目录读取竞争（例如，目录的内容在搜索过程中被修改）。
- `-noignore_readdir_race`：不忽略目录读取竞争。

### **测试条件**（`N` 可以是 `+N`、`-N` 或 `N`，表示时间范围）

- `-amin N`：查找最后访问时间在 `N` 分钟前的文件。
- `-anewer FILE`：查找自 `FILE` 之后被访问过的文件。
- `-atime N`：查找最后访问时间在 `N` 天前的文件。
- `-cmin N`：查找最后状态更改时间在 `N` 分钟前的文件。
- `-cnewer FILE`：查找自 `FILE` 之后更改状态的文件。
- `-context CONTEXT`：查找符合特定 SELinux 上下文的文件。
- `-ctime N`：查找最后状态更改时间在 `N` 天前的文件。
- `-empty`：查找空文件或空目录。
- `-false`：始终返回 `false`，不匹配任何文件。
- `-fstype TYPE`：查找文件系统类型为 `TYPE` 的文件。
- `-gid N`：查找具有给定组 ID 的文件。
- `-group NAME`：查找属于指定组的文件。
- `-ilname PATTERN`：查找符合不区分大小写的文件名模式的文件。
- `-iname PATTERN`：查找符合不区分大小写的文件名模式的文件。
- `-inum N`：查找 inode 号为 `N` 的文件。
- `-iwholename PATTERN`：查找符合不区分大小写的完整路径模式的文件。
- `-iregex PATTERN`：查找符合不区分大小写的正则表达式模式的文件。
- `-links N`：查找硬链接数为 `N` 的文件。
- `-lname PATTERN`：查找符号链接匹配模式的文件。
- `-mmin N`：查找最后修改时间在 `N` 分钟前的文件。
- `-mtime N`：查找最后修改时间在 `N` 天前的文件。
- `-name PATTERN`：查找文件名匹配模式的文件。
- `-newer FILE`：查找修改时间在 `FILE` 之后的文件。
- `-nouser`：查找没有有效用户 ID 的文件。
- `-nogroup`：查找没有有效组 ID 的文件。
- `-path PATTERN`：查找路径名匹配模式的文件。
- `-perm [-/]MODE`：查找文件权限匹配指定模式的文件。
- `-regex PATTERN`：查找符合正则表达式模式的文件。
- `-readable`：查找可读的文件。
- `-writable`：查找可写的文件。
- `-executable`：查找可执行的文件。
- `-wholename PATTERN`：查找完整路径名匹配模式的文件。
- `-size N[bcwkMG]`：查找文件大小为 `N` 的文件，单位可以是字节（b）、字符（c）、千字节（k）、兆字节（M）或吉字节（G）。
- `-true`：始终返回 `true`，匹配所有文件。
- `-type [bcdpflsD]`：查找特定类型的文件，例如块设备（b）、字符设备（c）、目录（d）、符号链接（l）、套接字（s）等。
- `-uid N`：查找用户 ID 为 `N` 的文件。
- `-used N`：查找最近 `N` 分钟内被使用过的文件。
- `-user NAME`：查找指定用户拥有的文件。
- `-xtype [bcdpfls]`：查找特定类型的符号链接目标。

### **动作**：

动作定义了 `find` 查找结果后应该执行的操作。

- `-delete`：删除查找到的文件。
- `-print0`：打印文件路径，并使用 null 字符（`'\0'`）分隔文件名，适用于处理带有空格的文件名。
- `-printf FORMAT`：根据指定格式打印查找到的文件信息。
- `-fprintf FILE FORMAT`：将文件信息以指定格式输出到文件。
- `-print`：打印文件路径。
- `-fprint0 FILE`：将文件路径以 null 字符（`'\0'`）分隔输出到指定文件。
- `-fprint FILE`：将文件路径输出到指定文件。
- `-ls`：列出文件的详细信息（类似 `ls -l`）。
- `-fls FILE`：将文件的详细信息输出到指定文件。
- `-prune`：剪除符合条件的目录，避免进一步搜索。
- `-quit`：在找到第一个匹配的文件后停止查找。
- `-exec COMMAND ;`：对查找到的每个文件执行指定的命令。
- `-exec COMMAND {} +`：与 `-exec` 类似，但批量处理文件。
- `-ok COMMAND ;`：对查找到的每个文件执行指定命令，并在执行之前询问用户确认。
- `-execdir COMMAND ;`：在查找文件的目录中执行命令。
- `-execdir COMMAND {} +`：与 `-execdir` 类似，但批量处理文件。
- `-okdir COMMAND ;`：与 `-execdir` 类似，但执行之前会询问用户确认。

### **其他常见选项**：

- `--help`：显示帮助信息并退出。
- `--version`：显示版本信息并退出。

### **有效的 `-D` 参数**：

- `exec`, `opt`, `rates`, `search`, `stat`, `time`, `tree`, `all`, `help`

你可以使用 `-D help` 来查看这些选项的详细描述，或者参考 `find(1)` 手册。

### **报告问题**：

你可以通过访问 [GNU findutils bug-reporting page](https://savannah.gnu.org/bugs/?group=findutils) 来报告问题，或者通过电子邮件发送到 `bug-findutils@gnu.org`。

------

这段文档详细列出了 `find` 命令的所有可用选项和参数，帮助用户灵活使用该命令进行复杂的文件查找和操作。

## 实用部分教程🎈



### 1. 基本语法

```bash
find [搜索目录] [搜索条件] [执行动作]
```

例如：

```bash
find /home -name "*.txt"
```

> 在 `/home` 目录及其子目录中查找所有 `.txt` 文件。

------

### 2. 按文件名查找（`-name` 和 `-iname`）

- **区分大小写查找：**

```bash
find /path/to/search -name "file.txt"
```

- **忽略大小写查找：**

```bash
find /path/to/search -iname "file.txt"
```

- **使用通配符（必须加引号）：**

```bash
find /home -name "*.log"
```

- **查找多个后缀的文件（使用 `-o`）：**

```bash
find /home \( -name "*.log" -o -name "*.txt" \)
```

> `\( ... \)` 用于避免 shell 解析错误。

------

### 3. 按文件(目录)类型查找（`-type`）

- **查找文件：**

```bash
find /home -type f
```

- **查找目录：**

```bash
find /home -type d
```

- **查找符号链接：**

```bash
find /home -type l
```

- **查找设备文件：**

```bash
find /dev -type b   # 块设备
find /dev -type c   # 字符设备
```

------

### 4. 按文件大小查找（`-size`）

- **查找大于 100MB 的文件：**

```bash
find /home -size +100M
```

- **查找小于 10KB 的文件：**

```bash
find /home -size -10k
```

- **查找正好 1GB 的文件：**

```bash
find /home -size 1G
```

> `k` = KB，`M` = MB，`G` = GB。

------

### 5. 按时间查找🎈

#### 按修改时间（`-mtime`）

- **查找 7 天内修改的文件：**

```bash
find /home -mtime -7
```

- **查找 30 天前修改的文件：**

```bash
find /home -mtime +30
```

- **查找 3 天前刚好修改的文件：**

```bash
find /home -mtime 3
```

#### 按访问时间（`-atime`）

- **查找 7 天内访问的文件：**

```bash
find /home -atime -7
```

#### 按更精确的修改时间（`-mmin`）

- **查找 10 分钟内修改的文件：**

```bash
find /home -mmin -10
```

------

### 6. 按用户和权限查找

#### 按所有者查找（`-user`）

- **查找属于 `root` 用户的文件：**

```bash
find /home -user root
```

#### 按用户组查找（`-group`）

- **查找属于 `staff` 组的文件：**

```bash
find /home -group staff
```

#### 按权限查找（`-perm`）

- **查找 `777` 权限的文件（所有用户可读写执行）：**

```bash
find /home -perm 777
```

- **查找至少有 `777` 权限的文件：**

```bash
find /home -perm -777
```

- **查找权限必须完全匹配 `644` 的文件：**

```bash
find /home -perm 644
```

------

### 7. 按深度查找（`-maxdepth` 和 `-mindepth`）🎈

find默认是无限递归查找目录

`-maxdepth` (最大深度)

限制 `find` 向下搜索的最大层级。

- `-maxdepth 0`：只检查命令行参数本身（通常没意义）。
- `-maxdepth 1`：只在当前层级（指定的目录本身）搜索，**不进入任何子目录**。
- `-maxdepth 2`：搜索当前层级及下一级子目录。

`-mindepth` (最小深度)

要求 `find` 在达到指定深度之后才开始搜索。

- `-mindepth 1`：处理除命令行参数（搜索路径本身）之外的所有文件。
- `-mindepth 2`：忽略当前层级的文件，从子目录内部开始搜索。

- **仅查找当前目录（不递归）：**

```bash
find /home -maxdepth 1 -type f
```

- **查找深度至少为 2 的目录（排除顶层）：**

```bash
find /home -mindepth 2 -type d
```

------

### 8. `find` 结合 `exec` 进行批量操作

#### 删除查找到的文件（`exec rm`）

```bash
find /home -name "*.log" -exec rm {} \;
```

> `{}` 代表查找到的文件，`\;` 结束 `exec` 命令。

#### 交互式删除（确认后删除）

```bash
find /home -name "*.log" -ok rm {} \;
```

> `-ok` 作用类似 `-exec`，但会要求确认。

#### 查找 `.log` 文件并移动到 `/backup/`

```bash
find /home -name "*.log" -exec mv {} /backup/ \;
```

#### 查找 `.log` 文件并压缩：

```bash
find /home -name "*.log" -exec gzip {} \;
```

------

### 9. `find` 结合 `xargs`（更高效）

#### 批量删除（比 `-exec` 更快）

```bash
find /home -name "*.log" | xargs rm
```

**处理空格文件名：**

```bash
find /home -name "*.log" -print0 | xargs -0 rm
```

#### 统计所有 `.txt` 文件的行数：

```bash
find /home -name "*.txt" | xargs wc -l
```

------

### 10. `find` 结合 `tar` 批量备份

#### 将 `.log` 文件压缩为 `logs.tar.gz`

```bash
find /home -name "*.log" | tar -czvf logs.tar.gz -T -
```

> `-T -` 让 `tar` 读取 `find` 结果。

------

### 11. 按文件内容查找（`-exec grep`）

#### 在 `.txt` 文件中搜索 "error"

```bash
find /home -name "*.txt" -exec grep "error" {} \;
```

> 查找所有包含 "error" 的 `.txt` 文件。

#### 仅显示匹配的文件：

```bash
find /home -name "*.txt" -exec grep -l "error" {} \;
```

------

### 12. 按空文件和空目录查找

#### 查找空文件：

```bash
find /home -type f -empty
```

#### 查找空目录：

```bash
find /home -type d -empty
```

#### 删除空目录：

```bash
find /home -type d -empty -delete
```

------

## 总结🎈

| 任务                    | 命令                                                |
| ----------------------- | --------------------------------------------------- |
| 按文件名查找            | `find /home -name "*.txt"`                          |
| 忽略大小写查找          | `find /home -iname "*.txt"`                         |
| 查找目录                | `find /home -type d`                                |
| 按大小查找              | `find /home -size +100M`                            |
| 查找 7 天内修改的文件   | `find /home -mtime -7`                              |
| 查找 `root` 用户的文件  | `find /home -user root`                             |
| 查找 `777` 权限的文件   | `find /home -perm 777`                              |
| 限制搜索深度            | `find /home -maxdepth 1`                            |
| 删除 `.log` 文件        | `find /home -name "*.log" -exec rm {} \;`           |
| 交互式删除              | `find /home -name "*.log" -ok rm {} \;`             |
| 结合 `xargs` 删除       | `find /home -name "*.log"`                          |
| 压缩 `.log` 文件        | `find /home -name "*.log" -exec gzip {} \;`         |
| 查找包含 "error" 的文件 | `find /home -name "*.txt" -exec grep "error" {} \;` |
| 查找空文件              | `find /home -type f -empty`                         |
| 删除空目录              | `find /home -type d -empty -delete`                 |

`find` 在 Linux 中极其强大，尤其适用于批量文件管理、定期清理、自动化任务等场景。





## 常见问题FAQ

### 全局参数位置问题

```bash
$ find . -name "*.sh" -maxdepth 1
find: warning: you have specified the global option -maxdepth after the argument -name, but global options are not positional, i.e., -maxdepth affects tests specified before it as well as those specified after it.  Please specify global options before other arguments.
./install_panel.sh
./install.sh
./gitee_install.sh
```

你的 `find` 命令：

```bash
find . -name "*.sh" -maxdepth 1
```

产生了一个警告：

```
find: warning: you have specified the global option -maxdepth after the argument -name, but global options are not positional...
```

这个警告的意思是 **`-maxdepth` 是全局选项（global option），必须放在路径之后，条件之前**。`find` 允许你这样使用，但它会提醒你按照正确的顺序编写命令。

**正确的写法**

```bash
find . -maxdepth 1 -name "*.sh"
```

这样写就不会有警告了，`-maxdepth 1` 先限制搜索深度，然后 `-name "*.sh"` 进行匹配。

**解释**

- `.` 代表当前目录。
- `-maxdepth 1` 限制 `find` 只搜索当前目录，不递归进入子目录。
- `-name "*.sh"` 匹配所有 `.sh` 结尾的文件。

虽然你的原始命令仍然可以执行，但建议按照官方推荐的顺序写，以避免不必要的警告，并使命令更清晰易读。



## find 和硬链接检索

- 所有指向统一个文件的硬链接都具有相同的`inode`

  - 当然,同一文件的所有`symbolic link`和`hard link`都具有一致的`inode`

  - 查看文件的inode号可以通过`ls --inode`

    - ```bash
      $ ls --inode|sort -n
      2533274790464558 dirToSymlinks
      2533274790488885 num
      2533274790919396 words
      3659174697316891 dirTohardlinks
      8725724278214695 name1
      8725724278214695 numbers
      9288674231547765 pip
      ```

      

- 我们只需要根据文件的任意一个硬链接就可以获取文件的`inode`

- 在通过`find -inum`来搜索同一个硬盘分区上的某个文件的所有硬连接(也包括可区分的`symbolic link`)


> 不同于软符号链接(symbolic link),可以通过多个命令来查询
>
> - `ls -l`
>
> - `file`
>
>     
>
> 虽然检索某个文件的所有名称(硬连接)这个需求很少,但也是提供一种方法

- ```bash
  # cxxu_kali @ CxxuWin11 in ~ [8:55:33]
  $ find ./ -inum 8725724278214695 -exec ls -l {} \;
  -rw-r--r-- 3 cxxu_kali cxxu_kali 17 Apr  5 15:33 ./dirTohardlinks/numbers
  -rw-r--r-- 3 cxxu_kali cxxu_kali 17 Apr  5 15:33 ./name1
  -rw-r--r-- 3 cxxu_kali cxxu_kali 17 Apr  5 15:33 ./numbers
  
  # cxxu_kali @ CxxuWin11 in ~ [8:55:38]
  $ find ./ -inum 8725724278214695 -exec ls -l -inum {} \;
  8725724278214695 ./dirTohardlinks/numbers
  8725724278214695 ./name1
  8725724278214695 ./numbers
  #上述指令结果说明,返回的三个文件(名称)都指向同一个文件.
  ```

