[toc]



# 各种链接

- [english version](https://docs.microsoft.com/en-us/windows/win32/fileio/symbolic-links?redirectedfrom=MSDN)
- [chinese verison](https://docs.microsoft.com/zh-cn/windows/win32/fileio/symbolic-links?redirectedfrom=MSDN)

- 在Windows和Linux系统下，<u>符号链接、软连接和硬链接</u>的概念和用途有所不同。以下是它们在这两个操作系统中的区别：
  1. Linux系统：
     - 符号链接（软连接）：在Linux系统中，符号链接和软连接是同一概念。它们是一种特殊的文件，包含了指向另一个文件或目录的路径。符号链接可以跨越不同的文件系统。在Linux中，使用ln -s <target> <link>命令创建符号链接。
     - 硬链接：硬链接是一个指向文件的目录条目，它与原始文件共享相同的inode和数据。硬链接只能在同一文件系统中使用。在Linux中，使用ln <target> <link>命令创建硬链接。
  2. Windows系统：
     - 符号链接：符号链接是一种特殊的文件，它指向另一个文件或目录。符号链接可以跨越不同的文件系统。在Windows中，使用mklink /d <link> <target>命令创建目录符号链接.
     - 硬链接：硬链接是一个指向文件的目录条目，它与原始文件共享相同的文件数据。硬链接只能在同一文件系统中使用。在Windows中，使用mklink /h <link> <target>命令创建硬链接。
     - Junction（连接点）：Junction是Windows系统中的一种特殊目录链接类型，类似于Linux中的符号链接。Junction可以链接到另一个目录，使得该目录中的所有文件和子目录都可以通过Junction访问。Junction只能在同一文件系统中使用。在Windows中，使用mklink /j <link> <target>命令创建Junction。
- 总结:Linux系统中有符号链接（软连接）和硬链接两种链接类型，而Windows系统中有符号链接、硬链接和Junction三种链接类型。在使用这些链接类型时，需要注意它们在不同操作系统中的实现方式和限制。

## 用途

###  直接简化目录名

- 在不影响对当前目录的依赖的同时,为该目录(记为D)起一个别名,可以通过创建D的符号链接来实现

- 特别是使用学校邮箱注册的,创建的目录名老长,还带空格,不好看,但是直接修改会破坏映射关系.\
- 例:`mklink /j d:\org "d:\OneDrive - pop.zjgsu.edu.cn\"`

###  文件搬家

- 对于软件,搬家,可能需要在关机状态下启用修复模式/pe系统下进行
- (不然旧文件夹删不掉,会被占用)

## git管理和符号链接

- 经过粗略的实践,有如下结论
- 在git 仓库中通过`/j` 选项创建的符号链接并绑定的git目录之外的目录,可以被git所管理到
- 对于`/d`选项,行为类似,但是git似乎只能够在初次对外源目录做一次管理,之后的外源目录的变更似乎无法引起git的注意.

## ondrive

- 将某些软件的下载目录通过软连接可用定向到onedrive目录实现自动同步,即便软件本身没有提供下载路径的修改功能

## FAQ



### 权限要求🎈

- 硬链接的创建需要管理员权限

- 硬链接不可以盘(分区)创建

- 只有文件才可以创建硬链接,文件夹(目录)不可以

  - ```powershell
    PS C:\Users\cxxu\Desktop> New-Item -ItemType HardLink -Path todirr -Target $env:desktop\recycleBin\
    New-Item: A file is required for the operation. The item 'C:\Users\cxxu\desktop\recycleBin\' is not a file.
    ```

###  通过本地安全策略来为用户分配指定权限

win+r
输入`secpol.msc`
按如下方法将当前用户添加到`Create symbolic links`权限组中.
![在这里插入图片描述](https://img-blog.csdnimg.cn/4d024b6602504e1d94d0158f247e2e6c.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
但是修改完成后,注销(logout登出)后再登陆才可以生效.

### 关于硬链接

- [shell script - Determining if a file is a hard link or symbolic link? - Unix &amp; Linux Stack Exchange](https://unix.stackexchange.com/questions/167610/determining-if-a-file-is-a-hard-link-or-symbolic-link)
- 简单的说,就是电脑磁盘上的文件具有0个或1个或更多个名字,这些名字就像路牌/指针,系统可以根据指向文件的指针找到文件所在位置(文件实体/文件数据),根据文件系统的组织方式,不同的目录(文件夹)下可以放置了一系列的文件指针,这些指针体现在用户面前就是一个个 `文件`/`目录文件夹`;

### 删除文件/目录对应的操作

那么,当用户删除掉某个 `文件`,这意味这什么?

- 实际上,用户删除掉的只是指向文件的一个指针,如果该指针所绑定的文件恰好就这么一个指针,那么你删除掉该指针,就再也不能找到该文件(在哪里了,效果相当于文件没有了(不可寻));
  - 而一些数据恢复技术也是基于此特点实现的(帮助用户找回文件指针,文件就可用了)
- 而如果某个文件不知有一个指针(名字),那么当其中的一个指针被删除,我们仍然可以通过其他的名字找到该文件,也就是文件仍然可以正常别引用!

### 硬链接的所绑定的target是谁?

- 实际上,通过上述的分析,我们发现,文件的名字其实是平等的,没有谁绑定谁(在文件系统中)所有的路标都是直接指向文件实体,名字和名字之间并无关联,他们唯一的关联就是都直接指向同一个文件;
- 正因为此,我们可以借助已有的硬链接(某一个文件路径path)来创建同等地位的其他硬链接(同一个文件的新路径)(都指向同一个文件)(新的通往"罗马"的道路))
  - 此外,使用powershell查找某个所谓的硬链接(事实上文件系统呈现给用户的文件一般都是硬链接!(处理一些被创建出来的软连接和符号链接)),linktype都是hardlink!

### 创建带有环境变量引用的符号链接

- 为了避免命令解析错误,您应当编写路径参数的时候用引号将参数括起来(尽管您的参数中没有空格)

###  使用`/j`选项还是`/d`选项

- 一般而言,使用/j选项即可
  - /j选项不需要管理员权限即可创建
- 如果使用/d选项创建的符号在移动的时候不会将真实文件夹移动
  - 但是被移动过的符号链接一般就不在具有可用性了
  - 因为符号链接移动后,其绑定的目标目录/文件会发生更改
  - 应该来说,符号链接会将其绑定的对象路径解释(计算)为绝对路径



###  中间环境变量对符号链接创建的影响

- 在创建符号链接的时候,不应当使用够过多的中间变量(不超过一层(嵌套))

  - (过多的中转会导致解析错误)
  - 例如:未能完全解析成有效路径(绝对路径)
  - 这里`.gradle`变量还引用了`androidDepends`变量,mklink 只解释了一层(得到`%androidDepends%\Android\.gradle`,第二层变量`androidDepends`未能解释
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/16094d900228465ba3fd58a553e8edc7.png)



# 创建方法



## windows: cmd下的`mklink`创建链接



### refs

- [mklink | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/mklink)

- mklink:三种模式可以创建不同的链接符号.
  
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

  

- mklink命令是Windows操作系统中的一个命令行工具，用于创建符号链接或硬链接。

- 符号链接是一种特殊的文件，它指向另一个**文件或目录**，就像一个快捷方式一样。

- 硬链接是<u>指向同一文件的多个**文件名**</u>，它们共享相同的数据块。

- 当你需要在Windows操作系统中创建符号链接时，可以使用mklink命令。mklink命令有三个主要的参数：/j、/d和/h。这些参数用于指定符号链接的类型和行为。

#### /j参数：创建目录符号链接

/j参数用于创建目录符号链接。目录符号链接是一种特殊的符号链接，它可以链接到一个目录，使得该目录中的所有文件和子目录都可以通过符号链接访问。使用/j参数创建目录符号链接的语法如下：

`mklink /j <link> <target>`

其中，<link>是符号链接的名称，<target>是符号链接指向的目标目录的路径。

#### /d参数：创建目录符号链接（兼容旧版Windows）

/d参数也用于创建目录符号链接，但它与/j参数不同的是，它可以在旧版的Windows操作系统中使用。使用/d参数创建目录符号链接的语法如下：

`mklink /d <link> <target>`

#### /h参数：创建文件符号链接

/h参数用于创建文件符号链接。文件符号链接是一种特殊的符号链接，它可以链接到一个文件，使得该文件可以通过符号链接访问。使用/h参数创建文件符号链接的语法如下：

`mklink /h <link> <target>`

其中，<link>是符号链接的名称，<target>是符号链接指向的目标文件的路径。

需要注意的是，符号链接的名称和标路径都可以是相对路径或绝对路径。如果使用相对路径，那么符号链接和目标路径都是相对于当前工作目录的。如果使用绝对路径，那么符号链接和目标路径都是绝对路径。

#### Note

- 请注意，硬链接只能在同一驱动器上创建，而符号链接可以跨驱动器创建。

### 权限要求🎈

- 使用`管理员权限`打开终端命令行

- 部分目录的文件(比如系统目录)不允许被创建硬链接

  - ```bash
    C:\Users\cxxu\Desktop# mklink /h C:\Users\cxxu\Desktop\test_pad  C:\Windows\System32\notepad.exe
    Access is denied.
    ```

- 虽然可能允许创建符号链接,但是可能并无意义(例如创建的链接打不开)

  - ```bash
    C:\Users\cxxu\Desktop#  mklink /d C:\Users\cxxu\Desktop\test_pad.exe C:\Windows\System32\notepad.exe
    symbolic link created for C:\Users\cxxu\Desktop\test_pad.exe <<===>> C:\Windows\System32\notepad.exe
    ```

- 在powershell 下使用`cmd /C`来执行`mklink`命令

  - ```bash
    PS C:\Users\cxxu\Desktop> cmd /C mklink /h $env:USERPROFILE\desktop\test_byHardlink.pdf  C:\users\cxxu\Desktop\test.pdf
    Hardlink created for C:\Users\cxxu\desktop\test_byHardlink.pdf <<===>> C:\users\cxxu\Desktop\test.pdf
    ```

  

## powershell 创建链接

- 帮助文档:
  -  ` help about_FileSystem_Provider`
  -  `help new-item`
  -  [refenrence link](https://winaero.com/create-symbolic-link-windows-10-powershell/)
- 通过`new-item -itemType hardlink `进行创建

- 注意,使用-target 相对路径无法成功创建,需要使用绝对路径
- 幸运的是,我们可以利用pwd来优化这一点

- 以下函数经过一定的处理,使得用户可以仅仅输入相对路径就可以创建硬连接

```powershell
function newHardLink
{
    param(
        $Path = 'slides.md',
        [String]$target 
    )
    # 下面这段判断处理可有可无
    <# if ($target.ToString().StartsWith(".\")) {
        $target=$target.TrimStart(".\")
    } #>
    # $absTarget = "$pwd\" + "$target"
    $absTarget = (Get-ChildItem $target).FullName
    Write-Output "$absTarget will be target!"
    # $absTarget = Invoke-Expression $absTarget
    Write-Output "@$absTarget"
    # $absTarget = $pwdPrefix + $target
    Write-Output '@注意,Target必须使用绝对路径!'
    Write-Output "@当然,也可以是这样的表达式:`"`$pwd\\file`""
    Write-Output '@带上-target 选项'
    if (Test-Path $Path)
    {
        rmFV $Path
    }
    New-Item -ItemType HardLink -Path $Path -Target $absTarget -Force -Verbose
}
```

- 经过初步测试,该函数能够兼容Target 参数为相对路径以及完整路径的情况

### powershell获取文件绝对路径

- 两种方式:
  - `    $absTarget = (Get-ChildItem $pattern).FullName`
  - `rvpa $path`

##   linux shell 创建硬链接

- ` man ln|nl|less`查看命令ln命令详情

- target是指,需要被创建链接的文件/目录名(变量)

  - 在带`...`的用法中,可以同时指定多个target源(譬如用法3/4)
  - 用法三可以同时在一个目录中创建多个链接

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

  

###  例

#### 例1

- 创建指向python3.10(二进制文件)的符号链接`symbolic link`

```bash
# cxxu_kali @ CxxuWin11 in ~/dirToSymlinks [15:50:38] C:1
$ ln -s  /usr/bin/python3.10 py3

# cxxu_kali @ CxxuWin11 in ~/dirToSymlinks [15:51:01]
$ ll
total 0
lrwxrwxrwx 1 cxxu_kali cxxu_kali 19 Apr  5 15:51 py3 -> /usr/bin/python3.10
```

#### 例2

- 利用符号链接给文件多加一个名字

```bash
# cxxu_kali @ CxxuWin11 in ~ [15:55:01] C:130
$ ln  numbers num -s
```

###  检查链接🎈



###  ls -l

该选项可以检查某个目录下的`symbolic link`
链接会以箭头指示

```bash
# cxxu @ cxxuAli in /usr/bin [15:34:47] C:130
$ ls -1l python*
lrwxrwxrwx 1 root root       9 Apr 16  2018 python -> python2.7
lrwxrwxrwx 1 root root       9 Apr 16  2018 python2 -> python2.7
-rwxr-xr-x 1 root root 3633000 Feb 27  2021 python2.7
lrwxrwxrwx 1 root root       9 Feb  8 14:51 python3 -> python3.6
-rwxr-xr-x 2 root root 4526456 Dec  9 05:08 python3.6
lrwxrwxrwx 1 root root      33 Dec  9 05:08 python3.6-config -> x86_64-linux-gnu-python3.6-config
-rwxr-xr-x 2 root root 4526456 Dec  9 05:08 python3.6m
lrwxrwxrwx 1 root root      34 Dec  9 05:08 python3.6m-config -> x86_64-linux-gnu-python3.6m-config
lrwxrwxrwx 1 root root      16 Oct 25  2018 python3-config -> python3.6-config
lrwxrwxrwx 1 root root      10 Feb  8 14:51 python3m -> python3.6m
lrwxrwxrwx 1 root root      17 Oct 25  2018 python3m-config -> python3.6m-config
```

###  file 命令

- 该命令可能需要手动安装
- 可以识别出`symbolic link`以及链接的target.

```bash
# cxxu @ cxxuAli in /usr/bin [15:37:52]
$ file python3
python3: symbolic link to python3.6

```

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

- 符号链接,千好万好,就是太过于逼真(尽管在图标上可以看出和普通目录的区别,但是在原管理器中(路径属性)的显示中,并不容易看出符号链接到底指向哪里

- `/d`选项创建的符号可以通过右键看到target属性(即它指向的目录)
- `/j`选项创建的符符号难以通过右键来识别其绑定的目录
  好在,我们可以使用cmd(而不是powershell)的`dir`命令来查看这些符号(指针)所指向的目录

## cmd下dir命令查看

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


##  powershell来查看符号连接的类型与其target

- `ls | Format-Table name,LinkType,Target`

- 简写为`ls | ft name,LinkType,Target`

- ```bash
  PS C:\Users\cxxu> ls |where {$_.LinkType}|ft name,LinkType,LinkTarget
  
  Name         LinkType     LinkTarget
  ----         --------     ----------
  android_test SymbolicLink D:\android
  downloads    Junction     D:\usersByCxxu\DownloadsAll\
  ser          Junction     D:\repos\ccser\emotion-recognition-using-speech\
  ```

- 包装为函数:

  - ```bash
    
    function get_links_of_type{
        <# 
        .SYNOPSIS
        查看指定类型的链接,以表格的形式输出(包括:name,linktype,linktarget)
        可用的类型包括:hardlink,symboliclink,junction
        默认不区分大小写.
         #>
        param(
            $linkType=''
        )
        Get-ChildItem $dir| Where-Object { $_.LinkType -eq $linkType} | Format-Table name, LinkType, LinkTarget
    }
    
    function get_links_in_dir
    {
        <# 
        .SYNOPSIS
        如果没有指定类型,则查看所有的链接
        否则仅查看指定连接类型的来连接
        #>
        param(
            $dir='.',
            $linkType=''
        )
        if ($linkType -eq ''){
    
            Get-ChildItem $dir| Where-Object { $_.LinkType } | Format-Table name, LinkType, LinkTarget
        }
        # elif($linkType -eq 'Junction'):
        else{
            get_links_of_type -linkType $linkType
        }
        
    }
    
    ```

    

- 如果您了解powershell的一些基本技巧,那么可以对他进行个性化的排序等高级操作

- 譬如:我希望优先看到符号连接相关项目(符号连接绑定的地址在名字的箭头后方(当然,您可以配合前面字段投影技巧)来更加自定义显示效果

- ```bash
  PS C:\Users\cxxu> ls|sort -Property Target -Descending
  
          Directory: C:\Users\cxxu
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  l----        2022/12/28     20:38                  downloads  D:\usersByCxxu\DownloadsAll\
  l----         2023/3/27     16:09                  ser  D:\repos\ccser\emotion-recognition-using-speech\
  l----         2023/5/24     20:37                  android_test  D:\android
  d----         2023/5/24     14:28                  .android
  ....
  
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

- 带统计的版本:

  - ```powershell
    function get_links_count {
        param (
        )
        $step = Get-ChildItem | Sort-Object -Property target  | Select-Object name, linktype, target|where {$_.Target }
        Write-Output $step "-------------"
    
        Write-Output "itemsCount: $($step.count)"
    
    }
    ```


  - 查询当前目录中存在的符号连接以及对应的类型：

    - ```bash
      PS C:\Users\c	xxu> get_links_count
      
      Name         LinkType     Target
      ----         --------     ------
      android_test SymbolicLink D:\android
      ser          Junction     D:\repos\ccser\emotion-recognition-using-speech\
      downloads    Junction     D:\usersByCxxu\DownloadsAll\
      -------------
      itemsCount: 3
      ```

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









