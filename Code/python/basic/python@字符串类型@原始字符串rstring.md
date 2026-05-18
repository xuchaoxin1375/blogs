[toc]

## abstract

[内置类型 — Python 文档 --- Built-in Types — Python documentation](https://docs.python.org/3/library/stdtypes.html#text-sequence-type-str)

[字符串和字节字面量](https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals)

[string --- 常见的字符串操作 — Python  文档](https://docs.python.org/zh-cn/3/library/string.html#)

------

## 字面量

字面量是某些内置类型的常量值的表示法。

就词法分析而言，Python 有两大类字面量:

- [字符串和字节](https://docs.python.org/3/reference/lexical_analysis.html#strings) 字面量
- [数值](https://docs.python.org/3/reference/lexical_analysis.html#numbers)字面量。

其他“字面意义”则用[关键词](https://docs.python.org/3/reference/lexical_analysis.html#keywords)进行词汇表示。 （ `None` ， `True` ， `False` ）和特殊 [省略号标记 ](https://docs.python.org/3/reference/lexical_analysis.html#lexical-ellipsis)（ `...` ）。

### 字符串和字节字面量

字符串字面量是用单引号 ( `'` ) 或双引号 ( `"` ) 括起来的文本。例如：

```python
"spam"
'eggs'
```

用于开始字符串字面量的引号也同时终止字符串字面量，因此字符串字面量只能包含另一个引号（转义序列除外，见下文）。例如：

```python
'Say "Hello", please.'
"Don't do that!"
```

除了这个限制之外，引号字符（ `'` 或 `"` ）的选择不会影响字面量的解析方式。

在字符串字面量中，反斜杠 ( `\` ) 字符用于引入一个 *转义序列* ，其特殊含义取决于反斜杠后面的字符。例如， `\"` 表示双引号字符，并且*不会*结束字符串：

```python
print("Say \"Hello\" to everyone!")
Say "Hello" to everyone!
```

### 数值字面量

[`NUMBER`](https://docs.python.org/3/library/token.html#token.NUMBER) 标记表示数值字面量，其中有三种类型：**整数、浮点数和虚数**。

```
NUMBER: integer | floatnumber | imagnumber
```

数值字面量的数值与将其作为字符串分别传递给 [`int`](https://docs.python.org/3/library/functions.html#int) 、 [`float`](https://docs.python.org/3/library/functions.html#float) 或 [`complex`](https://docs.python.org/3/library/functions.html#complex) 类构造函数时的值相同。

> ```python
> # 1. 普通十进制整数
> lit_int = 123
> str_int = int("123")
> print(lit_int == str_int)  # True
> 
> # 2. 带有下划线的分隔符(最终表示的数值是`_`移除后的数值)
> lit_thou = 1_000_000
> str_thou = int("1_000_000")
> print(lit_thou) # 1000000
> print(lit_thou == str_thou)  # True
> 
> # 3. 十六进制 (Hexadecimal)
> lit_hex = 0xff
> str_hex = int("0xff", 16)  # 注意：字符串转非十进制时需指定基数
> print(lit_hex == str_hex)  # True
> 
> 
> ```
>
> 浮点数不仅支持普通的小数点写法，还支持科学计数法（使用 `e` 或 `E`）。
>
> ```python
> # 1. 标准浮点数
> lit_float = 3.14159
> str_float = float("3.14159")
> print(lit_float == str_float)  # True
> 
> # 2. 科学计数法 (1.23 * 10^4)
> lit_sci = 1.23e4
> str_sci = float("1.23e4")
> print(lit_sci == str_sci)  # True
> 
> # 3. 带有下划线的浮点数
> lit_float_drop = 3_14.15_92
> str_float_drop = float("3_14.15_92")
> print(lit_float_drop == str_float_drop)  # True
> ```
>
> 在Python中，复数的虚部用 `j` 或 `J` 表示。使用**字符串构造复数**时，**加减号两边绝对不能有空格**（例如 `"1+2j"` 是合法的，而 `"1 + 2j"` 会报错）
>
> ```python
> # 1. 纯虚数
> lit_comp1 = 5j
> str_comp1 = complex("5j")
> print(lit_comp1 == str_comp1)  # True
> 
> # 2. 实部 + 虚部
> lit_comp2 = 2 + 3j
> str_comp2 = complex("2+3j")  # 注意：字符串内不能有空格
> print(lit_comp2 == str_comp2)  # True
> 
> # 3. 科学计数法形式的复数
> lit_comp_sci = 1e3 + 2e-1j
> str_comp_sci = complex("1e3+2e-1j")
> print(lit_comp_sci == str_comp_sci)  # True
> ```
>
> 

请注意，并非所有这些**构造函数的有效输入**都是有效的字面量。

> “数值字面量与字符串构造函数的值相同”是一个**单向的等价性**：所有合法的数值字面量，写成字符串传给构造函数都是有效的；但反过来，**构造函数能够接收并解析的某些字符串，在 Python 语法中根本不是合法的数值字面量。**

数值字面量不包含符号；像 `-1` 这样的短语实际上是一个由一元运算符“ `-` ”和字面量组成的表达式

> 在 Python 语法中，`-5` 或 `+5` 严格来说**不是一个字面量**，它是一个一元运算符（`-` 或 `+`）作用于一个正数数字字面量（`5`）上。而在构造函数中，正负号可以作为字符串的一部分被直接解析。
>
> 这在含有正负号的复数或科学计数法中尤为明显：
>
> ```python
> # 构造函数完全合法
> f = float("+3.14")
> c = complex("-1-2j")
> 
> # 但在 Python 中，你不能直接写出带有“内嵌正号”的字面量（除了运算符连接）
> # 比如 1e+5 是合法的科学计数法字面量，但 "+3.14" 作为独立字面量其实是隐式包含了运算
> ```

字符串两端的空白字符 (Whitespace)

> 构造函数在解析字符串时，会自动剥离（strip）两端的空格、制表符（`\t`）或换行符（`\n`）。但在代码中，数值字面量绝对不能包含这些空白。
>
> ```python
> # 构造函数：完美运行
> print(int("  42  \n"))      # 输出: 42
> print(float("\t3.14 "))     # 输出: 3.14
> 
> # 字面量：直接报语法错误 (SyntaxError)
> #   42  
> # \t3.14
> ```

特殊的浮点数值：`NaN` 和 `Inf`

`float()` 构造函数可以接受特殊的字符串来表示“非数（Not a Number）”或“无穷大（Infinity）”，这些字符串甚至是不区分大小写的。然而，Python 并没有为它们设计对应的字面量。

```python
# 构造函数：成功创建特殊浮点数
nan_val = float("nan")
inf_val = float("-infinity")

# 字面量：Python 语法中没有 nan 或 inf 这样的字面量
# 如果直接在代码里写 nan，Python 会把它当成一个未定义的变量名，报 NameError
```

复数构造函数的双参数形式

`complex()` 构造函数还允许传入两个参数（分别代表实部和虚部），这显然是无法用单个数值字面量来表示的。

```python
# 构造函数：传入两个独立数字
c = complex(1.2,3.4)   # 得到 1.2 + 3.4j

# 字面量：你必须连着写成 1.2+3.4j
```

#### 总结

- **数值字面量**：受限于 **Python 词法分析器（Lexer）** 的严格规则，主要用于在代码中静态地硬编码数字。
- **构造函数**：是一个 **运行时的解析器**，它的容错率更高，设计目的是为了处理来自用户输入、文件读取或网络传输的、格式可能不太完美的文本数据。

## 文本序列类型(text sequence type )

Python 中用 [`str`](https://docs.python.org/3/library/stdtypes.html#str) 对象（或*字符串）* 处理文本数据。 字符串是不可变的 Unicode 代码点[序列 ](https://docs.python.org/3/library/stdtypes.html#typesseq)。字符串字面量可以用多种方式书写：

- 单引号： `'allows embedded "double" quotes'`
- 双引号： `"allows embedded 'single' quotes"`
- 三重引号： `'''Three single quotes'''` ， `"""Three double quotes"""`

三引号括起来的字符串可以跨越多行——所有相关的空格都将包含在**字符串字面量**中。

**单个表达式**中**仅包含空格的字符串字面量**将被隐式转换为**单个字符串字面量**。也就是说， `("spam " "eggs") == "spam eggs"` 。

```python
print("spam"  "eggs" == "spameggs") # 结果是True
```

### 字符串前缀

字符串字面量可以有一个可选的*前缀* ，该前缀会影响字面量内容的解析方式，例如：

```
b"data"
f'{result=}'
```

允许使用的前缀有：

- `b` ：[ 字节字面量](https://docs.python.org/3/reference/lexical_analysis.html#bytes-literal)
- `r` ：[ 原始字符串](https://docs.python.org/3/reference/lexical_analysis.html#raw-strings)
- `f` ：[ 格式化字符串字面量 ](https://docs.python.org/3/reference/lexical_analysis.html#f-strings)（“f-string”）
- `t` ：[ 模板字符串字面量 ](https://docs.python.org/3/reference/lexical_analysis.html#t-strings)（“t-string”）
- `u` ：无影响（为向后兼容而允许）

请参阅相关链接章节了解每种类型的详细信息。

前缀不区分大小写（例如，“ `B` ”与“ `b` ”的效果相同）。前缀“ `r` ”可以与“ `f` ”、“ `t` ”或“ `b` ”组合，因此“ `fr` ”、“ `rf` ”、“ `tr` ”、“ `rt` ”、“ `br` ”和“ `rb` ”也是有效的前缀。

### 字节字面量

*字节字面量*总是以“ `b` ”或“ `B` ”为前缀；

它们会生成 [`bytes`](https://docs.python.org/3/library/stdtypes.html#bytes) 类型的实例，而不是 [`str`](https://docs.python.org/3/library/stdtypes.html#str) 类型的实例。 

它们只能包含 ASCII 字符；数值为 128 的字节。 

或更大必须用**转义序列**表示（通常为 [十六进制字符](https://docs.python.org/3/reference/lexical_analysis.html#string-escape-hex)或[八进制字符 ](https://docs.python.org/3/reference/lexical_analysis.html#string-escape-oct)）：

```python
b'\x89PNG\r\n\x1a\n'
b'\x89PNG\r\n\x1a\n'
list(b'\x89PNG\r\n\x1a\n')
[137, 80, 78, 71, 13, 10, 26, 10]
```

同样，零字节必须使用转义序列（通常为 `\0` 或 `\x00` ）。

#### bytes类型

Python 中的 `bytes` 类型是不可变的字节序列，每个元素是 0-255 范围内的整数。它用于处理二进制数据，比如文件 I/O、网络通信、加密等场景。

**创建方式**

```python
# 字面量（仅限 ASCII）
b = b'hello'

# 从字符串编码
b = 'hello'.encode('utf-8')

# 从整数列表
b = bytes([72, 101, 108, 108, 111])

# 指定长度的零填充
b = bytes(5)  # b'\x00\x00\x00\x00\x00'

# 从十六进制字符串
b = bytes.fromhex('48656c6c6f')
```

**基本操作**

```python
b = b'hello'

b[0]        # 104（整数，不是字符）
b[1:3]      # b'el'（切片仍是 bytes）
len(b)      # 5
b + b'!'    # b'hello!'
b * 2       # b'hellohello'
```

**与 str 的转换**

```python
# bytes -> str
b'hello'.decode('utf-8')    # 'hello'

# str -> bytes
'hello'.encode('utf-8')     # b'hello'
```

**常用方法**

`bytes` 拥有和 `str` 类似的方法：`find`、`replace`、`split`、`startswith`、`upper` 等，但操作对象是字节而非字符。

```python
b'Hello World'.split()          # [b'Hello', b'World']
b'hello'.replace(b'l', b'L')   # b'heLLo'
b'hello'.hex()                  # '68656c6c6f'
```

**可变版本：bytearray**

如果需要原地修改字节序列，用 `bytearray`：

```python
ba = bytearray(b'hello')
ba[0] = 72  # 修改第一个字节
ba          # bytearray(b'Hello')
```

**关键区别：bytes vs str**

|          | `str`        | `bytes`          |
| -------- | ------------ | ---------------- |
| 内容     | Unicode 字符 | 原始字节 (0-255) |
| 索引返回 | 单字符字符串 | 整数             |
| 字面量   | `'hello'`    | `b'hello'`       |
| 可变版本 | 无           | `bytearray`      |
| 用途     | 文本处理     | 二进制数据       |

**典型使用场景**

- 读写二进制文件（`open('file', 'rb')`）
- 网络 socket 收发数据
- 哈希和加密操作
- 处理图片、音频等非文本数据
- 与 C 扩展或系统调用交互

###  转义序列

如未标注 `'r'` 或 `'R'` 前缀，字符串和字节串字面值中，转义序列以类似 C 标准的规则进行解释。可用的转义序列如下：

| 转义序列     | 含意                    | 备注  |
| :----------- | :---------------------- | :---- |
| `\`<newline> | 忽略反斜杠与换行符      | (1)   |
| `\\`         | 反斜杠（`\`）           |       |
| `\'`         | 单引号（`'`）           |       |
| `\"`         | 双引号（`"`）           |       |
| `\a`         | ASCII 响铃（BEL）       |       |
| `\b`         | ASCII 退格符（BS）      |       |
| `\f`         | ASCII 换页符（FF）      |       |
| `\n`         | ASCII 换行符（LF）      |       |
| `\r`         | ASCII 回车符（CR）      |       |
| `\t`         | ASCII 水平制表符（TAB） |       |
| `\v`         | ASCII 垂直制表符（VT）  |       |
| `\ooo`       | 八进制数 *ooo* 字符     | (2,4) |
| `\xhh`       | 十六进制数 *hh* 字符    | (3,4) |

字符串字面值专用的转义序列：

| 转义序列     | 含意                                  | 备注 |
| :----------- | :------------------------------------ | :--- |
| `\N{name}`   | Unicode 数据库中名为 *name* 的字符    | (5)  |
| `\uxxxx`     | 16 位十六进制数 *xxxx* 码位的字符     | (6)  |
| `\Uxxxxxxxx` | 32 位 16 进制数 *xxxxxxxx* 码位的字符 | (7)  |

### 忽略换行符

1. 可以在行尾添加一个反斜杠来忽略换行符:

   ```python
>>> 'This string will not include \
   ... backslashes or newline characters.'
   'This string will not include backslashes or newline characters.'
   ```
   
   同样的效果也可以使用 [三重引号字符串](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#strings)，或者圆括号和 [字符串字面值拼接](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#string-concatenation) 来达成。

2. 与 C 标准一致，接受最多三个八进制数字。

   *在 3.11 版本发生变更:* 取值大于 `0o377` 的八进制数转义序列会产生 [`DeprecationWarning`](https://docs.python.org/zh-cn/3/library/exceptions.html#DeprecationWarning)。

   *在 3.12 版本发生变更:* 数值大于 `0o377` 的八进制转义符会产生 [`SyntaxWarning`](https://docs.python.org/zh-cn/3/library/exceptions.html#SyntaxWarning)。 在未来的 Python 版本中将最终改为 [`SyntaxError`](https://docs.python.org/zh-cn/3/library/exceptions.html#SyntaxError)。

3. 与 C 标准不同，必须为两个十六进制数字。

4. *字节串* 字面值中，十六进制数和八进制数的转义码以相应数值代表每个字节。*字符串* 字面值中，这些转义码以相应数值代表每个 Unicode 字符。

5. *在 3.3 版本发生变更:* 加入了对别名 [1](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#id16) 的支持。

6. 必须为 4 个十六进制数码。

7. 表示任意 Unicode 字符。必须为 8 个十六进制数码。

与 C 标准不同，无法识别的转义序列在字符串里原样保留，即，*输出结果保留反斜杠*。（调试时，这种方式很有用：输错转义序列时，更容易在输出结果中识别错误。）注意，在字节串字面值内，字符串字面值专用的转义序列属于无法识别的转义序列。

*在 3.6 版本发生变更:* 不可识别的转义序列会产生 [`DeprecationWarning`](https://docs.python.org/zh-cn/3/library/exceptions.html#DeprecationWarning)。

*在 3.12 版本发生变更:* 不可识别的转义序列会产生 [`SyntaxWarning`](https://docs.python.org/zh-cn/3/library/exceptions.html#SyntaxWarning)。 在未来的 Python 版本中将最终改为 [`SyntaxError`](https://docs.python.org/zh-cn/3/library/exceptions.html#SyntaxError)。

### 原始字面值和引号转义

即使在**原始字面值**中，**引号也可以用反斜杠转义**，但**反斜杠会保留在输出结果里**；(目前想要用原始字符串字面值表示单独的`"`号是不可行的)`r"""`以及`r""""`都不是完整的字符串字面值;而`r"" ""`被解释为`r""`,相当于空字符串`""`

而 `r"\""` 是由**两个字符**组成的有效字符串字面值：反斜杠和双引号`\"`；

如果要表示单独的一个引号字符`"`需要用`"\""`或`'"'`这种普通字符串

```python
In [8]: "\""
Out[8]: '"'

In [9]: len("\"")
Out[9]: 1
```

`r"\"` 则不是有效字符串字面值（原始字符串也不能以奇数个反斜杠结尾）。尤其是，*原始字面值不能以单个反斜杠结尾* （反斜杠会转义其后的引号)。

还要注意，反斜杠加换行在字面值中**被解释为两个字符**，而 *不是* 连续行。



###  字符串字面值合并

以空白符分隔的多个相邻字符串或字节串字面值，可用不同引号标注，等同于合并操作。因此，`"hello" 'world'` 等价于 `"helloworld"`。此功能不需要反斜杠，即可将长字符串分为多个物理行，还可以为不同部分的字符串添加注释，例如：

```python
re.compile("[A-Za-z_]"       # 字母或下划线
           "[A-Za-z0-9_]*"   # 字母、数字或下划线
          )
```

注意，此功能在句法层面定义，在编译时实现。在运行时，合并字符串表达式必须使用 '+' 运算符。还要注意，字面值合并可以为每个部分应用不同的引号风格（甚至混用原始字符串和三引号字符串)，格式字符串字面值也可以与纯字符串字面值合并。

## 二进制序列类型(binary sequence type)

[binary sequence types|Built-in Types — Python documentation](https://docs.python.org/3/library/stdtypes.html#binary-sequence-types-bytes-bytearray-memoryview)

## `str` 类型概述

`str`（字符串）是 Python 中表示文本的基本数据类型。它是 **不可变（immutable）** 的序列，存储的是 **Unicode 字符**，支持索引访问、切片、迭代等常见序列操作。

示例：

```python
s = "Hello, Python!"
print(s[0])   # 输出 'H'
print(s[-1])  # 输出 '!'
print(s[7:])  # 输出 'Python!'
```

------

### `str` 的基本操作

#### 1. 拼接（Concatenation）

可以使用 `+` 运算符拼接两个字符串：

```python
s1 = "Hello"
s2 = "World"
print(s1 + ", " + s2)  # 输出 'Hello, World'
```

#### 2. 重复（Repetition）

可以使用 `*` 运算符重复字符串：

```python
s = "Ha" * 3
print(s)  # 输出 'HaHaHa'
```

#### 3. 成员检测（Membership Test）

可以使用 `in` 关键字检查子串是否存在：

```python
print("Py" in "Python")  # 输出 True
print("Java" in "Python")  # 输出 False
```

------

### `str` 的索引与切片

#### 1. 通过索引访问字符

```python
s = "Python"
print(s[0])   # 'P'
print(s[-1])  # 'n'
```

#### 2. 通过切片获取子串

切片格式：`s[start:end:step]`

```python
s = "Python"
print(s[0:4])  # 'Pyth'
print(s[::2])  # 'Pto' (步长2)
print(s[::-1]) # 'nohtyP' (反转字符串)
```

------

### `str` 的方法（Methods）

Python `str` 提供了丰富的方法来操作字符串，包括大小写转换、查找、替换、分割等。

#### 1. **大小写转换**

```python
s = "hello world"
print(s.upper())  # 'HELLO WORLD'
print(s.lower())  # 'hello world'
print(s.capitalize())  # 'Hello world'
print(s.title())  # 'Hello World'
```

#### 2. **去除空白字符**

```python
s = "  hello  "
print(s.strip())  # 'hello' (去掉两侧空格)
print(s.lstrip())  # 'hello  ' (去掉左侧空格)
print(s.rstrip())  # '  hello' (去掉右侧空格)
```

#### 3. **查找子串**

```python
s = "Python is fun"
print(s.find("is"))  # 7 (返回子串的起始索引)
print(s.find("Java"))  # -1 (未找到返回 -1)
```

#### 4. **替换**

```python
s = "I love Java"
print(s.replace("Java", "Python"))  # 'I love Python'
```

#### 5. **分割与合并**

```python
s = "apple,banana,orange"
print(s.split(","))  # ['apple', 'banana', 'orange']

words = ["Python", "is", "awesome"]
print(" ".join(words))  # 'Python is awesome'
```

#### 6. **格式化**

```python
name = "Alice"
age = 25
print(f"My name is {name} and I am {age} years old.")
```

------

### `str` 的编码与解码

Python 的字符串默认使用 **Unicode** 存储，可以使用 `.encode()` 方法将其转换为 `bytes`，再用 `.decode()` 还原：

```python
s = "你好"
b = s.encode("utf-8")  # 编码为 UTF-8 字节串
print(b)  # b'\xe4\xbd\xa0\xe5\xa5\xbd'
print(b.decode("utf-8"))  # '你好'
```

------

### 总结

- `str` 是不可变的 Unicode 字符序列。
- 支持索引、切片、拼接、重复等操作。
- 提供丰富的方法进行大小写转换、查找、替换、分割、格式化等操作。
- 支持 `bytes` 与 `str` 的编码和解码转换。

