[toc]

#  typora 样式嵌套中的样式化与反操作
##  通用小技巧

##  表格

### 条装相邻格宽度

- 利用空格填充来调整(标题可能无法起作用,尝试选择一个过窄的单元格追加空格)

### 格内换行

- 在表格单元内要换行的化追加html元素`<br/>`
- 快捷键可能是`ctrl+shift+enter`
![在这里插入图片描述](https://img-blog.csdnimg.cn/c4f0be26917d41d1be75d4916aaa47cf.png)

### 快捷键方式
> 通常发生在将一段文本样式化为列表的时候
- `回车`&(某些定制主题可以帮助你分辨一段文本到底有没有换行符
- 比如浅色下划线![在这里插入图片描述](https://img-blog.csdnimg.cn/0237ed818a4547c497a17aea7dca1df8.png)

- `Backspace`&
- `shift+tab`
> 截断和前面部分的关联
> 再选中文本段进行样式化

> 一般将目标内容拉到顶层,就可以正常使用快捷键样式化
> 样式化完毕后,再利用将样式化好的内容剪切粘贴回去原来的位置(最好前面再插入一个换行,防止粘贴失败

> 也可以进入原码模式将片段粘贴再合适的位置
> ###  方案1:(打断上下文独立样式化)
> ![在这里插入图片描述](https://img-blog.csdnimg.cn/62936360de984ced8fbdc7f6b5941807.png)
- 光标上移

![在这里插入图片描述](https://img-blog.csdnimg.cn/e066b09463f2470da9dcca3f3b845c5b.png)


- 回车&backspace(核心步骤)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/d5959250394249da9eb1481e1e01b746.png)
- 效果
![在这里插入图片描述](https://img-blog.csdnimg.cn/33a927cd37424f3997bdf2dde0f5721e.png)
###  方案2(原码编辑)
- 进入原码编辑模式
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/93ae25e6f3324dfca835f73b4b6c21f4.png)
- 删除`-`,在输入空格调整对齐
![在这里插入图片描述](https://img-blog.csdnimg.cn/1906e0217dd84d8dba49ee5631bf17d6.png)

###  有序列表编号问题

![在这里插入图片描述](https://img-blog.csdnimg.cn/fc7ae878400a4eeba59ddef5bc730776.png)
- 将需要排序的列表剪切掉
- 将剪切版的内容粘贴到文章末尾(或者中间开辟出一段足够大的空白区域,不和上下文邻接)
- 选中需要重排序的内容,按下`shift+tab`;
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/68af342b96b34d93b6c1fa731227b750.png)
- 按下`ctrl+shift+[`(或者右键排序)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/4c0a7c6d8d5c4446b38c3565e36c007d.png)
- 进行微调:上图`5.`编号是不恰当的,为了去除掉`5.`,可以鼠标选中`5.`所在的行,按下`shift+tab`,然后再按下`tab`,得到:
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/ea2612670cbb4b68a3bf7e41a7a1deff.png)



###  列表项缩进(无序列表)🎈

![在这里插入图片描述](https://img-blog.csdnimg.cn/f42f62f2d9ce4e5ab72d60a3cc5c7c33.png)
- 将光标点击在列表黑点的前面,如图所示:
![在这里插入图片描述](https://img-blog.csdnimg.cn/7a824e8e7d614a1baa64ab5d1bc043c9.png)
- 按下tab键,即可将代码快缩进
![在这里插入图片描述](https://img-blog.csdnimg.cn/b7b0387157b244e0b179236cdf0ad622.png)
- 列表项前提(升级缩进)则是通过shfit+tab进行
####  错误做法:
- 列表和附近相邻的列表项的缩进级别为0或者1,如果达到2,是没有办法正常操作的!
- 至少typora中不允许用户通过快捷键这操作,否则导致意想不到的结果
![在这里插入图片描述](https://img-blog.csdnimg.cn/57564118c55d413aa0ac0891b0ee290e.png)
####  数学公式块出入到列表中
- 比较推荐的方式是,点击需要被缩进的块,然后`Ctrl+A`全选tex原码内容
	- 删除掉该块
	- 创建新的项,执行需要的缩进
	- 重新创建公式块,粘贴复制出来的代码
- 如果需要调整的块比较多,还是进入原码模式进行调整
####  表格位于列表中时的缩进
![在这里插入图片描述](https://img-blog.csdnimg.cn/cbe9df5f31444818bcecd8df5e41b0ef.png)
##### 进入源码编辑
![在这里插入图片描述](https://img-blog.csdnimg.cn/6a49a9f9f4c54974a2fa6e049bee15d3.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/8fe6cb6dc6b24f8f9c88adc258551c7a.png)
#####  构造插入法
![在这里插入图片描述](https://img-blog.csdnimg.cn/c367b03e2aa64e518a084951c1fe537f.png)
 向表格前面2行(可以是空白)的列表项
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/376798287ef643348ac3cdbcaf256bcf.png)
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/fbf128b632904934ac8142262edb4c0c.png)

 然后鼠标选中表格的所有行以及填充的上一行(test)
 按下tab,将test行和表格一同向后缩进一个,然后删除掉多余的test行即可
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/d5151673e3454adba1392edd32ab0413.png)

###  打散代码块(正文<=>代码)
- 使用快捷键`ctrl+shift+k`
###  配置插入下一个段落
> 这很有用,特别是需要`从代码块跳出来`的时候!

![在这里插入图片描述](https://img-blog.csdnimg.cn/a3f43e8acabe488981384bd520f00f0a.png)