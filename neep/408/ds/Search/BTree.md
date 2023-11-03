@[toc]
# B-Tree(BMST/BT)

## 一个例子

- 一棵5阶2层BTree(包含根结点的内部结点部分)
![在这里插入图片描述](https://img-blog.csdnimg.cn/ebab9e3cc0a64fb89e38cffc967ae852.png)
- 这棵B树可能是5阶/6阶,但不可能是其他阶
- 这受到BTree的定义约束
- 每个结点的子树指针数不超过阶数m(上界)
- 还有下界限制...(分析如下一目)

## B树的内涵和缩写来源

| B-TREE缩写来源 | Balanced Multiway Search Tree |
| -------------- | ----------------------------- |

## B-Tree基本特点

- In [computer science](https://en.wikipedia.org/wiki/Computer_science), a **B-tree** is a self-balancing [tree data structure](https://en.wikipedia.org/wiki/Tree_data_structure) that maintains sorted data and allows the following operations in  [logarithmic time](https://en.wikipedia.org/wiki/Logarithmic_time). 

  -  searches,
  
  
    -  sequential access,
  
  
    -  insertions, 
  
  
    - deletions 
  


- The B-tree generalizes the [binary search tree](https://en.wikipedia.org/wiki/Binary_search_tree), 

  - allowing for [nodes](https://en.wikipedia.org/wiki/Node_(computer_science)) with more than two children.[[2\]](https://en.wikipedia.org/wiki/B-tree#cite_note-FOOTNOTEComer1979-2) 
  - Unlike other [self-balancing binary search trees](https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree), the B-tree is well suited for **storage systems** that <u>read and write relatively large blocks of data,</u> such as [databases](https://en.wikipedia.org/wiki/Database) and [file systems](https://en.wikipedia.org/wiki/File_system).

## 不同版本不同说法

- 算法导论
- wikipedia
  - [B树 -](https://zh.wikipedia.org/wiki/B树#术语和定义)(这是完整的来源/下文仅摘取概要)
- 国内严版教材(主要版本)

> 三个地方所描述的方式存在一定差别,同一个词指的东西还不是同一个;但是描述出来的BTree是类似的
>
> 比如内部结点,wikipedia是认为不包括根结点的,
>
> 而严认为是包括根结点的

# wikipedia版(可跳过/回头参考)

### Internal nodes

- Internal nodes (also known as [inner nodes](https://en.wikipedia.org/wiki/Tree_(data_structure)#Terminology)) are **all nodes except for <u>leaf nodes and the root node</u>**. 
  - 这里所说的内部结点是不包括**根结点**也不包括**叶子结点**
  - They are usually represented as <u>an ordered set of elements and child pointers</u>.
    - 内部结点通常代表一系列有序的元素
    - 以及孩子结点(子树)的指针

  - Every internal node contains a **maximum** of *U* children and a **minimum** of *L* children. 
    - 每个内部结点的孩子(子树)数量有一个上限值U,以及一个下限值L

  - Thus, the number of elements is always 1 less than the number of child pointers (the number of elements is between *L*−1 and *U*−1). 
    - 结点内的元素数量总是要比孩子指针数量要少1
    - 也就是说,结点内的元素数量处于[L-1,U-1]闭区间内

#### U&L

- U&L的关系:*U* must be either **2*L* or 2*L*−1**;
  - U=m(B树的阶数)

  - $U=(2L)或(2L-1)$
    - $L=\frac{U}{2}或\frac{U+1}{2}$
    - 总之$L\geqslant\frac{U}{2}$

  - therefore each internal node is <u>at least half full</u>. 
  - The relationship between *U* and *L* implies that two half-full nodes can be <u>joined to make a legal node</u>, and one full node can be split into two legal nodes (if there's room to push one element up into the parent). 
  - These properties make it possible to delete and insert new values into a B-tree and adjust the tree to preserve the B-tree properties.

### The root node

- The root node's number of children has **the same upper limit** as internal nodes, but has no lower limit.
  - 根结点的孩子数的上限和内部结点的上限一样(U)
  - 但是它具有更小的下限值(比L小)
  - For example, when there are <u>fewer than *L*−1 elements in the entire tree</u>, the root will be the only node in the tree with no children at all.


### Leaf nodes

> In Knuth's terminology, leaf nodes do not carry any information. 

- 叶子节点对元素的数量有相同的限制，但是没有子节点，也没有指向子节点的指针。

- 一个深度为n+1 的B树可以容纳的元素数量大约是深度为 n 的B树的 U 倍，

- 但是搜索、插入和删除操作的开销也会增加。和其他的平衡树一样，这一开销增加的速度远远慢于元素数量的增加。

- <u>一些平衡树</u>只在叶子节点中存储值，而且叶子节点和内部节点使用不同的结构。

- B树**在每一个节点中都存储值**，所有的节点有着相同的结构。

- 然而，因为叶子节点没有子节点，所以可以通过使用专门的结构来提高B树的性能。

  



## definition(wiki)

- B树的概念由:**至多**,**至少**,"**除外**"等词语来描述
- According to [Knuth](https://en.wikipedia.org/wiki/Donald_Knuth)'s definition, a **<u>B-tree of order *m*</u>** (n阶B树)is a tree which satisfies the following properties:[[7\]](https://en.wikipedia.org/wiki/B-tree#cite_note-FOOTNOTEKnuth1998483-7)

### m阶BTree结点的子树(指针)数量上限和下限

#### 下限

- Every **internal node** has <u>at least ⌈*m*/2⌉ children.</u>(内部结点孩子数下限为$ceil(\frac{m}{2})\geqslant \frac{1}{2}m,仅当m为偶数的时候取等号$)

  - 例如m=5,则内部结点孩子数至少为$ceil(5/2)=3$

- Every **non-leaf node** ha<u>s at least two children.</u>

- A **non-leaf node** with *k* children contains *k*−1 **keys**.

  - 设非叶子结点(包括内部结点)含有的是孩子数的k,则关键字数为k-1

  - Every node has <u>at most *m* children.</u>(孩子数上限为m)
    - 也至多含有m-1个关键字(key)

- All **leaves appear on the same level** and <u>carry no information.</u>

  - 所有叶子结点处在同层,B-Tree是完全等高的

- Each **internal node's keys** act as separation values which divide its subtrees. 

  - For example, if an internal node has 3 child nodes (or subtrees) then it must have 2 keys: *a*1 and *a*2. 

  - All values in **the leftmost subtree** will b**e less than *a*1**, 

  - all values in the middle subtree will be **between *a*1 and *a*2**, 

  - and all values in the rightmost subtree will be **greater than *a*2**.

    

### Advantages of B-tree usage for databases

- The B-tree uses all of the ideas described above. 

- In particular, a B-tree:

  - **keeps keys in sorted order** for sequential traversing

  - uses **a hierarchical index** to minimize the number of disk reads

  - uses **partially full blocks** to speed up insertions and deletions

  - keeps **the index balanced** with a recursive algorithm

In addition, a B-tree minimizes waste by making sure the interior nodes are at least half full. A B-tree can handle an arbitrary number of insertions and deletions

# domestic(严版)

## 描述B-Tree的参数

- B-Tree(s,n,h,m)
  - s表示顶点数
  - n表示含有那个<u>关键字</u>(而不是结点数!!!)
  - h表示B-Tree的高度
  - m表示阶数(m叉树)

### 内部结点

- 含有关键字的结点(严版)

## BTree定义

- 一棵m阶的B-树，或为**空树**(也就是说,BTree允许0层)，或为满足下列特性的m叉树:

  

### 所有结点

- 树中**每个结点**`至多`有m棵子树;

### 所有分支结点

- 所有的非终端结点`至多`有m-1个关键字(和)
- 由于外部结点的引入,我们认为叶子结点是第h+1层的那些不含关键字的(表示查找失败的结点)
- 而含有关键字的最后一层结点依然认为是分支结点

#### 根分支结点

- 也叫根分支结点也叫非叶根结点

- 若根结点不是叶子结点，则**至少**有两棵子树;
  - 有**两层**的BTree根结点至少有2个子树
- 相较于其他分支结点,根结点是分支结点的时候具有<u>更低的下限(即,2)</u>

#### 非根分支结点

- <u>除根之外</u>的所有**非终端结**点`至少`有ceil(m/2)棵子树;

### 含有关键字信息的最后一层结点

- 为了方便区分不含关键字的叶子结点(外部结点,特意提一下)

### 叶子结点/失败结点

- <u>区别于含有关键字信息的最后一层结点</u>

  - 一般我们不会把叶子结点画出来(它不含关键字信息),只需要意识到它有相应的结构

- 所有的叶子结点都出现在同一层次上，并且不带信息，通常称为**失败结点**

  - （失败结点并不存在，指向这些结点的指针为空。引入失败结点是为了便于分析B-树的查找性能);

  - 如果一棵BTree有关键字个数n,那么查询失败的情况可能有n+1类,(这在二分查找的时候我们已经讨论过了)

    - 比如两个关键字$a_1,a_2$(对于BTree而言可能存在于同一个中结点)
      - 那么查询值x失败的情况为
        - $x\in(-\infin,a_1),(a_1,a_2),(a_2,\infin)$三种可能的区间
        - 而对应的,我们设置了相应数量的外部结点来表示查询失败(n+1)个结点
        - 这是理解(外部)叶子结点的数量和关键字数量关系的好方式

    


### 分支结点的结构:

- ![image-20221007203020305](https://img-blog.csdnimg.cn/img_convert/7afb5cfe0ee626a6c212fb61d3adbb32.png)
- 关键字填充在子树指针间隙之间:($K_i$及其两侧的子树指针形如)
  - $\set{P_{i-1}K_iP_i}$
  - n棵子树(指针)构成n-1个内部缝隙

### 注意两个范围(分支结点)

- $childes\in[ceil(\frac{m}{2}),m]$
  - 每个分支结点的child指针数的范围
  - 但是根结点的下界是例外,可以降到2
- $keys\in[ceil(\frac{m}{2})-1,m-1]$

- 这两个个取值范围在插入和删除的时候起到调整的依据作用
- 推导其他性质(比如结点数和关键字数的关系)

### B树的结点数s&关键字个数n和高度h&阶数m的关系

## 结点数和高度&阶数间的关系

- 如果BTree高度为h,阶为m
- 含有的最多结点数是当这棵树是满m叉树


### 满m叉树结点总数

- 对于一棵**满m叉树**,<u>前h层的结点总数</u>为
  - 结点总数$s_{max}$最多为$s_{max}=1+m+m^2+m^3+\cdots+m^{h-1}=\frac{1(m^h-1)}{m-1}$
    - 同时也是m阶h层B树的结点数上限


### BTree关键字个数上限

- 取上限的时候,BTree结点数要达到最大$\frac{m^h-1}{m-1}$
- 再次基础上,让每个结点内的关键字达到最多m-1个

- BTree的**关键字**个数$n\leqslant (m-1)\frac{m^h-1}{m-1}=m^h-1$
  - 因为B=BTree(n,h,m)的**每个结点**(包括根结点,它可包含的关键字/孩子结点个数的上限都和和其他内部结点一样,只是下限不同)最多含有关键字$m-1$个

### BTree高度下限

- 根据上一节的不等式,自然的变形得到高度h关于结点数n的不等式
- $高度h\geqslant \log_m(n+1)$

### BTree高度上限

- 前面讨论过含有n个`关键字`的BTree的叶子结点数=n+1

  - 这些叶子结点数都分布在第h+1层

    - 意味着该层至少有$2k^{h-1}$个关键字

  - 因此$n+1\geqslant 2k^{h-1}$

  - 得到高度上限:

    - $$
      h\leqslant 1+\log_k(\frac{n+1}{2})= 1+\log_{\lceil \frac{m}{2}\rceil}(\frac{n+1}{2})
      $$

### 小结:BTree的高度确界

$$
\log_m(n+1)\leqslant
h\leqslant 1+\log_k(\frac{n+1}{2})
\\(k=\lceil \frac{m}{2} \rceil)
$$

- 这个结论揭示了一棵含有BTree(n,m)的高度(查找深度)范围
- 例如,当m=3,n=8的时候,$2\leqslant h\leqslant3.17$
  - powershell计算:`u=[Math]::log2(9/2)=2.17...`
  - u+1 $\approx$ 3.17





### 讨论上/下限的材料

- 本文没有覆盖的上下限问题,基本上也是根据两个基本的上限和下限进行讨论
  - 采用贪心的思想可以逐层统计计算最值,比如
    - 关键字个数下限

#### 讨论下限

- 讨论下限的时候,要区分根结点的特殊性
  - 除根结点以外,所有**非根分支结点**(从第2层开始到h层的所有(包含关键字)的结点)
    - **至少**有$k=ceil(\frac{m}{2})$棵子树
    - 这角度描述了下一层结点数的数量规律,可用来计算下一层结点数量
  - 或者说**至少** $有k-1个关键字$
    - 这角度描述的是本层结点的关键字数

#### 讨论上限

- 每个包含关键字的结点的上限都是一样的(包括根结点),不做区分
  - 每个结点**至多**含有m个子树(指针)
  - 最多含有m-1个关键字

### 每层的结点数下限情况

- $s(1)\geqslant 1:$
  - 第一层至少1个结点
- $s(2)\geqslant2:$
  - 第二层至少2个结点
- $s(3)\geqslant2k$
  - 第三层开始就由:
    - 上一层的(每个)分支结点都具有<u>至少$k=ceil(\frac{m}{2})$个子树</u>的性质来计算最少结点数
    - 由于第二层结点数$s(2)=2$
  - 换句欢说,从第三层开始,每层结点数量下限是上层结点数量下限的k倍
- $s(4)\geqslant 2k^2$
- $s(h)\geqslant 2k^{h-2}$
- $s(h+1)\geqslant 2k^{h-1}$
  - 这里计算到了h+1层(外部结点层,是不包含任何信息的叶子结点)

### BTree结点总数量下限

- 如果我们只计算含有关键字的结点数量
  - 即前h层(h>1)
  - $\sum\limits_{i=1}^{h}=1+2+2k+2k^2+\cdots +2k^{h-2}$
    - $=3+2(\sum\limits_{i=1}^{h-2}k^i)=3+2\cdot\frac{k(k^{h-2}-1)}{k-1}$
- 例如,BTree的高度为h=5,阶数为m=3的时候,结点数下限为
  - $s_{min}=3+2\cdot\frac{2(2^3-1)}{1}=3+2\cdot14=33$
  - $s_{max}=\frac{3^5-1}{3-1}=\frac{9*9*3-1}{2}=121$



## B+Tree

### BTree&B+Tree对比

- 和BTree类似,但有以下主要区别

- 非根内部结点的子树数量范围

- |                                      | BTree                                                | B+Tree                                                       | 备注                             |
  | ------------------------------------ | ---------------------------------------------------- | ------------------------------------------------------------ | -------------------------------- |
  | 非根内部结点的关键字范围             | $[ceil(\frac{m}{2})-1,m-1]$                          | $[ceil(\frac{m}{2}),m]$                                      |                                  |
  | $根结点关键字范围$(注意不是子树数量) | $[1,m-1]$                                            | $[2,m]$                                                      | 包含根结点是最后一层结点时的情况 |
  | 非根分支结点子树数量                 | $[ceil(\frac{m}{2}),m]$                              | $[ceil(\frac{m}{2}),m]$                                      |                                  |
  | 根分支结点(非叶根结点)的子树数量     | [2,m]                                                | [2,m]                                                        |                                  |
  | 结点的关键字数:子树指针数            | n:n+1                                                | n:n                                                          | 区分B树和B+树最明显的特征啦      |
  | 叶结点的作用                         | 叶结点(内部)包含的关键字和其他内部结点的关键字不重复 | 叶结点包含信息,叶结点包含所有关键字                          |                                  |
  | 分支结点                             |                                                      | 仅索引,而且包含其孩子结点中的最大元素的副本                  |                                  |
  | 头指针                               |                                                      | 一个指向B+Tree的根结点的头指针A;另一个指向具有最小关键字的叶结点头指针B |                                  |
  | 查找方式                             |                                                      | 借助A可以多路查找,借助B可以顺序查找                          |                                  |

- 判断B树的阶数

  - 可以找到分支结点中具有最多关键字的结点(比如记为k)
    - $由于k\leqslant m-1$
    - 那么该BTree的阶数$m\geqslant k+1$
  - 同时,找到具有最多子树的结点,即这个最大子树值为c
    - $由于c\leqslant m$所以该BTree的阶数至少为c

## BTree的操作

### 查找

- 相对简单,和BST类似,多了结点内部的横向查找

### 插入

- 定位:基于查找算法,找到合适的插入位置
  - 注意,插入的位置不想二叉搜索树那样容易确定
  - 需要优先找到已有的最底层的非叶(内部)结点进行插入
    - 即,要找到表示失败的叶结点,这时候就以确定要插在哪里

- 插入:插入后可能引起BTree性质别破坏
  - 执行**分裂操作**(由于插入溢出引起)
    - 判断依据在于前面介绍的每个结点的关键字数量取值范围和子树取值范围
  - 具体的<u>分裂方法</u>
    - 设新元素key=x要被插入到结点z上
    - 分裂涉及到被分裂的**父结点**(记为z.p)
      - 对于溢出(此时结点数量达到m)而需要分裂的结点,锁定中间位置mid=$ceil(\frac{m}{2})$
      - 将mid元素并入到父结点
        - 如果父结点因为并入z.p而导致溢出,则需要对z.p执行同样的分裂操作
      - 对于刚开始建立B树之类的情况,可能没有现成的父结点,那么被选中的元素就新构造一个上层结点作为父结点(有可能充当了新根结点)

#### 例

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/ea15a6c38b6b490eb6ec8e743f6b72e6.png) | ![](https://img-blog.csdnimg.cn/3aef4fbe20b44b69971138009465abb5.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/7e0ef3f0478b470aa8d6d9537df6fa56.png) |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | A B Tree insertion example with each iteration.  The nodes of this B tree have at most 3 children (Knuth order 3) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/1dbaf3d8a3ed4b5087135dc71eca21b2.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/04937d0fc06d4225a0c2039a0c0ab238.png) |
  |                                                              | 所示为3阶的B-树(图中略去F结点(即叶子结点))，假设需依次插入关键字30、26、85和7。 | 首先通过查找确定应插入的位置。由根*a起进行查找，确定30应插入 |

  



### 删除

- 定位:找到要删除的结点
- 删除类型(同样根据每个结点的关键字数量取值范围和子树取值范围,执行下面三类情况的对应操作)
  - case1:直接删除
    - 删除后不会破坏两个取值范围
  - case2:兄弟够借
    - 删除后破坏两个取值范围中的一个
    - 项被插入结点的兄弟结点借一个结点y
      - 但是借的过程是有讲究的,因为B树是有考虑子树结点元素间的相对大小
      - 需要将前驱后继确定(相关元素大小排列出来,从父结点中的关键字选出结点t替换掉被删除结点x
      - 将被结的结点补偿给父结点(中的那个替换了被删除的结点)
  - cases3:兄弟不够借
    - 那就需要执行**合并操作**
    - 可以让不够借的兄弟结点中的元素合并(吸收走父结点的一个元素)
    - 但这导致父结点关键字数量减少1,进而可能导致父结点也负溢出,需要进一步向父结点的父结点执行类似的操作(包括cases2&3的判断)
      - 如果重复执行到根结点的所有结点都孩子结点吸收光,那么删除掉原根结点,而使新合并的结点作为新的根结点

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/a5dc673f347140d8ad912e957fb0eea6.png)


### 分裂&合并小结

- 两种操作都不是仅仅涉及一个结点
  - 分裂需要影响被插入结点的父结点
  - 合并需要影响父结点和兄弟结点
- 在不理想的情况下,可能要往根结点方向对多个结点执行分裂与合并
