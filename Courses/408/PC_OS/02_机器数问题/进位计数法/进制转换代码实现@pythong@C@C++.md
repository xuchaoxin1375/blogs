[toc]

## abstract

- 进制转换理论部分另见它文

## 进制转换计算器

许多计算器自带进制转换功能(程序员计算器)

例如windows之后的计算器自带的计算器

而这里给出一个基于上述理论的简单实现,支持常见进制数间的转换,以及小数进制转换,代码基于python编写

### 进制转换相关参考代码(py)

- ```python
  #本代码试图实现16进制内的数进制转换(r1->r2)
  ##包括对整数部分和小数部分的处理
  ## 基础函数包括是10进制转r进制
  ## r进制转10进制
  #基本思想是,将r1进制转换为10进制,z10进制转为r2进制
  d_16 = {10: "A", 11: "B"}
  for i in range(10, 16):
      c = chr(ord('A') - 10 + i)
      d_16[i] = c
      d_16[c] = i
  print(d_16)
  # 对十进制内的各进制数进行转换
  #16进制由于引入了A~F6个英文字母,需要额外处理,但是算法核心没有变
  dotted_line = "\n============================\n"
  
  
  def separate_outputs(separator=dotted_line):
      print(dotted_line)
  
  
  def puts(strx):
      print(strx, end="")
  def ten_to_r_Z(Z, r):
      """十进制数的小数部分转换为为r进制
  
      Parameters
      ----------
      F : int
          被转换的十进制数的小数部分
      r : int
          目标进制数(基数)
  
      Returns
      -------
      list
          目标进制(r)的结果(各个数位上的数码)
      """
      i = 0
      res = []
      remainder = Z // r**i
      while (remainder):
          next_bit = remainder % r
          if (next_bit > 9):
              next_bit = d_16[next_bit]
          res.append(next_bit)
          i += 1
          remainder = Z // r**i
      res.reverse()
      return res
      # puts(res)
  
  
  def ten_to_r_F(F, r):
      """十进制数的小数部分转换为为r进制
  
      Parameters
      ----------
      F : float
          被转换的十进制数的小数部分
      r : int
          目标进制数(基数)
          
  
      Returns
      -------
      list
          目标进制(r)的结果(各个数位上的数码)
      """
      i = 1
      # print(F)
      res = []
      remainder = 1
      while (remainder):
          dividend = F * r**i
          next_bit = (int(dividend) % r)
          if (next_bit > 9):
              next_bit = d_16[next_bit]
          res.append(next_bit)
          i += 1
          # is_continue = F * r**i % r
          remainder = dividend - int(dividend)
      return res
      # puts(res)
  
  
  def ten_to_r(S, r):
      """将十进制数转换为r进制数
  
      Parameters
      ----------
      S : float(int)
          被转换的十进制数数
      r : int
          目标进制
          
  
      Returns
      -------
      list
          转换完成后的r进制数的各个数码(从高位到低位,列表中包含一个小数点(字符))
      """
      Z = int(S)
      F = S - Z
      Zr = ten_to_r_Z(Z, r)
      # puts(".")
      Fr = ten_to_r_F(F, r)
      res = Zr + ["."] + Fr
      # print(res)
      return res
  
  
  def r_to_ten(S, r):
      """将r进制数转换为10进制数r不超过16
  
      Parameters
      ----------
      S : list
          需要转换的数的字符化列表
      r : int
          被转换的数的进制
      Returns
      -------
      float
          r进制数(列表)转换为十进制数的结果
      """
  
      # Sr=list(Sr)
      index_dot = len(S)
      if ('.' in S):
          index_dot = S.index(".")
          S.remove(".")
      # Z=S[:index_dot]
      # F=S[index_dot+1:]
      # print(Z,F)
      S10 = 0
      # i=1
      # for zi in Z:
      #     S10+=r**(len(Z)-i)*int(zi)
      #     i+=1
      i = 1
      for si in S:
          # print("current:si=:",si)
          if (si in d_16.keys()):
              si = d_16[si]
              # print("changed to ten si:=",si)
  
          S10 += r**(index_dot - i) * int(si)
          # puts(S10)
          i += 1
      # print(S10)
      return S10
  
  
  def r1_to_r2(Sr1, r1=16, r2=10):
      """r1进制转为r2进制(不超过16进制)
  
      Parameters
      ----------
      Sr1 : float(int) 
          被转换的r1进制数
      r1 : int
          Sr1的进制
      r2 : int
          转换目标进制
  
      Returns
      -------
      list[str]
          转换结果(各个位上的数码(以及小数点))
      """
      Sr1 = list(str(Sr1))
      # print(Sr1)
      S10 = r_to_ten(Sr1, r1)
      res = ten_to_r(S10, r2)
      # print("res:",res)
      return res
  
  
  def test(S10):
      print("example :将10进制的", S10, "转换为二进制和八进制")
      print("")
      puts("2进制:")
      S2 = ten_to_r(S10, 2)
      generator_S2 = map(lambda i: puts(i), S2)
      list(generator_S2)
      separate_outputs()
      puts("8进制:")
      S8 = ten_to_r(S10, 8)
      list(map(lambda i: puts(i), S8))
      separate_outputs()
      puts("16进制:")
      S16 = ten_to_r(S10, 16)
      list(map(lambda i: puts(i), S16))
      separate_outputs()
      print("将上述结果转换为十进制来验证:")
      puts("2->10:")
      print(r_to_ten(S2, 2))
      puts("8->10:")
      print(r_to_ten(S8, 8))
      puts("16->10:")
      print(r_to_ten(S16, 16))
  
  if __name__ == "__main__":
      # ten_to_r_Z(Z, r2)
      # ten_to_r_F(F, r)
      S10 = 123.6875
      S2_1 = 11111
      S2_2 = 1011
      S16 = "7B.B"
      test(S10)
  
      separate_outputs()
  
      #todo 解决123.88问题(16进制)
      # res = r1_to_r2(S, 2, 13)
      print("r1进制转换为r2进制:")
      print(S16, "16->8:")
      res = r1_to_r2(S16, r1=16, r2=8)
      res_str = "".join(map(lambda x: str(x), res))
      print(res_str)
      print(S2_1, "2->8:")
      res = r1_to_r2(S2_1, 2, 8)
      res_str = "".join(map(lambda x: str(x), res))
      print(res_str)
  
  ```

  

