[toc]



## chfs(CuteHttpFileServer)

- 本文介绍chfs的用法,该软件比较简单易用,轻量灵活(免费)

- 几乎不用配置防火墙和共享站点的根目录的权限控制

- 同时给出http和webdav的链接,用浏览器就可以进行webdav传输,享受webDav的优点

- 浏览器所有设备几乎都有,因此可以不下在专门的客户端

  

### 下载软件

- 根据上述提供的官网,下载可执行文件
  - 如果是计算机老手,可以考虑用命令行,更加轻量
  - 如果图方便或者是电脑新手,用GUI也是极好的(及其简单,可以将软件语言切换为中文,可以快速配置)
  - 复杂配置也建议用GUI比较方便
- 官网同时就是使用文档和使用说明书



### GUI方案

- |                                                              |                        |
  | ------------------------------------------------------------ | ---------------------- |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/0ca405796f814c9d888f723ed4642673.png) | 支持语言切换和配置导出 |

- 软件启动:配置完成后,点击左上角的按钮切换服务启动或关闭状态

- 右上角可以切换语言和配置导出,观察操作日志

- 至此就可以实现方便的局域网内传输



## 补充

### 命令行方案

- 这里假设用户有命令行使用经验
  - windows比如cmd或者powershell都可以
  - 这里我用powershell

#### 命令行程序定位

- 找到下载好的命令行可执行文件,比如**D:\exes\chfs-windows-x64-3.1\chfs-windows-x64-3.1.exe**

- 复制其所在目录,在命令行中定位到可执行文件

  - ```powershell
    PS D:\exes\chfs-windows-x64-3.1> rvpa .\chfs-windows-x64-3.1.exe
    
    Path
    ----
    D:\exes\chfs-windows-x64-3.1\chfs-windows-x64-3.1.exe
    
    PS D:\exes\chfs-windows-x64-3.1> sal chfs (rvpa .\chfs-windows-x64-3.1.exe)
    
    
    ```

  - 这里我为文件**chfs-windows-x64-3.1.exe**起了个别名,方便后面引用该程序

    - `sal chfs (rvpa .\chfs-windows-x64-3.1.exe)`
    - 也可以直接修改可执行文件的名字(或者配置别名到shell的配置文件中,今后在命令行任意位置都可以访问到该程序)

  - 检查文档:`chfs --help`

  - ```
    PS D:\exes\chfs-windows-x64-3.1> chfs --help
    Usage of D:\exes\chfs-windows-x64-3.1\chfs-windows-x64-3.1.exe:
      -file string
            Configuration file.
      -path string
            Shared directories, separated by '|'. (default ".")
      -port uint
            HTTP listening port. (default 80)
      -version
            Print version.
    ```

#### 简单创建服务站点

- 例如:`chfs -path D:\1WebDav\ -port 8084`

  - 该命令指出,将目录`D:\1WebDav`作为共享站点根目录,端口设置为`8084`(能用就行,不能用时(和其他服务冲突时),稍微改改数值)

- ```
  PS D:\exes\chfs-windows-x64-3.1> chfs -path D:\1WebDav\ -port 8084
  
  **************************************************
            CUTE HTTP FILE SERVER 3.1
            Homepage: http://chfs.iscute.cn
             Author: docblue@163.com
  **************************************************
     Shared path: D:\1WEBDAV
  Listening port: 8084
        Websites: http://192.168.1.46:8084
     Webdav URLs: http://192.168.1.46:8084/webdav
  ```

#### 使用配置文件配置细节

- 有时WebDav客户端(软件)需要使用用户名密码登录才可访问站点,这时我们要用配置文件配置更多细节

