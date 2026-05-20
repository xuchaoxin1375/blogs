[toc]

## 共享文件夹介绍

[Shared Folders: File and Storage Services | Microsoft Learn](https://learn.microsoft.com/zh-cn/previous-versions/windows/it-pro/windows-server-2003/cc781374(v=ws.10))

## 最佳实践

以下内容源自官方文档

### 将权限分配给组，而不是用户账户。

- 为组分配权限可以简化共享资源的管理，因为这样就可以在组中添加或删除用户，而无需重新分配权限。要拒绝所有对共享资源的访问，请拒绝 "完全控制 "权限。



### 在允许用户执行所需任务的前提下，分配最严格的权限。

- 例如，如果用户只需读取文件夹中的信息，而他们永远不会删除、创建或更改文件，则可分配 "读取 "权限。



### 如果用户在本地登录以访问共享资源（如终端服务器上的资源），则应使用 NTFS 文件系统权限或访问控制设置权限。

- 共享权限仅适用于通过网络访问共享资源的用户；不适用于本地登录的用户。在这种情况下，请使用 NTFS 和访问控制。有关更多信息，请参阅设置、查看、更改或删除文件和文件夹的权限。



### 组织资源，使具有相同安全要求的对象位于同一文件夹中。

- 例如，如果用户需要多个应用程序文件夹的 "读取 "权限，则应将应用程序文件夹存储在同一个父文件夹中。然后，共享父文件夹，而不是共享每个单独的应用程序文件夹。请注意，如果需要更改应用程序的位置，可能需要重新安装。



### 共享应用程序时，请将所有共享的应用程序整理到一个文件夹中。

- 将所有应用程序整理到一个文件夹中



### 为防止访问网络资源时出现问题，请勿拒绝 Everyone 组的权限。

- 除匿名登录组外，Everyone 组包括可以访问网络资源的任何人，包括访客账户。有关更多信息，请参阅组的默认安全设置和默认安全设置的差异。



### 避免明确拒绝共享资源的权限。

- 通常只有在要覆盖已分配的特定权限时，才有必要明确拒绝权限。



### 限制管理员组的成员资格并为其分配完全控制权限。

Limit membership in, and assign the Full Control permission to, the Administrators group.

即不要轻易让某个用户成为管理员,一旦成为管理员(组成员),就有对共享文件的完全控制权限

- 这使管理员能够管理应用程序软件并控制用户权限

### 在大多数情况下，不要更改 Everyone 组的默认权限（读取）。

- Everyone 组包括可以访问网络资源的任何人，包括访客账户。在大多数情况下，除非你希望用户能对共享资源中的文件和对象进行更改，否则不要更改此默认权限。有关共享权限的更多信息，请参阅共享权限。



### 使用域用户账户授予用户访问权限。

- 在运行 Windows XP Professional以上的windows并连接到域的计算机上，通过域用户账户而不是本地用户账户授予共享资源的访问权限。这样可以集中管理共享权限。



### 使用集中式数据文件夹。

- 通过集中式数据文件夹，您可以轻松管理资源和备份数据。



### 为共享资源使用直观、简短的标签。

- 这可确保用户和所有客户端操作系统都能轻松识别和访问共享资源。



### 使用防火墙。

- 防火墙可保护共享资源不被互联网访问。在 Windows XP 和 Windows Server 2003 系列中，您可以利用新的防火墙功能。
- 有关详细信息，请参阅 Internet 连接防火墙, Windows 防火墙。

## 查看和管理共享文件夹👺

- [查看当前有哪些电脑在连接自己电脑的共享文件夹-百度经验 (baidu.com)](https://jingyan.baidu.com/article/49711c61a26824fa441b7cba.html#:~:text=在计算机管理中点击“共享文件夹”。 4%2F7 点击后，鼠标双击右侧的“会话”。,5%2F7 这样，就会列出当前正在通过windows系统的共享功能连接和访问自己电脑中共享文件夹的其他电脑的情况。 显示的信息从左至右依次为：其他电脑登录本电脑所用的用户账户名称、其他电脑在局域网中的名称、其他电脑访问用的系统、打开的文件、其他电脑连接本电脑的时间等。)

- [Windows 10如何禁止专用于共享的账号从本地登录-百度经验 (baidu.com)](https://jingyan.baidu.com/article/6b97984de2c7441ca2b0bf16.html)


使用`compmgmt.msc`命令可以直接打开"**计算机管理**器"控制面板;

## 文件夹共享工具👺

- [局域网共享一键通 – 杏雨梨云启动维护系统 (xyboot.com)](https://www.xyboot.com/lanshare_onekey_ok/)
- 这个小软件可以提供了快速和简单的局域网共享文件夹设置(特别是提供了匿名访问的选项和Smb版本的选择)
  - 经过了解,使用匿名时,软件会启用Guest账户以提供匿名登录(作为匿名访客的标志),这可以在设备管理器中找到共享文件夹的会话(session)窗口中查看

## 修改组策略

### 允许不安全的登录

This policy setting determines if the SMB client will allow insecure guest logons to an SMB server.

If you enable this policy setting or if you do not configure this policy setting, the SMB client will allow insecure guest logons.

If you disable this policy setting, the SMB client will reject insecure guest logons.

If you enable signing, the SMB client will reject insecure guest logons.

Insecure guest logons are used by file servers to allow unauthenticated access to shared folders. While uncommon in an enterprise environment, insecure guest logons are frequently used by consumer Network Attached Storage (NAS) appliances acting as file servers. Windows file servers require authentication and do not use insecure guest logons by default. Since insecure guest logons are unauthenticated, important security features such as SMB Signing and SMB Encryption are disabled. As a result, clients that allow insecure guest logons are vulnerable to a variety of man-in-the-middle attacks that can result in data loss, data corruption, and exposure to malware. Additionally, any data written to a file server using an insecure guest logon is potentially accessible to anyone on the network. Microsoft recommends disabling insecure guest logons and configuring file servers to require authenticated access."

### 禁用对通信进行数字加密

Microsoft 网络服务器: 对通信进行数字签名(始终)

此安全设置确定 SMB 服务器组件是否要求进行数据包签名。

服务器消息块(SMB)协议为 Microsoft 文件和打印共享以及许多其他网络操作(如远程 Windows 管理)提供了基础。为了防止在传输过程中修改 SMB 数据包的“中间人”攻击，SMB 协议支持对 SMB 数据包进行数字签名。此策略设置确定在允许与 SMB 客户端进行进一步通信前是否必须协商 SMB 数据包签名。

如果启用此设置，则只有在 Microsoft 网络客户端同意执行 SMB 数据包签名时，Microsoft 网络服务器才会与该客户端通信。如果禁用此设置，则会在客户端和服务器之间协商 SMB 数据包签名。

默认设置:

对成员服务器禁用。
对域控制器启用。

注意

所有 Windows 操作系统都支持客户端 SMB 组件和服务器端 SMB 组件。在 Windows 2000 及更高版本中，是否启用或要求对客户端和服务器端 SMB 组件进行数据包签名受以下四种策略设置控制:
Microsoft 网络客户端: 对通信进行数字签名(始终) - 控制客户端 SMB 组件是否需要数据包签名。
Microsoft 网络客户端: 对通信进行数字签名(如果服务器允许) - 控制客户端 SMB 组件是否启用数据包签名。
Microsoft 网络服务器: 对通信进行数字签名(始终) - 控制服务器端 SMB 组件是否需要数据包签名。
Microsoft 网络服务器: 对通信进行数字签名(如果客户端允许) - 控制服务器端 SMB 组件是否启用数据包签名。
同样，如果要求客户端 SMB 签名，则该客户端将无法与未启用数据包签名的服务器建立会话。默认情况下，仅在域控制器上启用服务器端 SMB 签名。
如果启用了服务器端 SMB 签名，则将与已启用客户端 SMB 签名的客户端协商 SMB 数据包签名。
SMB 数据包签名可能会显著降低 SMB 性能，具体取决于方言版本、OS 版本、文件大小、处理器卸载能力和应用程序 IO 行为。

重要信息

为了使此策略在运行 Windows 2000 的计算机上生效，还必须启用服务器端数据包签名。若要启用服务器端 SMB 数据包签名，请设置以下策略:
Microsoft 网络服务器: 对通信进行数字签名(如果服务器允许)

对于要与 Windows NT 4.0 客户端协商签名的 Windows 2000 服务器，必须在 Windows 2000 服务器上将以下注册表值设置为 1:
HKLM\System\CurrentControlSet\Services\lanmanserver\parameters\enableW9xsecuritysignature
有关详细信息，请参考: https://go.microsoft.com/fwlink/?LinkID=787136。

