@[toc]



# 刷入twrp_twrp刷入面具&进入recovery(twrp)的方式&获取root&刷入第三方rom&下载魔趣(MOKEErom&Paranoid Android )刷入体验&国际版rom包的网络连接受限问题

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

### 第三方rom获取/推荐



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

#### 其他来源

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

#### 例如

- [Paranoid Android Quartz 5 - Xiaomi Redmi 4X (Santoni) | XDA Forums (xda-developers.com)](https://forum.xda-developers.com/t/paranoid-android-quartz-5-xiaomi-redmi-4x-santoni.4119495/)

## 国际版rom包的网络连接受限问题

- 由于基于较新版本的android制作的包经常是老外做的,那么时区问题就会显现出来,例如在android12的类原生包,提示我连接wifi后连接受限(limited connection)
- 尝试设置时区和系统时间,最好和北京时间一致(相差个别小时也是没问题的,虽然可能还是提示受限,但是浏览器之类的应用应该能够正常访问互联网了)



## twrp的作用$\bigstar$

- twrp`功能全面`,可以用来
  - 刷入面具(magisk)以获取root
  - 关于卡刷第三方包(非官方rom的刷入经常使用流行的twrp来操作)
    - 刷第三方包用卡刷方式的较多感觉,线刷一般用来
      - 获取root,刷入twrp,当然还可以刷入官方rom实现降级以及救砖(白砖)
      - 之后的事情可以交给twrp
      - 或者用magisk app就可以安装模块
  - twrp中advance还提供linux终端,你可以执行一些命令(譬如创建文件夹)
    - 应该是自带root权限的
- twrp方式(或者更准确的讲,是recovery的共同问题)
  - 需要有人来适配你的机型
  - 刷入twrp往往需要fastboot,如果是这样,那么你大概率要会线刷(譬如刷入修补后的boot.img)的基础
- 对于线刷方式玩机(root/模块)可以看看
  - [android 手机获取root权限_获取刷入模块_MIUI_android7~android12实践/A1内存管理和钢铁后台效果测评/root省电调度&性能调度_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/126015726?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"126015726"%2C"source"%3A"xuchaoxin1375"}&ctrtid=A1OZh)

## 获取twrp

