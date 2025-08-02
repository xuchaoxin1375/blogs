[toc]

## abstract

- 在 PowerShell 中，可以通过自定义 `$prompt` 变量来修改命令行提示符（Prompt）。以下是修改 PowerShell 提示符的一些基本方式：

  1. **简单修改**：
     你可以直接覆盖 `$prompt` 变量的内容，例如将其设为任何你想要的文字：
     ```powershell
     $prompt = "Hello, World PS> "
     ```

  2. **动态提示符**：
     利用 PowerShell 表达式来构造动态提示符，例如包含当前目录、时间戳或用户名等信息：
     ```powershell
     function prompt {
         "$([System.Environment]::UserName) at $(Get-Location): $(Get-Date -Format 'HH:mm:ss') > "
     }
     ```

  3. **颜色和样式**：
     使用 ANSI 转义码或 PowerShell 的 Write-Host 命令配合特殊字符来实现颜色和样式变化：
     ```powershell
     function prompt {
         Write-Host -ForegroundColor Green -NoNewline "[ $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ]"
         Write-Host -ForegroundColor DarkCyan -NoNewline "($(Get-Location)) "
         return ">"
     }
     ```


### 流行的powershell prompt模块

1. **使用 PowerShell 模块**：
   有一些社区开发的 PowerShell 模块，如 posh-git 和 oh-my-posh，专门用于增强和美化 PowerShell 提示符，尤其是针对 Git 用户，它们会在提示符中显示 Git 仓库的状态。

2. **定制复杂的提示符**：
   你还可以根据自己的需求编写更为复杂的函数来定制提示符，它可以包含各种环境信息、快捷菜单项、甚至是图形元素（如在 Windows Terminal 应用中）。

### 示例

```powershell
function prompt {
    $GitStatus = git status --porcelain 2>$null
    $Branch = git rev-parse --abbrev-ref HEAD 2>$null
    if ($LASTEXITCODE -eq 0) {
        "$([char]0x1b)[32m[$Branch]$([char]0x1b)[0m$(if ($GitStatus) {' *'}) $($pwd.ProviderPath)\>"
    } else {
        "PS $($pwd.Path)>"
    }
}
```
以上示例尝试获取 Git 分支信息并检查是否有未提交的更改，从而在提示符中显示 Git 相关状态。

请注意，对于不同版本的 PowerShell （尤其是跨平台的 PowerShell Core），提示符的定制可能会有所差异，需确保代码兼容对应的 PowerShell 版本。同时，为了防止与其他脚本冲突，建议在用户的配置文件（如 `Microsoft.PowerShell_profile.ps1`）中进行个性化提示符的设置。

##  powershell原生修改Prompt函数

- 通过重写prompt来修改powershell命令行提示符的样式👺

- 本方案不需要第三方模块,但是需要自己编写和设计主题(可以clone或参考仓库)

### 配置文档

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

### Prompt命令来自哪里

如果机器上安装了许多软件,可能会遇到命令活别名冲突

例如我的机器上安装了MiniConda,并且配置了powershell启动Conda环境

然后发现了powershell内置的Prompt函数被覆盖了

- ```bash
  PS>gcm prompt
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Function        prompt                                             0.0        Conda
  ```

  

  

## 简单修改

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

### 带上电量和时间的Prompt

- ```powershell
  function Get-BatteryLevel
  {
      # get battery charge:
      $charge = Get-CimInstance -ClassName Win32_Battery | Select-Object -ExpandProperty EstimatedChargeRemaining
      return $charge
      # "Current Charge:[ $charge %]."
      # -replace '.*\[(.*)\].*', '$1'
  }
  
  function Set-PromptNice
  {
      Set-Item -Path function:prompt -Value { 'PS ' + '🕰️' + (Get-Date -Format T) + ' ' + "[$(Get-Location)]" + " 🔋$(Get-BatteryLevel)%" + '> ' }
      # 显示时分秒,可以用-Format T 或 -Displayhint time
  }
  ```

  

