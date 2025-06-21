[toc]



## references

- [正则表达式指南@分组 — Python 文档](https://docs.python.org/zh-cn/3.13/howto/regex.html#grouping)
- 作为地道的英文术语参考,这是英文版的文档:[Regular Expression HOWTO — Python documentation](https://docs.python.org/3.13/howto/regex.html#grouping)

## 捕获组(capturing )|分组(Grouping)🎈

通常，你需要获取更多信息，而不仅仅是正则是否匹配。

正则表达式通常用于通过将正则分成几个子组来解析字符串，这些子组匹配不同的感兴趣组件。

 例如，RFC-822 标题行分为标题名称和值，用 `':'` 分隔，如下所示：

- ```
  From: author@example.com
  User-Agent: Thunderbird 1.5.0.9 (X11/20061227)
  MIME-Version: 1.0
  To: editor@example.com
  ```

- 这可以通过编写与整个标题行匹配的正则表达式来处理，并且具有与标题名称匹配的一个组，以及与标题的值匹配的另一个组。

- Groups are marked by the `'('`, `')'` metacharacters. `'('` and `')'` have much the same meaning as they do in mathematical expressions;

- they group together the expressions contained inside them, and you can repeat the contents of a group with a quantifier, such as `*`, `+`, `?`, or `{m,n}`. For example, `(ab)*` will match zero or more repetitions of `ab`.

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

- 组可以**嵌套**；要确定编号，只需计算从左到右的左括号字符。:

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

- ```python
  >>> m.groups()
  ('abc', 'b')
  ```

### 引用组🎈

- 模式中的**后向引用**允许你指定还必须在字符串中的当前位置<u>找到先前捕获组的内容</u>。

- 例如，如果可以在当前位置找到组 1 的确切内容，则 `\1` 将成功，否则将失败。 

  - 请记住，Python 的字符串文字也使用**反斜杠后跟数字**以允许在字符串中包含任意字符，因此正则中引入反向引用时务必使用**原始字符串**`\r''`。

  - 例如，以下正则检测字符串中的双字。:

  - ```python
    >>> p = re.compile(r'\b(\w+)\s+\1\b')
    >>> p.search('Paris in the the spring').group()
    'the the'
    ```

- 像这样的后向引用通常不仅仅用于搜索字符串 —— 很少有文本格式以这种方式重复数据,你很快就会发现它们在执行字符串替换时 *非常* 有用。🎈




### 重复捕获组

```python
>>> m = re.match("([abc])+", "abc")
>>> m.groups()
('c',)
```

例子`re.match("([abc])+", "abc")`捕获到的子组只有一组`c`

可以配合在线工具来分析

> A repeated capturing group will only capture the last iteration. Put a capturing group around the repeated group to capture all iterations or use a non-capturing group instead if you're not interested in the data
>
> 重复捕获组只捕获最后一次迭代。

在重复组周围设置一个捕获组来捕获所有迭代，或者如果您对数据不感兴趣，则改用非捕获组。

- 对于模式串`([abc])+`,只包含一对括号,意味着子分组只有1组;并且组内`()`只包含一个字符.

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

  

## 非捕获(Non-capturing)和命名组(Named Groups)🎈

- 精心设计的正则可以使用许多组，既可以捕获感兴趣的子串，也可以对正则本身进行分组和构建。
- 在复杂的正则中，很难跟踪**组号**。 
  - 有两个功能可以帮助解决这个问题。 它们都使用常用语法进行正则表达式扩展
  - Perl 5 以其对标准正则表达式的强大补充而闻名。 对于这些新功能，Perl 开发人员无法选择新的单键击元字符或以 `\` 开头的新特殊序列，否则 Perl 的正则表达式与标准正则容易混淆。 例如，如果他们选择 `&` 作为一个新的元字符，旧的表达式将假设 `&` 是一个普通字符，并且不会编写 `\&` 或 `[&]`。
  - Perl 开发人员选择的解决方案是使用 `(?...)` 作为扩展语法。 括号后面紧跟 `?` 是一个语法错误，因为 `?` 没有什么可重复的，所以这样并不会带来任何兼容性问题。 紧跟在 `?` 之后的字符表示正在使用的扩展语法，所以 `(?=foo)` 是一种语法（一个**前视断言**）和 `(?:foo)` 是另一种语法（ 包含子表达式 `foo` 的**非捕获组**）。

- Python 支持一些 Perl 的扩展，并<u>增加了新的扩展语法用于 Perl 的扩展语法</u>。 
  - 如果<u>在问号之后的第一个字符</u>为 `P`，即表明其为 Python 专属的扩展。


### 非捕获(组)

有时你会想要**使用组来表示正则表达式的一部分**，但是对检索(retrieving) **组的内容不感兴趣**。

- 你可以通过使用**非捕获组**来显式表达这个**事实**: `(?:...)`，你可以用**任何其他正则表达式**替换 `...`


```py
>>> m = re.match("([abc])+", "abc")
>>> m.groups()
('c',) #解释参考重复捕获组一节
>>> m = re.match("(?:[abc])+", "abc")
>>> m.groups()
()
```

- 除了你无法检索组匹配内容的事实外，非捕获组的行为与捕获组完全相同；

- 你可以在里面放任何东西，用重复元字符重复它，比如 `*`，然后把它嵌入其他组（捕获或不捕获）。

- `(?:...)` 在**修改现有模式时特别有用，因为你可以添加新组而不更改所有其他组的编号方式**。 

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

### 命名组

更重要的功能是命名组：不是通过**数字**引用它们，而是可以通过**名称**引用组。

命名组的语法是**Python特定的扩展之一**: `(?P<name>...)`。

 *name* 显然是该组的名称。 **命名组的行为与捕获组完全相同，并且还将名称与组关联**。 处理捕获组的 [匹配对象](https://docs.python.org/zh-cn/3.13/library/re.html#match-objects) 方法都接受按编号引用组的**整数**或包含所需**组名的字符串**。 命名组仍然是给定的数字，因此你可以**通过两种方式检索有关组的信息**:

### 命名分组提取为字典🎈

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


### 小结

- 表达式中的后向引用语法，例如 `(...)\1`，指的是组的编号。 当然有一种变体使用组名而不是数字。 

- 这是另一个 Python 扩展: `(?P=name)` 表示在当前点再次匹配名为 *name* 的组的内容。 用于查找双字的正则表达式，`\b(\w+)\s+\1\b` 也可以写为 `\b(?P<word>\w+)\s+(?P=word)\b`,这里我们用`(?P=word)`来引用前面一组匹配的结果

```python
>>> p = re.compile(r'\b(?P<word>\w+)\s+(?P=word)\b')
>>> p.search('Paris in the the spring').group()
'the the'
```



### 前视断言[¶](https://docs.python.org/zh-cn/3.13/howto/regex.html#lookahead-assertions)

另一个零宽断言是前视断言。 前视断言有肯定型和否定型两种形式，如下所示：

- `(?=…)`

  肯定型前视断言。如果内部的表达式（这里用 `...` 来表示）在当前位置可以匹配，则匹配成功，否则匹配失败。 但是，内部表达式尝试匹配之后，正则引擎并不会向前推进；正则表达式的其余部分依然会在断言开始的地方尝试匹配。

- `(?!…)`

  否定型前视断言。 与肯定型断言正好相反，如果内部表达式在字符串中的当前位置 **不** 匹配，则成功。

更具体一些，来看一个前视的实用案例。 考虑用一个简单的表达式来匹配文件名并将其拆分为基本名称和扩展名，以 `.` 分隔。 例如，在 `news.rc` 中，`news` 是基本名称，`rc` 是文件名的扩展名。

与此匹配的模式非常简单：

```
.*[.].*$
```

请注意，`.` 需要特别处理，因为它是元字符，所以它在字符类中只能匹配特定字符。 还要注意尾随的 `$`；添加此项以确保扩展名中的所有其余字符串都必须包含在扩展名中。 这个正则表达式匹配 `foo.bar`、`autoexec.bat`、`sendmail.cf` 和 `printers.conf`。

现在，考虑使更复杂一点的问题；如果你想匹配扩展名不是 `bat` 的文件名怎么办？ 一些错误的尝试：

`.*[.][^b].*$` 上面的第一次尝试试图通过要求扩展名的第一个字符不是 `b` 来排除 `bat`。 这是错误的，因为模式也与 `foo.bar` 不匹配。

```
.*[.]([^b]..|.[^a].|..[^t])$
```

当你尝试通过要求以下一种情况匹配来修补第一个解决方案时，表达式变得更加混乱：扩展的第一个字符不是 `b`。 第二个字符不 `a`；或者第三个字符不是 `t`。 这接受 `foo.bar` 并拒绝 `autoexec.bat`，但它需要三个字母的扩展名，并且不接受带有两个字母扩展名的文件名，例如 `sendmail.cf`。 为了解决这个问题，我们会再次使模式复杂化。

```
.*[.]([^b].?.?|.[^a]?.?|..?[^t]?)$
```

在第三次尝试中，第二个和第三个字母都是可选的，以便允许匹配的扩展名短于三个字符，例如 `sendmail.cf`。

模式现在变得非常复杂，这使得它难以阅读和理解。 更糟糕的是，如果问题发生变化并且你想要将 `bat` 和 `exe` 排除为扩展，那么该模式将变得更加复杂和混乱。

否定型前视可以解决所有这些困扰：

`.*[.](?!bat$)[^.]*$` 否定型前视意味着：如果表达式 `bat` 在当前位置不能匹配，则可以接着尝试正则表达式的其余部分；如果 `bat$` 能匹配，则整个正则表达式将匹配失败。尾随的 `$` 是必需的，以确保可以匹配到像 `sample.batch` 这样以 `bat` 开头的文件名。当文件名中有多个点号时， `[^.]*` 可以确保表达式依然有效。

现在很容易排除另一个文件扩展名；只需在断言中添加它作为替代。 以下模块排除以 `bat` 或 `exe`:

```
.*[.](?!bat$|exe$)[^.]*$
```