### 简化版本(py)(十进制数转二进制)

```py
a = 11
b = 33
c = 100
d = 123.6875
e = 12345
l = [ a, b, c, d, e]


# print(a)
def puts(string):
    print(string, end="")


def next_bit_z(a):
    """将输入的参数转换为二进制
    由于除基取余法在输出的时候要逆序输出,这里采用递归的方式,可以恰好的逆序输出

    Parameters
    ----------
    a : int
        输入的需要转化为二进制的整数
    """
    if (a > 0):
        quotient = a // 2
        next_bit_z(quotient)
        puts(a % 2)
    # else:
    #     print()


def next_bit_f(a):
    """将给定的纯小数转化为无符号二进制纯小数
    成基取整法是顺序输出的,这里将递归安排在打印之后,也可以做到顺序输出
    Parameters
    ----------
    a : float
        需要转换为二进制小数的十进制小数
    """
    fraction = a - int(a)
    if (fraction > 0):
        a = a * 2
        puts(int(a) % 2)
        next_bit_f(a)


def next_bit(a):
    next_bit_z(int(a))
    if (a % 1 != 0):
        puts(".")
    next_bit_f(a - int(a))


def ten_to_bin(a):
    next_bit(a)
    print()


if __name__ == "__main__":
    # next_bit(a)
    # next_bit(d)
    list(map(lambda x: ten_to_bin(x), l))

```

输出

- ```bash
  1
  1011
  100001
  1100100
  1111011.1011
  11000000111001
  ```


## C

用一段代码来介绍

```c
#include <stdio.h>

void printBinary(int num) {
    for (int i = sizeof(int) * 8 - 1; i >= 0; i--) {
        printf("%d", (num >> i) & 1);
    }
    printf("\n");
}

void printOctal(int num) {
    printf("Octal: %o\n", num);
}

void printDecimal(int num) {
    printf("Decimal: %d\n", num);
}

void printHexadecimal(int num) {
    printf("Hexadecimal (lowercase): %x\n", num);
    printf("Hexadecimal (uppercase): %X\n", num);
}

int main() {
    int number = 42;
    
    printBinary(number);
    printOctal(number);
    printDecimal(number);
    printHexadecimal(number);

    return 0;
}
```

### 二进制转换



```c
void printBinary(int num) {
    for (int i = sizeof(int) * 8 - 1; i >= 0; i--) {
        printf("%d", (num >> i) & 1);
    }
    printf("\n");
}
```

#### `for` 循环

```c
for (int i = sizeof(int) * 8 - 1; i >= 0; i--)
```

- `int i = sizeof(int) * 8 - 1`：初始化循环变量 `i`，其值为 `sizeof(int) * 8 - 1`。`sizeof(int)` 返回 `int` 类型的大小（通常是 4 字节），乘以 8 得到 `int` 类型的总位数（通常是 32 位）。减去 1 后得到最高位的索引（通常是 31）。
- `i >= 0`：循环条件，确保 `i` 从 31 递减到 0。
- `i--`：每次循环后将 `i` 减 1。

#### 位操作与打印

```c
printf("%d", (num >> i) & 1);
```

- `num >> i`：将 `num` 右移 `i` 位。右移位操作符 `>>` 会将 `num` 的二进制表示向右移动 `i` 位，高位补零。例如，如果 `num` 是 `42`（二进制 `101010`），当 `i` 为 `2` 时，`num >> 2` 的结果是 `10`（二进制 `1010`）。
- `(num >> i) & 1`：对右移后的结果与 `1` 进行按位与操作。按位与操作符 `&` 只保留最低位的值，其他位都置为 `0`。这相当于提取右移后的结果的最低位。例如，如果 `num >> i` 的结果是 `10`（二进制 `1010`），则 `(num >> i) & 1` 的结果是 `0`。
- `printf("%d", ...)`：将按位与操作的结果（即当前位的值）打印出来。



