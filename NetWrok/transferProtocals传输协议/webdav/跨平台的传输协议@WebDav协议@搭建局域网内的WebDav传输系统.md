[toc]

## WebDav

### 协议基本信息

- 来自wikipedia:基于Web的分布式编写和版本控制（英语：Web-based Distributed Authoring and Versioning，缩写：WebDAV）是超文本传输协议（HTTP）的扩展，有利于用户间协同编辑和管理存储在万维网服务器文档。WebDAV由互联网工程任务组的工作组在RFC 4918中定义。
- WebDAV协议为用户在服务器上创建、更改和移动文档提供了一个框架。
- WebDAV协议**最重要的功能**包括作者或修改日期等属性的维护、命名空间管理、集合和覆盖保护。
  - 为属性维护所提供的功能包括创建、删除和查询文件信息等；
  - 命名空间管理处理在服务器名称空间内复制和移动网页的能力；
  - 集合（Collections）处理各种资源的创建、删除和列举；
  - 覆盖保护处理与锁定文件相关的问题。
  - WebDAV协议利用TLS、HTTP摘要认证、XML等技术来满足这些需求。
- 许多现代操作系统为WebDAV提供了内置的客户端支持。



## 专业的webdav协议相关软件搭建WebDav服务👺

- 推荐使用Chfs或Alist,局域网内共享文件变得轻松简单,这些软件还跨平台
- 熟悉计算机的可以用后者,不仅可以把电脑搭成WebDav服务器,也可以把手机搭成Webdav服务器



### 跨平台的第三方软件😊

1. [Introduction | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/)
   - Alist一个名气颇大的存储相关的软件:一个支持多种存储的文件列表程序
   - 不仅可以将本地存储处理成存储服务,还可以集合并挂载各种网盘
   - 可以创建不同用户,分配不同的权限;使用时不同权限的用户登陆管理页面可查看和配置的内容也不同
   - 在自动跳转和页面功能提示方面需要查看官方文档
     - 配置文件里的各个项目在弄清楚前不要轻易改动,容易造成不必要的麻烦,例如ip地址
     - 桌面端和移动端都有Alist软件,跨平台性较好
     - 社区讨论活跃(虽然教程丰富,但很多视频教程都介绍得都很浅,以文档为主)

   - [WebDAV | AList文档 (nn.ci)](https://alist.nn.ci/zh/guide/webdav.html)
   - 使用记录和配置过程中的常见问题
     - [openlist/alist基本用法@文档阅读@挂载网盘@网盘webdav挂载](http://t.csdnimg.cn/5aFS3)

2. [CuteHttpFileServer | iscute.cn](http://iscute.cn/chfs)
   - 提供了windos端的命令行程序和图形界面程序,轻量而且易于配置
   - 但是社区方面就不如Alist,当然,简单易用的软件需要解决的问题往往就比较少
   - 跨平台,但是移动端设备(android等)缺乏
3. [tfcenter](http://www.tfcenter.com.cn/updatelog)
   - 功能比chfs要多,软件也是跨平台的,更新维护中,安装完内有帮助和手册的链接
   - 总得来说也算易于使用,配置用户(用户密码),然后配置共享的目录即可,某些方面比chfs要完善
   - 也可以注册开机自启
   - [tfcenter使用手册 (qq.com)](https://docs.qq.com/doc/DQW14Z1NSb0FSTEhw)



### 小结👺

- 对于web端(浏览器内打开的界面),alist的打包下载(下载文件夹)可能会比chfs复杂一些,需要额外的设置(未来可能会改进)
- 另外,网页内上传的功能alist和chfs都支持,而alist隐藏右下角的展开图标按钮中,而chfs则直观许多
- alist 擅长多端跨平台的体验一致性,而chfs则在网页端上传下载的易用性上会更好
- 当然如果您习惯挂载webdav来使用的话,那么alist则是更强大的,毕竟在访问权限控制和聚合网盘的方面提供了支持

### 共享文件夹/smb

- 本文重点虽然是webdav相关软件和使用的介绍,但是对于挂载和映射操作,我们有其他选择,甚至更合适的选择,就是共享文件夹

- 然而,如果不在乎网页端,那么对于windows系统而言,使用自带的共享文件夹(smb)功能来共享和供其他设备映射挂载网络驱动器是最稳定的,而且不用安装任何额外的软件,会比alist和chfs更加稳定(同样支持直接点播视频和音乐,图片)

### 其他

- [GitHub - hacdias/webdav: Simple Go WebDAV server.](https://github.com/hacdias/webdav)
  - 专门设计支持WebDav的命令行程序(可能停更了)
- [Caddy - The Ultimate Server with Automatic HTTPS (caddyserver.com)](https://caddyserver.com/)
  - candy+webdav:[Module http.handlers.webdav - Caddy Documentation (caddyserver.com)](https://caddyserver.com/docs/modules/http.handlers.webdav)



## windows上配置Webdav(不推荐)

- 虽然我不推荐用windows自带的组件搭webdav服务
- 但是既然操作过一遍,就记录下来

### windows自带组件

- IIS webdav
  - windows自带的服务,启用相关功能后还要进行一系列的配置
  - 而且在WebDav客户端上传到站点的文件大小存在限制问题
  - 总体体验并不好,因此推荐第三方专业软件,灵活而且易于配置

### 启用必要的windows功能

- |                                                              |                                                              |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/01fcb1c3a7e543628af5229b396da118.png) | 勾选WebDAV Publishing时会自动勾选其他选项;但是Security中的Basic Authentication要手动勾选<br />拿不准就都勾选(但是没必要)<br /> |      |

- 勾选完毕后系统开始安装需要的组件和功能,完成后**建议重启**,使得某些配置生效,特别是**Basic Authentication**

### 启动站点管理器IIS

- 在开始菜单中搜索IIS,(**Internet Information Services (IIS) Manager**)

  - |                                                              |                                                              |      |
    | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
    | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/87a993b9f1ee44e58baa78be1683ff98.png) | 里面可能已经由若干站点,建议重新建立一个站点,例如取名为**WebDav** |      |
    | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/0354bc85c8d04a1ab5b1695e080e746a.png) | 这里选择一个路径,作为文件交换站(共享目录,或称**站点根目录**);<br />下面的Binding(绑定http协议保持默认即可);<br />但如果您的电脑运行着其他服务,建议将端口(port)改为其他端口,例如8090等) |      |
    |                                                              |                                                              |      |

### 站点根目录访问权限设置

- |                                                              |                                                              |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/ea51fb53e723430f94dd78e747ea1ec5.png) | 右键站点,选择权限编辑,会调整到目录(文件夹)的属性             |      |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/342b6d26bf67459c9f9225ec5a569424.png) | 选择安全选项卡(security),如果权限不满足需求(通常我们给它在允许(allow)这一列全打勾,方能实现读,写操作) |      |
  |                                                              |                                                              |      |

### 站点的功能设置

|                                                              |                                                              |      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/056ae96e7a484d74ad8886249fc732fd.png) | 点击站点,来到站点功能面板主页,设置3个功能                    |      |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/3879161b8fe146ea90eff7cf9ceb77ad.png) | 验证设置:启用基础验证(basic Authentication);<br />其余可以根据需要都设置为禁用(Disable);<br />开关在Actions面版中选择 |      |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/646914fc5087442f8e4e63baa14d459b.png) | 启用目录浏览功能,在Action栏中切换                            |      |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/95ba644063de4b709422d444d740f496.png) | 启用WebDAV功能,并且添加规则<br />简单起见,可以勾选全用户     |      |

