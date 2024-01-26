[toc]

## refs

- [手机不弹出允许usb调试](https://www.csdn.net/tags/MtjaIg3sMTkyNDItYmxvZwO0O0OO0O0O.html)

  


## 设备驱动

- 使用win10/win11 自带驱动,一般不用自己再安装了

## android开发者可能遇到的问题👺

### 故事缘由

- 本人之前开发过一点android应用,当时由于android studio的依赖组件和缓存下载到c盘,我特意用了符号链接来将实际位置指向到D盘的一个目录下,后来要准备考试,下载备考资料,删除了开发环境的相关目录,没想到会在这个时候(使用adb搞机)处理意想不到的问题
- 当然,如果你有两台pc,那么问题会更容易排除,我通过查阅资料发现了影响`允许调试窗口弹出的 .android目录`
- 这种情况十分罕见,但还是被我给遇见了
  - 你曾经使用android studio开发过android app
  - 你还使用了软连接将开发环境的目录指向的地方删除了

- ![image-20220718221333447](https://img-blog.csdnimg.cn/img_convert/568b3cea84c0871ad12b81114768e7d3.png)


- 由于符号链接所指目录不存在,所以会导致查看失败

```bash
PS C:\Users\cxxu\.android> ls
Get-ChildItem: Could not find a part of the path 'C:\Users\cxxu\.android'.
```

- 现在,我将引起问题的软连接删除,重新尝试建立adb链接,`%userprofile%/.android/`目录下成功创建了一下内容

  - ```bash
    PS C:\Users\cxxu\.android> ls
    
            Directory: C:\Users\cxxu\.android
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         7/18/2022   9:54 PM           1732   adbkey
    -a---         7/18/2022   9:54 PM            710   adbkey.pub
    ```

  - 

### 问题小结

- 使用了软连接,替换了当前用户家目录的`.android`目录(并且指向了一个不存在(或者已经被删除的目录))
- 这导致新建立的调试连接会试图访问一个非法的位置,导致adb相关工具的调试失败

### 案例:小米助手连接失败

- 这种情况下小米助手会在链接的时候卡死
#### 小米刷机助手官方的FAQ

- USB连接不上助手

-  1.物理连接层面：请检查USB口、USB线是好还是坏。

-  2.驱动层面：安装对应驱动。其中部分USB3.0（蓝色）计算机无法识别，需要连接计算的USB2.0（黑色）。

-  3.端口占用层面：请关闭计算机中其他手机助手相关的软件，或会占用端口的软件。

-  4.计算机系统层面：注销，重启，更换计算机



### 体验链接成功后的adb链接

- 检查已链接设备

  - ```bash
    PS D:\repos\blogs> adb devices
    * daemon started successfully
    List of devices attached
    cb41dced        device
    ```

    

- 激活scene

  - ```bash
    
    PS D:\repos\blogs> adb shell sh /data/user/0/com.omarea.vtools/files/up.sh
    
    Copy ToyBox
    Copy BusyBox
    Install BusyBox……
    Origin File:  /data/user/0/com.omarea.vtools/files/scene-daemon
    Target File:  /data/local/tmp/scene-daemon
    ```

### 开发者选项和adb功能受限的android设备

- 某些国内厂商(比如维沃(vivo,iqoo))对开发者选项做了严格限制(OriginOS高版本),例如**允许通过usb安装应用**等选项被删除了,这就导致我们无法在不操作手机的情况下安装应用,诸如`adb install xxx.apk`需要我们操作手机点击安装才能够执行安装
  - 在OriginOS中,替换默认应用安装程序是很困难的事情(使用自带的应用商店或google play才能静默安装),而在MIUI/HyperOS中则是相对容易实现的
- 而小米等提供了解bl锁的厂商往往支持完整的开发者选项功能







