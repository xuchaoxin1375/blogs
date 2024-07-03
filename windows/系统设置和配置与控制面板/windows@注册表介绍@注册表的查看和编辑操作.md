[toc]

# 介绍windows的注册表

## abstract

- Windows注册表是Microsoft Windows操作系统中的一个核心数据库，用于存储系统和应用程序的设置信息。
  - 早在Windows 3.0推出OLE技术时，注册表就已经出现，但直到Windows 95操作系统开始，注册表才真正成为Windows用户经常接触的内容，并在其后的操作系统中继续沿用。
  - 注册表在整个系统中起着核心作用，直接控制着Windows的启动、硬件驱动程序的装载以及一些Windows应用程序的运行。

- 本文介绍注册表的基本信息和查看操作,修改注册表的方法详见参考文档
- 声明:作为一个学习者的初步学习记录,本文可能出现许多不准确的地方

## refs

主要来自Microsoft官方文档和wikipedia,前者建明扼要,后者介绍了其他一些相关信息

- [Windows registry for advanced users - Windows Server | Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-server/performance/windows-registry-advanced-users)
- [Windows Registry - Wikipedia](https://en.wikipedia.org/wiki/Windows_Registry)




## 注册表的主要组件包括

### 根键极其缩写名称👺

1. **根键（Root Keys）**：注册表的顶级层次

   1. **HKEY_CLASSES_ROOT (HKCR)**：包含文件扩展名与相应应用程序之间的关联信息，以及系统中注册的COM组件和类的信息。
   2. **HKEY_CURRENT_USER (HKCU)**：存储当前用户的个人配置信息，如桌面背景、文件夹选项等。
   3. **HKEY_LOCAL_MACHINE (HKLM)**：存储计算机的全局配置信息，如硬件、操作系统设置等。
   4. **HKEY_USERS (HKU)**：存储每个用户的配置信息，每个用户都有一个对应的子键。
   5. **HKEY_CURRENT_CONFIG (HKCC)**：存储当前计算机的硬件配置信息。

2. 相关路径:

   - Windows注册表的文件通常存储在“C:\Windows\System32\config”文件夹中

     - 利用管理员权限,可以看到

     - ```powershell
       PS C:\Windows\System32> Get-ChildItem .\config\
       
           Directory: C:\Windows\System32\config
       
       Mode                 LastWriteTime         Length Name
       ----                 -------------         ------ ----
       d----            2024/4/5    11:06                BFS
       d----            2022/5/7    13:24                Journal
       d----            2022/5/7    13:24                RegBack
       d----            2022/5/7    13:24                systemprofile
       d----            2024/4/5    11:22                TxR
       -a---           2024/5/10    23:05         786432 BBI
       -a---            2024/4/5    12:05          28672 BCD-Template
       -a---           2024/5/11     9:35       35651584 COMPONENTS
       -a---           2024/5/10    23:05        1310720 DEFAULT
       -a---           2024/5/11     9:30        8232960 DRIVERS
       -a---            2024/4/5    11:13          32768 ELAM
       -a---           2024/5/10    23:05         131072 SAM
       -a---           2024/5/10    23:05          65536 SECURITY
       -a---           2024/5/10    23:05      105119744 SOFTWARE
       -a---           2024/5/10    23:05       18612224 SYSTEM
       -a---            2024/4/4    20:00           8192 userdiff
       -a---            2024/5/3    21:19           1623 VSMIDK
       ```

   - 包含的条目中部分和使用`regedit`看到的`Computer\HKEY_LOCAL_MACHINE`的条目是一样的

### 子键

1. **子键和值**：每个键可以有多个子键，形成一个树状结构。每个键或子键下可以有多个值项，每个值项由**名称、类型和数据**组成，用于具体存储配置信息。


### 特性

1. **安全性**：注册表支持**访问控制列表**（ACLs），允许管理员对不同用户或组设定访问权限，以增强系统的安全性。
2. **备份与恢复**：由于注册表对于系统运行至关重要，定期备份注册表以及在出现问题时能够恢复是非常重要的。Windows提供了如`regedit`这样的工具来进行手动备份和编辑操作。
3. **注册表在Windows操作中的作用**：从决定系统启动时加载哪些驱动程序，到控制用户界面的外观和行为，再到保存应用程序的设置信息，注册表几乎涉及Windows操作的每一个方面。

尽管注册表是一个强大的配置工具，但由于其复杂性，现代应用程序和系统越来越多地采用更易于管理和故障排查的配置文件和API，以减少对注册表的依赖。

## 查看注册表👺

为了便于说明,以注册表路径`computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\profileList`为例

- 查看注册表分为两层含义
  - 一个是查看注册表某个路径下的**键值对**
  - 另一个是查看注册表某个路径下的子路径或子键

### 使用powershell查看路径下的子路径

#### 声明概念

- 注册表中,某个路径下可能有**子路径**和**键值对**(Key-Value pair)(或者称为**属性值对**(Property-value pair)),可分别类比文件管理中的子目录和文件
- 为了方便讨论注册表的路径(地址),我们不妨约定以下称呼
  - 不能再创建或打开下一层的路径称为键值对(或称为**叶子路径**)
  - 否则称为**非叶路径**

#### Get-ChildItem查看注册表路径下的项

`Get-ChildItem`(简写为`ls`)功能简介是:获取一个或多个指定位置中的项和子项。

- 这里的指定位置不仅可以是文件系统的位置,也可以是注册表的位置(路径),当然也可以是环境变量的路径
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/e657784af9cc494d92778f77b0248d26.png)

