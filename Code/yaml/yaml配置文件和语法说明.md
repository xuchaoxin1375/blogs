[toc]



## abstract

官网

[The Official YAML Web Site](https://yaml.org/)

语法

[YAML Ain’t Markup Language (YAML™) revision 1.2.2](https://yaml.org/spec/1.2.2/)

> 完整的语法规范具有相当的篇幅,但是对于大多数应用,仅需要了解其中的一部分

简单语法参考(这份说明本身就是yaml语言写的)

[YAML 参考卡](https://yaml.org/refcard.html)

简明教程

[YAML 入门教程 | 菜鸟教程](https://www.runoob.com/w3cnote/yaml-intro.html)

百科

[YAML ---- YAML - Wikipedia](https://en.wikipedia.org/wiki/YAML)

### 工具

- 检查yaml语法问题:
  - 权威检查:[YAMLlint - The YAML Validator](https://www.yamllint.com/)
  - [learn-yaml - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=docsmsft.docs-yaml)
- 在线转换:(yaml-json双向转换)
  - 自动转换,更推荐[JSON to YAML Online Converter](https://www.bairesdev.com/tools/json2yaml/)
  - 手动点击[在线YAML转JSON](https://www.lddgo.net/convert/yaml-to-json)
- 本地转换:
  - yaml转json[YAML ❤️ JSON - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=hilleer.yaml-plus-json)
  - linux系统上有yamlint

### 概述

**YAML** （ [/ˈjæməl/] ）是一种人类可读的数据序列化语言 。

它常用于**配置文件**以及需要**存储或传输数据**的应用程序。YAML 的目标应用与可扩展标记语言 (XML) 类似，但其语法更为简洁，有意与标准通用标记语言 (SGML) 有所区别

它使用类似 Python 的缩进来表示嵌套，并且**大多数字符串值不需要引号**（它也**支持在同一文件中混合使用 JSON** 风格的 `[...]` 和 `{...}` ）。(**yaml被认为是json的超集**)

YAML 允许自定义**数据类型**，但它原生支持:

1. 标量（例如字符串、整数和浮点数）
2. 列表
3. 关联数组（也称为**映射、字典或哈希映射**,类似于json中的**对象**,结构嵌套主要体现在关联数组上）

这些数据类型基于 Perl 编程语言，尽管所有常用的高级编程语言都共享非常相似的概念。PHP语言中有类似名称的**关联数组（Associative Array）**

yaml文档的主体部分是一系列键值对(`key: value`),类比json中的概念,可以称为属性(包含`key,value`连个部分)

> 虽然value也可以单独出现,但是这种用法少见,主要以键值对的形式出现

用于表示键值对的**冒号中心语法**借鉴了 RFC 822 中定义的电子邮件标头，而**文档分隔符 ---** 则借鉴自 MIME（RFC 2046）。

转义序列重用自 C 语言，多行字符串的空格换行则借鉴自 HTML。

列表和哈希可以包含嵌套的列表和哈希，从而形成**树状结构**；

可以使用 YAML 别名（类似于 SOAP 中的 XML）表示任意图。

YAML 旨在以流的方式进行读写，这一特性受到了 SAX 的启发。

### 数据处理与表示

YAML 规范将*实例文档*定义为“表示”（Presentation）或“字符流”（character stream）。

YAML 实例文档中的主要逻辑结构是**标量(scalar)、序列(sequence)和映射(map)**。YAML 规范还指出了一些适用于这些主要逻辑结构的基本约束。

> 例如，根据规范，**映射键没有顺序**。在任何**节点顺序重要的情况下，都必须使用序列**。  

此外，在定义 YAML 处理器的一致性时，YAML 规范定义了两个主要操作： *dump* 和 *load* 。所有符合 YAML 规范的处理器必须*至少*提供其中一个操作，并且可以选择性地同时提供这两个操作。

### yaml vs json

大多数 JSON 文档都可以被一些 YAML 解析器（例如 Syck）解析。因为 JSON 的语义结构等同于 YAML 的可选“内联式”编写方式。

> 虽然扩展的层级结构可以像 JSON 一样用内联式编写，但除非有助于提高清晰度，否则不建议使用这种 YAML 编写方式。

YAML 具有 JSON 所不具备的许多附加功能，包括注释、可扩展的数据类型、关系锚点、不带引号的字符串以及保留键顺序的映射类型。

由于 JSON 格式简洁 ， 其序列化和反序列化速度比 YAML 快得多。

## yaml基本结构

YAML（YAML Ain’t Markup Language）文档的**基本结构**基于**缩进**和**键值对**，具有清晰的层次关系，易于人类阅读和编写。

其核心由三种原生数据类型构成：**标量（Scalar）**、**列表（Sequence）** 和 **映射（Mapping）**。

yaml文档的主体是一系列**键值对**,而键值对中的关键是**值**(`key: value`中的`value`部分)

相比于json,yaml中允许的`key`的形式更多样,而`value`更是各种各样的,不仅在于value的类型,也在于其可以借助缩进可以表示嵌套,让其可以表示复杂的信息(哪怕只用yaml的三种基础原生类型scalar,sequence,mapping都可以表示出复杂的结构),具有比json更强大和简洁的表示能力,信息密度更大,另一方面,规范要求也更多)

---

### 1. 文档起始与结束（可选）

- 可用 `---` 表示文档开始（尤其在多文档文件中）。
- 可用 `...` 表示文档结束（通常省略）。

```yaml
---
# 这是一个 YAML 文档
name: MyApp
version: 1.0
...
```

> 单文档场景下，`---` 和 `...` 通常省略。

---

### 2. 缩进表示层级

- 使用**空格**（不能用 Tab）表示嵌套层级。
- 同一级别的元素必须对齐。
- 缩进数量无硬性规定，但需保持一致。

✅ 正确：

```yaml
server:
  host: localhost
  port: 8080
```

❌ 错误（混用 Tab 或不对齐）：

```yaml
server:
	host: localhost  # Tab 导致解析错误
  port: 8080
```

---

### 3. 键值对（映射 / Mapping）

- 格式：`key: value`
- 冒号后**必须跟一个空格**

```yaml
database:
  name: mydb
  user: admin
  password: secret
```

---

### 4. 列表（Sequence）

- 每个列表项以 `-` 开头，后跟空格
- 列表可包含标量、映射或其他列表

```yaml
services:
  - web
  - db
  - cache

environments:
  - name: dev
    url: http://dev.example.com
  - name: prod
    url: https://example.com
```

---

### 5. 标量（Scalar）

- 包括字符串、数字、布尔值、null 等
- 字符串通常无需引号，但特殊字符或保留字建议加引号

```yaml
count: 42
price: 19.99
enabled: true
description: "This is a multi-word string."
path: /usr/local/bin  # 路径无需引号
```

> 注意：`yes`、`no`、`on`、`off` 等在某些 YAML 解析器中可能被解释为布尔值，建议用引号避免歧义。

---

### 6. 多行字符串（可选高级结构）

- 使用 `|`（保留换行）或 `>`（折叠换行）

```yaml
message: |
  Line 1
  Line 2
  Line 3

summary: >
  This is a long sentence
  that will be folded into
  a single line.
```



---

### 关键规则总结：

| 规则           | 说明                          |
| -------------- | ----------------------------- |
| **缩进**       | 必须用空格，不能用 Tab        |
| **冒号后空格** | `key: value` ✅，`key:value` ❌ |
| **对齐**       | 同级元素必须左对齐            |
| **大小写敏感** | `Name` 和 `name` 是不同键     |
| **注释**       | 用 `#` 开头                   |

这种简洁、层级清晰的结构使 YAML 成为配置文件（如 Docker Compose、Kubernetes、Ansible）的首选格式。

## 三种原生数据类型

在 YAML（YAML Ain’t Markup Language）中，有**三种原生数据类型**，它们构成了所有 YAML 文档的基础结构。以下是它们的定义和常用模板示例：

---

### 1. 标量（Scalar）

**定义**：  
标量是最基本的数据类型，表示单个不可再分的值，如字符串、整数、浮点数、布尔值、null 等。

**模板示例**：

```yaml
# 字符串（可带引号或不带）
name: Alice
description: "A simple string"
path: /home/user

# 整数
age: 30

# 浮点数
price: 19.99

# 布尔值
active: true

# null（可用 null、~ 或留空）
value: null
empty:
```

> 注意：YAML 会自动推断类型（如 `30` 是整数，`19.99` 是浮点数），但可通过引号强制为字符串（如 `"30"`）。

---

### 2. 列表（Sequence / List）

**定义**：  
列表是有序的值集合，每个元素可以是标量、嵌套列表或映射。

**模板示例**（两种写法）：

**块格式（推荐）**：

```yaml
fruits:
  - apple
  - banana
  - orange

ports:
  - 80
  - 443
  - 8080
```

**流格式（内联）**：

```yaml
fruits: [apple, banana, orange]
ports: [80, 443, 8080]
```

> 列表项用 `-` 开头（块格式）或用方括号包裹（流格式）。



---

### 3. 关联数组（Mapping / Dictionary / Hash Map）

**定义**：  
关联数组是由**键值对组成的无序集合**，键通常是字符串，值可以是任意 YAML 类型（标量、列表、嵌套映射等）。

**模板示例**：

**块格式（常用）**：

```yaml
person:
  name: Bob
  age: 25
  hobbies:
    - reading
    - coding
  address:
    city: Shanghai
    country: China
```

这里`person`是键,而值是一个**关联数组**,并且这个关联数组具有4个键值对,前两个是简单键值对,第三个键的值是列表类型,而第4个键值对的值又是一个关联数组,其具有两个简单键值对

**流格式（内联）**：

```yaml
person: {name: Bob, age: 25}
```

> 键与值之间用冒号加空格（`key: value`）分隔，缩进表示嵌套层级。

---

### 映射结点(mapping node)

在 YAML 抽象语法树（AST）中：

- **映射节点（mapping node）** 就是我们通常写的 `key: value` 结构。

它可以是：

- 一个普通映射：`{ name: Alice, age: 30 }`
- 一个带锚点（`&`）的映射：`defaults: &defaults { theme: dark, lang: en }`
- 一个通过别名（`*`）引用的映射：`*defaults`

> ✅ 所以，“映射节点” = 任意一个 YAML 映射（字典），无论它是字面量、锚点定义，还是别名引用。

---



### 补充说明

键值对单独出现可以视为特殊的关联数组

键值对也可以作为列表的元素

```yaml
More types:
  '!!set' : { cherries, plums, apples }
  '!!omap': [ one: 1, two: 2 ]
```

```json
{
    "More types": {
        "!!set": {
            "cherries": null,
            "plums": null,
            "apples": null
        },
        "!!omap": [
            {
                "one": 1
            },
            {
                "two": 2
            }
        ]
    }
}
```

### 综合示例（三种类型混合）：

```yaml
app:
  name: MyApp
  version: 1.2.3
  enabled: true
  ports: [8080, 8443]
  databases:
    - name: users
      host: localhost
      port: 3306
    - name: logs
      host: db.example.com
      port: 5432
```

此结构展示了：

- 标量：`MyApp`, `1.2.3`, `true`
- 列表：`ports` 和 `databases`
- 映射：`app`、每个数据库项

 

## 基础语法

YAML 接受除某些控制字符外的整个 Unicode 字符集，并且可以采用 UTF-8、UTF-16 或 UTF-32 中的任何一种进行编码。（虽然 UTF-32 不是强制性的，**但解析器要兼容 JSON 则需要使用 UTF-32**。）

- 空格缩进用于表示结构；但是，**缩进中不允许使用制表符**。

- 注释以井号`#`开头，可以从一行中的任何位置开始，一直持续到行尾。注释必须与其他标记之间用空格字符分隔。如果 # 字符出现在字符串内部，则它们是井号（#）字面量。(这类似于大多数高级编程语言中的注释,尤其和shell语言中的注释用法类似)

- 列表成员以连字符（`-`）开头，每行一个成员。

  - 也可以用方括号（`[...]`）括起文本，并用逗号分隔每个条目来指定列表。

- 关联数组的元素用**冒号加空格**(`: `)表示，格式为“`key: value`”，**每行一个元素**。

  - YAML 要求冒号后必须跟一个空格，这样像 `http://www.wikipedia.org` 这样的 URL 式字符串就可以直接表示，而无需用引号括起来。

  - 可以**在键前面使用问号**`?`(`?`不需要追加空格)，形式为`?key: value`，以允许**键**包含前导破折号、方括号等，而**无需引号**。

    ```yaml
    # demo yaml
    ---
    key1: value1
    ?host:port: 127.0.0.1:8080
    ?[::1]:443: 127.0.0.1:443
    ```

    可以被转换为

    ```JSON
    {
      "key1": "value1",
      "?host:port": "127.0.0.1:8080",
      "?[::1]:443": "127.0.0.1:443"
    }
    ```

  - 也可以用花括号（`{...}`）括起来的文本指定关联数组，键和值之间用冒号分隔，**条目之间用逗号分隔**（不需要空格以保持与 JSON 的兼容性）。

- **字符串**（YAML 中的一种标量）**通常不加引号**，但可以用双引号（"）或单引号（'）括起来。

  - 在双引号内，特殊字符可以用以反斜杠（\）开头的 **C 风格转义序列表示**。根据文档，唯一支持的八进制转义序列是 \0。
  - 在单引号内，唯一支持的转义序列是双单引号（''），表示单引号本身，如 `'don''t'`。

- **块标量**用**缩进**分隔，并可选择使用**修饰符**(两种:`|`,和`>`):

  - 使用`|`保留换行符
  - 使用`>`折叠换行符

- 单个流中的**多个文档**用三个连字符（`---`）分隔。

  - 三个句点（`...`）可以用于**结束流中的文档**。

- **重复节点**最初用 & 符号表示，之后用星号 * 表示。

- 可以使用双感叹号（!!）后跟字符串来**标记节点的类型或标签**，该字符串可以**展开为 URI**。

- 流中的 YAML 文档可以以“指令”开头，指令由百分号（`%`）后跟名称和**空格分隔的参数**组成。YAML 1.1 中定义了两个指令：

  - `%YAML` 指令用于标识给定文档中的 **YAML 版本**。
  - `%TAG` 指令用作 **URI 前缀的简写**形式。这些简写形式**随后可用于节点类型标签中**。(相对少用,本文不展开)

### 重点

- 字符串不需要用引号括起来。
- 缩进的空格数量并不重要，只要并列元素左对齐方式相同，并且层级嵌套的元素进一步缩进即可。

### 基本组件

传统的块格式使用**连字符+空格**(`- <item>`来开始**列表**中的新项目。

简单列表(例子使用`---`表示开始,这行是可选的)

```yaml
--- # Favorite movies
- Casablanca
- North by Northwest
- The Man Who Wasn't There
```

对应的json

```json
[
    "Casablanca",
    "North by Northwest",
    "The Man Who Wasn't There"
]
```

可选的内联格式以逗号+空格分隔，并用方括号括起来（类似于 [JSON](https://en.wikipedia.org/wiki/JavaScript_Object_Notation) ）。  

```yaml
--- # Shopping list
[milk, pumpkin pie, eggs, juice]
```

键和值之间用**冒号加空格**(`key: value`)分隔。

- YAML 数据文件中常见的**缩进块**使用**缩进和换行**来分隔键值对。
- YAML 数据流中常见的**行内块**使用**逗号加空格**来分隔花括号内的键值对。

```yaml
--- # Indented Block
  name: John Smith
  age: 33

```

```yaml
--- # Inline Block
{name: John Smith, age: 33}
```

### 特殊键

```yaml
Special keys:
  '='  : Default "value" mapping key.
  '<<' : Merge keys from another mapping.
```

其中`=`并不广泛使用

`<<`则是标准的一部分,用来合并引用的结点,详情另外章节(合并到当前位置)

### 多行字符串🎈

通常,字符串不需要引号包裹。

有两种方法可以编写**多行字符串**，一种保留换行符（使用 `|` 字符），另一种折叠换行符（使用 `>` 字符），**两种方法后都必须跟一个换行符**。

```yaml
data: |
   There once was a tall man from Ealing
   Who got on a bus to Darjeeling
       It said on the door
       "Please don't sit on the floor"
   So he carefully sat on the ceiling
```

默认情况下，首行缩进和行尾空格将被删除，但也可以明确指定其他行为。

```yaml
data: >
   Wrapped text
   will be folded
   into a single
   paragraph

   Blank lines denote
   paragraph breaks
```

折叠文本会将换行符转换为空格，并删除前导空白。



#### 保留换行和折叠换行

```yaml
# 块标量：保留换行（|）
preserved_block: |
  这是一段
  保留原始换行的文本。
  
  每行结尾的换行符都会被保留。

# 块标量：折叠换行（>）
folded_block: >
  这是一段折叠文本。
  连续的换行会被合并为单个空格，
  
  但每个空行会变成1个换行符。
```

转换为json

```json
{
    "preserved_block": "这是一段\n保留原始换行的文本。\n\n每行结尾的换行符都会被保留。\n",
    "folded_block": "这是一段折叠文本。 连续的换行会被合并为单个空格，\n但空行会变成换行。\n"
}
```

在 YAML 中，`|`（保留换行）和 `>`（折叠换行）是**块标量修饰符（block scalar indicators）**，用于定义多行字符串（块标量），并控制换行符的处理方式。它们让 YAML 能优雅地嵌入大段文本（如配置、日志、脚本等），同时保持格式清晰。

---

一、基本语法

```yaml
保留换行: |
  第一行
  第二行
  第三行

折叠换行: >
  第一行
  第二行
  第三行
```

两者都要求**内容缩进**（缩进必须一致，且比键多），缩进部分会被自动剥离。

---

二、`|` — 保留换行（Literal Block Scalar）

- **保留所有换行符**（`\n`）；
- **不折叠空行**；
- **尾部换行默认保留**（可通过修饰符控制）。

示例

```yaml
text: |
  Hello
  World
  !
```

**解析结果（字符串）**：

```
Hello\nWorld\n!\n
```

> 注意：末尾有一个换行（因为最后一行后有换行）。

修饰符（Chomping Indicators）

可与 `|` 组合使用，控制**尾部换行**：

| 修饰符 | 含义                                                 |
| ------ | ---------------------------------------------------- |
| `|-`   | **去除尾部换行**（strip）                            |
| `|+`   | **保留尾部换行**（keep，即使原文没有也会加一个）     |
| `|`    | **默认行为**（clip）：保留原文尾部换行，但不额外添加 |

示例对比

```yaml
default: |
  Line1
  Line2

stripped: |-
  Line1
  Line2

kept: |+
  Line1
  Line2
```

**解析结果**：

- `default`: `"Line1\nLine2\n"`（末尾有换行）
- `stripped`: `"Line1\nLine2"`（无末尾换行）
- `kept`: `"Line1\nLine2\n"`（即使原文没换行也会加，但此处原文有，所以同 default）

> 💡 若最后一行后**没有换行**（如文件末尾紧贴内容），`|` 仍会保留内容内部换行，但末尾无 `\n`；`|+` 则会强制加一个。

---

三、`>` — 折叠换行（Folded Block Scalar）

理解为换行符数量-1,但是减为0时补偿1个空格

- **将连续的行折叠为空格**；
- **空行（即两个 `\n\n`）会被转换为一个换行符 `\n`**；
- 适用于“段落式”文本。

示例

```yaml
text: >
  This is line one.
  This is line two.

  This is a new paragraph.
```

**解析结果**：

```
This is line one. This is line two.\nThis is a new paragraph.\n
```

> - 前两行合并为一行（换行变空格）；
> - 每个空行变成一个 `\n`，形成段落分隔；
> - 末尾仍有一个换行（默认 clip 行为）。

修饰符同样适用

```yaml
folded_stripped: >-
  Line1
  Line2

  Line3
```

**结果**：`"Line1 Line2\nLine3"`（无末尾换行）

---

四、缩进处理规则

- 块标量内容必须**整体缩进**（比键多）；
- 解析器会自动**剥离公共前导空格**；
- 但**不能使用制表符**（YAML 禁止在缩进中使用 tab）。

示例

```yaml
script: |
    echo "Hello"
    echo "World"
```

解析为：

```bash
echo "Hello"\necho "World"\n
```

> 每行前的 4 个空格被保留（因为它们是内容的一部分，不是“公共缩进”）。

> ✅ **关键**：YAML 以**最小缩进行**为基准，剥离所有行的公共前缀空格。

---

五、典型使用场景

| 场景                      | 推荐修饰符                  |
| ------------------------- | --------------------------- |
| Shell 脚本、SQL、配置文件 | `|`（保留原始格式）         |
| 多段说明文本、文档描述    | `>`（自动段落折叠）         |
| 需要精确控制尾部换行      | `|-` 或 `|+` / `>-` 或 `>+` |

实际案例

```yaml
# Shell 脚本（必须保留换行和缩进）
init_script: |-
  #!/bin/bash
  echo "Starting..."
  systemctl restart nginx

# 用户说明（自然语言段落）
description: >
  This tool processes log files.
  It supports multiple formats.

  Output is written to /tmp/results.
```

---

六、常见误区

1. **误以为 `>` 会完全删除换行**  
   → 实际上：**单换行变空格，双换行变单换行**。

2. **混合使用 tab 和空格缩进行**  
   → YAML 会报错（缩进必须全为空格）。

3. **忘记内容必须缩进**  

   ```yaml
   bad: |
   not indented  # ❌ 错误！必须缩进
   ```

---

#### 文本修饰符总结表

| 修饰符 | 换行处理                       | 空行处理     | 尾部换行控制              | 适用场景         |
| ------ | ------------------------------ | ------------ | ------------------------- | ---------------- |
| `|`    | 保留所有 `\n`                  | 保留         | 默认保留（clip）          | 代码、日志、配置 |
| `|-`   | 保留所有 `\n`                  | 保留         | **去除**尾部换行          | 精确字符串       |
| `|+`   | 保留所有 `\n`                  | 保留         | **强制保留/添加**尾部换行 | 需要末尾换行     |
| `>`    | 单换行 → 空格<br>双换行 → `\n` | 转为段落分隔 | 默认保留（clip）          | 文档、说明文本   |
| `>-`   | 同上                           | 同上         | **去除**尾部换行          | 段落文本无尾换行 |

掌握 `|` 和 `>` 能让你写出更清晰、更专业的 YAML 配置。

### 复杂文本表示

例如带有`:`和`"`的混合串

```yaml
k2: 
   k20: "s1 s2\" s3: sf"
   k21: 's1 s2" s3: sf'
   k22: | #或者>号修饰符
    s1 s2" s3: sf

```

使用第三种是最简洁的,不需要考虑引号包裹和转义

json

```json
{
    "k2": {
        "k20": "s1 s2\" s3: sf",
        "k21": "s1 s2\" s3: sf",
        "k22": "s1 s2\" s3: sf\n"
    }
}
```



### 对象和列表的混合写法



```yaml
--- # The Smiths
- {name: John Smith, age: 33}
- name: Mary Smith
  age: 27
- [name, age]: [Rae Smith, 4]   # sequences as keys are supported

```

```json
[
    {
        "name": "John Smith",
        "age": 33
    },
    {
        "name": "Mary Smith",
        "age": 27
    },
    {
        "name,age": [
            "Rae Smith",
            4
        ]
    }
]
```

对于`[name, age]: [Rae Smith, 4]`这种写法,yaml支持将序列作为键值对中的键,例如这里的序列`[name, age]`



```yaml
--- # People, by gender
men: [John Smith, Bill Jones]
women:
  - Mary Smith
  - Susan Williams
```

```json
{
    "men": [
        "John Smith",
        "Bill Jones"
    ],
    "women": [
        "Mary Smith",
        "Susan Williams"
    ]
}
```

**对象和列表**是 YAML 的重要组成部分，可以混合使用。

第一个例子是一个键值对列表，列出了史密斯家族的所有成员。第二个例子按性别列出了他们；它是一个包含两个列表的键值对。

### 多层嵌套

```yaml
l1:
  l1-1: a
  l1-2:
    l2:
      l3: b

```

对应json

```json
{
    "l1": {
        "l1-1": "a",
        "l1-2": {
            "l2": {
                "l3": "b"
            }
        }
    }
}
```

```yaml
L1: 
 L1-1: a
 L1-2: 
  L2: 
   L3: 
    - a
    - b
    - c: 
      k1: v1
      k2: v2
  
```

json

```json
{
    "L1": {
        "L1-1": "a",
        "L1-2": {
            "L2": {
                "L3": [
                    "a",
                    "b",
                    {
                        "c": null,
                        "k1": "v1",
                        "k2": "v2"
                    }
                ]
            }
        }
    }
}
```

另一种借助(`&`,`*`)的嵌套写法

```yaml
B: &B
 k1: v1
 k2: v2
A: *B
```

对应的json

```json
{
    "B": {
        "k1": "v1",
        "k2": "v2"
    },
    "A": {
        "k1": "v1",
        "k2": "v2"
    }
}
```



### 利用json-yaml转换工具学习yaml

虽然json更加冗长,但是json规则更加简单清晰,如果某些结构你清楚用json表示,那么通过yaml转换器,可以将其转换为yaml,并且排版美观,然后和自己写的yaml进行对比



### 嵌套错误案例

一个完整的键值对后面不能直接跟缩进量更多的其他键值对,这在含义上是不清楚也是不合理的(但是两个完整的且缩进量相同的键值对是可以连续出现的,这时候表明两个键值对都是同一个关联数组中的属性,)

如果要定义某个key(比如`A`的值为一个对象,那么标准写法是`A: `换行,然后用适当数量的空格对齐缩进作为值的对象中的各个内部键值对)

```yaml
A: a
 k1: v1
 k2: v2
```

上面的`a`是多余的,将引发错误



## 高级组件

YAML 与其他**数据序列化语言**的功能区别在于结构 、数据键和复合键。

YAML 结构允许在**单个文件中存储多个文档**，允许**对重复节点使用引用**，并**允许使用任意节点作为键**。

### 结点的引用🎈

为了清晰、简洁并避免数据输入错误，YAML 提供了节点锚点（使用 `&` ）和引用（使用 `*` ）。

对锚点的引用**适用于所有数据类型**（请参见以下示例中的收货地址引用）。

下面是一个乐器音序器中的队列示例，其中引用了两个步骤但没有完全描述。

```yaml
--- # Sequencer protocols for Laser eye surgery
- step:  &id001                  # defines anchor label &id001
    instrument:      Lasik 2000
    pulseEnergy:     5.4
    pulseDuration:   12
    repetition:      1000
    spotSize:        1mm

- step: &id002
    instrument:      Lasik 2000
    pulseEnergy:     5.0
    pulseDuration:   10
    repetition:      500
    spotSize:        2mm
- Instrument1: *id001   # refers to the first step (with anchor &id001)
- Instrument2: *id002   # refers to the second step
```

```json
[
    {
        "step": {
            "instrument": "Lasik 2000",
            "pulseEnergy": 5.4,
            "pulseDuration": 12,
            "repetition": 1000,
            "spotSize": "1mm"
        }
    },
    {
        "step": {
            "instrument": "Lasik 2000",
            "pulseEnergy": 5,
            "pulseDuration": 10,
            "repetition": 500,
            "spotSize": "2mm"
        }
    },
    {
        "Instrument1": {
            "instrument": "Lasik 2000",
            "pulseEnergy": 5.4,
            "pulseDuration": 12,
            "repetition": 1000,
            "spotSize": "1mm"
        }
    },
    {
        "Instrument2": {
            "instrument": "Lasik 2000",
            "pulseEnergy": 5,
            "pulseDuration": 10,
            "repetition": 500,
            "spotSize": "2mm"
        }
    }
]
```

### 结点复用

这里涉及到3个符号,实现复用定义好的内容

`&`建立锚点和 `*` 引用锚点,`<<`表示**合并**到当前数据(`<<`是一个特殊的键)

以下两个例子是典型的用法

```yaml
defaults: &defaults
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development #定义当前属性的一个子属性
  <<: *defaults #把defaults属性定义的两个下级属性提取并合并到当前位置

test: *defaults # 直接引用定义在defaults中的子属性
```

对应json

```json
{
    "defaults": {
        "adapter": "postgres",
        "host": "localhost"
    },
    "development": {
        "database": "myapp_development",
        "adapter": "postgres",
        "host": "localhost"
    },
    "test": {
        "adapter": "postgres",
        "host": "localhost"
    }
}
```

又比如简单引用(不需要使用合并标记`<<`)

```yaml
- &showell This is a very long string...end.
- Clark 
- Brian 
- Oren 
- *showell 
```

json

```json
[
    "This is a very long string...end.",
    "Clark",
    "Brian",
    "Oren",
    "This is a very long string...end."
]
```

#### 关于合并(merge)

Specify one or more mappings to be merged with the current one.
指定一个或多个要与当前映射合并的映射。

The “**`<<`**” merge key is used to indicate that all the keys of one or more specified maps should be inserted into the current map. 

- If the value associated with the key is **a single mapping node**, each of its key/value pairs is inserted into the current mapping, unless the key already exists in it.
- If the value associated with the merge key is a **sequence**, then this sequence is expected to contain mapping nodes and each of these nodes is merged in turn according to its order in the sequence.

 Keys in mapping nodes **earlier** in the sequence **override** keys specified in later mapping nodes.

“ **`<<`** ”**合并键**是 用于指示**一个或多个指定映射的所有键** 应将其插入到**当前映射**中。

```yaml
# 情况1(单个映射结点)
<<: *anchor
# 情况2(位于序列中)
<<: [*anchor1, *anchor2, ...]
```



- 如果与该键相关联的值是一个单个映射节点(map类型的值)，则其中每个键/值对都会插入到**当前映射**中，除非该键已经存在于其中。
- 如果与合并键相关联的值是一个序列，则期望该序列包含映射节点，并且根据它们在序列中的顺序依次合并这些节点。**序列中较早的映射节点中的键会覆盖后面映射节点中指定的键**。

 合并键 `<<` 的两种用法

#### 情况 1：`<<` 的值是 单个映射节点

```yaml
base: &base
  color: blue
  size: large

item:
  <<: *base      # ← 这里 *base 是一个映射节点
  name: widget
```

**行为**：

- 将 `*base` 中的所有键值对（`color`, `size`）**插入到 `item` 中**；
- 如果 `item` 已有同名键（如 `color: red`），则**保留 `item` 中的值**（不覆盖）。

✅ 结果等价于：

```yaml
item:
  name: widget
  color: blue
  size: large
```

---

#### 情况 2：`<<` 的值是映射节点的序列（列表）

```yaml
theme: &theme
  color: green
  font: sans

layout: &layout
  color: red    # 注意：和 theme 有冲突
  margin: 10px


component:
  <<: [*theme, *layout]   # ← 这是一个包含两个映射节点的序列
  name: button
```



#### 用法列举

```yaml
merge:

  - &CENTER { x: 1, y: 2 }
  - &LEFT { x: 0, y: 2 }
  - &BIG { r: 10 }
  - &SMALL { r: 1 }

  # All the following maps are equal:

  - # Explicit keys
    x: 1
    y: 2
    r: 10
    label: nothing

  - # Merge one map
    << : *CENTER
    r: 10
    label: center

  - # Merge multiple maps
    << : [ *CENTER, *BIG ]
    label: center/big

  - # Override
    << : [ *BIG, *LEFT, *SMALL ]
    x: 1
    label: big/left/small
```

json

```json
{
    "merge": [
        {
            "x": 1,
            "y": 2
        },
        {
            "x": 0,
            "y": 2
        },
        {
            "r": 10
        },
        {
            "r": 1
        },
        {
            "x": 1,
            "y": 2,
            "r": 10,
            "label": "nothing"
        },
        {
            "x": 1,
            "y": 2,
            "r": 10,
            "label": "center"
        },
        {
            "x": 1,
            "y": 2,
            "r": 10,
            "label": "center/big"
        },
        {
            "r": 10,
            "x": 1,
            "y": 2,
            "label": "big/left/small"
        }
    ]
}
```



### 数据类型

由于 YAML 会自动检测简单类型，因此**大多数 YAML 文档中很少出现显式数据类型**。

数据类型可以分为三类：**核心类型、已定义类型和用户定义类型**。

- 核心类型是指任何解析器都应包含的类型（例如浮点数、整数、字符串、列表、映射等）。
- YAML 规范中定义了许多更高级的数据类型，例如二进制数据，但并非所有实现都支持这些类型。
- 最后，YAML 还定义了一种在**局部范围内扩展数据类型定义**的方法，以支持用户定义的类、结构或基本类型（例如四精度浮点数）。

#### 显式定义数据类型(!!)

YAML 会自动检测实体的数据类型，但有时需要**显式地转换数据类型**。最常见的情况是，当一个**单字字符串**看可能起来像数字、布尔值或标签时，需要用**引号将其括起来**或使用**显式的数据类型标签**来消除歧义(明确其为字符串)。

其中显式数据类型通常使用前缀`!!Type`的结构声明

```yaml
---
a: 123                     # an integer
b: "123"                   # a string, disambiguated by quotes
c: 123.0                   # a float
d: !!float 123             # also a float via explicit data type prefixed by (!!)
e: !!str 123               # a string, disambiguated by explicit type
f: !!str Yes               # a string via explicit type
g: Yes                     # a Boolean True (yaml1.1), string "Yes" (yaml1.2)
h: Yes we have No bananas  # a string, "Yes" and "No" disambiguated by context.
```

并非所有 YAML 实现都包含规范定义的所有数据类型。这些**内置类型**使用双[感叹号](https://en.wikipedia.org/wiki/Sigil_(computer_programming))前缀（ `!!` ）。

一些**特别值**得关注但此处未展示的类型包括集合、有序映射、时间戳和十六进制。

以下是一个 [base64](https://en.wikipedia.org/wiki/Base64) 编码的二进制数据示例。

```yaml
---
picture: !!binary |
  R0lGODdhDQAIAIAAAAAAANn
  Z2SwAAAAADQAIAAACF4SDGQ
  ar3xxbJ9p0qa7R0YxwzaFME
  1IAADs=
```

#### 自定义数据类型(!)

许多 YAML 实现都支持用户自定义的数据类型进行对象序列化。

本地数据类型并非通用数据类型，而是在应用程序中使用 YAML 解析器库定义的。

本地数据类型使用单个感叹号 ( `!` )。

### 复杂键

YAML 支持**复合键**，复合键由多个值组成。

> 这种键对于坐标变换、多字段标识符、带有复合条件的测试用例等非常有用。

```yaml
--- # Transform between two systems of coordinates
  transform:
      {x: 1, y: 2}: {x: 3, y: 4}
      {x: 5, y: 6}: {x: 7, y: 8}
```

这里关联数组充当键



较为复杂的对象格式，可以使用**问号加一个空格**代表定义一个复杂的 key，配合一个冒号加一个空格代表一个 value：

```yaml
?  
    - complexkey1
    - complexkey2
:
    - complexvalue1
    - complexvalue2
```

意思即对象的属性是一个数组 `[complexkey1,complexkey2]`，对应的值也是一个数组 `[complexvalue1,complexvalue2]`

对应的json

```json
{
    "complexkey1,complexkey2": [
        "complexvalue1",
        "complexvalue2"
    ]
}
```



YAML 规范定义了一组**内置（原生）类型标签（implicit tags）**，用于在解析时明确或隐式地指定节点的数据类型。这些标签以 `!!` 为前缀，表示“YAML 原生标签”（canonical tags）。以下是 YAML 1.2（以及广泛兼容的 1.1）中主要的内置类型标签：

---

## yaml核心内置类型标签🎈

```yaml
Core types: # Default automatic tags.
  '!!map' : { Hash table, dictionary, mapping }
  '!!seq' : { List, array, tuple, vector, sequence }
  '!!str' : Unicode string
More types:
  '!!set' : { cherries, plums, apples }
  '!!omap': [ one: 1, two: 2 ]
```



| 标签      | 对应数据类型                                                 | 示例                                                         |
| --------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `!!null`  | 空值（null）                                                 | `empty: !!null null` 或 `empty:`                             |
| `!!bool`  | 布尔值                                                       | `flag: !!bool true`                                          |
| `!!int`   | 整数                                                         | `count: !!int 42`                                            |
| `!!float` | 浮点数                                                       | `ratio: !!float 3.14`                                        |
| `!!str`   | 字符串                                                       | `name: !!str "hello"`                                        |
| `!!seq`   | 序列（列表/数组）                                            | `list: !!seq [1, 2, 3]`                                      |
| `!!map`   | 映射（字典/哈希表）                                          | `dict: !!map {a: 1, b: 2}`                                   |
| `!!set`   | 集合（特殊无序不重复键值对序列),如果是block-style,可以用`? value`格式定义每一行 | `baseball teams: !!set { Boston Red Sox, Detroit Tigers, New York Yankees }` |
| `!!omap`  | 有序映射(order map)                                          | `Numbers: !!omap [ one: 1, two: 2, three : 3 ]`              |
| `!!pairs` | 是 YAML 中用于表示**可重复键、保序的键值对序列**的高级类型。 | `!!pairs [ meeting: with team, meeting: with boss ]`         |

> 💡 在大多数情况下，YAML 解析器会根据**字面值自动推断类型**（如 `42` → `!!int`，`true` → `!!bool`），无需显式写标签。显式使用标签主要用于：
>
> - 覆盖自动推断（如强制 `"123"` 为字符串而非整数）；
> - 提高可读性或规范性；
> - 避免自定义类型解析器干扰。

---

#### 补充

`!!set` 是一种**特殊映射结构**，其语义是：

- **每个元素都是一个“键”**；
- **所有键的值隐式为 `null`（或 `~`）**；
- **集合中的元素必须唯一**（重复即无效）；
- **顺序无关**（集合是无序的）。

> 📌 技术上，`!!set` 被编码为一个**所有值为 `null` 的映射（map）**，但通过 `!!set` 标签赋予其“集合”语义。 

 语法解析

```yaml
baseball players: !!set
  ? Mark McGwire
  ? Sammy Sosa
  ? Ken Griffey
```

等价于（显式写出 null 值）：

```yaml
baseball players: !!set
  Mark McGwire: null
  Sammy Sosa: null
  Ken Griffey: null
```

重复定义就会报错(duplicated mapping key)

```yaml
baseball players: !!set
  ? Ken Griffey
  ? Ken Griffey
```



- 实际上，对于简单字符串，也可以省略 `? `,`null`值也可以省略,但是为了表示键值对,需要末尾`:`

  ```yaml
  baseball players: !!set
    Mark McGwire: 
    Sammy Sosa: 
    Ken Griffey: 
  ```

---



###  其他数值格式

YAML 1.1 还支持一些扩展数值标签（在某些实现中可用）：

- `!!binary`：Base64 编码的二进制数据  

  ```yaml
  data: !!binary "SGVsbG8="
  ```

- `!!timestamp`：时间戳（ISO 8601）  

  ```yaml
  time: !!timestamp "2025-11-05T12:00:00Z"
  ```

- `!!omap`：有序映射（保留插入顺序）  

- `!!pairs`：键值对列表（允许重复键）

> ⚠️ 注意：YAML 1.2 默认采用 **JSON Schema** 或 **Core Schema**，其中 `!!timestamp` 和 `!!binary` 不再是核心类型，需依赖具体解析器支持（如 PyYAML 仍支持）。

---

###  实际用途示例

#### 1. 强制字符串（避免数字/布尔误判）

```yaml
version: !!str 1.20  # 防止被解析为浮点数 1.2
enabled: !!str off   # 防止被解析为布尔 false
```

#### 2. 显式结构类型（用于模板或文档规范）

```yaml
metadata: !!map
  name: app
  version: "1.0"
items: !!seq
  - item1
  - item2
```

#### 3. 二进制数据（如证书、图片嵌入）

```yaml
cert: !!binary |
  LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0t...
```

---

###  小结

- `!!null`, `!!bool`, `!!int`, `!!float`, `!!str`, `!!seq`, `!!map` 是 **最通用且跨语言支持最好的内置标签**。
- 显式标签不是必需的，但在**类型歧义、数据保真、规范文档**等场景非常有用。
- 不同 YAML 解析库（如 Python 的 PyYAML、Go 的 yaml.v3、JavaScript 的 js-yaml）对扩展标签的支持略有差异，建议在关键系统中验证兼容性。

如果你有特定语言环境（如 Python、Go）或使用场景（如 Kubernetes、Ansible），我可以提供更针对性的说明。



## 综合类型指南🎈

### 集合类型

```yaml
---
# Collection Types #####################################################

# http://yaml.org/type/map.html -----------------------------------------------#

map:
  # Unordered set of key: value pairs.
  Block style: !!map
    Clark : Evans
    Ingy  : dot Net
    Oren  : Ben-Kiki
  Flow style: !!map { Clark: Evans, Ingy: dot Net, Oren: Ben-Kiki } #使用显式类型声明!!map,定义一个映射型的值(关联数组)

# http://yaml.org/type/omap.html ----------------------------------------------#

omap:
  # Explicitly typed ordered map (dictionary).
  Bestiary: !!omap
    - aardvark: African pig-like ant eater. Ugly.
    - anteater: South-American ant eater. Two species.
    - anaconda: South-American constrictor snake. Scaly.
    # Etc.
  # Flow style
  Numbers: !!omap [ one: 1, two: 2, three : 3 ]

# http://yaml.org/type/pairs.html ---------------------------------------------#

pairs:
  # Explicitly typed pairs.
  Block tasks: !!pairs
    - meeting: with team.
    - meeting: with boss.
    - break: lunch.
    - meeting: with client.
  Flow tasks: !!pairs [ meeting: with team, meeting: with boss ]

# http://yaml.org/type/set.html -----------------------------------------------#

set:
  # Explicitly typed set.
  baseball players: !!set
    ? Mark McGwire
    ? Sammy Sosa
    ? Ken Griffey
  # Flow style
  baseball teams: !!set { Boston Red Sox, Detroit Tigers, New York Yankees }

# http://yaml.org/type/seq.html -----------------------------------------------#

seq:
  # Ordered sequence of nodes
  Block style: !!seq
  - Mercury   # Rotates - no light/dark sides.
  - Venus     # Deadliest. Aptly named.
  - Earth     # Mostly dirt.
  - Mars      # Seems empty.
  - Jupiter   # The king.
  - Saturn    # Pretty.
  - Uranus    # Where the sun hardly shines.
  - Neptune   # Boring. No rings.
  - Pluto     # You call this a planet?
  Flow style: !!seq [ Mercury, Venus, Earth, Mars,      # Rocks
                      Jupiter, Saturn, Uranus, Neptune, # Gas
                      Pluto ]                           # Overrated

```

### 标量类型

```yaml

# Scalar Types #################################################################
################################################################################

# http://yaml.org/type/bool.html ----------------------------------------------#

bool:
  - true
  - True
  - TRUE
  - false
  - False
  - FALSE

# http://yaml.org/type/float.html ---------------------------------------------#

float:
  canonical: 6.8523015e+5
  exponentioal: 685.230_15e+03
  fixed: 685_230.15
  negative infinity: -.inf
  not a number: .NaN

# http://yaml.org/type/int.html -----------------------------------------------#

int:
  canonical: 685230
  decimal: +685_230
  octal: 0o2472256
  hexadecimal: 0x_0A_74_AE
  binary: 0b1010_0111_0100_1010_1110

# http://yaml.org/type/merge.html ---------------------------------------------#

merge:
  - &CENTER { x: 1, y: 2 }
  - &LEFT { x: 0, y: 2 }
  - &BIG { r: 10 }
  - &SMALL { r: 1 }

  # All the following maps are equal:

  - # Explicit keys
    x: 1
    y: 2
    r: 10
    label: nothing

  - # Merge one map
    << : *CENTER
    r: 10
    label: center

  - # Merge multiple maps
    << : [ *CENTER, *BIG ]
    label: center/big

  - # Override
    << : [ *BIG, *LEFT, *SMALL ]
    x: 1
    label: big/left/small

# http://yaml.org/type/null.html ----------------------------------------------#

null:
  # This mapping has four keys,
  # one has a value.
  empty:
  canonical: ~
  english: null
  ~: null key
  # This sequence has five
  # entries, two have values.
  sparse:
    - ~
    - 2nd entry
    -
    - 4th entry
    - Null

# http://yaml.org/type/str.html -----------------------------------------------#

string: abcd

# http://yaml.org/type/timestamp.html -----------------------------------------#

timestamp:
  canonical:        2001-12-15T02:59:43.1Z
  valid iso8601:    2001-12-14t21:59:43.10-05:00
  space separated:  2001-12-14 21:59:43.10 -5
  no time zone (Z): 2001-12-15 2:59:43.10
  date (00:00:00Z): 2002-12-14


```



## 案例

### 案例

```yaml
---
receipt:     Oz-Ware Purchase Invoice
date:        2012-08-06
customer:
    first_name:   Dorothy
    family_name:  Gale

items:
    - part_no:   A4786
      descrip:   Water Bucket (Filled)
      price:     1.47
      quantity:  4

    - part_no:   E1628
      descrip:   High Heeled "Ruby" Slippers
      size:      8
      price:     133.7
      quantity:  1

bill-to:  &id001
    street: |
            123 Tornado Alley
            Suite 16
    city:   East Centerville
    state:  KS

ship-to:  *id001
merge: 
    oldkey: old
    newobj: *id001
    <<: *id001
    
specialDelivery:  >
    Follow the Yellow Brick
    Road to the Emerald City.
    Pay no attention to the
    man behind the curtain.
...
```

此示例文档定义了一个包含 7 个顶级键的关联数组：其中一个键“items”包含一个具有两个元素的**列表**，该列表中的每个元素本身也是一个**关联数组**，但键各不相同。

文档展示了**关系数据和冗余消除**：如锚点 ( `&` ) 和引用 ( `*` ) 标签所示，“ship-to”关联数组的内容是从“bill-to”关联数组的内容复制而来。可以添加可选的空行以提高可读性。单个文件/流中可以存在多个文档，并用 `---` 分隔。可以在文件末尾使用可选的 `...` （这在流式通信中表示结束而不关闭管道时非常有用）。

对应的json

```json
{
    "receipt": "Oz-Ware Purchase Invoice",
    "date": "2012-08-06T00:00:00.000Z",
    "customer": {
        "first_name": "Dorothy",
        "family_name": "Gale"
    },
    "items": [
        {
            "part_no": "A4786",
            "descrip": "Water Bucket (Filled)",
            "price": 1.47,
            "quantity": 4
        },
        {
            "part_no": "E1628",
            "descrip": "High Heeled \"Ruby\" Slippers",
            "size": 8,
            "price": 133.7,
            "quantity": 1
        }
    ],
    "bill-to": {
        "street": "123 Tornado Alley\nSuite 16\n",
        "city": "East Centerville",
        "state": "KS"
    },
    "ship-to": {
        "street": "123 Tornado Alley\nSuite 16\n",
        "city": "East Centerville",
        "state": "KS"
    },
    "merge": {
        "oldkey": "old",
        "newobj": {
            "street": "123 Tornado Alley\nSuite 16\n",
            "city": "East Centerville",
            "state": "KS"
        },
        "street": "123 Tornado Alley\nSuite 16\n",
        "city": "East Centerville",
        "state": "KS"
    },
    "specialDelivery": "Follow the Yellow Brick Road to the Emerald City. Pay no attention to the man behind the curtain.\n"
}
```



### 案例

```yaml
companies:
    -
        id: 1
        name: company1
        price: 200W
    -
        id: 2
        name: company2
        price: 500W
```

对应json

```json
{
    "companies": [
        {
            "id": 1,
            "name": "company1",
            "price": "200W"
        },
        {
            "id": 2,
            "name": "company2",
            "price": "500W"
        }
    ]
}
```

```yaml
languages:
  - Ruby
  - Perl
  - Python 
websites:
  YAML: yaml.org 
  Ruby: ruby-lang.org 
  Python: python.org 
  Perl: use.perl.org
```

对应json

```json
{
    "languages": [
        "Ruby",
        "Perl",
        "Python"
    ],
    "websites": {
        "YAML": "yaml.org",
        "Ruby": "ruby-lang.org",
        "Python": "python.org",
        "Perl": "use.perl.org"
    }
}
```



### 案例

```yaml
%YAML 1.2

# YAML 中 %TAG 是指令（directive），必须出现在文档开始处，在任何数据之前，且不能在已有内容之后出现。
# YAML 文档起始标记（可选，但推荐用于多文档流）
---
# 指令：声明使用 YAML 1.2 版本（尽管规范提到 1.1，但 1.2 更通用）
# 定义标签简写，用于后续类型标注（URI 前缀缩写）

# 标量（字符串）：不加引号的普通字符串
title: Welcome to YAML

# 字符串：包含特殊字符（如冒号、URL）无需引号（因冒号后有空格）
homepage: https://www.example.com

# 字符串：使用单引号（内部单引号需转义为两个单引号）
quote: "It's a beautiful day!"

# 字符串：使用双引号，支持 C 风格转义
escaped: "Line 1\nLine 2\tTabbed"

# 块标量：保留换行（|）
preserved_block: |
  这是一段


  保留原始换行的文本。

  每行结尾的换行符都会被保留。

# 块标量：折叠换行（>）
folded_block: >
  这是一段折叠文本。


  连续的换行会被合并为单个空格，

  但空行会变成换行。

# 列表：使用连字符（-）表示
fruits:
  - Apple
  - Banana
  - Cherry

# 列表：使用行内格式（方括号）
colors: [Red, Green, Blue]

# 关联数组（映射）：键值对，冒号后必须有空格
database:
  host: localhost
  port: 3306
  # 键包含特殊字符时，可用 ? 显式声明键（此处仅为演示，实际不需要）
  ? ssl-enabled: true

# 行内映射（花括号）
metadata: { author: "Alice", version: "1.0" }

# 重复节点：使用 & 定义锚点，* 引用
default_config: &default
  timeout: 30
  retries: 3

production:
  <<: *default # 合并锚点内容
  host: prod.example.com

# 注释示例：井号后必须有空格，且不能紧贴标记
# 这是一个有效的注释
invalid#comment: 这里的 # 是字符串的一部分，因为前面没有空格


# 多文档分隔符（下一个文档开始）
# ---
# summary: This is the second document.


...
# 文档结束标记（可选）
```
