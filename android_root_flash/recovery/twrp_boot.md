[toc]



# 刷入twrp_twrp刷入面具&进入recovery(twrp)的方式&获取root&刷入第三方rom&获取第三方rom包&国际版rom包的网络连接受限问题

## 风险声明

- 刷机总是伴随风险,尽管你可以采取很小心的态度来降低变砖的几率
  - 但是我有义务提醒读者,读者也有必要做好心理准备

## 参考链接

- 以redmi 4x为例
  - 下面的教程中,有些步骤不是必须要的,但是可以开阔思路
  - [Install LineageOS on santoni | LineageOS Wiki](https://wiki.lineageos.org/devices/santoni/install)
  - [Xiaomi Redmi 4X (twrp.me)](https://twrp.me/xiaomi/xiaomiredmi4x.html)
  - [Download and Install Lineage OS 19 for Redmi 4X (Android 12) (getdroidtips.com)](https://www.getdroidtips.com/lineage-os-19-redmi-4x/#Instructions-to-Install)

## 工具&材料准备

- 已经解锁的android手机(譬如小米/redmi手机)
  - [解锁小米手机 - Magisk中文网 (magiskcn.com)](https://magiskcn.com/unlock-mi)
  - 同时,在开发者选项中开启usb调试
    - (驱动现在一般不是问题,win10/11自带对android的驱动)
    - 但是不排除例外,请自行搜索驱动打上
- pc(windows10/11)
  - windows terminal+powershell(或者cmd) 组合
- 命令行工具
  - [SDK Platform Tools 版本说明  | Android 开发者  | Android Developers (google.cn)](https://developer.android.google.cn/studio/releases/platform-tools?hl=zh-cn)
- 下载magisk app

  - [Releases · topjohnwu/Magisk (github.com)](https://github.com/topjohnwu/Magisk/releases)





# 第三方recovery(twrp篇)

- twrp是流行的第三方recovery,功能十分丰富

- 第三方recovery也叫custom recovery
  - [TWRP (software) - Wikipedia](https://en.wikipedia.org/wiki/TWRP_(software))

## twrp的作用$\bigstar$

- twrp`功能全面`,可以用来
  - 刷入面具(magisk)以获取root
  - 关于卡刷第三方包(非官方rom的刷入经常使用流行的twrp来操作)
    - 刷第三方包用卡刷方式的较多感觉,线刷一般用来
      - 获取root,刷入twrp,当然还可以刷入官方rom实现降级以及救砖(白砖)
      - 之后的事情可以交给twrp
      - 或者用magisk app就可以安装模块
  - twrp中advance还提供
    - linux终端,你可以执行一些命令(譬如创建文件夹)
      - 应该是自带root权限的
    - 文件管理器
      - 可以执行删除文件或者目录的功能(拖动滑块来确定执行操作)
      - 这很有用,特别是玩机部分(比如magsik的某系模块冲突导致的无限重启,就可以使用twrp的文件管理功能删除掉可能引起冲突的模块)

### 第三方recovery(custom recovery)适配问题

- custom recovery的共同问题

  - 需要有人来适配你的机型

  - 刷入twrp往往需要fastboot,如果是这样,那么你大概率要会线刷(譬如刷入修补后的boot.img)的基础

  - 幸运的是,只要你的机器不是太过于冷门,那么玩机大佬往往会打包好相关工具

    - 比如专门适配过的twrp(非twrp团队的unofficial版本)

    - 甚至还提供了刷写脚本(对于高版本android设备来说是一个福音)

- 对于线刷方式玩机(root/模块)可以看看

  - [android 手机获取root权限_获取刷入模块_MIUI_android7~android12实践/A1内存管理和钢铁后台效果测评/root省电调度&性能调度_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/126015726?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"126015726"%2C"source"%3A"xuchaoxin1375"}&ctrtid=A1OZh)

## 获取twrp

- [TeamWin - TWRP](https://twrp.me/)
- 例如redmi 4x的教程
  - 借助**<u>google搜索</u>**想要的机型(例如:`redmi 4x twrp`或者`twrp for <your device type name>`)
    - 必要的时候,使用强调语法(加`双引号"keyword"`)来提供搜索效率,譬如`"redmi" note 11 t pro "twrp"`
  - [Xiaomi Redmi 4X (twrp.me)](https://twrp.me/xiaomi/xiaomiredmi4x.html)

- 其他来源
  - 酷安论坛!
  - github!
    - 例如:[Search · redmi note 11t pro · GitHub](https://github.com/search?q=redmi+note+11t+pro)





## 刷入twrp

- 刷入twrp的方式有多种
  - 最通用的当属fastboot线刷方式,这不要求你有root权限,也比较推荐
  - 其他方式有不需要电脑的,但是前提是手机已经root,这可能导致的囧境是,我还没有root,去需要用到root!
    - 但是这种方式也有用处,比如,我确实已经通过某种途径(未必是刷入面具的方式),而仅仅只是想要刷入twrp这种流行的第三方的recovery维护系统

### 线刷方式(by fastboot)

####  android11之前的设备

- 确保设备已经解除bl锁,usb调试打开并且允许电脑调试android设备
- 命令行检查驱动(可选的,如果遇到异常,再检查)
  - 如果处于开机状态,执行`adb devices -l`
    - 开机状态下,如果设备正常驱动,也可以通过`adb reboot bootloader`直接重启到fastboot模式
  - 如果处于关机状态,通过组合键(通常是(`音量-` 结合 `电源键`) ,进入到fastboot模式fastboot devices`检查设备是否正常链接
- 正常连接到电脑后,利用google提供的命令行工具(fastboot.exe)进行刷写`twrp文件`(img)到recovery 分区中
  - ` fastboot flash recovery .\twrp-3.6.2_9-0-santoni.img`

#### android11之后的设备(稍复杂)

- 手动刷入的步骤可以参考

  - [Install Custom ROMs on any Android Device- Includes A/B Partition (droidwin.com)](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#STEP_1_Temporary_Boot_your_device_to_TWRP_Recovery)

    - Install Custom ROMs on any Android Device- Includes A/B Partition

      - [IMPORTANT NOTE 1- About Flashing and Partitions](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#IMPORTANT_NOTE_1-_About_Flashing_and_Partitions)

      - [Prerequisites:](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#Prerequisites)

      - [Downloads](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#Downloads)

      - [IMPORTANT NOTE 2- Setting up the TWRP Recovery](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#IMPORTANT_NOTE_2-_Setting_up_the_TWRP_Recovery)

        - [STEP 1: Temporary Boot your device to TWRP Recovery](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#STEP_1_Temporary_Boot_your_device_to_TWRP_Recovery)
        - [STEP 2: Permanently Install the TWRP Recovery:](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#STEP_2_Permanently_Install_the_TWRP_Recovery)

      - Installing Custom ROMs on A/B Partition Devices

        - [What is an A/B Partition?](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#What_is_an_AB_Partition)
        - [IMPORTANT NOTE 4- Handling Slots and Partitions](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#IMPORTANT_NOTE_4-_Handling_Slots_and_Partitions)
        - How to Install a Custom ROM on A/B Partition Devices
          - [STEP 1: Installing a Custom ROM](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#STEP_1_Installing_a_Custom_ROM)
          - [STEP 2: Changing Slots- From Active to Inactive](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#STEP_2_Changing_Slots-_From_Active_to_Inactive)

      - [Installing Custom ROMs on Single ‘A’ Partition Devices](https://www.droidwin.com/install-custom-roms-android-device-a-b-partition/#Installing_Custom_ROMs_on_Single_‘A’_Partition_Devices)

        

> 简单一句话,如果想偷懒,就找那种包含刷写脚本的资源,可以大大降低刷入难度并提高成功率

- 高版本android设备基本普及了对于vab分区特性的使用,使得刷写稍微复杂了一些

- 而且对于联发科的设备,需要更加小心(fastboot十分的脆弱,一不小心就得换主板😥)不像高通的那么耐操)

- 示例代码(这是一段bat脚本代码,是为2022年5月发布的redmi note 11t pro(代号为xaga(pro)的机器失配的twrp的刷写脚本))

  - ```bat
    @echo off
    
    set twrp_version=twrp-12.1
    
    title "Note 11T pro TWRP Recovery 刷入工具 版本: %twrp_version% "
    
    :menu
    cls
    echo "Note 11T pro TWRP Recovery 刷入工具 版本: %twrp_version% "
    echo 请选择内核版本: 
    echo          1.  原版
    echo          2.  twrp
    echo.
    echo PS: 请先进入Fastboot模式
    echo.
    set choice=
    set /p choice=请直接输入对应数字回车: 
    if not "%choice%"=="" set choice=%choice:~0,1%
    if /i "%choice%"=="1" (
    set kernel=原版
    goto flash
    )
    if /i "%choice%"=="2" (
    set kernel=twrp
    goto flash
    )
    echo.
    echo 输入无效，请重新输入...
    timeout /t 2 /nobreak > nul
    echo.
    goto menu
    
    :flash
    cls
    echo 镜像文件: %twrp_version%_%kernel%.img
    echo.
    echo 获取当前槽位中...
    for /f "tokens=2 delims=: " %%i in ('fastboot %* getvar current-slot 2^>^&1 ^| findstr /r /c:"current-slot:"') do (set slot=%%i)
    echo 槽位 %slot%
    echo.
    echo 刷写 vendor_boot 中
    fastboot flash vendor_boot_ab %twrp_version%_%kernel%.img
    echo 刷写完成
    echo.
    if "%slot%"=="b" (
    echo 重启进入 Fastbootd
    fastboot reboot fastboot
    echo 正在设置槽位 %slot%
    fastboot --set-active=%slot%
    echo.
    )
    echo 重启进入 Recovery
    fastboot reboot recovery
    pause
    exit
    ```

    
#####  刷入过程输出
```bash
镜像文件: twrp-12.1_twrp.img

获取当前槽位中...
槽位 a

刷写 vendor_boot 中
Sending 'vendor_boot_ab' (65536 KB)                OKAY [  1.552s]
Writing 'vendor_boot_ab'                           OKAY [  0.371s]
Finished. Total time: 1.981s
刷写完成

重启进入 Recovery
Rebooting into recovery                            OKAY [  0.048s]
Finished. Total time: 0.055s
Press any key to continue . . .


```
## 进入recovery(twrp)的方式

- 刷入**twrp** recovery文件之前,我们先感性认识一下刷机包的品类

### 刷机包的类别(custom Recovery vs ROM)

- 刷机包可以是
  - 第三方rom
  - 或者类似于模块的包,例如
    - 用户获取root的magisk app,将安装包的名称后缀从`.apk`修改为`zip`,就是一种所谓的`刷机包`
      - 很神奇是不是!(其实刷入magisk的时候不需要修改包名,但是为了保险起见,修改一下)
      - 估计是magisk apk和twrp达成某种协议,使得magisk可以刷入修改后缀名的`magisk`安装包
- 但是注意,刷入第三方rom的时候需要清除数据
- 刷入magisk的时候,不需要清除数据

### 进入recovery模式的通法

- 除了尝试音量键和电源键,我更推荐在开机状态下执行adb命令
  - `adb reboot recovery`的方式进入到recovery
    - 如果你刷入的是第三方recovery,那么就会进入到第三方recovery(譬如twrp)
  - 好处是不要把握按按键组合和按压时间

### 按键法🤷‍♂️(●'◡'●)

- 如果您已经通过某种方式刷入第三方rom系统包,而想要进入recovery,进入方式**可能**发生改变
  - 例如,我的情况
    - 设备:redmi 4x(已经解除bl锁)
    - 通过fastboot刷入第三方recovery(用的是twrp)
    - 下载的第三方rom系统包,借助刚刚刷好的twrp(recovery)卡刷刷入rom包
    - 系统能够正常进入,但是进入recovery的方式发生改变
      - 原本是`音量+`配合`电源键`进入recovery
      - 现在经过一番尝试,变为`音量+`,`音量-`,`电源键`同时按下进入



## 各种清除数据的操作&N清

- [TWRP教程之双清、三清、四清的含义和用在什么情况下 - 腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/news/484152)
- [What should I wipe in TWRP?](https://twrp.me/faq/whattowipe.html)

- twrp三清:现在twrp简化了操作,直接swipe to wipe(滑动滑块完成清除操作)
  - 包括Data,Cache,Dalvik
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/cbe2286b95f14ca782754f2efd7c9998.png)

#### format Data 

- format Data 在新刷入的系统启动时要求输入密码的时候,执行它(通常不需要执行)
  - 类似于`/sdcard/`这类目录可能不会被清除
  - 即,由于内部存储(internal storage)被加密(某些rom包在被刷入时会执行加密),新系统无法顺利加载,关机后重新执行数据清除(format Data)操作
    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/5e08fc64f428448bb522bd889b6b8a5a.png)

  - 重启进入系统

#### 高级清除:N清

![在这里插入图片描述](https://img-blog.csdnimg.cn/c1a12d8e69c544368e61ed6ab82ebf05.png)

### twrp的清除功能使用说明:官网的解释



- If you are switching ROMs (changing from one ROM to a completely different one) then you should perform a factory reset.
  -  A factory reset wipes data and cache (which includes dalvik cache). 
  -  A factory reset will also wipe sd-ext and android_secure if your device has those items. 99% of the time, this is all that you need to wipe and you only need to do it once, not three times as some people would lead you to believe.
- If you're installing a nightly update, then oftentimes you don't need to wipe anything at all. However, if you encounter strange behavior, then you may want to consider performing a factory reset. Of course, if the ROM maker recommends that you do a factory reset during an update, then it's a good idea to follow their recommendation.
- The vast majority of ROMs wipe system as part of the zip install. This means that in most cases you do not need to wipe system... ever.
- At this point, cache (not dalvik cache) is primarily used for recovery. It's used to store the recovery log and for storing OTA (Over The Air) updates. You probably don't need to wipe cache, and cache is already wiped as part of a factory reset.
- In most ROMs, dalvik cache is stored in the data partition, so if you do a factory reset, you've also wiped dalvik cache. In a few custom ROMs, especially on older devices with small data partitions, the ROM maker may have moved dalvik to the cache partition to provide you with more room for apps. Since we wipe cache with a factory reset, again, you probably don't need to wipe dalvik. There are a few situations where you may need to wipe dalvik cache when installing updates, but you will know that it's needed when you are greeted with force closes when trying to open some apps.
- Depending on your device and its configuration, you may have options for wiping internal storage, external storage, sd-ext, android_secure, and/or an option for formatting data. There's almost no reason that you would ever need to use these items. These options are there for convenience. For instance, if you're getting ready to sell your device, then it's a good idea to wipe everything on the device so that the new owner doesn't get your private data. Note that these wipe options may not be completely destructive. If you store especially sensitive information on your device or are really concerned about your private data, then you may need to look into other options to ensure that your data is fully destroyed.



# 第三方rom篇

## 第三方rom获取/推荐



- google搜索(推荐,可以检索到各种来源)
  - 你可以搜索指定机型指定android版本(这是最高效,且有目的性的)
    - 想要获取基于最新android版本的rom包这么google搜几乎是最高效的
    - 有时候还会搜索到配套刷机视频(譬如来自youtub e)
    - 刷机包资源就在视频简介下方或者评论区
    - 而且还可以看看用户对该rom的评价,问题早发现,譬如有的包链接wifi会受限/时间过期导致的网络问题等
    - 或者解决方案(而不仅仅只有bug的提出)
  - XDA论坛/酷安论坛
- 比较容易刷入的包
  - `Mokee OS`提供的包(纯卡刷包)
  - `Paranoid Android  OS`(有纯卡刷包)(官网不太好使,配合搜搜引擎)
  - 注意到,有些冷门的机型,或者已经过时很久的机型,几个rom网站可能找不到(譬如我试验的redmi 4x)
    - 这种情况下,可以借助google搜一下,或许有人发布的高手制作的包
    - 注意是否有提供了操作步骤,以防止刷入失败(特别是个人制作的非官方lineageOs,不那么容易刷成功,可能会有额外的步骤要求)
  - 有的还有telegram群组,就不细讲了

### 其他来源

- [7 款最佳第三方安卓](https://www.ruancan.com/android/7-best-third-party-android-custom-roms.html)
  - LineageOS
    - 原 CyanogenMod 项目的正统继任者
    - 仅提供最少的附加功能，以高性能、高通用性著称
    - [官网](https://lineageos.org/)
  - Pixel Experience
    - 提供最接近 Pixel 上的原生 Android 体验
    - 随附所有 Google 应用和 Pixel 桌面、壁纸、图标、字体和启动动画。
    - [官网](https://download.pixelexperience.org/)
  - Paranoid Android（又名 AOSPA）
    - 提供创新的功能、流畅的界面以及优秀的相机应用
    - [官网](https://paranoidandroid.co/)
  - Evolution X
    - 提供接近 Pixel 原生 ROM 的体验
    - 预装了 Google 应用程序
    - 多种自定义功能，例如状态栏可见性切换和游戏模式快速设置
    - [官网](https://evolution-x.org/)
  - ArrowOS
    - 轻量级的 ROM
    - 最贴近 AOSP，仅在前者之上进行了少量调整
    - 提供流畅的性能和更长的电池续航
    - [官网](https://arrowos.net/)
  - dotOS
    - 基于 AOSP，以独特的界面和创新功能著称
    - 提供了大量附加功能
    - [官网](https://www.droidontime.com/)
  - Xiaomi.EU
    - 基于中国 MIUI beta 版固件包构建，并进行了国际化
    - 适用于海外用户



### 实操案例:魔趣rom

- **魔趣开源项目**，前身为**魔趣OS**，是基于CAF二次开发的一个[Android](https://zh.m.wikipedia.org/wiki/Android)分支版本，是完全[开源](https://zh.m.wikipedia.org/wiki/开源)的[Android](https://zh.m.wikipedia.org/wiki/Android)第三方操作系统
  - 魔趣的所有功能完全遵循[Material Design](https://zh.m.wikipedia.org/wiki/Material_Design)[[1\]](https://zh.m.wikipedia.org/zh-hans/魔趣#cite_note-introduce-1)，是一款类原生[Android](https://zh.m.wikipedia.org/wiki/Android)操作系统

#### 下载魔趣ROM

- 为了赚点维护费,魔趣下载页面有广告,这可能影响到下载的定位
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/f936360781f34b96be8c60fc203fc13f.png)

  - 右上角可以选择版本的稳定性为过滤条件
    - ![image-20220729084101220](https://img-blog.csdnimg.cn/img_convert/becedf9d725b1a7c052a0886ad7d0198.png)
  - 注意到,您可以选择android版本
    - 譬如上面显示的基于android11的rom



## 辨别ROM刷机包是否为纯正的卡刷包

- 不同的第三方ROM刷入方式可能存在差异
  - 例如`lineageOS`提供的包的刷入方式和`魔趣`的包是有差异的
  - 前者似乎是使用依赖于
    - `adb sideload `方式刷入
    - 有点线刷的味道
- 魔趣的包目前刷入风格是可以直接通过twrp就可以愉快的刷入

## 国际版rom包的网络连接受限问题

- 由于基于较新版本的android制作的包经常是老外做的,那么时区问题就会显现出来,例如在android12的类原生包,提示我连接wifi后连接受限(limited connection)
- 尝试设置时区和系统时间,最好和北京时间一致(相差个别小时也是没问题的,虽然可能还是提示受限,但是浏览器之类的应用应该能够正常访问互联网了)

# twrp玩机部分

## 用twrp刷入第三方rom(twrp玩法1)

- 魔趣提供的rom为例





### 操作要求和注意事项

- 不合适的刷机包可能导致
  - 无法正常刷入
  - 刷入但无法开机
- 一般老机器刷入类原生rom后,有可能就焕发第二春啦
  - 有机会体验类原生
  - 体验较高版本的android(OEM可能停止维护,就可以通过这种方式尝鲜)
  - 拒绝臃肿,体验到精简系统

### 下载rom&查看rom提供者的刷入教程

- 首先你需要下载合适你机型的rom(可以参考前面提到的获取途径)
- 不同rom提供来源会配备独家的刷入流程,否则默认按照常规方式刷入
- 甚至于,不同版本的android,同一网站提供的不同rom包刷入教程也可能不同
- 例如这是魔趣提供的刷入流程(参考)
  - [快速上手 | 魔趣 ROM (mokeedev.com)](https://www.mokeedev.com/guide/getting_started.html#通过-fastboot-安装-recovery)
    - 这里的清除数据不会删除`/sdcard/Download`这类目录文件



### 开始刷入rom包

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/740c83eeefac4f0dbf94c774f901e58f.png)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/3d642cad3c934c13acdafffef27bb443.png)

## 用twrp刷入面具获取root(twrp玩法2)

- 实际上,如果有现成的twrp,那么刷入magsik获取root的过程会变得十分的简单

- 相对于线刷,twrp刷入magisk不需要在修补boot.img(也就省去了获取boot.img过程(这对于某些开发版系统来说更为简便)

  - 但这不是唯一的方式,还可能通过修补boot.img线刷的方式,这种方式是获取root的更加通用的方式,这里不展开,另外查资料

  - [如何获取MIUI最新系统包 - Magisk中文网 (magiskcn.com)](https://magiskcn.com/get-miui)

    

- 基于twrp刷入magisk过程

  - 和刷入rom的操作类似
  - 但是不需要清除数据啦
  - 下面是具体的操作步骤

### 下载magisk app的安装包

- 现在已经是25以上的版本

- 途径很多
  - [Magisk下载 - Magisk中文网 (magiskcn.com)](https://magiskcn.com/magisk-download)
  - [Magisk安装教程 - Magisk中文网 (magiskcn.com)](https://magiskcn.com/)

#### 注意事项

- 下载完后,及时安装上magisk app,即,在刷入之前就安装好
- 我试过如果在刷入后,才安装会使得root无法被接管
  - 但是可以再次重启尝试修复这个问题

#### 将包放在你能够轻易找到的地方

- 譬如`/sdcard/Download`(其实就是`/storage/emulated/0/Download/`)
  - 一般就是浏览器下载的默认路径啦

### 修改包名(刷入面具时是可选的)

- 实际上,经过我的实践,不需要修改apk后缀为zip,直接就可以用twrp将magisk当做一个刷机包刷入
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/44c3481781f440e18111f05a283dad74.png)

- 但是注意,卸载magisk的时候情况可能就不一样了,需要你改成指定的名称参考下面(我没试过卸载面具)

#### 参考链接:用于第三方recovery卡刷面具

- [Magisk Magisk中文网 (magiskcn.com)](https://magiskcn.com/magisk-download)

- 卡刷包：把名字改成 **magisk.zip**
- 卸载包：把名字改成 **uninstall.zip**

#### 其他方式

- 你可以复制apk的一个副本,然后修改副本的包名为`.zip`后缀

### 重启手机到twrp

- 不同机器的进入方式可能有不同

#### 命令行fastboot法

- 如果你的手机刚好处于命令行fastboot可用的环境,这时候可以尝试以下命令重启到custom recovery(twrp)
  - `fastboot reboot recovery`

- 但是如果平时想要进入twrp,则可以在开机状态下,链接电脑借助命令行adb工具进入
  - `adb reboot recovery `

#### 按键法

- 前面也提到过了,刷入第三方包后,可能进入方式按键组合可能发生改变
  - 但是一般来讲,还是`音量+`配合`电源键`进入recovery
    - 也可能变为`音量+`,`音量-`,`电源键`同时按下进入
- 你可以在开机状态下可以直接尝试按上面提到的的组合键
  - 按到什么时候?
    - 直到重启到twrp第一幕大图标弹出为止
      - (已经可以立刻松手了(如果按压过久,会导致twrp被跳过进入系统引导)
    - 并且松手的片刻,后续可能灭屏再加载几秒)(耗时10s左右吧)
    - 这时候单击一下电源键唤醒屏幕
      - (twrp有锁屏功能,还有调节语言/亮度/振动等功能)
      - 甚至,你在刷入包的时候还可以单机电源键锁屏,来节省电源,想要查看进度的时候再单机电源键即可

### 选择刷机包(magisk)并刷写

- 可以看到,我下载的`magisk.apk`(这里名字是`app-release.apk`,并且我还复制了一份改名为`app-release.zip`)
- 选择刷入`app-release.zip`(根据自己的包名选择)



![在这里插入图片描述](https://img-blog.csdnimg.cn/1efc1707799645ff967c1719c4b13cdb.png)


#### 安装选项

- 签名验证我没有勾选,我保持默认
  - 你也可以根据需要操作

#### 开始刷入

- 滑动开始刷入即可

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/a983748d74c545d8a985cd20c8f657fe.png)


- 会耗时一定时间,除非报错,否则耐性等等,(不会超过2分钟应该)



## 检查效果

- 重启手机
- 打开提前安装好的magisk app
  - 本人是预先安装后才开始刷入的
  - 不出意外,可以使用root授权功能了



# 冷门机型/低端机刷机的刷机心得

> 实际上,入门机型或者冷门的低端机型是不建议用来玩机的,各方面玩机资源的不充足,连个twrp都没有官方适配,而且由于配置低端,有些模块甚至都无法使用

- 某些机器是冷门的,这种情况下,twrp团队管方没有提供twrp包文件给用户
  - 幸运的是,我们可以通过搜索引擎/论坛获取相关的非官方twrp,**我们姑且称呼这类非官方(unofficial) twrp**(`瑕疵twrp`)(或者称之为**high risk twrp**,即`高风险twrp`)
    - 除了twrp,其他第三方recovery(例如`orange fox`也是类似的道理)
  - 不幸的是,非官方的twrp包往往存在问题,例如,刷入兼容性不佳的twrp,可能导致无法使用常规方法进入twrp(recovery)
    - 事实上,即使使用的是twrp官方团队制作的正式发布的official twrp,也有几率会导致设备变砖
      - 特别是不恰当的操作,或者对于android启动和分区机制不了解/电脑端`fastboot`命令行工具(或其他客户端)的不正确使用,导致分区被破坏,都有可能使得手机变砖
      - 譬如,将不正确的recovery包刷入到手机中,或者把准备刷入recovery分区的包给刷到boot或者其他分区
    - 而刷入高风险twrp后,即使能够成功进入twrp功能菜单,也会由于兼容性,导致文件系统无法访问
    - 也可能使得本来可以刷入的rom,在安装解析的时候发生错误而终止

## 高风险twrp的刷入建议

- 尽管冒着变砖的风险,你还是想尝试,那么我提一下可以降低变砖风险的一些建议
  - 找twrp时,尽量找有完整教程的资源贴或者文章(图文并茂的更好)或者有配套视频的就更好了
    - 而且,可以的话,多找一套,配有版本不同(twrp)资源的教程
    - 这样可以在第一套twrp无法进入时又其他机会进入twrp
  - 了解android的基本知识(譬如近几年的android分区)
  - 阅读twrp的主要功能和使用说明
- 另一方面,建议了解手机厂商oem提供的救砖流程
  - 比如救砖工具(客户端,比如小米的MiFlash)
    - 我甚至用oem提供的线刷工具把进不了组合按键进不了fastboot的变砖机(无线重启)给重新卡入fastboot
  - 提前准备好设备制造商oem官方提供的线刷包(符合你的设备型号的线刷包)

### 高风险twrp下可能出现的问题举例

#### 声明

- 编写这篇日志的时候,我对于android高版本得到分区还不是特别了解
  - 比如,自从android7引入的a/b分区以及android11引入的超级分区(super partitoin)
  - 这些可能潜在的会对twrp的刷入方式和使用差生影响

#### Required key not available

- 例如,我尝试使用adb shell从电脑端传输文件到手机端(处于高风险twrp界面)

  - 可与遇到的情况:adb push 在twrp下传输时,需要formatData进行解密

  - ```bash
    ~ # cp Magisk-v25.2.apk /sdcard/
    cp: can't create '/sdcard/Magisk-v25.2.apk': Required key not available
    ```

  - 我的处理办法是,进入wipe->formatData(清除加密和其他系统数据)

    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/40aaf1737e2d435f90849264c6b54c27.png)


  - 然后重新尝试上述的文件传输操作

- 有些高风险twrp,甚至,还会影响到你进入fastboot模式,使得手机变成一块黑砖(亲身经历过)




### twrp & magisk & rom

- 某些版本的twrp提供了丰富的功能模块,可以方便的刷入一些东西,譬如获取root权限
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/81d1180daeb24aab8a224a47f76e0a86.png)

  - 譬如我选择`Install Root`
    - 这个版本twrp提供的root功能会刷入面具
    - 但是不保证刷入一定是正常的(特别是对于高风险twrp)
    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/9bf12dec8203425f87e2bc152c9412b4.png)


### 第三方rom刷入和magisk root推荐做法

- 首先,确保手机中该备份的数据都已经备份(到云盘或者电脑/U盘)

  - 清除手机数据以及存储加密(twrp的wipe->format Data->输入yes->滑动执行清除操作)
  - $\bigstar$😂总之,要确保adb 命令行此时能够顺利传输文件给手机端,并且twrp能够正确识别文件(譬如zip包)
    - 为了确保效果,建议传输的文件名具有规范的名字,而且有文件后缀为好(譬如zip,也通常是zip,毕竟进入twrp经常是要刷入某些包(rom/magisk/...))

- 传输文件到手机

  - 将刷机包(譬如卡刷包)传输到手机
  - 同时将magisk app(25版本以上) 传输到手机

- 开始刷入包

  - ⛔刷入时,不要勾选reboot after done!

  - 后面刷入的东西是按需可选的

    - 等rom刷完以后,回到twrp的刷入菜单,定位到magisk,选择刷入,这样进入系统后,再安装一下magisk app,就可以管理root权限了(如果不能够管理,请重启手机后再看看效果)

    - 如果还需要Gapp(谷歌条件或其他东西,也在此时一并刷入)

### 急救处理/高风险twrp试探可用性

- 其实,twrp也不是非得固化刷入,特别是没有twrp官方支持的情况下

- 处理利用OEM的线刷工具抢救还可以试试一下命令(前提是可以进入fastboot模式)

#### 临时刷入twrp:fastboot boot 命令
- 对于老android设备,可以使用下面格式的命令临时刷入(进入)twrp
	- 区别于`fastboot flash`
- ⛔但是对于较新设备android11+,该方法可能失效!
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/75d0c81c429b4e63a68d36a8b955e856.png)

  - `fastboot boot recovery_file_name.img`
- 其中,recovery.img根据你的twrp文件名称而定
- 这会尝试进入临时刷入的twrp(如果recovery不正常,可能会尝试重启系统)
  - 但是不同设备情况有可能不同的反应,特别是已经变砖的机器
  - 而且可能还需要同时按下`音量下`联合`电源键`把recovery卡出来
    - 说到这里已经有点玄乎了,但是我的一台老设备刷了高风险twrp后感觉真的玄乎


# android相关知识的补充

## android设备的系统启动过程

- [How Android Boots Up. The first program that runs on any… | by Stanislaw Baranski | ProAndroidDev](https://proandroiddev.com/how-android-boot-up-9864376d911c)

### vab分区特性

- [Virtual A/B Overview  | Android Open Source Project](https://source.android.com/docs/core/ota/virtual_ab)

  - Background and terminology
    - [Device-mapper](https://source.android.com/docs/core/ota/virtual_ab#device-mapper)(简称dm)
    - [dm-snapshot](https://source.android.com/docs/core/ota/virtual_ab#dm-snapshot-overview)
    - [Compressed snapshots](https://source.android.com/docs/core/ota/virtual_ab#compressed-snapshots)
  - Virtual A/B compression processes
    - [Reading metadata (Android 12)](https://source.android.com/docs/core/ota/virtual_ab#reading-metadata)
    - [Merging (Android 12)](https://source.android.com/docs/core/ota/virtual_ab#merging)
    - [Device-mapper layering](https://source.android.com/docs/core/ota/virtual_ab#device-mapper-layering)
    - [Init transitions](https://source.android.com/docs/core/ota/virtual_ab#init-transitions)
  - [Space usage](https://source.android.com/docs/core/ota/virtual_ab#space-usage)

  

### 分区知识:a/b分区的设备是否更难刷机?

- 下文提到,原来怎么刷,现在还是怎么刷
  - 但是实际上并不是,按照老安卓的刷写方式,会失败(分区不存在)
  - [GUIDE Flash ROMs/Magisk/TWRP/Kernels on A/B Partition Devices (droidwin.com)](https://www.droidwin.com/flash-roms-magisk-twrp-kernels-a-b-partition-devices/)


### android 文件系统的常用目录&/sdcard目录

- 现在android设备基本取消了内存卡插槽,至于android里的`sdcard`目录是android系统的一个用于存放文件的目录

- `/storage/emulated/0/`目录是android自带文件管理器可以查看到的顶级目录

  - [What is Android storage/emulated/0? (The Complete Guide) (convergeddevices.net)](https://convergeddevices.net/what-is-android-storage-emulated-0/)

- 而使用特别开发的app(并且授予其权限)可以访问到根目录`/`

  - 感兴趣的话可以下载`MT管理器app`进行目录观察

    - [MT管理器(bin.mt.plus) - 2.11.3 - 应用 - 酷安 (coolapk.com)](https://www.coolapk.com/apk/bin.mt.plus)

  - 根目录下的常用目录包括

    - `/storage`
      - 该目录下的`/storage/emulated/0/`正是一般情况下我们能够看到的最顶级的目录了
    - `/sdcard/`

  - 以及一些linux/unix系统上常见的目录

    - `/bin`

    - `/sys`

    - `/system`

    - `/mnt`

    - ...

      

## fastboot常用命令和用途

- [How to Use ADB and Fastboot on Android (And Why You Should) (makeuseof.com)](https://www.makeuseof.com/tag/use-adb-fastboot-android/)

## fastboot 命令行工具的功能分类usage: fastboot [OPTION...] COMMAND...

- [fastboot | Android Debug Bridge (ADB) Commands Manual (adbcommand.com)](http://adbcommand.com/fastboot#boot-image)

### flashing:

```
 update ZIP                 Flash all partitions from an update.zip package.
 flashall                   Flash all partitions from $ANDROID_PRODUCT_OUT.
                            On A/B devices, flashed slot is set as active.
                            Secondary images may be flashed to inactive slot.
 flash PARTITION [FILENAME] Flash given partition, using the image from
                            $ANDROID_PRODUCT_OUT if no filename is given.
```



#### basics:

 devices [-l]               List devices in bootloader (-l: with device paths).
 getvar NAME                Display given bootloader variable.
 reboot [bootloader]        Reboot device.

#### locking/unlocking:

 flashing lock|unlock       Lock/unlock partitions for flashing
 flashing lock_critical|unlock_critical
                            Lock/unlock 'critical' bootloader partitions.
 flashing get_unlock_ability
                            Check whether unlocking is allowed (1) or not(0).

#### advanced:

```bash
 erase PARTITION            Erase a flash partition.
 format[:FS_TYPE[:SIZE]] PARTITION
                            Format a flash partition.
 set_active SLOT            Set the active slot.
 oem [COMMAND...]           Execute OEM-specific command.
 gsi wipe|disable           Wipe or disable a GSI installation (fastbootd only).
 wipe-super [SUPER_EMPTY]   Wipe the super partition. This will reset it to
                            contain an empty set of default dynamic partitions.
 create-logical-partition NAME SIZE
                            Create a logical partition with the given name and
                            size, in the super partition.
 delete-logical-partition NAME
                            Delete a logical partition with the given name.
 resize-logical-partition NAME SIZE
                            Change the size of the named logical partition.
 snapshot-update cancel     On devices that support snapshot-based updates, cancel
                            an in-progress update. This may make the device
                            unbootable until it is reflashed.
 snapshot-update merge      On devices that support snapshot-based updates, finish
                            an in-progress update if it is in the "merging"
                            phase.
 fetch PARTITION OUT_FILE   Fetch a partition image from the device.
```



#### boot image:

 boot KERNEL [RAMDISK [SECOND]]
                            Download and boot kernel from RAM.(临时的刷入)

 flash:raw PARTITION KERNEL [RAMDISK [SECOND]]
                            Create boot image and flash it.
 --dtb DTB                  Specify path to DTB for boot image header version 2.
 --cmdline CMDLINE          Override kernel command line.
 --base ADDRESS             Set kernel base address (default: 0x10000000).
 --kernel-offset            Set kernel offset (default: 0x00008000).
 --ramdisk-offset           Set ramdisk offset (default: 0x01000000).
 --tags-offset              Set tags offset (default: 0x00000100).
 --dtb-offset               Set dtb offset (default: 0x01100000).
 --page-size BYTES          Set flash page size (default: 2048).
 --header-version VERSION   Set boot image header version.
 --os-version MAJOR[.MINOR[.PATCH]]
                            Set boot image OS version (default: 0.0.0).
 --os-patch-level YYYY-MM-DD
                            Set boot image OS security patch level.

#### Android Things:

 stage IN_FILE              Sends given file to stage for the next command.
 get_staged OUT_FILE        Writes data staged by the last command to a file.

#### options:

 -w                         Wipe userdata.
 -s SERIAL                  Specify a USB device.
 -s tcp|udp:HOST[:PORT]     Specify a network device.
 -S SIZE[K|M|G]             Break into sparse files no larger than SIZE.
 --force                    Force a flash operation that may be unsafe.
 --slot SLOT                Use SLOT; 'all' for both slots, 'other' for
                            non-current slot (default: current active slot).
 --set-active[=SLOT]        Sets the active slot before rebooting.
 --skip-secondary           Don't flash secondary slots in flashall/update.
 --skip-reboot              Don't reboot device after flashing.
 --disable-verity           Sets disable-verity when flashing vbmeta.
 --disable-verification     Sets disable-verification when flashing vbmeta.
 --fs-options=OPTION[,OPTION]
                            Enable filesystem features. OPTION supports casefold, projid, compress
 --unbuffered               Don't buffer input or output.
 --verbose, -v              Verbose output.
 --version                  Display version.
 --help, -h                 Show this message.