- [TeamWin - TWRP](https://twrp.me/)
- 例如redmi 4x的教程
  - 借助google搜索想要的机型(例如:`redmi 4x twrp`或者`twrp for <your device type name>`)
  - [Xiaomi Redmi 4X (twrp.me)](https://twrp.me/xiaomi/xiaomiredmi4x.html)

- 其他来源
  - 酷安论坛!

### 🎈🎈twrp 和android内核版本间要求

- 有的twrp有明确的内核要求
  - 比如说,当前android系统的内核是5.10.66
  - 现在某个twrp仅支持特定版本的内核(比如不超过5.10)
  - 如果无视这一点,可能导致系统无法引导(反复重启到twrp)
    - 这种情况下,基本只能靠(fastboot)线刷来修复
    - 例如miui用miflash

## 关于刷机包

- 刷机包可以是
  - 第三方rom
  - 或者类似于模块的包,例如
    - 用户获取root的magisk app,将安装包的名称后缀从`.apk`修改为`zip`,就是一种所谓的`刷机包`
      - 很神奇是不是!(其实刷入magisk的时候不需要修改包名,但是为了保险起见,修改一下)
      - 估计是magisk apk和twrp达成某种协议,使得magisk可以刷入修改后缀名的`magisk`安装包
- 但是注意,刷入第三方rom的时候需要清除数据
- 而刷入magisk的时候,不需要

## 刷入twrp

- 刷入twrp的方式有多种
  - 最通用的当属fastboot线刷方式,这不要求你有root权限,也比较推荐
  - 其他方式有不需要电脑的,但是前提是手机已经root,这可能导致的囧境是,我还没有root,去需要用到root!
    - 但是这种方式也有用处,比如,我确实已经通过某种途径(未必是刷入面具的方式),而仅仅只是想要刷入twrp这种流行的第三方的recovery维护系统

### 线刷方式

- 确保设备已经解除bl锁,usb调试打开并且允许电脑调试android设备
- 命令行检查驱动(可选的,如果遇到异常,再检查)
  - 如果处于开机状态,执行`adb devices -l`
    - 开机状态下,如果设备正常驱动,也可以通过`adb reboot bootloader`直接重启到fastboot模式
  - 如果处于关机状态,通过组合键(通常是(`音量-` 结合 `电源键`) ,进入到fastboot模式fastboot devices`检查设备是否正常链接
- 正常连接到电脑后,利用google提供的命令行工具(fastboot.exe)进行刷写`twrp文件`(img)到recovery 分区中
  - ` fastboot flash recovery .\twrp-3.6.2_9-0-santoni.img`

### 进入recovery模式的通法

- 除了尝试音量键和电源键,我更推荐在开机状态下执行adb命令
  - `adb reboot recovery`的方式进入到recovery
    - 如果你刷入的是第三方recovery,那么就会进入到第三方recovery(譬如twrp)
  - 好处是不要把握按按键组合和按压时间

#### 按键法进入recovery注意事项

- 如果您已经通过某种方式刷入第三方rom系统包,而想要进入recovery,进入方式可能发生改变
  - 例如,我的情况
    - 设备:redmi 4x(已经解除bl锁)
    - 通过fastboot刷入第三方recovery(用的是twrp)
    - 下载的第三方rom系统包,借助刚刚刷好的twrp(recovery)卡刷刷入rom包
    - 系统能够正常进入,但是进入recovery的方式发生改变
      - 原本是`音量+`配合`电源键`进入recovery
      - 现在经过一番尝试,变为`音量+`,`音量-`,`电源键`同时按下进入

### 刷机包是纯正的卡刷包吗

- 不同的第三方ROM刷入方式可能存在差异
  - 例如`lineageOS`提供的包的刷入方式和`魔趣`的包是有差异的
  - 前者似乎是使用依赖于
    - `adb sideload `方式刷入
    - 有点线刷的味道
- 魔趣的包目前刷入风格是可以直接通过twrp就可以愉快的刷入

### 各种清除数据的操作&N清

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





- If you are switching ROMs (changing from one ROM to a completely different one) then you should perform a factory reset.
  -  A factory reset wipes data and cache (which includes dalvik cache). 
  -  A factory reset will also wipe sd-ext and android_secure if your device has those items. 99% of the time, this is all that you need to wipe and you only need to do it once, not three times as some people would lead you to believe.
- If you're installing a nightly update, then oftentimes you don't need to wipe anything at all. However, if you encounter strange behavior, then you may want to consider performing a factory reset. Of course, if the ROM maker recommends that you do a factory reset during an update, then it's a good idea to follow their recommendation.
- The vast majority of ROMs wipe system as part of the zip install. This means that in most cases you do not need to wipe system... ever.
- At this point, cache (not dalvik cache) is primarily used for recovery. It's used to store the recovery log and for storing OTA (Over The Air) updates. You probably don't need to wipe cache, and cache is already wiped as part of a factory reset.
- In most ROMs, dalvik cache is stored in the data partition, so if you do a factory reset, you've also wiped dalvik cache. In a few custom ROMs, especially on older devices with small data partitions, the ROM maker may have moved dalvik to the cache partition to provide you with more room for apps. Since we wipe cache with a factory reset, again, you probably don't need to wipe dalvik. There are a few situations where you may need to wipe dalvik cache when installing updates, but you will know that it's needed when you are greeted with force closes when trying to open some apps.
- Depending on your device and its configuration, you may have options for wiping internal storage, external storage, sd-ext, android_secure, and/or an option for formatting data. There's almost no reason that you would ever need to use these items. These options are there for convenience. For instance, if you're getting ready to sell your device, then it's a good idea to wipe everything on the device so that the new owner doesn't get your private data. Note that these wipe options may not be completely destructive. If you store especially sensitive information on your device or are really concerned about your private data, then you may need to look into other options to ensure that your data is fully destroyed.

## 用twrp刷入第三方rom(魔趣提供的rom为例)(twrp玩法1)

### 注意事项

- 下载合适的刷机包
- 不合适的刷机包导致
  - 无法正常刷入
  - 刷入但无法开机
  - 我用的例子是从`魔趣那里下载的`
    - 一般老机器刷入以后,有可能就焕发第二春啦
      - 有机会体验类原生
      - 体验较高版本的android(OEM可能停止维护,就可以通过这种方式尝鲜)
      - 拒绝臃肿,体验到精简系统

### 查看rom提供者的刷入教程

- 不同rom提供来源会配备独家的刷入流程
- 甚至于,不同版本的android,同一网站提供的不同rom包刷入教程也可能不同
- 例如这是魔趣提供的刷入流程(参考)
  - [快速上手 | 魔趣 ROM (mokeedev.com)](https://www.mokeedev.com/guide/getting_started.html#通过-fastboot-安装-recovery)
    - 这里的清除数据不会删除`/sdcard/Download`这类目录文件

### 关于魔趣

- **魔趣开源项目**，前身为**魔趣OS**，是基于CAF二次开发的一个[Android](https://zh.m.wikipedia.org/wiki/Android)分支版本，是完全[开源](https://zh.m.wikipedia.org/wiki/开源)的[Android](https://zh.m.wikipedia.org/wiki/Android)第三方操作系统
  - 魔趣的所有功能完全遵循[Material Design](https://zh.m.wikipedia.org/wiki/Material_Design)[[1\]](https://zh.m.wikipedia.org/zh-hans/魔趣#cite_note-introduce-1)，是一款类原生[Android](https://zh.m.wikipedia.org/wiki/Android)操作系统

#### 下载魔趣

- 为了赚点维护费,魔趣下载页面有广告,这可能影响到下载的定位
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/f936360781f34b96be8c60fc203fc13f.png)

  - 右上角可以选择版本的稳定性为过滤条件
    - ![image-20220729084101220](https://img-blog.csdnimg.cn/img_convert/becedf9d725b1a7c052a0886ad7d0198.png)
  - 注意到,您可以选择android版本
    - 譬如上面显示的基于android11的rom
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/740c83eeefac4f0dbf94c774f901e58f.png)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/3d642cad3c934c13acdafffef27bb443.png)


## 用twrp刷入面具获取root(twrp玩法2)

- 基于twrp可以方便的刷入magisk获取root

  - 但是不是唯一的方式,还可能通过修补boot.img线刷的方式,这种方式是获取root的更加通用的方式,这里不展开,另外查资料

  - [如何获取MIUI最新系统包 - Magisk中文网 (magiskcn.com)](https://magiskcn.com/get-miui)

    

- 和输入rom的操作类似

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

#### 将包放在你能够轻易找到的地方

- 譬如`\sdcard\Download`
  - 一般就是浏览器下载的默认路径啦

### 修改包名(可选操作)

- 重命名/修改magisk安装包名的操作:在刷入面具时是可选的

- 实际上,经过我的实践,不需要修改apk后缀为zip,直接就可以用twrp将magisk当做一个刷机包刷入
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/44c3481781f440e18111f05a283dad74.png)


### 卸载面具



- 但是注意,卸载magisk的时候情况可就不一样了
  - 可以预先在下载好面具后直接用系统的文件管理器复制/重命名一份名为`uninstall.zip`的备份
    - 这个备份只能用于删除(卸载magisk,而不是安装)
    - 意思是,twrp安装这个`uninstall.zip`,时间操作会被识别为移除面具!
  - 你可以在twrp中,利用文件管理器进行重命名操作也是可以的
- 需要你改成指定的名称参考下面(我没试过卸载面具)

#### 参考链接:如何修改面具名:用于第三方recovery卡刷面具

- [Magisk Magisk中文网 (magiskcn.com)](https://magiskcn.com/magisk-download)

- 卡刷包：把名字改成 **magisk.zip**
- 卸载包：把名字改成 **uninstall.zip**

#### 其他方式

- 你可以复制apk的一个副本,然后修改副本的包名为`.zip`后缀

### 重启手机到twrp

- 不同机器有不同
- 前面也提到过了,输入第三方包后,可能进入方式按键组合可能发生改变
  - 原本是`音量+`配合`电源键`进入recovery
  - 现在经过一番尝试,变为`音量+`,`音量-`,`电源键`同时按下进入
  - 开机状态下可以直接尝试按
    - 按到什么时候?
      - 直到重启到twrp第一幕大图标弹出为止
      - (已经可以立刻松手了(如果按压过久,会导致twrp被跳过进入系统引导)
      - 并且松手的片刻,后续可能灭屏再加载几秒)(耗时10s左右吧)
      - 这时候单击一下电源键唤醒屏幕
        - (twrp有锁屏功能,还有调节语言/亮度/振动等功能)
        - 甚至,你在刷入包的时候还可以单机电源键锁屏,来节省电源,想要查看进度的时候再单机电源键即可

#### 选择刷机包

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
