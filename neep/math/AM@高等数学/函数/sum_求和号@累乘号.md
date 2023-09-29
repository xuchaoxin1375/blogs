[toc]

# 求和号的性质$\sum$@累乘号$\prod$

## 求和符号

- 例

  - $$
    {\displaystyle \sum _{i\mathop {=} m}^{n}a_{i}=a_{m}+a_{m+1}+a_{m+2}+\cdots +a_{n-1}+a_{n}}
    $$

- where *i* is the **index of summation**;
-  *$a_i$* is an indexed variable representing each term of the sum; 
- *m* is the **lower bound of summation**, and
- *n* is the **upper bound of summation**.
-  The "*i* = *m*" under the summation symbol means that the index *i* starts out equal to *m*.
-  The index, *i*, is <u>incremented by one for each successive term</u>, stopping when *i* = *n*. 

### 读法

- This is read as "sum of *$a_i$*, from *i* = *m* to *n*".
- 从$i=m到n$对$a_i$进行累加求和

## 累加多项式乘法

### 乘法对加法的分配律在求和号中表示

- $$
  f\cdot\sum{g}=\sum{f\cdot g}
  $$

- Note:

  - $$
    A=\sum_{i}{p}q(i)
    \\
    B=q(i)\sum_{i}p
    $$

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

- $$
  \sum{f_1}\sum{f_2}\cdots\sum{f_n}=\sum\sum\cdots\sum{f_1f_2\cdots{f_n}}
  \\
  \prod_{i=1}^{n}{(\sum{f_i})}=\sum\sum\cdots\sum(\prod_{i=1}^{n}f_i)
  $$

  

## 求和式包含的项数

- 关于(连续逐项的)累加和累乘的总项数

  - $$
    \prod_{k=d}^{k=u}{exp}
    \\
    \sum_{k=d}^{k=u}{exp}
    \\总项数为上界与下界之差+1,即:
    \\items=d-u+1
    \\某些情况下,我们首先知道的是items,以及d\&u中的一个,就可以利用上面等式进行计算
    \\注意,无论表达式exp是怎样的,上述等式总是成立
    $$

    

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

## 排列序列累积@二重循环

#### 范德蒙行列式的展开

- $$
  |A_{V}|=\prod\limits_{1\leqslant{j}<{i}\leqslant{n}}(x_i-x_j)
  =\prod\limits_{i=2}(\prod\limits_{j=1}(x_i-x_j))
  $$

  


### 例:错位相减法

- 等差乘以等比的数列求和可以利用求导法进行求解,但是这里暂不提及
  - 可以参考:[math_等差数列/等比数列求和推导&等幂和差推导/两个n次方数之差与等价无穷小实例/求和符号的性质和应用_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/125417321)

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

#### 例:无穷级数

- $$
  \sum_{k=1}^{+\infin}
  \frac{\lambda^{k-1}}{(k-1)!}
  =\sum_{k=0}^{+\infin}
  \frac{\lambda^{k}}{k!}
  =e^\lambda
  $$

  

- $$
  S=\sum\limits_{k=0}^{+\infin}
  kq^{k-1}
  \\
  qS=\sum\limits_{k=0}^{+\infin}
  kq^{k}
  \\\\
  S=0+\sum\limits_{k=1}^{+\infin}
  kq^{k-1}
  \\向qS累加通项看起,将q^{k-1}提高到q^k
  \\为了等值地做到这一点,需要同时变动累加求和号的上下限
  \\此处上界恰是无穷大(+\infin)所以不用管(加上一个有穷数不改变无穷性)
  \\变动下界,累加通项变量k+1,那么界就起点/终点-1
  \\
  \sum\limits_{k=1}^{+\infin}
  kq^{k-1}=\sum\limits_{k=0}^{+\infin}
  (k+1)q^{(k-1)+1}=\sum\limits_{k=0}^{+\infin}
  (k+1)q^{k}
  \\从而:S=\sum\limits_{k=0}^{+\infin}
  (k+1)q^{k}
  \\这与qS具有一致的累加下界和上界,并且第k项的次数是一致的
  \\S-qS=\sum\limits_{k=0}^{+\infin}
  (k+1)q^{k}-\sum\limits_{k=0}^{+\infin}
  kq^{k}=\sum\limits_{k=0}^{+\infin}
  1\cdot q^{k}
  \xlongequal{几何(等比)级数}=\frac{1}{1-q}
  \\(1-q)S=\frac{1}{1-q}
  \\S=\frac{1}{(1-q)^2}
  $$

  

