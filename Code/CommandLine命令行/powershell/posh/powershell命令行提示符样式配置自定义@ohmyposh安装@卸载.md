[toc]

# abstract

- 介绍两种方案来自定义配置prompt主题
  - 免安装模块:powershell编辑prompt函数来更改命令行提示符
  - 安装流行模块:posh主题设置和自定义@动态补全配置

# Prompt函数

- 本方案不需要第三方模块,但是需要自己编写和设计主题

## 配置文档

- [关于 Prompt - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_prompts?view=powershell-7.4)

- 文档中给出了基本信息和配置方式,这里不再赘述,而讨论许多配置效果以及可能遇到的问题

- PowerShell 中的 `prompt` 函数是一个特殊内置函数，它负责定义命令行提示符的格式和内容。每当 PowerShell 完成一行命令的执行并准备接受下一条命令输入时，它会调用 `prompt` 函数来生成一个新的提示符字符串。

  默认情况下，`prompt` 函数显示类似以下格式的提示符：
  ```plaintext
  PS [当前目录]>
  ```
  这里的 "PS" 是 PowerShell 的标识符，紧跟的是当前工作目录路径，然后是一个大于号（>），表示等待用户输入命令。

  用户可以根据需要自定义 `prompt` 函数以改变提示符的行为和样式，例如添加时间戳、用户名、主机名、颜色等元素。例如，一个简单的自定义 `prompt` 函数可能如下所示：

  ```powershell
  function prompt {
      "$([System.DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss')) $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
  }
  ```
  上述函数会让 PowerShell 提示符显示当前时间以及目录，而不是默认的格式。

  通过编辑 `prompt` 函数，您可以完全个性化您的 PowerShell 控制台体验，使其更符合个人喜好或特定工作场景的需求。

## Prompt命令来自哪里

如果机器上安装了许多软件,可能会遇到命令活别名冲突

例如我的机器上安装了MiniConda,并且配置了powershell启动Conda环境

然后发现了powershell内置的Prompt函数被覆盖了

- ```bash
  PS>gcm prompt
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Function        prompt                                             0.0        Conda
  ```

  

- 

  ```bash
  PS>(Get-Command Prompt).ScriptBlock
  
          if ($Env:CONDA_PROMPT_MODIFIER) {
              $Env:CONDA_PROMPT_MODIFIER | Write-Host -NoNewline
          }
          CondaPromptBackup;
  
  
  ```

- 为了创建一个在 PowerShell 中的自动补全功能，你可以使用动态参数和参数补全（TabExpansion）。这些特性可以帮助你在输入命令参数时提供自动补全的功能。下面是一个如何创建一个 `Show-Command` 函数，它使用了 `Register-ArgumentCompleter` 来注册一个自定义的参数补全器，使你能够在输入 `-Name` 参数时自动补全以指定字符串开头的命令：

  ```powershell
  function Show-Command {
      [CmdletBinding()]
      param(
          [Parameter(Mandatory = $true)]
          [string]$Name
      )
  
      # 调用 get-command 来显示以 Name 开头的命令
      Get-Command -Name "${Name}*"
  }
  
  # 注册参数补全，使其用于 Show-Command 的 Name 参数
  Register-ArgumentCompleter -CommandName Show-Command -ParameterName Name -ScriptBlock {
      param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
      
      # 搜索所有可能的命令以便于补全
      $commands = Get-Command -Name "$wordToComplete*" | ForEach-Object { $_.Name }
      
      # 返回补全结果
      $commands | ForEach-Object {
          [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
      }
  }
  
  # 现在可以尝试 Show-Command -Name Go 并按下 Tab 来补全了
  ```

  将这段代码复制到你的 PowerShell 会话中，或者你的 PowerShell 配置文件（profile）中。定义函数并注册了参数补全之后，你就可以使用 `Show-Command -Name Go` 并按下 Tab 键，它会自动显示和提供所有以 “Go” 开头的命令进行补全。

  请注意，`Show-Command` 在这里是我们自定义的函数名，和 PowerShell 自带的 `Show-Command` cmdlet 不同。如果你想保持内置 cmdlet 和自定义函数的名称一致性，你可能需要为你的函数选择不同的名称，以避免命名冲突。

