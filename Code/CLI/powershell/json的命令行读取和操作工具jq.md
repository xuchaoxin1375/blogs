[toc]

## abstract

- [jqlang/jq: Command-line JSON processor](https://github.com/jqlang/jq)

`jq` 是一个用于处理 JSON 数据的命令行工具，非常强大且灵活。它允许你对 JSON 数据进行解析、提取、修改等操作。以下是一些常用的 `jq` 用法示例，帮助你快速上手。

### 基础用法

#### 读取并显示 JSON
```bash
jq '.' file.json
```
这个命令读取 `file.json` 文件中的 JSON 数据，并以美化格式（pretty print）输出。

#### 从 JSON 中提取字段
```bash
jq '.field_name' file.json
```
提取 JSON 中指定字段 `field_name` 的值。例如，假设 `file.json` 内容如下：
```json
{
  "name": "Alice",
  "age": 25
}
```
执行：
```bash
jq '.name' file.json
```
输出：
```bash
"Alice"
```

#### 多层次提取
如果 JSON 是嵌套的，你可以通过点符号链式提取：
```bash
jq '.person.address.city' file.json
```
比如，给定以下 JSON：
```json
{
  "person": {
    "address": {
      "city": "New York",
      "zipcode": "10001"
    }
  }
}
```
执行以上命令后，输出为：
```bash
"New York"
```

#### 提取数组元素
如果 JSON 包含数组，`jq` 可以用索引提取元素：
```bash
jq '.items[0]' file.json
```
比如对于以下 JSON：
```json
{
  "items": [
    "apple",
    "banana",
    "cherry"
  ]
}
```
命令将输出：
```bash
"apple"
```

### 过滤和查询

#### 过滤数组中的元素
你可以通过表达式过滤数组中的元素。例如，提取一个年龄大于 20 的所有人：
```bash
jq '.people[] | select(.age > 20)' file.json
```
给定 JSON：
```json
{
  "people": [
    {"name": "Alice", "age": 25},
    {"name": "Bob", "age": 19},
    {"name": "Charlie", "age": 30}
  ]
}
```
输出为：
```json
{
  "name": "Alice",
  "age": 25
}
{
  "name": "Charlie",
  "age": 30
}
```

#### 过滤并提取字段
你可以在过滤的基础上，进一步提取特定字段：
```bash
jq '.people[] | select(.age > 20) | .name' file.json
```
输出为：
```bash
"Alice"
"Charlie"
```

### 修改 JSON

#### 修改某个字段的值
可以通过 `=` 运算符修改 JSON 中的字段值：
```bash
jq '.name = "Bob"' file.json
```
这将把 `name` 字段的值修改为 `"Bob"`，并输出修改后的 JSON 数据。

#### 添加新字段
如果想为现有的 JSON 对象添加一个新字段，可以使用 `|=` 运算符：
```bash
jq '.new_field |= "new_value"' file.json
```

### 组合操作

#### 管道操作
`jq` 支持管道 `|`，可以将一个操作的结果传递给下一个操作。例如：
```bash
jq '.people[] | select(.age > 20) | .name' file.json
```
这个命令首先选择 `age > 20` 的所有人，然后只提取他们的 `name`。

#### 多个字段提取
可以提取多个字段，并生成新的 JSON 对象：
```bash
jq '.people[] | {name: .name, city: .address.city}' file.json
```
如果 `file.json` 中每个人都有一个地址信息，上述命令将只提取 `name` 和 `city`。

### 复杂操作

#### 数组的映射和转换
可以对数组中的每个元素进行映射操作，改变每个元素的结构。例如，将每个人的 `name` 和 `age` 提取为新数组：
```bash
jq '[.people[] | {name: .name, age: .age}]' file.json
```

#### 合并多个 JSON 文件
可以使用 `jq` 将多个 JSON 文件合并成一个数组：
```bash
jq -s '.' file1.json file2.json
```
`-s` 选项会将所有输入合并为一个数组。比如 `file1.json` 和 `file2.json` 的内容如下：
```json
{"name": "Alice"}
{"name": "Bob"}
```
命令输出：
```json
[
  {"name": "Alice"},
  {"name": "Bob"}
]
```

### 其他常用选项

#### 压缩输出
使用 `-c` 选项可以使输出为紧凑格式（去掉多余的空白符）：
```bash
jq -c '.' file.json
```

#### 输出为字符串
使用 `-r` 选项可以直接输出 JSON 字段的原始值（即不带引号的字符串）：
```bash
jq -r '.name' file.json
```
输出为：
```bash
Alice
```

### 总结
`jq` 是处理 JSON 数据的强大工具。你可以用它来提取数据、修改数据、筛选数据，甚至组合多个 JSON。通过管道和灵活的表达式，`jq` 能够简化复杂的 JSON 操作。

更多高级用法可以查阅官方文档或使用 `man jq` 命令查看帮助。