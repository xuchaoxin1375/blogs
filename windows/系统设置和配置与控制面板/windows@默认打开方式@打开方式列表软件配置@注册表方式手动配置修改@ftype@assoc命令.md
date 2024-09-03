[toc]

## abstract

[On Windows 10, is there a file I can modify to configure the default apps? ](https://superuser.com/questions/1748620/on-windows-10-is-there-a-file-i-can-modify-to-configure-the-default-apps)

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/4eaff1f9e3114fdfaf2569413aff9bcc.png)

## 相关命令行

[ftype | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/ftype)

### 案例:将powershell 7设置为ps1文件的默认打开方式

 Windows 系统中：要通过命令行将 `.ps1` 文件的默认打开方式设置为 PowerShell 7 (`pwsh`)，你可以使用 PowerShell 的 `ftype` 和 `assoc` 命令。



1. **打开命令提示符**（以管理员身份运行）。

2. **设置 .ps1 文件的文件类型关联**：
   
    ```cmd
    assoc .ps1=Microsoft.PowerShellScript.1
    ```
    
3. **设置 PowerShell 7 (pwsh) 为 .ps1 文件的默认打开方式**：
    ```cmd
    ftype Microsoft.PowerShellScript.1="C:\Program Files\PowerShell\7\pwsh.exe" "%1"
    ```

    这里假设 PowerShell 7 安装在 `C:\Program Files\PowerShell\7\` 目录下。如果安装在其他目录，请修改路径。

完整的步骤如下：

```cmd
assoc .ps1=Microsoft.PowerShellScript.1
ftype Microsoft.PowerShellScript.1="C:\Program Files\PowerShell\7\pwsh.exe" "%1"
```

这将使 .ps1 文件默认使用 PowerShell 7 (pwsh) 打开。

### 检查路径

确保 PowerShell 7 安装在预期的目录中。如果不确定其安装路径，可以通过以下命令在 PowerShell 7 中查找路径：

```powershell
Get-Command pwsh | Select-Object -ExpandProperty Source
```

这将返回 `pwsh.exe` 的完整路径，您可以根据此路径进行设置。

### 示例说明

假设您的 PowerShell 7 安装在 `D:\PowerShell\7\` 目录中，则命令应修改为：

```cmd
ftype Microsoft.PowerShellScript.1="D:\PowerShell\7\pwsh.exe" "%1"
```

这样设置后，双击 .ps1 文件时将使用 PowerShell 7 打开它们。

## 设置指定软件添加到打开方式程序列表

相关powershell函数:

以下函数指定使用powershell7添加到打开方式列表(候选),无论这个被想要被打开的文件是什么格式

```powershell
function Set-ProgramToOpenWithList
{
    <# 
    .SYNOPSIS
    Set the Program to the Open with Program list or the Program list popup when the user want to open a file with a strange file extension
    .NOTES
    The function is not to set the default apps to open a specific file 
    but this function will help the action which set the defualt app to open the files with a specific extension more convenient
    #>
    param (
        $ProgramName= 'pwsh.exe' #不需要指定完整路径:例如'C:\Program Files\powershell\7\pwsh'
    )
    
    $regPath = "Registry::\HKEY_CLASSES_ROOT\Applications\$ProgramName\shell\open\command "
    write-host $regPath 
    New-Item $regPath -Value '$ProgramName'+" %1" -Force
}
```



## 设置某个文件类型的默认打开方式

用管理员权限打开一个cmd命令行窗口(powershell不支持直接运行属于`cmd`中的`ftype`命令)

- [assoc | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/assoc)
- [ftype | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/ftype)

如果不想从当前的powershell环境跳转到cmd,则可以利用`cmd /c`在powershell中执行`ftype`

```cmd
assoc [<.[ext]>[=[<filetype>]]]
ftype [<filetype>[=[<opencommandstring>]]]
```



```powershell

