### [“互斥”组合符：|]

- [“互斥”组合符：\|](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Value_definition_syntax#%E2%80%9C%E4%BA%92%E6%96%A5%E2%80%9D%E7%BB%84%E5%90%88%E7%AC%A6%EF%BC%9A "Permalink to “互斥”组合符：|")

*“互斥”组合符*表示各组成部分中只能 **恰好出现一个** ，通常用来分隔一个属性的所有可选值。例如：

```
<percentage> | <length> | left | center | right | top | bottom
```

以下均为该例的合法取值：

* `3%`
* `0`
* `3.5em`
* `left`
* `center`
* `right`
* `top`
* `bottom`

但以下不是合法取值：

* `center 3%` as only one of the components must be present.
* `3em 4.5em` as a component must be present at most one time.

**注：** “或”组合符的优先级高于“互斥”组合符，比如`bold | thin || <length>`等价于`bold | [ thin || <length> ]`。它们的合法取值是：`bold`, `thin`, `<length>`, `<length> thin`, 或`thin <length>，但不能是bold <length>，`因为“互斥”组合符所连接的数个部分中，只有一个能出现。
