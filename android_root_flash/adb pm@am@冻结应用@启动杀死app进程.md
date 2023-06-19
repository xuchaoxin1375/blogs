[toc]

# adb pm和am

- 运行方式
  - 不进入shell直接运行
    - 每次执行命令(issue command)需要带上adb shell开头的前缀
    - 例如:
      - `adb shell pm list packages -s -d|nl`
        - 统计被禁用(冻结)的包
  - 进入shell再运行
    - 这比较适合需要执行大量命令交互的情况下

## 手机端终端

- 有些android 端app提供了可以执行adb命令的接口(模拟终端)
  - 例如`mt管理器`的终端模拟器(Terminal Simulator)在没有电脑的情况下也可执行某些adb命令
    - [MT管理器 (mt2.cn)](https://mt2.cn/)
      - 这种方式需要root权限
        - 或者高于一般用户的权限才可以调用
      - 项shizuku授权个黑域应该也是可以的

## adb pm包管理(app管理).md

### 检索和查找

- 检查所包
  - `pm list package`
- 查找具有关键字的包
  - `pm list package|grep <keyword>`
    - 例如:`pm list package|grep thaons`

### 禁用/冻结

- 禁用包

  - `pm disable <packageName>`


#### 😀列举/导出自己的冻结列表

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

    

### 🎈注意事项

- 不是所有app都可以被冻结成功
  - 比如某些系统核心app
    - 以miui为例,
      - 手机管家
      - 应用商店
      - 都是无法通过该方式disable

- 另一方面,肆意冻结可能导致系统异常,导致无法开机

### 启用/解冻

- 启用包

  - `pm enable <packageName>`
    - `pm enable com.miui.analytics`

- 批量启用包

  - 可以将已经用的包列举出来
    - 在用编辑器将`package:`替换为`pm enable `
      - 然后执行这些替换好指令的命令行

  - ```bash
    cd /sdcard/
    #back up the current disabled packages list
    pm list package -d|sed 's/package://g'|tee disabled_packaged_list.bak
    #生成/创建解冻脚本(create the shell file of list of packages that need to be enable)
    pm list packages -d|sed 's/package:/pm enable /g'> enable_pkg_list.sh
    nl enable_pkg_list.sh
    source ./enable_pkg_list.sh
    ```

    

## adb am

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

  

## 启动/杀死app进程

### 启动某个app

- [How to start an application using Android ADB tools - Stack Overflow](https://stackoverflow.com/questions/4567904/how-to-start-an-application-using-android-adb-tools)

#### 使用am启动指定app(app的某个页面activity)

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

  





