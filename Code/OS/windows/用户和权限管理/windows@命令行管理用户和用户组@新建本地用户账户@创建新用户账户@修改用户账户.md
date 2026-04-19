[toc]

## abstract

- 介绍windows powershell如何管理用户和组
- 创建和管理用户的命令行有两类

  - 传统的可以使用`net user`,`net localgroup`命令
  - `net `系列命令现在已经过时了,但是语法方便,所有许多地方还用到

- 另一方面,尽管`net`命令目前所有windows版本都可以用,它承担的功能有很多,powershell的这一套比较清晰

- 参考资料

  - [Net user | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/cc771865(v=ws.11))

  - [New-LocalUser (Microsoft.PowerShell.LocalAccounts) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.localaccounts/new-localuser?view=powershell-5.1)
    - 这是powershell5.1命令行程序中可以执行的命令
    - powershell 7某些版本直接执行可能会报错

## 命令行与用户管理



### net user本地帮助

```cmd
PS> net help user
此命令的语法是:

NET USER
[username [password | *] [options]] [/DOMAIN]
         username {password | *} /ADD [options] [/DOMAIN]
         username [/DELETE] [/DOMAIN]
         username [/TIMES:{times | ALL}]
         username [/ACTIVE: {YES | NO}]

NET USER 将创建并修改计算机上的用户帐户。在不使用命令开关的情况下，
将列出计算机的用户帐户。用户帐户信息存储在用户帐户数据库中。

username     为可添加、删除、修改或查看的用户帐户的名称。用户帐户名称
             最多可以有 20 个字符。
password     指定或更改用户帐户的密码。密码的长度必须符合 NET ACCOUNTS
             命令的 /MINPWLEN 选项所设置的最小长度。
             最多可以有 14 个字符。
*            生成密码提示。在密码提示下键入密码时，将不会显示密码。
/DOMAIN      在当前域的域控制器上执行此操作。
/ADD         向用户帐户数据库添加用户帐户。
/DELETE      从用户帐户数据库删除用户帐户。

选项         如下所示:

   选项                       描述
      --------------------------------------------------------------------
   /ACTIVE:{YES | NO}         激活或取消激活帐户。如果该帐户处于非激活状态 ，
                              用户将无法访问服务器。默认设置为“YES”。
   /COMMENT:"text"            提供有关用户帐户的描述性注释。请将文本用引号
                              括起来。
   /COUNTRYCODE:nnn           使用操作系统国家/地区代码执行指定的语言文件，
                              以显示用户帮助和错误消息。值 0 表示使用默认
                              的国家/地区代码。
   /EXPIRES:{date | NEVER}    如果设置了日期，可导致帐户过期。
                              NEVER 将帐户设置为无时间限制。
                              过期日期采用格式 mm/dd/yy(yy)。
                              月份可以是一个数字、完整字母拼写，
                              或使用三个字母的缩写。年份可以使用两位数字
                              或四位数字。使用斜线(/)(不留空格)
                              将日期的各个部分隔开。
   /FULLNAME:"name"           用户的全名(而不是用户名)。请将该名称用引号
                              括起来。
   /HOMEDIR:pathname          用户的主目录设置路径。该路径必须存在。
   /PASSWORDCHG:{YES | NO}    指定用户是否可以更改其密码。默认设置
                              为“YES”。
   /PASSWORDREQ:{YES | NO}    指定用户帐户是否必须拥有密码。
                              默认设置为“YES”。
   /LOGONPASSWORDCHG:{YES|NO} 指定用户是否应在下次登录时更改其密码。
                              默认设置为“NO”。
   /PROFILEPATH[:path]        为用户登录配置文件设置路径。
   /SCRIPTPATH:pathname       用户登录脚本的位置。
   /TIMES:{times | ALL}       登录小时数。TIMES 表示为
                              day[-day][,day[-day]],time[-time][,time
                              [-time]]，增量限制为 1 小时。
                              日期可以是完整拼写，也可以是缩写。
                              小时可以是 12 或 24 小时表示法。对于
                              12 小时表示法，请使用 am、pm、a.m. 或
                              p.m。ALL 表示用户始终可以登录，
                              空白值表示用户始终不能登录。使用逗号将日期和 时
                              间隔开，使用分号将多个日期和时间隔开。
   /USERCOMMENT:"text"        允许管理员添加或更改帐户的用户注释。
   /WORKSTATIONS:{computername[,...] | *}
                              列出用户可用于登录到网络的计算机，最多为八台 。
                              如果 /WORKSTATIONS 没有列表，或其列表为 *，
                              则用户可以通过任何计算机登录到网络。

NET HELP 命令 | MORE 显示帮助内容，一次显示一屏。
```



