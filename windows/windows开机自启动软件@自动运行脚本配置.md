[toc]

## windows配置开机自启动软件或脚本

### 配置自启动目录

- 在Windows中添加开机自动运行的软件，可以按照以下步骤进行操作：
  1. 按下Win+R键，打开“运行”对话框。
  2. 在运行对话框中输入“`shell:startup`”，并点击“确定”按钮。
  3. 在打开的“启动”文件夹中，右键点击空白处，选择“新建”→“快捷方式”。
  4. 在弹出的“新建快捷方式”对话框中，输入要启动的程序的路径和名称。
  5. 点击“下一步”按钮，输入快捷方式的名称，然后点击“完成”按钮。 这样，添加的程序就会在系统启动时自动运行了。

### 补充👺

- 在 Windows 系统中，开机自启动程序通常可以放在两个不同的目录下：

  1. **用户级别的启动目录**：
     用户自启动目录用于让某个特定用户在登录时启动指定的应用程序。在 Windows 10 及以上版本中，用户个人的启动目录位于：
     ```
     C:\Users\[用户名]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
     ```
     其中 `[用户名]` 是当前用户的账户名称。

  2. **系统级别的启动目录**：
     系统启动目录用于配置所有用户在登录时都自动启动的应用程序。此目录的位置在 Windows 10 及以上版本中是：
     
     ```
     C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
     ```

- 若要通过命令行快速打开这两个目录，可以分别使用以下命令：

  - 打开用户级别的启动目录：
    ```shell
    explorer shell:startup
    ```

  - 打开系统级别的启动目录：
    ```shell
    explorer shell:common startup
    ```

- 或者直接在运行（Win + R）对话框中输入上面的 `shell:startup` 和 `shell:common startup` 并回车。

- 将程序快捷方式或可执行文件放入这些目录中，就可以实现相应级别的开机自启动功能。

  - 但需要注意的是，随着 Windows 安全性的提升，一些权限限制可能会影响非管理员用户的操作。
  - 此外，对于现代 Windows 版本，如 Windows 11 和 Windows 10，还可以通过“设置”->“应用”->“启动”来管理开机启动的应用程序。(搜索启动(startup),可以进行配置)

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



## 注册表和开机自启软件配置

- 软件有的会将自己的快捷方式创建到用户的startup目录

  - 通常是:`$env:appdata\Roaming\Microsoft\windows\Start Menu\programs\Startup`

  - 例如

    ```
    C:\Users\cxxu\AppData\Roaming\Microsoft\windows\Start Menu\programs\Startup
    ```

- 还有的软件(大部分软件的策略)是将开机启动注册在以下注册表中

  - 要在 PowerShell 中查看 `HKEY_USERS\S-1-5-21-1150093504-2233723087-916622917-1001\Software\Microsoft\Windows\CurrentVersion\Run` 这个特定注册表路径下的内容，可以使用如下命令：

  - ```powershell
    # 先定位到 HKEY_USERS 下对应的 SID 键
    $SID = 'S-1-5-21-1150093504-2233723087-916622917-1001'
    $keyPath = "Registry::HKEY_USERS\$SID\Software\Microsoft\Windows\CurrentVersion\Run"
    
    # 列出该路径下的注册表键及其值
    Get-ItemProperty -Path $keyPath
    ```

- 这段命令首先构造了要访问的完整注册表路径，然后使用 `Get-ItemProperty` 命令来获取该路径下所有键值对的数据。

- 这个路径指向的是特定用户的启动项，即当该用户登录时会自动运行的应用程序列表。如果想要查看该路径下有哪些程序会在用户登录时启动，上述命令将会输出相关的应用程序名称及其对应的执行路径。

  - ```powershell
    PS>startup_register
    
    OneDrive                : "C:\Users\cxxu\AppData\Local\Microsoft\OneDrive\OneDrive.exe" /background
    com.alicloud.smartdrive : C:\Users\cxxu\AppData\Local\Programs\aDrive\aDrive.exe --openAtLogin
    QQNT                    : "C:\Program Files\Tencent\QQNT\QQ.exe" /background
    BaiduYunDetect          : "C:\Users\cxxu\AppData\Roaming\baidu\BaiduNetdisk\YunDetectService.exe"
    Docker Desktop          : C:\Program Files\Docker\Docker\Docker Desktop.exe -Autostart
    PSPath                  : Microsoft.PowerShell.Core\Registry::HKEY_USERS\S-1-5-21-1150093504-2233723087-916622917-1001\
                              Software\Microsoft\Windows\CurrentVersion\Run
    ```

    





