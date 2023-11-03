[toc]

当某个值反复(频繁)被用到,可以考虑为该变量(某个path路径值,当然也可以是其他值(任意字符串,但不可以过分长)设置环境变量,这样可以通过环境变量来快速引用某个值(经常是目录)

还有其他的一些好处:

- Constant special item ID list (CSIDL) values provide a way to identify folders that applications use frequently but may not have the same name or location on any given computer.
- For example, the system folder may be C:\Windows on one computer and C:\Winnt on another. 

##  environment variables快速入口

- 开始菜单搜索path
![在这里插入图片描述](https://img-blog.csdnimg.cn/3da29cf515d7425fa2bb620b22e24a73.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  实例:配置java_home
例如,设置环境变量`java_home`,其对应的值此处是设置为一个路径:
`D:\exes\jdk-16.0.1_windows-x64_bin\jdk-16.0.1`
![在这里插入图片描述](https://img-blog.csdnimg.cn/b5ee40453df94b06b661cbce3508ecd2.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
### 引用java_home:
用`%java_home%`的形式来引用
这个值可以被win+r(运行程序)使用:

![在这里插入图片描述](https://img-blog.csdnimg.cn/4f83d9da16f54f17adecf2d9ac1746d7.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
### 可以被cmd使用
查询变量java_home的值:
`echo %java_home%`
![在这里插入图片描述](https://img-blog.csdnimg.cn/88ce1e5ba58c41289581c3a19750a4d3.png)
###  可以被资源管理器中的地址栏所引用
![在这里插入图片描述](https://img-blog.csdnimg.cn/75fae381c2934ea180353b374a2fa186.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

### 当然可以用在windows 的bat脚本中

##  对于Path
###  %java_home%\bin
![在这里插入图片描述](https://img-blog.csdnimg.cn/aaa89ed9399a4a21b95738c6e3bfb402.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
上面框中的两行效果一样,保留其中一种即可
##  使用path

- Path变量中的各个值(一般仅保存文件夹(目录)),Path中记录的目录下的子目录或文件都可以被直接引用:
- 比如,我将D:\这个目录添加为Path变量的一个值,同时假设D:\目录下有文件a.txt,目录a 等,那么我们就可以用win+R或cmd中输入a.txt直接打开a.txt(而无需输入a.txt所在目录)
##  导出Path变量的所有值:
###  cmd
在cmd中输入`path`或者`each %path%`
(注意不是%path%)
![在这里插入图片描述](https://img-blog.csdnimg.cn/97f8604a8a7f4f1d9fb53aab2660988d.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/21edabacaf9c428480ea8256cdce671f.png)
###  powershell
`$env:Path  -split ';'`
##  节约Path变量取值的字符数(推荐做法)
## Additional information
DOS limits the path to 122 bytes. Every command is limited to 127 bytes; however, 127 - 5 (minus 5 because of PATH=) = 122.
基于此,建议将重复使用的目录前缀单独作为一个变量创建,然后在path中引用该变量(%variableName%),可以达到简化字符串长度的目的(这种限制似乎可以被破解(安装python的时候有一个相关功能))

比如我将`d:\onedrive - pop.zjgsu.edu.cn`提取为单独的环境变量`org`
==注意,单独的环境变量值末尾不宜带有`'\'`==
==否则在转义时会容易出错(用path命令检查可知/win+r报错也可知)==
(当然取决于您在path中的variable中是否使用`\`来连接了)
![在这里插入图片描述](https://img-blog.csdnimg.cn/9b0e39db97d3401ca395acb7c489dd93.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/1c6146419a63424491d48f6bfebc5c2c.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


详见参考资料:
# 相关可参考资料
[How to set the path and environment variables in Windows](https://www.computerhope.com/issues/ch000549.htm#dospath)
[MS-DOS and Windows command line path command](https://www.computerhope.com/pathhlp.htm)

# 总结
##  可能出现的问题
###  使用环境变量前,您需要做的扫尾(状态更新工作)
环境变量修改(添加)完成后,请关闭所有配置窗口(一般有两层窗口,需要点击确认两次,然后关闭相关窗口:
![在这里插入图片描述](https://img-blog.csdnimg.cn/bbc17e5927334b6aa04c285566c6e2a9.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
####  options up to you
- 关闭已开启(如果有的话)的cmd/powershell/terminal窗口,然后重新开启(如果您要使用刚配置(修改)的环境变量




###  变量配置不成功
如果您确信您的操作是正确的,但是依然没有办法使用该变量
最可能的原因是使用了过多的中间变量(超过2次)
不过,无论是什么原因,都可以利用powershell来检查问题(检查之前确保关闭所有已经打开的powershell(或者windows terminal),然后重新打开一个powershell专门检查(否则无法检测到刚配置的变量)
<hr>

然后借助powershell打开powershell 的`$env:YourEnvName`来查询结果
如果返回了内容,说明配置的值成功写入到系统注册表中
但是,如果您的环境变量引用了超过二重的中间变量,那么系统解析出来的路径将包含有基础变量(以`%`标记出来的)部分,这就导致环境变量无法正常提供服务(解决方案就是减少嵌套)(换句话说,使用绝对路径配置的环境变量就不存在引用过度的问题)
<hr>


演示查询和使用:
(以下终端是经过本人一定的配置才有的效果)
譬如,我想查询`pwsh`这个变量是否被成功配置:
![在这里插入图片描述](https://img-blog.csdnimg.cn/f4b5d6a2a250434080393859f415b616.png)
powershell 返回的路径是一个不带`%`的绝对路径,说明该变量可以被正常使用

某些复杂字符串(而不单单是长路径)都可以通过环境变量记录到系统当中,并以类似的方式查询该字符串
此外,如果我们将某个路径(或者环境变量)添加到path变量中(作为path值数组中的一个元素值),那么powershell 配合PSReadLineKeyHandler 功能模块可以实现补全功能(预览)
甚至,可以使用通配符来查询环境变量下可以搜索到的文件/目录
![在这里插入图片描述](https://img-blog.csdnimg.cn/f3015f4eaf7f41e3934e3910128fa9a3.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)


对于老电脑,可通过`cmd`中运行`set` 命令但是看不到刚配置的环境变量
(或者用`echo yourNewEnvVariable`的形式查询是否配置成功(注意,==查询之前请务必打开新的终端,否则检测不到刚配置的变量.==

某些时候,也可以考虑重启计算机
###  环境变量的非shell(terminal)使用
==windows在这一方面做的不是那么完美==
(特别是win+r(也就是run)窗口在输入某些环境变量时而可以打开,时而说找不到路径(或许是'run'程序的锅吧)
![run窗口](https://img-blog.csdnimg.cn/1770e0ad70bb41019b5402ee963d243d.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_10,color_FFFFFF,t_70,g_se,x_16)
<p align="center">run窗口</p>
<hr>


##  其他可以检查的地方
### 不要在路径变量前面留有空白字符!
(通过cmd下 `set >> env.txt`
输出各个变量值来检查)

打开输出文件:直接在cmd中(接续上一条指令的提示符)输入:
`env.txt`打开查看
![在这里插入图片描述](https://img-blog.csdnimg.cn/b2f3f1b7cd434e91ab8b2aea2756a7d5.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_14,color_FFFFFF,t_70,g_se,x_16)
###  检查path中的值结尾的'\'
如果您发现形如`%variableName%\`的值再path中没有效果,那么可以尝试将`\`去掉保存后重新尝试

单独设置环境变量会比较灵活(复用性好;可以使用`\`来连接相对论路径(可读性也更好)
但是要用%号引用

在path变量中设置目录值:只需要将目标文件(目录)所在的父目录添加到path中的值即可),这样就可以直接用过文件名(目录名)来打开目标
###  仍然不行?
我在配置过程中遇到了使用terminal(cmd)可以访问,但是win+R访问不了的情况,这种可能是由于path中引用的是其他变量的形式(而不是采用采用绝对路径)(前面也提到过)
如果是以路径字面量(而不是将路径赋值给某个其他的环境变量,然后再path中引用的方式)成功率几乎是百分之百

虽然为路径单独设置一个环境变量会比较好管理,但是缺点是成功率不高.
估计是windows对变量引用层数解析限制(不超过2重)

#  导出/导入环境变量方法
##  方法1：方便导入回去的备份方法：
You can use RegEdit to export the following two keys:

```HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment```

`HKEY_CURRENT_USER\Environment`
The first set are system/global environment variables;
 the second set are user-level variables. Edit as needed and then import the .reg files on the new machine.
![在这里插入图片描述](https://img-blog.csdnimg.cn/9a72021b65164d5e8bf0a62771f21b90.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

![](https://img-blog.csdnimg.cn/img_convert/54ff5581a26c0c611c46a8af903be398.png)
if you want to import,just click the reg file you exported (of course ,if you want to wirte environment variables reg file ,it's may be ok.)
##  其他不同的导出格式peek
![在这里插入图片描述](https://img-blog.csdnimg.cn/5106922abbb14953a7be9e4a152a24a1.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

##  方法2：方便人类阅读的方法
use the cmd command:
`set >> env.txt
`
![在这里插入图片描述](https://img-blog.csdnimg.cn/787d5850cc0f4303acb294244997eaa0.png)

###  peek the result
![在这里插入图片描述](https://img-blog.csdnimg.cn/fa3d14040c8c420da1adeaf6e53a1bc0.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)


##  Note the encoding
Note the difference in file encoding,save as correct encoding,or it will broken.
![在这里插入图片描述](https://img-blog.csdnimg.cn/ca6e017ccfff466d8a6d1b5cd2380806.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_15,color_FFFFFF,t_70,g_se,x_16)
#  环境变量的相关妙用
- 配置了对应的相关变量后，您可以在path变量中更加轻松的设置目录值，同时，如果您的文件夹目录发生变更，很多时候就只需要修改环境变量（维护起来更加轻松）
- 您可以在run中直接利用%环境%的形式打开对应的文件文件夹
- 还可以在cmd命令行中快速切换工作目录
	- 带上参数	`/D` 可以跨盘符跳转
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7fe3d25434264da29debb0ba4662b5d4.png)
- 简化常用命令(比如登录远程主机)

![在这里插入图片描述](https://img-blog.csdnimg.cn/5e8b0af9adef484681bef2b4f8e9119e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

