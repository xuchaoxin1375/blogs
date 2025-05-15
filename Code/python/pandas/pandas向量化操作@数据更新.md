[toc]



---

##  一、什么是“向量化操作”？

**向量化操作（Vectorized Operations）** 指的是利用 NumPy 和 Pandas 内部优化过的 C 级别代码，对整个数组或 DataFrame 的所有元素进行快速运算的操作。

这些操作是**无循环**的，底层由高效的 C 语言实现，因此速度非常快，是 Pandas 最推荐使用的操作方式。

---

##  二、常见向量化操作

### 1. **基本算术运算**
```python
df + 10
df * 2
df1 + df2  # 对应位置相加
```

### 2. **比较运算**
```python
df > 5
df != 0
```

### 3. **数学函数（NumPy 提供）**
```python
import numpy as np

np.sqrt(df)        # 开平方
np.log(df)         # 自然对数
np.abs(df)         # 绝对值
np.sin(df), np.cos(df), np.exp(df)  # 其他数学函数
```

### 4. **Pandas 内置函数**
```python
df.round(2)        # 四舍五入到两位小数
df.clip(lower=0, upper=10)  # 裁剪数值范围
df.astype(int)     # 类型转换
```

---

##  三、`.apply()`：按行/列应用函数🎈

### 📌 基本语法：

```python
df.apply(func, axis=0)
```

- `axis=0`：按列（默认）
- `axis=1`：按行

###  示例：

```python
df = pd.DataFrame({
    'A': [1, 2, 3],
    'B': [4, 5, 6]
})

# 按列最大值减最小值
df.apply(lambda col: col.max() - col.min())
# 输出:
# A    2
# B    2
# dtype: int64

# 按行求和
df.apply(lambda row: row.sum(), axis=1)
# 输出:
# 0     5
# 1     7
# 2     9
# dtype: int64
```

### 🔁 可用于复杂逻辑，比如：

```python
def custom_func(x):
    return x.mean() + x.std()

df.apply(custom_func)
```

---

##  四、`.applymap()`：逐元素应用函数

### 📌 基本语法：
```python
df.applymap(func)
```

- 对每个元素执行函数。
- 函数必须接受一个标量并返回一个标量。

###  示例：

```python
# 所有元素加 10
df.applymap(lambda x: x + 10)

# 所有元素格式化为字符串
df.applymap(str)
```

> ⚠️ 注意：`.applymap()` 只能作用于 DataFrame，不能用于 Series。

---

## 📊 五、性能对比总结

| 方法                                 | 是否向量化 | 适用对象 | 性能       | 推荐程度 |
| ------------------------------------ | ---------- | -------- | ---------- | -------- |
| 向量化操作（如 `+`, `*`, `np.sqrt`） | 完全向量化 | 整体     | ⭐⭐⭐⭐⭐ 最快 | 强烈推荐 |
| `.applymap()`                        | ❌ 非向量化 | 每个元素 | ⭐⭐⭐ 一般   | 推荐     |
| `.apply()`                           | ❌ 非向量化 | 行/列    | ⭐⭐⭐ 一般   | 推荐     |
| `.iterrows()` / `.itertuples()`      | ❌ 循环     | 行       | ⭐ 最慢     | ⚠️ 不推荐 |

---

## 🧩 六、使用建议与最佳实践

| 场景                                       | 推荐方法                             |
| ------------------------------------------ | ------------------------------------ |
| 对每个元素做简单计算（如加减乘除、开方等） | 使用向量化操作                       |
| 对每列或每行做聚合、变换、自定义逻辑       | 使用 `.apply()`                      |
| 对每个元素做统一处理（如类型转换、格式化） | 使用 `.applymap()`                   |
| 处理大数据时                               | 尽量用向量化                         |
| 小数据调试                                 | 可以使用 `.apply()` 或 `.iterrows()` |

---

## 🧪 七、综合示例对比

```python
import pandas as pd
import numpy as np

df = pd.DataFrame({
    'A': [1, 2, 3],
    'B': [4, 5, 6]
})
```

###  向量化操作（最快）
```python
df_new = df * 2 + 10
```

###  applymap（适合非向量化但逐元素）
```python
df_new = df.applymap(lambda x: x * 2 if x % 2 == 0 else x + 1)
```

###  apply（按列/行处理）
```python
df.apply(lambda col: col.max() - col.min())  # 按列
df.apply(lambda row: row['A'] + row['B'], axis=1)  # 按行
```

---

##  八、总结

在 Pandas 中，**优先使用向量化操作（如 `+`, `*`, `np.sqrt`, `df.round()`），其次考虑 `.applymap()` 和 `.apply()`，最后才使用迭代方式**。这样既能保证代码简洁，又能获得最佳性能。

---

