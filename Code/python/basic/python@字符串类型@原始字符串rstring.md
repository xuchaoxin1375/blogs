[toc]

## abstract

[内置类型 — Python 字符串 文档](https://docs.python.org/zh-cn/3/library/stdtypes.html#text-sequence-type-str)

[string --- 常见的字符串操作 — Python 3.13.2 文档](https://docs.python.org/zh-cn/3/library/string.html#)

### 词法分析

[词法分析 — Python   文档](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#literals)

[Lexical analysis — Python  documentation](https://docs.python.org/3/reference/lexical_analysis.html#literals)

------

##   字面值

字面值是内置类型**常量值**的表示法。

###   字符串与字节串字面值|词法定义

字符串字面值的词法定义如下：

```python
stringliteral   ::= [stringprefix](shortstring | longstring)
stringprefix    ::= "r" | "u" | "R" | "U" | "f" | "F"
                    | "fr" | "Fr" | "fR" | "FR" | "rf" | "rF" | "Rf" | "RF"
shortstring     ::= "'" shortstringitem* "'" | '"' shortstringitem* '"'
longstring      ::= "'''" longstringitem* "'''" | '"""' longstringitem* '"""'
shortstringitem ::= shortstringchar | stringescapeseq
longstringitem  ::= longstringchar | stringescapeseq
shortstringchar ::= <any source character except "\" or newline or the quote>
longstringchar  ::= <any source character except "\">
stringescapeseq ::= "\" <any source character>
bytesliteral   ::= bytesprefix(shortbytes | longbytes)
bytesprefix    ::= "b" | "B" | "br" | "Br" | "bR" | "BR" | "rb" | "rB" | "Rb" | "RB"
shortbytes     ::= "'" shortbytesitem* "'" | '"' shortbytesitem* '"'
longbytes      ::= "'''" longbytesitem* "'''" | '"""' longbytesitem* '"""'
shortbytesitem ::= shortbyteschar | bytesescapeseq
longbytesitem  ::= longbyteschar | bytesescapeseq
shortbyteschar ::= <any ASCII character except "\" or newline or the quote>
longbyteschar  ::= <any ASCII character except "\">
bytesescapeseq ::= "\" <any ASCII character>
```

- 这些产生式未指明的一个句法限制是空白符不允许在 [`stringprefix`](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#grammar-token-python-grammar-stringprefix) 或 [`bytesprefix`](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#grammar-token-python-grammar-bytesprefix) 与**字面值的其余部分之间**出现。 
- 源字符集是由**编码格式声明**来定义的；**如果源文件没有给出编码格式声明则默认 UTF-8**；参见 [编码声明](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#encodings) 一节。

## 字符串字面值概述

直白的说明：**两种类型的字面值**都可用成对的单引号 (`'`) 或双引号 (`"`) 括起来。 它们还可以用**成对的连续三个单引号或双引号**括起来 (这通常被称为 ***三重引号字符串***)。 

反斜杠 (`\`) 字符被用来**给予普通的字符特殊含义**例如 `n`，当用斜杠转义时 (`\n`) 表示 '换行'。

它还可以被用来**对具有特殊含义的字符进行转义**，例如**换行符、反斜杠本身或者引号**等。 请参阅下面的 [转义序列](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#escape-sequences) 查看示例。



**字节串字面值**要加前缀 `'b'` 或 `'B'`；生成的是类型 [`bytes`](https://docs.python.org/zh-cn/3/library/stdtypes.html#bytes) 的实例，不是类型 [`str`](https://docs.python.org/zh-cn/3/library/stdtypes.html#str) 的实例；字节串只能包含 ASCII 字符；字节串数值大于等于 128 时，必须用转义表示。

**字符串和字节串字面值**都可选择加前缀字母 `'r'` 或 `'R'`；这分别被称为 *原始字符串字面值* 和 *原始字节串字面值* 并会**将反斜杠视为原本的字符字面值**。 因此，在原始字符串字面值中，`'\U'` 和 `'\u'` 转义符号不会被特殊对待。

*Added in version 3.3:* 新增原始字节串 `'rb'` 前缀，是 `'br'` 的同义词。

支持 unicode 字面值（`u'value'`）遗留代码，简化 Python 2.x 和 3.x 并行代码库的维护工作。详见 [**PEP 414**](https://peps.python.org/pep-0414/)。



前缀为 `'f'` 或 `'F'` 的字符串称为 *格式字符串*；详见 [f 字符串](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#f-strings)。`'f'` 可与 `'r'` 连用，但不能与 `'b'` 或 `'u'` 连用，因此，可以使用原始格式字符串，但不能使用格式字节串字面值。

三引号字面值可以包含未转义的换行和引号（原样保留），除了连在一起的，用于终止字面值的，未经转义的三个引号。（"引号" 是启用字面值的字符，可以是 `'`，也可以是 `"`。）

####  转义序列

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

### 注释：

1. 可以在行尾添加一个反斜杠来忽略换行符:

   \>>>

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



### f 字符串

*Added in version 3.6.*

*格式字符串字面值* 或称 *f-string* 是标注了 `'f'` 或 `'F'` 前缀的字符串字面值。这种字符串可包含替换字段，即以 `{}` 标注的表达式。其他字符串字面值只是常量，格式字符串字面值则是可在运行时求值的表达式。

除非字面值标记为原始字符串，否则，与在普通字符串字面值中一样，转义序列也会被解码。解码后，用于字符串内容的语法如下：

```python
f_string          ::= (literal_char | "{{" | "}}" | replacement_field)*
replacement_field ::= "{" f_expression ["="] ["!" conversion] [":" format_spec] "}"
f_expression      ::= (conditional_expression | "*" or_expr)
                      ("," conditional_expression | "," "*" or_expr)* [","]
                      | yield_expression
conversion        ::= "s" | "r" | "a"
format_spec       ::= (literal_char | replacement_field)*
literal_char      ::= <any code point except "{", "}" or NULL>
```

双花括号 `'{{'` 或 `'}}'` 被替换为单花括号，花括号外的字符串仍按字面值处理。单左花括号 `'{'` 标记以 Python 表达式开头的替换字段。在表达式后加等于号 `'='`，可在求值后，同时显示表达式文本及其结果（用于调试）。 随后是用叹号 `'!'` 标记的转换字段。还可以在冒号 `':'` 后附加格式说明符。替换字段以右花括号 `'}'` 为结尾。

格式化字符串字面值中的表达式会与用圆括号包围的常规 Python 表达式一样处理，但有少量例外。 空表达式是不被允许的，而 [`lambda`](https://docs.python.org/zh-cn/3/reference/expressions.html#lambda) 和赋值表达式 `:=` 都必须显式地用括号包围。 每个表达式都将在格式化字符串字面值出现的上下文中按从左到右的顺序进行求值。 替换表达式可在单引号和三引号f-字符串中包含换行符并可包含注释。 替换字段内 `#` 后面的所有内容都是注释（即使结尾花括号和引号也是）。 在这种情况下，替换字段必须在另一行中结束。

```python
>>> f"abc{a # This is a comment }"
... + 3}"
'abc5'
```

*在 3.7 版本发生变更:* Python 3.7 以前， 因为实现的问题，不允许在格式字符串字面值表达式中使用 [`await`](https://docs.python.org/zh-cn/3/reference/expressions.html#await) 表达式与包含 [`async for`](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#async-for) 子句的推导式。

*在 3.12 版本发生变更:* 在 Python 3.12 之前，不允许在 f-字符串的替换字段中使用注释。

表达式里含等号 `'='` 时，输出内容包括表达式文本、`'='` 、求值结果。输出内容可以保留表达式中左花括号 `'{'` 后，及 `'='` 后的空格。没有指定格式时，`'='` 默认调用表达式的 [`repr()`](https://docs.python.org/zh-cn/3/library/functions.html#repr)。指定了格式时，默认调用表达式的 [`str()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#str)，除非声明了转换字段 `'!r'`。

*Added in version 3.8:* 等号 `'='`。

指定了转换符时，表达式求值的结果会先转换，再格式化。转换符 `'!s'` 调用 [`str()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#str) 转换求值结果，`'!r'` 调用 [`repr()`](https://docs.python.org/zh-cn/3/library/functions.html#repr)，`'!a'` 调用 [`ascii()`](https://docs.python.org/zh-cn/3/library/functions.html#ascii)。

然后使用 [`format()`](https://docs.python.org/zh-cn/3/library/functions.html#format) 协议对结果进行格式化。 格式说明符将传给表达式或转换结果的 [`__format__()`](https://docs.python.org/zh-cn/3/reference/datamodel.html#object.__format__) 方法。 如果省略格式说明符则将传入空字符串。 格式化后的结果将包括在整个字符串的最终值中。

最高层级的格式说明符可以包括嵌套的替换字段。 这些嵌套字段也可以包括它们自己的转换字段和 [格式说明符](https://docs.python.org/zh-cn/3/library/string.html#formatspec)，但是不可再包括更深层嵌套的替换字段。 这里的 [格式说明符微语言](https://docs.python.org/zh-cn/3/library/string.html#formatspec) 与 [`str.format()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#str.format) 方法所使用的相同。

格式化字符串字面值可以拼接，但是一个替换字段不能拆分到多个字面值。

格式字符串字面值示例如下：

\>>>

```python
>>> name = "Fred"
>>> f"He said his name is {name!r}."
"He said his name is 'Fred'."
>>> f"He said his name is {repr(name)}."  # repr() is equivalent to !r
"He said his name is 'Fred'."
>>> width = 10
>>> precision = 4
>>> value = decimal.Decimal("12.34567")
>>> f"result: {value:{width}.{precision}}"  # nested fields
'result:      12.35'
>>> today = datetime(year=2017, month=1, day=27)
>>> f"{today:%B %d, %Y}"  # using date format specifier
'January 27, 2017'
>>> f"{today=:%B %d, %Y}" # using date format specifier and debugging
'today=January 27, 2017'
>>> number = 1024
>>> f"{number:#0x}"  # using integer format specifier
'0x400'
>>> foo = "bar"
>>> f"{ foo = }" # preserves whitespace
" foo = 'bar'"
>>> line = "The mill's closed"
>>> f"{line = }"
'line = "The mill\'s closed"'
>>> f"{line = :20}"
"line = The mill's closed   "
>>> f"{line = !r:20}"
'line = "The mill\'s closed" '
```

允许在替换字段中重用外层 f-字符串的引号类型:

\>>>

```python
>>> a = dict(x=2)
>>> f"abc {a["x"]} def"
'abc 2 def'
```

*在 3.12 版本发生变更:* 在 Python 3.12 之前不允许在替换字段中重用与外层 f-字符串相同的引号类型。

替换字段中也允许使用反斜杠并会以与在其他场景下相同的方式求值:

\>>>

```python
>>> a = ["a", "b", "c"]
>>> print(f"List a contains:\n{"\n".join(a)}")
List a contains:
a
b
c
```

*在 3.12 版本发生变更:* 在 Python 3.12 之前，f-字符串的替换字段内不允许使用反斜杠。

即便未包含表达式，格式字符串字面值也不能用作文档字符串。

\>>>

```
>>> def foo():
...     f"Not a docstring"
...
>>> foo.__doc__ is None
True
```

参阅 [**PEP 498**](https://peps.python.org/pep-0498/)，了解格式字符串字面值的提案，以及与格式字符串机制相关的 [`str.format()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#str.format)。

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

这部分文档详细介绍了 `str` 类型的核心特性，掌握这些内容可以更高效地处理字符串操作！