[toc]

## abstract

- 命令行执行创建快捷/修改快捷方式等操作

- [file - Editing shortcut (.lnk) properties with Powershell - Stack Overflow](https://stackoverflow.com/questions/484560/editing-shortcut-lnk-properties-with-powershell)

## 相关实现

### 查看和创建快捷方式

```powershell

function Get-ShortcutLinkInfo
{
    <# 
    
    获取已经存在的快捷方式lnk文件的信息
    
    #>
    param(
        $Path
    )
    $shell = New-Object -ComObject WScript.Shell
    if (Test-Path $Path)
    {
        $Path = Resolve-Path $Path #获取绝对路径(使用相对路径的话可能会受到当前路径或环境的影响)
    }
    elseif ($Path -match '\./*')
    {
        
        $Path = (Join-Path -Path (Get-Location).Path -ChildPath $Path)
    }
    $shortcut = $shell.createShortcut($Path)
    return $shortcut
}

```

