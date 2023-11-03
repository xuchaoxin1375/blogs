@[toc]

## magisk的使用系列



### 隐藏root权限

#### 参考链接

- [Shamiko安装（Zygsik Hide 模块） - Magisk中文网 (magiskcn.com)](https://magiskcn.com/shamiko-install)
  -  这种方式我们还没有实践,但是也放在这里!
  -  这里提到了通过安装shamiko模块来实现隐藏root
  -  以及shamiko安装方式
  -  shamiko如何配置?
     - Shamiko 模块，会根据配置勾选的 排除列表 进行很好的隐藏（Hide）
- [Hide My Applist 使用教程 - Magisk中文网 (magiskcn.com)](https://magiskcn.com/hide-my-applist)
  - 这块不太了解,看看酷安 

- 这部分内容也挺重要,关乎某些银行类软件(设置是手机营业厅app)的使用
- 这一部分的操作过程由于我没有截图,所以不清楚的可以查看其他文章

> 但是解决方案各种各样,不同版本的magisk 和手机型号均可能产生不同的效果(有的甚至无效)

- 有使用第三方模块的(譬如shamio模块(估计是日本人开发的))
  - 这种方法其他人用的不少,我没试过

#### magisk替身

![image-20220727142732113](https://img-blog.csdnimg.cn/img_convert/e6bfa427fc76e739c1513320154ed066.png)

- 我采用magisk自带的zygisk和隐藏面具功能(这会创建一个magisk app的替身,可以混淆银行类app检测不到root)
  - 这种方式简单,但是可能导致第三方app的数据丢失(譬如需要重新登录账号)
  - 而且原来的magisk app图标会消失,取而代之的是一个简陋的app 图标(该app的名字是可以有你自己取名)
    - 默认名字是`settings`
    - 授权后,magisk替身app会提示`root`权限丢失
    - 此时原来的magisk app应该还在桌面上,你进入到`root`重新授权给这个替身app,这样替身就接管了原来magisk的功能和身份以及权限

## 刷入各种模块

### 获取magisk模块(optional)

- 可以到酷安论坛找找想要的功能模块
  - 耐心找找
  - 前面提供了一些
- [模块贴1 - 酷安 (coolapk.com)](https://www.coolapk.com/feed/37588281?shareKey=ODg1MTNiNjA2N2ZhNjJlMTNkMjY~&shareUid=5097617&shareFrom=com.coolapk.market_12.4)
- [K50最全root优化教程（流畅省电美化） 来自 Cx660 - 酷安 (coolapk.com)](https://www.coolapk.com/feed/37739778?shareKey=ZWUwZGQxNTliNjg2NjJlMTNlY2M~&shareUid=5097617&shareFrom=com.coolapk.market_12.4)
  - [该贴资源1 (lanzoui.com)](https://wwr.lanzoui.com/b03j5ih8b) 提取码: `5krx`
- [资源贴:模块大合集(coolapk.com)](https://www.coolapk.com/feed/37398134?shareKey=ZTRkMjQxMGZkYzI2NjJlZTAzOWY~&shareUid=5097617&shareFrom=com.coolapk.market_12.4)
- [收藏单分享 - 酷安 (coolapk.com)](https://www.coolapk.com/collection/2869939)
  - 我的收藏单,需要下载酷安查看




#### $\bigstar$模块虽好,可不要贪多

- 模块之间均可能存在嵌在的冲突,导致各种问题(性能下降/死机等)
- 有的模块会由于缺少维护而失效



### 刷入模块

- 刷入模块的客户端(GUI provider)不止有magisk 本身(替身app 也可以)
  - 浏览器下载或者其他途径下载号模块压缩包(通常不太大)
  - ![image-20220727143146223](https://img-blog.csdnimg.cn/img_convert/d456b20d98204105ce394c3f80e74c32.png)
  - 打开面具进行安装
  - 注意,有的模块会一些交互,譬如让你按`音量+`或者`音量-`,你按完才算正式刷入(例如上面的A1内存管理)
    - 此时会弹出`reboot`的按钮
    - 根据情况可以立即重启或者稍后重启(返回切走)
  - 有的模块会由于过时而失效,请不要过于惊讶
  - 甚至,某些模块导致相互冲突,使得手机变砖也有可能
  - 所以说,要回刷也好会救砖

### 其他客户端获取并安装模块

####  scene4&scene5

- 官方网站:
  - [Scene (omarea.com)](http://vtools.omarea.com/)
  - [Releases · helloklf/vtools (github.com)](https://github.com/helloklf/vtools/releases)

- `scene5`也有丰富的功能,可以授权给scene5,间接安装模块
- scene5 的root模式试用一段时间要收费的
- scene4是免费的
- 我就不展开了

####  爱玩机工具箱

- 功能丰富,但是不建议和scene5同时设置似的配置(譬如虚拟内存),容易发生系统异常
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7e867fc9a9944508a21cdaa5057dc703.png)
- 爱玩机magisk仓库
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/9df56aec00ea4bf9a2ea485b464333fb.png)



### 经典模块&使用体验

#### 调节zram和swapfile(虚拟内存)

- 虚拟内存谨慎调节
  - 对于某些设备设置了swapfile(是比较耗时的过程)和zram未必生效,而且可能会相互干扰可能导致zram无法正常使用,甚至容易引起死机
  - 还可能和系统自带的内存扩展(虚拟内存功能)发生冲突(猜测)
  - 建议保持默认即可

#### A1内存管理和钢铁后台效果测评

- 总的来说效果可以🆗
- 可以短时内保活较多数量的后台
- 会不会造成卡顿/动画掉帧?(或许会,但应该影响不大,但我用其他的省电调度,是有一定影响的)

### scene5性能调度和省电调度(yc uperf)

- scene5提供了性能调度(和省电调度)
  - tuner中设置 
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/679b6fc983d140d3ae03a958be871b80.jpeg)
  - app profile 可以设置单个应用的调度策略(游戏狂喜)

- 还提供了其他调度模块的下载引导
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/d0a1f459089c4867ad4b41e403e3b658.png)

####  使用细节

![在这里插入图片描述](https://img-blog.csdnimg.cn/af2341060fa647ed9e49913f36546f88.png)

- 点击后会弹出一个绘画框,可以修改当前app的电源策略
- 开启相关权限后,可以在通知栏上看到当前运行的app(前台活跃)的app的电源策略
- 譬如当前的telegram app是采用均衡模式(balance)
  而对于桌面动画相关(比如桌面启动器,app名称会显示system,建议采用均衡模式或更高,如果采用节能模式`save power`,会导致明显的卡顿和掉帧
- 又例子:调整edge 浏览器电源策略为balance
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/c5f1f0929455400d94a16b100705e293.jpeg)

####  scene5常驻后台&开启/关闭守护进程自启动

![在这里插入图片描述](https://img-blog.csdnimg.cn/232be8840f274d2595ba995d639fe995.jpeg)

####  电源调节&性能模式(fast)有用吗

- 有用,而且比官方提供的更加灵活和直观
- 下面是两次geekbench的跑分对比
- 后一次是开启fast模式跑的,分数显著提高,但是发热量随之上涨(dimensity 8100)
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/839f41b33ab84aff84f94fc0f05b2360.jpeg)
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/00067c5e7aa947bba825232fcc1dd15e.jpeg)

## lsposed&xposed框架的使用

### 相关框架的作用概览

- [magisk和xposed/lsposed 概要](https://www.bilibili.com/video/BV1w94y127Z4/?spm_id_from=333.788)

- [8个超实用功能模块推荐，让手机成为更好的工具 —— [Magisk&Xposed模块推荐 ep.1\]_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1fB4y1v7B5?spm_id_from=333.999.0.0)

### 安装lpsosed模块

- [LSPosed/LSPosed: LSPosed Framework (github.com)](https://github.com/LSPosed/LSPosed)
  - 安装方法和magisk 安装不同模块的方式一样
  - 下载LSposed包,magisk中选择本地安装zip文件即可
  - 重启,就可以看到桌面上多了一个LSposed的app应用图标(安装方式和常规的apk不同就是了)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/65cf54f19a9d4c89baa075ed70a4345e.jpeg)


### lsposed模块来源

- lsp官方仓库
  - 有时可能加载不出来,或许要科学上网
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/fea6ab6f99b646d09d0b52929ec530a9.png)

- 其他来源
  - 酷安资源贴
  - bilibili 相关视频下的评论区领取

### 搞机助手提供的模块仓库(magisk+LSposed模块)

- [酷安 - 发现科技新生活 (coolapk.com)](https://coolapk.com/)

- 搞机助手(GJZS.R):[搞机助手-官网 (lsdy.top)下载](https://lsdy.top/gjzs)
  - [主页 | 搞机助手·R (gjzsr.com)](https://gjzsr.com/)
  - [liuran001/GJZS: 搞机助手·R（原「搞机助手重制版」） (github.com)](https://github.com/liuran001/GJZS)
  - ![image-20220803093757368](https://img-blog.csdnimg.cn/img_convert/3017cc5a6f9a646a19ed9f4df0731b50.png)

#### 搞机助手提供的基础内容/网站

- 高级助手是众多搞机中对小白比较友好的玩机工具了
- 内置了一些教程/rom下载/recovery下载
- 例如
  - [首页 - 首页 - 👈萤火虫资源站 (kamiui.ml)](https://kamiui.ml/)

## 经典模块(lposed/xposed 应用)和使用举例

#### 小窗多开

- [MIUI13 小窗多开 来自 YifePlayte - 酷安 (coolapk.com)](https://www.coolapk.com/feed/35446014?shareKey=Yjg1OTY3NjFmZTUxNjJhYWFjZjQ)

####  试验系统版本

- MIUI13 (powered by android12 )

###  安装模块

  - 下载模块安装包并安装(通常以apk的形式提供),按照常规按照apk的形式按照即可
    - 这种为LSposed模块一般桌面可能没有启动图标

### 模块管理和配置

- 在lsposed中找到对应的模块名称,选择相应开关
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20d8da89f667480cb2a1ae019c4dd2f3.png)


#### 查看模块信息/配置

- 长按模块,查看View in Repo(sitory),可以查看官网(有的模块没有)
  - 如上图所示
- 或者在lsposed的在线仓库中搜索模块名称查看release/readme使用说明
- 也可以进行更新操作
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/ad3f8a71783841d6ae0ffc9a3638a001.png)


#### 这里以MaxFreeForm模块为例  

- 进入指定模块:maxFreeForm
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/fe948211e5934259805d862b67991d93.png)

  - 启用该模块
  - 指定该模块需要作用在那些app的运行时(这是lsposed比前辈xposed要灵活和改进的地方)
  - 还可以点击悬浮于右下角附近的进入模块的其他行为设置
    - ![image-20220803093950434](https://img-blog.csdnimg.cn/img_convert/d49777aaea69cdce78a69c2e94481101.png)

- 即,通过LSposed进行管理(譬如启用那个模块,模块要作用于那些app上)
- 另外,为了是配置生效,可能还需要再次重启手机!

####  miui多开效果预览

![在这里插入图片描述](https://img-blog.csdnimg.cn/ba53bd0e3a224b85b9c5160aba5a2a9e.png)

### MIUI工具箱(for LSposed)

- [ChiMi - Xposed Module Repository (lsposed.org)](https://modules.lsposed.org/module/chili.xposed.chimi)