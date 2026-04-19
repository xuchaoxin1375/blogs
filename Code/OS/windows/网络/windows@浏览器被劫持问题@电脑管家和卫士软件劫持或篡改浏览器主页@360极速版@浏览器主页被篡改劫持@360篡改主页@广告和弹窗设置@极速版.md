[toc]

## abstract

- windows@浏览器被劫持问题@电脑管家和卫士软件劫持或篡改浏览器主页
- 360安全卫士极速版代替普通版360安全卫士
- 计算机厂商自带电脑关键篡改或劫持浏览器主页

## 软件篡改浏览器主页

- 为了便于讨论，这里统称360安全卫士和其他电脑管家类软件为**管家软件**
- 例如360安全卫士，如果您使用360,且不想卸载它,那么当你启动360后,它可能会篡改你的浏览器(比如edge)的主页`start page`为360
- 早期可能是通过修改快捷方式的`target`等属性,但是现在变得更加隐蔽,在注册表层面做文章!
- 联想电脑管家也可能做出默认的锁定，并且默认锁定的网页往往不是用户想要的，用户想要通过浏览器自带的主页设置修改为自己想要的主页都是无效的，我认为厂商的这种做法是不恰当的
- 特别是两个管家类软件都想要竞争锁定主页，会有一方失败，例如360安全卫士和联想笔记本的电脑管家之间的设置，360主页防护会失败（360想要篡改为360搜索，联想电脑管家想要篡改为百度搜索，是通过`discovery.lenovo.com.cn/home/ilive/v1/c1`这个链接重定向到百度

## 360安全卫士的主页防护和篡改

## 方法1

- 最好的办法就是打开360安全卫士(对于这个方法,如果卸载掉了得安装回去)
- 打开功能大全,里面的有个**主页防护**功能,我们将所有的主页**锁定全部取消**
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/bc771d90923e47bba46a05ebdcf5f78f.png)

### 锁定浏览器主页

- 360的锁定主页功能十分顽固,随着版本的更新,不仅把注册表改了,还可能注册开机自启等相关服务来反复设置360主页
- 想要自己指定主页也可以,如果不想指定的话就不要锁定浏览器主页了,那么360完全网址导航就不会设置为浏览器主页
- 以edge为例,默认的浏览器主页为`edge://newtab`,它不是http(s)协议的链接,360拒绝将其设为主页,那怎么办?解锁后就不要管它即可,edge启动后会打开自己的主页(newtab)

## 方法2

- 我们借助[Registry Finder (registry-finder.com)](https://registry-finder.com/)来查找注册表中得`hao.360`相关字段,可以发现4个路径得`start page`被默认修改为`hao.360.com`
- 一个推荐的方式是打开360:功能大全->**主页防护**->解锁所有浏览器->更改主页(比如空白页或者自己喜欢的主页)->一键锁定

### 注册表修改

- 这个方法不是很彻底,在360启动的时候修改将无法进行,而且在360运行起见,打开edge依然会被定向到`hao.360.com`

- 但是如果您已经将360卸载,那么可以这么作

- 用**管理员权限**打开powershell

- ```powershell
  $items=@("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main",
  "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main",
  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main",
  "HKEY_USERS\S-1-5-21-1862010897-3831421347-3551306287-1001\Software\Microsoft\Internet Explorer\Main")
  
  $items|%{reg query $_ /v 'start page'}
  
  
  
  ```

- 上述内容输入powershell回车,如果看到形如:

  - ```bash
    PS C:\Users\cxxu\Desktop> $items|%{reg query $_ /v 'start page'}
    
    HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main
        start page    REG_SZ    https://hao.360.com
    
    
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main
        start page    REG_SZ    https://hao.360.com
    
    
    HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main
        start page    REG_SZ    https://hao.360.com
    
    
    HKEY_USERS\S-1-5-21-1862010897-3831421347-3551306287-1001\Software\Microsoft\Internet Explorer\Main
        start page    REG_SZ    https://hao.360.com
    ```

  - 这正说明您的计算机浏览器主页被篡改为`hao.360.com`

- 删除这些注册表:

  - ```powershell
    $items|%{reg delete $_ /v 'start page'}
    ```

    - ```
      PS C:\Users\cxxu\Desktop> $items|%{reg delete $_ /v 'start page'}
      Delete the registry value start page (Yes/No)? y
      The operation completed successfully.
      Delete the registry value start page (Yes/No)? y
      The operation completed successfully.
      Delete the registry value start page (Yes/No)? y
      The operation completed successfully.
      Delete the registry value start page (Yes/No)? y
      ```

- 注意,如果采用此方法,此时您再次打开360,主页依然受360控制,除非360已经卸载,才推荐使用该方法

## 例

### 移除edge策略组

- ```bash
  PS C:\Users\cxxu\Desktop> reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge
  Permanently delete the registry key HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge (Yes/No)? yes
  The operation completed successfully.
  ```

- 这里操作的KeyName是`HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge`;

- 前面不要带`Computer`(直接从注册表编辑器中复制的路径是`Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge`,这不被命令行识别)

##  360广告和弹窗
- 360越来越过分了,本着偶尔杀毒,扫描网络故障的想法用一下,没有卸载掉,这广告项目是多得不得了,广告内容还是那么差,可以考虑其他查毒软件了(号称免费的软件其实往往并不免费,除了一些开源项目比较赞)
- 23年那会儿还没这么严重,加载广告也要占用计算机资源的,几遍你退出360卫士,后台的服务还是在运行的,可以进msconfig里面去停掉360的服务,或者找旧版的360,或者卸载它,或者有个极速版的
## 360极速版👺

- [360官网 软件下载](https://weishi.360.cn/)

- 相比于标准版,极速版显得良心许多,选择极速版即可,官网还提供了一些老版本,比如多年前的领航版

  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/dbf72590d24c404b9ec66597df9c492b.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/db7be486c5ec401aa9d4d96d592e39dc.png) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  |                                                              |                                                              |      |

## 假装卸载

- 其实360自己知道哪些地方可能会引起用户反感,如果用户想要卸载它时,360会试图挽留用户,并且告诉你诸如广告弹窗或者网页主页被篡改等行为开关
- 其实wps也有类似的操作
- 广告行为我们也能理解,比较要赚钱的,但是我们也有自己选择的权利
- 如果这些挽留对于你来说不够,那么就选择 狠心卸载.

## 小结

- 这会儿标准版360已经是弊大于利了,顶多考虑一下极速版
- 要么临时用一下,用完就卸载,过河拆桥被逼的😂,反正系统出大问题时360也解决不了,最后还是重置系统
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/1bd3924e6d03488e9e251a83dc85cccd.png)