在使用 Pandas 的 `DataFrame` 进行数据处理时，向量化操作（Vectorized Operations）是高效处理数据的关键。它们利用了 NumPy 的底层优化，避免了 Python 原生循环的性能瓶颈。以下是一些常用的 **Pandas DataFrame 向量化操作 API** 分类总结：

---

## 🧮 一、数学运算（Arithmetic Operations）

| 操作   | 方法/符号          | 示例                |
| ------ | ------------------ | ------------------- |
| 加法   | `+` 或 `df.add()`  | `df['A'] + df['B']` |
| 减法   | `-` 或 `df.sub()`  | `df['A'] - df['B']` |
| 乘法   | `*` 或 `df.mul()`  | `df['A'] * df['B']` |
| 除法   | `/` 或 `df.div()`  | `df['A'] / df['B']` |
| 取余   | `%` 或 `df.mod()`  | `df['A'] % df['B']` |
| 幂运算 | `**` 或 `df.pow()` | `df['A'] ** 2`      |

> 这些操作支持广播（Broadcasting），例如对整列进行标量操作。

---

## 📈 二、统计计算（Statistical Functions）

| 操作       | 方法           | 说明                 |
| ---------- | -------------- | -------------------- |
| 求和       | `df.sum()`     | 对每列或每行求和     |
| 平均值     | `df.mean()`    | 计算平均值           |
| 中位数     | `df.median()`  | 计算中位数           |
| 标准差     | `df.std()`     | 标准差               |
| 方差       | `df.var()`     | 方差                 |
| 最大值     | `df.max()`     | 找出最大值           |
| 最小值     | `df.min()`     | 找出最小值           |
| 累加       | `df.cumsum()`  | 累计求和             |
| 累积乘积   | `df.cumprod()` | 累计乘积             |
| 相关性矩阵 | `df.corr()`    | 列与列之间的相关系数 |
| 协方差矩阵 | `df.cov()`     | 列与列之间的协方差   |

---

## 🔍 三、逻辑判断与条件筛选

| 操作       | 方法               | 示例                             |
| ---------- | ------------------ | -------------------------------- |
| 条件判断   | `df > 5`           | 返回布尔型 DataFrame             |
| 多条件判断 | `&`, `|`           | `(df['A'] > 5) & (df['B'] < 10)` |
| 筛选数据   | `df.loc[]`, `df[]` | `df[df['A'] > 5]`                |
| where 操作 | `df.where()`       | 替换不符合条件的值为 NaN         |
| mask 操作  | `df.mask()`        | 替换符合条件的值为 NaN           |

---

## 📊 四、元素级函数应用（Element-wise）

| 方法                 | 用途                             |
| -------------------- | -------------------------------- |
| `df.applymap(func)`  | 对每个元素应用函数               |
| `np.vectorize(func)` | 将普通函数向量化后用于 DataFrame |
| `df.transform(func)` | 对每列应用函数并返回同形状结果   |

---

## 🧮 五、类型转换与数值处理

| 方法                           | 用途                                         |
| ------------------------------ | -------------------------------------------- |
| `df.astype(int)`               | 转换列的数据类型                             |
| `df.round(2)`                  | 四舍五入保留小数位                           |
| `df.abs()`                     | 绝对值                                       |
| `df.clip(lower=0, upper=100)`  | 截断超出范围的值                             |
| `df.isnull()` / `df.notnull()` | 检测缺失值                                   |
| `df.fillna(0)`                 | 填充缺失值（也可配合方法如 'ffill'/'bfill'） |

---

## 📅 六、时间序列操作（适用于 datetime 类型列）

| 方法            | 用途                       |
| --------------- | -------------------------- |
| `df.dt.year`    | 提取年份                   |
| `df.dt.month`   | 提取月份                   |
| `df.dt.day`     | 提取天                     |
| `df.dt.hour`    | 提取小时                   |
| `df.dt.weekday` | 获取星期几                 |
| `df.diff()`     | 时间差（按行计算）         |
| `df.shift(1)`   | 数据平移（用于比较前后行） |

---

## 🧩 七、字符串向量化操作（适用于 object 类型列）

| 方法                           | 用途                    |
| ------------------------------ | ----------------------- |
| `df.str.lower()`               | 字符串转小写            |
| `df.str.upper()`               | 转大写                  |
| `df.str.len()`                 | 获取长度                |
| `df.str.contains('abc')`       | 是否包含某字符串        |
| `df.str.replace('old', 'new')` | 替换内容                |
| `df.str.split(',')`            | 分割字符串成列表        |
| `df.str.get(0)`                | 获取分割后的第 n 个元素 |

---

## ✅ 总结建议

- 避免使用 `for` 循环或 `apply()`，优先使用向量化操作。
- 使用 `.loc[]` 和布尔索引来进行高效筛选。
- 利用 NumPy 函数（如 `np.where`, `np.select`）实现更复杂的向量化逻辑。
- 使用 `df.eval()` 或 `df.query()` 实现简洁表达式操作。

---

 
