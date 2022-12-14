# principe_basic

## 汇编和编译

- 汇编语言:被汇编后得到及其语言的语言
- 汇编语言被汇编为机器语言的过程称为汇编
- 高级语言`翻译为`汇编语言/机器语言的过程,称为翻译

## 翻译

- 词法分析:分析词性/词类
- 语法分析:分析短语->获得句子的结构
- 语义分析:根据句子的结构,分析出各个短语充当的成分->确定各个名词性成分同核心谓语之间的语义关系
- 最后给出中间表示形式

> 翻译的一个重要概念是,`中间形式`,语义的中间形式可以用各种不同的具体的语言来描述(不同的语言可以通过中间形式来联系起来)

## 文法

- 文法解决了无穷语言的有穷表示,文法即语言规则

### 句型&句子

- 文法的句型
- 以下概念注意开始符号S

- 如果 $S \Rightarrow^* α，α∈(V_T∪V_N)^*$，则称α是G的一个**句型(sentential form)**
  - 一个句型中既可以包含终结符，又可以包含非终结符，也可能是空串
- 如果 $S \Rightarrow^* w，w ∈V_T^*$，则称w是G的一个**句子(sentence)**

> **句子**是不包含非终结符的句型

### 文法生成的语言

- 推导 (Derivations) 和归约(Reductions)
  - 均根据语言规则(文法)
  - 句子的推导（派生）从生成语言的角度
  - 句子的归约从识别语言的角度



### 符号约定

这些概念课程后续讨论的基础,需要熟练区分!

> - 文法符号（即终结符或非终结符）:字母表中排在后面的大写字母（如X、Y、Z）                          
> - **终结符号串**（包括空串）:字母表中排在后面的小写字母（主要是u,v,w,x,y,z）                 
> -  小写希腊字母，如α、β、γ，表示文法符号串（包括空串）

- 终结符 a, b, c
-  终结符号串 u, v, . . . , z 

- 非终结符   A, B, C

- **文法符号** X, Y, Z
-  文法符号**串** α, β, γ



#### 开始符号

> - **除非特别说明，第一个产生式的左部就是开始符号**

### 文法的形式化定义



- G = (VT , VN , P , S )

- VT ：终结符集合
- VN：非终结符集合
- P  ：产生式集合
- S  ：开始符号

> 其中,终结符VT和非终结符VN都是非空有穷集

S∈VN。开始符号(start symbol ) 表示的是该文法中最大的语法成分
例：S = 句子 

### 语言的形式化定义

由文法G的开始符号S推导出的所有句子构成的集合称为文法G生成的语言，记为L(G )。
即
$$
L(G )= {w | S\Rightarrow^* w, w∈ V_T^* }
$$

### 语言上的运算

![image-20220611092103391](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220611092103391.png)

### Chomsky 文法分类体系

- 0型文法 (Type-0 Grammar)

  -  无限制文法(Unrestricted Grammar) /短语结构文法
       (Phrase Structure Grammar, PSG )
  - 仅要求:α中至少包含一个非终结符
  - 左部长度至少为1

- 1型文法 (Type-1 Grammar)

  - 上下文有关文法(Context-Sensitive Grammar , CSG )
    ∀α → β∈P，｜α｜≤｜β｜  (即产生式的左部中的符号的个数不能多于右部的符号个数)
  - 另一方面,上下文有关有体现在:
    - 产生式的一般形式： α1Aα2 → α1βα2 ( β≠ε )
    - 即,将A替换为β,需要考虑上下文是否符合可替换规则.
  - CSG中不包含ε-产生式
    - (右部不包含空产生式)
    - 因为,我们要求,α中至少包含一个非终结符(在0文法中就要求的)

- 2型文法 (Type-2 Grammar)

  - 左部必须是一个非终结符
  - 产生式的一般形式：A→β
  - 被称为上下文无关文法,是因为,将A替换为β,不需要考虑上下文

- 3型文法 (Type-3 Grammar)

  

  - 正则语言（3型语言）
    由正则文法 (3型文法) G生成的语言L(G )

  - 正则文法 (Regular Grammar, RG )

    - 右线性(Right Linear)文法： A→wB 或 A→w
    - 左线性(Left Linear)  文法： A→Bw 或 A→w

    

  - > 这里的w是**终结符号串**,

  - 从正则文法的形式化定义可以看出,相比于2文法(上下文无关文法),正则文法对产生式的右部进一步提高了限制要求

  - 描述能力有限

  - 左线性文法和右线性文法都称为正则文法

    α → β

    正则文法能描述程序设计语言的多数单词

### 4种文法:逐级限制

0型文法：α中至少包含1个非终结符
1型文法（CSG） ：｜α｜≤｜β｜
2型文法（CFG） ：α ∈ VN (α就是一个非终结符啦)
3型文法（RG）：A→wB 或 A→w   (A→Bw 或A→w)

