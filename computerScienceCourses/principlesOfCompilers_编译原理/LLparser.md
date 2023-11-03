# 编译原理_字符集(字母表)/LLparser

## 字母表

- 字母表是元素的非空有穷集合,字母表中的元素称为符号，因此字母表也称为符号集。

- 不同的语言可以有不同的字母表，例如汉语的字母表中包括汉字、数字及标点符号等。

- C语言的字母表由字母、数字、若专用符号及char、struct、if、do之类的保留字(特殊单词)组成。

  

## 符号串

- 由字母表中的符号组成的任何有穷序列称为符号串
- 如果某符号串了中有m个符号，则称其长度为m，
-  符号串，即不包含任何符号的符号串，用ε表示，其长度为0,即|ε|=0

## 符号串集合

### 符号串集合上的运算

- 最重要的是笛卡尔积运算(符号串集合之间的乘法)
  - 运算结果还是字母表上的串
- 闭包运算
  - 闭包(克林闭包):字母表上的任意字符序列(任意长度和任意字符)共同构成的字符序列集合称为字母表$\sum$的闭包(包括空串(空字符串ε))
    - 克林闭包可以用<u>字母表的$n$次方幂</u>的并集合表示
    - 字母表的n次方幂运算所得到的结果(是一个集合)中的元素(符号串)的长度是`n`
      - 单个符号的长度是1,但是符号串的长度却可以是0(空串)
      - 串由若干(大等于0)个符号有序构成,需要区分两者的不同
  - 正闭包:
    - 是克林闭包的一个子集(与克林闭包仅相差一个空串`ε`)
    - 闭包(集合)中的元素的数目是无穷多的,但是具体的元素其长度是有穷的
      - (每种语言都可以由无数不同的句子,但是每个句子的长度是有穷的)

## 推导和规约

### 推导

- 推导的概念:用产生式的右部替换产生式的左部(产生式的右部重写左部)



- n步推导的记号
  - 直接推导$\Rightarrow$
  - 长度为n的推导$n\ge1$的推导$\Rightarrow^+$
  - 长度为n($n\ge0$)的推导$\Rightarrow^*$

#### 最左推导(Left-mostDerivation)

- 在最左推导中，总是选择每个**句型**的**最左非终结符**进行替换

##### 最左推导案例

![image-20220616152020671](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616152020671.png)

![image-20220616152436782](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616152436782.png)

- 分析嵌套深度&层内的表达式结构(即,每一层的包含的**<u>兄弟字串</u>**分析清楚),然后选用产生式
- 唯一性

![image-20220616152038629](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616152038629.png)

## 自顶向下分析

### 最左推导和最右推导的唯一性

- 自顶向下的语法分析采用最左推导方式

- 总是选择每个句型的最左非终结符进行替换
- 根据输入流中的下一个终结符，选择最左非终结符的一个候选式

#### 递归下降分析 (Recursive-Descent Parsing)

- 由一组过程组成，**每个过程**对应一个**非终结符**(换句话说,非终结符有其子集的对应的一组过程(可调用))
- 从**文法开始符号S**对应的过程开始，其中**递归调用**文法中**其它非终结符对应的过程**。
- 如果S对应的过程体**恰好扫描了整个输入串**，则成功**完成语法分析**

![image-20220612104517106](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220612104517106.png)

假设A定义为
$$
X_1X_2\dots X_k
$$
其中for遍历就是针对这个产生式的右部的文法符号

## 预测分析

- 递归下降分析的一个特例
  - 预测分析是递归下降分析技术的一个特例，通过在输入中向前看**固定个数（通常是一个）符号**来选择正确的A-产生式。
  - 可以对某些文法构造出**向前看k个输入符号**的预测分析器，该类文法有时也**称为LL(k) 文法类**
  - 预测分析不需要回溯，是一种确定的自顶向下分析方法
- 预测分析法的工作过程
  - 从文法开始符号出发，在每一步推导过程中根据**当前句型的最左非终结符A**和**当前输入符号a**，选择**正确的A-产生式**。
  - 为保证分析的确定性，选出的**候选式必须是唯一**的。


