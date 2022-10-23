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

## adb pm包管理(app管理).md

- 检查所包
  - `pm list package`
- 查找具有关键字的包
  - `pm list package|grep <keyword>`
    - 例如:`pm list package|grep thaons`
- 禁用包
  - `pm disable <packageName>`

- 列举已经禁用的包:

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

      

- 启用包

  - `pm enable <packageName>`
    - `pm enable com.miui.analytics`

- 批量启用包

  - 可以将已经用的包列举出来
    - 在用编辑器将`package:`替换为`pm enable `
      - 然后执行这些替换好指令的命令行


## adb am

- [How to start an application using Android ADB tools - Stack Overflow](https://stackoverflow.com/questions/4567904/how-to-start-an-application-using-android-adb-tools)

## 多用户(multiple user adb)

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

- 