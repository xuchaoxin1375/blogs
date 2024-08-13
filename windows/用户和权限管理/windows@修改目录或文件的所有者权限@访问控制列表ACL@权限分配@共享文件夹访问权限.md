[toc]





## abstract

- windows个人用户对文件夹或文件做访问控制权限设置的情况比较少,但有时确实需要
  - 一类是不当得使用管理员权限做某些更改或者授权给某些软件运行了一些修改文件夹或文件的命令导致用户访问发生异常
  - 另一方面则是用户主动利用访问控制权限保护数据不被未授权的行为造成影响,比如共享文件夹为特定用户设置特定的权限,那么就要配合NTFS访问控制权限设置,授权不同用户不同的访问权限


### 问题举例

- 个别情况下,比如系统上有多个用户,或者不当使用**管理员权限**运行了某些命令后产生的目录或文件无法被其他用户访问,即使这个用户也处于`administrators`组内
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

这种情况下,一般是系统上有多个用户或者设备上有系统(比如不同版本的windows跨盘访问数据造成文件(夹)权限设置被污染)

可以尝试移除分配给不明的用户权限;如果无法直接修改,则先尝试取消**权限继承**,然后再修改或移除特定用户对相应文件夹的访问权限

### 共享文件夹的访问控制权限

出来本地文件夹的**NTFS访问控制权限**,设置了共享的文件夹还有单独的**共享访问权限**,也就是对于共享文件夹,有两层访问控制权限设置

如果是普通文件夹(没有被创建为网络共享文件夹),那么讨论设置文件夹权限一般指定是NTFS访问控制权限,或者称为**文件及文件夹权限**

下面这段内容来自于官方文档(译):[Combine shared folder and NTFS permissions - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/configure-manage-shared-folders/5-combine-shared-folder-ntfs-permissions)

当你在使用支持安全性的文件系统格式化的卷上创建共享文件夹时，**共享文件夹权限**和**文件及文件夹权限**会结合起来控制用户通过网络访问文件资源的权限。

无论用户是本地访问还是通过网络访问资源，文件和文件夹权限都会起作用，但它们会过滤共享文件夹权限。

当你授予共享文件夹权限时，以下规则适用：

- 除了使用网络文件和文件夹共享中的“共享”选项外，Everyone（所有人）组拥有读取共享文件夹权限。

- 用户必须对共享文件夹中的每个文件和子文件夹拥有适当的文件系统权限以及适当的共享文件夹权限，才能访问这些资源。
- 当文件系统权限和共享文件夹权限结合时，结果权限是两种权限中最严格的一个。通常，这是文件系统和共享文件夹权限中最高的共同分母。
- 当用户尝试通过共享连接到内容时，文件夹的共享权限适用于该文件夹、其所有文件和子文件夹及子文件夹中的所有文件。
- 当你为每个共享文件夹配置共享文件夹权限时，你只能允许或拒绝读取、更改和完全控制权限，这些权限适用于所有文件夹和子文件夹中的内容。而当你配置文件系统权限时，你有更多的细粒度控制。你可以为每个文件配置权限，并且可以允许或拒绝更多的文件系统权限，而不仅仅是共享权限。

以下类比可以帮助你理解当文件系统权限和共享权限结合时会发生什么：

- 如果你想通过网络访问共享文件夹的文件，你必须通过共享文件夹。
- 如果共享权限设置为读取（Read），那么当通过共享文件夹连接时，你最多只能读取文件，即使单个文件系统权限设置为完全控制（Full Control）。所有比共享权限限制更少的文件系统权限都会被过滤掉，因此只有最严格的权限保留——在这种情况下是读取权限。
- 如果你将共享权限配置为更改（Change），你可以读取或修改共享的数据。如果文件系统权限设置为完全控制（Full Control），共享权限会将有效权限过滤为修改（Modify）。
- 相反，如果共享权限设置为完全控制（Full Control），但用户对文件夹的NTFS权限设置为读取（Read），则有效权限为读取。

## 简单查看路径的访问控制权限

我们可以用`Get-Acl`来查看指定目录或文件的访问控制权限

