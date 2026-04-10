[toc]



## reference

本文主要针对gnu sed,而非bsd(macos)的sed.

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

  

### 常用sed命令(sed script)

一些常用的 `sed` 命令包括：

- `s/old/new/`：查找并替换，将每行中首次出现的 "old" 替换为 "new"。
  - 这里固定的部分是`s///`,而`old`,`new`分别在第一,二个斜杠和第二,三个斜杠内指定
  - old,new可以是正则表达式,也可是简单的字面量表达式,此时做的是精确匹配

- `d`：删除行，匹配到该命令指定的模式时，删除整行。
- `p`：打印行，可以配合地址或者模式使用，只打印满足条件的行。
- `a\newline`：追加，在**匹配行后**追加文本。
- `i\newline`：插入，在**匹配行前**插入文本。

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

## 行插入语法

在 `sed` 的手册或文档中，你经常会看到 `i\text`,`a\text` 这种写法。这里的 `\`（反斜杠）其实是一个**续行符/转义符**，它是 POSIX 标准中 `a` (append) 命令的标准语法格式。

### 1. 为什么有一个反斜杠？

在传统的 `sed` 语法中，`a` 命令后面必须紧跟一个反斜杠，然后换行输入你要添加的文本。

**标准格式：**

```bash
sed 'a\
这是要追加的文本' file
```

这个反斜杠告诉 `sed`：**“追加动作开始了，下一行（或反斜杠之后的内容）就是我要插入的字串。”**

------

### 2. 现代用法与差异

随着 `sed` 的演进（尤其是我们常用的 **GNU sed**），语法变得更加宽松了，但在不同环境下会有差异：

#### **在 Linux (GNU sed) 中：**

你可以省略换行，直接连着写，甚至不带反斜杠（只要不产生歧义）：

> 向file文件最后一行后加上'text'字符串

- `sed '$a text' file` —— ✅ 正常工作
- `sed '$a\text' file` —— ✅ 正常工作（手册推荐写法）



------

### 3. 详解 `a\text` 的各个部分

- **`a`**: 代表 Append 指令。
- **`\`**: 标记文本的开始。在多行插入时，它也用来转义行尾，告诉 `sed` 下一行还没完。
- **`text`**: 你想要插入的实际内容。

------

### 4. 示例：插入带有空格或多行的内容

使用 `\` 的好处在于处理复杂格式。例如，你想在第一行后追加两行带缩进的内容：

Bash

```
sed '1a\
    第一行缩进内容\
    第二行缩进内容' test.txt
```

### 总结

当你看到 `a\text` 时，可以简单地把它理解为 **“追加（append）以下内容”**。

- 如果是写**简单的单行脚本**，在 Linux 下你可以直接用 `sed 'a your-text'`。
- 如果是写**跨平台兼容的脚本**（比如要给 Mac 用户用），请务必遵守手册中的 `a\文本` 格式。

### 其他示例

创建一个包含若干行内容的文本文件(test.log),内容如下:

```
# Demo content line for sed test
Line1
Line 2
line 3
abc 123 
end
# done!

```

**插入（insertion）**：`i\text`

- 在**匹配行前(上方一行)**插入文本：

  ```bash
  $ sed '/^#.*$/iThis is an inserted line.' test.log 
  
  This is an inserted line.
  # Demo content line for sed test
  Line1
  Line 2
  line 3
  abc 123 
  end
  This is an inserted line.
  # done!
  ```

- 上述命令会在所有以 `#` 开头的**行前**插入文本 "This is an inserted line."。

- 这里的格式为:`sed '/pattern/i\ContentToInsert' inputFile.txt`   ,也即是说这里的command实际是三段式

**追加（appending）**：`a\text`

`sed '/pattern/a\ContentToAppend' inputFile.txt`

- 在匹配行后(下方一行)追加文本：

  使用echo 打印字符串(包含`\n`,是否使用`-e`输出会有影响;)
  
  ```bash
  # ✔ (base) [macOS 26.4][bash 5.3.9]cxxu@CxxuMac in ~/sh on git:main [22:52:25]
  $  echo -e "line1 example\n\line2"|sed "/example/a\New line after example"
  line1 example
  New line after example
  \line2
  
  # (base) [macOS 26.4][bash 5.3.9]cxxu@CxxuMac in ~/sh on git:main [22:55:35]
  $  echo  "line1 example\n\line2"|sed "/example/a\New line after example"
  line1 example\n\line2
  New line after example
  ```
  
  

---

## 总结表格

### sed 常用选项（Options）

| 选项                        | 描述                                  |
| --------------------------- | ------------------------------------- |
| `-n`, `--quiet`, `--silent` | 禁止默认输出，只输出被处理的行        |
| `-e script`                 | 添加一个编辑脚本（可多个 -e 使用）    |
| `-f script-file`            | 从文件中读取编辑脚本                  |
| `-i[SUFFIX]`                | 就地编辑文件（可加备份后缀）          |
| `-r`, `-E`                  | 启用扩展正则表达式（macOS 上是 `-E`） |
| `-b`                        | 二进制模式（Windows）                 |
| `-u`                        | 非缓冲输出（实时输出）                |

---

###  sed 脚本命令速查表（Script Commands）

