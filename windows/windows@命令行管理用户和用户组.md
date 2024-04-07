[toc]

## abstract

- 介绍windows powershell如何管理用户和组
- cmd下也有命令行工具:在Windows Command Prompt（CMD）中创建新用户，可以使用`net user`命令。
- 但是cmd不是讨论的重点,尽管`net`命令目前所有windows版本都可以用,它承担的功能有很多,powershell的这一套比较清晰
- 有关net的用法另外参考资料

## 命令行与用户管理



### 一览

- 相关命令

  ```powershell
  PS>gcm *user*,*group*|?{$_.CommandType -eq 'cmdlet'}
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Cmdlet          Add-LocalGroupMember                               1.0.0.0    Micros…
  Cmdlet          Add-VMGroupMember                                  2.0.0.0    Hyper-V
  Cmdlet          Copy-UserInternationalSettingsToSystem             2.1.0.0    Intern…
  Cmdlet          Disable-LocalUser                                  1.0.0.0    Micros…
  Cmdlet          Enable-LocalUser                                   1.0.0.0    Micros…
  Cmdlet          Get-LocalGroup                                     1.0.0.0    Micros…
  Cmdlet          Get-LocalGroupMember                               1.0.0.0    Micros…
  Cmdlet          Get-LocalUser                                      1.0.0.0    Micros…
  Cmdlet          Get-VMGroup                                        2.0.0.0    Hyper-V
  Cmdlet          Get-WinUserLanguageList                            2.1.0.0    Intern…
  Cmdlet          Group-Object                                       7.0.0.0    Micros…
  Cmdlet          New-LocalGroup                                     1.0.0.0    Micros…
  Cmdlet          New-LocalUser                                      1.0.0.0    Micros…
  Cmdlet          New-VMGroup                                        2.0.0.0    Hyper-V
  Cmdlet          New-WinUserLanguageList                            2.1.0.0    Intern…
  Cmdlet          Remove-LocalGroup                                  1.0.0.0    Micros…
  Cmdlet          Remove-LocalGroupMember                            1.0.0.0    Micros…
  Cmdlet          Remove-LocalUser                                   1.0.0.0    Micros…
  Cmdlet          Remove-VMGroup                                     2.0.0.0    Hyper-V
  Cmdlet          Remove-VMGroupMember                               2.0.0.0    Hyper-V
  Cmdlet          Rename-LocalGroup                                  1.0.0.0    Micros…
  Cmdlet          Rename-LocalUser                                   1.0.0.0    Micros…
  Cmdlet          Rename-VMGroup                                     2.0.0.0    Hyper-V
  Cmdlet          Set-LocalGroup                                     1.0.0.0    Micros…
  Cmdlet          Set-LocalUser                                      1.0.0.0    Micros…
  Cmdlet          Set-WinUserLanguageList                            2.1.0.0    Intern…
  
  ```

- 浓缩一下

  - ```bash
    PS>gcm |?{$_.Source -eq 'Microsoft.PowerShell.LocalAccounts'}
    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    Cmdlet          Add-LocalGroupMember                               1.0.0.0    Micros…
    Cmdlet          Disable-LocalUser                                  1.0.0.0    Micros…
    Cmdlet          Enable-LocalUser                                   1.0.0.0    Micros…
    Cmdlet          Get-LocalGroup                                     1.0.0.0    Micros…
    Cmdlet          Get-LocalGroupMember                               1.0.0.0    Micros…
    Cmdlet          Get-LocalUser                                      1.0.0.0    Micros…
    Cmdlet          New-LocalGroup                                     1.0.0.0    Micros…
    Cmdlet          New-LocalUser                                      1.0.0.0    Micros…
    Cmdlet          Remove-LocalGroup                                  1.0.0.0    Micros…
    Cmdlet          Remove-LocalGroupMember                            1.0.0.0    Micros…
    Cmdlet          Remove-LocalUser                                   1.0.0.0    Micros…
    Cmdlet          Rename-LocalGroup                                  1.0.0.0    Micros…
    Cmdlet          Rename-LocalUser                                   1.0.0.0    Micros…
    Cmdlet          Set-LocalGroup                                     1.0.0.0    Micros…
    Cmdlet          Set-LocalUser                                      1.0.0.0    Micros…
    ```

### 这些命令的别名