### 端口通行防火墙

- 如果不是使用默认端口,比如改成了8090端口,需要设置windows的防火墙的入站和出站规则

  - 参考[windows@网络防火墙@软件联网控制@netsh advfirewall firewall-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/128438542)
  - [(Windows) 创建出站端口规则 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/security/threat-protection/windows-firewall/create-an-outbound-port-rule)

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/8ef469f2f14e44db89bb95163427a8e3.png) | 配置入站和出站规则                                           |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/2df795dd07d74ead9adadbcd7081f811.png) | 新建规则时,依次选择:端口->输入端口号,例如8090->允许链接->保持默认->为规则起个名字(随意,例如入站规则为`WebDavIn`;出站规则名取为`WebDavOut`) |      |

### IMME文件类型(文件后缀)

- 通常不需要设置
- 有时某些格式的文件,例如`.rmvb`视频文件无法直接被WebDav客户端直接点播,这时可能会出错,但是可以将其下载下来播放



## 其他设备登录和访问本机的WebDav服务站点😊

- 客户端有多种选择,对于Android设备,可以用 
  - **Cx 文件管理器**(对于过大的文件可能无法上传)
  - **Es 文件管理器**(功能复杂和界面设计的复杂了一些)
- 账号密码就是平时登录windows桌面的账号密码
- 也可以考虑在系统上新建一个用户账户(本地账户),专门用来登录WebDav服务
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/9422892ecb174ba2be6972ff9820d184.png)

### FAQ

#### 文件过大无法上传

- 稍微大点的文件可能就无法顺利传输到WebDav站点上
- 其他设备倒是可以从webdav站点下载大文件(可能限制在4GB)





## WebDav协议小结

### 优点

- 像常用的txt,mp4,png这类文件可以直接打开而不需要下载再打开,甚至允许在线修改自动同步更新文件,这就是WebDav挂载的厉害之处
- 比之于FTP,SMB,都无法做到这一点
- 许多网盘支持WebDav协议,能够允许用户将网盘挂载到本地,仿佛将网盘当作本地盘一样操作(部分操作),例如坚果云,dropbox
- 某些性能较差的路由器ftp,smb的传输速度很慢,但是用WebDav可能就比较快
  - 我的某次试验中,路由器很差,ftp,smb不超过10Mb/s,但是用WebDav可以达到30Mb/s
- 和ftp,smb类似,配置一次后,几乎不需要再配置,客户端一般都支持链接记录,下次链接直接就连上,windows重启后服务会自动运行

### 缺点

- 直接用windows自带的服务配置步骤比较繁琐
- 可以靠用其他软件创建服务

## refs

- [Windows有没有什么搭建webdav服务的好方法？](https://www.zhihu.com/question/387913764/answer/2885725453)
- vedio:[搭建webDAV@免费低配nas/内网视频资源中心](https://b23.tv/reApRhO) 
- blog:[windows开启WebDAV服务及其配置](https://cornradio.github.io/hugo/posts/2023-02-24windows开启webdav/)
- 官方文档
  - [Installing and Configuring Web Deploy on IIS 8.0 or Later | Microsoft Learn](https://learn.microsoft.com/en-us/iis/install/installing-publishing-technologies/installing-and-configuring-web-deploy-on-iis-80-or-later)
    - [在 IIS 8.0 或更高版本上安装和配置 Web 部署 | Microsoft Learn](https://learn.microsoft.com/zh-cn/iis/install/installing-publishing-technologies/installing-and-configuring-web-deploy-on-iis-80-or-later)
    - [在 IIS 7 及更高版本上安装和配置 WebDAV | Microsoft Learn](https://learn.microsoft.com/zh-cn/iis/install/installing-publishing-technologies/installing-and-configuring-webdav-on-iis)





