@[toc]
# 外部排序

## 时间代价:为什么不用二路归并

- 主要考虑磁盘IO的耗时

- 一般认为,机械IO的耗时远远超过内存运算的时间

- 我们用一次多路归并就完成了所有临时文件的归并，而并非按内存中的二路归并那样，一次归并两个子串，耗费$ \log _{2}n$次归并。

  - 外排序中不适用上述方法的原因在于每次读写都需要对硬盘进行读写，而这是非常缓慢的。
  - 所以应该尽可能减小磁盘的读写次数。

- 在上述方法中也存在权衡。

  - 当临时文件（顺串）的数量继续增大时，归并时每次可从顺串中读入的数据减少了。

  - 比如说，50 GB的数据量，100 MB的可用内存，

    - 这种情况下用一趟多路归并就显得不划算。
    - 读入很多的顺串花费的时间占据了排序时间的大部分。
    - 这时，我们可以用多次（比如两次）归并来解决这个问题。

    - 这时排序算法变为下述这样：

      - 第一步不变。

      - 将小的顺串合并为大一些的顺串，适当减小顺串的数目。

      - 将剩余的大一些的顺串归并为最终结果。

## 概念

### 归并段

- 外部排序一般采用归并排序法

- 包括两个独立的阶段(内部排序+外部归并)

  - 根据内存缓冲区的大小,将外部文件分为k份长度为L的子文件$R_i$
  - 依次将这些文件读入内存,就可以使用内部排序算法对这些子文件进行排序
  - 这些被排序后的子文件,将这些归并段<u>重新写回到磁盘</u>(有序子文件称为**归并段(顺串)**)
  - 这样,获得归并段需要2k次IO

  - 对前一个阶段或得到归并段进行**<u>逐趟归并</u>**,直到得到一个有序的文件

- 在磁盘上,一个归并段的大小可能可能占用了多个盘块

  - 如果缓冲区每次只能够读取一个盘块,那么一个归并段中的数据则不能够被一次性读取完
  - 这意味着需要多次从一个归并段中读取数据块
  - “归并算法”(merge algorithm)对每一个大块只是顺序地做一轮访问(进行归并)，每个大块不用完全载入主存。

  

- 将两个有序段归并成一个有序段的过程,若在内存进行，则很简单(调用merge过程)

- 但是，在外部排序中实现两两归并时，不仅要调用merge过程，而且要进行外存的读/写﹐

- 这是由于我们不可能将两个有序段及归并结果段**同时存放在内存**中的缘故。

- 计算机对外存上信息的读/写是以“物理块"为单位的。

  - 假设外部文件含有$10^4$记录,划分为10个归并段,每段$10^3$条记录,
    - 10个初始归并段到一个有序文件,共进行了4趟归并,每一趟从m个归并段得到$ceil(\frac{m}{2})$ 个归并段。
      - 这种归并方法称为2-路平衡归并。
  - 如果**每个物理块**可以容纳200个记录(每个段R要占用$\frac{1000}{200}=$5个块)，则**每一趟归并**需进行5*10=50次“读”和50次“写”
  - 4趟归(400次IO)并加上内部排序(100次IO得到10个有序归并段**文件**)时所需进行的读/写使得在外排中总共需进行500次的读/写。

#### 小结:每趟归并需要读写磁盘的次数取决于

- 计算机对外存上信息的读/写是**以“物理块"为单位的**
  - 这意味着,尽管内存足够大,访问磁盘的次数却不会减小
  - 但是内存够大,可以为改进提供优化空间
    - 对于k路归并,我们可以读入k个不同归并段的磁盘数据块
    - 以此减少归并趟数,从而减少IO次数
- 待排序文件的记录数量NumberOfRecords=n
- 磁盘块能够容纳的记录数量blockSizeOfRecords=m
- 待排总记录数占用的块数为$\frac{n}{m}$(也就是读磁盘的次数,同时等于写磁盘的次数)
- 因此读写磁盘的总次数为$2\frac{n}{m}$
- ...(或者更多的限制,比如内存缓冲区)



### 内存工作区

