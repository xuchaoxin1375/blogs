[toc]





## ftp server

- windows自带的方式步骤稍微繁琐
  - 该功能系统往往不会默认启用,需要启动windows的功能
  - 配置防火墙(否则可能其他设备无法访问)
  - 但是不失为一种方案(毕竟作为一种基础通信协议,不需要额外安装软件)
- 参考链接
  - [FTP Sites | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831422(v=ws.11)?redirectedfrom=MSDN#SiteInformation)(官方文档)
  - [FTP Directory Browsing | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831403(v=ws.11)?redirectedfrom=MSDN)(官方文档)
  - [How to set up and manage an FTP server on Windows 10 | Windows Central](https://www.windowscentral.com/how-set-and-manage-ftp-server-windows-10)
  - 可供参考的视频:
    - [【教程】4分钟学会电脑开启ftp，手机上传文件到电脑ftp_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1nS4y147pQ/?spm_id_from=333.337.search-card.all.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)
    - [告别繁琐的Windows共享设置，试试搭建一个FTP来共享文件吧 bilibili](https://www.bilibili.com/video/BV1rL4y1V7zF/?spm_id_from=333.337.search-card.all.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

### 下面是核心步骤

- windows控制面板中启用windows相关功能

  - | 启用FTP和WEB功能                                             | 设置防火墙                                                   |      |
    | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
    | ![请添加图片描述](https://img-blog.csdnimg.cn/direct/6b21045a7ce04bcc92dcea42e7284df9.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/52e263ad45ff451cbfecc5e0da2ee775.png) |      |
    | 可以通过windows开始菜单(快捷键**win+s**搜索:**windows功能**或**windows features**快速打开;<br />先按照左侧勾选的那样尝试是否可以工作(都勾选当然没问题,可能会占用更多资源罢了) | 同样可以通过搜索快速打开防火墙设置<br />或者通过命令行输入`Firewall.cpl`快速启动该面板 |      |
    |                                                              |                                                              |      |

- 启动IIS并设置FTP服务站点

  1. 可以在快捷键**win+r**下输入`%windir%\system32\inetsrv\InetMgr.exe`快速启动

     - 或者在**win+s**下输入`IIS`搜索,找到**Internet Information Services (IIS) Manager**,
     - 它的所在目录可能是这样的"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools\IIS Manager.lnk"

  2. 配置站点

     - 站点配置是很灵活的,可以根据自己的需要灵活配置,可以简单配置,也可以精细地配置

     - 简单的**匿名访问**配置

       - |                                                              |                                                              |
         | ------------------------------------------------------------ | ------------------------------------------------------------ |
         | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/e5021b414f0747beb715692a2f4b3727.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/79dffedfba744fa3a222b70df3a310b5.png) |
         | ftp站点绑定的目录如果要作为匿名可访问,则建议设再D盘或其他系统盘之外的盘的某个文件夹或根目录下(C盘的某些和用户相关的目录要求登录用户账户密码,无法支持匿名登录,尽管ftp站点设置为匿名登录,这个要注意一下) | 例如站点目录设置在某个用户的桌面,那么意味着链接该ftp需要账号密码而无法匿名登录,这是为了安全起见 |
         | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/941d9e323968456eb0fb0517a2946970.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/57e59138a16148b6b86017c717427757.png) |
         | 设置为无需SSL                                                | 简单起见,设置为所有用户可以访问                              |

- 其他设置

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/65c54bd898044bfdb194903b0d16df1b.png)
  - 例如停止或重启ftp服务器,也可以移除它
  - 右侧的面版是拓展功能,一般用不上

### FAQ

- 如果使用过程中体验不要,例如容易上传某些文件时会出现权限错误,有的可以传,有的会失败,可以考虑
  - 更改传输失败的文件的文件名,最好时纯英文字母的名字,后期再改回来(或者压缩,更名)
  - 或者更换专业的传输软件(使用更合适的协议)进行传输