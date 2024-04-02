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

- 还有的软件(大部分软件的策略)是将开机启动注册在以下**注册表**中

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

    

## windows 系统专业的开机启动软件和服务工具

- [Autoruns for Windows - Sysinternals | Microsoft Learn ](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns)

- 通常不必使用这个软件,但是如果您对windows的开机启动或者登录后自动启动的服务或软件的详细清单或细节感兴趣,我们考虑下载这个小工具

- 工具解压后的目录内可能包含如下内容

  - ```bash
    PS>ls_eza -deepth 5
    Mode  Size Date Modified Name
    d----    - 26 Mar 19:17   .
    -a---  25k  6 Feb 19:49  ├──  autoruns.chm
    -a--- 1.8M  6 Feb 19:49  ├──  Autoruns.exe
    -a--- 2.0M  6 Feb 19:49  ├──  Autoruns64.exe
    -a--- 2.1M  6 Feb 19:49  ├──  Autoruns64a.exe
    -a--- 718k  6 Feb 19:49  ├──  autorunsc.exe
    -a--- 804k  6 Feb 19:49  ├──  autorunsc64.exe
    -a--- 827k  6 Feb 19:49  ├──  autorunsc64a.exe
    -a--- 7.5k  6 Feb 19:48  └──  Eula.txt
    ```

- 可以看到里面有诸多可执行文件,包含3个GUI程序和命令行版本的可执行程序

### 不同平台的版本

- 您所列举的文件列表代表了在下载的Autoruns工具目录下包含的不同组件和文档，它们各有其特定用途和适用场景。下面是对这些文件的解读：

  1. **autoruns.chm**:
     这是一个编译过的HTML帮助文件（CHM格式），包含了Autoruns工具的详细使用手册和帮助信息。通过双击打开此文件，您可以查阅关于工具各项功能、选项、启动项类型的详细说明，以及如何使用Autoruns进行系统启动项管理的步骤指导。这对于初次使用或需要深入了解工具功能的用户非常有用。


#### GUI版本

1. **Autoruns.exe**:
   这是适用于32位（x86）Windows系统的Autoruns主程序。如果您正在使用的是32位操作系统，或者在64位系统中需要管理32位应用程序的启动项，应运行此文件来启动Autoruns工具。

2. **Autoruns64.exe**:
   这是专门为64位（x64）Windows系统设计的Autoruns主程序。如果您使用的是64位操作系统，并希望管理与之对应的64位应用程序的启动项，应运行此文件。由于64位系统同时支持32位和64位应用，通常建议在64位系统中使用对应的64位版本工具以获取更完整的信息。

3. **Autoruns64a.exe**:
   这可能是arm64平台的版本

#### 命令行版本

1. **autorunsc.exe**:
   这是Autoruns的命令行版本。相比于图形界面版，autorunsc.exe允许用户通过命令行参数进行操作，适合自动化脚本、远程管理或在无图形界面环境下使用。它可以用来批量查询、导出或处理启动项数据，为系统管理员提供了更为灵活的管理方式。

2. **autorunsc64.exe**:
   同样是命令行版本，但针对64位Windows系统。与`autorunsc.exe`类似，适用于在64位环境中通过命令行进行启动项管理。

3. **autorunsc64a.exe**:
   类似于`Autoruns64a.exe`，这可能是arm64 平台的版本

4. **Eula.txt**:
   End User License Agreement（最终用户许可协议）文本文件，详述了您使用该软件的权利和限制，包括但不限于版权、使用范围、责任免除、技术支持政策等内容。在使用任何软件之前，尤其是商业或专业级工具，建议仔细阅读并接受其许可协议。

总结来说，这个目录包含了Autoruns工具的主程序（图形界面版和命令行版，分别针对32位和64位系统）、帮助文档以及许可协议。根据您的操作系统类型、操作习惯（图形界面还是命令行）以及具体需求，选择相应版本的程序进行启动项管理。在使用前务必阅读并理解Eula.txt中的条款。

### 介绍



