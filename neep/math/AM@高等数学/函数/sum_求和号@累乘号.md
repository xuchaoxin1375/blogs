[toc]

## abstract

- 求和号(连加号)的性质$\sum$

## 求和符号

- 例:$\sum _{i=m}^{n}a_{i}$=$a_{m}+a_{m+1}+a_{m+2}+\cdots +a_{n-1}+a_{n}$

- where *i* is the **index of summation**;
-  *$a_i$* is an indexed variable representing each term of the sum; 
- *m* is the **lower bound of summation**, and
- *n* is the **upper bound of summation**.
-  The "*i* = *m*" under the summation symbol means that the index *i* starts out equal to *m*.
-  The index, *i*, is <u>incremented by one for each successive term</u>, stopping when *i* = *n*. 

### 读法

- This is read as "sum of *$a_i$*, from *i* = *m* to *n*".
- 从$i=m到n$对$a_i$进行累加求和



## 求和号的性质$\sum$🎈

- 联系求和式$\sum\limits_{i=p}^{n}$以及它的展开$a_p+a_{p+1}+\cdots+a_n$是求和号的一些性质的源泉

- $$
  \sum\limits_{i=p}^{n}f(i)=\sum\limits_{i=n+q}^{n+q}f(i-q)=f(p)+f(p+1)+\cdots+f(n)
  \\(或者:\sum\limits_{i=p}^{n}f(i)=\sum\limits_{i=p-q}^{n-q}f(i+q))
  $$

  

  - 上面的公式可以用来改造求和公式的形式,将一个连续的求和式分为若干个片段(通常是2个)
  - 例如:$下面的例子中f(j)=j\cdot2^{j-1};那么f(j+1)=(j+1)\cdot2^{j}$
    - 新的形式可能会更加有利于推进演算
    - 例:下面的推导以错位相减法的角度来计算出t的关于h的公式(消去求和号)

- 下面的推导过程试图将求和式t的下界和2t的下界对齐

  - 为了统一为同一组下界和上界,可以将不齐(不一致)的上界中多出来的项从求和范围剥离出来,
    使得求和区间内的项数一致
  - 并且适当的利用上面介绍的公式,将求和区间长度一致但没有对齐的求和进行对齐得到各项齐次,求和号上下界一致的局面,方便求和式合并)

$$
\\
t=\sum\limits_{j=1}^{h}j\cdot 2^{j-1}
=\sum\limits_{j=1-1=0}^{h-1}(j+1)\cdot 2^{j-1+1}
=\sum\limits_{j=0}^{h-1}(j+1)\cdot 2^{j}
\\=\sum\limits_{j=0}^{h-1}j\cdot 2^{j}+\sum\limits_{j=0}^{h-1}1\cdot 2^{j}
\\=0+\sum\limits_{j=1}^{h-1}j\cdot2^j+\frac{1(1-2^h)}{1-2}
\\=(\sum\limits_{j=1}^{h-1}j\cdot2^j)+(2^h-1)
\\对a_1=0,前n项为q=2的等比数列求和
\\即有等式:t=\sum\limits_{j=1}^{h}j\cdot 2^{j-1}
=(\sum\limits_{j=1}^{h-1}j\cdot2^j)+(2^h-1)
$$


$$
\\2t=\sum\limits_{j=1}^{h}j\times 2^{j}
\xlongequal{前(h-1)项之和+第h项}=(\sum\limits_{j=1}^{h-1}j\cdot 2^j)+h\cdot 2^h
\\
观察到t=2t-t=h\cdot2^h-2^h+1=(h-1)2^h+1
$$


### 展开重组法计算求和式

