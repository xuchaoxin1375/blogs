[toc]



## abstract

- Bernoulli概型是结合独立事件和n重Bernoulli试验概念的古典概型

## 伯努利概型

- Bernoulli概型是基于bernoulli试验的一类古典概型
- 这类概型的等可能性体现在$n$重Bernoulli试验种的各种结果出现的可能性相等,而单重Bernoulli试验的两种结果发生的概率不一定要相等

### 独立重复试验

- 把一随机试验**独立重复**做若干次,称为**独立重复试验**,即:

  - 各次试验所联系的**事件**之间**相互独立**

  - 同一**事件**在各个试验中出现的**概率相同**

    

## 伯努利试验

- 如果试验E的样本空间中只有两个对立样本点:$A,\overline{A}$,则试验E是**Bernoulli试验**
- 样本点概率关系:$P(A)=p$,则$P(\overline{A})=1-p$

### n重伯努利试验

- 如果把Bernoulli试验E**独立重复**做$n$次,将这$n$次构成一个**新试验**,这个新试验称为$n$重Bernoulli试验
- Note:
  - **重复**是指每次Bernoulli试验中$P(A)=p$保持不变
  - **独立**是指各次的试验结果互不影响
    - 若$C_i$表示第$i$次Bernoulli试验的结果,则$C_i\in\set{A,\overline{A}}$,$i=1,2,\cdots,n$;且$P(C_1\cdots{C_n})$=$P(C_1)\cdots{P(C_n)}$

  - 每重复完成n次基本试验,才能够算完成一次`n重伯努利试验`

- n重伯努利试验也叫**伯努利概型**,$记为E^n$

### 例

- 试验$E_1$是抛一枚硬币观察得到的正反面:$A,\overline{A}$分别表示结果为正面和反面
- 试验$E_2$是抛一个子,若$A$表示"得到1点",$\overline{A}$表示得到"非1点"
- $E_1,E_2$都是Bernoulli试验
- 如果将$E_1,E_2$各执行$n$次,得到各自的$n$重Bernoulli试验$E_1^{n},E_2^{n}$

#### 样本空间

- $E^{n}$的样本空间
  - 记$\omega_i$为第$i$次基本Bernoulli的试验结果,则$\omega_i\in\set{A,\overline{A}}$
  - 且某一次试验结果(样本点)可以表示为$\omega=(\omega_1\cdots \omega_n)$;
  - 并且,若$\omega$中的$n$次基本试验若出现了$k$个$A$,则剩余$n-k$个基本试验都是$\overline{A}$
  - 样本空间的样本数为$2^{n}$
    - $\omega_i$取值有2种,$i=1,\cdots,n$,所以$\omega$取值有$2^{n}$
    - 或者可以这样算:$\sum_{i=0}^{n}{\binom{n}{i}}$=$(1+1)^{n}$=$2^{n}$


#### 样本空间的重要划分

- 不妨把恰好出现$k$次$A$的$E^{n}$试验记为事件$B_{k}$,则$B_0,B_1,\cdots,B_n$构成$E^{n}$样本空间的一个划分
- 根据$\omega=(\omega_1\cdots \omega_n)$中$\omega_i,\omega_j$,$i\neq{j}$相互独立,若$\omega=(\omega_1\cdots \omega_n)$中有$k$个$A$,且$P(A)=p,P(\overline{A})=1-p=q$,$E^{n}$的样本点$\omega$发生的概率为
  - $P(\omega)=P(\omega_1\cdots \omega_n)=\prod_{i=1}^{n}P(\omega_i)$=$p^kq^{n-k}$,

#### 二项概率公式

- 若单重Bernoulli试验结果为$A$视为成功,则$n$重Bernoulli试验出现$k$次$A$视为成功$k$次,即$B_k$发生

- 事件$B_k$中包含的样本点数量为$\binom{n}{k}$,每个样本点发生的概率是相同的因此:
  - $P(B_k)=\binom{n}{k}p^kq^{n-k}$,称为二项概率公式($k=0,1,\cdots,n$)

- 可以为$B_k$加上其对应的Bernoulli试验的重数$n$,记为$B_{k}^{(n)}$或$B_k(n=4)$

- 显然$\bigcup_{i=0}^{n}B_i=S$,$P(\bigcup_{i=0}^{n}B_i)$=$\sum_{i=0}^{n}P(B_i)$=$\sum_{i=0}^{n}\binom{n}{i}p^{i}q^{n-i}$=1

### 例

- 利用$P(B_k)=\binom{n}{k}p^kq^{n-k}$,来计算一些具体问题

  - 设4次独立重复试验中,事件A至少出现一次的概率为0.5904
  - 那么3次独立试验中,事件A出现1次的概率?

