# Linux 必学的 60 个命令(1)-安装与登陆

Linux 必学的 60 个命令

Linux 提供了大量的命令，利用它可以有效地完成大量的工作，如磁盘操作、文件存取、目

录操作、进程管理、文件权限设定等。所以，在 Linux 系统上工作离不开使用系统提供的命

令。要想真正理解 Linux 系统，就必须从 Linux 命令学起，通过基础的命令学习可以进一步理

解 Linux 系统。

不同 Linux 发行版的命令数量不一样，但 Linux 发行版本最少的命令也有 200 多个。这里笔者

把比较重要和使用频率最多的命令，按照它们在系统中的作用分成下面六个部分一一介绍。

### ◆安装和登录命令：

login、shutdown、halt、reboot、install、mount、umount、chsh、

exit、last；

### ◆ 文件处理命令：

file、mkdir、grep、dd、find、mv、ls、diff、cat、ln；

◆

### 系统管理相关命令：

df、top、free、quota、at、lp、adduser、groupadd、kill、

crontab；

◆

### 网络操作命令：

ifconfig、ip、ping、netstat、telnet、ftp、route、rlogin、rcp、

finger、mail、 nslookup；

### ◆ 系统安全相关命令：

passwd、su、umask、chgrp、chmod、chown、chattr、sudo
ps、

who；

◆

### 其它命令：

tar、unzip、gunzip、unarj、mtools、man、unendcode、uudecode。

本文以 Mandrake Linux 9.1(Kenrel
2.4.21)为例，介绍 Linux 下的安装和登录命令。

login

1.作用

login 的作用是登录系统，它的使用权限是所有用户。

2.格式

login \[name\]\[－p \]\[－h 主机名称\]

3.主要参数

－p:通知 login 保持现在的环境参数。

－h:用来向远程登录的之间传输用户名。

如果选择用命令行模式登录 Linux 的话，那么看到的第一个 Linux 命令就是 login：。

一般界面是这样的：

Manddrake Linux release 9.1(Bamboo) for i586

kennel 2.4.21－0.13mdk on i686 / tty1

localhost login:root

password:

上面代码中，第一行是 Linux 发行版本号，第二行是内核版本号和登录的虚拟控制台，我们

在第三行输入登录名，按"Enter"键在 Password 后输入账户密码，即可登录系统。出于安

全考虑，输入账户密码时字符不会在屏幕上回显，光标也不移动。

登录后会看到下面这个界面（以超级用户为例）：

\[root\@localhost root\]\#

last login:Tue ,Nov 18 10:00:55 on vc/1

上面显示的是登录星期、月、日、时间和使用的虚拟控制台。

4.应用技巧

Linux 是一个真正的多用户操作系统，可以同时接受多个用户登录，还允许一个用户进行多

次登录。这是因为 Linux 和许多版本的 Unix 一样，提供了虚拟控制台的访问方式，允许用户

在同一时间从控制台（系统的控制台是与系统直接相连的监视器和键盘）进行多次登录。每

个虚拟控制台可以看作是一个独立的工作站，工作台之间可以切换。虚拟控制台的切换可以

通过按下 Alt 键和一个功能键来实现，通常使用 F1-F6 。

例如，用户登录后，按一下"Alt+F2"键，用户就可以看到上面出现的"login:"提示符，

说明用户看到了第二个虚拟控制台。然后只需按"Alt+
F1"键，就可以回到第一个虚拟控

制台。一个新安装的 Linux 系统允许用户使用"Alt+F1"到"Alt+F6"键来访问前六个虚拟

控制台。虚拟控制台最有用的是，当一个程序出错造成系统死锁时，可以切换到其它虚拟控

制台工作，关闭这个程序。

shutdown

1.作用

shutdown 命令的作用是关闭计算机，它的使用权限是超级用户。

2.格式

shutdown \[－h\]\[－i\]\[－k\]\[－m\]\[－t\]

