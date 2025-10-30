[toc]



---

## 一、基本功能

- 默认情况下，`ls` 列出**当前目录的内容**。
- 若指定文件或目录作为参数，则列出这些文件/目录的信息。
- 默认按**字母顺序排序**（除非使用了 `-cftuvSUX` 或 `--sort` 等选项）。



### `ls`: List directory contents  



The `ls` program lists information about files (of any type, including directories). Options and file arguments can be intermixed arbitrarily, as usual. Later options override earlier options that are incompatible.ls 程序列出有关文件（任何类型，包括目录）的信息。像往常一样，选项和文件参数可以任意混合。后面的选项会覆盖前面不兼容的选项。

For non-option command-line arguments that are directories, by default `ls` lists the contents of directories, not recursively, and omitting files with names beginning with ‘.’. For other non-option arguments, by default `ls` lists just the file name. If no non-option argument is specified, `ls` operates on the current directory, acting as if it had been invoked with a single argument of ‘.’.对于作为目录的非选项命令行参数，默认情况下 ls 会非递归地列出目录的内容，并忽略名称以“.”开头的文件。对于其他非选项参数，默认情况下 ls 仅列出文件名。如果未指定非选项参数，则 ls 将对当前目录进行操作，就像使用单个参数“.”调用它一样。