```powershell
PS> Get-Acl C:\sharePlus |fl

Path   : Microsoft.PowerShell.Core\FileSystem::C:\sharePlus
Owner  : COLORFULCXXU\cxxu
Group  : COLORFULCXXU\cxxu
Access : BUILTIN\Administrators Allow  FullControl
         NT AUTHORITY\SYSTEM Allow  FullControl
         BUILTIN\Users Allow  ReadAndExecute, Synchronize
         NT AUTHORITY\Authenticated Users Allow  Modify, Synchronize
         NT AUTHORITY\Authenticated Users Allow  -536805376
Audit  :
Sddl   : O:S-1-5-21-1150093504-2233723087-916622917-1001G:S-1-5-21-1150093504-2233723
         087-916622917-1001D:AI(A;OICIID;FA;;;BA)(A;OICIID;FA;;;SY)(A;OICIID;0x1200a9
         ;;;BU)(A;ID;0x1301bf;;;AU)(A;OICIIOID;SDGXGWGR;;;AU)
```

- 其中最直观的是路径对象的拥有着(owner)以及Access(访问控制权限)
- 上面的例子中,有5行权限记录,第一行是指windows内置的管理员账户(Administrator)对此目录有完整的控制权限,第二行类似;

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

例如，一个简化的 SDDL 字符串可能看起来像这样：

```
Sddl                    : O:S-1-5-21-1150093504-2233723087-916622917-1001G:S-1-5-21-1150093504-22337230
                          87-916622917-1001D:PAI(D;OICI;DCLCRPCR;;;BU)(A;OICI;FA;;;WD)(A;OICI;0x1201bf;
                          ;;AU)(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICI;FA;;;BU)
```

 其中每个部分代表安全描述符的不同组件，如所有者（Owner, O:）、组（Group, G:）、DACL（D:）和各个访问控制项（ACE）。

由于 SDDL 直接关系到系统的安全配置，通常需要管理员级别的权限才能进行相关操作。

### 查看访问控制信息

在 PowerShell 中，要检查某个目录的所有者，可以使用 `Get-Acl` cmdlet。

这个命令可以获取指定项的访问控制列表（ACL），从中你可以查看到所有者信息。

[Get-Acl (Microsoft.PowerShell.Security) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.security/get-acl?view=powershell-7.4)

这个命令默认没有别名,如果需要可以设置为acl

该命令具有很多功能,这里仅介绍最常用和最基本的功能

### 查看文件所有者

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

## icacls 修改文件或目录的访问权限

[icacls | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/icacls)

- 显示或修改指定文件上的随机访问控制列表 (DACL)，并将存储的 DACL 应用于指定目录中的文件。

`icacls`是Windows操作系统中用于管理文件和目录访问权限的命令行工具。它的名称代表"**Integrity Control Access Control Lists**"。以下是对icacls命令的详细介绍：

1. 基本用途：
   `icacls`用于显示或修改文件和文件夹的访问控制列表(ACL)。它允许管理员精确控制用户和组对文件系统对象的访问权限。

2. 语法：
   基本语法为：`icacls <文件名> [/选项] [/T] [/C] [/L] [/Q]`

   使用`icacls  /?`获取本地使用手册 (手册中`perm`是`permission`的缩写)

   ```powershell
   
   ICACLS name /save aclfile [/T] [/C] [/L] [/Q]
       stores the DACLs for the files and folders that match the name
       into aclfile for later use with /restore. Note that SACLs,
       owner, or integrity labels are not saved.
   
   ICACLS directory [/substitute SidOld SidNew [...]] /restore aclfile
                    [/C] [/L] [/Q]
       applies the stored DACLs to files in directory.
   
   ICACLS name /setowner user [/T] [/C] [/L] [/Q]
       changes the owner of all matching names. This option does not
       force a change of ownership; use the takeown.exe utility for
       that purpose.
   
   ICACLS name /findsid Sid [/T] [/C] [/L] [/Q]
       finds all matching names that contain an ACL
       explicitly mentioning Sid.
   
   ICACLS name /verify [/T] [/C] [/L] [/Q]
       finds all files whose ACL is not in canonical form or whose
       lengths are inconsistent with ACE counts.
   
   ICACLS name /reset [/T] [/C] [/L] [/Q]
       replaces ACLs with default inherited ACLs for all matching files.
   
   ICACLS name [/grant[:r] Sid:perm[...]]
          [/deny Sid:perm [...]]
          [/remove[:g|:d]] Sid[...]] [/T] [/C] [/L] [/Q]
          [/setintegritylevel Level:policy[...]]
   ....
   ```

   或者阅读在线手册

   ```cmd
   icacls <filename> [/grant[:r] <sid>:<perm>[...]] [/deny <sid>:<perm>[...]] [/remove[:g|:d]] <sid>[...]] [/t] [/c] [/l] [/q] [/setintegritylevel <Level>:<policy>[...]]
   
   icacls <directory> [/substitute <sidold> <sidnew> [...]] [/restore <aclfile> [/c] [/l] [/q]]
   ```

   