- 对于一个含有2000记录的文件,存储在盘块可容纳125条记录的磁盘上
- 先通过8次内部排序,得到8个有序子文件(归并段)
  - 将他们分别记为$R_1,\cdots,R_8$
  - 每个段含有记录125条
- 在内存工作区中分为等分三个缓冲区:
  - 两个输入缓冲区A&B(用以读入归并段)
  - 一个输出缓冲区(保存归并结果)

- $A\&B分别读入R_1和R_2中的一个块$
- 在内存执行2路归并排序
- 排完序后放入输出缓冲区C中
  - 缓冲区C满时,则将内容顺序写入归并段
  - 清空输出缓冲区
- 当某个输入缓冲区中内容为空的时候,继续读入归并段/文件的下一个块
- 当两个输入归并段的数据块都被读入完,而且归并完成,则开始处理其他归并段

### 严格k叉树

- 只有0度和k度结点的k叉树
  - 例如一棵一般的(非完全满的严格二叉树)
    - 只有0度叶子(7个)和2度分支结点(6个)
    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/6bba2a4323de4d2bbd9039e5233bd955.png)

  - 又比如haffman树

### k叉树和k路归并的趟数s与初始归并段数量m的关系

- 对于同一文件而言,进行外部排序所需要的IO次数和归并的趟数s成正比

- 对于m个初始归并段,做k路平衡归并,归并的趟数s满足

  - s就是归并k叉树的高度
  - $m=k^s$
  - $s=floor(\log_k m)$

- 下面分析为什么是这样的

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/fef5724f2bfd489f8b5cb011effe4318.png)

    - 对于m=10段初始归并段,采用k=3路归并进行外部归并

      - 从图中可以看出,执行了3趟归并

      - 如果m=9,则只需要2趟归并

      - 对于满k叉树,第h层的结点数(叶子结点)数m量最多为$k^{h-1}$个

        - $$
          m\leqslant k^{h-1}
          \\ \log_k m\leqslant h-1
          \\因为h是整数,所以我们适当的放缩\log_k m,对其向上取整
          \\
          得到celi(\log_k m),用它来代替不等式左边,方便我们
          \\直接判断h-1的实用的最小值
          \\就是说,等式右边的实际可以取到的有意义的最小整数值是celi(\log_k m)
          \\总结:h\geqslant ceil(\log_k {m})+1
          $$

      - 现在我们回到归并趟数s和k叉树的高度关系之间的讨论

        - 从上图的例子中可以看出,叶子结点的所在层(归并段)归并成倒二层(最后一层分支结点层)
        - 从倒二层一直统计到根结点层,就可以统计出发生了多少趟归并
        - 不过更加直接的理解是,自根结点向叶子结点开始统计
          - 处理根结点不在继续归并,其余所有层都要执行归并
          - 因此归并趟数是层数h-1,即s=h-1
            - 也就是叶子结点到根结点的**路径长度(路径边数)**表示它参与的归并趟数
          - 从而得到归并趟数s和归并路数以及初始归并段数m之间的关系!🎈

        $$
        h-1\geqslant ceil(\log_k{m})
        ,即:
        \\
        s \geqslant ceil(\log_k{m})
        $$

    - 用上面的例子代入体验一下公式:(m=10,k=3)

      - $$
        s\geqslant ceil(\log_3{10})=2+1=3
        $$

        可见,至少需3趟归并操作,和示例中的情况相符合

      - 如果取m=9,k=3,那么只需要执行2趟归并

# 提高外部排序性能

- 从上面的分析可以看出:
  - 减少归并排序趟数s,可以减少IO次数
    - 可以通过增加归并路数k来减小s
      - 扑克牌玩家增加到k位🎈
    - 或者通过减小初始归并段数m,也可以减小s
      - 需要设法加长初始归并段

## k路归并排序所需要的比较次数

- 和2路归并排序的过程相比,k路归并需要比较的次数要多
  - 如果用传统的办法确定最小值
  - 如果引入败者树可以解决这个问题


### 每趟k路归并需要比较的次数T

