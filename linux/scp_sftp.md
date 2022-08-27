@[toc]

# GUI方案

vnc Viewer

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210619185553211.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

# 通用方案:scp方式下的文件传输(linux)

## scp方式:

- 注意,有多台raspberry时,将 `userName@RaspberrypiHostName`作
  `userName@<RaspberrryIP>`
- 详情,查看 `scp`帮助文档
  - 在linux(或者windows wsl)下执行 `man scp`获取帮助

### windows_powershell+scp:

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210619185637990.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

### cmd+scp也类似

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210619185644520.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

## ssh远程编程

- 特别是远程主机没有安装图形界面的时候(节约云服务器的资源占用)
- 可以通过vscode提供的 `remote-ssh`插件,来利用本地可视化编辑器(其他IDE可能也有其自己的远程编程支持)来编辑远程代码

> 这不是必须的,但是有时可以提供便利
> [Connect over SSH with Visual Studio Code](https://code.visualstudio.com/docs/remote/ssh-tutorial)
> ![](https://img-blog.csdnimg.cn/img_convert/3a8981c85332c47bee026cccb916de41.png)
> ![](https://img-blog.csdnimg.cn/img_convert/f503275d90ad94b1b8fcc93177523334.png)

### sftp传输协议

- [SFTP - SSH - Connectors | Microsoft Docs](https://docs.microsoft.com/en-us/connectors/sftpwithssh/)
  - SFTP (SSH File Transfer Protocol) is a network protocol that provides file access, file transfer, and file management over any reliable data stream.
  - It was designed by the Internet Engineering Task Force (IETF) as an extension of the Secure Shell protocol (SSH) version 2.0 to ` provide secure file transfer capabilities`.
- [说说SSH、SCP和SFTP的那些事儿 - 云+社区 - 腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1042350)
- 
#### sftp相关工具

- [MobaXterm free Xserver and tabbed SSH client for Windows (mobatek.net)](https://mobaxterm.mobatek.net/)
  - 算是一款功能丰富的终端工具
  - 免费版一般够用:下载[MobaXterm Xserver with SSH, telnet, RDP, VNC and X11 - Download (mobatek.net)](https://mobaxterm.mobatek.net/download.html)
  - 支持文件拖曳进行双向传输,记住密码等管理功能

## powershell+ssh连接

- 最简单的ssh连接用法
  `ssh remoteHostName@remoteHostIp `
  例如,我连接到本地的linux 虚拟机(ubuntu server)(局域网内的链接)
- 购买的云主机也是类似的方式链接
- > 注意,如果仅仅指定ip而不指定远程主机上的用户名,将无法以用户的形式登录控制远程主机
  >
- 完整文档参考[OpenSSH: Manual Pages](https://www.openssh.com/manual.html)

![在这里插入图片描述](https://img-blog.csdnimg.cn/d93b9d0daa7747098f45fb951c546988.png)

## 通过git部署最新代码

可以通过在本地修改代码,上传到github/gitee;在服务器(linux)端clone(pull)最新代码实现代码更新(也是基于ssh执行相应命令)
在这种做法下,一般不在服务端编辑代码,二至通过git 跟新代码

当然要传输二进制文件也是可以的.
