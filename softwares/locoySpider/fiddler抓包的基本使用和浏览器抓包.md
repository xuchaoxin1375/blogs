[toc]



## abstract

使用fiddler classic 进行简单抓包和数据拦截

一般存在网络请求的进程都可以抓包,但是通常我们主要想要对指定的网站进行抓包,也就是对浏览器进行抓包

有些客户端软件进程容易抓包,不需要额外设置,但是浏览器基本要设置为解密https链接才能抓到内容

使用过程中还要注意代理或代理插件可能对抓包结果的干扰,浏览器中设置代理插件(比如proxyfy这类插件)的话可能就抓不到包了

本文以edge浏览器为例,设置的fiddle版本以及操作系统信息如下

```bash
Progress Telerik Fiddler Classic

v5.0.20245.10105 for .NET 4.6.2
Built: 2024年10月16日

64-bit AMD64, VM: 106.0mb, WS: 180.0mb
.NET 4.8 WinNT 10.0.19044.0

You've run Progress Telerik Fiddler Classic: 7 times.

Running ELEVATED on: cxxuredmibook:8888
Listening to: All Adapters
Gateway: No Gateway

Copyright ©2003-2024 Progress Software Corporation. All rights reserved.
```

## 参考链接和资源

- [Fiddler抓包工具保姆级使用教程](https://blog.csdn.net/Mubei1314/article/details/122389950)
- [Fiddler安装，使用及汉化教程 - love_x - 博客园](https://www.cnblogs.com/love-x/p/17777763.html)
- 官方文档:[Configure Fiddler - Fiddler Classic](https://docs.telerik.com/fiddler/configure-fiddler/tasks/configurefiddler)
- 网络上有绿化便携版和汉化版本

## 解密https设置

[Decrypt HTTPS traffic - Fiddler Classic](https://docs.telerik.com/fiddler/configure-fiddler/tasks/decrypthttps)

这个步骤很重要,不设置的话大多数包都抓不到,浏览器进程的包可能一个都抓不到

上述文档有些老旧,但任然可以提供基本的参考

方便起见,可以将解密窗口中的复选框都打勾(只勾选解密可能达不到预期效果)

## 解码(解压)抓到的内容

默认抓到的包是被编码压缩的,为了查看原来的内容,需要选择解码

点击窗格中的横条`Response body is encoded.Click to decode`,将被编码的内容解码会人类可读的形式

### 设置自动解压

工具栏中有一个`Decode`按钮,点击它可以切换是否自动解压功能

鼠标悬停会提示:When enabled,all traffic is decompressed for easy viewing

这个功能默认不启用,需要手动设置

但是默认不开启是有考量的，部分网页数据量大，默认解密内容的话一旦点击会造成一定时间的卡死，是否开启要酌情考虑

## 搜索抓到的包中的内容

抓到的包通常都是被压缩的形式,在fiddler中直接查看往往都是一些乱码

有时你可能需要搜索带有特定关键字的包(响应),则在搜索中要勾选解压,还可以考虑勾选二进制文件

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/756701d7c8754e928e22892202cdbcc8.png)

对于博客或新闻类的页面,可以点击fiddler软件的inspectors页面下webview查看对应的文章

## 影响抓包的可能设置

通常设置了解密https后,就能够正常抓包了

但是如果使用了代理插件等情况,可能会阻碍抓包的顺利进行,为了排除这种情况,可以打开另一个浏览器,或关闭相应插件,或者关闭代理软件

如果有用浏览器代理插件的话,建议用另一个浏览器(内存够的话),避免忘记切换而导致抓包或工作效率降低