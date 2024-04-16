@[toc]
# 图的遍历算法&归纳推理和认识规律的方法论

# 图的遍历算法

## 深度优先遍历(DFS)

- 通过递归的方式来遍历所有图结点

- 类似于树的先序遍历

- 设函数

  - ```c
    void DFS(Grahp G,Node v){
    	从顶点v开始遍历完整个连通图
    }
    ```

    

- 如果图G是连通图,那么全图的遍历函数组织成:

  - ```c
    void DFSTraverse(Graph G){
    	初始化所有点的访问标记数组visited;
    	DFS(G,v)
    }
    ```

  - 如果G是包含多个连通分量的较为分散的图

    - 极端情况下,这个图只有点,没有边
    - 那么为了遍历

- ```c
  void DFSTraverse(Graph G){
  	初始化所有点的访问标记数组visited;
  	检查visited数组中的所有点是否都被访问过;
  		如果没有访问过,那么从该结点开始作为作为DFS的参数调用DFS,完成该顶点所在的连通分量
  }
  ```

- 可以先学习一个具体的例子

- 然后理解抽象成一般规律的方法

- 最后再用具有一般性的方法来解决具体的问题



## 广度优先遍历(BFS)

- 广度优先遍历通过队列来实现,从第一层遍历到最后一层
- 它不是递归算法
  - 而在深度优先中,的递归实现中,是存在回退
- 而是类似于二叉树的层次遍历算法
- 不存在回退的情况!

## 性能分析

### 存储结构对性能的影响

- 一般的,邻接矩阵的性能是不如邻接表的
  - 邻接矩阵在查找某个点的全部邻接点复杂度为O(|V|),而全图(|V|各定点)所有顶点找各自的所有邻接顶点达到$O(|V|^2)$的复杂度
    - $O(v^2+v)=O(v^2)$
  - 邻接表在查找某个点的全部邻接顶点的复杂度就比较小,并且,查找<u>所有顶点的邻接点也只需要O(|E|)</u>
    - 访问所有顶点(全图共有|V|个定点,整个遍历过程各店只需要访问一次),所需要的时间为O(|V|)
    - 综合查找和访问的复杂度,基于邻接表的图遍历算法复杂度为O(|V|+|E|)
      - 注意不是相乘

#### 广度优先生成树和深度优先生成树的唯一性问题

