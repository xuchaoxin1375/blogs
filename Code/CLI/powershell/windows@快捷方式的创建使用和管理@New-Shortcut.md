[toc]

## abstract

- windows中的快捷方式有两类
  - 便于自定义的lnk文件快捷方式(指的是创建后会生成相应的`.lnk`或`.url`文件,以第一类为主)
  - 系统默认的快捷键组合(比如切换输入法,打开系统录屏等)
- 两类快捷方式都很常用,不过通常主要是指第一类,而第二类主要称为快捷键(组合)
- 为了便于讨论,简称第一类快捷方式为快捷方式,第二称为快捷键

### windows lnk文件快捷方式

Windows快捷方式（Shortcuts）是一种方便用户快速访问**文件、文件夹、应用程序或系统功能**的机制。

通过创建快捷方式，用户可以避免深入文件系统或多个菜单中寻找目标，提升工作效率。

我没有找到创建快捷方式的官方文档(可能是因为创建快捷方式很简单,windows提供的右键创建快捷方式引导程序还是比较易用和通俗易懂的)

### windows hotkey键盘快捷方式(快捷键)

- [Windows 的键盘快捷方式 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/windows-的键盘快捷方式-dcc61a57-8ff0-cffe-9796-cb9706c75eec)
- lnk快捷方式可以设置快捷键触发方式,比如我可以创建一个重启资源管理器的快捷方式到桌面,在这个资源管理器中设置快捷键组合,这样不需要用鼠标点击快捷方式的图标,也可以启动快捷键对应的目标或程序或脚本

### 快捷方式的基本概念

1. **快捷方式文件**：快捷方式是一种特殊的文件，它通常以`.lnk`为扩展名。快捷方式文件并不包含目标对象的实际数据，而是一个指向目标对象的位置标识符。

2. **快捷方式图标**：快捷方式文件的图标通常会在左下角有一个小箭头，表示这是一个快捷方式而不是目标文件本身。

3. **快捷方式的路径**：快捷方式存储了目标的路径。这个路径可以是绝对路径（完整的路径地址）或相对路径（基于当前位置的路径）。

4. 其他更多属性(用的相对较少,可以通过快捷方式的属性查看可以配置的项目)

## 创建快捷方式

方法有两大类,一类是图形化界面操作,一类是命令行方式创建

用户可以通过几种方式在 Windows 中创建快捷方式：

- **右键菜单创建**：右键点击文件、文件夹或程序，选择“创建快捷方式”，生成 `.lnk` 文件。
- **从空白创建**：右键点击桌面或文件夹中的空白处，选择“新建” -> “快捷方式”，并按照向导输入目标路径和快捷方式名称。
- **拖拽法**：按住 `Alt` 键并将文件或文件夹拖到桌面或其他文件夹中，系统会自动生成一个快捷方式。

- **命令行方式**,例如在**PowerShe中ll**通过 `New-Object -ComObject WScript.Shell` 创建快捷方式

下面详细介绍

### 图形化方式创建

图形化方式创建的方式又细分为几类,其中通用快捷方式创建的快捷方式更加通用,可以创建携带启动参数的程序启动快捷方式,以及设置快捷键触发等额外信息

而另一类简单快捷方式主要是用来跳转目录或者打开指定位置的文件或程序,默认不携带参数,也不设置说明或快捷键组合和窗口等信息

#### 通用快捷方式:鼠标右键创建

- 右键点击[桌面或任意文件夹]**空白处**，选择“新建” -> “快捷方式”。
  - 在弹出的对话框中输入目标对象的路径或点击“浏览”选择目标。
  - 为快捷方式命名，点击“完成”。

- 通过发送到菜单创建：
  - 右键点击目标对象，选择“发送到” -> “桌面快捷方式”。这会在桌面上生成一个指向该目标的快捷方式。
- 创建快捷方式比较简单,官方没有提供创建文档,但是相关教程很多,也很通俗易懂易操作

#### 简单的文件或文件夹的快捷方式:拖放创建

