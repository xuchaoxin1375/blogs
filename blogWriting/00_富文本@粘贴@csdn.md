[toc]



# 链接引用和跳转

- 可以用于不同网页间的跳转

##  references

- [Overview](https://www.markdownguide.org/cheat-sheet/#overview)
- [Basic Syntax基础语法](https://www.markdownguide.org/cheat-sheet/#basic-syntax)
  - [Basic Syntax | Markdown Guide](https://www.markdownguide.org/basic-syntax) 
- [Extended Syntax扩展语法参考](https://www.markdownguide.org/cheat-sheet/#extended-syntax)
  - [Extended Syntax | Markdown Guide](https://www.markdownguide.org/extended-syntax/#copying-and-pasting-emoji) 	
  - ==扩展语法会因为不同的编辑器的支持程度(功能的启用)的不同而有不同的预期效果==
- [表情参考:Complete list of github markdown emoji markup](https://gist.github.com/rxaviers/7360908)
- [Downloads](https://www.markdownguide.org/cheat-sheet/#downloads)


## 内联网址的方式

- [baidu](https://baidu.com)

  - ```bash
    [baidu](https://baidu.com)	
    ```

## 将链接提取出来

- 这种定义方式分为两部分

- 好处:

  - 可以仅通过定义链接时的名字(链接的别名)重复引用同一个链接

  - 查看markdown源代码时更加简洁和紧凑.

  - 同时兼容图片链接的别名定义

- 包括链接的定义:名称(类似于定义并初始化一个变量)
- 这个定义的名称可以通过`[]`单独使用(渲染出来的就是定义时的名称)
- 可以在配合一个前置`[]`使用,这样可以对链接做详细的说明.

## 链接示例

- baidu1: [baidu: a popular search engin in China.][1]
- baidu2: [baidu:search:a search engin rich in advertizements.][var1]
- baidu3: [baidu:some times,it performs better than bing!][baidu]
- baidu4(直接使用定义的链接别名,但可能造成兼容问题,不推荐):[baidu]

- 定义链接的别名(定义不会被渲染出来),引用的时候,名字被渲染出来(如果有前置`[]`,则渲染的是前置`[]`中的内容.

  - [1]: https://baidu.comb

  - [var1]: https://baidu.comb

  - [baidu]: https://baidu.comb

- 本部分源代码

  - ```xml
    - baidu1: [baidu: a popular search engin in China.][1]
    - baidu2: [baidu:search:a search engin rich in advertizements.][var1]
    - baidu3: [baidu:some times,it performs better than bing!][baidu]
    - baidu4(直接使用定义的链接别名):[baidu]
    > 定义链接的别名(定义不会被渲染出来),引用的时候,名字被渲染出来(如果有前置`[]`,则渲染的是前置`[]`中的内容.
    
    [1]: https://baidu.comb
    [var1]: https://baidu.comb
    [baidu]: https://baidu.comb
    ```

# 注脚

- 注脚功能的支持需要编辑器支持(vscode可以外装插件来支持)
  - 定义一组注脚引用.[^first]
  - big[^big]
  - small[^small]
- 点击注脚标记可以跳转到注脚的解释除
- 注脚的引用,几乎可以放在任意需要的位置
- 注脚的定义可以放置在文末,当然也可以是其他地方

- 注脚的定义和引用名字要对应上
- 名字可以不限于数字,可以是单词
- 但是注脚引用处会`渲染成`数字角标(文档自己递增),示例
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

#  csdn markdown

## 辅助功能

-  文档帮助和模板

##  图片居中

- csdn only!

- 原始图片:

![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw)

- 源码1

- `![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw)`

### 带尺寸的图片:

- 源码

- `![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw =30x30)`

### 居中的图片: 

![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw#pic_center)

- 居中源码

- `![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw#pic_center)`
- 居中并且带尺寸的图片: ![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw#pic_center =30x30)

- 居中带尺寸图片源码

- `![Alt](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hdmF0YXIuY3Nkbi5uZXQvNy83L0IvMV9yYWxmX2h4MTYzY29tLmpwZw#pic_center =30x30)`

## 将word/OneNote中的笔记(图文笔记)直接复制粘贴到csdn上

- 这种情况下打开csdn**富文本编辑器**,支持直接粘贴word内容操作