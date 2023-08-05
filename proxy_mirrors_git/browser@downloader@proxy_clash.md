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
  - ```bash
    PS C:\Users\cxxu> ping www.google.com
    
    正在 Ping www.google.com [198.18.0.5] 具有 32 字节的数据:
    来自 198.18.0.5 的回复: 字节=32 时间<1ms TTL=64
    来自 198.18.0.5 的回复: 字节=32 时间<1ms TTL=64
    来自 198.18.0.5 的回复: 字节=32 时间<1ms TTL=64
    来自 198.18.0.5 的回复: 字节=32 时间<1ms TTL=64
    
    198.18.0.5 的 Ping 统计信息:
        数据包: 已发送 = 4，已接收 = 4，丢失 = 0 (0% 丢失)，
    往返行程的估计时间(以毫秒为单位):
        最短 = 0ms，最长 = 0ms，平均 = 0ms
    ```
  
    
- wget等命令行下载工具也可以在此配置下走代理


## edge 浏览器内部代理配置插件

## 插件1 proxy switchomega

- [Microsoft Edge 加载项 - proxy switchyomega](https://microsoftedge.microsoft.com/addons/search/proxy switchyomega)
- 推荐使用，简单易用，较稳定
- 配置完服务器资源后，在浏览器处的插件图标切换到proxy模式，否则默认是系统代理（直连），插件配置的代理将无法生效

### 插件2 smartproxy

- [SmartProxy - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/smartproxy/canbjhbbhfggbdfgpddpnckdjgfcbnpb?hl=en-US)
  
  

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

  