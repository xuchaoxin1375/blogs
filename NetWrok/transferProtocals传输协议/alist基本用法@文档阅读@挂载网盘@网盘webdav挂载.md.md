[toc]

## alist官网

### alist网站风格说明

- 官网的各个页面大多是以目录列表的形式作为一级界面
- 点击列表中的各个条目打开详情(一个问题是一般的可点击条目(文字)有下划线,或者显示蓝色字体,而alist官网就不按惯例来,需要将鼠标悬停在目录列表上才显示为可点击链接的风格,阅读的时候要注意一下)
- 鉴于此,本文对alist的基本使用稍作整理

### alist软件版本

- 对于windows,分为免费的命令行版本和收费的图形界面版本
- 通常使用命令行版本就够用了,稍微懂命令行就可以操作,基础配置算简单
- [安装 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/install/)

## 安装和启动使用必看文档👺

- [手动安装 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/install/manual.html)
  - 介绍不同平台的安装和启动的方法

- 为可执行程序`alist.exe`配置Path变量或者取别名
- 执行`alist server`初始化
- 根据需要可以修改密码:`alist admin set <new_password>`
- alist会默认在5244端口启动服务

### alist for android版本

- [Releases (github.com)](https://github.com/jing332/AListFlutter/releases)
- 加速下载:[下载速度慢？教你如何高速下载 github release！ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/521472595)

### 启动alist网页

- 浏览器中输入:`http:\\localhost:5244`
- 登录刚才命令行给出的用户和账号(账号名`admin`,密码默认是随机密码,可以自行指定)
- 启动配置页面,点击管理(manage),进入配置页面
- 添加存储(storage)

## 典型用例@挂载阿里云盘open

- [阿里云盘 Open | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/drivers/aliyundrive_open.html#刷新令牌)

#### 获取阿里云令牌

- [Get Aliyundrive Refresh Token ](https://alist.nn.ci/tool/aliyundrive/request.html)
  - 登录阿里云盘账号,点击授权,可以获得令牌
  - 或者用手机扫码,授权获取令牌



### 主页检查挂载情况

- 本地alist服务器的主页为:http://localhost:5244/
  - 也可以点击配置页面的home(主页)跳转到挂载列表

## 常用页面

### 以配置挂载列表

- [Home | AList](http://localhost:5244/)

### 管理配置页面

- [Profile | AList Manage](http://localhost:5244/@manage)

## 配置文件和目录👺

- 在命令行中,运行`alist server`会检查当前**工作目录**(由`pwd`命令返回的目录)是否存在配置文件(用户密码,已挂载过的网盘等)
- 如果没有,则会在当前工作目录创建`data`目录并初始化创建必要的文件
- 如果每次都在不同的目录上启动alist,会导致数据无法自动恢复,即每次需要登录alist都无法保持上一次的配置
- 如果是通过创建快捷方式,通过快捷方式的方式启动,则可以确保每次alist家目录是一致的
- 如果要在某个脚本中使用alist,建议使用`cd <alist_home>`,使得工作目录定位到alist家目录,然后根据需要可以返回或跳转到其他目录

## FAQ可能遇到的错误

- `failed get objs: failed to list objs: InvalidParameter.ParentFileId:The input parameter parent_file_id is not valid. for cpp path domain parent_file_id is required`

- 路径问题,考虑删除旧配置重新添加

### 检查服务重启前后alist的动作(自动挂载)

- 初次配置启动服务

  ```bash
  PS C:\Users\cxxu\Desktop> alist server
  INFO[2024-01-13 20:02:54] reading config file: data\config.json
  INFO[2024-01-13 20:02:54] load config from env with prefix: ALIST_
  INFO[2024-01-13 20:02:54] init logrus...
  WARN[2024-01-13 20:02:54] init tool aria2 failed: failed get aria2 version: Post "http://localhost:6800/jsonrpc": dial tcp [::1]:6800: connectex: No connection could be made because the target machine actively refused it.
  INFO[2024-01-13 20:02:54] init tool SimpleHttp success: ok
  WARN[2024-01-13 20:02:54] init tool qBittorrent failed: Post "http://localhost:8080/api/v2/auth/login": dial tcp [::1]:8080: connectex: No connection could be made because the target machine actively refused it.
  INFO[2024-01-13 20:02:54] start HTTP server @ 0.0.0.0:5244
  INFO[2024-01-13 20:25:47] Shutdown server...
  INFO[2024-01-13 20:25:47] Server exit
  
  ```

- 成功挂在某个网盘后(以阿里云盘opne)为例,再次启动服务,输出:

  - ```bash
    
    PS C:\Users\cxxu\Desktop> alist server
    INFO[2024-01-13 20:25:52] reading config file: data\config.json
    INFO[2024-01-13 20:25:52] load config from env with prefix: ALIST_
    INFO[2024-01-13 20:25:52] init logrus...
    WARN[2024-01-13 20:25:52] init tool aria2 failed: failed get aria2 version: Post "http://localhost:6800/jsonrpc": dial tcp [::1]:6800: connectex: No connection could be made because the target machine actively refused it.
    INFO[2024-01-13 20:25:52] init tool SimpleHttp success: ok
    WARN[2024-01-13 20:25:52] init tool qBittorrent failed: Post "http://localhost:8080/api/v2/auth/login": dial tcp [::1]:8080: connectex: No connection could be made because the target machine actively refused it.
    INFO[2024-01-13 20:25:52] start HTTP server @ 0.0.0.0:5244
    INFO[2024-01-13 20:25:52] success load storage: [/AliyunDrive], driver: [AliyundriveOpen]
    ```

  - 可以发现,alist可以自动将上次挂载的云盘重新挂载


### alist token问题

- ```bash
  PS 🕰️18:01:06 [C:\share] 🔋100% alist admin set 1212
  INFO[2024-02-10 18:01:13] reading config file: data\config.json
  INFO[2024-02-10 18:01:13] load config from env with prefix: ALIST_
  INFO[2024-02-10 18:01:13] init logrus...
  INFO[2024-02-10 18:01:13] admin user has been updated:
  INFO[2024-02-10 18:01:13] username: admin
  INFO[2024-02-10 18:01:13] password: 12345...
  ERRO[2024-02-10 18:01:13] [del_user_cache_online] error: that's not even a token
  
  ```

- 尝试关闭所有alist进程

  - 用`ps alist*`检查是否有`alist`进程,如果有,则执行`ps alist|stop`,结束相关进程

- 重新设置`admin`密码

  - ```
    PS 🕰️18:01:13 [C:\share] 🔋100% alist admin set 1212
    INFO[2024-02-10 18:02:07] reading config file: data\config.json
    INFO[2024-02-10 18:02:07] load config from env with prefix: ALIST_
    INFO[2024-02-10 18:02:07] init logrus...
    INFO[2024-02-10 18:02:07] admin user has been updated:
    INFO[2024-02-10 18:02:07] username: admin
    INFO[2024-02-10 18:02:07] password: 1212
    WARN[2024-02-10 18:02:07] [del_user_cache_online] failed: Post "http://localhost:5244/api/admin/user/del_cache?username=admin": dial tcp [::1]:5244: connectex: No connection could be made because the target machine actively refused it.
    ```

  - 抛出了一个`WARN`,可以打开浏览器,刷新`alist`管理网页,检查是否修改成功

### webDav链接和配置👺

[WebDAV | AList文档WebDav (nn.ci)](https://alist.nn.ci/zh/guide/webdav.html#webdav-配置)

- [WebDAV | 获取已添加网盘的webdav链接配置 (nn.ci)](https://alist.nn.ci/zh/guide/webdav.html#webdav-配置)
- [WebDAV |挂载填写实例](https://alist.nn.ci/zh/guide/webdav.html#可以用来挂载webdav的软件)

## 开机自动运行配置(守护进程)👺

- [守护进程开机自启动 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/install/manual.html#守护进程)
- [windows配置开机自启动软件或脚本-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/136098694?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"136098694"%2C"source"%3A"xuchaoxin1375"})

## 挂载到资源管理器(模拟本地磁盘分区)👺

- [windows@映射磁盘驱动器若干方法-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/136093467)
  - 注意对于http协议需要修改注册表(默认开放https的webdav连接)

- 也可以考虑用第三方软件挂载,例如RailDrive,rclone等

## refs

- [Alist保姆级搭建教程_alist搭建教程-CSDN博客](https://blog.csdn.net/BG1230521/article/details/129786880)





