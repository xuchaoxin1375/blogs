[toc]



## ref

- [【必看】刷机注意事项 (miui.com)](https://web.vip.miui.com/page/info/mio/mio/detail?postId=32681233&app_version=dev.20051)

### miflash下载

提供两个版本

- [MiFlash2020-3-14-0（点我）下载](https://cdn.alsgp0.fds.api.mi-img.com/micomm/MiFlash2020-3-14-0.rar) 
- [MiFlash2018-5-28-0（点我）下载](http://bigota.d.miui.com/tools/MiFlash2018-5-28-0.zip)



### 待线刷设备扫描和检查

- 手机进入fastboot模式后,可以通过`fastboot devices`来检查设备连接情况
- 可以fastboot命令行看到设备序列号和MiFlash工具查询到的是一致的
  - 对于MiFlash工具,如果在开机状态下想要点击刷新(refresh)是无法查询到设备的,而且可能会报错(RunDll)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7a56c179d545477dba26f25bfb6ae1ee.png)

### 使用方式

- 打开刷机工具，点击“选择”选择**解压后的刷机包(文件夹)**或将**解压后的刷机包地址**复制到刷机工具**地址栏**；

- 手机关机，“音量下”+“电源键”进入Fastboot模式，并连接电脑端解锁工具；

- 点击刷机工具“加载设备”刷出设备；

- 选择合适的脚本（全部清除、保留所有数据、全部删除并Lock），点击“刷机”，等待手机重启后刷机完成。

### 线刷工具卡住的关闭方法@RunDll错误😂

- 错误内容

  - ```
     There was a problem starting qcCoInStaller.dll
     the specified module could not be found
    ```

    

- 这个软件不是太稳定和鲁棒(rubust),如果某些错误(比如RunDll错误)导致软件卡死无法关闭,可以尝试以下方法

  - 使用管理员方式打开poweshell,执行` stop-Process -name XiaoMiFlash`
  - 或者打开任务管理器,找到`XiaoMiFlash`(miflash的全称),右键结束相应进程

- 在windows系统下可能会出现这个错误可能是由于命令行创建别名的方式启动`miflash`导致的

- 推荐的启动miflash的方式还是进**入到软件目录**打开,可以避免这个错误

- ```bash
  PS D:\exes\android_root_roms\Miflash2020> ls
  
          Directory: D:\exes\android_root_roms\Miflash2020
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  d----        12/30/2022   6:13 PM                  da
  d----        12/30/2022   6:13 PM                  Doc
  d----         8/10/2023   6:55 PM                  log
  d----        12/30/2022   6:13 PM                  mi
  d----        12/30/2022   6:13 PM                  Source
  d----        12/30/2022   6:13 PM                  SP_Download_tool
  -a---         2/28/2020  10:05 AM          22658   AutoUpdater.config
  ....
  ...
  ...
  -a---         2/28/2020  10:05 AM         174592 󰣆  QSaharaServer.exe
  -a---         3/23/2020  10:07 AM           1021 󰪷  ReadMe.txt
  -a---         2/28/2020  10:05 AM          57856   RoutingObject.dll
  -a---         2/28/2020  10:05 AM         143288   SLA_Challenge.dll
  -a---         2/28/2020  10:05 AM           9728 󰣆  Upgrader.exe
  -a---         2/28/2020  10:05 AM          30208   Upgrader.pdb
  -a---         3/23/2020   4:20 PM         376832 󰣆  XiaoMiFlash.exe
  -a---         8/10/2023   7:20 PM           1960   XiaoMiFlash.exe.Config
  -a---         3/23/2020   4:20 PM         849408   XiaoMiFlash.pdb
  -a---         2/28/2020  10:05 AM          11608 󰣆  XiaoMiFlash.vshost.exe
  -a---         2/28/2020  10:05 AM           1827   XiaoMiFlash.vshost.exe.config
  -a---         2/28/2020  10:05 AM           2373 󰗀  XiaoMiFlash.vshost.exe.manifest
  ```

  

## 解bl锁

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/9374f9b84a5946f5a6de26790ba8ef39.png)

- 手机绑定账号
- 进入fastboot模式
- 使用官方解锁工具解锁
  - 现在账号绑定手机后可能要等待一段时间才可以解锁!
  - 通常是一周或则更长时间,如果等不及可以考虑新建一个小米账号绑定,通常新账号只需要7天(168)小时

### 绑定计时规则

- 假设您在1月份解锁了一部MIUI手机,那么需要到2月份才可解锁下一部手机

  - 这里的月不是按天计算,而是只看当天的月份,也就是两台手机解锁日期是否是处在不同的月份即可
  - 如果今天是当前月份的最后一天(比如30号或31号),那么第二天就是新的月份,因此,两部手机都绑定同一个小米账号的解锁间隔最短(最理想)情况下只需要很短的时间,但这是最理想的单账号连续解锁情况

  - 如果是当月1号解锁,那么下个月一号才可以解锁,需要等待大约30天时间

- 开发着选项中小米账号绑定手机的操作通常只要绑定一次,如果反复操作,则要重新计时

  - 这意味这,假设您在绑定账号的第6天又执行了绑定操作,那么这6天就白等了
  - 您可以通过MIUI解锁来查询绑定时间是否已经达到168小时或者还需多小小时达到168小时
  - 查询过程就是解锁过程,如果绑定时间足够,通常可以顺利解锁,如果绑定时间不足,可能会出现各种错误,也可能会提示绑定时间不足,总之在处理绑定时间不足的情况下,软件运行结果是不稳定的(经常返回错误代码而不是剩余时间)
  - 如果遇到报错,您可以多尝试几次,或切换网络再试;但是这里在绑定的时候记住日期x,或者提前算好可以解锁的日期(x+7),然后再多等一天(x+8),以确保等到充足的168小时,避免浪费时间处理软件的报错上

## 驱动

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/661810c754b44b299f96ecb49d1f9326.png)

