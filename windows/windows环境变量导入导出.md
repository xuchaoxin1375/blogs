

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