### 一览相关powershell命令

- ```powershell
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

### 权限

- 使用管理员权限打开powershell5.1命令行,可以尽可能减少权限问题导致的报错

## 创建新用户👺

可以用两类命令行方法,一类是powershell命令,一类是用`net user`命令

都支持指定密码或者不指定密码

### 创建具有密码的用户帐户

创建指定密码的账户使用powershell方法会更加安全但也更加复杂

而使用`net use`命令可以很简单

#### powershell New-LocalUser方法

PowerShell文档中的示例:创建密码字符串加密的用户

使用`Read-Host`读入字符串加密为密码

```powershell
$Password = Read-Host -AsSecureString
$params = @{
    Name        = 'User04'
    Password    = $Password
    FullName    = 'Third User'
    Description = 'Description of this account.'
}
New-LocalUser @params

```

第一个命令使用 `Read-Host` cmdlet 提示输入密码。 该命令将密码存储为 `$Password` 变量中的安全字符串。

第二个命令创建本地用户帐户，并将新帐户的密码设置为存储在 `$Password` 中的安全字符串。 该命令指定用户帐户的用户名、全名和说明。

```powershell
PowerShell 7.4.2
PS C:\Users\cxxu> $Password = Read-Host -AsSecureString
*
PS C:\Users\cxxu> $params = @{
>>     Name        = 'User03'
>>     Password    = $Password
>>     FullName    = 'Third User'
>>     Description = 'Description of this account.'
>> }
PS C:\Users\cxxu> New-LocalUser @params

Name   Enabled Description
----   ------- -----------
User03 True    Description of this account.
```

上述尝试是在windows10系统上执行的,powershell版本是7.4.2,更新到7.4.3也是可以执行的

然而,在其他windows版本(windows11)上某些版本可能会出现错误,详情查看下一节

##### powershell模块错误

- powershell模块异常时,无法顺利执行上述命令

  - 您可以考虑使用windows自带的powershell版本

    - ```
      PS C:\Users\cxxu\Desktop> powershell.exe
      Windows PowerShell
      Copyright (C) Microsoft Corporation. All rights reserved.
      
      Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows
      
      PS C:\Users\cxxu\Desktop> $PSVersionTable
      
      Name                           Value
      ----                           -----
      PSVersion                      5.1.22621.3672
      PSEdition                      Desktop
      PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
      BuildVersion                   10.0.22621.3672
      CLRVersion                     4.0.30319.42000
      WSManStackVersion              3.0
      PSRemotingProtocolVersion      2.3
      SerializationVersion           1.1.0.1
      ```

    - 然后利用管理员权限执行创建新用户的命令

相关可能遇到的错误详情

- [Running New-LocalUser in PowerShell 7.3 raises an error · Issue #18624 · PowerShell/PowerShell (github.com)](https://github.com/PowerShell/PowerShell/issues/18624)
- 在windows11上执行时遇到了如下错误

```powershell
Could not load type 'Microsoft.PowerShell.Telemetry.Internal.TelemetryAPI'
或者
New-LocalUser: Could not load type 'Microsoft.PowerShell.Telemetry.Internal.TelemetryAPI' from assembly 'System.Management.Automation, Version=7.4.3, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.
```

##### 解决方案

已知有两种方法可以解决

- 从powershell7 切换到windows自带的powershell版本,直接执行`powershell.exe`

- 执行导入语句

  ```powershell
   import-module microsoft.powershell.localaccounts -UseWindowsPowerShell
  ```

两种方案任选一种,然后执行创建用户的操作

##### 在自动化脚本中创建带有密码的用户

使用`CovertTo-SecureString`将字符串转换为加密字符串作为密码,这种方式适用于非交互式的自动化执行脚本内使用,如果条件允许,应当尽量用前面的方式,则尽量不要用下面的方式

```powershell
# 创建一个新的本地用户并设置密码(这种方式会暴露密码与终端里)
$passwordSecureString = ConvertTo-SecureString "pt123" -AsPlainText -Force
New-LocalUser -Name "UserName" -Password $passwordSecureString

