[toc]



## abstract

- windows中的本地账户中有一类是没有密码的,比如Administrator账户,一些魔改的镜像安装完默认就是一个无密码用户
- 这种用户除了表面上的安全问题,还会给网络共享等功能的使用带来不便,会引起各种安全检查不通过而被禁止的现象

## 此用户无法登录@账户被禁用问题

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/6f35188bc86943c28f1bbec19c02544c.png)

- 想要访问共享文件夹的当前客户端没有设置密码的情况下,默认情况下是会出问题的
- 典型的免密登录的Administrator账户,想用访问同网络的其他机器(作为服务端)上的共享文件夹一般需要显式的提供服务端允许的凭据(用户名和密码)才能够访问或挂载共享文件夹到资源管理器

### 访问共享文件夹时带上凭据

- 例如,服务端(`server`可以是计算机名`ComputerName`或者`ip`地址,前者需要启用**网络发现**);并假设有一个共享文件夹名为`share`;现在分发给其所在网络的其他用户一个公用的合法凭证:用户名为`smb`,密码为`1`,那么通常客户端可以用
  - `net use Q: \\server\share /user:smb 1`的命令行将服务端(server)的共享文件夹挂载到资源管理器汇中
  - 或者使用powershell的cmdlet来挂载`new-SmbMapping -LocalPath 'Q:' -RemotePath \\server\share -UserName smb -Password 1`;如果执行成功,那么重启资源管理器就可以看到盘符`Q`

### 错误案例和解决

- ```powershell
  PS C:\Users\Administrator> new-SmbMapping -LocalPath 'Q:' -RemotePath \\redmibookpc\share
  New-SmbMapping: 此用户无法登录，因为该帐户当前已被禁用。
  ```

- 我们追加凭据,即可

  ```powershell
  PS C:\Users\Administrator> new-SmbMapping -LocalPath 'Q:' -RemotePath \\redmibookpc\share -UserName smb -Password 1
  
  Status Local Path Remote Path
  ------ ---------- -----------
  OK     Q:         \\redmibookpc\share
  ```

  



## 两类登录方式

控制台登录（Console Logon）是指用户直接在计算机本地登录，即在计算机的物理控制台（例如显示器、键盘、鼠标）上进行登录。这与通过远程桌面（Remote Desktop）或其他远程访问方式进行登录有所不同。

在组策略的`Accounts: Limit local account use of blank passwords to console logon only`项目中描述了相关内容

### 控制台登录与远程登录的区别

1. **控制台登录（Console Logon）**：
   - 用户直接在计算机的物理设备上进行登录。
   - 典型的情景是用户坐在计算机前面，使用本地连接的键盘和显示器进行登录。
   - Windows系统在本地用户登录时称之为“控制台登录”。

2. **远程登录（Remote Logon）**：
   - 用户通过网络连接到远程计算机进行登录。
   - 典型的情景是用户使用远程桌面协议（RDP）或其他远程访问工具（如SSH、VNC）从另一台计算机连接到目标计算机。
   - Windows系统在用户通过远程桌面进行登录时称之为“远程登录”。

### 为什么限制空密码账户只允许控制台登录

限制空密码账户只允许控制台登录是一个安全措施。这一设置存在于Windows的安全策略中，默认情况下启用，以减少空密码账户被远程攻击利用的风险。启用该策略后：

- **只有本地控制台登录**：拥有空密码的账户只能在物理控制台上进行登录。
- **禁止远程登录**：如果尝试使用空密码账户通过远程桌面或其他远程连接方式进行登录，系统会拒绝连接请求。

### 相关安全策略

在组策略编辑器中，这一安全策略的完整路径和名称如下：

- **路径**：`Computer Configuration` > `Windows Settings` > `Security Settings` > `Local Policies` > `Security Options`
- **策略名称**：`Accounts: Limit local account use of blank passwords to console logon only`

