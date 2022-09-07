@\[toc\]

## references

- 排列数:[Permutation - Wikipedia](https://en.wikipedia.org/wiki/Permutation)

- 二项式系数[Binomial coefficient - Wikipedia](https://en.wikipedia.org/wiki/Binomial_coefficient)

- [组合 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.m.wikipedia.org/zh-cn/%E7%B5%84%E5%90%88)

## 乘法原理

> 做一件事，完成它需要分成n个步骤，做第一 步有$m_{1}$种不同的方法，做第二步有$m_{2}$种不同的方法，……，做第n步有$m_{n}$种不同的方法。那么完成这件事共有 N=$m_{1}$$m_{2}$...$m_{n}$ 种不同的方法

> 做完一整件事的若干`步骤`中,各个步骤各自存在的方案总数的计算不能脱离步骤间的执行顺序

- 在`组合数`公式的展开中,其分母比对应的`排列数`的展开式要多上一部分(可以理解为该部分就是用以去重(去序)的.

## 排列数/组合数公式

### 排列数Permutation

$$
P^m_n=\underbrace{n(n-1)\dots(n-m+1)}_{共有m项}=\frac{n!}{(n-m)!}
$$

|6|5|||||||
|-|-|-|-|-|-|-|-|
|1|2|3|...|m|m+1|||
|n|n-(1)|n-(2)|...|n-(m-1)=n-m+1|~~n-(m)~~|||
|||||||||

> - 基于乘法原理
>
> - 排列数中的一每种结果将顺序考虑在内,即,多个排列结果中包含的元素集合是一致的

### 组合数combination

$$
C^m_n=\frac{P^m_n}{m!}=\frac{n!}{m!(n-m)!}
$$

- 从 n 个不同元素中取出 k 个元素的所有不同组合的个数，叫做从 n 个不同元素中取出 k 个元素的组合数

- 可见,组合数不区分顺序,不同的结果中的元素集合必然不同

- 可通过对排列数进行`去序`来得到对应额组合数结果

### 组合数的特点

$$
C^m_n=C^{n-m}_{n}
$$

$$
C^m_n+C^{m-1}_{n}=C^m_{n+1}
$$

#### 证明

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

### 回顾上述公式/性质

![在这里插入图片描述](https://img-blog.csdnimg.cn/7a4a718d33bb4865bf24dfdc7eb16fde.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

#### 全排列公式

将上述的全排列公式`m取值为n(m=n)`,则得到下式

> - 注意:((n-n)!=0!=1)

![在这里插入图片描述](https://img-blog.csdnimg.cn/aaad1921f99e483dbaaa0b0bb6fd321f.png)

### 排列数实例

#### 取出元素不重复出现状况

![image-20220620173651242](https://img-blog.csdnimg.cn/img_convert/9f5c4290c033811939380aaeb55eaa48.png)

#### 取出的元素可重复

![image-20220620174553371](https://img-blog.csdnimg.cn/img_convert/428b99193b58bce4d2b50a029b7802fc.png)

### 组合数实例

- n选k

- $\binom{n}{k}$表示n个互不相同的元素中选取出k个元素的组合情况(总数)

> - wiki百科将n放在上标,把k放在下标,但是含义是一样的
>
> - 实际上,也不失直观性

![image-20220620175430783](https://img-blog.csdnimg.cn/img_convert/c6e6856935f7e127b08a268d5b30d9a2.png)

理解均匀分组中的去重复计算问题,可以这样入手

## 均匀分组

> 为了不引起混淆,以给一批游工人组队(不考虑分配任务,仅仅考虑人员组合可能的情况的种数)作为问题场景

从最简单的均匀分组来看:

> (没有第1组和第2组这样组别区分,只有单个分组内的人员构成作(成员间要做区分)为组与组的区别)

* 两个人,均分成两个组,有几种不同分法?

> 显然,只有一种分法(两个组都是一组一个人)

* 三个人,均分成三组,有几种不同分法?

> 显然还是只有一种分法(每组一个人这一种分组方法)

利用组合数和分步乘法原理,不考虑去重(保留分组顺序),那么两个问题的解分别表示为

> 为第一个组选择并分配一个人;在为第二组人选择并分配一个人;...
> $\binom{2}{1}\binom{1}{1}=2*1=2$
> $\binom{3}{1}\binom{2}{1}\binom{1}{1} =3*2*1=6$

问题是,如何理解这个结果?

- 其实上述做法是`考虑组别之间顺序情况下`的很自然的做法

- 如果需要得到无序别的结果数,只需要做去序操作

`binomial 美: [baɪˈnoʊmiəl]  adj.	【数】二项(式)的`
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

### 例题

人数不等的组别不计入均匀分组的去重计算,例如

![在这里插入图片描述](https://img-blog.csdnimg.cn/33ee849e72ef49d5aedd7cfef868a0f0.png)
解:$\frac{C_{7}^{2}C_{5}^{2}A_{3}^{3}}{A_{2}^{2}}$

## 二项式定理&二项式系数

> - 了解完排列组合的相关知识,可以进一步学习二项式定理

![image-20220620195532158](https://img-blog.csdnimg.cn/img_convert/576387ac6694d2aaa0a036994d2e32f8.png)

- 二项式的**n次幂**的代数展开中:

  - 每一个项都形如$ax^by^c$

    - b+c=n

    - $a=\binom{n}{b}=\binom{n}{c}$

      - 这一点很重要,特别是对于下面介绍的求和表达式中的(通项公式)对称性的基础

- ![image-20220620200417325](https://img-blog.csdnimg.cn/img_convert/81fe1d052b0a33a53162a7e4dbd5eae7.png)

- 

  $$
  (x+y)^n=\sum\limits_{k=0}^{k=n}\binom{n}{k}x^{n-k}y^k=\sum\limits_{k=0}^{k=n}\binom{n}{k}x^{k}y^{n-k}\\
  其中:C_n^k=\binom{n}{k}
  $$

- 共经历n+1项

### 几何含义

![image-20220620200722482](https://img-blog.csdnimg.cn/img_convert/282ace47999bcb55fff77fe071b59aaa.png)

### 证明&应用

* [4证明](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E8%AD%89%E6%98%8E)

  * [4.1数学归纳法](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E6%95%B8%E5%AD%B8%E6%AD%B8%E7%B4%8D%E6%B3%95)

  * [4.2组合方法](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E7%B5%84%E5%90%88%E6%96%B9%E6%B3%95)

  * [4.3不尽相异物排列方法](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E4%B8%8D%E7%9B%A1%E7%9B%B8%E7%95%B0%E7%89%A9%E6%8E%92%E5%88%97%E6%96%B9%E6%B3%95)

  * [4.4一般形式的证明](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E4%B8%80%E8%88%AC%E5%BD%A2%E5%BC%8F%E7%9A%84%E8%AF%81%E6%98%8E)

* [5应用](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E5%BA%94%E7%94%A8)

  * [5.1证明组合恒等式](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E8%AF%81%E6%98%8E%E7%BB%84%E5%90%88%E6%81%92%E7%AD%89%E5%BC%8F)

  * [5.2多倍角恒等式](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E5%A4%9A%E5%80%8D%E8%A7%92%E6%81%92%E7%AD%89%E5%BC%8F)

  * [5.3e级数](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#e%E7%BA%A7%E6%95%B0)

* [6推广](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E6%8E%A8%E5%B9%BF)

  * [6.1多项式展开](https://oracleusa.ml/-----https://zh.wikipedia.org/zh-sg/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86#%E5%A4%9A%E9%A1%B9%E5%BC%8F%E5%B1%95%E5%BC%80)

### 组合法

![image-20220620202219910](https://img-blog.csdnimg.cn/img_convert/f48dc2f6595c36421ac08a6c8111c3c5.png)

### 不尽相异物排列法

![image-20220620202232704](https://img-blog.csdnimg.cn/img_convert/bba1a7cc0a4df9cea82ead5c0e646d94.png)

### 二项式相关恒等式

![image-20220620203431040](https://img-blog.csdnimg.cn/img_convert/9d16e36d1a12b4510ccffb13fe1f22cd.png)

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

- 

  $$
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