- 某些时候,我们掌握了某类问题的求解方法

  - 但是一些组合让具有类似本质的问题然人觉得很陌生,或者亲切中带有陌生感

  - 如果我们能够化开问题,换原问题的本质,或许我们就可以用已有的方法来求解这个开始全新的问题

  - 比如说,$t=\sum\limits_{j=1}^{h}j\times 2^{j-1}计算,用仅含有h的表达式表示出来$

    - 出来后面提到的错位相减法

    - 也可以展开上面的求和式,进行重组表达式

    - $t=1\cdot2^0+2\cdot2^1+3\cdot2^2+\cdots+h\cdot2^{h-1}$

      - $$
        \\
        \begin{aligned}
        t&=2^0+(2^1+2^1)+(2^2+2^2+2^2)+\cdots(\underset{h个}{2^{h-1}+2^{h-1}+\cdots2^{h-1}})\\
        	&\begin{aligned}
            \\=2^0+2^1+2^2+\cdots+2^{h-1}&
            \\+2^1+2^2+\cdots+2^{h-1}&
            \\+2^2+\cdots+2^{h-1}&
            \\+\vdots&
            \\+2^{h-2}+2^{h-1}&
            \\+2^{h-1}&
            \end{aligned}
        \end{aligned}
        \\
        \\问题被转换为多个等比数列的求和问题
        $$

  - $$
    \begin{aligned}
        \\2^0+2^1+2^2+\cdots+2^{h-1}&=\sum\limits_{i=0}^{h-1}2^i
        \\+2^1+2^2+\cdots+2^{h-1}&=2\sum\limits_{i=0}^{h-2}2^i
        \\+2^2+\cdots+2^{h-1}&=2^2\sum\limits_{i=0}^{h-3}2^i
        \\+\vdots&
        \\+2^{h-2}+2^{h-1}&=2^{h-2}\sum\limits_{i=0}^{1}2^i
        \\+2^{h-1}&=2^{h-1}\sum\limits_{i=0}^{0}2^i
    \end{aligned}
    $$

  - 将上面各式子记为$a_i$,并且$s(h)=\sum\limits_{i=0}^{h}2^i$ $\xlongequal{h+1项}$  $\frac{1(1-2^{h+1})}{1-2}=2^{h+1}-1$
    $$
    a_i=2^{i-1}s(h-i)=2^{i-1}(2^{h-i+1}-1)=2^h-2^{i-1}
        \\
        \\a_1=2^h-2^0
        \\a_2=2^h-2^1
        \\a_3=2^h-2^2
        \\ \vdots
        \\a_{h-1}=2^h-2^{h-2}
        \\a_h=2^h-2^{h-1}
    $$

  - 所以$t=\sum\limits_{i=1}^{h}a_i$=$h\cdot 2^h-(\sum\limits_{i=0}^{h-1}2^i)$=$h\cdot 2^h-(2^h-1)=(h-1)2^h+1$



## 累加式乘法

### 乘法对加法的分配律在求和号中表示

- $f\cdot\sum{g}=\sum{f\cdot g}$
  
- Note:

  - $A=\sum_{i}{p}q(i)$
  - $B=q(i)\sum_{i}p$
    - 其中p是任意表达式,$q(i)$表示带有求和指标$i$的表达式因子,这种情况下不像分配律那样可以提取公共因子,因为不同的$i$的取值(比如$i=1,2,\cdots$)下的$q(i)$往往是不相等的,即($h(i)\neq{h(j)},i\neq{j}$)
    - 表达式B的形式式不是一种正确的写法,除非$q(i),i\in{\mathbb{Z}}$始终取同一个值k,那么可以写作$B=k\sum{p}$
  
- 在程序设计中,相当于一个二重循环:
  $$
  (\sum\limits_{i=1}^{n}x_i)(\sum\limits_{i=j}^{m}y_j)
  =\sum\limits_{i=1}^{n}(x_i\sum\limits_{i=j}^{m}y_j)
  =\sum\limits_{i=1}^{n}(\sum\limits_{i=j}^{m}x_iy_j)
  =\sum\limits_{i=1}^{n}\sum\limits_{i=j}^{m}x_iy_j
  $$

  - ```c
    s=0
    int x[n],y[m];
    for(int i=1;i<=n;i++){
        for(int j=1:j<=m;j++){
        	s+=(x[i]*y[j]);
        }
    }
    ```

### 更一般的情况

- $\sum{f_1}\sum{f_2}\cdots\sum{f_n}$=$\sum\sum\cdots\sum{f_1f_2\cdots{f_n}}$
  
- $\prod_{i=1}^{n}{(\sum{f_i})}$=$\sum\sum\cdots\sum(\prod_{i=1}^{n}f_i)$
  
  

## 求和式包含的项数



- $\prod_{k=d}^{u}{(\cdot)}$;$\sum_{k=d}^{u}{(\cdot)}$的总项数$N$为上界$u$与下界$d$之差+1,即:$N=d-u+1$

  

## 求和区间的等值变化🎈

- 此处主要指求和区间的等值变化

- 联系求和式$\sum\limits_{i=p}^{n}$以及它的展开$a_p+a_{p+1}+\cdots+a_n$是求和号的一些性质的源泉

- $$
  \sum\limits_{i=p}^{n}f(i)=\sum\limits_{i=n+q}^{n+q}f(i-q)=f(p)+f(p+1)+\cdots+f(n)
  \\(或者:\sum\limits_{i=p}^{n}f(i)=\sum\limits_{i=p-q}^{n-q}f(i+q))
  $$

  - 上面的公式可以用来改造求和公式的形式,将一个连续的求和式分为若干个片段(通常是2个)
  - 例如:$下面的例子中f(j)=j\cdot2^{j-1};那么f(j+1)=(j+1)\cdot2^{j}$
    - 新的形式可能会更加有利于推进演算
    - 例:下面的推导以错位相减法的角度来计算出t的关于h的公式(消去求和号)





