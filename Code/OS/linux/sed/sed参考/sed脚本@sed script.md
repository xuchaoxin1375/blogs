[toc]





##  `sed` scripts🎈

### document

| • [sed script overview](https://www.gnu.org/software/sed/manual/sed.html#sed-script-overview): | `sed` script overview          |
| ------------------------------------------------------------ | ------------------------------ |
| • [sed commands list](https://www.gnu.org/software/sed/manual/sed.html#sed-commands-list): | `sed` commands summary         |
| • [The "s" Command](https://www.gnu.org/software/sed/manual/sed.html#The-_0022s_0022-Command): | `sed`’s Swiss Army Knife       |
| • [Common Commands](https://www.gnu.org/software/sed/manual/sed.html#Common-Commands): | Often used commands            |
| • [Other Commands](https://www.gnu.org/software/sed/manual/sed.html#Other-Commands): | Less frequently used commands  |
| • [Programming Commands](https://www.gnu.org/software/sed/manual/sed.html#Programming-Commands): | Commands for `sed` gurus       |
| • [Extended Commands](https://www.gnu.org/software/sed/manual/sed.html#Extended-Commands): | Commands specific of GNU `sed` |
| • [Multiple commands syntax](https://www.gnu.org/software/sed/manual/sed.html#Multiple-commands-syntax): | Extension for easier scripting |

- sed 脚本(script中的命令)中最常用的是替换命令,即`s`,它可以应对
  * 文本修改
  * 文本删除(将内容替换为空)

### `sed` script overview

#### sed program@sed script🎈

- A `sed` program consists of one or more `sed` commands, passed in by one or more of the -e, -f, --expression, and --file options, or the first non-option argument if zero of these options are used. 
- This document will refer to “the” `sed` script; 
- this is understood to mean the in-order concatenation of all of the scripts and script-files passed in. 
  - See [Overview](https://www.gnu.org/software/sed/manual/sed.html#Overview).

#### sed script语法@sed command🎈

- `sed` commands follow this syntax:

  - `[addr]X[options]`

  1. `X` is a single-letter `sed` command. 
  2. `[addr]` is an **optional** <u>line address</u>.(range)
     -  If `[addr]` is specified, the command X will be executed **only on the matched lines**.
     -  `[addr]` can be
        -  a single line number, 
        -  a regular expression, 
        -  a range of lines (see [sed addresses](https://www.gnu.org/software/sed/manual/sed.html#sed-addresses)). 
  3. `[options]` are used for some `sed` commands.

#### 例

- The following example deletes lines 30 to 35 in the input. 
  - `sed '30,35d' input.txt > output.txt	`
    - `30,35` is an **address range**. 
    - `d` is the delete command:

#### 例

- The following example **prints** all input until a line <u>starting with the word ‘foo’</u> is found. 

  - `sed '/^foo/q42' input.txt > output.txt`

  - If such line is found, `sed` will terminate with exit status 42.

  - If such line was not found (and no other error occurred), `sed` will exit with status 0. 

  - `/^foo/` is a regular-expression address. 

  - `q` is the quit command. `42` is the command option.

    - 命令q的语法和作用:

      - `q[exit-code]`

      - (quit) Exit `sed` without processing any more commands or input.

- Commands within a script or script-file can be separated by semicolons (`;`) or newlines (ASCII 10). 
- Multiple scripts can be specified with -e or -f options.

- The following examples are all equivalent. 
  - They perform two `sed` operations: 
    - deleting any lines matching the regular expression `/^foo/`, 
    - and replacing all occurrences of the string ‘hello’ with ‘world’:

```bash
sed '/^foo/d ; s/hello/world/' input.txt > output.txt
#
sed -e '/^foo/d' -e 's/hello/world/' input.txt > output.txt
#
echo '/^foo/d' > script.sed
echo 's/hello/world/' >> script.sed
sed -f script.sed input.txt > output.txt
#-e和-f可以混合使用
echo 's/hello/world/' > script2.sed
sed -e '/^foo/d' -f script2.sed input.txt > output.txt
```

- Commands `a`, `c`, `i`, due to their syntax, **cannot be followed by semicolons** working as command separators and thus s<u>hould be terminated with newlines or be placed at the end of a script or script-file.</u> 
- Commands can also be preceded with optional non-significant whitespace characters. See [Multiple commands syntax](https://www.gnu.org/software/sed/manual/sed.html#Multiple-commands-syntax).

### 可用的sed command 列表🎈

- sed commands summary:

- ```bash
  sed commands summary
  The following commands are supported in GNU sed. Some are standard POSIX commands, while other are GNU extensions. Details and examples for each command are in the following sections. (Mnemonics) are shown in parentheses.
  
  a\
  text
  Append text after a line.
  
  a text
  Append text after a line (alternative syntax).
  
  b label
  Branch unconditionally to label. The label may be omitted, in which case the next cycle is started.
  
  c\
  text
  Replace (change) lines with text.
  .....
  ```

- 自行使用`info sed`查阅或者在线文档查阅完整列表

###  The `s` Command

- The `s` command (as in substitute) is probably **the most important** in `sed` and has a lot of different options. 

- The **syntax** of the `s` command is 

  - `'s/regexp/replacement/flags'`

  - Its basic concept is simple: the `s` command attempts to <u>match the **pattern space**(模式空间) against the supplied regular expression regexp</u>;

  - if the match is successful, then that **portion** of the **pattern space** which was matched is replaced with replacement.

#### 正则语法参考

- For details about regexp syntax see [Regular Expression Addresses](https://www.gnu.org/software/sed/manual/sed.html#Regexp-Addresses).

#### 高级匹配和指代🎈

- 这部分内容可以实现将被匹配模式空间(输入)进行细分成多个部分(最多9个)

  - 这几个部分的指代可以用于调换位置等操作

- The **replacement** can contain `\n` (n being a number from 1 to 9, inclusive) **references**, which refer to the **portion** of the match <u>which is contained between the nth</u> `\(` and its matching `\)`. 

  - ```bash
    ➜  ~ echo "a-b-"| sed 's/\(b\)-/x\1/'
    a-xb
    ➜  ~ echo "a-b-"| sed 's/\(b\)-/x\1\1/'
    a-xbb
    ➜  ~ echo "a-b-"| sed 's/\(b\)-/x\1\1\1/'
    a-xbbb
    ```

  - 调换分组@分组内容加括号示例

    - 通过echo将待测试的输入内容作为sed的模式空间

    ```bash
    ➜  ~ echo "a-b"| sed 's/\(a\)-\(b\)/\2-\1/'
    b-a
    ➜  ~ echo "aaa-bbb"| sed 's/\(a\+\)-\(b\+\)/\2-\1/'
    bbb-aaa
    #这里第1组(记为\1)命中模式空间aaa部分
    #第2组(记为\2)命中模式空间bbb部分
    #整个替换regep串命中模式空间整个串
    ➜  ~ echo "aaabbb"| sed 's/\(a\+\)\(b\+\)/\2-\1/'
    bbb-aaa
    ➜  ~ echo "aaabbb"| sed 's/\(a\+\)\(b\+\)/\2\1/'
    bbbaaa
    ➜  ~ echo "aaabbb"| sed 's/\(a\+\)\(b\+\)/[\2](\1)/'
    [bbb](aaa)
    ```

  - 使用sed扩展正则选项

    - 注意,扩展正则只对sed script 中的`regexp`部分起作用

    - `replacement`部分依然是非扩展的正则语法,比起同时启用扩展语法,这往往是方便的

    - ```bash
      ➜  ~ echo "aaabbb"| sed -E 's/(a+)(b+)/{\2}(\1)/'
      {bbb}(aaa)
      ```

  - 值得注意的是,regex命中模式空间的次数和分组编号是独立的

    - 每一次命中都独立计数分组编号

    - 而`s`命令默认只处理行的第一次出现(匹配命中)的部分

    - 如果行内后续又出现regexp匹配命中的模式空间字串,则需要借助参数`g`

    - ```bash
      ➜  ~ echo "aaabbbaabb"| sed 's/\(a\+\)\(b\+\)/[\2](\1)/'
      [bbb](aaa)aabb
      ➜  ~ echo "aaabbbaabb"| sed 's/\(a\+\)\(b\+\)/[\2](\1)/g'
      [bbb](aaa)[bb](aa)
      ```

      

- Also, the replacement can contain unescaped `&` characters which **reference the whole matched portion of the pattern space.**

  - 也就是说,在`replacement`表达式中使用(出现)`&`,这些地方会被替换为模式空间被`regexp`匹配这个部分(所有分组)

  - ```bash
    ➜  ~ echo "aaabbb"| sed -E 's/(a+)(b+)/{\2}(\1)&/'
    {bbb}(aaa)aaabbb
    ➜  ~ echo "aaabbbCCC"| sed -E 's/(a+)(b+)/{\2}&(\1)/'
    {bbb}aaabbb(aaa)CCC
    ➜  ~ echo "aaabbb"| sed -E 's/(a+)(b+)/{\2}&(\1)/'
    {bbb}aaabbb(aaa)
    ```

    

- The `/` characters may be **uniformly** replaced by any other single character within any given `s` command. 

- The `/` character (or whatever other character is used in its stead) can appear in the regexp or replacement only if it is preceded by a `\` character.

  - 模式串中的`/`需要转移成`\/`

#### 大小写控制

- Finally, as a GNU `sed` extension, you can include **a special sequence** <u>made of a backslash and one of the letters</u> `L`, `l`, `U`, `u`, or `E`. 

- The meaning is as follows:(作用在`replacement`中的字符)

  - `\L`

    Turn **the replacement** to lowercase until a `\U` or `\E` is found,

  - `\l`

    Turn **the next character** to lowercase,

  - `\U`

    Turn the replacement to uppercase until a `\L` or `\E` is found,

  - `\u`

    Turn **the next character** to uppercase,

  - `\E`

    Stop case conversion started by `\L` or `\U`.

  - ```bash
    ➜  ~ echo "aabb"| sed -E 's/(a+)(b+)/{\2\U}(\1)/'
    {bb}(AA)
    
    ➜  ~ echo "aabb"| sed -E 's/(a+)(b+)/\1\u\2/'
    aaBb
    # 分组\1(即aa)后的第一个字符被设为大写(如果是英文字符的话),本例是\2分组(即bb)的第一个字母b被设为B
    
    
    ➜  ~ echo "aabb"| sed -E 's/(a+)(b+)/\2\u\1/'
    bbAa
    
    # \u等不会改变字符长度,只控制英文字母大小写,\n则可能会(n=1,2,...,9)
    ➜  ~ echo "aabb"| sed -E 's/(a+)(b+)/\2\ut\1/'
    bbTaa
    ➜  ~ echo "aabb"| sed -E 's/(a+)(b+)/\1\u\u\2/'
    aaBb
    ➜  ~ echo "aabbbcccddd"| sed -E 's/(a+)(b+)(.*)/\1\U\2\l\3/'
    aaBBBcCCDDD
    ➜  ~ echo "aabbbcccddd"| sed -E 's/(a+)(b+)(.*)/\1\U\2\E\3/'
    aaBBBcccddd
    ➜  ~
    ```

    

- When the `g` flag is being used, case conversion does **not** propagate from one occurrence of the regular expression to another.

  - For example, when the following command is executed with `a-b-` in pattern space:

    - 假设模式空间中的字符串为`a-b-`,使用如下的sed script进行处理

    - `s/\(b\?\)-/x\u\1/g`

      - regexp:`\(b\?\)-`

        - 即可以匹配到`b-`或`-`
        - 从模式串中可以看出,能够匹配上的所有情况的分组内容有两种可能
          - 空串
          - 含有一个字符的串`b`
        - 正则模式串regexp中展开为`(b)-`和`()-`,可以将括号内的部分串标记成组,可以做后续的指代
        - 这里的括号仅仅用来作为分割分组的虚记号,不会匹配模式空间中的括号

      - 本例中,对于模式空间`a-b-`中的可以被命中两次:

        - `-`,`b-`(第一个字符`a`不被命中,原样输出)

        - | 字符                | a    | -    | b    | -    |
          | ------------------- | ---- | ---- | ---- | ---- |
          | 索引[i],即第i个字符 | 1    | 2    | 3    | 4    |

        - 第一个分组内容是空

          - 第2个字符`-`第一次命中模式,分组括号内为空

        - 第二个分组内容是字符`b`

          - 第3,4个字符构成第2次命中,分组括号内为字符`b`

    - ```bash
      ➜  ~ echo "a-b-"| sed 's/\(b\?\)-/x\u\1/'
      axb-
      ➜  ~ echo "a-b-"| sed 's/\(b\?\)-/x\u/'
      axb-
      #正则扩展语法的写法
      ➜  ~  echo "a-b-"| sed -E 's/(b?)-/x\u\1/'
      axb-
      
      ```

    - ```bash
      ➜  ~ echo "a-b-"| sed 's/\(b\?\)-/x\u\1/g'
      axxB
      #打开扩展正则,简写为:
      ➜  ~  echo "a-b-"| sed -E 's/(b?)-/x\u\1/g'
      axxB
      ```

    - the output is ‘axxB’. (输出结果为`axxB`)

      - 其中,b被转为大写的B

    - When replacing the first ‘-’,

      -  the ‘\u’ sequence only affects **the empty replacement** of ‘\1’. 
      -  It does not affect the `x` character that is added to pattern space when replacing `b-` with `xB`.
      -  第一次命中(`-`)的`\1`分组是空串,
         - `\u`后的首字符大写处理(即`\1`的首字符,本次为空串,所以无效果)
         - 所以输入的模式空间中,`-`被替换为`x`+`空串`
      -  第2次命中`b-`,`\1`分组是`b`
         - `\u`后的首字符大写处理(即`\1`的首字符,本次为字符`b`,替换为`B`)
         - 所以输入的模式空间中,`-`被替换为`x`+`B`,即`xB`

- On the other hand, `\l` and `\u` **do affect the remainder of the replacement text** <u>if they are followed by an empty substitution.</u>

- ```bash
  ➜  ~ echo "a-b-"| sed 's/\(b\?\)-/\u\1x/g'
  aXBx
  #优化分组显示
  ➜  ~ echo "a-b-"| sed 's/\(b\?\)-/(\u\1x)/g'
  a(X)(Bx)
  ```

  -  With`‘a-b-` in pattern space, 

  -  the following command:

     - `s/\(b\?\)-/\u\1x/g`

     - will replace ‘-’ with ‘X’ (uppercase) and ‘b-’ with ‘Bx’. If this behavior is undesirable, you can prevent it by adding a ‘\E’ sequence—after ‘\1’ in this case.

     - To include a literal `\`, `&`, or newline in the final replacement, be sure to precede the desired `\`, `&`, or newline in the replacement with a `\`.

### 命令`s`的标志(flags)🎈

The `s` command can be followed by zero or more of the following flags:

- `g`

  Apply the replacement to *all* matches to the regexp, not just the first.

- `number`

  Only replace the numberth match of the regexp.interaction in `s` command Note: the POSIX standard does not specify what should happen when you mix the `g` and number modifiers, and currently there is no widely agreed upon meaning across `sed` implementations. For GNU `sed`, the interaction is defined to be: ignore matches before the numberth, and then match and replace all matches from the numberth on.

- `p`

  If the substitution was made, then print the new pattern space.Note: when both the `p` and `e` options are specified, the relative ordering of the two produces very different results. In general, `ep` (evaluate then print) is what you want, but operating the other way round can be useful for debugging. For this reason, the current version of GNU `sed` interprets specially the presence of `p` options both before and after `e`, printing the pattern space before and after evaluation, while in general flags for the `s` command show their effect just once. This behavior, although documented, might change in future versions.

- `w filename`

  If the substitution was made, then write out the result to the named file. As a GNU `sed` extension, two special values of filename are supported: /dev/stderr, which writes the result to the standard error, and /dev/stdout, which writes to the standard output.[3](https://www.gnu.org/software/sed/manual/sed.html#FOOT3)

- `e`

  This command allows one to pipe input from a shell command into pattern space. If a substitution was made, the command that is found in pattern space is executed and pattern space is replaced with its output. A trailing newline is suppressed; results are undefined if the command to be executed contains a NUL character. This is a GNU `sed` extension.

- `I`

- `i`

  The `I` modifier to regular-expression matching is a GNU extension which makes `sed` match regexp in a case-insensitive manner.

- `M`

- `m`

  The `M` modifier to regular-expression matching is a GNU `sed` extension which directs GNU `sed` to match the regular expression in multi-line mode. The modifier causes `^` and `$` to match respectively (in addition to the normal behavior) the empty string after a newline, and the empty string before a newline. There are special character sequences (`\`` and `\'`) which always match the beginning or the end of the buffer. In addition, the period character does not match a new-line character in multi-line mode.

### 指定分界符(自定义转义)

- `\%regexp%`(The `%` may be <u>replaced by any other single character</u>.)

- This also matches the regular expression regexp, but allows one to use a different delimiter than `/`. This is particularly useful if the regexp itself contains a lot of slashes, since it avoids the tedious escaping of every `/`.

- If regexp itself includes any delimiter characters, each must be escaped by a backslash (`\`).

- The following commands are equivalent.

  - They print lines which start with ‘/home/alice/documents/’:

  - ```bash
    sed -n '/^\/home\/alice\/documents\//p'
    sed -n '\%^/home/alice/documents/%p'
    sed -n '\;^/home/alice/documents/;p'
    ```

## debug



- ```
  sed --debug
  ```

- Print the input sed program in canonical form, and annotate program execution.

  ```bash
  $ echo 1 | sed '\%1%s21232'
  3
  
  $ echo 1 | sed --debug '\%1%s21232'
  
  SED PROGRAM:
    /1/ s/1/3/
  INPUT:   'STDIN' line 1
  PATTERN: 1
  COMMAND: /1/ s/1/3/
  PATTERN: 3
  END-OF-CYCLE:
  3
  ```

