[toc]



##  powershell 多行输入重定向🎈

- powershell也支持`>`号的方法进行重定任意行内容
- 此外powershell可以不用明写前头的echo;
- powershell中文本重定向的方法比较统一,总体更加方便,构造单行或多行字符串,然后从定向到指定文件就可以,而且`@"..."@`支持插值引用外部变量,很方便

###  @string(here-string)方式

- 使用`" "`可以直接创建多行文本,但是如果需要阻止shell解释内部的一些特殊符号和可能引起shell解释的字符,则使用`' '`来创建

- `' '`本身就是不解释插值变量的直接使用`' '`

- 无法直接保留包含多个`'`的字符串(这时候尝试`@'`字符串

- ```powershell
  PS D:\repos\blogs> @'
  >> 欧拉公式（英语：Euler's formula，又称尤拉公式）是复分析领域的公式，它将三角函数与复指数函数关联起来，因其提出者莱昂哈德·欧拉而得名。欧拉公式提出，对任意实数 (Image: x)，都存在
  >> (Image: e^{ix} = \cos x + i\sin x)
  >> 其中 (Image: e) 是自然对数的底数，(Image: i) 是虚数单位，而 (Image: \cos) 和 (Image: \sin) 则是余弦、正弦对应的三角函数，参数 (Image: x) 则以弧度为单位[1]。这一复数指数函数有时还写作 cis x （英语：cosine plus i sine，余弦加i 乘以正弦）。由于该公式在 (Image: x) 为复数时仍然成立，所以也有人将这一更通用的版本称为欧拉公式[2]。
  >> 欧拉公式在数学、物理和工程领域应用广泛。物理学家理查德·费曼将欧拉公式称为：“我们的珍宝”和“数学中最非凡的公式”[3]。
  >> 当 (Image: {\displaystyle x=\pi }) 时，欧拉公式变为(Image: {\displaystyle {{{e}^{{i}\,{\pi }}}+{1}}=0})，即欧拉恒等式。
  >> '@
  
  ```

- 构造一个多行字符串,您通常需要三行内容

  - 第一行`@'`
  - 第二行`任意内容`(不想要被powershell解读内容(不做转义和插值计算处理))
  - 第三行`'@`

- 带**插值**解释的多行字符串,类似的需要三行内容

  - 第一行`@"`
  - 第二行`任意内容`(包含需要被powershell解读和计算的内容(转义和插值计算处理))
  - 第三行`"@`

- Note:

  - 上面所说的三行内容是保证最佳效果,不是必须的,(它们当然也可以拿来构造单行字符串,这是它们的功能和`""`以及`''`是相仿的

- 例

  - ```powershell
    PS D:\repos\blogs> @'
    >> test calc $PROFILE;`n
    >> `t....
    >> '@
    test calc $PROFILE;`n
    `t....
    
    ```

  - ```powershell
    PS D:\repos\blogs> @"
    >> test calc $PROFILE;`n
    >> `t....
    >> "@
    test calc C:\Users\cxxu\Documents\PowerShell\Microsoft.PowerShell_profile.ps1;
    
            ....
    PS D:\repos\blogs>
    ```

    

> 