[toc]

## 重复导包问题

- 假设您由许多零零散散的demo,其中,部分或者全部demo需要用的库导库语句是缺失的
  - 一个典型的例子是`pyside6`开发官方教程,[Your First QtWidgets Application - Qt for Python](https://doc.qt.io/qtforpython/tutorials/basictutorial/widgets.html)
  - 比如打算将前面个章节都放到同一个jupyter notebook后,通常第一个demo的包如果由导入缺失的问题时,可以用`alt+enter`尝试导入
  - 在粘贴第二个demo的时候,由于某些包已经在第一个demo中导完了,那么这里就不会提示你再导一遍
  - 这种情况下,如果假设您重启了jupyter notebook 服务,直接运行第二个demo就可能报错
  - 因为有些导包语句再第一个demo中,直接运行第二个demo将导致库的缺失
    - 这种情况下,IDEA@pycharm的导包工具不会提示你,因为它的检擦范围是整个notebook

- 鉴于上述原因,通常不建议将多个demo放到同一个notebook中
- 或者,将所有导包语句放置到notebook的第一个(或者其他容易找到的)cell中,并且每次重启(打开)notebook都坚持运行一次导包单元(cell)
  - 结合markdown的标题,这样大纲就可以直接跳转到导包语句的cell附近

### 选择导包语句的位置

- 假设您的第一个cell是专门存放导包语句,那么导包的时候可以选择的
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/88a60b211ad94858914aefea252fd8ee.png)
- 如果选择插入到`current cell`,那么导包语句将插入到当前cell
- 如果选择`import this name`,那么会集中地插入到某个cell中(例如都插入到第一个cell)

### 清除无用(多余)的导包语句(import optimize)

- 导包语句中如果有灰色的部分,那么可以尝试`alt+enter`进行导包优化,可以自动移除无用的包

  