- 上述工具来自Microsoft,提供的Sysinternals工具集中的autoruns
- 该工具集包含一系列强大工具，专为高级用户、系统管理员和IT专业人士设计，旨在帮助他们对Windows操作系统进行故障排查、监控及管理。
- Autoruns这款工具，它是一款极其实用的应用，用于详细检查和管理在Windows启动或登录过程中自动运行的各种程序、进程和服务。
  1. **功能定位**：
     Autoruns是一款专注于系统启动项管理的工具。其主要目标是帮助用户全面、深入地了解并控制Windows启动过程中的各种自动加载项，包括但不限于启动文件夹、注册表键值、计划任务、服务、驱动程序、Winlogon通知、Explorer加载项等。这些加载项可能会影响系统的启动速度、资源占用以及整体稳定性。

  2. **功能特点**：
     - **全面检测**：Autoruns能够扫描并列出系统中几乎所有的启动项来源，远超Windows自带的“任务管理器”或“系统配置实用程序(msconfig)”所提供的信息。
     - **详细信息展示**：对于每个启动项，Autoruns不仅显示其名称、路径、类型，还提供关联的发布者、数字签名、命令行参数等详细信息，便于用户判断其性质和潜在影响。
     - **深度分析**：通过内置的签名数据库，Autoruns可以帮助识别已知的恶意软件或潜在不安全的启动项，为安全分析和清理工作提供支持。
     - **操作便捷**：用户可以直接在Autoruns界面中启用、禁用或删除启动项，无需在复杂的注册表编辑器或系统设置中寻找相关条目。
     - **实时更新**：作为Sysinternals工具集的一部分，Autoruns会随着技术发展和威胁形势的变化持续更新，以确保其检测能力和兼容性。

  3. **应用场景**：
     - **系统优化**：通过禁用不必要的启动项，可以加快系统启动速度，减少资源占用，提升整体性能。
     - **故障排查**：当系统出现启动慢、卡顿、异常行为等问题时，使用Autoruns查找并处理可能导致问题的启动项，有助于解决问题。
     - **安全防护**：定期检查启动项，及时发现并移除潜在的恶意软件、间谍软件或其他不安全的自动加载项，提高系统安全性。
     - **系统定制**：对于高级用户和IT专业人员，Autoruns可用于精确控制系统的启动行为，实现特定的定制化需求。


### 案例

- 某些软件难以用系统自带的**启动应用**(或任务管理器中的**启动**)中找到或关闭自启动
- 例如Intel的驱动升级助手DSA:[英特尔® 驱动程序和支持助理安装程序 (intel.cn)](https://www.intel.cn/content/www/cn/zh/support/intel-driver-support-assistant.html)

## windows快速启动功能

- Windows的快速启动功能是一项旨在缩短操作系统启动时间的技术，特别是在Windows 10及后续版本中得到广泛应用。


### 混合休眠与冷启动的结合

快速启动本质上是将传统的冷启动（即完全关闭系统后重新启动）与休眠模式的部分特性相结合。具体来说，当您选择“关机”时，系统实际上执行了以下几个步骤：

1. **保存系统状态**：Windows在关闭前将当前系统的内核状态、驱动程序、以及部分用户会话信息写入一个特殊的文件——**hiberfil.sys**。这个文件位于系统分区根目录下，通常隐藏，大小与物理内存相当或略大于物理内存，用于存储休眠数据。

2. **实际关机**：完成上述保存工作后，系统执行类似冷关机的过程，切断电源供应给硬件，但保留hiberfil.sys文件在硬盘上。

3. **快速恢复**：当您下一次按下电源按钮启动计算机时，Windows不再像常规冷启动那样从头加载操作系统和驱动程序。相反，它直接从hiberfil.sys文件中读取先前保存的系统状态，并将其快速载入内存。这样一来，系统无需经历完整的初始化过程，而是直接跳转到登录界面，大大减少了启动所需时间。

### 快速启动的优点

- **提高效率**：显著减少开机时间，使用户能更快地开始工作或使用计算机。

- **用户体验改善**：减少等待时间，提升用户满意度。

### 快速启动的注意事项👺

- **空间占用**：启用快速启动功能需要保留与物理内存大小相当的硬盘空间来存放hiberfil.sys文件。对于硬盘空间紧张的用户，这可能是一个考虑因素。

- **某些情况下的限制**：在某些特定场景下，快速启动可能不如预期般有效，如在安装了大量更新后首次启动、系统出现严重错误需要进行自我修复时，或者在进行了硬件改动后，系统可能仍需要进行完整的启动过程。

- **驱动程序兼容性**：虽然大多数现代驱动程序都支持快速启动，但在极少数情况下，某些驱动程序可能与快速启动机制不完全兼容，导致启动过程中出现问题。遇到此类问题时，可能需要更新或替换不兼容的驱动程序。

### 启用与禁用快速启动

快速启动通常在Windows 10系统中默认启用，但用户可以根据需要在系统设置中手动调整。以下是一般步骤（可能因系统更新有所变化）：

1. **打开电源选项**：可以通过控制面板、设置应用或者右键点击开始菜单找到“电源选项”。

2. **进入高级设置**：在电源选项界面中找到并点击“选择电源按钮的功能”或类似的选项，接着点击“更改当前不可用的设置”。

3. **启用/禁用快速启动**：在随后出现的窗口中，找到“启用快速启动”选项，并根据需要勾选或取消勾选。最后，保存设置更改。

### 结论

Windows的快速启动功能通过结合冷启动与休眠的优势，实现了显著的开机时间优化，提升了用户的使用体验。尽管存在一些潜在限制和注意事项，但对于大多数用户而言，这项功能是提升计算机启动速度的有效手段。用户可根据自身需求和系统状况决定是否启用或禁用快速启动功能。