- 对k路有序序列进行归并,就是要依次逐个的确定k个有序序列最小元素

  - 也就是,从k个有序序列的最小值$L_1,\cdots,L_k$的各自的最小元素$m_1,m_2,\cdots,m_k$中选择最小的元素

  - 过程有点像简单选择排序,总共需要比较的次数为k-1次

  - 如果想要归并得到u个有序记录(u为全部的待归并元素),在大致需要比较$(u-1)(k-1)$次

    - 实际上,就算是最坏的情况也不会达到这个次数
    - 但是可以大致估计出来(特别是u/k比较)
    - 一个可以参考的(主观的最坏情况的比较次数):
      - $(u-k)(k-1)+\frac{k(k-1)}{2}=(k-1)(u-\frac{k}{2})$次

    

### S趟归并需要的比较次数

- $T=S(u-1)(k-1)=ceil(\log_k m)(u-1)(k-1)$
  - T表示TotalComparisons
  - m表示初始归并段数量m
- 由换底公式,$\log_k m=\frac{\log_2m}{\log_2k}$
- 所以$T=ceil(\log_2m)(u-1)\frac{k-1}{ceil(\log_2{k})}$
- 我们需要设法减小后面的因子$\frac{k-1}{ceil(\log_2{k})}$



### 败者树LT(LoserTree)

- 也叫**k路归并败者树**

  - k体现在叶子结点有k个
  - 这和待归并的归并段数量k一致

- 利用败者树来减少由于增大k带来的比较次数的增多

- 能够使得内部k路归并不受到k的增大的影响