3. 常用选项：
   - /grant：授予指定用户或组特定权限
   - /deny：拒绝指定用户或组特定权限
   - /remove：移除指定用户或组的权限
   - /setowner：**设置所有者**(这个功能选项不强制,使用takeown命令来强制,但是仍然不保证)
   - /reset：重置ACL到默认继承的ACL
   - /T：**递归**应用到所有子文件夹和文件
   - /C：在出错时继续操作
   - /L：对符号链接本身进行操作，而不是它们的目标
   - /Q：抑制成功消息

4. 权限类型：
   - F (完全控制)
   - M (修改)
   - RX (读取和执行)
   - R (读取)
   - W (写入)
   - 此外还有高级权限...


### 使用cmd和管理员权限执行icacls

- 建议使用cmd执行`icacls`命令,因为powershell直接执行会遇到括号时会造成错误解析
- 或者通过一些手段将原本的命令行做修改
- 修改访问控制权限一般要管理员权限

### 示例用法

#### 显示文件的访问控制权限列表

- 显示文件权限：`icacls <name>`

  - ```cmd
    PS C:\temp> icacls .\newfile.txt
    .\newfile.txt BUILTIN\Administrators:(I)(F)
                  NT AUTHORITY\SYSTEM:(I)(F)
                  BUILTIN\Users:(I)(RX)
                  NT AUTHORITY\Authenticated Users:(I)(M)
    
    Successfully processed 1 files; Failed processing 0 files
    ```

    这个输出显示了文件 "newfile.txt" 的访问控制列表（ACL）。

    1. `.\newfile.txt` 
       这是被查询的文件名。
    2. `BUILTIN\Administrators:(I)(F)`
       - BUILTIN\Administrators 是内置的管理员组
       - (I) 表示这个权限是继承的（Inherited）
       - (F) 表示完全控制（Full control）权限
    3. `BUILTIN\Users:(I)(RX)`
       - BUILTIN\Users 是内置的用户组
       - (RX) 表示读取和执行（Read and Execute）权限
    5. `NT AUTHORITY\Authenticated Users:(I)(M)`
       - NT AUTHORITY\Authenticated Users 代表所有已认证的用户
       - (M) 表示修改（Modify）权限


#### 其他示例

- 授予用户读写权限：`icacls C:\example.txt /grant John:(RW)`

- 拒绝用户访问

  - ```cmd
    #查看设置前的权限
    C:\Users\cxxu\Desktop>icacls C:/share1
    C:/share1 BUILTIN\Administrators:(I)(OI)(CI)(F)
              NT AUTHORITY\SYSTEM:(I)(OI)(CI)(F)
              BUILTIN\Users:(I)(OI)(CI)(RX)
              NT AUTHORITY\Authenticated Users:(I)(M)
              NT AUTHORITY\Authenticated Users:(I)(OI)(CI)(IO)(M)
    
    Successfully processed 1 files; Failed processing 0 files
    #设置拒绝写的权限
    C:\Users\cxxu\Desktop>icacls C:\share1 /deny u1:(W)
    processed file: C:\share1
    Successfully processed 1 files; Failed processing 0 files
    
    C:\Users\cxxu\Desktop>icacls C:\share1
    C:\share1 CXXUCOLORFUL\u1:(DENY)(W)
              BUILTIN\Administrators:(I)(OI)(CI)(F)
              NT AUTHORITY\SYSTEM:(I)(OI)(CI)(F)
              BUILTIN\Users:(I)(OI)(CI)(RX)
              NT AUTHORITY\Authenticated Users:(I)(M)
              NT AUTHORITY\Authenticated Users:(I)(OI)(CI)(IO)(M)
    ```

