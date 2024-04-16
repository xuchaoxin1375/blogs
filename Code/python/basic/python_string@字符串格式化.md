

[toc]



# python字符串格式化操作

- python的字符串插值语法,允许你在字符串中直接使用`{}`来指明一个表达式,而统一地将指示该字符串是一个插值字符串的`f`提到字符串的前面

- python 提供了两种现代化的字符串格式化方法:format()和f-string
  -  前者的风格更像正则表达式分组中的操作
  - 后者更加简单,内联替换变量名为字符串,阅读起来更加方便

##  ref

- [7. Input and Output — Python 3.11.1 documentation](https://docs.python.org/3/tutorial/inputoutput.html)

- [7. 输入与输出](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#)
	- [7.1. 更复杂的输出格式](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#fancier-output-formatting)
	  - [7.1.1. 格式化字符串字面值](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#formatted-string-literals)
	  - [7.1.2. 字符串 format() 方法](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#the-string-format-method)
	  - [7.1.3. 手动格式化字符串](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#manual-string-formatting)
	  - [7.1.4. 旧式字符串格式化方法](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#old-string-formatting)
	- [7.2. 读写文件](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#reading-and-writing-files)
	  - [7.2.1. 文件对象的方法](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#methods-of-file-objects)
	  - [7.2.2. 使用 ](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#saving-structured-data-with-json)`json` 保存结构化数据

###  常用字符串操作

- [string --- 常见的字符串操作 ](https://docs.python.org/zh-cn/3/library/string.html#helper-functions)
  - [字符串常量](https://docs.python.org/zh-cn/3/library/string.html#string-constants)
  - [自定义字符串格式化](https://docs.python.org/zh-cn/3/library/string.html#custom-string-formatting)

##  %风格%value@旧式(类c语言printf风格的字符串格式化)🎈

- [printf 风格的字符串格式化](https://docs.python.org/zh-cn/3/library/stdtypes.html#old-string-formatting) 

- % 运算符（和求余符一样的符号）也可用于字符串格式化。

- 给定 `'string' % values`，则 `string` 中的 `%` 实例会以零个或多个 `values` 元素替换。

- 此操作被称为字符串插值。例如：

  - ```py
    >>> a=10
    >>> "test%d"%a
    'test10'
    >>> "test%s"%5.6
    'test5.6'
    >>> "test:try wide test%10f"%5.6
    'test:try wide test  5.600000'
    >>>
    >>> type("test%s"%5.6)
    <class 'str'>
    ```

  - 和C语言的最大不同在于,python中的`'string%type' %values`表达式本身计算结果可以独立存在

    - 不依赖于printf函数就可以工作
    - 上面的几个例子都验证了这一点

  - ```py
     import math
     print('The value of pi is approximately %5.3f.' % math.pi)
    The value of pi is approximately 3.142.
    ```


  - ```py
    print("place%d" % cnt)
    print('[%d,%d],mid:%d' %(l,r, mid))#按照位置对应(3个变量)
    ```

## format()方法 字符串格式化操作

- [string ---对比两种字符串格式化方式](https://docs.python.org/zh-cn/3/library/string.html#format-examples)
  - [string — examples — Python 3.11.1 documentation](https://docs.python.org/3/library/string.html#format-examples)

- [内置类型str.format函数原型 — Python 文档](https://docs.python.org/zh-cn/3/library/stdtypes.html#str.format)
- [string --- 常见的字符串操作](https://docs.python.org/zh-cn/3/library/string.html#formatstrings)
- [PEP 3101 – Advanced String Formatting | peps.python.org](https://peps.python.org/pep-3101/)

- python字符串的第二种格式化方式

  - 比类C语言的printf()更加强大,支持的操作也更加的丰富

  - 这种格式化方法,是编写一个格式字符串(包含格式化目标的字符串的结构信息)

    - 不妨称其为结构字符串`structure_str`
      - 结构字符串中可以包含一些特定的符合规定的表达式,例如访问format()提供的参数对象的属性或者元素(项)
      - 对于按位置访问format()中的参数,可以使用位置索引(0,1,...)
      - 对于按名称访问format()参数,则使用名称作为索引,而不需要考虑format()参数位置顺序
    - 那么这种字符串格式方法的形式`structure_str.foramt()`

  - 然后将具体的值填充到对应的位置,组织成需要的目标字符串

    - ```py
      >>> '{}, {}, {}'.format('a', 'b', 'c')  # 3.1+ only
      'a, b, c'
      
      ```

    - ```python
      '{}, {:^5}, {}'.format('a', 'b', 'c') 
      # 'a,   b  , c'
      ```
  
      
  
  - 按位置访问参数:

    - 比如更好的支持复用以及变量插入字符串顺序调整

      - ```py
        >>> '{0} {1} {0}'.format('abra', 'cad')   # arguments' indices can be repeated
        'abra cad abra'
        ```
  
        
  
    - 支持字符串对象解包

      - ```py
        >>> '{2}, {1}, {0}'.format(*'abc')      # unpacking argument sequence
        'c, b, a'
        >>> '{1}, {1}, {0}'.format(*'abc')      # unpacking argument sequence
        'b, b, a'
        ```
  
  - 按**名称**访问参数:
  
    - ```python
      >>> 'Coordinates: {latitude}, {longitude}'.format(latitude='37.24N', longitude='-115.81W')
      'Coordinates: 37.24N, -115.81W'
      >>> coord = {'latitude': '37.24N', 'longitude': '-115.81W'}
      >>> 'Coordinates: {latitude}, {longitude}'.format(**coord)
      'Coordinates: 37.24N, -115.81W'
      ```
  
  - 访问对象属性
  
    - 下面一个python自带的复数对象为例
  
    - ```python
      >>> c = 3-5j
      >>> c
      (3-5j)
      >>> c.real
      3.0
      >>> c.imag
      -5.0
      >>> d=4+2j
      >>> d
      (4+2j)
      ```
  
      ```python
      
      >>> ('The complex number {0} is formed from the real part {0.real} '
      ...  'and the imaginary part {0.imag}.').format(c)
      'The complex number (3-5j) is formed from the real part 3.0 and the imaginary part -5.0.'
      
      >>> 'The complex number:{0},{1};imag parts:({0.imag}),({1.imag}) '.format(c,d)
      'The complex number:(3-5j),(4+2j);imag parts:(-5.0),(2.0) '
      
      ```
  
      - 结构字符串中的{0}表示对象c
        - {0.real}=c.real
  
  - 访问参数的项:
  
    - ```python
      >>> coord = (3, 5)
      >>> 'X: {0[0]};  Y: {0[1]}'.format(coord)
      'X: 3;  Y: 5'
      ```


### 代替`%s`,`%r`🎈

- ```python
  >>> "repr() shows quotes: {!r}; str() doesn't: {!s}".format('test1', 'test2')
  "repr() shows quotes: 'test1'; str() doesn't: test2"
  
  ```

- `!r`和`%r`都可以用于在字符串格式化中将一个值转换为其`repr()`形式，但它们的语法有所不同。
  - `!r`是一种新的格式化语法，它出现在使用`str.format()`方法或者f-strings时。它的作用是对传入的值进行`repr()`处理，以便在字符串中显示它们的原始表示形式。例如，`'Hello, {!r}!'.format('world')`将产生结果`'Hello, 'world'!'`，而不是`'Hello, world!'`。
  - `%r`是旧的格式化语法，它出现在使用`%`运算符时。它的功能与`!r`相同，即对传入的值进行`repr()`处理，并将其插入到格式化字符串中。例如，`'Hello, %r!' % 'world'`将产生结果`'Hello, 'world'!'`。
  - 虽然这两种语法的作用基本相同，但它们的语法和用法略有不同。通常情况下，应该使用最适合你的代码风格和需求的语法。如果你在使用较新版本的Python（3.6及更高版本），那么推荐使用`!r`语法。如果使用较旧版本的Python，或者在某些情况下无法使用`!r`，则可以考虑使用`%r`。

### 对齐文本以及指定宽度@居中设置

- ```py
  >>> '{:<30}'.format('left aligned')
  'left aligned                  '
  >>>
  >>> '{:>30}'.format('right aligned')
  '                 right aligned'
  >>>
  >>> '{:^30}'.format('centered')
  '           centered           '
  >>>
  >>> '{:*^30}'.format('centered')  # use '*' as a fill char
  '***********centered***********'
  ```

### 其他

- 替代 `%+f`, `%-f` 和 `% f` 以及指定正负号:

  - ```python
    '{:+f}; {:+f}'.format(3.14, -3.14)  # show it always
    '+3.140000; -3.140000'
    '{: f}; {: f}'.format(3.14, -3.14)  # show a space for positive numbers
    ' 3.140000; -3.140000'
    '{:-f}; {:-f}'.format(3.14, -3.14)  # show only the minus -- same as '{:f}; {:f}'
    '3.140000; -3.140000'
    ```

- 替代 `%x` 和 `%o` 以及转换基于不同进位制的值:

  - ```py
    # format also supports binary numbers
    "int: {0:d};  hex: {0:x};  oct: {0:o};  bin: {0:b}".format(42)
    
    # with 0x, 0o, or 0b as prefix:
    "int: {0:d};  hex: {0:#x};  oct: {0:#o};  bin: {0:#b}".format(42)
    ```

- 逗号作为千位分隔符

  - ```py
    '{:,}'.format(1234567890)
    
    '1,234,567,890'
    ```

- 表示为百分数

  - ```py
    points = 19
    total = 22
    'Correct answers: {:.2%}'.format(points/total)
    
    'Correct answers: 86.36%'
    ```

### 综合例

- ```python
  #双阶乘
  from functools import reduce
  def df_basic(n):
      l = range(n, 0, -2)
      res = reduce(lambda x, y: x * y, l)
      list_str = str(list(l))
      print("n=%-3d-->" % n, "{:-^30}".format(list_str), "product_res=%d" % res)
  
      return res
  
  test_list = [3, 4, 5, 8, 9, 16]
  res = list(map(df_basic, test_list))
  ```

  - ```bash
    PS D:\repos\PythonLearn\scripts>  py double_factorial.py
    n=3  --> ------------[3, 1]------------ product_res=3
    n=4  --> ------------[4, 2]------------ product_res=8
    n=5  --> ----------[5, 3, 1]----------- product_res=15
    n=8  --> ---------[8, 6, 4, 2]--------- product_res=384
    n=9  --> -------[9, 7, 5, 3, 1]-------- product_res=945
    n=16 --> -[16, 14, 12, 10, 8, 6, 4, 2]- product_res=10321920
    ```

    

##  f-string 字符串

  - 格式字符串语法
    - [格式规格迷你语言](https://docs.python.org/zh-cn/3/library/string.html#format-specification-mini-language)
    - [格式示例](https://docs.python.org/zh-cn/3/library/string.html#format-examples)
  - [模板字符串](https://docs.python.org/zh-cn/3/library/string.html#template-strings)
  - [辅助函数](https://docs.python.org/zh-cn/3/library/string.html#helper-functions)

###  f-string
- [PEP 498 – Literal String Interpolation](https://www.python.org/dev/peps/pep-0498/)

- a f-string looks like:
`
f ' <text> { <expression> <optional !s, !r, or !a> <optional : format specifier> } <text> ... '
`

- Python supports multiple ways to format text strings. 
- 	These include `%-formatting` [[1\]](https://www.python.org/dev/peps/pep-0498/#id12), `str.format()` [[2\]](https://www.python.org/dev/peps/pep-0498/#id13), and `string.Template` [[3\]](https://www.python.org/dev/peps/pep-0498/#id14). 
- Each of these methods have their advantages, but in addition have disadvantages that make them cumbersome to use in practice. 
- This PEP proposed to add a new string formatting mechanism: Literal String Interpolation. In this PEP, such strings will be referred to as "f-strings", taken from the leading character used to denote such strings, and standing for "formatted strings".

### f-string examples:
 ```python
     import datetime
     name = 'Fred'
     age = 50
     anniversary = datetime.date(1991, 10, 12)
    #  example1:
     f'My name is {name}, my age next year is {age+1}, my anniversary is {anniversary:%A, %B %d, %Y}.'
    >>> 'My name is Fred, my age next year is 51, my anniversary is Saturday, October 12, 1991.'
    # example2:
     f'He said his name is {name!r}.'
    >>>"He said his name is 'Fred'."
 ```

###  format specifiers
- [https://www.python.org/dev/peps/pep-0498/#id30](https://www.python.org/dev/peps/pep-0498/#id30)[Format specifiers](https://peps.python.org/pep-0498/#format-specifiers)

- Format specifiers may also contain evaluated expressions. This allows code such as:

```python
>>> width = 10
>>> precision = 4
>>> value = decimal.Decimal('12.34567')
>>> f'result: {value:{width}.{precision}}'
'result:      12.35'
```

- Once expressions in a format specifier are evaluated (if necessary), format specifiers are not interpreted by the f-string evaluator. Just as in `str.format()`, they are merely passed in to the `__format__()` method of the object being formatted.

## 小结

- 控制一个字符串格式,可以分为2部分

  - 被控制的输出对象(变量)(object/variable)
  - 控制格式(format)

- 上述这些方式中,他们都是变量在前,而控制格式在后

  - 只有f-string方式中,格式控制是在变量之后

  - ```python
    s=123
    print("[%10s]"%s)
    print("[%10s]"%(str(s).center(10)))
    print("[{:^10}]".format(s))
    print(f"[{s:^10}]")
    print(f"[{format(s,'^10')}]")
    ```

    - ```bash
      [       123]
      [   123    ]
      [   123    ]
      [   123    ]
      [   123    ]
      ```

  - f-string可读性强,但是由于不像shell语言(比如powershell)和`Kotlin`那样可以不许在字符串前插入`f`,写起来手感差一些

  - 所以实际操作中通常建议坚持一种格式控制方式,先想好控制格式,然后开始写代码

- f-strings是最简洁和易读的字符串格式化方法，同时还支持更多的功能，例如表达式求值、函数调用等。但是，它只能在Python 3.6及以上的版本中使用。而%风格的字符串格式化和str.format()方法则可以在Python 2.x和Python 3.x中使用，但是语法稍微繁琐一些。

### 打印n维数组带变量标签@打印长内容

#### varName的方式打印整齐的numpy数组🎈

- ```python
  var=np.random.rand(3,4)
  print(var,'@{var}')#这里用{}是为了能够利用IDE的变量不全提示而已,@也可以自由取舍和修改
  ```

  - ```
    [[0.11348592 0.27222936 0.08205775 0.76527058]
     [0.02168872 0.13725135 0.26062867 0.87108257]
     [0.17941007 0.43327873 0.32511791 0.58340419]] @{var}
    ```

    

- 对比:

  - ```python
    var=np.random.rand(3,4)
    print(f'{var=}')
    ```

  - ```
    var=array([[0.65701977, 0.65230895, 0.82171856, 0.40276676],
           [0.03756505, 0.98463162, 0.44814283, 0.93763523],
           [0.67204106, 0.26669688, 0.56406436, 0.95693298]])
    ```

### 使用2个打印语句来打印长内容

- 尽管多个打印语句总是可以合并为一个打印语句,但是在调式代码的时候,将要答应的内容写成多个答应语句有时更加高效

- 特别是在notebook中打印一个超长的列表,将变量名插在后面就不容易查看

  - ```python
    print("{varName}")
    print(varName)
    ```

  - 例如:

    - ```bash
      Ones Tensor: 
       tensor([[1, 1],
              [1, 1]]) 
      ```

      

##  Raw f-string

- [https://www.python.org/dev/peps/pep-0498/#id43](https://www.python.org/dev/peps/pep-0498/#id43)

# python@string@编码

## refs

- [词法分析 — Python 3文档](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#strings)
  - [ 字面值¶](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#literals)

- [字符串和编码  (liaoxuefeng.com)](https://www.liaoxuefeng.com/wiki/1016959663602400/1017075323632896)
- [Text Sequence Type — [`str`]](https://docs.python.org/3/library/stdtypes.html#str)
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