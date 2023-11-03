[toc]

# 备份

- 用到的powershell脚本:
  - [modulesByCxxu  (gitee.com)](https://gitee.com/xuchaoxin1375/scripts/tree/main/modulesByCxxu)

## 桌面快捷方式

- 调用`backup_deploy_shortcuts_lnk`进行备份或者还原(使用deploy参数指定`$True`还原)

## 符号链接备份

- 推荐的备份方式是备份创建符号链接的命令,而不是直接复制这些符号链接

### 扫描

- 调用powershell函数`backupSymbolicLinks`

## 系统环境变量

- 调用`backupEnvs_regeditPrintPath`

## 家目录中的配置文件

- 例如`.condarc`,`.git`

### 驱动

- 根据自己的习惯是否备份或者重装完再安装

## 软件数据

- wechat
- qq
- office 自定义配置
- ...

## 文档和下载数据

- 比如`$env:userprofile\downloads`
- `$env:userprofile\documents\`

# 重装后👺

## 第一批恢复

- 环境变量还原
  - `cd $configs\env`
  - 选择合适的版本进行还原(也可以双击文件还原),这是通过修改注册表还原
  - 重启终端
- 代理软件
  - 注意端口修改为惯用的端口号,例如`10801`,否则浏览器在导入的配置不匹配导致浏览器访问网络卡顿等问题
- 浏览器配置
  - 某些代理插件中导入配置后需要分别在代理列表和代理服务器点保存，例如
    - proxy switchomega（推荐）
    - SmartProxy

### 系统更新检查@驱动

- 刚安装的系统可能也会检查更新,这些行为不仅会占用带宽,而且会占用cpu资源
- 更新包括驱动下载(windows现在将驱动下载放到了更新中,因此除了自己到官网下载驱动还可以看看system update)傻等着可能不会自动给你装上
- 类似于显卡驱动,声卡驱动(以及DTS音效),都可以在windows update更新得到

## 第二批恢复

### 字体

- hack nerd font(阿里云盘备份)

### 编辑器

- vscode 注意下载system版的而不是user版[Download Visual Studio Code - Mac, Linux, Windows](https://code.visualstudio.com/Download)



### 命令行工具👺

- winget
  - [使用 winget 工具安装和管理应用程序 | Microsoft Learn](https://learn.microsoft.com/zh-CN/windows/package-manager/winget/)
- powershell

- scoop
  
  - 可以先试试`iwr -useb get.scoop.sh | iex`,不行的话开代理`tun`模式
  - [scoopInstaller: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理。 (gitee.com)](https://gitee.com/glsnames/scoop-installer)
  
- python

  - [Download Python | Python.org](https://www.python.org/downloads/)

  - 下载源替换:

    



## 网速问题🎈

- 网速监控软件`trafficMonitor`依赖于:[MS Visual C++ 程序包下载 | Microsoft Learn](https://learn.microsoft.com/zh-CN/cpp/windows/latest-supported-vc-redist?view=msvc-170)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/0f37ffe74f794f4195d83990100a7ad8.png)
  - 默认单位是`Mbps`,不过通常人们更习惯看`MBps`这个单位($MBps=Mbps/8$)

- 如果手机/wifi热点在电脑上很慢(其他设备或热点源本身很快)可能是电脑的问题
  - 比如硬件老化(或受损,可能性较小)等(如果重装前正常,也可能是驱动的问题)
  - 可以考虑手机做USB热点机(现在的手机可以同时链接wifi并作开热点)
  - network band(网络频段)调整(比如从2.4GHz调整到5GHz试试,现在的手机基本都支持)
    - 本人做这个实验的时候在图书馆,各种wifi信号很多,发现切换后确实稳定了不少
  - 另外,热点机本身可能会由于电量过低导致的速率下降的问题,建议电量充足的时候再测试一次.
  - 热点源距离等

## 触摸板问题(touch pad)

###  笔记本一般会提供关闭触摸板的快捷键

- 自带键盘一般是分布在F1~F12上的某个键

- 对于笔记本键盘(或紧凑键盘)一般是配合Fn键,按下,可以切换触摸板状态

###  驱动问题

- 360卫士的扫描有时会给计算机安装不兼容的程序,可能导致笔记本触摸板无法使用
- 您可能需要从主板相关的驱动项目更新或者卸载不兼容的驱动
![在这里插入图片描述](https://img-blog.csdnimg.cn/e5e73ef7074346dd99fc33341676b307.png)