By default, `ls` lists each directory’s contents alphabetically, according to the locale settings in effect.[3](https://www.gnu.org/software/coreutils/manual/html_node/ls-invocation.html#FOOT3) If standard output is a terminal, the output is in columns (sorted vertically) and control characters are output as question marks; otherwise, the output is listed one per line and control characters are output as-is.默认情况下，ls 根据有效的区域设置按字母顺序列出每个目录的内容。 如果标准输出是终端，则输出按列排列（垂直排序），控制字符输出为问号；否则，每行列出一个输出，并按原样输出控制字符。

Because `ls` is such a fundamental program, it has accumulated many options over the years. They are described in the subsections below; within each section, options are listed alphabetically (ignoring case). The division of options into the subsections is not absolute, since some options affect more than one aspect of `ls`’s operation.因为 ls 是一个非常基础的程序，所以多年来它积累了很多选项。它们在下面的小节中进行了描述；在每个部分中，选项按字母顺序列出（忽略大小写）。将选项划分为小节并不是绝对的，因为某些选项影响 ls 操作的多个方面。



Exit status:退出状态：

```
0 success
1 minor problems  (e.g., failure to access a file or directory not
  specified as a command line argument.  This happens when listing a
  directory in which entries are actively being removed or renamed.)
2 serious trouble (e.g., memory exhausted, invalid option, failure
  to access a file or directory specified as a command line argument
  or a directory loop)
```

Also see [Common options](https://www.gnu.org/software/coreutils/manual/html_node/Common-options.html).另请参阅常用选项。

- [Which files are listed列出了哪些文件](https://www.gnu.org/software/coreutils/manual/html_node/Which-files-are-listed.html)
- [What information is listed列出了什么信息](https://www.gnu.org/software/coreutils/manual/html_node/What-information-is-listed.html)
- [Sorting the output对输出进行排序](https://www.gnu.org/software/coreutils/manual/html_node/Sorting-the-output.html)
- [General output formatting通用输出格式](https://www.gnu.org/software/coreutils/manual/html_node/General-output-formatting.html)
- [Formatting file timestamps格式化文件时间戳](https://www.gnu.org/software/coreutils/manual/html_node/Formatting-file-timestamps.html)
- [Formatting the file names格式化文件名](https://www.gnu.org/software/coreutils/manual/html_node/Formatting-the-file-names.html)

------

### Footnotes

If you use a non-POSIX locale (e.g., by setting `LC_ALL` to ‘en_US’), then `ls` may produce output that is sorted differently than you’re accustomed to. In that case, set the `LC_ALL` environment variable to ‘C’.如果您使用非 POSIX 语言环境（例如，通过将 LC_ALL 设置为“en_US”），则 ls 可能会生成与您习惯的排序方式不同的输出。在这种情况下，请将 LC_ALL 环境变量设置为“C”。

`ls` 是 Linux 和类 Unix 系统中最基础、最常用的命令之一，用于**列出目录内容**（list directory contents）。根据 [man7.org 的 `ls(1)` 手册页](https://www.man7.org/linux/man-pages/man1/ls.1.html)，其核心能力和功能如下：

---

## 二、核心能力与常用选项分类

### 1. **显示控制**
- `-l`：使用**长格式**（long listing），显示权限、链接数、所有者、组、大小、时间、文件名等。
- `-a` / `--all`：显示**所有文件**，包括以 `.` 开头的隐藏文件。
- `-A` / `--almost-all`：显示除 `.` 和 `..` 之外的所有文件（即隐藏文件但不包括当前/上级目录）。
- `-1`：每行只显示一个文件（单列）。
- `-C`：按**多列**方式显示（默认在终端宽度允许时启用）。
- `-x`：按行（横向）而非列排列。
- `-m`：用逗号分隔列出文件。

### 2. **时间与排序**
- `-t`：按**修改时间**（mtime,modify time）排序，最新在前。
- `-S`：按**文件大小**(Size)排序，从大到小。
- `-r`：**反转排序顺序**。
- `-U`：**不排序**，按目录中原始顺序列出。
- `-v`：对文件名中的**版本号进行自然排序**（如 file2.txt 在 file10.txt 之前）。
- `-X`：按**扩展名**排序。
- `-c`：使用 **ctime**（状态更改时间change of status time,time of last change of file status information）进行排序或显示。
  - `-c`是一个在 `ls` 命令中**不太常用但有特定用途**的选项

- `-u`：使用 **atime**（访问时间access time）进行排序或显示。
- `--time=<WORD>`：可指定**显示/排序**的**时间类型**（WORD的可能取值`mtime`、`atime`、`ctime`、`birth`）。

### 3. **文件类型与标识**
- `-F` / `--classify`：在文件名后添加**类型标识符**(各种标识符含义如下)：
  - `/`：目录  
  - `*`：可执行文件  
  - `@`：符号链接  
  - `|`：FIFO  
  - `=`：套接字
  - 如果没有可见表示符,则为普通文件
- `-p`：仅对目录类型添加类型标识符(即除了在目录末尾添加 `/`,其他类型的文件不添加任何类型标识符)。
- `--indicator-style=STYLE`：控制标识符风格（`none`、`slash`、`file-type`、`classify`）。

```bash
#( 10/10/25@10:57PM )( root@CxxuColorfulWin10 ):~/archived
   # 创建各类文件
mkdir mydir
touch normal.txt run.sh
chmod +x run.sh                 # 使其可执行
ln -s normal.txt mylink
mkfifo mypipe
python3 -c "import socket, os; s=socket.socket(socket.AF_UNIX); s.bind('mysock'); os.chmod('mysock', 0o666)" &
[1] 1158
[1]  + 1158 done       python3 -c
#( 10/10/25@10:58PM )( root@CxxuColorfulWin10 ):~/archived
   ls -l -F
total 4
drwxr-xr-x 2 root root 4096 Oct 10 22:58 mydir/
lrwxrwxrwx 1 root root   10 Oct 10 22:58 mylink -> normal.txt
prw-r--r-- 1 root root    0 Oct 10 22:58 mypipe|
srw-rw-rw- 1 root root    0 Oct 10 22:58 mysock=
-rw-r--r-- 1 root root    0 Oct 10 22:58 normal.txt
-rwxr-xr-x 1 root root    0 Oct 10 22:58 run.sh*
#( 10/10/25@10:58PM )( root@CxxuColorfulWin10 ):~/archived
   ls -1 -F
mydir/
mylink@
mypipe|
mysock=
normal.txt
run.sh*
```



### 4. **符号链接处理**
- `-L` / `--dereference`：显示符号链接**指向的文件信息**，而非链接本身。
- `-H`：仅对命令行中指定的符号链接进行解引用。
- 默认情况下，`ls` 显示符号链接本身的信息。

### 5. **大小与单位**👺
- `-h` / `--human-readable`：配合 `-l` 或 `-s`，以易读单位显示大小（如 `1K`、`234M`）。
  - `-h` **必须与 `-l`、`-s` 或 `-o` 等显示文件大小的选项一起使用**，否则无效。
    - 单独 `ls -h` 不会显示大小，因此 `-h` 不起作用。
  - 它会将字节（bytes）自动转换为更易读的单位：(这些单位是自动决策(根据不同文件的大小自动分配,用户无法指定统一的显示单位,即便更换基数也是自动分配)
    - **K** = 千字节（1024 字节）($2^{10}$)
    - **M** = 兆字节（1024² 字节）($2^{20}$)
    - **G** = 吉字节（1024³ 字节）($2^{30}$)
    - **T** = 太字节（1024⁴ 字节）
    - 以此类推（P、E 等）

- `--si`：使用 1000 为基数（而非 1024）。
- `-s`：显示文件占用的**磁盘块数**。
- `--block-size=SIZE`：自定义块大小单位（如 `--block-size=M`）。

```bash
#( 10/14/25@11:07PM )( root@CxxuColorfulWin10 ):~
   ls -sh
total 28K
   0 'abc def'  4.0K  archived  4.0K  f   20K  install.sh     0  zstdL
#( 10/14/25@11:09PM )( root@CxxuColorfulWin10 ):~
   ls -s
total 28
 0 'abc def'   4  archived   4  f  20  install.sh   0  zstdL
```



### 6. **所有权与权限**
- `-n`：以**数字形式**显示 UID 和 GID（而非用户名/组名）。
- `-g`：类似 `-l`，但**不显示所有者**。
- `-o`：类似 `-l`，但**不显示组信息**。
- `-G`：在长格式中**省略组名**。

### 7. **特殊功能**
- `-R`：**递归列出子目录**内容。
- `-d`：列出**目录本身**，而不是其内容（常用于查看目录属性）。
- `-i`：显示每个文件的 **inode 编号**。
- `-Z`：显示文件的 **SELinux 安全上下文**（如启用）。
- `--color[=WHEN]`：**彩色输出**区分文件类型（`always`/`auto`/`never`）。
- `--hyperlink[=WHEN]`：在支持的终端中为文件名添加**超链接**。
- `--zero`：以 **NUL 字符**（而非换行）结束每行，便于脚本处理。

```bash
# root @ CxxuColorfulWin10 in ~ [23:44:35]
$ ls -1R
.:
'abc def'
archived
f
install.sh
zstdL

./archived:
mydir
mylink
mypipe
mysock
normal.txt
run.sh

./archived/mydir:
```



### 8. **过滤与忽略**
- `-I PATTERN` / `--ignore=PATTERN`：忽略匹配 shell 通配符的文件。
- `--hide=PATTERN`：类似 `-I`，但可被 `-a` 或 `-A` 覆盖。
- `-B` / `--ignore-backups`：忽略以 `~` 结尾的备份文件。

### 9. **国际化与格式**
- `--time-style=STYLE`：自定义时间显示格式（如 `iso`、`full-iso` 或 `+FORMAT` 类似 `date` 命令）。

  ```bahs
  $ ls -l --time-style=iso
  full-iso  iso       locale    long-iso
  ```

  各种时间风格,详情查看补充说明一节
- `--quoting-style=WORD`：控制文件名引号风格（如 `shell`、`c`、`literal` 等）。

```bash
#( 10/14/25@11:04PM )( root@CxxuColorfulWin10 ):~
   ls --quoting-style=c
c             clocale       escape        literal       locale        shell         shell-always
```

```bash

#( 10/14/25@11:04PM )( root@CxxuColorfulWin10 ):~
   ls --quoting-style=literal
abc def  archived  f  install.sh  zstdL
#( 10/14/25@11:04PM )( root@CxxuColorfulWin10 ):~
   ls --quoting-style=shell
'abc def'   archived   f   install.sh   zstdL
#( 10/14/25@11:04PM )( root@CxxuColorfulWin10 ):~
   ls --quoting-style=c
"abc def"  "archived"  "f"  "install.sh"  "zstdL"
#( 10/14/25@11:04PM )( root@CxxuColorfulWin10 ):~
   ls --quoting-style=escape
abc\ def  archived  f  install.sh  zstdL
#( 10/14/25@11:05PM )( root@CxxuColorfulWin10 ):~
   ls --quoting-style=locale
‘abc def’  ‘archived’  ‘f’  ‘install.sh’  ‘zstdL’
```



---

## 三、退出状态（Exit Status）

- `0`：成功
- `1`：轻微问题（如无法访问某个子目录）
- `2`：严重错误（如无法访问命令行指定的路径）

---

## 四、典型用途示例
```bash
ls -l                # 长格式列出
ls -la               # 显示所有文件（含隐藏）的详细信息
ls -lh               # 人类可读的文件大小
ls -lt               # 按修改时间排序（最新在前）
ls -R /etc           # 递归列出 /etc 下所有内容
ls -d */             # 仅列出当前目录下的子目录
```

---

## 仅列出文件或目录🎈

`ls` **本身不能直接只列出目录**（没有内置的“仅目录”选项），但可以通过**组合其他选项或配合 shell 通配符/命令**来实现。

- 最好的方案是使用find命令而不是ls

- ls没有直接提供这方面的选项,但是也可以通过组合合适的选项和参数实现,尤其是配合grep和文件模式标记位


> linux上的ls命令和powershell提供的get-childitem不同,后者提供了`-File`和`-Directory`来实现仅列出文件或目录

---

### 仅列出目录

仅使用 `ls `命令的话,有许多方案,但是都不是很好

```bash
ls -p|grep /
```

> 隐藏目录不会被列出,可以配合`-a`一并列出` ls -ap |grep /`

跳过`./`和`../`两个特殊的隐藏目录,列出其他所有目录(包括普通隐藏目录)

```bash
ls -ap | grep / | grep -vE '^\.{1,2}/$'

```

或者

```bash
ls -d */
```

- `*/`：匹配所有目录（shell 通配符，`/` 表示目录）
- `-d`：不展开目录内容，只列出目录本身

 注意：不会显示隐藏目录（如 `.git`）,这是此方法的一个缺陷

如果执行`ls -d`而没有跟其他东西,会列出`.`

示例：

```bash
$ ls -d */
Documents/  Downloads/  Music/  Pictures/  Videos/
```

> 优点：简单、高效、无需额外工具  

---

显示包括隐藏目录也可以,但是要追加的参数组合是`*/ .*/`

这样无论目录前面是否带有`.`都会被列出(默认情况下`.`开头的目录不被列出)

并且此用例一般不与`-a`一起用(`-a`并不能代替`.*/`)

```bash
ls -d .*/ */
```

或更简洁（避免重复）：
```bash
ls -d .*/ */ 2>/dev/null
```

> `2>/dev/null` 用于屏蔽可能的“无匹配”错误（如没有隐藏目录时）

---

但是这种写法可读性就比较差

### 仅列出文件

难以仅使用`ls`命令就能过滤掉目录而仅输出文件

通常要配合其他工具(比如grep),例如

```bash
ls -p |grep -v /

```

或者直接使用find命令简单实现

### 使用 `find` 命令（更强大）

仅列出指定目录下的目录或文件的标准做法是:

> 默认包含被隐藏的文件和目录

1.仅列出目录

```bash
find . -maxdepth 1 -type d
```

- `-maxdepth 1`：只列出当前目录下的内容（不递归）
- `-type d`：只匹配目录

2.仅列出文件(将上述`-type d`改为`-type f`即可)

跳过隐藏目录或文件

```bash
  find . -maxdepth 1 -not -path '*/.*'  -type d #如果是文件就把d改为f
```

不过上面的版本会列出`.`,为此,可以在`-maxdepth 1`之外,配合`-mindepth 1`限制最低层级

```bash
  find . -mindepth 1 -maxdepth 1 -not -path '*/.*' -type d
```



#### 示例：
```bash
$ find . -maxdepth 1 -type d
.
./Documents
./Downloads
./.git
```

> 优点：包含隐藏目录，可灵活控制深度  
> 🔄 可排序：`find . -maxdepth 1 -type d | sort`

---

### 使用 `ls` + `grep`

基于长格式输出的特点进行过滤

```bash
ls -la | grep '^d'
```

- `ls -la`：列出所有文件（含隐藏），长格式
- `grep '^d'`：筛选以 `d` 开头的行（`d` 表示目录）

#### 示例：
```text
drwxr-xr-x  5 user user 4096 Jun 10 10:00 Documents
drwxr-xr-x  3 user user 4096 Jun 11 14:20 .git
```

> ⚠️ 缺点：
> - 效率低（先列出所有再过滤）
> - 如果文件名含换行符会出错（罕见但存在）
> - 不如 `ls -d */` 简洁

---

###  总结：推荐用法

| 需求                         | 推荐命令                     |
| ---------------------------- | ---------------------------- |
| **仅列出非隐藏目录**         | `ls -d */`                   |
| **列出所有目录（含隐藏）**   | `ls -d .*/ */ 2>/dev/null`   |
| **需要完整路径或脚本中使用** | `find . -maxdepth 1 -type d` |

---

### 封装为函数@创建别名

将常用命令设为别名，例如：

```bash
# 仅目录（不含隐藏）
alias lsd='ls -d */'

# 所有目录（含隐藏）
alias lsda='ls -d .*/ */ 2>/dev/null'
# 或
alias lsda='ls -ap | grep / | grep -vE '^\.{1,2}/$'
# 仅文件
alias lsf='ls -p |grep -v /'
```

加入 `~/.bashrc` 或 `~/.zshrc` 后，直接输入 `lsd` 即可！

---

**结论**：虽然 `ls` 没有原生“仅目录”选项，但通过 `ls -d */` 是最简单高效的方式。



##  补充说明

---

### 1. **关于 SIZE 参数（文件大小单位）**

> **原文**：  
> The SIZE argument is an integer and optional unit (example: 10K is 10*1024). Units are K,M,G,T,P,E,Z,Y,R,Q (powers of 1024) or KB,MB,... (powers of 1000). Binary prefixes can be used, too: KiB=K, MiB=M, and so on.

**解释**：  

- `SIZE` 参数用于指定文件大小，格式为一个整数加上可选的单位。
- **示例**：`10K` 表示 `10 × 1024 = 10240` 字节。
- **单位说明**：
  - **大写字母（如 K, M, G...）**：表示 **二进制单位**（基于 1024）。
    - K = 1024¹ = 1024  
    - M = 1024² = 1,048,576  
    - G = 1024³，依此类推，一直到 Q（1024⁹）。
  - **带 B 的单位（如 KB, MB, GB...）**：表示 **十进制单位**（基于 1000）。
    - KB = 1000¹ = 1000  
    - MB = 1000² = 1,000,000，等等。
  - **国际标准二进制前缀（如 KiB, MiB）** 也被支持，并且：
    - `KiB` 等价于 `K`（即 1024 字节）
    - `MiB` 等价于 `M`（即 1024² 字节）
    - 以此类推。

> 总结：`K`/`KiB` = 1024；`KB` = 1000。

---

### 2. **关于 TIME_STYLE 参数（时间显示格式）**

> **原文**：  
> The TIME_STYLE argument can be full-iso, long-iso, iso, locale, or +FORMAT. FORMAT is interpreted like in date(1). If FORMAT is FORMAT1<newline>FORMAT2, then FORMAT1 applies to non-recent files and FORMAT2 to recent files. TIME_STYLE prefixed with 'posix-' takes effect only outside the POSIX locale. Also the TIME_STYLE environment variable sets the default style to use.

**解释**：  

- `TIME_STYLE` 控制 `ls` 命令如何显示文件的时间戳（如修改时间）。

- 可选值包括：

  - `full-iso`：完整 ISO 8601 格式，例如 `2024-06-15 14:30:45.123456789 +0800`
  - `long-iso`：类似 `2024-06-15 14:30`
  - `iso`：简短 ISO 格式，如 `06-15 14:30`
  - `locale`：使用系统本地化设置的时间格式
  - `+FORMAT`：自定义格式，语法与 `date(1)` 命令相同（如 `+%Y-%m-%d`）

- **高级用法**：如果 `FORMAT` 包含换行符（`\n`），即写成：

  ```
  FORMAT1
  FORMAT2
  ```

  那么：

  - `FORMAT1` 用于 **非近期文件**（通常是 6 个月前或更早的文件）
  - `FORMAT2` 用于 **近期文件**（通常是最近 6 个月内的文件）

- **`posix-` 前缀**：如 `posix-long-iso`，仅在 **非 POSIX 语言环境**（locale）下生效。

- **环境变量**：可通过设置 `TIME_STYLE` 环境变量来指定默认的时间显示风格，例如：

  ```bash
  export TIME_STYLE=long-iso
  ```

---

### 3. **关于 WHEN 参数（控制某些功能的启用条件）**

> **原文**：  
> The WHEN argument defaults to 'always' and can also be 'auto' or 'never'.

**解释**：  

- `WHEN` 是一个通用参数（常见于 `--color=WHEN` 或 `--hyperlink=WHEN` 等选项中）。
- 取值：
  - `always`：始终启用该功能（如始终显示颜色）
  - `auto`（或 `tty`）：仅当输出连接到终端（tty）时启用
  - `never`：从不启用
- 默认值通常是 `always`，但具体取决于选项（例如 `--color` 默认是 `auto`）。

---

### 4. **关于颜色输出（--color 选项）**

> **原文**：  
> Using color to distinguish file types is disabled both by default and with --color=never. With --color=auto, ls emits color codes only when standard output is connected to a terminal. The LS_COLORS environment variable can change the settings. Use the dircolors(1) command to set it.

**解释**：  

- **默认情况下**，`ls` **不使用颜色**（即使你看到颜色，那也是因为你的 shell 别名设置了 `--color=auto`）。

- `--color=never`：明确禁用颜色。

- `--color=auto`：**仅当输出到终端时才使用颜色**（如果重定向到文件或管道，则不输出颜色码）。

- 颜色规则由 **`LS_COLORS` 环境变量** 控制。

  - 你可以通过 `dircolors` 命令生成或修改 `LS_COLORS`。

  - 示例：

    ```bash
    eval $(dircolors)        # 加载默认配色
    dircolors -p > ~/.dircolors  # 保存默认配色到文件以自定义
    ```

---

### 总结要点：

| 功能           | 说明                                                         |
| -------------- | ------------------------------------------------------------ |
| **SIZE 单位**  | `K/M/G...` = 1024 的幂；`KB/MB/GB...` = 1000 的幂；`KiB=K`   |
| **TIME_STYLE** | 控制时间显示格式，支持预设值或 `date` 风格的自定义格式       |
| **WHEN**       | 控制功能（如颜色）何时启用：`always` / `auto` / `never`      |
| **颜色输出**   | 默认关闭；`--color=auto` 最常用；通过 `LS_COLORS` 和 `dircolors` 自定义 |

这些功能常见于 GNU `ls`（即 Linux 上的 `ls`），在 macOS（BSD 版本）上可能不完全支持。