3.重要参数

－t：在改变到其它运行级别之前，告诉 init 程序多久以后关机。

－k：并不真正关机，只是送警告信号给每位登录者。

－h：关机后关闭电源。

－c：cancel current
process 取消目前正在执行的关机程序。所以这个选项当然没有时间

参数，但是可以输入一个用来解释的讯息，而这信息将会送到每位使用者。

－F：在重启计算机时强迫 fsck。

－time：设定关机前的时间。

－m: 将系统改为单用户模式。

－i：关机时显示系统信息。

4.命令说明

shutdown 命令可以安全地将系统关机。有些用户会使用直接断掉电源的方式来关闭 Linux 系

统，这是十分危险的。因为 Linux 与 Windows 不同，其后台运行着许多进程，所以强制关机可

能会导致进程的数据丢失，使系统处于不稳定的状态，甚至在有的系统中会损坏硬件设备（

硬盘）。在系统关机前使用
shutdown 命令，系统管理员会通知所有登录的用户系统将要关

闭，并且 login 指令会被冻结，即新的用户不能再登录。

5.举例

shutdown -h 3:40

说明 3：40 开始关机。

halt

1.作用

halt 命令的作用是关闭系统，它的使用权限是超级用户。

2.格式

halt \[－n\] \[－w\] \[－d\] \[－f\] \[－i\] \[－p\]

3.主要参数说明

－n：防止 sync 系统调用，它用在用 fsck 修补根分区之后，以阻止内核用老版本的超级块覆

盖修补过的超级块。

－w：并不是真正的重启或关机,只是写 wtmp（/var/log/wtmp）纪录。

－f：没有调用 shutdown，而强制关机或重启。

－i：关机（或重启）前，关掉所有的网络接口。

－f：强迫关机，不呼叫 shutdown 这个指令。

－p: 当关机的时候顺便做关闭电源的动作。

－d：关闭系统，但不留下纪录。

4.命令说明

halt 就是调用 shutdown
－h。halt 执行时，杀死应用进程，执行 sync(将存于 buffer 中的资

料强制写入硬盘中)系统调用，文件系统写操作完成后就会停止内核。若系统的运行级别为

0 或 6，则关闭系统；否则以 shutdown 指令（加上－h 参数）来取代。

reboot

1.作用

reboot 命令的作用是重新启动计算机，它的使用权限是系统管理者。

2.格式

reboot \[－n\] \[－w\] \[－d\] \[－f\] \[－i\]

3.主要参数

－n: 在重开机前不做将记忆体资料写回硬盘的动作。

－w: 并不会真的重开机，只是把记录写到/var/log/wtmp 文件里。

－d: 不把记录写到/var/log/wtmp 文件里（－n 这个参数包含了－d）。

－i: 在重开机之前先把所有与网络相关的装置停止。

install

1.作用

install 命令的作用是安装或升级软件或备份数据，它的使用权限是所有用户。

2.格式

(1)install \[选项\]\... 来源 目的地

(2)install \[选项\]\... 来源\... 目录

(3)install －d \[选项\]\... 目录\...

在前两种格式中，会将\<来源>复制至\<目的地>或将多个\<来源>文件复制至已存在的\<目录>，

同时设定权限模式及所有者/所属组。在第三种格式中，会创建所有指定的目录及它们的主

目录。长选项必须用的参数在使用短选项时也是必须的。

3.主要参数

－－backup\[=CONTROL\]：为每个已存在的目的地文件进行备份。

－b：类似 －－backup，但不接受任何参数。

－c：(此选项不作处理)。

－d，－－directory：所有参数都作为目录处理，而且会创建指定目录的所有主目录。

－D：创建\<目的地>前的所有主目录，然后将\<来源>复制至
\<目的地>；在第一种使用格式中

有用。

－g，－－group=组：自行设定所属组，而不是进程目前的所属组。

