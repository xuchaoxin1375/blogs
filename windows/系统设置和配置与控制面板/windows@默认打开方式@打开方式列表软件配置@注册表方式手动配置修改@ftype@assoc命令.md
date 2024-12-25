[toc]

## abstract

- windows上设置指定文件格式用指定软件打开有两类方法
  - GUI设置
    - 从一个特定文件开始,右键选择打开方式,找到对应的程序后打开,一般可以设置为始终用此方式打开(可以是一次性,也可以是默认始终)
    - 从系统设置中根据后缀名批量设置,或者将一个程序设置为其支持打开的所有格式文件的默认打开程序(默认方式设置)
  - 命令行设置
    - 使用cmd中的`assoc,ftype`命令配置,适合脚本化和自动化部署配置(默认方式设置,或者添加到打开方式列表中)
    - 修改注册表(相对繁琐,也比较危险)

### 相关文档

- [在 Windows 中更改默认应用 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/在-windows-中更改默认应用-e5d82cad-17d1-c53b-3505-f10a32e1894d#:~:text=In the Settings app on your Windows device, select Apps)
- [Change default apps in Windows - Microsoft Support](https://support.microsoft.com/en-us/windows/change-default-apps-in-windows-e5d82cad-17d1-c53b-3505-f10a32e1894d#:~:text=In the Settings app on your Windows device, select Apps)

- 其他
  - [Changing Default File Associations in Windows 10 and 11 | Windows OS Hub (woshub.com)](https://woshub.com/managing-default-file-associations-in-windows-10/#:~:text=You can automatically assign a specific app with the file)
  - [默认程序 - Win32 apps | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/win32/shell/default-programs)
    - windows上很多软件都支持设定自己为某些软件的默认打开方式,尤其是解压缩软件最为典型
    - 这个文档介绍了相关的api

### 本文重点

如果你方便操作GUI,那么使用GUI方案是直观和简单的(注册表方式也是尽量不用)

如果你希望配置打开方式能够脚本化,那么可以考虑命令行方式配置

本文主要介绍如何通过windows提供的两个命令`assoc,ftype`来相对简单的完成文件类型和打开方式设置

脚本文件类型和格式的配置比较敏感,这部分不建议去动,其他格式可以参考着设置

### 修改注册表来配置默认打开软件

[On Windows 10, is there a file I can modify to configure the default apps? ](https://superuser.com/questions/1748620/on-windows-10-is-there-a-file-i-can-modify-to-configure-the-default-apps)

## 设置某个文件类型和打开方式

windows中,文件通常有扩展名(可以通过设置显示扩展名或者用命令行列出文件,可以看到文件扩展名)

而扩展名是为了表示一个文件的类型,以便系统知道用那个软件来打开它(如果你的电脑安装过支持该类型文件的软件并且注册了它能够支持的格式或类型)

格式和类型有关但是并不完全相同,例如音频类型的文件包含了`.mp3,.wav,.flac`等格式,而许多音乐软件同时支持多种不同格式的音乐类型文件

在windows中,`assoc`可以用来查看或指定扩展名被定义为哪一种文件类型,例如`.cmd`脚本文件被定义为`cmdfile`类型文件;而`ftype`可以查看或指定某个类型文件的打开方式(打开命令行),比如`cmdfile`

用管理员权限打开一个cmd命令行窗口(powershell不支持直接运行属于`cmd`中的`ftype`命令)

- [assoc | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/assoc)
- [ftype | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/ftype)

如果不想从当前的powershell环境跳转到cmd,则可以利用`cmd /c`在powershell中执行`ftype`

```cmd
assoc [<.[ext]>[=[<filetype>]]]
ftype [<filetype>[=[<opencommandstring>]]]
```

## 设置指定文件打开方式的案例👺

- 这里推荐一下windows下的软件安装器`scoop`,建议使用部署**国内加速过的版本**
- 通过scoop安装的软件,具有很一致的安装/卸载等操作的体验,并且安装速度十分快速(特别是被scoop收录的国内软件,比如qq,qqnt,微信(wechat)等软件,开发者工具类大多可以从scoop上直接下载)
- 下面演示的sublime-text,typora等软件都可以通过scoop安装,并且路径没有包含空格,非常适合在命令行中直接引用

### 将notepad--设置为文本文件打开方式

假设你将notepad--安装在`"C:\ProgramData\scoop\shims\notepad--.exe"`路径,那么利用guan'li'y执行以下命令设置

```cmd
#$p="C:\ProgramData\scoop\shims\notepad--.exe" #scoop 安装的,命令行直接启动,没有软件图标
$p="C:\ProgramData\scoop\apps\notepad--\current\Notepad--.exe"  #GUI软件路径,有图标
cmd /c assoc .txt=txtfile
cmd /c ftype txtfile=$p %1
```



### 将sublime-text设置为某个文件类型的打开方式

为例演示指定扩展名(格式)文件的打开方式,以sublime-text 打开`.demo`文件为例

**使用管理员权限运行**以下命令

#### 设置指定格式文件用指定方式打开

```powershell
cmd /c assoc .demo=demofile
cmd /c ftype demofile=C:\Users\cxxu\scoop\shims\subl.exe %1
```

这里我将`.demo`后缀的文件指定为`demofile`类型的文件

然后针对`demofile`类型的文件指定了打开软件(打开命令行)`C:\Users\cxxu\scoop\shims\subl.exe %1`

这样,当您的桌面上有后缀为.demo的文件,那么右键打开方式会提供`subl.exe`(也就是sublime-text的缩写)

#### 例:设置powershell脚本文件的打开方式

```powershell
#关联指定格式文件为文件类型
cmd /c assoc .ps1=Microsoft.PowerShellScript.1 #将.PS1格式的文件设置为标准的Microsoft.PowershellScript.1类型
#指定某个文件类型的打开方式(指定powershell文件有pwsh.exe来打开)
# $pwsh7_home="C:\Program Files\powershell\7" #powershell 7
$pwsh_home="C:\ProgramData\scoop\apps\powershell\current" #scoop 安装的最新版powershell
cmd /c ftype Microsoft.PowerShellScript.1="$pwsh_home\pwsh.exe" "%1"
```

### 将typora设置为Markdown打开方式👺

- 假设我将typora安装在以下目录(通过scoop安装)

  ```
  C:\ProgramData\scoop\apps\typora\current\Typora.exe
  ```

- ```powershell
  cmd /c assoc .md=MarkdownFile #这里的MarkdownFile是自定义的名字，也可以是别的名字,注意在ftype中使用同一个文件类型名字
  cmd /c ftype MarkdownFile=C:\ProgramData\scoop\apps\typora\current\Typora.exe %1 
  ```

- 设置完毕后,相关文件(.md)图标不一定有变化,但是右键打开方式应该能够找到typora选项

- 或者尝试重启资源管理器再检查(上述试验经过测试可以正确设置)

### FAQ

#### 脚本文件特殊情况

- 注意脚本文件比较特殊,例如powershell脚本文件,系统要求后缀必须是`.ps1`才能够被powershell或pwsh程序执行,而其他后缀的文件,即便用`assoc`指定为powershell脚本文件类型,也是无法被powershell执行的
- 类似的`cmd`文件,后缀必须是`.bat`或者`.cmd`才能正确被cmd执行,否则会造成错误,无法返回结果并且陷入死循环消耗资源或引起反病毒软件的反应

#### 设置完没有生效

- 例如我在桌面事先创建了`file.demo`文件,然后执行`assoc,ftype`设置后发现右键打开方式么有想要的方式

- 那么考虑**重启资源管理器**来刷新,然后重新观察配置是否生效

  - 重启资源管理器的代码如下(powershell下执行)

    ```powershell
    stop-process explorer;explorer
    #cmd下可以执行: powershell -c "spps -name explorer;explorer"
    ```
  
  - CMD执行以下内容来重启资源管理器(通用)
  
    ```cmd
    taskkill /f /im explorer.exe && start explorer.exe
    ```
  
    这个命令的作用如下：
    1. `taskkill /f /im explorer.exe` 强制结束 `explorer.exe` 进程。
    2. `&&` 确保前一个命令成功执行后再执行下一个命令。
    3. `start explorer.exe` 重新启动 `explorer.exe`。
  
    你只需将上述命令复制并粘贴到 CMD 中，然后按 Enter 键即可。

## 相关命令

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

PowerShell 本身没有直接的命令(诸如`assoc,ftype`来设置文件关联，但是你可以使用 PowerShell 调用 CMD 命令来完成相同的任务：(即使用`cmd /c`开头执行相关命令)

```powershell
cmd /c assoc .mytxt=MYTXTFILE
cmd /c ftype MYTXTFILE="C:\Program Files\MyEditor\myeditor.exe" "%1"
```

此外，PowerShell 提供了 `New-ItemProperty` 和 `Set-ItemProperty` cmdlet 可以通过操作注册表来实现文件关联，但这需要更深入的 Windows 注册表知识。

### 总结

使用 `assoc` 和 `ftype` 命令，您可以轻松地在 Windows 操作系统中管理文件类型与程序之间的关联.

## 补充:检查指定程序的路径

例如,确保 PowerShell 7 安装在预期的目录中。如果不确定其安装路径，可以通过以下命令在 PowerShell 7 中查找路径：

```powershell
Get-Command pwsh | Select-Object -ExpandProperty Source
```

这将返回 `pwsh.exe` 的完整路径，您可以根据此路径进行设置。