```

也可以设置用不过期选项

```bash
# 创建用户并设置更多属性
New-LocalUser -Name "UserName" -Description "User description" -PasswordNeverExpires 
```

为了防止出错,依然要从上述可能报错的解决方案中使用导入语句` import-module microsoft.powershell.localaccounts -UseWindowsPowerShell`,然后执行上述代码

#### net user命令方法

创建一个带密码的用户

```cmd
net user NewUsername YourPassword /add
```

请将 `NewUsername` 替换为您想创建的用户名，将 `YourPassword` 替换为您想设置的密码。

还可以完成更多操作,但是这是一种不再被维护和推荐的方法,特别带有明文密码的方式不安全,除非这个账户目的是匿名访问计算机资源用途,比如访问共享文件夹



### 创建无密码用户

- 和有密码用户的创建方法类似,不适用密码参数即可
- 这种情况比较少用

### 创建密码不过期的账户👺

此类修改需要管理员权限!

#### powershell 快捷实现

如果想通过PowerShell实现，可以使用以下命令：

先用powershell直接创建一个用户(密码会过期),然后设置现有用户为密码不过期：

```powershell
Set-LocalUser "用户名" -PasswordNeverExpires $true
```

#### 使用cmd实现

先说结论:要在Windows上使用`net user`创建一个密码不过期的用户似乎是无法做到的

> 如果您的系统上powershell可以用,那么建议使用powershell方法

net user命令相关选项:(注意下面这些选项都无法设置**密码不过期**,尤其是`/expires`选项,并不是指密码不过期)

| Command-line option syntax                                   | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| /expires:{{<MM/DD/YYYY> \| <DD/MM/YYYY> \| <mmm,dd,YYYY>} \| never} | Causes the user account to expire if you specify the date. Expiration dates can be in [MM/DD/YYYY], [DD/MM/YYYY], or [mmm,dd,YYYY] formats, depending on the Country/Region code. Note that the account expires at the beginning of the specified date. For the month value, you can use numbers, spell it out, or use a three-letter abbreviation (that is, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec). You can use two or four numbers for the year value. Use commas or slashes to separate parts of the date. Do not use spaces. If you omit <YYYY>, the next occurrence of the date (that is, according to your computer's date and time) is assumed. For example, the following entries are equivalent if entered between Jan. 10, 1994, and Jan. 8, 1995:<br />jan,9<br/><br/>1/9/95<br/><br/>january,9,1995<br/><br/>1/9 |
| /passwordchg:{yes \| no}                                     | Specifies whether users can change their own password. The default is **yes**. |
| /passwordreq:{yes \| no}                                     | Specifies whether a user account must have a password. The default is **yes**. |

这里使用`wmic`命令行工具来设置和实现密码不过期

可以使用以下命令：(密码处使用`*`表示使用交互模式填写密码,而不明文显示密码,比较安全)

```cmd

