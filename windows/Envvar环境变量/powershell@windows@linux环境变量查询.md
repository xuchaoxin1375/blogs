[toc]



## 环境变量类型

- 在Windows操作系统中，**环境变量**是一种系统级别的设置，它用来定义操作系统的行为和应用程序的运行环境。
- 环境变量是一系列**名称-值**对，这些值可以被操作系统、命令行解释器（如cmd.exe或PowerShell）以及运行在其上的应用程序所访问和使用。

### 系统环境变量

- 系统环境变量由系统管理员或安装程序设置，对所有登录到该系统的用户都有效。
- 这些变量通常包含全局路径信息，例如 `%SystemRoot%` 指向 Windows 文件夹的位置，而 `Path` 环境变量包含了系统搜索可执行文件（如.exe, .bat等）的一系列目录列表。
- 其他系统环境变量可能与系统配置、库文件路径、系统服务相关或者其他系统级功能有关。

### 用户环境变量

- 用户环境变量由特定用户创建或修改，仅对该用户账户有效。
- 当某个用户登录时，他们的用户环境变量会与系统环境变量合并，形成该用户最终使用的环境变量集合。
- 用户环境变量常用于存储个人偏好设置、自定义的工作目录或者工具的路径，比如开发人员可能会为自己的账户添加一个指向本地安装的Java JDK目录的 `JAVA_HOME` 用户环境变量。

### 共同点

- 都是键值对形式；
- 都可以包含路径信息，影响程序的查找和执行路径；
- 不区分变量名大小写，但实践中通常遵循大写的约定以提高可读性；
- 变量可以在命令行界面通过 `%VariableName%` (在CMD,Run窗口)或 `$env:VariableName` （在PowerShell中）的形式引用。

当系统尝试执行一个没有完整路径指示的命令时，它会按照以下顺序查找：

1. 当前工作目录下的可执行文件
2. 环境变量 `Path` 中列出的各个路径

无论是系统还是用户环境变量中的 `Path`，都将参与这个搜索过程。

### 覆盖

- 用户环境变量覆盖系统环境变量
- 系统环境变量相当于一个默认值,如果用户修改属于自己的同名环境变量,则以用户环境变量为主

## refs

- [关于环境变量 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7.4)

## 环境变量检查和搜索查看👺

- 假设我们想试探`Var`这个变量是否存在
- 在powershell中输入`$env:Var`,如果返回结果非空,则说明已经存在相应环境变量

### 多值环境变量分行查看👺



- 假设环境变量`Var`有多个值,比如其值包含了多个常用路径,这些路径往往用`;`隔开

- 因此可以用`$env:Var -split ';'`分行查看

- `$env:Var`如果非空,则是一个字符串类型

- ```powershell
  PS 🕰️5:01:50 PM [C:\repos\scripts] 🔋100%→($env:path).GetType()
  
  IsPublic IsSerial Name                                     BaseType
  -------- -------- ----                                     --------
  True     True     String                                   System.Object
  ```

  

### 查看Path变量的所有取值@分行查看👺

- 最简单的命令:`$env:Path`
- 每个路径值一行显示`$env:Path  -split ';'`

- ```ps1
  
  PS C:\Users\cxxu_11> $env:Path  -split ';'
  D:\Program Files\PowerShell\7
  C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.9.1942.0_x64__8wekyb3d8bbwe
  C:\WINDOWS\system32
  C:\WINDOWS
  C:\WINDOWS\System32\Wbem
  ...
  D:\Program Files\nodejs\
  D:\exes\python-3.9.5-embed-amd64
  .....
  ```


## 列出所有环境变量👺

- 在Windows操作系统中，要列出所有系统环境变量，可以使用命令行工具（cmd.exe）或PowerShell。

### 同时显示环境变量的键和值

#### 通过命令提示符 cmd

- 直接输入`set`

- ```cmd
  
  C:\repos\scripts>set
  
  ALLUSERSPROFILE=C:\ProgramData
  APPDATA=C:\Users\cxxu\AppData\Roaming
  CommonProgramFiles=C:\Program Files\Common Files
  ...
  ```

- 运行这个命令后，命令提示符将输出当前会话的所有环境变量及其值。

#### 通过PowerShell

