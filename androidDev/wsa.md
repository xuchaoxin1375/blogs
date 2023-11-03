[toc]

## refs

- [管理 Windows 上移动应用的设置 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/管理-windows-上移动应用的设置-000f97e8-8c20-490e-9ef4-cd90d903f847)
- [适用于 Android™️ 的 Windows 子系统 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/android/wsa/#test-and-debug)
- [连接到适用于 Android 的 Windows 子系统进行调试 | Microsoft Learn@connect-to-the-windows-subsystem-for-android-for-debugging](https://learn.microsoft.com/zh-cn/windows/android/wsa/#connect-to-the-windows-subsystem-for-android-for-debugging)

### 找到wsa

- 安装完成后,在开始菜单中搜索`android`
  - 如果没有结果,可以再试试`subsystem`

## 命令行链接

### 初次链接

- ```bash
  PS C:\Users\cxxu\Desktop> adb connect 127.0.0.1:58526
  failed to authenticate to 127.0.0.1:58526
  ```

- 要求授权调试:

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/7835db52b8ba4e82b304f27ac30248b5.png)

### 后续使用

- ```bash
  PS C:\Users\cxxu\Desktop> adb connect 127.0.0.1:58526
  already connected to 127.0.0.1:58526
  ```

### adb shell

- ```bash
  PS C:\Users\cxxu\Desktop> adb shell
  windows_x86_64:/ $ ls
  ls: ./init: Permission denied
  acct        config         dev              mnt          proc                    sys          vendor_dlkm
  apex        d              etc              odm          product                 system
  bin         data           init.environ.rc  odm_dlkm     sdcard                  system_dlkm
  bugreports  data_mirror    linkerconfig     oem          second_stage_resources  system_ext
  cache       debug_ramdisk  metadata         postinstall  storage                 vendor
  ```

### adb install `<apk>`

- 环境检查链接

  ```bash
  #检查当前环境是否存在adb链接(如果是空白的,表明后续操作不会受到干扰)
  PS C:\Users\cxxu\Desktop> adb devices -l
  List of devices attached
  
  #尝试链接到wsa
  PS C:\Users\cxxu\Desktop> adb connect 127.0.0.1:58526
  connected to 127.0.0.1:58526
  
  #检查当前链接是否有效(注意,如果出现offline字段,需要重新链接,执行adb kill-server来重新操作)
  #如果正常,则提示device字段
  PS C:\Users\cxxu\Desktop> adb devices -l
  List of devices attached
  127.0.0.1:58526        device product:windows_x86_64 model:Subsystem_for_Android_TM_ device:windows_x86_64 transport_id:1
  ```

- 准备需要安装的apk安装包,例如我这里要安装的是**酷安(coolapk)**

  - ```
    #找到apk所在路径
    PS C:\Users\cxxu\Desktop> dls_
    PS C:\Users\cxxu\Downloads> ls *apk
    
            Directory: C:\Users\cxxu\Downloads
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---          2023/6/5      9:07       97753220   coolapk.apk
    ```

    

- 执行安装命令

  ```bash
  PS C:\Users\cxxu\Downloads> adb install .\coolapk.apk
  Performing Streamed Install
  Success
  ```

### 检查某个已安装的app

- 例如,我想要搜索`coolapk`的app,

  ```bash
  PS C:\Users\cxxu\Downloads> adb shell
  windows_x86_64:/ $ pm list package |grep coolapk
  package:com.coolapk.market
  windows_x86_64:/ $
  ```

### app版本查看

- 例如查看酷安版本

  ```bash
  windows_x86_64:/ $ dumpsys package com.coolapk.market|grep versionName -i
      versionName=13.1.3
  ```

  

## GUI安装apk

- 有些软件提供双击apk进行安装,可以在github或windows store上找到

