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

如果不想从当前的powershell环境跳转到cmd,则可以利用`cmd /c`在powershell中执行`ftype`

```powershell

$pwsh7_home="C:\Program Files\powershell\7"
cmd /c 'ftype Microsoft.PowerShellScript.1="$pwsh7_home\pwsh.exe" "%1"'

```



而执行

```

```