- 给定的图的处理成**邻接矩阵存储表示是唯一**的,所以BFS下产生的广度优先生成树也是唯一的
- 而邻接表**存储表示不唯一**(如果输入边的**次序**不同(ab,ac,ad)的次序有3!=6中,生成的邻接表也不同,故其广度优先生成树也不是唯一的
- 深度优先生成树的结论类似
- 总结就是,对于同一个图,
  - 基于邻接矩阵的遍历所得到的DFS序列和BFS序列是唯一的
  - 基于邻接表的遍历所得的BFS/DFS序列则都是不唯一

### 问题规模

- 有时候,问题规模依赖于多个指标,**输入规模的最佳概念依赖于研究的问题**。

  - 对许多问题，如排序或计算离散傅里叶变换，最自然的量度是输入中的

    项数，

    - 例如，待排序数组的规模n,

  - 对其他许多问题，如*两个整数相乘*，输入规模的最佳量度是用通常的二进制记号表示输入所需的<u>总位数s</u>。

- 有时，用**两个数**而不是一个数来**描述输入规模**可能更合适。

  - 例如，若某个算法的输入是一个**图**，则输入规模可以用该**图中的顶点数和边数**来描述。
  - 这关乎到相关算法的复杂度度量

### DFS性能分析

- 深度优先遍历在代码中没有显示的使用栈,更没有用队列,而是采用递归的方式实现
  - 奥妙就在递归这里,递归函数的执行需要辅助的<u>**递归工作栈**</u>
  - 空间复杂度是O(|V|)

### BFS性能分析

- BFS的采用队列(Queue)的实现中,需要一个辅助**队列Q**
- 设图G(V,E)有|V|各定点和|E|条边
- 并且,|V|个顶点顶点都要入队列一次(且仅一次),其空间复杂度为O(|V|)
- 采用邻接表存储方式的图,
  - 每个顶点vertex均要搜索一次,时间复杂度为O(|V|)
  - 每条边Edge都需要至少访问一次,时间复杂度为O(|E|)
  - 算法的总时间就是O(|E|+|V|)
- 另一方面,采用邻接存储矩阵的方式
  - 查找每个顶点的邻接点都是需要的时间为O(|V|)
  - 而根据BFS算法的逻辑,我们需要查询每个结点的邻接点
    - $算法的总复杂度为O(|V|^2+|V|)=O(|V|^2)$

## BFS&DFS核心逻辑代码



### 预备部分 数据结构和变量

```cpp
/* for the c language */
// typedef int bool;
// #define 0 False;
// #define 1 True;
/* for the c++ language */
#include <iostream>
#define Max_Vertex_Num 50
typedef struct Graph
{
    //邻接表或者邻接矩阵
    int vexnum;
    // pass the detial implements
} Graph;
typedef struct Q
{
    // pass detail implements
} Queue;
bool visited[Max_Vertex_Num];
void visit(int v); ///比如该元素执行打印操作
void Enqueue(Queue, int);
void Dequeue(Queue, int);
void InitQueue(Queue);
bool isEmpty(Queue);
/* 下面定义的两个函数是图的操作,当遇到不存在的情况下都返回-1(<0)
这样,我们遍历G的某个顶点的所有邻接顶点的时候就可以这么写:

for (int w = FristNeighbor(G, v); w >= 0; w = NextNeighbor(G, v, w))

 */

int FristNeighbor(Graph, int);
int NextNeighbor(Graph, int, int);
/* 队列Q作为全局变量 */
Queue Q;
//函数调用逻辑:用XFSTraverse间接地调用XFS
// 这里的XFS表示BFS或者DFS中的一种.

```

### 公用函数

```cpp
/* 初始化结点访问标记 */
void initializeVisited(Graph G, bool *visited)
{
    for (int i = 0; i < G.vexnum; i++)
    {
        visited[i] = false;
    }
}
```



### BFS

```cpp
/* 访问当前结点,并未下一个结点的访问做准备(即入队列) */
void BFSVisitNowPrepareNext(Queue Q, int vertex)
{
    /* 对每个临界点执行相同和每次调用的开头逻辑:访问并标记点v
                   相同的逻辑*/
    visit(vertex);
    visited[vertex] = true;
    /* 借助队列执行下一步操作 */
    Enqueue(Q, vertex);
}
/* BreadthFirstSearch */
/* 核心逻辑函数:便利连通分量的全部顶点 */
void BFS(Graph G, int v)
{
    BFSVisitNowPrepareNext(Q, v);
    /* 进入循环,访问v的所有邻接点 */
    while (!isEmpty(Q))
    {
        Dequeue(Q, v); //顶点出队
        for (int w = FristNeighbor(G, v); w >= 0; w = NextNeighbor(G, v, w))
        {
            // 访问前先检查邻接点w是否已经别访问过了
            if (!visited[w])
            {
                BFSVisitNowPrepareNext(Q, w);
            }
            //如果已经访问过,那么考察下一个邻接点
        } //当点v的所有邻接点处理完毕,就回到队列头部,如果队列中还有元素,那么重复执行上述过程
        /* 当对接中不再有任何元素时,G的全部连通结点就别访问完毕 */
    }
    /* 最终G的所有顶点都会进出一次队列 */
}
/* for cases that contain severial(>=0) connected subgraph */
void BFSTraverse(Graph G)
{
    initializeVisited(G, visited);
    InitQueue(Q); //引入空队列
    /* 为了能够处理所有连通分量(不遗留某个部分分量) 只好遍历所有标志位,直到所有标志位都被置为true*/
    for (int i = 0; i < G.vexnum; i++)
    {
        if (visited[i] == false)
        {
            BFS(G, i);
        }
    }
}

```

### DFS



```cpp
/* DepthFirstSearch */
void DFS(Graph G, int v)
{
    visit(v);
    visited[v] = true;
    /* for将会体现回退遍历的过程上 */
    for (int w = FristNeighbor(G, v); w >= 0; w = NextNeighbor(G, v, w))
    {
        if (!visited[w])
        {
            DFS(G, w);
        }
    }
}
/* for cases that contain severial(>=0) connected subgraph */
void DFSTraverse(Graph G)
{
    initializeVisited(G, visited);
    /* 同样为了遍历所有连通分量而设定的visited检查遍历 */
    for (int i = 0; i < G.vexnum; i++)
    {
        if (!visited[i])
        {
            DFS(G, i);
        }
    }
}
```

### 函数调用逻辑

- 函数调用逻辑:用XFSTraverse间接地调用XFS
- 这里的XFS表示BFS或者DFS中的一种.

### 遍历连通性

- 无向图
  - xFSTraverse()调用xFS(G,i)的次数为连通分量的个数
  - 即,调用一次,就可以完成一个连通分量的所有顶点的访问
- 有向图
  - 分为强连通分量和非强连通分量
  - 对于一个非强连通分量调用一次XFS(G,i)是没有办法完成分量上的所有顶点的访问

#  其他参考资料
##  dfs with stack structure:
- Depth First Search (DFS)


- The DFS algorithm is a recursive algorithm that uses the idea of backtracking. It involves exhaustive searches of all the nodes by going ahead, if possible, else by backtracking.


- Here, the word backtrack means that when you are moving forward and there are no more nodes along the current path, you move backwards on the same path to find nodes to traverse. All the nodes will be visited on the current path till all the unvisited nodes have been traversed after which the next path will be selected.


## This recursive nature of DFS can be implemented using stacks. The basic idea is as follows:
   **1. Pick a starting node and push all its adjacent nodes into a stack.
   2. Pop a node(the top node,which is the last node be pushed in the stack) from stack 
   3. find the adjacent nodes(not visited yet) of the node was popped just before, then, push all the adjacent nodes into a stack and mark them visited.**

   Repeat this process(you may recursive) until the stack is empty. 
    However, ensure that the nodes that are visited are marked. This will prevent you from visiting the same node more than once. If you do not mark the nodes that are visited and you visit the same node more than once, you may end up in an infinite loop.

```java
Pseudocode
    //Where G is graph and s is source vertex   
    DFS-iterative (G, s):                                   
      let S be stack
      S.push( s )            //Inserting s in stack 
      mark s as visited.
      while ( S is not empty):
          //Pop a vertex from stack to visit next
          v  =  S.top( )
          S.pop( )
          //Push all the neighbours of v in stack that are not visited   
          for all neighbours w of v in Graph G:
              if w is not visited :
                 S.push( w )         
                 mark w as visited


    DFS-recursive(G, s):
        mark s as visited
        for all neighbours w of s in Graph G:
            if w is not visited:
                DFS-recursive(G, w)
```

```cpp
   #include <iostream>
   #include <vector>
    using namespace std;

    vector <int> adj[10];
    bool visited[10];

    void dfs(int s) {
        visited[s] = true;
        for(int i = 0;i < adj[s].size();++i)    {
         if(visited[adj[s][i]] == false)
             dfs(adj[s][i]);
        }
    }

    void initialize() {
        for(int i = 0;i < 10;++i)
         visited[i] = false;
    }

    int main() {
        int nodes, edges, x, y, connectedComponents = 0;
        cin >> nodes;                       //Number of nodes
        cin >> edges;                       //Number of edges
        for(int i = 0;i < edges;++i) {
         cin >> x >> y;     
     //Undirected Graph 
         adj[x].push_back(y);                   //Edge from vertex x to vertex y
         adj[y].push_back(x);                   //Edge from vertex y to vertex x
        }

        initialize();                           //Initialize all nodes as not visited

        for(int i = 1;i <= nodes;++i) {
         if(visited[i] == false)     {
             dfs(i);
             connectedComponents++;
         }
        }
        cout << "Number of connected components: " << connectedComponents << endl;
        return 0;
    }

```
# 认识顺序&认知方法论

### 对立统一规律和认识规律

- 人的认识的一般规律就是由认识个别上升到认识一般，再由一般到个别的辩证发展过程
- 科学认识就是这样一个由特殊到一般，又由一般到特殊，循环往复，不断深化的过程。

### 归纳推理

- 强归纳：(有潜在的正确性和不正确性)
  - 这例示了归纳的本质：从<u>**特殊归纳出普遍**</u>。结论明显不是确定的。
  - 除非我们见过所有的乌鸦 - 我们怎能都知道呢? - 可能还有些罕见的蓝(乌)鸦或是白(乌)鸦。
- 弱归纳：(明显不正确)
  - 在这个例子中，前提建立在确定事物之上： “我总是把画像挂在钉子上”，但是不是所有的人都把画像挂在钉子上，而那些确实使用钉子的人也可能只是有时使用。
  - 有很多物体可以用来挂画像，包括但不限于：螺丝钉、螺栓和夹子。
  - 我做的结论是**过度普遍化**，并在某些情况下是错的。
  - 在这个例子中，基础前提<u>不是建立在确定事物之上</u>：不是所有我发现超速的少年得到了罚单。这可能在于少年要超速的普遍本质 - 同乌鸦是黑的一样 - 但是**<u>前提所基于的更像痴心妄想而不是直接的观察</u>**。

### 演绎vs归纳

- 多数人学习的[形式逻辑](https://zh.wikipedia.org/wiki/形式逻辑)是<u>演绎的而不是归纳</u>的。
  - 相对于[演绎推理](https://zh.wikipedia.org/wiki/演绎推理)，归纳推理达成的**结论**<u>并非必然与最初的假定有相同的确定程度</u>。
    - 例如，所有天鹅都是白色的结论明显是错的，但在[殖民](https://zh.wikipedia.org/wiki/殖民)于[澳大利亚](https://zh.wikipedia.org/wiki/澳大利亚)之前在[欧洲](https://zh.wikipedia.org/wiki/欧洲)一直被认为是正确的。
    - 归纳论证从来就不是[有约束力的](https://zh.wikipedia.org/wiki/有效性)但它们***可以是[有说服力的](https://zh.wikipedia.org/w/index.php?title=有说服力的&action=edit&redlink=1)。***
    - 归纳推理在演绎上是无效的。（在形式逻辑中的论证是有效的，当且仅当论证的前提为真而结论却为假是不可能的。）

- 在归纳法中，总是有很多结论可以合理的关联于特定前提。
  - 归纳是开放的；而演绎是封闭的。
- [归纳问题](https://zh.wikipedia.org/w/index.php?title=归纳问题&action=edit&redlink=1)的经典哲学处理，意味着为**归纳推理找到了正当理由**，是苏格兰人[大卫·休谟](https://zh.wikipedia.org/wiki/大卫·休谟)完成的。
  - 休谟突出了依据重复经验的模式的<u>我们的日常推理</u>，而不是*演绎上的有效论证*。
  - 比如我们相信面包对我们有益，因为过去一直如此，但是面包将来对我们有害至少是可以想象的。
  - 休谟说对所有事情都坚持可靠的演绎上的正当有理的人会饿死的。
  - 替代[激进怀疑论](https://zh.wikipedia.org/w/index.php?title=哲学怀疑论&action=edit&redlink=1)关于所有事物的无所作为，他提倡基于常识的[实用怀疑论](https://zh.wikipedia.org/wiki/科学怀疑论)，这里接受归纳法是必然的。
  - 二十世纪的开发者很不同的为归纳问题加了外框。胜过选择对将来做什么预测，它可以被看作是选择适合于观察的概念（参见条目[蓝绿色](https://zh.wikipedia.org/wiki/蓝绿色)）或适合于观测数据点的曲线图。
- 归纳法有时被加边框为关于从过去做关于将来的推理，但是在最广泛的意义上它涵盖了在已观察的事物的基础上达成对未观察的事物的结论。
  - 从现在的证据推论过去（比如[考古](https://zh.wikipedia.org/wiki/考古)）也算做归纳法。
  - 归纳法也可以跨越空间而不是时间，比如从在我们的星系得出关于整个宇宙的结论，基于本地经济业绩得出关于国家经济政策的结论。