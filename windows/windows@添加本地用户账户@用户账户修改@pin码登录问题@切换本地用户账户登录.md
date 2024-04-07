[toc]

## abstract

- 针对windows 7之后的windows用户账户问题
- windows@添加本地用户账户@用户账户修改
- pin码登录问题@切换本地用户账户登录
- user vs account :在windows中文版中,有:**用户**(user),**账户**(account)这两个词
  - 相关的控制面板称为**用户账户**界面(相关概念还有**组**(Group)和**成员**(member))
  - 一般一个用户对应有一个账户,用户登录到指定账户,可以利用计算机资源

## 本地用户创建

- `netplwiz` 是 Windows 操作系统中的一个工具，全称为 "Network Users Accounts Wizard"，用于管理和配置用户账户设置。通过运行这个命令，你可以打开“用户账户”窗口，进行如下操作：

  1. 配置计算机登录选项，例如禁用或启用自动登录功能。
  2. 查看和编辑本地用户账户列表。
  3. 添加、删除或修改用户账户的密码和其他属性。

  要使用 `netplwiz` 命令，请按以下步骤操作：

  1. 打开命令提示符（CMD）或 PowerShell（以管理员身份运行）。
  2. 输入并执行命令 `netplwiz`。
  3. 将弹出“用户账户”窗口，你可以在此窗口中进行相应的账户设置和管理。

- `lusrmgr.msc` 是在 Windows 操作系统中用于本地用户和组管理的一个 Microsoft 管理控制台（MMC） snap-in（模块）。`lusrmgr.msc` 的全称是 “Local User and Group Manager”，这是一个 Microsoft Management Console (MMC) 的管理单元，主要用于在 Windows 操作系统中管理本地用户账户和本地组账户。通过这个工具，管理员可以方便地创建、删除用户账户，更改账户属性，管理用户密码，以及分配用户到不同的本地组中，从而控制用户的访问权限和系统资源。

  - 通过运行 `lusrmgr.msc`，您可以打开“本地用户和组”管理工具，进行如下操作：
    - 创建、删除和管理本地用户账户。
    - 创建、删除和管理本地组账户。
    - 设置用户账户属性，例如密码、账户状态（启用/禁用）等。
    - 将用户添加至或从组中移除。

  - 要在 Windows 中打开“本地用户和组”管理工具，请在“运行”对话框（Win + R 键打开）中输入 `lusrmgr.msc` 并回车。这将允许您以图形化界面的方式对本地用户和组进行详细管理。注意，此工具仅适用于 Windows Server 操作系统以及部分高级版本的 Windows 客户端操作系统（如 Windows 10 Pro 或更高版本）。

### 使用`netplwiz`程序创建和管理用户

- 该方法比较通用

- 按`win+r`

- 输入**netplwiz** 回车

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/2021011923164753.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210119231609855.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | 添加用户                                                     | 选择本地账户                                                 |      |

### 使用`lusrmgr.msc`创建和管理用户

- 也是windows自带的功能,和`netplwiz`类似

## 新系统GUI方法创建本地用户

- 新方法的界面比较现代化,但是却不如旧界面来的高效(旧方法不再被维护,但是简单起见,优先旧方法)

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/3ea8568f91df44769be816e352d3f117.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/669a3faa0b43422ebeb0c1ef46bec916.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/3d425aa9273549ed8629a03dded76c61.png) |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | win11从控制面板中跳转到新用户创建                            | win11添加本地用户的新方法                                    | 密码设置可以放空                                             |


## 命令行创建新用户

- [New-LocalUser (Microsoft.PowerShell.LocalAccounts) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.localaccounts/new-localuser?view=powershell-5.1)
  - 这是powershell5.1命令行程序中可以执行的命令

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

      


### 补充

- 在 PowerShell 中，用户和组管理是非常重要的一部分。
- 以下是一些用于管理本地用户和组的 PowerShell 命令及其详细说明：

### 创建本地用户：

```powershell
# 创建一个新的本地用户，不提供密码（用户首次登录时必须更改密码）
New-LocalUser -Name "UserName"

# 创建一个新的本地用户并设置密码
$passwordSecureString = ConvertTo-SecureString "SecurePassword123!" -AsPlainText -Force
New-LocalUser -Name "UserName" -Password $passwordSecureString

# 创建用户并设置更多属性
New-LocalUser -Name "UserName" -Description "User description" -PasswordNeverExpires $true
```


### **删除本地用户：**

```powershell
# 删除指定的本地用户
Remove-LocalUser -Name "UserName"
```

### **启用或禁用本地用户：**

```powershell
# 启用本地用户
Enable-LocalUser -Name "UserName"

# 禁用本地用户
Disable-LocalUser -Name "UserName"
```