- 按住`Alt`键（有时也可以是`Ctrl+Shift`），然后将目标对象拖动到需要创建快捷方式的位置，松开鼠标时会自动生成快捷方式。

### GUI方式管理快捷方式

1. **属性设置**：
   - 右键点击快捷方式，选择“属性”，可以查看和修改快捷方式的相关设置。
   - 在“快捷方式”选项卡中，可以修改目标路径、快捷键设置、运行方式等。

2. **快捷键**：
   - 快捷方式可以绑定快捷键。通过在属性的“快捷方式键”字段中输入快捷键组合，用户可以使用特定的按键组合快速启动该快捷方式。

3. **更改图标**：
   - 在“快捷方式”选项卡中，点击“更改图标”按钮，可以为快捷方式指定一个不同的图标。

4. **运行方式**：(不一定有效果,对于powershell,cmd等自带程式有效果,对于explorer(资源管理器)没有效果)
   - 用户可以设置快捷方式在运行时是以普通窗口、最大化窗口或最小化窗口的形式打开。

## 命令行和快捷方式

### 执行创建快捷/修改快捷方式等操作

- [file - Editing shortcut (.lnk) properties with Powershell - Stack Overflow](https://stackoverflow.com/questions/484560/editing-shortcut-lnk-properties-with-powershell)

### 管理快捷方式的powershell函数👺

下面是一个用于创建快捷方式的函数,函数的使用示例包含在头部的文档中

相关的其他函数,参考powershell模块仓库:[PS/Shortcut/Shortcut.psm1 · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/PS/Shortcut/Shortcut.psm1)

安装此命令和使用命令:[PwshModuleByCxxu.md · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/PwshModuleByCxxu.md#自动部署一键运行脚本)

#### 创建快捷方式@New-Shortcut👺👺

```powershell
function New-Shortcut
{

    <# 
    .SYNOPSIS
    创建一个快捷方式
    .DESCRIPTION

    TargetPath 可以是相对路径/绝对路径/也可以是配置在系统变量Path中的可以直接根据软件名启动的程序名
    将该参数设置为非路径的字符串通常没有意义,除非桌面上有个文件名为该字符串的文件或目录
    函数执行完毕后会调用Get-shortcutLinkInfo获取快捷方式的信息

    .DESCRIPTION
    使用此命令行方式创建的快捷方式会在路径(TargetPath)不可用时默认将其拼接到用户桌面目录后,例如`TargetPath = startup.myfile`,
    如果此文件系统无法直接找到该文件，则会自动创建新的路径"$env:USERPROFILE\Desktop\startup.myfile"
    尽管如此,这个自动生成的路径只是一种猜测而已,往往是不可靠的
    快捷方式(Shortcut)不支持相对路径,只支持绝对路径
    在这种仅指定一个名字(不是绝对路径)的情况下,利用本函数提供的参数`TargetPathAsAppName`开关来告诉创建脚本,
    我这个是一个程序名,而不是绝对路径,需要进一步将其转换为绝对路径才可以用(事实上,这个参数也兼容路径字符串)
    在此参数作用下,这里利用了`gcm`命令来解析TargetPath,解析成功的前提是`TargetPath`是存在的路径,
    或者是通过path环境变量配置过路径,能够在命令行直接打开的文件(通常是可执行文件.exe,.msc等),比如说,notepad就是合法的取值

    #>

    <# 

    .EXAMPLE
    
    PS[BAT:69%][MEM:27.80% (8.81/31.70)GB][12:01:17]
    # [~\Desktop]
    PS> New-Shortcut -Path demo3 -TargetPath C:\repos\scripts\PS\Startup\startup.ps1 -Arguments  '-Nologo -NoProfile'
            The shortcut file name must has a suffix of .lnk or .url
            The .lnk extension is used by default
    [C:\Users\cxxu\Desktop\demo3.lnk] will be used
    New-Shortcut: File already exists: C:\Users\cxxu\Desktop\demo3.lnk
    You can use -Force to overwrite it,or move the existing file first

    .EXAMPLE
    # 使用Force参数强制覆盖已有的同名链接文件(如果已经有了的话)
    PS> New-Shortcut -Path demo4 -TargetPath C:\repos\scripts\PS\Startup\startup.ps1 -Arguments  '-Nologo -NoProfile' -Force
            The shortcut file name must has a suffix of .lnk or .url
    [C:\Users\cxxu\Desktop\demo4.lnk] will be used

    Check action result:

    FullName         : C:\Users\cxxu\Desktop\demo4.lnk
    Arguments        : -Nologo -NoProfile
    Description      : 09/22/2024 11:46:37
    Hotkey           :
    IconLocation     : ,0
    RelativePath     :
    TargetPath       : C:\repos\scripts\PS\Startup\startup.ps1
    WindowStyle      : 1
    WorkingDirectory :

    PS[BAT:69%][MEM:27.74% (8.79/31.70)GB][12:01:38]
    # [~\Desktop]
    PS> ls

            Directory: C:\Users\cxxu\Desktop


    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         2024/1/17     10:31           1411   blogs_home.lnk
    -a---         2024/4/21     21:35            715   DCIM.lnk
    -a---         2024/4/28     12:01           1000   demo3.lnk
    -a---         2024/4/16     12:10           1453   EM.lnk
    -a---         2024/4/16     12:10           1439   Math.lnk
    -a---         2024/4/21     22:47           4874   scratch@bugs.md
    -a---         2024/3/22     16:35           1421   Todo.lnk


    PS[BAT:69%][MEM:27.70% (8.78/31.70)GB][12:01:46]
    # [~\Desktop]
    PS> get-ShortcutLinkInfo .\demo3.lnk

    FullName         : C:\Users\cxxu\Desktop\demo3.lnk
    Arguments        : -Nologo -NoProfile
    Description      :
    Hotkey           :
    IconLocation     : ,0
    RelativePath     :
    TargetPath       : C:\repos\scripts\PS\Startup\startup.ps1
    WindowStyle      : 1
    WorkingDirectory :


    .EXAMPLE
    # 设置一个快捷方式,保存在桌面,效果为调用 Typora 打开某个文件夹
    PS[BAT:69%][MEM:27.32% (8.66/31.70)GB][12:04:02]
    # [~\Desktop]
    PS> New-Shortcut -path C:\Users\cxxu\desktop\linux_blogs.lnk -TargetPath 'C:\Program Files\typora\Typora.exe' -Arguments C:\repos\blogs\Linux
    Shortcut created at C:\Users\cxxu\desktop\linux_blogs.lnk

    PS[BAT:69%][MEM:27.33% (8.66/31.70)GB][12:04:52]
    # [~\Desktop]
    PS> ls .\linux_blogs.lnk

            Directory: C:\Users\cxxu\Desktop


    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         2024/4/28     12:04           1007   linux_blogs.lnk


    PS[BAT:69%][MEM:27.34% (8.67/31.70)GB][12:05:00]
    # [~\Desktop]
    PS> Get-ShortcutLinkInfo .\linux_blogs.lnk

    FullName         : C:\Users\cxxu\Desktop\linux_blogs.lnk
    Arguments        : C:\repos\blogs\Linux
    Description      :
    Hotkey           :
    IconLocation     : ,0
    RelativePath     :
    TargetPath       : C:\Program Files\Typora\Typora.exe
    WindowStyle      : 1
    WorkingDirectory :

    .EXAMPLE
    # 创建上帝模式的快捷方式
    $GodModeFolderGUID = 'ED7BA470-8E54-465E-825C-99712043E01C'
    $GodModePath = "shell:::{$GodModeFolderGUID}"
    New-shortcut -path "$home\desktop\GodMode.lnk" -TargetPath 'explorer.exe' -Arguments $GodModePath -Force -TargetPathAsAppName
    
    #执行结果:
    explorer.exe
    Shortcut created at C:\Users\cxxu\Desktop\GodMode.lnk

    FullName         : C:\Users\cxxu\Desktop\GodMode.lnk
    Arguments        : shell:::{ED7BA470-8E54-465E-825C-99712043E01C}
    Description      :
    Hotkey           :
    IconLocation     : ,0
    RelativePath     :
    TargetPath       : C:\WINDOWS\explorer.exe
    WindowStyle      : 1
    WorkingDirectory :
    .EXAMPLE
    #创建一个powershell脚本的快捷方式
    #powershell脚本文件的后缀是.ps1,但是windows系统对于powershell脚本文件默认是不会直接执行的,甚至不会识别出`.ps1`后缀的文件应该调用自带的windows powershell还是用户安装的新版powershell(pwsh)
    而是用快捷方式局面将变得不一样,因为快捷方式可以指定要启动或打开的软件以及启动参数,因此可解决掉打开方式的问题
    PS> $startup_user='C:\Users\cxxu\AppData\Roaming\Microsoft\windows\Start Menu\programs\Startup'
    PS> New-Shortcut -Path $startup_user\startup.lnk  -TargetPath pwsh -TargetPathAsAppName   -Arguments $scripts\ps\startup\startup.ps1 -Force

    Check action result:

    FullName         : C:\Users\cxxu\AppData\Roaming\Microsoft\windows\Start Menu\programs\Startup\startup.lnk
    Arguments        : C:\repos\scripts\ps\startup\startup.ps1
    Description      :
    Hotkey           :
    IconLocation     : ,0
    RelativePath     :
    TargetPath       : C:\Program Files\PowerShell\7\pwsh.exe
    WindowStyle      : 1
    WorkingDirectory :
    .EXAMPLE
    设置scoop安装的typora为markdown文件所在目录的打开方式
    PS> New-Shortcut -Path $HOME\desktop\Mathx -TargetPath typora.exe -Arguments C:\repos\blogs\Courses\Math\ -IconLocation C:\ProgramData\scoop\apps\typora\current\resources\assets\app.ico -Force -TargetPathAsAppName
    
    #>
    <# 
    .EXAMPLE
    #创建一个任务管理器的快捷方式,直接指定taskmger作为TargetPath(需要配合ResolveTargetPath选项),默认打开最大化 显示创建过程中的信息,强制创建
    PS> new-Shortcut -Path tsk -TargetPath taskmgr -WindowStyle Maximized -Force -ResolveTargetPath
        The shortcut file name must has a suffix of .lnk or .url
    [C:\Users\cxxu\Desktop\tsk.lnk] will be used

    Check action result:

    FullName         : C:\Users\cxxu\Desktop\tsk.lnk
    Arguments        :
    Description      : 09/22/2024 12:13:03
    Hotkey           :
    IconLocation     : ,0
    RelativePath     :
    TargetPath       : C:\WINDOWS\system32\taskmgr.exe
    WindowStyle      : 3
    WorkingDirectory :

    .EXAMPLE
    创建taskmgr的快捷方式,这里没有指定TargetPathAsAppName选项，函数内部会推荐你尝试将TargetPath作为可执行程序名(用户可能经常会忘记使用TargetPathAsAppName选项)
    PS> new-Shortcut -Path tsk -TargetPath taskmgr -WindowStyle Minimized  -Force -Verbose -TargetPathAsAppName
    VERBOSE: The path []  is converted to absolute path: [C:\Users\cxxu\Desktop\tsk]
    Try Consider the targetPath as a callable name:@{Source=C:\WINDOWS\system32\Taskmgr.exe}

    Key                 Value
    ---                 -----
    Path                tsk
    TargetPath          taskmgr
    WindowStyle         Minimized
    Force               True
    Verbose             True
    TargetPathAsAppName True

            The shortcut file name must has a suffix of .lnk or .url
    VERBOSE:        The .lnk extension is used by default
    [C:\Users\cxxu\Desktop\tsk.lnk] will be used
    VERBOSE: WindowStyle: 7

    Check action result:

    FullName         : C:\Users\cxxu\Desktop\tsk.lnk
    Arguments        :
    Description      : 09/22/2024 16:28:53
    Hotkey           :
    IconLocation     : ,0
    RelativePath     :
    TargetPath       : C:\WINDOWS\system32\taskmgr.exe
    WindowStyle      : 7
    WorkingDirectory :
    #>
    <# 
    .EXAMPLE
    创建声音设置控制面板(sound)
    PS> New-Shortcut -Path $home/desktop/snd -TargetPath control -Arguments '/name Microsoft.sound'
    TargetPath is not a available path: control
    Try with Option  -TargetPathAsAppName?[y/n](default y to continue):
    Try Consider the targetPath as a callable name:@{Source=C:\WINDOWS\system32\control.exe}
            The shortcut file name must has a suffix of .lnk or .url
    [C:\Users\cxxu/desktop/snd.lnk] will be used

    Check action result:

    FullName         : C:\Users\cxxu\desktop\snd.lnk
    Arguments        : /name Microsoft.sound
    Description      : 09/22/2024 17:59:07
    Hotkey           :
    IconLocation     : ,0
    RelativePath     :
    TargetPath       : C:\WINDOWS\system32\control.exe
    WindowStyle      : 1

    .EXAMPLE
    在桌面上创建可选功能配置控制面板的快捷方式
    PS>  New-Shortcut -Path $home/desktop/windows可选功能配置 -TargetPath optionalfeatures.exe -Force
    #>

    [CmdletBinding()]
    param (
        # 快捷方式要存放的路径
        [string]$Path = '.',

        # 快捷方式指向的目标(目录或文件,可以是课执行程序文件或代码文件)
        [string]$TargetPath,

        # 快捷方式启动参数(当TargetPath为可执行程序时并且接受命令行参数时有用)
        [string]$Arguments = '',
        # 快捷方式的工作目录,部分可执行程序对于工作目录比价敏感,这时候指定工作目录比较有用
        [string]$WorkingDirectory = '',
        # 指定快捷方式的图标,比较少使用此参数,如果快捷方式的图标有问题，或者想要其他的非默认图标,可以使用此参数指定
        $IconLocation = '',

        # 指定快捷方式的目标是一个可执行程序的名字,而不是一个目录或文件的路径
        # 用户可能经常会忘记使用TargetPathAsAppName选项,函数会向用户做出决策推荐
        [switch]
        [alias('ResolveTargetPath')]
        $TargetPathAsAppName,

        # 指定快捷方式的快捷键启动(主要针对放在桌面上的快捷方式)
        $HotKey = '',
        # 对快捷方式的描述
        $Description = "$(Get-Date)",
        # 窗口样式(1为普通，3为最大化，7为最小化),默认为1;此参数不一定有效,例如shell窗口一般有效
        [ValidateSet('Normal', 'Maximized', 'Minimized')]
        $WindowStyle ,
        # 如果已经存在同名快捷方式,使用Force选项覆盖已经存在的快捷方式
        [switch]$Force
    )
    # 处理快捷方式各个属性值
    # 虽然快捷方式仅支持绝对路径,这里尝试获取$Path的绝对路径,将函数间接支持相对路径
    # $Path = Convert-Path $Path #无法解析尚不存在的路径,另寻它法
    if ((Get-PathType $Path ) -eq 'RelativePath')
    {
        $RawPath
        $Path = Join-Path -Path $PWD -ChildPath $Path
        Write-Verbose "The path [$RawPath]  is converted to absolute path: [$Path]"
        
    }
    # 如果不指定为AppName的话，尝试解析传入的TargetPath

    if (! $TargetPathAsAppName)
    {
        # 尝试将TargetPath作为一个路径来解析(同一成绝对路径的形式)
        $TargetPathAbs = Convert-Path $TargetPath -ErrorAction SilentlyContinue
        if (! $TargetPathAbs)
        {
            # 如果解析失败,很可能是用户直接输入了一个可执行程序的名字,那么尝试将它作为可执行程序的名字来处理(也就是不用修改TargetPath)
            Write-Host "TargetPath is not a available path: $TargetPath;You can try the option -TargetPathAsAppName to run it" -ForegroundColor DarkGray
            # 向用户确认是否尝试推荐的决策(这一块代码不是必须的,完全可以要求用户重新追加参数再次执行命令)
            # 为了方便起见,这里加入了交互式的询问
            $Continue = Read-Host -Prompt 'Try with Option  -TargetPathAsAppName?[y/n](default y to continue)'
            if ($Continue.ToLower() -eq 'y' -or $Continue.Trim() -eq '')
            {
                # 报告更改后的行为是如何的
                $TargetPathAsAppName = $true
            
            }
            else
            {
                # 用户放弃推荐的决策,结束函数
                return
            }
        
        }
    }
    # 这里两个if顺序有讲究(如果前面没有指定TargetPathAsAppName,但是函数认为用户很可能会使用TargetPathAsAppName选项,那么会把$TargetPathAsAppName设置为$True)
    if ($TargetPathAsAppName)
    {
        # 如果TargetPath是一个程序名字(而不是路径),那么可以原原本本的传递给TargetPath属性就行(前提是命令中直接输入此名字的换可以打开某个文件或者程序)
        # pass
        # $TargetPathAbs = Convert-Path $TargetPath -ErrorAction SilentlyContinue
        
        $detail = $(Get-Command $TargetPath -ErrorAction Stop | Select-Object Source )  
        # try
        # {

        # }
        # catch
        # {
        #     return
        # }

        Write-Host "Try Consider the targetPath as a callable name: ${Detail} " -ForegroundColor Blue
    }

 
    
    if ($VerbosePreference)
    {
        $PSBoundParameters | Format-Table
    }

    # Write-Host $TargetPath

    # 设置快捷方式取名
    if (!($Path -match '.*\.(lnk|url)$'))
    {
        
        $indent = "`t"
        Write-Host "${indent}The shortcut file name must has a suffix of .lnk or .url" -ForegroundColor Magenta

        Write-Verbose "${indent}The .lnk extension is used by default "

        $Path = "$Path.lnk"
        Write-Host "[$Path] will be used"
    }
    # 检查文件是否存在,根据Force参数决定是否覆盖
    if (Test-Path $Path)
    {
        if ($Force)
        {
            Remove-Item $Path -Force
            # Write-Host $Path 'exist!,Force to remove it'
            # 事实上,如果不移除的话,也会被直接覆盖
        }
        else
        {
            Write-Error "File already exists: $Path"
            return 'You can use -Force to overwrite it,or move the existing file first'
        }
    }
    else
    {
        # Write-Host $path 'does not exist!'
    }
    # Write-Host -BackgroundColor Green $TargetPath

    # 设置对象
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.createShortcut($Path)
    $Shortcut.TargetPath = $TargetPath
    $Shortcut.Hotkey = $HotKey
    $Shortcut.Description = $Description

    #如果语句是 $Shortcut.TargetPath = 'string example',则会被拼接为"$env:userprofile/desktop/string example";这是api决定的
    # 事实上,快捷方式是针对计算机上的某个位置(资源)的快捷访问方式,而不是对于一个字符串做访问,因此targetPath参数不要设置为非路径或者软件名的字符串,否则会出现意外的效果,而且本身也没有意义,例如将数字123设置为一个快捷方式的目标路径,通常是没有意义的,除非您的桌面上恰好有一个文件或目录名为123
    $Shortcut.Arguments = $Arguments

    if ($WindowStyle )
    {

        $windowStyleCode = switch ($WindowStyle)
        {
            'Maximized' { 3 }
            'Minimized' { 7 }
            Default { 1 }
        }
        Write-Verbose "WindowStyle: $windowStyleCode"
        $Shortcut.WindowStyle = $windowStyleCode
    }
    # 以下属性如果默认置空容易报错,这里将他们放到分支中,当参数不为空时才设置
    if ($WorkingDirectory -ne '')
    {
        $Shortcut.WorkingDirectory = $WorkingDirectory
    }
    if ($IconLocation)
    {
        
        $Shortcut.IconLocation = $IconLocation
    }
    $Shortcut.Save()

    # Release the COM object when done
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
    Remove-Variable WshShell

    Write-Host ''
    Write-Host 'Check action result:' -ForegroundColor Blue
    # debug
    Get-ShortcutLinkInfo $Path
}
```

#### 其他函数

- 详见上述列出的仓库,修改快捷方式使用GUI方式可以更直观

### 经典用例

#### 桌面上创建上帝模式👺

对上述函数的一个应用

```powershell
# 创建上帝模式的快捷方式
$GodModeFolderGUID = 'ED7BA470-8E54-465E-825C-99712043E01C'
$GodModePath = "shell:::{$GodModeFolderGUID}"
new-shortcut -path "$home\desktop\GodMode.lnk" -TargetPath 'explorer.exe' -Arguments $GodModePath -Force -TargetPathAsAppName
```





## 综合案例

### 桌面创建重启资源管理器的桌面快捷方式

#### 传统方法创建

下面是利用powershell 重启资源管理器的桌面快捷方式

在桌面上新建一个快捷方式,在输入对象位置的一栏中输入以下内容

```powershell
powershell -noe -c " & {kill -name explorer;explorer;get-date}"
```

一直下一步点击确定,桌面上出现一个powershell图标,双击它会重启资源管理器

如果需要设置快捷键唤醒,可以右键这个快捷方式,然后分配一个组快捷键给它

#### 命令行方法创建

只需要一行命令行

```powershell
new-shortcut -Path $home\Desktop\RE -TargetPath powershell.exe -Arguments '-noe -c  & {kill -name explorer;explorer;get-date}' -Force -HotKey 'ctrl+alt+F5'
```

以下是创建过程中输出的结果

```powershell

