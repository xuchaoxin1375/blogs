[toc]

## abstract

- PowerShell 是一种跨平台的任务自动化解决方案，由命令行 shell、脚本语言和配置管理框架组成。 PowerShell 在 Windows、Linux 和 macOS 上运行。
- 作为一种脚本语言，PowerShell 通常用于自动执行系统管理。 它还用于经常在 CI/CD 环境中生成、测试和部署解决方案。
-  PowerShell 是在` .NET `公共语言运行时 (CLR) 上构建的。 **所有输入和输出都是` .NET `对象**。 无需分析文本输出即可从输出中提取信息。

## powershell和传统shell的比较

- PowerShell 是由微软开发的命令行外壳程序和脚本环境，与其他传统的Unix/Linux shell（如Bash、sh、csh、zsh等）以及Windows上的CMD命令提示符相比，具有显著的区别和增强功能：

  1. **设计哲学与目标**：
     - PowerShell 设计之初的目标是为系统管理员提供一种更强大、更灵活的方式来管理现代操作系统，特别是针对Windows环境的服务、事件日志、WMI（Windows Management Instrumentation）、Active Directory等复杂管理任务。
     - Unix/Linux Shell 传统上聚焦于文件系统操作、进程管理、脚本编写和管道机制，其在跨平台和轻量级脚本处理方面有悠久历史。

  2. **语言特性**：
     - PowerShell 使用.NET框架作为后盾，支持强类型、面向对象编程，并且内置了丰富的.NET Framework类库支持，允许直接操作.NET对象而非简单的文本流。
     - Unix Shell 主要基于文本处理，使用字符串和通配符进行匹配和数据传递，虽然也能处理复杂的脚本逻辑，但语法相对简单，不支持直接的对象化操作。

  3. **命令结构**：
     - PowerShell 中的命令被称为cmdlet（command-let），遵循 Verb-Noun 的命名规范，例如 `Get-Process`，并且可以通过管道传递完整的对象而非仅文本输出。
     - Unix Shell 使用各种命令和工具，每个都有自己的参数和选项，通常通过管道连接以实现数据流的连续处理。

  4. **脚本能力**：
     - PowerShell 提供了更为完善的脚本语言支持，可以编写非常复杂的脚本和函数，同时支持模块化和版本控制等功能。
     - Unix Shell 脚本同样强大，尤其是像bash这样的shell，它们也支持变量、条件语句、循环和函数，但在语言特性上没有PowerShell那么丰富。

  5. **跨平台性**：
     - PowerShell 最初专为Windows设计，但现在已发展为跨平台工具，可在Linux和macOS上运行（PowerShell Core）。
     - Unix/Linux Shell 自然地跨多个Unix-like系统兼容，包括Linux、BSD、Mac OS X以及其他Unix变种。

  6. **安全策略**：
     - PowerShell 提供了执行策略（Execution Policies），用于控制脚本是否可以在本地计算机上运行，有助于提升安全性。
     - Unix Shell 在默认情况下可能更加开放，但可通过权限设置和其他安全措施来确保脚本的安全执行。

  

##  文档和学习

- 官方文档

  - [PowerShell 文档 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/)
  - 概述和入门:[ PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/overview?view=powershell-7.4)
  - 其中的示例部分是精华部分

- 文档被组织为多个部分

  - 要系统的学习和掌握,需要花费一定的时间;如果您经常使用脚本,或者希望更加熟练和高效的使用计算机,那么这个时间是值得的
  - 但如果只需要了解部分内容或只是偶尔使用,使用搜索引擎或AI大模型代替你编写相关脚本是一个不错的选择

- 培训教程(一个平缓的教程)

  - [使用 PowerShell 自动执行管理任务 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/paths/powershell/)

- 语言规范和语言参考
  - [Windows PowerShell Language Specification 3.0 - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-01?view=powershell-7.2)

  

## 下载



### powershell程序加速下载

