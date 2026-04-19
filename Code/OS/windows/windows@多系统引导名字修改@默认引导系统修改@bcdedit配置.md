[toc]

## abstract

[BCDEdit 命令行选项 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/bcdedit-command-line-options?view=windows-11)

在Windows双系统环境中（例如安装了Windows 10和Windows 11），可能需要对每个操作系统的启动项名称进行修改，以便更清晰地区分它们。

这通常涉及到编辑引导加载程序（Boot Loader）的设置。对于Windows系统，这可以通过使用`bcdedit`命令来实现。

**bcdeditor**:(Boot Configuration Data Store Editor)

另外,windows自带的GUI程序`msconfig`中可以查看所有系统启动项以及默认启动项,当前系统所在盘符等信息,还可以删除启动项,设置**启动倒计时时间**,但是无法重命名启动项名称

此外`msconfig`设置的时间区间是`3-999`,使用`SystemPropertiesAdvanced.exe`中的启动项设置可以设置更短的时间,但是其他功能仍然有限

关于bcdedit更改启动项的操作演示和说明,可以直接跳转到相应章节

## 相关软件

第三软件有集成系统引导设置功能的入口,提供更完整和方便的设置体验

- [EasyBCD - NeoSmart Technologies](https://neosmart.net/EasyBCD/)
  - 个人用户选择最后一个非商用版本(免费,需要填写邮箱)
- [windows重启到另一个系统@重启到bios-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/144302302)

## 修改Windows启动项名称的步骤

### 准备工作

1. **启动任一Windows系统**：
   首先，你需要启动到你想要保留或不需要更改名称的Windows系统中。

2. **以管理员身份运行命令提示符**：
   - 按 `Win + X` 键，然后选择“命令提示符 (管理员)”或“Windows PowerShell (管理员)”

3. **列出所有启动项**：
   在打开的命令提示符或PowerShell窗口中，输入以下命令并按回车键执行：

   ```cmd
   bcdedit.exe
   ```

   或者查看更多启动项

   ```shell
   bcdedit /enum all
   ```
   这将显示所有已知的启动项及其**标识符**（ID）。

   注意每个Windows系统的标识符，**特别是你想修改的那个**。

   

### 修改启动项名称：

使用`bcdedit /set`命令加上你想修改的启动项的标识符（ID）和新的描述名称。命令格式如下：

```shell
bcdedit /set {identifier} description "新的启动项名称"
```
其中 `{identifier}` 是上一步找到的目标操作系统的唯一标识符，而 `"新的启动项名称"` 是你希望设置的新名称。

1. **验证更改**：
   再次运行 `bcdedit /enum all` 命令来检查是否成功更改了启动项名称。
2. **重启计算机**：
   最后，重启计算机并进入启动菜单（通常是按F8或Esc键，具体取决于你的计算机品牌和型号），查看启动项名称是否已经更新。

## bcdedit常用命令

### 中文帮助文档概述

```cmd
PS> bcdedit /?

BCDEDIT - 启动配置数据存储编辑器

Bcdedit.exe 命令行工具用于修改启动配置数据存储。
启动配置数据存储包含启动配置参数并
控制操作系统的启动方式。这些参数以前
位于 Boot.ini 文件中(在基于 BIOS 的操作系统中)或位于非易失性 RAM 项中
(在基于可扩展固件接口的操作系统中)。可以
使用 Bcdedit.exe 在启动配置数据存储中
添加、删除、编辑和附加项。

有关命令和选项的详细信息，请键入 bcdedit.exe /? <command>。例如，
若要显示有关 /createstore 命令的详细信息，请键入:

     bcdedit.exe /? /createstore

有关本帮助文件中按字母顺序排列的主题列表，请运行 "bcdedit /? TOPICS"。

对存储执行的命令
================================
/store          用于指定当前系统默认值以外的 BCD 存储。
/createstore    新建空的启动配置数据存储。
/export         将系统存储的内容导出到文件。以后
                可以使用该文件还原系统存储的状态。
/import         使用 /export 命令创建的备份文件来还原
                系统存储的状态。
/sysstore       设置系统存储设备(仅影响 EFI 系统，在重新启动后不再保留，
               且仅用于系统存储
                设备不确定的情况下)。

对存储中的项执行的命令
===========================================
/copy           复制存储中的项。
/create         在存储中创建新项。
/delete         删除存储中的项。
/mirror         创建存储中项的镜像。

运行 bcdedit /? ID 可获得有关这些命令使用的标识符的信息。

对项选项执行的命令
======================================
/deletevalue    删除存储中的项选项。
/set            设置存储中的项选项值。

运行 bcdedit /? TYPES 可获得这些命令使用的数据类型的列表。
运行 bcdedit /? FORMATS 可获得有效数据格式的列表。

控制输出的命令
============================
/enum           列出存储中的项。
/v              命令行选项，完整显示项标识符，
                而不是使用已知标识符的名称。
                单独使用命令 /v 可完整
                显示 ACTIVE 类型的项标识符。

单独运行 "bcdedit" 等同于运行 "bcdedit /enum ACTIVE"。

控制启动管理器的命令
======================================
/bootsequence   为启动管理器设置一次性启动序列。
/default        设置启动管理器将使用的默认项。
/displayorder   设置启动管理器显示
                多重启动菜单的顺序。
/timeout        设置启动管理器的超时值。
/toolsdisplayorder  设置启动管理器显示工具
                    菜单的顺序。

控制启动应用程序紧急管理服务的命令
==========================================================================
/bootems        启用或禁用启动应用程序的
                紧急管理服务。
/ems            启用或禁用操作系统项的
                紧急管理服务。
/emssettings    设置全局紧急管理服务参数。

控制调试的命令
==============================
/bootdebug      启用或禁用启动应用程序的启动调试。
/dbgsettings    设置全局调试程序参数。
/debug          启用或禁用操作系统项的内核
                调试。
/hypervisorsettings  设置虚拟机监控程序的参数。

控制远程事件日志记录的命令
=========================================
/eventsettings  设置全局远程事件日志记录参数。
/event          启用或禁用操作系统项的远程
                事件日志记录。
```



### 控制引导项

```cmd
Commands that control the boot manager
======================================
/bootsequence   Sets the one-time boot sequence for the boot manager.
/default        Sets the default entry that the boot manager will use.
/displayorder   Sets the order in which the boot manager displays the
                multiboot menu.
/timeout        Sets the boot manager time-out value.
/toolsdisplayorder  Sets the order in which the boot manager displays
                    the tools menu.
```

比如修改默认引导项,使用`/default`选项

### bcdedit /set 文档

```cmd
PS> bcdedit /set /?

此命令在引导配置数据存储中设置项选项值。

bcdedit [/store <filename>] /set [{<id>}] <datatype> <value> [/addfirst | /addlast | /remove ]

    <filename> 指定要使用的存储。如果此选项未
                指定，则使用系统存储。有关详细信息，
                运行 "bcdedit /? store"。

    <id>        指定要修改的项的标识符。如果未
                指定，则使用 {current}。有关
                标识符的详细信息，运行 "bcdedit /? ID"。

<datatype>  指定将创建或修改的选项数据
                类型。运行 "bcdedit /? TYPES" 了解有关数据类型的
                详细信息。

    <value>     指定应该分配给选项的值。
                <value> 的格式取决于指定的数据类型。运行
                "bcdedit /? FORMATS" 了解数据格式的详细信息。

    /addfirst   此交换机仅在数据类型为对象列表时才可使用。
                将指定的项标识符添加到列表的顶部。
                如果指定此交换机，则将仅指定单个项
                标识符。 如果指定的标识符已存在于
                列表中，它将被移到列表的顶部。

    /addlast    此交换机仅在数据类型为对象列表时才可使用。
                将指定的项标识符添加到列表的末尾。
                如果指定了此交换机，则将仅指定单个项
                标识符。如果指定的标识符已存在
                于列表中，它将被移到列表的末尾。

    /remove     此交换机仅在数据类型为对象列表时才可使用。
                从列表中移除指定的项标识符。
                如果指定了此交换机，将仅指定单个项
                标识符。如果该标识符不在列表中，
                则该操作不起作用。如果最后一项
                被删除，则数据类型值也将删除。

示例:

以下命令将应用程序设备设置为分区 C: 对于
指定的操作系统项:

    bcdedit /设置 {cbd971bf-b7b8-4885-951a-fa03044f5d71} 设备分区=C:

    注意: 使用 "hd_partition=" 语法显式禁用自动 VHD
          检测，并创建兼容的项以启动
          虚拟机，即

    bcdedit /store F:\boot\bcd /set{default}device hd_partition=F:

以下命令将操作系统设备设置为 VHD 文件(C:\vdisks\vdisk01.vhd)
对于指定的操作系统项:

    bcdedit /set {cbd971bf-b7b8-4885-951a-fa03044f5d71} osdevice
        vhd=[C:]\vdisks\disk01.vhd

以下命令将应用程序的路径设置为
指定的操作系统项的 \windows\system32\winload.exe:

    bcdedit /set {cbd971bf-b7b8-4885-951a-fa03044f5d71} 路径
        \windows\system32\winload.exe

以下命令针对当前操作
系统启动项将 NX 策略设置为 OptIn。

    bcdedit /set nx optin
```



```cmd
PS> bcdedit set /?

This command sets an entry option value in the boot configuration data store.

bcdedit [/store <filename>] /set [{<id>}] <datatype> <value> [ /addfirst | /addlast | /remove ]

    <filename>  Specifies the store to be used. If this option is not
                specified, the system store is used. For more information,
                run "bcdedit /? store".

    <id>        Specifies the identifier of the entry to be modified.  If not
                specified, {current} is used. For more information about
                identifiers, run "bcdedit /? ID".

    <datatype>  Specifies the option data type that will be created or
                modified. Run "bcdedit /? TYPES" for more information about
                data types.

    <value>     Specifies the value that should be assigned to the option. The
                format of <value> depends on the data type specified. Run
                "bcdedit /? FORMATS" for more information about data formats.

    /addfirst   This switch can only be used if datatype is an object list.
                Adds the specified entry identifier to the top of the list.
                If this switch is specified, only a single entry identifier
                may be specified.  If the specified identifier is already
                in the list, it will be moved to the top of the list.

    /addlast    This switch can only be used if datatype is an object list.
                Adds the specified entry identifier to the end of the list.
                If this switch is specified, only a single entry identifier
                may be specified.  If the specified identifier is already
                in the list, it is moved to the end of the list.

    /remove     This switch can only be used if datatype is an object list.
                Removes the specified entry identifier from the list.
                If this switch is specified, only a single entry identifier
                may be specified.  If the identifier is not in the list
                then the operation has no effect. If the last entry is being
                removed, then the datatype value is deleted.

Examples:

The following command sets the application device to the partition C: for the
specified operating system entry:

    bcdedit /set {cbd971bf-b7b8-4885-951a-fa03044f5d71} device partition=C:

    NOTE: Use 'hd_partition=' syntax to explicitly disable automatic VHD
          detection, and create entries that are compatible for booting a
          virtual machine, i.e.,

    bcdedit /store F:\boot\bcd /set {default} device hd_partition=F:

The following command sets the OS device to a VHD file (C:\vdisks\vdisk01.vhd)
for the specified operating system entry:

    bcdedit /set {cbd971bf-b7b8-4885-951a-fa03044f5d71} osdevice
        vhd=[C:]\vdisks\disk01.vhd

The following command sets the application path to
\windows\system32\winload.exe for the specified operating system entry:

    bcdedit /set {cbd971bf-b7b8-4885-951a-fa03044f5d71} path
        \windows\system32\winload.exe

The following command sets the NX policy to OptIn for the current operating
system boot entry.

```

## 经典案例操作演示👺

### 查询identifier👺

```cmd
Commands that control output
============================
/enum           Lists entries in the store.
/v              Command-line option that displays entry identifiers in full,
                rather than using names for well-known identifiers.
                Use /v by itself as a command to display entry identifiers
                in full for the ACTIVE type.

Running "bcdedit" by itself is equivalent to running "bcdedit /enum ACTIVE".
```

下面的大多数操作需要知道操作对象(引导项)的`identifier`,它可以通过`bcdedit `或`bcdedit /v`查看

详细说明见文档

例如,找到要更改的启动项的`identifier`

先用`bcdedit`查询boot loader 信息,获取`identifier`

```cmd
Windows Boot Loader
-------------------
identifier              {88888866-7880-46de-8439-4fc3d0fb4ce6}
device                  ramdisk=[D:]\WEPE\WEPE64.WIM,{888885bd-e62a-4d9f-b133-f2551f11e866}
path                    \windows\system32\boot\winload.efi
....
```

如果`identifier`是`{defaut}`,那么可以使用`bcdedit /v`来强制显示标准格式而非缩写(不过这不是必须的，使用`{default}`缩写一样可以完成命令)

上述例子中,` {88888866-7880-46de-8439-4fc3d0fb4ce6}`就是安装在D盘上的操作系统的`identifier`

注意,C,D,E,..盘上的系统对应关系到底是什么要以当前系统分配的为准,不同系统进去后分配的盘符不同,可用资源管理器查看各个盘符的系统对应关系,或`msconfig`以及`bcdedit`本身也可以查看各个`windows boot loader`

### 修改多系统启动名称 windows boot loader项

```cmd
PS> cmd /c 'bcdedit /set  {88888866-7880-46de-8439-4fc3d0fb4ce6} description "we pe"'
The operation completed successfully.
```

注意`bcdedit`适合在cmd下执行,如果powershell上执行,需要使用`cmd /c  '....'` 来包装一下再执行或者使用`start-process`命令来执行,也要注意`{ }`需要使用引号包裹

另外,更改的新名字建议包裹在双引号内`" "`,这样即使新名字里面有空格也不影响,名字尽量使用英文,减少出现乱码的可能和几率

检查结果

- 可以用bcdedit检查,也可以用GUI程序,比如`msconfig`中的boot选项卡检查

```cmd
Windows Boot Loader
-------------------
identifier              {88888866-7880-46de-8439-4fc3d0fb4ce6}
device                  ramdisk=[D:]\WEPE\WEPE64.WIM,{888885bd-e62a-4d9f-b133-f2551f11e866}
path                    \windows\system32\boot\winload.efi
description             we pe
osdevice                ramdisk=[D:]\WEPE\WEPE64.WIM,{888885bd-e62a-4d9f-b133-f2551f11e866}
systemroot              \windows
nx                      OptIn
pae                     ForceEnable
detecthal               Yes
winpe                   Yes
```

### 修改当前系统的启动项名称

例如,我把当前系统启动项改为`"Win 11 IoT Enterprise"`,可以省略掉`identifier`的指定

```cmd

PS> cmd /c 'bcdedit /set description "Win 11 IoT Enterprise"'
The operation completed successfully.
```

### 修改默认引导项的启动名称

比如我将默认引导的系统的启动名称改为`win11 23h2 pro lite`

```cmd
PS> cmd /c 'bcdedit /set   {default}  description "win11 23h2 pro lite"'
The operation completed successfully.
```



### 将选择倒计时时间更改

为了避免倒计时带来的卡机速度减慢,可以将倒计时更改为1秒

```cmd
PS> bcdedit /timeout 1
操作成功完成。
```

这种情况下,如果要切换为非默认系统,需要在开机时快速点击上下箭头中的一个,避免错失切换机会

## 修改默认引导系统👺

例如

```cmd
C:\Users\cxxu\Desktop# bcdedit /default {c8bae8c5-939a-11ef-a658-30f6ef072e65}
The operation completed successfully.
```

这部分也可以用GUI程序来修改,打开`msconfig`中的boot选项卡进行默认启动项修改,还可以删除掉启动项

或者`SystemPropertiesAdvanced.exe`系统属性->高级->启动和故障恢复->设置里也可以设置默认启动项,还可以设置倒计时(允许低于3秒)

## 注意事项：
- 操作`bcdedit`命令时要特别小心，错误的操作可能会导致无法正常启动操作系统。
- 如果你不熟悉命令行操作，建议在尝试上述步骤之前备份重要数据，并考虑寻求专业人士的帮助。