## 数组元素位置&起始地址

### 二维数组(矩阵)

- 按行优先排列
- $m,n分别表示矩阵的行数和列数$
  - $i\in[0,m-1]是行下标的维界$
  - $j\in[0,n-1]是列下标的维界$
- $a_{i,j}表示矩阵中的第i行第j列元素$
  - 例如,$第一个元素坐标为a_{00}$
- $L表示数组中的元素占的存储单元数,比如字节数$
- $Loc(a_{i,j})表示元素a_{i,j}在内存中的起始地址$

### 一维数组

- 按行优先排列

- $m分别表示一维数组的维数$

  - $i\in[0,m-1]是行下标的维界$

- $a_{i}表示数组中下标为i的元素$

  - 例如,$第一个元素坐标为a_{0}$

- $L表示数组中的元素占的存储单元数,比如字节数$

- $Loc(a_{i})表示元素a_{i}在内存中的起始地址$

  - | a[0] | a[1] | a[2] | ...  | a[i] |      |      |
    | ---- | ---- | ---- | ---- | ---- | ---- | ---- |

  - $$
    Loc(a_1)=Loc(a_0)+1\times L
    \\一种不太准确的Loc(a_i)的理解:
    \\\underset{\underset{L}{\upharpoonleft}}{} \overbrace{a[0],\underbrace{a[1],\cdots,a[i-1]}_{i-1}}^{i个元素},\underset{\upharpoonleft}{}a[i],\cdots
    \\比较合适的理解Loc(a_i):
    \\\overbrace{{\underset{\upharpoonleft_{Loc}}{a[0]}},\underbrace{a[1],\cdots,a[i-1]}_{i-1}}^{i个元素},a[i],\cdots
    \\所以:
    Loc(a_i)=Loc(a_0)+i\times L
    $$

    

- $$
  Loc(a_i)=Loc(a_0)+i\times L
  $$

- $$
  Loc(a_{i,j})=Loc(a_{0,0})+i\times sizeof(row)+j\times L
  \\sizeof(raw)=m\times L
  \\Loc(a_{i,j})=Loc(a_{0,0})+ (i\times m+j)\times L
  $$

