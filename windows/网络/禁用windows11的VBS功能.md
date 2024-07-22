[toc]



## 基于虚拟化的安全 (VBS)

[基于虚拟化的安全 (VBS) | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/design/device-experiences/oem-vbs)

[内存完整性启用 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/design/device-experiences/oem-hvci-enablement)



## 禁用虚拟化安全(VBS)

[Win11 VBS 安全功能 如何检测并关闭 - IT之家 (ithome.com)](https://www.ithome.com/0/579/260.htm)

#### 关闭VBS的命令行

管理员命令行执行:

```cmd
bcdedit /set hypervisorlaunchtype off
```

这条命令用于在Windows系统中修改启动配置数据(BCD)。

1. bcdedit: 这是Windows的命令行工具,用于管理启动配置数据(BCD)存储。BCD存储包含了引导加载配置数据,用于控制系统如何启动。

2. /set: 这是bcdedit的一个参数,表示要设置或修改一个选项。

3. hypervisorlaunchtype: 这是被修改的选项名称。Hypervisor是一种运行在硬件和操作系统之间的软件层,用于创建和运行虚拟机。

4. off: 这是设置的值,表示关闭。

整体来说,这条命令的作用是禁用Hypervisor的自动启动。执行此命令后,Windows将不会在启动时自动加载Hypervisor。

#### 这条命令的主要影响包括:

1. 禁用Hyper-V功能(如果已安装)。
2. 可能会禁用某些依赖于虚拟化的Windows安全功能,如基于虚拟化的安全性(VBS)、内存完整性等。
3. 可能会提高某些应用程序或游戏的性能,特别是那些与Hypervisor不兼容的程序。

需要注意的是:
- 执行此命令需要管理员权限。
- 更改后需要重启系统才能生效。
- 如果您想重新启用Hypervisor,可以使用命令:
  bcdedit /set hypervisorlaunchtype auto

在修改这些系统设置之前,请确保您了解其影响,并在必要时做好系统备份。

### 其他

要在PowerShell中禁用VBS（Virtualization Based Security），并删除指定的注册表项，可以使用以下脚本。

该脚本会先删除指定的注册表项，然后重启设备以应用更改。请确保以管理员身份运行PowerShell，以便具有必要的权限进行注册表修改和系统重启。

```powershell
# 禁用VBS并删除指定的注册表项
function Disable-VBS {
    try {
        # 删除注册表项 EnableVirtualizationBasedSecurity
        Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -ErrorAction Stop
        Write-Host "Successfully removed EnableVirtualizationBasedSecurity registry key."

        # 删除注册表项 RequirePlatformSecurityFeatures
        Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequirePlatformSecurityFeatures" -ErrorAction Stop
        Write-Host "Successfully removed RequirePlatformSecurityFeatures registry key."

        # 提示用户即将重启设备
        Write-Host "The system will restart in 10 seconds to apply changes."
        Start-Sleep -Seconds 10

        # 重启设备
        Restart-Computer -Force
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

# 调用函数禁用VBS
Disable-VBS
```

该脚本的详细步骤如下：

1. 定义一个名为`Disable-VBS`的函数。
2. 使用`Remove-ItemProperty`命令删除`EnableVirtualizationBasedSecurity`和`RequirePlatformSecurityFeatures`两个注册表项。
3. 如果删除操作成功，输出相应的成功信息。
4. 提示用户系统将在10秒后重启，以应用更改。
5. 使用`Restart-Computer`命令强制重启设备。
6. 如果在删除注册表项时发生错误，输出错误信息。

运行脚本时，请确保您已经备份了重要数据，因为重启操作会中断当前的工作进程。