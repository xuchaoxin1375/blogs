[toc]





## adb调试

### 功能介绍

- ADB（Android Debug Bridge）是一种强大的命令行工具，它允许您与设备进行通信，将电脑上的指令发送到设备，并在设备上执行各种操作。：

### 有线调试

- 有线调试是通过 USB 连接电脑和 Android 设备的方式。
- 这种方式的优点是连接稳定、速度快，适用于大量的数据传输，比如应用安装、调试等。
- 在进行有线调试时，需要将 Android 设备连接到电脑，并在电脑上安装相应的 USB 驱动程序。

### 无线调试

- 无线调试是通过无线网络连接电脑和 Android 设备的方式。
- 这种方式的优点是**不需要物理连接线**，更加方便灵活.
  - 在手机端上可以利用shizuku等工具,在不需要电脑的情况下可以获得adb的功能和权限
  - 虽然需要链接到一个无线网络(WLAN),这个无线网络不需要能够链接互联网,也就是说如果有一台无线路由器或者备用手机(开热点),就可以进行无线调试
- 限制
  - 在进行无线调试时，需要将 Android 设备和电脑连接到同一无线网络，并在电脑上运行 ADB 命令行工具。
  - 即wireless debugging,仅**在Android11及其以上的版本才支持**

## 配置无线adb调试

### 手机端开发者选项配置

- 必须和计算机(电脑)链接同一个局域网(一般链接同一个wifi即可,而且不可以是手机共享热点的这种形式,但这还是容易满足的)

  

|                                                              |                                                              |      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/8111ea06881848368e46eb0d60140d38.png) | 下方是的实际操作和上述截图不是同一个时刻的,所以端口号看起来不一样 <br />中间的一栏`IP address & Port`是在执行`adb connect`的时候使用 |      |



### 电脑端配置步骤

#### 初次使用进行配对

-  根据移动设备的ip:port进行配对`adb pair <ip:port>`

  - 这个步骤相当于设备初次握手,通常只需要执行一次
  - 在今后的无线调试中只需要直接链接(connect)而不需要 再执行配对操作(如果网络环境变换,可能需要重新配对)

  ```bash
  PS C:\Users\cxxu> adb pair 192.168.1.165:41363
  
  Enter pairing code: 962532
      * daemon not running; starting now at tcp:5037
      * daemon started successfully
  Successfully paired to 192.168.1.165:41363 [guid=adb-10AC7Q0EEM000W7-3iApyy]
  
  ```


#### 链接设备

- 在链接设备前,确保之前配对过,如果发现链接失败,检查
  - 手机和电脑是否在同一个局域网下(同一个wifi)
  - 是否配对过或者ip和端口port是否输入错误 

- 配对成功后尝试连接(connect)设备`adb connect <ip:port>`

  ```bash
  PS C:\Users\cxxu> adb connect 192.168.1.165:40581
  connected to 192.168.1.165:40581
  ```


#### 小结

- 可以看到,配置步骤中,我们看到了两个`<ip:port>`(套接字)
  - 一个是点击**使用配对码配对设备**后弹出的`<ip:port>`和6位配对码,这里的套接字用来验证设备身份
  - 另一个是**无线调试**界面上的`<ip:port>`,这个套接字是用来正式链接的(每次断开链接(关闭无线调试后再开启)就会刷新duan'kou)
- 一般两个ip地址是一样的,但是端口号会不一样
  - 配对端口号是用于两个设备相互认识来使用的
  - 配对成功后,两个设备就算是**认识**了(或者说是相互信任的了)
  - 就像两个陌生人称为朋友,在今后的使用中,不需要重新认识,可以直接交谈(不需要再配对,也就是不需要再自我介绍的意思)
- adb 对这两个端口(port)做了区分,是这么理解的(当然如果统一成一个端口也不是不行,但是工具被设计成这样,就只好这么用)

### 检查链接是否成功

- 用adb 命令检查链接完毕后检查设备列表

  ```bash
  PS C:\Users\cxxu> adb devices -l
  List of devices attached
  192.168.1.165:40581    device product:PD2218 model:V2218A device:PD2218 transport_id:1
  ```


- 在手机端检查

  - | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/fad1df7965484b0587b1a23cad2caad4.png) | 下拉通知中心,会提示已连接到无线调试,并且可以关闭链接 |      |
    | ------------------------------------------------------------ | ---------------------------------------------------- | ---- |

## 技巧

### 快速打开无线调试

- |                                                              |                                                              |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/b0fe1de42d1b4f68a103fe5b6d65a651.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/5307bc15a375466b937857c74af52243.png) |
  | 开发者选项中设置快捷方式(控制中心中的磁贴开关)               | 从下拉可控制中心启动无线调试                                 |

- 有些设备进行上述操作会闪退(例如某些(xiaomi/redmi)设备)

- 上述截图来自于vivo OriginOS 中的界面



## refs

- [Android Debug Bridge (adb)  | Android Developers](https://developer.android.com/studio/command-line/adb#connect-to-a-device-over-wi-fi-android-11+)
  - 完整建立adb连接分为两部分
    - 配对
      - 配对完一次后,相当于记录下来这个设备(计算机)是可以信任的
      - 后续的链接(断开之后在连接)的时候,就只需要`执行adb connect ip:port`即可,而不要再点击`pairing code`
    - 连接(低版本android使用usb;高版本android(11+)可以使用无线网络(wifi)建立链接)
      - 这里和配对步骤中使用的端口号不同(ip一般会相同)
- [How to use adb over TCPIP connect? (honeywellaidc.com)](https://support.honeywellaidc.com/s/article/How-to-use-adb-over-TCPIP-connect)





