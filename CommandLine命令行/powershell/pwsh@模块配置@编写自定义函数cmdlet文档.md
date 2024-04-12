[toc]



# vscode@powershellExtension配置和启用问题🎈

## refs

- [PowerShell editing with Visual Studio Code](https://code.visualstudio.com/docs/languages/powershell)
- [使用 Visual Studio Code 进行 PowerShell 开发 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.3)

### 插件官网

- [PowerShell - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
  - This extension provides rich PowerShell language support for [Visual Studio Code](https://github.com/Microsoft/vscode) (VS Code). 
  - Now you can write and debug PowerShell scripts using the excellent IDE-like interface that VS Code provides.

#### 工作组件

- This extension is powered by 
  -  **PowerShell language server**,
  -  [PowerShell Editor Services](https://github.com/PowerShell/PowerShellEditorServices). 
- This leverages the [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) where `PowerShellEditorServices` is the server and `vscode-powershell` is the client.

####  Platform Support

- [Changelog | Visual Studio Marketplace](https://marketplace.visualstudio.com/items/ms-vscode.PowerShell/changelog)

- 截至2022年最后一个版本的情况如下:

  - The extension *should* work anywhere VS Code itself and **PowerShell Core 7.2** or higher is [supported](https://docs.microsoft.com/en-us/powershell/scripting/powershell-support-lifecycle). 

  - For Windows PowerShell, only version 5.1 is supported. 

  - Please note that PowerShell Core 6 is end-of-life and so not supported

- powershell Core 7.2以及之后的版本都支持
  - powershell core 6不再支持

### 不同版本powershell对比🎈

- windows powershell 和powershell core 是差别巨大的不同版本的powershell
  - 前者是windows系统自带的版本
- 但他们统称为powershell
- 现在提到powershell时,通常指的是`powershell core`

#### winodws powershell 

- ```powershell
  PS D:\repos\scripts> $PSVersionTable
  
  Name                           Value
  ----                           -----
  PSVersion                      5.1.22621.963
  PSEdition                      Desktop
  PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
  BuildVersion                   10.0.22621.963
  CLRVersion                     4.0.30319.42000
  WSManStackVersion              3.0
  PSRemotingProtocolVersion      2.3
  SerializationVersion           1.1.0.1
  ```

#### powershell core 7.2+

- 

  ```powershell
  PS D:\repos\scripts> $psVersionTable
  
  Name                           Value
  ----                           -----
  PSVersion                      7.3.1
  PSEdition                      Core
  GitCommitId                    7.3.1
  OS                             Microsoft Windows 10.0.2…
  Platform                       Win32NT
  PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}
  PSRemotingProtocolVersion      2.3
  SerializationVersion           1.1.0.1
  WSManStackVersion              3.0
  ```



## 添加自己的powershell客户端版本

- [adding-your-own-powershell-paths-to-the-session-menu | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.3#adding-your-own-powershell-paths-to-the-session-menu)

### 可视化配置

- 在设置中搜索`powershell.powerShellAdditionalExePaths`
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/f610cdf201ed4319acb6b68a911776ea.png)

#### 添加powershell版本

- 例如,我要添加名为`pwsh7.3`,且可执行文件绝对路径为`C:\Program Files\powershell\7\pwsh.exe`
- 通常推荐使用gui进行配置
  - 这是因为,配置的时候不需要定位到具体的json对象
  - 对于windows环境下路径不需要手动转移反斜杠
- 配置完,settings.json文件中的添加了如下内容

- ```bash
  "powershell.powerShellAdditionalExePaths": {
  	"pwsh7.3": "C:\\Program Files\\powershell\\7\\pwsh.exe"
  }
  ```

## powershell插件加载问题

- 如果您的系统powershell版本不符合vscode powershell插件的支持

- 或者配置的非默认powershell 版本的路径设置出现问题
  - 也可能是重装软件导致路径过期
  - 或者vscode软件/powershell extension版本更新导致接口更新,需要更新配置格式(需要查阅最新文档)

#  配置模块@脚本@函数 🎈

##  references
- [关于脚本 - PowerShell | Microsoft Docs](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2)
	-  [简短说明](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2#short-description)
	* [长说明](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2#long-description)
	* [如何运行脚本](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2#how-to-run-a-script)
	* [获取脚本的帮助](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2#get-help-for-scripts)
	* [如何编写脚本](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2#how-to-write-a-script)
	* [脚本范围和网点源](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2#script-scope-and-dot-sourcing)
	* [模块中的脚本](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2#scripts-in-modules)
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