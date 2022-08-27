@[toc]
## 欲求NFA等价的DFA N,需要求出对应的DFA M的五元组
###  两种运算
- $\varepsilon-closure运算$和$move$运算
![在这里插入图片描述](https://img-blog.csdnimg.cn/20607fa245114c23969e53c234163ac7.png)

>  我们把下文用到的符号捋一下:

* $K,K_0,K_t$分别作为NFA的有穷状态集合和初始状态以及终止状态
* $S,S_0,S_t$分别作为DFA的有穷状态集合和初始状态以及终止状态

- 主要部分是求解M的状态集S(其又有DFA N的状态机K的一些子集组成)
  - 问题有转成求解K的子集
  - 我们使用$S_i$数组表示待求状态集S中的元素(状态元素)
  - DFA的状态是NFA的状态集的子集

![1647779369354.png](https://img-blog.csdnimg.cn/img_convert/76fafdc8dc3915a48bfdd80b6560eec7.png)

* 注意到,这里说$S_i$是有序的,S是一个集合其内部元素是无序的(书写的时候不体现顺序).
  * 转换函数D(S,a)=R(此处a代表输入字符集合$\sum$中的任意元素);
    * S,R是状态集合(NFA的状态子集);S,R作为DFA的状态

![1647779382247.png](https://img-blog.csdnimg.cn/img_convert/c01164f052566386747fd3abfaed65e8.png)![1647781161832.png](https://img-blog.csdnimg.cn/img_convert/b212382b9afab01d9588dd712cb2fae1.png)



本图中,N的有限状态集包括了0,1,..10;

且,其实状态$K_0$是状态0

子集族C要表达的意思和S相近,C可能强调顺序

### 算法3.7中的内层循环(for)是对输入符号集合(字母表)做遍历

- 算法伪代码中的U就是下面所说的子集$T_i$
- 结合本例题,这个被遍历的输入集合是$\sum=\{\varepsilon,a,b\}$
- 内部的两个抽象运算也比较简单
  - $\varepsilon-closure(StateSet)$
    - 运行一次$\varepsilon-closure()$运算,可以得到一个子集族中的元素$T_i$
    - 准确的说,是下一个子集$T_j$的候选集合是经过$\varepsilon-closure$和move的嵌套(复合)运算得到的,当这个候选集合是想对于集合族是全新的集合时,它就成为了$T_j$
    - 经过一次for循环的遍历,可能产生超过一个的新增子集加入到子集组$C$
    - 同一个for循环还没走完之前,使用的都是同一个$T_i$(它就是while循环开头所作的被新标记的子集T)来计算新的候选子集
  - move(StateSet,a)
  - 都是找出某一出边(弧)的过程前者是找$\varepsilon$(可以连续多次的);后者是找输入符号a(不可连续)
  - 手工计算的时候,可以使用树形分叉记法(习惯看表格的话叶可以将状态转移图转化成状态转移表,然后再画树性分支,注意$\varepsilon-closure$运算包含起点本身)

### 例子

> 可以围绕这FA的各个状态节点,将出边标出

![1647784295115.png](https://img-blog.csdnimg.cn/img_convert/0a2155f691d4b0d6279307720067df4a.png)

![1647779276846.png](https://img-blog.csdnimg.cn/img_convert/864d28b4cf6431eab6ed291597be299c.png)![1647779292959.png](https://img-blog.csdnimg.cn/img_convert/954deec3fbdd25553abc2d7b7e13fe0c.png)

* 我们将$T_1到T_4$集合分别视为一个个整体作为互不相同的状态(DFA)的状态;并可以进一步简写为1,2,3,4

![1647785043474.png](https://img-blog.csdnimg.cn/img_convert/6ac14340f71c339c532bcd7a9611654e.png)

* 该定义还是基于NFA
* 转换函数$D(S,a)=R$(此处a代表输入字符集合$\sum$中的任意元素);

---

* 最终,确定下来的转换函数D可以有前面计算并确定DFA状态集S(各个子集$Ti$)时得出的结论分别收集记录下来;便可方便的得到DFA的 `状态转移图`

![1647779305981.png](https://img-blog.csdnimg.cn/img_convert/20cc112a53450654db51de46c37ac7f5.png)