### 左递归文法

> **左递归文法**会使**递归下降分析器陷入无限循环**



- 如果一个文法中有一个**非终结符A**使得**对某个串α**存在一个推导
  $$
  A\Rightarrow^+Aα
  $$
   ，那么这个文法就是左递归的

- 含有**A→Aα**形式产生式的文法称为是**直接左递归的(immediate left recursive)**

- 经过**两步或两步以上推导产生的左递归**称为是**间接左递归**的

#### 消除左递归

- 转化算法如下

  - 事实上，这种消除过程就是把左递归转换成了右递归

  - 对于形如
    $$
    A\rightarrow A\alpha |\beta
    $$
    

  的左递归文法,可以通过如下流程操作,转换为右递归

  - 对于不同的左递归文法,文法符号串α&β的取值是各异的,可以包含非终结符和终结符,他们可以很长
  - 但是非终结符长度为1

  

  - ![image-20220612113023763](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220612113023763.png)

- $$
  A'\rightarrow\alpha A'|\varepsilon
  $$

  - 可以用来产生具有若干个α的串(长度可为0)
  - 正则表达式为:`A'=α*`

- 先确定给定的左递归文法种,充当α&β的部分(α&β的取值)

- 带入到公式原型即可

- > - 将文法串β前提到A的右部的第一个部分
  >   - 引入非终结符A'跟随在β的后面
  >
  > - 然后定义这个被引入的A'为:
  >
  >   - 将文法串α做为右递归文法产生式右部的第一个部分
  >   - A'=αA'|ε(这是一个右递归形式的产生式)
  >
  >   - 并且注意到,空串的引入!

- 下面给出三个例子
  - ![image-20220612113048592](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220612113048592.png)
- 对于第一个例子

$$
A=E\\
\alpha=+T
\\
\beta=T
$$

更一般的![image-20220612130426061](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220612130426061.png)

消除左递归是要付出代价的——引进了一些非终结符和ε_产生式 

将所有候选式一对一对的分析

![image-20220615143212850](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615143212850.png)





### 消除间接左递归

![image-20220612130642805](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220612130642805.png)

经过两部推导,S产生式的右部首字符和左部一致

![image-20220612131029271](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220612131029271.png)

- 注意到S的定义中,有两个候选式
- 所以带入A的右部中的时候,类似于分配律地形式展开:
  - Sd=(Aa|b)d=Aad|bd
  - 即,得到了两个以d结尾的文法字符串
  - 将Sd的值用Aad|bd替换后,得到结果

如此如此,我们得到了直接左递归文法,问题类型转化为了上一种(化归)

