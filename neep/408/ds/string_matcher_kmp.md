## ref

- 2Ruan Xingzhi

  

  - 4Ruan Xingzhi

- [2字符串匹配问题](https://www.ruanx.net/kmp/#-)

- [2Brute-Force](https://www.ruanx.net/kmp/#brute-force)

- [2Brute-Force的改进思路](https://www.ruanx.net/kmp/#brute-force-)

- [2跳过不可能成功的字符串比较](https://www.ruanx.net/kmp/#--1)

- [2next数组](https://www.ruanx.net/kmp/#next-)

- [2利用next数组进行匹配](https://www.ruanx.net/kmp/#-next-)

- [2快速求next数组](https://www.ruanx.net/kmp/#-next--1)

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

### 关键概念

### 主串T

1. 文本来源(算法输入的字符序列1)

### 模式串p

- 算法输入序列2

1. 需要在主串中找到的第一次出现位置的串(目标串)
2. $s_1s_2s_3\cdots s_{m-1}s_{m}$

#### 模式串长度m

1. $m=p.len表示模式串的长度$



### 部分匹配串PM(partialMatch)

### 头部串$h_t$

- <u>某个字符串</u>s的头部串是指:该字符串的前t个字符构成的序列

  - 这里字符串s作为头部串的主串

  - 它们具有不同的字符数t,它们形如:

    1. 我们把长度为t$的头部串记为h_t$
    2. $\bigstar h_t=s_1s_2s_3\cdots s_{t};t=1,2,3,\cdots, m$

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
   假设失配发生在模式串s_1s_2s_3\cdots s_t,s_{t+1}\cdots s_{m-1}s_{m}中的s_{t+1}
   \\那么h_t=s_1s_2s_3\cdots s_t就是成功匹配上的那部分
   \\下面的调理将聚焦在h_t串上
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
   \\&(s_1s_2\cdots s_k)&\cdots 
   &&(s_{x}\cdots s_{t-1}s_{t})
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
   \\s_t之后的字符是失配部分(s_{t+1}\cdots),我们不关心
$$

-    但是,我们的最终目的并不是滑动模式串,最好是能够直接知道下一次比较从主串和模式串的何处开始
  - 因为对齐之后,我们还是要找合适的串内位置继续比较下去
  - $从上面的示意公式可以看出b_1\sim b_k是一定能够匹配上的,这就滑动的基础上再次加速$
  - 不需要做这一部分的比较,$直接从b_{k+1}开始和主串a_{i+t+1}继续往后比较$
    - $s[s+t]cmp\ p[k+1]$
- 这就引出了next数组

## next数组($\bigstar$)

- $next[x] 定义为：对于模式串p的头部串h_x(x表示头部串长度)$
  -  $h_x的最长相等前后缀的长度值$
  - $next[x]=length(lepp(h_x))$
  - $为了方便推导,可以将next[x]记为k[x]$

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



### 部分匹配表:PMT(PartialMatchTable)/next数组

- 有了上面概念的铺垫，下面引入PMT来描述kmp算法是如何让模式匹配变得高效
- 在算法导论中该表也被称为**模式串的预计算**表


1. $根据h_t,(其中t=1,2,\cdots m)分别求出lepp(h_t)$
2. $这些lepp(h_t)构成PMT的主体$
3. $特别的,当失配发生时的lepp(h_t)=0,那么模式串将向后移动多少个位置$

|      |      |      |
| ---- | ---- | ---- |
|      |      |      |
|      |      |      |
|      |      |      |

## 快速求解next数组

- 这是kmp算法的精髓
- next数组的计算方法不是唯一的有高效的也有低效的
- 下面讨论高效的求解方法

#### 递推(递归)法

- 假设进行第m次匹配时,模式串的前t个字符($h_t$和主串匹配上了

- 那么$h_{t-1}肯定也是匹配上的$

- 关键在于,$如果我们知道next(t-1),怎么求解next(t)$

  - 在后面的推导过程中,$我们将使用k(t)来表示next(t),来简化书写$
    - 这有点而像动态规划,利用已知规模问题输入的答案来加速求解未知规模的答案

  - $记now=next(t-1),那么根据定义,我们有:$

  

- $$
  \\模式串p=s_1s_2\cdots s_m
  \\首先h_t长度比h_{t-1}要长1(仅仅相差一个元素a_t)
  \\\\
  h_{t-1}=\underset{A串(前缀)}{\underline{(s_1\cdots s_{k{(t-1)}})}}
  \cdots
  \underset{B串(后缀)}{\underline{(s_{j}\cdots s_{t-1})}}
  \\\\
  h_{t}=\underset{A串(前缀)}{\underline{(s_1\cdots s_{k{(t-1)}})}}s_{k(t-1)+1}
  \cdots
  \underset{B串(后缀)}{\underline{(s_{j}\cdots s_{t-1})}}s_{t}
  \\A串=B串
  $$

  
  $$
  \\如果走运的话,s_{t}=s_{k(t)+1},那么k(t)=k(t-1)+1
  \\关键在于,如果不走运(s_{t}\neq s_{k(t)+1}),那k_t会是多少?
  \\根据最长相等前后缀的定义,我们发现,A=B
  \\为了找到A'=B'
  \\A'=A串尾向前收缩;
  B'=B串首向后收缩
  \\
  $$
  
  $$
  \underset{A'串(前缀)}{\underline{(s_1\cdots s_{x-1}s_{x}} \cdots s_{k{(t-1)}})}
  \\\underset{B'串(后缀)}{(s_{j}\cdots \underline{s_y\cdots s_{t-1})s_{t}}}
  \\随着收缩A,B串的过程,我们有望找到的下一个使得
  \\s_1\cdots s_x=s_y\cdots s_t具有如下特点:
  $$

  
  $$
  \\h_t中可能存在满足这样条件的字符串,也可能不存在,
  但是如果存在,一定有
  \\但是我们可以确定s_1\cdots s_{x-1}=s_y\cdots s_{t-1}
  \\又因为A串=B串:
  \underset{A串}{\underline{(s_1\cdots s_{k{(t-1)}})}}
  =
  \underset{B串}{\underline{(s_{j}\cdots s_{t-1})}}
  \\所以在串B中寻找s_y等价于在串A中寻找s_y
  \\现在我们把问题聚焦到了A串上(或者说A串的子串上)
  \\这一点理解上的转变并非可有可无,集中起来有利于我对问题模型做抽象
  \\也许你已经发现,s_1\cdots s_{x-1}=s_y\cdots s_{t-1}就是\\
  h_{k(k(t-1))}的相等前后缀能够满足的条件
  $$
  
  $$
  \\(而收缩过程中,第一次遇到的一定是最长相等前后缀lepp)
  \\进而,串A中的字符s_x和串B之后的字符s_t相等与否确定了k(t-1)=k({t}-2)+1
  \\(lepp(h_t)=lepp(h_{t}-1)+1)能否成立
  \\next[t]=next[t-1]+1
  $$
  

  $$
  这样看来,递推关系变得明朗起来
  $$


  ```python
  def pre_calculate_next_list(pattern):
  
      len_list = len(pattern)
      next_list = []
      next_list.append(0)
      the_adding_char_index = 1
      current_len = 0
  
      while the_adding_char_index < len_list:
          if pattern[current_len] == pattern[the_adding_char_index]:  # matched!
              current_len += 1
              the_adding_char_index += 1
              # this new  scale is calculated! it could be recorded into the next_list
              next_list.append(current_len)
          # mismatched:
          else:
              if current_len:  # to iterate the length value
                  current_len = next_list[current_len - 1]  # the current_len>=0
              else:
                  # explictly set the length value as 0 in this case
                  next_list.append(0)
                  the_adding_char_index += 1
  
      return next_list
  ```

  



