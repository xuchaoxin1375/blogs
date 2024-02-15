[toc]

## windows配置开机自启动软件或脚本

### 配置自启动目录

- 在Windows中添加开机自动运行的软件，可以按照以下步骤进行操作：
  1. 按下Win+R键，打开“运行”对话框。
  2. 在运行对话框中输入“`shell:startup`”，并点击“确定”按钮。
  3. 在打开的“启动”文件夹中，右键点击空白处，选择“新建”→“快捷方式”。
  4. 在弹出的“新建快捷方式”对话框中，输入要启动的程序的路径和名称。
  5. 点击“下一步”按钮，输入快捷方式的名称，然后点击“完成”按钮。 这样，添加的程序就会在系统启动时自动运行了。

### 开机运行的脚本

- 通常的,我们可以在这个自动运行目录里面配置一个**脚本文件**(或者其他位置下的某个脚本的**快捷方式**),而在这个脚本中编写我们需要的逻辑(启动某个软件,检查网络连通性,延迟执行,都可以写在同一个脚本文件中,也方便维护)
  - 这个目录中的任务文件在开机时会被尝试打开或执行,如果是文件夹,会被尝试自动打开
  - 我们可以只保留一个脚本(或脚本的快捷方式)在里面,在脚本文件可以是一个大杂烩,可以调用各种api,也方便我们备份开机自启动配置,迁移到另一台windows上,比较灵活,而且管理的文件数目也会更少
- 在windows平台上有多种脚本类型可以选用,比如传统的`cmd`(bat),`powershell`(ps1),`vbs`(vbs)文件或者它们的**快捷方式**
- 这里提到快捷方式,它的一个用处在于启动shell参数的配置,例如我们可能不希望powershell脚本的运行窗口弹出来(或者尽可能快地自动关闭,即使这个脚本需要执行比较长的一段时间)
  - 例如`powershell.exe -NoLogo -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\path\to\your_script.ps1"`

### 调试开机自启动脚本

- 为了便于确认编写的脚本是否能够符合预期执行,可以在桌面创建开机运行的脚本的快捷方式,并且填写合适的参数,控制窗口的显示
- 在powershell脚本中,使用`Pause`等指令和`Tee-Object`可以用来跟踪日志


### 配置守护进程(包装成自启动服务)

- 许多没有自带的软件(包括命令行软件)都可以通过[nssm](https://nssm.cc/download)软件进行包装,配置启动参数不在话下
- 当然一般我倾向于用前面的配置自启动目录的方法,不需要额外的软件

### 使用任务计划程序

- 任务计划命令行程序[schtasks commands | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks)

  - ```bash
    PS 🕰️16:08:44 [C:\exes\alist\log] 🔋100% schtasks.exe /?
    
    SCHTASKS /parameter [arguments]
    
    描述:
        允许管理员创建、删除、查询、更改、运行和中止本地或远程系统上的计划任
        务。
    
    参数列表:
        /Create         创建新计划任务。
    
        /Delete         删除计划任务。
    
        /Query          显示所有计划任务。
    
        /Change         更改计划任务属性。
    
        /Run            按需运行计划任务。
    
        /End            中止当前正在运行的计划任务。
    
        /ShowSid        显示与计划的任务名称相应的安全标识符。
    
        /?              显示此帮助消息。
    
    Examples:
        SCHTASKS
        SCHTASKS /?
        SCHTASKS /Run /?
        SCHTASKS /End /?
        SCHTASKS /Create /?
        SCHTASKS /Delete /?
        SCHTASKS /Query  /?
        SCHTASKS /Change /?
        SCHTASKS /ShowSid /?
    ```

    

- 开发windows 应用中相关api[使用任务计划程序 - Win32 apps | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/win32/taskschd/using-the-task-scheduler)

- 图形界面`taskschd`[Task Scheduler Overview | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc721871(v=ws.11)?redirectedfrom=MSDN)

  | 命令行输入`taskschd`启动任务计划程序                         | 创建新的任务计划                                             |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/e796725b12674a06a1bb9e24f4f5e0a0.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/067d70276f874db182d8e1cac9b799c2.png) |      |
  | `taskschd`是windows自带的程序,十分古老但是有用`C:\Windows\System32\taskschd.msc` | 可以选择定期执行,也可以选择条件触发,比如开机启动(运行)       |      |

- 可以配置权限等,操作丰富

### FAQ

