[toc]

## abstract

在 `pandas` 中，`axis` 是一个非常关键的参数，它决定了操作是在行（rows）还是列（columns）上进行。理解 `axis` 的含义对于正确使用 `pandas` 的函数和方法非常重要。

> 沿着轴(axis)的向量和轴垂直

## numpy中的轴axis

- [Glossary — NumPy Manual](https://numpy.org/doc/stable/glossary.html#term-axis)
- [术语表- NumPy  Manual --- Glossary — NumPy  Manual](https://numpy.org/doc/stable/glossary.html#term-along-an-axis)

### axis 轴编号

Another term for an array dimension. Axes are numbered left to right; axis 0 is the first element in the shape tuple.
数组维度的另一个术语。轴从左到右编号;轴0是形状元组中的第一个元素。

In a two-dimensional vector, the elements of axis 0 are rows and the elements of axis 1 are columns.
**在二维向量中，轴0(方向上)的元素是行，轴1的元素是列**。(先行向量,后列向量)

In higher dimensions, the picture changes. NumPy prints higher-dimensional vectors as replications of row-by-column building blocks, as in this three-dimensional vector:
在更高的维度中，情况发生了变化。NumPy 打印更高维度的向量作为逐列构建块的复制，如下面的三维向量：

```
a = np.arange(12).reshape(2,2,3)
a
array([[[ 0,  1,  2],
        [ 3,  4,  5]],
       [[ 6,  7,  8],
        [ 9, 10, 11]]])
```

`a` is depicted as a two-element array whose elements are 2x3 vectors. From this point of view, rows and columns are the final two axes, respectively, in any shape.
`A` 被描绘为两元素数组，其元素是 2 × 3 向量。从这个角度来看，行和列分别是任何形状中的最后两个轴。

This rule helps you anticipate how a vector will be printed, and conversely how to find the index of any of the printed elements. For instance, in the example, the last two values of 8’s index must be 0 and 2. Since 8 appears in the second of the two 2x3’s, the first index must be 1:
这个规则可以帮助你预测向量将如何打印，以及如何找到任何打印元素的索引。例如，在示例中，8 的索引的最后两个值必须是 0 和 2。因为 8 出现在两个 2x3 的第二个中，所以第一个索引必须是 1：

```
a[1,0,2]
8
```

A convenient way to count dimensions in a printed vector is to count `[` symbols after the open-parenthesis. This is useful in distinguishing, say, a (1,2,3) shape from a (2,3) shape:
在打印的向量中计算维数的一种方便方法是在开括号后计算 `[` 符号。这在区分（1，2，3）形状和（2，3）形状时很有用：

```
a = np.arange(6).reshape(2,3)
a.ndim
2
a
array([[0, 1, 2],
       [3, 4, 5]])
```

```
a = np.arange(6).reshape(1,2,3)
a.ndim
3
a
array([[[0, 1, 2],
        [3, 4, 5]]])
```



### along an axis 沿着轴

An operation along axis n of array a behaves as if its argument were an array of slices of a where each slice has a successive index of axis n.
沿着数组 a 的沿着轴 n 的操作表现得好像它的参数是 a 的切片数组，其中每个切片都有轴 n 的连续索引。

For example, if a is a 3 x N array, an operation along axis 0 behaves as if its argument were an array containing slices of each row:
例如，如果 a 是一个 3 xN 数组，则沿轴 0 的沿着操作的行为就像其参数是一个包含每行切片的数组：

`np.array((a[0,:], a[1,:], a[2,:]))` 
To make it concrete, we can pick the operation to be the array-reversal function numpy.flip, which accepts an axis argument. We construct a 3 x 4 array a:
具体来说，我们可以选择数组反转函数 numpy.flip，它接受一个轴参数。我们构造一个 3 x 4 的数组 a：

```
a = np.arange(12).reshape(3,4)
a
array([[ 0,  1,  2,  3],
       [ 4,  5,  6,  7],
       [ 8,  9, 10, 11]])
```

Reversing along axis 0 (the row axis) yields
沿着轴0（行轴）反转，

```
np.flip(a,axis=0)
array([[ 8,  9, 10, 11],
       [ 4,  5,  6,  7],
       [ 0,  1,  2,  3]])
```

Recalling the definition of along an axis, flip along axis 0 is treating its argument as if it were
回想一下沿着轴的定义，沿沿着轴 0 翻转将其参数视为

```
np.array((a[0,:], a[1,:], a[2,:]))
array([[ 0,  1,  2,  3],
       [ 4,  5,  6,  7],
       [ 8,  9, 10, 11]])
```

and the result of np.flip(a,axis=0) is to reverse the slices:
而 np.flip（a，axis=0） 的结果是反转切片：

```
np.array((a[2,:],a[1,:],a[0,:]))
array([[ 8,  9, 10, 11],
       [ 4,  5,  6,  7],
       [ 0,  1,  2,  3]])
```



---

## pandas中的axis

在 `pandas` 中，`axis` 参数用于指定操作的方向：

| axis 值  | 对应方向       | 含义                                 |
| -------- | -------------- | ------------------------------------ |
| `axis=0` | 行方向（默认） | 操作沿着行进行，**对每一列进行操作** |
| `axis=1` | 列方向         | 操作沿着列进行，对每一行进行操作     |

你可以这样记忆：

- **`axis=0`**：表示“垂直”方向，从上到下，逐列操作。
- **`axis=1`**：表示“水平”方向，从左到右，逐行操作。

---

## 🧠 二、通俗理解 axis

举个例子帮助理解：

```python
import pandas as pd
import numpy as np

df = pd.DataFrame({
    'A': [1, 2, 3],
    'B': [4, 5, 6]
})
```

输出：
```
   A  B
0  1  4
1  2  5
2  3  6
```

axis=0,表示逐列执行操作,沿着0号轴

axis=1,表示逐行执行操作

### 示例 1: 使用 `df.mean()`

```python
df.mean()
```

输出：
```
A    2.0
B    5.0
dtype: float64
```

这是默认 `axis=0`，意思是按列计算平均值（纵向），结果是每列的平均值。

如果设置为 `axis=1`：

```python
df.mean(axis=1)
```

输出：
```
0    2.5
1    3.5
2    4.5
dtype: float64
```

这表示按行计算平均值（横向），即每行中 A 和 B 的平均值。

---

## 🔍 三、常见用法与举例说明

以下是一些常用方法中 `axis` 的作用说明：

### 1. `drop()` 删除行或列

```python
# 删除列
df.drop('A', axis=1)

# 删除行
df.drop(0, axis=0)
```

### 2. `apply()` 应用函数

```python
# 对每列应用函数
df.apply(np.sum, axis=0)

# 对每行应用函数
df.apply(np.sum, axis=1)
```

### 3. `concat()` 合并 DataFrame

```python
df1 = pd.DataFrame({'A': [1, 2], 'B': [3, 4]})
df2 = pd.DataFrame({'A': [5, 6], 'B': [7, 8]})

# 纵向合并（上下拼接）
pd.concat([df1, df2], axis=0)

# 横向合并（左右拼接）
pd.concat([df1, df2], axis=1)
```

### 4. `sort_values()` 排序

```python
# 按某一行排序所有列
df.sort_values(by=0, axis=1)

# 按某一列排序所有行
df.sort_values(by='A', axis=0)
```

---

## 🎯 四、总结一句话口诀

> - `axis=0` → “对列做操作”，比如按列统计、删除某列；
> - `axis=1` → “对行做操作”，比如按行统计、删除某行。

或者记住这个经典说法：

> - **`axis=0` 表示 index 方向（向下）**
> - **`axis=1` 表示 column 方向（向右）**

---

## ✅ 五、小练习（加深理解）

给定如下 DataFrame：

```python
df = pd.DataFrame({
    'Math': [90, 85, 70],
    'English': [80, 75, 85],
    'Science': [95, 90, 80]
}, index=['Alice', 'Bob', 'Charlie'])
```

问题：

1. 如何计算每个学生的总分（按行求和）？
2. 如何计算每门课的平均分（按列求均值）？
3. 如何删除 "English" 这一列？
4. 如何删除 "Bob" 这一行？

```python
# 1. 按行求和
df.sum(axis=1)

# 2. 按列求均值
df.mean(axis=0)

# 3. 删除 English 列
df.drop('English', axis=1)

# 4. 删除 Bob 行
df.drop('Bob', axis=0)
```

---

