[toc]

## 命令行操作注册表

- 操作注册表时应当慎重，因为不当的修改可能会导致系统故障。如果不熟悉注册表的操作，建议尽量不要随意修改。

- 如果需要修改注册表，可以使用Windows操作系统自带的注册表编辑器（`regedit`），或者通过一些系统辅助软件来进行。


### 两类方法命令行方法

- 也可以用系统自带的命令行工具`reg`来修改,通过`reg /?`来获取使用帮助,或则在线搜索

- 详情查看文档:[Windows registry for advanced users - Windows Server | Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-server/performance/windows-registry-advanced-users#edit-the-registry)

- 相关的powershell函数:[Set-ItemProperty (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/set-itemproperty?view=powershell-7.4)


### 从reg文件导入注册表更改(通用)

- 此外,还有导入的方式进行修改(创建.reg文件导入):
  - [如何使用 .reg 文件添加、修改或删除注册表子项和值 - Microsoft 支持](https://support.microsoft.com/zh-cn/topic/如何使用-reg-文件添加-修改或删除注册表子项和值-9c7f37cf-a5e9-e1cd-c4fa-2a26218a1a23)
  - [How to add, modify, or delete registry subkeys and values by using a .reg file - Microsoft Support](https://support.microsoft.com/en-us/topic/how-to-add-modify-or-delete-registry-subkeys-and-values-by-using-a-reg-file-9c7f37cf-a5e9-e1cd-c4fa-2a26218a1a23)

## powershell操作注册表

主要有2个命令:`New-ItemProperty`,`Set-ItemProperty`

- ```powershell
  # 设置LargeSystemCache的值为1  
  Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1 -Type DWord  
    
  # 注意：上面的命令假设LargeSystemCache项已经存在。如果不存在，你需要先创建它。  
  # 但通常，这个项在Windows系统中是存在的，只是值可能不是1。  
    
  # 如果LargeSystemCache项不存在，你需要先创建它，然后再设置值。但PowerShell没有直接的命令来创建不存在的注册表项。  
  # 一种方法是使用New-ItemProperty，但如果你不确定项是否存在，你可以先检查它：  
    
  if (-NOT (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\LargeSystemCache")) {  
      # 如果项不存在，则创建它  
      New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1 -PropertyType DWord -Force  
  } else {  
      # 如果项存在，则直接设置值  
      Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1 -Type DWord  
  }
  ```

  

## reg命令操作注册表(通用)

- 注册表操作是一个危险操作(不恰当的修改容易导致系统崩溃)
  - 因此,当您确实需要编辑注册表的时候,一定要先备份
  - 备份特定注册表内容可以通过命令行进行(读取/备份操作是安全的,危险在于删除和修改)

- [reg commands | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/reg)
  -  Caution:Don't edit the registry directly unless you have no alternative. The registry editor bypasses standard safeguards, allowing settings that can degrade performance, damage your system, or even require you to reinstall Windows. You can safely alter most registry settings by using the programs in Control Panel or Microsoft Management Console (MMC). If you must edit the registry directly, back it up first.
  -  官方建议,编辑注册表应该使用windows提供的GUI程序
  -  但是为了高效配置,熟悉相关操作的用户可以用命令行来配置,便于部署环境



## 更新某个key👺

- 下面这个例子试图修改注册表中指定了限制系统环境变量`Path`的值(value)的的长度(或者说,将限制放宽为32000个字符)




### 推荐的流程

#### 方案1:

- ```bash
  #检查特定的key是否存在以及原来的值是多少:
  PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
  
  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
      LongPathsEnabled    REG_DWORD    0x0
     
  #确定无误后,开始修改
  #修改的第一步是删除掉该条目(但是这不是必须的!)
  PS C:\Users\cxxu\Desktop> reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
  Delete the registry value LongPathsEnabled (Yes/No)? yes
  The operation completed successfully.
  
  #开始设置新的值
  PS C:\Users\cxxu\Desktop> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 1
  The operation completed successfully.
  
  #再次查询该条目,确认修改后的值
  PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
  
  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
      LongPathsEnabled    REG_DWORD    0x1
  
  PS C:\Users\cxxu\Desktop>
  ```

#### 方案2:

- 另一种操作思路(覆盖)

  - ```bash
    #查询
    PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
    
    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
        LongPathsEnabled    REG_DWORD    0x1
        
    #尝试直接使用reg add覆盖已有的值
    PS C:\Users\cxxu\Desktop> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 0
    Value LongPathsEnabled exists, overwrite(Yes/No)? y
    The operation completed successfully.
    
    #再次查询修改结果
    PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
    
    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
        LongPathsEnabled    REG_DWORD    0x0
    
    ```

### 允许http链接映射为磁盘驱动器

- 下面的操作将是的windows能够将http链接映射为驱动器

- 首先,您需要使用管理员方式打开`cmd`或者`powershell`

- 如果目标明确,执行类似以下操作的命令

  - `reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2`

  - ```bash
    PS C:\repos\blogs> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2
    
    值 BasicAuthLevel 已存在，要覆盖吗(Yes/No)? yes
    操作成功完成。
    ```

