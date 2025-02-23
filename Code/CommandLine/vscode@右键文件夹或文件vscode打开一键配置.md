[toc]



## abstract

- 有两大类方法:用vscode安装包重新安装,在双击安装包后勾选上相关选项(添加右键vscode打开菜单)
- 另一类是你不想重新安装,现在也可以很方便的一键配置(还可以完成一定的自定义设置,比如菜单名称)

## 一键脚本

打开powershell(系统自带的也可以)运行下面的一个方案即可

### 在线下载代码并运行

执行下面的语句,并回车执行

```powershell
irm https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Tools/Tools.psm1|iex

Set-OpenWithVscode

```

### 说明

可以指定参数(如果执行效果不达预期,可以查看命令行内置文档)

```powershell
help Set-OpenWithVscode
```

例如

```powershell
PS> help Set-OpenWithVscode

NAME
    Set-OpenWithVscode

SYNOPSIS
    设置 VSCode 打开方式为默认打开方式。


SYNTAX
    Set-OpenWithVscode [-Path <Object>] [-MenuName <Object>] [<CommonParameters>]

    Set-OpenWithVscode [-Remove] [<CommonParameters>]


DESCRIPTION
    直接使用powershell的命令不是很方便
    这里通过创建一个临时的reg文件,然后调用reg import命令导入
    支持添加右键菜单open with vscode
    也支持移除open with vscode 菜单
    你可以根据喜好设置标题,比如open with Vscode 或者其他,open with code之类的名字
....
```

完整内容请自行执行查看命令

### 运行示例

```powershell
PS C:\Users\Administrator\Desktop> irm https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Tools/Tools.psm1|iex
PS C:\Users\Administrator\Desktop>
PS C:\Users\Administrator\Desktop> Set-OpenWithVscode
详细信息: Set [C:\Program Files\Microsoft VS Code\Code.exe] as Vscode Path(default installation path)
Creating registry entries for VSCode:
    Windows Registry Editor Version 5.00

       [HKEY_CLASSES_ROOT\*\shell\VSCode]
       @="Open with VsCode"
       "Icon"="C:\\Program Files\\Microsoft VS Code\\Code.exe"

       [HKEY_CLASSES_ROOT\*\shell\VSCode\command]
       @="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\" \"%1\""

       Windows Registry Editor Version 5.00

       [HKEY_CLASSES_ROOT\Directory\shell\VSCode]
       @="Open with VsCode"
       "Icon"="C:\\Program Files\\Microsoft VS Code\\Code.exe"

       [HKEY_CLASSES_ROOT\Directory\shell\VSCode\command]
       @="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\" \"%V\""

       Windows Registry Editor Version 5.00

       [HKEY_CLASSES_ROOT\Directory\Background\shell\VSCode]
       @="Open with VsCode"
       "Icon"="C:\\Program Files\\Microsoft VS Code\\Code.exe"

       [HKEY_CLASSES_ROOT\Directory\Background\shell\VSCode\command]
       @="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\" \"%V\""
操作成功完成。
Registry entries for VSCode have been successfully created.
Completed.Refresh Explorer to see changes.
```



### 备用源码

如果在线版本无法执行,可以将以下内容拷贝粘贴到powershell中