## 求和恒等式(小结)🎈

- [Summation - Wikipedia](https://en.wikipedia.org/wiki/Summation)
- ${\displaystyle \sum _{n=s}^{t}C\cdot f(n)=C\cdot \sum _{n=s}^{t}f(n)\quad }$🎈
  - (distributivity)
- ${\displaystyle \sum _{n=s}^{t}f(n)\pm \sum _{n=s}^{t}g(n)=\sum _{n=s}^{t}\left(f(n)\pm g(n)\right)\quad }$
  -  (commutativity and associativity)[3]
- ${\displaystyle \sum _{n=s}^{t}f(n)=\sum _{n=s+p}^{t+p}f(n-p)\quad }$🎈
  -  (index shift)
- ${\displaystyle \sum _{n\in B}f(n)=\sum _{m\in A}f(\sigma (m)),\quad }$
  - for a bijection σ from a finite set A onto a set B (index change); this generalizes the preceding formula.

- ${\displaystyle \sum _{n=s}^{t}f(n)=\sum _{n=s}^{j}f(n)+\sum _{n=j+1}^{t}f(n)\quad }$ 
  - (splitting a sum, using associativity)
- ${\displaystyle \sum _{n=a}^{b}f(n)=\sum _{n=0}^{b}f(n)-\sum _{n=0}^{a-1}f(n)\quad }$🎈 
  - (a variant of the preceding formula)
- ${\displaystyle \sum _{n=s}^{t}f(n)=\sum _{n=0}^{t-s}f(t-n)\quad }=\sum\limits_{n=0}^{t-s}f(n+t)$🎈
  -  (the sum from the first term up to the last is equal to the sum from the last down to the first)
  - ${\displaystyle \sum _{n=0}^{t}f(n)=\sum _{n=0}^{t}f(t-n)\quad }$ (a particular case of the formula above)
- ${\displaystyle \sum _{i=k_{0}}^{k_{1}}\sum _{j=l_{0}}^{l_{1}}a_{i,j}=\sum _{j=l_{0}}^{l_{1}}\sum _{i=k_{0}}^{k_{1}}a_{i,j}\quad }$ (commutativity and associativity, again)交换性🎈
  - 例如矩阵中的求和所有元素,逐行求和和逐列求和结果一样
- ${\displaystyle \sum _{k\leq j\leq i\leq n}a_{i,j}=\sum _{i=k}^{n}\sum _{j=k}^{i}a_{i,j}=\sum _{j=k}^{n}\sum _{i=j}^{n}a_{i,j}=\sum _{j=0}^{n-k}\sum _{i=k}^{n-j}a_{i+j,i}\quad }$ 🎈
  - (another application of commutativity and associativity)
- ${\displaystyle \sum _{n=2s}^{2t+1}f(n)=\sum _{n=s}^{t}f(2n)+\sum _{n=s}^{t}f(2n+1)\quad }$ 🎈
  - (splitting a sum into its odd and even parts, for even indexes)
- ${\displaystyle \sum _{n=2s+1}^{2t}f(n)=\sum _{n=s+1}^{t}f(2n)+\sum _{n=s+1}^{t}f(2n-1)\quad }$ 
  - (splitting a sum into its odd and even parts, for odd indexes)
- ${\displaystyle \left(\sum _{i=0}^{n}a_{i}\right)\left(\sum _{j=0}^{n}b_{j}\right)=\sum _{i=0}^{n}\sum _{j=0}^{n}a_{i}b_{j}\quad =\sum _{i=0}^{n}\left(\sum _{j=0}^{n}a_{i}b_{j}\right)}$ (distributivity)🎈
- ${\displaystyle \sum _{i=s}^{m}\sum _{j=t}^{n}{a_{i}}{c_{j}}=\left(\sum _{i=s}^{m}a_{i}\right)\left(\sum _{j=t}^{n}c_{j}\right)\quad }$ (distributivity allows factorization)因式分解🎈
- ${\displaystyle \sum _{n=s}^{t}\log _{b}f(n)=\log _{b}\prod _{n=s}^{t}f(n)\quad }$ 
  - (the logarithm of a product is the sum of the logarithms of the factors)
- ${\displaystyle C^{\sum \limits _{n=s}^{t}f(n)}=\prod _{n=s}^{t}C^{f(n)}\quad }$
  -  (the exponential of a sum is the product of the exponential of the summands)

