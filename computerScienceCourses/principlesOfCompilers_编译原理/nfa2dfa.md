[toc]

#  NFA等价的DFA子集法求解

##  NFA

一个不确定的有穷自动机  M  是一个五元组:

$M=(K, \Sigma, f, S, Z)$

其中:

(1)  $K$  是一个有穷集, 它的每个元素称为一个状态。
(2)  $\Sigma$  是一个有穷字母表, 它的每个元素称为一个输人符号。


(3)  $f$  是一个从 $K \times \Sigma^{*}$到  $K$  的全体子集的映像, 即  $K \times \Sigma^{*} \rightarrow 2^{K}$ , 其中  $2^{K}$  表示  $K$  的 幂集。


(4)  $S \subseteq K$ , 是一个非空初态集。
(5)  $Z \subseteq K$ , 是一个终态集。
> 一个含有m个状态和n 个输人符号的NFA可表示成一张状态转换图,
> 这张图含有m个状态结点,每个结点可射出若干条箭弧与别的结点相连接,
> 每条弧用$\sum^*$中的一个串作标记,整个图至少含有一个初态结点以及若干个终态结点。
> ##  DFA(NFA的特例)
$$
(1)  K  是一个有穷集, 它的每个元素称为一个状态。\\
(2)  \Sigma  是一个有穷字母表,它的每个元素称为一个输人符号, 所以也称  \Sigma  为输人符 号表。\\
(3)  f  是转换函数, 是  K \times \Sigma \rightarrow K  上的映像。\\例如,  f\left(k_{i}, a\right)=k_{j}\left(k_{i} \in K, k_{j} \in K\right) , \\
就意味 着, 当前状态为  k_{i}  、输人字符为  a  时, 将转换到下一状态  k_{1} , 把  k_{j}  称作  k_{i}  的一个后继状态。\\
(4)  S \in K , 是唯一的一个初态。\\
(5)  Z \subseteq K , 是一个终态集, 终态也称可接受状态或结束状态。\\
$$
##  正则表达式构造NFA
### 基础对应关系

#### ε对应的NFA

![image-20220611201942570](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611201942570.png)





#### 字母表Σ中符号a对应的NFA

![image-20220611202010352](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611202010352.png)

#### 连接&或&幂运算对应的NFA