- 执行`Get-ChildItem Env:`,主要末尾的冒号`:`

  - ```bash
    PS 🕰️5:54:29 PM [C:\repos\scripts] 🔋99%→ls env:
    
    Name                           Value
    ----                           -----
    ALLUSERSPROFILE                C:\ProgramData
    APPDATA                        C:\Users\cxxu\AppData\Roaming
    CommonProgramFiles             C:\Program Files\Common Files
    CommonProgramFiles(x86)        C:\Program Files (x86)\Common Files
    CommonProgramW6432             C:\Program Files\Common Files
    COMPUTERNAME                   CXXUWIN
    ....
    ```

### 模糊查找环境变量👺

- `ls env:<pattern>`支持模糊查找(通配符)

  ```powershell
  🚀 ls env:p*h
  
  Name                           Value
  ----                           -----
  PSModulePath                   C:\Users\cxxu\Documents\PowerShell\Modules;C:\Program Files\PowerShell\Modules;c:\program files\powershell\7\Modules;C:\P…
  Path                           C:\Program Files\PowerShell\7;C:\Users\cxxu\AppData\Roaming\Python\Python312\Scripts;C:\Program Files\PowerShell\7;C:\Pro…
  POSH_THEMES_PATH               C:\Program Files (x86)\oh-my-posh\themes
  ```

- 模糊搜索`ls env:|where{$_...}`

  - 利用`-like`,`-match`等.
  - 例如

  ```powershell
  🚀 ls env:|where{$_.value -like 'C:*'}
  
  Name                           Value
  ----                           -----
  ALLUSERSPROFILE                C:\ProgramData
  APPDATA                        C:\Users\cxxu\AppData\Roaming
  CommonProgramFiles             C:\Program Files\Common Files
  ```

#### Note

- `ls env:<pattern>`与`$env:<pattern>`是不同的,后者不支持统配模式

  - ```powershell
    
    🚀 ls env:p*h
    
    Name                           Value
    ----                           -----
    PSModulePath                   C:\Users\cxxu\Documents\PowerShell\Modules;C:\Program Files\PowerShell\Modules;c:\program files\powershell\7\Modules;C:\P…
    Path                           C:\Program Files\PowerShell\7;C:\Users\cxxu\AppData\Roaming\Python\Python312\Scripts;C:\Program Files\PowerShell\7;C:\Pro…
    POSH_THEMES_PATH               C:\Program Files (x86)\oh-my-posh\themes
    ```

  - ```powershell
    🚀  $env:p*h
    ParserError:
    Line |
       1 |  $env:p*h
         |         ~
         | You must provide a value expression following the '*' operator.
    ```

    

### 仅显示环境变量的键或值

- 列举所有已有的环境变量键:`ls env:|select Name`

  ```bash
  [🔋 99%] MEM:59.83% [4.70/7.85] GB |ls env:|select Name
  
  Name
  ----
  ALLUSERSPROFILE
  APPDATA
  CHROME_CRASHPAD_PIPE_NAME
  COLORTERM
  ....
  ```

- `ls env:|select Value`,仅显示值(不常用,仅显示值难以分清是哪个变量的值)

  

## 获取环境变量的对象

- powershell中可以用**System.Environment** 类提供 **GetEnvironmentVariable** 和 **SetEnvironmentVariable** 方法来

### 用户环境变量和系统环境变量👺

- 通常,您可以通过使用命令`$env:<VarName>`的方式查询**环境变量**

- 但是如果`VarName`这个变量名字同时存在于系统,那么上述命令只能查到生效的那个(也就是用户环境变量)


### [Environment]对象@powershell环境变量搜索

#### 辅助函数`Format-EnvItemNumber`

- ```powershell
  
  function Format-EnvItemNumber
  {
      <#
      .SYNOPSIS 
      辅助函数，用于将Get-EnvList(或Get-EnvVar)的返回值转换为带行号的表格
      如果放在脚本(.ps1)中要放在Get-EnvList之前
      如果放在模块(.psm1)中,则位置可以随意一点
       #>
      param(
          $EnvVars,
          #是否显式传入Scope
          [switch]$Scope
      )
      $res = for ($i = 0; $i -lt $EnvVars.Count; $i++)
      {
          [PSCustomObject]@{
              'Number' = $i + 1
              'Scope'  = $Scope ? $EnvVars[$i].Scope :'Default'
              'Name'   = $EnvVars[$i].Name
              'Value'  = $EnvVars[$i].Value
          }
      }
      return $res
  }
  ```

  

#### `Get-EnvList`@列出所有用户环境变量或系统环境变量

