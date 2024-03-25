[toc]

## sandboxie

### 文档

- [Sandboxie documentation | Sandboxie Documentation (sandboxie-plus.github.io)](https://sandboxie-plus.github.io/sandboxie-docs/)
- 命令行[Start Command Line | Sandboxie-Plus](https://sandboxie-plus.com/sandboxie/startcommandline/)

### 下载

- [Downloads | Sandboxie-Plus](https://sandboxie-plus.com/downloads/)
- [Release Release  sandboxie-plus/Sandboxie · GitHub](https://github.com/sandboxie-plus/Sandboxie/releases/tag/v1.12.9)

- 软件的便携性

  - [Portable Sandbox | Sandboxie Documentation (sandboxie-plus.github.io)](https://sandboxie-plus.github.io/sandboxie-docs/Content/PortableSandbox.html)

  - 在安装时有一选项是`Extract all files to directory for portable use`,进行便携式安装



## 初始配置和启动

### 安装版

- 安装版使用见文档[Getting Started | Sandboxie Documentation (sandboxie-plus.github.io)](https://sandboxie-plus.github.io/sandboxie-docs/Content/GettingStarted.html)

- 普通使用建议用安装版,许多教程是基于安装版介绍(便携式安装后效果和安装版不完全相同)


### 便携版

- [Instructions for launching Sandboxie Plus, especially portable mode · sandboxie-plus/Sandboxie · Discussion #1752 · GitHub](https://github.com/sandboxie-plus/Sandboxie/discussions/1752)

- 对于便携版,进入安装目录,执行`sandMan.exe`

  - 文件夹中的可执行文件有很多,

  - ```bash
    PS [C:\exes\Sandboxie-Plus] ls *exe
    
            Directory: C:\exes\Sandboxie-Plus
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---          2/6/2024  10:06 AM         182736 󰣆  ImBox.exe
    -a---          2/6/2024  10:06 AM         216016 󰣆  KmdUtil.exe
    -a---          2/6/2024  10:06 AM         119248 󰣆  SandboxieBITS.exe
    -a---          2/6/2024  10:06 AM         151504 󰣆  SandboxieCrypto.exe
    -a---          2/6/2024  10:06 AM         154064 󰣆  SandboxieDcomLaunch.exe
    -a---          2/6/2024  10:06 AM         168912 󰣆  SandboxieRpcSs.exe
    -a---          2/6/2024  10:06 AM         122320 󰣆  SandboxieWUAU.exe
    -a---          2/6/2024  10:06 AM        3030992 󰣆  SandMan.exe
    -a---          2/6/2024  10:06 AM        3405264 󰣆  SbieCtrl.exe
    -a---          2/6/2024  10:06 AM         151504 󰣆  SbieIni.exe
    -a---          2/6/2024  10:07 AM         410576 󰣆  SbieSvc.exe
    -a---          2/6/2024  10:07 AM         336848 󰣆  Start.exe
    -a---          2/6/2024  10:07 AM         181200 󰣆  UpdUtil.exe
    ```

  - 初次启动,会让你执行简单的配置,包括授权以及沙盒位置的确认

- 您可以考虑启用`sandboxie control`,但是对于便携安装的版本，建议只是使用sandMan，这是新UI版本

- 当然前者也可以用,有些功能sandMan没有但是SbieCtrl有,例如设置沙盒(例如让沙盒中运行的程序窗格边框的设置(建议设置为始终显示边框))

## sandbox control

- sandboxie的基本程序,基本上围绕着它进行操作
  - [Sandboxie Control | Sandboxie Documentation (sandboxie-plus.github.io)](https://sandboxie-plus.github.io/sandboxie-docs/Content/SandboxieControl.html)
- 以下简称其为`SbieCtrl.exe`或`sbct`

### 手动启动sandbox control

- 有时候可能只启动了sandbox-plus程序,例如直接从命令行通过sandboxie 的start启动软件,这时候可能不会自动打开`sandbox control`,需要手动打开

- 找到软件目录中的`SbieCtrl.exe`执行
  - 可以用命令行或创建快捷方式双击运行

## 在沙盒中启动windows程序

### GUI方式启动

- [Getting Started Part Three | Sandboxie Documentation (sandboxie-plus.github.io)](https://sandboxie-plus.github.io/sandboxie-docs/Content/GettingStartedPartThree.html)

- sandboxie默认有一个沙盒,名称为Defaultbox
  - 通常只需要这一个沙盒就够了(也可以)
- 经典的方式是**右键sbct**,选择一个沙盒(比如Defaultbox),选择
  - `Run any program`(输入软件路径,如果是存在于path变量的路径,可以只输入软件名字)
  - 或者`menu`,从windows开始菜单启动软件)

### 命令行方式启动

- [Start Command Line | Sandboxie-Plus](https://sandboxie-plus.com/sandboxie/startcommandline/#start-programs)

### 从沙盒中导出文件

- [Getting Started Part Four | Sandboxie Documentation (sandboxie-plus.github.io)](https://sandboxie-plus.github.io/sandboxie-docs/Content/GettingStartedPartFour.html)

## 将软件安装进沙盒

- 沙盒的一个特点是隔离,因此将软件安装入沙盒而不在系统上直接安装也是一个常用操作,而不仅仅是多开已经安装在系统上的软件
- 软件的安装包也是一个可执行的程序,因此使用方法也是选择一个一创建的沙盒,然后运行安装包程序
- 如果是安装版沙盒,可以右键待测试的安装包.用沙盒运行安装,比如安装个迅雷下载

## 沙盒的用途👺

### 程序多开

- 利用沙盒可以多开程序,例如多开**微信**

### 微信多开👺

- sandboxie就可以多开大多数程序
- 虽然微信本身没有明显的支持多开,网路上有许多开微信的方式,
  - 比如用一段脚本快速打开多个微信登录窗口
  - 这种方法的一个明显问题就是多开前必须关闭所有微信窗口(如果已经登录账号需要退出,然后多开)
  - 推出登录后想要重新登录,除了最后一个退出的微信,再次登录其他账号往往要重新扫码,很不方便
- 而使用sandboxie可以不需要关掉已经登录的微信,当然也会各自保留上一次登录的账号
- 微信是可以用sandboxie多开的,用文档介绍的方法就可以多开微信
  - 这里介绍创建快捷方式,使得多开微信变得便捷

#### 命令行方式

- cmd方式:`start.exe wechat.exe`,分别将

  - `start.exe`替换sandboxie中start.exe路径
  - `wechat.exe`替换为微信路径
  - 将替换后的路径各自加上引号,最终命令**形如**(替换为自己的实际情况)`"C:\exes\sandboxie-plus\start.exe" "C:\Program Files\Tencent\WeChat\wechat.exe"`
  - 可以将创建为:脚本或快捷方式,以后双击就可以多开微信

- powershell方式:

  - 与cmd略有不同,在前面加一个`.`号即可

    - ```powershell
      PS> . "C:\exes\sandboxie-plus\start.exe" "C:\Program Files\Tencent\WeChat\wechat.exe"
      ```

  - 可以配置相关的函数,别名等,也同样可以创建为脚本或快捷方式

- Note:关于脚本创建和快捷方式创建是基本操作,这里不赘述,另见它文(或者问AI大模型)

### 运行便携版的浏览器

- 比如当前的edge版本被无意间更新了,则我们可以考虑使用免安装的浏览器版本(比如仍然选择edge浏览器)
- 但是有的免安装浏览器点击启动后会跳转到系统的edge,这时候考虑用沙盒来运行免安装的edge

## 报错

### 软件干扰沙盒引起报错

- 某些软件会引起沙盒的运行报错,例如某些桌面版的**微信输入法**(wetype),会导致沙盒启动某个程序时报错
- 虽然我们可以忽略这些报错,但是很影响体验(可以将输入法切换为系统自带输入法
- 停用微信输入法在系统输入法(IME)列表中的位置)
- 可以修改系统默认输入法来将微信输入法在列表中的优先级下调
  - `Time&language`->`typing`->`Advanced keyboard settings`

### 部分软件不兼容隔离安装导致异常

- 例如低于系统上已经安装的edge版本想要按照入沙盒可能无法顺利安装(卡住不动)
- 又比如有的powertoys版本安装近沙盒会服务无法连接等异常,而且安装地十分缓慢

##  refs

- [windows@电脑版微信多开若干方法-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/136075606)
- [同时开N个微信不成问题 (zhihu.com)](https://zhuanlan.zhihu.com/p/132613510)