-  移除被设置为拒绝的访问权限

  - ```cmd
    #将上例中的设置拒绝用户u1对目录C:\share1 进行写操作的设置撤销(回复u1账户的写权限)
    C:\Users\cxxu\Desktop>icacls C:\share1 /remove:d u1
    processed file: C:\share1
    Successfully processed 1 files; Failed processing 0 files
    
    C:\Users\cxxu\Desktop>icacls C:\share1
    C:\share1 BUILTIN\Administrators:(I)(OI)(CI)(F)
              NT AUTHORITY\SYSTEM:(I)(OI)(CI)(F)
              BUILTIN\Users:(I)(OI)(CI)(RX)
              NT AUTHORITY\Authenticated Users:(I)(M)
              NT AUTHORITY\Authenticated Users:(I)(OI)(CI)(IO)(M)
    
    Successfully processed 1 files; Failed processing 0 files
    ```

    

- 递归修改文件夹权限：`icacls C:\folder /grant u1:(OI)(CI)(F) /T`

### 重置权限分配

例如,要清空 C:/share 目录的已有权限设置并重置为默认状态，可以使用 icacls 命令的 /reset 选项。

```cmd
ICACLS name /reset [/T] [/C] [/L] [/Q]
    replaces ACLs with default inherited ACLs for all matching files.
```

这将移除所有明确设置的权限，并恢复继承自父目录的默认权限。以下是具体步骤：

1. 首先，以管理员身份打开命令提示符或 PowerShell。
2. 使用以下命令重置 C:/share 目录的权限：

```cmd
icacls C:\share /reset /T
```

这个命令的解释：

- `/reset` 选项会删除所有明确的权限条目，仅保留继承的权限。
- `/T` 选项使命令递归应用到所有子文件夹和文件。

1. 等待命令执行完毕。根据文件夹的大小和内容数量，这可能需要一些时间。
2. 执行完成后，检查权限是否已重置：

```cmd
icacls C:\share
```

1. 如果你想在重置后为特定用户或组设置权限，可以使用 /grant 选项。例如，要给 Users 组读写权限：

```cmd
icacls C:\share /grant Users:(RW) /T
```

### Note

- 使用`icacls`分配权限有时是最管用的

  ```powershell
  PS C:\Users\cxxu> cmd  /c 'icacls.exe .\documents\ /grant cxxu:(F)'
  已处理的文件: .\documents\
  已成功处理 1 个文件; 处理 0 个文件时失败
  ```

- 部分情况下图形界面设置的权限不靠谱，可以尝试用`icacls`来试试

- 子目录和文件递归和继承权限设置

```powershell
cmd /c ' icacls $Path  /grant cxxu:(OI)(CI)F  /T ' #将$path修改为目标目录即可
```



## takeown 命令设置文件或目录所有权

[takeown | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/takeown)

- 使管理员作为文件的所有者，恢复对之前被拒文件的访问权限。 此命令通常用于批处理文件。
- Description:
      This tool allows an administrator to recover **access** to **a file that was denied** by re-assigning file ownership.

`takeown` 命令在 Windows 操作系统中用于获取文件或文件夹的所有权。通过获取所有权，你可以更改文件或文件夹的权限，以便进行修改。

尽管如此,对于系统文件面前,takeown命令基本上很难管用,也就能管理一些普通用户的文件夹权限以及配置文件,例如系统的hosts文件

例如这种方法无法设置`C:\windows\system32\`目录下的文件的系统内置可执行文件(比如`cmd.exe`的所有权)

许多定制版系统内置的**右键管理员取得所有权**选项,基本上就是利用`takeown`命令来实现的

总之如果需要修改系统核心文件,那么需要寻求更高的提权方案,比如获取`TrustedInstaller`权限



### 语法

通过执行命令行` takeown.exe /?`获取本地帮助文档

```cmd
TAKEOWN [/S system [/U username [/P [password]]]]
        /F filename [/A] [/R [/D prompt]]
