[toc]

## 下载

- 目前想要下载最新版Android Studio基本就是上官网下,速度比较慢
  - 可以尝试代理

## 初次启动软件安装组件

- ```bash
  Setup Type: Standard
  SDK Folder: C:\Users\cxxu\AppData\Local\Android\Sdk
  JDK Location: D:\Program Files\Android\Android Studio\jbr (Note: Gradle may be using JAVA_HOME when invoked from command line. More info...)
  Total Download Size: 1.61 GB
  SDK Components to Download: 
  
  Android Emulator hypervisor driver (installer)
    
  165 KB
  
  Android SDK Build-Tools 33.0.2
    
  53.1 MB
  
  Android SDK Platform 33
    
  64.2 MB
  
  Android SDK Platform-Tools
    
  5.8 MB
  
  Google APIs Intel x86_64 Atom System Image
    
  1.44 GB
  
  Intel x86 Emulator Accelerator (HAXM installer)
    
  500 KB
  
  Sources for Android 33
    
  46.9 MB
  ```

- 重点内容:

  - `SDK Folder: C:\Users\cxxu\AppData\Local\Android\Sdk`
  - `JDK Location: D:\Program Files\Android\Android Studio\jbr` 
    - (Note: `Gradle` may be using `JAVA_HOME` when invoked from <u>command line</u>. More info...)

## Note

### 组件目录设定(optional)

- 如果您的C盘空间不充裕或者其他原因,希望将组件下载到其他盘,可以在`$userprofile`下设置(即,没有特别说明,默认的其实路径总是用户的**家目录**,可以在命令行中将当前目录设置为家目录(通常是默认的目录)):

  - `.android`

    - 存放一些android虚拟设备(avd等),目录体积一般也比较大

  - `.gradle`

    - 这个目录在后续的依赖中会大量使用

    - 以powershell为例:

      - ```powershell
        mkdir D:/.gradle;
        new-Item -ItemType Junction -Path $env:USERPROFILE\.gradle -Target D:\.gradle\
        
        
        ```

    - `gradle_user_home`是可供覆盖默认路径的环境变量,如有需要,可以通过配置该环境变量来调整gradle路径!

      - 注意添加或修改该路径后需要重启软件

  - `$env:LOCALAPPDATA`(用户家目录)下提前设置一下目录的junction链接(或符号链接):

    - `Android`

      - 内部创建的Sdk目录将自动被定向到junction所指的位置

      - ```powershell
        mkdir D:/Android;
        New-Item  -ItemType Junction  -path $env:localAppdata/Android -Target D:/Android
        
        ```

    

  - `$env:userprofile\AndroidStudioProjects`

    - ```powershell
      new-item -ItemType Junction -Path $env:userprofile\AndroidStudioProjects -Target D:\repos\AndroidProjects\
      ```

#### 小结

- ```bash
  PS C:\Users\cxxu> get_links_count
  
  Name                  LinkType Target
  ----                  -------- ------
  .android              Junction D:\.android
  .gradle               Junction D:\.gradle\
  AndroidStudioProjects Junction D:\repos\AndroidProjects\
  ```

  



### java_home和Path配置

- 以windows配置为例:
  - 系统环境变量`java_home`
  - Path变量值:`%java_home/bin`

- 下载并安装依赖之前,最好检查一下JDK是否正确配置(或是否可以正常使用)

  - ```bash
    java --version
    ```

  - 否则某些组件可能会无法正常安装

    - 这种情况下,需要配置jdk,然后建议重启后再重试(直接重试可能会因为配置未生效或错误缓存导致二次失败)

    ```
    Preparing "Install Google APIs Intel x86_64 Atom System Image (revision: 10)".
    Downloading https://dl.google.com/android/repository/sys-img/google_apis/x86_64-33_r10.zip
    "Install Google APIs Intel x86_64 Atom System Image (revision: 10)" ready.
    Installing Google APIs Intel x86_64 Atom System Image in C:\Users\cxxu\AppData\Local\Android\Sdk\system-images\android-33\google_apis\x86_64
    "Install Google APIs Intel x86_64 Atom System Image (revision: 10)" complete.
    "Install Google APIs Intel x86_64 Atom System Image (revision: 10)" finished.
    Parsing C:\Users\cxxu\AppData\Local\Android\Sdk\build-tools\33.0.2\package.xml
    Parsing C:\Users\cxxu\AppData\Local\Android\Sdk\emulator\package.xml
    Parsing C:\Users\cxxu\AppData\Local\Android\Sdk\extras\google\Android_Emulator_Hypervisor_Driver\package.xml
    Parsing C:\Users\cxxu\AppData\Local\Android\Sdk\extras\intel\Hardware_Accelerated_Execution_Manager\package.xml
    Parsing C:\Users\cxxu\AppData\Local\Android\Sdk\patcher\v4\package.xml
    Parsing C:\Users\cxxu\AppData\Local\Android\Sdk\platform-tools\package.xml
    Parsing C:\Users\cxxu\AppData\Local\Android\Sdk\platforms\android-33\package.xml
    Parsing C:\Users\cxxu\AppData\Local\Android\Sdk\sources\android-33\package.xml
    Parsing C:\Users\cxxu\AppData\Local\Android\Sdk\system-images\android-33\google_apis\x86_64\package.xml
    Android SDK is up to date.
    Creating Android virtual device
    Android virtual device Pixel_3a_API_33_x86_64 was successfully created
    
    ```

## gradle和代理设置

- [配置 Android Studio  | Android 开发者  | Android Developers](https://developer.android.com/studio/intro/studio-config?hl=zh-cn#proxy)

## FAQ

### 组件下载通畅性检查

- 可以借助第三方工具来查看当前网络的传输速率,例如开源的trafficMonitor等
- windows自带的资源管理器有网络监控的功能

### 系统性能和资源检查

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/8bd6bf63c59544e582cb71cd7597e50e.png)
- 软媒内存整理(魔方组件)和trafficMonitor.
- 当系统变得卡顿时,需要检查相关资源,包括内存和网络速率

