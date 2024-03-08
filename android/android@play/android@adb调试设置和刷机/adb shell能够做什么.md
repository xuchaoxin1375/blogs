[toc]

# adb shell能够做什么

![image-20221008180836136](https://img-blog.csdnimg.cn/img_convert/27bd499f8662ca291a09d22f0236c19b.png)

### mksh

- 和指令集不同,shell可以调用不同的指令集
- 但是shell作为用户命令行解释器,本身又是一个可执行文件
  - 比如bash/zsh/ksh/mksh
- adb shell所用的shell一般指`mksh`

```bash
1|xaga:/system/xbin $ sh -v
# Copyright (c) 2010, 2012, 2013, 2014
#       Thorsten Glaser <tg@mirbsd.org>
# This file is provided under the same terms as mksh.
#-
# Minimal /system/etc/mkshrc for Android
#
# Support: https://launchpad.net/mksh

set +o nohup

if (( USER_ID )); then PS1='$'; else PS1='#'; fi
PS4='[$EPOCHREALTIME] '; PS1='${|
        local e=$?

        (( e )) && REPLY+="$e|"

        return $e
}$HOSTNAME:${PWD:-?} '"$PS1 "
```

### 其他shell

- 在android(ARM)架构,有zsh for arm可以选用,您可以使用magisk刷入

  - ```bash
    localhost# zsh -h
    localhost# zsh -v
    # /etc/zsh/zshenv: system-wide .zshenv file for zsh(1).
    #
    # This file is sourced on all invocations of the shell.
    # If the -f flag is present or if the NO_RCS option is
    # set within this file, all other initialization files
    # are skipped.
    #
    # This file should contain commands to set the command
    # search path, plus other important environment variables.
    # This file should not contain commands that produce
    # output or assume the shell is attached to a tty.
    #
    # Global Order: zshenv, zprofile, zshrc, zlogin
    export USER=$([[ "$(print -P "%#")" == '#' ]] && print 'root' || print 'system')
    export HOME=/data/local/${USER}
    export ANDROID_ROOT=/system
    ```

    

## android基础指令集

### toybox

- `toybox --help`

  ```bash
  xaga:/data/adb/busybox # toybox --help
  Toybox 0.8.4-android multicall binary: https://landley.net/toybox (see toybox --help)
  
  usage: toybox [--long | --help | --version | [COMMAND] [ARGUMENTS...]]
  
  With no arguments, "toybox" shows available COMMAND names. Add --long
  to include suggested install path for each command, see
  https://landley.net/toybox/faq.html#install for details.
  
  First argument is name of a COMMAND to run, followed by any ARGUMENTS
  to that command. Most toybox commands also understand:
  
  --help          Show command help (only)
  --version       Show toybox version (only)
  
  The filename "-" means stdin/stdout, and "--" stops argument parsing.
  
  Numerical arguments accept a single letter suffix for
  kilo, mega, giga, tera, peta, and exabytes, plus an additional
  "d" to indicate decimal 1000's instead of 1024.
  
  Durations can be decimal fractions and accept minute ("m"), hour ("h"),
  or day ("d") suffixes (so 0.1m = 6s).
  xaga:/data/adb/busybox #
  ```

  ```bash
  130|xaga:/system/bin $ ls -al|nl|tail -n 20
     440  -rwxr-xr-x  1 root shell      33 2009-01-01 08:00 wm
     441  lrwxrwxrwx  1 root root        6 2022-10-08 15:33 xargs -> toybox
     442  -rwxr-xr-x  1 root shell     128 2009-01-01 08:00 xml2abx
     443  lrwxrwxrwx  1 root root        6 2022-10-08 15:33 xxd -> toybox
     444  lrwxrwxrwx  1 root root        6 2022-10-08 15:33 yes -> toybox
     445  lrwxrwxrwx  1 root root        6 2022-10-08 15:33 zcat -> toybox
     446  -rwxr-xr-x  1 root shell   65720 2009-01-01 08:00 zip_utils
     447  lrwxrwxrwx  1 root root        7 2022-10-08 15:33 zipinfo -> ziptool
     448  -rwxr-xr-x  1 root shell   28712 2009-01-01 08:00 ziptool
  ```

  - 大概有400+多命令的二进制文件

    - 比如大名鼎鼎的svc,可以用来调试NFC/蓝牙等外围设备

    - ```bash
      xaga:/system/bin $ svc -h
      Available commands:
          help             Show information about the subcommands
          power            Control the power manager
          usb              Control Usb state
          nfc              Control NFC functions
          bluetooth        Control Bluetooth service
          system-server    System server process related command
      xaga:/system/bin $ svc nfc -h
      Control NFC functions
      
      usage: svc nfc [enable|disable]
               Turn NFC on or off.
      
      ```

      





### busybox@toybox加强指令集

- [BusyBox](https://busybox.net/)官网

#### android版

- 高版本android可以通过magisk 刷入busybox模块(需要一定时间几十秒到1分钟左右甚至更长时间)
- busybox简介
  - BusyBox is a multi-call binary that combines many common Unix    utilities into a single executable.  Most people will create a link to busybox for each function they wish to use and BusyBox will act like whatever it was invoked as.



## toybox&busybox指令集(二进制程序）所在目录@安装路径

```bash
xaga:/data/adb/busybox # type busybox
busybox is /system/xbin/busybox
```

```bash
xaga:/data/adb/busybox # type toybox
toybox is /system/bin/toybox
```



```bash
xaga:/data/adb/busybox # ls -al /system/xbin/busybox
-rwxrwxrwx 1 root root 2087000 2022-10-08 15:30 /system/xbin/busybox
```

#### busybox版本信息查看

```bash
xaga:/data/adb/busybox # busybox --help
BusyBox v1.34.1-osm0sis (2021-10-02 04:33:49 ADT) multi-call binary.
BusyBox is copyrighted by many authors between 1998-2015.
Licensed under GPLv2. See source distribution for detailed
copyright notices.

Usage: busybox [function [arguments]...]
   or: busybox --list[-full]
   or: busybox --show SCRIPT
   or: busybox --install [-s] [DIR]
   or: function [arguments]...

        BusyBox is a multi-call binary that combines many common Unix
        utilities into a single executable.  Most people will create a
        link to busybox for each function they wish to use and BusyBox
        will act like whatever it was invoked as.

Currently defined functions:
        [, [[, acpid, adjtimex, ar, arch, arp, arping, ascii, ash, awk, base32, base64, basename, bbconfig,
        beep, blkdiscard, blkid, blockdev, brctl, bunzip2, bzcat, bzip2, cal, cat, chat, chattr, chcon,
        chgrp, chmod, chown, chroot, chrt, chvt, cksum, clear, cmp, comm, conspy, cp, cpio, crc32, crond,
       ...........................
       ....................
        tc, tcpsvd, tee, telnet, telnetd, test, tftp, tftpd, time, timeout, top, touch, tr, traceroute,
        traceroute6, true, truncate, ts, tty, ttysize, tunctl, tune2fs, ubiattach, ubidetach, ubimkvol,
        ubirename, ubirmvol, ubirsvol, ubiupdatevol, udhcpc, udhcpc6, udhcpd, udpsvd, uevent, umount, uname,
        uncompress, unexpand, uniq, unix2dos, unlink, unlzma, unlzop, unshare, unxz, unzip, uptime, usleep,
        uudecode, uuencode, vconfig, vi, volname, watch, watchdog, wc, wget, which, whoami, whois, xargs,
        xxd, xz, xzcat, yes, zcat, zcip
```



## windows版

- 可以通过scoop来安装,也可以直接使用官网的二进制文件

```bash
PS D:\repos\blogs\neep> busybox.exe
BusyBox v1.36.0-FRP-4621-gf3c5e8bc3 (2022-02-28 07:17:58 GMT)
(mingw64-gcc 11.2.1-3.fc35; mingw64-crt 9.0.0-2.fc35; glob)

BusyBox is copyrighted by many authors between 1998-2022.
Licensed under GPLv2. See source distribution for detailed
copyright notices.

Usage: busybox [function [arguments]...]
   or: busybox --list[-full]
   or: busybox --install [-s] [-u|DIR]
   or: busybox --uninstall [-n] file
   or: function [arguments]...

```



### 常用指令

#### set1:

- [ADB Shell - Android ADB Commands Manual](https://adbshell.com/)

#### set2



- [发出 adb 命令](https://developer.android.com/studio/command-line/adb#issuingcommands)
  - [调用 activity 管理器 (`am`)](https://developer.android.com/studio/command-line/adb#am)
  - [调用软件包管理器 (pm)](https://developer.android.com/studio/command-line/adb#pm)
  - [调用设备政策管理器 (dpm)](https://developer.android.com/studio/command-line/adb#dpm)
  - [截取屏幕截图](https://developer.android.com/studio/command-line/adb#screencap)
  - [录制视频](https://developer.android.com/studio/command-line/adb#screenrecord)
  - [读取应用的 ART 配置文件](https://developer.android.com/studio/command-line/adb#appprofiles)
  - [重置测试设备](https://developer.android.com/studio/command-line/adb#test_harness)
  - [sqlite](https://developer.android.com/studio/command-line/adb#sqlite)
- [将命令发送至特定设备](https://developer.android.com/studio/command-line/adb#directingcommands)
- [安装应用](https://developer.android.com/studio/command-line/adb#move)
- [设置端口转发](https://developer.android.com/studio/command-line/adb#forwardports)
- [将文件复制到设备/从设备复制文件](https://developer.android.com/studio/command-line/adb#copyfiles)
- [停止 adb 服务器](https://developer.android.com/studio/command-line/adb#stopping)



## 设置无操作后息屏时间

- `adb shell settings put system screen_off_timeout 600000`
  - $60*10*1000ms=600s=10min$
  - 有效值应该在5000(ms)以上
  - 否则无效