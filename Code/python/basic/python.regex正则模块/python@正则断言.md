[toc]





## 断言

在 Python 的正则表达式（`re` 模块）中，**前视断言（lookahead assertion）** 是一种用于匹配某个位置之前或之后是否满足某种条件的机制，但它 **不会真正消费字符**，也就是说它只是“查看”某些内容是否存在，而不会包含在最终的匹配结果中。

---

🔍 一、什么是前视断言？

前视断言分为两种：

### ✅ 1. 正向前瞻（Positive Lookahead）

语法：`(?=...)`

表示：匹配一个位置，其**后面跟着**某个特定的内容。

#### 示例：

```python
import re

text = "I love Python3 and Python2"
matches = re.findall(r"Python(?=\d)", text)

print(matches)
# 输出: ['Python', 'Python']
```

> 解释：只匹配后面跟着数字的 "Python"。虽然 `Python3` 和 `Python2` 都匹配，但只返回了 "Python"。

---

### ❌ 2. 负向前瞻（Negative Lookahead）

语法：`(?!...)`

表示：匹配一个位置，其**后面不跟着**某个特定的内容。

#### 示例：

```python
import re

text = "I love Python3 and Python2 but not PythonX"
matches = re.findall(r"Python(?!\d)", text)

print(matches)
# 输出: ['Python']
```

> 解释：只匹配那些后面**不是数字**的 "Python"。只有 `PythonX` 中的 "Python" 满足这个条件。

---

## 🔁 二、后视断言（Lookbehind Assertion）

除了前视断言，还有**后视断言**，用于判断某个位置前面是否有某种模式。

### ✅ 正向后视：`(?<=...)`

表示：当前位置前面是某个模式。

### ❌ 负向后视：`(?<!...)`

表示：当前位置前面**不是**某个模式。

#### 示例：

```python
import re

text = "abc123def456"

# 匹配被字母包围的数字
result = re.findall(r"(?<=\d)\d+(?=\d)", text)
print(result)  # 输出: ['2']
```

---

## 🧠 使用场景举例

### 场景：提取链接中的域名部分

```python
import re

url = "https://www.example.com/path/to/page.html"
match = re.search(r"(?<=https:\/\/)[^/]+", url)
if match:
    print(match.group())  # 输出: www.example.com
```

---

## ⚠️ 注意事项

- 前视/后视断言本身**不捕获也不消耗字符**。
- 后视断言要求长度固定（在大多数正则引擎中），但 Python 的 `regex` 模块支持变长后视。
- 在标准库 `re` 模块中，**后视断言必须是定长的**；例如不能写成 `(?<=a{1,3})`。

---

## 📦 总结

| 类型     | 语法       | 含义               |
| -------- | ---------- | ------------------ |
| 正向前视 | `(?=...)`  | 后面匹配指定内容   |
| 负向前视 | `(?!...)`  | 后面不匹配指定内容 |
| 正向后视 | `(?<=...)` | 前面匹配指定内容   |
| 负向后视 | `(?<!...)` | 前面不匹配指定内容 |

---

 