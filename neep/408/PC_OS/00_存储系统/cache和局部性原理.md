[toc]

## 高速缓冲存储器cache

- cache也是存储器中的一种

### 程序访问的局部性原理

- 时间局部性
  - 最近的未来要用到的**信息**,很可能是正在使用的信息
  - 因为程序中存在循环(重复执行相同一批的指令(取指操作))
- 空间局部性
  - 最近的未来要用到的**信息**,很可能与现在正在使用的信息在存储空间上是邻近的
  - 因为指令通常是顺序存放,顺序执行的
  - 数据一般也是以向量/数组等形式簇聚地存储在一起的
- 高速缓冲技术就是利用局部性原理,把程序正在使用的部分数据存放在一个高速的(容量较小的)Cache中
  - 使cpu的访存操作大多在针对cache进行,从而提高了程序的执行速度

#### 程序访问数据的局部性好坏判断

- 如果某个程序(片段)对数据的**访问顺序**和数据的**存放顺序**一致,那么认为程序**空间局部性好**
  - 比如二维数组
    - 按行访问,空间局部性好
    - 按列访问,空间局部性不好
- 如果数据只被访问了一次(或者重复次数少),那么其**时间局部性**被认为是不好
  - 如果数据被重复访问,那么比较符合时间局部性
  - 因为最近访问过的数据已经存在于cache上,对这些数据的访问是快速的

#### 程序指令的局部性判断

- 比如for循环访问二维数组
  - for循环体被**重复执行**一批相同的指令,因此**时间局部性好**
  - 循环体内的**指令被连续存放**,和执行顺序一致,**空间局部性好**

### 局部性原理&算法时间复杂度

- 以遍历二维数组求和所有元素的算法为例
  - 一种方法是按行遍历相加
  - 另一种是按列遍历相加
  - 它们在复杂度上都是$O(n^2)$(渐进性能)
  - 但是由于计算机的结构特点,按行遍历的方式速度更快

## cache的工作原理

- 设主存由$2^n$个可编址的**字**组成
  - 每字具有唯一的n位地址

### cache和内存

- 为了便于cache和主存交换信息,,cache和主存被划分为大小相等的**块**
- **cache块**(<u>缓存块</u>)也称为**cache行**
  - 每块由**若干个字**或字节(Byte)组成,每个块内包含的存储字数相同
  - 块的长度称为**块长**(cache行长)
  - cache中仅保存最活跃的若干块(主存的)副本
  - cache按照某种策略,预测cpu在未来一段时间内预访问的数据,将其(从主存)载入到cache

#### 地址划分

- 通过分块操作:主存和cache的地址被分为两部分:
- 主存:
  - 高m位表示主存的**块地址**
    - $M=2^m$表示主存块数
  - 低b位表示**块内地址**
- cache:
  - 高c位表示缓存块的块号
    - $C=2^c$表示缓存块数
  - 低b位同样表示块内地址
- 块的大小(内存块和缓存块大小都是$B=2^b$个**字**(存储字))

### cache工作过程/命中

- 当CPU发出读请求时，
  - 若访存地址在Cache 中命中，就将此地址转换成Cache地址，直接对Cache进行读操作，与主存无关;
  - 若Cache不命中，则仍需访问主存，并<u>把此**字所在的块**一次性地从主存调入Cache</u>。
    - 若此时Cache已满，则需根据某种**替换算法**，用这个块替换Cache中原来的某块信息。
    - 整个过程全部由硬件实现。
    - CPU 与 Cache之间的数据交换**以字为单位**，
    - Cache与**主存**之间的数据交换则以Cache**块**为单位。
  - 注意:某些计算机中也采用**同时访问Cache和主存的方式**，
    - 若Cache命中，则<u>主存访问终止</u>;
    - 否则(cache未命中),则<u>访问主存并替换Cache</u>.
  - 当CPU发出写请求时，若Cache命中，有可能会遇到<u>Cache 与主存</u>中的**内容不一致的问题**。
    - 例如，由于CPU 写Cache，把 Cache某单元中的内容从X修改成了X'，
      - 而主存对应单元中的内容仍然是X，没有改变。
      - 所以若Cache命中，需要**按照一定的写策略处理**，常见的处理方法有**全写法和回写法**

