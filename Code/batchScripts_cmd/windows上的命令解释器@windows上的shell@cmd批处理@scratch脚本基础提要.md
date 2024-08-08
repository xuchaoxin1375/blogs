[toc]





## 引言

在日常的计算机操作中，我们经常会遇到需要重复执行的任务，比如备份文件、自动安装软件或者进行系统维护等。这时候，如果能够编写一些脚本来自动化这些任务，将会极大地提高我们的工作效率。

CMD脚本（也称为批处理脚本）就是一种非常实用的工具，它允许我们在Windows操作系统上轻松地实现自动化任务。

CMD实际上早就不在被推荐为首选的windows脚本语言,取而代之的是powershell

### windows上的命令行和两类shell



- [Windows 命令 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/windows-commands)
- [cmd | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/cmd) 古老windows自带的命令解释器
- 官方鼓励想要使用更高级功能的用户探索 [PowerShell](https://learn.microsoft.com/zh-cn/powershell/)，获取增强的脚本功能和自动化功能。

### windows的两种shell相互调用



并且个别情况下使用cmd的命令可以用powershell 内以`cmd /c <cmd command lines>`来运行,也就是说,几乎可以不用离开powershell而执行任何可用命令

另一方面，我们也可以在cmd中调用或运行powershell命令行或脚本

值得注意的是，powershell更佳注重安全性，版本又比较杂，如果不是本地编写并保存的powershell脚本文件默认是无法被直接执行的，需要进行执行策略的配置才行

这就引出了一系列问题：如何修改执行策略，如果临时或者长期有效地修改执行策略、如何查看当前的执行策略，本指定计算机的不同用户或角色的执行策略分别是什么，详情查看以下文档

- [关于执行策略 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.4)



总得来说，对于一个小白用户，要让其尽可能简单的执行脚本或命令行，那么使用`cmd`脚本文件比`powershell`脚本文件更方便

### 远程协助脚本方案

假设你要帮助某个小白用户执行一段修改系统设置的脚本,您可以有如下选择:

- 如果你了解cmd,并且能够用它完成需要,那么只需要写一个cmd批处理脚本文件,发送给对方执行

- 如果你只了解powershell,而不了解cmd,那么你可以用powershell语言编写脚本的功能,不妨记为`function.ps1`,然后再创建一个`cmd`脚本`start_function.cmd`来调用`function.ps1`,里面的内容可以形如

  ```cmd
  powershell -executionpolicy bypass -file function.ps1 
  ::#注意function.ps1和start_function.cmd要放在同一个目录中
  :: 这个语句把执行策略临时设置为bypass,以便function.ps1中的命令能够执行而不会被系统阻止
  ```

  如果运行的是最新版的`powershell`,那么可以将其中的语句powershell替换为`pwsh`

例如

```powershell
C:\Users\cxxu\Desktop>pwsh -executionpolicy bypass -file C:\users\cxxu\desktop\demo.ps1

    Directory: C:\Users\cxxu\Desktop

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            2024/8/8    17:11             67 demo.cmd
-a---            2024/8/8    17:10             10 demo.ps1
-a---            2024/8/7    12:12             50 MK.cmd
Press Enter to continue...:
```

用cmd包装powershell脚本

```powershell
PS C:\Users\cxxu\Desktop> 'pwsh -executionpolicy bypass -file C:\users\cxxu\desktop\demo.ps1'>demo.cmd
PS C:\Users\cxxu\Desktop> .\demo.cmd
#执行结果和上面的一样
C:\Users\cxxu\Desktop>pwsh -executionpolicy bypass -file C:\users\cxxu\desktop\demo.ps1

    Directory: C:\Users\cxxu\Desktop

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            2024/8/8    17:11             67 demo.cmd

```



## 为什么要了解cmd

但是为什么仍然提及cmd批处理,是因为cmd支持古老的windows,即便是现在的windows在未来很长一段时间将继续存在,以确保系统的兼容性足够好

网络上流传着大量批处理脚本(.bat或.cmd),后缀不是重点,基本都是用`cmd`语法进行编写的,cmd虽然不如最新的powershell强大和跨平台,但是在windows上不仅兼容老系统,而且占用资源低,启动速度快;这一点可以和powershell互补。

许多软件同时提供了cmd,powershell的启动脚本,例如编程环境anaconda,克隆与同步软件Rclone等把cmd作为首选命令行启动器

### CMD脚本是什么？

CMD脚本是由一系列命令组成的文本文件，这些命令可以在Windows的命令行解释器（CMD.exe）中运行。

当您运行一个批处理文件时，CMD会按照文件中的顺序依次执行每一行命令。CMD脚本可以用来执行一系列复杂的任务，如文件管理、系统配置、数据处理等。

### 必备知识

在开始之前，您需要确保已经熟悉以下基础命令,然后便于我们使用cmd的语法来组织cmd命令或系统命令或调用用户安装的命令：
- 基本的Windows命令行操作（如`echo`,`dir`, `cd`, `copy`等)
- 文件和文件夹的基本操作（如创建、删除、移动等）`mkdir`,`rmdir`,`del`,`mv`
- 如果不熟悉,可以通过`commandName /?`形式获取帮助,或者阅读在线文档,越是基础的命令往往用法越是灵活,参数选项多样,我们了解最核心的用法即可）
- 阅读命令行的语法记号:[命令行语法项 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/command-line-syntax-key)

