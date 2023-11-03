[toc]



# abstract

- 不使用数据线的情况下,无线地执行:

  - windows访问android文件

  - android访问桌面系统上的文件

- 本文将涉及两种协议:ftp,http的应用

- 高级root用户:

  - android 手机同通过安装lsposed框架和模块来固定生成的ftp地址,从而避免后续手动输入ip达到一键访问手机资源的便捷效果


  


# windows浏览android文件

## 环境准备

###  客户端软件
- android手机自带的文件管理器通常带有远程管理的功能，如果没有，可以下载支持该功能的app,比如

  - [MT管理器(bin.mt.plus) - 应用 - 酷安 (coolapk.com)](https://www.coolapk.com/apk/bin.mt.plus)

  - [ES文件浏览器(com.estrongs.android.pop) - 应用 - 酷安 (coolapk.com)](https://www.coolapk.com/apk/com.estrongs.android.pop)
    - 免费版够用
    - 也可以到论坛下找特殊版本

- windows端不需要额外的软件,只需要系统自带的资源管理器`explorer`

### 无线网络链接

- 只要能使得两类设备**链接在同一个无线网路下**即可,不需要能够访问公网,局域网足够
- 也不一定需要路由器的参与,只要手机/电脑中的一方能够创建热点供另一方链接即可

### 步骤

- 不同的客户端具体操作可能有些许差别
- 但总的流程是一样的
- 这里以`MT`管理器为例,任何不过时的android都可以安装
- 打开`MT`的远程管理,点击启动服务,会给出一个`<ftp地址>`,例如`ftp://192.168.137.41:2121`,要以自己的显示为主
  - 这说明此时手机的角色成为了一个`ftp`服务器,android上的文件资源可以被作为客户端的windwos访问
- 打开windows的`cmd`或者`powershell`,输入:`explorer <ftp地址>`,回车即可(这里的`<ftp地址>`)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/cc85b7400b474ab2b201478a06a7d6d7.png)

### 其他方法

- windows上也可以直接通过资源管理器中输入`<ftp地址>`来打开手机文件浏览
- 不过我还是推荐用命令行的方式进入
  - 因为直接在资源管理器中输入`ftp地址`,如果输错,那么资源管理器甚至系统可能要卡死一段时间,这个体验不好
  - 如果用命令行输错了地址,那么后台可能会运行一个无法响应的的资源管理器,但是不影响前


# 手机浏览电脑文件

## 公网

- 借助腾讯QQ(可以公网远程)

## 局域网

### everything

- 局域网方法推荐(比较简单的)方法:[使用everything开启ftp服务器 (baidu.com)](https://jingyan.baidu.com/article/36d6ed1f0d5bd15acf4883c2.html)
  - windwos端的everything,如果没有路由器,则需要电脑(笔记本)开热点了(mobile hotspot)
  - android端的ES文件管理器,可以扫描windows上的FTP服务器
- windows自带的方式步骤比较繁琐,不推荐

### python http.server

- 电脑端下载python安装
  - 执行`python -m http.server`将桌面系统(windows/linux通用)建立http服务器
    - 运行成功则给出端口,通常是8000端口
  
    - 使用手册
  
      ```
      PS D:\repos\scripts> python -m http.server -h
      usage: server.py [-h] [--cgi] [--bind ADDRESS] [--directory DIRECTORY] [port]
      
      positional arguments:
        port                  specify alternate port (default: 8000)
      
      options:
        -h, --help            show this help message and exit
        --cgi                 run as CGI server
        --bind ADDRESS, -b ADDRESS
                              specify alternate bind address (default: all interfaces)
        --directory DIRECTORY, -d DIRECTORY
                              specify alternate directory (default: current directory)
      ```
  
    - 其中`port`可以指定端口,通常默认就行,除非无法创建或者需要保留
  
    - `--directory` 可以指定需要共享的根目录,默认是当前目录,例如:
  
      - ` python.exe -m http.server --directory C:\Users\xxx\desktop\`将电脑面设为http服务器根目录
  
- 手机端可以用浏览器访问,效果和电脑上浏览器访问效果类似

  - 注意手机访问的地址需要通过ipconfig查询
  - 例如`http://192.168.97.165:8000`,通常可以省略协议`http://`,直接输入`<ip>地址:端口`

- ![http.server](https://img-blog.csdnimg.cn/7d53eafed3844e98a61377b5183f43f0.png)

### 配置静态IP

- 假设电脑链接手机的热点,那么电脑(windwos)静态ip后手机将无法访问电脑,而`DHCP`分配的地址则可以访问

- 通过路由器配置应该可以做到,但我未尝试

  

# 高级:固定android设备IP

- 这部分是给高级root用户参考的(如果您不了解如何获取或者不是刚需,可跳过)
- 但是如果您恰好有这个权限,经过下面的一番配置,那确实很方便,从此想要无线传输文件只需要点几个开关就能建立通道,美滋滋

- android 手机同通过安装lsposed框架和模块来固定生成的ftp地址,从而避免后续手动输入ip达到一键访问手机资源的便捷效果

## 准备

1. 所需权限:root权限(可通过刷入magisk或magisk修补后的boot.img或init_boot.img来获取)
2. 所需框架软件:[LSposed-release](https://github.com/LSPosed/LSPosed/releases/)
3. 模块:[GitHub - XhyEax/SoftApHelper: SoftAp static server IP(v4) for Android P-T (Xposed)](https://github.com/XhyEax/SoftApHelper)
   - 网站提供了2种包,一种事将ap固定为192.168.43.1;另一个是固定为192.168.1.1(我选择这个)
4. 安装上述软件(模块),并且正确打开激活模块的开关
5. 重启(或者软重启)android系统,使得模块生效

### 检查模块是否生效

- 手机端自查:

  - 用`MT`管理器的模拟终端输入`ifconfig`查看是否出现`192.168.1.1`;如果有则成功
  - 或者`MT`管理器种打开远程管理,看ip是否为`192.168.1.1`;如果是,则成功(默认端口是`2121`,这个端口是可以直接通过MT修改,后续讨论种假设端口是`2121`,如果被更改,以自己的为准)

- 电脑ping:

  - ```
    PS C:\Users\cxxu\Desktop> ping 192.168.1.1
    
    Pinging 192.168.1.1 with 32 bytes of data:
    Reply from 192.168.1.1: bytes=32 time=5ms TTL=64
    Reply from 192.168.1.1: bytes=32 time=6ms TTL=64
    Reply from 192.168.1.1: bytes=32 time=6ms TTL=64
    Reply from 192.168.1.1: bytes=32 time=6ms TTL=64
    
    ```

    

## windows 访问ftp服务器快捷方式

- 创建快速访问ftp资源服务器的方式有多种,这种方式适合访问的ftp服务器ip固定的情况
- 下面的方式中,都十分方便,都是一次性配置后续不再配置,一劳永逸

### 命令行方式

- 编写脚本或函数(命令行):例如,可以配置一个powershell函数,`explorer ftp://192.168.1.1:2121`

  - ```powershell
    function ftpAndroid{
    	explorer ftp://192.168.1.1:2121
    }
    ```

### 双击启动方式

#### 普通快捷方式

- 创建快捷方式图标:创建快捷方式图标可以双击启动,方式也有多种,最简单的是
  - 桌面右键,选择新建快捷方式
  - 输入`explorer ftp://192.168.1.1:2121`
  - 一直确认下去即可,图标将是一个资源管理器的图标,双击后可以打开

#### 映射新的网络位置

- 添加网路位置(映射新位置)
  - [refs links](https://jingyan.baidu.com/article/ff42efa9f5f604c19f220245.html)
  - 右键我的电脑,添加新的网络位置(add Network Location);或者资源管理器中的网络图标右键,映射网络驱动器(map network drive),在进入(connect to a web site)同样可以添加新的网络位置
  - 将`ftp://192.168.1.1:2121`完整的链接填入,一直点击确认即可

