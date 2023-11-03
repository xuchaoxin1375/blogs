[toc]

## adb命令介绍和使用说明

- [Android 调试桥 (adb)  | Android 开发者  | Android Developers (google.cn)](https://developer.android.google.cn/studio/command-line/adb?hl=zh-cn#am)
  - 这部分文档并不包含所有的指令功能的介绍
  - 可以和命令行的`--help`选项的本地文档一同查阅

## adb shell pm和am的运行方式

- 运行方式有两种
  - 不进入shell直接运行
    - 每次执行命令(issue command)需要带上adb shell开头的前缀
    - 例如:
      - `adb shell pm list packages -s -d|nl`
        - 统计被禁用(冻结)的包
  - 进入shell再运行
    - 这比较适合需要执行大量命令交互的情况下
      - `adb shell`
      - `pm ...`或`am ...`

- 下面默认当前已经进入了`adb shell` 模式,采用第二种方式运行

## 手机端终端应用(terminal for android)

- 有些android 端app提供了可以执行adb命令的接口(模拟终端),使得我们可以不依赖电脑就可以执行一些adb 命令行

### 设备已root

- 例如[MT管理器 (mt2.cn)](https://mt2.cn/)提供了终端模拟器(Terminal Simulator)
  - 这种方式需要root权限才能顺利执行大多数命令,或者高于一般用户的权限才可以调用

### 设备未root

- [Shizuku(moe.shizuku.privileged.api)  (coolapk.com)](https://www.coolapk.com/apk/moe.shizuku.privileged.api)授权的方式使用(通过无线调试来激活shizuku,需要android11或更高版本),激活后配合以下之一的app使用:

  - [shizukuRunner](https://www.coolapk.com/apk/com.shizuku.uninstaller)
  - [黑域](https://www.coolapk.com/apk/me.piebridge.brevent)

- 当然,还存在一些其他的app可以借助无线调试来执行adb命令行

  

## adb shell pm包管理

- app管理器

### 检索和查找包(app)

- 检查所包
  - `pm list packages`
  
  - ```bash
    
      list packages [-f] [-d] [-e] [-s] [-3] [-i] [-l] [-u] [-U]
          [--show-versioncode] [--apex-only] [--uid UID] [--user USER_ID] [FILTER]
        Prints all packages; optionally only those whose name contains
        the text in FILTER.  Options are:
          -f: see their associated file
          -a: all known packages (but excluding APEXes)
          -d: filter to only show disabled packages
          -e: filter to only show enabled packages
          -s: filter to only show system packages
          -3: filter to only show third party packages
          -i: see the installer for the packages
          -l: ignored (used for compatibility with older releases)
          -U: also show the package UID
          -u: also include uninstalled packages
          --show-versioncode: also show the version code
          --apex-only: only show APEX packages
          --uid UID: filter to only show packages with the given UID
          --user USER_ID: only list packages belonging to the given user
    ```

### 查找具有关键字的包(grep)

- 基于查找全部包的基础上用管道符过滤具有关键字的包
- `pm list packages|grep <keyword>`
  - 例如:`pm list packages|grep thaons`



## 导出禁用列表

#### 列举/导出自己的冻结列表

- 列出已经禁用的包:

  - `pm list package -s -d`

    - ```bash
      package:com.miui.systemAdSolution
      package:com.android.vending
      package:com.miui.analytics
      package:com.google.android.ext.shared
      package:com.miui.yellowpage
      package:com.google.android.configupdater
      package:com.google.android.gms
      package:com.google.android.gsf
      package:com.xiaomi.gamecenter.sdk.service
      package:com.xiaomi.migameservice
      package:com.google.android.printservice.recommendation
      package:com.milink.service
      package:com.google.android.onetimeinitializer
      package:com.miui.voiceassist
      ```



- 导出后,方便分享给别人🎈
  - 可以直接复制文本内容
  - 也可以截图分享
  - 也可以保存到一个文件文件中

#### 导出冻结包列表

- ```bash
  cd /sdcard/
  #back up the current disabled packages list
  pm list package -d|sed 's/package://g'|tee disabled_packaged_list.bak
  ```

  

#### 导出/创建冻结脚本



- ```bash
  cd /sdcard/
  #back up the current disabled packages list
  pm list package -d|sed 's/package://g'|tee disabled_packaged_list.bak
  #生成/创建冻结脚本(create the shell file of list of packages that need to be disable)
  pm list packages -d|sed 's/package:/pm disable /g'|tee disable_pkg_list.sh
  
  ```

  - 如果直接复制粘贴到终端中运行,那么可能需要按几次换行好(回车确认)以便脚本完整执行

  

- 不出意外的话,你会得到位于`/sdcard/`目录下的一个脚本文件:

  - 内容大概是这样的:

  - ```json
    pm disable com.miui.systemAdSolution
    pm disable com.android.vending
    pm disable com.miui.analytics
    pm disable com.xiaomi.mi_connect_service
    pm disable com.google.android.ext.shared
    pm disable com.google.android.configupdater
    pm disable com.xiaomi.mirror
    pm disable com.google.android.gms
    pm disable com.termux
    pm disable com.google.android.gsf
    pm disable com.android.quicksearchbox
    pm disable com.miui.carlink
    pm disable com.miui.cloudservice
    pm disable com.google.android.printservice.recommendation
    pm disable com.microsoft.skydrive
    pm disable com.google.android.onetimeinitializer
    pm disable com.miui.mishare.connectivity
    ```


## 启用/解冻

- 禁用包:`pm disable <packageName>`

  - 例如:`pm disable com.miui.analytics`

- 启用包`pm enable <packageName>`

  - 例如:`pm enable com.miui.analytics`

- 批量启用包

  - 可以将已禁用的包列举出来

    再用编辑器将`packages:`替换为`pm enable `,然后执行这些替换好指令的命令行

  - 具体命令如下:

  - ```bash
    cd /sdcard/
    #back up the current disabled packages list
    pm list package -d|sed 's/package://g'|tee disabled_packaged_list.bak
    #生成/创建解冻脚本(create the shell file of list of packages that need to be enable)
    pm list packages -d|sed 's/package:/pm enable /g'> enable_pkg_list.sh
    nl enable_pkg_list.sh
    source ./enable_pkg_list.sh
    ```

    

### Note

- 不是所有app都可以被冻结成功
  - 比如某些系统核心app
    - 以miui为例,
      - 手机管家
      - 应用商店
      - 系统更新
      - 都是无法通过该方式disable
  
- 另一方面,肆意冻结可能导致系统异常,导致无法开机

### 冻结系统更新@应用商店

- 系统更新和应用商店比一般的系统自带应用级别更高一些,无法通过`adb shell pm disable`冻结(执行过程会报错)

  - ```bash
    mondrian:/ $ pm disable com.xiaomi.market
    
    Exception occurred while executing 'disable':
    java.lang.SecurityException: Shell cannot change component state for null to 2
            at com.android.server.pm.PackageManagerService.setEnabledSettings(PackageManagerService.java:3925)
            at com.android.server.pm.PackageManagerService.-$$Nest$msetEnabledSettings(Unknown Source:0)
    ...
    com.android.server.pm.PackageManagerService$IPackageManagerImpl.onTransact(PackageManagerService.java:6187)
            at android.os.Binder.execTransactInternal(Binder.java:1290)
            at android.os.Binder.execTransact(Binder.java:1249)
    ```

    

- 使用`pm uninstall`配合`` --user `选项(通常搭配参数0),则不会报错

  ```bash
  
    uninstall [-k] [--user USER_ID] [--versionCode VERSION_CODE]
         PACKAGE [SPLIT...]
      Remove the given package name from the system.  May remove an entire app
      if no SPLIT names specified, otherwise will remove only the splits of the
      given app.  Options are:
        -k: keep the data and cache directories around after package removal.
        --user: remove the app from the given user.
        --versionCode: only uninstall if the app has the given version code.
  
  ```

- 即,可以通过伪卸载的方式实现冻结的效果,下面以`MIUI`的应用商店为例进行禁用操作

  - 不保留数据伪卸载

    ```bash
    mondrian:/ $ pm uninstall --user 0 com.xiaomi.market
    Success
    ```

  - 保留数据伪卸载(使用`-k`选项)

    ```
    mondrian:/ $ pm uninstall -k --user 0 com.xiaomi.market
    Success
    ```

  - 安装复原(取消伪卸载)

    - ```
      mondrian:/ $ pm install-existing --user 0 com.xiaomi.market
      Packag	e com.xiaomi.market installed for user: 0
      ```

- 系统更新的禁用或恢复操作类似

  - ```bash
    
    mondrian:/ $ pm uninstall -k --user 0 com.android.updater
    Success
    ```

  - ```bash
    mondrian:/ $ pm install-existing  --user 0 com.android.updater
    Package com.android.updater installed for user: 0
    ```

### 彻底卸载删除系统核心应用

- 诸如系统更新和应用商店这类系统自带应用也并非不可完全移除
- 对于普通的root(通过magisk修补的方式获得的root权限,是无法直接在开机状态下修改`/data`,`/product`目录下的内容)
  - 厂商系统应用的安装包通常位于`/`下的某个子目录,例如MIUI位于`/product/app`
- 可以借助一些软件来修改,比如[scene](https://www.coolapk.com/apk/com.omarea.vtools),提供了利用magisk修改(重启生效)

## adb shell am

- [How to start an application using Android ADB tools - Stack Overflow](https://stackoverflow.com/questions/4567904/how-to-start-an-application-using-android-adb-tools)



## 🎈多用户&双开app调试(multiple user adb)

- [测试多用户  | Android 开源项目  | Android Open Source Project](https://source.android.com/docs/devices/admin/multi-user-testing)

- pm和am都支持多用户app调试

  - 例如pm下:

    - 下面的例子是扫描用户999的可用的包(app)

      - 这是miui多开创建的用户

    - ```bash
      xaga:/ # pm list packages --user 999|nl
           1  package:com.miui.securitycore
           2  package:com.miui.analytics
           3  package:android
           4  package:com.tencent.mm
           5  package:org.mipay.android.manager
           6  package:com.google.android.gms
           7  package:com.android.nfc
           8  package:com.android.permissioncontroller
           9  package:com.tencent.soter.soterserver
          10  package:com.google.android.gsf
          11  package:com.miui.phrase
          12  package:com.xiaomi.gamecenter.sdk.service
          13  package:org.ifaa.aidl.manager
          14  package:com.miui.rom
          15  package:com.google.android.webview
          16  package:com.android.keychain
          17  package:com.miui.contentcatcher
          18  package:com.android.phone
      ```

  - 多用户 am

    - 下面这条命尝试为ID=999的用户启动微信

      - 实际效果会为创建了多开的(dual app)另一个微信做启动操作

    - ```bash
       am start --user 999 com.tencent.mm/com.tencent.mm.ui.LauncherUI
      ```

      

## app信息查看

### 查找某个app/package

- 例如,查找桌面启动器相关的包

- ```bash
  xaga:/ $ pm list packages|grep -e home -e launcher|nl
       1  package:android.miui.home.launcher.res
       2  package:com.yuk.miuihome
       3  package:com.miui.home
       4  package:com.miui.newhome
       5  package:cn.fuckhome.xiaowine
       6  package:bitpit.launcher
  ```

#### 查看某个包的信息

-  `dumpsys package com.miui.home|nl`

##### 查找android设备上的音乐/视频播放软件

- `pm list packages|grep -e music -e player -e tv -e ku|nl`
  - xaga:/ $ pm list packages|grep -e music -e player -e ku |nl
         1  package:com.android.sharedstoragebackup
         2  package:cn.kuwo.player
         3  package:com.android.backupconfirm
         4  package:player.normal.np
         5  package:com.miui.cloudbackup
         6  package:tv.danmaku.bili
         7  package:com.android.calllogbackup
         8  package:com.mylrc.mymusic
         9  package:com.miui.player
        10  package:com.android.wallpaperbackup
        11  package:com.kugou.android.lite
        12  package:com.android.musicfx
        13  package:com.miui.backup
        14  package:moe.shizuku.privileged.api

#### 过滤Activitiy

- ```bash
  xaga:/ $ dumpsys package com.tencent.mm|nl|grep LauncherUI
     487          b29e6a7 com.tencent.mm/.ui.LauncherUI filter 1484754
     492          b29e6a7 com.tencent.mm/.ui.LauncherUI filter 7a26fd
  ```

  



## app进程管理

- 利用`adb shell am <xxx>`和`monkey`进行管理

### 启动某个app

- [How to start an application using Android ADB tools - Stack Overflow](https://stackoverflow.com/questions/4567904/how-to-start-an-application-using-android-adb-tools)

#### 使用am start启动指定app(app的某个页面activity)

- `am start PackageName/activity`

- 例如启动微信
  
  - `am start com.tencent.mm/com.tencent.mm.ui.LauncherUI`
  
  - 简写:`am start com.tencent.mm/.ui.LauncherUI`
  
    - ```bash
      xaga:/ $ am start com.tencent.mm/.ui.LauncherUI
      Starting: Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] cmp=com.tencent.mm/.ui.LauncherUI }
      Warning: Activity not started, its current task has been brought to the front
      ```
  
      
  
  - 该命令将启动微信主页页面
  
  - `am start`还可以其他选项可以接受其他参数,比如,`am start -n`
  
  - 但是,这不总是方便的,有时我们就只需要启动默认主页面,那么Activity就不是一个很有必要写的部分
  
  - 但是我们不写activity名字,就不再是用`am`,而是改用`monkey`
  

#### monkey启动指定app🎈

- `monkey -p PackageName 1`

  - 需要将`PackageName`改为包名(相比于am start方式,不需要指定具体Activity)

  - 例如启动微信` monkey -p com.tencent.mm 1`

    - ```bash
      xaga:/ $ monkey -p com.tencent.mm 1
      
        bash arg: -p
        bash arg: com.tencent.mm
        bash arg: 1
      args: [-p, com.tencent.mm, 1]		
       arg: "-p"
       arg: "com.tencent.mm"
       arg: "1"
      data="com.tencent.mm"
      Events injected: 1
      ## Network stats: elapsed time=18ms (0ms mobile, 0ms wifi, 18ms not connected)
      ```

  - 如果启动失败,您可以尝试变动参数(将数字1改为其他值再试)
  



### 杀死某个app进程

#### 使用am stop 杀死

- [testing - Stopping an Android app from console - Stack Overflow](https://stackoverflow.com/questions/3117095/stopping-an-android-app-from-console)

- 使用`adb shell am force-stop PackageName`

  - 例如杀死<u>edge浏览器</u>:`adb shell am force-stop com.microsoft.emmx`

- 或者进入shell

- 调用`am force-stop PackageName`进行杀灭

  





