[toc]



## reference

- [sed, a stream editor (gnu.org)](https://www.gnu.org/software/sed/manual/sed.html)

## abstract

- `sed` 是一款强大的流编辑器（Stream Editor），主要用于对输入数据进行文本转换操作。它读取文件或从标准输入获取内容，逐行处理每一行文本，并根据指定的规则进行查找、替换、删除、插入等各种编辑操作。由于其非交互式的特性，`sed` 常常被用于批处理大量文本文件或者自动化脚本中。

### 基本使用格式

```bash
sed [options] 'commands' inputfile
```

- `options`：可选参数，例如 

  - `-i` 表示直接修改原文件(inplace 就地修改)，
  - `-e` 后接多个 sed 命令(expression)，
  - `-f` 从文件中读取 sed 命令等(file)。
  - `-n`：静默模式，仅打印经过命令处理的行，默认情况下，`sed` 会打印每一行，无论是否进行了修改。
  - `-i`：直接编辑原文件，否则默认情况下只是将处理结果显示到终端，不会改变原文件内容。
  - `-e command` 或 `-f script-file`：允许在同一命令行中添加多条命令或从文件中读取命令。

- `'commands'`：这是 sed 的命令部分，通常是一些针对文本模式匹配和替换的规则，每个规则由一个正则表达式和相应的操作组成，中间用逗号分隔。

  - 一系列针对文本的处理指令，这些指令可以在单引号内以 `-e` 参数逐一列出，也可以写入一个单独的脚本文件并通过 `-f` 参数引用。
  - 每条命令的基本形式为：`address {command}`
  - 其中，`address` 可以是行号（如 `10`，表示第10行）、行号范围（如 `5,15`，表示第5行至第15行）、正则表达式（如 `/pattern/`，匹配包含 pattern 的行），若省略地址，则表示对所有行生效。

- `inputfile`：需要处理的文件名，如果不指定或指定为`-`，则默认从标准输入读取数据。

  

### 常用sed命令

一些常用的 `sed` 命令包括：

- `s/old/new/`：查找并替换，将每行中首次出现的 "old" 替换为 "new"。
  - 这里固定的部分是`s///`,而`old`,`new`分别在第一,二个斜杠和第二,三个斜杠内指定
  - old,new可以是正则表达式,也可是简单的字面量表达式,此时做的是精确匹配

- `d`：删除行，匹配到该命令指定的模式时，删除整行。
- `p`：打印行，可以配合地址或者模式使用，只打印满足条件的行。
- `a\newline`：追加，在匹配行后追加文本。
- `i\newline`：插入，在匹配行前插入文本。

## 常用形式

### 替换

- **替换（substitution）**：`s/pattern/replacement/flags`

  - 替换当前行第一个匹配到的`pattern`为`replacement`

    ```bash
    echo "Hello world" | sed 's/world/Earth/'
    # 输出: Hello Earth
    ```

  - 使用标志`g`进行全局替换：

    ```bash
    echo "Hello world world" | sed 's/world/Earth/g'
    # 输出: Hello Earth Earth
    ```

  - 使用地址范围指定在哪几行进行替换：

    ```bash
    sed '5,10 s/world/Earth/g' inputFile.txt
    ```

- 替换命令`s`是最常用的,配合正则表达式,功能十分强大

### 删除

- **删除（deletion）**：`d`

  - 删除匹配到特定模式的行：

    ```bash
    echo "line1\nline2 more text\nline3" | sed '/line2/d'
    line1
    line3
    ```

### 打印

- **打印（printing）**：`p`

  - 默认情况下`sed`会打印每一行。但如果之前使用了`-n`参数，可以使用`p`

    来选择性打印

    ```bash
    echo "line1\nline2" | sed -n '/line1/p'
    # 输出: line1
    ```

### 插入

- **插入（insertion）**：`i\text`

  - 在匹配行前插入文本：

    ```bash
    sed '/^#.*$/i\This is an inserted line.' inputFile.txt
    ```

  - 上述命令会在所有以 `#` 开头的行前插入文本 "This is an inserted line."。

  - 这里的格式为:`sed '/pattern/i/ContentToInsert' inputFile.txt`   ,也即是说这里的command实际是三段式

### 追加

- **追加（appending）**：`a\text`

  - 在匹配行后追加文本：

    ```bash
    ~ ➤ echo "line1 example\n\line2"|sed "/example/a\New line after example"
    line1 example
    New line after example
    \line2
    ```

### 小结

这只是 `sed` 功能的一小部分，它还有其他丰富的命令和功能，如标签、分支、测试等功能，使得 `sed` 成为一种极其灵活且强大的文本处理工具。

