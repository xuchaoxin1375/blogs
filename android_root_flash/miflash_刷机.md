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


- 检查设备加载情况

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/44685049a6d94e7897c860af6d0bf49c.png)

  - 如果驱动正常
    - 关键目录合法(通常可以忽略,但是为了严谨,再此提一下,我在其他blog中讨论过这个歌问题)
  - 在fastboot模式下或者开机状态先应该都能够检测到
    - 设备号是一串不太有规律的字符串

- 选择刷机包

  - 要求是线刷包才可以被识别

  - 例如,下载下来的线刷包是压缩文件

    - 比如`tgz`格式

      - 里面肯能又是一个压缩包(比如`rar`)

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

            - 假设得到名字为`magisk_patched-25xxxx.img`

          - 将修补到的文件在fastboot模式下利用命令`fastboot flash boot magisk_patched-25xxx.img `

            - 将修补后的镜像输入到boot分区,从而获得root权限(需要借助magisk app来管理)

            - 详情查看其他blogs

              

## 保留数据刷机选项(🎈🎈🎈)

- 前面步骤顺利的话,还要小心到最后一步:选择是否保留数据以及是否加锁
  - 对于玩机用户,推荐只选择前两个按钮
  - 普通用户如果不需要root之类的玩机环境,可以选择第三个按钮(默认)
    - 但是资料全部消失

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/02c3c5b5077b4c0c8351c17b0099e273.png)

- 🎈保留数据可能造成一些bug

  - 建议备份后再刷机,选择(全部删除)

    
###  所谓保留数据
- 只是sdcard目录下的文件不会被删除
- app之类的东西将全部消失(重置)
- 但是照片之类的还在

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