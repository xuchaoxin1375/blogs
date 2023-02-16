[toc]



##  refs🎈

- [user guide](https://numpy.org/doc/stable/user/index.html)
  - [NumPy: the absolute basics for beginners — NumPy v1.24 Manual](https://numpy.org/doc/stable/user/absolute_beginners.html)
    - 最基础的入门文档

  - [numpy quickStart](https://numpy.org/doc/stable/user/quickstart.html)
    - 快速入门文档
    - FUNDAMENTALS AND USAGE
      - [Array creation](https://numpy.org/doc/stable/user/basics.creation.html)
      - [Indexing on `ndarrays`](https://numpy.org/doc/stable/user/basics.indexing.html#)
      - [I/O with NumPy](https://numpy.org/doc/stable/user/basics.io.html)
      - [Data types](https://numpy.org/doc/stable/user/basics.types.html)
      - [Broadcasting](https://numpy.org/doc/stable/user/basics.broadcasting.html)
      - [Copies and views](https://numpy.org/doc/stable/user/basics.copies.html)
      - [Structured arrays](https://numpy.org/doc/stable/user/basics.rec.html)
      - [Universal functions ( `ufunc `) basics](https://numpy.org/doc/stable/user/basics.ufuncs.html)


### 学习大纲🎈

- ![image-20220618111123248](https://img-blog.csdnimg.cn/img_convert/e80f01f1c552744cc2dd6b6b7f21789b.png)



##  基本概念

###  The Basics concepts

- NumPy’s main object is the homogeneous multidimensional array. It is a table of elements (usually numbers), all of the same type, indexed by a tuple of non-negative integers. In NumPy **dimensions** are called *axes*.


- For example, the array for the coordinates of a point in 3D space, `[1, 2, 1]`, has one axis. 
  - That axis has 3 elements in it, so we say it has a length of 3.

- In the example pictured below, the array has 2 axes. 
  - The first axis has a length of 2, 
  - the second axis has a length of 3.

```py
[[1., 0., 0.],
 [0., 1., 2.]]
```

- NumPy’s array class is called `ndarray`. 
- It is also known by the alias `array`. 
- Note that `numpy.array` is not the same as the Standard Python Library class `array.array`, 
  - which only handles one-dimensional arrays and offers less functionality. 

### 轴&维度概念图

| ![在这里插入图片描述](https://img-blog.csdnimg.cn/e3b7f4a070e040bdb639c665cf1439a8.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/f5501b8bc5834ae5b12cd78ddf9a20e9.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |

### axis

- $$
  A=\begin{pmatrix}
  	a_{1,1}  &a_{1,2}  &\cdots  &a_{1,n}  	\\
  	a_{2,1}  &a_{2,2}  &\cdots  &a_{2,n}  	\\
  	\vdots  &\vdots  &        &\vdots  	\\
  	a_{m,1}  &a_{m,2}  &\cdots  &a_{m,n}  	\\
  \end{pmatrix}
  $$

  - 一个二维数组(矩阵)

- Axes are numbered left to right; 
  - **axis 0** is **the first element in <u>the shape tuple</u>**.(描述最高维度的元素)

- In a two-dimensional vector, 
  - **the elements of axis 0 are rows** and 
  - **the elements of axis 1 are columns**.
  - 0轴上的每个元素表示行
  - 1轴上的元素表示列
  - 每个行由若干个基本元素构成
  - 基本元素位置由表示行号和列号构成的有序数对确定

- 例

  - 例如矩阵A中的每个元素的下表,由两个数字构成(比如$a_{ij}$)
    - 第一个值$i$是`axis 0`轴上的坐标(指出元素是哪一行)
    - 第二个值$j$是轴`axis 1`的坐标,指出元素在哪一列

- In higher dimensions, the picture <u>changes</u>. 

  - NumPy prints higher-dimensional vectors as **replications** of **row-by-column** building blocks, as in this three-dimensional vector:

  - ```py
    >>> a = np.arange(12).reshape(2,2,3)
    >>> a
    array([[[ 0,  1,  2],
            [ 3,  4,  5]],
           [[ 6,  7,  8],
            [ 9, 10, 11]]])
    >>> b = np.arange(24).reshape(4,3,2)
    >>> b
    array([[[ 0,  1],
            [ 2,  3],
            [ 4,  5]],
    
           [[ 6,  7],
            [ 8,  9],
            [10, 11]],
    
           [[12, 13],
            [14, 15],
            [16, 17]],
    
           [[18, 19],
            [20, 21],
            [22, 23]]])
    ```
    
    
    
  - `a` is depicted as a two-element array **whose elements are 2x3 vectors**. 
  - From this point of view, <u>rows and columns are the final two axes</u>, respectively, in any shape.

  - This rule helps you **anticipate** how a vector will be **printed**, and conversely how to find the index of any of the printed elements. 
  - For instance, in the example, the last two values of 8’s index must be 0 and 2. 
  - Since 8 appears in the second of the two 2x3’s, the first index must be 1:

  - ```py
    >>> a[1,0,2]
    8
    ```

- A convenient way to count dimensions in a printed vector is to count `[` symbols after the open-parenthesis. This is useful in distinguishing, say, a (1,2,3) shape from a (2,3) shape:

- ```py
  >>> a = np.arange(6).reshape(2,3)
  >>> a.ndim
  2
  >>> a
  array([[0, 1, 2],
         [3, 4, 5]])
  >>> a = np.arange(6).reshape(1,2,3)
  >>> a.ndim
  3
  >>> a
  array([[[0, 1, 2],
          [3, 4, 5]]])
  ```




- ```py
  a = np.arange(6).reshape(1,1,2,3)
  ```

  ```
  array([[[[0, 1, 2],
           [3, 4, 5]]]])
  ```

  - 怎么重组都可以,只要保证乘积一致(这里总是等于6)



##  多维数组和高维点🎈

###  experiment code

```python
import numpy as np
a = np.array([[[1, 2, 3],
               [11, 3, 4]],
              [[1, 2, 3],
               [11, 3, 4]]])

# %%
# 打印出a的维度数(即嵌套深度)
# 高维数组:嵌套深
print(a.ndim)
print(a.shape)
# 高维点:单个点的坐标的刻画维度多(可以用一个n元组表达)(d0,d1,d2,d3,d4,..dn-1):
''' 
例如:
一维点:(d0)
二维点:(d0,d1)
三维点:(d0,d1,d2):例如(1,2,3),(x=1,y=2,z=3)
...
总之,要区分好两种"维度"的含义
ndarray(多维度数组)对象的shape属性可以体现该数组在各个维度上的度量宽度
    '''
b = np.array(
    [1, 2, 3, 4, 5, 6]
    )
print(b.ndim, "\n", b.shape)

# %%
ls=range(120)
c=np.array(ls).reshape(2,2,5,3,2)
print(c)
#shape元组中的各个元素的乘积值为ndarray对象包含的元素的总数,例如这里2*2*5*3*2=120
# %%

```

### shape元组

- shape元组$(n_1,n_2,\cdots,n_k)$描述的是一个k维数组,各维的跨度分别是$n_1,n_2,\cdots,n_k$
  - 其中的各个元素的乘积值$S=\prod\limits_{i=1}^{k}n_i$为ndarray对象包含的元素的总数

- 比如某个5维数组M的规格为:shape=(10,2,5,3,2)
  - shape[-1]=2,(元组的最后一个值是2),则最深层的一维数组有2个基础元素(0维元素)
  - shape[-2]=3,则次深的数组(二维数组)是由3个上述规格(2,)的一维数组构成的二维数组
  - 依次类推.
  - shape[0]=10表示有10个规格为(2,5,3,2)的四维数组
- 同时,我们可以为shape元组按"权"来理解
  - 像理解十进制数中的个十百千万...那样
  - 这些权(权表示基本元素的个数,权越大,对应的元素个数也多)
  - 但有些不同,这些权之间的倍率关系取决于具体的shape元组),$n_i$相对于$n_{i+1}$是高位
  - shape元组的元素数和其描述的n为数组的最高中括号重数一致
```python
(2,2,5,3,2)
[[[[[  0   1]
    [  2   3]
    [  4   5]]

   [[  6   7]
    [  8   9]
    [ 10  11]]

   [[ 12  13]
    [ 14  15]
    [ 16  17]]

   [[ 18  19]
    [ 20  21]
    [ 22  23]]

   [[ 24  25]
    [ 26  27]
    [ 28  29]]]


  [[[ 30  31]
    [ 32  33]
    [ 34  35]]

   [[ 36  37]
    [ 38  39]
    [ 40  41]]

   [[ 42  43]
    [ 44  45]
    [ 46  47]]

   [[ 48  49]
    [ 50  51]
    [ 52  53]]

   [[ 54  55]
    [ 56  57]
    [ 58  59]]]]

 [[[[ 60  61]
    [ 62  63]
    [ 64  65]]

   [[ 66  67]
    [ 68  69]
    [ 70  71]]

   [[ 72  73]
    [ 74  75]
    [ 76  77]]

   [[ 78  79]
    [ 80  81]
    [100 101]]

   [[102 103]
    [104 105]
    [106 107]]

   [[108 109]
    [110 111]
    [112 113]]

   [[114 115]
    [116 117]
    [118 119]]]]]
```
###  一维数组和n行1列数组

- ```python
  import numpy as np
  
  a=np.array([1,2,3])
  b=np.array([[1],[2],[3]])
  print(f'a={a},a.shape={a.shape}')
  print(f'b={b},b.shape={b.shape}')
  ```

- ```bash
  a=[1 2 3],a.shape=(3,)
  b=[[1]
   [2]
   [3]],b.shape=(3, 1)
  ```

- 这两种是不同规格的ndarray,从shape值也可以看出

## 用于描述ndarray对象的一些属性🎈

- The more important attributes of an `ndarray` object are:

  - ndarray.ndim
    - the number of axes (dimensions) of the array.

  - ndarray.shape
    - the dimensions of the array. This is a tuple of integers indicating the size of the array in each dimension. For a matrix with *n* rows and *m* columns, `shape` will be `(n,m)`. The length of the `shape` tuple is therefore the number of axes, `ndim`.

  - ndarray.size
    - the total number of elements of the array. This is equal to the product of the elements of `shape`.

  - ndarray.dtype
    - an object describing the type of the elements in the array. One can create or specify dtype’s using standard Python types. Additionally NumPy provides types of its own. numpy.int32, numpy.int16, and numpy.float64 are some examples.

  - ndarray.itemsize
    - the size in bytes of each element of the array. For example, an array of elements of type `float64` has `itemsize` 8 (=64/8), while one of type `complex32` has `itemsize` 4 (=32/8). It is equivalent to `ndarray.dtype.itemsize`.

  - ndarray.data
    - the buffer containing the actual elements of the array. Normally, we won’t need to use this attribute because we will access the elements in an array using indexing facilities.



### ndarray.ndim

- the number of axes (dimensions) of the array.
- 该属性描述了ndarry对象的阶数(维数的多少)

### ndarray.shape

- the dimensions of the array. 
- 该属性描述矩阵各个维度(轴)的长度(size),能够较好体现ndarray的规格
- This is a tuple of integers indicating the size of the array in each dimension. 
- For a matrix with n rows and m columns, shape will be (n,m). The length of the shape tuple is therefore the number of axes, ndim.
- shape属性和ndim属性的关系是,len(shape)==ndim
- 特殊的,当某个矩阵对象只有一维,那么`ndim==1` shape的取值由于是一个元组,单元素元组在括号内以一个`,`结尾

### ndarray.size

- the total number of elements of the array. This is equal to the product of the elements of shape.

- 该属性描述了这个数组对象的大小(即有多少个最小基本元素),它的大小等于shape元组中各个值的乘积(可以用来粗略衡量一个矩阵的体量)

###  描述构成ndarray对象中的最基本元素的属性

#### ndarray.dtype

- an object describing the type of the elements in the array. 
- One can create or specify dtype’s using standard Python types. Additionally NumPy provides types of its own. numpy.int32, numpy.int16, and numpy.float64 are some examples.
- 描述元素的类型

#### ndarray.itemsize

- the size in bytes of each element of the array. 
- For example, an array of elements of type float64 has itemsize 8 (=64/8), while one of type complex32 has itemsize 4 (=32/8). It is equivalent to ndarray.dtype.itemsize.
- 描述元素的大小

####  几乎不用的属性

- ndarray.data

- the buffer containing the actual elements of the array. 
- Normally, we won’t need to use this attribute because we will access the elements in an array using indexing facilities.

## 实例代码

```py
##
import numpy as np
a=np.array([1,2,3])

# 两个包含基本元素的向量a1,a2 
a1=[1,0,0]
a2=[1,0,0]
#最外层的向量维度,包含两个元素a1,a2;其中a1,a2又都是一个包含三个基本元素的向量
nd_list=[a1,a2]
# 将以上组织结构实例化一个相对应的numpy的ndarray对象
nd=np.array(nd_list)
print("@nd:\n",nd)
print("@nd.shape:",nd.shape)
print("@nd.dtype:",nd.dtype)
##
b1=[1,2]
b2=[3,4]
b3=[5,6]
nd2_list=[b1,b2,b3]
nd2=np.array(nd2_list)
print("@nd:\n",nd2)
print("@nd.shape:",nd2.shape)
print("@nd.dtype:",nd2.dtype)
# 同等体量(包含相同基本元素的向量,正如nd.size属性所指示的那样)的ndarray经过不同的组织,可以得到不同的规格的ndarray
print("@nd.size",nd.size)
print("@nd2:",nd2.size)

##
print(a)
##
b=np.array([[1,3,4],[1,2,3]])


```

- output:

  - ```bash
    (base) PS D:\repos\PythonLearn>  py tmp.py
    @nd:
     [[1 0 0]
     [1 0 0]]
    @nd.shape: (2, 3)
    @nd.dtype: int32
    @nd:
     [[1 2]
     [3 4]
     [5 6]]
    @nd.shape: (3, 2)
    @nd.dtype: int32
    @nd.size 6
    @nd2: 6
    [1 2 3]
    ```

    
