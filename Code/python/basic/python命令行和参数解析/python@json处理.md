[toc]



## Python JSON 处理指南

Python 处理 JSON 就像是把不同语言的翻译过程。JSON 是一种轻量级的数据交换格式，而 Python 则通过内置的 `json` 模块，让这种“翻译”变得极其简单。

[JSON (JavaScript Object Notation)](https://json.org/)，由 [**RFC 7159**](https://datatracker.ietf.org/doc/html/rfc7159.html) (它取代了 [**RFC 4627**](https://datatracker.ietf.org/doc/html/rfc4627.html)) 和 [ECMA-404](https://ecma-international.org/publications-and-standards/standards/ecma-404/) 进行规范，是一个受到 [JavaScript](https://en.wikipedia.org/wiki/JavaScript) 对象**字面值语法**启发的**轻量级数据交换格式** (虽然它并不是严格意义上的 JavaScript 子集 )。

- [json --- JSON 编码器和解码器 — Python  文档](https://docs.python.org/zh-cn/3.14/library/json.html)

  

------

##  核心概念：映射关系

在处理 JSON 之前，你需要了解 JSON 类型与 Python 类型之间的对应关系：

| **JSON 类型**       | **Python 类型**  |
| ------------------- | ---------------- |
| `object`            | `dict`           |
| `array`             | `list`           |
| `string`            | `str`            |
| `number (int/real)` | `int` 或 `float` |
| `true / false`      | `True / False`   |
| `null`              | `None`           |

------

##  基础操作：序列化与反序列化

`json` 模块主要提供四个核心函数。你可以通过“s”后缀（代表 **String**）来区分是操作字符串还是文件。

### A. 解析 JSON（从 JSON 到 Python）

- **`json.loads()`**: 将 JSON 格式的**字符串**转为 Python 对象(通常是字典)。
- **`json.load()`**: 从 **文件对象** 中读取并解析 JSON。

```python
import json

# 解析字符串
json_str = '{"name": "Gemini", "is_ai": true, "version": 2.0}'
data = json.loads(json_str)
print(type(data)) # <class 'dict'>
print(data["name"])  # 输出: Gemini

# 从文件读取
with open('config.json', 'r', encoding='utf-8') as f:
    config = json.load(f)
```

### B. 生成 JSON（从 Python 到 JSON）

- **`json.dump()`**: 将 Python 对象写入 **文件**。
- **`json.dumps()`**: 将 Python 对象转为 JSON 格式的**字符串**。这里的`dumps`表示`dump string`,`s`表示字符串`string`.

```python
data = {"user": "Alice", "active": False, "roles": ["admin", "editor"]}

# 转为字符串
json_output = json.dumps(data)

# 写入文件
with open('user.json', 'w') as f:
    json.dump(data, f)
```

------

##  json格式输出:让 JSON 更易读

默认生成的 JSON 字符串往往挤成一团。使用以下参数可以显著提升可读性：

- **`indent`**: 设置缩进空格数。
- **`sort_keys`**: 按键名排序。
- **`ensure_ascii=False`**: 正常显示中文（不使用 Unicode 转义）。

```python
import json
data = {
    "姓名": "张三",
    "age": 25,
    "city": "北京",
    "comments": [
        "这是一个字典",
        "包含中文",
        "包含列表",
        {"nested": "嵌套字典", "last": True},
    ],
}

# 漂亮的打印格式
## 直接打印(dumps)
pretty_json = json.dumps(data, indent=4, sort_keys=True, ensure_ascii=False)
print(pretty_json)
## 保存到文件(dump)到pretty_json.json
with open("pretty_json.json", "w", encoding="utf-8") as f:
    json.dump(data, f, indent=4, sort_keys=True, ensure_ascii=False)

```

------

output:

```json

{
    "age": 25,
    "city": "北京",
    "comments": [
        "这是一个字典",
        "包含中文",
        "包含列表",
        {
            "last": true,
            "nested": "嵌套字典"
        }
    ],
    "姓名": "张三"
}
```

### 关于:ensure_ascii

**ensure_ascii** ([*bool*](https://docs.python.org/zh-cn/3.14/library/functions.html#bool)) -- 如果为 `True` (默认值)，输出将确保**对所有输入的非 ASCII 和不可打印字符进行转义**。

 如果为 `False`，则所有字符将被原样输出，**只有必须被转义的字符除外**：引号、反斜线，以及 U+0000 至 U+001F 范围的控制字符。

> 即便是面向人类阅读的情况在,也不总是建议设置此选项为`False`;
>
> 部分外部程序可能会有自己的处理流程,如果自行更改默认行为,反而可能导致乱码.

##  处理复杂对象（自定义编码器）

`json` 模块默认无法处理自定义类（Class）或 `datetime` 等对象。遇到这种情况，你需要自定义转换逻辑。

> **方案：使用 `default` 参数**

```python
from datetime import datetime

data = {
    "task": "Update Guide",
    "timestamp": datetime.now()
}

def datetime_handler(obj):
    if isinstance(obj, datetime):
        return obj.isoformat()
    raise TypeError("Unknown type")

# 传入处理函数
json_str = json.dumps(data, default=datetime_handler)
print(json_str)
```

------

##  常见陷阱与建议

1. **单引号 vs 双引号**: JSON 规范严格要求使用 **双引号** (`"`)。Python 字符串可以用单引号，但在 JSON 内部，`{'key': 'value'}` 是无效的。
2. **尾随逗号**: JSON 不允许列表或字典的最后一项后面有逗号。
3. **性能问题**: 如果你需要处理数 GB 级别的超大型 JSON 文件，内置的 `json` 模块可能会较慢。建议尝试 **`orjson`** 或 **`ujson`**，它们是经过 C 优化的第三方库。

------

##  工具推荐

- **校验工具**: 编写 JSON 时，如果不确定格式是否正确，可以使用在线工具如 JSONLint。
- **VS Code 插件**: 搜索 "JSON Tools"，可以实现一键格式化。

如果你正在处理特定的 Web API 返回值，或者需要将复杂的数据库查询结果转为 JSON，通常结合 `requests` 库或 `Pydantic` 会更加高效。

