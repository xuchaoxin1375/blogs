[toc]



## 获取一个命令的语法

一个命令可以有很多参数,而且可以分组,不同参数可以分到同一组,但是一个参数不能同时分给多个组

这样可以支出哪些参数是无法共存的,而那些是同一组或必须同时使用的

以`Start-process`的某个一调用语法为例:

```powershell
PS [C:\exes]> gcm  Start-Process -Syntax
#语法1
Start-Process [-FilePath] <string> [[-ArgumentList] <string[]>] [-Credential <pscredential>] [-WorkingDirectory <string>] [-LoadUserProfile] [-NoNewWindow] [-PassThru] [-RedirectStandardError <string>] [-RedirectStandardInput <string>] [-RedirectStandardOutput <string>] [-WindowStyle <ProcessWindowStyle>] [-Wait] [-UseNewEnvironment] [-Environment <hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
#语法2
Start-Process [-FilePath] <string> [[-ArgumentList] <string[]>] [-WorkingDirectory <string>] [-PassThru] [-Verb <string>] [-WindowStyle <ProcessWindowStyle>] [-Wait] [-Environment <hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

我们选择第二个用法来解读

```powershell
Start-Process [-FilePath] <string> [[-ArgumentList] <string[]>] [-WorkingDirectory <string>] [-PassThru] [-Verb <string>] [-WindowStyle <ProcessWindowStyle>] [-Wait] [-Environment <hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## 语法记号解读

让我们从语法的角度来解读这个命令的结构：

```plaintext
Start-Process [-FilePath] <string> [[-ArgumentList] <string[]>] [-WorkingDirectory <string>] [-PassThru] [-Verb <string>] [-WindowStyle <ProcessWindowStyle>] [-Wait] [-Environment <hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### 语法解读

1. **命令名称**: `Start-Process`
   - 这是命令的名称，告诉 PowerShell 要执行什么操作。

2. **参数格式**:
   - **`[-FilePath] <string>`**: 
     
     - `[-FilePath]` 表示这是一个命名参数，`<string>` 表示它接受一个字符串值。
     - `-FilePath` 前面的方括号表示这个参数(行参名字)是可选的(可以明写,也可以不写)，但在实际使用中这个必需参数(实参不可以省略不写)。
     - 也就是
     
       ```powershell
       start-process notepad
       ```
     
       这个最简单的调用相当于`start-process  -FilePath notepad`,这里notepad被绑定到了`FilePath`参数,而不是绑定到其他参数
     
       ```powershell
       PS [C:\exes]> start-process
       
       cmdlet Start-Process at command pipeline position 1
       Supply values for the following parameters:
       FilePath: notepad
       ```
     
       
     
   - **`[[-ArgumentList] <string[]>]`**:
     - `[[-ArgumentList] <string[]>]` 表示这是一个可选的命名参数，接受一个字符串数组。
     - 双层方括号表示这个参数和它的值都是可选的。

   - **`[-WorkingDirectory <string>]`**:
     - 表示这是一个可选的命名参数，接受一个字符串值。
     - 如果要用(指定)这个参数,则必须指出`-WorkingDirectory` (**参数名字**)然后跟上一个字符串(不能放空)作为参数的**(取值)**
     - 也不得仅写一个字符串而没有参数名字,因为这个参数是一个纯关键字参数而不是位置参数,所以必须要指定参数名字,再跟上取值
     - 类似的语法几号解读也是一样的
     
   - **`[-PassThru]`**:
     - 这是一个开关参数（Switch Parameter），没有值，只是一个标志。
   
   - **`[-Verb <string>]`**:
     - `[-Verb]` 表示这是一个可选的命名参数，接受一个字符串值。
   
   - **`[-WindowStyle <ProcessWindowStyle>]`**:
     - `[-WindowStyle]` 表示这是一个可选的命名参数，接受一个 `ProcessWindowStyle` 枚举值。
   
   - **`[-Wait]`**:
     - 这是一个开关参数。
   
   - **`[-Environment <hashtable>]`**:
     - `[-Environment]` 表示这是一个可选的命名参数，接受一个哈希表。
   
   - **`[-WhatIf]`**:
     - 这是一个开关参数，显示命令将执行的操作而不实际执行。
   
   - **`[-Confirm]`**:
     - 这是一个开关参数，要求在执行命令前确认。
   
3. **通用参数**:
   - **`[<CommonParameters>]`**:
     - 这是一个占位符，表示 PowerShell 支持的通用参数，如 `-Verbose`, `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-OutBuffer` 等。

### 示例

假设我们要启动一个程序并传递一些参数，同时指定工作目录，并在执行前确认，可以使用以下命令：

```powershell
Start-Process -FilePath "program.exe" -ArgumentList "arg1", "arg2" -WorkingDirectory "C:\path\to\directory" -Confirm
```

这个命令的语法结构反映了参数的可选性和不同类型的参数（字符串、数组、开关、哈希表等）。希望这对你理解 PowerShell 命令的语法有所帮助。

## 获取命令的参数详情

典型的例子

利用`help <command> -Parameter *`来查看指定命令的所有参数及其解释

文档中每个参数用`-`开头引出

这里`Name`参数是位置参数(Position 取值为非负整数,比如0,表示第一个位置参数,是可以省略掉参数名字,而直接写参数值),其他都是关键字参数(Position 取值为`named`)

```powershell
PS [C:\exes]> help ps -Parameter *

-FileVersionInfo <System.Management.Automation.SwitchParameter>
    Indicates that this cmdlet gets the file version information for the program that runs in the process.

    On Windows Vista and later versions of Windows, you must open PowerShell with the **Run as administrator** option to use this parameter on processes that you do not own.

    Using this parameter is equivalent to getting the MainModule.FileVersionInfo property of each process object. When you use this parameter, `Get-Process` returns a FileVersi
    onInfo object System.Diagnostics.FileVersionInfo , not a process object. So, you cannot pipe the output of the command to a cmdlet that expects a process object, such as `S
    top-Process`.

    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       False
    Accept wildcard characters?  false


-Id <System.Int32[]>
    Specifies one or more processes by process ID (PID). To specify multiple IDs, use commas to separate the IDs. To find the PID of a process, type `Get-Process`.

    Required?                    true
    Position?                    named
    Default value                None
    Accept pipeline input?       True (ByPropertyName)
    Accept wildcard characters?  false


-IncludeUserName <System.Management.Automation.SwitchParameter>
    Indicates that the UserName value of the Process object is returned with results of the command.

    Required?                    true
    Position?                    named
    Default value                False
    Accept pipeline input?       False
    Accept wildcard characters?  false


-InputObject <System.Diagnostics.Process[]>
    Specifies one or more process objects. Enter a variable that contains the objects, or type a command or expression that gets the objects.

    Required?                    true
    Position?                    named
    Default value                None
    Accept pipeline input?       True (ByValue)
    Accept wildcard characters?  false
    
-Module <System.Management.Automation.SwitchParameter>
    Indicates that this cmdlet gets the modules that have been loaded by the processes.

    On Windows Vista and later versions of Windows, you must open PowerShell with the **Run as administrator** option to use this parameter on processes that you do not own.

    This parameter is equivalent to getting the Modules property of each process object. When you use this parameter, this cmdlet returns a ProcessModule object System.Diagnost
    ics.ProcessModule , not a process object. So, you cannot pipe the output of the command to a cmdlet that expects a process object, such as `Stop-Process`.

    When you use both the Module and FileVersionInfo parameters in the same command, this cmdlet returns a FileVersionInfo object with information about the file version of all
     modules.

    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       False
    Accept wildcard characters?  false


-Name <System.String[]>
    Specifies one or more processes by process name. You can type multiple process names (separated by commas) and use wildcard characters. The parameter name (`Name`) is optio
    nal.

    Required?                    false
    Position?                    0
    Default value                None
    Accept pipeline input?       True (ByPropertyName)
    Accept wildcard characters?  true

```



另一个例子`help Start-Process -Parameter *`

```powershell

PS [C:\exes]> help Start-Process -Parameter *

-ArgumentList <System.String[]>
    Specifies parameters or parameter values to use when this cmdlet starts the process. Arguments can be accepted as a single string with the arguments separated by spaces, or
     as an array of strings separated by commas. The cmdlet joins the array into a single string with each element of the array separated by a single space.

    The outer quotes of the PowerShell strings aren't included when the ArgumentList values are passed to the new process. If parameters or parameter values contain a space or
    quotes, they need to be surrounded with escaped double quotes. For more information, see about_Quoting_Rules (../Microsoft.PowerShell.Core/About/about_Quoting_Rules.md).

    For the best results, use a single ArgumentList value containing all the arguments and any needed quote characters.

    Required?                    false
    Position?                    1
    Default value                None
    Accept pipeline input?       False
    Accept wildcard characters?  false


-Credential <System.Management.Automation.PSCredential>
    Specifies a user account that has permission to perform this action. By default, the cmdlet uses the credentials of the current user.

    Type a user name, such as User01 or Domain01\User01 , or enter a PSCredential object generated by the `Get-Credential` cmdlet. If you type a user name, you're prompted to e
    nter the password.

    Credentials are stored in a PSCredential (/dotnet/api/system.management.automation.pscredential)object and the password is stored as a SecureString (/dotnet/api/system.secu
    rity.securestring).

    > [!NOTE] > For more information about SecureString data protection, see > How secure is SecureString? (/dotnet/api/system.security.securestring#how-secure-is-securestring)
    .

    Required?                    false
    Position?                    named
    Default value                Current user
    Accept pipeline input?       False
    Accept wildcard characters?  false


-FilePath <System.String>
    Specifies the optional path and filename of the program that runs in the process. Enter the name of an executable file or of a document, such as a `.txt` or `.doc` file, th
    at's associated with a program on the computer. This parameter is required.

    If you specify only a filename that does not correspond to a system command, use the WorkingDirectory parameter to specify the path.

    Required?                    true
    Position?                    0
    Default value                None
    Accept pipeline input?       False
    Accept wildcard characters?  false
...


```



### 补充

这是 PowerShell 中 `Start-Process` cmdlet 的语法。`Start-Process` 用于启动一个新的进程。

以下是每个参数的解释：

- `-FilePath <string>`: 要启动的可执行文件的路径。这个参数是必需的。
  - 其实对于`[-FilePath] <string> `这一节,`[-FilePath]`表示可选(可写可不写)
  - 而`<>`内的是必要参数,必须写


后面的都包裹在`[ ]`中,所有都是可选参数

- `-ArgumentList <string[]>`: 传递给可执行文件的参数列表。
- `-WorkingDirectory <string>`: 启动进程时的工作目录。
- `-PassThru`: 如果指定此参数，cmdlet 会返回一个表示该进程的对象。
- `-Verb <string>`: 指定操作（动词），例如 "runas"（以管理员权限运行）。
- `-WindowStyle <ProcessWindowStyle>`: 指定窗口样式（Normal, Hidden, Minimized, Maximized）。
- `-Wait`: 等待进程完成后再返回。
- `-Environment <hashtable>`: 指定环境变量。
- `-WhatIf`: 显示执行命令后将发生的操作，而不实际执行。
- `-Confirm`: 在执行命令前要求确认。
- `<CommonParameters>`: 包含 PowerShell 通用参数（如 `-Verbose`, `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-OutBuffer` 等）。

例如，如果你想启动记事本并打开一个名为 `example.txt` 的文件，可以使用以下命令：

```powershell
Start-Process -FilePath "notepad.exe" -ArgumentList "example.txt"
```

这个命令会启动记事本并打开 `example.txt` 文件。