- 效果

  ```bash
  #执行上述函数,调用之
  PS C:\Users\cxxu>Set-PromptNice
  #查看效果
  PS 🕰️21:22:26 [C:\Users\cxxu] 🔋77%> pwd
  
  Path
  ----
  C:\Users\cxxu
  ```

  

## 复杂修改

### 预览👺

- | 深色主题                                                     | 浅色主题                                                     |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/0e47f72368164a6ebbaf3570f59131db.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/17c6be9c1c6349c494904612513d86c3.png) |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/72f6243c9dc5438fba3af84c733f9566.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/f60c1e14681d46b09a8808bde231debd.png) |
  
  ```powershell
  PS☀️[BAT:75%][MEM:36.45% (11.56/31.71)GB][16:24:01]
  # [~\Desktop]
  PS> set-promptVersion Brilliant
  
  ┌─PS☀️[BAT:75%][MEM:36.38% (11.54/31.71)GB]
  ├─[cxxu@COLORFULCXXU][2024-05-21][16:24:07]
  ├─# [~\Desktop]
  └─PS> get-administratorPrivilege
  updating envs!
          env_set1
          env_set2
          strings
  2024/5/21 16:24:12
  
  PS🌙[BAT:75%][MEM:36.79% (11.67/31.71)GB][16:24:12]
  #⚡️[~\Desktop]
  PS> set-promptVersion Brilliant
  
  ┌─PS🌙[BAT:75%][MEM:36.73% (11.65/31.71)GB]
  ├─[cxxu@COLORFULCXXU][2024-05-21][16:24:21]
  ├─#⚡️[~\Desktop]
  └─PS>
  ```
  
  

### FAQ:有没有必要修改Prompt

- 有些用户觉得没必要,确实,通常没有必要去修改原生的shell样式
  - 让prompt显示的信息满足自己的需要才是最好的
  - 过少的内容可能让人觉得单调
  - 过多的内容会导致重点不突出,反而影响效率
  - 通常提示符的内容不要超过2行为宜

- 后面的内容有简洁和信息均衡的prompt可供参考,而且仓库内提供了多个样式
  - 有很简单的,也有很复杂的
  - 后续可能会引入git 信息检查,但是根据经验,进入大型仓库后prompt的响应性能可能会受到较大影响,这时体验会急剧下降,许多oh my posh的提示符引入了git检查,在大仓库中prompt相应很慢,这可能是得不偿失的

### 相关仓库地址

