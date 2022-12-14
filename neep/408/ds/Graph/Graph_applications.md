[toc]

# 图的应用

## 最小生成树(MST)

- MST:Minimum-Spaning-Tree
- 是基于连通图的一个概念:
- 设**带权连通无向图**G=(V,E)的顶点数为n=|V|,最小生成树是
  - **含有这n个顶点**的
  - 具有最少边的**极小连通子图**
  - 可见,最小生成树的边数是结点数n-1;
    - 否则会构成回路或者无法连通所有顶点
    - 这在以前我们讨论过:[dataStructure_图的基本概念和问题_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/127098045)

### 概念&性质

- 最小生成树的一个直观的理解是,将图G中的所有点凝聚在一起(顶点之间存在相互可达的路径)所需要的最小代价
  - 不难理解,确定且具体的带权连通无向图G一定存在最小生成树(至少一棵)
  - 而且这棵最小生成树的边的是确定的(一系列的二元组$(v_i,w_i)$确定这些二元组的先后顺序即使不同,也不会影响最小生成树的最终确定)
  - 在具体的算法设计中,会体现以上的事实

- 在讨论生成树的概念时我们已经知道,一个图的生成树往往不是唯一的
  - 而且就算是最小生成树,也不见得是唯一的:设连通图G的生成树集合$\Re$=ST_Set(G),简单记为ST(G)
    - ST:SpanningTree
  - 但是,当G中的各条边的权值互不相等的时候,那么其最小生成树是唯一的
  - 记MST(G)是G的最小生成树集合
    - 集合中可能包含多棵最小生成树
    - 但是这些最小生成树各自的边权值之后是相等的(唯一确定的)

- 设:
  - U是V的一个子集($U,V\neq \emptyset$)
  - W=V-U(即,集合W是V与U的差集)
  - $顶点u\in U,w \in W;$
    - 若边e=(u,w)是(图G中)最小权值边,那么边e一定属于G的某一棵最小生成树
    - 为了讨论这个这个结论的正确性,我们不妨逆向思考,假设G的最小生成树$MST_\alpha$是已经满足最小生成树的条件
    - 那么将这棵最小生成树中的顶点u抽取出来,不难知道,将顶点u连接到除结点u之外的<u>U'=U-{v}</u>中的结点应该是整个图G中依附于点u的所有边中的最小值
      - $(设U'中的顶点e是使得(u,x),x\in U',x取得最小值的x,即x=w,$
      - 否则由反证法,可以知道,所谓的最小生成树根本就不是权值最小的,
      - 因此,边(u,w)一定是最小生成树的一部分.
    - 由此可见,上面的结论是正确的



### 相关算法

- 基于贪心算法的通用算法框架
  - 构造初始的树的元素集合$T=(U_V,E_T)或简记为(U,E_T)$
    - $其中,U是V的子集;E_T是E的子集$
    - 初始时,最小生成树T的两个元素集合均为空
    - 算法开始启动,开始寻找下一条(包括第一条)边,该边应该满足(u,v)的代价(权值)最小
      - 试探:将这个新边加入到T
        - 如果加入T后,T产生了回路,则废弃该边
        - 否则将该边加入到最小生成树T中.
      - 算法知道T是一棵完成的生成树后停止
  - 算法中有两个相互区别的空间(都包含点集和边集),MST树空间从无到满,
    - 另一个空间是图G的空间,它的两个集合内的元素逐渐加入到MST的对应集合中去,
      - 点集全部加入到MST
      - 边集往往不是全部
- 主要包括prime算法和kruskal算法

#### kruskal算法

- 将森林连接成树
- 或者说,将连通分量的数量从结点数n减少到1
- 算法性能时间复杂度主要取决于边数E
  - 采用堆来存放,性能为O(log|E|),高性能
  - 可以采用**并查集**的数据结构来描述T,构造T的时间复杂度为O(|E|log|E|)
  - 因此,Kruskal算法适合于边数比较少的图(顶点数量太不影响复杂度)

#### prime算法

- 从顶点出发构建的算法
- $其时间复杂度为O(|V|^2)$
  - 可见,边度数量不太影响prime算法的时间复杂度
  - 因此比较适合于点稀疏的图(边稠密)

