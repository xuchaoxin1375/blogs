[toc]



[toc]

## abstract

windows可以直接在cmd/powershell内直接通过`wsl`或`bash`调用wsl终端

下面是其他形式连接wsl的方式

##  reference 

- [How to List Installed Packages on Ubuntu | Linuxize](https://linuxize.com/post/how-to-list-installed-packages-on-ubuntu/#:~:text=To%20list%20the%20installed%20packages%20on%20your%20%3Cu%3EUbuntu%3C%2Fu%3E,including%20information%20about%20the%20packages%20versions%20and%20architecture.)

------
# vscode+remote-wsl插件:
## remote-wsl
这是最简单的VSCode链接wsl的方式
在使用这种方式连接的时候,需要为wsl安装extension;windows上的vscode插件默认不可用

后面将会介绍到,您可以使用remote-ssh插件,也能够连接的wsl

(右键connect)![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/4230935f44c5d5e7317a1358c6b3189d.png)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/d19cf02435a7be39c57f7b4143b009c1.png)
## vscode_wsl窗口:
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/212434e26f5c860b7e2c1bfd4486be7d.png)

## wsl+code 命令

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/5bee7ba3649dbb4181df2b344e9bbef3.png)![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/0ee5c9de5405836a2c90e0c3157d0b91.png)
#  通用ssh连接wsl 配置
- 其实windows可以直接连接到wsl
- 不过某些时候可以用到(比如vscode连接,虽然有相应插件,但是可以整合到remote ssh)



###  尝试启动ssh
如果已安装ssh,可以尝试执行
`sudo service ssh start`
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/6ee894758b34408324ae2d5f0f824629.png)
###  检查ssh相关进程
`sudo ps -e |grep ssh`
```bash
cxxu_kali➜~» sudo ps -e |grep ssh                                                                            [12:54:33]
  676 ?        00:00:00 sshd
```
####  重装ssh服务(optional)
> 自带的openssh 可能有点问题,如果需要卸载重新装(ubuntu/kali),执行如下命令
```bash
sudo apt remove openssh-server
sudo apt install openssh-server
```
##  编辑ssh 配置文件
```bash
##  编辑ssh 配置文件
sudo vim /etc/ssh/sshd_config
```
- 大概在15行/58行附近分别设置`Port`和`passwordAuthentication`
即,在原有的行解开注释(其他需求自行配置)
###  放行端口22
![](https://i-blog.csdnimg.cn/blog_migrate/3a7a0a2641c2d25e38e57cd1731eb8f1.png)
###  允许密码登录passwordAuthentication yes
![](https://i-blog.csdnimg.cn/blog_migrate/31d2216bf969fa5272bd23c1c5f8c315.png)
###  登录root用户/普通用户
- 登录普通用户至此应该可以
- 但是root用户(root@hostname)可能需要额外的配置
	- 也可以通过先登录普通用户,然后基于普通用户执行`sudo -i`等操作进行切换 
##  重启ssh服务
完成配置后,需要重启ssh服务
`sudo service ssh restart`

>###  注意ssh服务的启动

- 手动启动ssh 服务,否则vscode 无法通过ssh连接上wsl
不过这一点,采用wsl插件或许更为方便
- 幸运的是,您可以设置开启wsl自动启动(在linux中,实现这一点比windows更简单,在linux中开机自启软件和其他一些永久有效配置类似,通过将启动命令写入到开机运行的配置文件中即可,例如,您可以将`service sshd start`写入到`/etc/rc.local`中(不存在该文件时创建一个即可)
####  开机启动ssh
```bash
echo "service sshd start" |sudo tee -a /etc/rc.local
## check the result:
cat /etc/rc.local
```

##  连接:用户名@主机名的方式
- 通过输入bash可以看到(用户名@主机名)
	-  ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/75c11807654df145e5bad1b0ac6e9f70.png)
- 或者命令行查询
`hostname`
`whoami`
分别查得主机名和用户名

![](https://i-blog.csdnimg.cn/blog_migrate/1ba7c20831df7a2f99dabfd489892eea.png)
###  vscode remote-ssh 插件连接wsl 效果
初次连接需要下载一些服务,这和第一个插件类似
等待时间在3分钟内
![](https://i-blog.csdnimg.cn/blog_migrate/caf8d5f3a0eced480b44f698c95f5431.png)
###  wsl中使用code 
>利用powershell 调出wsl后,键入`code`,同样可以在本地vscode中编辑文件wsl中的文件

![](https://i-blog.csdnimg.cn/blog_migrate/8fda48b0fbf1fcd8295ded823587adda.png)
##  权限问题
保存需要权限的文件时,参看其他解决方案(比如安装插件)
[Save as Root in Remote - SSH - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=yy0931.save-as-root)