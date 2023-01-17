@[toc]
# 基本概念

- **概率论**（英语：Probability theory）是击中研究[概率](https://zh.wikipedia.org/wiki/概率)及随机现象的[数学](https://zh.wikipedia.org/wiki/数学)分支，是研究随机性或不确定性等现象的[数学](https://zh.wikipedia.org/wiki/數學)。
- [概率论与数理统计常用英文词汇对照 - emanlee - 博客园 (cnblogs.com)](https://www.cnblogs.com/emanlee/archive/2011/04/29/2032477.html)

## 随机试验

- RExp:Random experiment 随机试验

- 对**随机现象**进行**观察/试验**,称为随机试验,简称**试验**,记为**E**
- 特点:
  - 可重复性:在相同条件下可以重复进行
  - 结果不唯一性:所有的可能结果不止一个(可以无穷多个)
    - 古典概型会对这一方面做限制
  - 已知性:所有**可能的结果**(集合)都能够事先知道
  - 无法预知性:虽然试验的结果的所有可能结果已知,但是每次具体的试验之前都无法预知会出现结果集合中的那一种发生
- 试验的具体意义可以在违背上述几条要求的情况下自行指定
  - 完整的一次试验结果才能够算入/属于$\Omega$(对应样本空间中的一个元素)
  - $第i次试验和第j次试验需要的操作次数不一定相同$
- 例如:
  - 抛硬币
    - 规定一次完整的试验流程为:一枚硬币抛两次
      - 在这种规定下,如果只抛了一次硬币,不能够算作一次完整的试验,出现的阶段性结果,无法构对应试验成样本点
  - 射击:
    - 规定试验要求:对一个目标不断射击,到击中为止,算作一次完整试验
    - 如果某次射击射了10次才集中目标,那么前9次都不能够算作完整的试验
  - 产品(比如灯泡)使用寿命:
    - 规定一次完整的试验:当产品使用到无法正常在使用(或者说损坏)的时候,算作一次完整的试验
      - 如果每个灯泡只测试5秒钟,那么几乎没有意义(几乎所有的灯泡都有5秒钟)
      - 但是测试完整的使用寿命周期,则比较有意义
      - 那么灯泡的使用寿命t的样本空间可以表示为$\Omega=\set{t|t>0}$

### 样本点SP($\omega$)

- SP:sample point 样本点:
  - 随机试验(RE)的**每一种可能**称为样本点,记为$\omega$

#### 例

- 抛一次硬币,算作一次试验

- 对一个目标不断射击,到击中为止,算作一次试验

  - 注意,一次射击不一定完成一次试验

  - 只有击中目标后,才算该次试验做完

  - 试验的结果用射击的次数来描述,比如n次

    

### 样本空间SS$\Omega$

- SS:SampleSpace:
  - 由E的所有SP组成的集合,记为$\Omega$

#### 例

- 从上面的射击试验来看,样本空间可以表示为$\Omega=\set{1,2,\cdots,n}$
  - 每个数字表示一个样本点(代表某次完整试验击中目标时耗费了的射击次数)
- 投硬币
  - 规定一枚硬币投2次(执行两次投掷操作),为才算一次完整的试验
  - 那么样本空间$\Omega=\set{(正,反),(正,正),(反,反),反正}$共有4中可能的结果(4个不同的样本点)

### 随机事件/事件

- 随机事件(Revent:Random Event)简称事件(event):
  - REvent是样本空间$\Omega$的子集
    - 意味着,REvent也是也是由SP构成的
  - 常用字母A,B,C表示事件

#### 例

- 上面的灯泡寿命试验,界定事件A为灯泡的使用寿命小于1000小时
- 记为$A=\set{t<1000}$
- A是$\Omega$的一个子集

### 基本事件

- BE:Basic Event
  - 仅有一个SP构成的Revent

### 随机事件和基本事件的关系

- Revent可以看出有BE组成

### 出现/发生

- 根据RExp的定义,如果某一次试验的结果为某一基本事件BE出现,这称该BE出现/发生
- 如果组成REvent的BE发生,那么也认为REvent出现/发生

### 必然事件$\Omega$

- 如果将$\Omega$看做一个特殊事件,那么每一次试验,$\Omega$必然发生
- 称$\Omega$必然事件

### 不可能事件

- 入过将不包含任何SP的空集$\empty$看出一个事件,
- 那么每次试验E都不会发生$\empty$
- 称$\empty$为不可能事件

## 事件之间的关系

### 事件的包含

- 如果被包含的事件B发生,必然导致A发生,那么称A包含B
  - A的范围更加宽泛
  - 记为$B\subset A$
  - 或者$A\supset B$

### 事件相等

- $A\subset B和B \supset A同时成立,则称事件A=B$

### 交事件/积事件

- 如果$某事件的发生使得A和B同时发生(发生的样本点同时属于A和B),这样的事件称为A,B的交事件或者积事件$

- 记作$A\cap B$

  - 更简单的,记为$AB$

- 集合$A\cap B$是所有同时属于A,B事件集合的<u>公共样本点</u>(公共指定是A,B所共有的)

- 可以推广到更多事件相交:

  - $$
    \overset{n}{\underset{i=1}{\cap}} =A_i
    \\更加语义化和推荐的写法:
    \\ \bigcap_{i=1}^{n}
    $$

    

### 互斥事件(互斥/不相容)$\varnothing$

- $A,B不可能同时发生:A\cap B=\empty$
- $如果总有A_i\cap A_j=\empty(i\neq j),i,j=1,2,\cdots n$,那么这个**<u>n个事件是两两互斥的</u>**



### 并事件(和事件)

- 如果某事件C是(被定义为)A或B至少有一个发生,那么称事件C是A,B的和事件/并事件
  - $被记为C=A\cap B$
  - C是所有属于A,B的样本点$\omega_i$构成的
- 如果一个事件D的发生导致事件A,B至少有一个发生,那么事件D为事件A,B的和事件或者并事件
  - $D\in A\cup B$

### 🎈并事件和交事件简化计算

- $A\cup B$并事件试图扩充A,B事件所包含的样本点
- $A\cap B$交事件试图将A,B包含的样本点收缩
  - $A(A\cup B)=A$
    - 记$C=A\cup B$
    - AC=A
  - $A\cup(A\cap B)=A$
    - $记:C=AB$
    - $C\sub A$
    - $A\cup C=A$

### 对立事件(complementation )(互逆事件)

- 从英文直译上,可以理解为互补事件(相对于样本空间$\Omega$)
- 如果A,B同时满足:
  - $A\cup B=\Omega$
  - $A \cap B=\empty$
- 则称A,B相互对立
- 或者称A,B为**互逆事件**

#### 对立事件之间的基本规律

- $A\cup \overline{A}=\Omega$
- $A\cap \overline{A}=\varnothing$
- $A-\overline{A}=AA=A$
  - $令A取\overline{A},\overline{A}-A=\overline{A}$
  - 这从集合意义上也好理解,毕竟$A\overline{A}=\varnothing$,没有重合样本点,作差就没有影响
- 通常,在化简计算中,遇到上面两个式子,是个好事情

#### 对立事件和互斥事件的关系

- 从互斥事件和对立事件的形式定义(描述)上看,对立事件一定是互斥事件
- 而互斥事件却不一定是对立事件!
- $A\cap \overline{A}=\varnothing$

### 🎃🎃事件的差运算

- 对于事件A发生而B不发生的事件,称为A和B的差事件,记为$A-B$
  - 也就是A相对于B的独占事件
  - 从定义上看如果,任意两个事件可以作差运算:$A\sub B,B-A;A-B=\varnothing(也是有意义的)$

#### 差事件和积事件的转换公式(差化积/积化差公式)

- $A-B=A\cap \overline{B}=A\overline{B}$
  - 由于A的独占事件,B肯定不发生(也就是说,A的独占事件的发生,必定导致B的对立$\overline{B}$发生)
  - 从积事件的角度上看,只有A和$\overline{B}$同时发生这样的时间是A的独占事件
- $A (B-A)=\varnothing,(A\sub B)$
  - 即,$A\cap (B-A)=\varnothing,(A\sub B)$
  - 设:$y=A\cap (B-A)$成立
    - 利用上面的公式以及结合律调整计算顺序,可得到:$y=A(B\overline{A})=A\overline{A}B=\varnothing$
    - $如果记C=B-A,那么AC=\varnothing$
  - 这在证明概率的相关性质很有用
- $B-A=B-AB$
  - 也写作:$B-AB=B-A$
  - 从Veen图也可以直观理解
  - 后面会再次提到


- $A\cup B=A\cup (B-AB)$

  - 借助上一个公式$B-AB=B-A$

  - $$
    y=A\cup (B-AB)=A\cup (B-A)=A\cup (B\overline{A})
    \\借助分配律
    \\=(A\cup B)(A\cup \overline{A})
    =(A\cup B)\Omega=A\cup B
    $$

    


## 简化书写

- 约定:集合加法为$\cup$和集合乘法为$\cap$
  - 在概率论中,姑且称呼它们为事件加法和事件乘法

- 为了书写方便,我们使用,我们借用`数字电路逻辑`中加法含义于乘法含义
- 加法用`+`表示(代替$\cup$;乘法用'$\cdot$'表示(代替$\cap$)
  - 特别注意事件和`+`对事件乘具有分配律
    - 这一点要区分于数学四则运算中加法
  - 而事件乘对事件和也有分配律
    - 有时候,我们将$\cdot$(点)省略不写
- 优先级:
  - A+AB的优先级是AB积事件优先级更高
  - 和集合论中的从左往右计算有些许不同

### 书写习惯

- 推荐:`积事件`运算符$\cap$省略不写

## 🎄🎄🎄事件间的运算规律

- 三种基本运算:(下面的运算定律仅针对基本运算进行讨论)
  - 交/并/差
- 运算定律的描述对象是运算符
  - 某些运算定律的描述涉及多个(种)运算符

### 自反律

- $A\cap A=A$
- $A\cup A=A$

### 交换律和结合律

- 交换律和结合律(分别是Commutative Law and Associative Law)
  - 交运算和并运算都满足交换律和结合律
  - 注意,仅仅在非混合运算的时候成立,否则请考虑分配律!(或者从左往右运算)
  - 例如$A\cup B=A\cup( A-B)=A\cup (A\overline{B})\xlongequal{分配律}(A\cup A)\cap (A\cup \overline{B})=A(A\cup \overline{B})$
  
- 事件交/并运算结合律虽然看起来比交并混合起来的分配律要简单的多,
  - 但是正确的利用结合律,是许多推导/化简中的重要步骤
  - 一些配凑技巧也是利用结合律做文章

### 🎋🎋🎋其他基本规律

#### 🎭🎭全集(必然事件)&空集(不可能事件)相关运算

- $\varnothing=\overline{\Omega}$
- $\Omega=\overline{\varnothing}$
- $A\Omega=A$
- $\varnothing \cap A=\varnothing$
- $\varnothing \cup A=A$
- 则:
  - $(\varnothing\cap B)\cup B=B$

#### 🧧前提和相应真命题

- $若A\sub B$,则:

  - $A\cup B=B$

  - $AB=A$

  - $A\cup (B-A)=B$

    - $y=A\cup(B-A)=A\cup (B\overline{A})=(A\cup B)(A \cup \overline{A})=(A\cup B)\Omega$
    - 根据上面两条结论,进一步得到:$y=A\cup B=B$

    


#### 🏀恒成立命题

- 在讨论分配律之前,有必要认识一下几个最基本的集合关系式
  - $AA=A$

  - $ABB=A(BB)=AB$
  
    - 即:$A\cap B\cap B=A\cap (B\cap B)=A\cap B$
    - 这是有结合律推导,即:$ABB=AB$

  - $A\subset (A\cup B)$
  
    - $\cup 优先级比\sub 高因此可以不加括号$
    - 或者说$B\sub A\cup B$
    - 集合A,B是都是任意集合
    - $a\in A\Rightarrow a\in A\cup B$

  - $AB\sub A $
  
    - 对于任意A,B,上式都成立
    - $即,(A\cap B)\subset A$
    - $a\in A\cap B\Rightarrow a\in A;a\in B$
  
  - $AB\cup B=B;A\cup (AB)=A$
  
    - $即:(A\cap B)\cup B=B$
  
    - 因为$AB\sub A,同时,AB\sub B$
  
  - $A(A\cup B)=A$
  
    - $A\sub (A\cup B)$
  
  - $A(B-A)=\varnothing$
  
    - $C=B-A;AC=\varnothing$
  
  - $B-A=B-AB$
  
    



### 分配律

- **分配律DP（distributive property）**是[二元运算](https://zh.wikipedia.org/wiki/二元运算)的一个性质，它起源于[基本代数](https://zh.wikipedia.org/wiki/基本代数)运算，

  - 同时部分[抽象代数](https://zh.wikipedia.org/wiki/抽象代数)运算亦符合该定律

  - $A*(B+C+D\cdots)=A*B+A*C+A*D+\cdots$

    - 为了让分配的意思更加明确,多写了几项
    - 我们看到的是一个$*对于+满足左分配律的等式$
      - 在展开的过程中,$A*仿佛是一个可被无限取用的物资包,被整个的反复分配给(B,C,D)$
      - 而$+则不动,用来分割展开后得到的各个项$

  - $设  *  及+是定义在集合  S  上的两个二元运算$

    
    $$
    \\我们说
    \\  *  对于+满足左分配律，如果:
    \\\forall x, y, z \in S, x *(y+z)=(x * y)+(x * z)
    \\  *  对于  +  满足右分配律，如果:
    \\\forall x, y, z \in S,(y+z) * x=(y * x)+(z * x)
    \\ 如果  *  对于  +  同时满足左分配律和右分配律，那么我们说*对于十满足分配律。 
    \\如果  *  满足交换律，那么以上三条语句在逻辑上是等价的。
    $$
    

- $X=A\cap (B\cup C)=(A\cap B)\cup (A\cap C)$
  - 记$D=B\cup C;E=A\cap B;F=A\cap C$
  - 描述的是,事件D的发生一定导致A发生和D同时发生
    - 而D的发生一定导致B,C中的至少一件事发生
    - 也就是,X的发生必定导致A发生,并且B或者C中的至少一件事发生
  - 另一边描述的是,事件X的发生一定导致A与B的积事件E与A与C的积事件F中至少一件发生
    - 即,E,F中至少发生一件,而E,F的发生必定导致A发生,而且伴随B或C中的至少一件事发生
    - 也就是说X一定导致A发生,并且B或者C中的也至少一件事发生
  - 可以利用样本点空间**相互包含**来形式化证明分配律等号的成立
    - $A\sube B,A \supe B\Rightarrow A=B$
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/7fe2253d78da420683f1f63b883e9b48.png)

- $Y=A\cup (B\cap C)=(A\cup B)\cap (A\cup C)$
  - 记:$D=B\cap C;E=A\cup B;F=A\cup C$
  - Y的发生必然导致A或D中的至少一件事发生
  - Y的发生必然导致E和F同时发生

#### 类比算数(加和乘)的分配律

- $$
  y=(A+B)\times(C+D)=AC+AD+BC+BD
  \\这可以通过将C+D看做一个整体E,
  \\那么y=(A+B)E=AE+BE
  \\将E=(C+D)代回,得到:
  \\y=A(C+D)+B(C+D)=AC+AD+BC+BD
  $$

  

- 在概率论(集合论中)有类似形式的规律

  - 将$+用\cup代替,(可选:将乘法用\cap)代替,就得到事件运算的另一种分配律形式$

    

  

### 对偶律(德摩根律)

- demorgan
  - demorgan Law 揭示了**和事件**于**积事件**之间的转换关系
  - 以及**对立事件**之间的转换
  - <u>这使得我们可以比较容易的在交事件和积事件(表达式)间变化形式(它们的对立事件也是)</u>
- 其他特点
  - 我们总是可以看到demorgan等式两侧有一个大的取逆号
  - 两侧也总是有一个并$\cup和一个交\cap运算符$
- $\overline{A\cup B}=\overline{A}\cap \overline{B}$
  - $令A取\overline{A},B取\overline{B},则得到\overline{\overline{A}\cup\overline{B}}=A\cap B$
  - 将上式两边同取逆:$\overline{A}\cup \overline{B}=\overline{A\cap B}$



### 事件运算(集合运算)律的逆用

- 典型的,比如:
  - 对偶律
  - 分配律



- 现在我们用+号代替$\cup$改写分配律:
  - $(A+B)\cdot C=AB+BC$
  - $(A\cdot B)+C=(A+C)\cdot (B+C)$
    - $更简单点写:AB+C=(A+C)(B+C)$
  - 从便于记忆的角度来看,可以将$\cdot C$和$+C$绑在一起
- 逆用:提取公共事件:
  - $AB+BC=B(A+C)=(A+C)B$
  - $(A+C)(B+C)=AB+C$
    - 和数学上的+&x和不同
    - 实际上表达的是:$(A\cup C)(B\cup C)=(A\cap B)\cup C$

### 🎈🎈🎈拒绝消去律

- 例如A={1,2,3};B={1,4},C={1,5}
- 下面讨论某些消去律在事件运算中是不成立的
- $AB=AC \not\Rightarrow B=C$
  - AB=AC={1},但是B不等于C
- 类似的,$C-A=C-B\not\Rightarrow A=B$
  - 例如:A={1};B={1,2,},C={1,3,5}
  - C-A=C-B={3,5}
  - 但是显然本例中$A\neq B$
- $A+C=B+C\not\Rightarrow A=B$
  - 例如A={1},B={2},C={1,2}
  - A+C=B+C={1,2}
  - 显然$A\neq B$

### 差事件和并事件的关系

- $A+C-C\not\Rightarrow A$
  - 比如:例A={1,2,3},C={1,2,5}
  - 那么A+C={1,2,3,5}
  - $A+C-C=\set{1,2,3,5}-\set{1,2,5}=\set{3}\neq A$

- $A-C+C$的情况会有不同吗?

  - $A-C+C \supseteq A$

    - 即,$A-C+C\not\Rightarrow A$
    - $记D=A-C+C=\set{1,2,3,5}$

  - 尽管如此,如果我们追加一个条件:$C\sub A$

    - $那么才有(A-C)\cup C=A$

  - 而$(A-(AB))\cup(AB)=A$也总是成立的

    - $因为AB\sub A总是成立的$

    

## 🎈✨✨案例

- 现在,我们使用demorgan'sLaw和差化积公式以及分配律逆用来化简一个稍稍隐蔽的的事件表达式

  - $$
    y=(A+C)-(C-A)=\overline{\overline{A}\ \overline{C}}-C\overline{A}
    =\overline{\overline{A}\ \overline{C}}(\overline{C\overline{A}})
    \\=\overline{\overline{A}\ \overline{C}+{C\overline{A}}}
    =\overline{\overline{A}(\overline{C}+C)}=\overline{\overline{A}\Omega}
    =\overline{\overline{A}}=A
    $$

  - $上面的+理解为\cap$