- 使用regedit注册表编辑器,打开示例路径`Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print`,我们也可以用简写`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print`粘贴到regedit 界面的地址栏,回车跳转到该注册表路径


#### registry::根键名称访问注册表路径

这种方式访问注册表比较可靠,而且还有利于我们复制路径到`regedit`中去编辑

```
PS> cd Registry::\HKEY_CLASSES_ROOT\

PS☀️[BAT:74%][MEM:27.04% (8.57/31.71)GB][22:48:31]
# [Microsoft.PowerShell.Core\Registry::\HKEY_CLASSES_ROOT\]
PS> pwd

Path
----
Microsoft.PowerShell.Core\Registry::\HKEY_CLASSES_ROOT\

```

#### 使用根键缩写(HKCU或HKLM)访问注册表路径

`HKCU`和`HKLM`可以缩写访问

```pwsh
PS> cd hklm:\

PS☀️[BAT:74%][MEM:26.09% (8.27/31.71)GB][22:52:24]
# [HKLM:\]
PS>
```

而有些不行

```
PS> cd hkcr:\
Set-Location: Cannot find drive. A drive with the name 'hkcr' does not exist.
```



##### 查看注册表非叶子路径和叶子路径

注册表叶子路径用`ls`查看

```powershell
PS HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.pdf\> ls

    Hive: HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.pdf

Name                           Property
----                           --------
OpenWithList
UserChoice                     ProgId : MSEdgePDF
                               Hash   : ruVnHUKkJ84=
```

非叶子路径查看

```powershell
PS HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts> ls

    Hive: HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts

Name                           Property
----                           --------
.3g2
.3gp
.3gp2
.3gpp
.3mf
.aac
...
```



##### 查看环境变量

- 查看单值环境变量

  ```powershell
  PS C:\Users\cxxu> ls Env:\JAVA_HOME
  
  Name                           Value
  ----                           -----
  JAVA_HOME                      C:\exes\jdk-21.0.2
  ```

  

- 查看多值环境变量

  ```powershell
  PS C:\Users\cxxu> ls -path Env:\PSModulePath|select value |fl
  
  Value : C:\Users\cxxu\Documents\PowerShell\Modules;C:\Program Files\PowerShell\Module
          s;c:\program files\powershell\7\Modules;C:\Users\cxxu\scoop\modules;C:\repos\
          scripts\ModulesByCxxu\;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\
          system32\WindowsPowerShell\v1.0\Modules
  ```

  


#### Set-Location进入注册表路径

使用`Set-Location`(简写为`cd`)命令也不仅可以切换当前工作目录为某个磁盘路径,也可以还注册表路径

#### 举例说明

##### 查看文件系统某个路径下的项

```powershell

PS[BAT:84%][MEM:32.49% (10.30/31.70)GB][22:11:45]
# [~\Desktop]
PS> ls

        Directory: C:\Users\cxxu\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/1/17     10:31           1411   blogs_home.lnk
-a---          2024/5/6     23:49          16879 󰈬  clipboard.docx
-a---         2024/4/30     12:08            700   DCIM.lnk
-a---         2024/4/16     12:10           1453   EM.lnk
-a---         2024/4/28     12:04           1007   linux_blogs.lnk
-a---         2024/4/16     12:10           1439   Math.lnk
-a---         2024/5/11     18:21        1304087   README.pdf
-a---          2024/5/7     22:02           8063   scratch@bugs.md
-a---         2024/3/22     16:35           1421   Todo.lnk


PS[BAT:84%][MEM:32.46% (10.29/31.70)GB][22:11:46]
# [~\Desktop]
PS> ls $env:USERPROFILE/desktop

        Directory: C:\Users\cxxu\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/1/17     10:31           1411   blogs_home.lnk
-a---          2024/5/6     23:49          16879 󰈬  clipboard.docx
-a---         2024/4/30     12:08            700   DCIM.lnk
-a---         2024/4/16     12:10           1453   EM.lnk
-a---         2024/4/28     12:04           1007   linux_blogs.lnk
-a---         2024/4/16     12:10           1439   Math.lnk
-a---         2024/5/11     18:21        1304087   README.pdf
-a---          2024/5/7     22:02           8063   scratch@bugs.md
-a---         2024/3/22     16:35           1421   Todo.lnk

```



