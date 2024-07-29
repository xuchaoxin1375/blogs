[toc]



## abstract

- powershell是强大的面相对象的语言,我们可以用它来播放语音,弹出GUI窗口,甚至让系统弹出一条通知
- 也许您想要在windows上找到能够整点报时或半点报时,定点报时的方法,有一些软件可以做到
  - 比如windows自带的**时钟(clock)**软件,有计时器,闹钟和秒表等功能;我们可以考虑使用闹钟来充当整点报时(每个钟头设置一个闹钟)
  - 但GUI软件闹钟一般不会播读当前时间,也没办法自动化批量设置报时
- 但我们可以不安装任何软件,在带有powershell的windows系统(通常是win10之后的系统),仅通过powershell实现报时功能
- 下面用一个综合的例子来说明这一点

## powershell报时器

- 下面的函数调用了其他函数,您可以克隆仓库:[scripts: 辅助脚本 (gitee.com)](https://gitee.com/xuchaoxin1375/scripts)阅读关于powershell Module文档下载并简单设置自动导入powershell模块,就能够快速调用相关模块中的函数

```powershell
function Start-TimeAnnouncer
{
    <# 
.SYNOPSIS
整点报时或者半点报时或者指定分钟报时
.description
可以配合Start-ProcessHidden来使用,实现后台运行此任务
.EXAMPLE
#整点与半点时报时
Start-ProcessHidden -scriptBlock {Start-TimeAnnouncer}
.EXAMPLE
#创建一个独立的后台powershell进程进行报时活动;指定在每个小时的20,21分时进行报时,其他分钟不报时
PS C:\exes> Start-ProcessHidden -scriptBlock {Start-TimeAnnouncer -TickMinsOnly 20,21 }

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
      6     0.42       2.61       0.02   19044   1 pwsh
.EXAMPLE
#临时运行,不需要保持后台运行,则直接调用,这里指定输出日志;指定处于28分时,每三秒请求一次报时
#由于是前台执行(当前会话会被占用),按下Ctrl+C结束此任务
PS C:\Users\cxxu\Desktop> Start-TimeAnnouncer -TickMinsOnly 28 -Verbose -TryReportInterval 3 -CheckInterval 1
.EXAMPLE
查找后台运行的报时任务:

PS C:\Users\cxxu\Desktop> ps pwsh|select id,CommandLine|sls Start-TimeAnnouncer

@{Id=19044; CommandLine="C:\Program Files\PowerShell\7\pwsh.exe" -Command Start-TimeAnnouncer -TickMinsOnly 20,21 }
@{Id=26924; CommandLine="C:\Program Files\PowerShell\7\pwsh.exe" -Command Start-TimeAnnouncer}

.EXAMPLE
指定时间报时;整分钟刚好报时,可以指定这一组轮询组合 -TryReportInterval 60 -CheckInterval 1

PS C:\Users\cxxu\Desktop> Start-TimeAnnouncer -InHour24Format 21 -InMinute 49 -Verbose -TryReportInterval 60 -CheckInterval 1
VERBOSE:  21:48:34
.....
....
VERBOSE:  21:48:58
VERBOSE:  21:48:59
Reporting time:21:49:00

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
5      Job5            BackgroundJob   Running       True            localhost            New-TextToSpeech -messag…
.EXAMPLE
#指定语音引擎报时(倒计时),同时弹出一个窗口,显示结束时间
可用的引擎可以自己安装语音包获取
例如:PS C:\repos\scripts> Get-SpeechVoiceOptions
Microsoft David Desktop - English (United States)
Microsoft Zira Desktop - English (United States)
Microsoft Huihui Desktop - Chinese (Simplified)
Microsoft Tracy Desktop - Chinese(Traditional, HongKong SAR)
Microsoft Hanhan Desktop - Chinese (Taiwan)
# 倒计时3秒后报时,同时弹出一个窗口,3秒后关闭;这里语音报时和显示窗口都是会阻塞当前绘画的调用,因此这里设法把他们送到后台作业去执行
PS C:\repos\scripts> start-timeAnnouncer -Timer 3 -Verbose -ShowWindow -Duration 3 -DesktopVoice Zira
Reporting timer Start From:22:51:47
waiting...
Reporting time:3 seconds  Passed!

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
13     Job13           BackgroundJob   Running       True            localhost            New-TextToSpeech -messag…
15     Job15           BackgroundJob   Running       True            localhost            Show-Message -Message " …
Reporting timer end at:22:51:50

#>
    # 定义 TTS 报时函数
    [CmdletBinding()]
    param (
        # 自定义报时(分钟)
        
   

        [parameter(ParameterSetName = 'MinsOnly')]
        $TickMinsOnly = @(),
        # 
        [parameter(ParameterSetName = 'Alarm')]
        $InHour24Format ,
        [parameter(ParameterSetName = 'Alarm')]
        $InMinute ,

        #倒计时报时(秒),例如输入4.5*60，表示倒计时4分钟半后倒计时报时(闹钟)
        [parameter(ParameterSetName = 'Timer')]
        $Timer = 0,



        [switch]$ShowWindow,
        $Duration = 2,
        # 可以自行查找系统安装的TTS引擎,参考Microsoft官方文档
        $DesktopVoice = 'Huihui', #常见的还有Zira(英文引擎)等,Huihui是中文引擎

        # [ValidateSet('Chinese', 'Default')][string]    
        # $Language = 'Default',

        # 等待一分钟，以避免重复报时
        #设置每多秒请求一次报时(不超过60),如果设置为0,表示不启用此参数
        # 否则建议配合$CheckInterval=1来使用,否则可能漏报,调试时可以设置的短一些,比如5秒,甚至是3秒(也不易过小)
        $TryReportInterval = 0,

        # 本函数采用定时检查时分秒的方式，这里控制每多少秒检查一下时间如果是调试报时,可以将60改为1等小的数试试报时效果)
        # 当检查间隔为1时是最密集的检查,再小则是浪费;
        $CheckInterval = 60
    )
    # function New-TextToSpeech{}
    
    function tickTime
    {
        param(
            $message = $Time
        )
        <# 
            检查时间并在指定分钟时报时
            这里是内部函数,参数请定义在外部函数的param()中
            #>
        #如果$TickMinsOnly不为空,则只报定义于$TickMinsOnly中指定分钟,包括整点和半点都不搞特殊
       
        Write-Host "Reporting time:$message" -ForegroundColor Red
        
        New-TextToSpeech -message " $message" -DesktopVoice $DesktopVoice & #这里使用后台执行运算符&

        if ($ShowWindow)
        {
            Show-Message -Message " $message" -Duration $Duration &
        }

    }   
    $TickMinsOnly = @($TickMinsOnly)
    # 处理定点报时:采用轮询的方式,为了判断当前时间是否应该报时,需要放置在循环中,每隔一段时间检查一次(比如1秒)
    while ($true)
    {
        $currentHour = (Get-Date).Hour
        # 关键是分钟,是否是30分(半点)还是0分 (整点)
        $currentMinute = (Get-Date).Minute
        $currentSecond = (Get-Date).Second
        
        $TimeRaw = Get-Time
        $Time = Get-Time -SetSecondsToZero

        $report = $false

        # 是否处于倒计时模式
        if ($PSCmdlet.ParameterSetName -eq 'Timer' )
        {
    
            Write-Host "Reporting timer Start From:$TimeRaw" -ForegroundColor Green
            Write-Host 'waiting...'
            # 直接倒计时$timer秒即可
            Start-Sleep $Timer
            # $report = $true
            tickTime -message "$Timer seconds  Passed!"

            Write-Host "Reporting timer end at:$(Get-Time)" -ForegroundColor Red
            # 闹钟报时后直接退出
            return
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'Alarm')
        {
            if ($currentHour -eq $InHour24Format -and $currentMinute -eq $InMinute)
            {
                # $report = $true
                tickTime
                return 
            }

        }
        elseif ($PSCmdlet.ParameterSetName -eq 'MinsOnly')
        {
            if (
                $TickMinsOnly -contains $currentMinute 
            )
            {
                # Announce time
                $report = $true
            }
        }
        elseif (
            $currentMinute -eq 0 -or
            $currentMinute -eq 30 
        )
        {
            $report = $true
        }
        # 统一根据需要报时
        if ($report)
        {
            tickTime
            
        }
             
    

        # $currentSecond -eq 0
        Write-Verbose " $(Get-Time)"
        if ($TryReportInterval)
        {
            # 提高报时频率用的,主要用于调试(一分钟内会报时几次)
            if ( $currentSecond % $TryReportInterval -eq 0 )
            {
                # tickTime # 报时
                Write-Host "$DesktopVoice $(Get-Time)" -ForegroundColor Blue
            }
        }
     

        
        # Start-Sleep -Seconds 60
        Start-Sleep -Seconds $CheckInterval

    }
}
```