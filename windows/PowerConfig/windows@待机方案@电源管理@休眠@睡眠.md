[toc]

## refs

- [如何禁用和重新启用休眠 - Windows Client | Microsoft Learn](https://learn.microsoft.com/zh-cn/troubleshoot/windows-client/setup-upgrade-and-drivers/disable-and-re-enable-hibernation)

- [Shut down, sleep, or hibernate your PC - Microsoft Support](https://support.microsoft.com/en-us/windows/shut-down-sleep-or-hibernate-your-pc-2941d165-7d0a-a5e8-c5ad-8c972e8e6eff)
- [关闭电脑，或使其进入睡眠或休眠状态 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/关闭电脑-或使其进入睡眠或休眠状态-2941d165-7d0a-a5e8-c5ad-8c972e8e6eff)
- [Powercfg 命令行选项 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/design/device-experiences/powercfg-command-line-options)



## 睡眠和休眠功能简介

- 在Windows操作系统中，睡眠（Sleep）和休眠（Hibernate）都是节能模式，它们的主要目的是为了在用户暂时不需要使用电脑时减少电能消耗，同时又能在用户回来后迅速恢复到之前的工作状态。


### 睡眠（Sleep）

**功能介绍**：

- 睡眠模式下，系统将当前运行状态的数据（包括打开的文档和程序）保存在RAM（随机访问存储器）中，大部分硬件都会进入低功耗状态，但内存仍会维持供电以保留这些数据。
- 当用户重新激活电脑（例如，按一下电源按钮或敲击键盘、移动鼠标）时，系统可以从内存中快速恢复，让用户继续之前的操作，唤醒速度非常快(一般不会超过10秒)。

**特点**：

- 快速恢复：通常只需几秒钟即可恢复至工作状态。
- 节能有限：虽然相比正常运行时节能，但仍需向内存供电以保持数据。(例如我的laptop睡眠了一个晚上,大概掉了10%左右的电
- 如果断电，内存中的数据将会丢失，因为RAM在失去电力供应时不能保持数据。

### 休眠（Hibernate）

**功能介绍**：
休眠模式下，系统不仅将当前运行状态的数据保存在内存中，还会将其写入到硬盘上的一个专门区域——**休眠文件**（也称为休眠映像）。之后，系统将**完全关闭电源**，包括内存在内的所有部件均停止供电。

再次启动时，系统从硬盘上的休眠文件中读取数据并恢复到先前的状态。

**特点**：

- 能耗更低：因为电脑完全关闭，所以休眠期间的能耗几乎为零。
- 数据安全性高：即使断电，硬盘上存储的数据不会丢失。
- 唤醒时间稍长：相较于睡眠模式，由于需要从硬盘读取数据，因此恢复到工作状态所需的时间稍微多一些，但在现代高速SSD硬盘上，这一差距已经显著减小。

### 应用场景：

- 睡眠模式适用于短暂离开电脑且希望短时间内快速恢复的情况。
- 休眠模式更适合长时间离开电脑，或者担心电源不稳定可能导致数据丢失的情况。



## 新式待机

- [新式待机 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/design/device-experiences/modern-standby)
- [新式待机与 S3 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/design/device-experiences/modern-standby-vs-s3)

##  睡眠和休眠设置前提要求

- 休眠主要是为笔记本设计的,通常现代的笔记本都支持休眠(可能需要手动启用,或者默认启用了快速启动但是没有在开始菜单里提供休眠按钮,可以在控制面板中设置打开)
- 但一台计算机是否支持休眠还需要进一步判断

### 计算机支持的电源类型检查😊

- 可以使用命令行`powercfg /a`来检查(参数`/a`是`/availablesleepstates`的缩写)

- 而关闭休眠和启用休眠后,可用的选项会发生变化,混合休眠主要面向台式机

- 例如,我关闭休眠功能(`powercfg /h off`)后,情况如下(即只有S3待机模式可用,并且由于Hibernate(休眠不可用,其他相关模式(Fast Startup快速开机)也不可用)

  - 这是一个2023年的游戏本,不支持S0待机模式,意味着从睡眠中唤醒需要一定时间(好几秒)

    ```bash
    PS C:\Users\cxxu>  powercfg /a
    The following sleep states are available on this system:
        Standby (S3)
    
    The following sleep states are not available on this system:
        Standby (S1)
            The system firmware does not support this standby state.
    
        Standby (S2)
            The system firmware does not support this standby state.
    
        Hibernate
            Hibernation has not been enabled.
    
        Standby (S0 Low Power Idle)
            The system firmware does not support this standby state.
    
        Hybrid Sleep
            Hibernation is not available.
            The hypervisor does not support this standby state.
    
        Fast Startup
            Hibernation is not available.
    ```

    启用休眠后,支持Hibernate和Fast Startup

  - ```bash
    [BAT:79%][MEM:34.38% (10.90/31.70)GB][20:49:10]
    [C:\repos\scripts\ModulesByCxxu\Startup]
    PS>powercfg /a
    The following sleep states are available on this system:
        Standby (S3)
        Hibernate
        Fast Startup
    
    The following sleep states are not available on this system:
        Standby (S1)
            The system firmware does not support this standby state.
    
        Standby (S2)
            The system firmware does not support this standby state.
    
        Standby (S0 Low Power Idle)
            The system firmware does not support this standby state.
    
        Hybrid Sleep
            The hypervisor does not support this standby state.
    ```

- 另一台机器是中文显示语言,系统提示如下(解释得比英文版要清楚(S0和Sx(x=1,2,3)不兼容,S0可用时后三者不可用)

  - 这是一台2019年的轻薄本,支持S0模式,也就是可以快速唤醒的休眠模式(这个过程很快)
  - 实际上,有时我在这个机器高负载时点击了睡眠,风扇还是会高速转好一会儿,跟据任务的不同,有时会快速会进入低功耗状态

  ```
  PS> powercfg /a
  此系统上有以下睡眠状态:
      待机 (S0 低电量待机) 连接的网络
      休眠
      快速启动
  
  此系统上没有以下睡眠状态:
      待机 (S1)
          系统固件不支持此待机状态。
          当支持 S0 低电量待机时，禁用此待机状态。
  
      待机 (S2)
          系统固件不支持此待机状态。
          当支持 S0 低电量待机时，禁用此待机状态。
  
      待机 (S3)
          当支持 S0 低电量待机时，禁用此待机状态。
  
      混合睡眠
          待机(S3)不可用。
  ```

  

### 睡眠(待机)档位说明

总的来说,Sx中x数值越大,节能效果越明显,但是唤醒速度也越慢,并且S1,S2,基本淘汰,而S3也不够现代化,所以S0,S4

​	 **S0**    Morden Standby

   **S1**    light sleep.

   **S2**    deeper sleep.

   **S3**    deepest sleep.

   **S4**    hibernation.

在计算机硬件和操作系统领域中，S0、S1、S2是ACPI（Advanced Configuration and Power Interface，高级配置与电源接口）定义的不同电源状态级别，它们描述了计算机系统不同的电源管理和节能状态

跟据文档,最重要的是S0,S3,其余的模式不是那么常见和重要,下面简单介绍S0,S3

1. **S0**：
   - 新式睡眠,具有更快的唤醒速度
   - 与手机一样，S0 低功耗空闲模型使系统能够在低功耗模式下保持网络连接。
   - 新式待机由多种硬件和软件电源模式组成，所有这些模式都在屏幕关闭时出现。 新式待机的复杂性在于要使系统保持活动状态以处理后台任务，同时确保系统保持足够安静以实现较长的电池寿命。
4. **S3**：
   - 传统睡眠模式

不同厂商对ACPI规范的支持程度和具体实现可能会有所不同，因此对于S1和S2的实际表现可能会有所差异。

此外，较新的 ACPI 规范中，原本的S2状态在实践中逐渐被S3所取代，因为S3具有更好的性能和节能效果。

## 休眠启用条件参考

在Windows操作系统中启用休眠模式通常是默认不启用的

如果需要启用,需要满足以下条件：(现代设备硬件都支持,主要是第三点启用)

1. **硬件支持**：
   - 计算机的主板和BIOS必须支持休眠功能。
   - 计算机的硬盘应有足够的可用空间来保存休眠文件（hiberfil.sys），该文件大小通常约等于或略小于物理内存的大小(如果设置了压缩,会比较小,因此对于有超大内存的设备,比如64G,128G的设备使用休眠就不是那么合适,会大量读写磁盘)。
2. **操作系统支持**：
   - Windows系统从较早版本开始就支持休眠模式，包括但不限于Windows 7、Windows 8、Windows 10等。
3. **系统设置**：
   - 休眠模式默认可能未启用，需要通过系统设置来激活它。以下是启用Windows 10休眠模式的基本步骤：
   - 除了用**管理员权限**命令行窗口内执行`powercfg.exe -h on`,如果要显示在开始菜单电源选项中,需要打开控制面板`powercfg.cpl`,然后点击设置按钮进行设置

### 启用休眠👺

- 使用**管理员权限**命令行`powercfg -h on`系统将尝试启用休眠功能

  - 如果您的软硬件都支持,一般情况下是可以正常启用
  - 个别情况(比如驱动问题,可能会执行失败,那么您可能需要修复一下驱动问题)

- 要让Windows系统进入休眠模式，可以使用以下命令：

  - ```powershell
    powercfg /h on # 先确保休眠功能已启用
    
    ```

- 第一条命令是启用休眠功能，如果不先启用休眠，可能会发现无法进行休眠操作。


#### 立即进入休眠

- ```bash
  shutdown /h
  ```

- 次命令是实际触发休眠操作，`shutdown /h` 命令会使计算机立即进入休眠状态，并将内存中的所有内容保存到硬盘的休眠文件中，断电后仍能恢复到之前的工作状态。


### 停用休眠功能

- **关闭休眠**：

  ```cmd
  powercfg -h off
  ```


#### 影响

- 此时系统上可用的电源睡眠方案将少掉**休眠**和**快速启动**

  - ```bash
    [C:\]
    PS>powercfg /a
    The following sleep states are available on this system:
        Standby (S3)
    
    The following sleep states are not available on this system:
        Standby (S1)
            The system firmware does not support this standby state.
    
        Standby (S2)
            The system firmware does not support this standby state.
    
        Hibernate
            Hibernation has not been enabled.
    
        Standby (S0 Low Power Idle)
            The system firmware does not support this standby state.
    
        Hybrid Sleep
            Hibernation is not available.
            The hypervisor does not support this standby state.
    
        Fast Startup
            Hibernation is not available.
    ```

    

### 关闭休眠功能@删除休眠文件👺

- `powercfg -h off`

  - 该命令删除应为启用休眠功能所产生的hiberfil.sys

- 该文件是系统文件,默认是隐藏文件

  - 如果需要查看,可以用资源管理器勾选显示隐藏文件

  - 或者使用powershell,输入以下命令查看

    - `ls C:\  -Force .\hiberfil.sys`

    - ```bash
      [BAT:78%][MEM:31.96% (10.13/31.70)GB][22:37:28]
      [C:\]
      PS>ls C:\ -Force .\hiberfil.sys
      
              Directory: C:\
      
      
      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
      -a-hs         2024/4/15     16:13    13619687424   hiberfil.sys
      ```

  

## 电源计划控制工具powercfg.exe

- [Powercfg 命令行选项 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/design/device-experiences/powercfg-command-line-options)
  - 使用 powercfg.exe 来控制电源计划（也称为电源方案），以使用可用的睡眠状态、控制单个设备的电源状态，以及分析系统中常见的能效和电池寿命问题。

- 或者查看本地文档
  
  ```bash
  PS C:\Users\cxxu> powercfg.exe /?
  
  POWERCFG /COMMAND [ARGUMENTS]
  
  Description:
    Enables users to control power settings on a local system.
  
    For detailed command and option information, run "POWERCFG /? <COMMAND>"
    ....
  ```

### 休眠(hibernate)命令及其参数

前面提到的休眠命令,它的文档如下

- ```bash
  PS>powercfg /H /?
  
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

这段文档是关于Windows操作系统中的命令行工具`powercfg`的使用说明，具体针对的是与休眠功能（Hibernate）相关的子命令。`powercfg`是一个用于配置和查询电源设置的实用程序。

1. **命令格式：**
   `POWERCFG /HIBERNATE` 或者其别名 `POWERCFG /H` 可以用来启用、禁用休眠功能或设置休眠文件（hiberfile）的大小。

2. **参数说明：**
   - `<ON|OFF>`：启用或禁用系统的休眠功能。例如：
     - `POWERCFG /HIBERNATE ON` 会启用休眠功能。
     - `POWERCFG /HIBERNATE OFF` 会禁用休眠功能。

   - `/SIZE <PERCENT_SIZE>`：设置休眠文件的大小，单位为系统总内存的百分比，且最小不能小于40%。同时，使用此参数也会自动启用休眠功能。例如：
     - `POWERCFG /HIBERNATE /SIZE 100` 将休眠文件大小设置为系统总内存的100%。

   - `/TYPE <REDUCED|FULL>`：设置休眠文件类型。其中，`REDUCED`表示减缩型休眠文件，仅支持“休眠启动”（Hiberboot）；`FULL`则表示完整型休眠文件，保存完整的系统状态信息。例如：
     - `POWERCFG /HIBERNATE /TYPE REDUCED` 设置休眠文件类型为减缩型。

3. **示例：**
   文档中列举了三个使用`powercfg`命令调整休眠设置的例子，分别对应上述的不同参数选项。

### 休眠类型@压缩休眠文件

- `/Type` 参数在 `powercfg` 命令中用于设置休眠文件（hiberfile.sys）的类型，具体有两种选择：

  - `REDUCED`：
    这种类型的休眠文件仅支持“休眠启动”（Hiberboot），它是Windows的一种特性，允许系统在关机后快速恢复至之前的状态，类似于休眠模式，但主要用于加快开机速度。减缩型休眠文件只保存足够的数据来实现快速启动，而不是保存整个系统内存状态，这样可以减少磁盘空间占用，但它不支持常规的从休眠状态唤醒操作。

  - `FULL`：
    这种类型的休眠文件保存了系统关机前的所有内存状态，包括所有打开的应用程序和数据，当系统从休眠状态唤醒时，能够恢复到关机前的精确状态。这种类型的休眠文件通常较大，因为它相当于将当时所有内存的内容写入硬盘，以便下次开机时能够完全恢复之前的运行环境。

  总结来说，如果你想要节省磁盘空间并支持快速启动功能而不关心从休眠状态直接恢复到上次工作状态，可以选择 `REDUCED` 类型；而如果希望能够在关闭电脑后再次打开时回到上次工作的准确位置，则应选择 `FULL` 类型。

- 

#### hiberfil.sys系统休眠文件😊

- Hiberfil.sys 隐藏系统文件位于操作系统安装所在驱动器的根文件夹中。
-  Windows 内核电源管理器在安装 Windows 时保留此文件。
-  此文件的大小与计算机上安装的随机存取内存 (RAM) 大致相等。
- 当混合睡眠设置打开时，计算机使用 Hiberfil.sys 文件在硬盘上存储系统内存的副本。 如果此文件不存在，则计算机无法休眠。
- 通常当您执行休眠操作后,系统将在`C:\`目录生成一个隐藏系统文件`hiberfil.sys`

#### 使计算机休眠😊

- 除了使用开始菜单处设置的休眠按钮,也可考虑使用命令行`shutdown -h`来进行休眠
- 这里提到了`shutdown`命令行程序,它不仅可以用来关机,也可以用来重启或休眠计算机

## 利用命令行让windows计算机睡眠(sleep)

- [如何使用命令行让Windows 进入睡眠 (sysgeek.cn)](https://www.sysgeek.cn/put-windows-10-sleep-mode-command-line/)
  - `rundll32.exe powrprof.dll,SetSuspendState 0,1,0`

- 由于Windows本身并未提供直接通过命令行进入睡眠模式的标准命令，但可以调用PowerShell命令或者使用`rundll32.exe`来间接实现

- 如果你想确保进入的是标准睡眠模式，而不是休眠，可以尝试：

  - ```powershell
    rundll32.exe powrprof.dll,SetSuspendState 0,1,0
    ```

- 其中参数含义如下：

  - `0` 表示不强制关闭未响应的应用程序就进入睡眠状态。

  - `1` 表示进入睡眠模式（如果是0则可能进入休眠）。

  - `0` 表示不唤醒事件。



- 启用混合休眠下情况下,可以通过以下方式

  - ```powershell
    rundll32.exe powrprof.dll,SetSuspendState Hibernate
    ```

  - 上面这个命令原本是用于休眠的，但由于在某些Windows版本中，若系统配置为混合睡眠（即同时支持休眠和睡眠），运行此命令实际上会让系统进入睡眠状态。

## 命令行工具shutdown.exe

- 与powercfg命令相关的命令还有shutdown,它的用法和功能也不少,可以设置重启,休眠,关机,支持延迟操作等

- 通常适合编写部署环境的脚本,用户执行脚本后会在合适的时候关机或重启

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


### 常用语句

- `shutdown.exe` 是 Microsoft Windows 操作系统中的一个命令行工具，它可以用来计划或立即执行关机、重启、注销当前用户或使计算机进入休眠状态等操作。以下是一些 `shutdown.exe` 常用命令及其功能：

  1. **关机命令：**
     - `shutdown -s` 或 `shutdown /s` - 这将立即安排系统关机。
     - `shutdown -s -t 秒数` 或 `shutdown /s /t 秒数` - 在指定的秒数后关机。

  2. **取消关机命令：**
     - `shutdown -a` 或 `shutdown /a` - 取消任何已计划的关机、重启或休眠操作。

  3. **重启命令：**
     - `shutdown -r` 或 `shutdown /r` - 立即重启计算机。
     - `shutdown -r -t 秒数` 或 `shutdown /r /t 秒数` - 在指定的秒数后重启计算机。

  4. **延迟关机或重启：**
     - 例如，要在60分钟后关机：`shutdown -s -t 3600`
     - 若要在特定时间关机（如下午1点）：`at 13:00 shutdown -s`

  5. **强制关闭应用程序并关机：**
     - `shutdown -f -s` 或 `shutdown /f /s` - 强制结束所有应用程序然后关机。

  6. **休眠命令：**
     - `shutdown -h` 或 `shutdown /h` - 将计算机置于休眠状态（如果支持的话）。

  7. **远程关机：**
     - `shutdown -m \\计算机名 -s` - 控制远程计算机关机。

  - 在Linux系统中，虽然也有`shutdown`命令，但其语法略有不同：
     - 立即关机：`sudo shutdown -h now`
     - 立即重启：`sudo shutdown -r now`

- 根据实际需求以及操作系统版本选择合适的命令，并确保拥有足够的权限执行这些操作。在某些场合下可能需要管理员权限才能执行`shutdown`命令。

## 

## 利用powershell 关机或重启

- shutdown.exe是古老的命令行程序
- 现在可以用powershell中的相关cmdlet来执行类似操作
  - `Stop-Computer`
  - `Restart-Computer`

- 两个命令可以追加`-Force`选项强制执行,比如当计算机上有其他用户登录时




## 拓展

### 检查计算机上次启动的类型

- [Was Windows last boot from Fast Startup, Full Shutdown, Hibernate? (thewindowsclub.com)](https://www.thewindowsclub.com/windows-10-last-boot-fast-startup-full-shutdown-hibernate)

  - ```bash
    [BAT:78%][MEM:32.77% (10.39/31.70)GB][22:40:17]
    [C:\]
    PS>Get-WinEvent -ProviderName Microsoft-Windows-Kernel-boot -MaxEvents 10 | Where-Object {$_.message -like “The boot type*”}
    
       ProviderName: Microsoft-Windows-Kernel-Boot
    
    TimeCreated                     Id LevelDisplayName Message
    -----------                     -- ---------------- -------
    2024/4/15 16:13:48              27 Information      The boot type was 0x0.
    ```

- 代码说明

  - **Boot**       **Type Description**
    0x0        cold boot from full shutdown
    0x1         hybrid boot (fast startup)
    0x2         resume from hibernation
  - 说明我上次启动是冷启动