- ![image-20220612141914427](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220612141914427.png)
  - 将上述直接左递归进行消除(利用一般的直接左递归消除算法)
  - 共用一个引进的非终结符(A')
- ![image-20220615143806983](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615143806983.png)

#### 消除左递归算法

- 输入：不含循环推导（即形如A \Rrightarrow+ A的推导）和ε-产生式的文法G
- 输出：等价的无左递归文法

![image-20220615145958018](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615145958018.png)

![image-20220615150647567](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615150647567.png)

![image-20220615151043011](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615151043011.png)

- 事实上,对于直接左递归,我们可以通过理解它所描述的串的特征,来对齐进行改造为(右递归)
- 当然,也可以将其写为正则表达式的形式
  - 值得注意的是,包含直接左递归的哪些候选式(譬如上方例子中的Sabc)在正则表达式中可以描述为abc重复若干次$(abc)*$
    - S'=abcS'|ε
  - 对于上述直接左递归,可以理解为:,以
    - abc
    - bc
    - c
    - 这几个的串作为开头的串(因为,S在最终需要替换为上面列举的三个串中的一个,这刚好替换在了串首)
    - 不带有非终结符的,可以理解为串首候选式

#### 提取左公因子(Left Factoring )

 ![image-20220612142936390](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220612142936390.png)

![image-20220612143219192](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220612143219192.png)



## 消除回溯

- 为了消除回溯必须保证**对文法的任何非终结符**，当要它去匹配输入串时，
  - 能够根据它所**面临的输入符**号准确地**指派它的一个候选**去执行任务，并且此**候选的工作结果应是确信无疑的。**
  - ![image-20220615154901537](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615154901537.png)

### Frist(α)的定义(非终结符的候选式的首终结符集)

- 消除回溯要的基本想法是,能够根据当前的输入字符(譬如为a)选用一个唯一合适的候选式来匹配(推导)这个输入字符,这可能包括:
  - 如果文法中的候选式(产生式的右部)恰好是以需要匹配的终结符开头的,那么最理想,就选它
  - 如果候选式都是已非终结符打头,那么需要进一步推测,如果非终结符经过若干步骤推导,可以间接的得到以a打头的串,那么响应的候选式可以选用

> 基于这个想法,我们提出了一个概念:First集合 

- ![image-20220615155551964](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615155551964.png)
- 终结符的FristSet很简单,就是它本身,我们更多的时候是要计算非终结符的FristSet计算方法
- 使用FristSet的定义来计算的空间可能是无穷大的
  - 但为不遗漏的计算出FirstSet,我采用了:重复扫描产生式来代替无限的推导空间的算法
  - 重复扫描的终点是,所有产生式左部的FristSet都不在改变为止,否则反复扫描并修正所有FirstSet
- 注意到,一个非终结符A的候选式α可以多个
  - 而Frist(αi)则是以A的候选式为参数计算候选式的首字符集合

#### Frist(A的候选式)两两不相交

- 非终结符A的各个候选式计算出的首字符集合(First),两两不相交,
  - <img src="https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615155638628.png" alt="image-20220615155638628" style="zoom: 50%;" />
  - <img src="https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615155844095.png" alt="image-20220615155844095" style="zoom: 50%;" />
  - 自上而下最左推导
  - ![image-20220615160955621](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615160955621.png)
  - ![image-20220615161611769](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615161611769.png)

### Follow(A):非终结符A的follow集合

- ![image-20220615161939697](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615161939697.png)
- follow函数的参数是非终结符
- 而其定义中,是从S开始推导(文法句型)



### select集:产生式的可选集

- 产生式p1:**A→β的可选集**是指:
  - *可以<u>选用**该产生式**(p1)进行推导时</u>*对应的**输入符号的集合**，记为**SELECT( A→β )**

#### select(production)函数

- 参数:某个**产生式**,
- 返回值:一个输入符号集合
  - (在进行推导的时候,遇到该集合中的元素,就可以选用被select计算的产生式)
  - 该产生式的合法调用者(输入符号)的集合

#### 借助follow集来定义select集

- 计算selectSet方法

![image-20220616173652736](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616173652736.png)

- SELECT( A→aβ ) = { a }(也就是Frist(a))
- SELECT( A→ε )=FOLLOW( A ) 



#### 构造SelectSet

- 根据FristSet&FollowSet构造SelectSet

![image-20220616173846195](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616173846195.png)



### 构造预测分析表

![image-20220616174139790](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616174139790.png)





##### 借助于first集&follow集来定义select集

产生式A→α的可选集SELECT

- 如果 $ε\notin FIRST(α)$,  那么SELECT(A→α)= FIRST(α)
- 如果$ ε∈FIRST(α), 那么SELECT(A→α)=( FIRST(α)-\{ε\} )∪FOLLOW(A)$
  - 即,α可以推导出空串ε时,(意味着有更多可能,(有机会利用到后面的非终结符的产生式))
  - Frist集中可能包含ε

### 计算Frist(X)

![image-20220614215721655](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220614215721655.png)

![image-20220614215731822](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220614215731822.png)

- 先处理各个产生式的右部中的非终结符打头的部分(直接加入)
- 在处理空串(直接加入)
- 对于产生式右部时非终结符打头的,那么存在继承关系
  - 左部的非终结符将会继承右部的打头的非终结符的所有非终结符
  - 可能要进行链式的查找(继承),例如
    - E继承T
    - T继承F
    - 本例F非空,将F中的终结符加入到T,再把T的终结符加入到E
- 抽象的形式化描述
- ![image-20220614220545760](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220614220545760.png)

### 计算Frist(X1X2...Xn)

- ![image-20220614220457568](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220614220457568.png)
- ![image-20220614220831204](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220614220831204.png)
- ![image-20220614220843342](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220614220843342.png)
- T的follow集合依赖于E'的Frist集合

## 例题

![image-20220616153536408](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616153536408.png)

![image-20220616153602694](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220616153602694.png)







## LL(Left-to-right,Left-most-derivation(最左推导))

- [LLparser-Wikipedia](https://en.wikipedia.org/wiki/LL_parser)

> 预测分析不需要回溯，是一种确定的自顶向下分析方法
>
> 第一个“L”表示从左向右扫描输入
> 第二个“L”表示产生最左推导
> `1`表示在每一步中只需要向前看一个输入符号来决定语法分析动作

- In[computerscience](https://en.wikipedia.org/wiki/Computer_science),an**LLparser**(Left-to-right,[leftmostderivation](https://en.wikipedia.org/wiki/Leftmost_derivation))isa[top-downparser](https://en.wikipedia.org/wiki/Top-down_parsing)forarestricted[context-freelanguage](https://en.wikipedia.org/wiki/Context-free_language).Itparsestheinputfrom**L**efttoright,performing[**L**eftmostderivation](https://en.wikipedia.org/wiki/Context-free_grammar#Derivations_and_syntax_trees)ofthesentence.
- AnLLparseriscalledan**LL(*k*)parser**ifituses*k*[tokens](https://en.wikipedia.org/wiki/Token_(parser))of[lookahead](https://en.wikipedia.org/wiki/Parsing#Lookahead)whenparsingasentence.
  - Agrammariscalledan[LL(*k*)grammar](https://en.wikipedia.org/wiki/LL_grammar)ifanLL(*k*)parsercanbeconstructedfromit.
  - Aformallanguageiscalledan**LL(*k*)language**ifithasanLL(*k*)grammar.
    - Thesetof**LL(*k*)languages**isproperlycontainedinthatof**LL(*k*+1)languages**,foreach*k*≥0.[[1\]](https://en.wikipedia.org/wiki/LL_parser#cite_note-1)
    - Acorollary[ˈkɔrəˌleri]ofthisisthat<u>notallcontext-freelanguagescanberecognizedbyanLL(*k*)parser.</u>

> 文法G是LL(1)的，当且仅当G的**任意两个具有相同左部**的产生式**A→α|β**满足下面的条件：

- 不存在终结符a使得α和β都能够推导出以a开头的串

- α和β至多有一个能推导出ε

- 如果$\beta\Rightarrow^*\varepsilon$，则FIRST(α)∩FOLLOW(A)=Φ；

- 如果$\alpha\Rightarrow^*\varepsilon$，则FIRST(β)∩FOLLOW(A)=Φ；

- > 同一**非终结符**的**各个产生式**的**可选集**(select())互不相交




## LL(1)文法

- 文法G是LL(1)的，当且仅当G的任意两个具有相同左部的
  
- 产生式A → α | β 满足下面的条件：

  - 不存在终结符a使得α 和β都能够推导出以a开头的串

  - α 和β至多有一个能推导出ε 

  - $$
    如果 β \Rightarrow^* ε，则FIRST (α)∩FOLLOW(A) =Φ；
    $$

    

  - $$
    如果 α \Rightarrow^* ε，则FIRST (β)∩FOLLOW(A) =Φ；
    $$


### LL1名词的含义解释

- 第一个“L”表示**从左向右扫描输入**
  - 第二个“ L”表示产生**最左推导**
- “1”表示在每一步中只需要向前看一个输入符号来决定语法分析动作



![image-20220615163655790](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615163655790.png)

![image-20220615163834636](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615163834636.png)

## First&Follow(构造&计算)

- FristSet&FollowSet中的元素都是**终结符**

![image-20220615164113571](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615164113571.png)



### FIRST(α )的计算(计算文法符号串α的FirstSet)

![image-20220615164512398](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615164512398.png)

- 上面,我们把文法符号串分为两大类
- 第一类的文法符号串的长度为1,比较简单
- 第二类的文法符号串长度任意,比较复杂



对于上述的第一大类,构造单个文法符号α=X的FirstSet

- 如果X是终结符集,最简单,直接将认定First(X)={X}
- 否则,需要对X做推导
  - 如果文法中恰好有X的产生式形如
    - X->a...,那么a是Frist(X)的一个元素(加入)
    - X->ε,那么ε也属于Frist(X)
- 另一大类情况中非终结符X的情况比较复杂
  - X->Y...(X又的产生式有牵涉到其他非终结符Y打头)
    - 这时,根据FristSet的含义,可以将First(Y)的非ε元素过继给Frist(X)(已经是递归定义了)
    - 再如果,文法中有形如此的产生式X->Y1Y2...,我们也要考察First(X)是否可以继承(分享)来自右部的非终结符的FristSet,至于能够分享到什么程度,又要考察各个Y_j是否推导ε的情况而定

![image-20220615175506395](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615175506395.png)

- 这里X表示文法符号(长度为1);对该文法符号X求其First(X)

  - 连续使用上述三条规则

  - 如果被求解的X是一个终结符,那么最简单,认定First(X)=X

  - 如果X是一个非终结符

    - (比较简单的非终结符,X以终结符打头或者是一个ε)

      - 那么需要考察该非终结符在文法中的产生式描述,是否有X->a...(非终结符a打头)的形式
      - 如果X->ε,那么也将ε加入到Frist(X)中

    - 如果X是比较复杂的非终结符(X的产生式右部也是以非终结符打头

      - 如果X的产生式右部是一个非终结符Y打头,那么就把Y的FirstSet的所有非ε元素加入到First(X)中

        - X产生式右部的的前若干个非终结符都可以推导出空串ε,那么意味着X推导若干次可以得到Frist(Yi)中的元素,因此将此时的First(Yi)中的非ε元素加入到Frist(X);(这属于复杂情况,遇到连续可以推导ε的情况)
        - 再参考其他材料完善&明确定义
      
      - > 在这一部分,FirstSet有点儿递归定义的味道

- 关于第三点,要求将First(Y)中的非ε元素加入到First(X)中,排除ε的原因是,尽管Y可以推导出ε,但是Y后面可能还跟着其他符号

![image-20220615193107472](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615193107472.png)

#### 构造任何符号串的FristSet

![image-20220615175720151](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615175720151.png)



### 构造FollowSet

- FollowSet的构造依赖于**FirstSet**

  - 尽管原始的FollowSet的定义中并没有直接牵涉FristSet

  - 但是从FristSet的语义上看

- 部分递归构造

- > 通常求解Follow(X)的时候,要结合考虑X后继β的FristSet以及左部E的followSet

- 从句型的角度(文法开始符号S开始推导)的,因此会有一些隐藏的特点(算法的第3步)

- 相比于FristSet的计算,FollowSet将重心移到右部的非终结符中

![image-20220615181406836](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615181406836.png)

![image-20220615181054528](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615181054528.png)

> - 代换(推导),继承后缀

![image-20220615181201247](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615181201247.png)

- 计算followSet的过程中,需要对一个产生式检测多个匹配规则
- ![image-20220615201818599](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615201818599.png)
- 各个非终结符的FollowSet的填充顺序依赖于文法给出产生式的顺序,但是不同的顺序不影响最终结果,因为每一次遍历扫描都会扫描全部的产生式
  - 但是,我们总是应该先处理开始符号的FolowSet,因为开始符号的FollowSet总是有一个`#`符号
  - 不难发现,关于FirstSet的继承操作只需要在第一遍扫描的时候执行就可以了,(而且FristSet不会在更行FollowSet的时候继续变化);即第二遍开始,只需要在扫描各个产生式的时候考虑FollowSet之间的继承

- ![image-20220615201925499](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220615201925499.png)

## 考试小技巧

- 由于FristSet&FollowSet的计算比较复杂,建议,在将推导规则一简介的形式标注在卷子上,以便计算的时候参考,提高正确率和求解效率
  - 例如,followSet的求解的三个分类,将各个模式下于FirstSet&过继FollowSet的示意图标注在上方