四种文法之间的关系

### 上下文无关文法的分析(2型文法)

![image-20220611095712208](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220611095712208.png)

-  根节点的标号为文法开始符号 
-  **内部结点**表示:对一个`产生式A→β`的应用(替换规则的使用)，该**结点的标号**是此**产生式左部A** 。
- 该结点的子结点的标号从左到右构成了产生式的右部β
-  叶结点的标号既可以是非终结符，也可以是终结符。
- 从左到右排列叶节点得到的符号串称为是这棵树的产出( yield )或边缘(frontier) 

### (句型的）短语



- 给定一个句型，其<u>分析树中</u>的<u>每一棵子树</u>的**边缘**称为该**句型的一个短语**(phrase) 

#### 直接短语

- 如果子树**只有父子两代结点**，那么**这棵子树的边缘**称为**该句型的一个直接短语(immediate phrase)** 
- 直接短语一定是**某产生式的右部**
- 但产生式的右部不一定是给定句型的直接短语

### 正则表达式

- 正则表达式可以由较小的正则表达式按照特定规则递归地构建。
- **每个正则表达式 r**定义（表示）一个语言，记为**L(r )**
  - 这个语言也是**根据r 的子表达式**所表示的**语言递归定义**的

#### 正则表达式的定义

- ε是一个RE，L(ε) = {ε}
- 如果 a∈∑，则a是一个RE，L(a) = {a}
- 假设 **r和 s都是 RE**，表示的**语言分别是 L(r)和L(s)**，则

-  r|s 是一个RE，L( r|s ) = L(r)∪L(s) 
  - 判断结果集合种的元素长度不变
-  rs  是一个RE，L( rs ) = L(r) L(s) 
  - 判断结果集合种的元素长度不长度改变
-  r*  是一个RE，L( r* )= (L(r))* 
  - 长度改变
-  (r) 是一个RE，L( (r) ) = L(r)
- **运算的优先级**：
  - ***、**
  - **连接、**
  - **|**


例如:

令 ∑ = {a, b}，则

-  `L(a|b) = L(a)∪L(b) ={a}∪{b} = {a, b}`

-  `L((a|b)(a|b)) = L(a|b) L(a|b)={a, b}{a, b}= { aa, ab, ba, bb }`

  -  上式:判断结果集合种的元素长度:2=(1)+(1)

  

-  `L(a*) = (L(a))*= {a}*= { ε, a, aa, aaa, . . .` }

  -  克林闭包,元素可以是各种长度
  - 如有疑问,请温习克林闭包的形式化描述

  

-  `L((a|b)*) = (L(a|b))*= (L(a)∪L(b) ={a}∪{b} = {a, b})* = {a, b}*= { ε, a, b, aa, ab, ba, bb, aaa, . . .}`

  - 包含任意长度的任意a/b组合序列(以及空串)

-  `L(a|a*b) = { a, b, ab, aab, aaab, . . .}`

  - `a*`的运算优先级最高
    - `a|(a*)b`
  - 其次是连接
    - `a|((a*)b)`
  - 最后是或
    - `(a|((a*)b))`

#### 正则语言

- 可以用RE定义的语言叫做
- 正则语言(regular language)或正则集合(regular set)

![image-20220611105123114](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220611105123114.png)

- 对于`或`运算,满足交换律和结合律
  - 结合律可以用上交换律
- 而或运算对于连接运算,满足分配律

## 自动机

### 有穷自动机

#### DFA

- M = ( S，Σ ，δ，s0，F )

- S：有穷**状态集**(注意到,后面S0,F分别是S的元素和S的子集)

- Σ：**输入字母表**，即输入符号集合。**假设ε不是 Σ中的元素**

- δ：将S×Σ映射到S的**转换函数δ**。 

  - 即:函数的值域是S(的子集)

  - $$
    \delta(S\times\Sigma)\in S
    $$

    

  $$
  \forall s∈S, a∈Σ, \\δ(s,a)表示从状态s出发，沿着标记为a的边所能到达的状态。
  $$

  

- s0：开始状态 (或初始状态)，s0∈ S

- F：**接收状态（或终止状态）集合**，F⊆ S

- 确定的有穷自动机 (DFA) 

### DFA的表示

![image-20220611182926210](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220611182926210.png)

转换图表示法

![image-20220611183033274](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220611183033274.png)

状态表表示法

两个表示方法都可以描述同一个DFA



### DFA

NFA和DFA的唯一区别:
$$
\forall \in S, a∈Σ, 
\\δ(s,a)表示
从状态s出发，沿着标记为a的边所能到达的\underline{状态集合}
$$
NFA的例子

![image-20220611184649903](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220611184649903.png)

![image-20220611184658997](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220611184658997.png)

- 如果转换函数没有给出对应于某个状态-输入对的信息，就把放入相应的表项中







## compilers_文法(grammer)和语法(syntax)

