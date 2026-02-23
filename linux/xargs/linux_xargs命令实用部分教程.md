[toc]

## linux_xargs管道符增强的使用

`xargs` 是 Linux 中一个强大的命令行工具，它可以**将标准输入转换为命令参数，并用于批量处理文件或数据**。

它常与 `find`、`ls`、`grep` 等命令结合使用，提高命令执行效率。

和`powershell`不同,bash中许多命令原生不直接支持管道符,但是可以借助`xargs`让许多常用命令能够像支持管道符那样使用

------

### 1. 基本语法

```bash
command | xargs [options] command_to_execute
```

**示例：**

```bash
echo "file1 file2 file3" | xargs rm
```

等价于：

```bash
rm file1 file2 file3
```

------

### 2. `xargs` 结合 `ls` 进行批量操作

#### 删除所有 `.log` 文件：

```bash
ls *.log | xargs rm
```

等价于：

```bash
rm file1.log file2.log file3.log
```

**⚠️ 注意：** `ls` 可能无法正确处理包含空格或特殊字符的文件，建议用 `find`。

------

### 3. `xargs` 结合 `find`🎈

#### 删除所有 `.log` 文件

```bash
find . -name "*.log" | xargs rm
```

等价于：

```bash
rm file1.log file2.log file3.log
```

安全版本:防止空格问题

```bash
find . -name "*.log" -print0 | xargs -0 rm
```

`-print0` 和 `-0` 让 `xargs` 处理带空格的文件名。

`-print0`是find的参数;而`-0`是xargs的参数

#### 统计目录下文件数：

```bash
find . -type f | wc -l
```

或者：

```bash
find . -type f | xargs ls -l | wc -l
```

------

### 4. `xargs` 结合 `grep`

#### 在当前目录所有 `.txt` 文件中搜索 "error"

```bash
ls *.txt | xargs grep "error"
```

或：

```bash
find . -name "*.txt" | xargs grep "error"
```

**带空格的文件名处理：**

```bash
find . -name "*.txt" -print0 | xargs -0 grep "error"
```

------

### 5. `xargs` 结合 `tar` 进行批量压缩

#### 压缩所有 `.log` 文件：

```bash
find . -name "*.log" | xargs tar -czvf logs.tar.gz
```

**如果文件名有空格：**

```bash
find . -name "*.log" -print0 | xargs -0 tar -czvf logs.tar.gz
```

------

### 6. `xargs` 限制每次执行的参数数量

有时 `xargs` 传递的参数过多，可能导致命令超出系统限制，可以使用 `-n` 控制：

```bash
find . -name "*.log" | xargs -n 10 rm
```

**每次删除 10 个文件，避免 `rm` 处理过多参数导致错误。**

------

### 7. 交互式确认执行 `xargs` 命令（`-p` 选项）

**逐个确认删除文件：**

```bash
find . -name "*.log" | xargs -p rm
```

> 你会看到 `rm file1.log file2.log file3.log ?...`，输入 `y` 确认，`n` 取消。

------

### 8. `xargs` 并行执行（`-P` 选项）

**加速执行多个命令**

```bash
find . -name "*.log" | xargs -P 4 -n 10 rm
```

> **并行执行 `rm`，最多 4 个并发进程，每次处理 10 个文件**，提高效率。

------

### 9. `xargs` 结合 `mkdir` 批量创建目录

```bash
echo "dir1 dir2 dir3" | xargs mkdir
```

等价于：

```bash
mkdir dir1 dir2 dir3
```

------

### 10. `xargs` 结合 `touch` 批量创建文件

```bash
echo "file1.txt file2.txt file3.txt" | xargs touch
```

等价于：

```bash
touch file1.txt file2.txt file3.txt
```

------

## 总结

| 任务                       | 命令                           |
| -------------------------- | ------------------------------ |
| 删除 `ls` 过滤出的文件     | `ls *.log`                     |
| 安全删除 `find` 查找的文件 | `find . -name "*.log" -print0` |
| 搜索 `error` 关键词        | `find . -name "*.txt"`         |
| 逐个确认删除文件           | `find . -name "*.log"`         |
| 并行删除（4 进程）         | `find . -name "*.log"`         |
| 批量创建目录               | `echo "dir1 dir2"`             |
| 批量创建文件               | `echo "file1 file2"`           |

