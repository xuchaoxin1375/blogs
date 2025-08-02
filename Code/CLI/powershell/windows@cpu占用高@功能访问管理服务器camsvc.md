[toc]

## abstract

- 有时功能访问管理服务器服务会占用大量cpu
- 这里提供powershell方法定位和禁用以及停止该服务的方法

## 分析

### 服务定位

```
PS> gsv -DisplayName 功能*

Status   Name               DisplayName
------   ----               -----------
Running  camsvc             功能访问管理器服务

```

### 服务功能

- Windows 的 **功能访问管理器服务**（`camsvc`，Capability Access Manager Service）是一项系统服务，用于管理 Windows 系统中应用程序对某些功能或设备的访问权限。它在 **隐私保护** 和 **权限管理** 方面起着重要作用，主要用于处理应用程序请求访问某些敏感的设备或数据资源，例如：

  - 摄像头
  - 麦克风
  - 位置服务
  - 通知权限

  当一个应用程序尝试访问这些设备时，`camsvc` 会负责检查是否有相应的权限设置，并根据用户的隐私配置决定是否允许访问。例如，当一个应用请求使用摄像头时，Windows 会提示用户同意或拒绝，并将这个权限记录下来。`camsvc` 服务就是在管理这些权限的请求和授权的过程。

  常见功能

  - **管理设备权限**：控制应用对摄像头、麦克风、位置信息等敏感设备的访问。
  - **权限记录**：维护应用程序的权限使用历史，帮助用户查看应用是否有权限访问某些功能。
  - **隐私保护**：提供一个集中的权限管理系统，帮助用户防止未经授权的访问。

  服务相关的信息

  - **服务名称**: `camsvc`
  - **显示名称**: Capability Access Manager Service
  - **启动类型**: 通常设置为“手动”，在某些情况下会自动启动。

  影响

  通常情况下，用户不需要手动管理这个服务，但如果禁用了此服务，某些应用程序可能无法访问需要的设备或功能，导致功能异常。例如，可能会导致应用无法调用摄像头或麦克风。

   

### 设置启动类型

```powershell
PS> Set-Service -Name camsvc -StartupType Disabled -Verbose
VERBOSE: Performing the operation "Set-Service" on target "功能访问管理器服务 (camsvc)".
```

### 停止服务

```
PS> spsv -name camsvc -Verbose
VERBOSE: Performing the operation "Stop-Service" on target "功能访问管理器服务 (camsvc)".
```

或者

```powershell
PS> gsv  camsvc |Stop-Service -Verbose
VERBOSE: Performing the operation "Stop-Service" on target "功能访问管理器服务 (camsvc)".
```

## 总结

### 模板

下面这一套连招可以适用于一般情况，比如设置打印机服务spooler，使用`gsv`命令查找是,可以试试`displayName`参数配合通配符进行

#### 一键禁用

```powershell
gsv camsvc|Set-Service -StartupType Disabled -PassThru -Verbose |spsv -Verbose -PassThru
```

#### 一键启用

```powershell
gsv camsvc|Set-Service -StartupType Automatic -PassThru -Verbose |sasv -Verbose -PassThru
```

### 演示

```
PS☀️[BAT:99%][MEM:49.59% (3.89/7.85)GB][8:23:44]
#⚡️[cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][C:\repos\scripts]{Git:main}
PS> gsv camsvc|Set-Service -StartupType Automatic -PassThru -Verbose |sasv -Verbose -PassThru
VERBOSE: Performing the operation "Set-Service" on target "功能访问管理器服务 (camsvc)".
VERBOSE: Performing the operation "Start-Service" on target "功能访问管理器服务 (camsvc)".

Status   Name               DisplayName
------   ----               -----------
Running  camsvc             功能访问管理器服务


PS☀️[BAT:99%][MEM:32.41% (2.54/7.85)GB][8:24:43]
#⚡️[cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][C:\repos\scripts]{Git:main}
PS> gsv camsvc|Set-Service -StartupType Disabled -PassThru -Verbose |spsv -Verbose -PassThru
VERBOSE: Performing the operation "Set-Service" on target "功能访问管理器服务 (camsvc)".
VERBOSE: Performing the operation "Stop-Service" on target "功能访问管理器服务 (camsvc)".

Status   Name               DisplayName
------   ----               -----------
Stopped  camsvc             功能访问管理器服务

```

