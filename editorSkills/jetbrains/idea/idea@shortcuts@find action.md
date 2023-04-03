[toc]



## ref

- [Double Shift to Search Everywhere | The IntelliJ IDEA Blog (jetbrains.com)](https://blog.jetbrains.com/idea/2020/05/when-the-shift-hits-the-fan-search-everywhere/)
- [Search by name | JetBrains Rider](https://www.jetbrains.com/help/rider/Navigation_and_Search__Search.html)
- [Go to Class | JetBrains Rider](https://www.jetbrains.com/help/rider/Navigation_and_Search__Go_to_Class.html)

## search everywhere@命令面板(find actions)🎈

- 默认的,idea使用双击`shift`键来唤醒`search everywhere`
  - 但是有时这个快捷键不是我们想要的,可以通过设置来关闭:
  - Preferences->Advanced Settings-> Disable double modifier key shortcuts
- 某些功能的打开方式记不起来,在这里搜索,还可以看到相应的快捷键.(再也不用担心记不住快捷键了)
- actions只显示当前可用(可以执行的)指令
  - 譬如某些开关(已经处于关闭的状态,再搜索`close...`将得不到想要的指令!

### 例隐藏侧边栏

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/87902593522a4190bc80c427723e998d.png)
- 关闭后,再次搜索同样的关键词,可用指令列表发生变化

- 找不到`Hide side Tool windows`了
![在这里插入图片描述](https://img-blog.csdnimg.cn/b3a50e2cf2634f168eae82a1a2d545ee.png)

- configure the shortcut:
可以增设一个`ctrl+shift+p`的shortcut(和vscode一样)
![在这里插入图片描述](https://img-blog.csdnimg.cn/2c9506d73aaa47b3894fb2d0a8c847dd.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

##  命令面板中立刻修改某些指令的快捷键

- 在命令面板中看到的快捷键(IDEA提示你可以直接为当前选中的指令分配快捷键(但是某些指令是无法分配的,比如set keymap)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/711c547a2999458f85686607bbd555b1.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

###  例:修改换行(wrap)快捷键

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/d0dcac8a0b5b4a9f891260aae208b4f0.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/71819bffe4c84b8fbeead335f727952d.png) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |



### 例:查看keymap相关命令

- 注意是`Action`选项卡下的结果

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/82649a74beb04192b0fe3ba5a937fff8.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_17,color_FFFFFF,t_70,g_se,x_16)
- 看到`set keymap`
- 之后想要修改快捷键,在这里搜索`set keymap`可以直达.
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/d9578518b78640ba8bc18ee32a508291.png)

##  打开项目文件(Go to file)

- search file by name
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/63421c0abc1a4a8e948be616627c7133.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_17,color_FFFFFF,t_70,g_se,x_16)

### 例子: 项目结构管理:

![在这里插入图片描述](https://img-blog.csdnimg.cn/dc1ebfb34174487fb0ca5bf7d57baaae.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_17,color_FFFFFF,t_70,g_se,x_16)

#  IDEA官方快捷键全表本地查看
- 在命令面板中搜索:
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/e4a7de87c1de45a59f4d931a008d4dcc.png)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/2f3a81d252a94719b45e2b76583d1e5a.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