总结来说，该函数通过一个循环，逐位检查整数 `num` 的每一位，从最高位（最左边）到最低位（最右边），并将每一位的值（0 或 1）打印出来，最终形成 `num` 的二进制表示。

示例

假设 `num` 为 `42`（十进制），其二进制表示为 `00000000000000000000000000101010`（32 位的表示），调用 `printBinary(42)` 时，输出如下：

```
00000000000000000000000000101010
```

每一位都是通过上述方法逐位计算并输出的。

## C++

在 C/C++ 中，将给定的整数转换为不同进制（如二进制、八进制、十进制和十六进制）的方法有多种。

### 根据转换理论编写代码

下面是十进制转$r$进制的简单实现,分为计算整数部分和小数部分的转换,分被有两种写法

整数部分使用递归来输出

```c++
#include <iostream>
using namespace std;

/*  求小数转换为二进制后的数码 方法1:递推 */
void d1(float f, int r)
{
  while (f > 0)
  {
    int k;
    f *= r;     // 小数点往右挪一位
    k = (int)f; // 获取整数位
    cout << k;  // 打印整数位作为数码
    f -= k;     // 取f的小数部分,用类似方操作计算下一位数码,形如递推
  }
}

/*  求小数转换为二进制后的数码 方法2:通项 */
void d2(float f, int r)
{
  int k = 0;
  while (f - (int)f)
  {
    f *= r;
    k = (int)f % r;
    cout << k;
    // if (f - (int)f == 0)//小数部分为0时退出
    //   break;
  }
}
void intr1(float f, int r)
{
  int n = (int)f;
  int k = 0;
  // 由于求整数部分的数码是从低位到高位,这里使用递归的方式逆序打印
  if (n == 0)
  {
    return;
  }
  k = n % r;
  n = (n - k) / r;
  intr1(n, r);
  cout << k;//打印语句放在递归调用后才可以逆序打印
  // 以下是从低位到高位打印的方案
  // while (n)
  // {
  //   k = n % r;
  //   cout << k;
  //   f /= r;
  //   n = (n - k) / r;

  // }
}
void intr2(float f, int r)
{
  int n = (int)f;
  int k = 0;
  k = n % r;      // 不要立刻打印k,留到递归调用后打印,才可以逆序打印
  n = int(n / r); // 这里的int可以不写,C/C++自动截取整数,因为n是int型
  if (n)
  {
    intr2(n, r);
  }

  cout << k;
}
int main()
{

  int r = 2;
  float f = 0;
  cout << "input a number(decimal),such as 4.625: ";
  cin >> f;
  intr2(f, r);
  cout << '.';
  d2(f - (int)f, r);
  cout << endl;
  return 0;
}

```

```bash
input a number(decimal),such as 4.625: 4.625
100.101
```



### 二进制转换



使用 `std::bitset`

```cpp
#include <iostream>
#include <bitset>

int main() {
    int number = 42;
    std::bitset<32> binary(number);
    std::cout << binary << std::endl;
    return 0;
}
```

`std::bitset<32> binary(num);`：创建一个长度为32位的 `bitset` 对象 `binary`，并用整数 `num` 的值进行初始化。`bitset` 会将整数 `num` 转换为其对应的二进制形式，长度固定为32位。例如，输入 `42` 会被转换为 `00000000000000000000000000101010`。



### 八进制转换

**方法：使用 `std::oct` 流操纵符**

```cpp
#include <iostream>

int main() {
    int number = 42;
    std::cout << std::oct << number << std::endl;//输出52
    return 0;
}
```

### 十进制转换

**方法：直接输出**

```cpp
#include <iostream>

int main() {
    int number = 42;
    std::cout << number << std::endl;
    return 0;
}
```

### 十六进制转换

**方法：使用 `std::hex` 流操纵符**

```cpp
#include <iostream>

int main() {
    int number = 42;
    std::cout << std::hex << number << std::endl;
    return 0;
}
```

### 综合示例

以下是一个将整数转换为二进制、八进制、十进制和十六进制的综合示例：

```cpp
#include <iostream>
#include <bitset>

void printBinary(int num) {
    std::bitset<32> binary(num);
    std::cout << "Binary: " << binary << std::endl;
}

void printOctal(int num) {
    std::cout << "Octal: " << std::oct << num << std::endl;
}

void printDecimal(int num) {
    std::cout << "Decimal: " << num << std::endl;
}

void printHexadecimal(int num) {
    std::cout << "Hexadecimal: " << std::hex << num << std::endl;
}

int main() {
    int number = 42;
    
    printBinary(number);
    printOctal(number);
    printDecimal(number);
    printHexadecimal(number);

    return 0;
}
```

输出：

```
Binary: 00000000000000000000000000101010
Octal: 52
Decimal: 42
Hexadecimal: 2a
```

这些方法可以帮助你在 C/C++ 中将整数转换为不同的进制表示。