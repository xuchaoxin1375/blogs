[toc]



## 求和式乘法

- $$
  \begin{aligned}
  S=&\prod_{j=1}^{m}\left(\sum\limits_{k=1}^{n_j}a_{jk}\right)_{\!\!\!j}
  \\
  =&(a_{11}+a_{12}+\cdots+a_{1n_1})
  (a_{21}+a_{22}+\cdots+a_{2n_2})
  \cdots
  (a_{m1}+a_{m2}+\cdots+a_{mn_{m}})
  \end{aligned}
  $$

- 分析这个表达式,可以从以下几个方面入手

  1. S展开后具有多少项?(不做任何合并项操作和值为零的项的省略)

     - 首先,乘法对加法满足分配律关系:$a(b+c)=ab+ac$,利用该规律展开多项式之间的乘法

     - $S=(a_1+a_2)(b_1+b_2)$

       - 可以记$B=b_1+b_2$
  - $S=a_1B+a_2B=a_1(b_1+b_2)+a_2(b_1+b_2)=a_1b_1+a_1b_2+a_2b_1+a_2b_2$
       - 共有4项
     
     - $S=(a_1+\cdots+a_m)(b_1+\cdots+b_n)=(\sum_{i=1}^{m}a_i)(\sum_{i=1}^{n}b_i)$

       - 记$B=\sum_{i=1}^{n}b_i$
  - $S=(\sum_{i=1}^{m}a_i)B=\sum_{i}^{m}Ba_i$
         - 其中$Ba_i=\sum_{j=1}^{n}b_ja_i$
         - $S=\sum_i^m(\sum_{j}^{n}b_ja_i)$=$\sum_i^m\sum_{j}^{n}b_ja_i$
       - 共有$n\times{m}$项
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
         
           - $i_{k}$表示第k组求和式中的第$i_k$个元素($i_k={1,2,\cdots},n_k$)
         
       - S的项数为$\prod\limits_{j=1}^{m}n_j$

  2. 每一项由多少基本因子(即$a_{ij}$)构成,又是如何构成的?

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

## 代数学基本定理👺

