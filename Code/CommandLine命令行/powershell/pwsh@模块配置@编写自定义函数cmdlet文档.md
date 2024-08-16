[toc]

#  配置模块@脚本@函数 🎈

##  references
- [关于脚本 - PowerShell | Microsoft Docs](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2)
- [关于模块 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7.4)
## 运行脚本/程序
- 例如执行.ps1和.bat脚本文件以及exe程序
- 在任意目录下执行任意位置的脚本
	- 在powershell中输入脚本/程序所在的准确的路径即可(`完整路径名+脚本名`)
- 也可以进入到脚本/程序所在目录,然后通过`.\<程序名或脚本名>`来执行某个脚本/程序
- 对于没有后缀的文件,似乎无法通过键入绝对路径来执行

##  自动导入模块所在目录

- 查看本机powershell模块路径(环境变量值)

- `$env:PSModulePath -split ";"`

  - ```powershell
    PS C:\Users\cxxu> $env:PSModulePath -split ";"
    D:\usersByCxxu\DocumentsAll\PowerShell\Modules
    C:\Program Files\PowerShell\Modules
    c:\program files\powershell\7\Modules
    D:\program files\WindowsPowerShell\Modules
    D:\repos\PwshLearn\modulesByCxxu
    ```


##  安装模块

- [创建基本 PowerShell 模块](https://docs.microsoft.com/zh-cn/powershell/scripting/developer/module/how-to-write-a-powershell-script-module?view=powershell-7.2)
- [创建模块清单](https://docs.microsoft.com/zh-cn/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest?view=powershell-7.2#creating-a-module-manifest)
- [安装 PowerShell 模块](https://docs.microsoft.com/zh-cn/powershell/scripting/developer/module/installing-a-powershell-module?view=powershell-7.2)

###  自动导入模块

- 关于自动导入,实际体验验上是指,您可以直接在终端中引用(通过模块中的(公开的)函数名称来调用某个函数

- 这些模块只有在被放置在`$env:psModulePath`下,同时符合一定的目录层析要求,才可以达到效果

- 如果你的模块文件组织的合乎规范,那么在调用相应函数后,模块才会显示的被导入
  - 是指,您可以通过`gmo`(get-module)查询到被导入的模块


##  添加您的模块目录

### 采用命令行方式添加

处理系统配置的几个模块自动导入目录,您还可以通过一定的语句实现`psModulePath`的自定义添加,如此一来,您的模块就不必要放置在那几个默认的目录下了.

- 为了实现自动添加,您需要将类似于以下代码写入到您的powershell配置文件中,这样在每新建一个session,您配置的路径都将有效.
```ps1
# add $psPath:
#Save the current value in the $p variable.
$p = [Environment]::GetEnvironmentVariable("PSModulePath")

#Add the new path to the $p variable. Begin with a semi-colon separator.
$p += ";$env:repos\learnpwsh\modulesByCxxu\"

#Add the paths in $p to the PSModulePath value.
[Environment]::SetEnvironmentVariable("PSModulePath",$p)

```
- 不同path需要以`;` 分割

- 按照microsoft的说法,修改path之后需要做广播处理,如果是通过修改启动配置文件的方式添加,则不需要即时广播psmodulePath的变化

##  配置环境变量psModulePath

- 这是更直接的方式!

- powershell中输入`SystemPropertiesAdvanced.exe`
  - 选择高级(advanced->environment(环境变量配置)
  - 根据需要修改配置文件/模块所在路径
    - 通常安装完powershell,就可以再系统环境变量中找到`psModulePath`
    - 这样,就不需要动态配置了


### 模块目录结构要求🎈

- 对于复杂的多文件模块,还需要(必须)有清单文件
- 您的模块不能有逻辑错误或者采用其他违反规定的编排方式
  - 否则将导致模块无法导入,这种失误不会给出错误提示!!





## 模块检查👺

顺利配置了上述模块集路径后,您的powershell中可以通过调用`get-module`或其缩写`gmo`函数,以及其他相关命令来检查模块导入情况

在 PowerShell 中，你可以使用以下几种方法来检查已安装的模块。

检查已安装模块和已经加载到当前环境的模块使用的命令行是不同的

### 1. **使用 `Get-Module -ListAvailable`**

   这个命令列出所有在当前系统上安装的模块，包括全局安装的模块和用户范围内安装的模块。

   ```powershell
Get-Module -ListAvailable
   ```

这个命令可以列出所有powershell可以找得到的模块，包括`$env:PsModulePath`中指定的各个路径下的自动导入的模块

但是全列出来往往不是我们想要的,更常见的需求是检查某个模块是否被安装,某个模块是否被导入

你可以通过 `-Name` 参数过滤特定模块：

   ```powershell
Get-Module -ListAvailable -Name ModuleName
   ```

### 2. **使用 `Get-InstalledModule`**

如果你想查看通过 `PowerShell Gallery` 安装的模块，可以使用 `Get-InstalledModule`。

这只会显示通过 `Install-Module` 命令安装的模块。

   ```powershell
Get-InstalledModule
   ```

   同样，你可以通过 `-Name` 参数过滤特定模块：

   ```powershell
Get-InstalledModule -Name ModuleName
   ```

### 3. **使用 `Get-Module`**检查已导入的模块

   如果你想查看当前会话中已经导入的模块，可以使用 `Get-Module`：(别名是`gmo`)

   ```powershell
Get-Module
   ```

例如检查模块`init`是否被导入

```
PS> gmo -Name Init

ModuleType Version    PreRelease Name                                ExportedCommands
---------- -------    ---------- ----                                ----------------
Script     0.0                   Init                                {Import-Termina…

```

如果指定的模块没有被导入或者压根就没有这个模块,那么返回结果会是空



### 总结👺

以下是一个比较各命令功能的表格：

| 命令                        | 描述                                           | 用途                                 |
| --------------------------- | ---------------------------------------------- | ------------------------------------ |
| `Get-Module -ListAvailable` | 列出所有在系统上安装的模块（包括未加载的模块） | 检查系统上所有可用的模块             |
| `Get-InstalledModule`       | 列出通过 PowerShell Gallery 安装的模块         | 查看从 PowerShell Gallery 安装的模块 |
| `Get-Module`                | 列出当前会话中已加载的模块                     | 检查当前会话中已经加载的模块         |

根据你的需求选择合适的命令来检查已安装的模块。

- ```bash
  PS C:\Users\cxxu\Desktop> gmo
  
  ModuleType Version    PreRelease Name                                ExportedCommands
  ---------- -------    ---------- ----                                ----------------
  Script     0.0                   Conda                               {Enter-CondaEnv…
  Manifest   7.0.0.0               Microsoft.PowerShell.Management     {Add-Content, C…
  Manifest   7.0.0.0               Microsoft.PowerShell.Utility        {Add-Member, Ad…
  Script     2.3.5                 PSReadLine                          {Get-PSReadLine…
  
  
  PS[BAT:98%][MEM:37.92% (12.02/31.70)GB][11:13:05]
  # [C:\repos\scripts]
  PS> Get-Module
  
  ModuleType Version    PreRelease Name                                ExportedCommands
  ---------- -------    ---------- ----                                ----------------
  Script     0.0                   Conda                               {Enter-CondaEnv…
  Manifest   7.0.0.0               Microsoft.PowerShell.Management     {Add-Content, C…
  Manifest   7.0.0.0               Microsoft.PowerShell.Utility        {Add-Member, Ad…
  Script     2.3.5                 PSReadLine    
  
  ```

- 实际上`gmo`函数显示的可能**并不全面**,对于配置在`$env:PsModulePath`环境变量路径总的模块,如果在**调用其中的任意一个函数前,pwsh是不会导入相应模块的,也就无法被 `gmo`命令扫描出来**,调用时则会自动导入

- 在调用上述模块中的任意一个函数之前,加载powershell的速度几乎不受影响



## powershell函数@模块文档的编写🎈

- [about Functions Advanced Parameters - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3)

### 编写基于注释的帮助🎈

- [about Comment Based Help - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3)

- [函数 - PowerShell | Microsoft Docs](https://docs.microsoft.com/zh-cn/powershell/scripting/learn/ps101/09-functions?view=powershell-7.2#comment-based-help)

- 一种好的习惯是将基于注释的帮助文档添加到函数，以便你与之共享函数的人知道如何使用它们。
  - [about_Comment_Based_Help](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#about_comment_based_help)
    - [简短说明](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#short-description)
    - [长说明](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#long-description)
    - [基于注释的帮助的语法](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#syntax-for-comment-based-help)
    - [函数中基于注释的帮助的语法](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#syntax-for-comment-based-help-in-functions)
    - [脚本中基于注释的帮助的语法](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#syntax-for-comment-based-help-in-scripts)
    - [脚本模块中基于注释的帮助的语法](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#syntax-for-comment-based-help-in-script-modules)
    - [基于注释的帮助关键字](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#comment-based-help-keywords)
      - [.SYNOPSIS](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#synopsis)
      - [.DESCRIPTION](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#description)
      - [.PARAMETER](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#parameter)
      - [.EXAMPLE](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#example)
      - [.INPUTS](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#inputs)
      - [.OUTPUTS](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#outputs)
      - [.NOTES](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#notes)
      - [.LINK](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#link)
      - [.COMPONENT](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#component)
      - [.ROLE](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#role)
      - [.FUNCTIONALITY](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#functionality)
      - [.FORWARDHELPTARGETNAME](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#forwardhelptargetname)
      - [.FORWARDHELPCATEGORY](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#forwardhelpcategory)
      - [.REMOTEHELPRUNSPACE](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#remotehelprunspace)
      - [.EXTERNALHELP](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#externalhelp)
    - [自动生成的内容](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#autogenerated-content)
      - [名称](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#name)
      - [语法](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#syntax)
      - [参数列表](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#parameter-list)
      - [通用参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#common-parameters)
      - [参数属性表](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#parameter-attribute-table)
      - [注解](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#remarks)


### 示例

- [示例](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#examples)
  - [函数的基于注释的帮助](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#comment-based-help-for-a-function)
  - [函数语法中的参数说明](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#parameter-descriptions-in-function-syntax)
  - [基于注释的脚本帮助](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#comment-based-help-for-a-script)
  - [重定向到 XML 文件](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#redirecting-to-an-xml-file)
  - [重定向到其他帮助主题](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#redirecting-to-a-different-help-topic)
- [另请参阅](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#see-also)
- [建议的内容](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3#recommended-content)

#### 例1@函数语法中的参数说明

- ```powershell
  function Add-Extension
  {
      param
      (
  
          [string]
          #Specifies the file name.
          $name,
  
          [string]
          #Specifies the file name extension. "Txt" is the default.
          $extension = 'txt'
      )
  
      $name = $name + '.' + $extension
      $name
  
      <#
          .SYNOPSIS
  
          Adds a file name extension to a supplied name.
  
          .DESCRIPTION
  
          Adds a file name extension to a supplied name. Takes any strings for the
          file name or extension.
  
          .INPUTS
  
          None. You cannot pipe objects to Add-Extension.
  
          .OUTPUTS
  
          System.String. Add-Extension returns a string with the extension or
          file name.
  
          .EXAMPLE
  
          PS> extension -name "File"
          File.txt
  
          .EXAMPLE
  
          PS> extension -name "File" -extension "doc"
          File.doc
  
          .EXAMPLE
  
          PS> extension "File" "doc"
          File.doc
  
          .LINK
  
          http://www.fabrikam.com/extension.html
  
          .LINK
  
          Set-Item
      #>  
  }
  ```

  

### 编写基于代码的函数文档

- [关于函数 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3)

- about_Functions
  - [简短说明](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#short-description)
  - [长说明](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#long-description)
  - [语法](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#syntax)
  - [简单函数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#simple-functions)
  - [函数名称](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#function-names)
  - 带参数的函数
    - [命名的参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#named-parameters)
    - [位置参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#positional-parameters)
    - [切换参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#switch-parameters)
  - [使用 Splatting 表示命令参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#using-splatting-to-represent-command-parameters)
  - [将对象管道到函数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#piping-objects-to-functions)
  - [筛选器](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#filters)
  - [函数范围](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#function-scope)
  - [使用函数查找和管理函数：驱动器](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#finding-and-managing-functions-using-the-function-drive)
  - [在新会话中重用函数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#reusing-functions-in-new-sessions)
  - [编写函数帮助](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#writing-help-for-functions)
  - [另请参阅](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#see-also)
  - [建议的内容](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#recommended-content)

## 函数的高级参数部分

- [about Functions Advanced Parameters - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#attributes-of-parameters)

- [关于 Functions 高级参数 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#attributes-of-parameters)

### 常用部分

#### 参数属性

- [参数属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#parameter-attribute)
  - [Mandatory 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#mandatory-argument)
  - [Position 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#position-argument)
  - [ParameterSetName 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#parametersetname-argument)
  - [ValueFromPipeline 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#valuefrompipeline-argument)
  - [ValueFromPipelineByPropertyName 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#valuefrompipelinebypropertyname-argument)
  - [ValueFromRemainingArguments 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#valuefromremainingarguments-argument)
  - [HelpMessage 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#helpmessage-argument)

- **Parameter** 属性用于声明函数参数的属性。

- **Parameter** 属性是可选的，如果函数的任何参数都不需要属性，则可以省略它。 

  - 但是，要识别为高级函数，而不是简单函数，函数必须具有 **CmdletBinding** 属性或 **Parameter** 属性，或者同时具有这两者。

- **Parameter** 属性具有**用于定义参数特征的参数**，

  - 例如:参数是必需参数还是可选参数。

- 使用以下语法声明 **Parameter** 属性、参数和参数值。 

  - 将参数及其值括起来的括号必须跟在 **参数** 后面，且没有干预空格。

  - 使用逗号分隔括号中的参数。 使用以下语法声明 **Parameter** 属性的两个参数。

    - 这里的参数是parameter属性的参数,而不是高级函数的参数

  - ```powershell
    Param(
        [Parameter(Argument=value)]
        $ParameterName
    )
    
    Param(
        [Parameter(Argument1=value1,Argument2=value2)]
    )
    #Use commas to separate arguments within the parentheses.
    #Use the following syntax to declare two arguments of the Parameter attribute.
    ```

### Parameter属性的参数的简写

- The boolean argument types of the **Parameter** attribute default to **False** <u>when omitted from the **Parameter** attribute</u>. 
- Set the argument value to `$true` or just list the argument by name.
  - `[parameter(..)]`中的`()`可以包含多个parameter-attribute-argument参数,记为paa,这些参数都是可选的
  - 其中有的paa是bool型的(取值限定为 `true/false` ) ,这类paa记为bpaa
  - 如果某个bpaa没有写入括号内的,那么该paa的取值默认为`False`
  - 例如`Mandatory`就属于bpaa,如果不写入括号,那么相当于写入`Mandatory=$false`
-  For example, the following **Parameter** attributes are equivalent.

- ```powershell
  Param(
      [Parameter(Mandatory=$true)]
  )
  
  # Boolean arguments can be defined using this shorthand syntax
  
  Param(
      [Parameter(Mandatory)]
  )
  ```

- ```powershell
  Param(
      [Parameter(Mandatory=$false)]
  )
  
  # Boolean arguments can be defined using this shorthand syntax
  
  Param(
      [Parameter()]
  )
  ```

  

##  别名及其作用域

- 相关命令
  - `export-alias`导出别名配置文件
  - `new-alias`新建别名(也可强制修改别名）
  - `set-alias`修改别名（也可新建别名）
- allscope是通过`option`选项来指定的（而不是scope选项）
  - 例如:` New-Alias testAllScopeAlias -Value desktop -Option AllScope `

- 将上述函数的调用（或者说函数名）写入到单独创建的启动配置文件中
  - 启动powershell时,在主配置文件中配置,使powershell读取别名配置文件,就可以自动导入别名，同时可以避免主配置文件中包含过多内容。

##  调试powershell
- [PowerShell editing with Visual Studio Code](https://code.visualstudio.com/docs/languages/powershell#_plaster)
- [Debugging PowerShell script in Visual Studio Code – Part 1 - Scripting Blog (microsoft.com)](https://devblogs.microsoft.com/scripting/debugging-powershell-script-in-visual-studio-code-part-1/)