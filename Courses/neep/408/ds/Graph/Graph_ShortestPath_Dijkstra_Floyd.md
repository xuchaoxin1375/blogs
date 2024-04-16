@[toc]

# 最短路径问题/dijkstra 和floyd算法的比较/最短路径最优子结构相关原理

# 最短路径相关的概念和基本原理



- 最优子结构是可以使用动态规划 和贪心算法的一个重要指标。
- 我们将在Dijkstra 算法就是一 个**贪心算法**,而 Floyd-Warshall 算法则是一个**动态规划算法**
- 贪心算法一般个动态规划更加高效,但是使用贪心算法的条件也更苛刻

### dijkstra算法和floyd算法比较

- 两者都有<u>迭代最短路径估计长度值的行为</u>

  - 都包含计算最小值的操作,来决定是否迭代distance数组(dijkstra)或者$A^{(k)}$矩阵(floyd)中的元素值

- floyd算法

  - 可以允许图中出现负权边

  - 通过**矩阵间递推关系**迭代矩阵序列

  - 利用低阶矩阵计算导出高阶矩阵,($从A^{(-1)}\to A^{(n-1)}$

    - $$
      A^{(-1)}[i][j]=archs[i][j]
      \\A^{(k)}[i][j]=Min(A^{k-1}[i][j],A^{k-1}[i][k]+A^{k-1}[k][j])
      ;k=0,1,\cdots,n-1
      \\min函数来判断,是直接继承A^{k-1}[i][j]
      \\还是修改为A^{k-1}[i][k]+A^{k-1}[k][j]
      $$

    - 递推公式表明,$在A^{k}[i][j]]中的各元素,在A^{k-1}[i][j]中尝试松弛<i,j>,是通过引入中间点k来实现的$

    - 借助这个公式,可以方便的写出floyd的核心代码

  - floyd算法可以求解图G中任意一对顶点间的最短路径,复杂度达到 $O(|V|^3)$

  - 而都每个顶点使用dijkstra,也可以得到任意一对顶点间的最短路径(此时复杂度达到了$O(|V|^3)$)

    - 不过dijkstra还是更加灵活一点,但却要求非负权图



### 带权路径长度(WPL)

- WPL=weightPathLength
  - 可以记两点间的**带权路径距离为WPL(u,v)**;u,v是图G中的两点.
    - 有时候也记<u>WPL(u,v)</u>为`w(u,v)`
  - 此`长度`非<u>边数</u>
  - 由于权的存在,我们不在单单用一条路径经过的边数来衡量顶点的`长度`
    - 由于路径往往可能有多条,所以将WPL(u,v)理解为路径集合
  - 在实际情况中,带权的路径会更加场景,比如模拟运输路线的代价

- 对于带权图,把从顶点$v_i到图的另一个顶点v_j的一条路径p_k的所经过的边上的权值之和定义为该路径(p_k)的\underline{带权路径长度}$

#### 最短路径定义( shortest path)$\bigstar$

- 我们把两点u,v的带权路径长度WPL(u,v)中的最小者称为最短路径,记为SWPL(u,v)或者$简洁的写作\delta(u,v)$
  - shortest  weight path length


#### 最短路径/(最短带权路径长度)的形式化描述

- A **shortest path** from `u` to `v` is a path of minimum weight from `u` to `v`. 
- The shortest-path weight from u to v is defined as `δ(u, v) = min{w(p) : p is a path from u to v}`.
- Note: `δ(u, v) = ∞` if no path from u to v exists. 

---

### 最短路径之间的最优子结构

