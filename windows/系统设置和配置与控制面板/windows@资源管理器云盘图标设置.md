[toc]



## abstract

国内的云盘等软件比如百度网盘,夸克网盘,wps等默认在资源管理器中添加图标,这或许不是用户想要的

移除方法有多重,一类是在软件内部设置关闭掉资源管理器中添加图标,另一类是设置注册表

第一类的方法比较直观,不介绍,介绍第二类,并且提供了GUI设置方案和一键执行脚本的便捷方案

## 设置方案

相关注册表路径如下

```cmd
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
```

### 移除注册表(不推荐单独使用)

编写一个PowerShell命令来删除该注册表路径。以下是删除该路径的PowerShell命令:

```powershell
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace" -Recurse
```

这个命令的解释:

- `Remove-Item`: 这是PowerShell中用于删除项目的cmdlet。
- `-Path`: 指定要删除的路径。
- `HKCU:`: 这是`HKEY_CURRENT_USER`的PowerShell缩写。
- `-Recurse`: 这个参数确保删除指定的键及其所有子键和值。

请注意,执行此命令时要小心,因为它会删除指定路径下的所有内容。在执行之前,建议你先备份注册表或创建一个系统还原点。

另外,你可能需要以管理员权限运行PowerShell来执行这个命令,因为它涉及修改注册表。

但是这种方法**容易复发**,重启网盘后可能有出现图标,考虑设置注册表的访问权限

### 设置访问权限

#### GUI设置

打开软件:`regedit.exe`,粘贴上述注册表路径到软件的地址栏中回车跳转

禁止一般用户访问相应注册表,仅保留管理员或者system组对该注册表的访问

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/46d91a461fc34df1936cf20e1f2aa8c3.png)

设置完毕后普通用户检查是否仍然可以访问

```powershell
PS🌙[BAT:79%][MEM:36.15% (11.46/31.71)GB][9:53:58]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][~\Desktop]
PS> $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace"

PS🌙[BAT:79%][MEM:36.07% (11.44/31.71)GB][9:54:07]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][~\Desktop]
PS> ls $path
Get-ChildItem: Requested registry access is not allowed.
Get-ChildItem: Requested registry access is not allowed.
```

发现已经被拒绝访问.

使用管理员权限打开powershell访问

```powershell
PS> $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace"
PS> ls $path

    Hive: HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComp
uter\NameSpace

Name                           Property
----                           --------
{82ca84ef-374c-5058-ba56-bb3dd (default) : 夸克网盘
ca980c4}
```

发现可以访问了



#### powershell方案

- 本方案不够方便和直观,推荐用GUI方式设置)
-  如果你只想设置该注册表项的访问权限而不是删除它，我们可以使用PowerShell的`Set-Acl`命令来完成这个任务。
- 详细操作见下一节展开

## 利用powershell设置相应注册表(一键执行脚本)

- 一键执行的方案(管理员权限要求)
- 推荐采用保留管理员访问的方案

### 移除所有用户对指定注册表路径的访问权限

这可以通过设置一个非常严格的访问控制列表（ACL）来实现。我们可以移除所有现有的访问权限。

这里是实现这一目标的 PowerShell 脚本：

```powershell
# 定义注册表路径
$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace"

# 获取当前的注册表项
$key = Get-Item -LiteralPath $path

# 获取当前的访问控制列表（ACL）
$acl = $key.GetAccessControl()

# 移除所有现有的访问规则
$acl.Access | ForEach-Object {
    $acl.RemoveAccessRule($_)
}

# 将修改后的ACL应用到注册表项
Set-Acl -Path $path -AclObject $acl
```

设置完成后,命令行将无法直接访问此注册表,管理员权限也不行,需要打开注册表编辑器,找到对应的路径手动设置权限,赋予读或者完全控制的权限才行

### 移除所有权限但保留管理员👺

移除所有访问权限，但保留 SYSTEM 和 Administrators 组的访问。相比于上述脚本,这个方案稍微温和一些,但是注意命令之间的组织顺序,修改全部完规则后再提交修改(如果删除所有权限后么有添加指定权限就提交修改是不合适的,这时如果反悔了,就得通过GUI方式修改)

以下是实现这一目标的 PowerShell 脚本：

即使在设置了权限之后，实际的权限设置不一定会达到预期。这可能是由于几个原因造成的，包括继承的权限、特殊的系统保护或隐藏的安全描述符。

