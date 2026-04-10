[toc]



## abstract

在操作系统中，用户和权限的关系是系统安全和管理的核心。

### 用户（Users）

[Local User | Microsoft Learn](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/local-accounts)

[本地帐户 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/security/identity-protection/access-control/local-accounts)

操作系统中的用户通常分为以下几类：

1. **普通用户 (Standard Users)**：拥有基本的系统访问权限，可以进行日常任务如运行应用程序和访问文件，对系统配置进行更改有限制。

2. **管理员用户 (Administrators)**：拥有更高的权限，可以安装软件、修改系统设置和管理其他用户账户。管理员账户用于系统管理和维护。

3. **特权用户 (Privileged Users)**：包括一些特殊的系统账户，如`SYSTEM`和`TrustedInstaller`，这些账户具有极高的权限，用于执行操作系统的核心功能和维护任务。

### 权限（Permissions）

- [Access Control overview | Microsoft Learn](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control)

权限是**对用户可以执行的操作范围的定义**。

操作系统通过权限来控制用户对系统资源（如文件、目录、设备、网络、应用程序等）的访问。

主要权限类型包括：

1. **读取权限 (Read)**：允许用户查看文件内容或目录列表。
2. **写入权限 (Write)**：允许用户修改文件内容或目录结构。
3. **执行权限 (Execute)**：允许用户运行可执行文件或脚本。
4. **完全控制 (Full Control)**：允许用户对资源进行任何操作，包括读取、写入、删除和修改权限。

### 用户和权限的关系

1. **用户组 (User Groups)**：
   - 用户可以被分配到**一个或多个用户组**。每个组具有特定的权限集合，**用户继承其所属组的权限**。
   - 常见用户组包括`Administrators`、`Users`、`Guests`等。

2. **访问控制列表 (Access Control Lists, ACLs)**：
   - ACL是一个权限表，用于定义特定**用户或用户组**对资源的**访问权限**。
   - 每个条目（称为访问控制项，ACE (Access Control Entry)）规定了用户或组对资源的特定权限。
   
3. **角色和权限 (Role-Based Access Control, RBAC)**：
   - RBAC是一种访问控制机制，根据用户的角色分配权限。角色代表一组权限，用户被分配到一个或多个角色，从而继承角色的权限。
   - 例如，一个系统管理员角色可能包含安装软件、管理用户和修改系统设置的权限。

### 操作系统中的权限管理示例

1. **Windows**：
   - Windows使用NTFS文件系统支持详细的权限设置。每个文件或目录都有一个ACL，规定哪些用户或组有权访问该资源及其权限类型。
   - 使用工具如“本地安全策略”（Local Security Policy）和“组策略”（Group Policy）来管理权限。
   - 命令行也可以调整用户权限,比如`net localgroup`,`add-localgroupmember`等
2. **Linux/Unix**：
   - Linux/Unix系统使用:**所有者、组和其他人**（owner, group, others）三种类别来管理文件权限。
   - 通过命令如`chmod`、`chown`和`chgrp`来修改权限和所有者。

### 安全性和最佳实践

下面的准则对于个人用户来说存在感不强,人们为了方便起见,遵守的人不多,但是准则本身很有价值

1. **最小权限原则 (Principle of Least Privilege)**：
   - 用户只应拥有完成其任务所需的最小权限。这减少了滥用权限和系统被攻击的风险。

2. **定期审查权限**：
   - 定期检查和更新用户权限，确保不必要的权限被移除，保持系统的安全性和合规性。

3. **使用强密码和多因素认证**：
   - 保护用户账户的安全，防止未经授权的访问。

通过理解操作系统中用户和权限的关系，可以有效地管理系统安全，确保不同用户在合理权限范围内执行任务，从而维护系统的稳定性和安全性。



## windows中的典型的访问控制权限例子

