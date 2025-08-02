[toc]

# abstract

现代操作系统(windows,linux)上创建各类链接的方法汇总

## 使用场景举例

| 场景               | 描述                                                         |
| ------------------ | ------------------------------------------------------------ |
| 快速访问深层目录   | 创建软链接简化路径，如 `/www/woo_df → /repos/scripts/wp/woocommerce/woo_df` |
| 共享脚本或配置文件 | 在多个位置创建软链接指向同一个源文件                         |
| Web 服务器部署     | 将网站根目录下的路径链接到实际项目目录                       |
| 节约存储空间       | 让不同项目引用同一个库文件而不复制                           |

---

基本链接类型和特点

| 类型      | 名称                               | 特点                                               |
| --------- | ---------------------------------- | -------------------------------------------------- |
| 默认      | 硬链接（Hard Link）                | 直接指向文件的 inode，不能跨文件系统、不能链接目录 |
| `-s` 参数 | 软链接 / 符号链接（Symbolic Link） | 类似快捷方式，可跨文件系统，可链接目录             |

# windows

## cmd mklink 创建链接

cmd下的`mklink`创建链接

- [mklink | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/mklink)

  - mklink是cmd下的命令,powershell无法直接调用

  - 如果需要在powershell执行mklink命令,需要借助`cmd /c mklink`来代替`mklink`

  - 当然powershell也有自己的创建符号的方法,即`New-item`方法,用不上古老的`mklink`,这部分放到后面介绍

  - `mklink`虽然比较古老,但是兼容性好,支持windows vista等老系统

- mklink:三种模式可以创建不同的链接符号.详情查看文档

- ```bash
  C:\Users\cxxu\AppData\Local>mklink /?
  Creates a symbolic link.
  
  MKLINK [[/D] | [/H] | [/J]] Link Target
  
          /D      Creates a directory symbolic link.  Default is a file
                  symbolic link.
          /H      Creates a hard link instead of a symbolic link.
          /J      Creates a Directory Junction.
          Link    Specifies the new symbolic link name.
          Target  Specifies the path (relative or absolute) that the new link
                  refers to.
  ```

### 示例

```powershell
PS☀️[BAT:71%][MEM:23.99% (7.61/31.71)GB][20:48:05]
# [cxxu@COLORFULCXXU][~\Desktop]
PS> cmd /c mklink /d symbolDir T:\DirInFat32\
symbolic link created for symbolDir <<===>> T:\DirInFat32\

PS☀️[BAT:71%][MEM:23.97% (7.6/31.71)GB][20:48:34]
# [cxxu@COLORFULCXXU][~\Desktop]
PS> ls

        Directory: C:\Users\cxxu\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
l----         2024/5/28     20:48                  symbolDir 󰁕 T:\DirInFat32\
```



## powershell 创建链接

`New-Item` 是 PowerShell 中用于创建新的文件系统对象（如文件和目录）的命令。通过指定 `-Type` 参数，可以创建不同类型的项目。

### 创建常规文件和目录

以下是各类型的详细解释：

1. **File**（文件）：创建一个新的文件。例如，你可以使用 `New-Item -Path "C:\Example\newfile.txt" -ItemType File` 来创建一个名为 `newfile.txt` 的文件。

   示例：

   ```powershell
   New-Item -Path "C:\Example\newfile.txt" -ItemType File
   ```

   这将创建一个空文件 `newfile.txt` 在 `C:\Example` 目录下。

2. **Directory**（目录）：创建一个新的文件夹或目录。例如，你可以使用 `New-Item -Path "C:\Example\NewFolder" -ItemType Directory` 来创建一个名为 `NewFolder` 的目录。

   示例：

   ```powershell
   New-Item -Path "C:\Example\NewFolder" -ItemType Directory
   ```

   这将在 `C:\Example` 目录下创建一个新的文件夹 `NewFolder`。


### 创建链接

1. **SymbolicLink**（符号链接）：创建一个符号链接，类似于 Unix 系统中的软链接。符号链接是指向另一个文件或目录的快捷方式。例如，你可以使用 `New-Item -Path "C:\LinkToFile.txt" -ItemType SymbolicLink -Target "C:\OriginalFile.txt"` 来创建一个指向 `C:\OriginalFile.txt` 的符号链接。

   示例：

   ```powershell
   New-Item -Path "C:\LinkToFile.txt" -ItemType SymbolicLink -Target "C:\OriginalFile.txt"
   ```

   这将创建一个符号链接 `LinkToFile.txt`，它指向 `C:\OriginalFile.txt`。