- ```bash
  PS>gcm |?{$_.Source -eq 'Microsoft.PowerShell.LocalAccounts'}|%{gal -Definition  $_.Name}
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Alias           algm -> Add-LocalGroupMember                       1.0.0.0    Micros…
  Alias           dlu -> Disable-LocalUser                           1.0.0.0    Micros…
  Alias           elu -> Enable-LocalUser                            1.0.0.0    Micros…
  Alias           glg -> Get-LocalGroup                              1.0.0.0    Micros…
  Alias           glgm -> Get-LocalGroupMember                       1.0.0.0    Micros…
  Alias           glu -> Get-LocalUser                               1.0.0.0    Micros…
  Alias           nlg -> New-LocalGroup                              1.0.0.0    Micros…
  Alias           nlu -> New-LocalUser                               1.0.0.0    Micros…
  Alias           rlg -> Remove-LocalGroup                           1.0.0.0    Micros…
  Alias           rlgm -> Remove-LocalGroupMember                    1.0.0.0    Micros…
  Alias           rlu -> Remove-LocalUser                            1.0.0.0    Micros…
  Alias           rnlg -> Rename-LocalGroup                          1.0.0.0    Micros…
  Alias           rnlu -> Rename-LocalUser                           1.0.0.0    Micros…
  Alias           slg -> Set-LocalGroup                              1.0.0.0    Micros…
  Alias           slu -> Set-LocalUser                               1.0.0.0    Micros…
  
  ```

- 别名规律执行`get-verb`进行归纳

- [New-LocalUser (Microsoft.PowerShell.LocalAccounts) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.localaccounts/new-localuser?view=powershell-5.1)
  - 这是powershell5.1命令行程序中可以执行的命令

### 权限

- 使用管理员权限打开powershell5.1命令行,可以尽可能减少权限问题导致的报错

## 创建新用户😊



### 创建本地用户

```powershell
# 创建一个新的本地用户，不提供密码（用户首次登录时必须更改密码）
New-LocalUser -Name "UserName"

# 创建一个新的本地用户并设置密码
$passwordSecureString = ConvertTo-SecureString "SecurePassword123!" -AsPlainText -Force
New-LocalUser -Name "UserName" -Password $passwordSecureString


```

其他:

```bash
# 创建用户并设置更多属性
New-LocalUser -Name "UserName" -Description "User description" -PasswordNeverExpires $true
```

### 归入用户组(可选操作)

- 在Windows操作系统中
  - 当你使用 `New-LocalUser` PowerShell cmdlet 创建新的本地用户时，默认情况下，新创建的用户不会被加入任何组
  - 可能有基础的权限,被当作`Everyone`的角色
- 使用`lusrmgr.exe`创建的用户默认归入到`Users`组

#### Users组

- 这个组通常对应于标准用户权限，拥有基本的文件访问和系统使用权限。
- 总之是一个相对受限的权限:Users are prevented from making accidental or intentional system-wide changes and can run most applications

#### 用户权限调整@提升为管理员😊

- 如果你需要将新用户加入到其他特定的组中，可以在创建用户后，使用 `Add-LocalGroupMember` cmdlet 将新用户添加至所需用户组。

- 详情查看命令文档

- 例如，将新用户加入到 "Administrators" 组：

  ```powershell
  # 将新用户添加至 "Administrators" 组
  Add-LocalGroupMember -Group "Administrators" -Member UserName
  ```

### 查看用户属于哪些组

- `lusrmgr`GUI程序支持查看用户所属的组

- 而命令行也可以,稍微编写一下:

  - ```powershell
    
    function Get-LocalGroupOfUser
    {
        <# 
        .SYNOPSIS
        查询用户所在的本地组,可能有多个结果
        功能类似于lusrmgr中的Member of,即可以用lusrmgr GUI查看
        .EXAMPLE
        PS>get-LocalGroupOfUser cxxu
        docker-users
        Administrators
        PS>get-LocalGroupOfUser usertest
        Administrators
        PS>get-LocalGroupOfUser NotExistUser
        #>
        param (
            $UserName
        )
        
        Get-LocalGroup | ForEach-Object {
            $members = Get-LocalGroupMember -Group $_ 
            # return $members
            foreach ($member in $members)
            {
                $name = ($member.name -split '\\')[-1]#
                if ( $name -match $UserName)
                {
                    
                    Write-Host "$_" -ForegroundColor Magenta
                    return
                } 
            }
        }
        
    }
    ```

    



### FAQ

#### New-LocalUser 执行报错