### 例:possion分布的期望和均值的推导

- $E(X)\sim{\lambda};D(X)\sim{\lambda}$
  - 假设期望已知,推导方差

  - $$
    E(X^2)=\sum\limits_{k=0}^{+\infin}
    k^2\cdot\frac{\lambda^{k}}{k!}e^{-\lambda}
    \\=e^{-\lambda}\sum\limits_{k=0}^{+\infin}k^2\cdot\frac{\lambda^{k}}{k!}
    \\\\
    \sum\limits_{k=0}^{+\infin}k^2\cdot\frac{\lambda^{k}}{k!}
    =0+\sum\limits_{k=1}^{+\infin}k^2\cdot\frac{\lambda^{k}}{k!}
    \xlongequal{k\geqslant1}\sum\limits_{k=0}^{+\infin}k^2\cdot\frac{\lambda^{k}}{k!}
    \\=\sum\limits_{k=1}^{+\infin}k^1\cdot\frac{\lambda^{k}}{(k-1)!}
    \\=\sum\limits_{k=1}^{+\infin}((k-1)+1)\cdot\frac{\lambda^{k}}{(k-1)!}
    \\=\sum\limits_{k=1}^{+\infin}(k-1)\cdot\frac{\lambda^{k}}{(k-1)!}
    +
    \sum\limits_{k=1}^{+\infin}1\cdot\frac{\lambda^{k}}{(k-1)!}
    \\=0+\sum\limits_{k=2}^{+\infin}(k-1)\cdot\frac{\lambda^{k}}{(k-1)!}
    +\sum\limits_{k=0}^{+\infin}\frac{\lambda^{k+1}}{(k)!}
    \\
    \xlongequal{k-1\geqslant{1}}
    \sum\limits_{k=2}^{+\infin}\frac{\lambda^{k}}{(k-2)!}
    +\lambda\sum\limits_{k=0}^{+\infin}\frac{\lambda^{k}}{(k)!}
    \\=\sum\limits_{k=0}^{+\infin}\frac{\lambda^{k+2}}{(k)!}
    +\lambda{e^\lambda}
    \\=\lambda^2\sum\limits_{k=0}^{+\infin}\frac{\lambda^{k}}{(k)!}
    +\lambda{e^\lambda}
    \\=\lambda^2{e^\lambda}+\lambda{e^\lambda}
    \\\\
    所以E(X^2)=e^{-\lambda}(\lambda^2{e^\lambda}+\lambda{e^\lambda})
    =\lambda^2+\lambda
    $$

### 子序列记号法

- 主要包括几个方面:
  - 原序列的情况:长度
    - n个元素的序列长度设为n
  - 子序列的抽取方式
  - 满足限定条件的(取法互不相同的)子序列的个数
  - 🎢边界情况
    - 子序列长度为1
    - 子序列长度为n

$$
求和号下面的1\leqslant i_1<\cdots<i_k\leqslant n表示对序列\set{1,\cdots,n}抽取出k个元素
\\构成长度为k的子序列
\\这些个元素的大小关系和区分正如式子:1\leqslant i_1<\cdots<i_k\leqslant n
所表示的那样
\\抽取的这些序列在原序列中未必是相邻的
\\满足条件:1\leqslant i_1<\cdots<i_k\leqslant n的不同的序列有\binom{n}{k}个
\\
\\拓展:如果取消掉大小关系的限制,要区分顺序,那么取法可达到排列数A_n^k中
$$

- 
  $$
  \frac{\partial{z}}{\partial{x_i}}=f'_y(x_1,\cdots,x_n),i\in\{1,2,\cdots,n\}
  \\
  \frac{\partial^k{z}}{H(\theta)}
  =f^{(k)}_{X(\theta)}(x_1,\cdots,x_n),i\in\{1,2,\cdots,n\}
  \\\theta=i_1i_2\cdots{i_n};
  \\\theta表示对序列的1,2,\cdots,{n}选出至少一个元素进行任意重新排列
  \\不同的\theta有n^k种(注意,序列中的元素可以重复,所以可能的情况数是方幂级别)
  \\这个更行列式那里的定义有所不同
  \\H(\theta)=H\partial{x}(\theta)=\partial{x}_{i_1}\partial{x}_{i_2}\cdots{\partial{x}_{i_k}}
  \\X(\theta)=x_{i_1}x_{i_2}\cdots{x_{i_k}}
  $$

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

