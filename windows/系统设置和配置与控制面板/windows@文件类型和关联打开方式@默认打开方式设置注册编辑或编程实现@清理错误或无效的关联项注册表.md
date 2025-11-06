\[toc\]

## abstract

在 Windows 系统中，**更改某个文件类型（如 .md）默认打开方式**，可以通过**修改注册表** (Registry) 或使用 PowerShell / 命令行脚本来实现。

### 相关文档

- [HKEY_CLASSES_ROOT Key - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/sysinfo/hkey-classes-root-key)

- [Windows registry for advanced users - Windows Server | Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-server/performance/windows-registry-advanced-users)

### HKEY_CLASSES_ROOT注册表

**HKEY_CLASSES_ROOT** (**HKCR**) 键包含**文件扩展名关联**和 **COM 类**注册信息，例如 **ProgID、CLSID 和 IID**。

它主要是为了与 16 位 Windows 中的注册表兼容。

**类注册和文件扩展名信息**存储在 **HKEY_LOCAL_MACHINE** 和 **HKEY_CURRENT_USER** 键下。

> HKEY_LOCAL_MACHINE\\Software\\Classes 项包含可应用于本地计算机上所有用户的默认设置。 HKEY_CURRENT_USER\\Software\\Classes 项包含仅适用于交互式用户的设置。
>
> HKEY_CLASSES_ROOT 键提供了一个注册表视图，该视图合并了这两个源的信息。 HKEY_CLASSES_ROOT 还为为以前版本的 Windows 设计的应用程序提供此合并视图。

用户特定设置的优先级高于默认设置。

> 例如，默认设置可能指定特定应用程序来处理 .doc 文件。但用户可以通过在注册表中指定不同的应用程序来覆盖此设置。

RegOpenKeyEx 或 RegQueryValueEx 等**注册表函数**允许您指定 HKEY_CLASSES_ROOT 键。

当您从在交互式用户帐户中运行的进程调用这些函数时，系统会将 HKEY_LOCAL_MACHINE\\Software\\Classes 中的默认设置与 HKEY_CURRENT_USER\\Software\\Classes 中的交互式用户**设置合并**。有关如何合并这些设置的详细信息，请参阅 HKEY_CLASSES_ROOT 的合并视图。