| 命令                          | 示例                         | 功能说明                           |
| ----------------------------- | ---------------------------- | ---------------------------------- |
| `s/pattern/replacement/flags` | `s/foo/bar/g`                | 替换匹配的内容（`g`=全局替换）     |
| `d`                           | `/pattern/d`                 | 删除匹配的行                       |
| `p`                           | `/pattern/p`                 | 打印匹配的行（常与 `-n` 搭配）     |
| `i\text`                      | `/pattern/i\ContentToInsert` | 在匹配行**前**插入文本             |
| `a\text`                      | `/pattern/a\ContentToAppend` | 在匹配行**后**追加文本             |
| `c\text`                      | `c\Replace with this line`   | 替换匹配的整行内容                 |
| `y/old/new/`                  | `y/abc/def/`                 | 字符转换（逐字符替换）             |
| `=`                           | `/pattern/=`                 | 打印匹配行的行号                   |
| `q [exit_code]`               | `3q`                         | 退出 `sed`（可指定退出码）         |
| `l`                           | `l`                          | 显示当前模式空间内容（含转义字符） |
| `{...}`                       | `1,5{s/foo/bar/; p}`         | 命令块，组合多个操作               |
| `w filename`                  | `/pattern/w file.txt`        | 将匹配行写入文件                   |
| `r filename`                  | `/pattern/r file.txt`        | 读取文件内容插入到匹配行后         |

---

###  地址范围（Addressing）示例

| 地址形式           | 示例              | 说明                       |
| ------------------ | ----------------- | -------------------------- |
| 单行               | `3s/foo/bar/`     | 第3行执行替换              |
| 行范围             | `10,20d`          | 删除第10到20行             |
| 正则匹配           | `/error/d`        | 删除包含 "error" 的行      |
| 从某行开始直到结尾 | `5,$d`            | 删除第5行到末尾的所有行    |
| 步长               | `1~2p`（需 `-n`） | 打印奇数行（每两行取一行） |

---

##  常见用法示例

```bash
# 替换所有 foo 为 bar（输出到终端）
sed 's/foo/bar/g' input.txt

# 替换并就地保存（带备份）
sed -i.bak 's/foo/bar/g' input.txt

# 删除包含 error 的行
sed '/error/d' input.txt

# 打印匹配行及其下一行
sed -n '/pattern/,+1p' input.txt

# 插入一行在匹配行之前
sed '/target/i\This is a new line' input.txt

# 替换整行内容
sed '/target/c\New content here' input.txt

# 只打印匹配行
sed -n '/success/p' input.txt

# 多个命令一起执行
sed -e 's/foo/bar/' -e '/bar/d' input.txt
```

---

## Notes

- `sed` 默认不修改原文件，除非使用 `-i`。
- 正则表达式中部分特殊字符需要转义 `\`。
- macOS 和 Linux 的 `sed` 有细微差别（如 `-i ''` vs `-i`）。

## 小结

`sed` 的基本命令格式通常为：`sed [选项] '命令' 文件名`

### 常用 sed 操作指令汇总表

| **分类**      | **命令** | **描述**                                                     | **示例**                             |
| ------------- | -------- | ------------------------------------------------------------ | ------------------------------------ |
| **内容替换**  | `s`      | **最常用**。替换匹配到的字符串。灵活使用可在行内插入或修改内容,也可以跨行替换内容; | `s/old/new/g` (全局替换)             |
| **内容插入**  | `i`      | 在匹配行**上方**插入一行。                                   | `1i "Title"` (在首行前插入)          |
| 内容追加      | `a`      | 在匹配行**下方**追加一行。                                   | `/pattern/a "Next"` (在匹配行后加)   |
| **内容删除**  | `d`      | 删除匹配到的行。                                             | `3d` (删除第 3 行); `/^$/d` (删空行) |
| **内容打印**  | `p`      | 打印匹配的行（通常配合 `-n` 使用）。                         | `-n '5p'` (仅打印第 5 行)            |
| **整行修改**  | `c`      | 将匹配到的整行**替换**为新文本。                             | `2c "New Line 2"` (修改第 2 行)      |
| **读取/写入** | `r`      | 从外部文件读取内容并插入到当前行后。                         | `3r other.txt` (在第 3 行后读入)     |
|               | `w`      | 将匹配到的行写入到外部文件。                                 | `/ERROR/w log.txt` (过滤错误到文件)  |
| **控制指令**  | `q`      | 立即退出 `sed`。                                             | `10q` (打印前 10 行后退出，效率高)   |
|               | `n`      | 读取下一行并覆盖当前模式空间（跳行）。                       | `n;d` (删除偶数行)                   |

------

### 必备选项 (Options) 说明

在使用上述命令时，配合以下选项能实现更强大的功能：

- **`-i` (in-place):** **最重要**。直接修改原始文件，而不是只在屏幕上输出预览。
- **`-n` (quiet):** 取消默认输出。只显示你用 `p` 命令明确指定的行。
- **`-r` 或 `-E` (extended-regexp):** 支持扩展正则表达式（比如 `+`, `?`, `|` 等，不需要加反斜杠转义）。
- **`-e` (expression):** 允许在一条指令中执行多个 `sed` 动作。
- **`-s` (separate):** 将多个输入文件视为独立文件（重置行号），即你最初提到的功能。

------

### 快速记忆技巧

- **i** = **i**nsert (在上面插)
- **a** = **a**ppend (在下面加)
- **s** = **s**ubstitute (改局部)
- **c** = **c**hange (改整行)
- **d** = **d**elete (删除)

