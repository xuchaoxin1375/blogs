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



### 体验链接成功后的adb链接(scene5)玩机工具

```bash
PS D:\repos\blogs> adb devices
* daemon started successfully
List of devices attached
cb41dced        device

PS D:\repos\blogs> adb shell sh /data/user/0/com.omarea.vtools/files/up.sh

Copy ToyBox
Copy BusyBox
Install BusyBox……
Origin File:  /data/user/0/com.omarea.vtools/files/scene-daemon
Target File:  /data/local/tmp/scene-daemon
```

## 无线adb调试(android11+:wireless debugging)

### refs

- [Android Debug Bridge (adb)  | Android Developers](https://developer.android.com/studio/command-line/adb#connect-to-a-device-over-wi-fi-android-11+)
  - 完整建立adb连接分为两部分
    - 配对
      - 配对完一次后,相当于记录下来这个设备(计算机)是可以信任的
      - 后续的链接(断开之后在连接)的时候,就只需要`执行adb connect ip:port`即可,而不要再点击`pairing code`
    - 连接(低版本android使用usb;高版本android(11+)可以使用无线网络(wifi)建立链接)
      - 这里和配对步骤中使用的端口号不同(ip一般会相同)
- [How to use adb over TCPIP connect? (honeywellaidc.com)](https://support.honeywellaidc.com/s/article/How-to-use-adb-over-TCPIP-connect)

## 手机端开发者选项配置

- 必须和计算机(电脑)链接同一个局域网(一般链接同一个wifi即可,而且不可以是手机共享热点的这种形式,但这还是容易满足的)
- 

![image-20220718222651254](https://img-blog.csdnimg.cn/img_convert/03c7ed2ad6a9ee899799b3ca9a02ea4c.png)

- 下方是的实际操作和上述截图不是同一个时刻的,所以端口号看起来不一样

- 中间的一栏`IP address & Port`是在执行`adb connect`的时候使用
- 计算机端启动命令行工具(adb),执行配对手机操作:

```bash
#根据移动设备的ip:port进行配对
PS C:\Users\cxxu> adb pair 192.168.2.82:35917
Enter pairing code: 894477
Successfully paired to 192.168.2.82:35917 [guid=adb-UO7PKFNF99IR9TV4-AHP89O]
#配对成功后尝试连接(connect)
PS C:\Users\cxxu> adb connect 192.168.2.82:34917
connected to 192.168.2.82:34917
#链接完毕后检查设备列表
PS C:\Users\cxxu> adb devices -l
List of devices attached
192.168.2.82:34917     device product:xaga model:22041216C device:xaga transport_id:2
```

##  玩机工具箱

- [搞机工具箱:作者:晨钟网络科技 - 致力于开发小众实用软件 (jamcz.com)](https://jamcz.com/)