- powershell7执行`New-LocalUser`失败(可能会被修复)

  - 改问题的讨论情况:[Running New-LocalUser in PowerShell 7.3 raises an error · Issue #18624 · PowerShell/PowerShell · GitHub](https://github.com/PowerShell/PowerShell/issues/18624)

  - 有人提出使用以下语句来修复,确实有效

  - ```bash
    import-module microsoft.powershell.localaccounts -UseWindowsPowerShell
    ```

- 或直接用windows自带的powershell5.1执行`New-LocalUser`命令

### 创建单个或少数用户的推荐做法

- 创建一个带有密码的本地账户

  - ```powershell
    #读取一串字符串作为密码
    $Password = Read-Host -AsSecureString
    #设置其他参数(HashTable)
    $params = @{
        Name        = 'User03'
        Password    = $Password
        FullName    = 'Third User'
        Description = 'Description of this account.'
    }
    #调用New-LocalUser 和设定好的参数
    New-LocalUser @params
    
    ```

  - 执行结果:

    - ```bash
      Name    Enabled  Description
      ----    -------  -----------
      User03  True     Description of this account.
      ```

### 创建大量测试用户的做法

- 使用交互式方式输入密码可以有较高的安全性,但是却不便于创建较多用户,特别是当这些用户不作为正常用户而只是临时使用,则考虑以下做法

- 在 PowerShell 中，如果您需要批量创建多个用户，一种常见的做法是通过读取 CSV 文件或数组中的数据，然后循环遍历这些数据并逐个调用 `New-LocalUser` 或 `New-ADUser` 来创建用户。

- 如果只考虑创建临时用户而不注重任何安全性,则利用循环创建有规律的用户('user1','user2',...,;密码可以全部设置成一样,或者'1','2',...)

- 实操

  - 下面创建3个用户,密码都是1

  - ```bash
    PS C:\WINDOWS\system32> $password=ConvertTo-SecureString -String '1' -AsPlainText -Force
    PS C:\WINDOWS\system32> foreach ($i in 1..3){
    >> New-LocalUser -Name "UserForTest$i" -Description "test User for demo($i)" -Password $password
    >> }
    
    Name         Enabled Description
    ----         ------- -----------
    UserForTest1 True    test User for demo(1)
    UserForTest2 True    test User for demo(2)
    UserForTest3 True    test User for demo(3)
    ```

    

- 检查

  - ```bash
    PS C:\WINDOWS\system32> Get-LocalUser -Name userForTest*
    
    Name         Enabled Description
    ----         ------- -----------
    UserForTest1 True    test User for demo(1)
    UserForTest2 True    test User for demo(2)
    UserForTest3 True    test User for demo(3)
    ```

  - 批量移除这些账户(注意通配符匹配出来的账户没有非测试账户,否则会造成误删)

  - ```bash
    PS C:\WINDOWS\system32> Get-LocalUser -Name userForTest*|Remove-LocalUser
    ```

  - 删除后重新检查,如果漏掉哪个,可以手动调用`remove-localuser`删除

  


## 补充

- 对于操作系统而言,用户和组管理是非常重要的一部分。

### 查询用户和组信息😊

```powershell
# 获取本地用户列表
Get-LocalUser

# 获取特定本地用户信息
Get-LocalUser -Name "UserName"

```

- ```bash
  PS>Get-LocalUser
  
  Name               Enabled Description
  ----               ------- -----------
  Administrator      False   Built-in account for administering the computer/domain
  cxxu               True
  DefaultAccount     False   A user account managed by the system.
  Guest              False   Built-in account for guest access to the computer/domain
  smb                True
  User03             True    Description of this account.
  WDAGUtilityAccount False   A user account managed and used by the system for Windows Defender Application Guard scenar…
  
  ```

```powershell
# 获取本地组列表
Get-LocalGroup

# 获取特定本地组成员
(Get-LocalGroupMember -Group "GroupName").Name
```

- ```bash
  PS>
  Name                                Description
  ----                                -----------
  docker-users                        Users of Docker Desktop
  __vmware__                          VMware User Group
  Access Control Assistance Operators Members of this group can remotely query
                                      authorization attributes and permissions for
                                      resources on this computer.
  Administrators                      Administrators have complete and unrestricted
                                      access to the computer/domain
  Backup Operators                    Backup Operators can override security
                                      restrictions for the sole purpose of backing up
                                      or restoring files
  Cryptographic Operators             Members are authorized to perform cryptographic
                                      operations.
  Device Owners                       Members of this group can change system-wide
                                      settings.
  Distributed COM Users               Members are allowed to launch, activate and use
                                      Distributed COM objects on this machine.
  Event Log Readers                   Members of this group can read event logs from
                                      local machine
  Guests                              Guests have the same access as members of the
                                      Users group by default, except for the Guest
  ```

  



### 删除本地用户：

```powershell
# 删除指定的本地用户
Remove-LocalUser -Name "UserName"
```

### 启用或禁用本地用户：

```powershell
# 启用本地用户
Enable-LocalUser -Name "UserName"

# 禁用本地用户
Disable-LocalUser -Name "UserName"
```

### 设置本地用户密码：

```powershell
# 更改现有用户的密码
$passwordSecureString = ConvertTo-SecureString "NewSecurePassword123!" -AsPlainText -Force
Set-LocalUser -Name "UserName" -Password $passwordSecureString
```

### 管理本地组以及组内用户

```powershell
# 创建新的本地组
New-LocalGroup -Name "GroupName"

# 添加用户到本地组
Add-LocalGroupMember -Group "GroupName" -Member "UserName"

# 从本地组中移除用户
Remove-LocalGroupMember -Group "GroupName" -Member "UserName"

# 删除本地组
Remove-LocalGroup -Name "GroupName"
```

### 管理员用户创建

- 创建一个管理员用户或将普通用户提升为管理员

- 确保当前的powershell是以管理员方式启动,以powershell5.1环境下执行

- ```bash
  #查询当前管理员组内哪些个用户
  PS C:\WINDOWS\system32> Get-LocalGroupMember -Name Administrators
  
  ObjectClass Name                       PrincipalSource
  ----------- ----                       ---------------
  User        COLORFULCXXU\Administrator Local
  User        COLORFULCXXU\cxxu          MicrosoftAccount
  
  #添加用户UserTest到管理员组
  PS C:\WINDOWS\system32> Add-LocalGroupMember -Group Administrators -Member UserTest
  
  #检查是否添加成功,可以看到对应用户出现在了管理员组内
  PS C:\WINDOWS\system32> Get-LocalGroupMember -Name Administrators
  
  ObjectClass Name                       PrincipalSource
  ----------- ----                       ---------------
  User        COLORFULCXXU\Administrator Local
  User        COLORFULCXXU\cxxu          MicrosoftAccount
  User        COLORFULCXXU\UserTest      Local
  ```

## 总结

- 以下是这些 PowerShell 命令的简要总结：(上述讨论并没有全部提及,仅讨论了最常用的部分)

  1. **Add-LocalGroupMember**: 此命令用于将用户或计算机账户添加到本地用户组中。例如，将用户添加到名为 "GroupA" 的本地用户组：
     ```powershell
     Add-LocalGroupMember -Group "GroupA" -Member "User1"
     ```

  2. **Disable-LocalUser**: 此命令用于禁用一个本地用户账户，使其无法登录系统。
     ```powershell
     Disable-LocalUser -Name "User1"
     ```

  3. **Enable-LocalUser**: 此命令用于启用已被禁用的本地用户账户，使用户能够再次登录系统。
     ```powershell
     Enable-LocalUser -Name "User1"
     ```

  4. **Get-LocalGroup**: 此命令用于获取本地计算机上的用户组信息，可以列出所有本地用户组或查询指定用户组的详细信息。
     ```powershell
     Get-LocalGroup
     ```

  5. **Get-LocalGroupMember**: 此命令用于获取指定本地用户组中的成员列表，显示该组内包含的所有用户和/或计算机账户。
     ```powershell
     Get-LocalGroupMember -Group "GroupA"
     ```

  6. **Get-LocalUser**: 此命令用于获取本地计算机上的用户账户信息，可以列出所有本地用户或查询指定用户的详细信息。
     ```powershell
     Get-LocalUser
     ```

  7. **New-LocalGroup**: 此命令用于在本地计算机上创建新的用户组。
     ```powershell
     New-LocalGroup -Name "NewGroup"
     ```

  8. **New-LocalUser**: 此命令用于在本地计算机上创建新的用户账户。
     ```powershell
     New-LocalUser -Name "NewUser"
     ```

  9. **Remove-LocalGroup**: 此命令用于从本地计算机上删除指定的用户组。
     ```powershell
     Remove-LocalGroup -Name "GroupA"
     ```

  10. **Remove-LocalGroupMember**: 此命令用于从本地用户组中移除指定的用户或计算机账户。
      ```powershell
      Remove-LocalGroupMember -Group "GroupA" -Member "User1"
      ```

  11. **Remove-LocalUser**: 此命令用于从本地计算机上永久删除指定的用户账户。
      ```powershell
      Remove-LocalUser -Name "User1"
      ```

  12. **Rename-LocalGroup**: 此命令用于更改本地用户组的名称。
      ```powershell
      Rename-LocalGroup -Name "OldGroupName" -NewName "NewGroupName"
      ```

  13. **Rename-LocalUser**: 此命令用于更改本地用户账户的名称。
      ```powershell
      Rename-LocalUser -Name "OldUserName" -NewName "NewUserName"
      ```

  14. **Set-LocalGroup**: 此命令用于更改本地用户组的属性，如描述信息等。
      ```powershell
      Set-LocalGroup -Name "GroupA" -Description "New group description"
      ```

  15. **Set-LocalUser**: 此命令用于更改本地用户账户的属性，如密码、账户是否启用、密码永不过期等。
      ```powershell
      $passwordSecureString = ConvertTo-SecureString "NewPassword" -AsPlainText -Force
      Set-LocalUser -Name "User1" -Password $passwordSecureString -PasswordNeverExpires $true
      ```



