[toc]





## 无线adb调试(android11及其以上的版本:wireless debugging)👺

### refs

- [Android Debug Bridge (adb)  | Android Developers](https://developer.android.com/studio/command-line/adb#connect-to-a-device-over-wi-fi-android-11+)
  - 完整建立adb连接分为两部分
    - 配对
      - 配对完一次后,相当于记录下来这个设备(计算机)是可以信任的
      - 后续的链接(断开之后在连接)的时候,就只需要`执行adb connect ip:port`即可,而不要再点击`pairing code`
    - 连接(低版本android使用usb;高版本android(11+)可以使用无线网络(wifi)建立链接)
      - 这里和配对步骤中使用的端口号不同(ip一般会相同)
- [How to use adb over TCPIP connect? (honeywellaidc.com)](https://support.honeywellaidc.com/s/article/How-to-use-adb-over-TCPIP-connect)

### 手机端开发者选项配置

- 必须和计算机(电脑)链接同一个局域网(一般链接同一个wifi即可,而且不可以是手机共享热点的这种形式,但这还是容易满足的)

  

|                                                              |                                                              |      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/8111ea06881848368e46eb0d60140d38.png) | 下方是的实际操作和上述截图不是同一个时刻的,所以端口号看起来不一样 <br />中间的一栏`IP address & Port`是在执行`adb connect`的时候使用 |      |



### 电脑端配置步骤

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

- 配对成功后尝试连接(connect)设备`adb connect <ip:port>`

  ```bash
  PS C:\Users\cxxu> adb connect 192.168.1.165:40581
  connected to 192.168.1.165:40581
  ```

- 链接完毕后检查设备列表

  ```bash
  PS C:\Users\cxxu> adb devices -l
  List of devices attached
  192.168.1.165:40581    device product:PD2218 model:V2218A device:PD2218 transport_id:1
  ```

  

##  玩机工具箱

- [搞机工具箱:作者:晨钟网络科技 - 致力于开发小众实用软件 (jamcz.com)](https://jamcz.com/)





