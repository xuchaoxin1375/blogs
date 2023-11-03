# t搭建您的第一给网页(2021.12 实践)

搭建材料

-   基于腾讯云 CentOS7 实例

-   tamcat v8.5.55

    -   tomcat 相应的历史版本下载:

    -   ![img](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/20211203201842.png)

-   java-sdk 17.0.1(包的大小比 java8 反而要小)

    -   java 1.8(java8)之后均可

***

## 参考资料

这里列举出我认为比较靠谱的:

-   腾讯官方手册:[云服务器 手动搭建 Java Web 环境 - 最佳实践 - 文档中心 - 腾讯云 (tencent.com)](https://cloud.tencent.com/document/product/213/38234)

    -   网络上搜到的有很多文章是来自腾讯社区(论坛)里的文章,和官方手册(文档中心)比起来质量还是稍微差一些.

    -   [推荐资料来源: 腾讯云文档中心 - 腾讯云 (tencent.com)](https://cloud.tencent.com/document/product)

    -   启动配置后的输出:

-   简单配置如下:

    -   确保您本地安装了某个版本的 java

        -   可以是阉割版的 openJdk

        -   通过 yum install

    -   ![img](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/20211203202250.png)

    -   startup.sh 运行之后的结果将类似于下方

    -   ![img](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/20211203204351.png)

    ***

    \[Road 2 Coding (r2coding.com)

    ]\(<https://r2coding.com/#/README)[熬10天夜，肝出了这个PDF版「软件安装手册」> (qq.com)]\(<https://mp.weixin.qq.com/s/YNOZSQ5smo1uGE5ZttUZ_w>)

    ### 注意坑点

-   如果服务启动起来之后,你的浏览器还是无法通过公网访问相应的网页,那么请考虑重启服务器实例

    -   这可能是某些配置或者更改没有生效所导致,也可能是其他的一些不当操作产生的影响所致

    -   我就是重启之后才能够成功访问页面(linux 虽然号称不用关机,但有时重启一下机器还是可以帮你省事许多.)

    -

-   其实可以配置的地方有很多

    -   防火墙配置

    -   开方访问的默认端口更改

    -   开机自动启动 tomcat 服务

    -   ...诸多配置

-   使用 `tar.gz`来安装(或者说抽取)软件是常用的方法(我的感觉是,使用 deb/rpm 包安装的软件倒是不好把握,tar.gz 更为诸多类型的 linux 发行版所通用.)
