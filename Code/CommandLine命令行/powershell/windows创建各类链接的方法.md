[toc]

# windows上创建各类链接的方法汇总



## windows: cmd下的`mklink`创建链接



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



##   linux shell 创建硬链接

- [ln(1) - Linux manual page (man7.org)](https://www.man7.org/linux/man-pages/man1/ln.1.html)

- - 

- ```bash
  NAME
         ln - make links between files
  
  SYNOPSIS
         ln [OPTION]... [-T] TARGET LINK_NAME
         ln [OPTION]... TARGET
         ln [OPTION]... TARGET... DIRECTORY
         ln [OPTION]... -t DIRECTORY TARGET...
  
  DESCRIPTION
         In  the  1st  form,  create a link to TARGET with the name LINK_NAME.  In the 2nd
         form, create a link to TARGET in the current  directory.   In  the  3rd  and  4th
         forms,  create  links to each TARGET in DIRECTORY.  Create hard links by default,
         symbolic links with --symbolic.  By default, each destination (name of new  link)
         should  not  already  exist.   When  creating hard links, each TARGET must exist.
         Symbolic links can hold arbitrary text; if later resolved, a relative link is in‐
         terpreted in relation to its parent directory.
  
         Mandatory arguments to long options are mandatory for short options too.
  
         --backup[=CONTROL]
                make a backup of each existing destination file
  
         -b     like --backup but does not accept an argument
  
         -d, -F, --directory
                allow the superuser to attempt to hard link directories (note: will proba‐
                bly fail due to system restrictions, even for the superuser)
  
         -f, --force
                remove existing destination files
        ....
  
  ```

  

`ln` 命令用于在文件之间创建链接。链接可以是硬链接（hard link）或者符号链接（symbolic link）。以下是`ln`命令的基本用法及其各个选项的详细说明。

### NAME
`ln` - 在文件之间创建链接

### SYNOPSIS
1. `ln [OPTION]... [-T] TARGET LINK_NAME`
2. `ln [OPTION]... TARGET`
3. `ln [OPTION]... TARGET... DIRECTORY`
4. `ln [OPTION]... -t DIRECTORY TARGET...`

### 详细说明

1. `ln [OPTION]... [-T] TARGET LINK_NAME`

这个用法是创建一个名为`LINK_NAME`的链接，指向`TARGET`文件或目录。
- `TARGET`：目标文件或目录。
- `LINK_NAME`：链接名称。

示例：
```bash
ln -s /path/to/file /path/to/symlink
```
在这个示例中，`-s`选项表示创建一个符号链接（symbolic link），`/path/to/file`是目标文件，`/path/to/symlink`是链接名称。

2. `ln [OPTION]... TARGET`

这个用法是创建一个指向`TARGET`的硬链接。默认情况下，链接名称与`TARGET`相同，但创建在当前目录中。
- `TARGET`：目标文件。

示例：
```bash
ln file1
```
在当前目录中创建一个名为`file1`的硬链接，指向`file1`文件。

3. `ln [OPTION]... TARGET... DIRECTORY`

这个用法是将一个或多个目标文件`TARGET`链接到指定的目录`DIRECTORY`中。每个链接将保留目标文件的名称。
- `TARGET...`：一个或多个目标文件。
- `DIRECTORY`：目标目录。

示例：
```bash
ln file1 file2 /path/to/directory
```
在`/path/to/directory`目录中创建两个硬链接，分别指向`file1`和`file2`。

4. `ln [OPTION]... -t DIRECTORY TARGET...`

这个用法与上一个用法类似，但在选项中显式指定目标目录`DIRECTORY`。
- `DIRECTORY`：目标目录。
- `TARGET...`：一个或多个目标文件。

示例：
```bash
ln -t /path/to/directory file1 file2
```
在`/path/to/directory`目录中创建两个硬链接，分别指向`file1`和`file2`。

### 常用选项
- `-s, --symbolic`：创建符号链接而不是硬链接。
- `-f, --force`：强制覆盖已经存在的链接。
- `-n, --no-dereference`：在目标是符号链接时，不要跟随目标。
- `-T, --no-target-directory`：将链接视为文件而不是目录。
- `-t DIRECTORY, --target-directory=DIRECTORY`：将链接创建在指定的目录中。

### 示例
1. 创建硬链接：
```bash
ln file1 file2
```
创建一个名为`file2`的硬链接，指向`file1`。

2. 创建符号链接：
```bash
ln -s file1 symlink
```
创建一个名为`symlink`的符号链接，指向`file1`。

3. 在指定目录中创建链接：
```bash
ln file1 file2 /path/to/directory
```
在`/path/to/directory`目录中创建两个硬链接，分别指向`file1`和`file2`。

4. 强制覆盖已经存在的链接：
```bash
ln -sf file1 existing_symlink
```
创建一个名为`existing_symlink`的符号链接，指向`file1`，并覆盖已有的`existing_symlink`。

以上是`ln`命令的基本用法及常用选项的详细介绍。如果需要更多帮助，可以使用`man ln`命令查看手册页。



## 检查链接🎈

主要是针对SymbolicLink的检查,而windows上还可以检查junction类型的链接

而HardLink由于其特点而不像其他类型链接那样容易检查,但是可以计数一个文件具有多少个Hardlink

### linux下检查

####  ls -l 命令

该选项可以检查某个目录下的`symbolic link`
链接会以箭头指示

```bash
# cxxu @ cxxuAli in /usr/bin [15:34:47] C:130
$ ls -1l python*
...
lrwxrwxrwx 1 root root      16 Oct 25  2018 python3-config -> python3.6-config
lrwxrwxrwx 1 root root      10 Feb  8 14:51 python3m -> python3.6m
lrwxrwxrwx 1 root root      17 Oct 25  2018 python3m-config -> python3.6m-config
```

####  file 命令

- 该命令可能需要手动安装
- 可以识别出`symbolic link`以及链接的target.

```bash
# cxxu @ cxxuAli in /usr/bin [15:37:52]
$ file python3
python3: symbolic link to python3.6

```

### windows下检查



#### cmd下dir命令查看

- 两种方式执行`dir`

  - 在cmd下直接执行`dir`
    - 对于powershell用户,可以在powershell中输入`cmd`即可切换到cmd,然后执行`dir`

  - 在powershell下直接执行`cmd /c dir`

  ```bash
  PS C:\Users\cxxu\AppData\Local> cmd /c dir
   Volume in drive C is win11
   Volume Serial Number is EC48-2060
  
   Directory of C:\Users\cxxu\AppData\Local
  
  2023/05/24  15:12    <DIR>          .
  2023/03/05  13:59    <DIR>          0install.net
  ...
  2023/05/24  15:12    <JUNCTION>     Android [\??\D:\Android]
  ...
  2023/04/07  18:15    <DIR>          cache
  2023/01/20  11:35    <DIR>          calibre-cache
  ..
  2023/05/24  20:37    <SYMLINKD>     android_test [D:\android]
  ...
  ```

  - 可以看到,`junction`类型和`symbol`的类型链接被显示出来.


####  powershell来查看符号连接的类型与其target

- `ls | Format-Table name,LinkType,Target`,其中`Format-Table`可以简写为`ft`

- ```bash
  PS C:\Users\cxxu> ls |where {$_.LinkType}|ft name,LinkType,LinkTarget
  
  Name         LinkType     LinkTarget
  ----         --------     ----------
  android_test SymbolicLink D:\android
  downloads    Junction     D:\usersByCxxu\DownloadsAll\
  ser          Junction     D:\repos\ccser\emotion-recognition-using-speech
  ```

  

- 过滤掉(不显示)非链接类型

  - `Get-ChildItem | Sort-Object -Property target -Descending | Select-Object name, linktype, target|where {$_.Target }`

  - ```bash
    PS C:\Users\cxxu> Get-ChildItem | Sort-Object -Property target -Descending | Select-Object name, linktype, target|where {$_.Target }
    
    Name         LinkType     Target
    ----         --------     ------
    downloads    Junction     D:\usersByCxxu\DownloadsAll\
    ser          Junction     D:\repos\ccser\emotion-recognition-using-speech\
    android_test SymbolicLink D:\android
    ```

#### powershell函数

```powershell

function Get-LinksOfType
{
    <# 
    .SYNOPSIS
    查看指定类型的链接,以表格的形式输出(包括:name,linktype,linktarget)
    可用的类型包括:hardlink,symboliclink,junction
    默认不区分大小写.
    .EXAMPLE
    PS☀️[BAT:71%][MEM:36.25% (11.49/31.71)GB][22:20:59]
    # [cxxu@COLORFULCXXU][~\Desktop]
    PS> pwsh
    PowerShell 7.4.2
    PS C:\Users\cxxu\Desktop> get-LinksOfType -Directory C:\Users\cxxu -LinkType symboliclink

    Name  LinkType     LinkTarget
    ----  --------     ----------
    repos SymbolicLink C:\repos

    .EXAMPLE
    PS C:\Users\cxxu\Desktop> get-LinksOfType -Directory ./ -LinkType symboliclink

    Name             LinkType     LinkTarget
    ----             --------     ----------
    symbolDir        SymbolicLink T:\DirInFat32\
    TestSymbolicLink SymbolicLink U:\demo.txt
    
    .EXAMPLE
    PS C:\Users\cxxu\Desktop> get-LinksOfType

    Name             LinkType     LinkTarget
    ----             --------     ----------
    demo.txt         HardLink
    symbolDir        SymbolicLink T:\DirInFat32\
    TestSymbolicLink SymbolicLink U:\demo.txt
     #>
    param(
        [Alias('D')]$Directory = '.',
        [validateset( 'symboliclink', 'junction', 'hardlink' , 'all')]$LinkType = 'all'

    )
    $all = Get-ChildItem $Directory | Where-Object { $_.LinkType } | Sort-Object -Property LinkType
    $Specifiedtype = $all | Where-Object { $_.LinkType -eq $linkType } 
    $res = ($LinkType -eq 'all') ? $all : $Specifiedtype
    $res = $res | Format-Table name, LinkType, LinkTarget
    return $res
}
```



## 

##  linux:硬连接和软连接的对比

### ref

- <<操作系统概念>>
- <<计算机操作系统(汤)>>

- 符号链接不具有被链接的文件的inode(index number)信息
- 符号链接仅仅包含被链接文件的`路径名`
- 被链接的文件名(指针)被删除后,该符号链接就无法正确引用文件(尽管,文件本体可以被文件的其他指针(硬连接)找到(换句话说,尽管文件的引用计数count值哪怕不是0,符号链接都不能够确保能够正确引用文件

下面的实验中,注意`ls -li`第3个字段,每当一个inode(index number)增加一个硬连接,数字就会加1;删除,则数字减一;

- 而符号链接和文件的inode (index number)关系就比较松散,遂,发生了符号链接所指的文件名已经被删除了,但是符号链接依然还是指着那个不再存在的文件名(尽管文件名对应的文件还存在着(任然可以通过文件的另一个名字file2来访问)

```bash
#( 05/24/22@ 2:31PM )( cxxu@cxxuAli ):~/testLink
   ec 'abc'>file1
#( 05/24/22@ 2:31PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 4
1835411 -rw-rw-r-- 1 cxxu cxxu 4 May 24 14:31 file1
#( 05/24/22@ 2:31PM )( cxxu@cxxuAli ):~/testLink
   ln file1 file2_hard
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 8
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 file1
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 file2_hard
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ln -s file1 file3_symbolic
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 8
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 file1
1835411 -rw-rw-r-- 2 cxxu cxxu 4 May 24 14:31 file2_hard
1835412 lrwxrwxrwx 1 root root 5 May 24 14:32 file3_symbolic -> file1
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   rm file1
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   ls -li
total 4
1835411 -rw-rw-r-- 1 cxxu cxxu 4 May 24 14:31 file2_hard
1835412 lrwxrwxrwx 1 root root 5 May 24 14:32 file3_symbolic -> file1
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   bat file2_hard
───────┬───────────────────────────────────────────────────────────────────────────────────
       │ File: file2_hard
       │ Size: 4 B
───────┼───────────────────────────────────────────────────────────────────────────────────
   1   │ abc
───────┴───────────────────────────────────────────────────────────────────────────────────
#( 05/24/22@ 2:32PM )( cxxu@cxxuAli ):~/testLink
   bat file3_symbolic
[bat error]: 'file3_symbolic': No such file or directory (os error 2)
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
ls -l file1 
-rw-rw-r--. 1 lilo lilo 0 Feb 26 07:08 file1
```

From the output above we can deduct a following information:

- -rw-rw-r- permissions
- 1 : **number of linked hard-links**
- lilo: owner of the file
- lilo: to which group this file belongs to
- 0: size
- Feb 26 07:08 modification/creation date and time
- file1: file/directory name



#  辨识符号链接🎈

## refs

- [shell script - Determining if a file is a hard link or symbolic link? - Unix &amp; Linux Stack Exchange](https://unix.stackexchange.com/questions/167610/determining-if-a-file-is-a-hard-link-or-symbolic-link)

- 符号链接,千好万好,就是太过于逼真
  - 尽管在图标上可以看出和普通目录的区别,但是在原管理器中(路径属性)的显示中,并不容易看出符号链接到底指向哪里

- `/d`选项创建的符号可以通过右键看到target属性(即它指向的目录)
- `/j`选项创建的符符号难以通过右键来识别其绑定的目录
  好在,我们可以使用cmd(而不是powershell)的`dir`命令来查看这些符号(指针)所指向的目录

## FAQ

###  使用限制

- windows符号链接执行绑定目标(target)地址的时候是硬编码,而且将环境变量转换为就对路径

- 主要是对于多用户(多系统用户)比较受影响
- 对于非用户目录,影响就要小一些.

###  重设符号链接的target

我只知道一个变通的方法(不是原生方法)

- 将原符号链接重命名
  - ![](https://img-blog.csdnimg.cn/img_convert/c27adbaaab9a3fd1b7b0b88e80ee4ec3.png)
- 现在可以以原名设定符号链接
  - 	利用`rename-item` 重名名
- 删除旧的被重命名的链接
  - ![](https://img-blog.csdnimg.cn/img_convert/8942d92680ca4d95bef3b375b98e555e.png)

###  符号链接与IDE

比如.在IDEA中,符号链接的识别效果和快捷方式的识别效果
![在这里插入图片描述](https://img-blog.csdnimg.cn/3022f7c2dd5b426d884d7ea9453ff497.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_10,color_FFFFFF,t_70,g_se,x_16)







###  中间环境变量对符号链接创建的影响

- 在创建符号链接的时候,不应当使用够过多的中间变量(不超过一层(嵌套))

  - (过多的中转会导致解析错误)
  - 例如:未能完全解析成有效路径(绝对路径)
  - 这里`.gradle`变量还引用了`androidDepends`变量,mklink 只解释了一层(得到`%androidDepends%\Android\.gradle`,第二层变量`androidDepends`未能解释
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/16094d900228465ba3fd58a553e8edc7.png)