```powershell
PS C:\Windows\System32> Get-Acl|fl

Path   : Microsoft.PowerShell.Core\FileSystem::C:\Windows\System32
Owner  : NT SERVICE\TrustedInstaller
Group  : NT SERVICE\TrustedInstaller
Access : CREATOR OWNER Allow  268435456
         NT AUTHORITY\SYSTEM Allow  268435456
         NT AUTHORITY\SYSTEM Allow  Modify, Synchronize
         BUILTIN\Administrators Allow  268435456
         BUILTIN\Administrators Allow  Modify, Synchronize
         BUILTIN\Users Allow  -1610612736
         BUILTIN\Users Allow  ReadAndExecute, Synchronize
         NT SERVICE\TrustedInstaller Allow  268435456
         NT SERVICE\TrustedInstaller Allow  FullControl
         APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES Allow  ReadAndExecute, Synchronize
         APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES Allow  -1610612736
         APPLICATION PACKAGE AUTHORITY\ALL RESTRICTED APPLICATION PACKAGES Allow  ReadAndExecute, Synch
         ronize
         APPLICATION PACKAGE AUTHORITY\ALL RESTRICTED APPLICATION PACKAGES Allow  -1610612736
Audit  :
Sddl   : O:S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464G:S-1-5-80-956008885-341852264
         9-1831038044-1853292631-2271478464D:PAI(A;OICIIO;GA;;;CO)(A;OICIIO;GA;;;SY)(A;;0x1301bf;;;SY)(
         A;OICIIO;GA;;;BA)(A;;0x1301bf;;;BA)(A;OICIIO;GXGR;;;BU)(A;;0x1200a9;;;BU)(A;CIIO;GA;;;S-1-5-80
         -956008885-3418522649-1831038044-1853292631-2271478464)(A;;FA;;;S-1-5-80-956008885-3418522649-
         1831038044-1853292631-2271478464)(A;;0x1200a9;;;AC)(A;OICIIO;GXGR;;;AC)(A;;0x1200a9;;;S-1-15-2
         -2)(A;OICIIO;GXGR;;;S-1-15-2-2)
```

在Windows操作系统中，`Get-Acl`命令用于获取对象的访问控制列表（ACL），其中包括文件或目录的权限设置。

以下是对提供的权限列表各个条目的详细分析(by gpt4o)：

### 1. 路径和所有者信息

- **Path**: `C:\Windows\System32`
  - 这是权限适用的目录路径。

- **Owner**: `NT SERVICE\TrustedInstaller`
  - 该目录的所有者是`TrustedInstaller`，这是一个特殊的服务账户，具有管理系统文件的最高权限。

- **Group**: `NT SERVICE\TrustedInstaller`
  - 该目录的主组也是`TrustedInstaller`，这意味着默认情况下，该组成员对目录具有某些权限。

### 2. 访问控制列表（Access Control List, ACL）

#### 具体权限条目

1. **CREATOR OWNER Allow 268435456**
   - **CREATOR OWNER**：表示创建此对象的用户。此用户对自己创建的对象拥有特定权限。
   - **268435456**：这是一个十六进制的权限掩码（0x10000000），通常代表GENERIC_READ权限。

2. **NT AUTHORITY\SYSTEM Allow 268435456**
   - **SYSTEM**：这是一个具有最高权限的系统账户。
   - **268435456**：同样表示GENERIC_READ权限。

3. **NT AUTHORITY\SYSTEM Allow Modify, Synchronize**
   - **Modify**：允许更改文件内容。
   - **Synchronize**：允许对象用于同步操作。

4. **BUILTIN\Administrators Allow 268435456**
   - **Administrators**：本地管理员组。
   - **268435456**：GENERIC_READ权限。

5. **BUILTIN\Administrators Allow Modify, Synchronize**
   - **Modify**：允许更改文件内容。
   - **Synchronize**：允许对象用于同步操作。

6. **BUILTIN\Users Allow -1610612736**
   - **Users**：本地用户组。
   - **-1610612736**：这是一个负值，表示拒绝某些权限（拒绝GENERIC_WRITE和GENERIC_EXECUTE权限）。

7. **BUILTIN\Users Allow ReadAndExecute, Synchronize**
   - **ReadAndExecute**：允许读取和执行文件。
   - **Synchronize**：允许对象用于同步操作。

