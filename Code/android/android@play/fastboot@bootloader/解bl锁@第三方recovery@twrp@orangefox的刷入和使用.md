[toc]



## android设备解bl锁

- [Bootloader unlocking - Wikipedia](https://en.wikipedia.org/wiki/Bootloader_unlocking)
  - 解锁Bootloader:是指**禁用Bootloader安全机制**的过程，使用户可**以更大程度的刷写和修改设备**，如刷写定制固件。在智能手机上，可能是安装其他第三方的定制固件。
  - 一些厂商设备的Bootloader根本没有上锁，而其他一些设备也可用标准Fastboot命令解锁，另一些设备则需要厂商的帮助才可解锁，而对于有些不提供解锁和方法的设备，只能通过软件漏洞进行解锁。
  - 有时解锁Bootloader也是出于取证的目的，例如用Cellebrite UFED等工具从移动设备中取证。

- 第三方的recovery的刷入的前提就是解bootloader锁(简称bl锁),或者设备压根没有bl锁

### 厂商为什么上锁

- 解除Bootloader通常会令设备保修失效，并可能使设备容易受到数据盗窃的影响。另一方面,用户做所的更改可能使系统变得不稳定和引入bug,容易导致厂商产品受影响
  - 例如在Chromebook上，启用开发者模式会令系统安全性不足安装于标准笔记本电脑的Linux系统。
  - 解锁Bootloader也会导致Android和Chrome OS设备上的数据丢失，因为有些数据在没有root权限的情况下是无法进行备份的。

### 解锁门槛越来越高

- 不是所有android设备都支持解锁
- 下面是以最为典型的Xiaomi/Redmi android设备进行实验(搭载MIUI的android定制系统)
  - 使用Miflash_unlock工具解bl锁

- 现在解锁设备越来越不容易,设备厂商对这类权限越收越紧,对于新的设备,解锁政策和条件门槛比以往更加高,例如Xiaomi Hyperos的设备,就需要满足种种条件才能解锁,这不是说解锁技术变复杂了,而是授权解锁权限得过程变得不容易,主打的是等待

### 步骤

1. 点击连接[申请解锁小米手机 (miui.com)](http://www.miui.com/unlock/index.html)下载解锁工具(miflash_unlock)；

2. 手机插入有效**SIM卡**并登陆**小米账户**，进入**开发者选项**将<u>小米账户与设备绑定</u>然后手机进入fastboot模式,有两种方案

   - 方式1:在手机关机状态下“音量下”+“电源键”进入`Fastboot`
     - 方式2:本方法需要对命令行有所连接,先连接手机到电脑,并在开发这选项中允许电脑通过usb调试手机(如果手机提供了无线调试也可以,但是无线调试根据繁琐一些)
       - 电脑下载并配置adb和fastboot工具箱,使得`adb`命令可以执行
       - 使用命令行工具adb,执行`adb reboot bootloader`,手机会随即重启到fastboot模式

   - 通过数据线(推荐用原装的数据线,减少兼容性问题发生的可能!)连接解锁工具后点击“解锁”,如果软件提示成功(没有报错地执行到了100%)，耐心等待手机重启后解锁完成;
   
   - https://xiaomiflashtool.com/category/download)
   



## 第三方recovery

### 词语说明

- recovery下面简称为rec
- 第三方recovery,简称为第三方rec或三方rec

### 什么是rec

#### 简洁

- [Android recovery mode - Wikipedia](https://en.wikipedia.org/wiki/Android_recovery_mode)

  - Android恢复模式（Android recovery mode）是Android用于安装系统更新的一种模式。 [1][2]它由一个带有RAM disk的Linux内核组成，该内核位于与主Android 系统不同的分区上。

    每个手机进入恢复的方式都不同。 [3]

  - 例如： 

    Nexus 7 ： Volume Up + Volume Down + Power
    三星Galaxy S III ： Volume Up + Home + Power
    摩托罗拉 Droid X ： Home + Power

#### 功能

- 恢复模式可以用来：

  - 使用Android调试桥更新系统或刷入模块修改已有系统

  - 通过SD卡更新系统

  - 恢复出厂设置

  - 安装分区

  - 运行系统测试

  - 自定义恢复

- Android上预装的恢复模式可以用其他软件代替，例如OrangeFox,TWRP或ClockWorkMod。[5]

- 比较流形的三方rec有以下两种:`OrangeFox`,`TWRP`

  - [OrangeFox Recovery Downloads](https://orangefox.download/en/)

  - [TeamWin - TWRP](https://twrp.me/)

- 不是所有机型都有官方适配的rec,许多冷门机型在上述网站上找不到,但有些论坛(coolapk)上有geek自己编译分享出来的版本,可能有较多bug

### 选择合适的twrp版本

- 无论是从主流rec官网还是极客分享的rec,都需要检查,是否和自己的设备兼容
  1. rec是否为自己设备的型号所开发的
  2. 自己设备的型号搭载的android版本也要关注,例如为android13开发和适配的rec刷入android11的版本,就可能无法正常工作,通常是无法读取设配存储(无法解密设备分区),导致刷机受阻
- 上述两点缺一不可
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/e334d997e2264b2a81a73ed1160a9632.png)
- 另一方面就是阅读使用说明,检查资源包下载的格式,通常是`img`格式或者其他压缩包格式,例如(`zip`),这时往往要解压出`img`
  - 如果直接刷入不正确的包,会导致rec模式无法进入(只能进入fastboot(bootloader)模式)或者虽然能开机,但是无法进入rec模式

#### 如何找到合适的TWRP rec

- twrp官方版本,适配的机型有限,很多冷门机型需要找非官方的版本,甚至自己编译
- 去酷安论坛中搜索twrp资源,可以到对应机型的话题中搜索twrp
- 去google搜索,有的github也有
- 甚至可以去哔哩哔哩找

### rec解密data问题

- 有些rec版本无法读取到设备存储(需要密码解密)
  - 有时您可以通过锁屏密码解密
  - 但有些情况,即便没设置锁屏密码,依然rec依然无法读取数据分区(通常是data分区)这导致(刷机包等文件无法被rec读取)
    - 这类情形通常是您的twrp和当前设备或系统不兼容
    - 要么寻找合适的rec,要么清除整个data分区,这样您的刷机包就需要通过电脑重新导入给rec
      - 通常格式化后,可以链接电脑,将待刷写数据传输到手机进行卡刷等操作

- 如果rec版本合适,那么通常不会有解密data分区的问题

Note:

- 某些twrp的rec在展示设备文件时,只显示压缩包格式
  - 这也是有道理的,通常twrp刷入的都是压缩包
- 但是项面具(magisk)获取root权限的包不一定是以压缩包后缀(比如zip),默认下载下来的是apk格式
  - 有些rec,例如twrp是可以直接刷入apk,而不需重命名修改后缀apk为zip,这就需要自己提前重命名文件,然后进入rec,或者借助电脑进入rec后将电脑上文件改名后传输给手机rec
  - 而OrangeFox刷入magisk时,就要将apk改为zip,否则orangeFox仅执行解包工作而不会刷入magisk

### rec下可以使用adb

- rec下可以用adb操作手机,因此也可以用电脑将需要的文件重命名号后移入手机在卡刷

- 以尝试用`adb push xxxx /sdcard` 命令将需要刷写的内容在rec模式下,传输到手机上




### 刷入面具magisk

- 如果不想通过修补boot的方法获取root权限,可以用rec刷入magisk的方式获取root
- 例如:`fastboot flash recovery .\twrp-3.7.0_9-0-lavender.img`可以刷入`3.7.0`版本的twrp
  - 对于Xiaomi/Redmi设备,为了能够重启到第三方recovery中,需要按住<u>音量+</u>,即`Volume up`
  - 然后执行`fastboot reboot`
  - 如果此时rec能解密data则解密,不能解密则尝试用电脑将面具的安装包,通常名字是`magisk`包传输到手机
    - `adb push app-release.apk /sdcard`

- 回到twrp主菜单,点击install(安装),浏览`/sdcard`目录,找到刚才传入过来的`magisk`安装包,将其刷入(其他选项通常保持默认即可)





## 附:MIUI线刷工具

- 线刷工具和解锁工具不同,解锁是第一步,线刷的前提是用解锁工具解锁bl锁

- 进入MIUI论坛或点击[http://bigota.d.miui.com/tools/MiFlash2017-12-12-0-ex.zip](http://bigota.d.miui.com/tools/MiFlashSetup201612220.msi)下载刷机工具;

  - miflash这个软件有多个版本,有些渠道下载的版本可能无法正常工作

  - 通常使用上述连接提供的版本就足够了

  - 有一个英文版的网站收录了一些看似较新的版本,但是这些版本来源并不清楚,而且运行可能会报错,将连接放在此处备用[Download - Official Xiaomi Flash Tool](

## ref

- [小米帮助中心@MIUI设备如何刷机@FAQ(mi.com)](https://www.mi.com/service/support)
- [MIUI刷 TWRP 方法 以及 MIUI历史版本 (miuiver.com)](https://miuiver.com/how-to-flash-twrp/)



