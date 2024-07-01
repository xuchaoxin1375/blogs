[toc]





## abstract

- 个别情况下,比如系统上有多个用户,或者不当使用管理员权限运行了某些命令后产生的目录或文件无法被其他用户访问,即使这个用户也处于`administrator`组内
- 例如,git仓库中,我遇到了如下问题

```bash
# [C:\repos\configs]
PS> git pull origin main
fatal: detected dubious ownership in repository at 'C:/repos/configs'
'C:/repos/configs' is owned by:
        BUILTIN/Administrators (S-1-5-32-544)
but the current user is:
        CXXUWIN/Cxxu (S-1-5-21-1891471771-882250236-2783003205-1014)
To add an exception for this directory, call:

        git config --global --add safe.directory C:/repos/configs
```

## 相关的powershell命令

- [Microsoft.PowerShell.Security Module - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.security/)

### 相关概念

#### 访问控制列表ACL

[访问控制列表 - Windows drivers | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/drivers/ifs/access-control-list)

Windows ACL（Access Control List，访问控制列表）是Windows操作系统中实现访问控制的核心机制之一，用于管理用户和组对系统资源（如文件、文件夹、注册表项、打印机等）的访问权限。Windows ACL系统基于NTFS（New Technology File System）文件系统，允许管理员以非常细致的方式分配权限，确保不同用户和组能按照既定策略访问相应的资源。

Windows ACL的关键组成部分包括：

1. **安全主体（Security Principal）**：指用户账户、用户组或服务账户等实体，它们可以被授予或拒绝访问权限。

2. **访问控制条目（ACE，Access Control Entry）**：ACL中的每个条目定义了一个安全主体对特定资源的访问权限，如读取、写入、执行、修改权限等。

3. **安全描述符（Security Descriptor）**：每个对象（如文件）都有一个安全描述符，其中包含对象的所有者、所属组以及DACL（Discretionary Access Control List）和SACL（System Access Control List）。DACL决定哪些用户或组可以访问对象及其权限级别，而SACL则用于审计目的。

4. **继承和传播**：Windows ACL支持权限的继承，即父文件夹的权限可以传递给其子文件夹和文件，但也可以被覆盖或明确设置。

5. **高级权限设置**：Windows资源管理器或命令行工具如`icacls`和`set-acl` PowerShell cmdlet允许管理员查看和修改ACL，进行诸如权限的添加、删除、复制和替换等操作。

6. **权限合并**：当一个用户属于多个组，且这些组都被赋予了不同的权限时，Windows会合并这些权限，最终确定用户的有效权限。

通过精细地管理ACL，管理员可以确保系统遵循最小权限原则，即每个用户或进程仅获得完成其任务所需的最小权限集，从而增强系统的整体安全性和合规性。

#### 安全描述符定义语言SDDL

SDDL 是 Security Descriptor Definition Language（安全描述符定义语言）的缩写，是一种用于表示 Windows 操作系统中安全对象（如文件、目录、注册表项、服务等）的访问控制信息的字符串格式。它是一种基于文本的、紧凑且可读性强的语法，用于详细描述安全描述符，包括 discretionary access control list (DACL) 和 system access control list (SACL)。

在 Windows 环境中，每个安全对象都有一个安全描述符，该描述符定义了哪些用户或组可以访问该对象以及他们可以执行的操作（如读取、写入、修改权限等）。SDDL 提供了一种标准化的方式来创建、查看和修改这些安全描述符，使得管理员能够精确控制资源的访问权限。

SDDL 字符串通常包含一系列编码的访问控制条目，每个条目定义了一组权限和与之关联的安全主体（如用户或组）。这些字符串可以通过命令行工具、脚本或编程接口来生成、解析和应用，便于自动化权限管理和安全策略的部署。

例如，一个简化的 SDDL 字符串可能看起来像这样：`O:SYG:SYD:(A;OICIIO;GA;;;SY)(A;OICIIO;GA;;;BA)`, 其中每个部分代表安全描述符的不同组件，如所有者（Owner, O:）、组（Group, G:）、DACL（D:）和各个访问控制项（ACE）。

由于 SDDL 直接关系到系统的安全配置，通常需要管理员级别的权限才能进行相关操作。