8. **NT SERVICE\TrustedInstaller Allow 268435456**
   - **TrustedInstaller**：这是Windows Modules Installer服务的特殊账户。
   - **268435456**：GENERIC_READ权限。

9. **NT SERVICE\TrustedInstaller Allow FullControl**
   - **FullControl**：完全控制权限，包括读取、写入、执行和修改权限。

10. **APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES Allow ReadAndExecute, Synchronize**
    - **ALL APPLICATION PACKAGES**：所有应用包，通常用于UWP（Universal Windows Platform）应用。
    - **ReadAndExecute**：允许读取和执行文件。
    - **Synchronize**：允许对象用于同步操作。

11. **APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES Allow -1610612736**
    - **-1610612736**：拒绝GENERIC_WRITE和GENERIC_EXECUTE权限。

12. **APPLICATION PACKAGE AUTHORITY\ALL RESTRICTED APPLICATION PACKAGES Allow ReadAndExecute, Synchronize**
    - **ALL RESTRICTED APPLICATION PACKAGES**：所有受限的应用包。
    - **ReadAndExecute**：允许读取和执行文件。
    - **Synchronize**：允许对象用于同步操作。

### 解释权限掩码

- **268435456 (0x10000000)**：通常代表GENERIC_READ权限，允许用户读取文件或目录内容。
- **-1610612736 (0xA0000000)**：负值，表示拒绝GENERIC_WRITE和GENERIC_EXECUTE权限。

### 结论

这个ACL表明，`C:\Windows\System32`目录具有严格的访问控制，以确保系统文件的安全性。`TrustedInstaller`和`SYSTEM`账户拥有最高权限，能够完全控制目录和文件，而普通用户组（`BUILTIN\Users`）仅有读取和执行权限。此外，UWP应用程序也受到限制，仅能读取和执行文件。



## 主要账户类型

