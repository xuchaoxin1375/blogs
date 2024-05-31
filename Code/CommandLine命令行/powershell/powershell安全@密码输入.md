[toc]

## refs

- [Microsoft.PowerShell.Security Module - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.security/?view=powershell-7.4)
- [向 PowerShell 函数添加凭据支持 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/learn/deep-dives/add-credentials-to-powershell-functions?view=powershell-7.4)

## 基础函数Get-Credential和PSCredential对象

[Get-Credential (Microsoft.PowerShell.Security) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.security/get-credential?view=powershell-7.4)

```powershell
$Cred = Get-Credential
$Cred = Get-Credential -Credential domain\user
$Cred = Get-Credential -UserName domain\user -Message 'Enter Password' #自动追加`: `提示
```

这三个 PowerShell 命令都使用 `Get-Credential` cmdlet 来创建一个 `PSCredential` 对象，该对象包含用户的用户名和密码。不同的是它们在获取这些信息时所用的参数和方法。

1. `$Cred = Get-Credential`

    这个命令会弹出一个对话框，要求用户输入用户名和密码。用户在图形界面中输入这些信息后，点击确定，`Get-Credential` 将这些信息封装在返回的 `PSCredential` 对象中。如果不输入用户名，对话框会自动填充当前用户的用户名。

2. `$Cred = Get-Credential -Credential domain\user`

    这个命令同样会弹出一个对话框，但是它会预填充用户名字段为 `domain\user`。用户只需要输入对应的密码即可。这个方法允许脚本的使用者提前指定用户名，从而简化用户的输入步骤。

3. `$Cred = Get-Credential -UserName domain\user -Message 'Enter Password'`

    这个命令会弹出一个对话框，其中用户名字段会被预填充为 `domain\user`，并且会显示一个自定义的消息 `'Enter Password'`。这个自定义消息可以用来给用户提供额外的指示或信息。用户输入密码后，`Get-Credential` 将这些信息封装在返回的 `PSCredential` 对象中。

在所有这些命令中，密码都会被存储为 `SecureString` 类型，以确保安全性。`Get-Credential` cmdlet 是一个方便的工具，它提供了一个标准的方法来提示用户输入凭据，并安全地处理这些凭据。

### 示例

`Get-Credential`读取收入后返回一个`PSCredential`对象实例

```powershell
PS C:\repos\scripts> $c=Get-Credential

PowerShell credential request
Enter your credentials.
User: smb
Password for user smb: *

PS C:\repos\scripts> $c.GetType()

IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     PSCredential                             System.Object
```

```powershell
PS C:\repos\scripts> $UserDemoCred = Get-Credential -Credential UserDemo

PowerShell credential request
Enter your credentials.
Password for user UserDemo: *

PS C:\repos\scripts> $UserDemoCred

UserName                     Password
--------                     --------
UserDemo System.Security.SecureString
#用户名不加密
PS C:\repos\scripts> $UserDemoCred.UserName
UserDemo
#密码加密
PS C:\repos\scripts> $UserDemoCred.Password
System.Security.SecureString
```

`Get-Credential`代替方法`PromptForCredential`

```powershell
PS C:\repos\scripts> $Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")

Need credentials
Please enter your user name and password.
User: smb
Password for user smb: *
```

## Get-Credential的分解实现

```powershell
#分别创建用户名和密码变量(密码加密输入)
PS C:\repos\scripts> $User = "Domain01\User01"
PS C:\repos\scripts> $PWord = Read-Host -Prompt 'Enter a Password' -AsSecureString
Enter a Password: *
#创建新的PSCredential对象(和Get-Credential返回的类型一致)
PS C:\repos\scripts> $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
#查看创建结果
PS C:\repos\scripts> $Credential.GetType()

IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     PSCredential                             System.Object
PS C:\repos\scripts> $Credential

UserName                            Password
--------                            --------
Domain01\User01 System.Security.SecureString
```



### 从终端读入用户名密码(非明文密码)

`Read-Host` 是 PowerShell 中用来从用户那里接收输入的命令。`-AsSecureString` 参数使得 `Read-Host` 命令返回一个 `SecureString` 对象，而不是普通的字符串。

这有助于提升安全性，因为 `SecureString` 对象用于存储敏感信息，如密码，在内存中以加密的形式保存数据。

