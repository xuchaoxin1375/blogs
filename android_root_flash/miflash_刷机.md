@[toc]
## ref

- [【必看】刷机注意事项 (miui.com)](https://web.vip.miui.com/page/info/mio/mio/detail?postId=32681233&app_version=dev.20051)

## 解锁

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/9374f9b84a5946f5a6de26790ba8ef39.png)

  - 手机绑定账号
  - 进入fastboot模式
  - 使用官方解锁工具解锁
    - 现在账号绑定手机后可能要等待一段时间才可以解锁!

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

- 🎈保留数据可能造成一些bug

  - 建议备份后再刷机,选择(全部删除)

    

###  所谓保留数据🎈

- 只是sdcard目录下的文件**这部分内容不会被删除**
  - 照片之类的还在

- app之类的东西将全部消失(重置)

## 🎈执行刷写前的最后确认

- 手机一定要进入到fastboot模式,

  - 否则进度条走也是白走


## 刷写完毕

- 参考截图
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/4d5ae53b427442a5b07bc42c1f6a50b7.png)

## 可能的错误

- `   error:Not catch checkpoint (\$fastboot -s .* lock),flash is not done`
- 这可能发生在您选择了删除全部数据,但是不上锁的情况下
  - 一般还是可以正常开机,不需要担心