> Registry functions such as [**RegOpenKeyEx**](https://learn.microsoft.com/en-us/windows/desktop/api/Winreg/nf-winreg-regopenkeyexa) or [**RegQueryValueEx**](https://learn.microsoft.com/en-us/windows/desktop/api/Winreg/nf-winreg-regqueryvalueexa) allow you to specify the **HKEY_CLASSES_ROOT** key. When you call these functions from a process running in the interactive user account, the system merges the default settings in **HKEY_LOCAL_MACHINE\\Software\\Classes** with the interactive user's settings at **HKEY_CURRENT_USER\\Software\\Classes**. For more information on how these settings are merged, see [Merged View of HKEY_CLASSES_ROOT](https://learn.microsoft.com/en-us/windows/win32/sysinfo/merged-view-of-hkey-classes-root).

要更改交互式用户(理解为当前使用计算机的用户)的设置，请将更改存储在 `HKEY_CURRENT_USER\Software\Classes` 下，而不是 HKEY_CLASSES_ROOT 下。

> 根据上述规则,`HKEY_CURRENT_USER\Software\Classes`下的项会覆盖系统默认级`HKEY_LOCAL_MACHINE`对应的项,而`HKEY_CLASSES_ROOT `大致是`HKEY_LOCAL_MACHINE\Software\Classes`的别名
>
> 修改`HKEY_CURRENT_USER\Software\Classes`下的项比较保险

要更改**默认设置**，请将更改存储在 HKEY_LOCAL_MACHINE\\Software\\Classes 下。

- 如果将键写入 HKEY_CLASSES_ROOT 下的键，系统会将信息存储在 HKEY_LOCAL_MACHINE\\Software\\Classes 下。

- 如果将值写入 HKEY_CLASSES_ROOT 下的某个键(子项)，并且该键已存在于 HKEY_CURRENT_USER\\Software\\Classes 下，则系统会将信息存储在此处(HKEY_CURRENT_USER\\Software\\Classes)，而不是存储在 HKEY_LOCAL_MACHINE\\Software\\Classes 下。

> 如此看来,修改默认设置如果改动`HKEY_CURRENT_USER\Software\Classes`是不可靠的

在交互用户以外的安全上下文中运行的进程不应将 HKEY_CLASSES_ROOT 项与注册表函数一起使用。相反，此类进程可以显式打开 HKEY_LOCAL_MACHINE\\Software\\Classes 项来访问默认设置。

> 要打开将 HKEY_LOCAL_MACHINE\\Software\\Classes 的内容与指定用户的设置合并的注册表项，这些进程可以调用 RegOpenUserClassesRoot 函数。例如，如果模拟客户端的线程需要检索被模拟客户端的合并视图，则可以调用 RegOpenUserClassesRoot。请注意，如果尚未加载指定用户的用户配置文件，则 RegOpenUserClassesRoot 将失败。
>
> 系统在登录时自动加载交互式用户的配置文件。对于其他用户，您需要调用LoadUserProfile函数显式加载用户的配置文件。

如果应用程序以管理员权限运行并且禁用了用户帐户控制，则 COM 运行时将忽略每用户 COM 配置并仅访问每计算机 COM 配置。需要管理员权限的应用程序应在安装过程中将相关 COM 对象注册到每台计算机的 COM 配置存储 (HKEY_LOCAL_MACHINE\\Software\\Classes)。有关详细信息，请参阅 AC：UAC：COM 每用户配置。

Windows Server 2003 和 Windows XP/2000：应用程序可以将相关 COM 对象注册到每台计算机或每用户 COM 配置存储（HKEY_LOCAL_MACHINE\\Software\\Classes 或 HKEY_CURRENT_USER\\Software\\Classes）。

### HKEY_CLASSES_ROOT数据类型

HKEY_CLASSES_ROOT 子树包含两种类型的数据：

1. 将文件类型与程序关联起来的数据。 HKEY_CLASSES_ROOT 中的文件类型子项与文件类型的文件扩展名具有相同的名称，例如 .exe。文件类型关联存储在注册表中，但您应该使用 Windows 资源管理器来更改它们。在 Windows 资源管理器中，从“工具”菜单中，单击“文件夹选项”，然后单击“文件类型”选项卡。

2. COM 对象、Visual Basic 程序或其他自动化的配置数据。配置子项使用程序 ID（例如 COM、Visual Basic、自动化和脚本）或其他信息类（例如 CLSID、Interface、TypeLib、AppId 等）的父项。

HKEY_CLASSES_ROOT 的内容有两个来源：

- HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes 和

- HKEY_CURRENT_USER\\SOFTWARE\\Classes。

如果子项或条目出现在任一位置，那么它也会出现在 HKEY_CLASSES_ROOT 中。**如果两个 Classes 子项中的条目值发生冲突，则只有 HKEY_CURRENT_USER\\SOFTWARE\\Classes 中的值出现在 HKEY_CLASSES_ROOT 中**。

在 Windows NT 4.0 及更早版本中，HKEY_CLASSES_ROOT 仅显示 HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes 中的数据。

当前的合并配置允许系统独立地为每个用户注册程序类。此功能称为每用户类别注册。

按用户类别注册有几个好处：

- 多个用户可以自定义一台计算机。**例如，一个用户可以安装使用特定文件类型的应用程序，而另一个用户可以安装使用相同文件类型的不同应用程序，而不会影响第一个用户**。

- 漫游类注册。由于类注册存储在用户配置文件中，因此在加载配置文件后，类注册将通过应用程序管理扩展加载到每台计算机上。当用户登录到另一台计算机时，注册信息将随用户一起通过目录进行传输，并写入用户配置文件的本地部分。

  注意：漫游类别注册仅在使用 Intellimirror 软件管理时可用。

- 提高注册表安全性。以前，用户可以更改或删除 HKLM\\SOFTWARE\\Classes 中的注册表项，从而破坏应用程序或更改其行为。然而，由于现在将类信息写入用户配置文件，**系统管理员可以限制对 HKLM\\SOFTWARE\\Classes 的访问**。

**笔记**

- 其中 **HKEY_CLASSES_ROOT 是 HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes 的别名**(这是一个大致的理解方式,但是也不完全一致,需要考虑以下更加细节的规则)。

  - 如果 HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes 和 HKEY_CURRENT_USER\\SOFTWARE\\Classes 中**都存在某个条目，则 HKEY_CURRENT_USER\\SOFTWARE\\Classes 中的条目值优先**。

  - 如果在 HKEY_CLASSES_ROOT 中**创建新项或子项**，那么它也会在 **HKEY_LOCAL_MACHINE**\\SOFTWARE\\Classes 中创建。如果您在同一项或子项中创建新条目，则该条目也将出现在 HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes 的该项或子项中。

  - 如果**在现有子项中创建新条目**，则该条目的**显示位置**取决于该子项是否已存在于 HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes 或 HKEY_CURRENT_USER\\SOFTWARE\\Classes 中：

    - 如果该子项同时存在于 HKEY_CURRENT_USER\\SOFTWARE\\Classes 和 HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes 中，则该条目将仅出现在 **HKEY_CURRENT_USER**\\SOFTWARE\\Classes 的该子项中。

    - 如果该子项仅存在于 HKEY_CURRENT_USER\\SOFTWARE\\Classes 中，则该条目将出现在 HKEY_CURRENT_USER\\SOFTWARE\\Classes 的该子项中。

    - 如果该子项仅存在于 HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes 中，则该条目将出现在 HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes 的该子项中。

------

### 备份注册表

[如何在 Windows 中备份和还原注册表 - Microsoft 支持](https://support.microsoft.com/zh-cn/topic/%E5%A6%82%E4%BD%95%E5%9C%A8-windows-%E4%B8%AD%E5%A4%87%E4%BB%BD%E5%92%8C%E8%BF%98%E5%8E%9F%E6%B3%A8%E5%86%8C%E8%A1%A8-855140ad-e318-2a13-2829-d428a2ab0692)

### 修改注册表

修改注册表的方案有许多,比较便于管理和批量操作的是`.reg`文件编辑和导入方案

- [How to add, modify, or delete registry subkeys and values by using a .reg file - Microsoft Support](https://support.microsoft.com/en-us/topic/how-to-add-modify-or-delete-registry-subkeys-and-values-by-using-a-reg-file-9c7f37cf-a5e9-e1cd-c4fa-2a26218a1a23)

- [如何使用 .reg 文件添加、修改或删除注册表子项和值 - Microsoft 支持](https://support.microsoft.com/zh-cn/topic/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8-reg-%E6%96%87%E4%BB%B6%E6%B7%BB%E5%8A%A0-%E4%BF%AE%E6%94%B9%E6%88%96%E5%88%A0%E9%99%A4%E6%B3%A8%E5%86%8C%E8%A1%A8%E5%AD%90%E9%A1%B9%E5%92%8C%E5%80%BC-9c7f37cf-a5e9-e1cd-c4fa-2a26218a1a23)

预览.reg模板/语法 A .reg file has the following syntax:(细节查看文档)

```ini


RegistryEditorVersion
Blank line
[RegistryPath1]

"DataItemName1"="DataType1:DataValue1"
"DataItemName2"="DataType2:DataValue2"
Blank line
[RegistryPath2]

"DataItemName3"="DataType3:DataValue3"
```

现代windows版本的更具体模板

```ini
Windows Registry Editor Version 5.00

[RegistryPath1]
"DataItemName1"="DataType1:DataValue1"
"DataItemName2"="DataType2:DataValue2"

[RegistryPath2]
"DataItemName3"="DataType3:DataValue3"
...
```

- 其中`[]`内的`RegistryPathx`替换为具体的注册表路径,保留`[]`,`[]`上面总是要求有空行

- `[RegistryPathx]`下面可以放空行,然后更上下一个`[RegistryPathy]`,这会表示不为`[RegistryPathx]`新建或修改或删除任何值,如果路径不存在,则创建路径

例如：

从regedit导出来的.reg文件的标准案例

```ini
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE]
"ServiceLastKnownStatus"=dword:00000002

[HKEY_LOCAL_MACHINE\BCD00000000]

[HKEY_LOCAL_MACHINE\BCD00000000\Description]
"KeyName"="BCD00000000"
"System"=dword:00000001
"GuidCache"=hex:8b,85,5b,76,86,57,db,01,00,27,00,00,13,b8,f9,28,d3,dc,c8,cd,cf,\
  00,00,00
"TreatAsSystem"=dword:00000001

[HKEY_LOCAL_MACHINE\BCD00000000\Objects]

[HKEY_LOCAL_MACHINE\BCD00000000\Objects\{0ce4991b-e6b3-4b16-b23c-5e0d9250e5d9}]

[HKEY_LOCAL_MACHINE\BCD00000000\Objects\{0ce4991b-e6b3-4b16-b23c-5e0d9250e5d9}\Description]
"Type"=dword:20100000
```

```ini
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\.md]
@="markdownfile"

[HKEY_CLASSES_ROOT\markdownfile\shell\open\command]
@="C:\Program Files\Typora\Typora.exe" "%1"
```

------

## 文件关联机制 (File Association)

Windows 通过注册表维护一套“**扩展名 → 文件类型 → 打开命令**”的映射，主要分为两级：

例如,`.md`文件通常是markdown文本文件的扩展名(也就是后缀,通常是某些个单词的缩写,追求简短),而**文件类型(名)相比于**扩展名字面意思**可读性更加友好**,通常是一个单词,甚至是一个短语,可以定义的长一些

> 部分读者可能认为直接走"扩展名"->"打开命令"这个映射更加简洁和直接,但是windows系统在其中添加了一个"文件类型(名)",这是为了可读性
>
> 文件类型名可以有应用程序(作者)定义,这样在资源管理器中显示(或者鼠标悬停在特定文件上时,会显示类型:xxx,例如a.xlsx文件,安装了wps程序后设置了文件关联,就会显示`xlsx工作表`,而不是xlsx文件,又比如安装了navicat程序后,右键.sql文件属性,提示"SQL 源文件 (.sql)")
>
> 此外,许多文件类型有不同后缀(比如markdown文件,后缀可能有`.md`,`.mkd`,`.mkdn`),可以将这些扩展都关联到同一个文件类型(比如`MarkdownFile`),这样设置`MarkdownFile`文件类型的打开方式后,就可以用指定程序打开这些不同扩展名的文件
>
> 而且后面更改默认打开程序也更加方便,而不是将这些同类但不同扩展名的打开方式全部更改一遍(不过事实上如果仅仅使用`ftype`命令修改可能无法直接生效)特别是便携版可执行程序被设置为默认打开方式后,可能会动到`HKEY_USERS`路径下的相关项,例如`HKEY_USERS\S-1-5-21-2010788592-737217637-528021739-500_Classes\markdownfile\shell\open\command`定义默认的`markdownfile`打开程序

又比如`.cpp`文件可以一般是"c++源代码文件",前者(.cpp)是文件的扩展名,后者(c++源代码文件)是文件类型

下面以`.md`(markdown)文件扩展名为例说明

|注册表路径|作用|
|-|-|
|`HKEY_CLASSES_ROOT`|**HKEY_CLASSES_ROOT** (**HKCR**) 键包含**文件扩展名关联**和 **COM 类**注册信息，例如 ProgID、CLSID 和 IID。|
|`HKEY_CLASSES_ROOT\.md`|指定扩展名对应的文件类型名（如 `markdownfile`）|
|`HKEY_CLASSES_ROOT\<文件类型名>\shell\open\command`|指定“打开”命令对应的可执行文件路径|

> 使用cmd 提供的`assoc`命令运行`assoc .md=MarkdownFile`可以得到如下结果中的(默认)

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][19:21:01] PS >
 reg query HKLM\Software\Classes\.md

HKEY_LOCAL_MACHINE\Software\Classes\.md
    (默认)    REG_SZ    MarkdownFile

HKEY_LOCAL_MACHINE\Software\Classes\.md\OpenWithProgids
```

### 使用 PowerShell 修改注册表

你可以用管理员权限运行以下 PowerShell 脚本

> 为当前用户(HKCU)设置`.mkd`扩展名的文件的打开方式

> \[!Note\]
>
> 设置默认打开方式比较复杂,涉及到的注册表操作比较多,下面的代码并不完善,cmd的assoc,ftype也不能直接设置默认打开方式,仅能将程序添加到右键的打开方式列表中
>
> 如果条件允许,通过系统的图形界面选择默认打开方式比较简单

```powershell
# 设置要使用的程序路径
# $programPath = "C:\Program Files\Typora\Typora.exe"
$programPath = "C:\exes\Typora\Typora.exe"
$extension = ".mkd"
$fileType = "markdownfile"

$p="HKCU:\Software\Classes\$extension"

# 将扩展名关联到 fileType
New-Item -Path $p -Force 
Set-ItemProperty -Path $p -Name "(default)" -Value $fileType
# 检查类型注册结果
Get-ItemProperty -Path $p
 
# 定义 fileType 的打开命令
$commandPath = "HKCU:\Software\Classes\$fileType\shell\open\command"
New-Item -Path $commandPath -Force
Set-ItemProperty -Path $commandPath -Name "(default)" -Value "`"$programPath`" `"%1`""

# 重启资源管理器通知系统刷新文件关联
```

说明：

- `HKCU:\Software\Classes` 是用户级别的注册表路径（不影响系统全局）。

- 如果想系统级生效，可改为 `HKLM:\Software\Classes`（需管理员权限）。

- `$programPath`变量取值换成你想设置的默认软件路径。

- 执行后 `.md` 文件双击将默认使用该程序打开。

------

### 注意事项

1. **系统保护机制 (Default Programs UI)** 从 Windows 10 起，微软引入了“用户确认默认应用”机制。某些类型（如浏览器、PDF、图片）需要用户交互确认。 `.md` 一般是普通文本类，不受限制，脚本能直接生效。

2. **刷新资源管理器** 若设置后双击仍未生效，可执行：

   ```powershell
   Stop-Process -Name explorer -Force
   Start-Process explorer
   ```

   或注销重登录。

3. **用户级 vs 系统级**

   - 用户级（`HKCU\Software\Classes`）只影响当前用户，安全且推荐。

   - 系统级（`HKLM\Software\Classes`）影响所有用户，需管理员权限。

## 清理无效的关联

如果注册表经过不恰当的修改,可能导致一些系统异常,比如优先打开方式中无效的选择,或者无法顺利更改到新的打开方式

这时候需要修复或者清理注册表,如果有备份的话,可以尝试导入备份

如果没有,可以尝试cclean这个专业的工具,使用其中的一个功能(tools->register)检查并修复注册表问题

------