- 考虑到可维护性,建议从官网下载模板,然后根据模板内的注释说明配置需要的条目即可

  - [iscute.cn/asset/chfs.ini](http://iscute.cn/asset/chfs.ini)
  - 您可以打开这个模板链接,复制全部内容,然后在找得到的地方(推荐在chfs所在目录下创建文件`chfs.ini`)
  - 将模板内容粘贴到该文件,根据需要进行配置,样例放在末尾

- 根据配置文件,启动服务

  - `chfs -file  chfs.init`(文件名替换为你配置文件目录,如果在当前目录,则输入文件名即可)

- ```bash
  PS D:\exes\chfs-windows-x64-3.1> chfs -file .\chfs.ini
  
  **************************************************
            CUTE HTTP FILE SERVER 3.1
            Homepage: http://chfs.iscute.cn
             Author: docblue@163.com
  **************************************************
     Shared path: D:\MINGW64
  Listening port: 8084
     Config file: .\chfs.ini
        Websites: http://192.168.1.46:8084
     Webdav URLs: http://192.168.1.46:8084/webdav
  
  2024-01-09 10:30:32 - 192.168.1.46 - user(tester) download '/33.txt'
  2024-01-09 10:30:41 - 192.168.1.46 - user(tester) download '/33.txt'
  2024-01-09 10:30:50 - 192.168.1.46 - user(tester) update text file:'33.txt'
  ```



### 使用软连接或符号链接等手段将向共享站点的根目录添加文件

- 如果将文件复制到共享站点根目录,可能会产生重复文件,造成资源浪费

- 可以考虑用软连接等方法尽可能减少对其他文件的影响

  - powershell和bash在各自平台上都可以创建类似的符号

- 另外chfs支持添加不同目录到分享站点

  - |                                                              |                                        |
    | ------------------------------------------------------------ | -------------------------------------- |
    | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/660162977a1b44e79815866da354f4e9.png) | 将两个(或更多)独立文件夹添加到分享站点 |

  - 这个操作对http有效,但是webdav仍然只显示一个首个目录

### 开机自启👺

- 如果您只是偶尔使用(局域网文件传输),那么不建议开机自启
- 如果经常使用,则建议开启开机自启
  - GUI软件勾选开机自启以及随软件启动运行
  - 如果是命令行版本,可以用nssm包装成服务,这样开机就会自动运行

#### 服务包装

##### nssm包装

- 命令行版可以用nssm包装成服务运行(支持老的windows系统)

- 将nssm配置到环境变量,或者配置别名

- 执行`nssm install chfs_service`,表示要安装(包装)一个名为`chfs_service`的可执行程序

- 名字可以自行指定,关键是路径和参数(启动方式默认即可(自动(Automatic)))

- 填写完后点击安装

- |                                                              |                                                              |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/8acd981ec14140139491b34513960cb5.png) | 输入参数和命令行执行时添加的参数一样(可以是配置文件,配置参数也可以是直接写明在参数字符串中) |


##### 使用powershell包装

- [New-Service (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-service?view=powershell-7.4&viewFallbackFrom=powershell-7)
  - 参考文档给出了操作方法
  - 这里我们没有成功启动

#### 服务启动

- 重启计算机检查效果(会自动启动服务)
- 或者直接打开`service.msc`,找到刚才创建的服务,直接在面板中启动
- 或者管理员权限,命令行中用nssm启动:`nssm start chfs_service`

#### chfs服务@检查服务运行情况



- |                                                              |                          |
  | ------------------------------------------------------------ | ------------------------ |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/044d9a66e2c7485a91d79e5f519578a2.png) | 重启后相关服务会自行启动 |

- 使用powershell检查

  - ```bash
    PS C:\Users\cxxu\Desktop> Get-CimInstance -ClassName Win32_Service -Filter "Name='chfs_service'"
    
    ProcessId Name         StartMode State   Status ExitCode
    --------- ----         --------- -----   ------ --------
    0         chfs_service Auto      Stopped OK     0
    ```

    

  - 或者

    ```powershell
    PS C:\Users\cxxu\Desktop> gsv chfs*
    
    Status   Name               DisplayName
    ------   ----               -----------
    Running  chfs_service       chfs_service
    
    PS C:\Users\cxxu\Desktop> gsv chfs_service |select *
    
    UserName            : LocalSystem
    Description         :
    DelayedAutoStart    : False
    BinaryPathName      : D:\exes\nssm\nssm.exe
    StartupType         : Automatic
    Name                : chfs_service
    RequiredServices    : {}
    CanPauseAndContinue : False
    CanShutdown         : True
    CanStop             : True
    DisplayName         : chfs_service
    DependentServices   : {}
    MachineName         : .
    ServiceName         : chfs_service
    ServicesDependedOn  : {}
    StartType           : Automatic
    ServiceHandle       :
    Status              : Running
    ServiceType         : Win32OwnProcess
    Site                :
    Container           :
    ```