### 检查设备加载情况

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/44685049a6d94e7897c860af6d0bf49c.png)
- 如果驱动正常,在fastboot模式下或者开机状态先应该都能够检测到设备
  - <u>设备号是一串不太有规律的字符串</u>
- 如果不正常,参考:
  - 这些是关于adb的,以及开发者选项的开关,usb选项设置的
  - 如果adb通信可用,那么驱动一般也是没问题的
  - [  android_adb调试链接方案/链接失败的若干问题/android11+无线调试(wireless debugging)/android玩机工具箱/进程管理scene5_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/125862525)
  - [android_使用adb安装app包的详细步骤和可能遇到的问题(apk文件)_xuchaoxin1375的博客-CSDN博客_android adb 安装apk](https://blog.csdn.net/xuchaoxin1375/article/details/127853819?ops_request_misc=%7B%22request%5Fid%22%3A%22166996652416800192297110%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=166996652416800192297110&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-1-127853819-null-null.nonecase&utm_term=apk&spm=1018.2226.3001.4450)

### 选择刷机包

- 要求是**线刷包**才可以被识别

- 例如,下载下来的线刷包是压缩文件

  - 比如`tgz`格式

    - 里面可能又是一个压缩包(比如`rar`)

  - 那么你需要将所有压缩层都解压,得到一个文件夹(目录)

  - 这时候通过选择按钮,找到你解压好的文件夹

    - 文件夹内容给一个大致的参考:

    - ```bash
      PS C:\Users\cxxu\Downloads\xaga_images_V13.0.13.0.SLOCNXM_20220908.0000.00_12.0_cn_chinatelecom> ls
      
              Directory: C:\Users\cxxu\Downloads\xaga_images_V13.0.13.0.SLOCNXM_20220908.0000.00
          _12.0_cn_chinatelecom
      
      
      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
      d----          9/8/2022   7:39 PM                  images
      d----          9/8/2022   7:39 PM                  Log
      -a---          9/8/2022   7:37 PM           2256   auth_sv5.auth
      -a---          9/8/2022   7:37 PM            100   check_sum.sh
      -a---          9/8/2022   7:37 PM          41344   CheckSum_Gen
      -a---          9/8/2022   7:37 PM           4489   flash_all_except_data_storage.bat
      -a---          9/8/2022   7:37 PM           4454   flash_all_except_data_storage.sh
      -a---          9/8/2022   7:37 PM           4672   flash_all_lock.bat
      -a---          9/8/2022   7:37 PM           4609   flash_all_lock.sh
      -a---          9/8/2022   7:37 PM           4672   flash_all.bat
      -a---          9/8/2022   7:37 PM           4631   flash_all.sh
      -a---          9/8/2022   7:37 PM           8081   flash_gen_crc_list.py
      -a---          9/8/2022   7:37 PM           2084   flash_gen_md5_list.py
      -a---          9/8/2022   7:37 PM        1721192   libflashtool.so
      -a---          9/8/2022   7:37 PM        7304367   libflashtool.v1.so
      -a---          9/8/2022   7:37 PM        6869569   libflashtoolEx.so
      -a---          9/8/2022   7:40 PM           3288   md5sum.xml
      -a---          9/8/2022   7:39 PM            128   misc.txt
      
      ```

    - 如你所见,应该可以看到一系列的刷机脚本

    - 还能够看到一个images文件夹

      - ```bash
        Mode                LastWriteTime         Length Name
        ----                -------------         ------ ----
        d----          9/8/2022   7:37 PM                  download_agent
        -a---          9/8/2022   7:37 PM              2   anti_version.txt
        -a---          9/8/2022   7:37 PM        1402656   apusys.img
        -a---          9/8/2022   7:37 PM        5506176   audio_dsp.img
        -a---          9/8/2022   7:37 PM       67108864   boot.img
        -a---          9/8/2022   7:37 PM         176288   ccu.img
        -a---          9/8/2022   7:40 PM            525   crclist.txt
        -a---          9/8/2022   7:39 PM      994824628   cust.img
        -a---          9/8/2022   7:37 PM         263984   dpm.img
        ...
        -a---          9/8/2022   7:37 PM           8192   vbmeta.img
        -a---          9/8/2022   7:37 PM        1586448   vcp.img
        -a---          9/8/2022   7:37 PM       67108864   vendor_boot.img
        ```

      - 在较新版本的android中,由于VAB分区的引入,会有很多镜像文件(`xxx.img`)文件

      - 其中最关键的是`boot.img`(和本主题没有太大关系,但是提一下)

        - 目前最流行的获取root权限的方法就是借助`magisk`修补`boot.img`

        - [  android 手机获取root权限(刷入magisk面具方式)_获取刷入模块_MIUI_android7/android12实践_xuchaoxin1375的博客-CSDN博客_修补boot中的vbmeta](https://blog.csdn.net/xuchaoxin1375/article/details/126015726?ops_request_misc=%7B%22request%5Fid%22%3A%22166996668816782425183742%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=166996668816782425183742&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-1-126015726-null-null.nonecase&utm_term=root&spm=1018.2226.3001.4450)

          

## 保留数据刷机选项(🎈🎈🎈)

- 前面步骤顺利的话,还要小心到最后一步:选择是否保留数据以及是否加锁
  - 对于玩机用户,**推荐只选择前两个按钮**
  - 普通用户(安全第一的用户)如果不需要root之类的玩机环境,可以选择第三个按钮(默认)
    - 但是资料全部消失
  - 如果之前就没有解锁过,那无所谓锁不锁,关键看要不要sdcard里的照片视频等数据
  
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/02c3c5b5077b4c0c8351c17b0099e273.png)


### 保留用户数据降级

- 保留数据可能造成一些bug设置无法正常使用设备

- 我在2023年对**K60**(modrian)从`MIUI 14.0.26`保留用户数据降级到`14.0.18`虽然能够重新开机,但是软件无法启动(提示我等系统完全加载(重启)后再启动app(除了系统设置),然而能进入桌面却始终无法打开app)

- 建议备份后再刷机,选择(全部删除)

  

###  所谓保留数据🎈

- 只是sdcard目录下的文件**这部分内容不会被删除**
  - 照片之类的还在

- app之类的数据将全部消失(重置)

- 脚本名称检查:软件下方的三个选项分别对应于三个方案的刷写脚本:

  - `ls .\flash_*bat`

    ```
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -----         1/11/2023   8:29 AM           5038   flash_all_except_storage.bat
    -----         1/11/2023   8:29 AM           5302   flash_all_lock.bat
    -----         1/11/2023   8:29 AM           5295   flash_all.bat
    ```

  - 如果是linux(bash),可以用`ls .\flash_*sh`来检查

    - ```
      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
      -----         1/11/2023   8:29 AM           6052   flash_all_except_storage.sh
      -----         1/11/2023   8:29 AM           6390   flash_all_lock.sh
      -----         1/11/2023   8:29 AM           6387   flash_all.sh
      ```

  - 两类情况只有后缀不同,文件名是相同的

    - `flash_all_except_storage`:保留数据刷写
    - `flash_all_lock`:清除所有数据并上锁(bl锁)刷写
    - `flasht_all`:清除所有数据刷鞋


## 执行刷写前的最后确认👺

- 手机一定要进入到fastboot模式,

  - 否则进度条走也是白走


## 刷写完毕

- 参考截图
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/4d5ae53b427442a5b07bc42c1f6a50b7.png)

## 可能的错误

- `   error:Not catch checkpoint (\$fastboot -s .* lock),flash is not done`
- 这可能发生在您选择了删除全部数据,但是不上锁的情况下
  - 一般还是可以正常开机,不需要担心