@[toc]

# powershell@使用指南与入门命令

##  ref

- learn by microsoft
  - [https://docs.microsoft.com/zh-cn/learn/paths/powershell/](https://docs.microsoft.com/zh-cn/learn/paths/powershell/)

- [文档内置教程]:
  - [Discover PowerShell - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/scripting/learn/tutorials/01-discover-powershell?view=powershell-7.2)

- [Learn and use PowerShell with just three commands - Tech Thoughts](https://www.techthoughts.info/learn-and-use-powershell-with-just-three-commands/)

## Learning Powershell😊

- [What is PowerShell? - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.3)
- [Introduction - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/00-introduction?view=powershell-7.3)
  - [Introduction](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/00-introduction?view=powershell-7.3)
  - [Getting Started with PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/01-getting-started?view=powershell-7.3)
  - [The Help System](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/02-help-system?view=powershell-7.3)
  - [Discovering objects, properties, and methods](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/03-discovering-objects?view=powershell-7.3)
  - [One-liners and the pipeline](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/04-pipelines?view=powershell-7.3)
  - [Formatting, aliases, providers, comparison](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/05-formatting-aliases-providers-comparison?view=powershell-7.3)
  - [Flow control](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/06-flow-control?view=powershell-7.3)
  - [Working with WMI](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/07-working-with-wmi?view=powershell-7.3)
  - [PowerShell remoting](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/08-powershell-remoting?view=powershell-7.3)
  - [Functions](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/09-functions?view=powershell-7.3)
  - [Script modules](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/10-script-modules?view=powershell-7.3)
  - [Appendix A - Help Syntax](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/appendix-a?view=powershell-7.3)

##  语言规范和语言参考

[Windows PowerShell Language Specification 3.0 - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-01?view=powershell-7.2)
* [1. Introduction](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-01?view=powershell-7.2)
* [2. Lexical Structure](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-02?view=powershell-7.2)
* [3. Basic concepts](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-03?view=powershell-7.2)
* [4. Types](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-04?view=powershell-7.2)
* [5. Variables](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-05?view=powershell-7.2)
* [6. Conversions](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-06?view=powershell-7.2)
* [7. Expressions](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2)
* [8. Statements](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-08?view=powershell-7.2)
* [9. Arrays](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-09?view=powershell-7.2)
* [10. Hashtables](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-10?view=powershell-7.2)
* [11. Modules](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-11?view=powershell-7.2)
* [12. Attributes](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-12?view=powershell-7.2)
* [13. Cmdlets](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-13?view=powershell-7.2)
* [A. Comment-Based Help](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-14?view=powershell-7.2)
* [B. Grammar](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-15?view=powershell-7.2)

## cmdlet Reference



- CimCmdlets
- <u>Microsoft.PowerShell.Archive</u>
- <u>Microsoft.PowerShell.Core</u>
- Microsoft.PowerShell.Diagnostics
- Microsoft.PowerShell.Host
- <u>Microsoft.PowerShell.Management</u>
  - [PackageManagement](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/?view=powershell-7.3)
  - [Find-Package](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/find-package?view=powershell-7.3)
  - [Find-PackageProvider](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/find-packageprovider?view=powershell-7.3)
  - [Get-Package](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/get-package?view=powershell-7.3)
  - [Get-PackageProvider](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/get-packageprovider?view=powershell-7.3)
  - [Get-PackageSource](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/get-packagesource?view=powershell-7.3)
  - [Import-PackageProvider](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/import-packageprovider?view=powershell-7.3)
  - [Install-Package](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/install-package?view=powershell-7.3)
  - [Install-PackageProvider](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/install-packageprovider?view=powershell-7.3)
  - [Register-PackageSource](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/register-packagesource?view=powershell-7.3)
  - [Save-Package](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/save-package?view=powershell-7.3)
  - [Set-PackageSource](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/set-packagesource?view=powershell-7.3)
  - [Uninstall-Package](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/uninstall-package?view=powershell-7.3)
  - [Unregister-PackageSource](https://learn.microsoft.com/en-us/powershell/module/packagemanagement/unregister-packagesource?view=powershell-7.3)
- Microsoft.PowerShell.Security
- <u>Microsoft.PowerShell.Utility</u>
- Microsoft.WSMan.Management
- PackageManagement
- PowerShellGet
- PSDiagnostics
- <u>PSReadLine</u>
- ThreadJob


#  基本常识
- powershell 大小写不敏感,但是鼓励该大写的还是大写
-  powershell的命令名是`动词-名称`形式的
- 通过`get-verb`可以获取powershell中的动词列表
- help 将帮助分页而get-help 不会分页,而只是将内容完全输出
#  获取相关命令
- 两种方式都支持模糊搜索(help/gcm)
- 我更喜欢用 `help`,这是个更加通用的命令


##  方式1:get-help(help)
```ps1
PS C:\Users\cxxu_11> help File

Name                              Category  Module                    Synopsis
----                              --------  ------                    --------
New-PSSessionConfigurationFile    Cmdlet    Microsoft.PowerShell.Core Creates a file that…
Test-PSSessionConfigurationFile   Cmdlet    Microsoft.PowerShell.Core     …
Write-CFile                       Function  Carbon                    …
Convert-CXmlFile                  Function  Carbon                    …
Test-CFileShare                   Function  Carbon                    …
Read-CFile                        Function  Carbon                    …
Uninstall-CFileShare              Function  Carbon                    …
Get-CFileSharePermission          Function  Carbon                    …
Get-CFileShare                    Function  Carbon                    …
...
about_Session_Configuration_Files HelpFile
```
- 对比 `get-command`


```ps1


PS C:\Users\cxxu_11> gcm *file*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Add-PoshGitToProfile                               1.0.0      posh-git
Function        ciscoFiles                                         0.0        jumpDirecto…
Function        Convert-CXmlFile                                   2.11.0     Carbon
Function        FileInfo                                           1.0.0.0    PSColor
Function        fritzingFiles                                      0.0        
Function        qqFiles                                            0.0        jumpDirecto…
Function        Read-CFile                                         2.11.0     Carbon
Function        Reset-CHostsFile                                   2.11.0     Carbon
...
              1.0.0.1    PowerShellG…
Function        wechatFiles                                        0.0        jumpDirecto…
Function        WINDOWS\…
Application     openfiles.exe                                      10.0.2200… C:\WINDOWS\…
Application     profiler.bat                                       0.0.0.0    D:\exes\and…
Application     profiler.exe                                       0.0.0.0    D:\exes\and…

```
##  方式2:get-command(gcm)
- 比如要获取和进程(process)相关的命令:
  - `Get-Command *process*`

- 这里的`*`表示通配符
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/79ca07930935462abadee30710da7abc.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

#  powershell语言的语法帮助`about_`帮助系统
- 用help获取相关主题:
- 例如操作符相关语法:
```ps1
PS C:\Users\cxxu_11> help operator

Name                              Category  Module                    Synopsis
----                              --------  ------                    --------
about_Arithmetic_Operators        HelpFile
about_Assignment_Operators        HelpFile
about_Comparison_Operators        HelpFile
about_Logical_Operators           HelpFile
about_Operators                   HelpFile
about_Operator_Precedence         HelpFile
about_Pipeline_Chain_Operators    HelpFile
about_Type_Operators              HelpFile
```
```ps1
PS C:\Users\cxxu_11> help about_Operators
                                                                                                ABOUT_OPERATORS
Short description
Describes the operators that are supported by PowerShell.
...
```

##  获取/更新帮助手册

```
Update-Help
```
某些情况下,您可能会收到错误,那么可以考虑改为运行如下指令
或者如果你想看到所有的消息详情:
	`Update-Help -Force -Verbose -ErrorAction SilentlyContinue`
可以安全地忽略这些错误。它们不会影响PS功能或使用。
	`Get-Module -ListAvailable | Where HelpInfoUri |Update-Help`

##  获取某条命令的使用帮助/example

- 获取帮助:
  - `help <commandName>`

- 这里man可以替换help(两者都是Get-Help)的别名
  - `<commandName> -?`

- cmdlet的帮助选项
  - `-example`
  - 相比于linux中的man,pwsh的`-example`选项算是一个亮点

- 比如获取Stop-Process 命令的相关帮助
  - `Get-Help Stop-Process`

### 例

获取相关用法例子`-example`

```
Get-Help Stop-Process -Examples
```

>❯ Get-Help Stop-Process -Examples

>NAME
>Stop-Process

>SYNOPSIS
>Stops one or more running processes.


    ---------- Example 1: Stop all instances of a process ----------
    
    PS C:\> Stop-Process -Name "notepad"
    
    This command stops all instances of the Notepad process on the computer. Each instance of Notepad runs in its own process. It uses the Name parameter to specify the processes, all of
    which have the same name. If you were to use the Id parameter to stop the same processes, you would have to list the process IDs of each instance of Notepad.
    ------- Example 2: Stop a specific instance of a process -------
    
    PS C:\> Stop-Process -Id 3952 -Confirm -PassThru
    Confirm
    Are you sure you want to perform this action?
    Performing operation "Stop-Process" on Target "notepad (3952)".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
    (default is "Y"):y
    Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id ProcessName
    -------  ------    -----      ----- -----   ------     -- -----------
    41       2      996       3212    31            3952 notepad
    
    This command stops a particular instance of the Notepad process. It uses the process ID, 3952, to identify the process. The Confirm parameter directs PowerShell to prompt you before
    it stops the process. Because the prompt includes the process namein addition to its ID, this is best practice. The PassThru parameter passes the process object to the formatter for
    display. Without this parameter, there would be no display after a Stop-Process command.
    --- Example 3: Stop a process and detect that it has stopped ---
    
    PS C:\> calc
    PS C:\> $p = Get-Process -Name "calc"
    PS C:\> Stop-Process -InputObject $p
    PS C:\> Get-Process | Where-Object {$_.HasExited}

#  获取对象类型/成员

`Get-Member`
以Get-Date 为例
```
Get-Date | `Get-Member`
```
但是,更有用的是`get-Member`获取对象的类型,然后利用`get-command`来查询可以操作对应类型的cmdlet
[learn:发现对象](https://docs.microsoft.com/zh-cn/learn/modules/discover-commands/4-discover-objects)

例如:

```powershell
PS D:\repos\blogs> Get-Process -Name '*edge'|Get-Member|select -First 5

   TypeName: System.Diagnostics.Process

Name    MemberType    Definition
----    ----------    ----------
Handles AliasProperty Handles = Handlecount
Name    AliasProperty Name = ProcessName
NPM     AliasProperty NPM = NonpagedSystemMemorySize64
PM      AliasProperty PM = PagedMemorySize64
SI      AliasProperty SI = SessionId
```

- 为节约篇幅,只展示前5行

- 注意`   TypeName: System.Diagnostics.Process`这一行指出命令行`Get-Process -Name '*edge'`的返回结果对象类型

  

## 根据对象类型查询相关的方法@操作

- 得到对象类型后,可能还需要知道这个对象可以做什么操作:

- ```powershell
  PS D:\repos\blogs> Get-Command -ParameterType System.Diagnostics.Process
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Cmdlet          Debug-Process                                      7.0.0.0    Microsoft.P…
  Cmdlet          Enter-PSHostProcess                                7.3.1.500  Microsoft.P…
  Cmdlet          Get-Process                                        7.0.0.0    Microsoft.P…
  Cmdlet          Get-PSHostProcessInfo                              7.3.1.500  Microsoft.P…
  Cmdlet          Stop-Process                                       7.0.0.0    Microsoft.P…
  Cmdlet          Wait-Process
  ```

- ` Get-Command -ParameterType System.Diagnostics.Process`查询`System.Diagnostics.Process`类型的对象可以执行那些操作
  - 上面的结果告诉我们,可以执行
    - `debug-process`
    - ....
    - `stop-process`
    - `wait-process`

#  处理显示内容(使用格式设置和筛选)

- [learn link](https://docs.microsoft.com/zh-cn/learn/modules/connect-commands/4-format)
- 类似于数据库,powershell提供了一些格式化返回内容的工具对象
- 操作原则:`正确设置格式，将格式设置作为最后一项操作`
- 鉴于筛选左侧在语句中是指尽可能早地筛选出内容，从右往左格式化数据在语句中就是指尽可能晚地格式化数据。 但为什么需要延迟设置格式？ 原因是格式设置命令将对象更改为格式对象。 这意味着数据不再位于相同的属性和方法中。(格式设置会破坏你正在处理的对象。)
- `Get-Process | Where-Object CPU -gt 2 | Sort-Object CPU -Descending | Select-Object -First 3`
- 上述命令分别涉及到记录筛选,排序以及列(投影),来获取更有针对性的查询(操作)结果