##### 查看某个注册表路径的项



```powershell
PS> ls -Path 'registry::\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'

    Hive: \HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList

Name                           Property
----                           --------
S-1-5-18                       Flags            : 12
                               ProfileImagePath : C:\WINDOWS\system32\config\systemprofile
                               RefCount         : 1
                               Sid              : {1, 1, 0, 0…}
                               State            : 0
S-1-5-19                       Flags            : 0
                               ProfileImagePath : C:\WINDOWS\ServiceProfiles\LocalService
                               State            : 0
S-1-5-20                       Flags            : 0
                               ProfileImagePath : C:\WINDOWS\ServiceProfiles\NetworkService
                               State            : 0
S-1-5-21-1150093504-2233723087 ProfileImagePath                        : C:\Users\cxxu
-916622917-1001                Flags                                   : 0
                               State                                   : 0
                               Sid                                     : {1, 5, 0, 0…}
                               FullProfile                             : 1
                               Migrated                                : {112, 102, 234, 92…}
                               LocalProfileLoadTimeLow                 : 1937225814
                               LocalProfileLoadTimeHigh                : 31105858
                               ProfileAttemptedProfileDownloadTimeLow  : 0
                               ProfileAttemptedProfileDownloadTimeHigh : 0
                               ProfileLoadTimeLow                      : 0
                               ProfileLoadTimeHigh                     : 0
                               RunLogonScriptSync                      : 0
                               LocalProfileUnloadTimeLow               : 2347813882
                               LocalProfileUnloadTimeHigh              : 31105771
```

- 这个例子中,还可以写成:`ls -path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'`
- 这里的路径同样是注册表路径,`ls`能够认出来`HKLM`等根键开头并以冒号引出的路径,就是一个注册表的路径
- 这和常见的C盘路径类似:`ls C:\...`,只不过路径的开头是磁盘驱动器分区盘符,而不是注册表或注册表的某个根键名(简写)

#### cd进注册表路径

- ```powershell
  PS[BAT:84%][MEM:32.28% (10.23/31.70)GB][22:25:12]
  # [~]
  PS> cd -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'
  
  PS[BAT:84%][MEM:32.28% (10.23/31.70)GB][22:25:14]
  # [HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList]
  PS>
  ```

  可以看到,路径从磁盘上的家目录`~`跳转到了注册表的路径`HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList`

- 在注册表路径中也可以用`ls`来执行文件系统上许多类似的操作,例如查看路径下有哪些子路径,可以指定是否显示绝对路径

  ```
  PS[BAT:84%][MEM:32.31% (10.24/31.70)GB][22:23:38]
  # [HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList]
  PS> ls |select pschildName
  
  PSChildName
  -----------
  S-1-5-18
  S-1-5-19
  S-1-5-20
  S-1-5-21-1150093504-2233723087-916622917-1001
  S-1-5-21-1150093504-2233723087-916622917-1003
  
  
  PS[BAT:84%][MEM:32.29% (10.23/31.70)GB][22:24:13]
  # [HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList]
  PS> ls |select name
  
  Name
  ----
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-18
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-19
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-20
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-21-1150093504-2233723087-916622917-1001
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-21-1150093504-2233723087-916622917-1003
  ```

  

### 查看指定路径下的属性或键值对

