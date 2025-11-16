[toc]

## 字符实体大全参考ref

- [HTML Standard (whatwg.org)](https://html.spec.whatwg.org/multipage/named-characters.html#named-character-references)

- [Entity - 术语表 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Glossary/Entity)

- [Unicode 符号表 - 所有 Unicode 字符及其代码都在一页上 (◕‿◕) SYMBL](https://symbl.cc/cn/unicode-table/)
  - 内容很全,但是很卡


## abstract

往网页中输入特殊字符，需在html代码中加入以&开头的字母组合或以&#开头的数字。下面就是以字母或数字表示的特殊符号大全。

### 部分表格预览

参照表:[HTML Standard](https://html.spec.whatwg.org/multipage/named-characters.html#named-character-references)

或者文档的json格式呈现:[html.spec.whatwg.org/entities.json](https://html.spec.whatwg.org/entities.json)

- | 实体编号(html代码) | UniCode编号     | 描述 |
  | ------------------ | --------------- | ---- |
  | `nbsp;`            | U+000A0         | 空格 |
  | `nbump;`           | U+0224E U+00338 | ≎̸    |
  | `nbumpe;`          | U+0224F U+00338 | ≏̸    |
  | `ncap;`            | U+02A43         | ⩃    |
  | `Ncaron;`          | U+00147         | Ň    |
  | `ncaron;`          | U+00148         | ň    |
  | `Ncedil;`          | U+00145         | Ņ    |
  | `ncedil;`          | U+00146         |      |

## Unicode refs

- [About Unicode – Unicode](https://home.unicode.org/about-unicode/)

- [Unicode - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/Unicode)
- [List of Unicode characters - Wikipedia](https://en.wikipedia.org/wiki/List_of_Unicode_characters)

## unicode

Unicode，全称为Unicode标准（The Unicode Standard），其官方机构Unicode联盟所用的中文名称为 **统一码**，又译作**万国码、统一字符码、统一字符编码**，是信息技术领域的业界标准，其整理、编码了世界上大部分的文字系统，使得电脑能以通用划一的字符集来处理和显示文字，不但减轻在不同编码系统间切换和转换的困扰，更提供了一种跨平台的乱码问题解决方案。

Unicode由非营利机构Unicode联盟（Unicode Consortium）负责维护，该机构致力让Unicode标准取代既有的字符编码方案，因为既有方案编码空间有限，亦不适用于多语环境。

目前，几乎所有电脑系统都支持基本拉丁字母，并各自支持不同的其他编码方式。

Unicode为了和它们**相互兼容**，其首256个字符保留给**ISO 8859-1**所定义的字符，使既有的西欧语系文字的转换不需特别考量；

并且把**大量相同的字符重复编到不同的字符码**中去，使得旧有纷杂的编码方式得以和Unicode编码间**互相直接转换**，而不会丢失任何信息。

> 举例来说，[全角](https://zh.wikipedia.org/wiki/全形)格式区段包含了主要的拉丁字母的全角格式，在中文、日文、以及韩文字形当中，这些字符以全角的方式来呈现，而不以常见的半角形式显示，这对**竖排文字和等宽排列文字有重要作用**。
>
> BMP 是 Unicode 的核心部分，最早的 Unicode 标准（1.0）就主要定义了 BMP。
>
> 在 BMP 之外的字符需要使用辅助平面（Supplementary Planes），通过 UTF-16 编码实现。
>
> **编码方式**(以下仅讨论BMP中的字符情况,此外的字符)
>
> - UTF-8：BMP 中的字符大多数用 1 至 3 个字节表示(做多6个字节用于表示罕见的字符)。
> - UTF-16：BMP 中的字符(之外也是)用 2 字节表示(无论这个字符多么常见还是多么罕见,总是占用2个字节)。
> - UTF-32：所有 BMP 中的字符用 4 字节表示。
>
> **分区**
>
> - BMP 被划分为多个区块，每个区块有特定的用途。以下是一些主要区块：
>
>   | 起始位置 | 结束位置 | 名称                                 | 描述                                 |
>   | -------- | -------- | ------------------------------------ | ------------------------------------ |
>   | U+0000   | U+007F   | 基本拉丁字母（Basic Latin）          | ASCII 字符，包括英文字母和基本符号。 |
>   | U+0080   | U+00FF   | 拉丁字母补充-1（Latin-1 Supplement） | 包含带重音符号的拉丁字符等。         |
>   | U+4E00   | U+9FFF   | CJK 统一表意文字                     | 包含中日韩常用的汉字。               |
>   | U+D800   | U+DFFF   | 代理区块（Surrogates）               | 用于编码超出 BMP 范围的字符。        |

在表示一个Unicode的字符时，通常会用“`U+`”然后紧接着一组**十六进制的数字**来表示这一个字符。

在**基本多文种平面**里的所有字符，要用四个数字（即2字节，共16位，例如U+4AE0，共支持六万多个字符($16^{4}=(2^{4})^{4}=2^{16}=65536$）；

> 基本多文种平面（BMP, Basic Multilingual Plane）
>
> **基本多文种平面**是 Unicode 编码体系中最重要的一个平面，包含了从 `U+0000` 到 `U+FFFF` 的代码点范围，总计 65,536个代码点。它是 Unicode 字符集中最早定义的部分，涵盖了大部分常用的字符。

在零号平面以外的字符则需要使用**五或六个数字**。旧版的Unicode标准使用相近的标记方法，但却有些微小差异：

**在Unicode 3.0里使用“U-”然后紧接着八个数字**，**而“U+”则必须随后紧接着四个数字**。

基本多文种平面的字符的编码为`U+hhhh`，其中每个h代表一个[十六进制](https://zh.wikipedia.org/wiki/十六进制)数字，与UCS-2编码完全相同。而其对应的4字节UCS-4编码后两个字节一致，前两个字节则所有位均为0。

### Unicode的实现方式

Unicode的实现方式不同于编码方式。一个字符的Unicode编码确定。但是在实际传输过程中，由于不同系统平台的设计不一定一致，以及出于节省空间的目的，对Unicode编码的实现方式有所不同。Unicode的实现方式称为Unicode转换格式（Unicode Transformation Format，简称为UTF）。

例如，如果一个仅包含基本7位ASCII字符的Unicode文件，如果每个字符都使用2字节的原Unicode编码传输，**其第一字节的8位始终为0。这就造成了比较大的浪费**。对于这种情况，可以使用UTF-8编码，这是**变长编码**，它将基本7位ASCII字符**仍用7位编码表示，占用一个字节（首位补0）**。

而遇到与**其他Unicode字符**混合的情况(比如英文和中文混合出现)，将按一定算法转换，每个字符使用1-3个字节编码，并**利用首位为0或1识别**。这样**对以7位ASCII字符为主的西文文档就大幅节省了编码长度**（具体方案参见UTF-8）。

类似的，对未来会出现的需要4个字节的辅助平面字符和其他UCS-4扩充字符，2字节编码的UTF-16也需要通过一定的算法转换。

再如，如果直接使用与Unicode编码一致（仅限于BMP字符）的UTF-16编码，由于每个字符占用了两个字节，在麦金塔电脑（Mac）机和个人电脑上，对字节顺序的理解不一致。这时同一字节流可能会解释为不同内容，如某字符为十六进制编码4E59，按两个字节拆分为4E和59，在Mac上读取时是从低字节开始，那么在Mac OS会认为此4E59编码为594E，找到的字符为“奎”，而在Windows上从高字节开始读取，则编码为U+4E59的字符为“乙”。就是说在Windows下以UTF-16编码保存一个字符“乙”，在Mac OS环境下开启会显示成“奎”。此类情况说明UTF-16的编码顺序若不加以人为定义就可能发生混淆，于是在UTF-16编码实现方式中使用了大端序（Big-Endian，简写为UTF-16 BE）、小端序（Little-Endian，简写为UTF-16 LE）的概念，以及可附加的字节顺序记号解决方案，目前在个人电脑上的Windows系统和Linux系统对于UTF-16编码默认使用UTF-16 LE。（具体方案参见UTF-16）

此外Unicode的实现方式还包括UTF-7、Punycode、CESU-8、SCSU、UTF-32、GB18030等，这些实现方式有些仅在一定的国家和地区使用，有些则属于未来的规划方式。目前通用的实现方式是**UTF-16小端序（LE）、UTF-16大端序（BE）和UTF-8**。

在微软公司Windows XP附带的记事本（Notepad）中，**“另存为”对话框**可以选择的**四种编码方式**

除去非Unicode编码的**ANSI**（对于英文系统即ASCII编码，中文系统则为**GB2312**或**Big5**编码）外，**其余三种为“Unicode”（对应UTF-16 LE）、“Unicode big endian”（对应UTF-16 BE）和“UTF-8”**。

### 非Unicode环境

在非Unicode环境下，由于不同国家和地区采用的字符集不一致，很可能出现无法正常显示所有字符的情况。微软公司使用了代码页（Codepage）转换表的技术来过渡性地部分解决这一问题，即通过指定的转换表将非Unicode的字符编码转换为同一字符对应的系统内部使用的Unicode编码。可以在“语言与区域设置”中选择一个代码页作为非Unicode编码所采用的默认编码方式，如936为简体中文GB码，950为繁体中文Big5（皆指PC上使用的）。在这种情况下，一些非英语的欧洲语言编写的软件和文档很可能出现乱码。而将代码页设置为相应语言中文处理又会出现问题，这一情况无法避免。只有完全采用统一编码才能彻底解决这些问题，但目前尚无法做到这一点。

代码页技术现在广泛为各种平台所采用。UTF-7的代码页是65000，UTF-8的代码页是65001。

### XML和Unicode

XML及其子集XHTML采用UTF-8作为**标准字符集**，理论上我们可以在各种支持XML标准的浏览器上显示任何地区文字的网页，只要电脑本身安装有合适的字体即可。

可以利用`&#nn...n;`的格式**显示特定的字符**。

- `nn...n`代表该字符的**十进制**`Unicode`代码。(兼容性更好)

- 如果采用**十六进制**代码，**在编码之前加上x字符即可**。即格式为`&#xhh...h`

所有unicode码可能呈现为`&#xhh...h;`的形式,其中`hh...h`代表该字符的16进制码,比如 &#256;(`&#256;`)和&#x100;(`&#x100;`)是相同的显示效果(如果软件兼容的话),但部分旧版本的浏览器可能无法识别十六进制代码。

根据Unicode的取值范围(十六进制),对应的字符为:`&#x0000; &#xffff;`



过去电脑编码的8位标准，使每个国家都只按国家使用的字符而编定各自的编码系统；而对于部分字符系统比较复杂的语言，如越南语，又或者东亚国家的大型字符集，都不能在8位的环境下正常显示。 只是最近才有在文本中对十六进制的支持，那么旧版本的浏览器显示那些字符或许可能有问题——大概首先会遇到的问题只是在对于大于8位Unicode字符的显示。

解决这个问题的普遍做法仍然是将其中的**十六进制码**转换成一个**十进制码**（例如：♠(&#9824;)用`&#9824;`代替`&#x2660;`,前者兼容性好,其中$2660_{16}$=$9824_{10}$）。

### 输入或翻译unicode字符

除了输入法外，操作系统也会提供另外几种方法输入Unicode。像是Windows 2000之后的Windows系统就提供可点击的[字符映射表](https://zh.wikipedia.org/wiki/字符映射表)。启动该程序,在命令行中输入`charmap.exe`,或者开始菜单中搜索

又或者在Microsoft Word下，按下Alt键不放，使用数字键盘输入0和某个字符的Unicode编码（**十进制**），再松开Alt键即可得到该字符，如Alt033865会得到Unicode字符`葉`。

另外，按AltX组合键，Microsoft Word也会将光标前面的字符同其**十六进制**的四位Unicode编码互相转换。

### unicode的utf实现

UTF是"Unicode/UCS Transformation Format"的首字母缩写，即把Unicode字符转换为某种格式之意。

- [UTF-8 - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/UTF-8#)
- [UTF-16 - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/UTF-16)

## utf-8

UTF-8（8-bit Unicode Transformation Format）是一种针对Unicode的**可变长度字符编码**，也是一种**前缀码**。

它可以用**一至四个字节**对Unicode字符集中的所有有效编码点进行编码，属于Unicode标准的一部分，最初由肯·汤普逊和罗布·派克提出。

由于较小值的编码点一般使用频率较高，直接使用Unicode编码效率低下，大量浪费内存空间。UTF-8就是为了解决向后兼容ASCII码而设计，Unicode中前128个字符，使用与ASCII码相同的二进制值的单个字节进行编码，而且字面与ASCII码的字面一一对应，这使得原来处理ASCII字符的软件无须或只须做少部分修改，即可继续使用。

因此，它逐渐成为电子邮件、网页及其他存储或发送文字优先采用的编码方式

UTF-16是Unicode字符编码五层次模型的第三层：字符编码表（Character Encoding Form，也称为"storage format"）的一种实现方式。即把Unicode字符集的抽象码位映射为16位长的整数（即码元）的序列，用于数据存储或传递。Unicode字符的码位，需要1个或者2个16位长的码元来表示，因此这是一个变长表示。

### utf-8和unicode

UTF-8使用**一至六个字节**为每个字符编码（尽管如此，2003年11月UTF-8被RFC 3629重新规范，**只能使用原来Unicode定义的区域，U+0000到U+10FFFF**，也就是说**最多四个字节**）：

1. 128个US-ASCII字符只需一个字节编码（Unicode范围由U+0000至U+007F）。
2. 带有附加符号的拉丁文、希腊文、西里尔字母、亚美尼亚语、希伯来文、阿拉伯文、叙利亚文及它拿字母则需要两个字节编码（Unicode范围由U+0080至U+07FF）。
3. 其他基本多文种平面（BMP）中的字符（这包含了大部分常用字，如大部分的汉字）使用三个字节编码（Unicode范围由U+0800至U+FFFF）。
4. 其他极少使用的**Unicode** 辅助平面的字符使用**四至六字节**编码（Unicode范围由U+10000至U+1FFFFF使用四字节，Unicode范围由U+200000至U+3FFFFFF使用五字节，Unicode范围由U+4000000至U+7FFFFFFF使用六字节）。

对上述提及的第四种字符而言，UTF-8使用**四至六个字节**来编码似乎太耗费资源了。但UTF-8对所有**常用**的字符都可以用三个字节表示

而且它的另一种选择，UTF-16编码，对前述的第四种字符同样需要四个字节来编码，所以要决定UTF-8或UTF-16哪种编码比较有效率，还要视所使用的字符的分布范围而定。不过，如果使用一些传统的压缩系统，比如DEFLATE，则这些不同编码系统间的的差异就变得微不足道了。若顾及传统压缩算法在压缩较短文字上的效果不大，可以考虑使用Unicode标准压缩格式（SCSU）。

Unicode**字符的比特被分割为数个部分**，并分配到UTF-8的**字节串中较低的比特的位置**。

在U+0080的以下字符都使用内含其字符的**单字节编码**。这些编码**正好对应7比特的ASCII字符**。

在其他情况，有可能需要**多达4个字符组来表示一个字符**。这些多字节的最高有效比特会设置成1，以防止与7比特的ASCII字符混淆，并保持标准的字节主导字符串运作顺利。

### 数据库中的utf8

MySQL字符编码集中有两套UTF-8编码实现：“utf8”和“utf8mb4”，其中“utf8”是一个字最多占据3字节空间的编码实现；而“utf8mb4”则是一个字最多占据4字节空间的编码实现，也就是**UTF-8的完整实现**。

这是由于MySQL在4.1版本开始支持UTF-8编码（当时参考UTF-8草案版本为RFC 2279）时，为2003年，并且在同年9月限制了其实现的UTF-8编码的空间占用最多为3字节，而UTF-8正式形成标准化文档（RFC 3629）是其之后。限制UTF-8编码实现的编码空间占用一般被认为是考虑到数据库文件设计的兼容性和读取最优化，但实际上并没有达到目的，而且在UTF-8编码开始出现需要存入非基本多文种平面的Unicode字符（例如emoji字符）时导致无法存入（由于**3字节的实现只能存入基本多文种平面内的字符**）。

直到2010年在5.5版本推出“utf8mb4”来代替、“utf8”重命名为“utf8mb3”并调整“utf8”为“utf8mb3”的别名，并不建议使用旧“utf8”编码，以此修正遗留问题

### html中实体字符和Unicode字符引用概述

字符引用(Character reference)

当Unicode字符本身不能或不应该使用时，HTML和XML提供了引用Unicode字符的方法。

 A *numeric character reference* refers to a character by its [Universal Character Set](https://en.wikipedia.org/wiki/Universal_Character_Set)/[Unicode](https://en.wikipedia.org/wiki/Unicode) *code point*, and a *character entity reference* refers to a character by a predefined name.

1. **数字字符引用**通过其通用字符集/Unicode码点引用字符
2. **字符实体引用**通过**预定义名称**引用字符。

#### 数字字符引用

数字字符引用通过通用字符集（Universal Character Set，UCS）/ Unicode 的代码点（code point）引用字符。格式如下：

`&#nnnn;`或`&#xhhhh; ` 

其中：

- `nnnn` 是十进制形式的代码点；
- `hhhh` 是十六进制形式的代码点；
- 在 XML 文档中，`x` 必须为小写；
- `nnnn` 或 `hhhh` 可以包含任意位数的数字，且可以包括前导零；
- `hhhh` 可以大小写混用，但通常使用大写形式。

#### 实体字符引用

实体字符引用通过一个实体的名称来引用字符，该实体的替代文本是所需的字符。格式为`&name;`  

其中：

- `name` 是区分大小写的实体名称；
- 分号（`;`）是必需的。

实体必须是预定义的（内置于标记语言中）或在文档类型定义（DTD）中明确声明的。

#### 人类与机器的使用偏好

由于数字比名称更难被人类记住，实体字符引用通常由人类编写，而数字字符引用则多由计算机程序生成。

## utf-16

UTF-16（16位Unicode转换格式）是一种字符编码方法，它能够编码所有的1,112,064个合法的Unicode码点。这种编码方式使用**一个或两个16位代码单元**来表示一个码点，因此它是变长的。

UTF-16是从早期固定宽度的16位编码UCS-2发展而来的，当意识到需要超过$2^{16}$（即65,536）个码点时，包括大多数表情符号和重要的CJK（中文、日文、韩文）字符，如人名和地名等，就产生了对更大范围编码的需求。

在Windows API以及许多编程环境中，例如Java编程语言和JavaScript/ECMAScript，都使用了UTF-16编码。此外，它也偶尔被用于纯文本文件和文字处理数据文件。然而，由于UTF-16是变长字符编码，而大多数字符实际上并不是变长的（所以变长特性很少被测试），这导致了许多软件中的错误，包括Windows本身。

值得注意的是，UTF-16是在网络上唯一仍被允许使用的与8位ASCII不兼容的编码。尽管如此，它在网络上的流行度远不及UTF-8。根据统计数据，到2025年，UTF-8已经占据了几乎全部网页的编码方式，占比达到了99%，而声明使用UTF-16的公共网页不到0.004%。Web Hypertext Application Technology Working Group (WHATWG)认为UTF-8应该是所有文本的强制性编码，并且出于安全考虑，浏览器应用程序不应该使用UTF-16。

至于中文排版，UTF-16可以很好地支持中文字符，因为它能够编码整个Unicode字符集，包括中文字符。不过，在实际应用中，由于UTF-8的广泛采用及其与ASCII的兼容性，很多中文排版工作也是基于UTF-8进行的。中文排版涉及到字体选择、行距、字距调整、断行规则等多个方面，而这些并不直接受编码方式的影响，更多取决于所使用的排版工具和系统的支持。

### 编码

Unicode的编码空间从U+0000到U+10FFFF，共有1,112,064个码位（code point）可用来映射字符。Unicode的编码空间可以划分为17个平面（plane），每个平面包含216（65,536）个码位。

17个平面的码位可表示为从U+xx0000到U+xxFFFF，其中xx表示十六进制值从$00_{16}$到$10_{16}$(对应于十进制的0到16)，共计17个平面。

第一个平面称为**基本多语言平面**（Basic Multilingual Plane, **BMP**），或称第零平面（Plane 0），其他平面称为**辅助平面**（Supplementary Planes）。

**基本多语言平面**内，从U+D800到U+DFFF之间的码位区段是永久保留不映射到Unicode字符。UTF-16就利用保留下来的0xD800-0xDFFF区块的码位来**对辅助平面的字符的码位进行编码**。

### utf-16和ucs-2

UTF-16可看成是UCS-2的父集。在没有辅助平面字符（surrogate code points）前，UTF-16与UCS-2所指的是同一的意思。

但当引入辅助平面字符后，就称为UTF-16了。现在若有软件声称自己支持UCS-2编码，那其实是暗指它不能支持在UTF-16中超过2字节的字集。对于小于0x10000的UCS码(不超过0xffff)，UTF-16编码就等于UCS码。



## utf-8对比utf-16

UTF-8和UTF-16之间的兼容性主要体现在它们都能够表示所有的Unicode字符，但是它们在设计上有显著的不同，这影响了它们在不同环境下的使用和互操作性。

### 兼容性分析

- **ASCII兼容性**：UTF-8是与ASCII完全向后兼容的。这意味着任何ASCII文本都是有效的UTF-8文本，并且每个ASCII字符（0到127）在UTF-8中只占用一个字节。而UTF-16不是与ASCII直接兼容的，因为它至少需要两个字节来表示一个字符，即使是ASCII字符也不例外。

- **变长编码**：UTF-8是一种变长编码，对于不同的Unicode码点，它会使用1到4个字节不等。UTF-16也是变长的，但对于基本多语言平面（BMP）内的字符，通常使用两个字节；对于超出BMP的字符，则使用四个字节（代理对）。这种差异意味着处理这两种编码时需要不同的逻辑。

- **字节序问题**：UTF-16有字节序的问题，即大端序（Big Endian, BE）和小端序（Little Endian, LE），因此可能需要一个字节顺序标记（BOM）来标识文件或流的字节序。UTF-8由于其变长特性，不需要BOM，但有时也会加上BOM来标识编码方式。

### 转换方法

当需要在UTF-8和UTF-16之间进行转换时，可以使用编程语言提供的内置函数或库来进行转换。例如，在Python中，可以通过`encode()`和`decode()`方法轻松地将字符串从一种编码转换为另一种：

```python
# 将UTF-8字符串转换为UTF-16
utf8_str = "Hello, 世界"
utf16_bytes = utf8_str.encode('utf-16')
print(f"UTF-16 encoded: {utf16_bytes}")

# 将UTF-16字节串转换回UTF-8
utf8_from_utf16 = utf16_bytes.decode('utf-16').encode('utf-8')
print(f"Back to UTF-8: {utf8_from_utf16}")
```

### 性能与应用场景

- **性能方面**：在处理包含大量ASCII字符的文本时，UTF-8具有更高的效率，因为每个ASCII字符只需一个字节。而在处理包含大量非ASCII字符（如中文、日文、韩文等）的文本时，UTF-16可能会更节省空间，因为这些字符在UTF-8中通常需要3个字节，而在UTF-16中只需要2个字节。

- **应用场景**：UTF-8在网络传输和跨平台数据交换中非常流行，因为它与ASCII兼容并且广泛支持。UTF-16则常见于某些操作系统内部（如Windows API）以及一些编程语言（如Java和JavaScript）的默认字符串表示形式。

综上所述，尽管UTF-8和UTF-16都能够完整表示Unicode字符集，但它们各有特点和适用场景，并且在实际应用中可能需要根据具体需求选择适当的编码方式或进行编码转换。



## js和json中的\u字符

在 JavaScript 字符串或 JSON 数据中，表示一个特定的 Unicode 字符有以下常用方法：

### 直接输入字符

如果你的编码是 UTF-8（现代项目大多采用 UTF-8），可以直接在字符串中输入该 Unicode 字符：

```javascript
const str = "中"; // 直接使用字符
```

###  使用 Unicode 转义序列

JavaScript 支持 Unicode 转义序列，用 `\u` 或 `\u{}` 表示 Unicode 字符。

#### 早期 Unicode 编码（BMP 内的字符，U+0000 到 U+FFFF）

用 `\u` 表示，后接四位十六进制代码。

```javascript
const str = "\u4E2D"; // "中"的 Unicode 转义形式
```

#### 扩展 Unicode 编码（辅助平面字符，U+10000 及以上）

用 ES6 引入的 `\u{}` 语法表示，可以支持任意长度的十六进制代码。

```javascript
const emoji = "\u{1F600}"; // 😀 的 Unicode 转义形式
```

### 3. **JSON 数据中的 Unicode 表示**

在 JSON 数据中，也可以使用 Unicode 转义来表示字符。JSON 本质上是文本格式，因此遵循与 JavaScript 字符串相同的规则。

#### 示例

```json
{
  "character": "\u4E2D",
  "emoji": "\uD83D\uDE00"
}
```

### 4. **使用字符编码转换函数**

JavaScript 提供了一些函数用于将字符或代码点转换为字符串。

#### 使用 `String.fromCharCode`

用于 BMP 范围内的字符（U+0000 至 U+FFFF）。

```javascript
const str = String.fromCharCode(0x4E2D); // "中"
```

#### 使用 `String.fromCodePoint`

支持所有 Unicode 字符，包括辅助平面的字符。

```javascript
const emoji = String.fromCodePoint(0x1F600); // 😀
```

#### 获取字符的 Unicode 值

- `charCodeAt`：获取 BMP 范围内字符的代码点。
- `codePointAt`：支持获取辅助平面字符的代码点。

```javascript
const char = "中";
console.log(char.charCodeAt(0)); // 20013 (十进制)
console.log(char.codePointAt(0)); // 20013 (十进制)
```

### 示例综合

以下是一个包含 Unicode 表示的代码示例：

```javascript
// 直接字符
const char1 = "中";

// 转义序列
const char2 = "\u4E2D"; // BMP 内字符
const char3 = "\u{1F600}"; // 辅助平面字符

// JSON 数据
const jsonData = {
  character: "\u4E2D",
  emoji: "\u{1F600}"
};

// 字符编码转换
const char4 = String.fromCharCode(0x4E2D);
const char5 = String.fromCodePoint(0x1F600);

console.log(char1, char2, char3, char4, char5);
console.log(JSON.stringify(jsonData));
```

### 总结

在 JavaScript 或 JSON 中表示 Unicode 字符的选择取决于应用场景：

- 直接字符：最简单直观，但依赖于文件编码。
- Unicode 转义序列：更通用，适用于所有字符。
- 编码转换函数：动态生成或处理字符时非常有用。

## 渲染失败案例

- html看似相同且正确的两段代码却无法渲染出一致的结果:空格问题(肉眼无法直接看出来错误的代码问题)/标签渲染不出来的可能原因/回调事件没有相应

##  这种由于ascii=160的空格可能引起渲染失败:

- 某些编辑器会显示出ascii=32和ascii=160的空格的区别
- 这种一般是复制代码可能造成混入&nbsp 空格的问题

##  可能导致标签渲染不出来的原因

不经常写前端的话,容易忘记某些细节,比如标签内的属性之间用的时空格来分割,如果使用了都好`,`之类的分隔符,就会导致渲染不出来
```html
 <!-- import vue cdn: -->
<script src="https://unpkg.com/vue@next"></script>
 <form @submit.prevent="insert">
            <input type="text" v-model="name">
            <input type="text" v-model.number="price">
            <button>add</button>
</form>
```
##  回调函数没有响应
- 不同于静态语言,js+html 经常对于标识符的不对应的检查能力较弱,这也是我们需要首先排查的地方,特别时函数签名和函数调用