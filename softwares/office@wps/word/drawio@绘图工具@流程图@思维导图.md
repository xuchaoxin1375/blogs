[toc]

- [drawing-app · GitHub Topics](https://github.com/topics/drawing-app)

- [Figma](https://www.figma.com/file/96EaDEuwW1rVmtgahmaZLP/Untitled?type=design&node-id=0-1&t=KxMYwtxjfMKTyoeF-0)

- [Create a SmartArt graphic from scratch - Microsoft Support](https://support.microsoft.com/en-us/office/create-a-smartart-graphic-from-scratch-fac94c93-500b-4a0a-97af-124040594842#:~:text=On the Insert tab%2C in,and then type your text.)

  

[toc]

- [drawing-app · GitHub Topics](https://github.com/topics/drawing-app)

- [Figma](https://www.figma.com/file/96EaDEuwW1rVmtgahmaZLP/Untitled?type=design&node-id=0-1&t=KxMYwtxjfMKTyoeF-0)

- [Create a SmartArt graphic from scratch - Microsoft Support](https://support.microsoft.com/en-us/office/create-a-smartart-graphic-from-scratch-fac94c93-500b-4a0a-97af-124040594842#:~:text=On the Insert tab%2C in,and then type your text.)

  

## refs



- [Diagrams with draw.io for Confluence: Our New User Documentation Is Online - draw.io (drawio-app.com)](https://drawio-app.com/blog/diagrams-with-draw-io-for-confluence-our-new-user-documentation-is-online/)
- [Tutorials - draw.io (drawio-app.com)](https://drawio-app.com/tutorials/)

- [Line start/end space in draw.io doesn't work? - Web Applications Stack Exchange](https://webapps.stackexchange.com/questions/113809/line-start-end-space-in-draw-io-doesnt-work)

##  drawio for vscode extension

- [Draw.io Integration - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio)

# 几何图形(元素)

##  添加几何图形



###  悬停选取方式

- 鼠标悬停于欲引出连线的图形元素的边框上
- `点击浮现`出来的箭头,选取更多图形元素

##  修改图形种类

可以修改图形种类(譬如将已有的矩形(矩形时默认形状)改为菱形rhombus;椭圆形(ellipse)

![在这里插入图片描述](https://img-blog.csdnimg.cn/b11f04535cae4661a00a129a509231fa.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

- 方式有许多,包括

- 默认快捷键(ctrl+E)
- 右键图形,`edit style`
- 点击选中图形,右侧面板点击`edit style`
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/553adf04768c4da9a702e8b527dbadd0.png)

- 将头部的图形(如果是矩形就添加一个名称)修改为对饮的几何图形的名称;

##  图形块的移动

- 一般来说,可以通过框选来批量选中要移动的图形群
- 但是某些时候(特别是图形很多很复杂,那么通过连通图为单位来移动是不错的选择)

##  选中单个连通图图形群 

配合快捷键效率更佳(`alt+shift+d`)(不是ctrl)
![在这里插入图片描述](https://img-blog.csdnimg.cn/b5fac20f030148e9b5cd1df61affaf83.png)


# 调整画板区域大小

- drawio 可以放大缩小,但是似乎没有直接调整画板(相对绘制的图形)大小的接口
- 不过drawio可以自动扩展画板(当您的图形元素溢出(或者被脱出当前画板时,就会自动扩展,而且会收缩视图)
- 扩张前
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/ff0290edc2684d70a90eeab5c0b20c48.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_19,color_FFFFFF,t_70,g_se,x_16)

- 扩张后
  - 
  - 可以看到背后的栅格(画板变大)

#  图像边界调节


点击图形,橙色点住橙色的点拖动,可以调整曲线

#  连线样式调整


调整说明:
进入模式:
选择connection & waypoint 后进入一个模式
![在这里插入图片描述](https://img-blog.csdnimg.cn/da81fc0c1f864ebcb16b5beb3e55f75e.png)

## 调整连线两端样式

无端点直线样式把line start 和line end 都设置为None即可(第一个选项)
![在这里插入图片描述](https://img-blog.csdnimg.cn/514c92a7296041cfb292f12cabb40675.png)

##  编辑连线上的文字:

只需要选中线条,直接键入内容即可
![在这里插入图片描述](https://img-blog.csdnimg.cn/abb40a73496d4d2db36be04cbf3ec3c4.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/c67c768cc5564e8598171ef4025bd41a.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_19,color_FFFFFF,t_70,g_se,x_16)

##  流图风格(直角/圆角/曲线)

- 右侧给出三中风格
  - sharp(棱角风格)
  - rounded(即下图示例) 
  - curved(曲线风格)
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/eeeaae363ffe4177a5efe7be7e90bea9.png)

#  添加绘图类型的符号集

##  添加更多图标

![在这里插入图片描述](https://img-blog.csdnimg.cn/01955e19ca26417da91ef04176871c35.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/fccaec6f5255429ab5b61686f6df6b7f.png)

例如添加UML常用形状集合
![在这里插入图片描述](https://img-blog.csdnimg.cn/33888b3a38974498ad6918f7f6990880.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_17,color_FFFFFF,t_70,g_se,x_16)

##  绘制思维导图

> draw io 可以绘制思维导图,甚至可以和流图等其他形式结合起来

要点在于线条样式的选取
![在这里插入图片描述](https://img-blog.csdnimg.cn/c5a0aaf3df6e41e19f6a58f1f923f091.png)

- 悬浮+拉取
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/220891580845479c9116f1e857abd2a6.png)
- 或者,先画定几何图形(自定义)再拉出线条连接

#  vscode mindmap

- 如果仅仅绘制思维导图,那么vscode中相关的插件,专门绘制思维导图
- [vscode-mindmap - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=Souche.vscode-mindmap)![在这里插入图片描述](https://img-blog.csdnimg.cn/4d2a5baf886e4d40824fd1e7ff4333ef.png)


#  文字大小

- 可以选中所有要输入文字的元素
- 然后到右侧面板中设置字体大小
- 之后输入文字的时候表现的字号就是一致的了

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/e7b07851625e4f6f8900e1f11d6267ed.png)


- 双击面板添加文字元素,上面的设置依然有效


#  关于line spacing

只有蓝色部分拉出来的线才可以使用line spacing
(包括line end spacing /line start spacing)

![在这里插入图片描述](https://img-blog.csdnimg.cn/ae1e6fdce84248a69b12ab71a4f20bd2.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)
同时,还需要在拉到终点处是让另一个形状呈现出蓝色(而不是其他颜色的时候,这是释放鼠标,就能够看到效果(使得该线和终点图形保持固定的距离,即使拖动目标图形也是这样)

![在这里插入图片描述](https://img-blog.csdnimg.cn/fd74b20f0a604e0caeb34de55de39f25.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_16,color_FFFFFF,t_70,g_se,x_16)
不生效的实例:(绿色)
![在这里插入图片描述](https://img-blog.csdnimg.cn/ac0be72f22d647ddaf9c5012cccdbb1d.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_11,color_FFFFFF,t_70,g_se,x_16)
同时,两个图形之间只有一条可以使用line spacing(绘制多条的话将会:要么重合,要么line spacing 不生效)
![在这里插入图片描述](https://img-blog.csdnimg.cn/303e9be77bf448c58de0920858e1151e.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_8,color_FFFFFF,t_70,g_se,x_16)

###  批量修改样式

![在这里插入图片描述](https://img-blog.csdnimg.cn/caca4bc0ecbd4832a955c01e8e0f3e66.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)

- 批量选中元素
  - 可以鼠标对角线划出矩形框选
  - 也可以ctrl+a全选
  - `ctrl+shift+v`应用样式

- 某些线条无法由于接入到集合元素的槽点而无法完整应用样式(譬如line end)边距,您可以手动调整这些端点(边距生效要点如上个section所述)  