当这一策略设置为“启用”（Enabled）时，拥有空密码的本地账户只能进行控制台登录，而无法通过远程桌面等方式进行远程登录。这在某种程度上可以保护系统免受基于网络的攻击，因为空密码账户极易成为攻击的目标。

### 如何修改该策略

如果必须允许空密码账户进行远程登录，可以禁用这一策略：

1. **打开组策略编辑器**：
   - 按 `Win + R` 键，输入 `gpedit.msc` 并按回车键。

2. **导航到策略位置**：
   - `Computer Configuration` > `Windows Settings` > `Security Settings` > `Local Policies` > `Security Options`

3. **修改策略**：
   - 找到 `Accounts: Limit local account use of blank passwords to console logon only`，双击它。
   - 在弹出的窗口中，将设置改为“Disabled”，然后点击“OK”。

### 注意事项

虽然可以通过禁用这一策略来允许空密码账户进行远程登录，但这样做会显著降低系统安全性。因此，强烈建议始终为所有账户设置密码，尤其是Administrator账户，以保护系统免受未经授权的访问。

## 启用允许被免密登录功能

这里提到的被免密登录是指,客户端仅凭借一个服务端计算机上存在的一个用户名(没有密码)而不需要密码就可以登录,比如用于远程桌面的登录凭证

如果目标设备上的Administrator账户没有密码，为了安全性和操作系统的限制，需要设置一个密码才能进行远程桌面连接。Windows系统默认不允许使用空密码的账户进行远程桌面连接。这是为了防止未经授权的访问并保护系统安全。



### 使用空密码进行远程桌面连接设置

尽管强烈不建议允许使用空密码登录，但如果必须这样做，可以通过修改组策略来允许空密码的账户进行远程桌面连接。请注意，这会降低系统的安全性。

#### 远程桌面链接的前提条件

首先您的被控制端(server)必须是windows 专业版以上或者是经过修补支持启用远程桌面的windwos版本

其次该功能默认是被关闭的,您需要手动启用它

最后如果server端有带有密码的用户,这可以作为客户端(Client)申请远程桌面控制的凭据

若server端仅提供给客户端一个无密码账户名,(比如Administrator,许多镜像网站魔改后的系统镜像安装完就是一个自动登录的Administrator账户),此时就需要做一些设置修改

也就是说,用无密码用户名登录可能会报错,一个实例如下:

`Remote Desktop ConnectionxA user account restriction (for example, a time-of-day restriction) is preventing you fromlogging on. For assistance, contact your system administrator or technical support.`



经过实验,下面修改**组策略**的方案以及**注册表**都可以成功达到目的,一般设置完成后不需要重启server计算机,但是如果没有生效,可以重启后检查效果,其中注册表方案比较有可能随着windows系统更新而不可用

### 组策略方案

#### 中文版步骤

1. **打开组策略编辑器**：
   - 按 `Win + R` 键，输入 `gpedit.msc` 并按回车键打开本地组策略编辑器。

2. **导航到相关设置**：
   - 在组策略编辑器中，依次展开 `计算机配置` > `Windows 设置` > `安全设置` > `本地策略` > `安全选项`。

3. **修改“帐户：使用空密码的本地帐户只允许进行控制台登录”策略**：
   - 找到“帐户：使用空密码的本地帐户只允许进行控制台登录”策略，双击它。
   - 在弹出的窗口中，将设置改为“已禁用”，然后点击“确定”。

#### 英文版步骤

**打开组策略编辑器**：

- 按 `Win + R` 键，输入 `gpedit.msc` 并按回车键打开本地组策略编辑器。

**导航到相关设置**：

- 在组策略编辑器中，依次展开 `Computer Configuration` > `Windows Settings` > `Security Settings` > `Local Policies` > `Security Options`。

**修改“Accounts: Limit local account use of blank passwords to console logon only”策略**：

- 找到“Accounts: Limit local account use of blank passwords to console logon only”策略，双击它。
- 在弹出的窗口中，将设置改为“Disabled”，然后点击“OK”。

