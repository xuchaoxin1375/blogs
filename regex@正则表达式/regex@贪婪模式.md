[toc]



## 匹配全部字符

###  [^]

- 可以匹配任意一个字符

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210703174253518.png)

- 你可以通过以下方式匹配 complementing 设置的字符类中未列出的字符。这通过包含一个 '^' 作为该类的第一个字符来表示。 

- 例如，[^5] 将匹配除 '5' 之外的任何字符。 
- ==如果插入符出现在字符类的其他位置，则它没有特殊含义。== 例如：[5^] 将匹配 '5' 或 '^'。

##  贪婪模式

- 对于'*', '+'，和 '?' 修饰符都是贪婪的；
- 它们在字符串进行尽可能多的匹配。
- 有时候并不需要这种行为,则对应用非贪婪模式

### 贪婪模式的工作过程

- 以字符串`abcbd`作为被匹配串

- 以`a[bcd]*b`作为正则模式串
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210703180649289.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

- 
  非贪婪模式包括:

```bash
*?, +?, ??,{m,n}?
```
##  实例

###  *?

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210703160425884.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

###  对应的贪婪模式:`*`

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210703160741262.png)

###  +?

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210703160810982.png)

### 对应的贪婪模式:+

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210703160824470.png)

###  ??

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210703160904542.png)
###  对应的贪婪模式:?

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210703161126316.png)

### {m,n}?

- 前一个修饰符的非贪婪模式，只匹配尽量少的字符次数。
- 比如，对于 'aaaaaa'， a{3,5} 匹配 5个 'a' ，
- 而 a{3,5}? 只匹配3个 'a'。