## 创建脚本文件的方法

- 脚本文件是一个文本文件,创建或获取一个脚本文件的方式有许多
  - 自己新建一个文本文件,然后用文本编辑器(比如基础的自带的记事本notepad),打开并编辑这个文本,最后将这个文件改名,尤其是扩展名(后缀)修改为脚本文件后缀名,对于cmd脚本,可以修改为`.cmd`或者`.bat`,如果是powershell脚本,那么后缀为`.ps1`(这里不讨论)
  - 从网络上下载脚本到本地运行,例如github上开源的脚本文件,具有特定的功能

## 创建第一个简单的脚本

让我们从一个简单的例子开始。假设您需要一个脚本来列出当前目录下的所有文件。您可以创建一个名为`list_files.cmd`的文件，并在其中输入以下内容：

```batch
@echo off
dir
pause
```

- `@echo off`：这条命令会关闭命令的回显，即不会显示接下来要执行的命令。
- `dir`：这条命令会列出当前目录下的所有文件和子目录。

保存文件后，在命令行中切换到该文件所在的目录，并运行：

```batch
list_files.cmd
```

您应该能看到当前目录下所有的文件和子目录被列出来了。

## 基础概念

### 变量

CMD脚本支持变量，您可以使用它们来存储和引用数据。变量有两种类型：环境变量和脚本变量。

#### 环境变量

环境变量是在整个系统范围内定义的，可以通过`set`命令查看：

例如

```batch
C:\Users\cxxu\Desktop>set
ALLUSERSPROFILE=C:\ProgramData
APPDATA=C:\Users\cxxu\AppData\Roaming
CommonProgramFiles=C:\Program Files\Common Files
CommonProgramFiles(x86)=C:\Program Files (x86)\Common Files
CommonProgramW6432=C:\Program Files\Common Files
...
```

#### 脚本变量

脚本变量是在脚本内部定义的，只能在脚本执行期间使用。定义变量的方式如下：

```batch
set variable_name=value
```