- [Get-ItemPropertyValue (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-itempropertyvalue?view=powershell-7.4&viewFallbackFrom=powershell-7.3&WT.mc_id=ps-gethelp)
- [Get-ItemProperty (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-itemproperty?view=powershell-7.4)

- 在PowerShell中，`Get-ItemProperty` 和 `Get-ItemPropertyValue` 都是用于获取项的属性值，但它们之间存在一些差异


#### Get-ItemProperty

- **功能**：此cmdlet用于获取指定路径下项的所有属性及其对应的值。当你需要查看某个路径下对象（如文件、注册表项）的所有属性时，它非常有用。
- **返回类型**：它返回的是一个包含多个属性名称和其对应值的对象（通常是一个哈希表或PSObject）。这意味着，如果你只关心某个特定属性，你还需进一步处理返回的结果来提取该属性的值。
- **使用场景**：适用于当你想要获取并可能进一步操作或筛选一个项的多个属性时。

示例：
```powershell
# 获取一个文件的属性
New-Item demofile
Get-ItemProperty -Path "./demofile"
# 获取注册表项的属性
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
```

创建一个文件并获取其属性

```powershell

PS> New-Item demofile

        Directory: C:\Users\cxxu\AppData\Roaming\Typora\themes


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/5/11     18:36              0   demofile

PS>$fileProperties=Get-ItemProperty -Path "./demofile"
#默认不会显示所有属性(数量较多时)
PS>$fileProperties

        Directory: C:\Users\cxxu\AppData\Roaming\Typora\themes


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/5/11     18:36              0   demofile

```

获取所有属性

```

PS> $fileProperties|select *

PSPath              : Microsoft.PowerShell.Core\FileSystem::C:\Users\cxxu\AppData\Roaming\Typora\themes\demofile
PSParentPath        : Microsoft.PowerShell.Core\FileSystem::C:\Users\cxxu\AppData\Roaming\Typora\themes
PSChildName         : demofile
....
ppData\Roaming\Typora\themes\demofile
Extension           :
CreationTime        : 2024/5/11 18:36:35
CreationTimeUtc     : 2024/5/11 10:36:35
LastAccessTime      : 2024/5/11 18:36:35
LastAccessTimeUtc   : 2024/5/11 10:36:35
LastWriteTime       : 2024/5/11 18:36:35
LastWriteTimeUtc    : 2024/5/11 10:36:35
LinkTarget          :
UnixFileMode        : -1
Attributes          : Archive
```



```bash
PS> Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'

SystemRoot                : C:\WINDOWS
BaseBuildRevisionNumber   : 1
BuildBranch               : ni_release
BuildGUID                 : ffffffff-ffff-ffff-ffff-ffffffffffff
BuildLab                  : 22621.ni_release.220506-1250
BuildLabEx                : 22621.1.amd64fre.ni_release.220506-1250
...

PSParentPath              : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT
PSChildName               : CurrentVersion
PSDrive                   : HKLM
PSProvider                : Microsoft.PowerShell.Core\Registry

```



#### Get-ItemPropertyValue

- **功能**：此cmdlet设计用于直接获取指定路径下项的特定属性值。相比`Get-ItemProperty`，它更加专注于单一属性的快速检索。
- **返回类型**：它直接返回所请求属性的值，而不是一个包含多个属性的哈希表或对象。这使得代码更简洁，特别是在只需要某一个属性值的场合。
- **使用场景**：当你确切知道要获取哪个属性，并且只需要那个属性的值时，使用这个cmdlet更加高效。

示例：
```powershell
# 获取文件的“CreationTime”属性值
$fileCreationTime = Get-ItemPropertyValue -Path "C:\path\to\file.txt" -Name CreationTime
# 获取注册表项的“CurrentVersion”属性值
$registryVersion = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentVersion
```

问题在于如何知道`Name`参数可以接受哪些值(属性名称),我们可以用`Get-ItemProperty`检查路径,然后对返回的结果使用`|select *`来获取所有属性;从而得知可用的属性名字,作为Get-ItemPropertyValue的`Name`参数

```powershell
PS C:\Users\cxxu> Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WebClient\Parameters' -Name BasicAuthLevel
2
PS C:\Users\cxxu> (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WebClient\Parameters' -Name BasicAuthLevel).BasicAuthLevel
2
```

总结来说，选择使用哪个cmdlet取决于你的具体需求：如果你需要查看或操作多项属性，应使用`Get-ItemProperty`；如果你的目标明确，只需获取一个特定属性的值，则`Get-ItemPropertyValue`更为直接和方便。

#### 联系

从结果上看,Get-ItemPropertyValue可以看作是Get-ItemProperty 传递给管道符`|select Property`的结果

但是后者会有一个Format-Table格式化输出的显示效果

```powershell
#使用Get-ItempropertyValue获取某个路径的某个属性的值
PS> Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' -Name ProfilesDirectory

C:\Users

#效果类似于
PS> $property=Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'
PS> $property.ProfilesDirectory
C:\Users

#或者使用管道符过滤select Property
PS> Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' |select ProfilesDirectory

ProfilesDirectory
-----------------
C:\Users
```

#### 小结

- 使用powershell中的`gp`,`gpv`命令时,使用`HKLM:\...`的格式来输入注册表的路径(Path参数)

  - 例如`HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion`

- 如果要在regedit中的地址栏输入,则需要去掉`:`,即输入`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion`,否则无法跳转

- 对于命令行工具`reg`,也和`regedit`一样需要去掉`:`,并且还要加上引号(为了防止路径中有空格,导致错误的解析),例如

  - ```cmd
    PS> reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v currentversion
    
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion
        currentversion    REG_SZ    6.3
    
    ```

    

### 使用CMD命令提示符查看

- 如果为了兼容老系统,你可以使用`reg query`命令来查询注册表：

  - ```cmd
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"	
    ```

- 这条命令会显示指定注册表路径下的子项和值。以我的机器为例,输出为:

  - ```bash
    PS> reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
    
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList
        Default    REG_EXPAND_SZ    %SystemDrive%\Users\Default
        ProfilesDirectory    REG_EXPAND_SZ    %SystemDrive%\Users
        ProgramData    REG_EXPAND_SZ    %SystemDrive%\ProgramData
        Public    REG_EXPAND_SZ    %SystemDrive%\Users\Public
    
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-18
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-19
    ...
    ```
    
    

- 请确保你在执行这些命令时拥有足够的权限，因为访问某些注册表键可能需要管理员权限。如果遇到权限问题，你可能需要以管理员身份运行PowerShell或CMD。

## 注册表的备份与恢复👺

- 修改注册表前,应当进行注册表备份
- [How to back up and restore the registry in Windows - Microsoft Support](https://support.microsoft.com/en-us/topic/how-to-back-up-and-restore-the-registry-in-windows-855140ad-e318-2a13-2829-d428a2ab0692)

## 修改和编辑注册表👺

- 操作注册表时应当慎重，因为不当的修改可能会导致系统故障。如果不熟悉注册表的操作，建议尽量不要随意修改。

- 如果需要修改注册表，可以使用Windows操作系统自带的注册表编辑器（`regedit`），或者通过一些系统辅助软件来进行。

- 也可以用系统自带的命令行工具`reg`来修改,通过`reg /?`来获取使用帮助,或则在线搜索

- 详情查看文档:[Windows registry for advanced users - Windows Server | Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-server/performance/windows-registry-advanced-users#edit-the-registry)

- 相关的powershell函数:[Set-ItemProperty (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/set-itemproperty?view=powershell-7.4)

- 此外,还有导入的方式进行修改(创建.reg文件导入):
  - [如何使用 .reg 文件添加、修改或删除注册表子项和值 - Microsoft 支持](https://support.microsoft.com/zh-cn/topic/如何使用-reg-文件添加-修改或删除注册表子项和值-9c7f37cf-a5e9-e1cd-c4fa-2a26218a1a23)
  - [How to add, modify, or delete registry subkeys and values by using a .reg file - Microsoft Support](https://support.microsoft.com/en-us/topic/how-to-add-modify-or-delete-registry-subkeys-and-values-by-using-a-reg-file-9c7f37cf-a5e9-e1cd-c4fa-2a26218a1a23)


## 拓展和补充

- 主要来自于wikipedia


---

### 注册表结构

- 注册表值是存储在键内的名称/数据对。注册表值与注册表键分开引用。存储在注册表键中的每个注册表值都有一个唯一的名称，其字母大小写不显著。查询和操作注册表值的 Windows API 函数将值名称与标识父键的键路径或句柄分开。
- 注册表值的名称中可能包含反斜杠，但这样做会使它们在使用某些旧版 Windows 注册表 API 函数时难以与它们的键路径区分开来（这些函数的使用在 Win32 中已弃用）。
- 术语有点误导，因为每个注册表键类似于一个关联数组，标准术语会将每个注册表值的名称部分称为“键”。这些术语是从 Windows 3 的 16 位注册表延续下来的，在 Windows 3 中，注册表键不能包含任意名称/数据对，而是只包含一个未命名的值（必须是字符串）。在这个意义上，Windows 3 注册表就像是一个单一的关联数组，其中键（在“注册表键”和“关联数组键”的意义上）形成了一个层次结构，注册表值都是字符串。当创建 32 位注册表时，也增加了为每个键创建多个命名值的能力，并且名称的含义有些扭曲。
- 每个值可以存储任意数据，长度可变，并且编码可变，但与一个符号类型相关联（定义为一个数值常量），该类型定义了如何解析这些数据。标准类型为：

#### 注册表值类型的列表👺

以下表格来自官方文档,可以结合wikipedia查看

| Name                    | Data type                      | Description                                                  |
| :---------------------- | :----------------------------- | :----------------------------------------------------------- |
| Binary Value            | REG_BINARY                     | Raw binary data. Most hardware component information is stored as binary data and is displayed in Registry Editor in hexadecimal format. |
| DWORD Value             | REG_DWORD                      | Data represented by a number that is 4 bytes long (a 32-bit integer). Many parameters for device drivers and services are this type and are displayed in Registry Editor in binary, hexadecimal, or decimal format. Related values are DWORD_LITTLE_ENDIAN (least significant byte is at the lowest address) and REG_DWORD_BIG_ENDIAN (least significant byte is at the highest address). |
| Expandable String Value | REG_EXPAND_SZ                  | A variable-length data string. This data type includes variables that are resolved when a program or service uses the data. |
| Multi-String Value      | REG_MULTI_SZ                   | A multiple string. Values that contain lists or multiple values in a form that people can read are generally this type. Entries are separated by spaces, commas, or other marks. |
| String Value            | REG_SZ                         | A fixed-length text string.                                  |
| Binary Value            | REG_RESOURCE_LIST              | A series of nested arrays that is designed to store a resource list that is used by a hardware device driver or one of the physical devices it controls. This data is detected and written in the \ResourceMap tree by the system and is displayed in Registry Editor in hexadecimal format as a Binary Value. |
| Binary Value            | REG_RESOURCE_REQUIREMENTS_LIST | A series of nested arrays that is designed to store a device driver's list of possible hardware resources the driver or one of the physical devices it controls can use. The system writes a subset of this list in the \ResourceMap tree. This data is detected by the system and is displayed in Registry Editor in hexadecimal format as a Binary Value. |
| Binary Value            | REG_FULL_RESOURCE_DESCRIPTOR   | A series of nested arrays that is designed to store a resource list that is used by a physical hardware device. This data is detected and written in the \HardwareDescription tree by the system and is displayed in Registry Editor in hexadecimal format as a Binary Value. |
| None                    | REG_NONE                       | Data without any particular type. This data is written to the registry by the system or applications and is displayed in Registry Editor in hexadecimal format as a Binary Value |
| Link                    | REG_LINK                       | A Unicode string naming a symbolic link.                     |
| QWORD Value             | REG_QWORD                      | Data represented by a number that is a 64-bit integer. This data is displayed in Registry Editor as a Binary Value and was introduced in Windows 2000. |

类型 ID 符号类型名称 存储在注册表值中的数据的含义和编码

- 0 REG_NONE 无类型（存储的值，如果有的话）
- 1 REG_SZ 一个字符串值，通常以 UTF-16LE 存储和公开（当使用 Win32 API 函数的 Unicode 版本时），通常以 NUL 字符终止
- 2 REG_EXPAND_SZ 一个“可扩展的”字符串值，可以包含环境变量，通常以 UTF-16LE 存储和公开，通常以 NUL 字符终止
- 3 REG_BINARY 二进制数据（任何任意数据）
- 4 REG_DWORD / REG_DWORD_LITTLE_ENDIAN 一个 DWORD 值，一个 32 位无符号整数（数字在 0 到 4,294,967,295 [2^32 – 1] 之间）（小端）
- 5 REG_DWORD_BIG_ENDIAN 一个 DWORD 值，一个 32 位无符号整数（数字在 0 到 4,294,967,295 [2^32 – 1] 之间）（大端）
- 6 REG_LINK 到另一个注册表键的符号链接（UNICODE），指定一个根键和目标键的路径
- 7 REG_MULTI_SZ 一个多字符串值，这是一个非空字符串的有序列表，通常以 Unicode 存储和公开，每个字符串以 null 字符终止，列表通常以第二个 null 字符终止。
- 8 REG_RESOURCE_LIST 一个资源列表（由即插即用硬件枚举和配置使用）
- 9 REG_FULL_RESOURCE_DESCRIPTOR 一个资源描述符（由即插即用硬件枚举和配置使用）
- 10 REG_RESOURCE_REQUIREMENTS_LIST 一个资源需求列表（由即插即用硬件枚举和配置使用）
- 11 REG_QWORD / REG_QWORD_LITTLE_ENDIAN 一个 QWORD 值，一个 64 位整数（大端或小端，或未指定）（在 Windows 2000 中引入）

#### 键的命名

- 在注册表的根级别键通常以其 Windows API 定义的名称命名，所有名称都以“HKEY”开头。 它们经常被缩写为以“HK”开头的三到四个字母的短名称（例如 HKCU 和 HKLM）。
- 技术上，它们是特定键的预定义句柄（具有已知的常数值），这些键要么在内存中维护，要么存储在本地文件系统中的文件中，并在系统启动时由系统内核加载，然后在本地系统上运行的所有进程之间共享（具有各种访问权限），或在用户登录系统时在所有进程中加载和映射。

### 两个结构相似的键

- HKEY_LOCAL_MACHINE（本地计算机特定配置数据）和 HKEY_CURRENT_USER（用户特定配置数据）节点具有彼此相似的结构；
  - 用户应用程序通常首先在“HKEY_CURRENT_USER\Software\Vendor's name\Application's name\Version\Setting name”下查找它们的设置，如果找不到设置，则改为在 HKEY_LOCAL_MACHINE 键下的相同位置查找。
  - 然而，对于管理员强制执行的策略设置，HKLM 可能优先于 HKCU。Windows Logo 程序对不同类型的用户数据可能存储的位置有特定要求，并遵循最小权限的概念，以便使用应用程序不需要管理员级别的访问。

#### 常用键的特点和用途

1. 缩写为 HKLM 的 HKEY_LOCAL_MACHINE 存储特定于本地计算机的设置。
   - **由 HKLM 定位的键实际上并不存储在磁盘上，而是由系统内核在内存中维护，以映射所有其他子键**。
   - 应用程序不能创建任何额外的子键。
   - 在 Windows NT 上，此键包含在启动时加载的四个子键，“SAM”、“SECURITY”、“SYSTEM”和“SOFTWARE”，它们分别位于 %SystemRoot%\System32\\config 文件夹中的各自文件中。
   - 第五个子键“HARDWARE”是易变的，是动态创建的，因此不存储在文件中（它暴露了所有当前检测到的即插即用设备）。
   - 在 Windows Vista 及更高版本上，第六个和第七个子键“COMPONENTS”和“BCD”由内核按需在内存中映射，并从 %SystemRoot%\\system32\\config\\COMPONENTS 或系统分区上的启动配置数据 \\boot\\BCD 加载。
   - “HKLM\\SAM”键对大多数用户来说通常看起来是空的（除非他们被本地系统的管理员或管理本地系统的域的管理员授予访问权限）。它用于引用所有“安全帐户管理器”（SAM）数据库，本地系统已经获得或配置了行政授权的所有域（包括运行系统的本地域，其 SAM 数据库存储在也命名为“SAM”的子键中：将根据需要创建其他子键，每个子键对应一个辅助域）。
   - 每个 SAM 数据库包含所有内置帐户（主要是组别名）和配置帐户（用户、组及其别名，包括来宾帐户和管理员帐户），在相应域上创建和配置的每个帐户，它显著地包含可用于登录该域的用户名，该域内的唯一内部用户标识符，每个用户密码的每个启用的身份验证协议的密码的加密哈希函数的加密哈希，他们用户注册表hive的存储位置，各种状态标志（例如，如果帐户可以枚举并在登录提示屏幕上可见），以及帐户配置的域列表（包括本地域）。
   - “HKLM\\SECURITY”键对大多数用户来说通常看起来是空的（除非他们被具有管理特权的用户授予访问权限），并且与当前用户登录的域的安全数据库相关联（如果用户登录到本地系统域，该键将链接到由本地机器管理和由本地系统管理员或内置的“系统”帐户和 Windows 安装程序管理的存储在本地机器上的注册表hive）。内核将访问它以读取和强制适用于当前用户和所有由该用户执行的应用程序或操作的安全策略。它还包含一个动态链接到当前用户登录的域的 SAM 数据库的“SAM”子键。
   - “HKLM\\SYSTEM”键通常只能由本地系统上的具有管理特权的用户编写。它包含有关 Windows 系统设置的信息，安全随机数生成器（RNG）的数据，包含文件系统的当前安装设备的列表，几个编号的“HKLM\\SYSTEM\\Control Sets”包含本地系统上运行的系统硬件驱动程序和服务的备用配置（包括当前使用的和备份的），一个包含这些 Control Sets 状态的“HKLM\\SYSTEM\\Select”子键，以及在启动时动态链接到本地系统上当前使用的 Control Set 的“HKLM\\SYSTEM\\CurrentControlSet”。每个配置的 Control Set 包含：
     - 一个“Enum”子键，它枚举所有已知的即插即用设备并将它们与安装的系统驱动程序关联（并存储这些驱动程序的设备特定配置），
     - 一个“Services”子键，列出所有安装的系统驱动程序（带有非设备特定的配置，以及它们实例化的设备的枚举）以及所有作为服务运行的程序（它们如何以及何时可以被自动启动），
     - 一个“Control”子键，用于组织各种硬件驱动程序和作为服务运行的程序以及所有其他系统范围的配置，
     - 一个“Hardware Profiles”子键，枚举已经调整的各种配置文件（每个配置文件都有“System”或“Software”设置，用于修改默认配置文件，无论是在系统驱动程序和服务还是在应用程序中）以及“Hardware Profiles\Current”子键，该子键动态链接到这些配置文件中的一个。
   - “HKLM\\SOFTWARE”子键包含软件和 Windows 设置（在默认硬件配置文件中）。它主要由应用程序和系统安装程序修改。它按软件供应商组织（每个供应商都有一个子键），但也包含一些 Windows 用户界面设置的“Windows”子键，一个包含所有从文件扩展名、MIME 类型、对象类 ID 和接口 ID（用于 OLE、COM/DCOM 和 ActiveX）到可以处理这些类型的本地机器上安装的应用程序或 DLL 的注册关联的“Classes”子键，以及一个用于在应用程序和服务上强制执行一般使用策略的“Policies”子键（也按供应商组织，包括用于认证、授权或禁止远程系统或服务的中央证书存储，这些系统或服务在本地网络域之外运行）。“HKLM\\SOFTWARE\\Wow6432Node”键由 64 位 Windows OS 上的 32 位应用程序使用，并且等同于但与“HKLM\\SOFTWARE”分开。对于 32 位应用程序，WoW64 将键路径透明地呈现为 HKLM\\SOFTWARE（类似于 32 位应用程序将 %SystemRoot%\\Syswow64 视为 %SystemRoot%\\System32 的方式）。
2. 缩写为 HKCR 的 HKEY_CLASSES_ROOT 包含有关注册应用程序的信息，例如文件关联和 OLE 对象类 ID，将它们与用于处理这些项目的应用程序联系起来。在 Windows 2000 及以上版本中，HKCR 是基于用户的 HKCU\\Software\\Classes 和基于机器的 HKLM\\Software\\Classes 的编译。如果给定值在上述两个子键中都存在，则 HKCU\\Software\\Classes 中的值优先。 该设计允许对 COM 对象进行机器或用户特定的注册。
3. 缩写为 HKU 的 HKEY_USERS 包含对应于机器上积极加载的每个用户配置文件的 HKEY_CURRENT_USER 键的子键，尽管用户 hive 文件通常只在当前登录的用户中加载。
4. 缩写为 HKCU 的 HKEY_CURRENT_USER 存储特定于当前登录用户设置。 HKEY_CURRENT_USER 键是指向 HKEY_USERS 中对应于用户的子键的链接；相同的信息可以在两个位置访问。
   - 引用的特定子键是“(HKU)\\(SID)\\...”，其中 (SID) 对应于 Windows SID；如果“(HKCU)”键具有后缀“(HKCU)\\Software\\Classes\\...”，则它对应于“(HKU)\\(SID)_CLASSES\\...”，即后缀字符串“_CLASSES”附加到 (SID)。
   - 在 Windows NT 系统上，每个用户的设置存储在他们自己的文件中，称为 NTUSER.DAT 和 USRCLASS.DAT，位于他们自己的文档和设置子文件夹中（或在 Windows Vista 及以上版本中他们自己的用户子文件夹中）。设置在此 hive 中的用户将随着漫游配置文件从一台机器移动到另一台机器。
5. HKEY_PERFORMANCE_DATA:此键提供由 NT 内核本身或提供性能数据的正在运行的系统驱动程序、程序和服务提供的性能数据的运行时信息。此键不存储在任何 hive 中，也不显示在注册表编辑器中，但可以通过 Windows API 中的注册表函数或通过任务管理器的性能选项卡（仅限本地系统上的一些性能数据）或通过更高级的控制面板（例如性能监视器或性能分析器，允许收集和记录这些数据，包括来自远程系统的数据）以简化视图查看。
6. HKEY_DYN_DATA:此键仅在 Windows 95、Windows 98 和 Windows ME 中使用。 它包含有关硬件设备的信息，包括即插即用和网络性能统计信息。此 hive 中的信息也不存储在硬盘上；即插即用信息在启动时收集和配置，并存储在内存中。

### hive

1. 尽管注册表呈现为一个集成的分层数据库，但注册表的分支实际上存储在称为hive的几个磁盘文件中。（“hive”这个词构成了一个内部玩笑。）

1. 一些hive是易变的，根本不存储在磁盘上。一个例子是 HKLM\\HARDWARE 开始的分支的hive。该 hive 记录有关系统硬件的信息，并在每次系统启动并执行硬件检测时创建。
2. 系统上用户的个别设置存储在每个用户的hive（磁盘文件）中。在用户登录期间，系统加载用户 hive 并在 HKEY_USERS 键下设置 HKCU（HKEY_CURRENT_USER）符号引用，以指向当前用户。这允许应用程序在 HKCU 键下隐式地为当前用户存储/检索设置。
3. 并非所有hive都会在任何时候加载。在启动时，只加载最小集的hive，之后，随着操作系统初始化和用户登录或应用程序显式加载hive，hive将被加载。



每个用户的hive（磁盘文件）中。在用户登录期间，系统加载用户 hive 并在 HKEY_USERS 键下设置 HKCU（HKEY_CURRENT_USER）符号引用，以指向当前用户。这允许应用程序在 HKCU 键下隐式地为当前用户存储/检索设置

每个用户的hive（磁盘文件）中。在用户登录期间，系统加载用户 hive 并在 HKEY_USERS 键下设置 HKCU（HKEY_CURRENT_USER）符号引用，以指向当前用户。这允许应用程序在 HKCU 键下隐式地为当前用户存储/检索设置