- 在理解dijkstra算法前,不妨先了解一下**最短路径的某些性质**,比如**最优子结构**
- 容易知道,在算法结束后,我们应该能够得到**原点A**(起点Source=A)到**任意其他点的最短路径**(以及最短路径距离值)
- (共有|v-1|条到不同终点的最短路径
  - 这些最短路径之间有什么关联?
    - 全局的角度上,最短路径具有最优子结构的特点
      - 例如,不是一般性,从原点A到图G中的某个点(比如E),求解得到的最短路径是A->B->C->E
        - 这个条件下,(我们基于结果来反推,这里的示例路径只是举个例子)
        - 假设出一条最优路径来说明最短路径的一些特点,后面的推理将基于这条路径进行,也以此为前提条件)
        - 那么我们可以知道,A->B->C这一条路径也是图G中的A通往C的最短路径(是A到C的最短路径)(这一点可以利用反证法来证明);
          - 假设A通往C的最短路径不是A->B->C,并假设有比A-B-C更短的路径A-X-C(X也表示一段路径)
          - 那么会导致A-X-C-E是比A-B-C-E更短,从而和条件矛盾(A到E的最短路径明明是A-B-C-E,却冒出个更短的路径)
          - 所以,根据给定条件A-B-C-E是图G中A-E的最短路径,那么中的片段A-B-C一定是A到C的最短路径!
        - 类似的我们还可以得到A到B的最短路径是A->B;
          - B->E的最短路径是B->C->E
    - $对于图G的某条最短路径序列(a_1\to a_n),记为P_{min}=a_1,a_2,\cdots,a_n$
      - $设i\leqslant j,那么P_{min}序列中的a_i\cdots a_j片段也是图G中a_i\to a_j的最短路径$
      - 但是不保证唯一性!

