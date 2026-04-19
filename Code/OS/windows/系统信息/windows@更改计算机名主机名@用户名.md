[toc]



## 获取windows系统设备的计算机名和用户名

在 Windows 系统中，通过命令行获取计算机名有多种方法

本节仅介绍最通用和简单的方法,还有更多方法,在后面介绍

推荐的方法应简单、高效，并且适用于大多数场景。根据这些标准，我推荐以下方法：

### 获取计算机名

最推荐方法：`hostname` 命令或`echo %ComputerName%`(for cmd)或`echo $env:ComputerName`(for powershell)

**理由：**
- 简单直接，只需一个命令。
- 不依赖于外部工具或复杂语法。
- 快速且在大多数 Windows 版本上都能使用。

操作示例

```powershell
PS> hostname
ColorfulCxxu

PS> cmd /c "echo %ComputerName%"
COLORFULCXXU
PS> echo $env:ComputerName
COLORFULCXXU
```



### 获取用户名

最推荐方法：`echo %USERNAME%`(for cmd)或者`echo $env:username`

**理由：**
- 简单直接，只需一个命令。
- 不依赖于外部工具或复杂语法。
- 快速且在大多数 Windows 版本上都能使用。

操作示例

1. 获取计算机名：
   - 打开命令提示符（可以按 `Win + R`，然后输入 `cmd`，按回车键）。
   - 输入 `hostname` 并按回车键。

2. 获取用户名：
   - 在同一个命令提示符窗口中，输入 `echo %USERNAME%` 并按回车键。
   
2. 示例
   
   ```powershell
   PS> echo $env:username
   cxxu
   PS> cmd /c "echo %username%"
   cxxu
   ```
   
   

这两种方法都非常简便、快速，并且易于记忆，适用于大多数日常使用场景。

## 获取计算机名方法列举

### 使用`ms-settings:system`打开设置获取计算机名

- 这种方法适用于win10之后的系统

- 您可以在设置中直接点击系统,就可以查看系统信息,里面包括计算机名
- 或者用`Win+R`快捷键输入`ms-settings:system`打开系统信息页面

### 使用 `hostname` 命令
`hostname` 命令是最简单的方法，只需要在命令行中输入：

```sh
hostname
```

这会直接返回计算机的主机名。

### 使用 `echo %COMPUTERNAME%`
可以使用环境变量 `COMPUTERNAME` 来获取计算机名。命令如下：

```sh
echo %COMPUTERNAME%
```

这个命令会输出计算机名。



### 使用 `systeminfo` 命令
`systeminfo` 命令可以获取详细的系统信息，其中包含计算机名。可以使用以下命令并在输出中查找 `主机名` 字段：

```sh
systeminfo | findstr /B /C:"主机名"
```

这个命令会筛选出包含计算机名的信息。

### 使用 PowerShell 命令
PowerShell 提供了更强大的脚本和命令处理能力。可以使用以下 PowerShell 命令获取计算机名：

```powershell
$env:COMPUTERNAME
```

或者：

```powershell
(Get-WmiObject -Class Win32_ComputerSystem).Name
```



## 获取当前登录用户的用户名列举

在 Windows 系统中，通过命令行获取当前用户名有多种方法。以下是几种常见的方法：

### 使用 `echo %USERNAME%`
可以使用环境变量 `USERNAME` 来获取当前用户名。命令如下：

```sh
echo %USERNAME%
```

这个命令会输出当前用户名。

### 使用 `whoami` 命令
`whoami` 命令会显示当前用户的用户名。命令如下：

```sh
whoami
```

这个命令会返回用户名以及域信息（如果有）。

### 使用 `wmic` 命令
可以使用 Windows Management Instrumentation Command-line (WMIC) 获取当前用户名。命令如下：

```sh
wmic useraccount where sid='%USERPROFILE:~10%' get name
```

这个命令会返回当前用户名。

### 使用 PowerShell 命令
PowerShell 提供了更强大的脚本和命令处理能力。可以使用以下 PowerShell 命令获取当前用户名：

```powershell
$env:USERNAME
```

或者：

```powershell
[System.Security.Principal.WindowsIdentity]::GetCurrent().Name
```



##  修改计算机名👺

###  CLI (powershell)

- 进入到**管理模式,切记**下运行(**run as administator**)

- `rename-computer <yourNewComputerName>`

  - DESCRIPTION

    > This cmdlet is only available on the Windows platform. The `Rename-Computer` cmdlet renames the local computer
    > or a remote computer. It renames one computer in each command.

    This cmdlet was introduced in Windows PowerShell 3.0.

- 例如:

  - ```powershell
    PS C:\Users\cxxu> Rename-Computer "New-PCName"
    WARNING: The changes will take effect after you restart the computer DESKTOP-CO17BQC.
    ```

  
  - 或者直接
  
    ```powershell
    Rename-Computer -NewName "NewNameTemp" -Force -Restart
    ```



