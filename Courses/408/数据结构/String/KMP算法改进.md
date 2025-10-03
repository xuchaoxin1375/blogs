[toc]

ref

- [字符串匹配问题](https://www.ruanx.net/kmp/#-)

- [Brute-Force](https://www.ruanx.net/kmp/#brute-force)

- [brute-Force的改进思路](https://www.ruanx.net/kmp/#brute-force-)

- [跳过不可能成功的字符串比较](https://www.ruanx.net/kmp/#--1)

- [next数组](https://www.ruanx.net/kmp/#next-)

- [利用next数组进行匹配](https://www.ruanx.net/kmp/#-next-)

- [快速求next数组](https://www.ruanx.net/kmp/#-next--1)



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
-    这就引出了next数组