```

基本语法:

```cmd
takeown /F <文件或文件夹路径>
```



### 常用参数

- `/F <文件或文件夹路径>`：指定你要获取所有权的文件或文件夹。
- `/A`：将所有权分配给管理员组。
- `/R`：递归获取文件夹及其子文件夹和文件的所有权。
- `/D Y`：对于每个无法获取的文件或文件夹，默认响应为“是”。



1. **递归获取文件夹及其子文件和文件夹的所有权**

   ```cmd
   takeown /F C:\Windows\System32\drivers /R
   ```

   这将获取 `drivers` 文件夹及其所有子文件夹和文件的所有权。

2. **将所有权分配给管理员组**

   ```cmd
   takeown /F C:\Windows\System32\drivers\etc\hosts /A
   ```

   这将 `hosts` 文件的所有权分配给管理员组。

   1. **在无提示的情况下获取所有权**

   ```cmd
   takeown /F C:\Windows\System32\drivers\etc\hosts /D Y
   ```

   对于每个无法获取的文件或文件夹，默认响应为“是”。


### 例子：获取系统文件夹的所有权

假设你需要获取 `C:\Windows\System32` 文件夹及其所有子文件夹和文件的所有权：

```cmd
takeown /F C:\Temp /R /D Y
```

这个命令会递归地获取 `C:\Temp` 文件夹及其所有内容的所有权，并在遇到无法获取的项目时默认响应“是”。

### 例子:管理员获取普通用户创建的文件的所有权

首先,利用**管理员权限命令行**,在windows上创建一个普通用户,比如执行

```cmd
PS> sudo net user maintainer * /add
Type a password for the user: #提示你输入密码,作为试验临时用途,简单点即可
Retype the password to confirm:
The command completed successfully.
```

然后切换到新用户(上面例子创建的新用户为`maintainer`)

- 如果你部署了ssh服务,那么可以利用ssh直接从命令行访问新用户(可以免去图形界面加载新用户的耗时过程以及磁盘占用开销)

- 如果没有,那么用图形界面切换登录到新建用户`maintainer`也是可以的

- 登录到新用户`maintainer`

  ```powershell
  PS> ssh maintainer@cxxucolorful
  ...
  Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
  
  Warning: Permanently added 'cxxucolorful' (ED25519) to the list of known hosts.
  maintainer@cxxucolorful's password:
  PowerShell 7.4.4
  
  ```

  在`maintainer`用户内创建一个属于其自己的文件,并检查所有者是否为`maintainer`自己

  ```powershell
  
  PS C:\Users\maintainer> "create by maintainer"> C:\temp\demo.txt
  PS C:\Users\maintainer> cd C:\temp\
  PS C:\temp> ls
  
      Directory: C:\temp
  
  Mode                 LastWriteTime         Length Name
  ----                 -------------         ------ ----
  -a---            8/2/2024  9:22 PM              4 demo.ps1
  -a---            8/6/2024  8:21 PM             22 demo.txt
  -a---            8/2/2024  9:22 PM              4 demohard.ps1
  -a---            8/2/2024  2:37 PM              0 exist
  -a---            8/2/2024  2:25 PM              0 testCreate
  
  
  PS C:\temp> get-acl .\demo.txt|select Owner
  
  Owner
  -----
  CXXUCOLORFUL\maintainer
  ```

- 现在尝试在某个**管理员账户**中,来尝试用`takeown`命令将文件`demo.txt`的所有者设置为管理员组中的一个成员`cxxu`

```powershell
PS C:\temp> ls .\demo.txt

    Directory: C:\temp

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            2024/8/6    20:21             22 demo.txt

PS C:\temp> acl .\demo.ps1|select Owner

Owner
-----
CXXUCOLORFUL\cxxu

PS C:\temp> acl .\demo.txt|select Owner

Owner
-----
CXXUCOLORFUL\maintainer

PS C:\temp> takeown /f .\demo.txt
ERROR: The current logged on user does not have ownership privileges on
       the file (or folder) "C:\temp\demo.txt".

PS C:\temp> sudo pwsh
PowerShell 7.4.4
PS C:\temp> whoami
cxxucolorful\cxxu
PS C:\temp> takeown /f .\demo.txt

SUCCESS: The file (or folder): "C:\temp\demo.txt" now owned by user "CXXUCOLORFUL\cxxu".
```



## powershell权限设置方案



- powershell有`Get-Acl`,`Set-Acl`等命令设置权限,可能还需要调用`.Net`api来修改
- 在 PowerShell 中，修改文件或目录的所有者可以通过 `Set-ACL` (设置访问控制列表) 命令来实现。但直接使用 `Set-ACL` 修改所有者可能不够直观，通常我们会先获取当前的 ACL，修改其中的所有者信息，然后再将修改后的 ACL 应用回去。

### 使用set-acl设置文件拥有者

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



## powershell设置访问控制权限👺

允许用户指定目录路径分配指定用户指定权限

也可以选择是否清除原有权限设置(权限清理)。这样除了命令执行时分配给指定用户的权限可以用(对于普通用户),其余权限都被取消

```powershell