### **设置本地用户密码：**

```powershell
# 更改现有用户的密码
$passwordSecureString = ConvertTo-SecureString "NewSecurePassword123!" -AsPlainText -Force
Set-LocalUser -Name "UserName" -Password $passwordSecureString
```

### **管理本地组：**

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

### **查询用户和组信息：**

```powershell
# 获取本地用户列表
Get-LocalUser

# 获取特定本地用户信息
Get-LocalUser -Name "UserName"

# 获取本地组列表
Get-LocalGroup

# 获取特定本地组成员
(Get-LocalGroupMember -Group "GroupName").Name
```



## Microsoft账户@互联网账户

- [有关 Windows 中帐户的帮助 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/有关-windows-中帐户的帮助-6c7a5522-c50b-460d-a0e9-c6fa7f806fae)

### 登录

- [Microsoft 帐户 | 主页](https://account.microsoft.com/?refd=login.live.com)
- 可以进行密码修改等操作

### 修改账户密码

- [更改密码 (live.com)](https://account.live.com/password/change?refd=account.microsoft.com&fref=home.banner.changepwd)
- [Change your Microsoft account password - Microsoft Support](https://support.microsoft.com/en-us/account-billing/change-your-microsoft-account-password-fdde885b-86da-2965-69fd-4871309ef1f1)

### 其他Microsoft账号相关链接

####  个人office

- [个人主页| Microsoft 365 (office.com)](https://www.office.com/?ui=zh-CN&rs=CN&auth=1)

#### 组织office

- [组织|Home | Microsoft 365 (office.com)](https://www.office.com/?auth=2&home=1)

#### oneNote

- 管理组织账号的onenote笔记本(用于删除笔记本清单中的历史/已废弃笔记本)

  - [org|OneNote | Microsoft 365 (office.com)](https://www.office.com/launch/onenote?auth=2&home=1)



## 账户PIN码登录

### 修复PIN不可更改的问题

#### 工具准备

- 这里借助第三方工具Dism++的文件浏览器
  - 中文名叫**春哥附体**
  - 作用是可以无视权限修改/删除某系文件(夹)(部分情况下)
  - 有时候可以处理管理员权限(Administraor也无法执行的操作)

#### 删除Ngc文件夹

- 如果你的计算机登录过学校或者工作组织的邮箱注册的微软账号,您的计算机可能受到意了之外的控制
  - 比如无法自由的修改PIN码等限制
  - 这时候可以考虑退出组织账号
- 但是有时候因为(保留文件)重置系统,导致登录选项@账号问题的出现
- 经过参考论坛,找到一个可能的解决办法
  - [Unable to change PIN for Sign-In - Microsoft Community](https://answers.microsoft.com/en-us/windows/forum/all/unable-to-change-pin-for-sign-in/64919f1b-3ac4-4bf7-852f-abdb99b905a0)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/8926e5cd913446b38997059241e6ce1d.png)


- 回到账户设置,发现可以设置PIN码
  - 但这并不一定奏效
  - 因为在设置的最后一步可能会报错失败!

#### 创建新账户设置PIN

- 新建一个账户尝试创建PIN,但这依然不一定成功

#### 重置计算机

- 如果真是这样,可能系统文件错误/缺失,可以考虑备份数据后,重置计算机
  - 保留数据重置会删除掉安装的程序,但是媒体文件(图片,视频)可以保留

##  同步Microsoft设置

- 注意,选择本地账户的话,将无法使用同步功能,可以通过切换改用microsoft账户登录以同步或备份系统设置

##  切换:本地账户和Microsoft账户登录windows

### 重复登录FAQ


- 注意,如果用来登录的账户在本设备上已经有的话(而且没有注销)那么可能会让你换一个账号登录



### 新旧windows版本的改变🎈

- win11 22H2之前的版本

  - [Switch your Windows 10 device to a local account - Microsoft Support](https://support.microsoft.com/en-us/windows/switch-your-windows-10-device-to-a-local-account-eb7e78a9-88ee-9bc3-8f06-831b56e339fd)
  - Save all your work.
  - In **Start** , select **Settings** > **Accounts** > **Your info**. 
  - Select **Sign in with a local account instead**.

  - | ![在这里插入图片描述](https://img-blog.csdnimg.cn/5e05da7d5fca4a6fa8cc9ef1f926b699.png) |
    | ------------------------------------------------------------ |
    | win11 22H2之前的版本                                         |

- win11之后的版本,如果还想要创建本地用户,可以借助`netplwiz.exe`来创建

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/5251d0ec6319412cb0878d2a55973bbd.png)

  



## 管理员账户相关设置

- [windows@管理员用户账户-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/135457247?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"135457247"%2C"source"%3A"xuchaoxin1375"})
