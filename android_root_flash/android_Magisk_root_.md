[toc]

# 预备环节

##  基础参考内容

- [Magisk安装教程 - Magisk中文网 (magiskcn.com)](https://magiskcn.com/)

- android12: [ How to Root Xiaomi Redmi Note 11T Pro / 11T Pro+ using Magisk without TWRP (getdroidtips.com)](https://www.getdroidtips.com/root-xiaomi-redmi-note-11t-pro-plus/)

### 视频教程$\bigstar$

- [玩机必看！带你入坑安卓刷机，小白也能看懂的ROOT基础指南来啦！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1BY4y1H7Mc?spm_id_from=333.880.my_history.page.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

## 基础知识准备

- 将前面列出的参考都看一遍
- 最好把文章结尾的基础知识以看看
  - 特别是`@晨钟(极客湾)`的视频,相对全面,可以看他个两三遍(一遍估计不太好消化),当然如果不搞游戏什么的进阶后面的部分可以略过

### 推荐具有的技能(optional)

- 遇到问题时,会使用搜索引擎/论坛寻求帮助查找问题
  - 会google更好,会使用搜索语法就更好
  - 能完整版酷安搜贴也不错(或xda)
  - 会点英文更好

## 工具/材料准备

###  硬件和软件

- 已经解锁的android手机(譬如小米/redmi手机)
  - [解锁小米手机 - Magisk中文网 (magiskcn.com)](https://magiskcn.com/unlock-mi)
  - 同时,在开发者选项中开启usb调试
    - 但是不排除例外,请自行搜索驱动打上
    - 极端情况下(对于使用过软连接修改过`%userprofile%\.android`的android开发者,下面这篇文章或许有用)
      - [android_adb调试链接方案/链接失败的若干问题](https://blog.csdn.net/xuchaoxin1375/article/details/125862525?spm=1001.2014.3001.5501)
- 数据线(usb cabl)
- pc(windows10/11)
  - windows terminal+powershell(或者cmd) 组合
- 命令行工具下载(adb/fastboot(platform-tools工具箱))
  - [SDK Platform Tools 版本说明  | Android 开发者  | Android Developers (google.cn)](https://developer.android.google.cn/studio/releases/platform-tools?hl=zh-cn)

- 下载magisk app

  - [Releases · topjohnwu/Magisk (github.com)](https://github.com/topjohnwu/Magisk/releases)

- boot.img和magisk_patched文件会在后续操作中产生

### magisk app注意事项/刷入面具

- 下载完后,及时安装上magisk app,即,在刷入之前就安装好
  - 这个步骤主要是针对修补文件是来自其他人提供的情况下
  - 如果是自己修补的,那么一般不会有问题(自己修补,magisk app是肯定是已经安装好了才有的修补(不用第二台手机参与的情况下)
- 我试过如果在刷入后,才安装magisk app可能会使得root无法被magisk app接管
  - 但如果,你是线刷入修补文件而后才安装magisk app,那么请**重启一下**,看看magisk app能否接管root(但不一定有效,这时候考虑再刷以便面具)
  - 重启对于twrp刷入magisk的方式有效(试验过)

####  关于刷进入magisk面具方式

- *刷入面具* 这个说法不完全准确
- 对于线刷的方式而言,称呼为刷入`修补后的boot.img`(即`magisk_patched`文件)
- 但是对于卡刷刷入面具,这种叫法没有问题
  -  卡刷依赖于第三方recovery(比如流行的twrp)
  -  这依赖于相关人员的适配
  -  可以参考卡刷玩法:[刷入twrp_twrp刷入面具&进入recovery(twrp)的方式&获取root&刷入第三方rom&下载魔趣(MOKEErom&Paranoid Android )刷入体验_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/126049254)




## 玩机root注意事项

- 玩机有风险

  - 硬件损坏风险
  - 数据/信息泄漏风险

- 建议用旧手机(备用机)试着操作一遍,总体简单

- android7之后的都可以(root过程差不多),提高主设备刷写的成功率(当然,如果只是体验一下,主设备就不用root了)

  

## 工作窗口预览(optional)

![在这里插入图片描述](https://img-blog.csdnimg.cn/ca47d80ec6804a828a23cc8351c09634.png)
#  GUI工具箱辅助操作
- 玩机辅助工具箱有好几种,这里只是提一下,能够完成一些刷机功能,更加友好

- [搞机助手-官网 (lsdy.top)](https://lsdy.top/gjzs)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/01285243eb2b4740bf3c4ef91c78896c.png)

# 交互式脚本进行root

- 有的酷安玩机达人编写了root脚本,脚本会提示你一步步操作下去,可以降低门槛
  - [简单自用root教程 来自 不会梦游的鱼 - 酷安 (coolapk.com)](https://www.coolapk.com/feed/38586705?shareKey=Zjc3YjgxMDI3YWU5NjMwNmViNWY~&shareUid=5097617&shareFrom=com.coolapk.market_12.4.2)
  - [全机型一键修补root.zip - 蓝奏云 (lanzouj.com)](https://zeville.lanzouj.com/iQswm09xe7uj)

# 核心步骤(正式)

##  操作声明

-  主要内容为:获取boot.img并修补为magisk_patched文件
-  为了使文章主体部分简洁,将一些细节放置到了文末(按自己需要,查看目录跳转)

## 设置工作路径(语境约定!🤗⛔推荐小白使用)

- **<u>默认路径</u>**(我们也叫`默认工作目录`):如果你对命令行工具的使用比较陌生,那么推荐你选定一个工作路径,我们可以将其称之为`默认路径`,之后的所有的操作到集中到该目录下!
- 将前面提到的命令行工具下载下来(下载后建议拖道到桌面,并解压该压缩包,得到一个`platform-tools`文件夹)

- 如果你不设置`环境变量`(文章末尾会提供),那么采用下面的方案中的一种即可

### 方式1:在platform-tools文件夹下打开cmd

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/de1df9f3516a4f53aea2096f54674b51.png)

- 这种方式和简单(推荐)
  - 首先打开解压后的platform-tools.zip文件夹
  - 在资源管理器的地址栏中输入`cmd`
  - 弹出一个命令行窗口(最小化,备用)
- 此时的默认工作目录就是这个被打开的文件夹
  - 后续的操作需要把修补的文件也放入到这个目录中!
  - 下面的方式2也还行,选择一种即可

### 方式2:基于桌面下的文件夹设置默认路径(目录/文件夹)



- 我们最熟悉,最明显的路径就是桌面了
  - 这有利于我们可视化操作文件!

- 打开cmd
  - 打开开始菜单搜索`cmd`
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/985a01440e434615ae09833d669bb77b.png)

  - 或者键盘同时按下`windows徽标`联合字母键`r`启动窗口
    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/671fc7f612b249ffa7e57c24e28f6972.png)

    - 输入cmd 回车即可打开cmd窗口
      - 一般来说,会是一个黑黑的窗口
- 命令行跳转到桌面做准备:
  - `cd %userprofile%/desktop/`
    - 复制上述命令行,并粘贴到cmd窗口中



- 正式设定默认`工作目录`🤗🤗🤗🤗

  - 工作目录就设定在`platform-tools`文件夹下
    - 将这个文件夹放在桌面上,将下面的命令行粘贴到cmd窗口回车执行

  - `cd %userprofile%/desktop/platform-tools`

## 获取boot.img(可选的步骤)

- 未修补的初始boot.img的**获取方式多种**

  - 可以自己下载rom然后(转化)提取
   - ![在这里插入图片描述](https://img-blog.csdnimg.cn/1e210f449fbe45c08ef25c871bc05bd3.png)

  - 也可以直接到网上找找别人提取好的boot.img文件(譬如酷安论坛中找找帖子)

  - 可选操作:把`boot.img`文件拖入到默认工作目录`platform-tools`中

## 获取magisk_patched文件

###  注意事项

- 将之前获取的boot.img进行修补,即可对到`magisk_patched`文件

- 获取`boot.img`可以是别人分享的(酷安找帖子),也可以是自己提取

- 但是,**<u>修补boot.img建议自己修补</u>**,即,使用自己安装的magisk app自行修补
  - 这样可以保证magisk app(客户端)和修补出来的magisk_patched文件具有一致性和兼容性,不容易出现异常
  - 异常情况包括但不限于
    - 无法开机
    - 开机了,但是magisk app无法管理root权限

- 上述方式是推荐的方式,不过你还是可以试试用别人修补过的`magisk_patched`文件
  - 但不建议,会增加风险(本人失败过(❁´◡`❁),幸好找到了一份未修补的boot.img,成功重刷恢复过来)


###  传输boot.img到手机(optional)

- 如果只是用手机就下载/提取到了boot.img那么这一步骤就可以跳过
- 如果是通过电脑获取的boot.img文件,那么将`boot.img` 通过任意一种你喜欢或你会的方式**传输到手机**

  - 可以用qq/微信发送
- 下载软件工具和修补过的.img文件都已经放置到合适的位置了,下面准备刷写

### 修补过程的操作细节(包括不同android版本)

#### 早期版本的android修补boot.img

注意,对于`较早版本的android`(譬如下面的情况是我的android7老设备(已经有了AB分区的概念了)
(第二幕中,会使用android12设备root的实践报告)

---

修补前需要选择选项:

- 保留AVbobo2.0
- 保持强制加密(默认勾选)
- 修补boot镜像中的vbmeta
- ![image-20220727002112541](https://img-blog.csdnimg.cn/img_convert/dbe6c39ce4ef273b4a15c27e24c1a8bb.png)
- 点击下一步
- 选择`boot.img`文件
- 选择完毕会回到面具,点击开始修补(`let's go`)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/1bd2a656093c48f38dbd15d590f3f7f9.png)


#### 较高版本的android修补boot.img

- 对于android12设备,应该没有这么多选项(反而简洁),直接默认,在方式(methed)选择boot.img文件直接进行修补
- 简而言之,如果有`选项`这一栏,实际保持默认即可
  - (这会保持加密,否则系统可能无法引导,
  - 不过救砖不难,只需要刷入未修补的boot.img即可恢复)
- 选择下一步,选择我们前面准备好的boot.img,文件进行修补(选择完文件后`点击开始`)

- 输出过程和低版本android类似,等待`all done!`提示

#### 修补操作小结

- 利用<u>已经安装的magisk 手机端app进行修补boot.img文件</u>
  - 这将得到一个修补过的boot.img(实际名字类似于`magisk_patched-some-id-token.img`)
  - 例如我的这次操作:得到修补后的文件`magisk_patched-25200_LFBPs.img`

## 将修补好的magisk_patched文件传输到电脑(required!)



### 修补后的文件放置在哪里/如何传输文件

- 首先注意,手机端,magisk app修补出来的文件会被magisk app放置到手机的`/sdcard/Download/`目录下

  - 对应到模拟路径也就是,`/storage/emulated/0/Download/magisk_patchedxxxx.img`
  - 具体以magisk app修补完给出的提示为准(见上一目的截图:`output file is written to...`)

- adb方式传输文件

  - ```bash
    PS D:\usersByCxxu\DownloadsAll> adb pull /storage/emulated/0/Download/magisk_patched-25200_VBQAh.img
    /storage/emulated/0/Download/magisk_patched-25200..., 0 skipped. 20.6 MB/s (29777192 bytes in 1.379s)
    ```

    

- 也可以使用qq/微信传输文件(友好方式)

- 或者其他方式

  - 感觉windows资源管理器不太靠谱

### 文件传输到那个文件夹

- 有多种方式传输文件到pc端,电脑路径可以是你熟悉的任何路径(譬如桌面)
  - 可选操作:将修补好的magisk_patched文件拖入到先前约定的默认工作目录`platform-tools`文件夹中




## fastboot刷入修补好的magisk_patched文件

> - 前面说到,adb是个好用的工具,但对于本教程并不是必须的
> - fastboot是本教程必须的

### 进入fastboot(bootloader)模式

- 按住`电源键`+`音量键下`(不同机型可能有不同组合键)
  - 在开机状态下可能可以直接进入到fastboot
  - 如果这不生效,可以关机后再按住上述组合键
- 或者在开机状态下,允许计算机usb调试手机,使用命令行工具adb执行`adb reboot bootloader`
- 某些recovery提供了重启到bootloader模式,也可以从recovery处重启进入

#### 验证fastboot是否联通(可用)

- 至此,电脑可以通过fastboot对手机执行相关操作
  - 使用命令`fastboot devices`进行查询设备连通性
  - 如果成功,会返回一串设备号和编码

#### 刷入命令格式

- ` fastboot flash boot .\magisk_patched-25xxx.img` 

  - 注意,上述命令在以下环境条件才可以
    - 上述命令的`magisk_patchedxxx`文件要修改为自己修补好的文件名
    - cmd进入到默认工作目录`platform-tools`文件夹中再执行
      - 这是为了简化命令行(fastboot.exe和magisk_patchedxxx.img文件都在同一个目录下)

- 可选方式:用**绝对路径**也可以,这样就可以在任何目录下执行相应命令

  - 例如:`C:\Users\userName\Desktop\platform-tools\fastboot.exe --help`

    - `C:\Users\userName\Desktop\platform-tools\fastboot.exe flash boot C:\Users\userName\Desktop\platform-tools\magisk_patched-25200_VBQAh.img `
    - 这样就无视任何环境,但是命令行变得很长

  - ```
    PS C:\Users\cxxu> C:\Users\cxxu\Desktop\platform-tools\fastboot.exe --help
    
    usage: fastboot [OPTION...] COMMAND...
    
    flashing:
     update ZIP                 Flash all partitions from an update.zip package.
     flashall                   Flash all partitions from $ANDROID_PRODUCT_OUT.
                                On A/B devices, flashed slot is set as active.
    ```

    

  - 总之,如果没有相应配置,甚至没有默认工作目录的语句,请用绝对路径来帮助系统找到命令行工具`fastboot`和`magisk_patched`文件路径

- 命令解释:

  - 根据自己的情况,选择是否先进入到修补文件(`magisk_patchedxxx`)所在目录
    - 不进入的话,可以用绝对路径表示`magisk_patche`文件
    - 文件名根据自己的情况(`magisk_patchedxxx`)输入,如果是用`powershell`,可以tab键自动补全文件名
  - 回车,开始刷写

#### 开始刷写&结果

- 刷写

```bash
PS D:\usersByCxxu\DownloadsAll> fastboot flash boot .\magisk_patched-25200_VBQAh.img
Sending 'boot' (29079 KB)                          OKAY [  0.936s]
Writing 'boot'                                     OKAY [  0.818s]
Finished. Total time: 2.015s
```

#### 上面的命令做了什么&原理(optional)

- 查看帮助文档

  - ```bash
    PS D:\usersByCxxu\DownloadsAll> fastboot -h
    usage: fastboot [OPTION...] COMMAND...
    
    flashing:
     update ZIP                 Flash all partitions from an update.zip package.
     flashall                   Flash all partitions from $ANDROID_PRODUCT_OUT.
                                On A/B devices, flashed slot is set as active.
                                Secondary images may be flashed to inactive slot.
     flash PARTITION [FILENAME] Flash given partition, using the image from
                                $ANDROID_PRODUCT_OUT if no filename is given.
    
    basics:
     devices [-l]               List devices in bootloader (-l: with device paths).
     getvar NAME                Display given bootloader variable.
     reboot [bootloader]        Reboot device.
    
    ```

  - 可以看到,` flash PARTITION [FILENAME] .`(Flash given partition, using the image from $ANDROID_PRODUCT_OUT if no filename is given)

  - 而我们的命令`fastboot flash boot magisk_patchedxx.img`就是让`fastboot`这个程序执行子命令`flash`,flash 会把指定的文件刷入到指定分区`partition`(这里也就是`boot`分区);从而实现对boot分区的修改



### 重启手机查看效果

- 打开magisk app

- ![image-20220727114346605](https://img-blog.csdnimg.cn/img_convert/d533e97818cb95e8472cf78b7beccfa6.png)

- 顺利的话,则成功获取




##  android12注意事项:刷入magisk获取&管理root权限

- 注意较高版本的android7+之后引入的a/b分区,如果上述刷入无效
  - 即`fastboot flash boot magisk_patch-xxx.img`不生效(或异常)
  - 那么尝试显式指定boot为`boot_a`&`boot_b`分别执行并刷写之
  - 然后使用`fastboot reboot`重启手机

![image-20220727105229883](https://img-blog.csdnimg.cn/img_convert/a97f80b8942f252632fcd2f3d69b901d.png)

## 预期结果

- 如果上述步骤都顺利的话,并且能够重启成功,那么magisk app应该能够获取到root权限并进行管理

# root 之后的玩机部分

- 参考 [android_root后的玩机:magisk模块&root隐藏_scene5 xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/126071341?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"126071341"%2C"source"%3A"xuchaoxin1375"}&ctrtid=8i2pw)

# 更多参考内容

##  线刷&卡刷(第三方recovery)

- 关于卡刷第三方包(经常使用流行的twrp来操作)
- twrp虽然不是本主题(root)的重点,但是可以参考一下思路和操作
 - [TeamWin - TWRP](https://twrp.me/)
- 例如redmi 4x的教程
  - 借助google搜索想要的机型(例如:`redmi 4x twrp`)
  - [Xiaomi Redmi 4X (twrp.me)](https://twrp.me/xiaomi/xiaomiredmi4x.html)


## android推荐工具(optional)(文件管理客户端)

- 这不是必须的
- 如果喜欢,可以到完整版酷安app下载该app(`MT管理器`)
  - [MT管理器(bin.mt.plus) - 2.11.3 - 应用 - 酷安 (coolapk.com)](https://www.coolapk.com/apk/bin.mt.plus)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/1977e721f9c1440bb6b5a23863213d43.jpeg)
  - 该文件管理器分为两部分视图,左侧是一般系统自带文件管理器可以看到的一样
  - 右侧则是由从根目录`/`开始展示的(是真正的文件系统)

# 驱动/命令行工具:adb&fastboot的使用和注意事项

## RSA秘钥指纹

- 驱动现在一般不是问题,win10/11自带对android的驱动

- 但是注意,除了驱动问题可能导致命令行工具链接不上手机
  - 特别是,如果没有经过下面的授权,在关机状态下的fastboot模式可能无法使用fastboot指令!
- 还可能是因为手机端没有同意电脑对设备的控制(RSA秘钥指纹)
  - ![image-20220810082950377](https://img-blog.csdnimg.cn/img_convert/f7c1617eed8680d25f0c03c3a1a11396.png)
- 所以说,建议在开机状态下,确保命令行工具可以访问手机
  - `adb devices -l`
  - 将上述命令行复制到cmd窗口(cmd处于默认工作目录`platform-tools`下),既可以检查连通性



## adb链接

- [安装ADB | 秋之盒 (atmb.top)](https://www.atmb.top/guide/adb/install/)
- [在手机上启用USB调试 | 秋之盒 (atmb.top)](https://www.atmb.top/guide/adb/enable/)

- [ADB命令简介 | 秋之盒 (atmb.top)](https://www.atmb.top/guide/adb/use/)
  - 秋之盒工具箱是一款玩机工具,这里推荐一片adb命令的使用介绍

##  大小写问题&斜杠问题(optional)

- 由于linux(android)都是区分大小写的,windows虽然不区分,但是本教程要求区分
  - 特别是使用adb&fastboot相关命令的时候是区分大小写的,传输文件的时候末尾斜杠不要多(访问目录则是可加可不加)
  - 总之就是,传输文件的时候,文件名末尾没有斜杠`/`
  - 指定目录参数的时候,推荐加上斜杠`/`
- 尤其是,手机上的目录是,`/sdcard/Download`
  - 斜杠方向
  - `Download`而不是小写`download`(x)
  - 是不带s的单数`Download`
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/9157882f3a3442acb9630861211f0cb8.png)

- 尽管如此,选择一个短的路径会有利于找到文件
  - 譬如,push 文件到android 设备目录设置为`/sdcard/`,而不必放到`/sdcard/Download/`这一子目录下
  - 只要确保你可以方便的找到该文件即可






### 配置命令行工具相关环境变量或命令行工具别名(optional)

#### 环境变量方式

- 这不是必须的,但是推荐配置一下,这会是你在用命令行的时候更加方便,而不需要将工作目录定在(fastboot.exe和adb.exe目录下)
- 如果你对此看兴趣,可以参考以下文章(只需要看一小部分,就可以满足本教程需求)
  - [windows_环境变量创建(environment variables/path)和使用(以java环境配置为例说明)+导出/导入环境变量方法+注册表备份_xuchaoxin1375的博客-CSDN博客_创建环境变量](https://blog.csdn.net/xuchaoxin1375/article/details/119189994?ops_request_misc=%7B%22request%5Fid%22%3A%22165889319416781790750884%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=165889319416781790750884&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-2-119189994-null-null.185^v2^control&utm_term=环境变量&spm=1018.2226.3001.4450)

#### 别名方式

- 如果你熟悉powershell,可以对上述两个命令行工具配置别名,同样是方便的,由于是可选的内容我就不展开了,另外查阅资料,或者查看powershell帮助手册
  - `man Set-Alias`
  - 如果喜欢,你还可以固化别名配置

#### 什么都不配置

- 都不想配置,那就得老老实实的将工作目录锁定在工具箱目录下
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/1fca69d61ac24ba29b3485f2514ea9ec.png)

- 😂还有一种方式,就是每次执行命令,都将命令行工具的绝对路径打出来,很不方便

### 关于fastboot工具和adb工具的使用场景和帮助名令

- adb可以在开机的状态下使用

  - 在一些不需要root权限但又高于普通android用户权限的时候,adb用得多
  - 本教程中,adb是可选的(例如,可以做到以下事情
    - 检查设备是否成功链接(驱动是否正常):`adb devices -l`
      - 注意`devices`的拼写
    - `adb reboot bootloader`使得开机的(并且已经允许计算机调试的android直接重启到bootloader(fastboot模式))
      - 这可以省去关机后按`音量减`&`电源键`的物理方式进入`fastboot`模式,更加高效
    - 以上都是可选,可以用你喜欢的传输方式进行传输文件
  
- 获取帮助` adb --help`

  - ```bash
    PS D:\usersByCxxu\DownloadsAll> adb --help
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
     很长,省略篇幅
    ```

    

- fastboot是线刷的主角命令

  - 用来对处于`fastboot`模式下的android设备进行操作

- fastboot帮助手册`fastboot --help`

  - ```bash
    PS D:\usersByCxxu\DownloadsAll> fastboot --help
    usage: fastboot [OPTION...] COMMAND...
    
    flashing:
     update ZIP                 Flash all partitions from an update.zip package.
     flashall                   Flash all partitions from $ANDROID_PRODUCT_OUT.
                                On A/B devices, flashed slot is set as active.
                                Secondary images may be flashed to inactive slot.
     flash PARTITION [FILENAME] Flash given partition, using the image from
                                $ANDROID_PRODUCT_OUT if no filename is given.
    
    basics:
     devices [-l]               List devices in bootloader (-l: with device paths).
     getvar NAME                Display given bootloader variable.
     reboot [bootloader]        Reboot device.
     
     省略篇幅
    
    ```

    

#  基础知识补习

##  玩机论坛/网站

- [玩机资源合集 (jamcz.com)](http://wanji.jamcz.com/)
- 完整版酷安app(应用商店一般都是阉割版的,没有灵魂)
  - [完整版:酷安 - 发现科技新生活 (coolapk.com)](https://coolapk.com/)
- 搞机助手(GJZS.R):[搞机助手-官网 (lsdy.top)下载](https://lsdy.top/gjzs)
  - [主页 | 搞机助手·R (gjzsr.com)](https://gjzsr.com/)
  - [liuran001/GJZS: 搞机助手·R（原「搞机助手重制版」） (github.com)](https://github.com/liuran001/GJZS)

##  fastboot命令

- [Fastboot - Wikipedia](https://en.wikipedia.org/wiki/Fastboot)

### bootloader(fastboot)下的常用操作

- [How to Boot into Recovery from Fastboot Mode (for TWRP/Stock) (androidjungles.com)](https://www.androidjungles.com/boot-into-recovery-from-fastboot-mode/)
- [Fastboot Commands List - Cheat Sheet PDF Download - Technastic](https://technastic.com/fastboot-commands-list/)

### 常用的fastboot子命令Commands

Some of the most commonly used fastboot commands include:

- flash – rewrites a partition with a binary image stored on the host computer.

- flashing unlock/oem unlock  – unlocks an OEM locked bootloader for flashing custom/unsigned ROMs. The  is a device specific unlock key.

- flashing lock/oem lock  – an opposite action.

- erase – erases a specific partition.

- reboot – reboots the device into either the main operating system, the system recovery partition or back into its boot loader.

- devices – displays a list of all devices (with the serial number) connected to the host computer.

- format – formats a specific partition; the file system of the partition must be recognized by the device.

- oem device-info – checks the bootloader state.

  - 例如,对于未解锁的设备,有如下提示

    - 这种情况下,许多fastboot的指令无法顺利执行.

  - ```bash
    fastboot oem device-info
    (bootloader) Verity mode: true
    (bootloader) Device unlocked: false
    (bootloader) Device critical unlocked: false
    (bootloader) Charger screen enabled: false
    OKAY [  0.015s]
    Finished. Total time: 0.015s
    ```

    

- getvar all – displays all information about device (IMEI, bootloader version, battery state etc.).

## android 分区

- [概览 Android 设备几个分区，它们在启动过程中提供不同的功能](https://source.android.com/devices/bootloader/partitions)
  - [[TechLab Team\] Different kinds of Android Partitions - TechLab - Xiaomi Community - Xiaomi](https://c.mi.com/oc/thread-3286379-1-0.html)
  - [How A/B Partitions and Seamless Updates Affect Custom Development on XDA (xda-developers.com)](https://www.xda-developers.com/how-a-b-partitions-and-seamless-updates-affect-custom-development-on-xda/)
  - [Recovery Images  | Android Open Source Project](https://source.android.com/devices/bootloader/recovery-images?hl=en)
  - [动态分区  | Android 开源项目  | Android Open Source Project](https://source.android.com/devices/tech/ota/dynamic_partitions)
  - [platform/external/avb - Git at Google (googlesource.com)](https://android.googlesource.com/platform/external/avb/)
  - [分区布局  | Android 开源项目  | Android Open Source Project](https://source.android.com/devices/bootloader/partitions/system-as-root)
  - [What differs Android from other Linux based systems? - #embeddedbits](https://embeddedbits.org/what-differs-android-from-other-linux-based-systems/)
- 早期的android:
  - [Android Partitions Explained: boot, system, recovery, data, cache & misc (addictivetips.com)](https://www.addictivetips.com/mobile/android-partitions-explained-boot-system-recovery-data-cache-misc/)

#  附(资源)

## 小米/redmi 刷机包获取(optional)

- 如果你要自己提取boot.img,可以到rom网站下载和当前系统版本对应的rom,一遍从中提取`boot.img`文件

  - 线刷包通常包里直接带有`boot.img`
  - 如果下载的是卡刷包可能需要做转换

- 方式1:直接从手机端获取rom

  - 到系统更新页面
  - 操作细节建议看看
    - [如何获取MIUI最新系统包 - Magisk中文网 (magiskcn.com)](https://magiskcn.com/get-miui)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/178267b64eb94ab3b98dc0f7bd1105a3.png)

  

- 方式2:google搜索

- rom网站

  - [Feishu Sheet](https://xiaomishequ.feishu.cn/sheets/shtcnsRTbwSvpUsaei6B04ogI6Z?sheet=67sr9v)
  - [MIUI ROM DOWNLOAD - Xiaomi Community - Xiaomi](https://c.mi.com/global/miuidownload/index)
  - 或者到网站:[Download Official ROM For All Xiaomi Devices | XiaomiROM.com](https://xiaomirom.com/en/series/)
  - [MIUI官方ROM仓库--由米柚发烧友整理维护 (miuier.com)](https://roms.miuier.com/index.html)
