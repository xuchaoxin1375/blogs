[toc]

## references

- 排列数:[Permutation - Wikipedia](https://en.wikipedia.org/wiki/Permutation)
- 二项式系数[Binomial coefficient - Wikipedia](https://en.wikipedia.org/wiki/Binomial_coefficient)
- [组合 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.m.wikipedia.org/zh-cn/組合)





# 排列数/组合数公式

##  乘法原理和三大模型基础模型:

> 做一件事，完成它需要分成n个步骤，做第一 步有$m_{1}$种不同的方法，做第二步有$m_{2}$种不同的方法，……，做第n步有$m_{n}$种不同的方法。那么完成这件事共有 N=$m_{1}$$m_{2}$...$m_{n}$ 种不同的方法

> 做完一整件事的若干`步骤`中,各个步骤各自存在的方案总数的计算不能脱离步骤间的执行顺序

- 在`组合数`公式的展开中,其分母比对应的`排列数`的展开式要多上一部分(可以理解为该部分就是用以去重(去序)的.

> 排列数&组合数和三角函数以及不等式性质一样在高等数学中频繁出现,是值得多多练习的基础内容
三个基础模型:

- 方幂模型
- 排列数模型
- 组合数模型

### 方幂模型

- 在概率论中,对应于
  - 不放回抽样
  - 独立重复试验
- $k次抽样或试验,每次试验结果记为x_i;设每次基础试验的结果有n种$
  - $k次试验的总结果记为(x_1,x_2,\cdots,x_k)$
  - 可以产生出$n^k$种结果

### 排列数Permutation

$$
P^m_n=\frac{n!}{(n-m)!}
=n(n-1)\dots(n-m+1)
\\=(n-0)(n-1)\dots(n-(m-1))
\\=\prod_{k=0}^{m-1}{(n-k)}
\\=\prod_{k=1}^{m}{(n-(k-1))}
=\prod_{k=1}^{m}{(n-k+1)}
$$

- 基于乘法原理

  - $$
    \\
    \begin{pmatrix}
    1&2&3&\cdots&x&\cdots&n-1&n\\
    \updownarrow&&&&&&&\updownarrow
    \\
    n&n-1&&\cdots&m&\cdots&2&1
    \end{pmatrix}
    \\
    \Delta=n-x=m-1
    \\
    (或\quad n-x+1=m)
    \\
    x=x(m,n)=n-m+1
    $$

    

- 排列数中的一每种结果将顺序考虑在内,即,允许存在多个排列结果中包含的元素集合是一致的
  - 例如:分配任务问题,适合用排列数计算方案总数



### 组合数combination

- $$
  C^m_n=\frac{P^m_n}{m!}=\frac{1}{m!}\frac{n!}{(n-m)!}
  \\
  =\frac{1}{\prod\limits_{k=1}^{m}k}\cdot
  \prod_{k=1}^{m}{(n-k+1)}
  \\
  ={\prod\limits_{k=1}^{m}k^{-1}}
  \prod_{k=1}^{m}{(n-k+1)}
  \\
  =\prod_{k=1}^{m}\frac{(n-k+1)}{k}
  $$

- 从 n 个不同元素中取出 k 个元素的所有不同组合的个数，叫做从 n 个不同元素中取出 k 个元素的组合数
- 可见,组合数不区分顺序,不同的结果中的元素集合必然不同
- 可通过对排列数进行`去序`来得到对应额组合数结果



### 组合数的特点

$$
C^m_n=C^{n-m}_{n}
\\
C^m_n+C^{m-1}_{n}=C^m_{n+1}
$$



#### 证明
- 纯代数方法
$$
LHS=\frac{P^m_n}{m!}+\frac{P^{m-1}_{n}}{(m-1)!}=\frac{P^m_n+P^{m-1}_n\times m}{m!}
=\frac{\frac{n!}{(n-m)!}+\frac{n!}{(n-(m-1))!}\times m}{m!}
\\
=\frac{\frac{(n-m+1)\times n!}{(n-m+1)\times (n-m)!}+\frac{n!}{(n-m+1))!}\times m}{m!}
=\frac{\frac{(n-m+1)\times n!}{(n-m+1)!}+\frac{n!\times m}{(n-m+1)!}}{m!}
=\frac{\frac{n!\times ((n-m+1)+m)}{(n-m+1)!}}{m!}
\\
=\frac{\frac{ (n+1)\times n!}{(n-m+1)!}}{m!}=\frac{\frac{ (n+1)!}{(n-m+1)!}}{m!}
\\
\\
$$

$$
RHS=\frac{P^{m}_{n+1}}{m!}=\frac{\frac{(n+1)!}{(n-m+1)!}}{m!}
$$

- 可见`LHS=RHS`证明完毕
####  二项式定理中的含义(杨辉三角/帕斯卡三角)
![在这里插入图片描述](https://img-blog.csdnimg.cn/3e756fefb1c245198e65b98aaef83a1d.png)

## 🎈小结(基础的排列组合公式)

#### 全排列公式

将上述的全排列公式`m取值为n(m=n)`,则得到下式

- 注意:$(n-n)!=0!=1$

$$
P^n_n=n(n-1)\cdots3\cdot2\cdot1=\prod_{i=1}^{n}i=n!
$$

#### 组合数(丰富)

- $C_n^m=\frac{P^m_n}{m!}=\frac{n!}{(n-m)!m!}$
- $C^m_n=C^{n-m}_n$
- $C^m_n+C^{m-1}_n=C^m_{n+1}$
- $\sum\limits_{i=0}^{n}C^i_n=2^n$
  - 或者:$\sum\limits_{i=0}^{n}\binom{n}{i}=2^n$
  - 在后面的二项式展开定理中将推导



### 🎆排列数实例

#### 取出元素不重复出现状况

![image-20220620173651242](https://img-blog.csdnimg.cn/img_convert/9f5c4290c033811939380aaeb55eaa48.png)

#### 取出的元素可重复

![image-20220620174553371](https://img-blog.csdnimg.cn/img_convert/428b99193b58bce4d2b50a029b7802fc.png)

### 🎆组合数实例

- n选k


- $\binom{n}{k}$表示n个互不相同的元素中选取出k个元素的组合情况(总数)


> - wiki百科将n放在上标,把k放在下标,但是含义是一样的
> - 实际上,也不失直观性

![image-20220620175430783](https://img-blog.csdnimg.cn/img_convert/c6e6856935f7e127b08a268d5b30d9a2.png)

理解均匀分组中的去重复计算问题,可以这样入手

### 🎆方幂实例

- 抛色子/抛硬币
  - $抛n次色子,第i次抛到点数结果记为x_i$
    - $抛完n次后得到的结果(x_1,x_2,\cdots,x_n)有6^n种可能$
    - $x_i\in\set{1,2,3,4,5,6}$

# 分组问题

##  均匀分组

>为了不引起混淆,以给一批游工人组队(不考虑分配任务,仅仅考虑人员组合可能的情况的种数)作为问题场景

从最简单的均匀分组来看:

> (没有第1组和第2组这样组别区分,只有单个分组内的人员构成作(成员间要做区分)为组与组的区别)

* 两个人,均分成两个组,有几种不同分法?

>显然,只有一种分法(两个组都是一组一个人)

* 三个人,均分成三组,有几种不同分法?

>显然还是只有一种分法(每组一个人这一种分组方法)

利用组合数和分步乘法原理,不考虑去重(保留分组顺序),那么两个问题的解分别表示为

>为第一个组选择并分配一个人;在为第二组人选择并分配一个人;...
>$\binom{2}{1}\binom{1}{1}=2*1=2$
>$\binom{3}{1}\binom{2}{1}\binom{1}{1} =3*2*1=6$ 

问题是,如何理解这个结果?

- 其实上述做法是`考虑组别之间顺序情况下`的很自然的做法
- 如果需要得到无序别的结果数,只需要做去序操作

`binomial
美: [baɪˈnoʊmiəl] 
adj.	【数】二项(式)的`
我们不妨对第二个问题进行有顺序区分下的枚举:

```bash
abc
acb
bac
bca
cab
cba
```

共有六种,这正好是排列数$A_{3}^{3}$的结果,换句话说,就是对均分后的组数(三组),对三个组对象求全排列的结果

- 事实上,组合数之间做乘法,就已经蕴含着顺序;(单个组合数内是无序的)

## 局部均匀分组

###  例题

人数不等的组别不计入均匀分组的去重计算,例如

![在这里插入图片描述](https://img-blog.csdnimg.cn/33ee849e72ef49d5aedd7cfef868a0f0.png)
解:$\frac{C_{7}^{2}C_{5}^{2}A_{3}^{3}}{A_{2}^{2}}$


##  求和中的对称性
$$
\sum\limits_{i=0}^{i=n}a^{i}b^{n-i}=\sum\limits_{i=0}^{i=n}a^{n-i}b^{i}
\\
LHS=a^0b^n+a^1b^{n-1}+\dots+a^{n-1}b^{1}+a^{n}b^0
\\
RHS=a^nb^0+a^{n-1}b^{1}+\dots+a^{1}b^{n-1}+a^0b^n
$$
- 对比上述的$LHS\&RHS$,不难发现,LHS中的各项时RHS中各项顺序互为逆序,而互为逆序的两个数列各自的求和结果显然一致,即$HLS=RHS$
- 但是,对称性需要保证a的指数和b的指数之和为n:$(i+(n-i)=n)$
- 事实上,求和式的各个项(term)的两个幂因子($a^ib^j)$(其中$i+j=n$(常数)),换句话说,确定了$i,j=n-i$这个值也就被唯一确定了(两个项如果有相同的幂因子($a^i$),则这两个项相等(在当前的上下文语境中,两个项来自于不同的两侧),
- 为此,我们考察求和的对称性的时候,只需要专注于项的第一个幂因子($a^i$),发现,仅仅只有累加的顺序不同,因此式子左边和右边式相等

# 二项式

## 二项式定理&二项式系数

- 了解完排列组合的相关知识,可以进一步学习二项式定理

![image-20220620195532158](https://img-blog.csdnimg.cn/img_convert/576387ac6694d2aaa0a036994d2e32f8.png)

- 二项式的**n次幂**的代数展开中:

  - 每一个项都形如$ax^by^c$
    - $b+c=n$
    - $a=\binom{n}{b}=\binom{n}{c}$
      - 这一点很重要,特别是对于下面介绍的求和表达式中的(通项公式)对称性的基础

###  二项式系数🎈

- 二项式系数的第k项(通项公式):
$$
a_k=\binom{n}{k}=\frac{n!}{k!(n-k)!}
\\k=0,1,2,\cdots,n
$$
### 二项式展开公式🎈

#### 利用对称性下的两种展开形式🎈

- 对称性:
  - $对于b+c=n,k可以取b或者c,a_b=a_c$

- $$
  (x+y)^n=\sum\limits_{k=0}^{k=n}\binom{n}{k}x^{n-k}y^k
  =\sum\limits_{k=0}^{k=n}\binom{n}{k}x^{k}y^{n-k}
  \\
  其中:C_n^k=\binom{n}{k}
  $$
  
  - 后面的表达式只是将根据x与y的对称性得出的，通过比较发现公式中的二项式系数也是对称的。
  
- $共经历n+1项(而不只n项)$

### 特别的情况🎈

- $令y=1$

- $二项式定理的一个变形是用1来代换g得到的，所以它只涉及一个变量。在这种形式中，公式写作$

  - $$
    (1+x)^n=\sum\limits_{k=0}^{n}\binom{n}{k}x^k
    $$

#### 🎈二项式系数求和

- $如果同时令x=y=1$
  - 得到$(1+1)^n=\sum\limits_{k=0}^{n}\binom{n}{k}1^k$
  - $因此2^n=\sum\limits_{k=0}^{n}\binom{n}{k}$
    - 实际上,用的比较多的是:
      - $\sum\limits_{k=1}^{n}\binom{n}{k}=2^n-1$
      - $\sum\limits_{k=2}^{n}\binom{n}{k}=2^n-n-1$



###  几何含义

![image-20220620200722482](https://img-blog.csdnimg.cn/img_convert/282ace47999bcb55fff77fe071b59aaa.png)



### 证明&应用

*   [4证明](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E8%AD%89%E6%98%8E)
    *   [4.1数学归纳法](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E6%95%B8%E5%AD%B8%E6%AD%B8%E7%B4%8D%E6%B3%95)
    *   [4.2组合方法](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E7%B5%84%E5%90%88%E6%96%B9%E6%B3%95)
    *   [4.3不尽相异物排列方法](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E4%B8%8D%E7%9B%A1%E7%9B%B8%E7%95%B0%E7%89%A9%E6%8E%92%E5%88%97%E6%96%B9%E6%B3%95)
    *   [4.4一般形式的证明](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E4%B8%80%E8%88%AC%E5%BD%A2%E5%BC%8F%E7%9A%84%E8%AF%81%E6%98%8E)
*   [5应用](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E5%BA%94%E7%94%A8)
    *   [5.1证明组合恒等式](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E8%AF%81%E6%98%8E%E7%BB%84%E5%90%88%E6%81%92%E7%AD%89%E5%BC%8F)
    *   [5.2多倍角恒等式](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E5%A4%9A%E5%80%8D%E8%A7%92%E6%81%92%E7%AD%89%E5%BC%8F)
    *   [5.3e级数](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#e%E7%BA%A7%E6%95%B0)
*   [6推广](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E6%8E%A8%E5%B9%BF)
    *   [6.1多项式展开](https://oracleusa.ml/-----https://zh\.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E5%A4%9A%E9%A1%B9%E5%BC%8F%E5%B1%95%E5%BC%80)

### 组合法

![image-20220620202219910](https://img-blog.csdnimg.cn/img_convert/f48dc2f6595c36421ac08a6c8111c3c5.png)



### 不尽相异物排列法

![image-20220620202232704](https://img-blog.csdnimg.cn/img_convert/bba1a7cc0a4df9cea82ead5c0e646d94.png)

## 二项式相关恒等式

![image-20220620203431040](https://img-blog.csdnimg.cn/img_convert/9d16e36d1a12b4510ccffb13fe1f22cd.png)
###  e级数
![image-20220620205131081](https://img-blog.csdnimg.cn/img_convert/2ff1624ae105452ef4aea83e2c178d86.png)

- 将第k项展开

$$
\binom{n}{k}\frac{1}{n^k}=\frac{\frac{n!}{k!(n-k)!}}{n^k}=
\frac{1}{k!}\times \frac{n(n-1)(n-2)\dots(n-k+1)}{n^k}
\\
=\frac{1}{k!}\times \frac{n(n-1)(n-2)\dots (n-(k-1))}{n^k}
$$

上式中的第二部分:
$$
f_{10}=\frac{n(n-1)(n-2)\dots (n-(k-1))}{n^k}
$$

- 分子的n的最高次是$1+(k-1)=k$次幂,这和分母是同阶的

- 所以,当$n\rightarrow\infin$时:

- $$
  \lim_{n->\infin}{f_{10}}=1
  $$

可见
$$
\lim_{n->\infin}{\binom{n}{k}\frac{1}{n^k}}=\frac{1}{k!}\times1=\frac{1}{k!}
$$
因此:
$$
e=\sum\limits_{k=0}^{\infin}\frac{1}{k!}
$$
##  🎈组合数:莱布尼兹公式与推广的求导法则

### 推广的乘法求导法则

$$
记:f(x)=\prod_{i=1}^{i=n}{g_i(x)}
$$

$$
f'(x)=(\prod\limits_{i=1}^{i=n} g_i(x))'
=\sum\limits_{i=1}^{n}
\left [
{
(\prod\limits_{j=0}^{j=i-1}
{
g_j(x)
})\cdot
{
g'_i(x)
}\cdot 
({
\prod\limits_{k=i+1}^{k=n}
{
g_k(x)
}
})
}
\right ]
\\约定g_0(x)=1
$$

- 讲白了,就是各个函数因子轮流求导,将会得到相应数量的项,将他们求和(相加),得到结果

- $$
  可以通过将f(x)划分为两部分g_i(x)和表示其余部分部分积\varphi_j(x)),
  \\使用基本的的乘法求导法则,不断地用下去
  \\可以得到一颗求导分析树(会极端地偏向于一支,直到含有\varphi'_j(x)的部分都被求导完毕)n'g'v
  $$

  

- 在乘法求导法则中不在乎轮流顺序,但是在除法中有所讲究



#### 更加简洁的写法


$$
f'(x)=(\prod_{i=1}^{i=n}g_i(x))'
=\sum\limits_{i=1}^{n}(g_i'(x)
\prod\limits_{
\begin{matrix} 
j= 1
\\
j\neq i
\end{matrix}
}^{n}
g_j(x))
$$
其中:
$$
\prod\limits_{
\begin{matrix} 
j= 1
\\
j\neq i
\end{matrix}
}^{n}
g_j(x)
=g_1(x)g_2(x)\cdots g_{i-1}(x)\cdot g_{i+1}(x)\cdots g_n(x)
=\frac{\prod\limits_{j=1}^{j=n}{g_j(x)}}{g_i(x)}
$$

## 形式上相似的公式

### 二项式展开


- 形式上类似于二项式定理的


  - $$
    (x+y)^n=\sum\limits_{k=0}^{k=n}\binom{n}{k}x^{n-k}y^k
    $$

    

### 莱布尼兹法则🎈


- 函数乘法高阶求导法则:

- 如果$f,g都为n次可导的函数,则f\cdot g的n阶导数为:$

- $$
  (f\cdot g)^{(n)}
  =\sum\limits_{k=0}^{n}
  {\binom{n}{k}f^{(k)}g^{(n-k)}}
  \\=\sum\limits_{k=0}^{n}
  {\binom{n}{k}f^{(n-k)}g^{(k)}}
  $$

  - $$
    \binom{n}{k}是二项式系数
    $$


### 等幂差公式

- $$
  a^n-b^n=(a-b)\sum\limits_{i=0}^{\theta}a^{\theta-i}b^{i}
  \\
  \theta=n-1
  $$

  

