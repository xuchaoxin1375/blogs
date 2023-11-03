[toc]



# linux@powershell字符串@文件输入输出重定向/shell写入多行文本到文件中/cat 操作文件

## references

- [Unix / Linux - Shell Input/Output Redirections (tutorialspoint.com)](https://www.tutorialspoint.com/unix/unix-io-redirections.htm)

- [bash - What does <<< mean? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/80362/what-does-mean)

- What is Redirection?
  - [Output Redirection](https://www.guru99.com/linux-redirection.html#1)
  - [Input redirection](https://www.guru99.com/linux-redirection.html#2)
  - [File Descriptors (FD)](https://www.guru99.com/linux-redirection.html#3)
  - [Error Redirection](https://www.guru99.com/linux-redirection.html#4)
  - [Why Error Redirection?](https://www.guru99.com/linux-redirection.html#5)

  

## sheet

### Redirection Commands

Following is a complete list of commands which you can use for redirection −

| Sr.No. | Command & Description                                        |
| ------ | ------------------------------------------------------------ |
| 1      | **pgm > file** Output of pgm is redirected to file           |
| 2      | **pgm < file** (pgm从文件读取输入)Program pgm reads its input from file |
| 3      | **pgm >> file** Output of pgm is appended to file            |
| 4      | **n> file** Output from stream with descriptor **n** redirected to file |
| 5      | **n>> file** Output from stream with descriptor **n** appended to file |
| 6      | **n>& m** Merges output from <u>stream **n**</u> with <u>stream **m**</u> |
| 7      | **n<& m** Merges input from stream **n** with stream **m**   |
| 8      | **<< tag** (读取标准输入内容块)Standard input comes from here through next tag at the start of line |
| 9      | $\textbf{|}$(管道符) Takes output from one program, or process, and sends it to another |

### Note that the file descriptor:

* **0** is normally standard input (STDIN),
* **1** is standard output (STDOUT),
* **2** is standard error output (STDERR).

###  Summary

- Each file in Linux has a corresponding File Descriptor associated with it
- The keyboard is the standard input device while your screen is the standard output device
- “>” is the output redirection operator. “>>” appends output to an existing file
- “<” is the input redirection operator
- “>&”re-directs output of one file to another.
- You can re-direct error using its corresponding File Descriptor 2.

### example

- 普通标准重定向

  - ```bash
    #环境:install_pip文件是存在的,而file_test文件时不存在的,以下命令会产生两种性质的输出
    # cxxu @ cxxuAli in ~ [18:27:34]
    $ ll install_pip file_test
    ls: cannot access 'file_test': No such file or directory
    -rw-rw-r-- 1 cxxu cxxu 290 May 18 23:22 install_pip
    
    # cxxu @ cxxuAli in ~ [18:28:05] C:2
    $ ll install_pip file_test > log
    ls: cannot access 'file_test': No such file or directory
    ```

  - 可见,被正确处理的部分可以被`>`重定向到指定文件中

  - 但是未被正确处理的错误内容依然会被输出到终端

  - 所以为了将错误信息一同保留,需要使用`2>&`

    - 比如指定`2>&1`,这样,错误信息会跟随标准输出 输出到同一个文件中.

- 流n 冲定向到流m:

  - ```bash
    # cxxu @ cxxuAli in ~ [18:28:11] C:2
    $ ll install_pip file_test > log 2>&1
    
    # cxxu @ cxxuAli in ~ [18:28:23] C:2
    $ cat log
    ls: cannot access 'file_test': No such file or directory
    -rw-rw-r-- 1 cxxu cxxu 290 May 18 23:22 install_pip
    ```

    

  - 将所有输出(包括错误输出重定向到一个文件中log.txt)

    - 使用`nohup...&`将任务挂在到后台执行

    - ```bash
      $ nohup webhook -hooks hooks.json -verbose >log.txt 2>&1 &
      [1] 29968
      
      ```

  

  

## 重定向多行文本输入(文本块)

- 下面提到的 token 是自定义的结束符(delimiter),一般使用 eof

### 覆盖性写入多行内容

- `> fileName << token`

- 键入多行内容(content lines..)
- 在单独的一行键入token,结束操作

```bash
# 创建多行文件
cxxu_kali➜~» > file << eof                                                      [13:58:25]
heredoc> line cover
heredoc> line cover
heredoc> eof
# 查看文件
cxxu_kali➜~» nl file                                                            [13:59:07]
     1  line cover
     2  line cover
cxxu_kali➜~»     
```

### 追加多行
####  >> <<重定向法
`>> fileName << token`

- 键入多行内容(content lines..)
- 在单独的一行键入token,结束操作
- 大概过程是这样的:`<<`将多行输入输送给前面的 `>>`;
- `>>`又将内容输送到文件 `fileName`中

```bash
cxxu_kali➜~» >> file << eof                                                    
heredoc> append line
heredoc> eof
# 查看结果
cxxu_kali➜~» cat file                                                           [14:05:51]
line cover
line cover
append line
```
####  `引号`换行重定向法(echo >)
##### 方法特点
- 简单易用
- 适用范围广(嵌入脚本内来修改/创建文件方便)
- 但是有些时候需要转义字符,会造成不便!
- 另外在脚本文件中,可以通过字符串加法/模板字符串等操作得到插值后的字符串!
>无论是单行还是多行,都可以轻松做到
```bash
cxxu_kali➜Users/cxxu/Desktop» ec "line1                                         [11:12:19]
line2
line3" > ww
cxxu_kali➜Users/cxxu/Desktop» nl ww                                             [11:12:25]
     1  line1
     2  line2
     3  line3
cxxu_kali➜Users/cxxu/Desktop» ec "line5                                         [11:12:28]
dquote> line6
dquote> line7">>ww
cxxu_kali➜Users/cxxu/Desktop» nl ww                                             [11:15:59]
     1  line1
     2  line2
     3  line3
     4  line5
     5  line6
     6  line7
```


## cat 和重定向

### 利用cat 创建一个多行文件
>方法特点:整齐
```bash
cxxu_kali➜~» cat > fileByCat                                                    [13:09:08]
line1
line2
#结束输入:可以通过键入ctrl+D完成文件的创建,不过此前需要确保有一个回车(也就是说ctrl+D在单独的行键入才有效);
# 检查文件创建
cxxu_kali➜~» nl fileByCat                                                       [13:15:19]
     1  line1
     2  line2
# 文件追加也没问题
cxxu_kali➜~» cat >> fileByCat                                                   [13:15:29]
line by "cat >>"
cxxu_kali➜~»                                                                    [13:18:10]
cxxu_kali➜~» nl fileByCat                                                       [13:18:11]
     1  line1
     2  line2

     3  line by "cat >>"
cxxu_kali➜~»            
```

### cat 合并文件并作为全新创建的文件的内容(concatenate files)

```bash
# 生成演示文件
cxxu_kali➜~» cat > file1                                                        [13:30:53]
file1 content:
lin1
lin2
cxxu_kali➜~» cat > file2                                                        [13:31:37]
file2 content:
lin3
lin4
# 执行合并
cxxu_kali➜~» cat file1 file2 > fileConcatenated                                 [13:36:14]
cxxu_kali➜~» nl fileConcatenated                                                [13:36:33]
     1  file1 content:
     2  lin1
     3  lin2
     4  file2 content:
     5  lin3
     6  lin4
cxxu_kali➜~»   
```

```
# 将file1的内容接到file2中去(末尾)
cxxu_kali➜~» cat file1 >> file2
# 查看合并结果
cxxu_kali➜~» cat file2                                                          [13:50:51]
file2 content:
lin3
lin4
file1 content:
lin1
lin2
```
##  利用tee来重定向
- 事实上,我最喜欢使用tee来创建多行内容,特别是在tee与sudo的配合比较方便写入到需要特殊权限的地方

###  利用tee创建多行文件

#### 类似于cat 的用法
- 从键盘上输入多行内容
- 使用`ctrl+D`完成输入
- 适用于手动交互输入多行内容(不适合脚本中使用)

- 下面是一个保存清华源到一个文件的过程;在单独的空行键入`ctrl+D`完成文件的创建

```bash
$ sudo tee -a ./KaliAptSourceQingHua

deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free

```
对应的cat语句:
`sudo cat >> ./KaliAptSourceQingHua`

#### tee也可以配合<<符使用

- 使用<< token 来结束输入

```bash
# cxxu_kali @ cxxuWin11 in ~ [9:16:39]
$ sudo tee -a  ./ustcAptSourceQingHua <<eof
heredoc> deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

heredoc> eof
# 此时文件已经创建完成
#以下是tee的回显
deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

## 再次检查确认
# cxxu_kali @ cxxuWin11 in ~ [9:25:55]
$ nl ustcAptSourceQingHua
     1  deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

     2  deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
```


## 在脚本文件中一次性打印多行

- 通过键盘输入内容来模拟文件输入,将数据传给命令

```bash
#!/bin/sh

cat << EOF
This is a simple lookup program
for good (and bad) restaurants
in Cape Town.
EOF
```

### 单行内容写入到文件
> 这比较简单

```bash
cxxu_kali➜~» echo "write to file" > file0                                       [13:08:41]
cxxu_kali➜~» nl file0                                                           [13:08:56]
     1  write to file
```
###  将字符串传递给命令行(<<<)
- 使用管道符,意味着管道符后面的任务是在subshell中执行的
- 参数可以传递到subshell中,这没问题,但是,当我们要在current shell 中拿到subshell中的处理结果,则需要小心
	- 要么再追加一个管道符,将需要取值的命令接在后面,要么避免使用管道符,采取变通的办法.
- 使用`<<<`将某个字符串传递给命令行,可以不开辟subshell,从而可以避免出现意外结果
- [bash - What does <<< mean? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/80362/what-does-mean)

- 利用cat来查看某些空白字符
```bash
┌──(cxxu㉿CxxuWin11)-[~]
└─$ echo "$IFS" |cat -A
:$

┌──(cxxu㉿CxxuWin11)-[~]
└─$ cat -A <<<"$IFS"
:$

```

##  powershell 多行输入重定向🎈
- powershell也支持`>`号的方法进行重定任意行内容
- 此外powershell可以不用前头的echo;
###  reference
- [about Quoting Rules - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7.2)🎈
- [Everything you wanted to know about variable substitution in strings - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#variable-substitution)
	 * [2Variable substitution](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#variable-substitution)
	* [2Command substitution](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#command-substitution)
	  * [3Command execution](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#command-execution)
	* [2Format string](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#format-string)
	  * [3Format values as arrays](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#format-values-as-arrays)
	* [2Advanced formatting](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#advanced-formatting)
	* [2Joining strings](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#joining-strings)
	* [2Join-Path](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#join-path)
	* [2Strings are arrays](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#strings-are-arrays)
	  * [3StringBuilder](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#stringbuilder)
	* [2Delineation with braces](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#delineation-with-braces)
	* [2Find and replace tokens](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#find-and-replace-tokens)
	  * [3Replace multiple tokens](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#replace-multiple-tokens)
	  * [3ExecutionContext ExpandString](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#executioncontext-expandstring)
	* [2Whatever works the best for you](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-7.2#whatever-works-the-best-for-you)

## powershell中的引号和字符串@多行字符的正确构造方法

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

    

