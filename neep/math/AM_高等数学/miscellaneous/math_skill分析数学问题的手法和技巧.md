@[toc]
# 数学表达式&等式方程的变形&组合操作技巧/手段积累

## 分式

- 分子分母同时乘以&除以同一个表达式

  - 分子有理化
  - 分母有理化

- 分式拆分(因子重组)

  

  

## 方程(等式)

### 方程

> 数学中，**方程**（equation）可以简单的理解为含有[未知数](https://zh.wikipedia.org/wiki/未知数)的[等式](https://zh.wikipedia.org/wiki/等式)，
>
> - 即含有一个以上的未知数并结合等号的[数学公式](https://zh.wikipedia.org/wiki/数学公式)（formula）

### 等式

> 在[数学](https://zh.wikipedia.org/wiki/數學)的领域中，若两个数学对象在各个方面都相同，则称他们是**相等的**。这就定义了一个[二元谓词](https://zh.wikipedia.org/wiki/二元谓词)**等于**，写作
> $$
> {\displaystyle x=y}
> $$
> [当且仅当](https://zh.wikipedia.org/wiki/当且仅当)x和y相等。
>
> 通常意义上，等于是通过两个元素间的[等价关系](https://zh.wikipedia.org/wiki/等价关系)来构造的。
>
> 将两个[表达式](https://zh.wikipedia.org/wiki/表達式)用等于符号连起来，就构成了**等式**，
>
> 
>
> 注意，有些时候
> $$
> {\displaystyle A=B}
> $$
> 并不表示等式。
>
> 例如，
> $$
> {\displaystyle T(n)=O(n^{2})}
> $$
> 表示在数量级
> $$
> {\displaystyle n^{2}}
> $$
> 因为这里的符号`=`不满足[当且仅当](https://zh.wikipedia.org/wiki/若且唯若)的定义，所以它不等于等于符号；
>
> 实际上，
> $$
> {\displaystyle O(n^{2})=T(n)}
> $$
> 是没有意义的。请参见[大O符号](https://zh.wikipedia.org/wiki/大O符号)了解这部分内容。

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
