[toc]

# katex/latex_常用符号

##  ref

- [latex&katex_符号表参考/符号大全在线参考/教程(核心部分(本科/全集)离线下载/&katex语法官方文档&符号大全_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/124306099?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"124306099"%2C"source"%3A"xuchaoxin1375"})

- [How do you write derivatives in LaTeX? (physicsread.com)](https://www.physicsread.com/latex-derivatives/)

## 手写符号识别

### Unicode符号

- [Detexify LaTeX handwritten symbol recognition](https://detexify.kirelabs.org/classify.html)

### latex符号

- 手写识别符号
  - [Detexify LaTeX handwritten symbol recognition (kirelabs.org)](http://detexify.kirelabs.org/classify.html)
- 关键字搜索符号(对于点组成的符号,推荐使用关键词搜索)
  - [Detexify LaTeX symbol table (kirelabs.org)](http://detexify.kirelabs.org/symbols.html)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/7921921ad8594f5fb3a78e4e552d19f8.png)
- 字体
  - 例如搜索`F`的不同字体
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/4fb625a7da8c414d9142d0d7aeff6909.png)

##  微分$\frac{\mathrm{d}y}{\mathrm{d}x}$

###  通用办法(by fonts)

- 通常,可以使用字体来强调正体字`d`
	- $\frac{\mathrm{d}x}{\mathrm{d}y}$
	- `\frac{\mathrm{d}x}{\mathrm{d}y}`
- 可以定义宏来简写



### 高度自适应大竖线$\left.\right|_{a}^{b}$👺

- 例如:

  - ```tex
    \left.
    	\left(x\cdot{e^{-\lambda{x}}}
        -\int_{0}^{+\infin}{e^{-\lambda{x}}} \mathrm{d}(x)
        \right)
    \right|%后面的内容就是大竖线的上下界角标啦
    _{0} ^{+\infty}
    ```

    
    $$
    \left.
    	\left(x\cdot{e^{-\lambda{x}}}
        -\int_{0}^{+\infin}{e^{-\lambda{x}}} \mathrm{d}(x)
        \right)
    \right|%后面的内容就是大竖线的上下界角标啦
    _{0} ^{+\infty}
    \\
    $$
    

## 字体变体(fonts)

- google 搜索:`latex a sign looks like F`

### 🎈简写

- $\rm{d}x$
  - 但是会使得x受到\rm作用

### mathsrc

- `\mathscr{F}`:$\mathscr{F}$
- `f\xrightarrow{\mathscr{F}}\hat{f}`:$f\xrightarrow{\mathscr{F}}\hat{f}$

### mathbb (常用来表示数集)

- `\mathbb{Z}`
- `$x\in \mathbb{Z}$`
  - $x\in \mathbb{Z}$

### mathrm(正罗马体常用来表示微分dx/dy)

- `\mathrm{d}x`
- `$\frac{\mathrm{d}x}{\mathrm{d}y}$`
  - $\frac{\mathrm{d}x}{\mathrm{d}y}$

### 强制样式displaystyle

- $$
  特别是对于内联与文本内的积分号,可以使用\displaystyle{}来换源应有的样式(高度)
  \\
  \begin{cases}
  \int_{a}^{b}
  \\
  \\\sum_{i=1}
  \end{cases}
  \\
  使用\text{\\displaystyle}:
  \\
  \begin{cases}
  \displaystyle{\int_{a}^{b}}
  \\
  \\\sum_{i=1}
  \end{cases}
  $$

  - 原码:

    - ```tex
      特别是对于内联与文本内的积分号,可以使用\displaystyle{}来换源应有的样式(高度)
      \\
      \begin{cases}
      \int_{a}^{b}
      \\
      \\\sum_{i=1}
      \end{cases}
      \\
      使用\text{\\displaystyle}:
      \\
      \begin{cases}
      \displaystyle{\int_{a}^{b}}
      \\
      \\\sum_{i=1}
      \end{cases}
      ```


## 颜色

- $$
  \huge\textcolor{blue}{F=ma}
  \\
  \Huge\textcolor{green}{F=ma}
  \\
  \Huge\textcolor{red}{F=ma}
  \\\Huge\textcolor{pink}{F=ma}
  \\\Huge\textcolor{orange}{F=ma}
  \\\Huge\textcolor{brown}{F=ma}
  $$

  - ```tex
    \huge\textcolor{blue}{F=ma}
    \\
    \Huge\textcolor{green}{F=ma}
    \\
    \Huge\textcolor{red}{F=ma}
    \\\Huge\textcolor{pink}{F=ma}
    \\\Huge\textcolor{orange}{F=ma}
    \\\Huge\textcolor{brown}{F=ma}
    ```
  
    

## 大号/小号字体(文本段)

  

- $$
  \\横向对比:\\
  \tiny{smallest}%最小
  \scriptsize{very small}%很小
  %\footnotesize{smaller}%较小(相对于small,有的不支持!)
  \small{small}%小
  \normalsize{normalsize}%正常
  \large{large}%大
  \Large{Large}%更大
  \LARGE{LARGE}%很大
  \huge{huge}%巨大
  \Huge{Huge}%巨无霸
  \\\\纵向对比:
  \\
  \begin{aligned}
  \tiny{tiny:A}
  \\\scriptsize{very small:A}
  \\\small{small:A}
  \\\normalsize{normalsize:A}%正常
  \\\large{large:A}%大
  \\\Large{Large:A}%更大
  \\\LARGE{LARGE:A}%很大
  \\\huge{huge:A}%巨大
  \\\Huge{Huge:A}%巨无霸
  \end{aligned}
  \\
  混合大小:
  \\
  \small小\normalsize中\large大
  $$

  - 原码:

    - ```tex
      \\横向对比:\\
      \tiny{smallest}%最小
      \scriptsize{very small}%很小
      %\footnotesize{smaller}%较小(相对于small,有的不支持!)
      \small{small}%小
      \normalsize{normalsize}%正常
      \large{large}%大
      \Large{Large}%更大
      \LARGE{LARGE}%很大
      \huge{huge}%巨大
      \Huge{Huge}%巨无霸
      \\\\纵向对比:
      \\
      \begin{aligned}
      \tiny{tiny:A}
      \\\scriptsize{very small:A}
      \\\small{small:A}
      \\\normalsize{normalsize:A}%正常
      \\\large{large:A}%大
      \\\Large{Large:A}%更大
      \\\LARGE{LARGE:A}%很大
      \\\huge{huge:A}%巨大
      \\\Huge{Huge:A}%巨无霸
      \end{aligned}
      \\
      混合大小:
      \small小\normalsize中\large大
      ```
  
- 通常而言,小字体会用的更少,因为tex会自动将需要变小的地方(比如角标显示的比较小)

  - 但是大字体可以用来更好的强调我们需要强调的部分
    - 当然还有下划线等强调方式
  - 也可以用来优化公式的显示,例如,某些指数非常长,比如二维正态分布的密度函数,这时候用Huge来使得e这个字母显得清晰可见


## 宏定义



- 宏定义,将`\def\MacroName{express}`使得`\MacroName`成为`express`的别名

- 总得来看,一条宏定义包括3部分:

  1. `\def`(关键字)
  2. `\MacroName`(自己取一个命令别名)
  3. `express`(需要被别名绑定的latex代码)
  4. 例如:`\def \ba#1 {#1^2}`有的三部分分别用空格分开,
     1. 最后一部分建议套一层`{}`,但是第二部分不能套`{}`
     2. `#1`表示该宏接受的第一个参数

- $$
  \spadesuit:\\
  definitions:
  \def\ba#1{#1^2};\\
  \ba{y}
  \def\bd#1{\boxed{#1}}
  \\\bd{test}
  \def\lra#1#2{#1\leftrightarrow{#2}}
  \\\lra{p}{q}
  \\\def\lra#1#2{#1\Leftrightarrow{#2}}
  \\\lra{p}{q}
  $$

  - ```tex
    \spadesuit:\\
    definitions:
    \def\ba#1 {#1^2}
    \\\ba{y}
    \def \bd#1{\boxed{#1}}
    \\\bd{test}
    \def\lra#1#2{#1\leftrightarrow{#2}}
    \\\lra{p}{q}
    \\\def\lra#1#2{#1\Leftrightarrow{#2}}
    \\\lra{p}{q}
    ```

  - $$
    \def \La#1 {\Rightarrow{#1}}
    \La{a}
    $$

    

- typora的宏定义的作用域比价广

- 某些在线markdown编辑器的宏定义作用域比较窄(以下表格可能无法正常渲染;typora中可以渲染)

  | `\def\bar#1{#1^2}`                    | ` \bar{y}`                   | $\ba{y}$                     |
  | ------------------------------------- | ---------------------------- | ---------------------------- |
  | `\def\bd#1{\boxed{#1}}`               | `\bd{text}`                  | $\bd{test}$                  |
  | `\def\lra#1#2{#1\leftrightarrow{#2}}` | `\lra{p}{q}`<br />`\lra{}{}` | $\lra{p}{q}$<br />$\lra{}{}$ |

  



##  可变长等号(自适应长度等号)

- [Support Table · X-length](https://katex.org/docs/support_table.html#x)

- $before \xlongequal{OversetContents} later$
  - `before \xlongequal{oversetContents} later`


# 🎈各种箭头

## 带文字箭头/可变长箭头

- 可变长箭头示例

  - `a \xRightarrow{\text{a long text}} b`

    - $$
      a\xRightarrow{\text{a long text}}b
      $$


  - `$a\xrightarrow{long\ text}b$`

    - $$
      a\xrightarrow{long\ text}b
      $$

    

- 箭头的方幂运算示例

  - ```tex
    \beta \Rightarrow^* \varepsilon
    ```

  

  $$
  \beta\Rightarrow^*\varepsilon
  $$

## 逻辑推导箭头🎈

- QP⟸Q
-  QP⟹Q

$$
\impliedby :P\impliedby Q
\\
\implies :P\implies Q
$$

### 命题否定

- `\neg{p}`:$\neg{p}$

## 常用的简单箭头参考

- [ The Comprehensive LaTeX Symbol List - CTAN http://tug.ctan.org › comprehensive › symbols-a4](http://tug.ctan.org/info/symbols/comprehensive/symbols-a4.pdf)

- ![image-20220610215545101](https://img-blog.csdnimg.cn/img_convert/2fde82c960255e876fbb7351102e2d91.png)

  

  
## 求和符号/分式
- `\frac{1}{n}`:$\frac{1}{n}$
- `\sum\limits_{i=1}^{n=5}`:$\sum\limits_{i=1}^{n=5}$

- 上述`\limits`是可选的


## 任意头顶上标/正上标符号
###  通用overset
```cpp
\overset{contents}{X}
```
- 效果: $\overset{contents}{X}$
###  通用下标
```latex
\underset{contents}{X}
```
- 效果:$\underset{contents}{X}$
###  专用上标
![在这里插入图片描述](https://img-blog.csdnimg.cn/5af99ba3705e49a493a2e1d048e9d6da.png)
$$
\mathring{U}
$$


### 强调符号表:stix Extensible Accents

![在这里插入图片描述](https://img-blog.csdnimg.cn/bfa9d41c0cbe4bf9bb16ab52f7fc78c7.png)

### 标记系列

- 这不分很多都Markdown都不兼容

- $\underset{100m}{\underleftrightarrow{A\boxed{\quad\text{test the underleftrightarrow }}B}}$

  - ```tex
    \underset{100m}{
    	\underleftrightarrow
    	{A
    		\boxed{\quad\text{test the underleftrightarrow }}
    	B}
    }
    ```

    

  

##  可扩展(高度)的括号对

- $$
  \left
  \{
      {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)
      +u(x)\cdot \frac{(v(x+\Delta x)-v(x))}{\Delta x}}
  \right
  \}
  $$

- 单行高大括号

- 由于`{`本身在latex中被解释为特殊符号,需要转义!`\{`&`\}`

- ```tex
  \left
  \{
      {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)
      +u(x)\cdot \frac{(v(x+\Delta x)-v(x))}{\Delta x}}
  \right
  \}
  ```

- 单行大圆括号对
$$
\left
(
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
\right
)
$$
- 单行大方括号对
$$
\left
[
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
\right
]
$$
- 混合括号也可以打出来,但一般不这么做
$$
\left
(
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
\right
\}
$$
####  源码

- ```tex
  - 单行大圆括号对
  
  \left
  (
      {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
  \right
  )
  - 单行大方括号对
  \left
  [
      {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
  \right
  ]
  - 混合括号也可以打出来,但一般不这么做
  \left
  (
      {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
  \right
  \}
  ```

##   对齐:公式/等式组/逐步演算对齐🎈

- - 最基础的对齐,可以使用`{aligned}`,`{align}`数学环境

- $$
  \\
  \begin{aligned}
  y^{(1)}&=\frac{1}{x+a}=(x+a)^{-1}&k=1\\
  y^{(2)}&=(-1)(x+a)^{-2} &k=2\\
  y^{(3)}&=(-1)(-2)(x+a)^{-3}&k=3\\
  \end{aligned}
  \\
  \begin{aligned}
  &y^{(1)}=\frac{1}{x+a}=(x+a)^{-1}\\
  &y^{(2)}=(-1)(x+a)^{-2}\\
  &y^{(3)}=(-1)(-2)(x+a)^{-3}\\
  \end{aligned}
  \begin{aligned}
  f(u) & =\sum_{j=1}^{n} x_jf(u_j)&\\
    & =\sum_{j=1}^{n} x_j \sum_{i=1}^{m} a_{ij}v_i\\
   & =\sum_{j=1}^{n} \sum_{i=1}^{m} a_{ij}x_jv_i
  \end{aligned}
  $$

- 可以使用`&`符号来指定需要对齐的基准元素

  - 譬如,总是在`=`前加上`&`,那么就可以排版会以等号为基准对齐
  - 由于不同的markdown客户端的使用的公式渲染引擎不同,支持的的语法以及效果可能会不同,下面这段代码可以在csdn的公式编辑块(基于katex版时)中以及typora(实验于1.3+)生效
  - 公式块/等式块换行

- ```c
  \\
  \begin{aligned}
  y^{(1)}&=\frac{1}{x+a}=(x+a)^{-1}&k=1\\
  y^{(2)}&=(-1)(x+a)^{-2} &k=2\\
  y^{(3)}&=(-1)(-2)(x+a)^{-3}&k=3\\
  \end{aligned}
  \\
  \begin{aligned}
  &y^{(1)}=\frac{1}{x+a}=(x+a)^{-1}\\
  &y^{(2)}=(-1)(x+a)^{-2}\\
  &y^{(3)}=(-1)(-2)(x+a)^{-3}\\
  \end{aligned}
  \begin{aligned}
  f(u) & =\sum_{j=1}^{n} x_jf(u_j)&\\
    & =\sum_{j=1}^{n} x_j \sum_{i=1}^{m} a_{ij}v_i\\
   & =\sum_{j=1}^{n} \sum_{i=1}^{m} a_{ij}x_jv_i
  \end{aligned}
  ```

###  集合交并符号



- $$
  \overset{n}{\underset{i=1}{\cap}} =A_i
  \\更加语义化和推荐的写法:
  \\ \bigcap_{i=1}^{n}
  \\在内联(inline)公式中,可以追加\\limits来保证上下界位于头顶!!
  \\例如:
  \\ \bigcap\limits_{i=1}^{n}
  \\ \bigcup_{i=1}^{n}
  $$

- 

- ```tex
  \overset{n}{\underset{i=1}{\cap}} =A_i
  \\更加语义化和推荐的写法:
  \\ \bigcap_{i=1}^{n}
  \\在内联(inline)公式中,可以追加\\limits来保证上下界位于头顶!!(例如:
  \\ \bigcap\limits_{i=1}^{n}
  \\ \bigcup_{i=1}^{n}
  ```

  

## 表格🎈

- markdown中的表格支持不是很完善

- 不能够直接使用table

- 但是可以使用基础的array

  - $$
    \begin{array}{|c|c|}
    \hline 
    操作码字段 & 地址码字段\\
    \hline
    c_1 & c_2\\
    \hline
    \end{array}
    $$

    - ```tex
      \begin{array}{|c|c|}
      \hline 
      操作码字段 & 地址码字段\\
      \hline
      c_1 & c_2\\
      \hline
      \end{array}
      ```

  - 通常,可以结合使用`\underbrace{}_{}`或者`\overbrace{}^{}`来做基本





## 逻辑学🎈

- $$
  \begin{array}{l}
  \neg(p \wedge q) \equiv(\neg p) \vee(\neg q) \\
  \neg(p \vee q) \equiv(\neg p) \wedge(\neg q)
  \end{array}
  $$


## 竖式计算

- $$
  \begin{array}{r}
  &10010101B\\
  +&001010B\\
  \hline
  &11011111B
  \end{array}
  $$

  - 

    ```tex
    \begin{array}{r}
    &10010101B\\
    +&001010B\\
    \hline
    &11011111B
    \end{array}
    ```

- $$
  \underline{
      \begin{aligned}
      &&0.1101
      \\&\times&0.111
      \end{aligned}
  }
  $$

  

  - ```tex
    \begin{aligned}
    &&0.1101
    \\&\times&0.111
    \hline
    \end{aligned}
    ```

### 横线

- $$
  test
  \\
  \rule{8cm}{1.4pt}
  \\
  test
  \\
  \rule{5cm}{.4pt}
  $$

  
  
  - ```tex
    test
    \\
    \rule{8cm}{1.4pt}
    \\
    test
    \\
    \rule{5cm}{.4pt}
    ```
  
    
  
- [rules - Horizontal line spanning the entire document in LaTeX - TeX - LaTeX Stack Exchange](https://tex.stackexchange.com/questions/19579/horizontal-line-spanning-the-entire-document-in-latex)

## 线性代数@向量正交

- $$
  \mathbf{S} \bullet \mathbf{T} = \frac{1}{m} \sum_{i=1}^{m} S_{i} T_{i}=0
  $$

  

  - ```tex
    \mathbf{S} \bullet \mathbf{T} \equiv \frac{1}{m} \sum_{i=1}^{m} S_{i} T_{i}=0
    ```




## 删除线

- $\xcancel{ABC}$
  - `\xcancel{ABC}`
- $\cancel{ABC}$
  - `\cancel{ABC}`
- $\bcancel{ABC}$
  - `\bcancel{ABC}`

- $$
  \cancel{\bcancel{testxfsdfsdfasd}}
  $$

  

## 框线图

- $$
  \boxed{\sum\limits_{i=1}^{\delta}=\spadesuit}
  \\
  \boxed{\boxed{\xcancel{\Huge{Net_1}}}}
  \\
  \boxed{\boxed{\boxed{\xcancel{\Huge{Net_1}}}}}
  \\
  $$

  - ```tex
    \boxed{\sum\limits_{i=1}^{\delta}=\spadesuit}
    \\
    \boxed{\boxed{\xcancel{\Huge{Net_1}}}}
    \\
    \boxed{\boxed{\boxed{\xcancel{\Huge{Net_1}}}}}
    ```

    

  

### 兼容性差的部分:

- typora支持但是某些在线markdown不支持
  - 效果预览
  -  ![在这里插入图片描述](https://img-blog.csdnimg.cn/fe5522b4156941358c8792297f32c974.png)

- $$
  \\\begin{CD}
     A @>a>> B \\
  @VbVV @AAcA \\
     C @= D
  \end{CD}
  \\
  \\\begin{CD}
     \\\boxed{\sum\limits_{i=1}^{\delta}=\spadesuit} @>a>> B \\
  @VbVV @AAcA \\
     C @= D
  \end{CD}
  $$

  - ```tex
    \\\begin{CD}
       A @>a>> B \\
    @VbVV @AAcA \\
       C @= D
    \end{CD}
    \\
    \\\begin{CD}
       \\\boxed{\sum\limits_{i=1}^{\delta}=\spadesuit} @>a>> B \\
    @VbVV @AAcA \\
       C @= D
    \end{CD}
    ```

    

  

  

## 条件分支

### 左花括号

- typora支持但是某些在线markdown不支持

- $$
  \begin{cases}
     a &\text{if } b \\
     c &\text{if } d
  \end{cases}
  $$

  - ```text
    \begin{cases}
       a &\text{if } b \\
       c &\text{if } d
    \end{cases}
    ```

    



### 右花括号

- $$
  \begin{drcases}
     a &\text{if } b \\
     c &\text{if } d
  \end{drcases}
  $$

  - ```tex
    \begin{drcases}
       a &\text{if } b \\
       c &\text{if } d
    \end{drcases}
    ```

    