- 

  

# Posh

## 安装oh my posh

- [Windows | Oh My Posh](https://ohmyposh.dev/docs/installation/windows#update)
  - 文档提供了多种方式安装,但是国内可能下载不下来
  - 可以直接打开github/release页面下载:[Releases · JanDeDobbeleer/oh-my-posh (github.com)](https://github.com/JanDeDobbeleer/oh-my-posh/releases)

### 安装模式

- oh my posh下载被制作为一个`.exe`程序,可以手动下载安装,并且可以选择安装模式
  - 仅为当前用户安装
  - 为所有用户安装
- 命令行安装通常是仅为当前用户安装(不需要管理员权限),而GUI安装界面还可以选择**为所有用户安装**,这需要管理员权限

- 不同安装模式安装后环境变量以及对应的安装目录不同,通过` $env:POSH_THEMES_PATH`获取路径
- 如果为当前用户安装过,再次为所有用户安装,那么当前用户的环境变量会盖过系统环境变量(如果只需要保留一个,可以考虑卸载掉一个)

### 权限问题

- 仅为当前用户安装的好处是修改posh的配置文件不需要管理员权限,比较方便



## 基本使用步骤

- Now that Oh My Posh is installed, you can go ahead and configure your terminal and shell to get the prompt to look exactly like you want.

  - install a [font](https://ohmyposh.dev/docs/installation/fonts)(本文提供了网盘链接)
  - configure your terminal/editor to use the installed font
  - configure your shell to [use Oh My Posh](https://ohmyposh.dev/docs/installation/prompt)
  - (optional) configure a theme or [custom prompt configuration](https://ohmyposh.dev/docs/installation/customize)




### posh命令和posh for powershell 命令👺

- 安装完posh后,其会自动配置环境变量,因此可以在任意shell中访问到posh程序(命令行程序)

  - ```bash
    PS 🕰️5:09:29 PM [C:\Users\cxxu\Desktop] 🔋100%→posh -h
    oh-my-posh is a cross platform tool to render your prompt.
    It can use the same configuration everywhere to offer a consistent
    experience, regardless of where you are. For a detailed guide
    on getting started, have a look at the docs at https://ohmyposh.dev
    
    Usage:
      oh-my-posh [flags]
      oh-my-posh [command]
    
    Available Commands:
      cache       Interact with the oh-my-posh cache
      completion  Generate the autocompletion script for the specified shell
      config      Interact with the config
      debug       Print the prompt in debug mode
    ```

### posh提供的可用函数

- 检查posh模块提供的所有可用的powershell函数

  ```powershell
  🚀 gcm *posh*|where {$_.Source -like "oh-my-posh*"}
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Function        Enable-PoshLineError                               0.0        oh-my-posh-core
  Function        Enable-PoshTooltips                                0.0        oh-my-posh-core
  Function        Enable-PoshTransientPrompt                         0.0        oh-my-posh-core
  Function        Export-PoshTheme                                   0.0        oh-my-posh-core
  Function        Get-PoshThemes                                     0.0        oh-my-posh-core
  Function        Set-PoshContext                                    0.0        oh-my-posh-core
  ```



### posh初始化和主题设置👺

- 但在powershell中,使用posh更改命令行提示符主题,或者调用posh提供的powershell函数,则前提是调用posh进行初始化powershell,即
- 详情另见:[powershell@posh主题设置和自定义@动态补全配置_oh my posh 修改主题-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/121123275)



### oh my posh 字体问题

- [Fonts | Oh My Posh](https://ohmyposh.dev/docs/installation/fonts)
  - 虽然posh提供了字体下载方法,但是在国内不容易下载下来,可以到官网下载
    - [Nerd Fonts - Iconic font aggregator, glyphs/icons collection, & fonts patcher](https://www.nerdfonts.com/font-downloads)
  - 分享一下网盘文件https://www.123pan.com/s/l7DKVv-rDbsH.html
    - 里面有`FiraMono Nerd`字体
    - 可能会失效,有条件的到官网下载





##  自动启动posh@powershell的配置文件 "$Profile"

- 根据需要修改以下配置文件,其中`#xxx`是注释,不会运行

```bash
#import Module (recommended add the next line,but,of course ,you can  choose not  to add the item,if you do not use the git tools)
# Import-Module posh-git

# import posh
Import-Module oh-my-posh
#set theme
Set-poshPrompt paradox
#set tab auto completion(optional item)
#(the command line will try to offer you a list(candidated) when you press the `tab`key
#of course,if the current path have only one or even none can match what you want to match,it will just try to complete the current object name

Set-PSReadlineKeyHandler -Key Tab -Function Complete
```



## 推荐的 posh-git模块😊

- [https://github.com/dahlbyk/posh-git/](https://github.com/dahlbyk/posh-git/)

- 安装方式有许多,如果网络不好的话,可以用国内镜像加速把仓库克隆或下载下来

- 然后手动导入项目中src目录下的`posh-git.psd1`即可

- 例如

  - ```powershell
    Import-Module "$repos\posh-git\src\posh-git.psd1"
    ```

## 自定义powershell命令行提示符的样式👺

### 简单修改

- 使用posh等美化工具需要比较大的开销,反映会变慢;

- 我们可以利用以下方法简单地修改默认地powershell提示符样式

  ```powershell
  function prompt_style
  {
      Set-Item -Path function:prompt -Value { 'PS ' + '🕰️' + (Get-Date -Format T) + ' ' + "[$(Get-Location)]" + ' ' }
      # 显示时分秒,可以用-Format T 或 -Displayhint time
  }
  ```

- ```bash
  PS 🕰️11:45:19 [C:\repos\scripts] 
  ```

- 日期或时间显示字段设置:[Get-Date (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/get-date?view=powershell-7.4)

### 带上电量

- ```powershell
  function batteryChargePer
  {
      # get battery charge:
      $charge = Get-CimInstance -ClassName Win32_Battery | Select-Object -ExpandProperty EstimatedChargeRemaining
      return $charge
      # "Current Charge:[ $charge %]."
      # -replace '.*\[(.*)\].*', '$1'
  }
  
  function prompt_style
  {
      Set-Item -Path function:prompt -Value { 'PS ' + '🕰️' + (Get-Date -Format T) + ' ' + "[$(Get-Location)]" + " 🔋$(batteryChargePer)%" + ' ' }
      # 显示时分秒,可以用-Format T 或 -Displayhint time
  }
  ```

  

##  基本的配置效果👺

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210613195329513.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)



## 卸载@移除 oh-my-posh👺

### 使用winget卸载

- [How to delete oh-my-posh from powershell? · JanDeDobbeleer/oh-my-posh · Discussion #2752 · GitHub](https://github.com/JanDeDobbeleer/oh-my-posh/discussions/2752)

- 使用winget卸载(如果您的电脑已经安装了winget(win11自带该工具))

  - `winget uninstall JanDeDobbeleer.OhMyPosh -s winget`

  - ```
     themes  winget uninstall JanDeDobbeleer.OhMyPosh -s winget
    已找到 Oh My Posh [JanDeDobbeleer.OhMyPosh]
    正在启动程序包卸载...
    已成功卸载
    ```

### 手动卸载

- 找到posh安装目录,找到`unins000`,卸载

  - ```
    PS C:\Program Files (x86)\oh-my-posh> ls
    
            Directory: C:\Program Files (x86)\oh-my-posh
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    d----          2024/2/8     23:45                  bin
    d----          2024/2/9      0:39                  themes
    -a---          2024/2/8     23:45          23103   unins000.dat
    -a---          2024/2/8     23:45        3209720 󰣆  unins000.exe
    -a---          2024/2/8     23:45          24097   unins000.msg
    ```

    