- 解
  - $B_k^{n}$={在n次独立试验中事件A出现恰好地出现了k次}
  - 显然A在4次独立重复试验种出现0次(对应事件$B_0^{4}$的概率为$1-0.5904=0.4096$
  - 记:$P(A)=p$;
  - $P(B_0^{4})=\binom{4}{0}p^{0}q^{4}$=0.4096
    - $q^{4}$=$2^{12}\times{10^{-4}}$=$(2^{3})^{4}\times{(10^{-1})}^{4}$=$0.8^{4}$
    - 解得$q=0.8$,从而$p=0.2$

  - 那么3次独立试验中,事件A出现1次的概率:
    - $P(B_1^{3})$=$\binom{3}{1}p^1q^2=3*0.2*0.64=0.384$

### 例

- 投掷一枚硬币$2n$次,则出现正面的次数多于反面的次数的概率?
- 本试验有三种可能:
  - A:正面次数多于反面
  - B:正面次数和反面次数相等
  - C:正面次数少于反面次数
  - 显然$A,B,C$构成样本空间的一个划分
- 由于每次抛硬币正反面出现的概率都是$\frac{1}{2}$,$2n$次抛掷硬币后,$A,C$事件是等概率的,
- 又因为$P(B)$=$\binom{2n}{n}\frac{1}{2}^{n}\frac{1}{2}^{n}$,$P(A)+P(B)+P(C)=1$,即$2P(A)+P(B)=1$所以$P(A)=\frac{1}{2}(1-\binom{2n}{n}(\frac{1}{2})^{2n})$
- 事实上,$P(A)=\sum_{i=1}^{n}\binom{2n}{n+i}\frac{1}{2}^{n+i}\frac{1}{2}^{n-i}$;$P(C)=\sum_{i=0}^{n-1}\binom{2n}{i}\frac{1}{2}^{i}\frac{1}{2}^{2n-i}$
  - $\sum_{i=0}^{n-1}\binom{2n}{i}$=$\sum_{i=1}^{n}\binom{2n}{n+i}$


### 例

- 设甲乙两人投球中目标的概率分别为$0.8,0.6$
- 若两人各投3次,则事件$A$:两人投中次数相等的概率?
  - 投中次数可能为:$k$=0,1,2,3
- 设$B_i,C_i$:分别表示甲乙两人投中$i$个球,$\set{B_i;i\in{I}}$,$\set{C_i;i\in{I}}$,$I=\set{1,2,3}$都是样本空间的一个划分
- 则$A=\bigcup_{i=0}^{3}B_iC_i$,且$(B_iC_i)(B_jC_j)=$$(B_iB_j)(C_iC_j)$=$\emptyset$,$i\neq{j}$$;且因为$$B_i,C_i$是相互独立的所以:
  - $P(A)$=$\sum_{i=0}^{3}P(B_iC_i)$=$\sum_{i=0}^{3}P(B_i)P(C_i)$=$\sum_{i=0}^{3}(\binom{3}{i}0.8^{i}0.2^{3-i})(\binom{3}{i}0.6^{i}0.4^{3-i})$=$0.305$





### 例

- 同时抛两个色子
  - 事件A={出现的点数之和为7}
  - 事件B={出现的点数之和为9}

- 注意仅抛1次不一定$A,B$都不一定发生,可能需要抛$k$次,$A$或$B$才能发生

- 再令事件C={事件A比事件B先发生},求$C$发生的概率?

- 令试验为抛$k$次色子观察点数之和,以下三个事件包含了第k次抛色子的所有可能事件,构成了样本空间的一个划分

  - $A_k$={A在第k次试验时发生}
    - $P(A_k)=\frac{6}{36}=\frac{1}{6}$
      - (1,6);(2,5);(3,4);(4,3),(2,5),(6,1)共6种可能

  - $B_k$={B在第k次试验发生}
    - $P(B_k)=\frac{4}{36}=\frac{1}{9}$
      - (3,6);(4,5);(5,4);(6,3)共4种可能

  - $C_k$={A,B在第k次试验时都没有发生}
    - 则$C_k={\overline{A_k\cup B_k} }$=$\overline{A_k}\;\overline{B_k}$

    - $P(C_k)=1-P(\overline{C_k})=1-P(A_k\cup B_k)$=$1-(P(A_k)+P(B_k)-P(A_kB_k))$
    - 由于$A_k,B_k$之间互斥,$P(C_k)=1-(P(A_k)+P(B_k))=\frac{13}{18}$

  - 事件$C$发生可以列为以下**互斥事件**的并事件:

    - $A_1$
    - $C_1A_2$
    - $C_1C_2A_3$
    - $\cdots$
    - $C_1\cdots{C_{n-1}}A_n$
    - $\cdots$

  - 显然$A_1,\cdots,A_k$是**独立事件**它们发生的概率相等,均为$\frac{1}{6}$

  - 同理,$B_1,\cdots,B_k$发生的概率都是$\frac{1}{9}$;$C_1,\cdots,C_k$发生的概率都是$\frac{13}{18}$

  - 并且$A_{i},B_{j},C_{k}$,($i,j,k$互不相等)都是相互独立的(即第$i$次发生的结果不影响第$i+1$次及以后的试验的结果)

- $A_k,B_k,C_k,$构成了第k次试验的样本空间的一个划分,它们之间互不相容

- 令$T(k)=\left(\bigcap\limits_{i=0}^{k-1}C_i \right)A_k$;$k=1,\cdots$,且$C_0=1$,例如,$T(1)=A_1$;$T(3)=C_1C_2A_3$

- $$
  \\C=\bigcup\limits_{k=1}^{\infin}T(k)=\bigcup\limits_{k=1}^{\infin}
  \left(
      \left(
      \bigcap\limits_{i=0}^{k-1}C_i 
      \right)
      A_k
  \right)
  \\T(i)T(j)=\varnothing;i\neq j
  $$

- 则$P(C)=\sum\limits_{k=1}^{\infin}P(T(k))$,再根据独立事件的性质$P(T(k))=(\prod_{i=1}^{k-1}P(C_i))P(A_k)$=$(\frac{13}{18})^{k-1}\frac{1}{6}$
- $P(C)$=$\sum_{k=1}^{\infin}(\frac{13}{18})^{k-1}\frac{1}{6}$=$\frac{1}{6}\sum_{k=1}^{\infin}(\frac{13}{18})^{k-1}$=$\frac{1}{6}\frac{1}{1-\frac{13}{18}}$=$\frac{3}{5}$

- 事实上,任何一次试验,$P(A)=\frac{1}{6}$,$P(B)=\frac{1}{9}$;令事件D:$A$或$B$发生;则事件$C$所谓的$A$先于$B$发生就是所有D发生的情况下$A$发生而$B$不发生
- 从而$P(C)=\frac{\frac{1}{6}}{\frac{1}{6}+\frac{1}{9}}$=$\frac{3}{5}$


​        

### li

- 一条自动生产线连续生产$n$件产品不出故障(正常)的概率为关于$n$的函数$\frac{\lambda^{n}}{n!}e^{-\lambda}$,$n=0,1,\cdots,n$(其中$\lambda$是产线的某个稳定性指数)
- 假设产品的优质概率为$p(0<p<1)$,且产品间是否为优质品相互独立
  1. 生产线在两次故障之间共生产$k(k=0,1,2,\cdots)$件优质品的概率
  2. 若已知某两次故障间,该生产线生产了$k$件优质品,则该间隔内生产了$m$件产品的概率?
- Note:
  - 两次故障间的指的是某一段产线正常的一段时期
  - 产线故障则无法生产产品,否则总是能够生产优质品或者普通品质产品
  - 记$B_k$:两次故障件生产了$k$件优质品;$A_m$:两次故障件共生产了$m$件产品
  - 将试验规定为:观察两次故障间产生的样品数量,那么样本空间$S$=$\set{0,1,2\cdots}$
  - $A_0,A_1,\cdots$是$S$的一个划分,且$P(A_m)$=$\frac{\lambda^{m}}{m!}e^{-\lambda}$,$m=0,1,\cdots$
  - 显然,$k>m$是不可能发生的$P(B_k|A_m)=0$
    - $k\leqslant{m}$时$P(B_k|A_m)$=$\binom{m}{k}p^{k}q^{m-k}$,$q=1-p$
- (1):由全概率公式:$P(B_k)=\sum_{i=0}^{\infin}P(B_k|A_i)P(A_i)$=$\sum_{i=k}^{\infin}P(B_k|A_i)P(A_i)$=$\sum_{i=k}^{\infin}(\binom{i}{k}p^{k}q^{i-k})(\frac{\lambda^{i}}{i!}e^{-\lambda})$
  - =$\sum_{i=k}^{\infin}(\frac{i!}{k!(i-k)!}p^{k}q^{i-k})(\frac{\lambda^{i}}{i!}e^{-\lambda})$
  - =$\frac{e^{-\lambda}p^{k}}{k!}\sum_{i=k}^{\infin}\frac{\lambda^{i}}{(i-k)!}q^{i-k}$
  - 根据无穷级数$\sum_{i=0}^{\infin}\frac{x^{i}}{i!}$=$e^{x}$,$P(B_k)$=$\frac{(\lambda{p})^{k}}{k!}e^{-\lambda{p}}\sum_{i=k}^{\infin}\frac{(\lambda{{q}})^{i-k}}{(i-k)!}e^{-\lambda{q}}$;TODO
    - 令$j=i-k$,$i=k,k+1,\cdots$,所以$j=0,1,\cdots$
    - 其中$\sum_{i=k}^{\infin}\frac{(\lambda{{q}})^{i-k}}{(i-k)!}$=$\sum_{j=0}^{\infin}\frac{(\lambda{q})^{j}}{j!}$=$e^{\lambda{q}}$
    - $\sum_{i=k}^{\infin}\frac{(\lambda{{q}})^{i-k}}{(i-k)!}e^{-\lambda{q}}=1$
    - 所以$P(B_k)$=$\frac{(\lambda{p})^{k}}{k!}e^{-\lambda{p}}$,$k=0,1,2,\cdots$
- (2):当$m<k$时,$P(A_m|B_k)=0$
  - $m\geqslant{m}$时,$P(A_m|B_k)$=$\frac{P(A_m)P(B_k|A_m)}{P(B_k)}$=$\cdots$=$\frac{(\lambda{q})^{m-k}}{(m-k)!}e^{-\lambda{q}}$,$m=k,k+1,\cdots$







