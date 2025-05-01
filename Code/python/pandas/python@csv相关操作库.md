[toc]

## abstract

[csv --- CSV 文件读写 — Python  文档](https://docs.python.org/zh-cn/3.13/library/csv.html)~

在 Python 中，处理 CSV 文件主要依赖于内置的 `csv` 模块以及一些第三方库（如 `pandas`）。以下是这些模块的核心用法和功能介绍：

---

## 1. **`csv` 模块**
`csv` 是 Python 内置的标准库模块，用于读取和写入 CSV 文件。它提供了灵活的接口来处理不同格式的 CSV 数据。

### 核心功能
#### (1) **读取 CSV 文件**
使用 `csv.reader` 或 `csv.DictReader` 读取 CSV 文件。

```python
import csv

# 使用 csv.reader
with open('example.csv', mode='r', encoding='utf-8') as file:
    reader = csv.reader(file)
    for row in reader:
        print(row)  # 每行是一个列表

# 使用 csv.DictReader
with open('example.csv', mode='r', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    for row in reader:
        print(row)  # 每行是一个字典，键为列名
```

#### (2) **写入 CSV 文件**
使用 `csv.writer` 或 `csv.DictWriter` 写入 CSV 文件。

```python
import csv

# 使用 csv.writer,header不做特殊对待,这种方法比较简洁
data = [['Name', 'Age'], ['Alice', 30], ['Bob', 25]]
#先建立普通文件写入流,在传递给csv.writer方法保证为csv文件写入流,最后将每一行(列表)数据写入文件
with open('output.csv', mode='w', encoding='utf-8', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(data)

# 使用 csv.DictWriter
# 这种用法分为两部分:header和rows;
# 仍然是先建立普通写入流,然后传入表头字段列表给csv.DictWriter,分被写入表头和普通数据行
fieldnames = ['Name', 'Age']
data = [{'Name': 'Alice', 'Age': 30}, {'Name': 'Bob', 'Age': 25}]
with open('output.csv', mode='w', encoding='utf-8', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()  # 写入表头
    writer.writerows(data)
```

小结,两种方法类似,流处理的开头和结尾基本一样,中间过程有所区别,因为第二中方式要处理表头,尤其是writeheader()方法

对于第二种方式,fieldnames中定义的表头名字是数据行(data)中各个字典的key-value中key的取值依据,如果某个字典的key在fieldnames中找不到,那么会抛出异常

#### (3) **自定义分隔符或引号**

可以通过 `delimiter` 和 `quotechar` 参数指定分隔符和引用字符。

```python
with open('example.csv', mode='r', encoding='utf-8') as file:
    reader = csv.reader(file, delimiter=';', quotechar='"')
    for row in reader:
        print(row)
```

---

## 2. **`pandas` 库**
`pandas` 是一个强大的数据处理库，特别适合处理表格数据，包括 CSV 文件。它提供了更高级的接口，操作更加简洁。

### 核心功能
#### (1) **读取 CSV 文件**
使用 `pandas.read_csv` 方法读取 CSV 文件。

```python
import pandas as pd

# 读取 CSV 文件
df = pd.read_csv('example.csv')

# 查看前几行
print(df.head())
```

#### (2) **写入 CSV 文件**
使用 `DataFrame.to_csv` 方法将数据写入 CSV 文件。

```python
import pandas as pd

# 创建 DataFrame
data = {'Name': ['Alice', 'Bob'], 'Age': [30, 25]}
df = pd.DataFrame(data)

# 写入 CSV 文件
df.to_csv('output.csv', index=False)  # 不保存索引
```

#### (3) **处理缺失值**
`pandas` 提供了丰富的工具来处理缺失值。

```python
# 填充缺失值
df.fillna(0, inplace=True)

# 删除包含缺失值的行
df.dropna(inplace=True)
```

#### (4) **数据筛选与操作**
可以轻松地对数据进行筛选、排序、分组等操作。

```python
# 筛选 Age 大于 20 的行
filtered_df = df[df['Age'] > 20]

# 按 Name 列排序
sorted_df = df.sort_values(by='Name')

# 分组统计
grouped = df.groupby('Name').mean()
```

---

## 3. **其他相关模块**
除了 `csv` 和 `pandas`，还有一些其他库可用于特定场景的 CSV 处理。

### (1) **`openpyxl`**
主要用于处理 Excel 文件，但也可以通过导出/导入 CSV 文件间接处理。

### (2) **`numpy`**
如果需要将 CSV 数据转换为数组形式，可以结合 `numpy` 使用。

```python
import numpy as np

# 将 CSV 转换为 NumPy 数组
data = np.genfromtxt('example.csv', delimiter=',', dtype=None, names=True)
print(data)
```

---

## 总结
- **`csv` 模块**：适合简单的 CSV 文件处理，轻量级。
- **`pandas` 库**：功能强大，适合复杂的数据分析任务。
- **其他库**：根据具体需求选择合适的工具。

## 读取指定列

在 Python 中，如果你需要 **读取 CSV 文件中的指定列**，可以使用内置的 `csv` 模块或更强大的第三方库如 `pandas`。下

---

## ✅ 方法一：使用 `csv` 模块（标准库）

适用于小型文件、轻量级处理。

### 📝 示例代码

```python
import csv

# 打开 CSV 文件
with open('data.csv', mode='r', encoding='utf-8') as file:
    reader = csv.reader(file)
    
    # 获取表头（第一行）
    headers = next(reader)
    
    # 假设我们想读取 'Name' 和 'Age' 两列
    name_index = headers.index('Name')
    age_index = headers.index('Age')

    for row in reader:
        print(f"姓名: {row[name_index]}, 年龄: {row[age_index]}")
```

### 📄 假设你的 `data.csv` 内容如下：

```csv
Name,Age,Gender,City
Alice,30,Female,New York
Bob,25,Male,San Francisco
Charlie,35,Female,Los Angeles
```

### 🔍 输出结果：

```
姓名: Alice, 年龄: 30
姓名: Bob, 年龄: 25
姓名: Charlie, 年龄: 35
```

---

## ✅ 方法二：使用 `pandas`（推荐用于数据分析）

适合大数据量、结构化数据操作。

### 📦 安装 pandas（如果尚未安装）：

```bash
pip install pandas
```

### 📝 示例代码

```python
import pandas as pd

# 读取整个 CSV 文件
df = pd.read_csv('data.csv')

# 提取指定列
selected_columns = df[['Name', 'Age']]

# 打印前几行
print(selected_columns.head())
```

### 🔍 输出结果（表格形式）：

```
      Name  Age
0    Alice   30
1      Bob   25
2  Charlie   35
```

### 🧠 更灵活的方式：只加载你需要的列

```python
# 只读取指定列，节省内存
df = pd.read_csv('data.csv', usecols=['Name', 'Age'])
print(df)
```

---

## ✅ 方法三：使用 `csv.DictReader`（按列名访问）

适用于你希望以字典形式访问每一行的情况。

### 📝 示例代码

```python
import csv

with open('data.csv', mode='r', encoding='utf-8') as file:
    reader = csv.DictReader(file)

    for row in reader:
        print(f"姓名: {row['Name']}, 年龄: {row['Age']}")
```

---

## 🧩 小技巧：读取多列 + 多条件过滤

比如你想读取所有年龄大于 30 的人：

```python
import pandas as pd

df = pd.read_csv('data.csv')
filtered = df[df['Age'] > 30][['Name', 'Age']]
print(filtered)
```

输出：

```
      Name  Age
2  Charlie   35
```

---

## 📌 总结对比

| 方法             | 是否推荐       | 特点                             |
| ---------------- | -------------- | -------------------------------- |
| `csv.reader`     | ✅ 简单脚本可用 | 轻量、无依赖、需手动索引列       |
| `csv.DictReader` | ✅ 易读性强     | 行为字典形式，便于按列名访问     |
| `pandas`         | ✅ 推荐         | 功能强大、语法简洁、支持复杂操作 |

---

