[toc]

## abstract

[On Windows 10, is there a file I can modify to configure the default apps? ](https://superuser.com/questions/1748620/on-windows-10-is-there-a-file-i-can-modify-to-configure-the-default-apps)

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/4eaff1f9e3114fdfaf2569413aff9bcc.png)

### 相关命令行

[ftype | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/ftype)

### 设置指定软件添加到打开方式程序列表

相关powershell函数:

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
        $Program
    )
    
    $regPath = "Microsoft.PowerShell.Core\Registry::\HKEY_CLASSES_ROOT\Applications\$Program\shell\open\command "
    New-Item $regPath -Value '"C:\Program Files\powershell\7\pwsh.exe" "%1"' -Force
}
```

## 设置某个文件类型的默认打开方式

用管理员权限打开一个cmd命令行窗口(powershell不支持直接运行属于`cmd`中的`ftype`命令)

```cmd

C:\Users\cxxu# ftype Microsoft.PowerShellScript.1="C:\program files\powershell\7\pwsh.
exe" "%1"
Microsoft.PowerShellScript.1="C:\program files\powershell\7\pwsh.exe" "%1"
```

如果不想从当前的powershell环境跳转到cmd,则可以利用`cmd /c`在powershell中执行`ftype`

也就是说,不执行`cmd`

```
PS🌙[BAT:100%][MEM:43.45% (3.41/7.85)GB][0:01:21]
#⚡️[~]
PS> cmd
Microsoft Windows [版本 10.0.19045.4412]
(c) Microsoft Corporation。保留所有权利。
```

而执行

```

```

