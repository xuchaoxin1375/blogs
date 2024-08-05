[toc]



## Mixplorer

Mixplorer文件管理器是一款功能丰富的文件管理软件,并提供了额外的功能,操作响应流畅

- [MiXplorer](https://mixplorer.com/)
- [GitHub - Magisk-Modules-Alt-Repo/MiXplorer: This package has born as personal-use purpose, just grouping all the features it provides, in order to simplify the installation/update process, making MiXplorer a full "all-in-one" in one shot...](https://github.com/Magisk-Modules-Alt-Repo/MiXplorer?tab=readme-ov-file)

### 其他文件管理器推荐

- [NextApp | FX File Explorer](http://www.nextapp.com/fx/)
  - 软件内自带使用文档
  - 用它建立http/webdav server界面美观,可用性强

### 特点

- 支持各种网络文件协议,比如:ftp,http/webdav,smb等;不仅可以挂载他们,还可以创建相应协议的服务器(比其他文件管理器要好)
- 其中能够挂载的协议非常丰富,还可以接入知名网盘(其他一些文件管理器也可以做到)

### Webdav和SMB服务的访问问题

- 如果您仅仅在android端设备间使用Mixplorer提供的服务,那么各项功能应该可以工作的很好
- 然而在android的Mixplorer上创建的Webdav和SMB却难以被windows直接利用
  - Mixplorer将http和webdab服务连接混用(共用),没有区分开来
  - 而windows的挂载http链接的功能是比较受限的,挂载http协议本身需要修改注册表来放行http链接的挂载,而且经常会报找不到服务的错误
  - 相反,手机端上的app一般都可以简单挂载
- 另一个是SMB,Microsoft windows主流版本禁用了有安全问题的SMBv1,如果需要得手动安装SMBv1功能
  - 另一方面还有服务端口的问题,使用网络发现无法检测到Mixplorer启用的SMB服务
  - 目前Mixplorer还是默认提供SMBv1的服务创建

