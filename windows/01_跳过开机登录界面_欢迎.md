## references

* [How to login automatically to Windows 11 - Microsoft Community](https://answers.microsoft.com/en-us/windows/forum/all/how-to-login-automatically-to-windows-11/c0e9301e-392e-445a-a5cb-f44d00289715)
* [一些对于老系统的方法:Win10开机跳过欢迎界面直接进系统桌面的设置方法－系统城 (xitongcheng.com)](http://www.xitongcheng.com/jiaocheng/win10_article_52489.html)

## 声明

> 建议只有在特殊情况下配置自动登录(比如不用担心安全问题的情况下)

## 成功率较高的方法

### 使用而外的小工具

> 由于系统的更新(系统版本的差异),某些老方法不再生效
>
> - 特别是注册表的相关方法中的提到的某些值,新系统中可能发生变化
>
> 下面的小工具实验基于win11(较新版的win10应该也适用)

* 小工具不是必须的,但似乎挺省事的
* [Autologon - Windows Sysinternals | Microsoft Docs](https://docs.microsoft.com/en-us/sysinternals/downloads/autologon)
* 下载microsoft 官方的小工具

![1644677438772](https://s2.loli.net/2022/02/12/EAC4U8xc6wgGh2e.png)

- 这里密码填写的是不是PIN码,而是账户对应的密码!

### win11下的设置

![1644677876096](https://s2.loli.net/2022/02/12/Ol3MfUVnXYxtT1B.png)



- 重启计算机后应该可以看到效果
- 如果存在多个用户账户,将会直接进入到默认用户(当前用户)
- 可以通过开始菜单切换到其他用户
  - ![1644677838275](https://s2.loli.net/2022/02/12/6A9suetKc7x1Y5i.png)


## 关于netplwiz.cpl

* 不是所有的版本都可以直接看到如下窗口中的复选框

![1644678015475](https://s2.loli.net/2022/02/12/Omhz16jlNcybtsW.png)
