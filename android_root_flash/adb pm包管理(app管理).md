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

      

    

## 应用

-  待续..



