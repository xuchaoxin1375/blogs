[toc]



## ref

- [Shut down, sleep, or hibernate your PC - Microsoft Support](https://support.microsoft.com/en-us/windows/shut-down-sleep-or-hibernate-your-pc-2941d165-7d0a-a5e8-c5ad-8c972e8e6eff)
- [win10删除休眠文件的方法是什么_windows10休眠文件怎么删除－系统城 (xitongcheng.com)](https://www.xitongcheng.com/jiaocheng/win10_article_61789.html)

##  设置前提:

### 驱动要求

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

