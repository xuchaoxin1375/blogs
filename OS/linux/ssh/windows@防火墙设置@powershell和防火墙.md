[toc]

## abstract

windows中有多种方式可以设置防火墙,有图形界面方法(比如控制面板)

也可以通过命令行设置,比如传统的`netsh advfirewall`命令

PowerShell 提供了一系列的命令来管理 Windows 防火墙（Windows Defender 防火墙），这些命令可以帮助用户创建、删除、启用、禁用防火墙规则，以及查询防火墙的状态等。

- [NetSecurity Module | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/netsecurity/?view=windowsserver2022-ps)

以下是一些常用的与防火墙规则相关的 PowerShell 命令：

1. **Get-NetFirewallRule** - 查询现有的防火墙规则：
   
   ```powershell
   Get-NetFirewallRule
   ```
   
2. **New-NetFirewallRule** - 创建新的防火墙规则：
   ```powershell
   New-NetFirewallRule -Name "MyRule" -DisplayName "My Rule" -Protocol TCP -LocalPort 8080 -Action Allow
   ```
   这里创建了一个名为"MyRule"的新规则，允许通过TCP协议的8080端口的流量。

3. **Remove-NetFirewallRule** - 删除防火墙规则：
   ```powershell
   Remove-NetFirewallRule -Name "MyRule"
   ```
   使用规则名称来删除之前创建的"MyRule"规则。

4. **Set-NetFirewallRule** - 修改现有防火墙规则的属性：
   ```powershell
   Set-NetFirewallRule -Name "MyRule" -Enabled False
   ```
   这个命令会禁用名为"MyRule"的防火墙规则。

5. **Enable-NetFirewallRule** 和 **Disable-NetFirewallRule** - 启用或禁用防火墙规则：
   ```powershell
   Enable-NetFirewallRule -Name "MyRule"
   Disable-NetFirewallRule -Name "MyRule"
   ```
   这两个命令可以快速地启用或禁用指定的规则。

6. **Get-NetFirewallProfile** - 获取当前防火墙配置文件的信息：
   ```powershell
   Get-NetFirewallProfile
   ```

7. **Set-NetFirewallProfile** - 设置防火墙配置文件的状态：
   ```powershell
   Set-NetFirewallProfile -Profile Domain -Enabled False
   ```
   这个命令会关闭域配置文件下的防火墙。

以上命令展示了如何使用 PowerShell 来管理防火墙规则。请注意，在执行某些命令时可能需要管理员权限，并且更改防火墙设置时应谨慎操作以确保系统的安全性。