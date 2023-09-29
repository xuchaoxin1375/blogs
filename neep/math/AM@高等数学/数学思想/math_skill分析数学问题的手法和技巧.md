[toc]

# 数学表达式&等式方程的变形&组合操作技巧/手段积累

## 分式

- 分子分母同时乘以&除以同一个表达式

  - 分子有理化
  - 分母有理化

- 分式拆分(因子重组)


## 方程(等式)

### 方程

数学中，**方程**（equation）可以简单的理解为含有[未知数](https://zh.wikipedia.org/wiki/未知数)的[等式](https://zh.wikipedia.org/wiki/等式)，

即含有一个以上的未知数并结合等号的[数学公式](https://zh.wikipedia.org/wiki/数学公式)（formula）

### 等式

- 在[数学](https://zh.wikipedia.org/wiki/數學)的领域中，若两个数学对象在各个方面都相同，则称他们是**相等的**。这就定义了一个[二元谓词](https://zh.wikipedia.org/wiki/二元谓词)**等于**，写作${\displaystyle x=y}$[当且仅当](https://zh.wikipedia.org/wiki/当且仅当)x和y相等。


- 通常意义上，**等于**是通过两个元素间的[等价关系](https://zh.wikipedia.org/wiki/等价关系)来构造的。

  - 将两个[表达式](https://zh.wikipedia.org/wiki/表達式)用等于符号连起来，就构成了**等式**，




- 注意，有些时候${\displaystyle A=B}$并不表示等式。

  - 例如，${\displaystyle T(n)=O(n^{2})}$


  - 表示在数量级${\displaystyle n^{2}}$

  - 因为这里的符号`=`不满足[当且仅当](https://zh.wikipedia.org/wiki/若且唯若)的定义，所以它不等于等于符号；

  - 实际上，${\displaystyle O(n^{2})=T(n)}$

    - 是没有意义的。请参见[大O符号](https://zh.wikipedia.org/wiki/大O符号)了解这部分内容。

### 常见手法

- 错位相减

- 等式两边同时做相同的处理
  - 1的代换(譬如
    - 三角函数:$1=sin^2x+cos^2x$
    - 幂:$(x+\sqrt{x^2+1})(-x+\sqrt{x^2+1})=1$
  - 同时乘方
  - 同时加上某一个表达式
  - 带入消元(减小变量个数)
  - 等式组加减消元
    - 譬如,函数的最值相关问题

## 一般表达式处理

> **表达式**（expression）此处是**数学表达式**（mathematical expression）的简称，
>
> - 在[数学领域](https://zh.wikipedia.org/wiki/数学领域)中是一些[符号](https://zh.wikipedia.org/wiki/符号)依据上下文的[规则](https://zh.wikipedia.org/wiki/規則)，[有限](https://zh.wikipedia.org/wiki/有限)而[定义](https://zh.wikipedia.org/wiki/定义)良好的[组合](https://zh.wikipedia.org/wiki/組合)。
> - [数学符号](https://zh.wikipedia.org/wiki/數學符號)可用于标定[常量](https://zh.wikipedia.org/wiki/常量)、[变量](https://zh.wikipedia.org/wiki/变量)、操作、函数、括号、标点符号和分组，帮助确定操作顺序以及有其它考量的[逻辑](https://zh.wikipedia.org/wiki/逻辑)[语法](https://zh.wikipedia.org/wiki/语法)。
> - 表达式随语境或不同领域学科也称：表示式、数学式、运算式（operation expression）、表式、陈式、算式；数学术语若是复合词，表达式也常简作“式”；
> - 例如：代数式（algebraic expression）、渐近式（asymptotic expression）。

- 列项相消

  - 譬如一部分的数列求和

    - $$
      \sum\limits_{i=1}^n{\frac{1}{(i)(i+1)}}
      =\sum\limits_{i=1}^n{\frac{1}{(i)}-\frac{1}{(i+1)}}
      =\sum\limits_{i=1}^n{\frac{1}{i}}
      -\sum\limits_{i=1}^{n}\frac{1}{i+1}
      \\=(\frac{1}{1}+\sum\limits_{i=2}^{n}{\frac{1}{i}})
      -(\sum\limits_{i=2}^{n}\frac{1}{i}+\frac{1}{n+1})
      \\=1-\frac{1}{1+n}
      \\
      令:\begin{cases}
      f(i)=\frac{1}{i};
      \\则g(i)=\underline{f(i+1)}=\frac{1}{i+1},可见是一个(离散)函数的向左偏移1
      \end{cases}
      $$

      

    

- 对数&指数的转化

- 换元法

- 配凑法

  - 加上一个表达式再减去相同大小的表达式

    - 例如,分离常数:(可以起到集中变量x的效果)

      - $$
        f(x)=\frac{2x-1}{x+1}=\frac{2x-1+2-2}{\frac{1}{2}(2x+2)}
        =\frac{2x+2-3}{x+1}=2+\frac{-3}{x+1}
        $$

    - 再比如导函数求导法则种的乘法求导法则的推导/证明:

      - $$
        f(x)=u(x)v(x)
        \\
        f'(x)=\lim_{\Delta x\rightarrow 0}
        {\frac{f(x+\Delta x)-f(x)}{\Delta x}}
        \\=\lim_{\Delta x\rightarrow 0}
        \frac{{u(x+\Delta x)v(x+\Delta x)-u(x)v(x)}}{\Delta x}
        \\=\lim_{\Delta x\rightarrow 0}
        \frac{{u(x+\Delta x)v(x+\Delta x)-u(x)v(x)
        +u(x)v(x+\Delta x)-u(x)v(x+\Delta x)}}
        {\Delta x}
        \\配凑\&组合
        \\
        =\lim_{\Delta x\rightarrow 0}
        \frac{[(u(x+\Delta x)-u(x))v(x+\Delta x)]
        +[u(x)(v(x+\Delta x)-v(x))]}
        {\Delta x}
        \\=\lim\limits{\Delta x\rightarrow 0}
        \left
        \{
            {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)
            +u(x)\cdot \frac{(v(x+\Delta x)-v(x))}{\Delta x}}
        \right
        \}
        \\=\lim_{\Delta x\rightarrow0}
        {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
        +\lim_{\Delta x\rightarrow0}u(x)\cdot \frac{(v(x+\Delta x)-v(x))}{\Delta x}
        \\=\lim_{\Delta x\rightarrow0}
        {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\lim_{\Delta x\rightarrow0} v(x+\Delta x)}
        \\
        +\lim_{\Delta x\rightarrow0}u(x)\lim_{\Delta x\rightarrow0} \frac{(v(x+\Delta x)-v(x))}{\Delta x}
        \\=u'(x)v(x)+u(x)v'(x)
        $$

        

  - 拆项相消

  - 方程组成组处理(经常是相加/减)法

  - > 很多和1有关
    >
    > 




### 直观的例子

- 这里的`元`可能是指复杂的式子(作为整体)
  - ![1643515659382](https://img-blog.csdnimg.cn/img_convert/f0d463ef947386628dff065f8882f722.png)



## 构造法(通项公式/消除递推)

- 在数列/递推公式推导通项公式中用的很多

- [由数列递推公式求通项十大模型 ](https://zhuanlan.zhihu.com/p/401413192?utm_id=0)

### 基本的递推模型

- 假设我们已经知道的两个经典知递推求通项模型

  - $a(n+1)=q\cdot a(n)$

    - $a(n)=a(1)\cdot q^{n-1}$

    - $特别的,当a(1)=q的时候,a(n)=q^n\bigstar$

    - 背后的精髓在于累加消项

    - $a(n)=S(n)-S(n-1),使得前n项和能够过渡到通项公式$

    - 可以类似的推广

      - $f(a(n+1))=q\cdot f(a(n))$ 

        - 比如:(下面提到的x,y都表示数列{$a(n)$}或(离散)函数a(n)的一项)

          - $f(x)=x+\lambda$

            - $a(n+1)+\lambda=q\cdot (a(n)+\lambda)$
            - $a(n+1)+\lambda(n+1)+\phi=q(a(n)+\lambda n+\phi)$

          - $f(x,y)=x+\lambda y$

            - $a(n+1)+\lambda a(n)=q(a(n)+\lambda a(n-1))$
            - $a(n+1)+\lambda a(n)+\phi=q(a(n)+\lambda a(n-1)+\phi)$
            - $a(n+1)+\lambda a(n)+\phi=q(a(n)+\lambda a(n-1)+\phi)$

          - 对于给定的一个递推关系式,尝试上面的基础模型或者推广模型,在系数比较对应,如果能够计算出

            - $\lambda 或者 q,那么这个模型有望转换为等比模型$

            

          

  - $a(n+1)=d+a(n)$

    - $a(n)=a(1)+(n-1)d$
    - $特别的,当a(1)=d的时候,a(n)=nd$
      - 主要利用累乘消项
      - $a(n)=\frac{S(n)}{S(n-1)}$
    - 可以做的推广形式,比如:
      - $f(a(n+1))=d+f(a(n))$

  - 作为一个基本模型集,可以随着经验的增加扩充这个集合,就像一个工具箱的版本迭代升级一样

  - **<u>目标:希望求解出,a(n)的不含a(n)的非递归表达式(消除递归(递推))</u>**

### 类型抽象

- $a(n+1)=g(a(n+p)_i)$
  - 大多可以通过方程两边
    - 同乘法变形
    - 同加法变形
    - 变形方向网下面的几个一般形式上靠近
  - $a(n+1)=g(a(n+1))$
  - $F(n+1)=Q\cdot F(n)$
    - 把g中的n相关式子集中到F(n)中
  - $F(n+1)=D+\cdot F(n)$

### Fibonacci Numbers斐波那契数列通项公式

- 试图有上述两个基本模型来解决各种变体,包括[斐波那契数列](https://zh.wikipedia.org/wiki/%E6%96%90%E6%B3%A2%E9%82%A3%E5%A5%91%E6%95%B0#%E5%88%9D%E7%AD%89%E4%BB%A3%E6%95%B8%E8%A7%A3%E6%B3%95)的通项公式的求解
  - ![image-20221005163855853](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20221005163855853.png)
  - ![image-20221005163908612](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20221005163908612.png)

#### res

- ![image-20221005163921307](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20221005163921307.png)

### $a(n+1)=Aa(n)+B$

- $$
  a(n+1)=Aa(n)+B
  \\a(n+1)+\lambda=u(a(n)+\lambda)
  \\a(n+1)=-\lambda+u\cdot a(n)+u\lambda=u\cdot a(n)+\lambda(u-1)
  \\\begin{cases}
  u=A
  \\\lambda(u-1)=B
  \end{cases}
  \\即\lambda=\frac{B}{A-1}
  $$

  
  $$
  或者
  \\a(n+1)+\lambda=Aa(n)+B+\lambda
  \\a(n+1)=Aa(n)+B
  =A(a(n)+\frac{B+\lambda}{A})
  \\从而,如果\lambda=\frac{B+\lambda}{A}的话(即\lambda=\frac{B}{A-1}),
  $$
  
  $$
  \\就得到了等比递推模型:q=A,b(n)=Aa(n)+\lambda
  \\b(n)=b(1)q^{n-1}
  \\Aa(n)+\lambda=(Aa(1)+\lambda)A^{n-1}
  \\
  \begin{cases}
  a(n)=\frac{(Aa(1)+\lambda)A^{n-1}-\lambda}{A}
  \\\lambda=\frac{B}{A-1}
  \end{cases}
  $$
  



### $a(n+1)=Aa(n)+B\cdot C^n(C\neq 0)$

- $$
  a(n+1)=Aa(n)+B\cdot C^n(C\neq 0)
  \\同乘以\frac{1}{A^{n+1}}
  \\\frac{a(n+1)}{A^{n+1}}=\frac{a(n)}{A^n}+\frac{B}{A}\cdot\frac{C^{n}}{A^{n}}
  \\记K(n)=\frac{C^{n}}{A^{n}}=(\frac{C}{A})^n=\frac{C}{A}\cdot(\frac{C}{A})^{n-1}
  \\记k=\frac{A}{C}
  \\b(n)=\frac{a(n)}{A^n}
  \\则a(n)=b(n)\cdot A^n,可见只需要求解出b(n)的去递推表达式即可
  \\由于K(n)不是常数,不好直接套用等差数列模型,
  \\但是却可以使用相同更加底层的累加法来处理
  \\b(n+1)=b(n)+\frac{B}{A}K(n)
  \\即b(n)=b(n-1)+K(n-1)
  $$

  
  $$
  \\记S(n)=\sum\limits_{i=1}^{n}b(n)
  \\S(n)-b(1)=S(n-1)+\sum\limits_{i=1}^{n-1}K(n)
  \\当A\neq C(k\neq1)时,
  \sum\limits_{i=1}^{n-1}K(n)=\frac{k(k^{n-1}-1)}{k-1}
  \\
  b(n)=b(1)+\frac{B}{A}\frac{k(k^{n-1}-1)}{k-1}
  $$
  
  $$
  或者对a(n+1)=Aa(n)+B\cdot C^n(C\neq 0)
  \\同乘以\frac{1}{C^{n+1}}
  \\\frac{a(n+1)}{C^{n+1}}=\frac{A}{C}\frac{a(n)}{C^n}+\frac{B}{C}
  \\并记c(n)=\frac{a(n)}{C^n}
  \\转化为类型:c(n+1)=Ac(n)+B
  $$
  
  $$
  \\特别的,当C=A,即k=1时:K(n)=1,\sum\limits_{i=1}^{n-1}K(n)=n-1
  \\\frac{a(n+1)}{A^{n+1}}=\frac{a(n)}{A^n}+\frac{B}{A}
  \\b(n+1)=b(n)+\frac{B}{A},
  \\这得到了形如等差递推模型的递推式子
  b(n)=b(1)+\frac{B}{A}(n-1)
  $$
  

## 双参数构造

#### $a(n+1)=Aa(n)+Ba(n-1)$

- $$
  a(n+1)=Aa(n)+Ba(n-1)
  \\这种递推形式等式两边不协调,因此,我们考虑为左边配凑成形如右边的式子
  \\f(n)=f(a(n+1),a(n))\sim f(n-1)=f(a(n),a(n-1))
  \\按照习惯,优先让等式左边LHS的系数简单一些
  \\a(n+1)+\lambda a(n)=u(a(n)+\lambda a(n-1))\bigstar
  \\如果可以求解出\lambda,u,那么b(n)=a(n+1)+\lambda a(n)将是一个等比数列
  \\公比为u,首项b(1)=a(2)+\lambda a(1)
  \\为了比较系数能够方便地进行,我们展开并整理上面的"试探针"
  \\a(n+1)=a(n)\cdot (u-\lambda)+u\lambda\cdot a(n-1)
  \\\begin{cases}
  A=u-\lambda
  \\B=u\lambda
  \end{cases}
  \\求解上面的二元二次方程(可以化为一元二次方程:B=(A+\lambda)\lambda,
  \\先求出\lambda,再求出u=A+\lambda
  $$

  

  
  $$
  \\现在假设\lambda和u都已经求解出来
  \\我们记b(n)=a(n+1)+\lambda a(n),其公比为u,首项b(1)=a(2)+\lambda a(1)
  \\b(n)=b(1)\cdot u^{n-1},
  \\b(n)=(a(2)+\lambda a(1))\cdot u^{n-1}
  $$

##### 接轨Fibonacci

$$
特别的,当A=B=1,且a(2)=a(1)=1的是Fibonacci数列的递推公式
\\\begin{cases}
1=u-\lambda即,\lambda+1=u
\\1=u\lambda
\end{cases}
\\此时B=(1+\lambda)\lambda=1
\\x^2+x-1=0
\\(x+\frac{1}{2})^2=1+\frac{1}{4}
\\x+\frac{1}{2}=\pm\frac{1}{2}\sqrt5
\\\lambda=\frac{\pm\sqrt{5}-1}{2}
\\u=1+\lambda=\frac{1\pm\sqrt{5}}{2}
\\如果取\lambda>0
\\ \lambda=\frac{\sqrt{5}-1}{2};u=\frac{1+\sqrt{5}}{2}
\\
a(n+1)=\frac{\sqrt{5}-1}{2}a(n)+\frac{1+\sqrt{5}}{2}
\\
\\b(n)=a(n+1)+\lambda a(n)
\\b(n+1)=b(1)\cdot u^{n-1}=(1+\lambda)\cdot u^{n-1}=u\cdot u^{n-1}=u^n
\\即b(n)=u^n
\\u^{n}=a(n+1)+\lambda a(n)\bigstar
\\a(n+1)=-\lambda a(n)+u^n
\\进而转为类型a(n+1)=Aa(n)+B\cdot C^n
\\
$$


$$
对等式两边同乘以\frac{1}{u^n}
\\\frac{a(n+1)}{u^{n+1}}=\frac{-\lambda}{u}\frac{a(n)}{u^n}+\frac{1}{u}
\\记c(n)=\frac{a(n)}{u^{n}}
\\c(n+1)=\frac{-\lambda}{u}c(n)+\frac{1}{u}
\\问题类型回到a(n+1)=Aa(n)+B:
\\c(n+1)=\frac{-\lambda}{u}c(n)+\frac{1}{u}
\\构造:c(n+1)+p=q(c(n+1)+p)
\\
\begin{cases}
p=\frac{\frac{1}{u}}{\frac{-\lambda}{u}-1}=\frac{-1}{\lambda+u}
\\q=\frac{-\lambda}{u}
\\\lambda=\frac{\sqrt{5}-1}{2}
\\u=\frac{1+\sqrt{5}}{2}
\end{cases}
\\设d(n)=c(n)+p=\frac{a(n)}{u^n}+p
\\d(n)=d(1)\cdot q^{n-1}=(\frac{1}{u}+p)(\frac{-\lambda}{u})^{n-1}
\\a(n)=u^n c(n)=u^n (d(n)-p)
$$


#### $a(n+1)=Aa(n)+Ba(n-1)+C$

- $$
  \\尝试消去常数C,将问题转换为a(n+1)=Aa(n)+Ba(n-1)类型
  \\
  a(n+1)=Aa(n)+Ba(n-1)+C
  \\a(n+2)=Aa(n+1)+Ba(n)+C
  \\a(n+2)-a(n+1)=A(a(n+1)-a(n))+B(a(n)-a(n-1))
  \\记b(n)=a(n+1)-a(n)
  \\b(n+1)=Ab(n)-Bb(n-1)
  $$

  













