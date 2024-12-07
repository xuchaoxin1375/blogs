[toc]

ref

- [字符串匹配问题](https://www.ruanx.net/kmp/#-)

- [Brute-Force](https://www.ruanx.net/kmp/#brute-force)

- [brute-Force的改进思路](https://www.ruanx.net/kmp/#brute-force-)

- [跳过不可能成功的字符串比较](https://www.ruanx.net/kmp/#--1)

- [next数组](https://www.ruanx.net/kmp/#next-)

- [利用next数组进行匹配](https://www.ruanx.net/kmp/#-next-)

- [快速求next数组](https://www.ruanx.net/kmp/#-next--1)

## 朴素匹配算法

### 实现1

| ...  |      |       | i'(下一次回溯的地方) |       |      | i     |      |
| ---- | ---- | ----- | -------------------- | ----- | ---- | ----- | ---- |
|      |      | $c_1$ | $c_2$                | $c_3$ | ...  | $c_j$ |      |

- $c_1c_2c_3\cdots c_j\cdots$是匹配的模式串
- $c_j是失配的地方$

- $那么有i-i'=j-2$;(根据闭区间内元素数量相等而建立的等式)
- $i'=i-j+2$

### 实现2（借助额外的回溯辅助指针）

### 实现3(借助其他调用（subString/strcmp)

## kmp

- In [computer science](https://en.wikipedia.org/wiki/Computer_science), the **Knuth–Morris–Pratt [string-searching algorithm](https://en.wikipedia.org/wiki/String-searching_algorithm)** (or **KMP algorithm**) searches for occurrences of a "word" `W` within a main "text string" `S` by employing the observation that when a mismatch occurs, the word itself embodies sufficient information to determine where the next match could begin, thus bypassing re-examination of previously matched characters.

### 主串(被搜索串)T

- 主串(main string)文本来源(算法输入的字符序列1)

### 模式串(目标串)p

- 模式串(patte)

1. 需要在**主串**中找到的第一次出现位置的串(目标串)
2. $p_1p_2p_3\cdots p_{m-1}p_{m}$

#### 模式串长度m

1. $m=p.len表示模式串的长度$



### 部分匹配串PM(partialMatch)

### 头部串$h_t$

- <u>某个字符串</u>s的头部串是指:该字符串的前t个字符构成的序列

  - 这里字符串s作为头部串的主串

  - 它们具有不同的字符数t,它们形如:

    1. 我们把长度为t$的头部串记为h_t$
    2. $\bigstar h_t=p_1p_2p_3\cdots p_{t};t=1,2,3,\cdots, m$

  - 头部串的长度可以和它的主串一样长

    - (这一点将有别于后面的真前缀)

    - 实际上头部串在含义上和后面的前缀是一样的,这里为了避免混淆,做了刻意的区分

      

#### 模式串的头部串$h_t(p)$

- 本算法的头部串主要是指模式串的头部串

1. 就是模式串在和主串T匹配过程中,成功匹配上的那部分字符序列(头部串)

   1. 根据匹配的程度不同,会产生不同长度的$h_t=h_t(p)$

2. > 从这个角度上看,模式串p只不过是头部集合中的一个而已

### 模式串的头部串集合HeadSet={$h_t$}

1. 所有模式串的头部串$h_t$构成的集合就是HeadSet

   1. 头部串集合含有m个长度不同的头部串
   2. $t=1,2,\cdots,m$

2. 模式串的头部串这个概念是为了描述模式串失配时,

   - 从模式串的第一个字符到失配位置前的一个字符序列片段,记其长度为t
   - (主串和模式串匹配了前t个字符匹配上了,之后的字符(t+1开始就发生了失配),
   - 这时匹配上的那部分符子序列就是头部串集合中的某一个元素

   

### 前后缀(prefix&postfix)

- 注意前后缀的方向性:它们是同一方向的(比如从左往右)
- 🤬而不是回文序列(方向相反)

#### 😂😂分析前后缀特点足够重要

- 在快速求解next数组的递推法中,我们将看到,通过利用前后缀的相等性来填充next数组

#### 真前缀(real prefix)

1. `形象描述:`$就是从字符串string的前x个字符(x<length(string))$
   1. 即从字符串的第一个字符开始截取任意长度的子串(但是不可以包含头部串的最后一个字符)
2. 形式化描述:真前缀形如:$s_1s_2s_3\cdots s_{x};x=1,2,3,\cdots, t-1$
3. 在kmp算法中,这个概念和头部串和相似,$且字符串主要指的就是头部串h_t$
   1. 但是头部串是针对模式串P而言
      1. 头部串可以和模式串长度m相等
   2. 前缀(后缀)都是针对头部串$h_t$而言;
      1. 且真前后缀串长度都必小于对应的头部串长度$t$



##### 真前缀集合

1. 所有真前缀构成真前缀集合
2. $当t=1时,真前缀为空;(其实集合内的元素数量就是t-1)$😉

#### 真后缀(real postfix)

1. `形象描述`:$就是从字符串string的后x个字符(x<length(string))$
   1. 即从字符串的<u>最后</u>一个字符开始向前截取任意长度的子串(但是不可以包含头部串的第一个字符)

2. 真前缀形如:$\cdots s_ys_3s_{t};x=t-1,t-2,\cdots,2$

##### 真后缀集合

1. 所有后缀构成后缀集合
2. $当t=1时,后缀集合为空;(其实集合内的元素数量也是t-1)$😉



#### 长度为x的前缀/后缀

##### x_前缀

- $长度为x的前缀$:x_prefix

##### x_后缀

- 长度为x的后缀:x_postfix

##### x_prefix(s)==x_postfix(s)

- 表示字符串s的前x个字符序列和后x个字符序列完全一致完全相等的(而不仅仅是长度一致)



#### FAQ常见问题

1. 为什么这里不让前后缀的长度达到和模式串的p一样长?
   1. 因为如果让前后缀取得和模式串一样长,根据定义,会使得后面的`最长相等前后缀`会变得没有意义
   2. 即,最长相等前后缀的长度总是模式串的头部串$h_t$的长度t


#### kmp是么时候大展身手

1. 可以看出,当t取值越小,那么kmp算法下,模式串可以越大程度的滑动
2. 在brute-force朴素匹配算法中的最坏情况在kmp算法下变得无关紧要了(大展身手)
3. 相反,如果t很大(比如t=m-1),(模式串很有特点,比如重复性很强p=aaaa),就不会有太大提升

   

### 相等前后缀/(公共)前后缀epp

- 这里**相等**是指两个缀串完全一样,如果是两个串的子串之间的比较,相等的子串还还经常叫做**公共子串**

1. $对于同一个头部串h_t(长度为t)$
   1. 它的**前缀集合**和**后缀集合**各出一个元素,相等的元素对(pair)称为相等前后缀

2. 可以设计函数:`String equal_prefix_postfix(ht)`简单记为`epp(ht)`
   1. 返回计算好的集合/列表或者通过修改相关指针所指的容器
   2. 可以全部归到下面的`lepp()中实现`

### 最长相等前后缀(lepp)

1. 相等前后缀中最长的就是最长相等前后缀(**lepp**)

   1. 更具体的,是指某个字符串s的最长的公共前后缀,参数可以是字符串s
   2. 在本算法中,$s=h_t$, Lepp($h_t$)

2. 可以设计函数:`String longest_equal_prefix_postfix(ht)`简单记为`lepp(ht)`
   1. 返回值是最长的公共前后缀

   2. `可以通过调用epp()来实现`

   3. $返回h_t的最长相等前后缀长度值e_t=lepp(h_t)$

      



### 失配MF(MatchFailed)

1. $$
   假设失配发生在模式串p_1p_2p_3\cdots p_t,p_{t+1}\cdots p_{m-1}p_{m}中的p_{t+1}
   \\那么h_t=p_1p_2p_3\cdots p_t就是成功匹配上的那部分
   \\下面的讨论将聚焦在h_t串上
   $$

   

2. $$
   容易知道,h_t的长度t\leqslant m,即部分匹配的头部串h_t的长度不超过模式串p的长度
   \\这意味着,如果h_t的最长相等前后缀为k=e_t,那么模式串p在本次生失配的(于a_{t+1}处)
   \\后可以向后滑动k=slide(h_t)个位置,就是模式串移动到a_x处对齐..
   \\下面的图中两列括号中的元素数目相等均为k=e_t=leep(h_t)
   \\h_t=
   \begin{aligned}
   \cdots(&a_{i+1}a_{i+2}\cdots a_{i+k})&\cdots 
   &&(a_{x}\cdots a_{i+t-1} a_{i+t})&\cdots
   \\&(p_1p_2\cdots p_k)&\cdots 
   &&(p_{x}\cdots p_{t-1}p_{t})
   \\&(\underline{b_1b_2\cdots b_{k}})&\cdots 
   &&(\underline{b_1b_2\cdots b_{k-1}b_{k}})&\cdots b_m
   \end{aligned}
   $$
   
   
   $$
   设本次匹配从主串的s号字符开始(对应于a_{i+1},模式串p在失配后要移动到a_x(序号为s')处
   \\s'=s+(t-k)
   $$
   


$$
上面的示意图中所示,移动到a_x处,这是模式串可以向前推进的最大也是最合适的位置
   \\p_t之后的字符是失配部分(p_{t+1}\cdots),我们不关心
$$

-    但是,我们的最终目的并不是滑动模式串,最好是能够直接知道下一次比较从主串和模式串的何处开始
  - 因为对齐之后,我们还是要找合适的串内位置继续比较下去
  - 从上面的示意公式可以看出$b_1\sim b_k$是一定能够匹配上的,这就在滑动的基础上再次加速
  - 不需要做这一部分的比较,$直接从b_{k+1}开始和主串a_{i+t+1}继续往后比较$
    - s[s+t] cmp p[k+1]
- 这就引出了next数组

## next数组($\bigstar$)/部分匹配表(PM(partialMatch))

- 部分匹配表和next数组几乎是同一个东西(但是深究有些许差别)
  - 但是对于算法而言,两者都可以体现kmp的主要思想
  - 下面我将比较初步的表格成为部分匹配表PM;
  - 而将优化过的表成为next数组😀(在不做细分的情况下,PM表被当做Next数组)
    - next数组在不同上下文有不同的形式,但是基本是大同小异
    - 所有右面的代码基本就是用最原始的PM表(作为next数组)来实现算法

#### PM数组和next数组(optional)

- 这部分不是算法所必须的,而仅仅是提一下有PartialMatch部分匹配值这个东西
  - 后面的演示代码主要是将PM直接作为Next数组来使用了

- 根据前面的分析,当匹配过程比较到字符串的p[j]位置的时候发生失配,那么为了确定模式串需要移动多少个位置以便进行下一趟比较,靠的是失配前的那段模式串的头部串:p[0]~p[j-1]的最长前后缀值(也就是PM[j-1])
- 事实上,当模式串p[j]和主串失配时,有滑动位数计算公式:$Move=(j-1)-PM[j-1]$
  - 注意j这里是位序(编号),而不是下标,是从1开始计数的
  - PM[j-1]也理解为从PM[1]开始计数的暂不作为数组索引
- 而且根据公式看出PM[i]是在p[i+1]和主串失配的时候用的
  - 模式串的第1个字符)就和主串失配的时候,不需要计算滑动位置,直接就可以确定要移动一个位置
    - $move=1=(1-1)-PM[1-1]=-PM[0]$
    - $但是如果为形式上能够更加统一,我们可以虚拟出一个PM[0]=-1$
  - 另一方面,模式串失配字符最靠后的字符是p[m],而这时候失配我们需要的是PM[m-1],而用不上PM[m],再往后的话说明模式串整个的就被匹配上了,因此PM[m]是不需要的一个值,可以不算,也可以舍弃
- 有了上面的两点分析,我们可以将PM的值向右一定一位,并称呼此时的PM为next数组
  - 公式变为move=(j-1)-next[j]

#### PM表示例

| order(字符位序) | 1    | 2    | 3    | 4    | 5    | 6    | 7    |
| --------------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| p               | a    | b    | a    | a    | b    | a    | c    |
| PM[j]           | 0    | 0    | 1    | 1    | 2    | 3    | 0    |
| index(下标索引) | 0    | 1    | 2    | 3    | 4    | 5    | 6    |

- 下面依然按照位序的计数方式来描述(也就是说next数组和模式串的第一个元素分别是next[1]和p[1]开始)

- 对应的next数组:

  - 

  - | order(字符位序)                  | 1    | 2    | 3    | 4    | 5    | 6    | 7    |
    | -------------------------------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
    | p                                | a    | b    | a    | a    | b    | a    | c    |
    | $next1[j](从PM数组右移一位得到)$ | -1   | 0    | 0    | 1    | 1    | 2    | 3    |

    

  - | order(字符位序)                   | 1    | 2    | 3    | 4    | 5    | 6    | 7    |
    | --------------------------------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
    | p                                 | a    | b    | a    | a    | b    | a    | c    |
    | $next2[j](从next'所有元素+1得到)$ | 0    | 1    | 1    | 2    | 2    | 3    | 4    |

  - 此时,next[j]的含义是,当模式串的p[j]字符和主串(的s[i]字符处)失配时,下一趟比较从模式串的j=next[j]处继续比较就可以了

    - 事实上,用PM表既可以方便的得到next数组,又可以直接用于代码实现,它们的主要差异在于:
    - $j=PM[j-1]+1(访问的是失配前的一个)$
      - 在从PM[0],p[0]开始计数的代码实现中,`j=PM[j-1]`
    - $j=next_2[j]$
      - 在从next[0],p[0]开始计数的代码实现中,`j=next1[j]`
      - 

| order   | 1    | 2    | 3    | 4    | 5    | 6    |
| ------- | ---- | ---- | ---- | ---- | ---- | ---- |
| index   | 0    | 1    | 2    | 3    | 4    | 5    |
| p       | a    | b    | c    | a    | b    | d    |
| next[i] | 0    | 0    | 0    | 1    | 2    | 0    |

- $next数组是基于模式串p=p_1p_2\cdots p_m$

  - 其长度就是m

- next[x]:

  - $$
    模式串p的从P[0] 到 P[x] 这一段子串(即h_{x+1},其长度为x+1)中，
    \\前k=next[x]个字符与后k个字符是相等的,且取的k是最大的(如果有多个可能值)
    $$

  - 

  - 如此,当模式串的p[j]位置和主串的s[i]位置失配后(也即是匹配到p[j-1]是成功的,但是p[j]却失败了,

    - $$
      记k=next[x-1],表示h_x=p_1\cdots p_{x}=p[0]\sim p[x-1]这段字符串的
      \\最长相等前后缀长度为next[x-1]
      $$

      

    - $$
      而此时k=next[x-1]是一个长度值,
      \\他对应到字符串下标p[k-1]=p[next[x-1]-1]
      \\这个字符是我们知道一定会和主串的s[i-1]字符匹配上(属于已知),
      \\所以p[k]=p[next[x-1]]恰好是我们需要继续再和s[i]比较的字符(未知)
      \\(新一趟比较的起点)!
      $$

    - 根据之前的分析可知,这意味着下一次字符比较从模式串的$p[next[j-1]]$处开始

  - $此外,next[x]=length(lepp(h_{x+1}))$

  - $为了方便推导书写,可以将next[x]记为k[x]$

- 或者说,k=next[i] 表示 P[0] ~ P[i] 这一个子串(长度为i+1)，使得 **前k个字符**恰等于**后k个字符** 的最大的k

#### FAQ

- $那么为什么不是稍微往前一点的a_{x-1}或者是稍微往后的a_{x+1}?$


- 如果是前者,那么说明最长相等前后缀长度要长于k,
  否则在走完模式串前一定会发生失配
  并且失配位置会在模式串的第t个字符之前发生;
  - $因为我们计算h_t$的最长相等前后缀k,就是仅利用了模式串的前t个字符
    而实际上最长相等前后缀就是算好的k(而不是更大的值),
    因此模式串滑动到x之前的任意位置,都是徒劳的!

- 那么后者的问题又是什么呢?
  - 对的,这又可能使得我们漏掉第一个能够完整匹配模式串的位置,
    而返回可能使第二个或者更后面的匹配位置
    这显然不是我们想要的,我们要的是第一个能够匹配成功的位置,而且不应该会遗漏才是





- 有了上面概念的铺垫，下面引入PMT来描述kmp算法是如何让模式匹配变得高效
- 在算法导论中该表也被称为**模式串的预计算**表


1. $根据h_t,(其中t=1,2,\cdots m)分别求出lepp(h_t)$
3. $特别的,当失配发生时的lepp(h_t)=0,那么模式串将向后移动1个位置$

## 快速求解next数组

- 这是kmp算法的精髓
- next数组的计算方法不是唯一的有高效的也有低效的
- 下面讨论高效的求解方法

### 递推法

#### 相关事实

$$
s=h_t=\underset{\alpha^{[i]}_l}{\underbrace{p_1\cdots p_{k^{[j]}(t)} \cdots p_{k^{[3]}(t)} \cdots p_{k^{[2]}(t)}\cdots p_{k(t)}}}
\underset{中间元素m^{[i]}}{\underbrace{\cdots \cdots\cdots}}
\underset{\alpha^{[i]}_{r}}{\underbrace{p_1\cdots p_{k^{[j]}(t)} \cdots p_{k^{[3]}(t)} \cdots p_{k^{[2]}(t)}\cdots p_{k(t)}}}
\\
$$



$$
下面,我们定义一个叫做\underline{\phi划分操作}(简称\phi操作)的字符串操作:
\\\phi操作就是将给定的字符串s划分为三个区域,形如上面的划分
\\字符串h_t经过一次\phi操作后,得到\alpha_l^{[1]},m,\alpha_r^{[1]}
\\划分的根据是被划分字符串对象的(最长)相等前后缀的长度,\alpha^{[1]}长度为k^{[1]}(t)
\\其中k^{[1]}(t)就是长度为t的字符串h_t的最长相等前后缀长度
\\此处t从1开始计数
\\注意,中间元素m^{[i]}可能是0,而且相等前后缀\alpha之间可能互有重叠的部分
\\(不妨把此时的m(负值)描述为重叠长度)
$$


$$
\\
\\对一个字符串h执行第一次\phi划分操作,得到两个相等的串\alpha_l^{[1]},\alpha_r^{[1]}
\\其中上标[i]表示执行的是第i次\phi操作;
\\下标的1,2分别表示该次\phi操作下产生的相等的前(prefix)/后(postfix)缀
\\由于后缀和前缀的相等性,后续只讨论前缀
$$

$$
\\现在我们对串\alpha_l^{[1]}再次执行\phi操作,可以得到\alpha_l^{[2]},\alpha_r^{[2]}
\\再对\alpha_l^{[2]}执行\phi操作后,得到\alpha_l^{[3]},\alpha_r^{[3]}
\\ \vdots
\\对\alpha_l^{[i]}执行\phi操作后,得到\alpha_l^{[i+1]},\alpha_r^{[i+1]}
\\并且\alpha_l^{[i+1]},\alpha_r^{[i+1]}总是分布在\alpha^{[i]}的前后缀端上
\\
\\由于模式串的长度是有限的,因此总有一个时候\alpha_l^{[n]}=\alpha_l^{[n]}=\beta^{[n]}=空串
\\这种条件下,就停止\phi操作的嵌套
$$

$$
从上面的\phi操作的嵌套执行过程中,
\\考虑到所有同级别前后缀相等(\alpha_l^{[i]}=\alpha_r^{[i]}=\beta^{[i]})总是成立的
\\第1次(第1重)\phi操作:操作对象是字符串s=h_t的,产生的两个相等前后缀串标记为\beta^{[1]}
\\第2重\phi操作:对每个等于\beta^{[1]}的串执行\phi操作后均可得到\beta^{[2]},总共是2*2=2^2个\beta^{[2]}
\\第3重\phi操作:对每个等于\beta^{[2]}的串执行\phi操作后均可得到\beta^{[3]},总共是2^2*2=2^3个\beta^{[2]}
\\\vdots
\\将每一重的\phi操作结果画到下一层(将\beta^{[i]}的串作为一个节点),它们的分布就像是一颗满二叉树
\\并且,同一层(级别)的左子树和右子树具有完全一样的性质
\\(左子树可以的划分,右子树可以一致的重演(水平传递))
$$

- 

$$
基于上面的实时,容易知道h_t的左端\beta_1^{[i]}=\beta_2^{[i]}=\beta_{2^i}^{[i]}
\\\beta_1^{[i]}是h_t的前缀,\beta_{2^i}^{[i]}是h_t的后缀
$$




- 关键在于,$如果我们知道next[t-1],(以及next[t-2],...next[1],next[0]),怎么求解next[t]$


  - $也就是说,next[t]是待求的,next[x](x\leqslant t)是已知的$

  - 在后面的推导过程中,$我们有时将使用k(t)来表示next[t],来简化书写$
    - 此处t从0开始计数,是字符的下标(而非位序)
    - 这有点而像动态规划,利用已知规模问题输入的答案来加速求解未知规模的答案

  - $记now=next[t-1],那么根据定义,我们有:$

  

- $$
  \\模式串p=p_1p_2\cdots p_m
  \\首先h_t长度比h_{t-1}要长1(仅仅相差一个元素a_t)
  \\\\
  h_{t}=\underset{A串(前缀)}{\underline{(p[0]\cdots p[now-1]}})p[now]
  \cdots
  \underset{B串(后缀)}{\underline{(p[j]\cdots p[t-1])}}
  \\
  h_{t+1}=\underset{A串(前缀)}{\underline{(p[0]\cdots p[now-1]}})p[now]
  \cdots
  \underset{B串(后缀)}{\underline{(p[j]\cdots p[t-1])}}p[t]
  \\A串=B串
  $$


#### $p[now]=p[t]$

- $如果走运的话,那么next[t]=next[t-1]+1=now+1$

#### $p[now]\neq p[t]$


$$
\\关键在于,如果不走运的时候
\\根据最长相等前后缀的定义,我们发现,A=B
\\为了找到A'=B'
\\A'=A串尾向前收缩;
B'=B串首向后收缩
\\
$$



$$
因为A串=B串:
\\
\underset{A串}{\underline{(p[0]\cdots p[now-1])}}
=\underset{B串}{\underline{(p[t-now]\cdots p[t-1])}}
\\所以在串B中寻找p[y]=p[t]等价于在串A中寻找p[y]
\\现在我们把问题聚焦到了A串上(或者说A串的子串上)
\\这一点理解上的转变并非可有可无,集中起来有利于我对问题模型做抽象
$$

$$
\\这时候,我们刷新now=next[now-1]
\\反复执行上述过程,直到找到p[y]=p[t];
\\或者now缩减至0,根据定义,next[t]=0
$$

## 相关代码


  ```python
  # def kmp(text, p):
  #     len_text = len(text)
  #     len_p = len(text)
  
  
  def pre_calculate_next_recursive(p):
      #build the next array(the position update guider when the 'matche failed' events occur. )
      len_list = len(p)
      next = [0]  #next[0]总是0
      match_lenx = 1  #从next[1]开始求(区分不同的头部串)(指示next数组的填充进度)
      now = 0  #保存next数组的各个元素的值
      #注意两组关系:
      # p[x]&p[x-1];相邻的串尾两字符
      # 其中,p[0]~p[x-1]所对应最长相等前后缀长度为now=next[x-1]#next元素的简写
      #now=next[x-1]代表已知解的问题规模;next[x]是尚未求解的
      #字符p[now]=?=p[x]将决定next[x]=now+1=next[x-1]是否成立
  
      while match_lenx < len_list:  #需要填充len(p)个值才算完成next数组的构建
          # 下面三个分支两两互斥，每次循环只会进入其中的一条逻辑！！！
          if p[now] == p[match_lenx]:  # matched!(走运)
              #注意,在这个循环中,p[now] == p[match_lenx]的左边p[now]会在关系表达式False
              # 的时候变发生变化,直到这个比较表达式为True,match_lenx才会+1
              #或者now=0,单独强制让match_lenx+=1
              now += 1
              match_lenx += 1
              # this new  scale is calculated! it could be recorded into the next
              next.append(now)
          # mismatched:(不走运)
          # 尝试缩小now,然后进入到下一轮的比较计算
          elif now > 0:  # to iterate the length value
              now = next[now - 1]  # the now>=0
              #修改now,然后重新进入循环再判断
          else:  #now=0,意味着p[0]~p[match_lenx]前缀不可能在有能够和某个后缀相等了(或者说这是个相等缀长度为0)
              # explictly set the length value as 0 in this case
              next.append(0)
              match_lenx += 1
  
      return next
  
  
  def kmp_all(text, p):
      s = 0  # offset
      pp = 0  #模式串内字符的指针postion_to_continue(pointer_p)
      #首先要明确,pp的取值范围是0~len(p)-1
      len_p = len(p)
      cnt = 1  #计数匹配位成功的次数
      matched_locations = []  #收集匹配成功的位序字符位序(而非下标)
      next = pre_calculate_next_recursive(p)
      while s < len(text):
          # matched!
          #在这个循环体中,需要明确:
          # 我们把逻辑分为两大块
          #第一块中包含三小块互斥的分支(它们构成所有情况的集合的一种划分,囊括了所有可能)
          #因此,循环每趟执行只会且一定会,进入其中的一个分支
          #第二块代码和第一块代码相对独立(作为单独的一段逻辑存在)
          if text[s] == p[pp]:  #模式串的第[pp]处字符成功匹配
              # 准备比较下一位字符
              s += 1
              pp += 1
          #pp处失配,每前进一个字符,就需要检查整个模式串是否已经都匹配上了(第二块代码)
          #本循环的后面部分仅仅调整指针而不做比较操作(指针调整好后,比较留给下轮循环的开头代码)
          #那么p[:pp]段字符是成功匹配的(右开)从字符p[0]~p[pp-1]
          #通过访问next[pp-1],拿到k=lepp(p[:pp])
          #下一趟比较中,模式串的这部分长度p[:k](p[0]~p[k-1])不需要再比较了
          #直接从p[k]开始和主串(T[s]比较(这是新一轮循环的任务了)
          elif pp:  #pp>0
              # mismatched!模式串在下标为pp处的字符失配!
              # 借助于next数组调整下一次比较的字符位置指针(pp)
              pp = next[pp - 1]
              # 如果失配发生在pp==0的地方,那么lepp==0(next[0]==0总是确定的)
              #发生失配,并且,模式串的指针跳转到下一个合理位置(next[continue-1]),作为下次继续比较的地方
              # 注意到,这里的下标表达式pp-1>=0就要求pp>0
              #pp==0的时候要额外处理
          else:  #pp=0
              #第一个字符(p[pp]就失配了,那么主串的指示指针向后移动一个字符)
              s += 1
          # 判断是否已经找到了模式串要匹配的位置
  
          if pp == len(p):  #其中pp是指向下一位要比较的字符,如果匹配完成,那么pp=len(p)
              # print("place%d:" % cnt, (s - pp) + 1)
              #其中s-pp是匹配点的下标,转换为位置+1(从1开始计数)
              matched_locations.append(s - pp + 1)
              cnt += 1
              # 开始寻找下一个能够匹配模式串的位置
              pp = next[pp - 1]
              #或者 pp=next[len_p-1]#因为此时pp==len_p
      if matched_locations == []:
          print("matched failed!")
      return matched_locations
  
  
  def naive_text_matcher(str, p):
      len_str = len(str)
      len_p = len(p)
      matched_locations = []
      # for c in t[:n-m]:
      # start = 0
      last_start = len_str - len_p  #最后一趟需要比较的主串字符的下标
      for start in range(last_start + 1):
          if p == text[start:start + len_p]:
              # print("Matched!")
              res = start + 1  #返回的数值为从1开始计数的字符位置(order not index)
              # print(res)
              # return res
              matched_locations.append(res)
      if len(matched_locations) == 0:
          print("matched failed!")
          # return -1
      return matched_locations
      # 切片左闭右开区间
  
  
  def get_next_naive_bad(p):
      # 性能较差的next元素计算函数/构建函数
      len_p = len(p) - 1
      for i in range(len_p - 1):  #0,1,2,3,...
          print(i)
          print("p[len_p-i]", p[0:len_p - i], "p[i:len_p]", p[i + 1:])
          if p[:len_p - i] == p[i + 1:]:
              break
      res = len_p - i
      print("res", res)
      return res
  
  
  def get_next_naive(p, matched_size):
      """ 用户逐个计算next数组中的元素(相对对立地计算)next[x] 的函数调用
      从最长相等前后缀,从长试验到短,比较合适
      prefix=p[:size-1]->p[0:0]=''
      postfix=p[1:]->p[size-1:]
      """
      # x=len(p)
      for i in range(matched_size, 0, -1):
          # i=size,size-1,...,1
          if p[0:i] == p[matched_size - i + 1:matched_size + 1]:
              return i
              # break
      # 不存在相等前后缀,返回0
      return 0
  
  
  def test_by_naive():
      print("test by naive:")
      naive_text_matcher(text, p1)
      naive_text_matcher(text, p2)
  
  
  def test_by_kmp():
      print("test by kmp:")
      kmp(text, p4)
      kmp(text, p1)
      # kmp(text, p2)
  
  
  text = "teababaca_aaaeeaae_abaabac_1234_abaabac"
  # p = "ea"
  p1 = "eea"
  # p="aacaa"
  # p="aadabaadaadaa"
  # p = "acbabaca"
  p2 = "ababaca"
  p3 = "ababa"  #lepp=3
  p4 = "abaabac"
  ps = [p1, p2, p3, p4]
  
  
  # print(pre_calculate_next_recursive(p1))
  # print(kmp())
  def puts(s):
      print(s, end='')
  
  
  if __name__ == "__main__":
      # test_by_naive()
      # test_by_kmp()
  
      p = p4
      # next = [get_next_naive(p, x) for x in range(len(p))]
      # print(next)
      for p in ps:
          puts("by kmp: ")
          print(kmp_all(text, p))
          puts("by naive: ")
          print(naive_text_matcher(text, p))
  
  ```

  

### 输出

```
by kmp: [14]
by naive: [14]
by kmp: [3]
by naive: [3]
by kmp: [3]
by naive: [3]
by kmp: [20, 33]
by naive: [20, 33]
```