### 命中率

- cpu欲访问的信息在cache中的比率称为cache的命令率

- 一个程序执行期间,cache的总命中次数为$N_c$

- 访问主存的总次数为$N_m$,则命中率H为

- $$
  H=\frac{N_c}{N_c+N_m}
  \\其中N=N_c+N_m为访存总次数
  $$

  

- 为了提高访问效率,命中率H越高(越接近1)越好

- 设

  - $t_c$为命中时的cache访问时间
  - $t_m$为未命中cache时访问内存的时间
  - $1-H$表示未命中率

- cache-主存系统的平均访问时间:

  - 设cpu采用同时访问cache和主存的策略

  - $$
    T_a=Ht_c+(1-H)t_m
    $$

    - 根据全概率公式可以直接得出该公式

### cache容量和命中率的关系

- 一般而言,cache容量越大,cpu命中cache的概率越大
- 但是当cache增大到一定程度后,命中率不再提高

### cache块长和命中率的关系

- 这一对关系比较复杂
- 块长的最优值是难以确定的
- 起初会由于块长的增加(由较小到大)提升命中率
  - 因为,局部性原理的作用:
    - 已被访问的字的附近字,近期可能也别访问
    - 快长增大,有望将更多有用的字存入cache,提高命中率
    - 🎈(如果存入的cache是不常用的字,那么反而会降低应有的命中率)
- 当cache块增加到一定程度,命中率会下降
  - 因为,装入缓存的有用数据字的在每个块的占比p会由于过长的块长导致下降
  - 使得有限的cache空间被不常用的字(内容)占据了较多空间,而常用的字占比下降,降低命中率
    - 由于块长的增长,缓存块数目下降,新装入的块会覆盖旧有的块
    - 可能造成刚刚被装入cache的块很快就被覆盖,使得一些常用的字被覆盖,而新装入的数据可能只是用上一次
      - 因为,虽则块长的增大,距离被访问的字T的较远的其他字D也被调入cache,然而这些较远的字近期被访问的概率没有那么高
    - 也就是说,每次变动的内容太多,容易使得真正常用的数据被不必要地替换出去
      - 如果采用不太大的块长,在发生替换时就没那么容易发生这种不希望发生的替换

### cache结构

#### cache存储体

- 大多采用**多体结构**

#### 地址映射变换机构

- 将cpu送来的**主存地址**转换为**cache地址**
- 主要是完成主存的块号(高位地址)与cache快号间的转换
- **地址变换**与主存地址采用的变换映射函数有关

#### 替换机构

- 当cache内容已满,无法接受新的来自主存的块时,有cache替换机构按照一定的替换算法来确定从cache内移出哪个块**返回主存**,而把来自主存的新块调入cache
- 用户编程的地址是主存地址
- cache块调换是透明的



### 例



- 假设访问主存的速度v

  - 时间为$t_m=\frac{1}{v}$

- 访问cache的速度为5v

  - 时间为$t_c=\frac{1}{5}t_m(=\frac{1}{5v})$
    - 整式化:$t_m=5t_c$

- cache命中率为H=95%

  - 1-H=5%

- 采用cache后性能提升为几倍$\eta=\frac{t_m}{t_a};t_a是引入cache后的访存时间(平均)$?

  - 倍数为$k=\eta-1$

  - 设cpu采用同时访问cache和主存的策略

  - $$
    T_a=0.95t_c+0.05t_m=0.95t_c+0.05(5t_c)=1.2t_c
    $$

  - $$
    \eta=\frac{5t_c}{1.2t_c}=4.17\cdots
    $$

  - $k=\eta-1=3.17$

## cache的主要问题

### 数据查找

- 讨论如何判断数据是否在cache中

### 地址映射

- 主存块如何放入cache中
- 如何将主存地址转换为cache地址



### 替换策略

- cache满后,如何对cache块进行替换/淘汰

### 写入策略

- 保证主存块和cache块的**数据一致性**