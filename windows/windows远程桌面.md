

[toc]

## refs

- [如何使用远程桌面 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/如何使用远程桌面-5fe128d5-8fb1-7a23-3b8a-41e636865e8c#ID0EDD=Windows_10)

#  被连接机器的信息获取/功能配置:
##  试验环境
- 两台主机均被设置了用户和密码,被控机器登录的账户是Microsoft账户(不同于本地账户,影响远程登录时的用户名+密码)
- 都是windows专业版以上的
- 这里试验的两台机器都是同一局域网下的主机
##  相关常识
- 一台计算机(host)上可能不止一个用户(user)
- 特别是用户名要加以区别

##  修改计算机名
###  CLI (powershell)
- 进入到**管理模式,切记**下运行(**run as administator**)
- `rename-computer <yourNewComputerName>`
	- DESCRIPTION
    > This cmdlet is only available on the Windows platform. The `Rename-Computer` cmdlet renames the local computer
    > or a remote computer. It renames one computer in each command.

    This cmdlet was introduced in Windows PowerShell 3.0.`
- 例如:
```bash
PS C:\Users\cxxu> Rename-Computer CxxuWin10
WARNING: The changes will take effect after you restart the computer DESKTOP-CO17BQC.
```
###  GUI
####  win10
- 比较容易报错
- [UNABLE TO CHANGE Computer name on WIndows 10 Pro - Microsoft Community](https://answers.microsoft.com/en-us/windows/forum/all/unable-to-change-computer-name-on-windows-10-pro/6a20f7e6-b5f8-4b96-9bdb-596a03892da8)
![在这里插入图片描述](https://img-blog.csdnimg.cn/5131f66de7bb41099c43bf275ae1c144.png)
####  win11 
- 情况比较正常


## 获取windows主机名/获取被控制机器的身份(HostName/Ip):
>在局域网下,可以通过唯一的用户名/私有ip来确定一台计算机
### 方式1(HostName)
####  UI
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210516230404396.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
####  CLI
`hostName`
eg.
![在这里插入图片描述](https://img-blog.csdnimg.cn/9fafb39c5c084bc2bb0664f462e66efd.png)

- 记下(复制)改名字(也可以自行修改计算机名)
如果需要,可以修改计算机名(修改后需要重启计算机)
![在这里插入图片描述](https://img-blog.csdnimg.cn/f771969303d24248b114ca79c64ff391.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_19,color_FFFFFF,t_70,g_se,x_16)


### 方式2(ip):
> 获取ipv4的地址

#### CLI
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210516231024406.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
####  UI
通过设置查看
![在这里插入图片描述](https://img-blog.csdnimg.cn/cb8c8e03f1f94b3ea12d86066d8766bf.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

>作用和hostName一样,两者选择一种即可

###  获取要被远程登录用户名(userName)
####  cli
- `whoami`获取的是`主机名/当前用户名`
![在这里插入图片描述](https://img-blog.csdnimg.cn/e638b97a86404f4daf2ace5d5ee97d31.png)


##  主控机的设置:
###  打开mstsc
win+R:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210516230506484.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

###  输入信息
第一栏:输入computer ip/username(刚才获取的被控制主机ip地址/hostName)

例如,我使用名字(hostName)也可:
![在这里插入图片描述](https://img-blog.csdnimg.cn/c4cffefc28c04d0687bdc74270367038.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
这里试验的两台机器都是同一局域网下的主机

输入被控机器的`用户名`及其`密码`(这里用的是Microsoft账户+密码
当然,本地用户也是可以的(本地用户的用户名+对应的登录密码(pin码))

------
###  登录到远程主机的本地账户
>和Microsoft账户类似

![在这里插入图片描述](https://img-blog.csdnimg.cn/9e4040c6b03249768b3071a316214c08.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_10,color_FFFFFF,t_70,g_se,x_16)
>最好设置登录密码,否则可能无法远程登录失败
>###  修改本地用户的登录密码
>注意,这不同于PIN码
>![在这里插入图片描述](https://img-blog.csdnimg.cn/305bc3ebda9d4fc1aac40305ca5a6a0a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)


![在这里插入图片描述](https://img-blog.csdnimg.cn/20210516233135665.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
##  总结
- 登录时,使用账户的登录密码`而不是pin码`
- 无论是microsoft账户还是本地账户,都用各自配置的密码来作为远程登录的入口凭证


## result:
这里被控机器我用的是`本地账号登录`:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210516232731474.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)