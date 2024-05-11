[toc]

##  refs
- [How To Change Your Username On Windows 11 and 10 (helpdeskgeek.com)](https://helpdeskgeek.com/windows-10/how-to-change-your-username-on-windows-10/)
- [3 Ways to Change User Account Name in Windows 10 (isunshare.com)](https://www.isunshare.com/windows-10/3-ways-to-change-user-account-name-in-windows-10.html)
- [How To Change User Name Windows 10 - Microsoft Community Hub](https://techcommunity.microsoft.com/t5/windows-10/how-to-change-user-name-windows-10/m-p/3630358)

##  副作用声明
-  如果您将原用户的`家目录`重命名了,那么已知一些软件(配置)会受到重大影响
   -  `wsl`
   -  `powershell`所安装的功能模块

 -  当然如果您会软连接的技巧,或许可以保住原来的样子,后面会提供一些修复手段
-  比较保守的做法参考:[Windows修改用户名-CSDN博客](https://blog.csdn.net/weixin_44815511/article/details/121549369?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-1.pc_relevant_default&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-1.pc_relevant_default&utm_relevant_index=2)
-  可能会遇到权限问题,某些文件访问不了,需要管理员权限更改目录或文件的属性


#  共需要修改3个地方
- 三个地方都需要通过`另一个管理员账户`来修改
- 如果`lusrmgr`中的用户名没改,可能导致wsl将丢失信息(发生错误)
(这里先提一下后果,后面会介绍修改)


##  管理员账户准备工作
- 进入另一个管理员账户(可以自己新建一个管理员账户)
- 有了当前账户之外的管理员账户后,注销(即登出logout(命令:`logoff.exe`)当前用户

## 原用户名对应的家目录名的处理
- 我原先的的方案是之间在另一个临时管理员账户中把`C`盘的旧用户目录名修改掉,后来看到其他地方的建议,发觉我这种手法是冒进的,特此强调一下保守一点的做法
- 您可以通过windows软连接(相关文章很多,例如powershell 的` New-Item -Verbose -Force -ItemType junction -Path $Path -Target $Target`;又比如cmd 的`mklink`命令,本人都使用较多,已经在其他地方专门介绍)
> 进入到`C:\users`
> ` New-Item -Verbose -Force -ItemType junction -Path <NewUserName> -Target <OldUserName>`
> 本处可以将尖括号中的内容替换为您的实际情况和需求
> 注意命令中新用户明在前,就用户名写在后者,否则没有效果!

>- 将c:\users\目录下的`<userNameOld>`改为`<userNameNew>`是一个偏激的操作,由于我一般不用快捷方式启动软件,而且大多装在D盘,没有遇上太大问题;
>- 但如果您不嫌弃c:/Users目录下有保留旧有的目录的话,可以不做更名,仅仅创建符号链接(软连接)
>![在这里插入图片描述](https://img-blog.csdnimg.cn/20210115190842668.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
>可以通过Win+r,再输入c:\users

##  修改本地用户配置信息
- 此时必须再修改注册表,否则无法正常登录被修改的用户的系统
	- 可以做如下操作修改注册表:
	推荐步骤:
	按`win+R`
	输入`lusrmgr.msc`
	点击用户(`users `)
	![在这里插入图片描述](https://img-blog.csdnimg.cn/2021011518511889.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
	按F2
	修改名称(注意管理员权限).

>  也可通过:鼠标点击方式打开设置
>  - 控制面板\用户帐户和家庭安全\用户帐户\管理帐户\更改帐户\重命名帐户)

## 修改注册表
-  按win+R,输入regedit,回车enter

-  在注册表编辑器中定位到以下路径： (可以拷贝粘贴到输入栏中)
	- 英文版系统:
	`computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\profileList`
	- 中文版系统:
	`计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\profileList`![计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\profileList](https://img-blog.csdnimg.cn/20210115185800148.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
>		注意是`'\'`(back slash)分隔符,而不是`/`.	

- 在ProfileList文件夹下，分别点击名字为较长的字符串的文件夹，查看窗口右侧的`ProfileImagePath`键的内容，找到路径为`C:/Users/USER1`的键。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210115190204698.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
-  双击此ProfileImagePath键，修改完,重新登陆USER2帐户
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210115190355472.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
##  修复环境变量
-  (这些配置是在用户名更名操作完成之后的一些修复工作)用户环境变量的修正(比如powershell的模块,以及一些UWP的配置目录(appdata)
![在这里插入图片描述](https://img-blog.csdnimg.cn/588342e126144c1cac683da3edde61f6.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
这或许可以修复一些由于更改用户名(目录)而导致原有的模块无法调用的问题
# FAQ

## windows store里安装的应用

- 某些已经有使用痕迹的uwp应用/onedrive就反应不过来(多点击几次)
比如,若干分钟后,onedrive会提示找不到`path.../userNameOld`,然后重新设置(登录账户)并选定你想要的同步目录所在位置


### wsl

- `wsl` 可能会受到影响,可以尝试导出wsl

  - [Basic commands for WSL | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/basic-commands)

  - ```bash
      --export <Distro> <FileName> [Options]
            Exports the distribution to a tar file.
            The filename can be - for stdout.
    
            Options:
                --vhd
                    Specifies that the distribution should be exported as a .vhdx file.
    ```

  - 利用`wsl` export命令来导出虚拟机,然后再合适的时候(修改完用户名字)重新导入(import)

  - 如果采用软连接而不修改用户名,那么或许wsl可以在新用户名中正常使用,但我未实践






