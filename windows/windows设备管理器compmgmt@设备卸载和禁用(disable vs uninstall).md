[toc]

## 启动设备管理器

### 自带的设备管理器devmgmt

- 开始菜单直接搜:`设备管理器`(device manager)
- 命令行或运行窗口中
  - 输入`compmgmt`,然后点击设备管理器
  - 或者最简单直接输入`devmgmt`,直接打开资源管理器

## 相关命令行工具


### PnPutil

[PnPUtil - Windows drivers | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/drivers/devtest/pnputil)

### 设备控制台程序(devcon)

- [Windows 设备控制台 (Devcon.exe) - Windows drivers | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/drivers/devtest/devcon)

## 设备查看

- 由于图形界面比价直观和易于使用,但是获取的信息不容易进一步处理
- 这里介绍命令行获取设备信息,可以帮助我快速过滤满足特定条件的硬件/设备信息,例如我对于没有正常驱动的设备感兴趣,就可以用命令行来过滤

在 Windows 操作系统中，您可以使用多种命令来列出不同类型的设备。

### 老式命令

1. **列出所有设备** 使用 `wmic` (Windows Management Instrumentation Command-line) 命令：

   ```
   wmic path Win32_PnPEntity get name, status
   ```

2. **列出所有磁盘驱动器**

   ```
   wmic diskdrive list brief
   ```

3. **列出所有网络适配器**

   ```
   wmic nic get name, macaddress, status
   ```

4. **列出所有 USB 设备**

   ```
   wmic path CIM_LogicalDevice where "Description like 'USB%'" get /value
   ```

以下是每个命令的一些详细解释和示例：

1. **列出所有设备** `wmic path Win32_PnPEntity get name, status` 这个命令会列出所有的即插即用设备，包括设备名称和状态。

   ```
   C:\> wmic path Win32_PnPEntity get name, status
   Name                                 Status
   NVIDIA GeForce GTX 1050              OK
   Realtek High Definition Audio        OK
   ...
   ```

2. **列出所有磁盘驱动器** `wmic diskdrive list brief` 这个命令会简要列出所有的磁盘驱动器，包括设备 ID、型号和大小等信息。

   ```
   C:\> wmic diskdrive list brief
   DeviceID    Model                         Size
   \\.\PHYSICALDRIVE0    ST1000DM003-1ER162    1000204886016
   ```

3. **列出所有网络适配器** `wmic nic get name, macaddress, status` 这个命令会列出所有的网络适配器，包括名称、MAC 地址和状态。

   ```
   C:\> wmic nic get name, macaddress, status
   Name                  MACAddress          Status
   Intel(R) Ethernet     00:1A:2B:3C:4D:5E   OK
   ```

4. **列出所有 USB 设备** `wmic path CIM_LogicalDevice where "Description like 'USB%'" get /value` 这个命令会列出所有 USB 设备的详细信息。

   ```
   C:\> wmic path CIM_LogicalDevice where "Description like 'USB%'" get /value
   Availability=3
   Caption=USB Root Hub
   ...
   ```

5. **列出所有系统进程** `tasklist` 这个命令会列出当前正在运行的所有系统进程。

   ```
   C:\> tasklist
   Image Name                     PID Session Name        Session#
   ```



### 使用新式powershell命令

要在PowerShell中查看类似于设备管理器(Device Manager)中列出的设备信息，可以使用`Get-PnpDevice` cmdlet。以下是如何使用此命令来获取设备信息的步骤和示例。

#### 查看所有设备基本信息列表

1. 输入以下命令以列出所有即插即用设备（PnP devices）：

```powershell
Get-PnpDevice
```

3. 如果你想获取更多具体的信息，例如仅显示状态为“错误”的设备，可以使用以下命令：

```powershell
Get-PnpDevice | Where-Object { $_.Status -ne "OK" }
```

4. 你还可以根据设备类别（Class）来过滤设备。例如，要查看所有网卡（Network Adapters），可以使用：

```powershell
Get-PnpDevice -Class Net
```

### 示例解释

#### 获取所有设备信息

```powershell
Get-PnpDevice
```
此命令将列出所有设备，包括设备名称、设备类和状态。