### 配置vbs脚本开机启动

- windows有个startup目录,将脚本快捷方式放到里头可以开机自启,这里不赘述(另见它文)

- 脚本内容

  - ```vbscript
    Dim ws
    Set ws = Wscript.CreateObject("Wscript.Shell")
    ws.run "chfs.exe --file ./chfs.ini",vbhide
    Wscript.quit
    
    ```

  - 其中`chfs.exe`需要替换为绝对路径(更改工作路径也行,但是独立使用该脚本是请执行替换)

### 效果

- 浏览器端支持上传下载删除搜索文件等操作,通常别人要发文件给你或者你要发文件给别人,都可以让对方打开浏览器输入你的ip和端口,进行基本的访问和传输操作
- 至于webDav链接需要配置一些东西,给自己使用为主,例如手机上安装cx file explorer,将计算机挂载到手机上
- 无论是哪种协议,都可以在线点播常见格式的视频,音频或则编辑文本

|                                                              |                                                              |      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/f68cea91d5af41288491be96f9f2153c.png) | 可以修改文本文件或重命名                                     |      |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/5c2af7c304424f19804b81d23d559595.png) | 局域网内挂在webdav<br />如果是本机的WebDav协议,可以用localhost来代指具体的ip<br />如果要和局域网内的其他人共享,那么其他windows设备就不是用localhost,而是用服务器(本机)的ip了 |      |
|                                                              |                                                              |      |



### 附:模板配置

- ```bash
  #---------------------------------------
  # 请注意：
  #     1，如果不存在键或对应值为空，则不影响对应的配置
  #     2，配置项的值，语法如同其对应的命令行参数
  #---------------------------------------
  
  
  # 监听端口
  port=8084
  
  
  # 共享根目录，通过字符'|'进行分割
  # 注意：
  #     1，带空格的目录须用引号包住，如 path="c:\a uply name\folder"
  #     2，可配置多个path，分别对应不同的目录
  path=D:\share 
  path=C:\Users\cxxu
  #path="D:\MinGW64"
  
  
  
  # IP地址过滤
  allow=
  
  
  # 用户操作日志存放目录，默认为空
  # 如果赋值为空，表示禁用日志
  log=D:\exes\chfs_home\log
  
  
  # 网页标题
  html.title=chfs创建的文件中心站点@由配置文件控制细节
  
  
  # 网页顶部的公告板。可以是文字，也可以是HTML标签，此时，需要适用一对``(反单引号，通过键盘左上角的ESC键下面的那个键输出)来包住所有HTML标签。几个例子：
  #     1,html.notice=内部资料，请勿传播
  #     2,html.notice=`<img src="https://mat1.gtimg.com/pingjs/ext2020/qqindex2018/dist/img/qq_logo_2x.png" width="100%"/>`
  #     3,html.notice=`<div style="background:black;color:white"><p>目录说明：</p><ul>一期工程：一期工程资料目录</ul><ul>二期工程：二期工程资料目录</ul></div>`
  html.notice=
  
  
  # 是否启用图片预览(网页中显示图片文件的缩略图)，true表示开启，false为关闭。默认关闭
  image.preview=true
  
  
  
  # 下载目录策略。disable:禁用; leaf:仅限叶子目录的下载; enable或其他值:不进行限制。
  # 默认值为 enable
  folder.download=
  
  
  
  #-------------- 设置生效后启用HTTPS，注意监听端口设置为443-------------
  # 指定certificate文件
  ssl.cert=
  # 指定private key文件
  ssl.key=
  
  
  
  # 设置会话的生命周期，单位：分钟，默认为30分钟
  session.timeout=
  
  
  # 文件/目录删除模式：
  #    1: 安全删除：移动到系统回收站 [不是所有操作系统都支持，建议使用前进行测试。默认模式]
  #    2: 安全删除：移动到chfs的专属回收站: ~/.chfs_trashbin， 程序会删除存储超过1个月的文件
  #    3: 真正删除
  file.remove=1
  
  
  #----------------- ------------------------
  # 注意： 账户配置区域放置到配置文件的后面
  #------------------------------------------
  
  
  
  #----------------- 账户及控制规则 -------------------
  #     [xxx] xxx即为账户名, 访客的用户名为guest
  #     password 账户密码
  #     rule.default 账户对所有的目录和文件的访问权限，但可以针对任意子目录进行重新设定访问权限，以覆盖默认的权限(设置成d,表示最高权限(读,写,删除))
  #     rule.none 表示对哪些子目录设置为不可访问的权限，多个目录使用字符'|'分割，也可以分为多行。注意：该子目录本身也不可访问！
  #     rule.r 表示对哪些子目录设置为读权限，多个目录使用字符'|'分割，也可以分为多行。注意： 该子目录本身不受影响，影响的只是它所包含的目录和文件！
  #     rule.w 表示对哪些子目录设置为写权限，多个目录使用字符'|'分割，也可以分为多行。注意： 该子目录本身不受影响，影响的只是它所包含的目录和文件！
  #     rule.d 表示对哪些子目录设置为最高访问权限，多个目录使用字符'|'分割，也可以分为多行。注意： 该子目录本身不受影响，影响的只是它所包含的目录和文件！
  #
  #   示例：
  #        [foo]
  #        password=bar
  #        rule.default=r
  #        rule.none=d:\公司制度|d:\财务票据
  #        rule.r=d:\施工项目\2021年
  #        rule.r=d:\施工项目\2022年
  #        rule.d=d:\个人目录\foo
  #
  #    该账户名为foo，密码为bar，默认访问权限是读权限，但账户没有“d:\公司制度”和“d:\财务票据”的访问权限，且
  #    对“d:\施工项目\2021年”和“d:\施工项目\2021年”只有读权限，对“d:\个人目录\foo”有最高访问权限。
  #
  
  
  #账户xxx,访客的用户名为guest
  [cxxu@dav]
  password=1
  rule.default=d
  rule.none=
  rule.r=
  rule.w=
  rule.d=
  ```



