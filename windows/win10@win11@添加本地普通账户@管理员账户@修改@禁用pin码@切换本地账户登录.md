[toc]

# win10@win11@添加本地普通账户@管理员账户@修改@禁用pin码@切换本地账户登录

## 登录Microsoft账户🎈

- [Microsoft 帐户 | 主页](https://account.microsoft.com/?refd=login.live.com)
- 可以进行密码修改等操作

### 修改账户密码

- [更改密码 (live.com)](https://account.live.com/password/change?refd=account.microsoft.com&fref=home.banner.changepwd)
- [Change your Microsoft account password - Microsoft Support](https://support.microsoft.com/en-us/account-billing/change-your-microsoft-account-password-fdde885b-86da-2965-69fd-4871309ef1f1)

### 其他Microsoft账号相关链接

####  个人office

- [个人主页| Microsoft 365 (office.com)](https://www.office.com/?ui=zh-CN&rs=CN&auth=1)

#### 组织office

- [组织|Home | Microsoft 365 (office.com)](https://www.office.com/?auth=2&home=1)

#### oneNote

- 管理组织账号的onenote笔记本(用于删除笔记本清单中的历史/已废弃笔记本)

  - [org|OneNote | Microsoft 365 (office.com)](https://www.office.com/launch/onenote?auth=2&home=1)

  

## 使用`netplwiz`程序创建和管理用户

- 该方法比较通用

- 按win+r

- 输入netplwiz 回车

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/2021011923164753.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210119231609855.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | 添加用户                                                     | 选择本地账户                                                 |      |


## 将某个用户提升为管理员🎈

- 根据需要,可以选择将某个用户设置为系统管理员

![在这里插入图片描述](https://img-blog.csdnimg.cn/2021011923153212.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  直接创建一个管理员账户😊

###  使用`lusrmgr.msc`程序创建

- 按下win+R
- 输入`lusrmgr.msc`

### 先新建一个用户

- 左侧栏的Users选项卡

- 右键新建一个用户(默认为普通用户)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/aa26ccecf5184038b0c14a2e107238ed.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)

- 创建完后,如果没有报错,就可以关闭窗口了
  - windows这里没设计好,创建完一个后不会关闭刷新,而是让你继续创建
  - 手动刷新用户列表


#### tips:

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

##  同步Microsoft设置

- 注意,选择本地账户的话,将无法使用同步功能
  - 可以通过切换改用microsoft账户

###  切换:本地账户和Microsoft账户登录


- 注意,如过用来登录的账户在本设备上已经有的话(而且没有注销)那么可能会让你换一个账号登录

### 切换使用本地账户登录@Microsoft账号登录🎈

- win11 22H2之前的版本

  - [Switch your Windows 10 device to a local account - Microsoft Support](https://support.microsoft.com/en-us/windows/switch-your-windows-10-device-to-a-local-account-eb7e78a9-88ee-9bc3-8f06-831b56e339fd)
  - Save all your work.
  - In **Start** , select **Settings** > **Accounts** > **Your info**. 
  - Select **Sign in with a local account instead**.

  - | ![在这里插入图片描述](https://img-blog.csdnimg.cn/5e05da7d5fca4a6fa8cc9ef1f926b699.png) |
    | ------------------------------------------------------------ |
    | win11 22H2之前的版本                                         |

- win11之后的版本,如果还想要创建本地用户,可以借助`netplwiz.exe`来创建

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/5251d0ec6319412cb0878d2a55973bbd.png)

  

## 账户@PIN码

### 修复PIN不可更改的问题

#### 权限问题

- 这里借助第三方工具Dism++的文件浏览器
  - 中文名叫`春哥附体`
  - 作用是可以无视权限修改/删除某系文件(夹)(部分情况下)
    - 有时候可以处理管理员权限(Administraor也无法执行的操作)

#### 删除Ngc文件夹

- 如果你的计算机登录过学校或者工作组织的邮箱注册的微软账号,您的计算机可能受到意了之外的控制
  - 比如无法自由的修改PIN码等限制
  - 这时候可以考虑退出组织账号
- 但是有时候因为(保留文件)重置系统,导致登录选项@账号问题的出现
- 经过参考论坛,找到一个可能的解决办法
  - [Unable to change PIN for Sign-In - Microsoft Community](https://answers.microsoft.com/en-us/windows/forum/all/unable-to-change-pin-for-sign-in/64919f1b-3ac4-4bf7-852f-abdb99b905a0)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/8926e5cd913446b38997059241e6ce1d.png)


- 回到账户设置,发现可以设置PIN码
  - 但这并不一定奏效
  - 因为在设置的最后一步可能会报错失败!

#### 创建新账户设置PIN

- 新建一个账户尝试创建PIN,但这依然不一定成功

#### 重置计算机

- 如果真是这样,可能系统文件错误/缺失,可以考虑备份数据后,重置计算机
  - 保留数据重置会删除掉安装的程序,但是媒体文件(图片,视频)可以保留