输出示例：
```plaintext
Status     Class           FriendlyName
------     -----           ------------
OK         USB             USB Root Hub (USB 3.0)
OK         DiskDrive       WDC WD10JPVX-75JC3T0
Error      Display         NVIDIA GeForce GTX 1050
...
```

#### 获取状态为“错误”的设备

```powershell
Get-PnpDevice | Where-Object { $_.Status -ne "OK" }
```
此命令将仅显示状态不为“OK”的设备，这对于排查设备问题非常有用。

输出示例：
```powershell
PS> Get-PnpDevice | Where-Object { $_.Status -ne "OK" }

Status     Class           FriendlyName
------     -----           ------------
Unknown    HIDClass        USB Input Device
Unknown    AudioEndpoint   Speakers (High Definition Audio Device)
Error      SoftwareDevice  NVIDIA Platform Controllers and Framework
Unknown    DiskDrive       HP USB Flash Drive USB Device
```

更直接的,可以直接过滤Error的设备

```
PS> get-PnpDevice | Where-Object { $_.Status -eq "Error" }

Status     Class           FriendlyName
------     -----           ------------
Error      SoftwareDevice  NVIDIA Platform Controllers and Framework
```

上述结果表明Nvidia独立显卡没有正常启用(处于不可用状态)

这实际上是由于我打开了省电模式从而禁用了独立显卡,切换会普通模式后稍等一会儿就可以发现显卡状态错误消失了

#### 获取特定类别的设备

```powershell
Get-PnpDevice -Class Net
```
此命令将仅显示类别为网络适配器（Net）的设备。

输出示例：
```plaintext
Status     Class           FriendlyName
------     -----           ------------
OK         Net             Intel(R) Ethernet Connection (7) I219-V
OK         Net             Realtek PCIe GbE Family Controller
...
```

### 进一步筛选和排序

你可以通过组合使用`Select-Object`和`Sort-Object`来筛选和排序输出。例如，按设备名称排序并选择特定的属性：

```powershell
Get-PnpDevice | Sort-Object -Property FriendlyName | Select-Object -Property FriendlyName, Class, Status
```

通过以上命令，你可以更好地管理和查看计算机上的设备信息，类似于在设备管理器中查看设备的情况。

```
PS> Get-PnpDevice|?{$_.Class -eq 'camera'}

Status     Class           FriendlyName
------     -----           ------------
OK         Camera          Chicony USB2.0 Camera
```



## 禁用设备和卸载设备的对比

- [How to Remove a Device in Windows Device Manager (computerhope.com)](https://www.computerhope.com/issues/ch000870.htm)
- 总之,卸载设备可以理解为临时禁用,重启后会自动启用回来
- 而禁用设备表示一直禁用,重启也不会自动启用,除非手动点击启用设置回去

## 卸载独立显卡

- 由于独立显卡具有较高功耗,即便是空载,也有十多瓦的功耗,对于笔记本来说是相当高的功耗,一台轻薄本的工作功耗也就十多瓦
- 虽然许多笔记本都配备了控制中心,可以设置省电模式来禁用独立显卡,但是也会影响到cpu的性能释放
- 而直接通过设备管理器卸载显卡可能会被自动重新安装,这可能是驱动程序在维护,但这并不是我们想要的
- 我们可以先选择禁用独立显卡,然后再执行卸载操作,即先`disable`,然后再`unintsall`,但是省电效果可能没有比单纯的`disable`要好,某次实验中仍然有十几瓦的功耗
- 注意此操作后不要刷新资源管理器,否则会自动安装并启用独立显卡(这样就是禁用卸载后想要重新安装启用的方法,当然还有其他方法,比如利用控制中心切换到普通模式或性能模式冲洗启用独立显卡)

### 控制中心的电源计划模式

- 省电模式可以将平均功耗控制在15瓦左右(离电),但是个别情况下切换到省电模式显卡功耗么有被降下来,此时先切换到普通模式然后重新切换会省电模式
- 功耗可以用aida等软件查看,也可以用trafficMonitory的插件查看

## 麦克风声音调整

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/a98e99e10d7746d2a11084750f107bbe.png)

### OBS录制麦克风调整

- OBS软件支持调整麦克风声音比例超过百分百
- 









