@[toc]

##  references

- [user guide](https://numpy.org/doc/stable/user/index.html)

- [numpy quickStart](https://numpy.org/doc/stable/user/quickstart.html)

  

##  基本概念

> numpy中,有以下基本概念

- 维(dimension)又被称作轴(axes)

- 轴有其长度值(该轴上的元素数目)

- 不同轴上的元素规格不同

- > - 一般的,简单的说,就是一个高维的元素(外层)中包含若干低维的元素
  >
  > - 低维度元素可以包含若干更低维度的元素
  >
  > - 最低维元素是基本元素(譬如一个整型值)
  >
  >   

## 学习大纲

- 创建ndarray对象
  - 特别是随机数据生成这一块
- 访问ndarray对象
- ndarray对象间的操作/运算/计算api



- ![image-20220618111123248](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220618111123248.png)

## The Basics

NumPy’s main object is the homogeneous multidimensional array. It is a table of elements (usually numbers), all of the same type, indexed by a tuple of non-negative integers. In NumPy dimensions are called *axes*.

- For example, the array for the coordinates of a point in 3D space, `[1, 2, 1]`, has one axis. 
  - That axis has 3 elements in it, so we say it has a length of 3.

-  In the example pictured below, the array has 2 axes. 
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

## 用于描述ndarray对象的一些属性

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

>the number of axes (dimensions) of the array.
>该属性描述了ndarry对象的阶数(维数的多少)

### ndarray.shape

>the dimensions of the array. 
>该属性描述矩阵各个维度(轴)的长度(size),能够较好体现ndarray的规格
>This is a tuple of integers indicating the size of the array in each dimension. 
>For a matrix with n rows and m columns, shape will be (n,m). The length of the shape tuple is therefore the number of axes, ndim.
>shape属性和ndim属性的关系是,len(shape)==ndim
>特殊的,当某个矩阵对象只有一维,那么`ndim==1` shape的取值由于是一个元组,单元素元组在括号内以一个`,`结尾

### ndarray.size

>the total number of elements of the array. This is equal to the product of the elements of shape.
>该属性描述了这个数组对象的大小(即有多少个最小基本元素),它的大小等于shape元组中各个值的乘积(可以用来粗略衡量一个矩阵的体量)

###  描述构成ndarray对象中的最基本元素的属性

#### ndarray.dtype

>an object describing the type of the elements in the array. 
>One can create or specify dtype’s using standard Python types. Additionally NumPy provides types of its own. numpy.int32, numpy.int16, and numpy.float64 are some examples.
>描述元素的类型

#### ndarray.itemsize

>the size in bytes of each element of the array. 
>For example, an array of elements of type float64 has itemsize 8 (=64/8), while one of type complex32 has itemsize 4 (=32/8). It is equivalent to ndarray.dtype.itemsize.
>描述元素的大小
>
>####  几乎不用的属性
- ndarray.data
>the buffer containing the actual elements of the array. 
>Normally, we won’t need to use this attribute because we will access the elements in an array using indexing facilities.

## 实例代码

```py
##
import numpy as np
a=np.array([1,2,3])


[
    [1., 0., 0.],
    [0., 1., 2.]
]

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

### 结果

![image-20220618100300449](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220618100300449.png)



## numpy&随机数

> Random sampling ([`numpy.random`](https://numpy.org/doc/stable/reference/random/index.html#module-numpy.random))

Numpy’s random number routines produce pseudo random numbers using combinations of a [`BitGenerator`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.BitGenerator.html#numpy.random.BitGenerator) to create sequences and a [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) to use those sequences to sample **from different statistical distributions**:

- BitGenerators: Objects that generate random numbers. These are typically unsigned integer words filled with sequences of either 32 or 64 random bits.
- Generators: Objects that transform sequences of random bits from a BitGenerator into sequences of numbers that follow a specific probability distribution (such as uniform, Normal or Binomial) within a specified interval.

Since Numpy version 1.17.0 the Generator can be initialized with a number of different BitGenerators. 

- It exposes many different probability distributions. See [NEP 19](https://www.numpy.org/neps/nep-0019-rng-policy.html) for context on the updated random Numpy number routines. 

- The legacy [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) random number routines are still available, but limited to a single BitGenerator. 

  - See [What’s New or Different](https://numpy.org/doc/stable/reference/random/new-or-different.html#new-or-different) for a complete list of improvements and differences from the legacy `RandomState`.

  - For convenience and backward compatibility, a single [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) instance’s methods are imported into the numpy.random namespace, see [Legacy Random Generation](https://numpy.org/doc/stable/reference/random/legacy.html#legacy) for the complete list.

## 随机数模块api文档

- [Random Generator — NumPy v1.22 Manual](https://numpy.org/doc/stable/reference/random/generator.html#simple-random-data)

### Random Generator

- The [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) provides access to a wide range of distributions, and served as a replacement for [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState). 
- The main difference between the two is that `Generator` relies on an additional BitGenerator to manage state and generate the random bits, which are then transformed into random values from useful distributions.
-  The default BitGenerator used by `Generator` is [`PCG64`](https://numpy.org/doc/stable/reference/random/bit_generators/pcg64.html#numpy.random.PCG64). 
- The BitGenerator can be changed by passing an instantized BitGenerator to `Generator`.

> rng:**r**a**n**dom-**g**enerator

###  随机数模块的基本使用

```py
#随机数模块
# 实例化一个默认的随机数产生器
rng=np.random.default_rng()
print("@rng:",rng)
##

rfloat=rng.random()
print("@rfloat:",rfloat)
##
rints = rng.integers(low=0, high=10, size=3)
print("@rints:",rints)
##
#产生随机数矩阵(shape=(3,3))
arr1 = rng.random((3, 3))
print("@arr1:\n",arr1)
##

arr2=rng.integers(low=-3, high=3, size=(3,4))
print("@arr2:\n",arr2)
##
arr3=rng.random((3,3))+10
print("@arr3:\n",arr3)
##
#生成0~10间的随机数
arr4=rng.random((3,3))*10
print("@arr4:\n",arr4)


## 
# 概率论&数理统计:符合泊松分布的数据集使用案例
import numpy as np
rng = np.random.default_rng()
s = rng.poisson(5, 10000)
import matplotlib.pyplot as plt
count, bins, ignored = plt.hist(s, 14, density=True)
plt.show()
```



#### Generator对象提供的api文档列表

- [numpy.random.Generator.bit_generator](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.bit_generator.html)
- [numpy.random.Generator.integers](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.integers.html)
- [numpy.random.Generator.random](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.random.html)
- [numpy.random.Generator.choice](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.choice.html)
- [numpy.random.Generator.bytes](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.bytes.html)
- [numpy.random.Generator.shuffle](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.shuffle.html)
- [numpy.random.Generator.permutation](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.permutation.html)
- [numpy.random.Generator.permuted](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.permuted.html)
- [numpy.random.Generator.beta](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.beta.html)
- [numpy.random.Generator.binomial](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.binomial.html)
- [numpy.random.Generator.chisquare](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.chisquare.html)
- [numpy.random.Generator.dirichlet](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.dirichlet.html)
- [numpy.random.Generator.exponential](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.exponential.html)
- [numpy.random.Generator.f](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.f.html)
- [numpy.random.Generator.gamma](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.gamma.html)
- [numpy.random.Generator.geometric](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.geometric.html)
- [numpy.random.Generator.gumbel](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.gumbel.html)
- [numpy.random.Generator.hypergeometric](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.hypergeometric.html)
- [numpy.random.Generator.laplace](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.laplace.html)
- [numpy.random.Generator.logistic](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.logistic.html)
- [numpy.random.Generator.lognormal](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.lognormal.html)
- [numpy.random.Generator.logseries](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.logseries.html)
- [numpy.random.Generator.multinomial](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.multinomial.html)
- [numpy.random.Generator.multivariate_hypergeometric](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.multivariate_hypergeometric.html)
- [numpy.random.Generator.multivariate_normal](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.multivariate_normal.html)
- [numpy.random.Generator.negative_binomial](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.negative_binomial.html)
- [numpy.random.Generator.noncentral_chisquare](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.noncentral_chisquare.html)
- [numpy.random.Generator.noncentral_f](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.noncentral_f.html)
- [numpy.random.Generator.normal](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.normal.html)
- [numpy.random.Generator.pareto](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.pareto.html)
- [numpy.random.Generator.poisson](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.poisson.html)
- [numpy.random.Generator.power](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.power.html)
- [numpy.random.Generator.rayleigh](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.rayleigh.html)
- [numpy.random.Generator.standard_cauchy](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.standard_cauchy.html)
- [numpy.random.Generator.standard_exponential](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.standard_exponential.html)
- [numpy.random.Generator.standard_gamma](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.standard_gamma.html)
- [numpy.random.Generator.standard_normal](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.standard_normal.html)
- [numpy.random.Generator.standard_t](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.standard_t.html)
- [numpy.random.Generator.triangular](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.triangular.html)
- [numpy.random.Generator.uniform](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.uniform.html)
- [numpy.random.Generator.vonmises](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.vonmises.html)
- [numpy.random.Generator.wald](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.wald.html)
- [numpy.random.Generator.weibull](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.weibull.html)
- [numpy.random.Generator.zipf](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.zipf.html)













