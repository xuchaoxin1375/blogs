[toc]



## Dhizuku

- 在Android操作系统中，设备拥有者权限（Device Owner）和ROOT权限是两种不同的权限类型，它们各自有不同的应用场景和限制。(非root权限下的最高权限,仅次于root权限;尽管设备拥有者权限听起来和强大,但是仍然无法和root权限相提并论,但我们可以用它来做一些事情)
- 设备拥有者权限:
  - Android系统中的一个特殊权限，通常用于企业或教育环境中的设备管理。当一个应用被设置为设备拥有者时，它将获得对设备的广泛控制权，包括：
  - **配置和锁定屏幕**：设备拥有者可以设置锁屏密码、安装应用、设置网络等。
  - **管理应用**：设备拥有者可以决定哪些应用可以安装在设备上，也可以远程卸载应用。
  - **数据安全**：设备拥有者可以设置数据加密、远程擦除数据等安全措施。
    设备拥有者权限的主要优点是它提供了一种在不获取ROOT权限的情况下管理设备的方法。这对于需要严格控制设备使用情况的企业或教育机构来说非常有用。然而，设备拥有者权限通常只能在特定的Android版本和设备上设置，且设置过程较为复杂。
- ROOT权限：
  - ROOT权限是指完全控制Android设备的最高权限。
  - 获取ROOT权限后，用户可以访问和修改系统的任何部分，包括安装定制ROM、删除系统应用、访问受保护的系统文件等。
    ROOT权限的主要优势是提供了最大程度的自由和控制权，允许用户进行深度定制和优化。然而，获取ROOT权限也存在一些风险和缺点：
  - **安全风险**：ROOT权限可能使设备更容易受到恶意软件和病毒的攻击。
  - **稳定性问题**：修改系统文件可能会导致系统不稳定甚至崩溃。
  - **保修问题**：获取ROOT权限通常会违反设备的保修条款。
    总结来说，设备拥有者权限和ROOT权限各有优势和限制。设备拥有者权限适用于需要集中管理设备的环境，而ROOT权限则适用于需要完全控制设备的用户。然而，无论是设备拥有者权限还是ROOT权限，都需要谨慎使用，以避免潜在的风险和问题。

### shizuku

- Shizuku 是一款用于安卓设备的高级权限管理工具，它允许应用直接使用 ADB（Android Debug Bridge）权限，从而进行一些需要更高权限的操作。这个软件特别适用于那些没有解锁 Bootloader 或获取 ROOT 权限的安卓设备。Shizuku 提供了一种无需 ROOT 权限即可进行系统级操作的解决方案。
- Shizuku 的工作原理是，在电脑上给 Shizuku 服务进程授予 ADB 权限后，它可以成为一个 ADB 权限管理器。通过这个管理器，Shizuku 可以给那些需要 ADB 权限来实现某些功能的应用进行授权。例如，可以用来冻结应用、管理后台进程、限制应用权限等。Shizuku 的优点在于，它简化了授权过程，省去了使用命令行的麻烦，并且避免了不同应用激活时需要多次授权的问题。

- Shizuku 支持多种启动方式，包括通过 ROOT 启动、通过无线调试启动（适用于 Android 11 或以上版本），以及通过连接电脑启动（适用于未 ROOT 且运行 Android 10 及以下版本的设备）。通过无线调试启动的方式不需要连接电脑，但每次重启后都需要重新进行启动步骤。而通过连接电脑启动的方式则需要使用数据线将手机连接到电脑，并按照一系列步骤来激活 Shizuku。

- Shizuku 的使用相对简单，对于已经支持 Shizuku 的软件，通常可以在软件中直接切换到 Shizuku 工作模式。目前支持 Shizuku 的软件包括各类系统优化工具、应用管理器、权限管理工具等。

### Dhizuku

- 参考Shizuku的设计思想，分享 DeviceOwner (设备所有者) 权限给其余应用
- 相对于shizuku是新出的权限类软件(api)

### 设备权限