`xargs` 在 Linux 命令行中非常实用，尤其适用于批量处理文件、并行执行命令、处理带空格文件名等场景。



## 参考

### The xargs Command

- [How to Use the xargs Command on Linux (howtogeek.com)](https://www.howtogeek.com/435164/how-to-use-the-xargs-command-on-linux/)

### 文档

#### 在线

- [xargs(1) - Linux manual page (man7.org)](https://man7.org/linux/man-pages/man1/xargs.1.html)
- [xargs options (GNU Findutils 4.9.0)](https://www.gnu.org/software/findutils/manual/html_node/find_html/xargs-options.html)
- [Invoking the shell from xargs (GNU Findutils 4.9.0)](https://www.gnu.org/software/findutils/manual/html_node/find_html/Invoking-the-shell-from-xargs.html)

#### 离线版

- `info xargs`

## The xargs Command

- `xargs` will accept piped input. 
- It can also accept input from a file. 
- `xargs` uses that **input** as **parameters** for the **commands** we’ve told it to work with.
  -  If we do not tell `xargs` to work with <u>a specific command</u> it will default to use `echo`.

- We can use that to demonstrate how `xargs` will always generate a single line of output, even from multi-line input.

  - If we use the `-1` (list one file per line) option with `ls`, we get a [single column of filenames](https://man7.org/linux/man-pages/man1/ls.1.html).

  - ```bash
    ls -1 ./*.sh
    
    # cxxu_u22 @ cxxuWn11 in ~ [0:03:28]
    $ ls -1 *.txt|xargs
    demo.txt input.txt output.txt
    # xargs 不跟东西(命令),则默认等价于跟上echo命令
    # cxxu_u22 @ cxxuWn11 in ~ [0:03:36]
    $ ls -1 *.txt|xargs echo
    demo.txt input.txt output.txt
    ```

  - 使用`-p`选项,可以帮助我们看到命令行被转为什么

  - ```bash
    # cxxu_u22 @ cxxuWn11 in ~ [0:06:03] C:1
    $ ls -1 *.txt|xargs -p wc
    wc demo.txt input.txt output.txt?...
    
    # cxxu_u22 @ cxxuWn11 in ~ [0:06:23]
    $ ls -1 *.txt|xargs -p
    echo demo.txt input.txt output.txt?...
    ```

    

### examples

```bash

┌─[cxxu@cxxuAli] - [~] - [2022-05-04 04:45:09]
└─[0] <> ls *.*|xargs head -n 3
==> envs.sh <==
#!/bin/bash

# 不同于aliases.sh

==> events.txt <==
Fluffy          1995-05-15                      litter                                  4 kittens  \N
Buffy                   1993-06-23              litter                  5                 puppies  \N
Buffy                   1994-06-19                      litter                            puppies  \N

==> package.json <==
{
  "dependencies": {
    "tldr": "^3.3.7"

==> package-lock.json <==
{
  "name": "cxxu",
  "lockfileVersion": 2,

==> recurse_dir.sh <==
#!/bin/bash

recursive_copy_file()
┌─[cxxu@cxxuAli] - [~] - [2022-05-04 04:47:45]
```

### 不带选项的xargs

```bash
┌─[cxxu@cxxuAli] - [~] - [2022-05-04 04:47:49]
└─[0] <> ls *.*|xargs wc
   50   106  2029 envs.sh
    7    28   223 events.txt
    5     7    49 package.json
 1366  2436 50350 package-lock.json
   41   130  1200 recurse_dir.sh
 1469  2707 53851 total
```

### -p@Using xargs With Confirmation

- We can use the `-p` (interactive) option to have `xargs` prompt us for confirmation that we are happy for it to proceed.

- If we pass a string of filenames to `touch`, through `xargs`, `touch` will [create the files](https://man7.org/linux/man-pages/man1/touch.1.html) for us.

```bash
echo 'one two three' | xargs -p touch
```

- The command that is going to be executed is displayed and `xargs` waits for us to respond by typing “y” or “Y”, or “n” or “N”, and pressing Enter.

  If you just press Enter, it is treated as “n”. The command is only executed if you type “y” or “Y”.

```bash
┌─[cxxu@cxxuAli] - [~] - [2022-05-04 04:48:17]
└─[0] <> echo 'one two three' | xargs -p touch
touch one two three ?...y

# cxxu_u22 @ cxxuWn11 in ~ [0:09:51] C:1
$ ls -1 *.txt|xargs -p wc
wc demo.txt input.txt output.txt?...y
  6  27 209 demo.txt
  5  25 200 input.txt
  5  25 200 output.txt
 16  77 609 total

┌─[cxxu@cxxuAli] - [~] - [2022-05-04 04:50:33]
└─[0] <> l one two three
-rw-rw-r-- 1 cxxu cxxu 0 May  4 16:50 one
-rw-rw-r-- 1 cxxu cxxu 0 May  4 16:50 three
-rw-rw-r-- 1 cxxu cxxu 0 May  4 16:50 two


#以下内容基于oh-my-zsh框架下执行,omz theme list 提供输入数据作为演示而已
 ~/ omz theme list | xargs  -p -I % sh -c 'echo %'
sh -c 'echo example'?...y
example
sh -c 'echo 3den'?...y
3den
sh -c 'echo Soliah'?...y
Soliah
sh -c 'echo adben'?...n
sh -c 'echo af-magic'?...y
af-magic
sh -c 'echo afowler'?...^C

 ~/ omz theme list | xargs  -I % sh -c 'echo  %'
example
3den
Soliah
adben
af-magic
afowler
agnoster
alanpeabody
```

#### -t

```bash
#( 05/04/22@ 7:44PM )( cxxu@cxxuAli ):~/sedLearn
   find . -name '*.txt' -type f -print0|xargs -t -0 rm -v
rm -v ./b.txt ./c.txt ./a.txt
removed './b.txt'
removed './c.txt'
removed './a.txt'
#( 05/04/22@ 7:44PM )( cxxu@cxxuAli ):~/sedLearn
   touch {a,b,c}.txt
#( 05/04/22@ 7:44PM )( cxxu@cxxuAli ):~/sedLearn
   find . -name '*.txt' -type f -print0|xargs -t -0 -n 1 rm -v
rm -v ./b.txt
removed './b.txt'
rm -v ./c.txt
removed './c.txt'
rm -v ./a.txt
removed './a.txt'
```





#### -I@指定循环变量



- ```bash
  -I replace-str
  --replace[=replace-str]
  -i[replace-str]
  ```

- Replace occurrences of replace-str in the initial arguments with names read from standard input. Also, unquoted blanks do not terminate arguments; instead, the input is split at newlines only. 

- If replace-str is omitted (omitting it is allowed only for ‘-i’), it defaults to ‘{}’ (like for ‘find -exec’). Implies ‘-x’ and ‘-l 1’. The ‘-i’ option is deprecated in favour of the ‘-I’ option.

```bash
#( 05/04/22@ 5:31PM )( cxxu@cxxuAli ):~/sedLearn
   cat > dirs.txt
dir1
dir2
dir3
#( 05/04/22@ 5:31PM )( cxxu@cxxuAli ):~/sedLearn
   cat dirs.txt|xargs -I % sh -c 'echo %;mkdir %'
dir1
dir2
dir3
#( 05/04/22@ 5:32PM )( cxxu@cxxuAli ):~/sedLearn
   tree -d
.
├── d1
│   ├── d2
│   └── da
│       └── db
├── dir1
├── dir2
└── dir3

7 directories
#( 05/04/22@ 5:32PM )( cxxu@cxxuAli ):~/sedLearn
   cat dirs.txt|xargs -I % sh -c 'echo %;rmdir %'
dir1
dir2
dir3
#( 05/04/22@ 5:34PM )( cxxu@cxxuAli ):~/sedLearn
   tree -d
.
└── d1
    ├── d2
    └── da
        └── db

```

- ```bash
  -I replace-str
             Replace  occurrences  of  replace-str  in the (initial-arguments) with names
             read from standard input. 
             Also, unquoted blanks do  not  terminate  input items;
             instead the separator is the newline character. 
             Implies -x and -L
             1.
  ```

- -I 定义的`replace-str` 类似于插值字符串的占位符

- ```bash
   ~/ omz theme list | xargs  -i% sh -c 'echo  %'
  example
  3den
  Soliah
  adben
  af-magic
  afowler
  agnoster
  ...
   ~/ omz theme list | xargs  -I '$_' sh -c 'echo  $_'
  example
  3den
  Soliah
  adben
  af-magic
  afowler
  agnoster
  ..
   ~/ omz theme list | xargs  -i % sh -c 'echo  %'
  xargs: %: No such file or directory
  ```

  

####  -n

> ```bash
>  -n max-args, --max-args=max-args
>               Use at most max-args arguments per command line. 
>               Fewer than max-args  arguments  will  be used if the size (see the -s option) is 						exceeded, unless the -x option is given, in which case xargs will exit.
> ```
>
> 

```bash
#( 05/04/22@ 5:51PM )( cxxu@cxxuAli ):~/sedLearn
   echo dir_t1 dir_t2 | xargs -n 1 cp -v --force ./*txt
'./coleridge.txt' -> 'dir_t1/coleridge.txt'
'./data.txt' -> 'dir_t1/data.txt'
'./dirs.txt' -> 'dir_t1/dirs.txt'
'./coleridge.txt' -> 'dir_t2/coleridge.txt'
'./data.txt' -> 'dir_t2/data.txt'
'./dirs.txt' -> 'dir_t2/dirs.txt'
```

- 可以每次只传递一个值给`xargs`的命令

  - 当然有些命令(譬如`cat`),一次传一个值还是多个值,都可以正常且正确工作

  - 但,对于有些命令,需要严格控制每次执行的参数个数

    - ```bash
      #( 05/04/22@ 6:06PM )( cxxu@cxxuAli ):~/sedLearn
         echo dir_t1 dir_t2 | xargs  cp -v --force ./*txt
      './coleridge.txt' -> 'dir_t2/coleridge.txt'
      './data.txt' -> 'dir_t2/data.txt'
      './dirs.txt' -> 'dir_t2/dirs.txt'
      cp: -r not specified; omitting directory 'dir_t1'
      ```

    - 

#### -0

## Deleting Files in Nested Directories

- If **filenames** have **spaces and strange characters** in them—such as **newline characters**— `xargs` will not be able to interpret them correctly. 
- We can overcome that problem by using the -0 (null terminator) option. 
- This tells `xargs` to use **the null character** as **the final delimiter** for filenames.

> - We’re going to use `find` in this example. 
>
> - `find` has its own option for [dealing with whitespace](http://man7.org/linux/man-pages/man1/find.1.html) and strange characters in filenames. 
>
> - It is the `-print0` (full name, **null character**) option.
>
>   -  **-print** 
>
>     - True; print the full file name on the standard output, followed by a newline. 
>     - If you are piping the output of find into another program and  there is the **faintest** possibility that the files which you are searching  for might contain a newline, then you should seriously consider using the  **-print0** option instead of -print. 
>       - 文件名中有小概率包含换行符等特殊字符
>
>     - See the UNUSUAL FILENAMES section for  information about how unusual characters in filenames are handled.   
>
>   - **-print0**  True; 
>
>     - print the full file name on the standard output, followed by a null  character (instead of the newline character that -print uses). 
>     - This  allows file names that contain newlines or other types of white space to  be correctly interpreted by programs that process the find output. 
>     - **This  option corresponds to the -0 option of xargs.** 
>
> - > `find`和`xargs`都相互考虑,:`find`的`-print0`和`xargs`的` -0`一般是同时出现(共用)

```bash
find . -name "*.png" -type f -print0 | xargs -0 rm -v -rf "{}"
```

This breaks down like this:

- *find . -name “\*.png”*: `find` is going to search from the current directory “.” for objects with names that match “*.png” that are files (`type -f`).
- *-print0*: names will be terminated by a null character, and spaces and strange characters will be catered for.
- *xargs -0*: *xargs* is also going to consider filenames to be null-terminated, and spaces and strange characters will not cause problems.
- *rm -v -rf “{}”*: 
  - rm is going to be verbose and report what is happening (`-v`). 
  - It is going to be recursive (-r) and **look through nested subdirectories**, and will <u>remove files without prompting (`-f`)</u>.
  -  The “{}” is replaced by **each filename.**

```bash
#( 05/04/22@ 6:48PM )( cxxu@cxxuAli ):~/sedLearn
   touch {a,b,c}.txt
# 下面的输出结果,其分隔符肉眼不可见(null)
#( 05/04/22@ 6:48PM )( cxxu@cxxuAli ):~/sedLearn
   find . -name "*.txt" -type f -print0
./b.txt./c.txt./a.txt
# null可以被xargs -0 替换为可见的空白符
#( 05/04/22@ 6:46PM )( cxxu@cxxuAli ):~/sedLearn
   find . -name '*.txt' -type f -print0|xargs  -0
./b.txt ./c.txt ./a.txt
#( 05/04/22@ 6:46PM )( cxxu@cxxuAli ):~/sedLearn
   find . -name '*.txt' -type f -print0|xargs  -0 rm -v
removed './b.txt'
removed './c.txt'
removed './a.txt'
```

#### find&xargs&tar

```bash
#( 05/04/22@ 7:34PM )( cxxu@cxxuAli ):~/sedLearn
   find . -name '*.txt' -type f -print0|xargs -0 tar czvf txts.tar.gz
./b.txt
./c.txt
./a.txt

#( 05/04/22@ 7:34PM )( cxxu@cxxuAli ):~/sedLearn
   ll txts.tar.gz
-rw-rw-r-- 1 cxxu cxxu 131 May  4 19:34 txts.tar.gz
#( 05/04/22@ 7:34PM )( cxxu@cxxuAli ):~/sedLearn
   tar -tvf txts.tar.gz
-rw-rw-r-- cxxu/cxxu         0 2022-05-04 18:48 ./b.txt
-rw-rw-r-- cxxu/cxxu         0 2022-05-04 18:48 ./c.txt
-rw-rw-r-- cxxu/cxxu         0 2022-05-04 18:48 ./a.txt
```

#### 更多使用案例

```bash
  xargs

  Execute a command with piped arguments coming from another command, a file, etc.
  The input is treated as a single block of text and split into separate pieces on spaces, tabs, newlines and end-of-file.
  More information: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/xargs.html.




# To Find all file name ending with .pdf and remove them
find -name *.pdf | xargs rm -rf

# if file name contains spaces you should use this instead
find -name *.pdf | xargs -I{} rm -rf '{}'

# Will show every .pdf like:
#       &toto.pdf=
#       &titi.pdf=
# -n1 => One file by one file. ( -n2 => 2 files by 2 files )

find -name *.pdf | xargs -I{} -n1 echo '&{}='

# If find returns no result, do not run rm
# This option is a GNU extension.
find -name "*.pdf" | xargs --no-run-if-empty rm

# xargs

print commands as they are executed

    xargs -t


parallelize ls with at most 5 processes

    xargs -P 5 ls


combine with find to remove all .txt files in directory

    find directory -name "*.txt" -print0 | xargs -0 -t rm



# Basic Usage

`xargs` is used to pass arguments to commands:

    <command_to_generate_arguments> | xargs <command_to_consume_arguments>



# Splitting Arguments

The `-n` command can specify how many arguments should be passed to `xargs` at
a time, splitting on whitespace. For example, this command will split the
`1 2 3 4 5 6` given to `echo` on whitespace and take two at a time (`-n 2`).
It will `echo` them back to `stdout`, printing the commands it is executing
(`-t`):

    $ echo 1 2 3 4 5 6
    1 2 3 4 5 6
    $ echo 1 2 3 4 5 6 | xargs -t -n 2 echo
    echo 1 2
    1 2
    echo 3 4
    3 4
    echo 5 6
    5 6
    
    
  - Run a command using the input data as arguments:
    arguments_source | xargs command

  - Run multiple chained commands on the input data:
    arguments_source | xargs sh -c "command1 && command2 | command3"

  - Delete all files with a .backup extension (-print0 uses a null character to split file names, and -0 uses it as delimiter):
    find . -name '*.backup' -print0 | xargs -0 rm -v

  - Execute the command once for each input line, replacing any occurrences of the placeholder (here marked as _) with the input line:
    arguments_source | xargs -I _ command _ optional_extra_arguments

  - Parallel runs of up to max-procs processes at a time; the default is 1. If max-procs is 0, xargs will run as many processes as possible at a time:
    arguments_source | xargs -P max-procs command

```



