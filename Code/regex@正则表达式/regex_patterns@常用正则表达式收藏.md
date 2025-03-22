[toc]



## latex系列

- 去掉wikipedia复制的公式的`(Image: )`

  - ```
    ^(\(Image:\s*)(.*)(\))$
    ```

    

- $\rm sinx,cosx,sin(nx)\to{\sin{x},\cos{x},\sin(nx)}$
  - `([^\\])(sin|cos)((\(.*?\))|(\w|\d|\d\w)(,))`
  - `$1\\$2{$4$5}$6`

### 匹配指定字符集合中的字符构成的串

假设我想要找出所有字符集合$\set{>,[,],<}$,也就是小于,大于,左右中括号

正则可以这么写:`[<>\[\]]+`

```powershell

#⚡️[Administrator@CXXUDESK][~\Desktop][8:44:42][UP:1.98Days]
PS> '[>[[>xesdf><>>[[[]]' -replace '[<>\[\]]+','$'
$xesdf$
```

注意,如果将`+`改为`*`,会是这样

```powershell
PS> '[>[[>xesdf><>>[[[]]' -replace '[<>\[\]]*','$'
$$x$e$s$d$f$$
```

