[toc]

## 互质

- 互质（英文：Coprime，符号：⊥，又称互素、relatively prime、mutually prime、co-prime)。
- 在数论中，如果**两个或两个以上的整数**的最大公约数是1，则称它们为**互质**。
- **公约数**(公因数)只有1的两个**整数**，叫做**互质整数**。
- 两个整数a与b互素,$gcd(a,b)=1$，记为$a\perp{b}$
- 依此定义：
  - 如果数域是**正整数**${\mathbb  {N^{+}}}$，那么1与所有正整数互素。
  - 如果数域是**整数** $\mathbb {Z}$，那么1和-1与所有整数互素，而且它们是仅有**与0互素**的整数。
- [公约数](https://baike.baidu.com/item/公约数/1063409?fromModule=lemma_inlink)只有1的两个[自然数](https://baike.baidu.com/item/自然数/385394?fromModule=lemma_inlink)，叫做**互质自然数**
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

- python实现

  - 最大公因数

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

    

  - 最小公倍数

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

    

