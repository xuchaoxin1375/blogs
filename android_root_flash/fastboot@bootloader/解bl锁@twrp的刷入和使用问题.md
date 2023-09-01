[toc]



# 解bl锁

- 不是所有android设备都支持解锁
- 下面是以最为典型的MIUI android设备进行实验
- 使用Miflash_unlock工具解bl锁

### 步骤

1. 点击连接[申请解锁小米手机 (miui.com)](http://www.miui.com/unlock/index.html)下载解锁工具(miflash_unlock)；

2. 手机插入有效**SIM卡**并登陆**小米账户**，进入**开发者选项**将<u>小米账户与设备绑定</u>然后手机进入fastboot模式,有两种方案

   - 方式1:在手机关机状态下“音量下”+“电源键”进入`Fastboot`
     - 方式2:本方法需要对命令行有所连接,先连接手机到电脑,并在开发这选项中允许电脑通过usb调试手机(如果手机提供了无线调试也可以,但是无线调试根据繁琐一些)
       - 电脑下载并配置adb和fastboot工具箱,使得`adb`命令可以执行
       - 使用命令行工具adb,执行`adb reboot bootloader`,手机会随即重启到fastboot模式

   - 通过数据线(推荐用原装的数据线,减少兼容性问题发生的可能!)连接解锁工具后点击“解锁”,如果软件提示成功(没有报错地执行到了100%)，耐心等待手机重启后解锁完成;

## 附:MIUI线刷工具

- 线刷工具和解锁工具不同,解锁是第一步,线刷的前提是用解锁工具解锁bl锁

- 进入MIUI论坛或点击[http://bigota.d.miui.com/tools/MiFlash2017-12-12-0-ex.zip](http://bigota.d.miui.com/tools/MiFlashSetup201612220.msi)下载刷机工具;

  - miflash这个软件有多个版本,有些渠道下载的版本可能无法正常工作

  - 通常使用上述连接提供的版本就足够了

  - 有一个英文版的网站收录了一些看似较新的版本,但是这些版本来源并不清楚,而且运行可能会报错,将连接放在此处备用[Download - Official Xiaomi Flash Tool](https://xiaomiflashtool.com/category/download)




# 第三方recovery

## twrp解密data

- 有些twrp版本是未解密的,这种情况下,即便没设置锁屏密码,依然twrp无法读取数据分区(刷机包等文件无法被twrp读取),只能格式化后才能访问数据分区,格式化后,可以链接电脑,将待刷写数据传输到手机进行卡刷等操作
- 有些twrp版本是做好解密的,这类版本就比较方便使用,不需要解密就可以读取数据分区中的数据
  - 但是我也遇到过某系twrp的安装浏览器只显示压缩包格式
    - 这也是有道理的,通常twrp刷入的都是压缩包
    - 但是项面具(magisk)获取root权限的包不一定要以压缩包后缀(比如zip),默认下载下来的是apk格式
    - 有些twrp是可以直接刷入apk,而不需重命名修改后缀apk为zip
    - 但是有些twrp安装器不显示非压缩包后缀的文件,可以自行重命名文件
      - twrp下可以用adb操作手机,因此也可以用电脑将需要的文件重命名号后移入手机在卡刷
  - Note:您可以使用twrp的高级功能中的文件浏览器来确定当前的twrp能够读取手机存储的数据



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
- 对于MIUI设备,为了能够重启到第三方recovery中,需要按住<u>音量+</u>
- 然后执行`fastboot reboot`
- 如果能解密则解密,不能解密则尝试用电脑将面具的安装包,通常名字是`app-release.apk`传输到手机
  - `adb push app-release.apk /sdcard`
- 回到twrp主菜单,点击install(安装),浏览`/sdcard`目录,找到刚才传入过来的`magisk`安装包,将其刷入(其他选项通常保持默认即可)



##  如何找到合适的TWRP rec

- twrp官方版本,适配的机型有限,很多冷门机型需要找非官方的版本,甚至自己编译
- 去酷安论坛中搜索twrp资源,可以到对应机型的话题中搜索twrp
- 去google搜索,有的github也有
- 甚至可以去哔哩哔哩找

# ref

- [小米帮助中心@MIUI设备如何刷机@FAQ(mi.com)](https://www.mi.com/service/support)
- [MIUI刷 TWRP 方法 以及 MIUI历史版本 (miuiver.com)](https://miuiver.com/how-to-flash-twrp/)

