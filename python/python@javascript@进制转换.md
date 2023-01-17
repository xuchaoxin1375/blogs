[toc]

#  相关问题
- 数制进制转换问题包括:
- 任意进制base1转任意进制base2
  - 特别的,任意进制转为十进制
  - 十进制转为任意进制
- 如果掌握了和10进制的互换,那么您就可以自行编写出任意进制的转换(可以以10进制为桥梁)
- 相关知识可以参考计算机组成原理的数字部分(有相关一般性的公式推理)		

#  javaScript:
js有一个非常好用的函数`toString()`
它由许多功能
其中一个功能可以用在转换任意进制数1到任意进制数2
>在javascript中,对应的做法包括:
>转为任意进制的方法:
>	`toString()`(该方法接受一个底数)
>对于转为十进制:
>`parseInt()`方法
>##  示例
- 在对十进制数或二进制进行转换的时候,应当定义一个变量来保存要被转换的数字,否则toString()会报错
![在这里插入图片描述](https://img-blog.csdnimg.cn/f347c984c5ba45aa8061be6b410c636a.png)

```js


//8进制数11转为二进制显示
console.log(011.toString(2));
//二进制数转为16进制数表示
console.log(0b101.toString(16));

```
#  python
## 十六进制、八进制和二进制记数

- 正如本章之前提到的那样，Python整数能够以十六进制、八进制和二进制记数法来编写，作为一般的以10位基数的十进制记数法的补充。
- 这些常量只是指定一个整数对象的值的一种替代方法。

```python
0o1, 0o20, 0o377           # Octal literals
(1, 16, 255)
0x01, 0x10, 0xFF           # Hex literals
(1, 16, 255)
0b1, 0b10000, 0b11111111   # Binary literals
(1, 16, 255)
```

- 这里，八进制值0o377、十六进制值0xFF和二进制值0b11111111，都表示十进制的255。
- 下面提到的`bin()/oct()/hex()`参数可以不是十进制数,可以是二/八/十六进制整数
- 暂时**不支持小数**

### bin()

- **bin**(*x*)

- Convert an integer number to a binary string prefixed with “0b”. The result is a valid Python expression. If *x* is not a Python [`int`](https://docs.python.org/3/library/functions.html#int) object, it has to define an `__index__()` method that returns an integer. Some examples:

```bash
>>> bin(3)
'0b11'
>>> bin(-10)
'-0b1010'
```

- If the prefix “0b” is desired or not, you can use either of the following ways.

```bash
>>> format(14, '#b'), format(14, 'b')
('0b1110', '1110')
>>> f'{14:#b}', f'{14:b}'
('0b1110', '1110')
```

- See also [`format()`](https://docs.python.org/3/library/functions.html#format) for more information.

### oct()

- **oct**(*x*)

- Convert an integer number to an octal string prefixed with “0o”. The result is a valid Python expression. If *x* is not a Python [`int`](https://docs.python.org/3/library/functions.html#int) object, it has to define an `__index__()` method that returns an integer. For example:

- ```python
  >>> oct(8)
  '0o10'
  >>> oct(-56)
  '-0o70'
  ```

- If you want to convert an integer number to an octal string either with the prefix “0o” or not, you can use either of the following ways.

- ```python
  >>> '%#o' % 10, '%o' % 10
  ('0o12', '12')
  >>> format(10, '#o'), format(10, 'o')
  ('0o12', '12')
  >>> f'{10:#o}', f'{10:o}'
  ('0o12', '12')
  ```

- See also [`format()`](https://docs.python.org/3/library/functions.html#format) for more information.

### hex()

- **hex**(*x*)

- Convert an integer number to a lowercase hexadecimal string prefixed with “0x”. If *x* is not a Python [`int`](https://docs.python.org/3/library/functions.html#int) object, it has to define an `__index__()` method that returns an integer. Some examples:

  ```python
  >>> hex(255)
  '0xff'
  >>> hex(-42)
  '-0x2a'
  >>> bin(0xA)
  '0b1010'
  ```

- If you want to convert an integer number to an uppercase or lower hexadecimal string with prefix or not, you can use either of the following ways:

  ```python
  >>> '%#x' % 255, '%x' % 255, '%X' % 255
  ('0xff', 'ff', 'FF')
  >>> format(255, '#x'), format(255, 'x'), format(255, 'X')
  ('0xff', 'ff', 'FF')
  >>> f'{255:#x}', f'{255:x}', f'{255:X}'
  ('0xff', 'ff', 'FF')
  ```

- See also [`format()`](https://docs.python.org/3/library/functions.html#format) for more information.

- See also [`int()`](https://docs.python.org/3/library/functions.html#int) for converting a hexadecimal string to an integer using a base of 16.

- To obtain a hexadecimal string representation for a float, use the [`float.hex()`](https://docs.python.org/3/library/stdtypes.html#float.hex) method.

### 进制间转换

- Python默认地用十进制值（以10为基数）显示，但它提供了内置的函数，允许我们把整数转换为其他进制的<u>数字字符串</u>：

```python
oct(64), hex(64), bin(64)
('0o100', '0x40', '0b1000000')
```

- oct函数会将十进制数转换为八进制数，hex函数会将十进制转换为十六进制数，而bin会将十进制数转换为二进制。

- ```python
  >>> bin(int('1111',2))
  '0b1111'
  >>> bin(int('17',8))
  '0b1111'
  >>> bin(int('f',16))
  '0b1111'
  >>> oct(int('f',16))
  '0o17'
  >>> hex(int('17',8))
  '0xf'
  ```

  - 可以借助int,将任意进制先转换为十进制,将结果传入`bin/oct/hex`转为二进制/八进制/十六进制的字符串

- 或者使用format()方法

  - ```python
    >>> format(0b1111,'b')
    '1111'
    >>> format(0b1111,'#X')
    '0XF'
    >>> format(0b1111,'#x')
    '0xf'
    ```

- 或者使用传统字符串格式化

  - ```python
    >>> '%X'%int('17',8)
    'F'
    >>> '%X'%int('1111',2)
    'F'
    >>> '%o'%int('1111',2)
    '17'
    >>> '%#o'%int('1111',2)
    '0o17'
    >>> '%#b'%int('17',8)
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
    ValueError: unsupported format character 'b' (0x62) at index 2
    ```

  - 容易发现,格式化的方式可以控制前缀是否显示

  - 但是`%`方式无法控制二进制,只可以控制八进制和十六进制

  - `format()`支持二进制

### int(x,base=10)

- *class* **int**(*x*, *base=10*)

- Return an integer object constructed from a number or string *x*, or return `0` if no arguments are given. If *x* defines `__int__()`, `int(x)` returns `x.__int__()`. If *x* defines `__index__()`, it returns `x.__index__()`. If *x* defines `__trunc__()`, it returns `x.__trunc__()`. For floating point numbers, this truncates towards zero.

- If *x* is not a number or if *base* is given, then *x* must be a string, [`bytes`](https://docs.python.org/3/library/stdtypes.html#bytes), or [`bytearray`](https://docs.python.org/3/library/stdtypes.html#bytearray) instance representing an integer in radix *base*. Optionally, the string can be preceded by `+` or `-` (with no space in between), have leading zeros, be surrounded by whitespace, and have single underscores interspersed between digits.

- A base-n integer string contains digits, each representing a value from 0 to n-1. The values 0–9 can be represented by any Unicode decimal digit. The values 10–35 can be represented by `a` to `z` (or `A` to `Z`). The default *base* is 10. 

- The allowed bases are 0 and 2–36. Base-2, -8, and -16 strings can be optionally prefixed with `0b`/`0B`, `0o`/`0O`, or `0x`/`0X`, as with integer literals in code.

-  For base 0, the string is interpreted in a similar way to an [integer literal in code](https://docs.python.org/3/reference/lexical_analysis.html#integers), in that the actual base is 2, 8, 10, or 16 as determined by the prefix. 

- Base 0 also disallows leading zeros: `int('010', 0)` is not legal, while `int('010')` and `int('010', 8)` are.

  The integer type is described in [Numeric Types — int, float, complex](https://docs.python.org/3/library/stdtypes.html#typesnumeric).

- 另一种方式，内置的int函数会将一个数字的字符串变换为一个整数，并可以通过定义的第二个参数来确定变换的数字的进制：

- ```python
   int('64'), int('100', 8), int('40', 16), int('1000000', 2)
   (64, 64, 64, 64)
   int('0x40', 16), int('0b1000000', 2)    # Literals okay too
   (64, 64)
  ```

- eval函数，将会把字符串作为Python代码。因此，它也具有类似的效果（但往往运行得更慢：它实际上会作为程序的一个片段编译并运行这个字符串，并且它假设你能够信任运行的字符串的来源。 

- ```python
   eval('64'), eval('0o100'), eval('0x40'), eval('0b1000000')
   (64, 64, 64, 64)
  ```

- 最后，你能够使用字符串格式化方法调用和表达式将一个整数转换成八进制数和十六进制数的字符串：

- ```python
  '{0:o}, {1:x}, {2:b}'.format(64, 64, 64)
   '100, 40, 1000000'
   '%o, %x, %X' % (64, 255, 255)
   '100, ff, FF'
  ```

- ```python
   0o1, 0o20, 0o377     # New octal format in 2.6 (same as 3.0)
   (1, 16, 255)
    
   01, 020, 0377        # Old octal literals in 2.6 (and earlier)
   (1, 16, 255)
  ```

### format()

- **format**(*value*, *format_spec=''*)

- Convert a *value* to a “formatted” representation, as controlled by *format_spec*.
-  The interpretation of *format_spec* will depend on the type of the *value* argument; however, there is a standard formatting syntax that is used by most built-in types: [Format Specification Mini-Language](https://docs.python.org/3/library/string.html#formatspec).

- The default *format_spec* is an empty string which usually gives the same effect as calling [`str(value)`](https://docs.python.org/3/library/stdtypes.html#str).
- A call to `format(value, format_spec)` is translated to `type(value).__format__(value, format_spec)` which bypasses the instance dictionary when searching for the value’s `__format__()` method.
-  A [`TypeError`](https://docs.python.org/3/library/exceptions.html#TypeError) exception is raised if the method search reaches [`object`](https://docs.python.org/3/library/functions.html#object) and the *format_spec* is non-empty, or if either the *format_spec* or the return value are not strings.