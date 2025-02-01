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

    

### powershell 方案👺

使用`start-process`可以打开一个新进程,这样原来的命令行窗口被关闭,也不会导致新窗口也被关闭

而`start-process`有一个参数`NoNewWindow`,这个参数不适合我们需要后台默默运行的情况,因为这不会创建新窗口,在当前窗口被关闭后,`start-process`启动的任务也会被关闭

此外,`Start-process`还有一个`WindowStyle`参数,我们可以指定为`hide`,可以对部分窗口做隐藏化窗口启动(比如powershell命令行窗口能够对`windowsStyle`的指定做出相应,就比较服务我们的需要);

Note:

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

#### 例

```powershell
 Start-Process  -WindowStyle Hidden -FilePath  pwsh -ArgumentList '-c Start-HTTPServer -port 8001'
```

或

```powershell
 Start-Process  -WindowStyle Hidden -FilePath  pwsh -ArgumentList {-c Start-HTTPServer -port 8080}
```



### 封装为powershell函数

```powershell

function Start-ProcessHidden
{
    <# 
    .SYNOPSIS
    在后台运行指定任务,由powershell启动,启动后的进程是后台进程(隐藏窗口)和启动者进程相互独立,启动者被杀死也不会影响后台进程
    这是和Start-Job的一个重要区别(依赖于当前powershell进程)
    .DESCRIPTION
    本命令启动的进程窗口通过-WindowStyle Hidden属性隐藏(隐藏窗口,而不是最小化窗口),来达到后台运行任务的效果
    如果使用windows terminal(wt)管理shell 窗口,利用本命令启动powershell后台任务隐藏窗口后,可能会在windows terminal窗口列表中留下一个空shell选项卡
    
    .EXAMPLE
    #执行桌面上的一个日志脚本(其他内容比如说是每隔1秒钟就往log文件中写入一行时间日志)
    PS C:\Users\cxxu\Desktop> Start-ProcessHidden -File .\LogTime.ps1
    .EXAMPLE
    #Scriptblock参数支持接受字符串包裹的命令行脚本块

    Start-ProcessHidden -scriptBlock 'start-TimeAnnouncer -TickMinsOnly 35 -Verbose'
    Start-ProcessHidden -scriptBlock {start-TimeAnnouncer -TickMinsOnly 33 -Verbose}

    .EXAMPLE
    #利用Scriptblock参数来执行指定的命令行脚本块,而不是执行指定的脚本文件
    PS C:\Users\cxxu\Desktop> Start-ProcessHidden -scriptBlock {
    >> function Write-TimeToLog
    >> {
    >>     param (
    >>
    >>     )
    >>     # 获取当前时间
    >>     $currentTime = Get-Date -Format 'HH:mm:ss'
    >>
    >>     # 构建日志文件路径
    >>     $logFilePath = Join-Path $([Environment]::GetFolderPath('Desktop')) 'log.txt'
    >>
    >>     # 追加当前时间到日志文件
    >>     Add-Content -Path $logFilePath -Value $currentTime
    >>
    >> }
    >> while (1)
    >>  {
    >>     Write-Host 'writing...'
    >>     Write-TimeToLog
    >>     Start-Sleep 1
    >>  }
    >> }

    NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
    ------    -----      -----     ------      --  -- -----------
        6     0.45       2.64       0.02   20416   1 pwsh


    PS [C:\Users\cxxu\Desktop]> cat .\log.txt -Wait
    22:31:43
    22:31:44
    22:31:45
    22:31:46
    22:31:47
    22:31:48
    ...

    .EXAMPLE
    # 启动chfs后台任务(注意chfs严格检查参数的大小写,例如-file不能写成-File,否则会报错,这是一个linux风格的命令行工具)
    Start-ProcessHidden -FilePath C:\exes\chfs\chfs -ArgumentList "-file C:\exes\chfs\chfs.ini" #-file 不能作-File
    #>
    [CmdletBinding()]
    param (
        # executable file Path(like the -FilePath parameter of Start-Process)
        [Parameter(  ParameterSetName = 'FilePath')]
        $FilePath,

        [Parameter(  ParameterSetName = 'FilePath')]
        $ArgumentList,


        [Parameter( ParameterSetName = 'PwshScriptBlock')]
        $scriptBlock


        # [Parameter(ParameterSetName = 'PwshScriptFile')]
        # $scriptFile
    )
   
    if ($PSCmdlet.ParameterSetName -eq 'FilePath')
    {
        $p = Start-Process -WindowStyle Hidden -FilePath $FilePath -ArgumentList $ArgumentList -PassThru
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'PwshScriptBlock')
    {
        $p = Start-Process -WindowStyle Hidden -FilePath pwsh.exe -ArgumentList '-noe','-Command', ([scriptblock]::Create($scriptBlock.ToString()) -join "`n") -PassThru
    }

    return $p
}

```

## powershell中受限于当前进程(会话)的后台任务方案👺

- 包括`Start-job`命令以及`&`符号的应用
- 一些命令的`Asjob`参数

### start-job以及命令中的Asjob参数功能

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

这里利用了powershell代码块(更准确地叫**脚本块**Scriptblock)的特点,与其他shell语言很不同:[关于脚本块 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_script_blocks?view=powershell-7.4)

脚本块的一个重要特点是可以包含参数,详情查看文档

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



### Start-job其他高级用例

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

....

```

## 某些命令的Asjob参数

`-AsJob` 参数在 PowerShell 中用于在后台运行命令，以便您可以继续执行其他操作而不会等待该命令完成。

`Invoke-Command` 的 `-AsJob` 参数用于远程执行命令，并且不能与本地执行命令结合使用。如果需要在本地运行一个任务并使用后台作业功能，应使用 `Start-Job`。

### 在后台运行一个长时间的任务

假设我们有一个耗时的任务，例如等待 3 秒，然后输出一条消息。我们可以使用 `-AsJob` 参数让这个任务在后台运行。

示例代码：

```powershell
# 启动后台任务
$job = Start-Job -ScriptBlock {
    Start-Sleep -Seconds 3
    "任务完成！"
}

# 继续执行其他操作，并检查任务状态
while ($job.State -eq 'Running') {
    Write-Host "任务正在运行..."
    Start-Sleep -Seconds 1
}
write-host '任务结束'

# 获取并显示任务结果
$result = Receive-Job -Job $job
Write-Host $result
```



## 混合方案

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

创建方式有命令行方式也有GUI方式,详情另见它文

