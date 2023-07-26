[toc]



## 求和式乘法

- $$
  \begin{aligned}
  S=&\prod_{j=1}^{m}\left(\sum\limits_{k=1}^{n_j}a_{jk}\right)_{\!\!\!j}
  \\
  %=&(a_{11}+a_{12}+\cdots+a_{1n_1})
  %(a_{21}+a_{22}+\cdots+a_{2n_2})
  %\cdots
  %(a_{m1}+a_{m2}+\cdots+a_{mn_{m}})\\
  =&\sum_{i_1=1}^{n_1}\sum_{i_2=1}^{n_2}\cdots\sum_{i_m=1}^{n_m}(\prod_{k=1}^{m}a_{k,i_k})
  \end{aligned}
  $$

- 分析这个表达式,可以从以下几个方面入手


#### S展开后的项数

不做任何合并项操作和值为零的项的省略

- 首先,乘法对加法满足分配律关系:$a(b+c)=ab+ac$,利用该规律展开多项式之间的乘法

- $S=(a_1+a_2)(b_1+b_2)$

  - 可以记$B=b_1+b_2$

- $S=a_1B+a_2B=a_1(b_1+b_2)+a_2(b_1+b_2)=a_1b_1+a_1b_2+a_2b_1+a_2b_2$
     - 共有4项
     
   - $S=(a_1+\cdots+a_m)(b_1+\cdots+b_n)=(\sum_{i=1}^{m}a_i)(\sum_{i=1}^{n}b_i)$

     - 记$B=\sum_{i=1}^{n}b_i$
   
- $S=(\sum_{i=1}^{m}a_i)B=\sum_{i}^{m}Ba_i$
  
   - 其中$Ba_i=\sum_{j=1}^{n}b_ja_i$,代入S,$S=\sum_i^m(\sum_{j}^{n}b_ja_i)$=$\sum_i^m\sum_{j}^{n}b_ja_i$,共有$n\times{m}$项
   
   - 把这个结果记为$S_{AB}$,反复运用这个阶段的结论,可以得到下面的结论
   
   - $S=(a_1+\cdots+a_{n_1})(b_1+\cdots+b_{n_2})(c_1+\cdots+c_{n_3})=(\sum_{i=1}^{n_1}a_i)(\sum_{i=1}^{n_2}b_i)(\sum_{i=1}^{n_3}c_i)$

     - $S=ABC=(AB)C$

     - $$
    S=\sum_{i_1=1}^{n_1}\sum_{i_2=1}^{n_2}\sum_{i_3=1}^{n_3}a_{i_1}b_{i_2}c_{i_3}
      $$
    
     - 因此有S有$(n_1\times{n_2})\times{n_3}$项

  - 更一般的,对于:

     - $$
       \begin{aligned}
       S=&\prod_{j=1}^{m}\left(\sum\limits_{k=1}^{n_j}a_{jk}\right)_{\!\!\!j}
       \\
       =&(\sum\limits_{k=1}^{n_1}a_{1k})(\sum\limits_{k=1}^{n_2}a_{2k})
       \cdots(\sum\limits_{k=1}^{n_m}a_{mk})
       \\
       =&\sum_{i_1=1}^{n_1}\sum_{i_2=1}^{n_2}\cdots\sum_{i_m=1}^{n_m}a_{1i_1}a_{2i_2}\cdots{a_{mi_m}}
       \\
       =&\sum_{i_1=1}^{n_1}\sum_{i_2=1}^{n_2}\cdots\sum_{i_m=1}^{n_m}(\prod_{k=1}^{m}a_{k,i_k})
       \end{aligned}
       $$
       
       - 记号说明:对于$\large{a_{k,i_k}}$其中:
         - k表示第k组求和式,$k=1,2,\cdots,m$(比如前面说的$A,B,\cdots$)
       
         - $i_{k}$表示第k组求和式($a_{k1}+a_{k2}+\cdots+a_{k,n_k}$)中的第$i_k$个元素($i_k={1,2,\cdots},n_k$)
       
     - S的项数为$\prod\limits_{j=1}^{m}n_j$
  
  - 例如
  
     - 常见形式$(a+b)(c+d)=ac+ad+bc+bd$,标准的展开方法,而不需要再由乘法对加法的分配律来展开
  
  
     - 例如$(a_{11}+a_{12})(a_{21}+a_{21})(a_{31}+a_{32})$,展开后有$2\times{2}\times{2}=8$项
  
       - $$
         a_{11}a_{21}a_{31}+a_{11}a_{21}a_{32}
         +a_{11}a_{22}a_{31}+a_{11}a_{22}a_{32}\\
         +a_{12}a_{21}a_{31}+a_{12}a_{21}a_{32}
         +a_{12}a_{22}a_{31}+a_{12}a_{22}a_{32}
         $$
  
       
  

#### 每一项的基本因子(即$a_{ij}$)构成

- 根据上一问的讨论,可以知道每一项由m个元素构成

