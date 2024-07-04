[toc]

## 相关命令行工具

[DISM 概述 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/what-is-dism?view=windows-11)

[powershell |DISM Module | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/dism/?view=windowsserver2022-ps)

### 安装可选功能

`Add-WindowsCapability` 和 `DISM /Add-Capability`

在Windows操作系统中，`Add-WindowsCapability` 和 `DISM`（Deployment Imaging Service and Management Tool）是两个用于管理系统功能和组件的命令行工具。

#### Add-WindowsCapability

`Add-WindowsCapability` 是一个用于添加或删除Windows功能的PowerShell cmdlet。它允许用户在系统上启用或禁用特定功能，而不需要重启计算机。

**示例：**

```powershell
Add-WindowsCapability -Online -Name <CapabilityName>
```

####  DISM /Add-Capability

`DISM` 是一个强大的工具，用于服务和准备Windows映像，包括Windows PE、Windows Recovery Environment（Windows RE）和Windows安装映像。DISM可以用来安装、卸载、配置和更新Windows功能、驱动程序和包。

**示例：**

```powershell
DISM /Online /Add-Capability /CapabilityName:<CapabilityName>
```



要检查当前系统已经安装了哪些可选功能和扩展模块，可以使用以下命令：

## 查看系统上的可选功能信息

使用PowerShell和`Get-WindowsOptionalFeature`

`Get-WindowsOptionalFeature` cmdlet 用于列出所有可选功能及其状态（已启用或已禁用）。

这里使用`-Online`选项来列出可选功能列表

**示例：**

1. 打开PowerShell（以**管理员身份**运行）。
2. 执行以下命令：

```powershell
Get-WindowsOptionalFeature -Online
```

这个命令会列出所有可选功能，并显示它们的安装状态。

### 使用DISM

`DISM` 命令行工具也可以用来列出所有可选功能及其状态。

**示例：**

1. 打开命令提示符（以管理员身份运行）或PowerShell。
2. 执行以下命令：

```powershell
DISM /Online /Get-Features
```

这个命令会列出所有可选功能及其状态。

### 使用`Get-WindowsCapability`

如果你想查看所有Windows能力（capabilities），可以使用 `Get-WindowsCapability` cmdlet。

**示例：**

1. 打开PowerShell（以管理员身份运行）。
2. 执行以下命令：

```powershell
Get-WindowsCapability -Online | Where-Object State -eq "Installed"
```

这个命令会列出所有已安装的Windows能力。

这些命令将帮助你检查当前系统上已经安装了哪些可选功能和扩展模块。

## 例

### 安装Wireless Display

要通过命令行安装Wireless Display（无线显示），你可以使用这两个工具中的任意一个。以下是具体步骤：

#### 使用Add-WindowsCapability

1. 打开PowerShell（以管理员身份运行）。
2. 执行以下命令：

```powershell
Add-WindowsCapability -Online -Name "WirelessDisplay.Connect"
```

#### 使用DISM

1. 打开命令提示符（以管理员身份运行）或PowerShell。
2. 执行以下命令：

```cmd
DISM /Online /Add-Capability /CapabilityName:App.WirelessDisplay.Connect~~~~0.0.1.0
```

演示

```cmd
PS> DISM /Online /Add-Capability /CapabilityName:App.WirelessDisplay.Connect~~~~0.0.1.0

Deployment Image Servicing and Management tool
Version: 10.0.22621.2792

Image Version: 10.0.22631.3810

[==========================100.0%==========================]
The operation completed successfully.
```

这两个命令将会在线安装Wireless Display功能，使你的Windows系统能够支持无线显示。

