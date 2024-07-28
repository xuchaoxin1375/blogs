[toc]



## abstract

在后台运行一段脚本或一个没有GUI的任务

尤其是启动任务P的命令行,假设运行命令行的的窗口为X,当X被关闭后,任务P不会一同被关闭,而是继续在后台运行

## 方案

### vbs脚本

- 有些程序员会使用`.vbs`脚本文件来运行一段开机自动执行的逻辑,也可以用来默默在后台启动某个任务
- 然而vbs在新系统中会被移出,这种方法将局限于不太新的系统(直到win11应该是都可以用)

#### 模板

```vbscript
Dim ws
Set ws = Wscript.CreateObject("Wscript.Shell")
ws.run "command line",vbhide
Wscript.quit
```

- 将其中的`command line`替换为自己要执行的命令行,例如
  1. `chfs.exe --file ./chfs.ini`
     - 这里如果没有配置`chfs.exe`路径到环境变量Path的值中,则可能需要绝对路径来表示,而且`--file `参数跟的路径也需要绝对路径,或者将脚本保存到`chfs.exe`同一个目录下
  2. `"alist.exe server"`
  3. `"taskkill /f /im alist.exe"`
  4. ...
- 修改后保存到一个后缀为`.vbs`的文本文件中,放到合适的位置

#### 例

- 以下是我用来开机自动启动chfs文件共享服务站点的`.vbs`脚本文件,将它放到`shell:startup`目录下,就可以开机自动后台启动chfs;

- 我们也可以手动关闭,可以利用命令行`ps chfs|kill`来停止任务,即便没有GUI,也可以将任务停掉

- 或者创建一个对应杀死进程的`.vbs`脚本

  - ```powershell
    PS☀️[BAT:77%][MEM:34.92% (11.07/31.71)GB][21:46:50]
    # [cxxu@CXXUCOLORFUL][C:\exes\chfs]
    PS> cat .\startup.vbs
    
    Dim ws
    Set ws = Wscript.CreateObject("Wscript.Shell")
    ws.run "chfs.exe --file ./chfs.ini",vbhide
    Wscript.quit
    
    ```

- 另一个例子是Alist,流行的网盘挂载服务,作者提供了一段用来开机自启的`vbs`脚本

  - 启动任务

    ```powershell
    PS [C:\Users\cxxu\Desktop]> cat C:\exes\alist\startup.vbs
    Dim ws
    Set ws = Wscript.CreateObject("Wscript.Shell")
    ws.run "alist.exe server",vbhide
    Wscript.quit
    
    ```

  - 停止任务

    ```powershell
    
    PS [C:\Users\cxxu\Desktop]> cat C:\exes\alist\stop.vbs
    Dim ws
    Set ws = Wscript.CreateObject("Wscript.Shell")
    ws.run "taskkill /f /im alist.exe",0
    Wscript.quit
    ```

    

### powershell 启动

使用`start-process`可以打开一个新进程,这样原来的命令行窗口被关闭,也不会导致新窗口也被关闭

而`start-process`有一个参数`NoNewWindow`,这个参数不适合我们需要后台默默运行的情况,因为这不会创建新窗口,在当前窗口被关闭后,`start-process`启动的任务也会被关闭

此外,`Start-process`还有一个`WindowStyle`参数,我们可以指定为`hide`,可以对部分窗口做隐藏化窗口启动(比如powershell命令行窗口能够对`windowsStyle`的指定做出相应,就比较服务我们的需要);

#### Note

但是,如果使用windows terminal,简称`wt` (而不是自带的console,尤其是选择),部分`wt`版本的则可能导致`start-process  -windowstyle hide`启动的powershell窗口无法彻底隐藏(会有一个空选项卡留在wt的shell活动列表中,容易应该wt被关闭而意外停止我们需要保留的进程)

#### 模板

```powershell
#简单方式:不保留日志
Start-Process  -WindowStyle Hidden -FilePath  <program> -ArgumentList '<args>' 

#或者:保留日志输出到日志文件(但这不一定管用,有的程序把日志输出位置有file参数指定的配置文件来指定(尽量确保路径存在),甚至只允许你指定日志文件存放目录,日志文件的名字又程序自己指定)
Start-Process  -WindowStyle Hidden -FilePath  <program> -ArgumentList '<args>' *> '<LogPath>'
```

替换`< >`为具体的值

#### 例

仍然以启动`chfs`为例

```powershell
Start-Process  -WindowStyle Hidden -FilePath  C:\exes\chfs\chfs.exe -ArgumentList '-file C:\exes\chfs\chfs.ini'  
```

我们还可以查看相关进程

```powershell

PS☀️[BAT:77%][MEM:36.1% (11.45/31.71)GB][21:57:48]
# [cxxu@CXXUCOLORFUL][C:\exes\chfs]
PS> ps chfs

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     12    15.34      12.11       0.05   21356   1 chfs

```

查看该进程的启动命令行