－m，－－mode=模式：自行设定权限模式 (像 chmod)，而不是 rwxr－xr－x。

－o，－－owner=所有者：自行设定所有者 (只适用于超级用户)。

－p，－－preserve－timestamps：以\<来源>文件的访问/修改时间作为相应的目的地文件的

时间属性。

－s，－－strip：用 strip 命令删除 symbol
table，只适用于第一及第二种使用格式。

－S，－－suffix=后缀：自行指定备份文件的\<后缀>。

－v，－－verbose：处理每个文件/目录时印出名称。

－－help：显示此帮助信息并离开。

－－version：显示版本信息并离开。

mount

1.作用

mount 命令的作用是加载文件系统，它的用权限是超级用户或/etc/fstab 中允许的使用者。

2.格式

mount －a \[－fv\] \[－t vfstype\] \[－n\] \[－rw\] \[－F\] device dir

3.主要参数

－h：显示辅助信息。

－v：显示信息，通常和－f 用来除错。

－a：将/etc/fstab 中定义的所有文件系统挂上。

－F：这个命令通常和－a 一起使用，它会为每一个 mount 的动作产生一个行程负责执行。在

系统需要挂上大量 NFS 文件系统时可以加快加载的速度。

－f：通常用于除错。它会使 mount 不执行实际挂上的动作，而是模拟整个挂上的过程，通常

会和－v 一起使用。

－t vfstype：显示被加载文件系统的类型。

－n：一般而言，mount 挂上后会在/etc/mtab 中写入一笔资料，在系统中没有可写入文件系

统的情况下，可以用这个选项取消这个动作。

4.应用技巧

在 Linux 和 Unix 系统上，所有文件都是作为一个大型树（以/为根）的一部分访问的。要访问

CD-ROM 上的文件，需要将 CD-ROM 设备挂装在文件树中的某个挂装点。如果发行版安装了自动

挂装包，那么这个步骤可自动进行。在 Linux 中，如果要使用硬盘、光驱等储存设备，就得

先将它加载，当储存设备挂上了之后，就可以把它当成一个目录来访问。挂上一个设备使用

mount 命令。在使用 mount 这个指令时，至少要先知道下列三种信息：要加载对象的文件系统

类型、要加载对象的设备名称及要将设备加载到哪个目录下。

（1）Linux 可以识别的文件系统

◆ Windows 95/98 常用的 FAT 32 文件系统：vfat ；

◆ Win NT/2000 的文件系统：ntfs ；

◆ OS/2 用的文件系统：hpfs；

◆ Linux 用的文件系统：ext2、ext3；

◆ CD-ROM 光盘用的文件系统：iso9660。

虽然 vfat 是指 FAT 32 系统，但事实上它也兼容 FAT 16 的文件系统类型。

（2）确定设备的名称

在 Linux 中，设备名称通常都存在/dev 里。这些设备名称的命名都是有规则的，可以用"推

理"的方式把设备名称找出来。例如，/dev/hda1 这个 IDE 设备，hd 是 Hard
Disk(硬盘)的，

sd 是 SCSI Device，fd 是 Floppy Device(或是 Floppy
Disk?)。a 代表第一个设备，通常 IDE 接

口可以接上 4 个 IDE 设备(比如 4 块硬盘)。所以要识别 IDE 硬盘的方法分别就是 hda、hdb、hdc

、 hdd。hda1 中的"1"代表 hda 的第一个硬盘分区
(partition)，hda2 代表 hda 的第二主分

区，第一个逻辑分区从 hda5 开始，依此类推。此外，可以直接检查/var/log/messages 文件

，在该文件中可以找到计算机开机后系统已辨认出来的设备代号。

（3）查找挂接点

在决定将设备挂接之前，先要查看一下计算机是不是有个/mnt 的空目录，该目录就是专门用

来当作挂载点(Mount
Point)的目录。建议在/mnt 里建几个/mnt/cdrom、/mnt/floppy、

