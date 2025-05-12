[toc]



Pandas DataFrame 初始化：全面创建方法指南

DataFrame 是 Pandas 中最常用的数据结构，理解如何初始化 DataFrame 是数据分析的第一步。下面我将详细介绍各种创建 DataFrame 的方法。

## 1. 从字典创建（最常用方法）

列表的字典作为构造参数

```python
import pandas as pd

# 方法1：字典的value是列表（等长）
data = {
    '姓名': ['张三', '李四', '王五'],
    '年龄': [25, 30, 35],
    '城市': ['北京', '上海', '广州']
}
df1 = pd.DataFrame(data)
print(df1)
```

输出：
```
   姓名  年龄  城市
0  张三  25  北京
1  李四  30  上海
2  王五  35  广州
```

## 2. 从列表创建

从列表的列表(矩阵)或者字典的列表构造参数

### 2.1 列表的列表（需指定列名）

```python
data = [
    ['张三', 25, '北京'],
    ['李四', 30, '上海'],
    ['王五', 35, '广州']
]
df2 = pd.DataFrame(data, columns=['姓名', '年龄', '城市'])
print(df2)
```

### 2.2 字典的列表（推荐）

```python
data = [
    {'姓名': '张三', '年龄': 25, '城市': '北京'},
    {'姓名': '李四', '年龄': 30, '城市': '上海'},
    {'姓名': '王五', '年龄': 35, '城市': '广州'}
]
df3 = pd.DataFrame(data)
print(df3)
```

## 3. 从 NumPy 数组创建

```python
import numpy as np

arr = np.array([
    ['张三', 25, '北京'],
    ['李四', 30, '上海'],
    ['王五', 35, '广州']
])
df4 = pd.DataFrame(arr, columns=['姓名', '年龄', '城市'])
print(df4)
```

## 4. 从 Series 创建

```python
name_series = pd.Series(['张三', '李四', '王五'], name='姓名')
age_series = pd.Series([25, 30, 35], name='年龄')
city_series = pd.Series(['北京', '上海', '广州'], name='城市')

df5 = pd.concat([name_series, age_series, city_series], axis=1)
print(df5)
```

## 5. 特殊初始化方法

### 5.1 创建空 DataFrame

```python
empty_df = pd.DataFrame(columns=['姓名', '年龄', '城市'])
print(empty_df)
```

### 5.2 创建带有默认值的 DataFrame

```python
# 方法1：全相同值
default_df1 = pd.DataFrame(index=range(3), columns=['A', 'B', 'C'])
default_df1[:] = 0  # 全部填充为0

# 方法2：使用numpy初始化
default_df2 = pd.DataFrame(np.zeros((3,3)), columns=['A', 'B', 'C'])
```

### 5.3 创建日期索引的 DataFrame

```python
date_df = pd.DataFrame(
    data={'销售额': [100, 200, 150]},
    index=pd.date_range('20230101', periods=3)
)
print(date_df)
```

## 6. 从外部文件创建（实际最常用）

### 6.1 从 CSV 文件

```python
csv_df = pd.read_csv('data.csv')
```

### 6.2 从 Excel 文件

```python
excel_df = pd.read_excel('data.xlsx', sheet_name='Sheet1')
```

### 6.3 从 SQL 数据库

```python
from sqlalchemy import create_engine

engine = create_engine('sqlite:///database.db')
sql_df = pd.read_sql('SELECT * FROM employees', engine)
```

## 7. 初始化时的常用参数

```python
# 完整参数示例
df = pd.DataFrame(
    data=data,
    index=['a', 'b', 'c'],  # 自定义索引
    columns=['姓名', '城市'],  # 指定列顺序/筛选列
    dtype={'年龄': 'float32'}  # 指定列数据类型
)
```

## 8. 实际应用示例

### 8.1 创建测试数据

```python
test_data = pd.DataFrame({
    'id': range(1, 101),
    'value': np.random.normal(0, 1, 100)
})
```

### 8.2 创建时间序列数据

```python
date_rng = pd.date_range(start='1/1/2023', end='1/10/2023', freq='D')
ts_df = pd.DataFrame(date_rng, columns=['date'])
ts_df['data'] = np.random.randint(0,100,size=(len(date_rng)))
```

## 初始化方法选择指南

| 场景           | 推荐方法               |
| -------------- | ---------------------- |
| 少量结构化数据 | 字典或字典列表         |
| 数值计算为主   | NumPy 数组转换         |
| 已有数据库     | pd.read_sql            |
| 已有文件数据   | pd.read_csv/read_excel |
| 需要特殊索引   | 指定index参数          |
| 创建测试数据   | NumPy随机数生成        |

## 注意事项

1. 字典方式创建时，所有列表长度必须一致
2. 大数据量初始化建议使用 NumPy 数组或从文件读取
3. 指定 `dtype` 参数可以优化内存使用
4. 使用 `copy=False` 可以避免不必要的数据复制（但要注意副作用）

掌握这些初始化方法，你就能灵活地创建各种结构的 DataFrame，为后续数据分析打下坚实基础。