@[toc]

# vim@修改@删除括号@引号中的内容

##  利用vi命令

###  选中

- command:`vi<pair notion>`
- `i`理解为`in ...notion pair`
- `pair notion`取值可以为:

| (                                     | [    |
| ------------------------------------- | ---- |
| {                                     | "    |
| '                                     | `    |
| ...                                   |      |
| 如果是双引号,那么在normal模式下:`vi"` |      |
| 如果是单引号,那么输入:`vi'`           |      |
| 依次类推                              |      |
### 修改

- 可以在选中的基础上,考虑再按下c(或者按d删除)

##  利用`d` &`/`

- 可以定位到目标行,然后通过搜索`/`定位到引号内的第一个字符
- 然后键入`d`
- 现在将光标定位到引号/括号的另一半(`'`或`"`)
- (或者通过键入`)`来定位另一半

# 删除单词

- 通用技巧:	以下两种方法,可以在您的光标处于单词中的任意位置时都删除一整个单词

##  仅作删除单词操作

- `daw `(理解为:delete a word,这是vim中的text object 相关操作;没有dae)

- 在一个英文句子中一个单词的附近前后各有一个空格,所以用daw
  - (会删除后一个空格)的方式较为合适,一般来讲,如果仅作删除操作,而不修改,那么daw和好了.记住这一个就够用啦)

## 如果想要修改光标所在单词呢?

- 使用caw
  但是空格还是会被删除==(<I>`lbce`(删除单词并可以保留空格,且直接进入输入模式)或者`cawh `可以解决）==
- 所以，字符不超过3个的时候，您可以通过按x/X(或者说,nx/nX(n表示欲重复执行x/X删除操作的次数)来删除，或者通过（number motion operator的用法来删除)(especially when you are editing english segments)
  - bdw

- 删除光标前的单词部分的字符
  - db(方块光标所在的字符会被保留)
- 删除光标处及以后的单词部分的字符(包括附带的空格一并删掉)
  - dw
- 删除到单词最后一个字符(空格会被保留)
  - de

##  reference

- The command/action/verb d in Vim acts on an object. For dw the object is "all text the cursor moves over with a w command". For daw you're actually using a Vim concept called a "text object". There are many of these, including aw (a word), as (a sentence), i} (inner {...} block, e.g. code within a block in C code), it (inner tag, useful for XML-like languages), and more.


- See :help text-objects for the full list.

- These can not only be used by the d command, but any command/action/verb that takes an object. For example, =aB will reindent an entire code block, cas will delete a sentence and drop you into insert mode to type a new one, and yit will yank/copy everything inside the current XML tag.