/mnt/mo 等目录，当作目录的专用挂载点。举例而言，如要挂载下列 5 个设备，其执行指令可

能如下 (假设都是 Linux 的 ext2 系统，如果是 Windows XX 请将 ext2 改成 vfat)：

软盘 ===>mount －t ext2 /dev/fd0 /mnt/floppy

cdrom ===>mount －t iso9660 /dev/hdc /mnt/cdrom

SCSI cdrom ===>mount －t iso9660 /dev/sdb /mnt/scdrom

SCSI cdr ===>mount －t iso9660 /dev/sdc /mnt/scdr

不过目前大多数较新的 Linux 发行版本（包括红旗 Linux、中软 Linux、Mandrake
Linux 等）

都可以自动挂装文件系统，但 Red Hat Linux 除外。

umount

1.作用

umount 命令的作用是卸载一个文件系统，它的使用权限是超级用户或/etc/fstab 中允许的使

用者。

2.格式

umount －a \[－fFnrsvw\] \[－t vfstype\] \[－n\] \[－rw\] \[－F\] device
dir

3.使用说明

umount 命令是 mount 命令的逆操作，它的参数和使用方法和 mount 命令是一样的。Linux 挂装

CD-ROM 后，会锁定 CD---ROM，这样就不能用 CD-ROM 面板上的 Eject 按钮弹出它。但是，当不再

需要光盘时，如果已将/cdrom 作为符号链接，请使用 umount/cdrom 来卸装它。仅当无用户正

在使用光盘时，该命令才会成功。该命令包括了将带有当前工作目录当作该光盘中的目录的

终端窗口。

chsh

1.作用

chsh 命令的作用是更改使用者 shell 设定，它的使用权限是所有使用者。

2.格式

chsh \[ －s \] \[ －list\] \[ －－help \] \[ －v \] \[ username \]

3.主要参数

－l：显示系统所有 Shell 类型。

－v：显示 Shell 版本号。

4.应用技巧

前面介绍了 Linux 下有多种 Shell，一般缺省的是 Bash，如果想更换 Shell 类型可以使用 chsh

命令。先输入账户密码，然后输入新 Shell 类型，如果操作正确系统会显示"Shell
change

"。其界面一般如下：

Changing fihanging shell for cao

Password:

New shell \[/bin/bash\]: /bin/tcsh

上面代码中，\[
\]内是目前使用的 Shell。普通用户只能修改自己的 Shell，超级用户可以修

改全体用户的 Shell。要想查询系统提供哪些 Shell，可以使用 chsh -l
命令，见图 1 所示。

图 1 系统可以使用的 Shell 类型

从图 1 中可以看到，笔者系统中可以使用的 Shell 有 bash（缺省）、csh、sh、tcsh 四种。

exit

1.作用

exit 命令的作用是退出系统，它的使用权限是所有用户。

2.格式

exit

3.参数

exit 命令没有参数，运行后退出系统进入登录界面。

last

1.作用

last 命令的作用是显示近期用户或终端的登录情况，它的使用权限是所有用户。通过 last 命

令查看该程序的 log，管理员可以获知谁曾经或企图连接系统。

2.格式

1ast\[---n\]\[－f file\]\[－t tty\] \[---h 节点\]\[－I
---IP\]\[---1\]\[－y\]\[1D\]

3.主要参数

－n：指定输出记录的条数。

－f file：指定用文件 file 作为查询用的 log 文件。

－t tty：只显示指定的虚拟控制台上登录情况。

－h 节点：只显示指定的节点上的登录情况。

－i IP：只显示指定的 IP 上登录的情况。

－1：用 IP 来显示远端地址。

－y：显示记录的年、月、日。

－ID：知道查询的用户名。

－x:显示系统关闭、用户登录和退出的历史。

动手练习

