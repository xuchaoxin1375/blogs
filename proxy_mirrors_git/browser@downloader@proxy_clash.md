[toc]



# 无须sstap等软件实现虚拟网卡代理

- 在较的版本中,您可以`直接下载TUN Mode`
- 开启tun而无须更多的配置即可以使用TUN (更多细节可以参看CFW官网)

## reference

- [cfw(lbyczf.com)](https://docs.cfw.lbyczf.com/)
- [TUN 模式 | cfw (lbyczf.com)](https://docs.cfw.lbyczf.com/contents/tun.html#windows)

## 配置步骤

### service Mode

- 先下载并启用`service Mode`(会自动重启应用,该过程一般不会太久(10s)
- ![1646271988176](https://img-blog.csdnimg.cn/img_convert/54d647f08ec4ff2e0b434dcb48a92a44.png)

### tun Mode

- 下载并启用`tun Mode`
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/6328429b0b2f4d658b87b5d56bacd4d8.png)


## 检查启用情况

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/5dc74f1d00c24aef89f928bf20e26f3f.png)

- 能够使得Ping 走代理
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/1a14140614c9432386ac36b32cc7d9fb.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_15,color_FFFFFF,t_70,g_se,x_16)
- wget也可
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/2ff1390821ce4bc788187e4c50873bf2.png)


## edge 浏览器内部代理配置

### 插件Proxy

- [SmartProxy - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/smartproxy/canbjhbbhfggbdfgpddpnckdjgfcbnpb?hl=en-US)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/d7c09421f93548029ab0e1b8e70b7917.png)

#### 代理白名单(pass)

- 例如校园网的登陆/跳转

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/4fed0b7b714c487b90bdfc3f4981a0c9.png)

## firefox

- 火狐浏览器自带作用域代理
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/9abaf1d074054b15a695a92f71a914f3.png)

##  IDM代理

![在这里插入图片描述](https://img-blog.csdnimg.cn/109263e1065045c2a6e4638bfe6670cb.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_11,color_FFFFFF,t_70,g_se,x_16)
## 小结

- 通过上述设置,就不必总是打开系统代理,可以更加灵活

  