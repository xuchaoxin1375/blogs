[toc]



##  references
###  标准文档(library)

- [re — Regular expression operations — Python  documentation](https://docs.python.org/3/library/re.html)

- 中文文档:[re --- 正则表达式操作 — Python  文档](https://docs.python.org/zh-cn/3/library/re.html)

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

### 编译正则表达式🎈

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

## 辅助GUI程序redemo.py

- 如果你有 [`tkinter`](https://docs.python.org/zh-cn/3/library/tkinter.html#module-tkinter)，你可能还想查看 [Tools/demo/redemo.py](https://github.com/python/cpython/tree/3.11/Tools/demo/redemo.py)，这是 Python 发行附带的演示程序。

  -  它允许你输入正则和字符串，并显示RE是匹配还是失败。 
    - 它像vscode这类编辑器的正则搜索一样
    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/58df1684726b4dcba4faf410dcffdbec.png)
  - `redemo.py` 在尝试调试复杂的正则时非常有用。

## re模块内容@Module Contents[¶](https://docs.python.org/3/library/re.html?highlight=findall#module-contents)

- The module defines several functions, constants, and an exception. Some of the functions are simplified versions of the full featured methods for compiled regular expressions. Most non-trivial applications always use the compiled form.
- 该模块定义了几个函数、常量和一个异常。
  - 其中**一些函数**是编译正则表达式的完整功能方法的**简化版本**。
    - 提供这些简化后的函数是为了以更简洁的方式处理简单的问题,而不需要编译形式
  - 大多数复杂的应用程序始终使用**编译形式**。

## `re.[functions]`

- re.**compile**(*pattern*, *flags=0*)

  Compile a regular expression pattern into a [regular expression object](https://docs.python.org/3/library/re.html?highlight=findall#re-objects), which can be used for matching using its [`match()`](https://docs.python.org/3/library/re.html?highlight=findall#re.Pattern.match), [`search()`](https://docs.python.org/3/library/re.html?highlight=findall#re.Pattern.search) and other methods, described below.

  - The expression’s behaviour can be modified by specifying a *flags* value. Values can be any of the following variables, combined using bitwise OR (the `|` operator).
  - The sequence:
    - `prog = re.compile(pattern);result = prog.match(string) `
    - is equivalent to`result = re.match(pattern, string) `but using [`re.compile()`](https://docs.python.org/3/library/re.html?highlight=findall#re.compile) and saving the resulting regular expression object for **reuse** is more **efficient** when the expression will be used several times in a single program.
    - Note The compiled versions of the most recent patterns passed to [`re.compile()`](https://docs.python.org/3/library/re.html?highlight=findall#re.compile) and the module-level matching functions are cached, so programs that use only a few regular expressions at a time needn’t worry about compiling regular expressions.

- re.**search**(*pattern*, *string*, *flags=0*)

  Scan through *string* looking for <u>**the first location** where the regular expression *pattern* produces a match</u>, and return a corresponding [match object](https://docs.python.org/3/library/re.html?highlight=findall#match-objects). Return `None` if no position in the string matches the pattern; note that this is different from finding a zero-length match at some point in the string.

- re.**match**(*pattern*, *string*, *flags=0*)
  - If zero or more characters <u>at the beginning of *string*</u> match the regular expression *pattern*, return a corresponding [match object](https://docs.python.org/3/library/re.html?highlight=findall#match-objects). Return `None` if the string does not match the pattern; note that this is different from a zero-length match.
  - Note that even in [`MULTILINE`](https://docs.python.org/3/library/re.html?highlight=findall#re.MULTILINE) mode, [`re.match()`](https://docs.python.org/3/library/re.html?highlight=findall#re.match) will only match at the beginning of the string and <u>not at the beginning of each line</u>.
  - If you want to locate a match anywhere in *string*, use [`search()`](https://docs.python.org/3/library/re.html?highlight=findall#re.search) instead (see also [search() vs. match()](https://docs.python.org/3/library/re.html?highlight=findall#search-vs-match)).

- re.**fullmatch**(*pattern*, *string*, *flags=0*)

  If <u>the whole *string*</u> matches the regular expression *pattern*, return a corresponding [match object](https://docs.python.org/3/library/re.html?highlight=findall#match-objects). Return `None` if the string does not match the pattern; note that this is different from a zero-length match.

- re.**split**(*pattern*, *string*, *maxsplit=0*, *flags=0*)

  - Split *string* by the occurrences of *pattern*. If capturing **parentheses** are used in *pattern*, then the text of all groups in the pattern are also returned as part of the resulting list. 
  - If *maxsplit* is nonzero, at most *maxsplit* splits occur, and the remainder of the string is returned as the final element of the list.

  ```python
  >>> re.split(r'\W+', 'Words, words, words.')
  ['Words', 'words', 'words', '']
  >>> re.split(r'(\W+)', 'Words, words, words.')
  ['Words', ', ', 'words', ', ', 'words', '.', '']
  >>> re.split(r'\W+', 'Words, words, words.', 1)
  ['Words', 'words, words.']
  >>> re.split('[a-f]+', '0a3B9', flags=re.IGNORECASE)
  ['0', '3', '9']
  ```

  - If there are **capturing groups** in the separator and it matches at the start of the string, the result will start with an empty string. The same holds for the end of the string:
  - 如果分隔符里有捕获组合，并且匹配到字符串的开始，那么结果将会以一个空字符串开始。对于结尾也是一样

  ```python
  >>> re.split(r'(\W+)', '...words, words...')
  ['', '...', 'words', ', ', 'words', '...', '']
  ```

  That way, separator components are always found at the same relative indices within the result list.

  **Empty matches** for the pattern **split** the string only when <u>not adjacent to a previous **empty match**</u>.

  该句话的含义为：对于正则表达式模式中的**空匹配**，只有当其<u>不与前一个空匹配相邻时，才会将其用于分割字符串。</u>

  具体来说，当正则表达式模式中存在连续的空匹配时，只有第一个空匹配会被用于分割字符串，后续的空匹配不会被用于分割字符串，因为它们与前一个空匹配相邻。

  换句话说，正则表达式模式中的空匹配只有在不相邻的情况下才会被用于分割字符串，以避免出现重复的分割结果。

  ```python
  >>> re.split(r'\b', 'Words, words, words.')
  ['', 'Words', ', ', 'words', ', ', 'words', '.']
  >>> re.split(r'\W*', '...words...')
  ['', '', 'w', 'o', 'r', 'd', 's', '', '']
  >>> re.split(r'(\W*)', '...words...')
  ['', '...', '', '', 'w', '', 'o', '', 'r', '', 'd', '', 's', '...', '', '', '']
  ```

### re.split的分割过程

- ```bash
  Signature: re.split(pattern, string, maxsplit=0, flags=0)
  
  Docstring:
  Split the source string by the occurrences of the pattern,
  returning a list containing the resulting substrings.  If
  capturing parentheses are used in pattern, then the text of all
  groups in the pattern are also returned as part of the resulting
  list.  If maxsplit is nonzero, at most maxsplit splits occur,
  and the remainder of the string is returned as the final element
  of the list.
  ```

  

- ```python
  In [8]: re.split(r'\W', '...words...')
  Out[8]: ['', '', '', 'words', '', '', '']
  ```

  - 我们以上面的例子为例,大致地描述re.split是如何从头处理一个主串的
  - `\W`会匹配`'...words...'`的第一个字符(第一个`.`字符),从而划分为两组:`""`和`'..words...'`,我们称每次划分得到的第2组为剩余串,剩余串的长度会随着分割<u>越来越短</u>
  - `\W`会匹配剩余串的第一个`.`,分割为`""`和`'.words...'`
  - `\W`再次匹配剩余串`.`,分割为`""`和`word...`
  - 依次类推...
  - 收集所有分割组,得到`['', '', '', 'words', '', '', '']`

### 检查所有发生匹配的位置@re.finditer

- ```python
  In [27]: it=p.finditer('ab')
  
  In [28]: list(it)
  Out[28]:
  [<re.Match object; span=(0, 0), match=''>,
   <re.Match object; span=(1, 1), match=''>,
   <re.Match object; span=(2, 2), match=''>]
  ```

  

## 模糊重复

### `*`

- Causes the resulting RE to match <u>0 or more repetitions of the preceding RE</u>, as many repetitions as are possible.

-  `ab*` will match ‘a’, ‘ab’, or ‘a’ followed by any number of ‘b’s.

- 又比如:`x*`,可以匹配的字符串集合为`S={'','x','xx','xxx',...}`

- 此外`a`,`ab`这类不属于S的字符串表面上看不会产生匹配,但是由于带`*`(被`*`修饰)的模式串总是可以匹配空字符的,因此所有字符都至少可以认为存在一个空字符成分(不可见)

- 下面的例子会更具清除的说明这点(使用ipython shell进行演示,略去了不关紧要的内容)

- ```python
  In [33]: px=re.compile("x*")
  
  In [34]: px.search("xx")
  Out[34]: <re.Match object; span=(0, 2), match='xx'>
  
  In [35]: sl=['','x','xxx','a','ab','abx']
  
  In [39]: for x in sl:
      ...:     res=p.search(x)
      ...:     print(repr(x),res)
      ...:
  '' <re.Match object; span=(0, 0), match=''>
  'x' <re.Match object; span=(0, 1), match='x'>
  'xxx' <re.Match object; span=(0, 3), match='xxx'>
  'a' <re.Match object; span=(0, 0), match=''>
  'ab' <re.Match object; span=(0, 0), match=''>
  'abx' <re.Match object; span=(0, 0), match=''>
  
  In [41]: for x in sl:
      ...:     #res=p.search(x)
      ...:     print(repr(x),list(p.finditer(x)))
      ...:
  '' [<re.Match object; span=(0, 0), match=''>]
  'x' [<re.Match object; span=(0, 1), match='x'>, <re.Match object; span=(1, 1), match=''>]
  'xxx' [<re.Match object; span=(0, 3), match='xxx'>, <re.Match object; span=(3, 3), match=''>]
  'a' [<re.Match object; span=(0, 0), match=''>, <re.Match object; span=(1, 1), match=''>]
  'ab' [<re.Match object; span=(0, 0), match=''>, <re.Match object; span=(1, 1), match=''>, <re.Match object; span=(2, 2), match=''>]
  'abx' [<re.Match object; span=(0, 0), match=''>, <re.Match object; span=(1, 1), match=''>, <re.Match object; span=(2, 3), match='x'>, <re.Match object; span=(3, 3), match=''>]
  ```

## 补充概念

### 空匹配@empty match

- "Empty matches" 是正则表达式中的一个概念，指的是一个匹配不包含任何字符的情况。在正则表达式中，有一些特殊的元字符和量词可以匹配空字符串或空白字符，例如 `*`、`?`、`{0,1}` 等。当使用这些元字符和量词进行匹配时，**有可能**会出现空匹配的情况。

  例如，正则表达式模式 `a*` 可以匹配任意数量的字符 "a"，包括零个 "a"。当匹配的字符串中包含连续的 "a" 时，正则表达式会匹配所有的 "a" 字符，但当匹配的字符串中不包含 "a" 时，正则表达式也会返回一个空匹配。

- 以下试验用`ipython` shell进行:

- `\W`可以匹配非单词字符,而`\W*`可以匹配<u>0个或多个非单词字符</u>,这里我们尝试得到**空匹配**结果,也就是`\W*`去匹配若干个<u>单词字符</u>,由于`\W*`可以匹配0个非单词字符,因此当被匹配的字符串为"w"这个字母的时候其实是可以匹配成功的,只不过匹配的内容长度为0(也就是发生`空匹配`)

- 为什么说匹配的部分长度为0也可以算作匹配成功?

  - 这取决于`*`特殊的作用(它能够匹配(包括了)主串中出现了0次模式串的情况),人们为这特殊的情况取了个名字叫空匹配(empty match)

- ```python
  In [14]: re.search(r'\W*', 'w')
  Out[14]: <re.Match object; span=(0, 0), match=''>
  #
  In [13]: re.findall(r'\W*', 'word')
  Out[13]: ['', '', '', '', '']
  ```

### 空字符@增广字符😎

- 为例更好的描述空匹配,我们定义空字符(串)是长度为0的字符串对象(不同于None)
- 以字符串`abxd`为例,`x*`匹配字符串`abxd`(这是一个包含4个非空字符的字符串),如果算上空字符,那么包含`2n+1`个**增广字符**(我将其定义为非空字符两侧都各有一个空字符),增广字符只在允许匹配0次的情况下有意义
  - `·a·b·x·d·`

### 例：

- `x*`,可以匹配的字符串集合为`S={'','x','xx','xxx',...}`，写作增广的形式：`S={'·','·x·','·x·x·','·x·x·x·',...}`或简洁的曾广：`S={'·','x·','xx·','xxx·',...}`

- ```python
  
  In [33]: px=re.compile("x*")
  
  In [43]: px
  Out[43]: re.compile(r'x*', re.UNICODE)
  
  In [44]: px.finditer('x')
  Out[44]: <callable_iterator at 0x18b09f4e520>
  
  In [45]: list(px.finditer('x'))
  Out[45]:
  [<re.Match object; span=(0, 1), match='x'>,
   <re.Match object; span=(1, 1), match=''>]
  
  In [46]: list(px.finditer('xx'))
  Out[46]:
  [<re.Match object; span=(0, 2), match='xx'>,
   <re.Match object; span=(2, 2), match=''>]
  
  In [49]: px.subn("-","")
  Out[49]: ('-', 1)
  
  In [47]: px.subn("-","x")
  Out[47]: ('--', 2)
  
  In [48]: px.subn("-","xxx")
  Out[48]: ('--', 2)
  
  
  ```

  

## 带转义符模式(`\<ASCII>`)

- The special sequences consist of `'\'` and a character from the list below. 
- If the ordinary character is not an ASCII digit or an ASCII letter, then the resulting RE will match <u>the second character</u>. For example, `\$` matches the character `'$'`.

- `\number`:

  1. Matches the contents of the **group** of the same number.
  2. Groups are numbered starting from `1`
  3. For example, `(.+) \1` matches `'the the'` or `'55 55'`, but not `'thethe'` (note the space after the group). 
  4. This special sequence can only be used to match <u>one of the first 99 groups</u>.
  5. If the first digit of *number* is 0, or *number* is 3 octal digits long, it will not be interpreted as a group match, but as the character with octal value *number*. 
  6. Inside the `'['` and `']'` of a character class, all numeric escapes are treated as characters.

- `\A`

  Matches only at the start of the string.

- `\b`
  - <u>Matches the **empty string**, but only at the beginning or end of a word.</u> 
  - A word is defined as a sequence of word characters. Note that formally, `\b` is defined as the **boundary** between a `\w` and a `\W` character (or vice versa), or between `\w` and the beginning/end of the string. 
  - This means that `r'\bfoo\b'` matches `'foo'`, `'foo.'`, `'(foo)'`, `'bar foo baz'` but not `'foobar'` or `'foo3'`.By default Unicode alphanumerics are the ones used in Unicode patterns, but this can be changed by using the [`ASCII`](https://docs.python.org/3/library/re.html?highlight=findall#re.ASCII) flag. 
  - Word boundaries are determined by the current locale if the [`LOCALE`](https://docs.python.org/3/library/re.html?highlight=findall#re.LOCALE) flag is used. Inside a character range, `\b` represents the backspace character, for compatibility with Python’s string literals.

- `\B`

  Matches the empty string, but only when it is *not* at the beginning or end of a word. This means that `r'py\B'` matches `'python'`, `'py3'`, `'py2'`, but not `'py'`, `'py.'`, or `'py!'`. `\B` is just the opposite of `\b`, so word characters in Unicode patterns are Unicode alphanumerics or the underscore, although this can be changed by using the [`ASCII`](https://docs.python.org/3/library/re.html?highlight=findall#re.ASCII) flag. Word boundaries are determined by the current locale if the [`LOCALE`](https://docs.python.org/3/library/re.html?highlight=findall#re.LOCALE) flag is used.

- `\d`

  For Unicode (str) patterns:Matches any Unicode decimal digit (that is, any character in Unicode character category [Nd]). This includes `[0-9]`, and also many other digit characters. If the [`ASCII`](https://docs.python.org/3/library/re.html?highlight=findall#re.ASCII) flag is used only `[0-9]` is matched.For 8-bit (bytes) patterns:Matches any decimal digit; this is equivalent to `[0-9]`.

- `\D`

  Matches any character which is not a decimal digit. This is the opposite of `\d`. If the [`ASCII`](https://docs.python.org/3/library/re.html?highlight=findall#re.ASCII) flag is used this becomes the equivalent of `[^0-9]`.

- `\s`

  For Unicode (str) patterns:Matches Unicode whitespace characters (which includes `[ \t\n\r\f\v]`, and also many other characters, for example the non-breaking spaces mandated by typography rules in many languages). If the [`ASCII`](https://docs.python.org/3/library/re.html?highlight=findall#re.ASCII) flag is used, only `[ \t\n\r\f\v]` is matched.For 8-bit (bytes) patterns:Matches characters considered whitespace in the ASCII character set; this is equivalent to `[ \t\n\r\f\v]`.

- `\S`

  Matches any character which is not a whitespace character. This is the opposite of `\s`. If the [`ASCII`](https://docs.python.org/3/library/re.html?highlight=findall#re.ASCII) flag is used this becomes the equivalent of `[^ \t\n\r\f\v]`.

- `\w`
  - For Unicode (str) patterns:Matches <u>Unicode word characters</u>; 
    - this includes alphanumeric characters (as defined by [`str.isalnum()`](https://docs.python.org/3/library/stdtypes.html#str.isalnum)) as well as the underscore (`_`). 
    - If the [`ASCII`](https://docs.python.org/3/library/re.html?highlight=findall#re.ASCII) flag is used, only `[a-zA-Z0-9_]` is matched.
  - For 8-bit (bytes) patterns:Matches characters considered alphanumeric in the ASCII character set; 
    - this is equivalent to `[a-zA-Z0-9_]`.
    -  If the [`LOCALE`](https://docs.python.org/3/library/re.html?highlight=findall#re.LOCALE) flag is used, matches characters considered alphanumeric in the current locale and the underscore.

- `\W`

  <u>Matches any character which is not a word character</u>. This is the opposite of `\w`. If the [`ASCII`](https://docs.python.org/3/library/re.html?highlight=findall#re.ASCII) flag is used this becomes the equivalent of `[^a-zA-Z0-9_]`. If the [`LOCALE`](https://docs.python.org/3/library/re.html?highlight=findall#re.LOCALE) flag is used, matches characters which are neither alphanumeric in the current locale nor the underscore.

- `\Z`

  Matches only at the end of the string.

Most of the standard escapes supported by Python string literals are also accepted by the regular expression parser:

```
\a      \b      \f      \n
\N      \r      \t      \u
\U      \v      \x      \\
```

(Note that `\b` is used to represent word boundaries, and means “backspace” only inside character classes.)

`'\u'`, `'\U'`, and `'\N'` escape sequences are only recognized in Unicode patterns. In bytes patterns they are errors. Unknown escapes of ASCII letters are reserved for future use and treated as errors.

## `re.Pattern`类@Regular Expression Objects

- [re — re-object— Python documentation](https://docs.python.org/3/library/re.html?highlight=findall#re-objects)

- 这个类不是必须的,但是对于复杂的正则表达式,可以提高处理速度.

- Pattern.**search**(*string*[, *pos*[, *endpos*]])

  Scan through *string* looking for <u>the first location where this regular expression produces a **match**</u>, and return a corresponding [match object](https://docs.python.org/3/library/re.html?highlight=findall#match-objects). 

  Return `None` if no position in the string matches the pattern; note that this is different from finding a zero-length match at some point in the string.

  The optional second parameter *pos* gives an index in the string <u>where the search is to start;</u> it defaults to `0`. 

  - This is not completely equivalent to slicing the string; the `'^'` pattern character matches at the real beginning of the string and at positions just after a newline, but not necessarily at the index where the search is to start.

  - The optional parameter *endpos* limits how far the string will be searched; it will be as if the string is *endpos* characters long, so only the characters from *pos* to `endpos - 1` will be searched for a match. If *endpos* is less than *pos*, no match will be found; otherwise, if *rx* is a compiled regular expression object, `rx.search(string, 0, 50)` is equivalent to `rx.search(string[:50], 0)`.

  - ```python
    pattern = re.compile("d")
    pattern.search("dog")     # Match at index 0
    #<re.Match object; span=(0, 1), match='d'>
    pattern.search("dog", 1)  # No match; search doesn't include the "d"
    ```

    

- Pattern.**match**(*string*[, *pos*[, *endpos*]])

  - If zero or more characters at the *beginning* of *string* match this regular expression, return a corresponding [match object](https://docs.python.org/3/library/re.html?highlight=findall#match-objects). Return `None` if the string does not match the pattern; note that this is different from a zero-length match.The optional *pos* and *endpos* parameters have the same meaning as for the [`search()`](https://docs.python.org/3/library/re.html?highlight=findall#re.Pattern.search) method.>>>
  - If you want to locate a match anywhere in *string*, use [`search()`](https://docs.python.org/3/library/re.html?highlight=findall#re.Pattern.search) instead (see also [search() vs. match()](https://docs.python.org/3/library/re.html?highlight=findall#search-vs-match)).

  - ```python
    pattern = re.compile("o")
    pattern.match("dog")      # No match as "o" is not at the start of "dog".
    pattern.match("dog", 1)   # Match as "o" is the 2nd character of "dog".
    #<re.Match object; span=(1, 2), match='o'>
    ```

    

- Pattern.**fullmatch**(*string*[, *pos*[, *endpos*]])

  If <u>the whole *string*</u> matches this regular expression, return a corresponding [match object](https://docs.python.org/3/library/re.html?highlight=findall#match-objects). Return `None` if the string does not match the pattern; note that this is different from a zero-length match.The optional *pos* and *endpos* parameters have the same meaning as for the [`search()`](https://docs.python.org/3/library/re.html?highlight=findall#re.Pattern.search) method.

  - ```python
    pattern = re.compile("o[gh]")
    pattern.fullmatch("dog")      # No match as "o" is not at the start of "dog".
    pattern.fullmatch("ogre")     # No match as not the full string matches.
    pattern.fullmatch("doggie", 1, 3)   # Matches within given limits.
    #<re.Match object; span=(1, 3), match='og'>
    ```

- Pattern.**split**(*string*, *maxsplit=0*)

  Identical to the [`split()`](https://docs.python.org/3/library/re.html?highlight=findall#re.split) function, using the compiled pattern.

- Pattern.**findall**(*string*[, *pos*[, *endpos*]])

  Similar to the [`findall()`](https://docs.python.org/3/library/re.html?highlight=findall#re.findall) function, using the compiled pattern, but also accepts optional *pos* and *endpos* parameters that limit the search region like for [`search()`](https://docs.python.org/3/library/re.html?highlight=findall#re.search).

- Pattern.**finditer**(*string*[, *pos*[, *endpos*]])

  Similar to the [`finditer()`](https://docs.python.org/3/library/re.html?highlight=findall#re.finditer) function, using the compiled pattern, but also accepts optional *pos* and *endpos* parameters that limit the search region like for [`search()`](https://docs.python.org/3/library/re.html?highlight=findall#re.search).

- Pattern.**sub**(*repl*, *string*, *count=0*)

  Identical to the [`sub()`](https://docs.python.org/3/library/re.html?highlight=findall#re.sub) function, using the compiled pattern.

- Pattern.**subn**(*repl*, *string*, *count=0*)

  Identical to the [`subn()`](https://docs.python.org/3/library/re.html?highlight=findall#re.subn) function, using the compiled pattern.

- Pattern.**flags**

  The regex matching flags. This is a combination of the flags given to [`compile()`](https://docs.python.org/3/library/re.html?highlight=findall#re.compile), any `(?...)` inline flags in the pattern, and implicit flags such as `UNICODE` if the pattern is a Unicode string.

- Pattern.**groups**

  The number of capturing groups in the pattern.

- Pattern.**groupindex**

  A dictionary mapping any symbolic group names defined by `(?P<id>)` to group numbers. The dictionary is empty if no symbolic groups were used in the pattern.

- Pattern.**pattern**

  The pattern string from which the pattern object was compiled.

## `re.Match`类🎈

- [re — match-object — Python  documentation](https://docs.python.org/3/library/re.html?highlight=findall#match-objects)

- 首先，运行 Python 解释器，导入 [`re`](https://docs.python.org/zh-cn/3/library/re.html#module-re) 模块，然后编译一个正则,得到要给正则**模式对象**`Pattern`

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

- ```python
  >>> p = re.compile('(ab)*')
  >>> print(p.match('ababababab').span())
  (0, 10)
  ```

- 用 `'('`，`')'` 表示的组也捕获它们匹配的文本的起始和结束索引；

  - 这可以通过将参数传递给 [`group()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.group)、[`start()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.start)、[`end()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.end) 以及 [`span()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.span)。 组从 0 开始编号。
  - 组 0 **始终存在**；它表示整个正则，所以 [匹配对象](https://docs.python.org/zh-cn/3/library/re.html#match-objects) 方法都将组 0 作为默认参数。

- ```python
  >>> p = re.compile('(a)b')
  >>> m = p.match('ab')
  >>> m.group()
  'ab'
  #m.group()等价于m.group(0)
  >>> m.group(0)
  'ab'
  ```
  
- **子组**从左到右编号，从 1 向上编号。**组0**不需要括号,是整个正则表达式匹配的最大部分(最大组)

  - 子组的内容是组0的某个部分

-  组可以**嵌套**；要确定编号，只需计算从左到右的左括号字符。:

- ```python
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

- ```python
  >>> m.group(2,1,2)
  ('b', 'abc', 'b')
  ```

- [`groups()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.groups) 方法返回一个元组，其中包含所有**子组**的字符串，即,从`1`(而不是从0)到最后一个子组。:

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

- ```python
  >>> p = re.compile(r'(?P<word>\b\w+\b)')
  >>> m = p.search( '(((( Lots of punctuation )))' )
  >>> m.group('word')
  'Lots'
  >>> m.group(1)
  'Lots'
  ```


#### 命名分组提取为字典

- 此外，你可以通过 [`groupdict()`](https://docs.python.org/zh-cn/3/library/re.html#re.Match.groupdict) 将**命名分组**提取为一个字典:

- ```python
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

## 修改字符串😎

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

```python
>>> p = re.compile(r'\W+')
>>> p.split('This is a test, short and sweet, of split().')
['This', 'is', 'a', 'test', 'short', 'and', 'sweet', 'of', 'split', '']
>>> p.split('This is a test, short and sweet, of split().', 3)
['This', 'is', 'a', 'test, short and sweet, of split().']
```

有时你不仅对分隔符之间的文本感兴趣，而且还需要知道分隔符是什么。 

如果在正则中使用**捕获括号**，则它们的值也将作为列表的一部分返回。 比较以下调用:

```python
>>> p = re.compile(r'\W+')
>>> p2 = re.compile(r'(\W+)')
>>> p.split('This... is a test.')
['This', 'is', 'a', 'test', '']
>>> p2.split('This... is a test.')
['This', '... ', 'is', ' ', 'a', ' ', 'test', '.', '']
```

模块级函数 [`re.split()`](https://docs.python.org/zh-cn/3/library/re.html#re.split) 添加要正则作为第一个参数，但在其他方面是相同的。:

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
-  [`sub()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.sub) 方法接受一个**替换值**，可以是<u>字符串或函数</u>，也可以是要处理的字符串。

- .**sub**(*replacement*, *string*[, *count=0*])

  - 返回通过 *replacement* 替换 *string* 中正则的最左边非重叠出现而获得的字符串。 如果未找到模式，则 *string* 将保持不变。

  - 可选参数 *count* 是要替换的模式最大的出现次数；*count* 必须是非负整数。 默认值 0 表示替换所有。

- 这是一个使用 [`sub()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.sub) 方法的简单示例。 它用 `colour` 这个词取代颜色名称:

```python
>>> p = re.compile('(blue|white|red)')
>>> p.sub('colour', 'blue socks and red shoes')
'colour socks and colour shoes'
>>> p.sub('colour', 'blue socks and red shoes', count=1)
'colour socks and red shoes'
```

- [`subn()`](https://docs.python.org/zh-cn/3/library/re.html#re.Pattern.subn) 方法完成相同的工作，但返回一个包含新字符串值和已执行的替换次数的 2 元组:

```python
>>> p = re.compile('(blue|white|red)')
>>> p.subn('colour', 'blue socks and red shoes')
('colour socks and colour shoes', 2)
>>> p.subn('colour', 'no colours at all')
('no colours at all', 0)
```

- 仅当空匹配与<u>前一个空匹配</u>不相邻时，才会替换空匹配。:

- ```python
  >>> p = re.compile('x*')
  >>> p.sub('-', 'abxd')
  '-a-b--d-'
  
  In [16]: p = re.compile('x*')
  
  In [17]: p.sub('-', 'abxd')
  Out[17]: '-a-b--d-'
  
  In [18]: p.sub('-', 'a')
  Out[18]: '-a-'
  
  In [19]: p.sub('-', '')
  Out[19]: '-'
  
  In [21]: p.search('')
  Out[21]: <re.Match object; span=(0, 0), match=''>
  ```

  - 本例中的字符(增广形式):`·a·b·x·d·`

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