```powershell
PS☀️[BAT:77%][MEM:36.16% (11.47/31.71)GB][21:58:03]
# [cxxu@CXXUCOLORFUL][C:\exes\chfs]
PS> ps chfs|select -ExpandProperty CommandLine
"C:\exes\chfs\chfs.exe" -file C:\exes\chfs\chfs.ini
```

### 封装为powershell函数 TODO

```

```

## powershell中受限于当前进程(会话)的后台任务方案👺

- [Start-Job (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/start-job?view=powershell-7.4)

- 从 PowerShell 6.0 开始，可以使用与符号 (`&`) 后台运算符启动作业。 后台运算符的功能类似于 `Start-Job`。 这两种启动作业的方法都会创建 PSRemotingJob 作业对象。 
- 若要详细了解如何使用与符号 (`&`)，请参阅 [about_Operators &](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.4#background-operator-)。
- 某些命令还支持`-Asjob`参数,可以起到作为后台作业运行任务的效果,例如`Invoke-command`

### 使用自动变量`$input`传递给`InputObject`参数

[inputobject@Start-Job (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/start-job?view=powershell-7.4#-inputobject)

[scriptblock@Start-Job (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/start-job?view=powershell-7.4#-scriptblock)

指定要在后台作业中运行的命令。 若要创建脚本块，请将命令括在大括号 (`{}`) 中。 

使用 `$input` 自动变量访问 InputObject 参数的值。 此参数是必需的。

例如

```powershell
PS C:\exes> start-job {param($m) New-TextToSpeech -message $input} -InputObject $m

Id     Name            PSJobTypeName   State         HasMoreData     Location
--     ----            -------------   -----         -----------     --------
11     Job11           BackgroundJob   Running       True            localhost
```



### 使用块内参数`{param()}`

1. 将变量 `$m` 设置为字符串 `"abc"`。
2. 使用 `Start-Job` cmdlet 启动一个后台作业，并将 `$m` 作为参数传递给作业块中的 `New-TextToSpeech` 函数。

```powershell
# 定义消息变量
$m = 'abc'

# 启动后台作业，并将消息作为参数传递
Start-Job -ScriptBlock {
    param($message)
    New-TextToSpeech -Message $message
} -ArgumentList $m

# 显示作业信息
Get-Job
```



启动后台作业:
```powershell
Start-Job -ScriptBlock {
    param($message)
    New-TextToSpeech -Message $message
} -ArgumentList $m
```
- `Start-Job` cmdlet 用于启动一个后台作业。
- `-ScriptBlock` 参数指定了要在后台执行的代码块。这里，我们使用 `param($message)` 来定义一个参数，并将该参数传递给 `New-TextToSpeech` 函数。
- `-ArgumentList $m` 指定了传递给作业块的参数，这里是变量 `$m`。



### 其他高级用例

```powershell
PS C:\repos\scripts> $file
C:\repos\blogs\readme.md
PS C:\repos\scripts> Start-Job -Name JobDemo -ScriptBlock { Get-Content -Path $input } -InputObject $file

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
13     JobDemo         BackgroundJob   Running       True            localhost             Get-Content -Path $inpu…

PS C:\repos\scripts> Receive-Job -Name JobDemo
# test board

-   [Themes · ohmyzsh/ohmyzsh Wiki (github.com)](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)

-   [Open vimrc file | Vim Tips Wiki | Fandom](https://vim.fandom.com/wiki/Open_vimrc_file)

-   [Example vimrc | Vim Tips Wiki | Fandom](https://vim.fandom.com/wiki/Example_vimrc)

-   [How to sudo without password on CentOS Linux - nixCraft (cyberciti.biz)](https://www.cyberciti.biz/faq/how-to-sudo-without-password-on-centos-linux/)

-   [JavaScript Programming with Visual Studio Code](https://code.visualstudio.com/Docs/languages/javascript)

```



### 混合方案

使用`vbs`脚本创建可以后台运行的脚本

然后利用`powershell`函数来调用执行相关脚本

例如

```powershell

function Start-ChfsShareServer
{
    Set-Location $chfs_home
    '.\startup.vbs' | Invoke-Expression

    # 等待一秒后检查进程服务是否启动
    Start-Sleep 1
    Get-Process alist
}

function Start-AlistShareServer
{
    param (
        # $alist_home=''
    )
    Set-Location $alist_home
    '.\startup.vbs' | Invoke-Expression

    # 等待一秒后检查进程服务是否启动
    Start-Sleep 1
    Get-Process alist
        
}
```



## 其他方案

### 包装成服务

有几种方案

- [NSSM - the Non-Sucking Service Manager](https://nssm.cc/)

- [New-Service (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/new-service?view=powershell-7.4&viewFallbackFrom=powershell-7)

### 使用任务计划程序

比如设置一段开机自动运行的程序(可携带参数),不一定要启动shell窗口来执行

- 你可以通过任务计划程序来创建一个任务，使其在后台运行。步骤如下：
  1. 打开任务计划程序（Task Scheduler）。
  2. 创建一个新的基本任务。
  3. 在任务触发器中选择“当我登录时”。
  4. 在操作中选择“启动程序”，并浏览选择你的脚本或程序。
  5. 完成并保存任务。

