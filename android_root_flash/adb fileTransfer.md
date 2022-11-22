[toc]

## adb file transfer

### 使用文档

- 包括三个子命令:

  - 比较常用的是前面

  - 使用`adb push`可以用来向anroid设备传输文件

  - 另一方面,`adb pull`可以从android 设备将文件拉取到电脑上
  
  - push
  
    - ```bash
       push [--sync] [-z ALGORITHM] [-Z] LOCAL... REMOTE
           copy local files/directories to device
           --sync: only push files that are newer on the host than the device
           -n: dry run: push files to device without storing to the filesystem
           -z: enable compression with a specified algorithm (any/none/brotli/lz4/zstd)
           -Z: disable compression
      ```

      
  
  - pull
  
    - ```bash
      pull [-a] [-z ALGORITHM] [-Z] REMOTE... LOCAL
           copy files/dirs from device
           -a: preserve file timestamp and mode
           -z: enable compression with a specified algorithm (any/none/brotli/lz4/zstd)
           -Z: disable compression
      ```

      
  
  - sync
  
    - ```bash
      
       sync [-l] [-z ALGORITHM] [-Z] [all|data|odm|oem|product|system|system_ext|vendor]
           sync a local build from $ANDROID_PRODUCT_OUT to the device (default all)
           -n: dry run: push files to device without storing to the filesystem
           -l: list files that would be copied, but don't copy them
           -z: enable compression with a specified algorithm (any/none/brotli/lz4/zstd)
           -Z: disable compression
      ```
  
      



## adb命令行进行文件传输注意事项

### adb push

- 我们以`adb push`(推送电脑文件到手机)为例
  - `adb pull`拉取手机文件到电脑)遵循类似的规则,但是参数位置不同
  - 合法的命令行格式(合法的路径参数)


#### 🎈路径名约定

- 为了确保传输顺利,应该尽可能的保证
  - 文件名尽量不包含空格和其他非法字符(比如特殊符号(字母/下划线/小数点都是合法的)
    - 如果以空格,应当使用引号将其包围,来表示这个一个整体名字
  - 中文支持的不好
    - 试验中文传输的过程中,及时没有带空格,也频频失败,所以如果想要传送中文文件,要么暂时改名
    - 要么用别的方式传输🎈
  - 命令行工具操作文件对于文件名是很敏感的
  - 特别是对于linux,区分大小写,更加敏感

### push文件

#### 保持名字直接传输

- 假设当前目录有一个文件名字叫做`fileName`
  - `adb push fileName /sdcard/`(传输完成后,android设备的`/sdcard/`目录下将出现文件fileNmae

#### 传输的同时更改名字

- `adb push fileName /sdcard/Download/fileNewName.ext`
- 目标目录为android设备的`/sdcard/Download/`,出现的新文件名为你指定的名字`fileNewName.ext`

#### 非法的路径参数

- 同时,如果手机上没有中间路径,那么adb的此次传输会创建相应中间路径

  - ```bash
    PS C:\Users\cxxu\Desktop> touch a
    PS C:\Users\cxxu\Desktop> push a /sdcard/d1/d2/d3/a2b
    a: 1 file pushed, 0 skipped.
    PS C:\Users\cxxu\Desktop> adb shell
    xaga:/$ ls -l /sdcard/d1/d2/d3/a2b
    -rw-rw---- 1 u0_a214 media_rw 0 2022-11-19 14:21 /sdcard/d1/d2/d3/a2b
    ```

##### 非法的路径参数

- `adb push file /sdcard/NotYetExistDir/`(报错)
  - 当路径结尾不是文件名而是一个不存在的目录(以一个斜杠`/`结尾表示传输的目标目录
  - 这种情况是非法的,会报错
  - 解决错误的办法是:
    - 去掉结尾斜杠,转化为上一种情况:`非法的路径参数`
    - 或者接着追加文件名字(此时不可以在带有结尾的斜杠)

#### powershell函数

- ```powershell
  $downloadM="/scard/Download"
  function pushToAndroid
  {
      param (
          $path,
          $DestinationPath_opt = "$downloadM"
      )
      adb push $path $DestinationPath_opt
  }
  set-alias push pushToAndroid
  
  ```

- 用例:`push fileNameOrDirName`

  - ```bash
    PS C:\Users\cxxu\Desktop\videos> push .\test
    .\test: 1 file pushed, 0 skipped.
    ```

    



## 更多adb 文件传输示例

####  绝对路径传输文件实例

- 这里我将一个压缩包传输到手机上
  
  这里要注意,第二个路径参数的斜杠是linux规范的`/`,如果写成`\`会导致意外的结果(文件传输到意料之外的地方,找不到了)
- 对于目录,即为可以不加斜杠,但是推荐加上,这样一目了然

```bash
PS C:\Users\cxxu\Downloads> adb push C:\Users\cxxu\downloads\Compressed\MK90.0-santoni-210620-HISTORY.zip /sdcard/Download
C:\Users\cxxu\downloads\Compressed\MK90.0-santoni-21062...shed, 0 skipped. 25.2 MB/s (695991497 bytes in 26.315s)
PS C:\Users\cxxu\Downloads>
```

#### 相对路径传输示例

- ```powershell
  PS C:\Users\cxxu\Downloads\Compressed> adb push  .\lineage-18.1-20220720-UNOFFICIAL-0xCAFEBABE-Mi8937.zip /sdcard/Download/
  .\lineage-18.1-20220720-UNOFFICIAL-0xCAFEBAB...pped. 23.7 MB/s (783898135 bytes in 31.594s)
  PS C:\Users\cxxu\Downloads\Compressed>
  ```

#### 利用adb shell 检查android 设备文件



- 可选操作:检查android指定目录下是否存在某文件(下面是已经root的才有权限)

  - ```bash
    santoni:/ # cd sdcard/
    santoni:/sdcard # ls
    Alarms   MIUI     Music         Ringtones baidu                did    sogou
    Android  MT2      Notifications TWRP      browser              jeejen wlan_logs
    DCIM     MiMarket Pictures      Xiaomi    com.miui.voiceassist miad
    Download Movies   Podcasts      backups   dctp                 mipush
    santoni:/sdcard # cd Download/
    santoni:/sdcard/Download # ls
    3b515ef2c77d9f04e58c1d75a3add549-0-o_1g8cle2dk1mia12ds1vjs13eost32c-uid-408649.apk
    DevCheck_4.37.apk
    GitHub\ -\ yc9559_uperf_\ Userspace\ performance\ controller\ for\ android.mhtml
    MK90.0-santoni-210620-HISTORY.zip
    app-releas.zip
    app-release.apk
    app-release_mini.apk
    boot.img
    boots.zip
    magisk_patched-25200_VBQAh.img
    miui_HM4X_V11.0.1.0.NAMCNXM_7e7448fe6d_7.1.zip
    uperf-dev-22.07.24.zip
    ```

  

### adb pull

- 从android拉取文件到pc端
- 要求和adb push 类似











