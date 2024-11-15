[toc]

## abstract

[BCDEdit 命令行选项 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/bcdedit-command-line-options?view=windows-11)

在Windows双系统环境中（例如安装了Windows 10和Windows 11），可能需要对每个操作系统的启动项名称进行修改，以便更清晰地区分它们。

这通常涉及到编辑引导加载程序（Boot Loader）的设置。对于Windows系统，这可以通过使用`bcdedit`命令来实现。

**bcdeditor**:(Boot Configuration Data Store Editor)

另外,windows自带的GUI程序`msconfig`中可以查看所有系统启动项以及默认启动项,当前系统所在盘符等信息,还可以删除启动项,设置**启动倒计时时间**,但是无法重命名启动项名称

此外`msconfig`设置的时间区间是`3-999`,使用`SystemPropertiesAdvanced.exe`中的启动项设置可以设置更短的时间,但是其他功能仍然有限

关于bcdedit更改启动项的操作演示和说明,可以直接跳转到相应章节

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

## 操作演示

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

### 修改默认引导系统

```cmd

C:\Users\cxxu\Desktop# bcdedit /default {c8bae8c5-939a-11ef-a658-30f6ef072e65}
The operation completed successfully.
```



## 注意事项：
- 操作`bcdedit`命令时要特别小心，错误的操作可能会导致无法正常启动操作系统。
- 如果你不熟悉命令行操作，建议在尝试上述步骤之前备份重要数据，并考虑寻求专业人士的帮助。