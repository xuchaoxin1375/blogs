[toc]

## ref

- [Android 调试桥 (adb)  | Android 开发者  | Android Developers](https://developer.android.com/studio/command-line/adb)

## android设备端(手机)

- USB选项:
  - 选择文件传输
  - 而不是仅充电(只会导致文件传输等功能无法生效)
    - 典型错误:`more than one device/emulator`
- 打开开发者选项(developerOptions)
- 启用USB调试(USB debugging)
  - Switche to debugging mode when USB is connected
- 允许通过USB安装应用(apps)(Install via USB)
	- 根据设备情况启用(比如MIUI) 
- (可选)关闭授权过期功能(Disalble adb authorizatoin timeout)

### 推荐设置

- 如果您经常用手机连接电脑做通行/传输,那么建议将usb连接的默认选项设置为`File Transfer`(文件传输)
- 可以在设置搜索`默认`
  - 或者直接在设置中按照打开路径:`Additional settings/Developer options/Default Use configuration/File Transfer`

## adb 端(电脑)

- 进入到安装包所在目录
  - 或者,在可以使用adb命令的任意目录下,复制(输入)完整的app安装包(比如apk文件)的路径名
- 执行`adb install <appName.apk>`完成安装

## 实操

- 检查设备链接情况

  - ```bash
    PS C:\Users\cxxu\Desktop\n11tp> adb devices
    List of devices attached
    UO7PKFNF99IR9TV4        device
    ```

- 执行安装

- ```bash
  PS C:\Users\cxxu\Desktop\n11tp> adb install .\magisk.apk
  Performing Streamed Install
  Success
  ```

### 参考adb文档

- ```bash
  PS C:\Users\cxxu> adb
  Android Debug Bridge version 1.0.41
  Version 33.0.2-8557947
  Installed as D:\exes\platform-tools\adb.exe
  ....省略篇幅....(跳过,直达主题:..app intallation
  
  app installation (see also `adb shell cmd package help`): 
   install [-lrtsdg] [--instant] PACKAGE
       push a single package to the device and install it
   install-multiple [-lrtsdpg] [--instant] PACKAGE...
       push multiple APKs to the device for a single package and install them
   install-multi-package [-lrtsdpg] [--instant] PACKAGE...
       push one or more packages to the device and install them atomically
       -r: replace existing application
       -t: allow test packages
       -d: allow version code downgrade (debuggable packages only)
       -p: partial application install (install-multiple only)
       -g: grant all runtime permissions
       --abi ABI: override platform's default ABI
       --instant: cause the app to be installed as an ephemeral install app
       --no-streaming: always push APK to device and invoke Package Manager as separate steps
       --streaming: force streaming APK directly into Package Manager
       --fastdeploy: use fast deploy
       --no-fastdeploy: prevent use of fast deploy
       --force-agent: force update of deployment agent when using fast deploy
       --date-check-agent: update deployment agent when local version is newer and using fast deploy
       --version-check-agent: update deployment agent when local version has different version code and using fast deploy
       (See also `adb shell pm help` for more options.)
   uninstall [-k] PACKAGE
       remove this app package from the device
       '-k': keep the data and cache directories
  
  ```

- 根据帮助文档:

  - app installation (see also `adb shell cmd package help`): 
    - <u>install</u> [-lrtsdg] [--instant] <u>PACKAGE</u>
           push a single package to the device and install it
  - 可以发现,使用adb程序的子命令install来安装某个包到设备
    - 具体通过`adb install`来调用,因为install package是adb可执行文件提供的命令接口
    - 该包含了多个可选的选项和一个参数(安装包的路径)
    - 也可以不使用任何选项,默认行为就是执行app包文件安装
    - 吐槽一下原文档第一个子命令install没有换行的问题,容易漏看,可以结合grep来看文档

### 可能出现的问题



#### 错误的进入adb shell

- ```bash
  xaga:/sdcard $ install magisk.apk
  install: Needs 2 arguments
  ```

  - adb install 是adb可执行文件提供,而不是adb shell 提供的(toybox)


#### more than one device/emulator

- ```
  PS C:\Users\cxxu\Desktop\n11tp> adb install .\magisk.apk
  adb.exe: more than one device/emulator
  ```

  - 初步排查:

    - 使用`adb devices ` -l检查当前列表

      - 这里加一个参数`-l`会列出设备更加详细的信息,推荐加上,可看到设备型号

    - 下面是adb 将设备识别为多模拟设备

      - 这可能是根手机端选择的链接方式的选项有关!

      - 从而导致虽然只连接了一台设备,却扫描出了2台设备(包括模拟设备,应该是您的选项`Use USB for `的选项更换之后导致的)

      - ```bash
        PS C:\Users\cxxu> adb devices
        List of devices attached
        UO7PKFNF99IR9TV4        device
        emulator-5554   offline
        ```

    - 如果向上面所讲的那样,发现了多台设备,那么考虑如下做法:

      - 断开所有adb链接:`adb kill-server`

        - 然后重新检查设备列表

        - ```bash
          PS C:\Users\cxxu> adb kill-server
          
          PS C:\Users\cxxu> adb devices -l
          * daemon not running; starting now at tcp:5037
          * daemon started successfully
          List of devices attached
          UO7PKFNF99IR9TV4       device product:xaga model:22041216C device:xaga transport_id:1
          ```

        - 您也可以选择跳过`adb kill-server`,通过追加选项`-s`指定设备参数
        - 这样就不会导致设备指代不明的错误

        - 如果您链接了多个android设备(包括虚拟设备),
          - 考虑物理断开与其他设备
          - 但是最优雅的方式,是指定具体设备进行通行/控制
            - `adb -s xxx `
          - 这里的`xxx`代指的是设备序列号,例如上面的`UO7PKFNF99IR9TV4`

    - 开发者选项相关开关为正确开启,也可能导致相应错误


​    

  - ```bash
    PS C:\Users\cxxu\Desktop\n11tp> adb install .\magisk.apk
    Performing Streamed Install
    adb: failed to install .\magisk.apk: Failure [INSTALL_FAILED_USER_RESTRICTED: Install canceled by user]
    
    ```


### 卸载

- `adb uninstall <packageName>`

- 例如:写在酷安应用市场:

  ```bash\
  PS C:\Users\cxxu\Downloads> adb uninstall com.coolapk.market
  Success
  ```

- 如果要降级安装某些应用,就需要先卸载新版本,再安装老版本

### 查看应用版本

- ` dumpsys package <com.example.packageName>|grep versionName -i`

- 例如,查看酷安的版本:

  ```bash
  windows_x86_64:/ $ dumpsys package com.coolapk.market|grep versionName -i
      versionName=13.1.3
  ```

  