- 下面提到的Prompt样式虽然显示的信息量不少,但是响应性能是不错的
  - [modules - 码云 - 开源中国 (gitee.com)](https://gitee.com/xuchaoxin1375/scripts/tree/main/modulesByCxxu)
  - 但是prompt的正确显示依赖于powershell初始化相关变量才会显示相应的信息字段
  - 也就是说,刚启动一个新的powershell环境时,如果要使用本文提供的prompt主题,可能会有比较明显的延迟,但是加载完环境后,prompt具有良好的响应速度
  - 具体实现被我放到多个模块中,以提高灵活性和可维护性

- 相关模块(目录):
  - pwsh
  - Info
  - init
  - TaskSchdPwsh
  - ...powershell Global变量
- 仓库中有许多文档(后期更新整理)

### 样式选择

```bash
PS[BAT:77%][MEM:36.65% (11.62/31.70)GB][21:26:16]
# [C:\Windows]
 Set-PromptVersion Balance
 #目前可选的样式:
Balance     Brilliant   Brilliant2  Default     Short       short2      Simple

```



### 平衡样式

- 效果预览

  ```powershell
  PS[BAT:77%][MEM:36.64% (11.62/31.70)GB][21:24:13]
  # [~\Desktop]
  PS[BAT:77%][MEM:36.67% (11.63/31.70)GB][21:25:54]
  # [~]
   cd $env:windir
  
  PS[BAT:77%][MEM:36.65% (11.62/31.70)GB][21:26:16]
  # [C:\Windows]
  ```

- 这个提示符带有多个信息

  - 显示当前是否为管理员权限(如果是,显示一个小闪电,并且背景设置为蓝绿色,否则为深灰色)
  - 显示初始化模式(如果是完全初始化,则显示为一个太阳标,否则为核心初始化,显示为一个月亮标)
  - 电池电量
  - 内存占用比率
  - 已使用内存
  - 总量比例
  - 显示时分秒

- 配色丰富清晰(上一节的截图中查看)

- 具有较好的兼容性(没有花哨的字体和符号)

- 具有较高的响应速度

### 花哨样式

- ```powershell
  ┌─PS[BAT:77%][MEM:39.84% (12.63/31.70)GB]
  ├─[cxxu@COLORFULCXXU][2024-04-19][21:44:35]
  ├─# [~\Desktop]
  └─ pwd
  
  Path
  ----
  C:\Windows
  ```

- 在平衡样式的基础上进一步显示:`userName@HostName`以及年月日的信息

- 并且用阶梯状的风格显示这个大Prompt😂

- 即便响应性能和平衡样式差不多,但过于花哨,容易喧宾夺主,我自己平时用的也比较少

## 响应性能👺

- 经过实验,这几种样式响应性能都不错

  - 其中最耗时的时读取内存占用的命令,大概要100ms左右
  - 虽然100ms对于人来说慢,也就0.1s,但是对于计算机这个时间算不上短
  - 要知道默认的prompt响应时间0.1ms级别的,不超过1ms
  - 而经过实验,如果响应时间不超过0.1s,体验还是可以的,但是如果按住回车键不断刷新shell prompt,那么0.1s的响应速度就不够看了,此时能够发现比较明显的响应滞后
  - 而我们如果能够优化到0.01s级别的,那么响应速度在体验上就有了飞跃,即便是按住回车不断刷新prompt,也可以做到几乎感觉不到响应延迟(尽管仍然比不上0.0001s的默认响应速度)


### 如何优化

- 命令行中显示内存占用还是蛮酷的,那么如何优化?
- 我们可以考虑拉大刷新内存占用的间隔,比如说每隔5秒钟计算一次内存占用信息(其他时刻获取上一次计算的结果)
- 这样经过实验,可以把响应速度从0.1s级别提高到0.01s级别
- 甚至我们还可以创建一个后台进程来执行计算内存占用这一耗时任务,而prompt每次刷新只需要读取后台进程给出的结果就行

### 附上性能测试结果

- ```powershell
  #默认样式微调,性能是0.0001s级别的
  PS [C:\repos\scripts]> test-PromptDelay
  0.00019081 seconds
  
  PS [C:\repos\scripts]> set-PromptVersion brilliant
  
  #花哨样式,性能是0.01s级别的
  ┌─PS[BAT:77%][MEM:39.77% (12.61/31.70)GB]
  ├─[cxxu@COLORFULCXXU][2024-04-19][22:12:33]
  ├─# [C:\repos\scripts]
  └─ test-PromptDelay
  0.013235219999999997 seconds
  
  
  #推荐的平衡样式性能也为0.01s级别
  PS[BAT:77%][MEM:39.62% (12.56/31.70)GB][22:12:44]
  # [C:\repos\scripts]
   test-PromptDelay
  0.01090278 seconds
  ```

- 补充:`test-PromptDelay`函数测试10次prompt刷新调用的平均耗时

  - 内存占用计算每各5秒钟重新计算一次,提高响应速度
  - 那么内存占用率显示的是5秒内的数值(延迟不超过5秒),理想情况下平均数据滞后时间为2.5s,而任务管理器中的普通刷新也是滞后的,效果大致和low级别的频率相当

## 小结

- 让shell 的prompt显示的信息丰富一些,色彩搭配丰富一些,可以提高命令行环境的使用体验
- 同时,要注意避免过于复杂的prompt,会导致响应速度变慢,命令行输入输出信息被埋没在Prompt中导致效率降低