上面介绍了 Linux 安装和登录命令，下面介绍几个实例，动手练习一下刚才讲过的命令。

1.一次运行多个命令

在一个命令行中可以执行多个命令，用分号将各个命令隔开即可，例如：

#last －x；halt

上面代码表示在显示系统关闭、用户登录和退出的历史后关闭计算机。

2.利用 mount 挂装文件系统访问 Windows 系统

许多 Linux 发行版本现在都可以自动加载 Vfat 分区来访问 Windows 系统，而 Red
Hat 各个版本

都没有自动加载 Vfat 分区，因此还需要进行手工操作。

mount 可以将 Windows 分区作为 Linux 的一个"文件"挂接到 Linux 的一个空文件夹下，从而将

Windows 的分区和/mnt 这个目录联系起来。因此，只要访问这个文件夹就相当于访问该分区

了。首先要在/mnt 下建立 winc 文件夹，在命令提示符下输入下面命令：

#mount -t vfat /dev/hda1 /mnt/winc

即表示将 Windows 的 C 分区挂到 Liunx 的/mnt/winc 目录下。这时，在/mnt/winc 目录下就可以

看到 Windows 中 C 盘的内容了。使用类似的方法可以访问 Windows 系统的 D、E 盘。在 Linux 系统

显示 Windows 的分区一般顺序这样的：hda1 为 C 盘、hda5 为 D 盘、
hda6 为 E 盘......以此类推。

上述方法可以查看 Windows 系统有一个很大的问题，就是 Windows 中的所有中文文件名或文件

夹名全部显示为问号
"？"，而英文却可以正常显示。我们可以通过加入一些参数让它显

示中文。还以上面的操作为例，此时输入命令：

#mount -t vfat -o iocharset=cp936 /dev/hda1 /mnt/winc

现在它就可以正常显示中文了。

3.使用 mount 加挂闪盘上的文件系统

在 Linux 下使用闪盘非常简单。Linux 对 USB 设备有很好的支持，当插入闪盘后，闪盘被识别

为一个 SCSI 盘，通常输入以下命令：

\# mount /dev/sda1 /usb

就能够加挂闪盘上的文件系统。

小知识

Linux 命令与 Shell

所谓 Shell，就是命令解释程序，它提供了程序设计接口，可以使用程序来编程。学习

Shell 对于 Linux 初学者理解 Linux 系统是非常重要的。
Linux 系统的 Shell 作为操作系统的外

壳，为用户提供了使用操作系统的接口。Shell 是命令语言、命令解释程序及程序设计语言

的统称，是用户和
Linux 内核之间的接口程序。如果把 Linux 内核想象成一个球体的中心，

Shell 就是围绕内核的外层。当从 Shell 或其它程序向 Linux 传递命令时，内核会做出相应的

反应。Shell 在 Linux 系统的作用和 MS DOS 下的 COMMAND.COM 和 Windows 95/98 的

explorer.exe 相似。Shell 虽然不是系统核心的一部分，只是系统核心的一个外延，但它能

够调用系统内核的大部分功能。因此，可以说
Shell 是 Unux/Linux 最重要的实用程序。

Linux 中的 Shell 有多种类型，其中最常用的是 Bourne Shell(sh)、C
Shell(csh)和 Korn

Shell(ksh)。大多数 Linux 发行版本缺省的 Shell 是 Bourne Again
Shell，它是 Bourne

Shell 的扩展，简称 bash，与 Bourne Shell 完全向后兼容，并且在 Bourne
Shell 的基础上增

加了很多特性。bash 放在/bin/bash 中，可以提供如命令补全、命令编辑和命令历史表等功

能。它还包含了很多 C Shell 和 Korn
Shell 中的优点，有灵活和强大的编程接口，同时又有

很友好的用户界面。Linux 系统中 200 多个命令中有 40 个是 bash 的内部命令，主要包括
exit

、less、lp、kill、 cd、pwd、fc、fg 等。
