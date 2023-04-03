[toc]



##  references
###  标准文档(library)
- [正则表达式操作](https://docs.python.org/zh-cn/3.9/library/re.html?highlight=findall#re.findall)
###  补充教程(howTo)

- [HOWTO本文档是在Python中使用 re 模块使用正则表达式的入门教程。 它提供了比“标准库参考”中相应部分更平和的介绍。](https://docs.python.org/zh-cn/3/howto/regex.html#regex-howto)

* [Python HOWTOs — Python  documentation](https://docs.python.org/3/howto/index.html)

  * [正则表达式HOWTO](https://docs.python.org/zh-cn/3/howto/regex.html#)
  * [概述](https://docs.python.org/zh-cn/3/howto/regex.html#introduction)
  * [简单模式](https://docs.python.org/zh-cn/3/howto/regex.html#simple-patterns)

    * [匹配字符](https://docs.python.org/zh-cn/3/howto/regex.html#matching-characters)
    * [重复](https://docs.python.org/zh-cn/3/howto/regex.html#repeating-things)
  * [使用正则表达式](https://docs.python.org/zh-cn/3/howto/regex.html#using-regular-expressions)🎈
    * [编译正则表达式](https://docs.python.org/zh-cn/3/howto/regex.html#compiling-regular-expressions)
    * [反斜杠灾难](https://docs.python.org/zh-cn/3/howto/regex.html#the-backslash-plague)
    * [应用匹配](https://docs.python.org/zh-cn/3/howto/regex.html#performing-matches)
    * [模块级函数](https://docs.python.org/zh-cn/3/howto/regex.html#module-level-functions)
    * [编译标志](https://docs.python.org/zh-cn/3/howto/regex.html#compilation-flags)
  * [更多模式能力](https://docs.python.org/zh-cn/3/howto/regex.html#more-pattern-power)
  
    * [更多元字符](https://docs.python.org/zh-cn/3/howto/regex.html#more-metacharacters)
    * [分组](https://docs.python.org/zh-cn/3/howto/regex.html#grouping)
    * [非捕获和命名组](https://docs.python.org/zh-cn/3/howto/regex.html#non-capturing-and-named-groups)
    * [前向断言](https://docs.python.org/zh-cn/3/howto/regex.html#lookahead-assertions)
  * [修改字符串](https://docs.python.org/zh-cn/3/howto/regex.html#modifying-strings)
  
    * [分割字符串](https://docs.python.org/zh-cn/3/howto/regex.html#splitting-strings)
    * [搜索和替换](https://docs.python.org/zh-cn/3/howto/regex.html#search-and-replace)
  * [常见问题](https://docs.python.org/zh-cn/3/howto/regex.html#common-problems)
  
    * [使用字符串方法](https://docs.python.org/zh-cn/3/howto/regex.html#use-string-methods)
    * [match() 和 search()](https://docs.python.org/zh-cn/3/howto/regex.html#match-versus-search)
    * [贪婪与非贪婪](https://docs.python.org/zh-cn/3/howto/regex.html#greedy-versus-non-greedy)
    * [使用 re.VERBOSE](https://docs.python.org/zh-cn/3/howto/regex.html#using-re-verbose)

## 使用python正则表达式

### 编译正则表达式

- 正则表达式被编译成模式对象，模式对象具有各种操作的方法，例如搜索模式匹配或执行字符串替换。:

  ```python
  >>> import re
  >>> p = re.compile('ab*')
  >>> p
  re.compile('ab*')
  ```

- [`re.compile()`](https://docs.python.org/zh-cn/3/library/re.html#re.compile) 也接受一个可选的 *flags* 参数，用于启用各种特殊功能和语法变体。 

  ```python
  >>> p = re.compile('ab*', re.IGNORECASE)
  ```

- 正则作为字符串传递给 [`re.compile()`](https://docs.python.org/zh-cn/3/library/re.html#re.compile) 。 

- 正则被处理为字符串，因为正则表达式<u>不是核心Python语言的一部分</u>，并且没有创建用于表达它们的特殊语法。

  - （有些应用程序根本不需要正则，因此不需要通过包含它们来扩展语言规范。）
  - 相反，[`re`](https://docs.python.org/zh-cn/3/library/re.html#module-re) 模块只是Python附带的C扩展模块，就类似于 [`socket`](https://docs.python.org/zh-cn/3/library/socket.html#module-socket) 或 [`zlib`](https://docs.python.org/zh-cn/3/library/zlib.html#module-zlib) 模块。

### 正则模式对象和方法@正则匹配🎈

- 一旦你有一个表示编译正则表达式的对象(得到<u>正则模式对象</u>)，你可以用它做什么？
-  模式对象有几种方法和属性。 
- 这里只介绍最重要的内容；请参阅 [`re`](https://docs.python.org/zh-cn/3/library/re.html#module-re) 文档获取完整列表。

- | 方法 / 属性  | 目的                                                         |
  | :----------- | :----------------------------------------------------------- |
  | `match()`    | 确定正则是否从字符串的开头匹配。                             |
  | `search()`   | 扫描字符串，查找此正则匹配的**任何位置**。                   |
  | `findall()`  | 找到正则匹配的所有子字符串，并将它们作为列表返回。           |
  | `finditer()` | 找到正则匹配的所有子字符串，并将它们返回为一个 [iterator](https://docs.python.org/zh-cn/3/glossary.html#term-iterator)。 |

- 如果没有找到匹配， [`match()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.match) 和 [`search()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.search) 返回 `None` 。

- 如果它们成功， 一个 [匹配对象](https://docs.python.org/zh-cn/3/library/re.html#match-objects) (Match-object)实例将被返回，包含匹配相关的信息：

  - <u>起始和终结位置、匹配的子串以及其它。</u>

- 你可以通过交互式实验 [`re`](https://docs.python.org/zh-cn/3/library/re.html#module-re) 模块来了解这一点。


#### 获取所有匹配字串的索引

- 借助模式对象的`finditer()`方法,再迭代它可以获取索引信息,末尾的例子中使用了`finditer`

### redemo.py

- 如果你有 [`tkinter`](https://docs.python.org/zh-cn/3/library/tkinter.html#module-tkinter)，你可能还想查看 [Tools/demo/redemo.py](https://github.com/python/cpython/tree/3.11/Tools/demo/redemo.py)，这是 Python 发行附带的演示程序。

  -  它允许你输入正则和字符串，并显示RE是匹配还是失败。 
    - 它像vscode这类编辑器的正则搜索一样
    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/58df1684726b4dcba4faf410dcffdbec.png)
  - `redemo.py` 在尝试调试复杂的正则时非常有用。


### 匹配对象@常用方法🎈

- 首先，运行 Python 解释器，导入 [`re`](https://docs.python.org/zh-cn/3/library/re.html#module-re) 模块，然后编译一个正则,得到要给正则模式对象Pattern

- 调用某个Pattern的方法,得到匹配对象(Match),检查 [匹配对象](https://docs.python.org/zh-cn/3/library/re.html#match-objects) 以获取有关匹配字符串的信息。 

- 匹配对象实例也有几个方法和属性；最重要的是：

  | 方法 / 属性 | 目的                                 |
  | :---------- | :----------------------------------- |
  | `group()`   | 返回正则匹配的字符串                 |
  | `start()`   | 返回匹配的开始位置                   |
  | `end()`     | 返回匹配的结束位置                   |
  | `span()`    | 返回包含匹配 (start, end) 位置的元组 |

- 尝试这些方法很快就会清楚它们的含义:

  - [`group()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.group) 返回正则匹配的**子字符串**。

  -  [`start()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.start) 和 [`end()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.end) 返回匹配的起始和结束索引。

  -  [`span()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.span) 在单个元组中返回开始和结束索引。

  -  由于 [`match()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.match) 方法只检查正则是否**<u>在字符串的开头</u>**匹配，所以 `start()` 将始终为零。 

    - match()有点像startswith()的泛化版,

  - 模式的 [`search()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.search) 方法会扫描字符串，因此在这种情况下匹配可能不会从零开始。:

    ```python
    >>> print(p.match('::: message'))
    None
    >>> m = p.search('::: message'); print(m)
    <re.Match object; span=(4, 11), match='message'>
    >>> m.group()
    'message'
    >>> m.span()
    (4, 11)
    ```

  - 在实际程序中，最常见的样式是在变量中存储 [匹配对象](https://docs.python.org/zh-cn/3/library/re.html#match-objects)，然后检查它是否为 `None`。 这通常看起来像:

    ```python
    p = re.compile( ... )
    m = p.match( 'string goes here' )
    if m:
        print('Match found: ', m.group())
    else:
        print('No match')
    ```

  - 两种模式方法返回模式的所有匹配项。 [`findall()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.findall) 返回匹配字符串的列表:

    ```python
    >>> p = re.compile(r'\d+')
    >>> p.findall('12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
    ['12', '11', '10']
    ```

  - 在这个例子中需要 `r` 前缀，使字面为原始字符串字面，因为普通的“加工”字符串字面中的**转义序列**不能被 Python 识别为正则表达式，导致 [`DeprecationWarning`](https://docs.python.org/zh-cn/3/library/exceptions.html#DeprecationWarning) 并最终产生 [`SyntaxError`](https://docs.python.org/zh-cn/3/library/exceptions.html#SyntaxError)。 请参阅 [反斜杠灾难](https://docs.python.org/zh-cn/3/howto/regex.html#the-backslash-plague)。

  - [`findall()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.findall) 必须先创建整个列表才能返回结果。

    -  [`finditer()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.finditer) 方法将一个 [匹配对象](https://docs.python.org/zh-cn/3/library/re.html#match-objects) 的序列返回为一个 [iterator](https://docs.python.org/zh-cn/3/glossary.html#term-iterator)
    
    ```python
    >>> iterator = p.finditer('12 drummers drumming, 11 ... 10 ...')
    >>> iterator  
    <callable_iterator object at 0x...>
    >>> for match in iterator:
    ...     print(match.span())
    ...
    (0, 2)
    (22, 24)
    (29, 31)
    ```

### 分组

- 通常，你需要获取更多信息，而不仅仅是正则是否匹配。

-  正则表达式通常用于通过将正则分成几个子组来解析字符串，这些子组匹配不同的感兴趣组件。 例如，RFC-822 标题行分为标题名称和值，用 `':'` 分隔，如下所示：

- ```
  From: author@example.com
  User-Agent: Thunderbird 1.5.0.9 (X11/20061227)
  MIME-Version: 1.0
  To: editor@example.com
  ```

- 这可以通过编写与整个标题行匹配的正则表达式来处理，并且具有与标题名称匹配的一个组，以及与标题的值匹配的另一个组。

- Groups are marked by the `'('`, `')'` metacharacters. `'('` and `')'` have much the same meaning as they do in mathematical expressions;

-  they group together the expressions contained inside them, and you can repeat the contents of a group with a quantifier, such as `*`, `+`, `?`, or `{m,n}`. For example, `(ab)*` will match zero or more repetitions of `ab`.

- ```
  >>> p = re.compile('(ab)*')
  >>> print(p.match('ababababab').span())
  (0, 10)
  ```

- 用 `'('`，`')'` 表示的组也捕获它们匹配的文本的起始和结束索引；

  - 这可以通过将参数传递给 [`group()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.group)、[`start()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.start)、[`end()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.end) 以及 [`span()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.span)。 组从 0 开始编号。
  - 组 0 **始终存在**；它表示整个正则，所以 [匹配对象](https://docs.python.org/zh-cn/3/library/re.html#match-objects) 方法都将组 0 作为默认参数。

- ```
  >>> p = re.compile('(a)b')
  >>> m = p.match('ab')
  >>> m.group()
  'ab'
  >>> m.group(0)
  'ab'
  ```

- **子组**从左到右编号，从 1 向上编号。**组0**不需要括号,是整个正则表达式匹配的最大部分(最大组)

  - 子组的内容是组0的某个部分

-  组可以嵌套；要确定编号，只需计算从左到右的左括号字符。:

- ```
  >>> p = re.compile('(a(b)c)d')
  >>> m = p.match('abcd')
  >>> m.group(0)
  'abcd'
  >>> m.group(1)
  'abc'
  >>> m.group(2)
  'b'
  ```

- [`group()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.group) 可以一次传递多个组号，在这种情况下，它将返回一个包含这些组的相应值的元组。:

- ```
  >>> m.group(2,1,2)
  ('b', 'abc', 'b')
  ```

- [`groups()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.groups) 方法返回一个元组，其中包含所有子组的字符串，从1到最后一个子组。:

- ```
  >>> m.groups()
  ('abc', 'b')
  ```

#### 引用组

- 模式中的**后向引用**允许你指定还必须在字符串中的当前位置<u>找到先前捕获组的内容</u>。

-  例如，如果可以在当前位置找到组 1 的确切内容，则 `\1` 将成功，否则将失败。 

  - 请记住，Python 的字符串文字也使用**反斜杠后跟数字**以允许在字符串中包含任意字符，因此正则中引入反向引用时务必使用**原始字符串**`\r''`。

  - 例如，以下正则检测字符串中的双字。:

  - ```
    >>> p = re.compile(r'\b(\w+)\s+\1\b')
    >>> p.search('Paris in the the spring').group()
    'the the'
    ```

- 像这样的后向引用通常不仅仅用于搜索字符串 —— 很少有文本格式以这种方式重复数据

- 你很快就会发现它们在执行字符串替换时 *非常* 有用。🎈

### 非捕获和命名组

- 精心设计的正则可以使用许多组，既可以捕获感兴趣的子串，也可以对正则本身进行分组和构建。
-  在复杂的正则中，很难跟踪**组号**。 
  - 有两个功能可以帮助解决这个问题。 它们都使用常用语法进行正则表达式扩展
  - Perl 5 以其对标准正则表达式的强大补充而闻名。 对于这些新功能，Perl 开发人员无法选择新的单键击元字符或以 `\` 开头的新特殊序列，否则 Perl 的正则表达式与标准正则容易混淆。 例如，如果他们选择 `&` 作为一个新的元字符，旧的表达式将假设 `&` 是一个普通字符，并且不会编写 `\&` 或 `[&]`。
  - Perl 开发人员选择的解决方案是使用 `(?...)` 作为扩展语法。 括号后面紧跟 `?` 是一个语法错误，因为 `?` 没有什么可重复的，所以这样并不会带来任何兼容性问题。 紧跟在 `?` 之后的字符表示正在使用的扩展语法，所以 `(?=foo)` 是一种语法（一个前视断言）和 `(?:foo)` 是另一种语法（ 包含子表达式 `foo` 的非捕获组）。

- Python 支持一些 Perl 的扩展，并<u>增加了新的扩展语法用于 Perl 的扩展语法</u>。 
  - 如果<u>在问号之后的第一个字符</u>为 `P`，即表明其为 Python 专属的扩展。

- 有时你会想要使用组来表示正则表达式的一部分，但是对检索组的内容不感兴趣。

-  你可以通过使用**非捕获组**来显式表达这个事实: `(?:...)`，你可以用任何其他正则表达式替换 `...`。:

\>>>

- ```py
  >>> m = re.match("([abc])+", "abc")
  >>> m.groups()
  ('c',)
  >>> m = re.match("(?:[abc])+", "abc")
  >>> m.groups()
  ()
  ```

  -  对于模式串`([abc])+`,只包含一对括号,意味着子分组只有1组;并且组内`()`只包含一个字符.

  - `m.gruops()`结果返回的是所有子分组构成的元组,模式串中子分组只有一个,所以应该返回包含一个字符的元组

  - 由于模式串匹配主串`abc`的过程中,(在子组0范围内)主串中的每个字符将被逐个接受模式串的匹配,所以最终停留在字符`c`

  - ```python
    >>> m = re.match("(a[bc])+", "abac123")
    >>> m.groups()
    ('ac',)
    >>> m.group(0,1)
    ('abac', 'ac')
    ```

    - 本例中,模式串`(a[bc])+`
      1. 匹配中`ab`
      2. 匹配中`ac`(括号中的内容就是`ac`)

  - ```python
    >>> m = re.match("(a[bcd])+", "abacad123")
    >>> m.group(0,1)
    ('abacad', 'ad')
    ```

    | 模式串分组(括号)第i次命中 | 命中的主串片段 |
    | :-----------------------: | :------------: |
    |             1             |       ab       |
    |             2             |       ac       |
    |             3             |       ad       |

    - 子组内容为最后一次命中的主串片段`ad`

    - 如果将模式串中的`+`去掉,则:

      - ```python
        >>> m = re.match("(a[bcd])", "abacad123")
        >>> m.group(0,1)
        ('ab', 'ab')
        ```

        

- ```python
  >>> m = re.match("([abc])", "abca123")
  >>> m.groups()
  ('a',)
  >>> m = re.match("([abc])([abc])", "abc123")
  >>> m.groups()
  ('a', 'b')
  ```

  

- 除了你无法检索组匹配内容的事实外，非捕获组的行为与捕获组完全相同；

- 你可以在里面放任何东西，用重复元字符重复它，比如 `*`，然后把它嵌入其他组（捕获或不捕获）。

-  `(?:...)` 在修改现有模式时特别有用，因为你可以添加新组而不更改所有其他组的编号方式。 

- 值得一提的是，捕获和非捕获组之间的搜索没有性能差异；两种形式没有一种更快。

- 更重要的功能是命名组：不是通过数字引用它们，而是可以**通过名称引用组**。

- 命名组的语法是Python特定的扩展之一: `(?P<name>...)`。

  -  *name* 显然是该组的名称。 命名组的行为与捕获组完全相同，并且还将名称与组关联。

  -  处理捕获组的 [匹配对象](https://docs.python.org/zh-cn/3/library/re.html#match-objects) 方法都接受按编号引用组的整数或包含所需组名的字符串。 命名组仍然是给定的数字，因此你可以通过两种方式检索有关组的信息:

- \>>>

- ```
  >>> p = re.compile(r'(?P<word>\b\w+\b)')
  >>> m = p.search( '(((( Lots of punctuation )))' )
  >>> m.group('word')
  'Lots'
  >>> m.group(1)
  'Lots'
  ```


#### 命名分组提取为字典

- 此外，你可以通过 [`groupdict()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.groupdict) 将**命名分组**提取为一个字典:

- \>>>

- ```
  >>> m = re.match(r'(?P<first>\w+) (?P<last>\w+)', 'Jane Doe')
  >>> m.groupdict()
  {'first': 'Jane', 'last': 'Doe'}
  ```

- Named groups are handy because they let you use easily remembered names, instead of having to remember numbers. Here's an example RE from the [`imaplib`](https://docs.python.org/zh-cn/3/library/imaplib.html#module-imaplib) module:

- ```python
  InternalDate = re.compile(r'INTERNALDATE "'
          r'(?P<day>[ 123][0-9])-(?P<mon>[A-Z][a-z][a-z])-'
          r'(?P<year>[0-9][0-9][0-9][0-9])'
          r' (?P<hour>[0-9][0-9]):(?P<min>[0-9][0-9]):(?P<sec>[0-9][0-9])'
          r' (?P<zonen>[-+])(?P<zoneh>[0-9][0-9])(?P<zonem>[0-9][0-9])'
          r'"')
  ```

- 检索 `m.group('zonem')` 显然要容易得多，而不必记住检索第 9 组。

- 表达式中的后向引用语法，例如 `(...)\1`，指的是组的编号。 当然有一种变体使用组名而不是数字。 这是另一个 Python 扩展: `(?P=name)` 表示在当前点再次匹配名为 *name* 的组的内容。 用于查找双字的正则表达式，`\b(\w+)\s+\1\b` 也可以写为 `\b(?P<word>\w+)\s+(?P=word)\b`:

\>>>

```python
>>> p = re.compile(r'\b(?P<word>\w+)\s+(?P=word)\b')
>>> p.search('Paris in the the spring').group()
'the the'
```

## 修改字符串

- 正则表达式通常也用于以各种方式**修改字符串**，使用以下模式方法：

- | 方法 / 属性 | 目的                                                     |
  | :---------- | :------------------------------------------------------- |
  | `split()`   | 将字符串拆分为一个列表，在正则匹配的任何地方将其拆分     |
  | `sub()`     | 找到正则匹配的**所有子字符串**，并用不同的字符串替换它们 |
  | `subn()`    | 与 `sub()` 相同，但返回<u>新字符串和替换次数</u>         |

### 分割字符串

- 模式的 [`split()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.split) 方法在正则匹配的任何地方拆分字符串，返回一个片段列表。 它类似于 [`split()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#str.split) 字符串方法，但在分隔符的分隔符中提供了更多的通用性；字符串的 `split()` 仅支持按空格或固定字符串进行拆分。 正如你所期望的那样，还有一个模块级 [`re.split()`](https://docs.python.org/zh-cn/3/library/re.html#re.split) 函数。

- .**split**(*string*[, *maxsplit=0*])

  通过正则表达式的匹配拆分 *字符串*。 如果在正则中使用捕获括号，则它们的内容也将作为结果列表的一部分返回。 如果 *maxsplit* 非零，则最多执行 *maxsplit* 次拆分。

你可以通过传递 *maxsplit* 的值来限制分割的数量。 当 *maxsplit* 非零时，将最多进行 *maxsplit* 次拆分，并且字符串的其余部分将作为列表的最后一个元素返回。 在以下示例中，分隔符是任何非字母数字字符序列。:

\>>>

```python
>>> p = re.compile(r'\W+')
>>> p.split('This is a test, short and sweet, of split().')
['This', 'is', 'a', 'test', 'short', 'and', 'sweet', 'of', 'split', '']
>>> p.split('This is a test, short and sweet, of split().', 3)
['This', 'is', 'a', 'test, short and sweet, of split().']
```

有时你不仅对分隔符之间的文本感兴趣，而且还需要知道分隔符是什么。 

如果在正则中使用**捕获括号**，则它们的值也将作为列表的一部分返回。 比较以下调用:

\>>>

```python
>>> p = re.compile(r'\W+')
>>> p2 = re.compile(r'(\W+)')
>>> p.split('This... is a test.')
['This', 'is', 'a', 'test', '']
>>> p2.split('This... is a test.')
['This', '... ', 'is', ' ', 'a', ' ', 'test', '.', '']
```

模块级函数 [`re.split()`](https://docs.python.org/zh-cn/3/library/re.html#re.split) 添加要正则作为第一个参数，但在其他方面是相同的。:

\>>>

```python
>>> re.split(r'[\W]+', 'Words, words, words.')
['Words', 'words', 'words', '']
>>> re.split(r'([\W]+)', 'Words, words, words.')
['Words', ', ', 'words', ', ', 'words', '.', '']
>>> re.split(r'[\W]+', 'Words, words, words.', 1)
['Words', 'words, words.']
```

### 搜索和替换🎈

- 另一个常见任务是找到模式的所有匹配项，并用不同的字符串替换它们。
-  [`sub()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.sub) 方法接受一个替换值，可以是字符串或函数，也可以是要处理的字符串。

- .**sub**(*replacement*, *string*[, *count=0*])

  - 返回通过替换 *replacement* 替换 *string* 中正则的最左边非重叠出现而获得的字符串。 如果未找到模式，则 *string* 将保持不变。

  - 可选参数 *count* 是要替换的模式最大的出现次数；*count* 必须是非负整数。 默认值 0 表示替换所有。

- 这是一个使用 [`sub()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.sub) 方法的简单示例。 它用 `colour` 这个词取代颜色名称:

\>>>

```python
>>> p = re.compile('(blue|white|red)')
>>> p.sub('colour', 'blue socks and red shoes')
'colour socks and colour shoes'
>>> p.sub('colour', 'blue socks and red shoes', count=1)
'colour socks and red shoes'
```

- [`subn()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.subn) 方法完成相同的工作，但返回一个包含新字符串值和已执行的替换次数的 2 元组:

\>>>

```python
>>> p = re.compile('(blue|white|red)')
>>> p.subn('colour', 'blue socks and red shoes')
('colour socks and colour shoes', 2)
>>> p.subn('colour', 'no colours at all')
('no colours at all', 0)
```

- 仅当空匹配与前一个空匹配不相邻时，才会替换空匹配。:

\>>>

```python
>>> p = re.compile('x*')
>>> p.sub('-', 'abxd')
'-a-b--d-'
```

- 如果 *replacement* (sub第1个参数)是一个字符串，则处理其中的任何反斜杠转义。
-  也就是说，`\n` 被转换为单个换行符，`\r` 被转换为回车符，依此类推。 
  - 诸如 `\&` 之类的未知转义是孤立的。
  -  后向引用，例如 `\6`，被替换为正则中相应组匹配的子字符串。 
  - 这使你可以在生成的替换字符串中<u>合并原始文本的部分内容</u>。

这个例子匹配单词 `section` 后跟一个用 `{`，`}` 括起来的字符串，并将 `section` 改为 `subsection`

- 这里使用了re.VERBOSE,可以插入一些空格来提高模式串正则表达式的可读性(同时不影响结果).

```python
>>> p = re.compile('section{ ( [^}]* ) }', re.VERBOSE)
>>> p.sub(r'subsection{\1}','section{First} section{second}')
'subsection{First} subsection{second}'
```

- 还有一种语法用于引用由 `(?P<name>...)` 语法定义的命名组。 
- `\g<name>` 将使用名为 `name` 的组匹配的子字符串，`\g<number>` 使用相应的组号。
-  因此 `\g<2>` 等同于 `\2`，但在诸如 `\g<2>0` 之类的替换字符串中并不模糊。
-  (`\20` 将被解释为对组 20 的引用，而不是对组 2 的引用，后跟字面字符 `'0'`。) 以下替换都是等效的，但使用所有三种变体替换字符串。:

\>>>

```python
>>> p = re.compile('section{ (?P<name> [^}]* ) }', re.VERBOSE)
>>> p.sub(r'subsection{\1}','section{First}')
'subsection{First}'
>>> p.sub(r'subsection{\g<1>}','section{First}')
'subsection{First}'
>>> p.sub(r'subsection{\g<name>}','section{First}')
'subsection{First}'
```

- *replacement* 也可以是一个函数，它可以为你提供更多控制。 如果 *replacement* 是一个函数，则为 *pattern* 的每次非重叠出现将调用该函数。 在每次调用时，函数都会传递一个匹配的 [匹配对象](https://docs.python.org/zh-cn/3/library/re.html#match-objects) 参数，并可以使用此信息计算所需的替换字符串并将其返回。

- 在以下示例中，替换函数将小数转换为十六进制:


\>>>

```python
>>> def hexrepl(match):
...     "Return the hex string for a decimal number"
...     value = int(match.group())
...     return hex(value)
...
>>> p = re.compile(r'\d+')
>>> p.sub(hexrepl, 'Call 65490 for printing, 49152 for user code.')
'Call 0xffd2 for printing, 0xc000 for user code.'
```

使用模块级别 [`re.sub()`](https://docs.python.org/zh-cn/3/library/re.html#re.sub) 函数时，模式作为第一个参数传递。 模式可以是对象或字符串；如果需要指定正则表达式标志，则必须使用模式对象作为第一个参数，或者在模式字符串中使用嵌入式修饰符，例如: `sub("(?i)b+", "x", "bbbb BBBB")` 返回 `'x x'`。

### 使用 re.VERBOSE

- 到目前为止，你可能已经注意到正则表达式是一种非常紧凑的表示法，但它们并不是非常易读。 具有中等复杂度的正则可能会成为反斜杠、括号和元字符的冗长集合，使其难以阅读和理解。

- 对于这样的正则，在编译正则表达式时指定 [`re.VERBOSE`](https://docs.python.org/zh-cn/3/library/re.html#re.VERBOSE) 标志可能会有所帮助，因为它允许你更清楚地格式化正则表达式。

- `re.VERBOSE` 标志有几种效果。 正则表达式中的 *不是* 在字符类中的**空格将被忽略**。
-  这意味着表达式如 `dog | cat` 等同于不太可读的 `dog|cat` ，但 `[a b]` 仍将匹配字符 `'a'` 、 `'b'` 或空格。
-  此外，你还可以在正则中放置注释；注释从 `#` 字符扩展到下一个换行符。 当与三引号字符串一起使用时，这使正则的格式更加整齐:

```python
pat = re.compile(r"""
 \s*                 # Skip leading whitespace
 (?P<header>[^:]+)   # Header name
 \s* :               # Whitespace, and a colon
 (?P<value>.*?)      # The header's value -- *? used to
                     # lose the following trailing whitespace
 \s*$                # Trailing whitespace to end-of-line
""", re.VERBOSE)
```

这更具有可读性:

```python
pat = re.compile(r"\s*(?P<header>[^:]+)\s*:(?P<value>.*?)\s*$")
```



## 例

### 使用正则表达式将wikipedia的段落转为markdown文本

- 从文件中读取文本

  - ```python
    # import os
    import os.path as op
    
    
    dirName = "./"
    fileName = 'tt'
    filePath = op.join(dirName, fileName)
    if op.exists(filePath):
        print("file exist!")
    else:
        print("file does not exist!")
    print("\n"*2)
    with open(fileName, encoding="utf-8") as f:
        read_data = f.read()
    # print(read_data)
    ```

  - 用于测试程序的文本内容

    - 段落1

    ```txt
    向量(Image: {\displaystyle \mathbf {y} ={\begin{bmatrix}y_{1}&y_{2}&\cdots &y_{m}\end{bmatrix}}^{\mathsf {T}}})关于标量 x的导数可以（用分子记法）写成
    (Image: {\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x}}\\{\frac {\partial y_{2}}{\partial x}}\\\vdots \\{\frac {\partial y_{m}}{\partial x}}\\\end{bmatrix}}})
    在向量微积分中，向量(Image: \mathbf {y})关于标量(Image: x)的导数也被称为向量(Image: \mathbf {y})的切向量，(Image: {\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}})。注意这里(Image: {\displaystyle \mathbf {y} :\mathbb {R} \rightarrow \mathbb {R} ^{n}})。
    例子 简单的样例包括欧式空间中的速度向量，它是位移向量（看作关于时间的函数）的切向量。更进一步而言， 加速度是速度的切向量。
    ```

    - 段落2

    ```
    假设X是一个定义在可数样本空间S上的离散随机变量 S ⊆ R，则其概率质量函数 fX(x) 为
    (Image: f_{X}(x)={\begin{cases}\Pr(X=x),&x\in S,\\0,&x\in {\mathbb  {R}}\backslash S.\end{cases}})
    注意这在所有实数上，包括那些X不可能等于的实数值上，都定义了 fX(x)。在那些X不可能等于的实数值上， fX(x)取值为0 ( x ∈ R\S，取Pr(X = x) 为0)。
    离散随机变量概率质量函数的不连续性决定了其累积分布函数也不连续。
    ```

    

  - 任务:

    - 将`(Image: xxx  )`全部替换为`$xxx$`

  - 源文本特点:

    - 这些被替换的结构相互不嵌套
    - 需要注意`xxx`可以有多重括号
    - 为了使得转换后的markdown文本更加严格,应当将潜在的`xxx`两侧的不确定数量的空格全部移除
    - 完成这个任务可以不用正则(例如replace,trim函数搭配),此处用正则作为演示
    - 包含模式对象的`finditer`等方法,获取所有匹配的子串的**索引**

- 直接运行下面代码之前,请将测试文本调整调整一下,比如将变量`test_text`改为`read_data`

  ```python
  
  import re
  ##
  test_text = r"w(Image: f_{X}(x))xx(Image: f_{Y}(Y))={\begin{cases}\Pr(X=x),&x\in S,\\0,&x\in {\mathbb  {R}}\backslash S.\end{cases}}  )j111"
  contents = read_data
  # 分片策略
  indexes_token = []
  p = re.compile(r"\(Image:")
  matches = p.finditer(contents)
  # matches
  for match in matches:
      span = match.span()
      start = span[0]
      indexes_token.append(start)
  # print(indexes_token)
  seg_tuples = [i for i in indexes_token]
  refine_segs = []
  
  bl = list('([{')  # brackets_left
  br = list(')]}')  # brackets_right
  
  # def get_last_rp(s):
  #     """ get right parenthesis index """
  #     return s.rfind(')')
  
  
  def puts(s):
      print(s, end='')
  
  
  # indexes_token.insert(0,0)
  indexes_token.append(len(contents))
  indexes_seg = indexes_token
  puts(read_data[:indexes_token[0]])
  p1 = re.compile(r'\(Image:\s*')
  for i in range(len(indexes_seg)-1):
  
      start = indexes_seg[i]
      end = indexes_seg[i+1]
      # end_rp=s1[:end].rfind(')')+1
      end_rp = start+contents[start:end].rfind(')')
      end_rp_next = end_rp+1
      # print(start,end_rp)
      seg = contents[start:end]
      # print(seg)
      # 处理`(imag: `
      t = p1.sub(r'$', seg)
      # 处理各段最后一个右括号`)`
      # 方法1:
      # seg_rp = t[:end].rfind(')')
      # seg_rp_next=seg_rp+1
      # # print(seg_rp)
      # puts(t[:seg_rp_next]+'$'+t[seg_rp_next+1:])
      # # refine_segs.append(s1[start:end_rp])
      # 放法2:用正则方法(兼容性不足)
      # print(t)
      # p2 = re.compile(r'(.*[^\s])(\s*\))')
      # res = p2.sub(r'\1$', t)
      # 方法3:括号对数计数法
      cntl=0
      close_rp=0
      # print(t,"\n")
      for i in range(len(t)):
          if(t[i] =='('):
              cntl+=1
              # print(i)
          elif (t[i] ==')'):
              close_rp+=1
              # print(i)
          if close_rp==cntl+1:
              break
      # print(cntl,close_rp)
      print(t[:i]+'$'+t[i+1:])
  
  
  ```

- 替换处理结果:

  - ```text
    向量${\displaystyle \mathbf {y} ={\begin{bmatrix}y_{1}&y_{2}&\cdots &y_{m}\end{bmatrix}}^{\mathsf {T}}}$关于标量 x的导数可以（用分子记法）写成
    ${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x}}\\{\frac {\partial y_{2}}{\partial x}}\\\vdots \\{\frac {\partial y_{m}}{\partial x}}\\\end{bmatrix}}}$
    在向量微积分中，向量$\mathbf {y}$关于标量$x$的导数也被称为向量$\mathbf {y}$的切向量，${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}}$。注意这里${\displaystyle \mathbf {y} :\mathbb {R} \rightarrow \mathbb {R} ^{n}}$。
    例子 简单的样例包括欧式空间中的速度向量，它是位移向量（看作关于时间的函数）的切向量。更进一步而言， 加速度是速度的切向量。
    ```

- 渲染结果

  - 向量${\displaystyle \mathbf {y} ={\begin{bmatrix}y_{1}&y_{2}&\cdots &y_{m}\end{bmatrix}}^{\mathsf {T}}}$关于标量 x的导数可以（用分子记法）写成 ${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x}}\\{\frac {\partial y_{2}}{\partial x}}\\\vdots \\{\frac {\partial y_{m}}{\partial x}}\\\end{bmatrix}}}$ 在向量微积分中，向量$\mathbf {y}$关于标量$x$的导数也被称为向量$\mathbf {y}$的切向量，${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}}$。注意这里${\displaystyle \mathbf {y} :\mathbb {R} \rightarrow \mathbb {R} ^{n}}$。 例子 简单的样例包括欧式空间中的速度向量，它是位移向量（看作关于时间的函数）的切向量。更进一步而言， 加速度是速度的切向量。

- 测试2:

  - 假设X是一个定义在可数样本空间S上的离散随机变量 S ⊆ R，则其概率质量函数 fX(x) 为
    $f_{X}(x)={\begin{cases}\Pr(X=x),&x\in S,\\0,&x\in {\mathbb  {R}}\backslash S.\end{cases}}$
    注意这在所有实数上，包括那些X不可能等于的实数值上，都定义了 fX(x)。在那些X不可能等于的实数值上， fX(x)取值为0 ( x ∈ R\S，取Pr(X = x) 为0)。
    离散随机变量概率质量函数的不连续性决定了其累积分布函数也不连续。

- 说明:本程序并不完美,对于复杂情况,可能需要自行手动调整

### 使用re正则编写一个生成latex矩阵的程序

- ```python
  ## 
  import re
  import numpy as np
  from functools import reduce
  size=[5,5]
  type="pmatrix"
  s=reduce(lambda x,y:x*y,size)
  # 整形元素矩阵(arange()的参数是整数时,产生的时整形元素;参数是浮点数时,则产生浮点数矩阵)
  mat=np.arange(s).reshape(size)
  #浮点型元素的矩阵(numpy默认为浮点型)
  # mat=np.ones(size)
  mat=np.array(
      [[1,-2,-3.1],[3,5,-1],[7.2,1,-1]]
  )
  
  ## 
  begin=r"\begin{"+type+"}"
  end=r"\end{"+type+"}"
  integer=False
  # integer=True
  # print(begin,end)# (str(begin),end)
  
  #使用元素遍历的方案
  ## 
  print(begin)
  for i in mat:
      l=[str(j) for j in i]
      line="&\t".join(l)+"\t"+r"\\"
      print("\t"+line)
  print(end)
  
  
  #使用正则表达式的方案:
  ##
  latex_mat_body=[]
  print(begin)
  if(integer):
      p=re.compile(r'(\d+)(\.?)')
      for i in mat:
          # print(str(i))
          line=str(i)
          line=re.sub(r'\[|\]','',line)
          # print(type)
          latex_mat_line = p.sub(r'\t\1&', line)
          latex_mat_line = latex_mat_line[:-1]+"\t"+r"\\"
          #注意使用`r'\1'`原始字符串便于处理分组引用\1组
          print(latex_mat_line)
          # latex_mat_body.append(latex_mat_line)
          # body="\n".join(latex_mat_body)
  else:
      for i in mat:
          # p=re.compile(r'(-?\d+(\.*\d*))')
          line=str(i)
          # print(line)
          p=re.compile(r'(-?\d+\.*\d*)')
          # 去除中括号(注意`]`前潜在的空格)
          line=re.sub(r'\[|\s*\]','',line)
          # print(type)
          #注意使用`r'\1'`原始字符串便于处理分组引用\1组
          latex_mat_line = p.sub(r'\t\1&', line)
          #去掉末尾的&,防止空列产生
          latex_mat_line = latex_mat_line[:-1]+"\t"+r"\\"
          print(latex_mat_line)
  print(end)
  ##
  
  ```
  
  - ```tex
    \begin{pmatrix}
    	0& 	1& 	2& 	3& 	4	\\
    	5& 	6& 	7& 	8& 	9	\\	
    	10& 	11& 	12& 	13& 	14	\\
    	15& 	16& 	17& 	18& 	19	\\
    	20& 	21& 	22& 	23& 	24	\\
    \end{pmatrix}
    ```
  
  - ```tex
    \begin{pmatrix}
     	1.&  	-2.&  	-3.1	\\
     	3.&  	5.& 	-1.	\\
     	7.2&  	1.&  	-1.	\\
    \end{pmatrix}
    ```
  
    
  
  
  
- $$
  \\
  \begin{pmatrix}
  	0& 	1& 	2& 	3& 	4	\\
  	5& 	6& 	7& 	8& 	9	\\
  	10& 	11& 	12& 	13& 	14	\\
  	15& 	16& 	17& 	18& 	19	\\
  	20& 	21& 	22& 	23& 	24	\\
  \end{pmatrix}
  \\
  \begin{pmatrix}
   	1.&  	-2.&  	-3.1	\\
   	3.&  	5.& 	-1.	\\
   	7.2&  	1.&  	-1.	\\
  \end{pmatrix}
  $$

  