```powershell
function Set-OpenWithVscode
{
    <# 
    .SYNOPSIS
    设置 VSCode 打开方式为默认打开方式。
    .DESCRIPTION
    直接使用powershell的命令不是很方便
    这里通过创建一个临时的reg文件,然后调用reg import命令导入
    支持添加右键菜单open with vscode 
    也支持移除open with vscode 菜单
    你可以根据喜好设置标题,比如open with Vscode 或者其他,open with code之类的名字
    .EXAMPLE
    简单默认参数配置
    Set-OpenWithVscode
    
    .EXAMPLE
    完整的参数配置
    Set-OpenWithVscode -Path "C:\Program Files\Microsoft VS Code\Code.exe" -MenuName "Open with VsCode"
    .EXAMPLE
    移除右键vscode菜单
    PS> Set-OpenWithVscode -Remove
    #>
    <# 
    .NOTES
    也可以按照如下格式创建vscode.reg文件，然后导入注册表

    Windows Registry Editor Version 5.00

    [HKEY_CLASSES_ROOT\*\shell\VSCode]
    @=$MenuName
    "Icon"="C:\\Program Files\\Microsoft VS Code\\Code.exe"

    [HKEY_CLASSES_ROOT\*\shell\VSCode\command]
    @="$PathWrapped \"%1\""

    Windows Registry Editor Version 5.00

    [HKEY_CLASSES_ROOT\Directory\shell\VSCode]
    @=$MenuName
    "Icon"="C:\\Program Files\\Microsoft VS Code\\Code.exe"

    [HKEY_CLASSES_ROOT\Directory\shell\VSCode\command]
    @="$PathWrapped \"%V\""

    Windows Registry Editor Version 5.00

    [HKEY_CLASSES_ROOT\Directory\Background\shell\VSCode]
    @=$MenuName
    "Icon"="C:\\Program Files\\Microsoft VS Code\\Code.exe"

    [HKEY_CLASSES_ROOT\Directory\Background\shell\VSCode\command]
    @="$PathWrapped \"%V\""

    #>

    [CmdletBinding(DefaultParameterSetName = "Add")]
    param (
        [parameter(ParameterSetName = "Add")]
        $Path = "C:\Program Files\Microsoft VS Code\Code.exe",
        [parameter(ParameterSetName = "Add")]
        $MenuName = "Open with VsCode",
        [parameter(ParameterSetName = "Remove")]
        [switch]$Remove
    )
    Write-Verbose "Set [$Path] as Vscode Path(default installation path)" -Verbose
    # 定义 VSCode 安装路径
    #debug
    # $Path = "C:\Program Files\Microsoft VS Code\Code.exe"
    $PathForWindows = ($Path -replace '\\', "\\")
    $PathWrapped = '\"' + $PathForWindows + '\"' # 由于reg添加右键打开的规范,需要得到形如此的串 \"C:\\Program Files\\Microsoft VS Code\\Code.exe\"
    $MenuName = '"' + $MenuName + '"' # 去除空格

    # 将注册表内容作为多行字符串保存
    $AddMenuRegContent = @"
    Windows Registry Editor Version 5.00
   
       [HKEY_CLASSES_ROOT\*\shell\VSCode]
       @=$MenuName
       "Icon"="$PathForWindows" 
   
       [HKEY_CLASSES_ROOT\*\shell\VSCode\command]
       @="$PathWrapped \"%1\""
   
       Windows Registry Editor Version 5.00
   
       [HKEY_CLASSES_ROOT\Directory\shell\VSCode]
       @=$MenuName
       "Icon"="$PathForWindows" 
   
       [HKEY_CLASSES_ROOT\Directory\shell\VSCode\command]
       @="$PathWrapped \"%V\""
   
       Windows Registry Editor Version 5.00
   
       [HKEY_CLASSES_ROOT\Directory\Background\shell\VSCode]
       @=$MenuName
       "Icon"="$PathForWindows" 
   
       [HKEY_CLASSES_ROOT\Directory\Background\shell\VSCode\command]
       @="$PathWrapped \"%V\""
"@  
    $RemoveMenuRegContent = @"
    Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\*\shell\VSCode]

[-HKEY_CLASSES_ROOT\*\shell\VSCode\command]

[-HKEY_CLASSES_ROOT\Directory\shell\VSCode]

[-HKEY_CLASSES_ROOT\Directory\shell\VSCode\command]

[-HKEY_CLASSES_ROOT\Directory\Background\shell\VSCode]

[-HKEY_CLASSES_ROOT\Directory\Background\shell\VSCode\command]
"@
    $regContent = $AddMenuRegContent
    # if ($Remove)
    if ($PSCmdlet.ParameterSetName -eq "Remove")
    {
        # 执行 reg delete 命令删除注册表文件
        Write-Verbose "Removing VSCode context menu entries..."
        $regContent = $RemoveMenuRegContent

    }
    # 检查 VSCode 是否安装在指定路径
    elseif (Test-Path $Path)
    {
          
        Write-Verbose "The specified VSCode path exists. Proceeding with registry creation."
    }
    else
    {
        Write-Host "The specified VSCode path does not exist. Please check the path."
        Write-Host "use -Path to specify the path of VSCode installation."
    }

    Write-Host "Creating registry entries for VSCode:"
    
    
    # 创建临时 .reg 文件路径
    $tempRegFile = [System.IO.Path]::Combine($env:TEMP, "vs-code-context-menu.reg")
    # 将注册表内容写入临时 .reg 文件
    $regContent | Set-Content -Path $tempRegFile
    
    # Write-Host $AddMenuRegContent
    Get-Content $tempRegFile
    # 删除临时 .reg 文件
    # Remove-Item -Path $tempRegFile -Force

    # 执行 reg import 命令导入注册表文件
    try
    {
        reg import $tempRegFile
        Write-Host "Registry entries for VSCode have been successfully created."
    }
    catch
    {
        Write-Host "An error occurred while importing the registry file."
    }
    Write-Host "Completed.Refresh Explorer to see changes."
}
```

粘贴回车执行,然后执行

```powershell
Set-OpenWithVscode
```

同样可以完成设置