- 

  ```powershell
  function Get-EnvList
  {
      <# 
      .SYNOPSIS
      列出所有用户环境变量[系统环境变量|全部环境变量(包括用户和系统共有的环境变量)|用户和系统合并后的无重复键的环境变量]
      获取
  
      .EXAMPLE
      🚀 Get-EnvList -Scope U
  
      Scope Name             Value
      ----- ----             -----
      User  TMP              C:\Users\cxxu\AppData\Local\Temp
      User  Path             C:\Users\cxxu\AppData\Local\Microsoft\WindowsApps;…
      User  TEMP             C:\Users\cxxu\AppData\Local\Temp
      User  OneDriveConsumer C:\Users\cxxu\OneDrive
      User  OneDrive         C:\Users\cxxu\OneDrive
      .EXAMPLE
      🚀 Get-EnvList
  
      Scope  Name                            Value
      -----  ----                            -----
      Combin OneDriveConsumer                C:\Users\cxxu\OneDrive
      Combin CommonProgramFiles(x86)         C:\Program Files (x86)\Common Files
      Combin POSH_INSTALLER                  manual
      Combin POSH_SHELL_VERSION              7.4.1
      Combin USERPROFILE                     C:\Users\cxxu
      Combin PROCESSOR_REVISION              8e0b
      #>
      param(
          #one of [User|Machine|Detail|Combin] abbr [U|M|D|C]
          [validateset('User', 'Machine', 'U', 'M', 'Detail', 'D', 'Combin', 'C')]
          $Scope = 'C'
      )
      $env_user = [Environment]::GetEnvironmentVariables('User')
      $env_machine = [Environment]::GetEnvironmentVariables('Machine')
      $envs = [System.Environment]::GetEnvironmentVariables()
      # $env_detail=$env_user,$env_machine
  
      $envs = $envs.GetEnumerator() | ForEach-Object {
          [PSCustomObject]@{
              Scope = 'Combin'
              Name  = $_.Name
              Value = $_.Value
              
          }
      }
      $env_user = $env_user.GetEnumerator() | ForEach-Object {
          [PSCustomObject]@{
              Scope = 'User'
              Name  = $_.Name
              Value = $_.Value
          }
      }
  
      $env_machine = $env_machine.GetEnumerator() | ForEach-Object {
          [PSCustomObject]@{
              Scope = 'Machine'
              Name  = $_.Name
              Value = $_.Value
          }
      }
  
      # 合并两个数组
      $env_detail = $env_user + $env_machine
  
      # 输出结果
      # $combinedEnvs | Format-Table -AutoSize -Property Scope, Name, Value
  
  
      # switch基本用法
      # switch ($Scope) {
      #     {$_ -eq 'User'} { $res=$env_user }
      #     {$_ -eq 'Machine'} { $res=$env_machine }
      #     Default {$res=$envs}
      # }
      # switch高级用法
      switch -Wildcard ($Scope)
      {
          'U*' { $res = $env_user }
          'M*' { $res = $env_machine }
          'D*' { $res = $env_detail }
          'C*' { $res = $envs }
          Default { $res = $envs }
      }
      #以下是可选操作
      # $res = $res.GetEnumerator() 
      #| Select-Object -ExpandProperty Name
      
      return $res
      
  }
  
  ```





#### `Get-EnvVar👺`

- 上面的函数作为铺垫,继承到如下的`Get-EnvVar`函数

- 满足常用的环境变量查询需求(能够区分用户变量和系统变量),依赖于下一节的`Get-EnvValue`运行

  ```powershell
  function Get-EnvVar
  {
      <# 
  .SYNOPSIS
  查询指定环境变量的值,或者查询所有环境变量(可以指定用户变量或系统变量或者全部变量)
  函数是对[Get-EnvList]的封装扩展,使得调用比较方便,支持统配模糊匹配环境变量名
  如果需要正则匹配,将-like改为-match
  如果需要检查变量值(匹配),直接用Get-EnvList 配合 |where{}查找
  
      #>
      param(
          #env var name
          $Key = '*',
  
          #one of [User|Machine|Detail|Combin] abbr [U|M|D|C]
          #Detail:show env in both user and machine
          #Combin:show env in user and machine merge(only user value if both have the env var)
          [validateset('User', 'Machine', 'U', 'M', 'Detail', 'D', 'Combin', 'C')]
          $Scope = 'C'
          
      )
      $res = Get-EnvList -Scope $Scope | Where-Object { $_.Name -like $Key }
  
      #统计环境变量个数
      $res = Format-EnvItemNumber -EnvVars $res -Scope 
      # Write-Output $res
      return $res
  }
  ```

##### 例