- 并且任意**2**组中的任意**2**个元素都一定有且只有相乘(构成一个项),

 - 项$(\prod_{k=1}^{m}a_{k,i_k})$的构成中可以看出项的<u>m个因子一定来自不同的求和组</u>

#### 多重求和号要和乘法区别

- 例如

  - $$
    \sum_i^{m}\sum_j^{n}a_{ij}=\sum_{j}^{n}\sum_{i}^{m}a_{ij}
    $$

    - 应该要把$\displaystyle \sum_i^{n}\sum_j^{m}$看作一个整体符号,而不是$\displaystyle(\sum_i^{n})(\sum_j^{m})$
    - 上面这个式子可以完成矩阵$(a_{ij})_{m\times{n}}$的所有元素求和,第一个是按行求和,第二个是按列求和

  - 求和号的结构

    - $\displaystyle{\sum_{i=1}^{n}}a_i$
    - $i$是求和指标,通常可以是任意字母(但是注意在求和项比较复杂时要选用不会导致混淆的字母作为指标)
      - 例如矩阵元素求和

  - 当相加的数具有多个指标的时候,可以用多重连加号(求和号)

    - $$
      \sum_{i+j+k=t}a_ib_jc_k=\sum_{i+r=t}\sum_{j+k=r}a_ib_jc_k
      $$

      

### 二项式乘积展开项相关问题

- $f(x)=\prod_{i=1}^{n}(x+a_i)$,则$f(x)$的k次项的系数$c_k$为?
  - $c_n$=$1$
  - $c_{n-1}=\sum_{i=1}^{n}a_i$
  - $c_{n-2}$=$\sum_{i_1\neq{i_2}}a_{i_1}a_{i_2}=a_1a_2+\cdots+a_1a_n+\cdots+a_{n-1}a_{n}$
  - $\cdots$
  - $c_{k}=\sum_{|set(i_1,i_2,\cdots,i_k)|=k}a_{i_1}a_{i_2}\cdots{a_{i_k}}$,$set$表示取集合,$|set(i_1,i_2,\cdots,i_k)|=k$表示$i_1,i_2,\cdots,i_k$是不相同的k个数

### 应用

- 可以用来确定m此项的系数

- 例如

  - $$
    f(x)=\sum_{i}^{n}(x+a_i)
    $$

  - 将$f(x)$展开合并同类项后

    - 那么$x^{n-1}$的系数是多少?

      - $f(x)$是一个n次多项式
      - 在合并同类项之前,包含$x^{n-1}$的项有$\binom{n}{n-1}=\binom{1}{n}$项
      - 它们的系数分别是$a_1,\cdots,a_n$

    - $x^{3}$的系数又是多少?

      - $\binom{n}{3}$,这些项的系数分别是$\prod_{i\in{P_3}}a_i$
        - 其中$P_r$表示对$a_1,\cdots,a_n$做$\binom{n}{n-r}$的排列(本例中r=3)

    - 一般的,$x^{r}$的系数是

      - $$
        \large\sum_i^{n_r}{(\prod_{i\in{P_{r}}}a_i)}
        \\
        其中:n_r=\binom{n}{r}
        $$

        

  - 例如$(x+1)(x+2)(x+3)=(x^2+3x+2)(x+3)=x^3+6x^2+11x+6$

    - $x$的系数
      - $n_r=3$
      - $(2\times3)+(1\times3)+(1\times2)=11$
    - $x^2$的系数为
      - $n_r=3$
      - $3+1+2=6$



##  求和中的对称性

$$
\sum\limits_{i=0}^{i=n}a^{i}b^{n-i}=\sum\limits_{i=0}^{i=n}a^{n-i}b^{i}
\\
LHS=a^0b^n+a^1b^{n-1}+\dots+a^{n-1}b^{1}+a^{n}b^0
\\
RHS=a^nb^0+a^{n-1}b^{1}+\dots+a^{1}b^{n-1}+a^0b^n
$$

- 对比上述的$LHS\&RHS$,不难发现,LHS中的各项时RHS中各项顺序互为逆序,而互为逆序的两个数列各自的求和结果显然一致,即$HLS=RHS$
- 对称性需要保证a的指数和b的指数之和为n:$(i+(n-i)=n)$
- 求和式的各个项(term)的两个幂因子($a^ib^j)$(其中$i+j=n$(常数)),换句话说,确定了$i,j=n-i$这个值也就被唯一确定了(两个项如果有相同的幂因子($a^i$),则这两个项相等(在当前的上下文语境中,两个项来自于不同的两侧),
- 为此,我们考察求和的对称性的时候,只需要专注于项的第一个幂因子($a^i$),发现,仅仅只有累加的顺序不同,因此式子左边和右边式相等

## refs

### 多项式相关内容

- 非数学专业的同学可能对多项式的认识比较薄弱,可以参考**高等代数**教材学习"多项式"章节的相关内容
- wikipedia多项式相关主题:
  - [多项式  (wikipedia.org)](https://zh.wikipedia.org/wiki/多項式#多项式乘法)
  - [Polynomial - Wikipedia](https://en.wikipedia.org/wiki/Polynomial)