PS🌙[BAT:78%][MEM:34.1% (10.81/31.71)GB][19:23:29]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.154>][C:\repos\scripts]{Git:main}
PS> new-shortcut -Path $home\Desktop\RE -TargetPath powershell.exe -Arguments '-noe -c  & {kill -name explorer;explorer;get-date}' -Force -HotKey 'ctrl+alt+F5'
TargetPath is not a available path: powershell.exe;You can try the option -TargetPathAsAppName to run it
Try with Option  -TargetPathAsAppName?[y/n](default y to continue):
Try Consider the targetPath as a callable name: @{Source=C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe}
        The shortcut file name must has a suffix of .lnk or .url
[C:\Users\cxxu\Desktop\RE.lnk] will be used

Check action result:

FullName         : C:\Users\cxxu\Desktop\RE.lnk
Arguments        : -noe -c  & {kill -name explorer;explorer;get-date}
Description      : 09/22/2024 19:25:33
Hotkey           : Alt+Ctrl+F5
IconLocation     : ,0
RelativePath     :
TargetPath       : C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe
WindowStyle      : 1
WorkingDirectory :
```

- 这样就会在桌面上生成一个双击后可以重启资源管理器的快捷方式,并且分配了一组快捷键,当你在任意场景下按下`Ctrl+alt+F5`,就会触发重启资源管理器的快捷方式(但是如果当前运行的某款软件占用了这组热键,那么快捷键启动会失效,至少有一方会失效)

## 文件或脚本打开方式指定问题👺

- powershell脚本文件的后缀是`.ps1`,但是windows系统对于powershell脚本文件默认是不会直接执行的,甚至不会对`.ps1`后缀的文件应该调用自带的windows powershell运行(可能会调用记事本打开)
- 用户安装新版powershell(pwsh)后,图标可能会变成powershell7的图标(如果是便携版powrshell,需要其他设置,比如利用`assoc,ftype`等cmd命令来设置打开方式,另见它文)
- 而使用快捷方式局面将变得不一样,因为快捷方式可以**指定要启动或打开的软件**以及**启动参数**,因此可解决掉打开方式的问题
- 因此,这对于开机自启目录中放置一个开机自动运行的脚本(`.ps1`)的做法不够稳定,可以放置一个启动脚本的快捷方式来代替

## FAQ

### 快捷方式的常见问题

1. **快捷方式失效**：如果目标对象被删除或移动，快捷方式会失效。此时打开快捷方式可能会提示“目标无效”。
2. **快捷方式循环**：避免两个快捷方式相互指向对方形成循环引用，这会导致无法打开。
