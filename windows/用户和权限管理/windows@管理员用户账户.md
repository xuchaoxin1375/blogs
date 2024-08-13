[toc]



## windows中的管理员用户账户

### 管理员组策略配置

- [用于内置管理员账户的管理员批准模式-CSDN博客](https://blog.csdn.net/ifu25/article/details/89786181)
- 配置:提升自建账户权限，自建账户将拥有和 "Administrator"管理员账号一样的权限

### 命令行管理用户和组

- 参考[windows@命令行管理用户和用户组-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/137403116?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"137403116"%2C"source"%3A"xuchaoxin1375"})
- 本文介绍GUI的操作

### 将某个用户提升为管理员🎈

- 根据需要,可以选择将某个用户设置为系统管理员

![在这里插入图片描述](https://img-blog.csdnimg.cn/2021011923153212.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

###  直接创建一个管理员账户😊

###  使用`lusrmgr.msc`程序创建

- 按下win+R
- 输入`lusrmgr.msc`

#### 先新建一个用户

- 左侧栏的Users选项卡

- 右键新建一个用户(默认为普通用户)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/aa26ccecf5184038b0c14a2e107238ed.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)

- 创建完后,如果没有报错,就可以关闭窗口了
  - windows这里没设计好,创建完一个后不会关闭刷新,而是让你继续创建(应该弹出一个创建成功的窗口比较好)
  - 手动刷新用户列表,检查新用户是否成功创建

#### FAQ

- 新用户名不可以和旧用户名冲突(重复)

- 如果您的当前的用户名(设为old)下出现系统环境问题(比如账户登录问题)

  - 考虑新建一个系统维护者maintainer账户(管理员组)
  - 退出当前账户
    - 如果您的账户是用Microsoft账户登录的,那么建议您用切换为本地账户
    - 然后登出
    - 这是为了避免同一个账户在同一台计算机下,不能同时登录作为多个账户
  - 登录到maintainer
  - 执行`lusrmgr`程序,删除掉old账户
    - 如有必要,删除old用户的家目录
  - 新建一个和old同名的账户,保持一致的用户名
    - 这么做的代价是,原来的old账户下家目录的某些软件可能无法在使用
    - 比如wsl子系统等

  

##  在管理员组中添加新用户为管理员🎈

### 方式1:手动输入


![在这里插入图片描述](https://img-blog.csdnimg.cn/db6a1242a2b846a9b07ca0900a9ae153.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

### 方式2:在已有的用户列表中查找并选中

![在这里插入图片描述](https://img-blog.csdnimg.cn/0f3c0f58178f44fb8303d3444a923d8d.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

### 修改/禁用pin码(普通情况)

- 打开路径:settings->Accounts->sign-in options->windows Hellow PIN
  - [Change your PIN when you’re already signed in to your device - Microsoft Support](https://support.microsoft.com/en-us/windows/change-your-pin-when-you-re-already-signed-in-to-your-device-0bd2ab85-b0df-c775-7aef-1324f2114b19)

- 如果不可更改,那和可能是组织账号(organization account)的关系
- 可以考虑断开链接后,重新修改pin,然后再登录组织账号

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/74e86e9a0b564f5ea516348025a4a6ae.png)

