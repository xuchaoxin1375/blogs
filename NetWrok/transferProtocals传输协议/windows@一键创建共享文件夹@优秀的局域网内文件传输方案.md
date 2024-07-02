[toc]



## 一键创建共享文件夹👺

### 简单操作步骤

如果您对共享文件夹创建细节不感兴趣,可以直接执行以下操作

- **管理员权限**打开一个`powershell`窗口

- 复制粘贴以下内容(如果需要,根据注释您可以手动修改相关变量来符合自己的需要)

  ```powershell
  #功能:快速创建一个可用的共享文件夹,能够让局域网内的用户访问您的共享文件夹
  # 使用前提要求:需要使用管理员权限窗口运行powershell命令行窗口
  
  #启用文件共享功能以及网络发现功能(后者是为了方便我们免ip访问,不是必须的)
  
  netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
  netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
  
  # 指定一个目录作为共享文件夹
  $p = 'C:\Share' #推荐尽可能短的目录(可以自定义,但是层级不宜深)
  $ShareName = 'Share' #如果您之前有过共享文件夹,并且名字也是Share,那么就需要修改名字
  $Permission = 'Change' #合法的值有:Read,Change,Full 权限从低到高 分别是只读(Read),可读可写(change),完全控制(full)
  # 指定专门用来访问共享文件夹的用户(这不是必须的,您可以用自己的用户和密码,但是不适合把自己的私人账户密码给别人访问,所以推荐建立一个专门的用户角色用于访问共享文件夹)
  $SmbUser = 'SmbUser' #如果本地已经有该用户，那么建议改名
  $password = '1' #密码可以改,但是建议尽可能简单,默认为1
  
  
  $exist = (Test-Path $p)
  if (! $exist)
  {
      mkdir $p
  }
  # 创建说明文件
  @'
  Files,folders,and links(symbolicLinks,JunctionLinks,HardLinks are supported to be shared )
  Others' can modify and read contents in the folder by defualt,you can change it 
  See more detail in https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbshare
  '@ > "$p\A Readme File@This is a shared folder! Place anything here to share with others.txt"
  
  
  # 创建共享文件夹
  "New-SmbShare -Name $ShareName -Path $p -${Permission}Access 'Everyone'" | Invoke-Expression #这里赋予任意用户修改权限(包含了可读权限和修改权限)
  $res = glu -Name "$SmbUser" -ErrorAction Ignore
  if (! $res)
  {
      # 权限要求:需要使用管理员权限窗口运行命令
      #方案1:使用net user 命令来创建带密码新用户(不要求安全性的共享凭证账户)
      net user $SmbUser $password /add /expires:never #这里添加的用户是永不过期的，更多参数查看官网文档
  
      #方案2:使用powershell方案来创建带密码新用户
      # $password = Read-Host "Enter password For $SmbUser" -AsSecureString
      # Import-Module microsoft.powershell.localaccounts -UseWindowsPowerShell
      # New-LocalUser -Name $SmbUser -Password $password -AccountNeverExpires 
  
  }
  
  ```

  Note:上述脚本非常适合电脑小白,如果您的计算机没有用过相关功能,那么执行完上述脚本,您的`C:\`下有一个`Share`目录,并且里面有一个说明文档

  现在,局域网内的其他设备就可以通过专用的账户`SmbUser`及其密码`1`来访问您创建的共享文件夹了,而且不会遇到权限问题,也不需要把自己私人的账户密码告诉给别人就可以让对方访问您的共享文件夹(这个对方也可以是您的其他设备,比如手机(需要软件支持,比如ES文件浏览器,Cx文件管理器等))

###  完整的演示流程参考

```powershell
实际演示

PS> glu

Name               Enabled Description
----               ------- -----------
Administrator      False   Built-in account for administering the computer/domain
cxxu               True
DefaultAccount     False   A user account managed by the system.
Guest              False   Built-in account for guest access to the computer/domain
smb                True
WDAGUtilityAccount False   A user account managed and used by the system for Windows…


PS> get-SmbShare

Name  ScopeName Path     Description
----  --------- ----     -----------
IPC$  *                  Remote IPC
share *         C:\share ColorfulCxxuShare


PS> #功能:快速创建一个

PS> # 使用前提要求:需要使用管理员权限窗口运行powershell命令行窗口


PS> #启用文件共享功能以及网络发现功能(后者是为了方便我们免ip访问,不是必须的)

PS> netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes

Updated 48 rule(s).
Ok.


PS> netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes

Updated 62 rule(s).
Ok.


PS> # 指定一个目录作为共享文件夹



PS> $p = 'C:\Share' #推荐尽可能短的目录(可以自定义,但是层级不宜深)



PS> $ShareName = 'ShareDemo' #如果您之前有过共享文件夹,并且名字也是Share,那么就需要修 改名字



PS> $Permission = 'Change' #合法的值有:Read,Change,Full 权限从低到高 分别是只读(Read),可读可写(change),完全控制(full)



PS> # 指定专门用来访问共享文件夹的用户(这不是必须的,您可以用自己的用户和密码,但是不适 合把自己的私人账户密码给别人访问,所以推荐建立一个专门的用户角色用于访问共享文件夹)


PS> $SmbUser = 'SmbUser' #如果本地已经有该用户，那么建议改名


PS> $password = '1' #密码可以改,但是建议尽可能简单,默认为1


PS> $exist = (Test-Path $p)



PS> if (! $exist)
>> {
>>     mkdir $p
>> }

PS> # 创建说明文件

PS> @'
>> Files,folders,and links(symbolicLinks,JunctionLinks,HardLinks are supported to be shared )
>> Others' can modify and read contents in the folder by defualt,you can change it
>> See more detail in https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbshare
>> '@ > "$p\A Readme File@This is a shared folder! Place anything here to share with others.txt"

PS> # 创建共享文件夹

PS> "New-SmbShare -Name $ShareName -Path $p -${Permission}Access 'Everyone'" | Invoke-Expression #这里赋予任意用户修改权限(包含了可读权限和修改权限)

Name      ScopeName Path     Description
----      --------- ----     -----------
ShareDemo *         C:\Share

PS> $res = glu -Name "$SmbUser" -ErrorAction Ignore


PS> if (! $res)
>> {
>>     # 权限要求:需要使用管理员权限窗口运行命令
>>     #方案1:使用net user 命令来创建带密码新用户(不要求安全性的共享凭证账户)
>>     net user $SmbUser $password /add /expires:never #这里添加的用户是永不过期的，更多参数查看官网文档
>>
>>     #方案2:使用powershell方案来创建带密码新用户
>>     # $password = Read-Host "Enter password For $SmbUser" -AsSecureString
>>     # Import-Module microsoft.powershell.localaccounts -UseWindowsPowerShell
>>     # New-LocalUser -Name $SmbUser -Password $password -AccountNeverExpires
>>
>> }
The command completed successfully.


PS> glu

Name               Enabled Description
----               ------- -----------
Administrator      False   Built-in account for administering the computer/domain
cxxu               True
DefaultAccount     False   A user account managed by the system.
Guest              False   Built-in account for guest access to the computer/domain
smb                True
SmbUser            True
WDAGUtilityAccount False   A user account managed and used by the system for Windows…


PS> get-SmbShare

Name      ScopeName Path     Description
----      --------- ----     -----------
IPC$      *                  Remote IPC
share     *         C:\share ColorfulCxxuShare
ShareDemo *         C:\Share


```

## 如何访问共享文件夹

另见它文