### 查看访问控制信息

在 PowerShell 中，要检查某个目录的所有者，可以使用 `Get-Acl` cmdlet。

这个命令可以获取指定项的访问控制列表（ACL），从中你可以查看到所有者信息。

[Get-Acl (Microsoft.PowerShell.Security) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.security/get-acl?view=powershell-7.4)

这个命令默认没有别名,如果需要可以设置为acl

该命令具有很多功能,这里仅介绍最常用和最基本的功能,例如查看文件所有者

```powershell
Set-Alias -name acl -Value Get-Acl
```

例如

```powershell
PS> acl .\RecycleBinDir\

    Directory: C:\

Path          Owner             Access
----          -----             ------
RecycleBinDir COLORFULCXXU\cxxu NT AUTHORITY\SYSTEM Allow  FullControl…
```



1. **打开 PowerShell**：
   - 如果需要修改访问控制权限,请以管理员身份运行 PowerShell。
   - 可以通过在开始菜单搜索“PowerShell”，然后右键点击“Windows PowerShell”或“PowerShell”并选择“以管理员身份运行”。
   
2. **使用 Get-Acl 获取目录的 ACL**：
   - 假设你想检查 `C:\example_directory` 的所有者，可以输入以下命令：
     ```powershell
     $acl = Get-Acl -Path "C:\example_directory"
     ```

3. **查看所有者信息**：
   - 要查看这个目录的所有者，可以访问 `$acl.Owner` 属性：
     ```powershell
     $acl.Owner
     ```
     这将会输出所有者的标识，通常是类似 `NT AUTHORITY\System` 或 `domain\username` 的格式。

综合以上步骤，完整的 PowerShell 命令序列如下：

```powershell
$acl = Get-Acl -Path "C:\example_directory"
$acl.Owner
```

这段脚本将获取指定目录的访问控制列表，并输出其所有者。请确保将 `"C:\example_directory"` 替换为你实际想要查询的目录路径。

#### 示例

```bash
PS> $acl

    Directory: C:\repos

Path    Owner                  Access
----    -----                  ------
configs BUILTIN\Administrators BUILTIN\Administrators Allow  FullControl…


PS[BAT:99%][MEM:48.85% (3.81/7.80)GB][10:30:50 PM]
# [C:\repos]
PS> $acl|select *|Out-Host -Paging

PSPath                  : Microsoft.PowerShell.Core\FileSystem::C:\repos\configs\
PSParentPath            : Microsoft.PowerShell.Core\FileSystem::C:\repos
PSChildName             : configs
PSDrive                 : C
PSProvider              : Microsoft.PowerShell.Core\FileSystem
CentralAccessPolicyId   :
Path                    : Microsoft.PowerShell.Core\FileSystem::C:\repos\configs\
Owner                   : BUILTIN\Administrators
Group                   : CXXUWIN\None
Access                  : {System.Security.AccessControl.FileSystemAccessRule, System.Security.AccessControl.FileSystemAccessRule,
                          System.Security.AccessControl.FileSystemAccessRule, System.Security.AccessControl.FileSystemAccessRule…}
Sddl                    : O:BAG:S-1-5-21-1891471771-882250236-2783003205-513D:AI(A;OICIID;FA;;;BA)(A;OICIID;FA;;;SY)(A;OICIID;0x1200a9;;;BU)(A;ID;0x1301bf;;;AU)(A;OICIIOID;SDGXG
                          WGR;;;AU)
AccessToString          : BUILTIN\Administrators Allow  FullControl
                          NT AUTHORITY\SYSTEM Allow  FullControl
                          BUILTIN\Users Allow  ReadAndExecute, Synchronize
                          NT AUTHORITY\Authenticated Users Allow  Modify, Synchronize
                          NT AUTHORITY\Authenticated Users Allow  -536805376
AuditToString           :
AccessRightType         : System.Security.AccessControl.FileSystemRights
AccessRuleType          : System.Security.AccessControl.FileSystemAccessRule
AuditRuleType           : System.Security.AccessControl.FileSystemAuditRule
AreAccessRulesProtected : False
AreAuditRulesProtected  : False
AreAccessRulesCanonical : True
AreAuditRulesCanonical  : True


PS[BAT:99%][MEM:49.02% (3.82/7.80)GB][10:31:21 PM]
# [C:\repos]
PS> $acl.Owner
BUILTIN\Administrators
```