$pwsh7_home="C:\Program Files\powershell\7"
cmd /c 'ftype Microsoft.PowerShellScript.1="$pwsh7_home\pwsh.exe" "%1"'
```



###  cmd下的`ftype` 和 `assoc` 命令

在 Windows 中注册文件扩展名与可执行程序的关联相关命令`ftype`,`assoc`命令(这两个命令必须在cmd下运行,或者使用`cmd /c`这种方式运行,powershell目前没有对应于此功能的cmdlet)

为了提高兼容性,建议使用`cmd /c assoc `和`cmd /c ftype`来分别代替`assoc`,`ftype`,使得powershell中也可以执行相应命令而不需要单独创建并切换到cmd进程;

在 Windows 操作系统中，我们常常需要将特定类型的文件与特定的应用程序关联。

例如，当你双击一个 `.txt` 文件时，通常会使用默认的文本编辑器（如记事本）打开它。这个**文件类型**与**程序**之间的**关联**是通过系统的**文件类型机制**实现的。

#### 1. `assoc` 命令

`assoc` 命令用于显示或更改文件扩展名与文件类型之间的**关联**。

##### 显示当前所有文件扩展名的关联

运行以下命令，可以列出当前系统中所有文件扩展名与文件类型的关联：

```cmd
assoc
```

##### 查看特定扩展名的关联

如果你只想查看某个特定文件扩展名（例如 `.txt`）的关联，可以使用：

```cmd
assoc .txt
```

系统会返回类似 `TXTFILE` 这样的文件类型。

```powershell
PS> cmd /c assoc .txt
.txt=txtfilelegacy
```



##### 在powershell中执行assoc和后续操作

利用`cmd /c`来执行,并且获取其输出,再用`powershell`的`sls`命令行来过滤我们感兴趣的项目

```powershell
PS> cmd /c assoc|sls '.mp3|.wav|.mp4'

.LMP4=PotPlayerMini64.LMP4
.m4v=WMP11.AssocFile.MP4
.mp2=WMP11.AssocFile.MP3
.mp3=WMP11.AssocFile.MP3
.mp4=WMP11.AssocFile.MP4
.mp4v=WMP11.AssocFile.MP4
.wav=WMP11.AssocFile.WAV
```



##### 更改或创建文件扩展名的关联

如果你想将一个新的文件扩展名（例如 `.mytxt`）与一个文件类型（例如 `MYTXTFILE`）关联，可以使用：

```cmd
assoc .mytxt=MYTXTFILE
```

此命令将扩展名 `.mytxt` 关联到文件类型 `MYTXTFILE`。两个部分都可以全新的名字

#### 2. `ftype` 命令

`ftype` 命令用于显示或更改文件类型与可执行程序之间的关联。

##### 显示当前所有文件类型的关联

使用以下命令可以列出所有文件类型与可执行程序的关联：

```cmd
ftype
```

##### 查看特定文件类型的关联

要查看特定文件类型（例如 `TXTFILE`）的关联程序，可以运行：

```cmd
ftype TXTFILE
```

系统将显示类似于 `TXTFILE=%SystemRoot%\system32\NOTEPAD.EXE %1` 的结果，这表示文件类型 `TXTFILE` 默认使用记事本（Notepad）打开。

##### 更改或创建文件类型的关联

如果你想将 `MYTXTFILE` 类型的文件设置为使用自定义程序（例如 `C:\Program Files\MyEditor\myeditor.exe`）打开，可以使用：

```cmd
ftype MYTXTFILE="C:\Program Files\MyEditor\myeditor.exe" "%1"
```

注意：`"%1"` 是一个占位符，表示文件的路径。它是必需的，以确保程序能够正确打开文件。

#### 3. 将 `assoc` 与 `ftype` 结合使用

通常情况下，你需要结合使用 `assoc` 和 `ftype` 来设置文件关联。例如，如果你想将自定义的 `.mytxt` 文件用你的编辑器打开，你需要执行以下步骤：

1. 使用 `assoc` 将 `.mytxt` 扩展名与 `MYTXTFILE` 文件类型关联：
   ```cmd
   assoc .mytxt=MYTXTFILE
   ```

2. 使用 `ftype` 将 `MYTXTFILE` 文件类型与你的编辑器程序关联：
   ```cmd
   ftype MYTXTFILE="C:\Program Files\MyEditor\myeditor.exe" "%1"
   ```

#### 4. PowerShell 的替代方案

PowerShell 本身没有直接的命令来设置文件关联，但是你可以使用 PowerShell 调用 CMD 命令来完成相同的任务：

```powershell
cmd /c assoc .mytxt=MYTXTFILE
cmd /c ftype MYTXTFILE="C:\Program Files\MyEditor\myeditor.exe" "%1"
```

此外，PowerShell 提供了 `New-ItemProperty` 和 `Set-ItemProperty` cmdlet 可以通过操作注册表来实现文件关联，但这需要更深入的 Windows 注册表知识。

#### 总结

使用 `assoc` 和 `ftype` 命令，您可以轻松地在 Windows 操作系统中管理文件类型与程序之间的关联。这对于需要自定义文件类型行为的高级用户和系统管理员特别有用。尽管 PowerShell 没有直接的等效命令，通过使用 PowerShell 调用 CMD 命令或操作注册表，我们仍然可以实现类似的功能。

希望这篇文章能帮助你更好地理解和使用 Windows 的文件类型关联功能！

---

通过以上步骤，您可以灵活地设置和更改 Windows 文件类型的关联，从而更好地控制文件的打开方式。