使用 `-AsSecureString` 参数时，用户输入的文本不会显示在命令行界面上，**代替显示的是星号 (*)**，这样可以防止旁观者看到或者通过记录屏幕内容来获取密码。

这里是 `Read-Host -AsSecureString` 的详细用法：

```powershell
# 提示用户输入密码
$securePassword = Read-Host 'Enter password: ' -AsSecureString
```

在执行上述代码时，PowerShell 会显示 "Enter password" 提示，并等待用户输入。用户输入的密码会以星号 (*) 显示，以保护输入内容不被旁观者看见。

当用户完成密码输入并按下 Enter 键后，`Read-Host` 命令会将输入的密码作为 `SecureString` 对象存储在 `$securePassword` 变量中。



## 使用SecureString实例

`SecureString` 对象不像明文密码那样直接使用，因为它是加密的。

在 PowerShell 中，通常需要将 `SecureString` 转换为一个 `PSCredential` 对象，这样你就可以在各种需要凭据的命令中使用它。`PSCredential` 类型的对象通常用于存储和传递用户名和密码。

以下是如何从 `SecureString` 创建 `PSCredential` 对象的示例：

```powershell
# 从用户获取用户名
$username = Read-Host "Enter username"

# 从用户获取密码，返回 SecureString 对象
$securePassword = Read-Host "Enter password" +

# 创建 PSCredential 对象
$credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)
```

现在，你可以使用 `$credential` 对象作为凭据来运行需要认证的命令。



例如，如果你想使用这个凭据来连接到一个 PowerShell 会话或远程计算机，你可以这样做：

```
# 使用凭据连接到远程 PowerShell 会话
$session = New-PSSession -ComputerName "RemoteComputerName" -Credential $credential
```

遗憾的是,有时我们要调用的命令或工具不支持powershell的凭据参数,这让Credential用得不那么顺畅

### 使用NetworkCredential方法解出明文密码



在 PowerShell 中，当你有一个 `PSCredential` 对象时，可以调用它的 `GetNetworkCredential()` 方法来获取一个 `NetworkCredential` 对象。这个 `NetworkCredential` 对象是 .NET Framework 中的类型，它包含了解码的用户名、密码以及域等信息。

当你调用 `$credential.GetNetworkCredential().password`，你实际上是在执行以下步骤：

1. `$credential.GetNetworkCredential()` 从 `PSCredential` 对象中提取出一个 `NetworkCredential` 对象。
2. 然后，`.password` 属性访问 `NetworkCredential` 对象内部的密码字段，这个字段包含了解码后的密码，即明文密码。

这是一个获取存储在 `PSCredential` 对象中的密码明文的方法。由于这个密码是**明文形式**的，所以在处理时需要非常小心，以避免潜在的安全风险。

下面是一个示例代码，说明了如何在 PowerShell 脚本中使用这种方法：

```powershell
# 获取凭证
$credential = Get-Credential -User DemoUser

# 使用 GetNetworkCredential() 方法获取 NetworkCredential 对象
$networkCredential = $credential.GetNetworkCredential()

# 获取明文密码
$plainPassword = $networkCredential.Password

# 输出明文密码
Write-Host "The password is: $plainPassword"
```

请注意，尽管这个例子显示了如何获取和打印明文密码，但在实际应用中，你应该尽量避免将密码以明文形式展示或存储，除非绝对必要，并且在使用后应确保安全地处理相关变量和内存空间。

### 从SecureString解析出输入内容(不推荐)

`SecureString` 对象不能直接被读取或输出到 PowerShell 控制台，因为它是加密的。

如果你需要将 `SecureString` 转换为普通文本，可以使用 `System.Runtime.InteropServices.Marshal` 类的 `PtrToStringBSTR` 方法。

但是，请注意，这样做可能会降低密码的安全性，因为转换后的字符串是可见的普通文本。

```powershell
CopyInsert# 转换 SecureString 为普通文本（慎用）
$ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
```

上述代码将 `SecureString` 对象转换为普通文本字符串，但是这种方式应该尽量避免，除非你确实需要在某些情况下以纯文本形式处理密码。

在处理完密码后，应立即使用 `ZeroFreeBSTR` 方法来清除包含明文密码的内存。

### 应用

例如,如果你想使用这些凭据映射网络驱动器，可以这样使用 `net use` 命令：