- ```bash
  .EXAMPLE
  🚀 get-EnvVar -scope U |ft -AutoSize -wrap
  
  Number Scope Name             Value
  ------ ----- ----             -----
      1 User  TMP              C:\Users\cxxu\AppData\Local\Temp
      2 User  Path             C:\Users\cxxu\AppData\Local\Microsoft\Window
                              sApps;C:\Users\cxxu\scoop\shims;C:\Users\cxx
                              u\AppData\Local\Programs\oh-my-posh\bin;
      3 User  TEMP             C:\Users\cxxu\AppData\Local\Temp
      4 User  OneDriveConsumer C:\Users\cxxu\OneDrive
      5 User  OneDrive         C:\Users\cxxu\OneDrive
  
  .EXAMPLE
  🚀 get-EnvVar -scope D -key t*mp
  
  Number Scope   Name Value
  ------ -----   ---- -----
       1 User    TMP  C:\Users\cxxu\AppData\Local\Temp
       2 User    TEMP C:\Users\cxxu\AppData\Local\Temp
       3 Machine TEMP C:\WINDOWS\TEMP
       4 Machine TMP  C:\WINDOWS\TEMP
  .EXAMPLE
  🚀 get-EnvVar -scope D -key t*mp |sort Name
  
  Number Scope   Name Value
  ------ -----   ---- -----
       2 User    TEMP C:\Users\cxxu\AppData\Local\Temp
       3 Machine TEMP C:\WINDOWS\TEMP
       1 User    TMP  C:\Users\cxxu\AppData\Local\Temp
       4 Machine TMP  C:\WINDOWS\TEMP
  .EXAMPLE
  🚀 get-EnvVar -scope User
  
  Number Scope Name             Value
  ------ ----- ----             -----
       1 User  TMP              C:\Users\cxxu\AppData\Local\Temp
       2 User  Path             C:\Users\cxxu\AppData\Local\Microsoft\Windo…
       3 User  TEMP             C:\Users\cxxu\AppData\Local\Temp
       4 User  OneDriveConsumer C:\Users\cxxu\OneDrive
       5 User  OneDrive         C:\Users\cxxu\OneDrive
  ```

  

### 其他相关函数

#### `Get-EnvValue`

- ```powershell
  
  function Get-EnvValue
  {
      <# 
      .synopsis 
      获取环境变量的值,即输入环境变量的名字字符串,然后返回该环境变量的值,如果值包含多个字符串(由`;`分隔),则每行输出一个 
      
      #>
      param(
          #环境变量名字符串
          $Key = '*',
          #scope 'Machine|User|All'.(or use abbr writing:'U' for 'User' | 'M' for 'Machine'|'A' for 'All)
          #default value is 'All'
          $Scope = 'All'
      )
      #字符串类型的结果
      $values_user = [Environment]::GetEnvironmentVariable($key, 'User') -split ';'
      $values_machine = [Environment]::GetEnvironmentVariable($key, 'Machine') -split ';'
      # -eq 不区分大小写
      if ($Scope -in 'U', 'User')
      {
          return $values_user
      }
      elseif ($Scope -in 'M', 'Machine')
      {
          
          # $Scope =  ? 'User' : 'Machine'
          #将查询到的结果用分号分隔后输出
          return  $values_machine
      }
      else
      {
          #这个写法在用户和系统变量都存在时,仅列出用户变量,而无法分别都列出
          # return '$env:' + $key | Invoke-Expression 
          #这个写法在用户和系统变量都存在时，能够同时列出用户和系统变量
          # $separator = "`n-------`n"#如果为了返回值的统一性,可以将$separator换成空字符串''
          # return $separator+ $values_user + $separator + $values_machine 
          return $values_user + $values_machine
      }
  }
  
  ```


##### 用例

