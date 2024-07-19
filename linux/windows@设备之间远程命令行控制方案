[toc]



## abstract

- 对于两台windows设备,统一网络下经常用远程桌面来控制(mstsc)
- 而用命令行来控制也是可以的,虽然windows主打可视化操作而非命令行,但是命令行也可以执行很多基础操作
- 命令行下,可以执行比如文件管理,资源下载,软件安装不在话下,也可以利用vscode等代码编辑器借助Remote-SSH远程编辑代码

### 为什么考虑命令行连接

- 命令行连接的一个好处在于资源消耗小,连接快捷,体验一致性好

  - 另外,现在windows命令行中也可以做到以管理员方式运行命令行

  - windows 11 24h2开始开发者模式中支持sudo运行

  - 而windows10也可以安装一些命令行工具比如`scoop`,然后下载诸如`gsudo`等工具实现类似效果

  - ```powershell
    PS> scoop search sudo
    Results from local buckets...
    
    Name    Version      Source Binaries
    ----    -------      ------ --------
    gsudo   2.4.4        main
    psutils 0.2023.06.28 main   sudo.ps1
    sudo    0.2020.01.26 main
    nsudo   8.2          extras
    ```

    

### 讨论主题

- 假设局域网内我有两台windows设备,如何在设备A用命令行控制另一台设备B?
  - 也就是说,把设备B作为server,设备A作为Client

## powershell远程控制

在局域网内，你可以通过多种方法在设备A上使用命令行控制设备B。下面介绍一种常见的方法，即使用PowerShell和Windows远程管理（WinRM）。

## 使用PowerShell远程管理

### 前提条件：
1. **启用WinRM服务**：WinRM服务需要在两台设备上启用。
2. **配置信任主机**：设备A需要信任设备B。
3. **用户权限**：确保你有足够的权限来执行远程命令。

### 步骤：

#### 1. 启用WinRM服务

在设备A和设备B上，都需要启用WinRM服务。打开PowerShell并运行以下命令：

```powershell
Enable-PSRemoting -Force
```

#### 2. 配置信任主机

在设备A上，配置信任主机，使其可以与设备B进行通信。假设设备B的IP地址是`$ip=192.168.1.198`：

```powershell
$ip=192.168.1.198 #根据自己的情况修改
```

配置设备B为信任设备

```powershell

Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$ip"
```

你可以用逗号分隔多个IP地址。如果你想信任所有主机，可以使用通配符`*`，但这可能会有安全风险：

```powershell
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*"
```

#### 3. 测试连接

在设备A上，使用以下命令测试与设备B的连接：

```powershell
Test-WsMan -ComputerName $ip
```

如果一切正常，你应该看到一个成功的响应。

例如

```powershell
PS C:\repos\scripts> Test-WsMan -ComputerName $ip

wsmid           : http://schemas.dmtf.org/wbem/wsman/identity/1/wsmanidentity.xsd
ProtocolVersion : http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd
ProductVendor   : Microsoft Corporation
ProductVersion  : OS: 0.0.0 SP: 0.0 Stack: 3.0
```



#### 4. 创建远程会话

在设备A上，创建一个到设备B的远程会话：

```powershell
$s = New-PSSession -ComputerName $ip -Credential (Get-Credential)
```

此命令会提示你输入设备B的用户名和密码。

#### 5. 运行远程命令

现在，你可以在设备A上运行命令来控制设备B。例如，查看设备B上的进程：

```powershell
Invoke-Command -Session $s -ScriptBlock { Get-Process }
```

#### 6. 关闭会话

完成操作后，记得关闭远程会话：

```powershell
Remove-PSSession -Session $s
```

### 例子

假设你想在设备A上获取设备B的主机名。你可以运行以下命令：

```powershell
Invoke-Command -Session $s -ScriptBlock { hostname}
```

```powershell
PS C:\Users\cxxu>  Invoke-Command -Session $s -ScriptBlock { hostname}
RedmiBookPC
```

而查看目录可能不会得到正确的结果

```powershell
PS C:\repos\scripts> invoke-command -Session $s -ScriptBlock {ls C:\share}

    Directory: C:\share

Mode                 LastWriteTime         Length Name              PSComputerName
----                 -------------         ------ ----              --------------
                                                                    192.168.1.198
                                                                    192.168.1.198
                                                                    192.168.1.198
                                                                    192.168.1.198
```

通过以上步骤，你就可以在设备A上通过命令行控制设备B了。如果在过程中遇到任何问题，请检查防火墙设置或用户权限。

### 小结

- 这种方式不是很优雅,连贯性和便利性不足

## SSH方案

- 参考它文 [windows@SSH远程控制@windows设备间使用OpenSSH CSDN博客](https://cxxu1375.blog.csdn.net/article/details/140308691)
