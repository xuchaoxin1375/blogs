[toc]

## 互质

- 互质（英文：Coprime，符号：⊥，又称互素、relatively prime、mutually prime、co-prime)。
- 在数论中，如果**两个或两个以上的整数**的最大公约数是1，则称它们为**互质**。
- **公约数**(公因数)只有1的两个**整数**，叫做**互质整数**。
- 两个整数a与b互素,$gcd(a,b)=1$，记为$a\perp{b}$
- 依此定义：
  - 如果数域是**正整数**${\mathbb  {N^{+}}}$，那么1与所有正整数互素。
  - 如果数域是**整数** $\mathbb {Z}$，那么1和-1与所有整数互素，而且它们是仅有**与0互素**的整数。
- 公约数只有1的两个自然数，叫做**互质自然数**
- 互质的两个数a,b不要求它们本身是质数,例如9和10
- 如果已知a,b都是质数,那么a,b一定互质

## 最小公倍数求法

- 最小公倍数,lowest common multiple,简记为$lcm$

- 设整数$a,b$

  - 最小公倍数范围取值$lcm(a,b)\in[\max{(a,b)},ab]$
  - 例如:
    - lcm(3,4)=12
    - lcm(6,8)=24

- 借助最大公因式的高效求法:

  - $d=gcd(a,b)$
  - $e=lcm(a,b)=d\cdot lcm(a/d,b/d)$
    - 因为$a_1=a/d$,$b_1=b/d$是互质的(否则$d$就不是最大公因数)
    - 显然$a=a_1d$,$b=b_1d$
    - 两个互质的数$a_1,b_1$的最小公倍数就是它们的乘积$a_1b_1$
    - $e=da_1a_2$,$a|e,b|e$(符号$x|y$表示$x$整除$y$)


### python实现

#### 最大公因数

```python


def gcd_Eucilidian_opt(a,b):
    """
    依然采用递归的方式实现
    通过分析欧几里得算法的停止条件可知,

	Parameters
    ----------
    a : int
        第1个整数
    b : int
        第2个整数
    """    
    c=a%b
    if c==0:
        return b
    else:
        return gcd_Eucilidian_opt(b,c)
# 简写函数名
gcd=gcd_Eucilidian_opt
```



#### 最小公倍数

```python

def validate_integer(*args):
    """判断若干个数是否全为整数,如果是,则返回True,否则返回False

    Returns
    -------
    bool
        是否为整数的布尔值
    """
    # print(args)
    for x in args:
        if type(x) is not int:
            return False
    return True

def lcm(a,b):
    """借助最大公因式求解最小公倍数

    Parameters
    ----------
    a : int
        整数1
    b : int
        整数2

    Returns
    -------
    int
        最大公因数
    """
    if(not validate_integer(a,b)):
        raise TypeError(f"{a},{b} are not all integer!")
    d=gcd(a,b)
    a1=a/d
    b1=b/d
    return int(d*a1*b1) 
##
lcm(99,66)
```

## 整数的整除问题

- 若$a|b$,$a\nmid{c}$,则$a\nmid (b+c)$
- 证明:由条件,$b$除以$a$的商为整数,且余数为0;而$c$除以$a$的余数不为0(商不是整数)
  - $b+c$除以$a$,即$(b+c)/a$=$b/a+c/a$第一项结果为整数,而$c/a$不是整数;
  - 考虑到整数加上一个非整数,结果不是整数,从而$(b+c)/a$余数不为0,结论成立
- 补充:
  - 而$c\nmid{b}$,$a\nmid{c}$时,$a|(b+c)$是否成立无法直接判定(因为$b+c$可能是$c$的整数倍)
  - 而$c|{b}$,$a|{c}$时,$a|(b+c)$一定成立(因为$(b+c)/a$余数一定为0)

## 生成所有公倍数👺

- 给定两个正整数$a,b$,生成它们的所有公倍数的公式?
  - 最小公倍数生成规律
  - 设$n_0$是$a,b$的最小公倍数,则$kn_0$,$k\in{\mathbb{Z}}$可以给出所有$a,b$的公倍数
  
- 证明:
  - 设$n_0$是$a,b$的最小公倍数,则$a|n_0$,$b|n_0$,其中$a|n$表示$a$能整除$n$;并用$a\nmid{n}$表示$a$不能整除$n$
  - 设$0<n_1<n_0$,则$a\nmid{n_1}$或 $b\nmid{n_1}$;即$n_1$不是$a,b$的公倍数`(0)`;从而$(a\nmid{n_0+n_1})$ 或${(b\nmid{n_0+n_1})}$,即$n_0+n_1$不是$a,b$的公倍数`(1)`
    - 尽管$n_1$可能是$a$或$b$中的某一个的整数倍,但不会同时是$a,b$的整数倍,否则$n_0$就不是$a,b$的最小公倍数,造成矛盾
  - 而$n_0+n_0$显然是$a,b$的公倍数,并且是除了$n_0$外的最小的公倍数,更一般的,$kn_{0}+n_1$不是$a,b$的公倍数`(1-1)`;实际上都归结于条件(0)
  - 同理,若$n_i$是$a,b$的公倍数,则$n_j=n_i+n_0$仍然是$a,b$公倍数但$n_i+n_1$不是$a,b$公倍数`(1-2)`
  - 因此,对于任意$n_2$,若$n_0\nmid{n_2}$`(2)`,则$n_{i_1}+n_2$和$n_{i_2}+n_1$都不是$a,b$的公倍数
    - 其中$n_{i_1},n_{i_2}$都是$n_0$的整数倍,也就必然是$a,b$的整数倍
    - 而由条件(2),$n_{2}$不是$n_{0}$的整数倍,也就不是$a,b$的公倍数
  - 所以$a,b$的所有公倍数必定形如$n_0+kn_0$,$k\in\mathbb{Z}$,即{$kn_0$|$k\in\mathbb{Z}$}是所有$a,b$的公倍数的集合
- 这个结论在计算许多概率问题很有用

