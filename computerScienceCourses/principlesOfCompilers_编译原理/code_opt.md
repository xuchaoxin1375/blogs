### 代码优化

#### 基本块

![image-20220616124008156](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616124008156.png)

- 基本块中的代码,要吗全部执行,要么全部不执行,他们是作为一个整体 	

![image-20220616122325604](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616122325604.png)

#### 首指令

- 从一条首指令到下一条首指令前的那部分就是一个基本块的划分



- 转移指令的**目标指令**是一个首指令

- 转移指令**之后(的紧跟)的**指令是一个首指令

- > 至于有条件跳转合无条件跳转仅仅在将基本块连接为流图的时候才有一定的区别(后继块的区别)

- 这意味着,一个跳转指令会产生两条首指令!

- 但是,跳转指令本身却往往不是首指令(它也能了,除非满足上述条件)

![image-20220616130416405](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616130416405.png)



#### 划分本块

![image-20220616130653944](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616130653944.png)

![image-20220616122304398](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616122304398.png)



### 从基本块到流图的绘制

![image-20220616123134539](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616123134539.png)

- 主要目标是分析所有块的后继块
  - 一个块的后继块可以通过日下方式确定
    - 指令序列上,块位置上相邻的物理相邻
    - 通过跳转来实现逻辑上的相邻
- 进一步,关键是检测块的末尾语句
  - 非跳转语句最简单,直接连接两个相邻快
  - 跳转语句分为:
    - 有条件跳转(if...):任然允许连接两个相邻块
      - 同时,还要注意该跳转语句可以跳转到的目标语句位置(目标语句所在块)也可以作为当前块的后继块作连边
    - 对于无条件跳转,只允许跳转的目标语句所在块作为该块的后继

![image-20220616123148261](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616123148261.png)