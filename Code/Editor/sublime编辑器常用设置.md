[toc]



## abstract

- sublime的常用设置

## refs

- [Documentation (sublimetext.com)](https://www.sublimetext.com/docs/index.html)
- [Font Settings (sublimetext.com)](https://www.sublimetext.com/docs/font.html)
- [Color Schemes (sublimetext.com)](https://www.sublimetext.com/docs/color_schemes.html)



## command palette

ctrl+shift+p

## 自动换行设置

输入wrap
enter键,即可在换行与否切换模式
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/bd80d0afeb6f4a218a58fa23795d87d4.png)

##  设置默认:
进入settings
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/c808e1fe0e73a3d5c862109192c27e78.png)

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/386d32fc14b8224e8d7b5c56a491b419.png)
保存修改


##  字体修改@change font to display in editor

- `"font_face": "<name of your font>"`
- 不是所有的字体都可以被成功应用，比如"hack nerd font"就无法成功应用（sublime4)
  - ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/fad4dc71c3ba7b8f9e7ddfee73b27900.png)

- 修改后保存,立刻生效(测试于sublime 4)

## 主题颜色

- `UI:set color scheme`是设置颜色主题的
- `UI:select Theme`是布局方面的(内置可选的有:自适应和默认)
- 使用`ctrl+shift+p`输入关键词快速设置

## 配置不可用问题

- | ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/41d125e75bc4e11f2f74f41913120ff6.png) | ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/791e319bc0223f1bf59beab7c32b736d.png) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  |                                                              |                                                              |      |



- sublime text/package/目录下混入了不不合法的文件(夹)

###  solution:

- 关闭sublime 
- 尝试将可能引起问题的目录移除