2. **Junction**（连接点）：创建一个目录连接点，可以将一个目录链接到另一个目录。例如，你可以使用 `New-Item -Path "C:\JunctionLink" -ItemType Junction -Target "C:\OriginalFolder"` 来创建一个指向 `C:\OriginalFolder` 的目录连接点。

   示例：

   ```powershell
   New-Item -Path "C:\JunctionLink" -ItemType Junction -Target "C:\OriginalFolder"
   ```

   这将在 `C:\JunctionLink` 创建一个目录连接点，它指向 `C:\OriginalFolder`。

3. **HardLink**（硬链接）：创建一个硬链接，硬链接是文件系统中同一个文件的多个路径名，多个硬链接指向相同的数据块。例如，你可以使用 `New-Item -Path "C:\HardLinkToFile.txt" -ItemType HardLink -Target "C:\OriginalFile.txt"` 来创建一个指向 `C:\OriginalFile.txt` 的硬链接。

   示例：

   ```powershell
   New-Item -Path "C:\HardLinkToFile.txt" -ItemType HardLink -Target "C:\OriginalFile.txt"
   ```

   这将创建一个硬链接 `HardLinkToFile.txt`，它与 `C:\OriginalFile.txt` 指向同一个数据块。

这些命令中的每一个都允许你在文件系统中创建不同类型的对象，以便更好地管理和组织文件和目录。



#   linux

## ln 命令创建硬链接