- ```bash
  .EXAMPLE
      PS BAT [7:57:19 PM] [C:\repos\scripts\ModulesByCxxu\functionsByCxxu]
      [🔋 99%] MEM:69.04% [5.42/7.85] GB |Get-EnvVar -key path -scope 'U'
      C:\Users\cxxu\AppData\Local\Microsoft\WindowsApps
      C:\Users\cxxu\scoop\shims
      C:\Users\cxxu\AppData\Local\Programs\oh-my-posh\bin
      .EXAMPLE
      PS BAT [7:57:51 PM] [C:\repos\scripts\ModulesByCxxu\functionsByCxxu]
      [🔋 99%] MEM:54.79% [4.30/7.85] GB |Get-EnvVar -key path -scope 'M'
      C:\Users\cxxu\AppData\Roaming\Python\Python312\Scripts
      C:\Program Files\PowerShell\7
      C:\Program Files\Python312\Scripts\
  
      .EXAMPLE
      PS BAT [8:03:32 PM] [C:\repos\scripts\ModulesByCxxu\functionsByCxxu]
      [🔋 99%] MEM:63.13% [4.96/7.85] GB |get-EnvVar -key tmp -Scope M       
      C:\WINDOWS\TEMP
      .EXAMPLE
      PS BAT [8:04:03 PM] [C:\repos\scripts\ModulesByCxxu\functionsByCxxu]
      [🔋 99%] MEM:63.10% [4.95/7.85] GB |get-EnvVar -key tmp 
      C:\Users\cxxu\AppData\Local\Temp
  
      PS BAT [8:58:20 PM] [C:\repos\scripts\ModulesByCxxu\functionsByCxxu]
      [🔋 99%] MEM:58.86% [4.62/7.85] GB |get-EnvValue -Key tmp -Scope U 
      C:\Users\cxxu\AppData\Local\Temp
      PS BAT [8:58:30 PM] [C:\repos\scripts\ModulesByCxxu\functionsByCxxu]
      [🔋 99%] MEM:60.47% [4.75/7.85] GB |get-EnvValue -Key tmp -Scope M
      C:\WINDOWS\TEMP
  
      PS BAT [9:08:37 PM] [C:\repos\scripts\ModulesByCxxu\functionsByCxxu]
      [🔋 99%] MEM:63.53% [4.99/7.85] GB |get-EnvValue -Key tmp -Scope A
  
      -------
      C:\Users\cxxu\AppData\Local\Temp
      -------
      C:\WINDOWS\TEMP
  ```

  

## 备份环境变量

### 导出为csv格式

- `Get-EnvVar |epcsv -path env_combin.csv`

### 导入csv到powershell

- ```bash
  🚀 ipcsv .\env_combin.csv |ft -wrap
  
  Number Scope  Name                            Value
  ------ -----  ----                            -----
  1      Combin OneDriveConsumer                C:\Users\cxxu\OneDrive
  2      Combin CommonProgramFiles(x86)         C:\Program Files (x86)\Common Files
  3      Combin POSH_INSTALLER                  manual
  4      Combin POSH_SHELL_VERSION              7.4.1
  5      Combin USERPROFILE                     C:\Users\cxxu
  ```

  

###  在path之外的地方搜索环境变量值

- ```powershell
  🚀 Get-EnvVar |where {$_.Name -ne 'Path'}
  
  Number Scope  Name                            Value
  ------ -----  ----                            -----
       1 Combin OneDriveConsumer                C:\Users\cxxu\OneDrive
       2 Combin CommonProgramFiles(x86)         C:\Program Files (x86)\Common Files
       3 Combin POSH_INSTALLER                  manual
       4 Combin POSH_SHELL_VERSION              7.4.1
       5 Combin USERPROFILE                     C:\Users\cxxu
  ```

- 上面的结果进一步用管道符配合`where`搜索

- 备份环境变量为csv,然后对csv文件进行搜索,可以用excel等进一步处理





##  linux PATH 查看



### refenrece

- [bash - How to display $PATH as one directory per line? - Ask Ubuntu](https://askubuntu.com/questions/600018/how-to-display-path-as-one-directory-per-line)

### solution1

- `echo -e "${PATH/:/\n}"`

- ```bash
  # cxxu @ cxxuAli in ~ [14:49:34]
  $ echo "${PATH//:/$'\n'}"
  /usr/node/node-v16.14.2-linux-x64/bin/$'
  '/home/cxxu/.cargo/bin$'
  '/usr/local/sbin$'
  '/usr/local/bin$'
  '/usr/sbin$'
  '/usr/bin$'
  '/sbin$'
  '/bin$'
  '/usr/games$'
  '/usr/local/games$'
  '/snap/bin
  ```

- 

### solution2

- ` echo $PATH|sed 's/:/\n/g'|sort`

```
# cxxu @ cxxuAli in ~ [14:58:49]
$ echo $PATH|sed 's/:/\n/g'|sort
/bin
/home/cxxu/.cargo/bin
/sbin
/snap/bin
/usr/bin
/usr/games
/usr/local/bin
/usr/local/games
/usr/local/sbin
/usr/node/node-v16.14.2-linux-x64/bin/
/usr/sbin
```









