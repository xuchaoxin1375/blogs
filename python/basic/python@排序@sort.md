[toc]

#  python@内置的排序方法@sort@sorted@本文文件内容排序

- [Sorting HOW TO — Python documentation](https://docs.python.org/3/howto/sorting.html)

## 1. 列表的 `sort()` 方法

Python 中的列表（list）对象自带一个 `sort()` 方法，可以对列表进行排序。默认情况下，`sort()` 方法会按照升序（从小到大）的顺序对列表进行排序，例如：

```python
a = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
a.sort()
print(a)
```

输出结果为：

```
[1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9]
```

如果需要按照降序（从大到小）的顺序对列表进行排序，可以使用 `sort()` 方法的 `reverse` 参数，例如：

```python
a = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
a.sort(reverse=True)
print(a)
```

输出结果为：

```
[9, 6, 5, 5, 5, 4, 3, 3, 2, 1, 1]
```

### 返回值为None

- Sort the list in ascending order and ==**return None.**==

  The sort is in-place (i.e. the list itself is modified) and stable (i.e. the order of two equal elements is maintained).

  If a key function is given, apply it once to each list item and sort them, ascending or descending, according to their function values.

  The reverse flag can be set to sort in descending order.


  ```python
  >>> a=[4,5,0]
  >>> print(a.sort())     
  None
  >>> print(a)
  [0, 4, 5]
  >>> b=a
  >>> print(b)
  [0, 4, 5]
  >>> b=a.sort() 
  >>> print(b)
  None
  
  
  ```

  - Python 中有多种排序方法可供选择，下面介绍其中三种常用的排序方法。

## 2. `sorted()` 函数

- [Built-in Functions — Python  documentation](https://docs.python.org/3/library/functions.html#sorted)

`sorted()` 是 Python 内置的一个函数，可以对任意可迭代对象进行排序，例如：

```python
a = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
b = sorted(a)
print(b)
```

输出结果为：

```
[1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9]
```

`sorted()` 函数还可以接受一个 `reverse` 参数，用于控制排序顺序。

##  使用 `key` 参数进行排序

有时候，我们需要按照某种特定的方式对列表进行排序，而不是按照默认的升序或降序排序。在这种情况下，可以使用 `sort()` 方法或 `sorted()` 函数的 `key` 参数，指定一个函数来计算每个元素的排序键（即一个可比较的对象），例如：

```python
words = ['banana', 'apple', 'cherry', 'date']
words.sort(key=len)
print(words)
```

输出结果为：

```
['date', 'apple', 'cherry', 'banana']
```

在上面的示例中，我们使用 `key` 参数指定了一个函数 `len`，该函数返回每个字符串的长度。`sort()` 方法会根据每个字符串的长度来进行排序，从而得到按照字符串长度升序排序的结果。

同样，在使用 `sorted()` 函数时，也可以使用 `key` 参数进行排序。例如：

```python
words = ['banana', 'apple', 'cherry', 'date']
sorted_words = sorted(words, key=len)
print(sorted_words)
```

输出结果为：

```
['date', 'apple', 'cherry', 'banana']
```

在这种方式下，`sorted()` 函数返回排序后的新列表，而不会修改原始列表。

## 小结

- 在 Python 中，可以调用 `.sort()` 方法的对象包括以下几种：
  1. 列表（list）：列表是 Python 中常用的数据类型，可以存储多个元素，支持索引和切片操作。列表对象自带一个 `.sort()` 方法，用于对列表进行排序。
  2. 字符串（str）：字符串是 Python 中不可变的序列类型，可以看作是由字符组成的列表。字符串对象也可以调用 `.sort()` 方法进行排序，但它实际上并不会改变原始字符串，而是返回排序后的新字符串。
  3. 元组（tuple）：元组是 Python 中不可变的序列类型，它和列表类似，但元组中的元素不可修改。元组对象没有自带的 `.sort()` 方法，但可以使用内置函数 `sorted()` 对元组进行排序，它会返回排序后的新元组。
  4. 集合（set）：集合是 Python 中的一种无序容器类型，它可以存储多个不重复的元素。集合对象自带一个 `.sort()` 方法，用于对集合进行排序，但它实际上并不会改变原始集合，而是返回排序后的新集合。
  5. 字典（dict）：字典是 Python 中的一种映射类型，它可以将键映射到值。字典对象没有自带的 `.sort()` 方法，但可以使用内置函数 `sorted()` 对字典进行排序，它会返回排序后的键或键值对的列表。
- 需要注意的是，以上对象中只有列表和集合是可变对象，它们可以直接修改排序后的结果。
- 而字符串、元组和字典是不可变对象，它们的排序结果必须赋值给一个新变量才能使用。此外，调用 `.sort()` 方法或使用 `sorted()` 函数时，需要确保元素是可比较的，否则会抛出 `TypeError` 异常。

#  problem eg:
本文文件“info_stocks.txt”中每一行的name对应股票名称，shares对应多少股，price对应该只股票的单价。
    (a) 请计算每只股票的总价，并按总价从大到小进行排序(程序中要求含lambda函数) ，将所有股票的名称、单价、总价依次打印输出。
    (b) 要求使用Python内置函数filter过滤出单价大于80的股票有哪些? 并将符合条件的股票名称、单价、总价打印输出。

## code:

```python

f = open(path_string_fix+"info_stocks.txt", "r")
ls = []
for line in f:
    ls.append(line.strip("\n").split(","))
f.close()
""" test the read result: """
# print(ls)

""" sum the price: """

def calculate_index(list_element):
    shares = int(list_element[1].split(":")[1])
    price = float(list_element[2].split(":")[1])
    sum_price = shares*price
    return sum_price

# 排序用例1
ls.sort(key=lambda list_element: calculate_index(list_element), reverse=True)


def print_iterable(iterable):
     for list_element in iterable:
        for i in [0, 2]:
            """ to make the print format tidily each column,we specify a width for the middle column: """
            print(list_element[i].strip().ljust(20), end=" ")
        print("sum_price="+str(calculate_index(list_element)))

# print(ls)


def print_sort_result(ls):
    print("\nthe sorted result:")
    print_iterable(ls)
        
            
#filter用例
filter_ls=filter(lambda list:float(list[2].split(":")[1])>80,ls)

def print_filter_result(filter_ls):
    print("\nthe filtered result:")
    print_iterable(filter_ls)
    # for list_element in filter_ls:
    #     for i in [0,2]:
    #         print(list_element[i].strip(),end=" ")
    #     print("sum_price=%s"%calculate_index(list_element))
        
print_sort_result(ls)
print_filter_result(filter_ls)

```
##  the file:"info_stocks.txt"
```json
'name': 'IBM', 'shares': 100, 'price': 91.1
'name': 'AAPL', 'shares': 50, 'price': 543.22
'name': 'FB', 'shares': 200, 'price': 21.09
'name': 'HPQ', 'shares': 35, 'price': 31.75
'name': 'YHOO', 'shares': 45, 'price': 16.35
'name': 'ACME', 'shares': 75, 'price': 115.65
```

##  result:

```bash

the sorted result:
'name': 'AAPL'       'price': 543.22      sum_price=27161.0
'name': 'IBM'        'price': 91.1        sum_price=9110.0
'name': 'ACME'       'price': 115.65      sum_price=8673.75
'name': 'FB'         'price': 21.09       sum_price=4218.0
'name': 'HPQ'        'price': 31.75       sum_price=1111.25
'name': 'YHOO'       'price': 16.35       sum_price=735.7500000000001

the filtered result:
'name': 'AAPL'       'price': 543.22      sum_price=27161.0
'name': 'IBM'        'price': 91.1        sum_price=9110.0
'name': 'ACME'       'price': 115.65      sum_price=8673.75
```