- **用户账户 (User Accounts)**
   - [默认本地用户账户(default local user accounts) | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/security/identity-protection/access-control/local-accounts#default-local-user-accounts)
   - **本地账户 (Local Accounts)**: 仅在创建它们的计算机上有效。
   - **微软账户 (Microsoft Accounts)**: 允许用户在多个设备上同步设置和数据。
   - **域账户 (Domain Accounts)**: 在Active Directory域内使用，可在域内的多台计算机上使用。

- **系统账户 (System Accounts)**
   - [默认本地系统帐户(default local system accounts) | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/security/identity-protection/access-control/local-accounts#default-local-system-accounts)
   - **本地系统账户 (Local System Account)**: 一个高权限的本地账户，主要用于运行系统服务。
   - **本地服务账户 (Local Service Account)**: 一个权限较低的账户，运行具有较低权限的服务。
   - **网络服务账户 (Network Service Account)**: 一个具有更高网络权限的账户，用于运行需要网络访问的服务。


## 高级权限👺

windows操作系统中，**TrustedInstaller**、**System**和**Administrator**都是具有高度权限的账户或服务，负责管理和维护系统的不同方面。

### 权限比较

| 账户/服务名称    | 主要职责                               | 权限范围                                       | 受限部分                                     |
| ---------------- | -------------------------------------- | ---------------------------------------------- | -------------------------------------------- |
| TrustedInstaller | 安装、修改和删除系统组件和更新         | 相当高,有些地方称其媲美linux中的root权限       | 一般不面相用户,有提权方法和工具              |
| System           | 运行操作系统的核心服务和进程           | 系统服务的特殊权限,windows安装时的重要角色权限 | 一般不面相用户,有提权方法和工具              |
| Administrator    | 管理系统设置、安装软件、用户账户管理等 | 对大部分系统文件和注册表项有高权限             | 最常见的高级权限,但是不如linux中的root那么高 |

- **TrustedInstaller**：主要用于系统组件和更新的安装和管理，对某些关键系统文件有最高权限。
- **System**：用于运行系统核心服务和进程，具有对整个系统的完全控制权。
- **Administrator**：用于日常系统管理任务，虽然权限很高,但是比不上Linux中root权限的地位那么高，但在某些受保护的系统文件和设置方面受到限制。

| 权限等级         | 主要用途                                           | 权限级别 |
| ---------------- | -------------------------------------------------- | -------- |
| 普通用户         | 运行应用程序，日常操作                             | 低       |
| 管理员           | 安装/卸载软件，修改系统设置，管理用户              | 较高     |
| SYSTEM           | 运行系统服务和后台任务，几乎所有资源的访问权限     | 高       |
| TrustedInstaller | 修改和替换系统核心文件，保护操作系统文件和注册表键 | 最高     |

## windows中的管理员组和成员

- windows内置了一个管理员账户`Administrator`,在许多非官方镜像安装后默认就是`Adminstrator`
- 然而Microsoft为了安全起见,在系统安装完毕后会让禁用内置的`Adminstrator`账户,并且引导用户(第一个用户,一般是设备的拥有者)创建一个自己的用户账户,这个账户隶属于`Administrators`组
- 为了便于讨论,称这个用户自创的账户为`User1`,虽然`A1` 隶属于`Adminstrators`组,但是平时执行任务时的权限水平就是一个普通用户的水平
- 与一个不属于管理员账户的普通用户(为了便于讨论记为`U1`)不同的地方在于,`A1`在遇到需要`Administrator`权限时可以一般可以直接右键使用管理员权限运行,而真正普通用户`U1`在这种情况下需要输入某个管理员组内的用户的密码来获取授权(比如获取`A1`用户的账户密码),步骤上比较繁琐
- 这是windows处于安全考虑,并不会让`Administrators`组内的用户总是处于管理员权限,反之,大多数是以普通权限操作计算机(最常见的是以管理员权限运行命令行窗口);
- 只有windows内置的管理员账户`Administrator`才是常态以管理员权限执行任务了，这可能是许多非官方镜像修改版钟爱`Administrator`这个内置用户的原因,但是这显然不如使用自己创建的`A1`来的安全
- 也就是说,只有windwos内置的`Administrator`账户才比较接近`Linux`中的`root`用户
- 而其他非内置的`Administrators`用户运行需要管理员权限的任务时就想调用`sudo`命令一样
  - windows上Linux(Debian系)系统的`sudo`提权模块,比如`gsudo`
  - 在windows 24h2后开始内置`sudo`命令(代发者选项中启用)

### 普通用户间的访问权限

- 假设windwos 系统上的u1用户在功能目录`C:\temp`内创建了文件`f1`,那么另一个普通用户`u2`一般对`f1`可读可写可删除
- 但是如果`u1`用户在自己的家目录创建了`f2`文件,那么`u2`用户通常无法访问`f2`(甚至连第一层家目录都无法访问),而如果`u3`是属于管理员组的用户,那么可以通过调用管理员权限来访问(使用命令行要比使用资源管理器更快取得访问权限,一般不建议这么做,可能会导致被强行访问的`u1`用户内的某些凭证文件(比如`~/.ssh`内的文件发生权限异常))

## windows上提取和分配权限的方案👺

### gsudo

- [GitHub - gerardog/gsudo: Sudo for Windows](https://github.com/gerardog/gsudo)

### nsudo

- [NSudo/Manual/用户手册.md at master · M2TeamArchived/NSudo · GitHub](https://github.com/M2TeamArchived/NSudo/blob/master/Manual/用户手册.md)
- [Releases · M2TeamArchived/NSudo (github.com)](https://github.com/M2TeamArchived/NSudo/releases)

## windows用户权限

### 有效权限评估

[如何评估远程计算机上资源的有效权限 - Windows Server | Microsoft Learn](https://learn.microsoft.com/zh-cn/troubleshoot/windows-server/windows-security/access-checks-windows-apis-return-incorrect-results)

[Effective Permissions Tool for Files and Folders in Windows 11/10 (thewindowsclub.com)](https://www.thewindowsclub.com/effective-permissions-tool-windows)

- 例如设置某个文件夹的访问权限,有时候是比价复杂的,比如一个用户(记为`User1`)隶属于多个组,这些组有不同的权限,可能是相冲突的
- 那么这个用户的权限最终会是如何,我们可以借助windows自带的权限评估功能,相对直观的看出指定用户对于某个文件夹具有则样的权限

### 权限互补合并

在Windows中，用户的最终权限是多个权限的综合结果。当用户属于多个组时，Windows会将这些组的权限进行合并。具体来说：

- **读权限 (Read permissions)**: 允许用户查看文件和文件夹内容，但不能修改。
- **写权限 (Write permissions)**: 允许用户修改文件和文件夹内容。

如果User1同时属于G1和G2组，而G1组仅有读权限，G2组仅有写权限，那么User1对资源的最终权限将是这两者的综合。因此，User1将既有读权限又有写权限。总结如下：

- User1可以查看文件和文件夹内容（读权限）。
- User1可以修改文件和文件夹内容（写权限）。

最终权限可以用表格表示如下：

| 用户/组 | 读权限 (Read) | 写权限 (Write) |
| ------- | ------------- | -------------- |
| G1      | 是 (Yes)      | 否 (No)        |
| G2      | 否 (No)       | 是 (Yes)       |
| User1   | 是 (Yes)      | 是 (Yes)       |

因此，User1对文件和文件夹的权限是读写权限。

### 权限冲突覆盖

在Windows操作系统中，当用户属于多个组时，权限继承的冲突裁决规则如下：

> 设置Deny（拒绝）权限时，系统会提示
>
> You are setting a deny permissions entry. Deny entries take precedence over allow entries. This means that if a user is a member of two groups, one that is allowed a permission and another that is denied the same permission, the user is denied that permission.

#### 权限的计算

Windows通过计算用户对文件或目录的所有显式分配的权限来确定最终权限。具体步骤如下：

1. **累积允许的权限**：
   - 如果用户属于多个组，则这些组的允许权限是累积的。例如，如果用户属于`Group1`（拥有读取权限）和`Group2`（拥有写入权限），则用户将同时拥有读取和写入权限。

2. **应用拒绝的权限**：
   - 拒绝权限优先于允许权限。如果用户所属的任何组有拒绝权限，这些权限将覆盖所有允许权限。例如，如果用户属于`Group1`（允许读取和写入权限）和`Group2`（拒绝写入权限），则最终用户将只有读取权限，因为拒绝写入权限覆盖了允许写入权限。

示例

假设用户`Alice`属于以下组，并具有以下权限：

- **Group1**：允许读取 (`Read`), 允许写入 (`Write`)
- **Group2**：允许执行 (`Execute`)
- **Group3**：拒绝写入 (`Write`)

在这种情况下：

- **允许的权限**：`Read`、`Write`、`Execute`
- **拒绝的权限**：`Write`

最终权限：

- **结果权限**：`Read`、`Execute`
  - 拒绝写入权限优先，覆盖了允许写入权限。

#### 权限决策规则

1. **显式拒绝优先**：拒绝权限优先级高于允许权限。任何显式拒绝的权限将覆盖任何显式允许的权限。
2. **显式允许优先于继承的拒绝**：显式设置在对象上的允许权限优先于从父对象继承的拒绝权限。
3. **显式权限优先于继承权限**：直接设置在对象上的权限优先于从父对象继承的权限。

#### ACL中的顺序

- ACL（访问控制列表）中的条目顺序也影响权限的裁决。显式设置的拒绝权限条目通常放在ACL的前面，以确保这些拒绝权限被优先处理。

理解和正确配置权限是确保系统安全性和功能性的关键。管理员需要仔细管理权限，以确保用户拥有完成其任务所需的最小权限，同时避免不必要的权限冲突。

### 修改用户对于某个文件对象的访问权限

- 如果目标文件夹或文件设置的访问控制权限是继承的,那么可能会阻止你修改(即便你的权限是够的,但是功能上是冲突的)
- 为了修改,您可能需要关闭继承权限,然后再做权限修改