使用变量的方式如下(加上一对`%`号：

```batch
echo %variable_name%
```

例如：

```batch
set myVar=Hello, World!
echo %myVar%
```

和powershell等其他脚本或变成语言不通,cmd中设置带空格字符串的变量不需要用引号包裹

### 条件判断

CMD脚本支持基本的条件判断结构，可以使用`if`命令来进行逻辑判断。


#### 1. `IF` 语句

`IF` 语句用于判断某个条件是否为真。如果条件为真，则执行相应的命令。

```
IF condition (command)
```

##### 例子：

```cmd
IF %USERNAME%==admin echo Hello Admin
```

#### 2. `IF NOT` 语句

`IF NOT` 用于判断条件是否为假。如果条件为假，则执行相应的命令。

```
IF NOT condition (command)
```

##### 例子：

```cmd
IF NOT %USERNAME%==admin echo You are not an admin
```

#### 3. `IF EXIST` 和 `IF NOT EXIST` 语句

`IF EXIST` 用于判断某个文件或目录是否存在。如果存在，则执行相应的命令。`IF NOT EXIST` 则相反，用于判断文件或目录是否不存在。

```
IF EXIST filename (command)
IF NOT EXIST filename (command)
```

##### 例子：

```cmd
IF EXIST C:\test.txt echo File exists
IF NOT EXIST C:\test.txt echo File does not exist
```

### 高级用法

#### 1. 复杂条件判断

可以使用逻辑运算符（如 `AND` 和 `OR`）来组合多个条件。

##### 例子：

```cmd
IF %USERNAME%==admin IF EXIST C:\test.txt echo Admin and file exists
```

#### 2. 使用变量进行条件判断

可以使用环境变量进行条件判断。

##### 例子：

```cmd
SET var=1
IF %var%==1 echo Variable is 1
```

#### 3. `IF` 语句中的 ELSE

可以在 `IF` 语句中使用 `ELSE` 来处理条件不成立的情况。

##### 例子：

```cmd
IF %USERNAME%==admin (
    echo Hello Admin
) ELSE (
    echo You are not an admin
)
```

### 示例总结

以下是一个综合使用条件判断的示例脚本：

```cmd
@echo off
SET var=2

IF %var%==1 (
    echo Variable is 1
) ELSE IF %var%==2 (
    echo Variable is 2
) ELSE (
    echo Variable is not 1 or 2
)

IF EXIST C:\test.txt (
    echo File exists
) ELSE (
    echo File does not exist
)

IF %USERNAME%==admin (
    echo Hello Admin
) ELSE (
    echo You are not an admin
)
```

这个示例展示了如何使用 `IF` 和 `IF EXIST` 进行条件判断，并结合 `ELSE` 语句处理不同的情况。通过这些条件判断，CMD 脚本可以变得更加灵活和强大。

### 循环结构

CMD脚本支持两种循环结构：`for`循环和`while`循环。

#### `for`循环

`for`循环可以用来遍历一系列的项或执行特定次数的命令。

#### 示例

打印出从1到10的数字：

```batch
@echo off
for /L %%i in (1,1,10) do (
    echo %%i
)
```

#### `while`循环

`while`循环会在满足某个条件时重复执行一组命令。

#### 示例

使用`while`循环来打印数字1到5：

```batch
@echo off
set i=1
:loop
if %i% leq 5 (
    echo %i%
    set /a i+=1
    goto :loop
)
```

## 实战案例

现在我们来编写一个稍微复杂一点的脚本，这个脚本可以帮助我们备份指定文件夹下的所有文件到另一个位置。

### 脚本代码

```batch
@echo off
setlocal enabledelayedexpansion

set "sourceFolder=C:\Users\YourName\Documents"
set "backupFolder=C:\Backup\Documents"

if not exist "!backupFolder!" mkdir "!backupFolder!"

echo Backing up files from !sourceFolder! to !backupFolder!...

xcopy "!sourceFolder!\*" "!backupFolder!" /s /e /y

echo Backup complete.
pause
```

### 解释

- `setlocal enabledelayedexpansion`：启用延迟变量扩展，允许在循环中使用变量。
- `set "sourceFolder=C:\Users\YourName\Documents"`：设置源文件夹。
- `set "backupFolder=C:\Backup\Documents"`：设置备份文件夹。
- `if not exist "!backupFolder!" mkdir "!backupFolder!"`：如果备份文件夹不存在，则创建它。
- `xcopy "!sourceFolder!\*" "!backupFolder!" /s /e /y`：复制文件夹及其内容到备份文件夹，覆盖已存在的文件。
- `pause`：暂停脚本，等待用户按任意键退出。

## 总结

通过这篇文章，您已经学习了CMD脚本的基础知识，包括如何创建简单的脚本、使用变量、条件判断和循环结构。掌握了这些基础之后，您可以尝试编写更复杂的脚本来解决实际问题。CMD脚本虽然简单，但在自动化日常任务方面却非常实用。