- [设备所有者 (Device Owner)](https://jesse205.github.io/FlashAndroidDevicesGuidelines/normal/danger_permissions/device_owner/)

### 相关资源和教程

- 这部分资源是Dhizuku仓库发布和产生的
  - [如何激活Dhizuku · iamr0s/Dhizuku · Discussion #16 · GitHub](https://github.com/iamr0s/Dhizuku/discussions/16)
  - [GitHub - iamr0s/Dhizuku: A Android Application for share DeviceOwner](https://github.com/iamr0s/Dhizuku)
  
- 考虑到有些用户可能无法打开相关网页,可以到论坛里(酷安这类的论坛里)找帖子
- 我这里记录一些操作过程中遇到的一些问题以及配置成功后将Dhizuku应用在哪里

### 激活过程

- 激活Dhizuku的大致步骤是

  - 删除手机上的所有账户,这个可以借助第三方app [Releases · iamr0s/AndroidAccounts (github.com)](https://github.com/iamr0s/AndroidAccounts/releases)
  - 然后有些软件账户无法用accout删除,那么就冻结它,可以用 雹:[Release 雹 Hail v1.8.0 · aistra0528/Hail (github.com)](https://github.com/aistra0528/Hail/releases/tag/v1.8.0),其他冻结类软件也可以,只是accout和雹两个操作起来顺一些(软件有点bug,列表为空时重开应用)
  - 最后是系统账户,例如vivo设备要退出vivo账号
  - 最后回到dhizuku,开始激活(操作前建议重启手机,否则可能会失败)
    - 如果有shizuku,就用shizuku授权
    - 否则用adb 命令来激活
  - 如果直接激活失败,可以重启后在尝试(本人推出账号后没有重启手机,两种方式都激活失败,后来重启后用adb命令激活成功,shizuku方式自测)

- 获取完设备所有者权限后,可以恢复其他软件账号的登录,以及被冻结的软件

  



### 资源下载和查看

- 尽管我可以提供安装包,但是鉴于软件版本是不断更新的,建议到官网下载,或者到论坛下载

  - github上的资源有时下载不下来,有条件可以使用代理下载

  - 没有的也可以上网搜索:`github release 加速下载`或`github 加速`,找到加速下载的方法,比如镜像下载(提供这类服务的网站容易失效,这里就不放具体的连接了)

  - 有些论坛(酷安等)和第三方应用商店可能会提供(分享)相关的软件


## 利用Dhizuku设备管理员权限授权第三方安装器

- OriginOs对于安装包安装器作了严格限制,想要使用第三方安装器安装apk等包是困难的
- 但是经过我的尝试,如果能够完整激活Dhizuku,然后将Dhizuku授权给支持设备管理员权限的第三方安装组件,就可以代替OriginOs默认的安装器
- 例如使用`R-安装组件`:[Releases  (github.com)](https://github.com/Xposed-Modules-Repo/com.yxer.compo.module/releases)
  - 该安装器在root的机器十分方便
  - 如果没有root使用设备管理员权限(Dhizuku)也是不错的
  - shizuku对于一般android系统是管用的,但是OriginOS就不管用,而且OriginOs难以root,只能考虑Dhizuku

### Note

- Dhizuku授权的方式替换默认安装器后,第三方安装器安装玩软件后,系统会提示`由管理员安装/更新软件包`
- 然而设备管理员的存在会导致多开遇到问题,例如OriginOs上的应用躲开将无法生效;但是创建新用户还是可以的,可以考虑手机上新建一个非机主用户来躲开软件,比如微信
- 但如果您不需要用到多开,那么可以考虑用Dhizuku来实现第三方安装器安装软件

- 这个方法在OriginOs4上实验成功,但是不保证未来的OriginOs能够继续生效

### FAQ

- 使用设备管理员权限是一把双刃剑,可以带来一定的便利,也会引入不便
- 例如除了软件多开,一些软件也会受影响,例如炼妖壶等不支持设备管理员的存在,而无法直接正常工作