- 山东大学镜像站[PowerShell_PowerShell (sdu.edu.cn)](https://mirrors.sdu.edu.cn/github-release/1702434474/github-release/PowerShell_PowerShell/)

### 官网下载

- [在 Windows 上安装 PowerShell - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4#installing-the-msi-package)
  - 推荐用MSI安装,命令行winget默认从github下载,比较慢,看似简单,但是更花时间
  - 下载MSI包用IDM等工具下载反而可能更快
  - 但最有优先考虑国内镜像下载

##  帮助系统



###  获取相关命令

- `gcm`,`help`都可以用来查询可用的命令

- 例如`help <command>`

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
- 对比 `gcm <command>`


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


###  获取/更新帮助手册

```
Update-Help
```
- 某些情况下,您可能会收到错误,那么可以考虑改为运行如下指令

- 或者如果你想看到所有的消息详情:
  - `Update-Help -Force -Verbose -ErrorAction SilentlyContinue`
- 可以安全地忽略这些错误。它们不会影响PS功能或使用。
  - `Get-Module -ListAvailable | Where HelpInfoUri |Update-Help`

###  获取某条命令的使用帮助@使用实例example

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

### 分页显示长内容

- 使用`Out-Host`来分页显示

- 例如

  - ```powershell
    ls -R -file|Out-Host -Paging
    ```

  - ```bash
    Get-Process | Get-Member | Out-Host -Paging
    ```

    


## 查询命令返回的结果

### Get-Member 获取对象的属性和方法

- [Get-Member (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/Microsoft.PowerShell.Utility/Get-Member?view=powershell-7.4)
- 值得注意的是,`Get-Member`处理数组时,返回的是数组元素的成员情况,而不是数组这一容器类型的结果
- 这一点和对象调用`.GetType()`方法返回的类型大为不同

### Object.Gettype()方法



- 基本使用

  ```powershell
  PS>(cat .\demo.txt).gettype()
  
  IsPublic IsSerial Name                                     BaseType
  -------- -------- ----                                     --------
  True     True     Object[]                                 System.Array
  
  PS>"content123".GetType()
  
  IsPublic IsSerial Name                                     BaseType
  -------- -------- ----                                     --------
  True     True     String                                   System.Object
  ```

  

- 配合`select *`可以获取更加详细的类型信息

  ```powershell
  PS>(cat .\demo.txt).gettype()|select *
  
  IsCollectible              : False
  DeclaringMethod            :
  FullName                   : System.Object[]
  AssemblyQualifiedName      : System.Object[], System.Private.CoreLib,
                               Version=8.0.0.0, Culture=neutral,
                               PublicKeyToken=7cec85d7bea7798e
  Namespace                  : System
  GUID                       : 00000000-0000-0000-0000-000000000000
  IsEnum                     : False
  IsConstructedGenericType   : False
  IsGenericType              : False
  ```

### 小结

- 在 PowerShell 中，`Get-Member` 和 `GetType()` 方法都是用来查询对象的类型及其成员（属性和方法）的工具，但它们在用途和详细程度上有所不同：

- **Get-Member**：

  - 是一个 cmdlet，用于显示指定对象或一组对象的成员信息，包括但不限于属性、方法、事件和脚本属性。
  - 使用方式通常是将对象通过管道 (`|`) 传递给 `Get-Member` 命令。
  - 提供了对对象结构更详细的描述，包括成员名称、类型、定义类型以及是否可以读写等信息。
  - 可以通过 `-Name` 参数筛选特定成员，通过 `-MemberType` 参数筛选特定类型的成员（如 Property、Method 等）。
  - 示例：`Get-Process | Get-Member` 或 `("Hello").GetType().FullName | Get-Member`

- **GetType() 方法**：
  - 是 .NET Framework 中所有对象都具有的方法，直接作用于变量或表达式返回的对象上。
  - 返回的是当前对象的确切类型，即 `System.Type` 对象，包含了关于对象类型的所有元数据。
  - 通常用来快速获取或验证对象的类型名称，以及调用基于类型的方法（如获取类型的所有属性列表）。
  - 不像 `Get-Member` 那样提供详细的成员描述，而是提供了编程级别的接口，可以直接操作类型信息。
  - 示例：`$var = "Hello"; $var.GetType()` 将返回字符串类型的 `System.String`。

  

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

##  提高程序运行效率的原则@避免低效操作

- [使用格式设置和筛选 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/connect-commands/4-format)
  - 在处理数据时(尤其是大量数据),通常应该先筛选数据,然后再格式化数据
  - 筛选数据可能有两种方法,一种是命令本身具备筛选功能;否则使用管道符配合`where`进行筛选
  - 然后是格式化,即使用`Select`选择要显示的属性信息;另外`Format`则是最后使用的格式化信息命令







