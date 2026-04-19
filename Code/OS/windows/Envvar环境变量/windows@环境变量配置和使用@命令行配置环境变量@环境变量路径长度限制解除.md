[toc]



## 环境变量

环境变量（Environment Variables）是操作系统中用来存储系统信息和配置信息的动态命名值。它们用于在不同的进程和程序之间传递配置数据，帮助软件了解运行时的环境状态。环境变量通常在操作系统启动时设置，可以被系统和用户程序读取。

环境变量的用途

- **配置**：环境变量可以存储程序所需的配置设置，如数据库连接字符串、API 密钥等。
- **路径管理**：
  - 路径搜索变量:
    - `PATH` 变量是环境变量中最为特殊且重要的一种，因为它用于定义操作系统在查找可执行文件时所搜索的目录路径。
    - `PATH` 环境变量包含一系列目录，系统在这些目录中查找可执行文件。通过修改这个变量，可以方便地添加或移除可执行文件的搜索路径。
- **系统信息**：一些环境变量提供关于系统的信息，如操作系统版本、计算机名等。

更一般的,当某个值反复(频繁)被用到,可以考虑为该变量(某个path路径值,当然也可以是其他值(任意字符串,但不可以过分长)设置环境变量,这样可以通过环境变量来快速引用某个值(经常是目录)



### 环境变量分级

- 通常,环境变量可以细分为
  - 系统环境变量
  - 用户环境变量
- 如果您的计算机只是个人使用,那么通常使用**用户环境变量**已经足够了,并且相关配置在使用命令行的时候不需要进入到管理模式就可以执行
- 但是如果您的计算机包含多个用户,并且希望所有用户都能够用一些共同的环境变量配置,则需要配置**系统环境变量**
- 用户环境变量的值会覆盖掉系统环境变量中的同名变量,而`Path`这类搜索路径环境变量比较特殊,不会覆盖,而会合并

- 在Windows操作系统中，系统环境变量是所有用户共享的环境变量，用户环境变量是每个用户私有的环境变量。具体来说：

  - 系统环境变量：是在Windows操作系统启动时就加载的环境变量，对所有用户和所有进程都可见。可以在控制面板的“系统”窗口中设置系统环境变量，或者在注册表中的“`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment`”键下设置系统环境变量。
  - 用户环境变量：是每个用户私有的环境变量，只对该用户可见。可以在控制面板的“用户账户”窗口中设置用户环境变量，或者在注册表中的“`HKEY_CURRENT_USER\Environment`”键下设置用户环境变量。

  系统环境变量和用户环境变量都是用来存储系统配置和用户配置的参数信息，例如PATH、TEMP等变量。在编程和系统管理中，常常需要读取和修改这些环境变量的值，以便正确地配置系统和程序。

### Path变量的特殊之处

**用于程序查找**：`PATH` 变量指定了可执行文件的搜索路径。当你在命令行中输入一个命令时，操作系统会在 `PATH` 变量中定义的目录中查找相应的可执行文件。这意味着，只有在这些目录中找到的命令才能被直接执行。

**影响命令可访问性**：如果某个程序的安装目录未被添加到 `PATH` 变量中，你就需要使用完整路径来运行该程序，这在操作上非常不便。例如，如果 `git` 的安装目录没有添加到 `PATH` 中，你需要使用 `C:\Program Files\Git\bin\git.exe` 来运行，而不能简单地输入 `git`。

**优先级顺序**：在 `PATH` 变量中，路径的顺序是有意义的。操作系统会按照从左到右的顺序搜索路径，因此同一命令在不同目录中存在时，优先找到的命令会被执行。这可能导致不同版本的程序冲突，因此了解并管理 `PATH` 的顺序非常重要。

**跨平台差异**：`PATH` 变量在不同操作系统中的表现可能有所不同。在 Windows 中，目录路径用分号（`;`）分隔；而在 Linux 和 macOS 中，使用冒号（`:`）分隔。



##  GUI方法

- 打开系统属性
  - 开始菜单搜索`path`,或者`Edit the system environment variables`,直接跳转到system property界面
  - 更通用的方法:可以通过`Win+R`打开运行窗口或者任意一个命令行窗口(`cmd/powershell`)输入`SystemPropertiesAdvanced.exe `回车执行

- 选择`Environment Variables`按钮,进入配置

###  实例:配置java_home
- [PATH and CLASSPATH (The Java™ Tutorials > Essential Java Classes > The Platform Environment) (oracle.com)](https://docs.oracle.com/javase/tutorial/essential/environment/paths.html)

## 命令行方式配置

- 分别介绍古老而通用的setx以及powershell的方法配置

### 使用Setx命令行工具配置环境变量👺

- [setx | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/setx)

- On Windows, there are three methods for making `a persistent change` to `an environment variable:` 
  1. setting them in your profile, (仅限从powershell中使用)
  2. using the **SetEnvironmentVariable** method,(此处介绍的方法)
  3. using the System Control Panel.(传统方法)

`setx` 是 Windows 操作系统中的命令行工具，用于设置用户或系统的环境变量，并且这些设置是永久性的，会在新打开的命令提示符窗口中生效。以下是 `setx` 命令的一些常用操作和示例：

### 基本语法

```cmd
setx variable value [/M]
```

- `variable`：你想要设置或修改的环境变量名。
- `value`：你想要赋予该环境变量的值。如果路径中包含空格，记得用双引号将路径包围起来。
- `/M`：可选参数，用于设置系统环境变量，如果不加此参数，默认设置用户环境变量。

#### 示例

1. **设置用户环境变量**

   ```cmd
   setx MY_VAR "SomeValue"
   ```

   这将在用户的环境变量中创建一个名为 `MY_VAR` 的变量，其值为 `SomeValue`。

2. **设置系统环境变量**

   ```cmd
   setx MY_SYS_VAR "SystemValue" /M
   ```

   此命令会在系统的环境变量中创建一个名为 `MY_SYS_VAR` 的变量，值为 `SystemValue`。

3. **添加路径到 PATH 变量**

   ```cmd
   setx PATH "%PATH%;C:\NewFolder\bin" /M
   ```

   这个命令会将 `C:\NewFolder\bin` 添加到现有的系统 PATH 变量中，注意使用了 `%PATH%` 来保留原有的 PATH 值。

#### 注意事项

- `setx` 设置的环境变量不会影响当前已经打开的命令提示符会话，只会影响后续新打开的窗口。
- 如果变量名已存在，`setx` 会覆盖原有变量的值。
- 在使用包含空格的路径时，确保整个路径被双引号包围。
- 确保 `setx.exe` 可执行文件存在于 `%systemroot%\system32\` 目录下，这是 Windows Vista 及之后版本的标准位置。对于较早的操作系统如 Windows XP，可能需要单独下载 `setx.exe`。
- 使用 `setx` 后，最好重启命令提示符或登录用户以确保环境变量生效。

以上就是关于 `setx` 命令的基本使用方法和示例。

#### set和setx

- `set` 和 `setx` 都是 Windows 系统中用于设置环境变量的命令。

  `set` 命令用于设置当前会话的环境变量。这些变量只在当前命令提示符窗口中有效，当你关闭这个窗口后，这些变量也就失效了。

  示例：假设你需要将 `C:\myfolder` 添加到系统的 Path 环境变量中，你可以使用以下命令：

  ```
  Copy Codeset PATH=%PATH%;C:\myfolder
  ```

  注意，此命令只对当前命令提示符窗口有效，如果你打开新的命令提示符窗口，这个环境变量就不存在了。

  `setx` 命令用于设置永久的环境变量，它会将环境变量写入到用户或者系统的注册表中，因此即使你关闭当前命令提示符窗口，这些环境变量仍然存在。

  示例：要将 `C:\myfolder` 添加到系统的 Path 环境变量中，你可以使用以下命令：

  ```
  Copy Codesetx PATH "%PATH%;C:\myfolder"
  ```

  注意，使用 `setx` 命令设置的环境变量不会立即生效，你必须重新启动命令提示符窗口或者注销并重新登录用户账户才能生效。

### setx用例

配置用户级环境变量@local environment

- ```cmd
  PS D:\repos\blogs> setx MACHINE Brand1
  
  SUCCESS: Specified value was saved.
  ```

- 配置当前用户,不需要管理员权限就行

配置系统级环境变量@ system environment

- ```cmd
  PS D:\repos\blogs> setx MACHINE "Brand1 Computer" /m
  
  SUCCESS: Specified value was saved.
  ```

  - 该操作需要管理员模式
  - 如果某个名字有空格,使用引号包裹起来

- 更多示例查看官方文档

### Setx使用注意事项

setx配置永久环境变量时,在添加和修改环境变量方面足够方便,但是有不得不注意的地方

setx命令的文档指出许多注意事项:[remark@setx | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/setx#remarks)

其中最引人关注的有两点

1. Running this command on an existing variable removes any variable references and uses expanded values.

   For instance, if the variable %PATH% has a reference to %JAVADIR%, and %PATH% is manipulated using **setx**, %JAVADIR% is expanded and its value is assigned directly to the target variable %PATH%. This means that future updates to %JAVADIR% **will not** be reflected in the %PATH% variable.

2. Be aware there's a limit of 1024 characters when assigning contents to a variable using **setx**.

   This means that the content is cropped if you go over 1024 characters, and that the cropped text is what's applied to the target variable. If this cropped text is applied to an existing variable, it can result in loss of data previously held by the target variable.

本文在Win11上测试时,发现第一点不符合实际,被`%var%`形式引用的值在`%var%`更新后可以正确反应到引用者变量中,不用担心不够灵活的问题

至于第二个注意事项,确实会被截断,但是我们有相应的技巧来绕过此限制(有些人可能觉得1024个字符很多,但是很多时候随便一个路径就几十个字符,以20个字符一个路径来算的话,也就大约50个路径,对于配置复杂的系统而言,这不太够用)

## powershell版👺

- [Setting Windows PowerShell environment variables - Stack Overflow](https://stackoverflow.com/questions/714877/setting-windows-powershell-environment-variables)
- [set-environment-variables-with-setenvironmentvariable@about_Environment_Variables - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7.2#set-environment-variables-with-setenvironmentvariable)

- 另见它文:[powershell@修改@删除@添加环境变量_powershell 添加环境变量-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/136134368)

## 总结

- 配置新变量和单值变量可以考虑用`setx`方案,但是不适合配置变量值很长的情况
  - 例如不适合用来配置`PATH`变量,因为它的取值通常是包括各种各样的目录,容易因为过长而被截断,造成数据丢失

- powershell中可以使用`.Net` api 来设置追加新值到`path`中,而不会造成截断



## 环境变量应用场景👺

1. **配置开发工具**：许多开发工具，如 JDK、Python、Node.js 等都依赖于环境变量的正确配置。例如，Java 开发需要设置 `JAVA_HOME` 和在 `PATH` 中添加 `bin` 目录路径，以便命令行能够找到 `javac` 和 `java` 命令。
2. **自定义命令行工具**：如果你有自定义的脚本或工具，可以将它们的路径添加到 `PATH` 中，以便随时在命令行中调用，而无需输入完整的路径。
3. **统一文件路径访问管理**：某些应用程序或脚本需要指定存放的位置。例如:通过配置 `TEMP` 和 `TMP` 环境变量，可以集中管理临时文件的存储路径。
4. **网络或远程管理**：通过设置 `COMPUTERNAME` 和 `USERNAME`，某些脚本可以根据不同的计算机或用户进行定制化操作，特别是在远程管理或自动化场景中非常有用。

## 引用环境变量

windows中引用或使用环境变量的方式有以下几类

- 通过`%var%`的形式引用
  - cmd中引用
  - 资源管理器地址栏中用来跳转路径
    - 注意这类情况下引用的变量要是路径才行,否则会报错找不到路径
    - 并且不能够是分号分隔的多个路径值,比如`%path%`一般是不可以在这里使用的
  - win+r快捷键打开的运行窗口(资源管理器的一部分)也可以使用这个形式引用环境变量

- 使用`$env:var`的形式引用

  - 主要是在powershell中使用这个形式,例如查询`PsModulePath`

    ```
    PS> $env:PSModulePath
    C:\Users\cxxu\Documents\PowerShell\Modules;C:\Program Files\PowerShell\Modules;
    ```

    

  - 或者`env:\var`的形式访问,需要配合`ls,gi`等命令访问

    ```powershell
    PS> ls Env:\path
    
    Name                           Value
    ----                           -----
    Path                           C:\ProgramData\scoop\apps\powershell\current;C:\ProgramData\scoop\apps\dotnet-sdk\current;C:\ProgramData\scoop\apps\gsudo…
    
    
    ```

### 查看环境变量

可以用gui程序查看(比如自带的控制面板或者`msinfo32`),或者命令行查看

### 查看Path变量的取值👺

推荐使用powershell查看,这样可以放便查看多个值的环境变量,例如path

```powershell
$env:Path  -split ';'
```

还有一个豪华版的,带计数和排序

```powershell
$env:path -split ';'|sort -OutVariable x|Out-Null;$x|%{if(!$_){return};[pscustomobject]@{index=$x.IndexOf($_);value=$_}}
```

效果

```powershell
PS> $env:path -split ';'|sort -OutVariable x|Out-Null;$x|%{if(!$_){return};[pscustomobject]@{index=$x.IndexOf($_);value=$_}}

index value
----- -----
    1 %repos%
    2 C:/exes
    3 c:/repos/scripts
    4 C:\exes\pcmaster
    5 C:\PortableGit\bin
    6 C:\Program Files\OpenSSH\
    7 C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps
....
```

- 注意这里的`%repos%`没有被展开是因为`repos`这个环境变量不存在或者不是路径



 

## 环境变量取值长度问题👺

python文档中介绍了windows在这方面的限制

[删除 MAX_PATH 限制|在Windows上使用 Python — Python  文档](https://docs.python.org/zh-cn/3.12/using/windows.html#removing-the-max-path-limitation)

历史上Windows的路径长度限制为260个字符。这意味着长于此的路径将无法解决并导致错误。

在最新版本的 Windows 中(比如win10之后)，此限制可被扩展到大约 32,000 个字符。 但需要让管理员激活“启用 Win32 长路径”组策略，或在注册表键 `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem` 中设置 `LongPathsEnabled` 为 `1`。

在 Windows 系统中，可以使用 **命令提示符 (CMD)** 和 **PowerShell** 来设置注册表键 `LongPathsEnabled` 为 `1`，以启用长路径支持。以下是两种方法的详细步骤和示例。

### 命令行中一键更改

#### 使用 CMD

1. **打开命令提示符**：
   - 按 `Win + R` 键，输入 `cmd`，然后按 `Enter`。

2. **执行命令**：
   在命令提示符中输入以下命令并按 `Enter`：

   ```cmd
   reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f
   ```

   - 解释：
     - `reg add`: 添加或修改注册表项的命令。
     - `"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem"`: 注册表路径。
     - `/v LongPathsEnabled`: 指定要设置的值名称。
     - `/t REG_DWORD`: 指定值的类型为 DWORD（32位整数）。
     - `/d 1`: 设置值的数据为 `1`。
     - `/f`: 强制覆盖现有值，而不提示确认。

#### 使用 PowerShell

1. **打开 PowerShell**：
   - 按 `Win + X`，选择 **Windows PowerShell** 或 **Windows PowerShell (管理员)**。

2. **执行命令**：
   在 PowerShell 窗口中输入以下命令并按 `Enter`：

   ```powershell
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -Type DWord
   ```

   - 解释：
     - `Set-ItemProperty`: 用于设置注册表项的属性。
     - `-Path`: 指定要修改的注册表路径。
     - `-Name`: 指定要设置的值名称。
     - `-Value`: 设置值的数据为 `1`。
     - `-Type DWord`: 指定值的类型为 DWORD。

### 验证更改

无论使用哪种方法设置后，可以通过以下命令检查 `LongPathsEnabled` 的值：

#### 在 CMD 中：

```cmd
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled
```

#### 在 PowerShell 中：

```powershell
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" | Select-Object LongPathsEnabled
```

### 注意事项

- 修改注册表可能会影响系统配置，因此在操作前建议备份注册表。
- 需要管理员权限才能对 `HKEY_LOCAL_MACHINE` 进行更改。如果未以管理员身份运行，可能会收到权限不足的错误提示。

###  节约Path变量值的字符数(推荐做法)


基于此,建议将重复使用的目录前缀单独作为一个变量创建,然后在path中引用该变量(%variableName%),可以达到简化字符串长度的目的

经过实验,如果`%key1%`,`%key2%`变量的取值字符总数超过1024,`setx`设置它们为值时不会发生截断


详见参考资料:
- [How to set the path and environment variables in Windows](https://www.computerhope.com/issues/ch000549.htm#dospath)
- [MS-DOS and Windows command line path command](https://www.computerhope.com/pathhlp.htm)

### 截断检查

如果使用setx会引起您的担心(发生截断),那么可以考虑使用以下powershell命令来检查

```powershell
PS> ($env:path).Length
759
```

或者

```powershell
PS> $env:path|Measure-Object -Character|select -ExpandProperty Characters
759
```

上面的例子说明path变量长度为`759`

不过这是一个保守的数值,实际上的`%path%`可能要短的多,特别是引用其他长路径变量时

如果得出的这个值和1024有较大差距,那么使用setx添加一个新的值到Path变量通常是安全的

不过我更推荐你使用`.Net`api来执行这类操作,它不会引起截断(经过实验验证的)

`[System.Environment]::SetEnvironmentVariable()`

```powershell
PS> [System.Environment]::SetEnvironmentVariable('key3',"1234;$env:key1;abcdefg",'user')
```

在新打开的shell中查询

```powershell
PS> ($env:key3).Length
1037
```



## 恢复系统默认环境变量配置

- [Win10 64位系统环境变量默认值（PATH变量原始值）-联想知识库 (lenovo.com.cn)](https://iknow.lenovo.com.cn/detail/158099.html)




###  变量配置不成功
如果您确信您的操作是正确的,但是依然没有办法使用该变量
最可能的原因是使用了过多的中间变量(超过2次)

换句话说,使用绝对路径配置的环境变量就不存在引用过度的问题

###  检查path中的值结尾的`\`

如果您发现形如`%variableName%\`的值在path中没有效果,那么可以尝试将`\`去掉保存后重新尝试



