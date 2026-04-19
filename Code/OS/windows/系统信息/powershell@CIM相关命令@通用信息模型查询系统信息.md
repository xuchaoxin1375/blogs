[toc]

## abstract

- 本文介绍CimCmdlet模块,对应的文档为:[CimCmdlets Module - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/cimcmdlets)

- 包含与通用信息模型 (CIM) 服务器（例如 Windows Management Instrumentation (WMI) 服务）进行交互的 cmdlet。

  此模块仅在 Windows 平台上可用。

## powershell中CIM相关命令

CimCmdlets 是一组 PowerShell cmdlets，专门设计用于与基于 CIM (Common Information Model) 标准的管理系统进行交互，尤其是 Windows Management Instrumentation (WMI)。这些 cmdlets 作为 PowerShell 的一部分提供，旨在简化和增强对系统管理信息的访问和操作能力。CimCmdlets 主要在 PowerShell 3.0 及以后的版本中引入，并逐渐成为推荐的与 WMI 交互的方式。

CimCmdlets 包括但不限于以下常用命令：

- `Get-CimInstance`: 用于查询和获取CIM类的实例，类似于旧版的 `Get-WMIObject`。
- `Set-CimInstance`: 修改现有CIM类实例的属性值。
- `New-CimInstance`: 创建新的CIM类实例。
- `Remove-CimInstance`: 删除CIM类的实例。
- `Invoke-CimMethod`: 调用CIM类实例上的方法。
- `Register-CimIndicationEvent`: 注册事件，以便在CIM对象发生变化时接收通知。
- `Get-CimClass`: 获取CIM类的定义。
- `Get-CimSession`: 管理与本地或远程计算机建立的CIM会话。
- `New-CimSession`, `Remove-CimSession`: 分别用于创建和删除CIM会话。

这些 cmdlets 通过使用 WS-Man (Web Services for Management) 协议，使得与远程系统以及支持 CIM 的非Windows系统的交互更为高效和灵活。它们是进行系统管理自动化、监控和配置的重要工具。

### 全部和CIM相关的命令

```powershell
PS> gcm *-cim*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Get-CimAssociatedInstance                          7.0.0.0    CimCmdlets
Cmdlet          Get-CimClass                                       7.0.0.0    CimCmdlets
Cmdlet          Get-CimInstance                                    7.0.0.0    CimCmdlets
Cmdlet          Get-CimSession                                     7.0.0.0    CimCmdlets
Cmdlet          Invoke-CimMethod                                   7.0.0.0    CimCmdlets
Cmdlet          New-CimInstance                                    7.0.0.0    CimCmdlets
Cmdlet          New-CimSession                                     7.0.0.0    CimCmdlets
Cmdlet          New-CimSessionOption                               7.0.0.0    CimCmdlets
Cmdlet          Register-CimIndicationEvent                        7.0.0.0    CimCmdlets
Cmdlet          Remove-CimInstance                                 7.0.0.0    CimCmdlets
Cmdlet          Remove-CimSession                                  7.0.0.0    CimCmdlets
Cmdlet          Set-CimInstance                                    7.0.0.0    CimCmdlets
Application     Register-CimProvider.exe                           10.0.2262… C:\WINDOWS\system32\Register-CimProvider…
```

### 查询信息的CIM命令

- ```
  PS> gcm get-cim*|^ name
  
  Name
  ----
  Get-CimAssociatedInstance
  Get-CimClass
  Get-CimInstance
  Get-CimSession
  ```

- 这四个 PowerShell 命令都是与 CIM（Common Information Model）相关的，用于管理和查询系统信息。
- 下面是每个命令的基本用途和对比：

### 1. Get-CimAssociatedInstance

- **用途**: 此命令用于获取与指定 CIM 实例关联的其他实例。它通常用于探索WMI对象之间的关系，比如获取某个服务依赖的其他服务。
- **示例**: 如果你有一个进程实例，你可以使用此命令来获取该进程所属的所有线程。

### 2. Get-CimClass

- **用途**: 用于获取CIM类的定义。CIM类定义了可以在管理系统中找到的对象类型及其属性和方法。
- **示例**: 你可以使用此命令获取 `Win32_Process` 类的详细信息，了解该类包含哪些属性和方法，从而更好地构造查询。

### 3. Get-CimInstance👺

- **用途**: 这是最常用的命令，用于从CIM/WMI检索具体的实例数据。你可以查询诸如系统服务、进程、硬件配置等信息。
- **示例**: 查询当前系统上正在运行的所有进程，或者获取特定服务的状态。

### 4. Get-CimSession

- **用途**: 此命令用于获取已建立的CIM会话信息。CIM会话是在本地或远程计算机上执行管理任务的基础，特别是当你需要多次执行操作时，建立会话可以提高效率和安全性。
- **示例**: 列出所有活动的CIM会话，查看它们的目标计算机和建立会话时使用的凭据。

### 总结

- **目标与作用域**:
  - `Get-CimAssociatedInstance` 更专注于对象间的关系，帮助深入探索某一实例的上下文环境。
  - `Get-CimClass` 关注于结构和定义，帮助理解可以查询和操作的数据模型。
  - `Get-CimInstance` 直接获取数据实例，是最直接的查询命令，广泛应用于各种信息收集场景。
  - `Get-CimSession` 管理会话状态，是进行持续或复杂管理操作的基础设施。

- **使用场景**:
  - 当你需要具体的数据（如服务状态、硬件信息）时，使用 `Get-CimInstance`。
  - 在需要了解数据模型细节以便构建精确查询时，选择 `Get-CimClass`。
  - 探索对象间关系或获取相关联数据时，采用 `Get-CimAssociatedInstance`。
  - 管理会话生命周期和优化远程管理操作时，则使用 `Get-CimSession`。