function Grant-PermissionToPath
{
    <# 
    .SYNOPSIS
    可以清除某个目录的访问控制权限,并设置权限,比如让任何人都可以完全控制的状态
    这是一个有风险的操作;建议配合其他命令使用,比如清除限制后再增加约束
    .DESCRIPTION
    设置次函数用来清理发生权限混乱的文件夹,可以用来做共享文件夹的权限控制强制开放
    .EXAMPLE
    PS [C:\]> Grant-PermissionToPath -Path C:/share1 -ClearExistingRules
    True
    True
    已成功将'C:/share1'的访问权限设置为允许任何人具有全部权限。
    .PARAMETER Path
    需要执行访问控制权限修改的目录
    .PARAMETER Group
    指定文件夹要授访问权限给那个组,结合Permission参数,指定该组对Path具有则样的访问权限
    默认值为:'Everyone'
    .PARAMETER Permission
    增加/赋于新的访问控制权限,可用的合法值参考:https://learn.microsoft.com/zh-cn/dotnet/api/system.security.accesscontrol.filesystemrights?view=net-8.0
    .PARAMETER ClearExistingRules
    清空原来的访问控制规则
    .NOTES
    需要管理员权限,相关api参考下面连接
    .LINK
     相关AIP文档:https://learn.microsoft.com/zh-cn/dotnet/api/system.security.accesscontrol.filesystemaccessrule?view=net-8.0
    #>
    [CmdletBinding()]
    param(
        [string]$Path,
        $Group = 'Everyone',
        # 指定下载权限
        $permission = 'FullControl',

        [switch]$ClearExistingRules

    )

    try
    {
        # 获取目标目录的当前 ACL
        $acl = Get-Acl -Path $Path

        # 创建允许“任何人（Everyone）”具有“完全控制”权限的新访问规则
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $Group,
            $permission, 
            'ContainerInherit, ObjectInherit',
            'None',
            'Allow'
        )

        if ($ClearExistingRules)
        {
            # 如果指定了清除现有规则，则先移除所有现有访问规则
            $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }
        }

        # 添加新规则到 ACL
        $acl.SetAccessRule($rule)

        # 应用修改后的 ACL 到目标目录
        Set-Acl -Path $Path -AclObject $acl

        Write-Host "已成功将'$Path'的访问权限设置为允许任何人具有全部权限。"
    }
    catch
    {
        Write-Error "设置权限时出错: $_"
    }
}


```



## 移除某个用户的权限

- 例如双系统设备,一台设备安装了两个不同版本的windows,分别在C盘和D盘(对于两个系统C,D盘是相互的)

- 如果跨系统访问,另一个盘上的系统(假设为系统X访问系统Y)中的某个用户的家目录,就需要获取权限,而这会对系统Y的相关目录的权限做修改

- 当你重启进入系统Y后会发现系统Y中的被X访问了的目录的权限控制发生变化,可能会多出一个陌生用户

- 那么许多鉴权文件的拥有者(访问权限)发生变更,会导致失效(比如`~/.ssh`目录下的公钥文件的免密登录ssh可能会失效,会要求你移出不明用户的访问权限)

  - ```cmd
    PS> ssh administrator@front
    Bad permissions. Try removing permissions for user: UNKNOWN\\UNKNOWN (S-1-5-21-208387601-1918623530-3577755754-1001) on file C:/Users/cxxu/.ssh/config.
    Bad owner or permissions on C:\\Users\\cxxu/.ssh/config
    ```


### 权限继承导致修改权限操作不可用

上述问题需要我们移除不明用户对关键目录的访问权限,然而修改可能受到权限继承的阻碍

- ```cmd
  You can't remove AccountJnkn0wn(S-1-5-21-208387601-1918623530-3577755754-1001)because this object is inheriting permissions from its parent.
  Toremove AccountUnkn0wn(S-1-5-21-208387601-1918623530-3577755754-1001),you must prevent this object from inheriting permissions.
  Turnoff the option for inheriting permissions, and then tryremoving AccountUnkn0wn(S-1-5-21-208387601-1918623530-3577755754-1001)again.
  ```

若使用gui修改权限,windows可能会跑出上述的提示,我们根据提示关闭目标文件(目录)的权限继承,然后再执行设置

## windows上提取高级权限的方案

例如gsudo,nsudo等工具,另见它文