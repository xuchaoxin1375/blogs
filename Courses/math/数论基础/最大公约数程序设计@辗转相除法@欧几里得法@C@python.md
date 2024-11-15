[toc]

## abstract

程序设计中使用辗转相除法(欧几里得法)计算给定的两个数的最大公因数时,可以利用取模运算(快速计算余数)以及递归的方式推进计算

相关理论或算法原理参考数论中的最大公约数部分

主要利用辗转相除法将函数计算方式推进为同一个函数操作两个更小操作数(问题规模)都变得越来越小,可以考虑递归的方法)

包括C,python语言版本



## C语言

```c
/* 函数(低级的短除法) */
#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <string.h>
int _Euclidian(int, int);
int (int,int);

//_Euclidian()
int _Euclidian(int a,int b)
{
    /*Euclidian版的递归写法简单,但递归入口的操作数顺序可以举个例子来检验正确性.
    eg. 对同一组a,b
    ((a>b)时):(8,6) = (6,8%6 = 2) = 2;
    ((a<b)时):(6,8) = (8,6) 
    发现回到了a>b的情况.*/
    // 如果b是a的因子,则a,b的最大公约数为b
    if (a % b == 0)
    {
        return b;
    }
    //如果a是b的因子,则
    else
    {
        return _Euclidian(b, a % b);
    }
}
//(短除法函数:)
int (int a,int b)
{
    int s = 1;
    for (int i = 2; i <= a && i <= b;/*因子i不可超过a,b中任一操作数*/ )
    {

        if (a % i == 0 && b % i == 0)/*i同时整除操作数a,b*/
        {
            // *= i;
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
    printf("input two integer 'a b' to calulate :\n");
    while (scanf("%d%d", &a, &b) != EOF)
    {
        printf("_short_division:%d\n", (a, b));
        printf("_Euclidian:%d\n", _Euclidian(a, b));
    }
    
    return 0;
}
```

## python

### 朴素版

```python
def _with_zero(a,b):
    """处理a,b中至少存在一个0的情况
    如果恰好有一个0,则返回非0的一方
    如果a=b=0,则抛出错误,此时不存在最大公约数
    如果ab!=0,则返回0,表示处于常规情况,将剩下的任务交给调用者处理
    0不会成为任何两个整数的最大公约数,且只有0本身的因子包含0,0作为公约数时,两个整数都是0

    Parameters
    ----------
    a : int
        第1个数
    b : int
        第2个数

    Returns
    -------
    int
        若输入合法,则返回最大公约数
        否则返回0,表示本函数未计算除最大公约数,需要调用者进一步处理

    Raises
    ------
    ValueError
        0,0不存在最大公约数,该情况应该抛出错误
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

def (a, b):
    """使用递归的方式利用欧几里得算法计算两个数的最大公约数((a,))
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
    res=_with_zero(a,b)
    if res :
        return res 
    
    M,m=max(a,b),min(a,b)
    c = M % m
    # [info]
    # print(f"{M=},{m=},{c=}")
    if c==0:
        return m
    else:
        return (m, c)

##
# (18,48)#6
# ##
# (102,170)#34 
# ## 
# (88,64)#8

test=[(18,48),(102,170),(88,64),(0,10),(12,0),(0,0)]

for p in test:
    print(f"{(*p)}")



```

### 优化版

- 依然采用递归的方式实现

- 设需要计算最大公约数()的两个整数分别记为$a,b$,并且函数$(x,y)$表示实现了计算$x,y$最大公约数的算法

- 通过分析欧几里得算法的停止条件可知,只有遇到整除的情况下才会结束算法

- 对于$c=a\%b$($ab\neq{0}$),可以确定$c<b$恒成立

- 设集合$I=\{0,1,2,\cdots,b-1\}$,则$c\in{I}$

  - case1:$c=0$,

    - 最理想的情况,只可能是$a\geqslant b$且$b|a$,($a=kb,k\in{\mathbb{N}^+}$),直接返回$b$作为$a,b$的最大公约数

  - case2:$c\neq{0}$,又包括两种可能:

    - 2.1:$a>b$但$a\nmid{b}$
      - 根据辗转相除法,设$r_{-1},r_0$分别表示$a,b$;$r_1,r_2,\cdots$分别是辗转相除过程中的各个余数
        - $r_{-1}=q_1r_0+r_1$
        - $r_{0}=q_2r_1+r_2$
        - $r_1=q_3r_2+r_3$
        - $\cdots$
        - $r_{i-2}=q_{i}r_{i-1}+r_{i}$
        - $\cdots$
        - $r_{s-1}=q_{s+1}r_s+r_{s+1}$,其中$r_s=(r_{-1},r_{0})=(r_1,r_2)=\cdots=(r_{s-1},r_{s})$
        - 并且恒成立$r_{i+1}<r_{i},i\in{D}$,随着$i$的增大,$r_{i}$严格减小,且减小速度至少为$r_{i+1}-r_{i}\geqslant{1}$
        - 可见,如果某次调用$(x,y)$时$x>y$,那么之后的递归调用参数总有$x>y$
        - 根据辗转相除法的性质,经过有限步的递归,可以保证存在$s$,使得$r_{s+1}=0$,$r_s$为最大公约数,在最后一次递归,问题转为case1
      - 因此,本情况的递归调用方式为$(b,c)$
    - 2.2:$b<a$并且$c=a$
      - 该情况下,需要"交换"$a,b$位置,使"被除数"大于"除数",使得情况能够转化为case1和cases2.1中的一种
      - 即调用$(b,a)$,又因为$c=a$,所以等价于调用$(b,c)$
      - 因此,本情况的递归调用方式为$(b,c)$
    - 综上所述,cases2下的两种可能最终都是调用$(b,c)$

  - 根据上述分析,编写代码$a,b\neq{0}$情况下的最大公约数求解代码:

    - ```python
      def (a,b):
      	c=a%b
          if c==0:
              return b
          else:
              return (b,a%b)
      ```

      

  - 若$a<b$,交换参数位置重新调用$(b,a)$,这样新的调用就转化为了$x>y$的情况

  - 

- ```python
  def _Eucilidian_opt(a,b):
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
      res=_with_zero(a,b)
      if res :
          return res 
      
      c=a%b
      if c==0:
          return b
      else:
          return _Eucilidian_opt(b,c)
  
  for p in test:
      print(f"{_Eucilidian_opt(*p)}")
  ```

  