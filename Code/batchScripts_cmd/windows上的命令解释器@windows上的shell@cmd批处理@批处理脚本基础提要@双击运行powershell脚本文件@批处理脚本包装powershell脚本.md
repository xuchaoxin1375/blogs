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

## 易于运行的免配置方案

总得来说，对于一个小白用户，要让其尽可能简单的执行脚本或命令行，那么使用`cmd`脚本文件比`powershell`脚本文件更方便

### 双击直接运行脚本|远程协助脚本方案

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

### 使用windows快捷方式提供双击运行脚本的体验

- windows上的快捷方式功能不仅仅是创建已有文件或目录的打开方式,还可以为某些命令或指令设置快捷方式,甚至允许你用快捷键组合触发某个命令
- 了解这一点,参考windows快捷方式的创建方法相关资料

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

### cmd文档和教程

- [Batch Script - Environment (tutorialspoint.com)](https://www.tutorialspoint.com/batch_script/batch_script_environment.htm)
  - 这是一份手把手教学的教程文档

- 对于有点经验的用户,可以在命令行中执行`cmd /?`获取帮助

  ```cmd
  C:\Users\cxxu\Desktop> cmd /?
  ```

- 文档的中文翻译(文档并不太适合初学者自学,许多概念缺乏解释,对于初学者不友好,查看坡度平缓的入门教程是更好的选择)

  启动一个新的Windows命令解释器实例

  ```cmd
  CMD [/A | /U] [/Q] [/D] [/E:ON | /E:OFF] [/F:ON | /F:OFF] [/V:ON | /V:OFF]
      [[/S] [/C | /K] string]
  ```

  /C      执行由字符串指定的命令，然后终止
  /K      执行由字符串指定的命令，但保持运行状态
  /S      修改/C或/K后字符串的处理方式（见下文）
  /Q      关闭回显
  /D      禁用从注册表执行Autorun命令（见下文）
  /A      使内部命令输出到管道或文件时使用ANSI编码
  /U      使内部命令输出到管道或文件时使用Unicode编码
  /T:fg  设置前景/背景颜色（更多信息请参见COLOR /?）
  /E:ON  启用命令扩展（见下文）
  /E:OFF 禁用命令扩展（见下文）
  /F:ON  启用文件和目录名自动完成字符（见下文）
  /F:OFF 禁用文件和目录名自动完成字符（见下文）
  /V:ON  使用!作为分隔符启用延迟环境变量扩展。例如，/V:ON将允许在执行时扩展变量var。var语法在输入时扩展变量，这在FOR循环内是完全不同的事情。
  /V:OFF 禁用延迟环境变量扩展。

  请注意，如果用引号包围，字符串可以接受由命令分隔符'&&'分隔的多个命令。同样，出于兼容性原因，/X等同于/E:ON，/Y等同于/E:OFF，/R等同于/C。其他任何开关都被忽略。

  如果指定了/C或/K，那么在开关后的命令行其余部分将作为命令行处理，其中使用以下逻辑处理引号(")字符：

  1. 如果满足以下所有条件，则保留命令行上的引号字符：

     - 没有/S开关
     - 恰好两个引号字符
     - 两个引号字符之间没有特殊字符，特殊字符包括：`&<>()@^|`
     - 两个引号字符之间有一个或多个空格字符
     - 两个引号字符之间的字符串是可执行文件的名称。

  2. 否则，旧的行为是检查第一个字符是否是引号字符，如果是，则剥离领先的字符，并移除命令行上的最后一个引号字符，保留最后一个引号字符后的任何文本。

  如果命令行上没有指定/D，那么当CMD.EXE启动时，它会查找以下REG_SZ/REG_EXPAND_SZ注册表变量，如果存在一个或两个，则首先执行它们。

      HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor\AutoRun
      
      和/或
      
      HKEY_CURRENT_USER\Software\Microsoft\Command Processor\AutoRun

  命令扩展默认启用。您也可以通过使用/E:OFF开关禁用特定调用的扩展。您可以通过使用REGEDIT.EXE在注册表中设置以下一个或两个REG_DWORD值来启用或禁用机器和/或用户登录会话的所有CMD.EXE调用的扩展：

      HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor\EnableExtensions
      
      和/或
      
      HKEY_CURRENT_USER\Software\Microsoft\Command Processor\EnableExtensions

  设置为0x1或0x0。用户特定的设置优先于机器设置。命令行开关优先于注册表设置。

  在批处理文件中，`SETLOCAL ENABLEEXTENSIONS`或`DISABLEEXTENSIONS`参数优先于`/E:ON`或`/E:OFF`开关。有关详细信息，请参见`SETLOCAL /?`。


#### 命令扩展涉及对以下命令的更改和/或补充：

```
DEL或ERASE
COLOR
CD或CHDIR
MD或MKDIR
PROMPT
PUSHD
POPD
SET
SETLOCAL
ENDLOCAL
IF
FOR
CALL
SHIFT
GOTO
START（还包括对外部命令调用的更改）
ASSOC
FTYPE
```

要获取具体细节，请键入`commandname /?`查看详细信息。

延迟环境变量扩展默认未启用。您可以使用/V:ON或/V:OFF开关启用或禁用CMD.EXE特定调用的延迟环境变量扩展。您可以通过使用REGEDIT.EXE在注册表中设置以下一个或两个REG_DWORD值来启用或禁用机器和/或用户登录会话的所有CMD.EXE调用的延迟扩展：

```
HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor\DelayedExpansion

和/或

HKEY_CURRENT_USER\Software\Microsoft\Command Processor\DelayedExpansion
```

设置为0x1或0x0。用户特定的设置优先于机器设置。命令行开关优先于注册表设置。

在批处理文件中，SETLOCAL ENABLEDELAYEDEXPANSION或DISABLEDELAYEDEXPANSION参数优先于/V:ON或/V:OFF开关。有关详细信息，请参见SETLOCAL /?。

如果启用了延迟环境变量扩展，则可以使用感叹号字符在执行时替换环境变量的值。

您可以使用/F:ON或/F:OFF开关启用或禁用CMD.EXE特定调用的文件名自动完成。您可以通过使用REGEDIT.EXE在注册表中设置以下一个或两个REG_DWORD值来启用或禁用机器和/或用户登录会话的所有CMD.EXE调用的自动完成：

```
HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor\CompletionChar
HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor\PathCompletionChar

和/或

HKEY_CURRENT_USER\Software\Microsoft\Command Processor\CompletionChar
HKEY_CURRENT_USER\Software\Microsoft\Command Processor\PathCompletionChar
```

使用特定功能的控制字符的十六进制值（例如0x4是Ctrl-D，0x6是Ctrl-F）。用户特定的设置优先于机器设置。命令行开关优先于注册表设置。

如果使用/F:ON开关启用了自动完成，则使用的两个控制字符是Ctrl-D用于目录名自动完成，Ctrl-F用于文件名自动完成。要在注册表中禁用特定自动完成字符，请使用空格的值（0x20），因为它不是有效的控制字符。

当您键入任一控制字符时，将调用自动完成。自动完成函数获取光标左侧的路径字符串，如果还没有通配符，则添加一个通配符，并构建一个匹配路径的列表。然后它显示第一个匹配的路径。如果没有路径匹配，它只会发出哔哔声并保留显示。此后，重复按相同的控制字符将循环遍历匹配路径的列表。按Shift键和控制字符将向后遍历列表。如果您以任何方式编辑行并再次按控制字符，将丢弃保存的匹配路径列表并生成一个新的。如果您在文件和目录名称自动完成之间切换，也会发生同样的情况。两个控制字符之间的唯一区别是文件完成字符匹配文件和目录名称，而目录完成字符仅匹配目录名称。如果在任何内置目录命令（CD、MD或RD）上使用文件完成，则假定为目录完成。

自动完成代码可以正确处理包含空格或其他特殊字符的文件名，方法是在匹配路径周围添加引号。此外，如果您回退，然后从行内调用自动完成，从调用自动完成点开始，光标右侧的文本将被丢弃。

#### 需要引号的特殊字符是

```
   <空格>
     &()[]{}^=;!'+,`~
```

## CMD中的可用命令

在Windows的命令提示符（Command Prompt，简称CMD）中，有许多命令可以使用。这些命令涵盖了系统管理、文件操作、网络管理等各个方面。以下是一些常用的命令：

### 1. 文件和目录操作
| 命令            | 说明                                 |
| --------------- | ------------------------------------ |
| `dir`           | 列出当前目录中的文件和子目录。       |
| `cd`            | 更改当前目录。                       |
| `md` 或 `mkdir` | 创建一个新目录。                     |
| `rd` 或 `rmdir` | 删除一个目录。                       |
| `del`           | 删除一个或多个文件。                 |
| `copy`          | 复制文件到另一个位置。               |
| `move`          | 移动文件到另一个位置，或重命名文件。 |
| `rename`        | 重命名文件或目录。                   |
| `attrib`        | 显示或更改文件属性。                 |

### 2. 系统管理
| 命令         | 说明                                         |
| ------------ | -------------------------------------------- |
| `tasklist`   | 显示当前运行的所有进程。                     |
| `taskkill`   | 终止一个或多个进程。                         |
| `systeminfo` | 显示系统配置信息。                           |
| `shutdown`   | 关闭或重启计算机。                           |
| `chkdsk`     | 检查磁盘并显示状态报告。                     |
| `sfc`        | 检查系统文件的完整性，并尝试修复损坏的文件。 |
| `powercfg`   | 配置电源设置，包括管理睡眠状态。             |
| `gpupdate`   | 更新组策略设置。                             |

### 3. 网络管理
| 命令       | 说明                                             |
| ---------- | ------------------------------------------------ |
| `ipconfig` | 显示和配置网络连接的IP地址。                     |
| `ping`     | 检查与远程主机的网络连接情况。                   |
| `tracert`  | 跟踪数据包到达目标主机的路由。                   |
| `netstat`  | 显示活动的网络连接和端口。                       |
| `nslookup` | 查询DNS记录。                                    |
| `netsh`    | 网络配置的高级工具，可以配置网络接口、防火墙等。 |
| `ftp`      | 连接FTP服务器进行文件传输。                      |
| `telnet`   | 远程连接到其他计算机（一般不再推荐使用）。       |

### 4. 其他工具
| 命令    | 说明                                    |
| ------- | --------------------------------------- |
| `echo`  | 在命令行显示消息，或打开/关闭回显功能。 |
| `cls`   | 清除命令提示符窗口的屏幕内容。          |
| `set`   | 显示、设置或删除环境变量。              |
| `time`  | 显示或设置系统时间。                    |
| `date`  | 显示或设置系统日期。                    |
| `pause` | 暂停批处理文件的执行并显示提示信息。    |
| `exit`  | 退出命令提示符或批处理程序。            |

### 示例
如果你想查看当前目录下的所有文件和文件夹，可以使用 `dir` 命令。假设你想要更改到 `C:\Program Files` 目录，可以输入：

```cmd
cd "C:\Program Files"
```

## 完整的命令列表以及用法👺

如果你想要查看更多命令，可以在命令提示符中输入 `help`，它会显示所有可用命令的简要列表。

```cmd

C:\Users\cxxu\Desktop> help
For more information on a specific command, type HELP command-name
ASSOC          Displays or modifies file extension associations.
ATTRIB         Displays or changes file attributes.
BREAK          Sets or clears extended CTRL+C checking.
BCDEDIT        Sets properties in boot database to control boot loading.
CACLS          Displays or modifies access control lists (ACLs) of files.
CALL           Calls one batch program from another.
CD             Displays the name of or changes the current directory.
....
```

获取特定命令的帮助:使用`HELP command-name`的形式获取,例如获取`cd`命令的帮助

```

C:\Users\cxxu\Desktop> help cd
Displays the name of or changes the current directory.

CHDIR [/D] [drive:][path]
CHDIR [..]
CD [/D] [drive:][path]
CD [..]

  ..   Specifies that you want to change to the parent directory.

Type CD drive: to display the current directory in the specified drive.
Type CD without parameters to display the current drive and directory.

Use the /D switch to change current drive in addition to changing current
directory for a drive.
```

## 后续

- 另见它文(核心用法)