![在这里插入图片描述](https://img-blog.csdnimg.cn/444a8201d0794f46ab855cae6d38e13a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_15,color_FFFFFF,t_70,g_se,x_16)![image-20220611202333787](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611202333787.png)

- 对于一个长的正则表达式,先进行分解
  - 从串联的角度进行分解,上述正则表达式可以分解为4个部分
  - 其中第一个部分可以继续分解
  - 最后,将或运算分解


## 求解五元组 
欲求**NFA** N等价的**DFA** M,需要求出对应的**DFA** M的五元组
###  两种运算
> $\varepsilon-closure运算$和$move$运算
>
> 

![在这里插入图片描述](https://img-blog.csdnimg.cn/20607fa245114c23969e53c234163ac7.png)

- (1）**状态集合Ⅰ**的***$\varepsilon-闭包$***,表示为$\varepsilon-closure(I)$

  - 该闭包定义为一个状态集,是**状态集Ⅰ**中的**任何状态S**经任意条$\varepsilon$弧而能到达的状态的集合。
  - 如输入符号是空串,则自动机仍停留在原来的状态上,显然,**状态集合Ⅰ**的**任何状态S**都属于**$\varepsilon-closure(I)$**。

- (2）**状态集合Ⅰ**的**α弧转换**,表示为$move(I,a)$,

  - 定义为状态集合J,其中J是所有那些可从Ⅰ中的某一状态经过一条α弧而到达的状态的全体。

- 

  

>  我们把下文用到的符号捋一下:

* $K,K_0,K_t$分别作为NFA的有穷状态集合和初始状态以及终止状态
* $S,S_0,S_t$分别作为DFA的有穷状态集合和初始状态以及终止状态

- 主要部分是求解M的状态集S(其又由NFA N的状态机K的一些子集组成)
  - 问题有转成求解K的子集
  - 我们使用$S_i$数组表示待求状态集S中的元素(状态元素)
  - DFA的状态是NFA的状态集的子集

### 算法伪代码

![1647779369354.png](https://img-blog.csdnimg.cn/img_convert/76fafdc8dc3915a48bfdd80b6560eec7.png)

* 注意到,这里说$S_i$是有序的,S是一个集合其内部元素是无序的(书写的时候不体现顺序).
  * 转换函数D(S,a)=R(此处a代表输入字符集合$\sum$中的任意元素);
    * S,R是状态集合(NFA的状态子集);S,R作为DFA的状态

![1647779382247.png](https://img-blog.csdnimg.cn/img_convert/c01164f052566386747fd3abfaed65e8.png)![1647781161832.png](https://img-blog.csdnimg.cn/img_convert/b212382b9afab01d9588dd712cb2fae1.png)



本图中,不确定有穷状态机N的有限状态集K包括了0,1,..10 这11种状态.;

且,状态$K_0$是状态0

子集族C要表达的意思和S相近,C可能强调顺序

### 回顾求解子集算法

![在这里插入图片描述](https://img-blog.csdnimg.cn/67dce31ec52b4fd59a2886000a85961a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_15,color_FFFFFF,t_70,g_se,x_16)

算法为二重循环
- 内层循环for比较确定
- 外层循环while的终止依赖于内循环for的计算结果
> 中的内层循环(for)是对输入符号集合(字母表)做遍历

- 算法伪代码中的U就是下面所说的子集$T_i$
- 结合本例题,这个被遍历的输入集合是$\sum=\{\varepsilon,a,b\}$
- 内部的两个抽象运算也比较简单
  - $\varepsilon-closure(StateSet)$
    - 运行一次$\varepsilon-closure()$运算,可以得到一个子集族中的元素$T_i$
    - 准确的说,是下一个子集$T_j$的候选集合是经过$\varepsilon-closure$和move的嵌套(复合)运算得到的,当这个候选集合是想对于集合族是全新的集合时,它就成为了$T_j$
    - 经过一次for循环的遍历,可能产生超过一个的新增子集加入到子集族$C$
    - 同一个for循环还没走完之前,使用的都是同一个$T_i$(它就是while循环开头所作的被新标记的子集T)来计算新的候选子集
  - $move(StateSet,a)$
  - 都是找出某一出边(弧)的过程前者是找$\varepsilon$(可以连续多次的);后者是找输入符号a(不可连续)
  - 手工计算的时候,可以使用树形分叉记法(习惯看表格的话叶可以将状态转移图转化成状态转移表,然后再画树状分支,注意$\varepsilon-closure$运算包含起点本身)

## 视频讲解

- 国防科技大学:编译原理Mooc系列
  - Bilibili查看(相关章节)

## DFA和NFA的等价性

- 对任何**非确定的有穷自动机N** ，存在定义同一语言的**确定的有穷自动机D**
- 对任何**确定的有穷自动机D** ，存在定义同一语言的**非确定的有穷自动机N**

### NFA&DFA&FA&正则

- ```mermaid
  flowchart 
      regex_gammar(正则文法)<==>regexp(正则表达式)<==>FA(自动机FA)<==>regex_gammar
      %%regexp_grammar<-->reg(正则表达式)<-->FA(自动机FA)
  
  ```

- NFA比DFA更加直观(对于人类而言)

- 另一方面,DFA在计算机实现上比NFA更容易



### 带有ε边的NFA

带不带空边(ε边)的NFA间具有等价性

![image-20220611195257380](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611195257380.png)

- 注意,后面的状态对于前面的状态具有累计效果
- 以及,各个状态是否为终态

### 根据RE(正则表达式)构造NFA

#### ε对应的NFA

![image-20220611201942570](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611201942570.png)





#### 字母表Σ中符号a对应的NFA

![image-20220611202010352](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611202010352.png)

![image-20220611202053565](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611202053565.png)

- 输入串联
- 输入并联
- 方幂:输入循环

#### 案例:



![image-20220611202333787](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611202333787.png)

- 对于一个长的正则表达式,先进行分解
  - 从串联的角度进行分解,上述正则表达式可以分解为4个部分
  - 其中第一个部分可以继续分解
  - 最后,将或运算分解

## NFA转换为DFA

### NFA与DFA的对比

![image-20220615130702081](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220615130702081.png)





### DFA与NFA的等价性

![image-20220615131219189](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220615131219189.png)

![image-20220615135205393](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220615135205393.png)

- 获得状态集之间的转换关系

  - ε-closure(I)运算

    - 我们可以用集合I来描述ε运算的结果

  - move运算(和字母表(输入字符)有关)

    - 我们可以用集合J来描述(接收)move运算的计算结果
      - $J_a,J_b$
    - 千万记住,move(I,a)运算的结果$J_a$只是一个中间结果,想要得到转换表中的$I_a$,还必须要再次执行ε运算
    - 对于其他字母表中的字母(例如b,c,d,...),也是类似的流程

  - ```mermaid
    flowchart LR
        I_nfa["S(NFA的初始状态)"]--"ε-closure(S)"-->I_initial("I (状态集合的初始状态)")
        I--"move(I,a)"-->Ja--"ε-closure(Ja)"-->Ia
        I--"move(I,b)"-->Jb--"ε-closure(Jb)"-->Ib
    ```

  - 字母状态转换表中的Ia,Ib,Ic,...取决于文法的字母表总符号的个数

- > 一个容易出错/疏漏的地方在于,被执行ε运算的状态(集)本身也要加入到ε计算的结果集合中,
  >
  > 或者说,本身集合中的元素至少要加入到ε-closure的结果集合中)(因为,我们允许经过的ε的弧数为0)

#### 状态转换表

![image-20220615135546592](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220615135546592.png)

### 转换表实例1

![image-20220615141617066](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220615141617066.png)

![image-20220615141835337](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220615141835337.png)

![image-20220615142150175](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220615142150175.png)

> DFA是NFA的特例

### 例子 2 

#### 没有ε边的NFA2DFA

- (从NFA初步转换后的)**DFA**的每个状态都是一个由NFA中的状态构成的集合,即**NFA**状态集合的一个子集

- <img src="https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611203236335.png" alt="image-20220611203236335" style="zoom:80%;" />

- 对于没有ε边的状态转换表,比较简单

  - 这种情况下,只需要执行move运算,而不需要考虑ε-closure运算.

    

- <img src="https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611203213594.png" alt="image-20220611203213594" style="zoom: 80%;" />

- 当然,新的状态集合来自于状态转换表中的非空状态集,可以单独将他们整理出来,得到以下的DFA状态转换图

  

- ![image-20220611203203763](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611203203763.png)



#### 从带有ε-边的NFA到DFA的转换

![image-20220611214140977](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611214140977.png)

- 这种带有ε边的情况下,就需要先算完move运算(作为中间结果J),然后计算J的ε-closure闭包

- > - 上面例题配置的状态转换表格形式比较简约,状态列依然采用NFA中的状态,
  > - 但是在根据该表格绘制DFA的时候,确定DFA的状态的时候,需要考察表格内的非空集合
  > - 并且,由于该形式的转换表不是太彻底(和例题1中的状态转换表的直观度要差一些),因此需要再稍微计算一下
  >   - 例题1中的转换表比较直观,但是要得到该层次的转换表,需要做的过程计算相应的要多上一些
  >   - 具体可以参看`哈工大(编译原理)`相关章节

- 需要注意的是,终止状态的判断,转换为DFA的每次新产生的一个状态都需要判断该状态(集合)中是否含有NFA的终止态(之一)

  

### 例子3: 识别无符号数的DFA

![image-20220611220701146](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611220701146.png)

![image-20220611220651935](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220611220651935.png)

- 注意到,转换为DFA后,各个状态中,包含原来NFA的终止态的新状态(集合),将要作为DFA的终止态

- 转换过程中,主要是找到每个**状态集合T**(可以由$\varepsilon-closure$ 计算得到状态集合(该运算的参数也是状态集合,特别的,状态集合可以只包含一个状态,譬如初始推导的时候))**的所有可能输入**(NFA中所指示的那样,但是不包括ε边)

  - 譬如,(1,3,6)构成的状态集(元素个数x=3),的所有可能输入是单独看待NFA中1,3,6状态的所有可能的输入符号的并集(假设有y个互不相同的元素)

- 分析完输入符号集后,将状态集合中的每个状态分别尝试这些可能的输入,在最多的情况下,产生的新状态集可达到x*y个

  - 但是通常不会那么多,因为,状态集中的某些状态是不接受输入符号集中的某些符号
  - 另一方面,还可能发生回环,复用已有的状态

  



- 容易出错的两个方面

  - DFA中的对终止态检测(遗忘该步骤)
  - 对于NFA中的ε边的疏漏

### 例子4

- 构造下列正规式相应的 DFA. 
  - ` 1(0|1)*101 `

![image-20220617112915899](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220617112915899.png)

![image-20220617113112365](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/imagesimage-20220617113112365.png)



### 例子5

> 可以围绕这FA的各个状态节点,将出边标出

![1647784295115.png](https://img-blog.csdnimg.cn/img_convert/0a2155f691d4b0d6279307720067df4a.png)

- $T_i$是通过$\varepsilon-closure$计算得到

![1647779276846.png](https://img-blog.csdnimg.cn/img_convert/864d28b4cf6431eab6ed291597be299c.png)![1647779292959.png](https://img-blog.csdnimg.cn/img_convert/954deec3fbdd25553abc2d7b7e13fe0c.png)
####  回顾转移函数的定义

* 我们将$T_1到T_4$集合分别视为一个个整体作为互不相同的状态(DFA)的状态;并可以进一步简写为1,2,3,4

![1647785043474.png](https://img-blog.csdnimg.cn/img_convert/6ac14340f71c339c532bcd7a9611654e.png)

* 该定义还是基于NFA
* 转换函数$D(S,a)=R$(此处a代表输入字符集合$\sum$中的任意元素);

---

* 最终,确定下来的转换函数D可以有前面计算并确定DFA状态集S(各个子集$Ti$)时得出的结论分别收集记录下来;便可方便的得到DFA的 `状态转移图`
####  收获五元组
![1647779305981.png](https://img-blog.csdnimg.cn/img_convert/20cc112a53450654db51de46c37ac7f5.png)
在计算子集的时候,可以将过程用表格的形式记录,这会方便于整理转换函数的总结
### 更多例子
构造下列正则表达式的DFA
-  $1(0|1)^*101$
- $1(1010^*|1(010)^*1)^*0$
- $a((a|b)^*|ab^*a)^*b$
- $b((ab)^*|bb)^*ab$

####  利用图表整理计算过程

>下方例子中出现的符号说名
- 子集$I$相当于前面说的子集族$C$,收集各不相同的状态集,其数字别名,作为DFA的状态.
- $I_0,I_1$作为算法内部的for循环的遍历结果(候选子集,候选子集也标记上相应的数字标号)
- 从表中可以方便的得到DFA的转换函数
	- 	同一行内的三个数据:例如第3行,可以解读出的转换函数(注意算法中转换函数的定义),
		- 	D(2,0)=2;
		-  D(2,1)=3
		![在这里插入图片描述](https://img-blog.csdnimg.cn/e32f8a049b3c4363b82f2e38464abd4e.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_17,color_FFFFFF,t_70,g_se,x_16)
		![在这里插入图片描述](https://img-blog.csdnimg.cn/eeadb6baece54fd4a59d915caa39ebab.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_17,color_FFFFFF,t_70,g_se,x_16)
>上面$I_1$列的{AF}应该是印刷错误,应该是{A}1

![在这里插入图片描述](https://img-blog.csdnimg.cn/e9a66ba5e5fa484a8a32d5b75d0d1981.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_19,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/b8c19e33538c4e9da2a78b30725bae8f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)