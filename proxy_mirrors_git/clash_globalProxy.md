@[toc]

# 无须sstap等软件实现虚拟网卡代理

- 在较的版本中,您可以`直接下载TUN Mode`
- 开启tun而无须更多的配置即可以使用TUN (更多细节可以参看CFW官网)

## reference

- [Clash for Windows | Clash for Windows (lbyczf.com)](https://docs.cfw.lbyczf.com/)
- [TUN 模式 | Clash for Windows (lbyczf.com)](https://docs.cfw.lbyczf.com/contents/tun.html#windows)

## 配置步骤

### service Mode

- 先下载并启用`service Mode`(会自动重启应用,该过程一般不会太久(10s)
- ![1646271988176](https://s2.loli.net/2022/03/03/a2HVRJgcWQPUGIY.png)

### tun Mode

- 下载并启用`tun Mode`
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/2f1b508b93ee46778d558d4a0803bfab.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

## 检查启用情况

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/a14c4123a9374a2287ec39040217df12.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_15,color_FFFFFF,t_70,g_se,x_16)
- 能够使得Ping 走代理
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/1a14140614c9432386ac36b32cc7d9fb.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_15,color_FFFFFF,t_70,g_se,x_16)
- wget也可
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/2ff1390821ce4bc788187e4c50873bf2.png)
