[toc]



## abstract

Pandas是Python数据分析的核心库，提供了高效、灵活的数据结构和工具。本教程将重点介绍Pandas最强大、最方便的特色功能。

## 1. Pandas核心数据结构

### 1.1 Series - 带标签的一维数组

```python
import pandas as pd
import numpy as np

# 创建Series
s = pd.Series([1, 3, 5, np.nan, 6, 8])
print(s)

# 带自定义索引
s2 = pd.Series([10, 20, 30], index=['a', 'b', 'c'])
print(s2['b'])  # 通过标签访问
```

### 1.2 DataFrame - 二维表格数据结构

```python
# 从字典创建DataFrame
data = {
    '姓名': ['张三', '李四', '王五'],
    '年龄': [25, 30, 35],
    '城市': ['北京', '上海', '广州']
}
df = pd.DataFrame(data)
print(df)

# 从CSV文件读取
df = pd.read_csv('data.csv')
```

## 2. 数据查看与选择

### 2.1 查看数据

```python
df.head()      # 查看前5行
df.tail(3)     # 查看后3行
df.shape       # 查看维度
df.info()      # 查看信息摘要
df.describe()  # 统计摘要
```

### 2.2 数据选择

```python
# 选择列
df['姓名']      # 选择单列
df[['姓名', '年龄']]  # 选择多列

# 选择行
df.loc[0]       # 按标签选择
df.iloc[0]      # 按位置选择
df[df['年龄'] > 30]  # 布尔索引

# 混合选择
df.loc[df['年龄'] > 30, ['姓名', '城市']]
```

## 3. 数据处理与清洗

### 3.1 处理缺失值

```python
df.isnull()       # 检测缺失值
df.dropna()       # 删除缺失值
df.fillna(0)      # 填充缺失值
df.fillna(df.mean())  # 用均值填充
```

### 3.2 数据转换

```python
# 类型转换
df['年龄'] = df['年龄'].astype(float)

# 重命名列
df.rename(columns={'姓名': 'name', '年龄': 'age'}, inplace=True)

# 替换值
df['城市'].replace({'北京': 'Beijing', '上海': 'Shanghai'}, inplace=True)

# 应用函数
df['年龄'] = df['年龄'].apply(lambda x: x + 1)
```

### 3.3 排序与去重

```python
df.sort_values('年龄', ascending=False)  # 按年龄降序
df.drop_duplicates()  # 删除重复行
```

## 4. 强大的分组与聚合

```python
# 基本分组
grouped = df.groupby('城市')

# 聚合操作
grouped.mean()       # 每组的均值
grouped.size()       # 每组的大小
grouped.describe()   # 每组的统计描述

# 多级分组
df.groupby(['城市', '年龄']).mean()

# 自定义聚合
df.groupby('城市').agg({
    '年龄': ['mean', 'min', 'max'],
    '姓名': 'count'
})
```

## 5. 数据合并与连接

```python
# 垂直合并
pd.concat([df1, df2])

# 水平合并
pd.concat([df1, df2], axis=1)

# SQL风格的连接
pd.merge(df1, df2, on='key')          # 内连接
pd.merge(df1, df2, on='key', how='left')  # 左连接
```

## 6. 时间序列处理

```python
# 创建时间序列
date_rng = pd.date_range(start='1/1/2020', end='1/08/2020', freq='D')
time_series = pd.Series(np.random.randn(len(date_rng)), index=date_rng)

# 重采样
time_series.resample('W').mean()  # 按周重采样

# 移动窗口
time_series.rolling(window=3).mean()
```

## 7. 高效数据输入/输出

```python
# 读取各种格式
pd.read_csv('file.csv')
pd.read_excel('file.xlsx')
pd.read_sql('SELECT * FROM table', con)

# 写入各种格式
df.to_csv('output.csv', index=False)
df.to_excel('output.xlsx')
df.to_sql('table_name', con)
```

## 8. 高级技巧

### 8.1 分类数据

```python
df['城市'] = df['城市'].astype('category')
```

### 8.2 数据透视表

```python
pd.pivot_table(df, values='年龄', index='城市', columns='性别', aggfunc=np.mean)
```

### 8.3 高性能操作

```python
# 使用eval进行高效计算
df.eval('年龄_平方 = 年龄 ** 2', inplace=True)

# 使用query进行高效过滤
df.query('年龄 > 30 and 城市 == "北京"')
```

## 9. 可视化集成

```python
df.plot()                 # 基本绘图
df['年龄'].plot.hist()      # 直方图
df.plot.scatter(x='年龄', y='收入')  # 散点图
```

## 10. 实际案例：销售数据分析

```python
# 读取数据
sales = pd.read_csv('sales_data.csv')

# 数据清洗
sales['Date'] = pd.to_datetime(sales['Date'])
sales = sales.dropna()

# 分析
monthly_sales = sales.groupby(pd.Grouper(key='Date', freq='M'))['Amount'].sum()
top_products = sales.groupby('Product')['Amount'].sum().nlargest(5)

# 可视化
monthly_sales.plot(title='Monthly Sales')
top_products.plot.pie(title='Top Selling Products')
```

## 总结

Pandas的强大之处在于：
- 直观的数据结构（Series和DataFrame）
- 丰富的数据操作（选择、过滤、分组、聚合）
- 强大的IO能力（支持多种数据格式）
- 与NumPy、Matplotlib等库无缝集成
- 高效处理大规模数据