- [代数基本定理  (wikipedia.org)](https://zh.wikipedia.org/zh-hans/代数基本定理)

- **代数基本定理**说明，任何一个一元复系数[多项式方程](https://zh.wikipedia.org/wiki/多项式方程)都**至少**有一个复数[根](https://zh.wikipedia.org/wiki/根_(数学))。

  - 也就是说，[复数](https://zh.wikipedia.org/wiki/複數_(數學))[域](https://zh.wikipedia.org/wiki/体_(数学))是[代数封闭](https://zh.wikipedia.org/wiki/代数封闭域)的。
  - 实数是复数的子集,因此在考虑实系数多项式方程时,定理一样适用

- 有时这个定理表述为：<u>任何一个非零的一元n次复系数多项式，都正好有n个复数根（重根视为多个根）</u>。

  - 这似乎是一个更强的命题，但实际上是“至少有一个根”的直接结果，因为不断把多项式除以它的线性因子，即可从有一个根推出有n个根。

  - 也就是说，任何一个n次多项式，都可以因式分解为n个复系数一次多项式的乘积。

- 尽管这个定理被命名为“**代数**基本定理”，但它还**没有纯粹的代数证明**(需要结合其他方法证明)

  - 许多数学家都相信这种证明不存在。
  - 另外，它<u>也不是最基本的代数定理</u>；
  - 只是因为在那个时候，代数基本上就是关于解实系数或复系数多项式方程，所以才被命名为代数基本定理。


### 补充

- **The fundamental theorem of algebra**, also known as **d'Alembert's theorem**(达朗贝尔定理),or the **d'Alembert–Gauss theorem**(达朗贝尔-高斯定理),states that every" non-constant single-variable polynomial with complex coefficients has at least one complex root".

-  This includes polynomials with real coefficients, since every real number is a complex number with its imaginary part equal to zero.

- Equivalently (by definition), the theorem states that the field of complex numbers is algebraically closed.

  The theorem is also stated as follows: every non-zero, single-variable, degree n polynomial with complex coefficients has, counted with multiplicity, exactly n complex roots. The equivalence of the two statements can be proven through the use of successive polynomial division.

- Despite its name, there is no purely algebraic proof of the theorem, since any proof must use some form of the analytic completeness of the real numbers, which is not an algebraic concept.

-  Additionally, it is not fundamental for modern algebra; its name was given at a time when algebra was synonymous with theory of equations.

- 代数基本定理，也被称为d'Alembert定理，或者d'Alembert-Gauss定理，它表明每一个非常数的单变量多项式，只要其系数为复数，就至少有一个复数根。
- 这包括了实系数的多项式，因为每一个实数都是虚部为零的复数。
- 等价地（根据定义），这个定理表明复数域是代数闭合的。
- 这个定理也可以这样表述：每一个非零的，单变量的，度为n的复系数多项式，计入重数后，恰好有n个复数根。这两种表述的等价性可以通过连续的多项式除法来证明。
- 尽管它的名字是代数基本定理，但并没有纯粹的代数证明，因为任何证明都必须使用实数的分析完备性，这不是一个代数概念。另外，对于现代代数来说，它并不是基本的；它的名字是在代数与方程理论同义的时代给出的。

- 在书《Arithmetica Philosophica》（1608年由Johann Lantzenberger在纽伦堡出版）中，Peter Roth写道，一个n次的多项式方程（实系数）可能有n个解。Albert Girard在他的书《L'invention nouvelle en l'Algèbre》（1629年出版）中断言，一个n次的多项式方程有n个解，但他并没有声明这些解必须是实数。
- 此外，他补充说，他的断言适用于"除非方程是不完全的"，他的意思是没有系数等于0。然而，当他详细解释他的意思时，很明显他实际上相信他的断言总是正确的；
- 例如，他展示了方程${\displaystyle x^{4}=4x-3,}$虽然不完全，但有四个解（计入重数）：1（两次），${\displaystyle -1+i{\sqrt {2}},}$和${\displaystyle -1-i{\sqrt {2}}.}$

- 如下面将再次提到的，根据代数基本定理，每一个非常数的**实系数多项式**都可以写成一系列**实系数的多项式的乘积**，这些多项式的次数(degree)要么是1，要么是2。
  - 然而，1702年，莱布尼茨错误地说，没有一个像$x^4 + a^4$这样的多项式（a是实数且不等于0）可以这样写。
  - 后来，尼古拉斯·伯努利对于多项式$x^4 − 4x^3 + 2x^2 + 4x + 4$也做出了同样的断言
- 然而,1742年欧拉的一封信中证明了这个多项式等于
  - ${\displaystyle \left(x^{2}-(2+\alpha )x+1+{\sqrt {7}}+\alpha \right)\left(x^{2}-(2-\alpha )x+1+{\sqrt {7}}-\alpha \right),}$
    - 其中${\displaystyle \alpha ={\sqrt {4+2{\sqrt {7}}}}.}$ 
  - 此外，欧拉指出
  - ${\displaystyle x^{4}+a^{4}=\left(x^{2}+a{\sqrt {2}}\cdot x+a^{2}\right)\left(x^{2}-a{\sqrt {2}}\cdot x+a^{2}\right).}$

### 相关证明历史

- A first attempt at proving the theorem was made by d'Alembert in 1746, but his proof was incomplete. Among other problems, it assumed implicitly a theorem (now known as Puiseux's theorem), which would not be proved until more than a century later and using the fundamental theorem of algebra. Other attempts were made by Euler (1749), de Foncenex (1759), Lagrange (1772), and Laplace (1795). These last four attempts assumed implicitly Girard's assertion; to be more precise, the existence of solutions was assumed and all that remained to be proved was that their form was a + bi for some real numbers a and b. In modern terms, Euler, de Foncenex, Lagrange, and Laplace were assuming the existence of a splitting field of the polynomial p(z).


- At the end of the 18th century, two new proofs were published which did not assume the existence of roots, but neither of which was complete. One of them, due to James Wood and mainly algebraic, was published in 1798 and it was totally ignored. Wood's proof had an algebraic gap.  The other one was published by Gauss in 1799 and it was mainly geometric, but it had a topological gap, only filled by Alexander Ostrowski in 1920, as discussed in Smale (1981). 


- The first rigorous proof was published by Argand, an amateur mathematician, in 1806 (and revisited in 1813);  it was also here that, for the first time, the fundamental theorem of algebra was stated for polynomials with complex coefficients, rather than just real coefficients. Gauss produced two other proofs in 1816 and another incomplete version of his original proof in 1849.


- The first textbook containing a proof of the theorem was Cauchy's Cours d'analyse de l'École Royale Polytechnique (1821). It contained Argand's proof, although Argand is not credited for it.


- None of the proofs mentioned so far is constructive. It was Weierstrass who raised for the first time, in the middle of the 19th century, the problem of finding a constructive proof of the fundamental theorem of algebra. He presented his solution, which amounts in modern terms to a combination of the Durand–Kerner method with the homotopy continuation principle, in 1891. Another proof of this kind was obtained by Hellmuth Kneser in 1940 and simplified by his son Martin Kneser in 1981.


- Without using countable choice, it is not possible to constructively prove the fundamental theorem of algebra for complex numbers based on the Dedekind real numbers (which are not constructively equivalent to the Cauchy real numbers without countable choice).  However, Fred Richman proved a reformulated version of the theorem that does work. 

- 对这个定理的第一次尝试证明是由d'Alembert在1746年进行的，但他的证明是不完整的。在其他问题中，它隐含地假设了一个定理（现在被称为Puiseux的定理），这个定理直到一个多世纪后才被证明，并且使用了代数基本定理。其他的尝试是由欧拉（1749年）、de Foncenex（1759年）、拉格朗日（1772年）和拉普拉斯（1795年）进行的。这最后四次尝试隐含地假设了Girard的断言；更准确地说，解的存在被假设了，剩下需要证明的只是它们的形式是a + bi，其中a和b是一些实数。用现代的术语来说，欧拉、de Foncenex、拉格朗日和拉普拉斯假设了多项式p(z)的分裂域的存在。

- 在18世纪末，两个新的证明被发表，这两个证明都没有假设根的存在，但都不完整。其中一个，由James Wood主要使用代数方法在1798年发表，但被完全忽视了。Wood的证明有一个代数上的漏洞[6]。另一个证明由高斯在1799年发表，主要使用几何方法，但它有一个拓扑上的漏洞，直到1920年由Alexander Ostrowski填补，如Smale（1981）[7]所讨论的。

- 第一个严谨的证明是由业余数学家Argand在1806年（并在1813年重新审视）[8]发表的；这也是代数基本定理首次被陈述为对复系数的多项式，而不仅仅是实系数的多项式。高斯在1816年提出了另外两个证明，并在1849年提出了他原始证明的另一个不完整版本。

  第一本包含该定理证明的教科书是柯西的《皇家理工学院分析课程》（1821年）。它包含了Argand的证明，尽管Argand并没有因此得到认可。

- 到目前为止提到的所有证明都不是构造性的。是魏尔斯特拉斯在19世纪中叶首次提出了寻找代数基本定理的构造性证明的问题。他在1891年提出了他的解决方案，这在现代术语中相当于将Durand-Kerner方法与同伦连续原理相结合。另一种这样的证明是由Hellmuth Kneser在1940年得到的，并在1981年由他的儿子Martin Kneser简化。

  如果不使用可数选择，就不可能基于Dedekind实数（没有可数选择的情况下，它们在构造上不等价于柯西实数）构造性地证明复数的代数基本定理[9]。然而，Fred Richman证明了一个改编版本的定理，这个定理是有效的[10]。

### 相关证明

- [高斯](https://zh.wikipedia.org/wiki/卡爾·弗里德里希·高斯)一生总共对这个定理给出了**四个证明**
  - 其中第一个是在他22岁时（1799年）的博士论文中给出的。
  - 高斯给出的证明既有几何的，也有函数的，还有积分的方法。
  - 高斯关于这一[命题](https://zh.wikipedia.org/wiki/命题)的证明方法是去证明其根的[存在性](https://zh.wikipedia.org/wiki/存在性)，开创了关于研究存在性命题的新途径。

### 高次方程

- 同时，高次代数方程的求解仍然是一大难题。
- [伽罗瓦理论](https://zh.wikipedia.org/wiki/伽羅瓦理論)指出，对于一般五次以及五次以上的方程，不存在一般的代数解。

## 同解的多项式方程todo

### 讨论集锦

- 一元二次方程$x^2+x+1=0\;(*)$和$x^3-1=0$的关系:

  - 由判别式$\Delta=1-4=-3<0$可知,方程$*$在实数域没有解

  - 它的复数域有解:$x=\frac{-1\pm{\sqrt{-3}}}{2}=\frac{1}{2}(-1\pm{\sqrt{3}\ i})$

  - $$
    x^2+x+1=0(x\neq{0})\Rightarrow\\
    x+1+x^{-1}=0\Rightarrow\\
    $$

  - 将上述两式相减$\Rightarrow{x^2-x^{-1}}=0\Rightarrow{x^3-1=0}\:(@)$

  - $\Rightarrow{x=1}$

- Note

  - 可以确定方程$(*)$的解一定是方程$@$的解
  - 方程$@$的解不一定都是方程$*$的解
  - 对于上面的例子,这种关系直观的理解就是从$*\to{@}$丢失了一次项

## refs

### 多项式相关内容

- 非数学专业的同学可能对多项式的认识比较薄弱,可以参考**高等代数**教材学习"多项式"章节的相关内容
- wikipedia多项式相关主题:
  - [多项式  (wikipedia.org)](https://zh.wikipedia.org/wiki/多項式#多项式乘法)
  - [Polynomial - Wikipedia](https://en.wikipedia.org/wiki/Polynomial)