### 修改注册表方案👺(一键修改)

您可以用GUI操作,但是这里提供两种方法,建议直接用命令行更方便快捷

#### GUI逐步修改注册表

1. **打开注册表编辑器**：

   - 按 `Win + R` 键，输入 `regedit` 并按回车键打开注册表编辑器。

2. **导航到相关键**：

   - 导航到以下路径：

     ```
     HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
     ```

3. **修改`LimitBlankPasswordUse`值**：

   - 找到名为 `LimitBlankPasswordUse` 的DWORD值，双击它。
   - 将值数据从 `1` 改为 `0`，然后点击“确定”。

#### 使用命令行(一键修改)👺

提供使用命令行(CMD)和PowerShell来实现该修改的方法,并给出详细解释。

##### 检查路径

首先检查一下对应注册表路径下的内容

```powershell
PS>$res=Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Lsa;$res

auditbasedirectories      : 0
auditbaseobjects          : 0
Authentication Packages   : {msv1_0}
Bounds                    : {0, 48, 0, 0…}
crashonauditfail          : 0
fullprivilegeauditing     : {0}
LimitBlankPasswordUse     : 1
NoLmHash                  : 1
....


PS> $res|select LimitBlankPasswordUse

LimitBlankPasswordUse
---------------------
                    1
```

- 例如我查询到的`LimitBlankPasswordUse`默认值为1

##### 执行修改

CMD 方式:

```
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f
```

PowerShell 方式:

```powershell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LimitBlankPasswordUse" -Value 0 -PropertyType DWORD -Force
```

详细解释:

1. CMD 命令解释:
   - `reg add`: 用于添加或修改注册表项的命令
   - `"HKLM\SYSTEM\CurrentControlSet\Control\Lsa"`: 目标注册表路径
   - `/v LimitBlankPasswordUse`: 指定要添加或修改的值名
   - `/t REG_DWORD`: 指定值的类型为DWORD
   - `/d 0`: 设置值为0
   - `/f`: 强制覆盖,不提示确认

2. PowerShell 命令解释:
   - `New-ItemProperty`: 用于创建新的注册表项属性
   - `-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"`: 指定注册表路径
   - `-Name "LimitBlankPasswordUse"`: 指定要创建的值名
   - `-Value 0`: 设置值为0
   - `-PropertyType DWORD`: 指定值的类型为DWORD
   - `-Force`: 强制执行,如果该值已存在则覆盖

这两个命令都会在指定的注册表路径下创建或修改 "LimitBlankPasswordUse" 值,并将其设置为0。这个修改允许使用没有密码的账户进行远程桌面登录。

#### 注意

1. 执行这些命令需要管理员权限。在CMD中,请以管理员身份运行命令提示符。在PowerShell中,请以管理员身份运行PowerShell。
2. 这个修改可能会降低系统安全性,请谨慎使用。
3. 更改注册表可能会影响系统稳定性,建议在执行前创建系统还原点。
4. 修改后可能需要重启系统才能生效。

### 免密账户登录远程桌面示例

完成上述步骤后，可以尝试使用远程桌面连接到目标设备：

1. **打开远程桌面连接**：
   - 按 `Win + R` 键，输入 `mstsc` 并按回车键打开远程桌面连接。

2. **输入目标设备的IP地址**：
   - 在“计算机”字段中输入目标设备的IP地址（例如 `192.168.1.100`），然后点击“连接”。

3. **输入凭据**：
   - 在弹出的对话框中，输入Administrator账户的用户名（`Administrator`）和空密码，然后点击“确定”。

### 注意事项

- 强烈建议为Administrator账户设置密码，以提升系统的安全性。
- 修改组策略和注册表可能会降低系统的安全性，因此在应用这些更改时需要特别小心，并且尽可能避免在生产环境中使用空密码的账户进行远程连接。

通过这些步骤，你可以在需要时实现使用空密码的Administrator账户进行远程桌面连接，但请务必考虑安全性问题。