[toc]





## 引言

在日常的计算机操作中，我们经常会遇到需要重复执行的任务，比如备份文件、自动安装软件或者进行系统维护等。这时候，如果能够编写一些脚本来自动化这些任务，将会极大地提高我们的工作效率。

CMD脚本（也称为批处理脚本）就是一种非常实用的工具，它允许我们在Windows操作系统上轻松地实现自动化任务。

CMD实际上早就不在被推荐为首选的windows脚本语言,取而代之的是powershell

并且个别情况下使用cmd的命令可以用powershell 内以`cmd /c <cmd command lines>`来运行,也就是说,几乎可以不用离开powershell而执行任何可用命令

但是为什么仍然提及cmd批处理,是因为cmd支持古老的windows,即便是现在的windows在未来很长一段时间将继续存在,以确保系统的兼容性足够好

网络上流传着大量批处理脚本(.bat或.cmd),后缀不是重点,基本都是用`cmd`语法进行编写的,cmd虽然不如最新的powershell强大和跨平台,但是在windows上不仅兼容老系统,而且占用资源低,启动速度快;这一点可以和powershell互补

### cmd程序

- [cmd | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/cmd) 古老windows自带的命令解释器
- 官方鼓励想要使用更高级功能的用户探索 [PowerShell](https://learn.microsoft.com/zh-cn/powershell/)，获取增强的脚本功能和自动化功能。

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
  - 

## 第一步：创建一个简单的脚本

让我们从一个简单的例子开始。假设您需要一个脚本来列出当前目录下的所有文件。您可以创建一个名为`list_files.cmd`的文件，并在其中输入以下内容：

```batch
@echo off
dir
```

- `@echo off`：这条命令会关闭命令的回显，即不会显示接下来要执行的命令。
- `dir`：这条命令会列出当前目录下的所有文件和子目录。

保存文件后，在命令行中切换到该文件所在的目录，并运行：

```batch
list_files.cmd
```

您应该能看到当前目录下所有的文件和子目录被列出来了。

## 基础语法

### 变量

CMD脚本支持变量，您可以使用它们来存储和引用数据。变量有两种类型：环境变量和脚本变量。

#### 环境变量

环境变量是在整个系统范围内定义的，可以通过`set`命令查看：

```batch
set
```

#### 脚本变量

脚本变量是在脚本内部定义的，只能在脚本执行期间使用。定义变量的方式如下：

```batch
set variable_name=value
```

使用变量的方式如下：

```batch
echo %variable_name%
```

例如：

```batch
set myVar=Hello, World!
echo %myVar%
```

### 条件判断

CMD脚本支持基本的条件判断结构，可以使用`if`命令来进行逻辑判断。

#### 基本格式

```batch
if condition (
    command_if_true
) else (
    command_if_false
)
```

#### 示例

假设我们需要根据当前日期判断是否是工作日：

```batch
@echo off
setlocal enabledelayedexpansion

set weekDay=%date:~7,2%
if !weekDay! equ 01 (
    echo Today is Monday.
) else if !weekDay! equ 02 (
    echo Today is Tuesday.
) else if !weekDay! equ 03 (
    echo Today is Wednesday.
) else if !weekDay! equ 04 (
    echo Today is Thursday.
) else if !weekDay! equ 05 (
    echo Today is Friday.
) else (
    echo It's the weekend!
)

endlocal
```

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

希望这篇教程能帮助您更好地理解和使用CMD脚本！

---

以上就是这篇介绍CMD脚本的文章，希望对您有所帮助！如果您有任何疑问或需要进一步的帮助，请随时提问。