## FAQ

### 浏览器无法打开

- 首先检查端口号是否正确,默认80端口可以不用输入,否则要明确指出端口号

- 浏览器代理设置可能导致无法打开本地的http链接,例如proxy switchOmega,需要将本地ip(私有ip)过滤掉
  - 插件默认过滤127.0.0.*
  - 但是可能不会过滤192.168.*
- 或者用`localhost:port`也可以访问,例如chfs提供的链接是:` http://192.168.1.46:8084`,则浏览器输入` http://localhost:8084`也行

### 关于权限问题(访问控制)

- 网页(http链接)打开的页面目前可以访问所有文件;而登录受限的用户后只能访问受配置文件约束的若干资源
- 这点有些不正常,但是不影响webdav的传输

### 日志

- 保存日志,需要指定日志存储目录,如果指定一个不存在的目录,日志文件将无法保存
- 所以如果要保存的路径需要检查存在性,不存在手动创建一下

### 无法连接问题👺

- 通常chfs可以良好的工作,特别时网页端,是很鲁棒的
- 对于webdav,您需要注意
  - 如果您在使用了符号连接(或软连接等)链接到其他文件夹或文件,当这些链接目标都存在于正确的路径时,chfs
  - 但是如果符号所指的路径被更改移动走了,那么webdav的访问将会出错(其他设备无法挂载webdav)

#### 故障排查@引起chfs webdav无法被挂载的原因

- 可以在全新的位置建立一个文件夹,然后令chfs将这个新文件夹作为服务站点根目录
- 如果新目录下可以工作,那么将原来出问题的目录的文件一点点移动到新目录,并刷新挂载端是否能够正常挂载
- 继续执行文件移动,直到找到引起问题的路径(文件夹)
- 我就是如此排查故障的

### 其他

- 详情参考官网

## 其他软件

### HFS

- 上面提到的chfs虽然方便也免费,但是不开源(在github上只有一个readme,多年不更新了)
  - [HFS ~ HTTP File Server (rejetto.com)](http://www.rejetto.com/hfs/?f=intro)这是一个开源免费的软件,主要支持http协议传输,同样有网页可用
  - 项目开源[GitHub - rejetto/hfs: HFS is a web file server to run on your computer. Share folders or even a single file thanks to the virtual file system.](https://github.com/rejetto/hfs)

### Alist

- 功能丰富,社区活跃的存储和共享软件Alist