- 败者树是<u>树形选择排序</u>的一种变体,视为一棵完全二叉树(CBT(complete BinaryTree))

  ![在这里插入图片描述](https://img-blog.csdnimg.cn/c62c126bcf8a45909f031b1e2b3f64e0.png)

  

  

#### 简单败者树示意图

![在这里插入图片描述](https://img-blog.csdnimg.cn/cb7a2b7723b142819ef378823fb33cd3.png)


- 上面是k=4路归并败者树(k取决于叶子结点数)
- 首先败者树的下方的几个序列分别表示独立的归并段B1~B4
- 叶子结点表示各个归并段当前参与比较的元素
- 而L0结点可以理解为虚拟结点,用来表示本轮比较出来的最小值
- 这样一来上面的树包含两层分支结点和一层叶子结点
  - 分支总是保存某两个叶子结点之间的<u>失败者(元素较大者)所属的</u>**段号**$(\in B1\sim B4)$
  - 比如:
    - 6>0,将6所属段的段号B1(可以简记为1)写入L2分支结点中
    - 9>8,将9所属段的段号B4(简记为4)写入写入到L3分支结点中
    - 现在子树L2和L3的叶子结点中的胜利者分别是0,8
    - 将两个胜利加赛区分:
      - 8>0,所以8所属段号B3(简记为3)写入分支结点L1中
    - 最终的胜利者元素0被确定出来了,将0所属的段号B2写入L0中
    - 本轮操作属于初始化败者树操作,需要比较$k-1$次$(k=4)$
- 在第二轮选择最小元素的过程中,我们将看到,比较次数比单纯的使用选择排序中的方法要少
  - 这是因为,分支结点记住了上一轮比较的阶段性结果,我们利用其这些分支结点,达到减少重复比较的目的
  - 在第一趟中,元素0被确定为第一轮的最小者(总冠军)
  - 于是第二轮中,0的后继元素12接替了0的位置,开始参与比较
  - 主需要看12所在结点的双亲结点中的段号,令12和双亲结点所指段号(B1)的当前待比较元素(6)比较
    - 12>6,于是L2被修改为B2
  - 6继续和它**爷结点**(L1)所指段B3的当前元素8进行比较:
    - 因为L1记录这**上一轮比较中**,子败者树L3下的所有叶子结点中的最小值(所属段号B3)
    - 第二轮比较中,上一轮的胜者子树的最小者和L3所指的元素比较后,得到的较小者可直接认定为第二轮的最小元素
    - 现在,由于8>6,于是此次比较的败者依然是8,所以L1就不需要更改
    - 同时,第二轮比较的出来的最小值也被确定下来,就是6
  - 本轮比较中,我们发现:完全二叉树根结点L1(不包括虚拟的L0)的右子树L3没有元素发生变动,不需要重新比较
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7c370db4bf32453abed2c088b6e940c3.png)

  - 这个例子中,经过第一轮(k-1=8-1=7次比较后),最小者(总冠军)在L2子树侧
  - **<u>那么L3子树侧的最小值则被记录在最后一个记录败者的分支结点L1上</u>**
    - 这一性质对于所有败者树都适用
    - 并且,因此条性质,从第二轮开始,比较次数会得到比第一趟所需的次数(k-1)来的小
    - 上一趟比较弹出的冠军(前冠军)的后继元素进入叶子结点后,只会影响前冠军所在的那一侧子树
    - 另一侧不会发生变化,不需要再次比较
    - 在每层都是如此,只影响一侧
  - 那么,对于败者树,(自第二趟确定最小元素)的过程中,最多只需要比较败者树高度相当的次数
    - 例如前总冠军0被替换为12后,发生如下比较
      - 记$head(Lx)$为某个分支结点所指段号的当前参与比较的元素
      - $min1=min(12 ,head(L4))=min(12,6)=6$
      - $min2=min(min1,head(L2))=min(6,8)=6$
      - $min3=min(min2,head(L1))=min(6,1)=1$
    - 只比较了3次,这恰好是败者树的非(外部)叶子结点高度

#### 估算k路归并败者树的高度:

$$
如果记非叶结点的高度为h,并且由于败者树是完全二叉树
\\第h+1层的结点数量上限为2^{(h+1)-1}=2^h
\\而k路归并意味着至少有k个叶结点
\\
k\leqslant 2^h
\\h\geqslant\log_2k
\\整数放缩:h\geqslant ceil(\log_2{k})
$$



#### 失败者/胜利者

- 理解为百米冲刺用时成绩
- 两个数中较大的为失败者
- 较小的为胜利者

##### 败者之间的关系:strongerLoser & weakerLoser

- 为了更好的描述不同轮次失败者之间的关系,引入两个称呼
- 在LT中,同一个子树根结点的各层分支结点中保存的败者结点(所属段的段号)存在一定关系
- 从算法的执行过程中可以看到,高层的分支结点(strongerLoser)对应的败者叶结点的值是较低层分支结点(weakerLoser)来的强
  - 就是说,strongerLoser vs weakerLoser,胜利的会是前者

- 回到归并排序,为了更加形象的理解归并段号和段内当前参与比较元素的关系:
  - 可以将归并段理解为国家队
  - 将归并段当前参与比较元素理解为当前派出场的赛跑选手



#### 叶结点

- k个叶结点分别存放k个归并段在归并过程中当**前参与比较**的记录

#### 内部分支结点

- 用来记忆子树中的**失败者**(胜利者向上继续比较,知道根结点)
  - 胜利者(叶子结点)类似于守擂台,直到有比自己更小的上层叶结点,自己才转为失败者
- 在败者树中,较晚失败的结点相对于早早失败的结点来的强
  - 相应的,较强的结点(所在的归并段的段号)也较靠后移入才移入到分支结点
  - 低层的分支结点是留给较早失败的结点所归属的段号

- **败者树的子树也是败者树**
  - 记败者树LT的根结点R:
    - 当前冠军结点所在子树为CCLT(champion child loser Tree)
    - 另一颗子树为FCLT(Faild Child Loser Tree)

  - 那么R中保存的总是FCLT子树的最小叶子结点(所在的归并段的段号)
  - 每一层的分支结点(子树根结点)都有这样的规律
  - 因此败者树的效率比直接比较最小值要高

## 🎈使用败者树后S趟比较需要比较的次数

- 直接比较:$T=ceil(\log_2m)(n-1)\frac{k-1}{ceil(\log_2{k})}$
- $败者树比较将分子(k-1)替换为ceil(\log_2k)$
- 🎈🎈从而得到$T=ceil(\log_2 {m})(n-1)$
  - 该公式仅包含了:
    - 初始归并段数m
    - 待归并总记录数n
    - (而于归并路数k无关)


- 从而消除了k增大带来的内部归并排序比较次数的增多.

### 缓冲区和比较路数

- 由于增大归并路数,需要相应数量的**输入缓冲区**来支持
- 如果可用的内存空间有限(不变),那么增加k,会导致每个缓冲区的容量的减小
  - 可能导致内外存交换数据的次数增大
- 因此,k增大来来达到归并次数s减少,读写外存的次数还可能增加

### 其他参考:Tournament Tree

- The Tournament Tree is based on <u>an elimination tournament</u>, as in sports competitions. 
  - In each game, two of the input elements compete. 
  - The winner is promoted to the next round. 
  - Therefore, we get a [binary tree](https://www.wikiwand.com/en/Binary_tree) of games.
  - The list is sorted in ascending order, so the winner of a game is the smaller one of both elements.

####  loser tree

- For k-way merging, it is more efficient to only store the loser of each game (see image).
  -  The data structure is therefore called a loser tree. 
  -  When building the tree or replacing an element with the next one from its list, we still promote the winner of the game to the top. 
  -  The tree is filled like in a sports match but the nodes only store the loser. 
  -  Usually, an additional node above the root is added that represents the overall winner. 
  -  Every leaf stores a pointer to one of the input arrays. Every inner node stores a value and an index. 
  -  The index of an inner node indicates which input array the value comes from. 
  -  The value contains a copy of the first element of the corresponding input array.The algorithm iteratively appends the minimum element to the result and then removes the element from the corresponding input list. It updates the nodes on the path from the updated leaf to the root (*replacement selection*). 
  -  The removed element is the overall winner. Therefore, it has won each game on the path from the input array to the root. When selecting a new element from the input array, the element needs to compete against the previous losers on the path to the root. When using a loser tree, the partner for replaying the games is already stored in the nodes. 
  -  The loser of each replayed game is written to the node and the winner is iteratively promoted to the top. When the root is reached, the new overall winner was found and can be used in the next round of merging.The images of the tournament tree and the loser tree in this section use the same data and can be compared to understand the way a loser tree works.

- For the most part, loser trees and heaps are quite similar.
  -  However, there are a few important distinctions. 
  -  The loser tree, because it provides the loser of each match, **will contain repeat nodes**. 
  -  Since the **heap** is a data-storing structure, it won't contain these redundancies.
  -  Another difference between the two is that the loser tree must be **a full binary tree** (because it is a type of tournament tree), 
  -  but the heap does not necessarily have to be binary.
- Finally, to understand a specific quality of the loser tree, consider the following problem: 
  - Suppose we have k sequences, each of which is sorted in nondecreasing order, that are to be merged into one sequence in nondecreasing order. 
  - This can be achieved by repeatedly transferring the element with **the smallest key** to an output array. 
  - The smallest key has to be found from the leading elements in the k sequences.
  - **Ordinarily**, this would require k − 1 comparisons for each element transferred. 
  - However, with a loser tree, this can be reduced to log2 k comparisons per element.





## 置换选择排序RSS

- 置换-选择排序(Replacement-Selection Sorting)是在树形选择排序的基础上得来的,
- 它的特点是:
  - 在整个排序(得到所有初始归并段)的过程中,选择最小(或最大)关键字
  - 输入&输出**交叉或平行**进行。



### 例

- 已知初始文件含有24个记录v它们的关键字分别为
- 51,49,39,46,38,29,14,61,15,30,1,48,52,3,63,27,4,13,89,24,46,58,33,76

- 假设内存工作区可容纳6个记录,按照
  - 普通的**简单选择排序**可求得如下4个初始归并段:(每段长度6)
    - (51,49,39,46,38,29,)(14,61,15,30,1,48),(52,3,63,27,4,13),(89,24,46,58,33,76)
    - RUN1:29,38,39,46.49,51
    - RUN2:1,14,15,30,48,61
    - RUN3 :3,4,13,27,52,63
    - RUN4 :24,33,46,58,76,89
  - 若按置换-选择进行排序,则可求得如下3个初始归并段:
    - <u>51,49,39,46,38,29</u>,14,61,15,30,1,48,52,3,63,27,4,13,89,24,46,58,33,76
      - 缓冲区大小为6
      - 读入前6个数到缓冲区WA,计算min(WA)=29
      - ...
    - RUN1:29,38,39,46,49,51,61
    - RUN2:1,3,14,15,27 ,30,48,52,63,89
    - RUN3 ; 4,13,24,33,46,58,76

#### 参考资料

- 为了增加每一个有序的临时文件的长度，可以采用[置换选择排序](https://zh.m.wikipedia.org/w/index.php?title=置换选择排序&action=edit&redlink=1)（Replacement selection sorting）。

- 它**可以产生大于内存大小的顺串**。

- 具体方法是在内存中使用一个[最小堆](https://zh.m.wikipedia.org/w/index.php?title=最小堆&action=edit&redlink=1)进行排序

  - 设该最小堆的大小为M。算法描述如下：

    1. 初始时将输入文件读入内存，建立最小堆。
    2. 将堆顶元素输出至输出缓冲区。然后读入下一个记录：
       1. 若该元素的关键码值不小于刚输出的关键码值，将其作为堆顶元素并调整堆，使之满足堆的性质；
       2. 否则将新元素放入堆底位置，将堆的大小减1。
    3. 重复第2步，直至堆大小变为0。
    4. 此时一个**顺串**已经产生。将堆中的所有元素建堆，开始生成下一个顺串。[[3\]](https://zh.m.wikipedia.org/zh-cn/外排序#cite_note-3)

    此方法能生成平均长度为2M的顺串，可以进一步减少访问外部存储器的次数，节约时间，提高算法效率。

### 相关对象

- 待排文件FI
  - 可以是无序的
- 初始归并段输出文件FO
  - 初始为0
  - 输出区中的元素是有序的
- 内存工作区WA
  - 可以容纳w个记录(初始为空)
  - 当RSS算法处理完所有w中的记录,得到所有归并段,算法将结束

### 步骤

1. FI输入w个元素到WA
2. 计算WA中最小元素M=Min(WA)
   1. 这个问题模型符合败者树模型,利用败者树来计算更好
3. 输出M到FO
4. 判断FI是为空,否则在输入一个元素到WA(补偿)
5. 再次计算M'=min(greaterThan(M)),如果存在M',那么M=M'
   - 其中,greaterThan(M)表示WA中大于M的元素(有可能找不到这样的元素)
   - 只有这样,才能够确保FO中的暂存的归并段序列是有序!🎈
6. 重复3~5步骤,直到找不到M'可以移到FO中,那么输出一个结束标记(比如`#`),表示归并段结束
   - 至此产生一个归并段文件
   - 而后就是下一个归并段的计算
7. 重复2~6,直到WA为空
   - 断言,所有初始归并段被处理完毕

### 算法特点

- 从上面的算法可以了解到,RSS算法得到的长度是不保证等长度的
- 为了组织不等长度的归并段的归并(顺序),引入归并树和完美归并树概念

## 归并树

归并树的各个叶结点表示归并段

- 叶权值表示归并段长度
- 叶结点到根的路径长度表示其参与的归并趟数
- 分支结点表示每次归并产生的新归并段
- **树的带权路径长**WPL(Tree)为归并过程中的**读取的总记录数**
  - WPL(Tree):树中所有**叶子结点**的<u>带权路径长度</u>之**和**
  - 记为WPL(Weighted Path Length ((of Tree))
    - $记第i个带权叶结点的权值为w_i$
    - $L_i为根结点到第i个叶结点的路径长度$
  - $wpl=\sum\limits_{i=1}^{n}{w_i}{L_i}$
- IO次数为2WPL(**读的次数**和**写的次数**一致)

### 最佳归并树

- 文件经过`置换-选择排序`后,得到的是长度不等的初始归并段
- 为了使得IO次数最少,引入`最佳归并树`来指导进行组织长度不等的初始归并段的归并顺序
###  ref (huffmanTree)
- 
[dataStructrue_二叉树的应用__Huffman/哈夫曼树和哈夫曼编码/最优归并树/最优m叉树/UnionSet_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/127078351?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"127078351"%2C"source"%3A"xuchaoxin1375"})
#### 实例

- 给定序列2,3,6,9,12,17,18,24,30

  - 以它们为叶子结点构建的最优3叉树如下(同一结点的子树交换位置不影响最优性)

  - 但总是具有最短路径长度:

    - $$
      \begin{aligned}WPL=&(2+3+6)\cdot3+(9+12+17+18+24)\cdot 2+30\cdot1
      \\=&11\cdot3+80\cdot 2+30\cdot1
      \\=&223
      \end{aligned}
      $$

  

  

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/9d389b5b09ce42299bb5d4b86f3245a1.png)
  - IO总次数为$2WPL=2\cdot 223=446$次

### 添加虚段

- 并不是任意结点数都是可以构成严格m叉树
  - 例如,只给你2个叶子结点,让你构建样3叉树是做不到的
  - 但是可以通过添加虚段,将叶子结点数补充到满足构建严格m叉树的条件而且不丢失信息

- 如果给定的叶子结点(归并段)不足以构成一棵严格m叉树,那么需要进行`虚段补充`
- 使得虚段数量刚好可以构成一棵严格k叉树,也就便于计算`最优归并树`
- 不同于最优二叉树,任意给定超过2个的叶子结点总是可以通过huffman建立最优二叉树的方法建立严格2叉树
- 如果想要构建最优m叉树,需要在确保给定的叶子结点数量满足一定规律(严格m叉树)
  - 假设给定的带权叶子结点是有n个,且不能够刚好以它们构成一棵严格m叉树
  - 那么由于我们是从叶子结点开始向根结点的方向构建m叉树,在最后,靠近根结点的时候,根结点度数不满m
    - 假设此时的WPL记为S1
  - 而我们知道,根结点的孩子结点是存放带权结点的好地方,因为路径长度短(仅有1)
  - 我们总是能够通过从其他地方迁移过来一个带权结点,使得新计算的WPL<S1
    - 而且如果迁移过来的结点越大,wpL越小
    - 可以通过验证实例来说明这一点:
      - 将上面的例子中的序列中的权为30的结点删除计算S1
      - 在向序列中补充一个0(虚段),重新结算WPL,和比较S1比价之
- 从上面的分析来看,为了从给定的序列构建出最优m叉树,我们可以先补充合适数量的0权结点(虚段)
- 使得这个补充过虚段的序列构建出来的严格m叉树是具有最短路径长度的最优m叉树

#### 树的基本性质:叶结点和分支结点



- 对于一般的树,满足基本规律:
  - 设结点数为n
    - $n_i为i度子结点数$
    - 总结点数$n=\sum\limits_{i=0}^{k}n_i$
  - 边数为e:
    - $e=\sum\limits_{i=0}^{k}i\cdot n_i$
  - $n=e+1$
- $特别地,对于严格k叉树,n=n_0+n_k;e=kn_k$

#### 严格k叉树:叶子结点和根结点数目关系

- $n_0+n_k=kn_k+1$
  - 即:$n_0=n_k(k-1)+1$
  - 或:$n_k=\frac{n_0-1}{k-1}$

#### 补充多少个虚段构成严格k叉树?

- 显然,如果商$n_k$恰好为整数的时候,$n_0$个归并段(叶结点)恰好可以构成严格k叉树

- 否则,需要通过补偿$x>0$个结点,使得$\frac{n_0-1}{k-1}$能够整除
  - 或者说$(n_0-1)\%(k-1)=0$
  - 记余数$u=(n_0-1)\%(k-1)$
- $需要补充的虚段数x满足(u+x)\%(k-1)=0$
- $正整数x应该尽可能的小,则\frac{u+x}{k-1}=1$
  - $u+x=k-1$
- 因此:$x=k-u-1$
