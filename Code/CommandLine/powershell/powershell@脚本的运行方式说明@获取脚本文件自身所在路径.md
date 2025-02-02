[toc]

## refs

- [about_Scripts - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.5)
- [How to Get the Current Location of the PowerShell Script | Delft Stack](https://www.delftstack.com/howto/powershell/get-the-current-location-of-the-powershell-script/#:~:text=A simple remedy to fix the issue is,when testing in the PowerShell ISE. Split-Path %24psISE.CurrentFile.FullPath)

## powershell脚本文件的运行方式

主要有两类运行方式,一种是预先启动一个powershell窗口,然后在窗口内运行,另一类是通过鼠标点击运行

### 通过 PowerShell 控制台运行

你可以直接在 PowerShell 控制台中输入脚本的内容或者运行脚本文件。

- 打开 PowerShell 控制台（可以在搜索框输入“PowerShell”找到并打开）。

- 如果要执行脚本文件（如 script.ps1），直接在命令行中输入路径：

  ```powershell
  C:\path\to\your\script.ps1
  ```

- 如果脚本路径在环境变量中，也可以直接用脚本名运行。

### 通过右键点击运行

在文件资源管理器中，**右键**点击 `.ps1` 脚本文件，选择“使用 PowerShell 运行”。



这种方法简单直接，适合用户不熟悉命令行时使用。

从 Windows PowerShell 3.0 开始，可以使用“使用 PowerShell 运行”功能从文件资源管理器运行脚本。 使用 **PowerShell** 的运行功能旨在运行没有所需参数的脚本，不要将输出返回到控制台，也不会提示用户输入。 将“运行与 PowerShell**”功能配合使用**时，仅短暂显示 PowerShell 控制台窗口（如果根本不显示）。

若要使用“使用 PowerShell 运行”功能，请执行以下操作：

在文件资源管理器（或 Windows 资源管理器）中，右键单击脚本文件名，然后选择“使用 PowerShell 运行”。

“使用 PowerShell 运行”功能会启动一个 Windows PowerShell 会话（该会话的执行策略为“绕过”），运行脚本，然后关闭会话。

它运行一个格式如下所示的命令：

```
pwsh.exe -File <FileName> -ExecutionPolicy Bypass
```

“使用 PowerShell 运行”仅为运行脚本的会话（PowerShell 进程的当前实例）设置“绕过”执行策略。 此功能不会更改计算机或用户的执行策略。

### 免配置直接运行运行powershell脚本|将powershell脚本用cmd批处理脚本打包

windows系统中,powershell脚本默认不能被直接双击执行

而由于历史原因,批处理(cmd/bat)文件可以被双击运行

我们可以为powershell脚本(.ps1)文件的运行命令写入到某个cmd脚本文件中,来触发powershell脚本的运行

### 案例

#### 下载并运行远程powershell脚本或命令

多功能重启powershell脚本的包装成cmd的批处理脚本

```powershell
$p="$home\desktop\rebootToOS.bat" #可以根据需要修该保存目录(或者默认保存到桌面后,再移动到你想要的地方)
@"
powershell -noprofile -nologo -c "Invoke-RestMethod https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Tools/Tools.psm1 | Invoke-Expression ;rebootToOS "
pause

"@ > $p
. $p

```

#### 运行本地powershell脚本或命令



```cmd
set p="c:\Users\cxxu\Desktop\t.ps1"  ::设置你要运行的powershell脚本(ps1)文件的路径
powershell -executionpolicy bypass -File %p% ::调用powershell 运行powershell脚本文件(临时设置执行策略为bypass,仅当前回话有效,尽量维持不修改系统当前的安全性设置)

```

例如,我的例子里面`t.ps1`包含了一个powershell函数`Start-httpServer`的定义和调用语句,现在通过上述的`cmd`脚本(比如保存为`t.bat`,双击运行)

```cmd
C:\Users\cxxu\Desktop>set p="c:\Users\cxxu\Desktop\t.ps1"

C:\Users\cxxu\Desktop>powershell -executionpolicy bypass -noprofile -File "c:\Users\cxxu\Desktop\t.ps1"
HTTP服务器已启动:
根目录: C:\ProgramData\scoop\apps\powershell\current
地址: http://localhost:8080/
按 Ctrl+C 停止服务器
```



## 查看脚本代码所在文件的路径

- ```powershell
  
  #方法1
  # $path_relative = Split-Path -Parent $($global:MyInvocation.MyCommand.Definition)
  #方法2
  #$path_relative = $PSScriptRoot
  
  #解析绝对路径
  Resolve-Path $path_relative
  
  ```

  
  
  