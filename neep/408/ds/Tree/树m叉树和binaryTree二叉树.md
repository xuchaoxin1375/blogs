@[toc]
## 基本性质

## 任意树的通用性质

### 树的定义

- 树的定义是一种递归定义

  - 树是n个结点的有限集合(可空)

  - 对于非空树而言,它的定义是:
    - 结点集合中,有且只有一个特定的点被**选做根结点**
    - **其余结点**再次划分为若干个有限集
    - 这些有限集各自被作为一棵树(称为根结点的子树:再次运用树的已有定义继续选定自己集合内的根节点,再划分下去(每一次划分都会产生一批第一级的子树)
    - 直到所有集合为空集为止


#### 边(分支)

- 每一棵子树需要有一条边来链接到它的上层的根节点
  - 显然,除了初始的大树根节点没有上层结点需要链接,所有它不引起边的产生
  - 或者理解为除了,初始根结点没有上级结点,其余所哟结点都有且仅有一条边指向它的上级

- 这样一来有如下结论:

#### 结点数和边数的关系

- 设一棵树的结点数为n
- 那么他又n-1条边
- `edges(nodes)=nodes-1`
  - 建立树的时候自顶向下
  - 分析点和边的关系的时候,字底向上!

### 二叉树结点和边的关系

- 我们为二叉树的结点分类:

  - $度为0的结点归为{d_1}类结点,共有n_0个$

  - $度为1的结点归为{d_1}类结点,共有n_1个$

  - $度为2的结点归为{d_2}类结点,共有n_2个$

  - $那么二叉树的结点数为nodes=\sum\limits_{i=1}^{2}n_i$

  - $二叉树的边数edges=\sum\limits_{i=1}^{2}i\times n_i$

  - $且edges=nodes-1$

  - $即0n_0+1n_1+2n_2=n_0+n_1+n_2-1;$

  - $n_2=n_0-1;或者n_0=n_2+1$

    

### 结点分类

#### 分支结点

- 有孩子结点的结点就是分支结点(度>0的结点)

#### 叶子结点

- 没有孩子结点的节点就是叶子结点(度为0的结点)

## m叉树的性质

- 从特殊到一般,因此我把m叉树的性质放在二叉树这种特殊化情况的后面,而不单独提取出来说明.

### m叉树的结点数量最多为:

#### $满m叉树第i层结点的数量=m^{i-1}$

- $$
  h层的m叉树,结点数最多的时候是满m叉树
  \\从根结点开始往下看,
  \\第1层有1个结点,l_0级别
  \\第2层 m个结点,l_1级别
  \\第m层 m*m=m^2个结点,均为l_2级别
  \\第4层 m^2*m=m^3个结点均为l_3级别
  \\\vdots
  \\第h层 m^{h-1}个结点,
  \\将它们求和(公比q=m;a_1=0,a_n=m^{h-1};前n=h项):
  $$


$$
  \sum\limits_{i=0}^{h-1}m^i=\frac{1(m^{h}-1)}{m-1}=\frac{1}{m-1}\times(m^{h}-1)\tag{num}
$$



## 二叉树

### 满二叉树

- 所有层的结点数都是满的(尽可能多的)
- 所有的叶子结点都在底层

#### 结点和双亲的序号关系

- 任意非根结点(序号为c)和它的双亲结点序号y具有关系:

  - $p=\lfloor\frac{1}{2}c\rfloor=\lceil \frac{c-1}{2}\rceil$

    

  - $$
    根据前的分析得到,c=2p或者c=2p+1
    \\即,c仅有可能是2p(c是p的左孩子时)
    \\或者2p+1(c是p的右孩子时)
    \\p=\frac{1}{2}c或者\frac{1}{2}(c-1)
    并且我们取两个结果中的整数
    \\(因为,如果不能够整除,那么说明c是p的右孩子)
    \\c是左孩子的时候一定可以整除
    p=\begin{cases}
    \frac{c}{2}&c\%2==0
    \\\frac{c-1}{2}&c\%2==1
    \end{cases}
    \\为了能够更加优雅和简洁的表达上述意思,我们利用向下取整来描述
    \\p=\lfloor\frac{c}{2}\rfloor
    \\实时上,任何能够完成
    \begin{cases}
    f(2p+1)=p
    \\f(2p)=p
    \end{cases}
    的映射(函数f(x))都可以
    \\例如,\lceil\frac{x-1}{2}\rceil也行
    $$





#### $第i层的结点数量为2^{i-1}$

- 第1$层有2^{1-1}=2^0=1个结点$
- 第2$层有2^{2-1}=2^1=2个结点$
- 第3$层有2^{3-1}=2^2=4个结点$
- $\vdots$
- 第i$层有2^{i-1}=2^{i-1}个结点$
- 由此可见,任何二叉树的第i$层的结点数量不超过2^{i-1}个$
- 后面我们将看到,完全二叉树的第i首结点编号就是$2^{i-1}$



#### $第i层结点数量达到2^{i-1}的二叉树$

- 事实上,由于二叉树每个节点的度的限制,只有完全二叉树的第i层结点才能够达到最大值$2^{i-1}$
- 换句话说,如果某棵树的告诉你某棵树的第i层结点数量达到$2^{i-1}-1或者2^{i-1}$
  - 那么这个棵树前i-1层是全满的!
- 第i层结点数量不超过第i-1层结点数量的2倍
- 因此,可以保证,高层满的树(或者在加一个就能够满的),其低层的每一层都是满的!



#### 满二叉树前i层的结点总数为:

- $$
  根据等比求和公式:前i层的结点数量为2^i-1
  $$

  

- $m叉树则为=\frac{1}{m-1}(m^{i}-1)$

  


#### 满二叉树的各行尾结点编号

- 其编号就是前i行结点总数值:
  - 第i$行的行尾结点编号为2^{i}-1$
  - $m叉树则为=\frac{1}{m-1}(m^{i}-1)$

#### 满二叉树的总结点数和高度的关系

- 设满二叉树高度为$h$
  $$
  取公式num中的m=2,
  \\或者i取h即可得到公式
  \\得到s=2^h-1
  $$





### 完全二叉树

- 当高度为h,结点数为n的二叉树的n个结点和等高度的满二叉树的前n个结点完全对应时,该二叉树就是完全二叉树
- 可以把满二叉树视为特别的完全二叉树



#### 完全二叉树的各行首结点编号

- $第i行的首个元素的编号是2^{i-1}$
  - $由于前i行的结点数为2^i-1$
  - $则前i-1行结点数为2^{i-1}-1$
  - $因此,第i行的第一个元素结点为2^{i-1}-1+1=2^{i-1}$

##### 完全m叉树的各行首结点编号

- $类似的方法(前i-1行的元素数量+1),可知m叉树则为=\frac{1}{m-1}(m^{i-1}-1)+1$



#### 完全二叉树的分支结点

- 设完全二叉树的高度为h
- 那么第h-1层可能出现叶子结点!
- 最后一个非叶子结点(分支结点取决于完全二叉树的最后一个叶子结点)
  - 设最后一个结点的编号是n:


#### $最后一个分支结点编号p_{last}=\lfloor\frac{n}{2}\rfloor$

- $n结点的双亲结点p_{last}=\lfloor\frac{n}{2}\rfloor就是最后一个非叶子结点$

- $$
  \\p的下一个结点将没有孩子结点可以分配了.
  \\另一方面,p的下一个结点p+1如果要有左孩子,那么该孩子结点的序号为
  \\
  \begin{aligned}
  c&=2(\lfloor \frac{n}{2}\rfloor+1)=2\lfloor \frac{n}{2}\rfloor+2
  \\&>2(\frac{n}{2}-1)+2=n
  \end{aligned}
  \\即c>n\\
  可见p+1结点没有孩子,是个叶子结点
  $$

#### 最后一个分支结点的孩子结点情况分析

- 如果完全二叉树的结点数n是个偶数,$那么p_{last}$的仅有左孩子

- 否则既有左孩子还有右孩子

  - $$
    设最后一个分支结点位于i=h-1层之前已经分析过;
    \\前i层结点总数2^{i}-1(是一个奇数)
    \\而且,由右孩子结点是其双亲结点p的关系式:c_r=2p+1
    \\显然如果结点数n(也是最后一个结点的编号)
    \\是一个奇数,才有可能成为右孩子结点
    \\如果是个偶数,那么一定是一个左孩子结点.
    $$

    

#### 完全二叉树的任意结点的孩子分析

- 对于有n个结点的完全二叉树,当结点p:

  - $$
    2p\leqslant n时,有左孩子,否则没有左孩子(也不可能有右孩子)
    $$

    

  - $$
    当2p+1\leqslant n,结点p有右孩子(也必有左孩子),否则没有右孩子
    $$

    

  



#### 度为1的结点

- 由于完全二叉树是满二叉树的去掉底层右侧的连续若干个叶子结点得到的
- 处理最后一个分支结点度可能为1(仅有左孩子),其余所有分支结点的度都为2
- 所有叶子结点度都为0
- 因此,完全二叉树的所有结点中,度为1的结点数不超过1(可能么有)



#### 根据双亲结点求孩子结点

- 假设结点p具有孩子结点(非叶子结点)

- $p的左孩子:c_l=2p$

  - $$
    前面讨论过,完全二叉树的按层编号来看每一层的第一个结点的序号为2^{i-1}
    \\我们设双亲结点y所在的层为h层
    那么在h层位于结点i之前面的结点数为i-2^{h-1}
    \\而i的孩子结点位于第h+1层,该层的第一个元素编号为2^h
    \\那么在h+1层,位于结点i的左孩子,记为结点c_l之前面的结点数量为c_l-2^{h}个
    \\容易知道结点数量关系:c_l-2^{h}=2(p-2^{h-1})=2p-2^h
    \\从而得到c_l=2p
    $$

    

- $则i的右孩子c_r=c_l+1=2p+1$



### 二叉树和有序2度树

- 二叉树是概念先行,它允许二叉树的结点数量为0
- 但是度的概念是一个统计概念,如果一颗树的度为2,那么说明它的所有结点的最大度是且只能是2
  - 2度树至少有3个结点(两个孩子结点和一个作为双亲(根)结点)
- 不过从定义上看,任意一颗有序2度树都可以通过添加适当转换规则将现有形状处理成二叉树,反之则不能
  - 有序2度树的`序`是在双亲结点有多个孩子的时候,才有意义(仅有一个孩子的时候不区分顺序)
  - 而二叉树在仅有一个孩子的时候,也要区分它是左孩子还是有孩子(从存储结构上的左右孩子指针可以看出)

### 完全二叉树的高度/最小高度问题

- 设完全二叉树结点总数为n;高度设为h

  - 对于满二叉树:

    - 高度为h-1时有关系式:$n=2^{h-1}-1;h-1=\log_2 (n+1)$

    - 高度为h时:$n=2^{h}-1;h=\log_2 (n+1)$

    - $$
      高度为h的完全二叉树相比高度为h-1的完全二叉树,多了x个结点(x\in[1,2^{h-1}])
      \\我们有2^{h-1}\leqslant n<2^h(形式协调,推荐用此形式进行推导);
      \\或者2^{h-1}-1<n\leqslant  2^h-1
      \\(又或2^{h-1}\leqslant n\leqslant2^h-1)
      \\(其中,2^{h-1}是我们之前讨论过的完全二叉树的第h层首个元素)
      \\2^{h},同样的公式,是完全二叉树的第h+1层首个元素
      $$

    - $$
      因此,完全二叉树的高度为
      \\h=
      \begin{cases}
      &\lceil\log_2 (n+1)\rceil
      \\&或者
      \\&\lfloor\log_2 n\rfloor+1
      \end{cases}
      $$


#### 取整函数的性质

- 注意,一般的
  $$
  当x\in\mathbb{Z}时,\lfloor x \rfloor=\lceil x \rceil
  \\x\notin\mathbb Z时,\lfloor x \rfloor+1 =\lceil x \rceil
  $$

  $$
  上面的公式中,\log_2{n+1}>\log_2 n;
  \\当\log_2 n\in \mathbb{Z}时,\log_2 n<\log_2 {(n+1)}\leqslant(\log_2 {n})+1
  =\log_2 2n
  \\当且仅当n=1时上式可以取等号
  \\令y=2n-(n+1)=n-1;在n\in\mathbb N^+范围内y\geqslant0
  \\当且仅当n=1时上式可以取等号
  \\因此仍然有\lceil\log_2(n+1)\rceil=\lfloor \log_2 n\rfloor+1
  $$


      - 抽查验证:
        - 构建一棵3层以内的矮树,验证临界结点



### 有u个叶子结点的二叉树的高度问题

- $$
  假设叶子结点处于第h层
  \\h层结点数量满足u\leqslant 2^{h-1}
  那么可以得到\log_2u\leqslant h-1
  $$

  
  $$
  1+\log_2u\leqslant h\tag{base}
  $$
  
  $$
  \\由于h一定是一个整数,我们可以对不等式坐标进行取整(进行放缩)
  \\根据取整函数的性质:
  \\floor(x)\leqslant x\leqslant ceil(x)
  \\当且仅当x\in \mathbb{Z}可以取等号(而且两个同时取等)
  \\floor(x)+1\leqslant x+1\leqslant ceil(x)+1
  \\(\log_2u)+1 \leqslant ceil(\log_2u)+1\leqslant h
  \\h不应取floor(\log_2u)+1,因为这可能违背了base式
  $$
  

- 因此

  - $$
    h\geqslant 1+ceil(\log_2u)
    $$

    

  

### 具有n个结点的m叉树的高度问题

- 最小高度:当这个m叉树是`完全m叉树`的时候,构成的树具有最小高度

- 有了推导二叉树的经验,从特殊到一般,我们在来推导`完全m叉树的高度`
  $$
  设高度为h的完全m叉树第i行首结点的编号为:\frac{1}{m-1}(m^{i-1}-1)+1
  \\
  \begin{cases}
  第h行首结点:\frac{1}{m-1}(m^{h-1}-1)+1
  \\第h行尾结点:\frac{1}{m-1}(m^{h}-1)
  \end{cases}
  \\
  \frac{1}{m-1}(m^{h-1}-1)+1\leqslant n\leqslant \frac{1}{m-1}(m^{h}-1)
  $$
  
  $$
  但是这种形式会更加协调:(两边做处理的时候更方便)
  \\\frac{1}{m-1}(m^{h-1}-1)< n\leqslant \frac{1}{m-1}(m^{h}-1)\tag{G}
  $$
  
  $$
  \\\bigstar注意,选择合适的不等式来计算,使得计算过程更加简洁,结论更加清晰
  \\那么一般来讲,选择形式上更加协调的不等式来计算,效果比较好
  \\(用同一侧的相邻行(行h-1和行h的)各自的结点或者尾结点都是不错的)
  \\不等式G等价于:
  \\m^{h-1}-1<n(m-1)\leqslant m^h-1
  \\进一步两边+1得到:m^{h-1}<n(m-1)+1\leqslant m^h
  \\h-1<\log_m (n(m-1)+1)\leqslant h
  \\又由于h是一个整数,所以要取整
  \\(只有向上取整才能够满足上述约束条件)
  \\所以h\geqslant\lceil \log_m(n(m-1)+1)\rceil
  $$
  
  

### 其他类型的特殊二叉树

#### 只有0度结点和2度结点的二叉树

- 按照使树达到最高的方式排列,那么每层仅有两个结点,而且它们是兄弟结点

- 按照使树有最低高度的方式排列,那么每层拥有最多结点

  - 即,最后一个结点是右孩子结点的完全二叉树(n为奇数时)

- 如果结点数n为偶数,那么不可能实现没有1度的结点

  - 因为

  - $$
    n_0=n_2+1
    \\n_0+n_1+n_2=n=2k(表示偶数)
    \\n_0用n_2+1表示,2n_2+1+n_1=2k
    \\则n_1必须是个奇数,等式两边的奇偶性才能够一致
    \\如果n_1=0(没有1度的结点),那么左边是奇数,右边是偶数,矛盾
    \\因此n_1至少为1
    $$

##### 一个关于奇偶性的公式

- 经过上一目的推导,可以得到公式Parity

- $$
  2n_2+1+n_1=2k\tag{Parity}
  $$

  

- <u>公式Parity比较有用,可以记住(或者它的推导过程)</u>

  - 可以用来求解`不可能性`相关问题(结点数组合)

  

## 二叉树的存储

### 顺序存储

- 适合存储完全二叉树,这样效率高

### 链式存储

- 适合存储非完全二叉树
- 对于每个结点设置2个指针,每一条边将占用一个指针(上层结点的指针域)
  - 叶子结点的指针域全为空(NULL)
  - 度为1的结点指针域被占用了一个,另一个为NULL
  - 度为2的结点所有指针域都别占用,没有空指针域
- 另外,由于每个结点中有两个指针域,因而结点数为n的树总共有2n个指针域
  - 其中n-1接入了边(非空)
  - 区域的n+1个指针域全部为空(2n-(n-1)=n+1)