[ln(1) - Linux manual page (man7.org)](https://www.man7.org/linux/man-pages/man1/ln.1.html)

ln命令十分灵活,可以一次性创建指定的多个文件/目录的链接

在不指定创建的链接名(LINK_NAME)的情况下,链接名和要被创建链接的目标(TARGET)同名

在ln命令中,TARGET不可省略,而链接明LINK_NAME是可以根据需要省略不写

提现在用法上,也是TARGET(位置参数)优先指定,而且可以连续指定多个TARGET(在连续指定多个TARGET的情况下,LINK_NAME是无法指定的(这时ln命令的一个缺点),并且命令行中最后一个位置参数会被解释为这批TARGET的链接会被创建于哪一个目录(DIRECTORY))

不过ln的最后一种用法允许你调整语序,以更清晰的方式批量创建链接(使用`-t`指定这批TARGET的链接要创建在哪个目录下)

- ```bash
  ln --help
  Usage: ln [OPTION]... [-T] TARGET LINK_NAME
    or:  ln [OPTION]... TARGET
    or:  ln [OPTION]... TARGET... DIRECTORY
    or:  ln [OPTION]... -t DIRECTORY TARGET...
  In the 1st form, create a link to TARGET with the name LINK_NAME.
  In the 2nd form, create a link to TARGET in the current directory.
  In the 3rd and 4th forms, create links to each TARGET in DIRECTORY.
  Create hard links by default, symbolic links with --symbolic.
  By default, each destination (name of new link) should not already exist.
  When creating hard links, each TARGET must exist.  Symbolic links
  can hold arbitrary text; if later resolved, a relative link is
  interpreted in relation to its parent directory.
  
  Mandatory arguments to long options are mandatory for short options too.
        --backup[=CONTROL]      make a backup of each existing destination file
    -b                          like --backup but does not accept an argument
    -d, -F, --directory         allow the superuser to attempt to hard link
                                  directories (note: will probably fail due to
                                  system restrictions, even for the superuser)
    -f, --force                 remove existing destination files
    -i, --interactive           prompt whether to remove destinations
    -L, --logical               dereference TARGETs that are symbolic links
    -n, --no-dereference        treat LINK_NAME as a normal file if
                                  it is a symbolic link to a directory
    -P, --physical              make hard links directly to symbolic links
    -r, --relative              create symbolic links relative to link location
    -s, --symbolic              make symbolic links instead of hard links
    -S, --suffix=SUFFIX         override the usual backup suffix
    -t, --target-directory=DIRECTORY  specify the DIRECTORY in which to create
                                  the links
    -T, --no-target-directory   treat LINK_NAME as a normal file always
    -v, --verbose               print name of each linked file
        --help     display this help and exit
        --version  output version information and exit
  
  The backup suffix is '~', unless set with --suffix or SIMPLE_BACKUP_SUFFIX.
  The version control method may be selected via the --backup option or through
  the VERSION_CONTROL environment variable.  Here are the values:
  
    none, off       never make backups (even if --backup is given)
    numbered, t     make numbered backups
    existing, nil   numbered if numbered backups exist, simple otherwise
    simple, never   always make simple backups
  
  Using -s ignores -L and -P.  Otherwise, the last option specified controls
  behavior when a TARGET is a symbolic link, defaulting to -P.
  
  GNU coreutils online help: <https://www.gnu.org/software/coreutils/>
  Full documentation <https://www.gnu.org/software/coreutils/ln>
  or available locally via: info '(coreutils) ln invocation'
  ```

  

`ln` 命令用于在文件之间创建链接。链接可以是硬链接（hard link）或者符号链接（symbolic link）。以下是`ln`命令的基本用法及其各个选项的详细说明。

- 使用绝对路径创建软链接更稳定（避免相对路径带来的问题）。

- 创建前确保目标路径不存在，否则 `ln` 会报错。

- 如果你想强制覆盖已有的链接，可以加 `-f` 参数：

  ```bash
  ln -sf source target
  ```

---



### NAME
`ln` - 在文件之间创建链接

### SYNOPSIS
1. `ln [OPTION]... [-T] TARGET LINK_NAME`
2. `ln [OPTION]... TARGET`
3. `ln [OPTION]... TARGET... DIRECTORY`
4. `ln [OPTION]... -t DIRECTORY TARGET...`

> 其中,`[OPTION]`表示ln命令的选项,而后面紧跟着的`...`表示选项可以有多个

第一种用法中的`[OPTION]... [-T]`末尾提示了`[-T]`,表明这种选项组合有特殊性

>   -T, --no-target-directory   treat LINK_NAME as a normal file always



## ln的四种语法详细说明

1.  `ln [OPTION]... [-T] TARGET LINK_NAME`

这个用法是创建一个名为`LINK_NAME`的链接，指向`TARGET`文件或目录。

- `[OPTION]...`：表示你可以加多个选项，比如 `-s` 表示软链接。
- `[-T]`：是一个可选参数，用于控制是否将链接视为目录（不常使用）。
- `TARGET`：你要链接的目标路径。
- `LINK_NAME`：你想创建的链接名字。

示例：

```bash
ln -s /path/to/file /path/to/symlink
```
在这个示例中，`-s`选项表示创建一个符号链接（symbolic link），`/path/to/file`是链接的目标文件，`/path/to/symlink`是链接名称。



2. `ln [OPTION]... TARGET`

这个其实和上一条是**同一种情况** ，只是省略了 `LINK_NAME`，这时系统会默认在**当前目录**下创建一个**与目标同名的链接**。

默认情况下，链接名称与`TARGET`相同，但创建在当前目录中。

> ⚠️ 这种方式只能在你当前目录下创建链接，且不能用于多个文件。 

- `TARGET`：目标文件。

示例：
```bash
ln p1
```
在当前目录中创建一个名为`p1`的硬链接，指向`p1`文件。

3. `ln [OPTION]... TARGET... DIRECTORY`

这个用法是将一个或多个目标文件`TARGET`链接到指定的目录`DIRECTORY`中。每个链接将**保留目标文件的名称**。
- `TARGET...`：一个或多个目标文件。
- `DIRECTORY`：目标目录。

示例：
```bash
ln p1 p2 /path/to/directory
```
在`/path/to/directory`目录中创建两个硬链接，分别指向`p1`和`p2`。

4. `ln [OPTION]... -t DIRECTORY TARGET...`

这个用法与上一个用法类似，但在选项中显式指定目标目录`DIRECTORY`。
- `DIRECTORY`：目标目录。
- `TARGET...`：一个或多个目标文件。

示例：
```bash
ln -t /path/to/directory p1 p2
```
在`/path/to/directory`目录中创建两个硬链接，分别指向`p1`和`p2`。

### 常用选项
- `-s, --symbolic`：创建符号链接而不是硬链接。
- `-f, --force`：强制覆盖已经存在的链接。
- `-n, --no-dereference`：在目标是符号链接时，不要跟随目标。
- `-T, --no-target-directory`：将链接视为文件而不是目录。
- `-t DIRECTORY, --target-directory=DIRECTORY`：将链接创建在指定的目录中。

### ln示例🎈

#### 创建硬链接：

```bash
ln p1 p2
```
创建一个名为`p2`的硬链接，指向`p1`。

或者说为`p1`创建一个位于`p2`路径下的符号(别名),这样如果的好处是:

- `p1`特别长,输入不方便,就可以利用`p2`来代替
- 又比如`p1`是个定期更新的配置文件或目录路径,而某个应用需要读取固定位置下的配置文件,就可以这样创建`p2`符号路径(指向`p1`)



#### 创建符号链接：

```bash
ln -s p1 symlink
```
创建一个名为`symlink`的符号链接，指向`p1`。

#### 在指定目录中创建链接：

```bash
ln p1 p2 /path/to/directory
```
在`/path/to/directory`目录中创建两个硬链接，分别指向`p1`和`p2`。

#### 强制覆盖已经存在的链接：

```bash
ln -sf p1 existing_symlink
```
创建一个名为`existing_symlink`的符号链接，指向`p1`，并覆盖已有的`existing_symlink`。

以上是`ln`命令的基本用法及常用选项的详细介绍。如果需要更多帮助，可以使用`man ln`命令查看手册页。

#### 综合

为当前目录下的`installer.sh`,`uninstaller.sh`在目标目录`/www/shs`下创建强制性(如果存在同名文件则覆盖)两个同名的符号链接

```bash
ln -sf installer.sh uninstaller.sh /www/shs
```

等价于

```
ln -sf -t /www/shs installer.sh uninstaller.sh 
```





##  linux:硬连接和软连接的对比

```bash
#创建硬链接会改变文件的引用计数
#( 05/24/22@ 2:31PM )( cxxu@cxxuAli ):~/testLink
   ec 'abc'>p1
#( 05/24/22@ 2:31PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 4
1835411 -rw-rw-r-- 1 cxxu cxxu 4 May 24 14:31 p1
#( 05/24/22@ 2:31PM )( cxxu@cxxuAli ):~/testLink
   ln p1 p2_hard
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 8
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 p1
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 p2_hard

#符号链接不会改变引用计数
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ln -s p1 file3_symbolic
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 8
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 p1
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 p2_hard
1835412 lrwxrwxrwx 1 root root 5 May 24 14:32 file3_symbolic -> p1
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   rm p1
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 4
1835411 -rw-rw-r-- 1 cxxu cxxu 4 May 24 14:31 p2_hard
1835412 lrwxrwxrwx 1 root root 5 May 24 14:32 file3_symbolic -> p1
```

###  ls -li

```bash
#( 05/24/22@ 2:38PM )( cxxu@cxxuAli ):~/testLink
   manly ls -l -i

ls - list directory contents
============================

      -i, --inode
              print the index number of each file

      -l     use a long listing format
```

### ls -l

```bash
ls -l p1 
-rw-rw-r--. 1 lilo lilo 0 Feb 26 07:08 p1
```

From the output above we can deduct a following information:

- -rw-rw-r- permissions
- 1 : **number of linked hard-links**
- lilo: owner of the file
- lilo: to which group this file belongs to
- 0: size
- Feb 26 07:08 modification/creation date and time
- p1: file/directory name





## FAQ

###  使用限制

- windows符号链接执行绑定目标(target)地址的时候是硬编码,而且将环境变量转换为就对路径

- 主要是对于多用户(多系统用户)比较受影响
- 对于非用户目录,影响就要小一些.

###  重设符号链接的target

我只知道一个变通的方法(不是原生方法)

- 将原符号链接重命名
- 现在可以以原名设定符号链接
- 利用`rename-item` 重名名
- 删除旧的被重命名的链接



###  中间环境变量对符号链接创建的影响

- 在创建符号链接的时候,不应当使用够过多的中间变量(不超过一层(嵌套))

  - 过多的中转会导致解析错误
  - 例如:未能完全解析成有效路径(绝对路径)
  
  





