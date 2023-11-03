[toc]

## 辗转相除法(欧几里得算法)简介

- [Euclidean algorithm - Wikipedia](https://en.wikipedia.org/wiki/Euclidean_algorithm)
- [辗转相除法和相关规律 -(wikipedia.org)](https://zh.wikipedia.org/zh-hans/輾轉相除法)
- **辗转相除法**，也被称为**欧几里得算法**，是一种用于求两个整数最大公约数的算法。
- 在数学中，辗转相除法，又称欧几里得算法（英语：Euclidean algorithm），是求最大公约数的算法。辗转相除法首次出现于欧几里得的《几何原本》（第VII卷，命题i和ii）中，而在中国则可以追溯至东汉出现的《九章算术》。
- 两个整数的**最大公约数**是能够同时整除它们的最大的正整数。
- 辗转相除法基于如下原理：<u>两个整数的最大公约数等于其中较小的数和两数相除余数的最大公约数</u>。
  - 例如，252和105的最大公约数是21（${\displaystyle 252=21\times 12;105=21\times 5}$） ；因为${\displaystyle 252-105=21\times (12-5)=147}$，所以147和105的最大公约数也是21。
  - 在这个过程中，较大的数缩小了 ，所以继续进行同样的计算可以不断缩小这两个数直至余数为零 。
  - 这时，所剩下的还没有变成零的数就是两数的最大公约数。
  - 由辗转相除法也可以推出，两数的最大公约数可以用两数的整数倍相加来表示，如${\displaystyle 21=5\times 105+(-2)\times 252}$。这个重要的结论叫做**贝祖定理**。

- 辗转相除法最早出现在欧几里得的《几何原本》中（大约公元前300年），所以它是现行的算法中历史最悠久的。
- 这个算法原先只用来处理自然数和几何长度（相当于正实数），但在19世纪，辗转相除法被推广至其他类型的数学对象，如高斯整数和**一元多项式**。由此，引申出欧几里得整环等等的一些现代抽象代数概念。后来，辗转相除法又扩展至其他数学领域，如纽结理论和多元多项式。

## 证明

### 带余除法描述



- 设数$a,b\neq{0}$分别是被除数和除数

- 由于$gcd(a,b)=gcd(b,a)$,不妨假设$a>b$

- 设$a=kb+c$,其中$k,c$分别是$a/b$的商和余数

- 这里用$f|g$表示$f$整除$g$,则$m|a$,$m|b$

- 记$a,b$的公因式构成的集合为$S_{ab}$,$b,c$的公因式构成的集合为$S_{bc}$

- $a=kb+c$(@)

  - 设$m$为$a,b$的公因子,则可分别设$a=a_1m,b=b_1m$,$a_1,b_1\in{\mathbb{Z^+}}$;式@改写为$a_1m=kb_1m+c$从而$c=(a_1-kb_1)m$,即$m|a,m|b,m|c$.有$S_{ab}\sube{S_{bc}}$
  - 设$n$为$b,c$的公因子,则可分别设$a=a_2n,b=b_2n$,$b_2,c_2\in{\mathbb{Z^+}}$;式@改写为$a=kb_2n+c_2n=(kb_2+c_2)n$,即$n|b,n|c,n|a$.有$S_{bc}\sube{S_{ab}}$
  - 从而$S_{ab}=S_{bc}$

- 因此$a,b$和$b,c$有共同的公因式



### 减法描述

- 辗转相除法的一个类似描述:两个整数的最大公约数等于**其中较小的数**和**两数的差**的最大公约数。
  - 设两个整数$a,b\in\mathbb{Z}$,令$M=\max(a,b);m=\min(a,b)$;$d=M-m$
  - 那么$gcd(a,b)=gcd(M,m)=gcd(m,d)$,其中$gcd(a,b)=gcd(b,a)$,表示a,b两数的最大公因子,参数位置交换不改变函数值
- 令设$M=M_1x,m=m_1x$,$M_1,m_1\in{\mathbb{Z}}$,即$x$表示$M,m$的公因子,$x$整除$a,b$,分别记为$x|m,x|M$
- 则$d=M-m=M_1x-m_1x=(M_1-m_1)x$,显然$x|d$
- 可见$m,M$的公因数$m$也是$m,d$的公因数
- 反之,设$y|d,y|m$;可设$d=M-m=d_2y$;$m=m_2y$,从而$M=m+d=(d_2+m_2)y$,显然$y|M$
- 可见$m,d$的公因子也是$m,M$的公因子
- 综上,$m,M$和$m,d$的公因子一致
- 在实际应用中,使用使用求余的方法代替减法更加高效

### 两种方式的对比

- 例如,$a,b$恰好满足$b|a$,即$gcd(a,b)=b$,那么根据求余方式,只需要判断$a\%b=0$是否成立,如果成立,则可立即结束算法
- 而使用减法可能需要多次辗转,特别是当$a,b$的大小相差很大,的时候,使用求余可以快速收缩两个数的规模,可以理解为减法的加快版本

## 算法步骤

- 以下是辗转相除法的步骤：

1. 将两个数中较大M的数除以较小的数m，得到余数$c_0$。
2. 将较小的数m和第一步得到的余数$c_0$进行同样的操作，即用较小的数m除以余数$c_0$，再得到一个新的余数$c_1$。
3. 重复第二步，直到余数为0。此时，最后一个非零余数就是两个原数的最大公约数。

- 例如，我们要求 48 和 18 的最大公约数：

  - $48 ÷ 18 = 2\cdots12$

  - $18 ÷ 12 = 1\cdots{6}$

  - $12 ÷ 6 = 2\cdots{0}$

  - 因此，48 和 18 的最大公约数是 6。
- 又比如,两个质数,$11,23$
  - $23/11=2\cdots{1}$
  - $11/1=11\cdots{0}$
  - 从而1是两个质数的最大公因子
- 直接使用求余号%计算$17,3$的最大公因子
  - $17\%3=2$
  - $3\%2=1$
  - $2\%1=0$
  - $gcd(17,3)=gcd(3,2)=gcd(2,1)$,由于$2\%1=0$,所以最终结果为1
- 如果使用加法的方式辗转,
  - $gcd(17,3)=gcd(14,3)=gcd(11,3)=gcd(8,3)=\cdots=gcd(2,3)=gcd(1,2)=gcd(1,1)=gcd(1,0)=1$





### 算法特点

- 在小学阶段,我们已经学过短除法来求解两个整数的最大公因子,这种方法在两个数都比较大的情况下效率较低
- 而使用欧几里得算法,可以大大提高效率,特别是两个数大小接近的时候,即便它们都很大,算法也可以快速求解最大公因子

### 应用

- 假设有2个数$a,b$,$(a>b)$
  - 则大小关系上有$a>b>c$
  - 约定数对$(a,b)>(m,n)$的条件是$a\geqslant{b}\geqslant{m}\geqslant{n}$
  - 结合规律$gcd(a,b)=gcd(b,c)$,我们把一组较大的数$a,b$的最大公因式求解问题转换为较小的$b,c$
  - 记$c_1=b\%c$
  - $gcd(b,c)=gcd(c,c_1)$
  - 类似的,最大公因子$G=gcd(a,b)=gcd=(b,c)=gcd(c,c_1)=\cdots=gcd(c_{t-1},c_t)$,其中$c_{t-1}\%c_{t}=0$;且最大公因子就是$c_t$

# 具体实现
## C语言

```c
/* gcd函数(低级的短除法) */
#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <string.h>
int gcd_Euclidian(int, int);
int gcd(int,int);

//gcd_Euclidian()
int gcd_Euclidian(int a,int b)
{
    /*Euclidian版的递归写法简单,但递归入口的操作数顺序可以举个例子来检验正确性.
    eg. 对同一组a,b
    ((a>b)时):gcd(8,6) = gcd(6,8%6 = 2) = 2;
    ((a<b)时):gcd(6,8) = gcd(8,6) 
    发现回到了a>b的情况.*/
    // 如果b是a的因子,则a,b的最大公因子为b
    if (a % b == 0)
    {
        return b;
    }
    //如果a是b的因子,则
    else
    {
        return gcd_Euclidian(b, a % b);
    }
}
//(短除法gcd函数:)
int gcd(int a,int b)
{
    int s = 1;
    for (int i = 2; i <= a && i <= b;/*因子i不可超过a,b中任一操作数*/ )
    {

        if (a % i == 0 && b % i == 0)/*i同时整除操作数a,b*/
        {
            //gcd *= i;
            s *= i;/*累乘*/
            /*更新两个操作数*/
            a /= i;
            b /= i;

        }
        else
        {
            i++;
        }

    }
    return s;
} 

int main(){
    int a,b;
    printf("input two integer 'a b' to calulate gcd:\n");
    while (scanf("%d%d", &a, &b) != EOF)
    {
        printf("gcd_short_division:%d\n", gcd(a, b));
        printf("gcd_Euclidian:%d\n", gcd_Euclidian(a, b));
    }
    
    return 0;
}
```

## python

### 朴素版

```python
def gcd_with_zero(a,b):
    """处理a,b中至少存在一个0的情况
    如果恰好有一个0,则返回非0的一方
    如果a=b=0,则抛出错误,此时不存在最大公因式
    如果ab!=0,则返回0,表示处于常规情况,将剩下的任务交给调用者处理
    0不会成为任何两个整数的最大公因子,且只有0本身的因子包含0,0作为公因子时,两个整数都是0

    Parameters
    ----------
    a : int
        第1个数
    b : int
        第2个数

    Returns
    -------
    int
        若输入合法,则返回最大公因子
        否则返回0,表示本函数未计算除最大公因式,需要调用者进一步处理

    Raises
    ------
    ValueError
        0,0不存在最大公因子,该情况应该抛出错误
    """
    if a==0:
        if b==0:
            raise ValueError("(0,0)has no greatest common divisor!")
        else:
            return b
    else: 
        #a!=0
        if b==0:
            return a
        else:
            # 常规的情况,交由调用者进一步处理
            return 0
            # 返回None

def gcd(a, b):
    """使用递归的方式利用欧几里得算法计算两个数的最大公约数(gcd(a,))
    其中,M,m的计算可以还这样实现
    M = a if a > b else b
    m = a if a < b else b

    Parameters
    ----------
    a : int
        第1个数
    b : int
        第2个数

    Returns
    -------
    int
        最大公约数
    """
    res=gcd_with_zero(a,b)
    if res :
        return res 
    
    M,m=max(a,b),min(a,b)
    c = M % m
    # [info]
    # print(f"{M=},{m=},{c=}")
    if c==0:
        return m
    else:
        return gcd(m, c)

##
# gcd(18,48)#6
# ##
# gcd(102,170)#34 
# ## 
# gcd(88,64)#8

test=[(18,48),(102,170),(88,64),(0,10),(12,0),(0,0)]

for p in test:
    print(f"{gcd(*p)}")



```

### 优化版

- 依然采用递归的方式实现

- 设需要计算最大公因子(gcd)的两个整数分别记为$a,b$,并且函数$gcd(x,y)$表示实现了计算$x,y$最大公因子的算法

- 通过分析欧几里得算法的停止条件可知,只有遇到整除的情况下才会结束算法

- 对于$c=a\%b$($ab\neq{0}$),可以确定$c<b$恒成立

- 设集合$I=\{0,1,2,\cdots,b-1\}$,则$c\in{I}$

  - case1:$c=0$,

    - 最理想的情况,只可能是$a\geqslant b$且$b|a$,($a=kb,k\in{\mathbb{N}^+}$),直接返回$b$作为$a,b$的最大公因式

  - case2:$c\neq{0}$,又包括两种可能:

    - 2.1:$a>b$但$a\nmid{b}$
      - 根据辗转相除法,设$r_{-1},r_0$分别表示$a,b$;$r_1,r_2,\cdots$分别是辗转相除过程中的各个余数
        - $r_{-1}=q_1r_0+r_1$
        - $r_{0}=q_2r_1+r_2$
        - $r_1=q_3r_2+r_3$
        - $\cdots$
        - $r_{i-2}=q_{i}r_{i-1}+r_{i}$
        - $\cdots$
        - $r_{s-1}=q_{s+1}r_s+r_{s+1}$,其中$r_s=gcd(r_{-1},r_{0})=gcd(r_1,r_2)=\cdots=gcd(r_{s-1},r_{s})$
        - 并且恒成立$r_{i+1}<r_{i},i\in{D}$,随着$i$的增大,$r_{i}$严格减小,且减小速度至少为$r_{i+1}-r_{i}\geqslant{1}$
        - 可见,如果某次调用$gcd(x,y)$时$x>y$,那么之后的递归调用参数总有$x>y$
        - 根据辗转相除法的性质,经过有限步的递归,可以保证存在$s$,使得$r_{s+1}=0$,$r_s$为最大公因子,在最后一次递归,问题转为case1
      - 因此,本情况的递归调用方式为$gcd(b,c)$
    - 2.2:$b<a$并且$c=a$
      - 该情况下,需要"交换"$a,b$位置,使"被除数"大于"除数",使得情况能够转化为case1和cases2.1中的一种
      - 即调用$gcd(b,a)$,又因为$c=a$,所以等价于调用$gcd(b,c)$
      - 因此,本情况的递归调用方式为$gcd(b,c)$
    - 综上所述,cases2下的两种可能最终都是调用$gcd(b,c)$

  - 根据上述分析,编写代码$a,b\neq{0}$情况下的最大公因子求解代码:

    - ```python
      def gcd(a,b):
      	c=a%b
          if c==0:
              return b
          else:
              return gcd(b,a%b)
      ```

      

  - 若$a<b$,交换参数位置重新调用$gcd(b,a)$,这样新的调用就转化为了$x>y$的情况

  - 

- ```python
  def gcd_Eucilidian_opt(a,b):
      """
      依然采用递归的方式实现
      通过分析欧几里得算法的停止条件可知,
      记c=a%b
      假设a>b,那么$c\in\{0,1,2,\cdots,b-1\}$
      否则b>a,那么$c=a$
  
  
      Parameters
      ----------
      a : int
          第1个整数
      b : int
          第2个整数
      """
      res=gcd_with_zero(a,b)
      if res :
          return res 
      
      c=a%b
      if c==0:
          return b
      else:
          return gcd_Eucilidian_opt(b,c)
  
  for p in test:
      print(f"{gcd_Eucilidian_opt(*p)}")
  ```

  

###  打印计算过程和示例






```python
gcd(77,70)
```

    M=77,m=70,c=7
    M=70,m=7,c=0





    7




```python
gcd(75,72)
```

    M=75,m=72,c=3
    M=72,m=3,c=0





    3




```python
gcd(102,170)
```

    M=170,m=102,c=68
    M=102,m=68,c=34
    M=68,m=34,c=0





    34




```python
gcd(102,102)
```

    M=102,m=102,c=0





    102




```python
gcd(16,102)
```

    M=102,m=16,c=6
    M=16,m=6,c=4
    M=6,m=4,c=2
    M=4,m=2,c=0





    2




```python
gcd(17,102)
```

    M=102,m=17,c=0





    17
