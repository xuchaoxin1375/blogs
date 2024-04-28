[toc]

## abstract

- 文档[chcp | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/chcp)

  - ```bash
    PS[BAT:80%][MEM:24.09% (7.64/31.70)GB][11:36:46]
    # [C:\Windows\System32]
     chcp /?
     
    Displays or sets the active code page number.
    
    CHCP [nnn]
    
      nnn   Specifies a code page number.
    
    Type CHCP without a parameter to display the active code page number.
    ```

    

## 常见编码

### ANSI

- ANSI编码是一种广泛使用的字符编码标准的总称，但实际上这个术语在不同的上下文中有不同的含义。传统上，ANSI编码指的是基于ASCII扩展的字符集，这些字符集由各个国家或地区定义，用于支持本地语言字符。然而，严格来说，美国国家标准学会（American National Standards Institute, ANSI）并没有直接定义这些多字节字符编码，而是通过采纳其他标准组织的工作成果间接影响了这一领域。

  在个人电脑领域，特别是在微软Windows操作系统中，“ANSI编码”通常指的是系统所采用的特定代码页（Code Page）。例如：

  - 在简体中文Windows环境中，ANSI编码通常指的是GBK编码，它扩展了GB2312，包含了更多的汉字和符号。
  - 在日文Windows环境中，ANSI编码则对应Shift_JIS编码，用于表示日语字符。
  - 在其他地区，ANSI编码可能代表ISO-8859系列或其他特定于地区的编码标准。

  ANSI编码通常使用1个字节来表示ASCII字符（0x00到0x7F），而对于扩展字符（如非英语字母、汉字等），则使用1到2个字节（或在某些情况下更多）。这意味着不同地区的ANSI编码之间是不兼容的，同一个二进制数据在不同的ANSI编码下可能被解释成完全不同的字符。

  随着Unicode（包括UTF-8）的普及，ANSI编码的使用已经减少，因为Unicode提供了一个统一的字符集，能够包含世界上几乎所有的字符，并且在国际化和网络通信方面表现得更加灵活和兼容。