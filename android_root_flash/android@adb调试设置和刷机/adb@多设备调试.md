[toc]



## adb操作多个在线设备👺

- ```bash
  PS C:\Users\cxxu\Desktop> adb --help
  Android Debug Bridge version 1.0.41
  Version 33.0.2-8557947
  Installed as D:\exes\platform-tools\adb.exe
  
  global options:
   -a                       listen on all network interfaces, not just localhost
   -d                       use USB device (error if multiple devices connected)
   -e                       use TCP/IP device (error if multiple TCP/IP devices available)
   -s SERIAL                use device with given serial (overrides $ANDROID_SERIAL)
   -t ID                    use device with given transport id
   -H                       name of adb server host [default=localhost]
   -P                       port of adb server [default=5037]
   -L SOCKET                listen on given socket for adb server [default=tcp:localhost:5037]
   --one-device SERIAL|USB  only allowed with 'start-server' or 'server nodaemon', server will only connect to one USB device, specified by a serial number or USB device address.
   --exit-on-write-error    exit if stdout is closed
  
  general commands:
   devices [-l]             list connected devices (-l for long output)
   help                     show this help message
   version                  show version num
  ```

- 注意到其中的:

  - ```bash
     -s SERIAL                use device with given serial (overrides $ANDROID_SERIAL)
     -t ID                    use device with given transport id
    ```

  - 参数`-s`,`-t`都可用来指定设备,通常,使用`-t`会更加方便

### 例

- 假设我当前有两台设备同时链接到同一台PC,且都处于在线状态(device而非offline),检查设备详情:`adb devices -l`

  ```bash
  PS C:\Users\cxxu\Desktop> adb devices -l
  List of devices attached
  194f4726               device product:mondrian model:23013RK75C device:mondrian transport_id:1
  cb41dced               device product:lavender model:Redmi_Note_7 device:lavender transport_id:2
  ```

  - 其中第一个字段为`serial`(设备序列号字段)
  - 最后一个字段为通信端口字段`trainsport_id`

#### -s

- ```bash
  PS C:\Users\cxxu\Desktop> adb -s 194f4726 shell
  mondrian:/ $ exit
  
  PS C:\Users\cxxu\Desktop> adb -s cb41dced shell
  lavender:/ $ exit
  ```

#### -t

- ```bash
  PS C:\Users\cxxu\Desktop> adb -t 1 shell
  mondrian:/ $ exit
  
  PS C:\Users\cxxu\Desktop> adb -t 2 shell
  lavender:/ $ exit
  
  ```

