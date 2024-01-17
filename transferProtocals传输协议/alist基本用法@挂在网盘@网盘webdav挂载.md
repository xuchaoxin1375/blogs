[toc]

## alist官网和文档



## 初始化alist

### alist网站风格说明

- 官网的各个页面大多是以目录列表的形式作为一级界面
- 点击列表中的各个条目打开详情(一个问题是一般的可点击条目(文字)有下划线,或者显示蓝色字体,而alist官网就不按惯例来,需要将鼠标悬停在目录列表上才显示为可点击链接的风格,阅读的时候要注意一下)

### alist软件版本

- 对于windows,分为免费的命令行版本和收费的图形界面版本
- 通常使用命令行版本就够用了,稍微懂命令行就可以操作,基础配置算简单
- [安装 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/install/)

## 安装和启动使用必看文档

- [手动安装 | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/install/manual.html)
  - 介绍不同平台的安装和启动的方法

- 为可执行程序`alist.exe`配置Path变量或者取别名
- 执行`alist server`初始化
- 根据需要可以修改密码:`alist admin set <new_password>`
- alist会默认在5244端口启动服务

### 启动alist网页

- 浏览器中输入:`http:\\localhost:5244`
- 登录刚才命令行给出的用户和账号(账号名`admin`,密码默认是随机密码,可以自行指定)
- 启动配置页面,点击管理(manage),进入配置页面
- 添加存储(storage)

### 挂载阿里云盘open

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

### FAQ可能遇到的错误

- `failed get objs: failed to list objs: InvalidParameter.ParentFileId:The input parameter parent_file_id is not valid. for cpp path domain parent_file_id is required`

- 路径问题,考虑删除旧配置重新添加

### 检查服务重启前后alist的动作

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

### webDav链接和配置

[WebDAV | AList文档WebDav (nn.ci)](https://alist.nn.ci/zh/guide/webdav.html#webdav-配置)

- [WebDAV | 获取已添加网盘的webdav链接配置 (nn.ci)](https://alist.nn.ci/zh/guide/webdav.html#webdav-配置)
- [WebDAV |挂在填写实例](https://alist.nn.ci/zh/guide/webdav.html#可以用来挂载webdav的软件)

## refs

- [Alist保姆级搭建教程_alist搭建教程-CSDN博客](https://blog.csdn.net/BG1230521/article/details/129786880)