下面的命令行尽可能考虑到这些问题,并且在我的计算机上测试通过(注意,如果用gui方式查看注册表访问权限,在命令行执行完更改后,请刷新注册表(F5),然后在检查注册表权限)

```powershell
function Set-ExplorerSoftwareIcons
{
    <# 
    .SYNOPSIS
    本命令用于禁用系统Explorer默认的计算机驱动器以外的软件图标,尤其是国内的网盘类软件(百度网盘,夸克网盘,迅雷,以及许多视频类软件)
    也可以撤销禁用
    .PARAMETER Enabled
    是否允许软件设置资源管理器内的驱动器图标
    使用True表示允许
    使用False表示禁用(默认)
    .NOTES
    使用管理员权限执行此命令
    .EXAMPLE
    PS C:\Users\cxxu\Desktop> set-ExplorerSoftwareIcons -Enabled True
    refresh explorer to check icons
    #禁用其他软件设置资源管理器驱动器图标
    PS C:\Users\cxxu\Desktop> set-ExplorerSoftwareIcons -Enabled False
    refresh explorer to check icons
    .EXAMPLE
    显示设置过程信息
    PS C:\Users\cxxu\Desktop> set-ExplorerSoftwareIcons -Enabled True -Verbose
    VERBOSE: Enabled Explorer Software Icons (allow Everyone Permission)
    refresh explorer to check icons
    .EXAMPLE
    显示设置过程信息,并且启动资源管理器查看刷新后的图标是否被禁用或恢复
    PS C:\Users\cxxu\Desktop> set-ExplorerSoftwareIcons -Enabled True -Verbose -RefreshExplorer
    VERBOSE: Enabled Explorer Software Icons (allow Everyone Permission)
    refresh explorer to check icons
    PS C:\Users\cxxu\Desktop> set-ExplorerSoftwareIcons -Enabled False -Verbose -RefreshExplorer
    VERBOSE: Disabled Explorer Software Icons (Remove Everyone Group Permission)
    refresh explorer to check icons
    
    #>
    [CmdletBinding()]
    param (
        [ValidateSet('True', 'False')]$Enabled ,
        [switch]$RefreshExplorer
    )
    $path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace'
    $acl = Get-Acl -Path $path

    # 禁用继承并删除所有继承的访问规则
    $acl.SetAccessRuleProtection($true, $false)

    # 清除所有现有的访问规则
    $acl.Access | ForEach-Object {
        $acl.RemoveAccessRule($_) | Out-Null
    }


    # 添加SYSTEM和Administrators的完全控制权限
    $identities = @('NT AUTHORITY\SYSTEM', 'BUILTIN\Administrators')
    if ($Enabled -eq 'True')
    {
        $identities += @('Everyone')
        Write-Verbose 'Enabled Explorer Software Icons (allow Everyone Permission)'
    }
    else
    {
        Write-Verbose 'Disabled Explorer Software Icons (Remove Everyone Group Permission)'
    }
    foreach ($identity in $identities)
    {
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule($identity, 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
        $acl.AddAccessRule($rule)
    }

    # 应用新的ACL
    Set-Acl -Path $path -AclObject $acl # -ErrorAction Stop
    Write-Host 'refresh explorer to check icons'    
    if ($RefreshExplorer)
    {
        explorer.exe
    }
}
#管理员权限限一键执行
set-ExplorerSoftwareIcons -Enabled False

```

这个脚本做了以下几件事：

1. 获取指定注册表项的引用。
2. 获取该项的当前访问控制列表（ACL）。
3. 移除ACL中的所有现有访问规则。
4. 为 SYSTEM 和 Administrators 组创建新的访问规则，给予它们完全控制权限。
5. 将新规则添加到ACL。
6. 将修改后的ACL应用回注册表项。

执行这个脚本后，只有 SYSTEM 和 Administrators 组能够访问这个注册表项。其他所有用户和程序都将无法访问。

请注意以下几点：

1. 这仍然是一个相当严格的限制，可能会影响依赖于访问这个注册表项的普通程序的正常运行。
2. 你需要以管理员权限运行 PowerShell 来执行这个脚本。
3. 在执行这个操作之前，强烈建议你创建一个系统还原点或备份注册表，以便在需要时可以恢复。
4. 如果你之后需要给其他用户或组添加访问权限，你可以通过管理员权限来修改这个注册表项的ACL。

