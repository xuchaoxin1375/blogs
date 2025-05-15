[toc]



---

## Pandas DataFrame 处理 NA（缺失值）的向量化操作

Pandas 使用 `NaN`（Not a Number）表示浮点数类型缺失值，`None` 表示对象类型缺失值。在实际数据清洗中，处理这些缺失值是常见且关键的步骤。

---

### 1. **检测缺失值**

| 方法                               | 说明                                        |
| ---------------------------------- | ------------------------------------------- |
| `pd.isnull(df)` 或 `df.isnull()`   | 返回布尔型 DataFrame，标记哪些是 NaN/None   |
| `pd.notnull(df)` 或 `df.notnull()` | 返回布尔型 DataFrame，标记哪些不是 NaN/None |

✅ 示例：
```python
df.isnull()  # 每个位置是否为 NA
```

---

### 2. **过滤缺失值**

| 方法                   | 说明                      |
| ---------------------- | ------------------------- |
| `df.dropna()`          | 删除包含 NA 的行或列      |
| `df.dropna(axis=1)`    | 删除包含 NA 的列          |
| `df.dropna(how='all')` | 只删除全为 NA 的行或列    |
| `df.dropna(thresh=2)`  | 保留至少有 2 个非空值的行 |

✅ 示例：
```python
df.dropna(subset=['A', 'B'])  # 只检查 A 和 B 列是否有缺失值
```

---

### 3. **填充缺失值**

| 方法                          | 说明                               |
| ----------------------------- | ---------------------------------- |
| `df.fillna(0)`                | 用标量填充所有 NA                  |
| `df.fillna({'A': 0, 'B': 1})` | 对不同列使用不同的填充值           |
| `df.fillna(method='ffill')`   | 向前填充（用上一个有效值填充）     |
| `df.fillna(method='bfill')`   | 向后填充                           |
| `df.interpolate()`            | 插值法填充（如线性插值、多项式等） |

✅ 示例：
```python
df.fillna(df.mean(), inplace=True)  # 用每列均值填充 NA
```

---

### 4. **替换特定值为 NA**

| 方法                                    | 说明                        |
| --------------------------------------- | --------------------------- |
| `df.replace(np.nan, 0)`                 | 替换 NaN 为 0               |
| `df.replace([np.inf, -np.inf], np.nan)` | 将 inf/-inf 替换为 NaN      |
| `df.replace('missing', np.nan)`         | 把字符串 missing 视为缺失值 |

---

### 5. **判断某列/某行是否存在 NA**

| 方法                       | 说明                       |
| -------------------------- | -------------------------- |
| `df['A'].hasnans`          | 判断某一列是否有 NA        |
| `df.isnull().any()`        | 查看各列是否有 NA          |
| `df.isnull().sum()`        | 统计每列的 NA 数量         |
| `df.isnull().values.any()` | 整个 DataFrame 是否存在 NA |

✅ 示例：
```python
df.isnull().sum()  # 显示每列的缺失值数量
```

---

### 6. **结合条件选择进行缺失值处理**

| 方法                                     | 说明                    |
| ---------------------------------------- | ----------------------- |
| `df.loc[df['A'].isnull(), 'A'] = 0`      | 将某列的 NA 填充为 0    |
| `np.where(df['A'].isnull(), 0, df['A'])` | NumPy 向量化方式替换 NA |

---

## ✅ 最佳实践建议

| 场景               | 推荐方法                                     |
| ------------------ | -------------------------------------------- |
| 快速查看缺失情况   | `df.isnull().sum()`                          |
| 删除缺失较多的列   | `df.dropna(axis=1, thresh=int(len(df)*0.7))` |
| 数值型列填充均值   | `df.fillna(df.mean())`                       |
| 时间序列填充前后值 | `df.fillna(method='ffill')`                  |
| 分类变量填充众数   | `df.fillna(df.mode().iloc[0])`               |

---

## 📌 总结表格：NA 处理常用 API

| 操作         | 函数                        |
| ------------ | --------------------------- |
| 检测 NA      | `isnull()`, `notnull()`     |
| 删除 NA      | `dropna()`                  |
| 填充 NA      | `fillna()`, `interpolate()` |
| 替换值为 NA  | `replace()`                 |
| 查询 NA 数量 | `isnull().sum()`            |
| 条件赋值     | `loc[]`, `np.where()`       |

---

 