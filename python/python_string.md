# python_string

- [2. 词法分析 — Python 3.10.4 文档](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#strings)
  - [ 字面值¶](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#literals)

​	



- [字符串和编码  (liaoxuefeng.com)](https://www.liaoxuefeng.com/wiki/1016959663602400/1017075323632896)
- Text Sequence Type — [`str`](https://docs.python.org/3/library/stdtypes.html#str)
- [Built-in Types — Python 3.10.4 documentation](https://docs.python.org/3/library/stdtypes.html#bytes-objects)

## ascii码

- 在计算机内部，所有数据都使用二进制表示。
  - 每一个二进制位（bit）有 0 和 1 两种状态，因此 **8 个二进制位**就可以组合出 256 种状态，这被称为**一个字节（byte）**。
  - 一个字节一共可以用来表示 256 种不同的状态，**每一个状态对应一个符号**，就是 256 个符号，从0000000 到 11111111。
- ASCII码：
  - 上个世纪60年代，美国制定了一套字符编码，对英语字符与二进制位之间的关系，做了统一规定。这被称为ASCII码。
  - ASCII码一共规定了128个字符的编码，比如空格“SPACE”是32（二进制00100000），大写的字母A是65（二进制01000001）。
  - 这128个符号（包括32个不能打印出来的控制符号），**只占用了一个字节的后面7位**，最前面的1位统一规定为0。
- 缺点：
  - 不能表示所有字符。
  - 相同的编码表示的字符不一样：比如，130在法语编码中代表了`é`，在希伯来语编码中却代表了字母`Gimel (ג)`

## unicode码

- Unicode 码&乱码：
  - 乱码:世界上存在着多种编码方式，同一个二进制数字可以被解释成不同的符号。因此，要想打开一个文本文件，就必须知道它的编码方式，否则用错误的编码方式解读，就会出现乱码。
  - Unicode：一种编码，将世界上所有的符号都纳入其中。每一个符号都给予一个独一无二的编码，使用 Unicode 没有乱码的问题。
- Unicode 的缺点：
  - Unicode只规定了符号的二进制代码，却没有规定这个二进制代码应该如何存储：
    - 无法区别 Unicode和 ASCII：计算机无法区分三个字节表示一个符号还是分别表示三个符号。
    - 另外，英文字母只用一个字节表示就够了，如果unicode统一规定，每个符号用三个或四个字节表示，那么每个英文字母前都必然有二到三个字节是0，这对于存储空间来说是极大的浪费。

### UTF-8编码

- UTF-8 是在互联网上使用最广的一种 <u>Unicode 的实现</u>方式。
  - UTF-8 是一种**变长的编码方式**。
    - 它可以使用 **1-6 个字节**表示一个符号，根据**不同的符号而变化字节长度**。
- UTF-8的编码规则：
  - 对于**单字节**的UTF-8编码，该字节的**最高位为0**，其余7位用来对字符进行编码（等同于ASCII码）。
  - 对于多字节的UTF-8编码，
    - 如果编码**包含 n 个字节，那么第一个字节的前 n 位为1**，
    - 第一个字节的**第 n+1 位为0**，
      - 该字节的**剩余各位用来对字符进行编码**。
    - <u>在第一个字节之后的</u>**所有的字节**，都是**最高两位为"10"**，**其余6位**用来对字符进行编码

## 对字符串进行编码

### python 字符串编码&字节解码

#### 对字符串对象编码

> 以python为例,调用字符串(str)类型的对象的编码方法(encode),将字符串编码转换为字节对象(bytes)

- 1个中文字符经过UTF-8编码后**通常**会占用3个字节，而1个英文字符只占用1个字节。

```py

>>> a="text"
>>> a.encode('utf-8')
b'text'
>>> b=a.encode('utf-8')
>>> b
b'text'
>>> type(b)
<class 'bytes'>
>>> type(a)
<class 'str'>
```

```py

>>> c="测试".encode('utf-8')
>>> c
b'\xe6\xb5\x8b\xe8\xaf\x95'
>>> len(c)
6
#可见,两个中文字符(字符串长度为2),被编码为utf-8的字节后,占了6个字节
```

### 对字节对象解码

```py
>>> c.decode('utf-8')
'测试'
>>> type(c)
<class 'bytes'>
>>> d=c.decode('utf-8')
>>> type(d)
<class 'str'>
>>> len(d)
2
```

### python字节码对象

- Only ASCII characters are permitted in bytes literals (regardless of the declared source code encoding). Any binary values over 127 must be entered into bytes literals using the appropriate escape sequence.
- As with string literals, bytes literals may also use a `r` prefix to disable processing of escape sequences. See [String and Bytes literals](https://docs.python.org/3/reference/lexical_analysis.html#strings) for more about the various forms of bytes literal, including supported escape sequences.