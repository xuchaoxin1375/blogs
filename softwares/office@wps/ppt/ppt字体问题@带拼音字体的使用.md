[toc]

## 字体下载

- [100font.com - 免费商用字体大全 - 免费字体下载网站](https://www.100font.com/)

### 拼音字体

- 带拼音字体一般是给小学生,特别是一二年级的小朋友看的

  - [拼音字体 免费商用字体大全 - 免费字体下载网站](https://www.100font.com/search-_E6_8B_BC_E9_9F_B3-1.htm)

  - [免费拼音字体下载 - 免费商用拼音字体大全 - 100font.com](https://www.100font.com/forum-1-1.htm?tagids=15_0_0_0)

  - [方正楷体拼音字库字体免费下载和在线预览-字体天下 (fonts.net.cn)](https://www.fonts.net.cn/font-32489380389.html)

### 多音字问题

- 使用拼音字体的一个问题是要注意多音字问题
- 例如**弹力**和**弹弓**两个“弹”字发音不同,因此定稿前建议仔细审查一遍
  - 带拼音字体一般会带有多个字库(往往是6个字库)
  - 不同字库内有的字同一个字有不同的发音,可以根据需要切换同一个字体的不同字库

## office中的文字添加拼音

- [向中文文字添加拼音指南 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/向中文文字添加拼音指南-c03ad8e4-799b-499e-89a2-c749fc5397e8)

  - 主要是再word中添加汉字拼音,我们可以对拼音直接编辑(可以更改拼音样式(字体,对齐方式))
  - 这种方法其实并不好,因为文字样式无法作用于拼音,使得加大文字后拼音的位置和大小无法跟着一起变换,就不满足需要
  - 但也有它的优点,比如说
    - 所有拼音字体的注音都不满足需要时可以用word的这个功能(先将文字字体大小调好,然后注音,之后就不要再更改格式了,否则需要重新注音)
    - 对于一般的词组,能够默认并正确地给出正确的注音,并且复制出来的形式是:
      - `弹(dàn)弓(gōng);弹(tán)力(lì)`
      - 也即是注音可以一并带出,用括号包裹
    - 更改读音:我们无法直接在注音框中自定义拼音字母的读音,但是可以用某些输入法插入带有声调的字母(或者从其他字的注音中复制需要的带声调字母),或者word中选择合适的字体(比如带有汉字拼音的字体,一般可以找到带有四个声调的拼音)

- 扩展:[( Word里怎么打出拼音和声调来？ (zhihu.com)](https://www.zhihu.com/question/463594542)


### word中自定i有声调

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/9c8d598a11ce42b8994e29468f42062f.png)

### 常用部分带声调拼音字母

- āáǎà
- ēéěè
- īíǐì
- ōóǒò
- ūǔúù
- üǖǘǚǜ
- ńň

### 常用中文标点符号

- —‘’“”…、。〈〉《》，

## 查看本机字体

### powershell列出所有字体

- `(New-Object System.Drawing.Text.InstalledFontCollection).Families`

  - ```
    PS C:\repos>  (New-Object System.Drawing.Text.InstalledFontCollection).Families
    
    Name
    ----
    Arial
    Arial Black
    Arial Narrow
    Bahnschrift
    Bahnschrift Condensed
    Bahnschrift Light
    Bahnschrift Light Condensed
    Bahnschrift Light SemiCondensed
    Bahnschrift SemiBold
    Bahnschrift SemiBold Condensed
    Bahnschrift SemiBold SemiConden
    Bahnschrift SemiCondensed
    ```

    

- 或者拍配置成函数,方便之后使用

  - ```powershell
    function font_list()
    {
        # [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
        (New-Object System.Drawing.Text.InstalledFontCollection).Families
    }
    ```

  - 之后直接执行`font_list`即可