## 修改访问控制信息



### 修改目录或文件的所有者

在 PowerShell 中，修改文件或目录的所有者可以通过 `Set-ACL` (设置访问控制列表) 命令来实现。但直接使用 `Set-ACL` 修改所有者可能不够直观，通常我们会先获取当前的 ACL，修改其中的所有者信息，然后再将修改后的 ACL 应用回去。这里有一个更直接且常用的方法是使用 `icacls` 工具（在 Windows 系统中可用），或者使用 `Set-NtObjectOwner` 函数，如果你安装了 NTFSSecurity 模块的话。

### 使用 icacls

1. 打开 PowerShell（以管理员身份运行）。
2. 使用以下命令格式更改指定目录的所有者：

```powershell
icacls "C:\路径\到\目录" /setowner "用户名或域\用户名"
```

例如，要将目录 `C:\example` 的所有者更改为 `administrators` 组，可以执行：

```powershell
icacls "C:\example" /setowner "NT AUTHORITY\Administrators"
```

### 使用 NTFSSecurity 模块

1. 首先，需要安装 NTFSSecurity 模块。在 PowerShell 中运行（管理员模式）：

```powershell
Install-Module -Name NTFSSecurity
```

2. 使用 `Set-NtObjectOwner` 函数来更改目录的所有者：

```powershell
Import-Module NTFSSecurity
Set-NtObjectOwner -Path "C:\路径\到\目录" -Account "用户名或域\用户名"
```

例如，将 `C:\example` 目录的所有者设为 `administrators`，可以这样做：

```powershell
Import-Module NTFSSecurity
Set-NtObjectOwner -Path "C:\example" -Account "NT AUTHORITY\Administrators"
```

请确保替换上述命令中的 `"C:\路径\到\目录"` 和 `"用户名或域\用户名"` 为实际的目录路径和用户名。

**注意：** 修改文件或目录的所有者可能需要管理员权限，并且在某些安全策略严格的环境中可能会受到限制。

### 使用set-acl设置

```powershell
# 设置目录路径和新所有者
$directoryPath = "C:\example"
$newOwner = "NT AUTHORITY\Administrators"

# 获取当前 ACL
$acl = Get-Acl -Path $directoryPath

# 创建新所有者的 NTAccount 对象
$newOwnerAccount = New-Object System.Security.Principal.NTAccount($newOwner)

# 设置新的所有者
$acl.SetOwner($newOwnerAccount)

# 应用修改后的 ACL
Set-Acl -Path $directoryPath -AclObject $acl
```

## 设置访问权限

为了提高代码的复用性和灵活性，我们可以将上述脚本抽象成一个函数，允许用户指定目录路径和是否清除现有权限等参数。下面是一个示例：

```powershell
function Grant-FullControlToEveryone {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter(Mandatory=$false)]
        [switch]$ClearExistingRules
    )

    try {
        # 获取目标目录的当前 ACL
        $acl = Get-Acl -Path $Path

        # 创建允许“任何人（Everyone）”具有“完全控制”权限的新访问规则
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "Everyone",
            "FullControl",
            "Allow"
        )

        if ($ClearExistingRules) {
            # 如果指定了清除现有规则，则先移除所有现有访问规则
            $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }
        }

        # 添加新规则到 ACL
        $acl.SetAccessRule($rule)

        # 应用修改后的 ACL 到目标目录
        Set-Acl -Path $Path -AclObject $acl

        Write-Host "已成功将'$Path'的访问权限设置为允许任何人具有全部权限。"
    }
    catch {
        Write-Error "设置权限时出错: $_"
    }
}
```

现在，你可以像下面这样调用这个函数，根据需要选择是否清除现有权限：

```powershell
Grant-FullControlToEveryone -Path "C:\路径\到\目录" -ClearExistingRules
```

或者，如果不希望清除现有权限，只需省略 `-ClearExistingRules` 参数：

```powershell
Grant-FullControlToEveryone -Path "C:\路径\到\目录"
```

这个函数提供了一个更灵活的方式来控制权限设置，同时保持了脚本的简洁和易用性。