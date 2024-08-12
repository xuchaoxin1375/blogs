[toc]



# 无须sstap等软件实现虚拟网卡代理

- 在较的版本中,您可以`直接下载TUN Mode`
  - 使用tun模式不需要打开**系统代理**

- 开启tun而无须更多的配置即可以使用TUN (更多细节可以参看CFW官网)

## reference🎈

- [Claxh for Windows | Claxh for Windows (lbyczf.com)](https://docs.cfw.lbyczf.com/)
- [TUN 模式 | Clash for Windows (lbyczf.com)](https://docs.cfw.lbyczf.com/contents/tun.html#windows)

## 配置步骤

### service Mode

- 先下载并启用`service Mode`(会自动重启应用,该过程一般不会太久(10s)
- ![1646271988176](https://s2.loli.net/2022/03/03/a2HVRJgcWQPUGIY.png)

### tun Mode

1. 下载并启用service mode(绿色小球)
2. 下载并启用`tun Mode`
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/2f1b508b93ee46778d558d4a0803bfab.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

## 检查启用情况

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/a14c4123a9374a2287ec39040217df12.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_15,color_FFFFFF,t_70,g_se,x_16)

### 命令行走代理检查

- 能够使得Ping 走代理

  - `ping google.com`

    - ```
      PS C:\Users\cxxu\Desktop> ping google.com
      
      Pinging google.com [172.217.163.46] with 32 bytes of data:
      Reply from 172.217.163.46: bytes=32 time=2ms TTL=64
      Reply from 172.217.163.46: bytes=32 time<1ms TTL=64
      Reply from 172.217.163.46: bytes=32 time=1ms TTL=64
      Reply from 172.217.163.46: bytes=32 time=1ms TTL=64
      
      Ping statistics for 172.217.163.46:
          Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
      Approximate round trip times in milli-seconds:
          Minimum = 0ms, Maximum = 2ms, Average = 1ms
      ```

  - `ping www.google.com`这不一定能够ping通(而且格式和上一条命令的结果不同)

    ```
    PS C:\Users\cxxu\Desktop> ping www.google.com
    
    Pinging www.google.com [::1] with 32 bytes of data:
    Reply from ::1: time<1ms
    Reply from ::1: time<1ms
    Reply from ::1: time<1ms
    Reply from ::1: time<1ms
    
    Ping statistics for ::1:
        Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
    Approximate round trip times in milli-seconds:
        Minimum = 0ms, Maximum = 0ms, Average = 0ms
    ```

    

- 值得注意的是

  - `ping "www.google.com"`

  - `ping www.google.com`

    

#### curl

- `curl www.google.com`

  ```
  PS C:\Users\cxxu\Desktop> curl www.google.com
  curl: (7) Failed to connect to www.google.com port 80 after 2224 ms: Connection refused
  
  ```

- `curl google.com`

  ```
  PS C:\Users\cxxu\Desktop> curl google.com
  <HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
  <TITLE>301 Moved</TITLE></HEAD><BODY>
  <H1>301 Moved</H1>
  The document has moved
  <A HREF="http://www.google.com/">here</A>.
  </BODY></HTML>
  
  ```

  

- wget也可

## 代理流量详细日志

如果浏览器中设置了某些代理配置或者插件(比如proxyfy)那么浏览器必须要在clash运行之后才能够上网,也就是流量会通过clash分配和检测(左上角的流量监测不仅可以监测转发到服务器的流量,如果只是中国直连的流量也是可以监测到的)

如果我们的代理服务器规则合理,那么在规则模式下,访问国内的网站一般走的是中国大陆直接访问(不会经过代理服务器,Clash会直接转发流量,而不会转发到服务器)

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/350535b78a1d48bd87f20238c579101a.png)





