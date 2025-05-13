[toc]

当然可以！在 Pandas 中，`DataFrame.query()` 是一个非常实用的方法，用于**通过字符串表达式筛选数据**。它提供了一种更简洁、可读性更强的方式来替代传统的布尔索引（如 `df[df['col'] > 10]`）。

---

## 🧠 一、基本介绍

### ✅ 方法定义：
```python
DataFrame.query(expression, inplace=False, **kwargs)
```

- `expression`: 字符串形式的查询表达式。
- `inplace`: 是否原地修改原始 DataFrame（默认为 `False`）。
- `**kwargs`: 其他参数，比如变量映射等。

### ✅ 返回值：
- 默认返回一个新的 `DataFrame`，包含满足条件的行；
- 如果设置 `inplace=True`，则直接修改原始 DataFrame 并返回 `None`。

---

## 📌 二、基本用法示例

假设我们有如下 DataFrame：

```python
import pandas as pd

df = pd.DataFrame({
    'A': [1, 2, 3, 4],
    'B': [5, 6, 7, 8],
    'C': ['a', 'b', 'c', 'd']
})
```

输出：
```
   A  B  C
0  1  5  a
1  2  6  b
2  3  7  c
3  4  8  d
```

---

### 示例 1：基本数值比较

```python
df.query("A > 2")
```

等价于：

```python
df[df['A'] > 2]
```

输出：
```
   A  B  C
2  3  7  c
3  4  8  d
```

---

### 示例 2：多条件查询（支持 `and`, `or`, `not`）

```python
df.query("A > 2 and B < 8")
```

输出：
```
   A  B  C
2  3  7  c
```

---

### 示例 3：字符串匹配

```python
df.query("C in ['a', 'c']")
```

输出：
```
   A  B  C
0  1  5  a
2  3  7  c
```

---

### 示例 4：使用外部变量（前缀 `@`）

```python
threshold = 3
df.query("A > @threshold")
```

输出：
```
   A  B  C
3  4  8  d
```

> ⚠️ 注意：变量前要加 `@` 符号才能在 query 表达式中引用。

---

## 🔍 三、query 的优势（与布尔索引对比）

| 特点       | `.query()`           | 布尔索引            |
| ---------- | -------------------- | ------------------- |
| 可读性     | ✅ 更清晰简洁         | ❗嵌套较多时不易读   |
| 性能       | ✅ 略快（底层优化过） | 一般                |
| 变量引用   | ✅ 支持 `@var`        | ❌ 需拼接表达式      |
| 多条件组合 | ✅ 更自然             | ❗需要括号和 `&`/`|` |

---

## 🧪 四、进阶用法

### 1. 使用函数或方法（支持部分 NumPy 函数）

```python
import numpy as np

df['D'] = [1.1, 2.2, 3.3, 4.4]
df.query("D > np.mean(D)")
```

---

### 2. 多层索引 DataFrame 查询

```python
df_multi = df.set_index(['C'])
df_multi.query("index == 'a'")
```

---

### 3. 结合 `eval` 引擎使用（高级）

默认使用的是 `'numexpr'` 引擎，但也可以切换为 Python 引擎：

```python
df.query("A > 2", engine='python')
```

> ⚠️ 不推荐除非必要，因为性能会下降。

---

## 🧱 五、语法规范 & 注意事项

- 列名不能含有空格或特殊字符，否则需要用反引号包裹：`` `column name` ``；
- 字符串值要用单引号或双引号包围；
- 支持 `in`, `not in`, `==`, `!=`, `>`, `<` 等比较运算；
- 支持逻辑运算：`and`, `or`, `not`；
- 支持 `isnull()` 和 `notnull()` 函数；
- 不适合复杂嵌套逻辑，建议用布尔索引代替。

---

## ✅ 六、总结一句话

> `df.query()` 是一种优雅且高效的筛选方式，适用于简单的列过滤和条件组合，尤其适合交互式分析、代码可读性和快速调试，是 Pandas 数据清洗和探索中的利器。

---

如果你还想了解 `.query()` 和 `.loc[]`、`.eval()` 的区别，或者如何结合 `groupby()` 使用 `.query()`，也可以继续问我 😊