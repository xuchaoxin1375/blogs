[toc]



## ref

- [Shut down, sleep, or hibernate your PC - Microsoft Support](https://support.microsoft.com/en-us/windows/shut-down-sleep-or-hibernate-your-pc-2941d165-7d0a-a5e8-c5ad-8c972e8e6eff)
- [win10删除休眠文件的方法是什么_windows10休眠文件怎么删除－系统城 (xitongcheng.com)](https://www.xitongcheng.com/jiaocheng/win10_article_61789.html)

## 睡眠和休眠功能

- 在Windows操作系统中，睡眠（Sleep）和休眠（Hibernate）都是节能模式，它们的主要目的是为了在用户暂时不需要使用电脑时减少电能消耗，同时又能在用户回来后迅速恢复到之前的工作状态。


### 睡眠（Sleep）

**功能介绍**：

- 睡眠模式下，系统将当前运行状态的数据（包括打开的文档和程序）保存在RAM（随机访问存储器）中，大部分硬件都会进入低功耗状态，但内存仍会维持供电以保留这些数据。
- 当用户重新激活电脑（例如，按一下电源按钮或敲击键盘、移动鼠标）时，系统可以从内存中快速恢复，让用户继续之前的操作，唤醒速度非常快(一般不会超过10秒)。

**特点**：
- 快速恢复：通常只需几秒钟即可恢复至工作状态。
- 节能有限：虽然相比正常运行时节能，但仍需向内存供电以保持数据。
- 如果断电，内存中的数据将会丢失，因为RAM在失去电力供应时不能保持数据。

### 休眠（Hibernate）

**功能介绍**：
休眠模式下，系统不仅将当前运行状态的数据保存在内存中，还会将其写入到硬盘上的一个专门区域——休眠文件（也称为休眠映像）。之后，系统将完全关闭电源，包括内存在内的所有部件均停止供电。再次启动时，系统从硬盘上的休眠文件中读取数据并恢复到先前的状态。

**特点**：
- 能耗更低：因为电脑完全关闭，所以休眠期间的能耗为零。
- 数据安全性高：即使断电，硬盘上存储的数据不会丢失。
- 唤醒时间稍长：相较于睡眠模式，由于需要从硬盘读取数据，因此恢复到工作状态所需的时间稍微多一些，但在现代高速SSD硬盘上，这一差距已经显著减小。

### 应用场景：
- 睡眠模式适用于短暂离开电脑且希望短时间内快速恢复的情况。
- 休眠模式更适合长时间离开电脑，或者担心电源不稳定可能导致数据丢失的情况。

需要注意的是，不同的Windows版本和硬件配置可能会影响到睡眠和休眠的具体表现和可用性。另外，用户可以根据自己的需求在电源管理设置中调整和选择适合自己的节能策略。

## 命令行方式进入睡眠于休眠状态👺

- 这部分可以作为脚本或函数调用

### 睡眠(Sleep)



- 由于Windows本身并未提供直接通过命令行进入睡眠模式的标准命令，但可以调用PowerShell命令或者使用`rundll32.exe`来间接实现

- 如果你想确保进入的是标准睡眠模式，而不是休眠，可以尝试：

  - ```powershell
     rundll32.exe powrprof.dll,SetSuspendState 0,1,0
    ```

- 其中参数含义如下：
  - `0` 表示不强制关闭未响应的应用程序就进入睡眠状态。

  - `1` 表示进入睡眠模式（如果是0则可能进入休眠）。

  - `0` 表示不唤醒事件。

#### 附

- 启用混合休眠下情况下,可以通过以下方式

  - ```powershell
    rundll32.exe powrprof.dll,SetSuspendState Hibernate
    ```

  - 上面这个命令原本是用于休眠的，但由于在某些Windows版本中，若系统配置为混合睡眠（即同时支持休眠和睡眠），运行此命令实际上会让系统进入睡眠状态。

### 休眠(Hibernate)


要让Windows系统进入休眠模式，可以使用以下命令：

```powershell
powercfg /hibernate on # 先确保休眠功能已启用
shutdown /h
```

第一条命令是启用休眠功能，如果不先启用休眠，可能会发现无法进行休眠操作。

第二条命令是实际触发休眠操作，`shutdown /h` 命令会使计算机立即进入休眠状态，并将内存中的所有内容保存到硬盘的休眠文件中，断电后仍能恢复到之前的工作状态。

### 关闭休眠或睡眠功能：

- **关闭休眠**：
  
  ```cmd
  powercfg -h off
  ```

- **开启休眠**：

  ```cmd
  powercfg -hibernate on
  ```

### 注意事项：

- 上述命令可能需要以管理员权限运行才能成功执行。
- 不同版本的Windows可能对这些命令的支持程度略有差异，建议根据实际操作系统版本查阅最新的官方文档或命令帮助信息。

### 关闭@删除休眠文件

- 休眠功能有一定的用途,但是休眠文件体积较大,经常使用休眠对硬盘的寿命有影响,系统稳定性可能会不如全新启动(容易累计内部错误,需要通过重启解决)

- 删除Windows系统的休眠文件通常是为了释放硬盘空间，特别是对于那些硬盘容量较小的用户来说，休眠文件（hiberfil.sys）可能会占用相当大的空间。

- 可以用第三方清理工具删除休眠文件,比如360卫士清理,PCmaster等

- 也可以手动清理(推荐)

  - 删除休眠文件步骤：

    1. **通过管理员权限打开命令提示符**：
       - 按下键盘上的 `Win + X` 组合键，然后选择“命令提示符（管理员）”或“Windows PowerShell（管理员）”；
       - 或者，您可以右键点击“开始”按钮，然后在菜单中选择“Windows 终端 (管理员)”或“命令提示符（管理员）”。

    2. **关闭休眠功能并删除休眠文件**：
       在命令提示符窗口中，输入以下命令并按回车键执行：
       ```powershell
       powercfg.exe /hibernate off
       ```
       - 这个命令会关闭系统的休眠功能，并自动删除对应的休眠文件（hiberfil.sys）。


  - 执行以上命令后，系统将不再维护休眠文件，相应空间将被释放给其他用途。

- 如果您后续想要重新启用休眠功能，可以使用相同命令行工具，但这次改为启用休眠：

  - ```bash
    powercfg.exe /hibernate on
    ```

    

  - 这会重新启用休眠功能，并根据当时内存使用量重新创建休眠文件。请注意，删除休眠文件意味着在您关机前的系统状态将无法通过休眠模式恢复。

##  休眠(hibernate)

### 设置前提和驱动要求

- 您的计算机已经安装了必要的驱动
  - 最好确保`显卡`在内的所有驱动都是正常的
  - 否则可能找不到或者无法顺利启用休眠功能
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626095954647.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

## GUI@控制面板方式启用

### powercfg.cpl

- 您可以用命令行或者win+R输入`powercfg.cpl`来快速跳转到相应的设置页面

  - ```powershell
    PS C:\Users\cxxu> powercfg.cpl
    ```

    

###  允许更改不可用按钮:

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626100223892.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


- 
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626095917243.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

###  the result

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626100311306.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)



## CLI@powercfg.exe命令行操作

- ```bash
  PS C:\Users\cxxu> powercfg.exe -?
  ```

### 基本语法和帮助

- ```bash
  POWERCFG /COMMAND [ARGUMENTS]
  
  Description:
    Enables users to control power settings on a local system.
  
    For detailed command and option information, run "POWERCFG /? <COMMAND>"
  ```

### 关于休眠的子命令

- ```bash
  
  POWERCFG /HIBERNATE <ON|OFF>
  
  POWERCFG /HIBERNATE /SIZE <PERCENT_SIZE>
  
  POWERCFG /HIBERNATE /TYPE <REDUCED|FULL>
  
  Alias:
    POWERCFG /H
  
  Description:
    Enables/disables the hibernate feature or sets the hiberfile size.
  
  Parameter List:
    <ON|OFF>                Enables/disables the hibernate feature.
  
    /SIZE <PERCENT_SIZE>    Specifies the desired hiberfile size as a percentage
                            of the total memory size. The default size cannot be
                            smaller than 40. This parameter will also cause
                            hibernate to be enabled.
  
    /TYPE <REDUCED|FULL>    Specifies the desired hiberfile type. A reduced
                            hiberfile only supports hiberboot.
  
  Examples:
    POWERCFG /HIBERNATE OFF
  
    POWERCFG /HIBERNATE /SIZE 100
  
    POWERCFG /HIBERNATE /TYPE REDUCED
  
  ```

### 启用休眠😊

- 使用命令行`powercfg -h on`系统将尝试启用休眠功能
  - 如果您的软硬件都支持,一般情况下是可以正常启用
  - 个别情况(比如驱动问题,可能会执行失败,那么您可能需要修复一下驱动问题)

### hiberfil.sys系统休眠文件

- 当您执行休眠操作后,系统将在`C:\`目录生成一个隐藏系统文件`hiberfil.sys`

### 使计算机休眠😊

- 比如使用命令行`shutdown -h`

#### shutdown相关用法

- `shutdown.exe -?`
- [shutdown | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/shutdown)

- ```bash
  🚀  shutdown.exe -?
  Usage: C:\WINDOWS\system32\shutdown.exe [/i | /l | /s | /sg | /r | /g | /a | /p | /h | /e | /o] [/hybrid] [/soft] [/fw] [/f]
      [/m \\computer][/t xxx][/d [p|u:]xx:yy [/c "comment"]]
  
      No args    Display help. This is the same as typing /?.
      /?         Display help. This is the same as not typing any options.
      /i         Display the graphical user interface (GUI).
                 This must be the first option.
      /l         Log off. This cannot be used with /m or /d options.
      /s         Shutdown the computer.
      /sg        Shutdown the computer. On the next boot, if Automatic Restart Sign-On
                 is enabled, automatically sign in and lock last interactive user.
                 After sign in, restart any registered applications.
      /r         Full shutdown and restart the computer.
      /g         Full shutdown and restart the computer. After the system is rebooted,
                 if Automatic Restart Sign-On is enabled, automatically sign in and
                 lock last interactive user.
                 After sign in, restart any registered applications.
      /a         Abort a system shutdown.
                 This can only be used during the time-out period.
                 Combine with /fw to clear any pending boots to firmware.
      /p         Turn off the local computer with no time-out or warning.
                 Can be used with /d and /f options.
      /h         Hibernate the local computer.
                 Can be used with the /f option.
      /hybrid    Performs a shutdown of the computer and prepares it for fast startup.
                 Must be used with /s option.
     节约篇幅
     ........
  ```

  

### 关闭休眠功能😊@删除休眠文件

- `powercfg -h off`

  - 该命令删除应为启用休眠功能所产生的hiberfil.sys

    - 该文件是系统文件,默认是隐藏文件

    - 如果需要查看,可以用资源管理器勾选显示隐藏文件

    - 或者使用powershell,输入以下命令查看

      - `ls C:\ -Force|where{$_.FullName -like '*sys'}`

      - ```bash
        	
        PS C:\Users\cxxu> ls C:\ -Force|where{$_.FullName -like '*sys'}
        
            Directory: C:\
        
        Mode                 LastWriteTime         Length Name
        ----                 -------------         ------ ----
        -a-hs          12/22/2022  5:13 PM     3371900928 hiberfil.sys
        -a-hs          12/22/2022  6:20 PM     5475780608 pagefile.sys
        -a-hs          12/21/2022 11:08 AM       16777216 swapfile.sys
        ```

    

### 其他相关子命令

- ```bash
  
  Command List:
    /LIST, /L          Lists all power schemes.
  
    /QUERY, /Q         Displays the contents of a power scheme.
  
    /CHANGE, /X        Modifies a setting value in the current power scheme.
  
    /CHANGENAME        Modifies the name and description of a power scheme.
  
    /DUPLICATESCHEME   Duplicates a power scheme.
  
    /DELETE, /D        Deletes a power scheme.
  
    /DELETESETTING     Deletes a power setting.
  
    /SETACTIVE, /S     Makes a power scheme active on the system.
  
    /GETACTIVESCHEME   Retrieves the currently active power scheme.
  
    /SETACVALUEINDEX   Sets the value associated with a power setting
                       while the system is powered by AC power.
  
    /SETDCVALUEINDEX   Sets the value associated with a power setting
                       while the system is powered by DC power.
  
    /IMPORT            Imports all power settings from a file.
  
    /EXPORT            Exports a power scheme to a file.
  
    /ALIASES           Displays all aliases and their corresponding GUIDs.
  
    /GETSECURITYDESCRIPTOR
                       Gets a security descriptor associated with a specified
                       power setting, power scheme, or action.
  
    /SETSECURITYDESCRIPTOR
                       Sets a security descriptor associated with a
                       power setting, power scheme, or action.
  
    /HIBERNATE, /H     Enables and disables the hibernate feature.
  
    /AVAILABLESLEEPSTATES, /A
                       Reports the sleep states available on the system.
  
    /DEVICEQUERY       Returns a list of devices that meet specified criteria.
  
    /DEVICEENABLEWAKE  Enables a device to wake the system from a sleep state.
  
    /DEVICEDISABLEWAKE Disables a device from waking the system from a sleep
                       state.
  
  ....
  省略篇幅
  ..
  ```

  

  ### 调整休眠文件大小

  - [Hibernation file too big? Reduce size of hiberfil.sys in Windows 11/10 (thewindowsclub.com)](https://www.thewindowsclub.com/change-the-size-of-hiberfil-sys-in-windows-10)

  - 例如:将休眠文件压缩到物理内存的50%(写入磁盘保存)

    - ```bash
      powercfg.exe /hibernate /size 50
      ```

    - 如果压缩的百分比设置的过于低(比如低于40个百分点,可能导致休眠失败/蓝屏)


## 睡眠(sleep)

- [如何使用命令行让Windows 进入睡眠 (sysgeek.cn)](https://www.sysgeek.cn/put-windows-10-sleep-mode-command-line/)

- `rundll32.exe powrprof.dll,SetSuspendState 0,1,0`
- 