- 需要注意的是，有些程序在启动时可能会需要**管理员权限**
  - 此时需要右键点击快捷方式，选择“属性”→“兼容性”→“以管理员身份运行此程序”，并点击“确定”按钮，以确保程序可以正常启动。
-  另外，如果需要删除已经添加的开机自动运行程序，只需要在“启动”文件夹中删除相应的快捷方式即可。

## 开机自动运行脚本示例

- ```bash
  
  # 为了更快的执行开机自启动脚本的执行速度,请在$startup_user目录内创建startup_basic.lnk,并且设置参数为如下
  # powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\repos\scripts\startup\startup_basic.ps1"
  #这样就不会加载不必要的配置,从而快速完成任务
  #可以选择隐藏powershell窗口静默执行:使用选项-WindowStyle Hidden
  # $scripts = 'C:\repos\scripts'
  
  #导入基本的powershell环境变量和字符串
  ImportGlobalEnvs
  # 日志:记录当前时间
  # "test:$(Get-Date)"> "$scripts\startup\log\log"
  
  #配置延迟启动(单位:秒)
  function sleep_tips
  {
      param(
          $delay = 0
      )
      
      if ($delay)
      {
          Write-Output "after $delay seconds run next task"
      }
      Start-Sleep $delay
  }
  
  # @REM 检查网络可用性,拖延一段时间(ping 2次即可,一般不需要太多次)
  $log_home = "$Scripts\startup\log"
  Set-Location $log_home
  $log_file = "$log_home\log.txt"
  
  ping www.baidu.com -n 2 | Tee-Object $log_file #初始化日志文件,这里不用append参数,只保留一次记录
  Get-Date | Tee-Object -Append $log_file
  
  
  
  #后台(不打印日志到前台)启动alist服务
  # $scriptBlock = {
  #     # $alist_home = 'c:\exes\alist'
  #     # Set-Location $alist_home
  #     # # (vbs免弹出窗口,同时也不会由信息输出,所以可以不用后台执行)
  #     # "$alist_home\startup.vbs" | Invoke-Expression
  #     # 当窗口退出后,如下写法会停止alist服务,因此下面的写法不可用
  #     # "$alist_home\alist.exe server" | Invoke-Expression
  # }
  # Start-Job -ScriptBlock $scriptBlock
  
  Set-Location $alist_home
  # (vbs免弹出窗口,同时也不会由信息输出,所以可以不用后台执行)
  "$alist_home\startup.vbs" | Invoke-Expression
  
  sleep_tips -delay 4
  importAliasGlobal #导入常用命令别名(会占用若干秒的时间)
  #尝试重定向输出到日志文件,但这在powershell似乎无法做到,我们用start-job虽然隐藏了输出,却无法重定向到文件
  # 如果想要接受start-job启动的任务返回结果,使用Receive-Job -Id $job.id,其中$job是Start-job 赋值的对象
  #然而这里调用的vbs没有输出结果,因此是空白的输出,就不需要定向到日志文件中
  #有些软件,例如alist server输出内容无法使用 >,2>等重定向阻止输出到标准输出终端(不知道cmd能不能做到)
  
  
  #执行已经编写好的cmd脚本文件,对于老系统,可以直接使用cmd脚本
  # C:\repos\scripts\startup\MapCloudDrive.bat
  
  $MapLog = "$scripts\startup\log\MapLog.txt"
  # "c:\repos\scripts\startup\log\MapLog"
  
  net use W: http://localhost:5244/dav /p:yes /savecred *> $MapLog # 可以输出为日志 *> "$MapLog"
  '👺👺👺' | Tee-Object -Append $MapLog
  net use | Tee-Object -Append $MapLog
  Get-Date | Tee-Object -Append $MapLog
  
  
  #查看日志文件
  
  Get-Content $log_home/*
  
  
  # 用pause指令阻止powershell窗口自动关闭
  # Pause 
  Start-Sleep 2
  
  #配置需要自启动的软件(缓慢启动)
  # "$snipaste_home\snipaste" | Invoke-Expression
  # "$ditto_home\ditto" | Invoke-Expression
  snipaste
  ditto
  #注意cfw会将日志打印占用终端,导致无法退出终端的问题,最为开机自启,如果使用 hidden参数隐藏窗口也是可以的
  # Start-Job -ScriptBlock { & 'C:\exes\cfw\Cfw.exe' }
  cfw *> null #将错误信息统统放空
  
  
  ```
  
  