### 注意事项

- 确保新计算机名在网络中是唯一的，避免名称冲突。
- 修改计算机名需要管理员权限。
- 修改计算机名后，某些依赖于计算机名的应用程序可能需要重新配置。



###  使用系统属性（GUI）

[重命名 Windows  电脑 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/重命名-windows-10-电脑-750bc75d-8ff8-e99a-b9dc-04dff566ae74)

- 您可以在命令行中输入`systemPropertiesAdvanced.exe`,进入系统属性(手动右键我的电脑也行);对于win10之后的系统,可以直接在开始菜单或者设置里搜索`重命名`或者`rename`
- 点击计算机名,包含更名菜单(注意不是描述,描述下有个更名按钮)
- 比较容易报错,推荐用上述的powershell的方式更改
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/5131f66de7bb41099c43bf275ae1c144.png)

## windows设备群和网络管理模式

在 Windows 系统中，**工作组（WorkGroup）** 和 **域（Domain）** 是两种不同的网络管理模式。它们的用途和管理方式各有特点，适用于不同规模和需求的网络环境。

### 工作组（WorkGroup）

**工作组** 是一种用于小型网络的对等（Peer-to-Peer）网络模式，适合家庭或小型办公室。每台计算机在工作组中都具有独立性，没有集中管理的机制。

#### 特点

1. **对等网络**：
   - 每台计算机都是独立的，没有专门的服务器或控制器来管理网络。

2. **本地账户**：
   - 用户账户和密码在每台计算机上单独管理。如果要访问另一台计算机的资源，需要在那台计算机上有相应的账户。

3. **简单设置**：
   - 配置简单，适用于少量计算机的网络环境。

4. **资源共享**：
   - 允许文件和打印机共享，但需要手动设置和管理权限。

#### 用途

- 家庭网络：适合家庭中几台计算机的互联互通。
- 小型办公室：适用于没有专门 IT 管理员的小型办公室。

### 域（Domain）

**域** 是一种**集中管理**的网络模式，适合中大型网络，通常用于企业环境。域提供了集中化的用户和资源管理，增强了安全性和管理效率。

#### 特点

1. **集中管理**：
   - 由域控制器（Domain Controller, DC）管理，存储所有用户账户、计算机和安全策略。

2. **域账户**：
   - 用户账户存储在域控制器上，用户可以在域内任何计算机上使用相同的凭证登录。

3. **集中策略**：
   - 使用组策略（Group Policy）来集中管理计算机和用户设置，增强安全性和一致性。

4. **扩展性**：
   - 适用于大规模网络，易于扩展和管理。

#### 用途

- 企业网络：适用于需要集中管理和高安全性的中大型企业网络。
- 学校和机构：适用于需要集中管理用户和资源的教育机构和其他组织。

## 两种网络模式的比较

| 特性           | 工作组（WorkGroup）                | 域（Domain）                           |
| -------------- | ---------------------------------- | -------------------------------------- |
| **管理方式**   | 每台计算机独立管理                 | 集中管理，由域控制器管理               |
| **用户账户**   | 本地账户，每台计算机单独管理       | 域账户，集中存储和管理                 |
| **资源共享**   | 需要手动配置，每台计算机单独设置   | 通过域控制器和组策略集中管理           |
| **安全性**     | 较低的安全性，依赖每台计算机的设置 | 高安全性，通过域控制器和组策略集中控制 |
| **适用环境**   | 家庭和小型办公室                   | 中大型企业和机构                       |
| **扩展性**     | 适用于少量计算机，扩展性有限       | 易于扩展，适用于大规模网络             |
| **设置复杂度** | 简单，适合没有专业 IT 管理员的环境 | 复杂，需要专业 IT 管理员进行配置和维护 |

### 示例

**工作组示例**：

1. 家庭网络中的三台计算机（PC1、PC2、PC3）都在同一个工作组 `HOMEGROUP` 中。
2. 每台计算机都有独立的用户账户和共享资源设置。
3. 用户需要在每台计算机上手动配置共享文件夹和打印机。

**域示例**：

1. 公司网络中的所有计算机都加入了域 `company.local`。
2. 域控制器 `DC1` 管理所有用户账户和计算机。
3. 用户可以在公司网络内的任何计算机上使用相同的域账户登录。
4. 通过组策略集中管理计算机和用户的设置，如软件安装、安全设置等。

### 总结

- **工作组**：适合小型、非专业管理的网络，配置简单，适用于家庭和小型办公室。
- **域**：适合需要集中管理和高安全性的中大型网络，配置复杂，但提供了更强大的管理和安全功能，适用于企业和机构。

通过了解工作组和域的特点和用途，可以根据具体需求选择合适的网络管理模式。