#新建一个带密码的用户
net user <UserName> <password/*> /add /expires:never
#如果是对已有的账户操作,则跳过上一步骤
wmic useraccount where "Name='UserName'" Set PasswordExpires=false
```

对于已存在的账户，设置密码不过期可以使用：

案例:修改一个已经存在的用户`userx`的密码为永不过期属性

```cmd
PS> wmic useraccount where "Name='userx'" Set PasswordExpires=false
正在更新“\\BFXUXIAOXIN\ROOT\CIMV2:Win32_UserAccount.Domain="BFXUXIAOXIN",Name="userx"”的属性
属性更新成功。

PS[Mode:1][BAT:100%][MEM:57.13% (8.78/15.37)GB][Win 11 专业版@24H2:10.0.26100.2033][17:07:19][UP:1.86Days]
#⚡️[cxxu@BFXUXIAOXIN][<W:192.168.1.77>][C:\repos\configs]{Git:main}
PS> wmic useraccount where "Name='userx'" Set PasswordExpires=false^C

```

查询修改结果

```cmd

PS[Mode:1][BAT:100%][MEM:57.15% (8.78/15.37)GB][Win 11 专业版@24H2:10.0.26100.2033][17:07:25][UP:1.86Days]
#⚡️[cxxu@BFXUXIAOXIN][<W:192.168.1.77>][C:\repos\configs]{Git:main}
PS> net user userx
用户名                 userx
全名
注释
用户的注释
国家/地区代码          000 (系统默认值)
帐户启用               Yes
帐户到期               从不

上次设置密码           2024/10/23 16:39:30
密码到期               从不
密码可更改             2024/10/23 16:39:30
需要密码               Yes
用户可以更改密码       Yes

允许的工作站           All
登录脚本
用户配置文件
主目录
上次登录               从不

可允许的登录小时数     All

本地组成员             *Users
全局组成员             *None
命令成功完成。

```

可以看到账户和密码从不到期,也可以用lusrmgr来验证



在 Windows 系统中，你可以通过组策略或命令行工具来设置所有用户的密码不过期。具体步骤如下：

## 设置所有用户密码不过期

这是个降低安全性的操作,但是可以为一般情况提供方便

建议使用命令行`net accounts /maxpwage:unlimited`一键执行,更为方便(打开管理员权限命令行执行)

详情如下

### 通过组策略设置（适用于 Windows 专业版及以上版本）

1. **打开组策略编辑器**：
   - 按 `Win + R`，输入 `gpedit.msc`，回车打开“本地组策略编辑器”。

2. **导航到安全设置**：
   - 在组策略编辑器中，依次展开：
     ```
     计算机配置 → Windows 设置 → 安全设置 → 账户策略 → 密码策略
     ```

3. **修改“密码最长使用期限”**：
   - 找到并双击“密码最长使用期限”。
   - 在弹出的窗口中，将值设置为 `0`，这表示密码永不过期。
   - 点击“应用”并“确定”。

4. **应用更改**：
   - 关闭组策略编辑器，重启计算机或运行命令 `gpupdate /force` 强制更新组策略。

### 通过命令行（适用于所有 Windows 版本）

你可以使用 `net accounts` 命令设置所有用户的密码不过期。

1. **打开命令提示符**：
   - 按 `Win + R`，输入 `cmd`，按下 `Ctrl + Shift + Enter` 以管理员身份运行命令提示符。

2. **执行命令**：
   - 输入以下命令，设置密码永不过期：
     ```
     net accounts /maxpwage:unlimited
     ```

3. **验证设置**：
   - 你可以输入 `net accounts` 查看当前的密码策略设置。`Maximum password age (密码最长使用期限)` 应该显示为 `Unlimited`，表示密码永不过期。

### 通过 PowerShell 设置

如果你想针对特定用户设置密码不过期，可以使用 PowerShell 命令。

1. **打开 PowerShell**：
   - 按 `Win + R`，输入 `powershell`，按下 `Ctrl + Shift + Enter` 以管理员身份运行 PowerShell。

2. **执行命令**：
   - 针对所有用户执行以下命令：
     ```powershell
     Get-LocalUser | ForEach-Object { Set-LocalUser -Name $_.Name -PasswordNeverExpires $true }
     ```
   - 该命令会遍历所有本地用户，并设置每个用户的密码永不过期。





## 将用户归入用户组

- 在Windows操作系统中
  - 当你使用 `New-LocalUser` PowerShell cmdlet 创建新的本地用户时，默认情况下，新创建的用户不会被加入任何组
  - 可能有基础的权限,被当作`Everyone`的角色
- 使用`lusrmgr.exe`创建的用户默认归入到`Users`组

#### Users组

- 这个组通常对应于标准用户权限，拥有基本的文件访问和系统使用权限。
- 总之是一个相对受限的权限:`Users are prevented from making accidental or intentional system-wide changes and can run most applications`

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

  

## 加密和安全字符串

在PowerShell中，纯文本、加密字符串和安全字符串是处理敏感信息（如密码）时常用的三种类型。每种类型都有其特定的用途和使用场景。

### 加密字符串（Encrypted String）

加密字符串是将纯文本进行加密后得到的字符串。加密字符串在传输和存储时提供了一定的安全性，但仍然容易被解密。因此，加密字符串在某些场景下用来保护敏感信息，但不能完全依赖于其安全性。

### 安全字符串（Secure String）

安全字符串是一种在内存中以加密形式存储的字符串。它主要用于存储敏感信息，如密码。安全字符串不能直接读取其内容，需要通过特定的方法来获取其值。相对于纯文本和加密字符串，安全字符串提供了更高的安全性。

```
System.Security.SecureString
```



### 小结

- **纯文本**：适合非敏感信息，易读易用，但安全性低。
- **加密字符串**：适合传输和存储较敏感的信息，但需要注意其安全性不足的问题。
- **安全字符串**：适合处理高敏感信息，如密码，提供较高的安全性，但使用起来稍微复杂一些。

在处理敏感信息时，优先使用安全字符串，并尽量避免使用纯文本存储或传输敏感数据。在必须将安全字符串转换为其他形式时，务必小心处理，确保不会暴露敏感信息。

### 字符串安全类型转换

[ConvertTo-SecureString (Microsoft.PowerShell.Security) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7.4)

将**纯文本**或**加密字符串**转换为**安全字符串**。

[ConvertFrom-SecureString (Microsoft.PowerShell.Security) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.security/convertfrom-securestring?view=powershell-7.4)

将**安全字符串**转换为**加密的标准字符串**。

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



