[toc]

- [MIUI刷 TWRP 方法 – MIUI历史版本 (miuiver.com)](https://miuiver.com/how-to-flash-twrp/)

## 解密data

### data decrypt

- 如果有锁屏密码,可以试试锁屏密码来解锁
- 若无重要数据,可以点击取消按钮,会跳转到菜单页,选择清除(wipe),清除data(数据会丢失)
- 如果不解密的化,twrp无法读取手机磁盘(存储内容),可以尝试用`adb push xxxx /sdcard` 命令将需要刷写的内容在twrp启动的状态下传输到手机上

### 清除data后用twrp中刷入文件

- 假设无法通过密码解密,使用清除data的方式解密会将系统恢复出场设置,数据全部丢失,为了能刷入内容,可以借助电脑,在重启到系统前将需要刷入的包传输到手机中,比如`/sdcard`目录中
- 然后回到twrp主菜单中的install(安装)进入浏览文件并刷入
- 重启会花费比较长的时间,因为清除了data,手机要执行恢复出产设置的操作

### 刷入面具

- 如果不想通过修补boot的方法获取root权限,可以走twrp(或其他第三放recovery)刷入magisk的方式获取root
- 以lavender(redmi note7)为例:`fastboot flash recovery .\twrp-3.7.0_9-0-lavender.img`可以刷入`3.7.0`版本的twrp
- 对于MIUI设备,为了能够重启到recovery中,需要按住<u>音量+</u>
- 然后执行`fastboot reboot`
- 如果能解密则解密,不能解密则尝试用电脑将面具的安装包,通常名字是`app-release.apk`传输到手机
  - `adb push app-release.apk /sdcard`
- 回到twrp主菜单,点击install(安装),浏览`/sdcard`目录,找到刚才传入过来的`magisk`安装包,将其刷入(其他选项通常保持默认即可)