![在这里插入图片描述](https://img-blog.csdnimg.cn/da9a8d37233a4fa788ded7cc3ce448c9.png)





- 在我们的算法实现过程中,将会维护一个关键的distance数组

  - 我们通过反复**扫描&迭代**来尽可能地让distance数组中的各个值变小

  - 在<u>有限次迭代</u>后,起点A到每个顶点的最短路径值就体现在distance数组中

    - 如果仅需要计算最短路径值,那么
    - (迭代中途过程中)该distance数组中的值的含义就是:
      - 从原点A到其他点(记为$V_i$)的当前已知的最短路径
      - 这个最短路径在算法结束之前$A\to V_i$都只是局部的,
        - 而非(或说不能保证为)全局上的最短路径

  - 问题在于,我们迭代的依据是什么,也就是,我们在改动distance数组中的值的理由是有是什么

    - 我们从最简的情况开始分析

    - 假设图G只有一个点A,那么结论显而易见

    - 假设有两个点(A,B),结论也是显而易见,A到B的最短路径就是AB边长

    - 3个点?

      - 

    - ```mermaid
      flowchart LR
      	s--2-->v1--1-->v2
      	s--5-->v2
      ```

      

    - |           | v0=s                       | v1                        | v2                         |
      | --------- | -------------------------- | ------------------------- | -------------------------- |
      | $d^{(0)}$ | 0(done!)($min(d^{(1)})=0$) | $\infin$                  | $\infin$                   |
      | $d^{(1)}$ |                            | 2(done!),$min(d^{(2)})=0$ | 5                          |
      | $d^{(1)}$ |                            |                           | 3(relaex&update,因为2+1<5) |

      



# dijkstra算法

## Dijkstra 算法基本原理(3sp问题的算法)

- `sssp`=3sp=Single-source shortest paths(单元最短路径问题)
  - Problem: From a given source vertex s ∈ V, find 
    the shortest-path weights δ(s, v) for all v ∈ V.
    If all edge weights w(u, v) are nonnegative, all 
    shortest-path weights must exist. 
  - IDEA: Greedy.
    1. Maintain a set `S` of `vertices` whose <u>shortest-path distances</u> from `S` are known.
    2. At each step add to S <u>the vertex v ∈ V – S</u>,whose distance estimate from s is minimal.
    3. Update the distance estimates of vertices adjacent to v.

### 路径符号相关说明

- $u\leadsto v表示中间结点的数量为\geqslant 0(不包括顶点两端)$
- $而使用'\to'来表示前后邻接,u\to v表示u的后继是v$



### 建立辅助对象

#### 最短路径估计数组d

- 如果我们不为顶点建立v.d(最短路径估计值)和前驱值,那么也可以专门建立数组
  - distance[s]数组(最短路径估计数组),大小为n,用来保存源点(起点)A到目标点$v_i$的<u>最短路径估计</u>
  - 简单记为d[]数组

#### 已求解部分点集合S

- 并且建立一个集合S,用它来收纳我们已经求解出最短路径的点集合

  - 为了方面描述,我们把S集合中的顶点标记为S1,S2,...
- 另外,在记W=V-S(表示图中尚未被确定出AX的最短路径的点集(未知空间))

  - $将W中的元素记为w_1,w_2,...w_i$
- 我们基于这S中的这些已知的解去求解未知的A到其他顶点的最短路径

- $设S_{k}是最近一个被求解出来的顶点$
  - 此外,distance数组中有些点是在算法结束前就已经是最小值
    - 尤其是维护已求解点集的集合S中的点;他们在distance中不在迭代
  - 当所有的点被遍历完成,我们就可以认为,distance数组上的各个值就是原点到该值对应的目标终点上的最短路径距离值
  - 清楚认识求解过程中维护的已求解点集S和最短路径distance数组是算法的关键:
  - 算法结束时,S包含所有点(以此逆向利用最优子结构的特点);
  - distance数组中的所有值收敛(减小)到了极限



#### 数组d更新迭代的过程

- 形式化的描述数组d:
  - 第i次遍历更新distance数组中的距离值,那么称该distance数组为i次distance数组(i阶distance数组)
  - 同时,i阶distance数组中的元素表示,路径A..X的边数不超过i时的A到X的最短路径

##### 那么i阶对列中的最小值有什么特别意义吗?(待解决/完善)

- 就是最小值min(Qi)对应的顶点Si将成为下一个进入到已求解顶点集合S中的顶点

- 即,图G中,A到点Si的最短距离就是min(Qi),而不可能更短

- 因为distance数组中的值是单调不增的(随着i的增加,只可能越来越小,不可能变大)

  - 更新distance数组中的值的原则就是,值变小才更新,否则保持原值!
  - 每新确定一个顶点Si,就要对distance数组中还处于未知(W集合)中的每个点进行优化试探(松弛操作)

  

##### 添加第三个点S3(好像没用)

- 记源点S1,

- 那么S2就是使得Awi距离的最小值

  - S1和wi建立边的最小代价就是S1的最短邻接边对应的wi,记为S2

- 现在集合S中有2个元素S1,S2

- 要求S3,路径情况无非两类

  - S1->S2->S3
  - S1->S3

- 3阶distance数组中的最小值到底是有多小?

  - 记weight(a,b)表示a,b两个顶点构成的边的权值

  - 则起点A的邻边权值可以表示为weight(A,wi)

  - $$
    现在讨论A到S3的最短路径
    \\SPL(A,S3)=min(min(weight(A,w_i)),min(weight(A,S_2)+weight(S2,w_i))
    \\等式右边记为RHS
    \\为什么是在全图G上成立
    \\假设存在其他路径使得SPL(A,S3)取得更小的值,
    \\那么这种路径的形式必定是P'=A\to w_i\to \cdots \to S_3,
    \\(否则一定大等于 min(weight(A,w_i))\geqslant RHS)
    \\它的路径长度记为L'=weight(A,w_i)+...+weight(w_j,S3)\geqslant weight(A,w_i)
    \\而上述的RHS的值不超过min(weight(A,w_i)),自然也就不存在L'能够比RHS还要小
    \\
    $$

    

- $$
  \delta(s1,s2)=w(s1,s2)\leqslant\delta(s_1,s_3)\leqslant d[s_3]
  \leqslant 
  \begin{cases}
  w(s_1,s_3)
  \\w(s_1,w_i)
  \end{cases}
  $$

  

#### 顺序上看

- 如果从结果来看,我们给所有的最短路径排个序,dijkstra算法在求解所有最短路径中,会先求短的,再求长的

#### 从结果上看

- 假设原点s到G中的其他顶点的最短路径已经被计算好了,那么这些最短路径形如$s\leadsto v_i$



## Dijkstra算法伪代码

![](https://img-blog.csdnimg.cn/img_convert/bea3a430e7c5a7c0dadb6dadf56b36dc.png)

- d[s]:distance[s]#size=s
- Adj[u]:Adjacent(u)
- w(u,v):weight(u,v)

```c
d[v]>d[u]+w(u,v)顶点u的邻接点v,v的权w(u,v)+d[u]如果小于d[v]
那么更新d[v]为新的更优的值w(u,v)+d[u]//得益于结点u作为中转
```

## 松弛操作 相关信息

- [图论算法的基本概念/松弛操作/最短路径_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/116892086?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"116892086"%2C"source"%3A"xuchaoxin1375"})

- 为了证明所讨论算法的正确性，我们需要使用最短路径和松弛操作的一些性质。

  - ![image-20221002125801880](https://img-blog.csdnimg.cn/img_convert/e512329185a47327178c2a7fc14d55e0.png)

  - 三角不等式性质:

    - $对于任何边(u,v)\in E,我们总有:$
    - $\delta(s,v)\leqslant \delta(s,u)+w(u,v)$
    - $\delta(s,v)\leqslant \delta(s,u)+\delta(u,v)$
    - 因为,如果上述的任意条成立,$就会和\delta(s,v)的定义发生矛盾$
      - 即存在更小的路径比所谓的最短路径更短
      - 因此上述不等式总是成立的

  - 上界性质:

    - $对于任意v\in V,总有v.d\leqslant \delta(s,v)$
    - 即,(最短路径估计值总是比真正的最短路径大或等于
    - $当v.d取值达到\delta(s,v),v.d不在变化$

  - 非路径性质

    - $如果从s到v之间没有可达路径,则v.d=\delta(s,v)=\infin$

    

##  dijekstra算法实例



- Maintain a set `S `of vertices whose shortest-path distances from `s `are known.

### 给定一个图(非负权有向图)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210746212.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

### 初始化



- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210804911.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)



- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210818591.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210829697.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

###  添加结点C

- 我们<u>遍历结点A的出边(调用定义在图上的函数(比如NextNeighbor,扫描到了两条边</u>:距离分别是3,10;
  - (因此,我们维护(更新)distance数组中的对应的B,C上的值(它们从无穷大做出如下变化:B:infinite->10;C:infinite->3);本轮遍历中,没有让D,E上的距离变小,所有distance数组中关于这两点的最短路径没有得到优化(变小)
- 现在,我们将为点集合S选入下一个点,我们要做的就是计算出此时(经过遍历A的出边并迭代后的)distance数组中的最小值,该最小值所关联的点就是这次要纳入点集S的新点
- 接下来,就是重复上述过程:遍历最新加入集合S的结点(譬如这次是C)的出边,即用新结点来优化迭代distance数组中的值,且在每次迭代完就计算出distance数组此时的最小值,将最小值关联的结点纳入集合S
- ...
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210841426.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)



- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210901987.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


### 添加结点E

- 这一轮变化中,D,E记录的值被优化迭代,都从无穷大分别变为了11,5,B则是从10被优化为更短路径值7;
- 由于5<7<11,故,距离值5对应的点E作为本轮新求解的被确定从A出发的最短路径的点,从而被纳入已求解集合`S`
- 其他轮的操作也是类似的流程.

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210908747.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210915287.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

### 添加结点B

- 列当中的数值可以出现重复(表示新求解的可知最短路径结点的引入,从该新结点出发探测对应列的对应点的更短路径没有得到优于之前的结果)
- 现在,B点上记录(经过迭代的目前的最好路径距离)为7,而D点记录的值是11
- 因此将B点纳入集合`S`
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210923903.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210931357.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

### 添加最后一个结点D

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507210938458.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

------




##  dijkstra小结

- Dijkstra算法在运行过程中维持的关键信息是一组结点集合S。
  - 从源结点s到该集合中每个结点之间的最短路径已经被找到。
- 算法重复从结点集W=V-S中<u>选择最短路径估计</u>**最小**的结点
  - 将u加入到集合S
  - 然后对所有**从u发出**的边进行**松弛**

- 我们通过迭代distance数组中个元素的值(都表示距离),**积累起各个S集中新结点的引入时所带来的松弛成果**
  - 在求解下一个结点(并放入到集合S)的之前,distance数组中各值的状态是:
    - (新结点引入S前,且只允许通过途经S中的若干个顶点所能达到(或者说保持)的路径长最小值

- 每当引入一个新结点到S中,我们就利用新结点的出边做松弛操作(试探操作)

  - 这些操作中可能发现有效的松弛,从而相应优化掉该松弛边在distance数组中的对应的最短路径估计值
  - 当然这些松弛操作中失败的部分(即,经过新结点的新路径并不能够由于目前的最短路径距离的估计值(反而有可能上升),
  - 这时,我们放弃对改点的迭代更新(否则导致负优化),即,我们应当让此时distance数组中对应的终点所对应的距离值保持松弛操作前的值
  - 我们的松弛操作本身就包含了择优判断,这一点很重要

- 只需要对V-S差集集合中的点做松弛操作;
  - 换句话说,对distance数组中的值**有机会**做出优化贡献的只可能是最新加入的已求解结点(通过它的出边松弛操作实现).
  - 反复操作上述流程:从而我们获取新的已求解结点,然后继续用获取的新结点做去优化distance数组,再取其中的最小值获得新的已求解结点,知道distance数组中已经没有元素为止,即所有结点与源点的最短路径都求解完毕)



# 可执行代码

- 包含bellman-ford
- dijkstra算法

- floyd 算法根据公式可以较为简单地自行实现

##  python code:

the code contain a  another algorithm:bellman_ford algorithm,you can use the method to verify the correctness of the dijkstra:

```python
import math
import logging as l
inf = math.inf

l.basicConfig(level=l.INFO)


class Edge():
    def __init__(self, start, end, weight):
        self.start = start
        self.end = end
        self.weight = weight


class Node():
    def __init__(self, sign):
        # self.number = number
        self.sign = sign
        # for initial nodes(vertex) of the graph
        self.distance = math.inf
        # set the node's precursor:
        self.precursor = None

    def initialize_source_node(self):
        self.distance = 0
        return self


class G():
    s_node = None

    def __init__(self, edges, nodes):
        self.edges = edges
        self.nodes = nodes
    # def generate_nodes(self):
    #     # get the nodes number(you can custom the number regularity,there use the default simple number system)
    #     self.nodes = [Node(chr(sign)) for sign in range(ord('A'), ord('E')+1)]

    def print_nodes(self):
        for node in self.nodes:
            # l.debug(f'{node.sign,node.distance}')
            print(f'{node.sign,node.distance}')

    def print_nodes_ford(self):
        self.print_nodes()
    def print_nodes_dijkstra(self, nodes_ite):
        for node in nodes_ite:
            # l.debug(f'{node.sign,node.distance}')
            print(f'{node.sign,node.distance}')

    def get_weight(self, u, v):
        for edge in self.edges:
            if edge.start == u and edge.end == v:
                return edge.weight

        return math.inf

    def relax(self, edge):
        u = edge.start
        v = edge.end
        l.debug(f'self.weight(u, v):{self.get_weight(u, v)}')
        new_distance = u.distance+self.get_weight(u, v)
        # debug
        l.debug(f'{edge.start.sign,edge.end.sign}')
        l.debug(f'new_distance:{new_distance}')
        if v.distance > new_distance:
            v.distance = new_distance
            v.precursor = u

    # def initialize_single_source(G, source_node):
        #     # for node in G.nodes:
        #     #     node.distance=0
        #     #     node.precursor=None
        #     source_node.distance = 0

    def bellman_ford(self, s):
        G.s_node = s.initialize_source_node()
        # l.info(f'G.s_node:{G.s_node.sign}')
        for i in range(len(self.nodes)-1):
            for edge in self.edges:
                self.relax(edge)
                l.debug(f'{edge.end.distance}')
        return self

    def dijkstra(self, s):
        G.s_node = s.initialize_source_node()
        S = []  # the S is the set which contain the solved points
        # Q={}
        Q = self.nodes[:]
        # for node in self.nodes:
        #     # Q[node.sign]=node.distance
        #     Q.append([node.sign,])
        while len(Q) > 0:
            node_u = min(Q, key=lambda item: item.distance)
            S.append(node_u)
            # print("len=",len(Q))
            Q.remove(node_u)
            for edge in self.edges:
                if edge.start.sign == node_u.sign:
                    self.relax(edge)
                    # print("there...")
        return S
    # def print_dijkstra(self):
        # print_nodes(self.dijkstra())

    def print_ford_result(self):
        # self.bellman_ford(s)
        if not self.is_exist_shortest():
            print("there is a nagetive circle.")
        else:
            for node in self.nodes:
                # print()'''  '''
                print(f'from source node to node:{node.sign},the minimal distance is:{node.distance}')

    def is_exist_shortest(self):
        for edge in self.edges:
            if edge.end.distance > edge.start.distance+edge.weight:
                return False
        return True

    def print_precursor(self, node):
        if node.sign == G.s_node.sign:
            print(G.s_node.sign, end=" ")
            # return
        else:
            if node.precursor == None:
                print(G.s_node.sign, "->", node.sign,
                      "(the node is not accessible)", end=" ")
            else:
                self.print_precursor(node.precursor)
                print(node.sign, end=" ")

    def print_path(self):
        for node in self.nodes:
            # print(node.sign)

            self.print_precursor(node)
            print()

def print_nodes(nodes_ite):
    for node in nodes_ite:
        # l.debug(f'{node.sign,node.distance}')
        print(f'{node.sign,node.distance}')

def get_node_instance(sign):
    for node in nodes:
        if node.sign == sign:
            return node

    # throw exception
    return None

# get the edges parameters to instantiate the edge nodes ,put the edges to the list edges;

def generate_edges():
    while(True):
        line = input("input node:")
        if line == "0":
            break
        edge_param = line.split(",")
        start, end, weight = edge_param[0], edge_param[1], int(edge_param[2])
        start_node = get_node_instance(start)
        end_node = get_node_instance(end)
        # print(end_node.sign)
        edges.append(Edge(start_node, end_node, weight))
    return edges

def generate_nodes():
    # get the nodes number(you can custom the number regularity,there use the default simple number system)
    nodes = [Node(chr(sign)) for sign in range(ord('A'), ord('E')+1)]
    return nodes

'''debug the edges is right: '''

def print_edges():
    for edge in edges:
        # print(edge.start.sign,edge.end.sign,edge.weight)
        l.info((edge.start.sign, edge.end.sign, edge.weight))


nodes = []
nodes = generate_nodes()
edges = []
edges = generate_edges()
G = G(edges, nodes)
# G.print_nodes()
source_node = input("input the source node you want:(from 'A'~'E')\n")
# source_node="A"

source_node=get_node_instance(source_node)
result=G.dijkstra(source_node)
print("solved by dijkstra:")
G.print_nodes_dijkstra(result)

print("solved by bellman_ford:")
G.bellman_ford(source_node)
G.print_nodes_ford()
G.print_ford_result()
G.print_path()
''' 
the dijkstra only solve the data without 
negative weights in edges of the Graph


A,B,10
A,C,3
B,C,1
C,B,4
B,D,2
C,D,9
C,E,2
D,E,7
E,D,9
0

A,B,1
A,C,4
B,C,3
D,C,5
D,B,1
B,D,2
B,E,2
E,D,3
0

'''
```

the first input data:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210516114304946.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  the executed result:

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210516114408187.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  the c code:

```c

#include "stdio.h"    
#include "stdlib.h"   

#define MAXVEX 20
#define Infinity 65535

typedef int Status;	/* Status是函数的类型,其值是函数结果状态代码，如OK等 */ 


typedef struct
{
	int vexs[MAXVEX];
	int arc[MAXVEX][MAXVEX];
	int numVertexes, numEdges;
}MGraph;

typedef int Patharc[MAXVEX];    /* 用于存储最短路径下标的数组(怎么走) */
typedef int ShortPathTable[MAXVEX];/* 用于存储到各点最短路径的权值和(有多短) */

/* 构建图 */
void CreateMGraph(MGraph *G)
{
	int i, j;

	/* printf("请输入边数和顶点数:"); */
	G->numEdges=16;
	G->numVertexes=9;

	for (i = 0; i < G->numVertexes; i++)/* 初始化图 */
	{
		G->vexs[i]=i;/*初始化顶点部分*/
	}

	/*初始化所有边上的代价*/
	for (i = 0; i < G->numVertexes; i++)/* 初始化图 */
	{
	
		for ( j = 0; j < G->numVertexes; j++)
		{
			if (i==j)
				G->arc[i][j]=0;
			else
				G->arc[i][j] = G->arc[j][i] = Infinity;
		}
	}

	G->arc[0][1]=1;
	G->arc[0][2]=5; 
	G->arc[1][2]=3; 
	G->arc[1][3]=7; 
	G->arc[1][4]=5; 

	G->arc[2][4]=1; 
	G->arc[2][5]=7; 
	G->arc[3][4]=2; 
	G->arc[3][6]=3; 
	G->arc[4][5]=3;

	G->arc[4][6]=6;
	G->arc[4][7]=9; 
	G->arc[5][7]=5; 
	G->arc[6][7]=2; 
	G->arc[6][8]=7;

	G->arc[7][8]=4;

	/*对称矩阵(处理另一半)*/
	for(i = 0; i < G->numVertexes; i++)
	{
		for(j = i; j < G->numVertexes; j++)
		{
			G->arc[j][i] =G->arc[i][j];
		}
	}

}

/*  Dijkstra算法，求有向网G的v0顶点到其余顶点v的最短路径P[v]及带权长度D[v] */  
/*注意避开(不要与):两点之间直线端最短混淆(最短路jing'径问题往往都是带权的各条边的权没有必然联系,即主要是为了处理多段权的和要小于单段大权的情况
虽然我们画图的时候习惯画直线来链接两个点,但是实际上两点之间的路径可能是弯曲的,出现了直达不一定比转站路径长度之和更短比如圆内接*/
/*  P[v]的值为前驱顶点下标,D[v]表示v0到v的最短路径长度和 */  
void ShortestPath_Dijkstra(MGraph G, int v0, 
	Patharc* P,/* Patharc *p 作为形参时等价与Patharc p[] (都是数组的地址(首元素的地址));(间接传参)*/
	ShortPathTable *D)
{    
	int v,w,k,min;    

	int final[MAXVEX];/* final[w]=1表示已求得顶点v0至vw的最短路径 */
	for(v=0; v<G.numVertexes; v++)    /* 初始化数据 */
	{        
		final[v] = 0;			/* 全部顶点初始化为未知最短路径状态 */
		/*(*D)[v]:(*D)相当于一级指针(也是数组名/数组的地址)*/
		(*D)[v] = G.arc[v0][v];/* 将与v0点有连线的顶点 加上权值 (初始化为代价矩阵第一行*/
		(*P)[v] = -1;				/* 初始化路径数组P为-1  */       
	}

	(*D)[v0] = 0;  /* v0至v0路径为0 */  
	final[v0] = 1;    /* v0至v0不需要求路径 */   

	/* 开始主循环，每次求得v0到 某个v顶点 的最短路径 */   
	for(v=1; v<G.numVertexes; v++)   
	{
		min=Infinity;    /* 保存当前所知离v0顶点的最近距离min */        

		for(w=0; w<G.numVertexes; w++) /* 寻找离v0最近的顶点 */    
		{            
			if(!final[w] && (*D)[w]<min)             
			{                   
				k=w;                    
				min = (*D)[w];    /* w顶点离v0顶点更近,更新min */            
			}        
		}        
		final[k] = 1;    /* 将目前找到的最近的顶点置为1 */

		for(w=0; w<G.numVertexes; w++) /* 修正当前最短路径及距离 */
		{
			/* 如果经过v顶点的路径比现在这条(经过中间点k的)路径长度短的话 */
			if(!final[w] && (min+G.arc[k][w]<(*D)[w]))   
			{ /*  说明找到了更短的路径，修改D[w]和P[w] */
				(*D)[w] = min + G.arc[k][w];  /* 修改当前路径长度 */               
				(*P)[w]=k;/*到w顶点的前驱设置为k(那前驱的前驱哪?之前已处理好)*/
			}       
		}   
	}//for_2
}

int main(void)
{   
	int i,j,v0;
	MGraph G;    
	
	Patharc P;  /*typedef int Patharc[MAXVEX]; 则 Patharc P;这个语句就是int p[MAXVEX]的缩写.
				(还原到原始声明的时候typedef关键字就不要了;再把新类型名用普通变量名(表示符)替换下即可
				p 的类型就是 int[20] 保存前驱结点?*/
	ShortPathTable D; /* 求某点到其余各点的最短路径 */   
	v0=0;
	
	CreateMGraph(&G);
	
	ShortestPath_Dijkstra(G, v0, &P, &D); /* &P和&D 的类型是数组指针: int[]* (而非二级指针 int **)   */

	printf("最短路径倒序如下:\n"); 
	/*二重循环:*/
	for(i=1;i<G.numVertexes;++i)   
	{
		/*打印第i条路径(v0->vi的路径(经过的中间结点的序列逆序):*/
		printf("v %d - v %d : ",v0,i);

		j=i;/*防止随意改动i*/
		while(P[j]!=-1)/*若存在可达路径*/
		{
			/*打印j的前驱p[j]*/
			printf("%d ",P[j]);/*从最后一个前驱向前打印*/
			j=P[j];/*更新后继j*/
		}
		printf("\n");
	}    
	printf("\n源点到各顶点的最短路径长度为:\n");  
	for(i=1;i<G.numVertexes;++i)        
		printf("v%d - v%d : %d \n",G.vexs[0],G.vexs[i],D[i]);     
	return 0;
}

```