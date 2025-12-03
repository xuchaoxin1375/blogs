[toc]



# ref

## markdown和latex常用部分参考

- [Markdown and LaTeX introduction (ashki23.github.io)](https://ashki23.github.io/markdown-latex.html#latex)
- [Markdown Guide](https://www.markdownguide.org/getting-started/)

### typora文档

- [Links - Typora Support](https://support.typora.io/Links/)

### 基础语法

- [Basic Syntax基础语法](https://www.markdownguide.org/cheat-sheet/#basic-syntax)
  - [Basic Syntax | Markdown Guide](https://www.markdownguide.org/basic-syntax) 

## 扩展语法

- [Extended Syntax扩展语法参考](https://www.markdownguide.org/cheat-sheet/#extended-syntax)
  - [Extended Syntax | Markdown Guide](https://www.markdownguide.org/extended-syntax/#copying-and-pasting-emoji) 	
  - ==扩展语法会因为不同的编辑器的支持程度(功能的启用)的不同而有不同的预期效果==
  - [Extended Syntax](https://www.markdownguide.org/extended-syntax/#extended-syntax)* [Overview](https://www.markdownguide.org/extended-syntax/#overview)
    * [Availability](https://www.markdownguide.org/extended-syntax/#availability)
      * [Lightweight Markup Languages](https://www.markdownguide.org/extended-syntax/#lightweight-markup-languages)
      * [Markdown Processors](https://www.markdownguide.org/extended-syntax/#markdown-processors)
    * [Tables](https://www.markdownguide.org/extended-syntax/#tables)
      * [Alignment](https://www.markdownguide.org/extended-syntax/#alignment)
      * [Formatting Text in Tables](https://www.markdownguide.org/extended-syntax/#formatting-text-in-tables)
      * [Escaping Pipe Characters in Tables](https://www.markdownguide.org/extended-syntax/#escaping-pipe-characters-in-tables)
    * [Fenced Code Blocks](https://www.markdownguide.org/extended-syntax/#fenced-code-blocks)
      * [Syntax Highlighting](https://www.markdownguide.org/extended-syntax/#syntax-highlighting)
    * [Footnotes](https://www.markdownguide.org/extended-syntax/#footnotes)
    * [Heading IDs](https://www.markdownguide.org/extended-syntax/#heading-ids)
      * [Linking to Heading IDs](https://www.markdownguide.org/extended-syntax/#linking-to-heading-ids)
    * [Definition Lists](https://www.markdownguide.org/extended-syntax/#definition-lists)
    * [Strikethrough](https://www.markdownguide.org/extended-syntax/#strikethrough)
    * [Task Lists](https://www.markdownguide.org/extended-syntax/#task-lists)
    * [Emoji](https://www.markdownguide.org/extended-syntax/#emoji)
      * [Copying and Pasting Emoji](https://www.markdownguide.org/extended-syntax/#copying-and-pasting-emoji)
      * [Using Emoji Shortcodes](https://www.markdownguide.org/extended-syntax/#using-emoji-shortcodes)
    * [Highlight](https://www.markdownguide.org/extended-syntax/#highlight)
    * [Subscript](https://www.markdownguide.org/extended-syntax/#subscript)
    * [Superscript](https://www.markdownguide.org/extended-syntax/#superscript)
    * [Automatic URL Linking](https://www.markdownguide.org/extended-syntax/#automatic-url-linking)
    * [Disabling Automatic URL Linking](https://www.markdownguide.org/extended-syntax/#disabling-automatic-url-linking)
      * [Take your Markdown skills to the next level.](https://www.markdownguide.org/extended-syntax/#take-your-markdown-skills-to-the-next-level)
        * [Want to learn more Markdown?]()
- [表情参考:Complete list of github markdown emoji markup](https://gist.github.com/rxaviers/7360908)
- [cheatsheet-Downloads](https://www.markdownguide.org/cheat-sheet/#downloads)

## 链接

### 内联链接的方式

- [baidu](https://baidu.com)

  - ```bash
    [baidu](https://baidu.com)	
    ```

### 将链接提取出来

- 这种链接的定义分为两部分

- 好处:

  - 可以仅通过定义链接时的名字(链接的别名)**重复引用**同一个链接

  - 查看markdown源代码时**更加简洁和紧凑**.

  - 同时兼容图片链接的别名定义

- 包括链接的定义:名称(类似于定义并初始化一个变量)
- 这个定义的名称可以通过`[]`单独使用(渲染出来的就是定义时的名称)
- 可以在配合一个前置`[]`使用,这样可以对链接做详细的说明.

## 链接示例

- baidu1: [baidu: a popular search engin in China.][1]
- baidu2: [baidu:search:a search engin rich in advertizements.][var1]
- baidu3: [baidu:some times,it performs better than bing!][baidu]
- baidu4(直接使用定义的链接别名,但可能造成兼容问题,不推荐):[baidu]

- 定义链接的别名

  - (定义不会被渲染出来),引用的时候,名字被渲染出来

  - (如果有前置`[]`,则渲染的是前置`[]`中的内容.否则,渲染链接本身)

  - [1]: https://baidu.comb

  - [var1]: https://baidu.comb

  - [baidu]: https://baidu.comb

    [#ref]:

- 本部分源代码

  - ```xml
    - baidu1: [baidu: a popular search engin in China.][1]
    
    - baidu2: [baidu:search:a search engin rich in advertizements.][var1]
    
    - baidu3: [baidu:some times,it performs better than bing!][baidu]
    
    - baidu4(直接使用定义的链接别名,但可能造成兼容问题,不推荐):[baidu]
    
    - 定义链接的别名
    
      - (定义不会被渲染出来),引用的时候,名字被渲染出来
    
      - (如果有前置`[]`,则渲染的是前置`[]`中的内容.否则,渲染链接本身)
    
      - [1]: https://baidu.comb
    
      - [var1]: https://baidu.comb
    
      - [baidu]: https://baidu.comb
    ```
    

### typora的支持

- ### Links

  Markdown supports two styles of links: inline and reference.

  In both styles, the link text is delimited by [square brackets].

  #### Inline Links

  To create an inline link, use a set of regular parentheses immediately after the link text’s closing square bracket. Inside the parentheses, put the URL where you want the link to point, along with an optional title for the link, surrounded in quotes. For example:

  ```
  This is [an example](http://example.com/ "Title") inline link.
  
  [This link](http://example.net/) has no title attribute.
  ```

  will produce:

  This is [an example](http://example.com/"Title") inline link. (`<p>This is <a href="http://example.com/" title="Title">`)

  [This link](http://example.net/) has no title attribute. (`<p><a href="http://example.net/">This link</a> has no`)

  #### Internal Links🎈

  To create an internal link that creates a ‘bookmark’ that allow you to jump to that section after clicking on it, use the name of the header element as the href. For example:

  Hold down Cmd (on Windows: Ctrl) and click on [this link](https://support.typora.io/Markdown-Reference/#block-elements) to jump to header `Block Elements`.

  ```
  Hold down Cmd (on Windows: Ctrl) and click on [this link](#block-elements) to jump to header `Block Elements`. 
  ```

  #### Reference Links

  Reference-style links use a second set of square brackets, inside which you place a label of your choosing to identify the link:

  ```
  This is [an example][id] reference-style link.
  
  Then, anywhere in the document, you define your link label on a line by itself like this:
  
  [id]: http://example.com/  "Optional Title Here"
  ```

  In Typora, they will be rendered like so:

  This is [an example](http://example.com/) reference-style link.

  The implicit link name shortcut allows you to omit the name of the link, in which case the link text itself is used as the name. Just use an empty set of square brackets — for example, to link the word “Google” to the google.com web site, you could simply write:

  ```
  [Google][]
  And then define the link:
  
  [Google]: http://google.com/
  ```

  In Typora, clicking the link will expand it for editing, and command+click will open the hyperlink in your web browser.

  ### URLs

  Typora allows you to insert URLs as links, wrapped by `<`brackets`>`. For example `<i@typora.io>` becomes [i@typora.io](mailto:i@typora.io).

  Typora will also automatically link standard URLs (for example: www.google.com) without these brackets.

### 文章内部跳转(Heading IDs)🎈

- [go to ref section(heading)](#ref)

  - ```
    [got to ref section(heading)](#ref)
    ```

- [ref](#ref)

- [markdown和latex常用部分参考](#markdown和latex常用部分参考)

# My Great Heading

## 注脚(Footnotes)🎈

- 注脚功能的支持需要编辑器支持(vscode可以外装插件来支持)
  - 定义一组注脚引用.[^first]
  - big[^big]
  - small[^small]
- 点击注脚标记可以跳转到注脚的解释除
- 注脚的引用,几乎可以放在任意需要的位置
- 注脚的定义可以放置在文末,当然也可以是其他地方

- 注脚的定义和引用名字要对应上
- 名字可以不限于数字,可以是单词,但是注脚引用处会`渲染成`数字角标(文档自己递增),示例
  - `[^1]`
  - `[^1]: the explain of the be footnoted phrase or concepts in the same article but different location of the article.`

###  本段核心源代码

```md
> 注脚功能的支持需要编辑器支持(vscode可以外装插件来支持)
定义一组注脚引用.[^first]
big[^big]
small[^small]

[^first]: explain:first word note😂
[^big]: explain: test bing😂
[^small]: explain:test bing😂
```

[^first]: explain:first word note😂
[^big]: explain: test bing😂
[^small]: explain:test bing😂
[^1]: the explain of the be footnoted phrase or concepts in the same article but different location of the article.

##  csdn markdown

### 辅助功能

-  文档帮助和模板

###  图片居中

- csdn only!

- 原始图片:

![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw)

- 源码1

- `![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw)`

#### 带尺寸的图片:

- 源码

- `![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw =30x30)`

#### 居中的图片:

![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw#pic_center)

- 居中源码

- `![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw#pic_center)`
- 居中并且带尺寸的图片: ![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw#pic_center =30x30)

- 居中带尺寸图片源码

- `![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw#pic_center =30x30)`

## 将word/OneNote中的笔记(图文笔记)直接复制粘贴到csdn上

- 这种情况下打开csdn**富文本编辑器**,支持直接粘贴word内容操作



[ref]:

[markdown和latex常用部分参考]: