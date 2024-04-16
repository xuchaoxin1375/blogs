[toc]


# numpy/pandas@series/dataframe/ndarray之间的简单转换

##  code:

- ```python
  import pandas as pd
  import numpy as np
  ''' 得到dataframe '''
  df1 = pd.DataFrame({'left': ['foo', 'bar']})
  df2 = pd.DataFrame({'left': [7, 8]})
  print(f"df1:\n{df1}\ndf1.type:{type(df1)}")
  # test=df1.merge(df2, how='cross')
  ''' 尝试合并列: '''
  test_df=pd.concat([df1,df2])
  print(f"test_df:\n{test_df}\ntype(test_df):{type(test_df)}")
  
  ''' 得到ndarray '''
  test_nd=np.array(test_df)
  print(f"test_nd:\n{test_nd}\ntest_nd.shape:{test_nd.shape}\ntype(test_nd):{type(test_nd)}")
  ''' 得到series: '''
  test_series=pd.Series({"a":2,"t":6})
  print(f"test_series:\n{test_series}\ntype(test_series):{type(test_series)}")
  ''' 得到一维ndarray '''
  test_nd=np.array(test_series)
  
  print(f"test_nd:\n{test_nd}\ntype(test_nd):{type(test_nd)}\ntest_nd.shape:{test_nd.shape}")
  ''' 得到二维ndarray: '''
  # test_nd2=np.array([test_nd])
  test_nd2=test_nd.reshape(test_nd.shape[0],1)
  print(f"test_nd2,test_nd2.shape:\n{test_nd2};\n{test_nd2.shape}")
  ```

##  the result:
- ```bash
  (base) PS D:\repos\PythonLearn\scripts>  py theSnippetYourSelectToRun.py                                                               
  df1:                                                                                                                                   
    left                                                                                                                                 
  0  foo                                                                                                                                 
  1  bar                                                                                                                                 
  df1.type:<class 'pandas.core.frame.DataFrame'>
  test_df:
    left
  0  foo
  1  bar
  0    7
  1    8
  type(test_df):<class 'pandas.core.frame.DataFrame'>
  test_nd:
  [['foo']
   ['bar']
   [7]
   [8]]
  test_nd.shape:(4, 1)
  type(test_nd):<class 'numpy.ndarray'>
  test_series:
  a    2
  t    6
  dtype: int64
  type(test_series):<class 'pandas.core.series.Series'>
  test_nd:
  [2 6]
  type(test_nd):<class 'numpy.ndarray'>
  test_nd.shape:(2,)
  test_nd2,test_nd2.shape:
  [[2]
   [6]];
  (2, 1)
  (base) PS D:\repos\PythonLearn\scripts> 
  ```

  ## numpy@dtype
  
  - [numpy.array — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/generated/numpy.array.html)
  
  - Data type objects ([`dtype`](https://numpy.org/doc/stable/reference/generated/numpy.dtype.html#numpy.dtype))
  
  - A data type object (an instance of [`numpy.dtype`](https://numpy.org/doc/stable/reference/generated/numpy.dtype.html#numpy.dtype) class) describes how <u>the bytes in the fixed-size block of memory</u> corresponding to an array item should be interpreted. 
  - It describes the following **aspects** of the data:
    1. **Type** of the data (integer, float, Python object, etc.)
    2. **Size** of the data (how many bytes is in *e.g.* the integer)
    3. **Byte order** of the data ([little-endian](https://numpy.org/doc/stable/glossary.html#term-little-endian) or [big-endian](https://numpy.org/doc/stable/glossary.html#term-big-endian))
    4. If the data type is [structured data type](https://numpy.org/doc/stable/glossary.html#term-structured-data-type), an aggregate of other data types, (*e.g.*, describing an array item consisting of an integer and a float),
       1. what are the names of the “[fields](https://numpy.org/doc/stable/glossary.html#term-field)” of the structure, by which they can be [accessed](https://numpy.org/doc/stable/user/basics.indexing.html#arrays-indexing-fields),
       2. what is the data-type of each [field](https://numpy.org/doc/stable/glossary.html#term-field), and
       3. which part of the memory block each field takes.
    5. If the data type is a sub-array, what is its shape and data type.
  - To describe the type of scalar data, there are several [built-in scalar types](https://numpy.org/doc/stable/reference/arrays.scalars.html#arrays-scalars-built-in) in NumPy for various precision of integers, floating-point numbers, *etc*. An item extracted from an array, *e.g.*, by indexing, will be a Python object whose type is the scalar type associated with the data type of the array.
  
  - Note that the scalar types are not [`dtype`](https://numpy.org/doc/stable/reference/generated/numpy.dtype.html#numpy.dtype) objects, even though they can be used in place of one whenever a data type specification is needed in NumPy.
  
  - Structured data types are formed by creating a data type whose [field](https://numpy.org/doc/stable/glossary.html#term-field) contain other data types. Each field has a name by which it can be [accessed](https://numpy.org/doc/stable/user/basics.indexing.html#arrays-indexing-fields). The parent data type should be of sufficient size to contain all its fields; the parent is nearly always based on the [`void`](https://numpy.org/doc/stable/reference/arrays.scalars.html#numpy.void) type which allows an arbitrary item size. Structured data types may also contain nested structured sub-array data types in their fields.
  
  - Finally, a data type can describe items that are themselves arrays of items of another data type. These sub-arrays must, however, be of a fixed size.
  
  - If an array is created using a data-type describing a sub-array, the dimensions of the sub-array are appended to the shape of the array when the array is created. Sub-arrays in a field of a structured type behave differently, see [Field access](https://numpy.org/doc/stable/user/basics.indexing.html#arrays-indexing-fields).
  
  - Sub-arrays always have a C-contiguous memory layout.

##  argsort():

- [numpy.argsort — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/generated/numpy.argsort.html)
- argsort()得到的序列是由待排数组的元素的索引构成的,将待排序数组中的元素按照argsort()的结果引导放置,就会得到一个有序的数组了

