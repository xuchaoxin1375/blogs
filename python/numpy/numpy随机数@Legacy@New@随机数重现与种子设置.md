[toc]

# numpy&随机数🎈

## 随机数模块api文档

- [Random sampling (numpy.random) — NumPy  Manual](https://numpy.org/doc/stable/reference/random/index.html)
  - [Random Generator — NumPy  Manual](https://numpy.org/doc/stable/reference/random/generator.html#simple-random-data)

## Quick Start

- Call [`default_rng`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.default_rng) to get a new instance of a [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator), then call its methods to obtain samples from different distributions. By default, [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) uses bits provided by [`PCG64`](https://numpy.org/doc/stable/reference/random/bit_generators/pcg64.html#numpy.random.PCG64) which has better statistical properties than the legacy [`MT19937`](https://numpy.org/doc/stable/reference/random/bit_generators/mt19937.html#numpy.random.MT19937) used in [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState).

- 请调用default_rng以获取Generator的新实例，然后调用其方法从不同的分布中获取样本。默认情况下，Generator使用PCG64提供的位，其统计特性比RandomState使用的旧版MT19937更好。

- ```python
  In [9]: # Do this (new version)
     ...: from numpy.random import default_rng
     ...: rng = default_rng()
     ...: vals = rng.standard_normal(10)
     ...: more_vals = rng.standard_normal(10)
  
  In [10]: rng,vals,more_vals
  Out[10]:
  (Generator(PCG64) at 0x1ECDF49C120,
   array([ 0.84248865, -0.03747258, -0.58596388,  0.69606647,  1.35019572,
           0.63704896, -2.19215194, -0.45073109,  0.27984074, -0.4711174 ]),
   array([ 0.35881568, -0.62622682,  0.03282997,  0.51418967, -1.08631947,
           0.29556383,  0.35040567,  1.811308  ,  0.51156615, -1.85488487]))
  ```

- ```python
  In [11]: # instead of this (legacy version)
      ...: from numpy import random
      ...: vals = random.standard_normal(10)
      ...: more_vals = random.standard_normal(10)
  
  In [12]: rng,vals,more_vals
  Out[12]:
  (Generator(PCG64) at 0x1ECDF49C120,
   array([-0.33599132, -2.61003258, -1.46557606, -1.7670854 , -0.71540471,
           0.56912975,  1.19226498, -1.81105522, -0.18135109,  0.23795518]),
   array([-0.19618078, -0.95267038, -0.31023044,  0.18503194,  0.70748253,
           0.16578623,  1.72903242, -0.23564813, -2.12872048, -2.13597204]))
  ```

### 新旧API

- [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) can be used as a replacement for [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState). Both class instances hold an internal [`BitGenerator`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.BitGenerator.html#numpy.random.BitGenerator) instance to provide the bit stream, it is accessible as `gen.bit_generator`. Some long-overdue API cleanup means that legacy and compatibility methods have been removed from [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator)
- Generator可以用作RandomState的替代品。两个类实例都持有一个内部的BitGenerator实例来提供比特流，可以通过gen.bit_generator访问它。一些早就过期的API清理意味着从Generator中删除了旧版和兼容性方法。

- | [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) | [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) | Notes                                                        |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | `random_sample`,                                             | `random`                                                     | Compatible with [`random.random`](https://docs.python.org/3/library/random.html#random.random) |
  | `rand`                                                       |                                                              |                                                              |
  | `randint`,                                                   | `integers`                                                   | Add an `endpoint` kwarg                                      |
  | `random_integers`                                            |                                                              |                                                              |
  | `tomaxint`                                                   | removed                                                      | Use `integers(0, np.iinfo(np.int_).max,` `endpoint=False)`   |
  | `seed`                                                       | removed                                                      | Use [`SeedSequence.spawn`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.SeedSequence.spawn.html#numpy.random.SeedSequence.spawn) |

- See [What’s New or Different](https://numpy.org/doc/stable/reference/random/new-or-different.html#new-or-different) for more information.

### 兼容处理

Something like the following code can be used to support both `RandomState` and `Generator`, with the understanding that the interfaces are slightly different

```python
try:
    rng_integers = rng.integers
except AttributeError:
    rng_integers = rng.randint
a = rng_integers(1000)
```

Seeds can be passed to any of the BitGenerators. The provided value is mixed via [`SeedSequence`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.SeedSequence.html#numpy.random.SeedSequence) to spread a possible sequence of seeds across a wider range of initialization states for the BitGenerator. Here [`PCG64`](https://numpy.org/doc/stable/reference/random/bit_generators/pcg64.html#numpy.random.PCG64) is used and is wrapped with a [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator).任何BitGenerator都可以接收种子。提供的值通过SeedSequence混合，以在BitGenerator的更广范围的初始化状态中传播可能的种子序列。这里使用PCG64并用Generator进行包装。

```python
from numpy.random import Generator, PCG64
rng = Generator(PCG64(12345))
rng.standard_normal()
```

Here we use [`default_rng`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.default_rng) to create an instance of [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) to generate a random float:

### Random Generator

- rng:**r**a**n**dom-**g**enerator

- The [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) provides access to a wide range of distributions, and served as a replacement for [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState). 
- The main difference between the two is that `Generator` relies on an additional BitGenerator to manage state and generate the random bits, which are then transformed into random values from useful distributions.
- The default BitGenerator used by `Generator` is [`PCG64`](https://numpy.org/doc/stable/reference/random/bit_generators/pcg64.html#numpy.random.PCG64). 
- The BitGenerator can be changed by passing an instantized BitGenerator to `Generator`.

### 概要

Random sampling ([`numpy.random`](https://numpy.org/doc/stable/reference/random/index.html#module-numpy.random))

- Numpy’s random number routines produce pseudo random numbers using combinations of a [`BitGenerator`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.BitGenerator.html#numpy.random.BitGenerator) to create sequences and a [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) to use those sequences to sample **from different statistical distributions**:


- BitGenerators: Objects that generate random numbers. These are typically unsigned integer words filled with sequences of either 32 or 64 random bits.
- Generators: Objects that transform sequences of random bits from a BitGenerator into sequences of numbers that follow a specific probability distribution (such as uniform, Normal or Binomial) within a specified interval.

- Since Numpy version 1.17.0 the Generator can be initialized with a number of different BitGenerators. 

  - It exposes many different probability distributions. See [NEP 19](https://www.numpy.org/neps/nep-0019-rng-policy.html) for context on the updated random Numpy number routines. 


  - <u>The legacy [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) random number routines are still available, but limited to a single BitGenerator.</u> 

  - See [What’s New or Different](https://numpy.org/doc/stable/reference/random/new-or-different.html#new-or-different) for a complete list of improvements and differences from the legacy `RandomState`.

  - For convenience and backward compatibility, a single [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) instance’s methods are imported into the numpy.random namespace, see [Legacy Random Generation](https://numpy.org/doc/stable/reference/random/legacy.html#legacy) for the complete list.

  - Numpy的随机数生成器使用 BitGenerator 和 Generator 的组合来生成伪随机数，并从不同的统计分布中进行采样：

    BitGenerator：生成随机数的对象。通常是填充有32位或64位随机位序列的无符号整数字。

    Generator：将BitGenerator中的随机位序列转换为遵循特定概率分布（例如均匀分布、正态分布或二项分布）的数字序列，序列在指定的区间内。

    自Numpy 1.17.0版本以来，Generator可以使用多种不同的BitGenerators进行初始化。它公开了许多不同的概率分布。有关更新的Numpy随机数例程的上下文，请参见NEP 19。旧版的RandomState随机数例程仍然可用，但仅限于一个BitGenerator。有关改进和与旧版RandomState的区别的完整列表，请参见“What's New or Different”。

    为了方便和向后兼容，单个RandomState实例的方法被导入到numpy.random命名空间中，请参见“Legacy Random Generation”以获取完整列表。

### PCG-64

- PCG-64 is a 128-bit implementation of O’Neill’s permutation congruential generator ([[1\]](https://numpy.org/doc/stable/reference/random/bit_generators/pcg64.html#r4523891264fe-1), [[2\]](https://numpy.org/doc/stable/reference/random/bit_generators/pcg64.html#r4523891264fe-2)). 
- PCG-64 has a period of $2^{128}$ and supports advancing an arbitrary number of steps as well as $2^{127}$ streams. 
- The specific member of the PCG family that we use is PCG XSL RR 128/64 as described in the paper ([[2\]](https://numpy.org/doc/stable/reference/random/bit_generators/pcg64.html#r4523891264fe-2)).

- `PCG64` provides a capsule containing function pointers that produce doubles, and unsigned 32 and 64- bit integers. These are not directly consumable in Python and must be **consumed** by a `Generator` or similar object that supports low-level access.

- Supports the method [`advance`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.PCG64.advance.html#numpy.random.PCG64.advance) to advance the RNG an arbitrary number of steps. The state of the PCG-64 RNG is represented by 2 128-bit unsigned integers.

#### State and Seeding

The `PCG64` state vector consists of 2 unsigned 128-bit values, which are represented externally as Python ints. One is the state of the PRNG, which is advanced by a linear congruential generator (LCG). The second is a fixed odd increment used in the LCG.

The input seed is processed by [`SeedSequence`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.SeedSequence.html#numpy.random.SeedSequence) to generate both values. The increment is not independently settable.

#### Parallel Features

The preferred way to use a BitGenerator in parallel applications is to use the [`SeedSequence.spawn`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.SeedSequence.spawn.html#numpy.random.SeedSequence.spawn) method to obtain entropy values, and to use these to generate new BitGenerators:

```python
>>> from numpy.random import Generator, PCG64, SeedSequence
>>> sg = SeedSequence(1234)
>>> rg = [Generator(PCG64(s)) for s in sg.spawn(10)]
```

#### Compatibility Guarantee

`PCG64` makes a guarantee that a fixed seed will always produce the same random integer stream.



- PCG-64是O'Neill置换同余发生器的128位实现 。
- PCG-64的周期为2的128次方，并支持任意步骤的推进以及2的127次方个流。
- 我们使用PCG家族的特定成员PCG XSL RR 128/64，如文献[2]中所述。

- `PCG64`提供了一个封装，其中包含生成双精度浮点数、无符号32位和64位整数的函数指针。这些在Python中不能直接使用，必须通过一个支持底层访问的`Generator`或类似对象来使用。

- 支持使用`advance`方法将RNG（随机数生成器）向前推进任意数量的步骤。PCG-64 RNG的状态由2个128位无符号整数表示。

#### 状态和种子

PCG64状态向量由2个无符号的128位值组成，它们以Python int的形式表示。其中一个是PRNG的状态，它通过线性同余发生器（LCG）进行推进。第二个是在LCG中使用的固定奇数增量。

输入的种子由SeedSequence处理以生成两个值。增量不能独立设置。

#### 并行功能

在并行应用程序中使用BitGenerator的首选方法是使用SeedSequence.spawn方法获取熵值，并使用它们生成新的BitGenerators

#### 兼容性保证

PCG64保证固定种子将始终产生相同的随机整数流。

## Introduction

The new infrastructure takes a different approach to producing random numbers from the [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) object. Random number generation is separated into two components, a bit generator and a random generator.

The [`BitGenerator`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.BitGenerator.html#numpy.random.BitGenerator) has a limited set of responsibilities. It manages state and provides functions to produce random doubles and random unsigned 32- and 64-bit values.

The [`random generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) takes the bit generator-provided stream and transforms them into more useful distributions, e.g., simulated normal random values. This structure allows alternative bit generators to be used with little code duplication.

The [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) is the user-facing object that is nearly identical to the legacy [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState). It accepts a bit generator instance as an argument. The default is currently [`PCG64`](https://numpy.org/doc/stable/reference/random/bit_generators/pcg64.html#numpy.random.PCG64) but this may change in future versions. As a convenience NumPy provides the [`default_rng`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.default_rng) function to hide these details:

新的架构采用了与RandomState对象不同的方法来生成随机数。随机数生成分为两个组件：BitGenerator和RandomGenerator。

BitGenerator具有有限的职责。它管理状态并提供函数来产生随机的双精度和随机的无符号32位和64位值。

随机生成器接受由BitGenerator提供的流，并将其转换为更有用的分布，例如模拟正态随机值。这个结构允许使用替代的BitGenerator，而几乎不需要重复编写代码。

Generator是面向用户的对象，几乎与旧的RandomState对象相同。它接受一个BitGenerator实例作为参数。默认值当前为PCG64，但在未来版本中可能会更改。为了方便起见，NumPy提供了default_rng函数来隐藏这些细节：

- ```python
  In [2]: from numpy.random import default_rng
     ...:    ...: rng = default_rng(12345)
  
  In [3]: print(rng,'@{rng}')
  Generator(PCG64) @{rng}
  
  In [4]: print(rng.random())
  0.22733602246716966
  ```

- To use the default [`PCG64`](https://numpy.org/doc/stable/reference/random/bit_generators/pcg64.html#numpy.random.PCG64) bit generator, one can instantiate it directly and pass it to [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator):

- ```python
  In [5]: from numpy.random import Generator, PCG64
     ...: rng = Generator(PCG64(12345))
     ...: print(rng)
  Generator(PCG64)
  ```

  

- Similarly to use the older [`MT19937`](https://numpy.org/doc/stable/reference/random/bit_generators/mt19937.html#numpy.random.MT19937) bit generator (not recommended), one can instantiate it directly and pass it to [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator):

  ```python
  In [6]: from numpy.random import Generator, MT19937
     ...: rng = Generator(MT19937(12345))
     ...: print(rng)
  Generator(MT19937)
  ```

  



## What’s New or Different

- Warning
  - The Box-Muller method used to produce NumPy’s normals is no longer available in [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator). It is not possible to reproduce the exact random values using Generator for the normal distribution or any other distribution that relies on the normal such as the [`RandomState.gamma`](https://numpy.org/doc/stable/reference/random/generated/numpy.random.RandomState.gamma.html#numpy.random.RandomState.gamma) or [`RandomState.standard_t`](https://numpy.org/doc/stable/reference/random/generated/numpy.random.RandomState.standard_t.html#numpy.random.RandomState.standard_t). If you require bitwise backward compatible streams, use [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState).

- The Generator’s normal, exponential and gamma functions use 256-step Ziggurat methods which are **<u>2-10 times faster</u>** than NumPy’s Box-Muller or inverse CDF implementations.
- Optional `dtype` argument that accepts `np.float32` or `np.float64` to produce either single or double precision uniform random variables for select distributions
- Optional `out` argument that allows existing arrays to be filled for select distributions
- All BitGenerators can produce doubles, uint64s and uint32s via CTypes ([`PCG64.ctypes`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.PCG64.ctypes.html#numpy.random.PCG64.ctypes)) and CFFI ([`PCG64.cffi`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.PCG64.cffi.html#numpy.random.PCG64.cffi)). This allows the bit generators to be used in numba.
- The bit generators can be used in downstream projects via [Cython](https://numpy.org/doc/stable/reference/random/extending.html#random-cython).
- [`Generator.integers`](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.integers.html#numpy.random.Generator.integers) is now the canonical way to generate integer random numbers from a discrete uniform distribution. The `rand` and `randn` methods are only available through the legacy [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState). The `endpoint` keyword can be used to specify open or closed intervals. This replaces both `randint` and the deprecated `random_integers`.
- [`Generator.random`](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.random.html#numpy.random.Generator.random) is now the canonical way to generate floating-point random numbers, which replaces [`RandomState.random_sample`](https://numpy.org/doc/stable/reference/random/generated/numpy.random.RandomState.random_sample.html#numpy.random.RandomState.random_sample), *RandomState.sample*, and *RandomState.ranf*. This is consistent with Python’s [`random.random`](https://docs.python.org/3/library/random.html#random.random).
- All BitGenerators in numpy use [`SeedSequence`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.SeedSequence.html#numpy.random.SeedSequence) to convert seeds into initialized states.
- The addition of an `axis` keyword argument to methods such as [`Generator.choice`](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.choice.html#numpy.random.Generator.choice), [`Generator.permutation`](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.permutation.html#numpy.random.Generator.permutation), and [`Generator.shuffle`](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.shuffle.html#numpy.random.Generator.shuffle) improves support for sampling from and shuffling multi-dimensional arrays.

- See [What’s New or Different](https://numpy.org/doc/stable/reference/random/new-or-different.html#new-or-different) for a complete list of improvements and differences from the traditional `Randomstate`.

Generator中用于生成NumPy正态分布的Box-Muller方法已不再可用。使用Generator无法复制正态分布或任何其他依赖于正态分布的分布（例如RandomState.gamma或RandomState.standard_t）的确切随机值。如果您需要比特位向后兼容的流，请使用RandomState。

Generator的正态、指数和伽马函数使用256步Ziggurat方法，其速度比NumPy的Box-Muller或逆CDF实现快2-10倍。

可选的dtype参数接受np.float32或np.float64，以产生选择性分布的单精度或双精度均匀随机变量。

可选的out参数允许为选择性分布填充现有数组。

所有BitGenerators都可以通过CTypes（PCG64.ctypes）和CFFI（PCG64.cffi）产生doubles、uint64s和uint32s。这使得可以在numba中使用比特生成器。

比特生成器可以通过Cython在下游项目中使用。

Generator.integers现在是从离散均匀分布中生成整数随机数的规范方法。rand和randn方法仅通过旧版的RandomState可用。endpoint关键字可用于指定开放或封闭间隔。这替换了randint和已弃用的random_integers。

Generator.random现在是生成浮点随机数的规范方法，替换了RandomState.random_sample、RandomState.sample和RandomState.ranf。这与Python的random.random一致。

NumPy中的所有BitGenerators都使用SeedSequence将种子转换为初始化状态。

在Generator.choice、Generator.permutation和Generator.shuffle等方法中添加axis关键字参数，提高了对从和洗牌多维数组的支持。

有关改进和与传统Randomstate的差异的完整列表，请参见“What's New or Different”。

##  随机数模块的基本使用🎈

### 构造RandomGenerator

- ```python
  import numpy as np
  # 随机数模块
  # 实例化一个默认的随机数产生器
  rng = np.random.default_rng()
  print("@rng:", rng)
  ```

  - ```bash
    @rng: Generator(PCG64)
    ```

    

## 生成指定形状的n维数组

### 整型数矩阵

- ```py
  ##
  # 生成一个随机整数数组(元素大小范围[0,10),包含3个随机整数
  rints = rng.integers(low=0, high=10, size=3)
  print( rints,"@rints1")
  ##
  # 生成一个元素大小范围为[5,10),3行4列的随机整数矩阵
  rints = rng.integers(low=5, high=10, size=(3,4))
  print("%s@rints2"% rints)
  ##
  # 生成一个元素大小范围为[5,10),3行4列的随机整数矩阵
  rints = rng.integers(low=5, high=10, size=(3,4,2))
  print("%s@rints3"% rints)
  ```


- ```bash
  [6 2 2] @rints1
  [[5 9 6 8]
   [7 6 5 6]
   [9 6 6 7]]@rints2
  [[[5 7]
    [7 7]
    [7 5]
    [7 7]]
  
   [[9 6]
    [5 9]
    [7 5]
    [9 6]]
  
   [[9 6]
    [5 8]
    [6 9]
    [6 9]]]@rints3
  ```

- 老式api:(调用方式类似)


  - ```python
    import numpy as np
    
    # 生成3行4列的随机整数矩阵
    random_matrix = np.random.randint(0, 10, size=(3, 4))
    
    print(random_matrix)
    ```

    


### 浮点数矩阵

- ```python
  # 生成一个随机浮点数[0,1)
  rfloat = rng.random()
  print("@rfloat:", rfloat)
  ##
  # 产生元素在[0,1)随机浮点数矩阵(shape=(3,3))
  arr1 = rng.random((3, 3))
  print("@arr1:\n", arr1)
  ##
  #生成元素在[10,11)的3行3列随机浮点数矩阵
  arr3 = rng.random((3, 3))+10
  print("@arr3:\n", arr3)
  #生成元素在[10,15)的3行3列随机浮点数矩阵
  arr3 = rng.random((3, 3))*(15-10)+10
  print("@arr3:\n", arr3)
  ##
  # 生成0~10间的随机数浮点数
  arr4 = rng.random((3, 3))*10
  print("@arr4:\n", arr4)
  
  ```

  - ```
    @rfloat: 0.7939732827048979
    @arr1:
     [[0.99358211 0.41876978 0.02352003]
     [0.05406612 0.23521216 0.78707249]
     [0.06253873 0.01311899 0.20807799]]
    @arr3:
     [[10.04022177 10.46978502 10.18798832]
     [10.22221633 10.95567349 10.35092544]
     [10.51654467 10.77036623 10.03771871]]
    @arr3:
     [[14.39844957 14.39288912 14.94155331]
     [13.59679302 14.93300216 11.32998308]
     [11.10215349 12.17755138 14.9722963 ]]
    @arr4:
     [[8.05027557 0.93742348 7.96298449]
     [6.06692369 9.4384969  8.14886692]
     [9.55586509 5.97955699 1.40634796]]
    ```

- 老式api:

  - ```python
    import numpy as np
    
    # 生成3行4列的随机浮点数矩阵
    random_matrix = np.random.rand(3, 4)
    
    print(random_matrix)
    ```

  - ```
    [[0.62246687 0.64744595 0.34477091 0.13634874]
     [0.9282927  0.10339838 0.82403918 0.0128686 ]
     [0.83765859 0.93527123 0.93757736 0.78928998]]
    ```

    

### 数理统计和随机数

- ```python
  import matplotlib.pyplot as pl
  # 概率论&数理统计:符合泊松分布的数据集使用案例
  rng = np.random.default_rng()
  s = rng.poisson(5, 10000)
  count, bins, ignored = plt.hist(s, 14, density=True)
  plt.show()
  ```

  

### 随机矩阵元素精度设置

- ```python
  import numpy as np
  # a = np.arange(16).reshape(4,4)
  #rng:random generator
  # Construct a new Generator with the default BitGenerator (PCG64).
  rng = np.random.default_rng()
   
  ##
  c=rng.random(size=(4,4))
  # 保留三位小数(可以确保打印的时候每个元素的小数位数不超过3位)
  d=c.round(3)
  print(d)
  ##
  # 一种可能的实现(存在精度表示问题,仅作为一种理论上的方法)
  p=c%0.001
  # p=c%1e*3
  d=c-p
  print(d)
  #两种方式在打印的时候都不打印结尾的0串(如果有的话)
  ##矩阵转置的一种实现
  d=c.round(3)
  for i in d:
      # print(i)
      for j in i:
          print(j,end="\t")
      print()
  print("translating...","-"*10)
  l=len(d)
  for i in range(l):
      # print(i)
      for j in range(l):
          print(d[j,i],end="\t")
      print()
  
  ```

- ```bash
  0.067	0.367	0.923	0.795	
  0.086	0.041	0.033	0.969	
  0.572	0.868	0.353	0.908	
  0.196	0.508	0.374	0.743	
  translating... ----------
  0.067	0.086	0.572	0.196	
  0.367	0.041	0.868	0.508	
  0.923	0.033	0.353	0.374	
  0.795	0.969	0.908	0.743	
  ```

  

### numpy.random@shuffle&permutation

- [numpy.random.shuffle — NumPy Manual](https://numpy.org/doc/stable/reference/random/generated/numpy.random.shuffle.html)

- [numpy.random.permutation — NumPy Manual](https://numpy.org/doc/stable/reference/random/generated/numpy.random.permutation.html)

- 新的代码应该使用`Generator`的同名api

  - ```python
    import numpy as np
    rng=np.random.default_rng()
    #新api
    rng.shuffle()
    rng.permutation()
    ```

- `np.random.permutation` 和 `np.random.shuffle` 都是 Numpy 库中用于随机打乱数组的函数，它们的作用类似，但是有一些区别。

  `np.random.permutation` 函数返回一个随机排列的数组，它接受一个整数或者数组作为输入参数。如果输入参数是一个整数 `n`，则 `np.random.permutation(n)` 会返回一个包含 `0` 到 `n-1` 的随机排列的数组。如果输入参数是一个一维数组 `a`，则 `np.random.permutation(a)` 会返回一个随机排列的 `a` 的副本，而不会改变原始数组 `a`。例如：

  ```python
  import numpy as np
  
  a = np.array([1, 2, 3, 4, 5])
  b = np.random.permutation(a)
  print(a)  # [1 2 3 4 5]
  print(b)  # [5 2 4 1 3]
  ```

  `np.random.shuffle` 函数是一个原地操作，它会随机打乱原始数组的顺序。它接受一个数组作为输入参数，然后随机打乱数组的顺序。例如：

  ```python
  import numpy as np
  
  a = np.array([1, 2, 3, 4, 5])
  np.random.shuffle(a)
  print(a)  # [2 4 1 5 3]
  ```

  可以看到，`np.random.shuffle` 函数打乱了原始数组 `a` 的顺序，并且没有返回任何结果。

  因此，`np.random.permutation` 和 `np.random.shuffle` 都可以用于随机打乱数组，但是它们的作用略有不同。如果需要得到一个随机排列的数组，并且不想改变原始数组的顺序，可以使用 `np.random.permutation`。如果需要原地打乱数组的顺序，可以使用 `np.random.shuffle`。

## Legacy Random Generation

- [Legacy Random Generation — NumPy Manual](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState)

- The [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) provides access to legacy generators. This generator is considered frozen and will have no further improvements. It is guaranteed to produce the same values as the final point release of NumPy v1.16. These all depend on Box-Muller normals or inverse CDF exponentials or gammas. This class should only be used if it is essential to have randoms that are identical to what would have been produced by previous versions of NumPy.

  [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) adds additional information to the state which is required when using Box-Muller normals since these are produced in pairs. It is important to use [`RandomState.get_state`](https://numpy.org/doc/stable/reference/random/generated/numpy.random.RandomState.get_state.html#numpy.random.RandomState.get_state), and not the underlying bit generators *state*, when accessing the state so that these extra values are saved.

  Although we provide the [`MT19937`](https://numpy.org/doc/stable/reference/random/bit_generators/mt19937.html#numpy.random.MT19937) BitGenerator for use independent of [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState), note that its default seeding uses [`SeedSequence`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.SeedSequence.html#numpy.random.SeedSequence) rather than the legacy seeding algorithm. [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) will use the legacy seeding algorithm. The methods to use the legacy seeding algorithm are currently private as the main reason to use them is just to implement [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState). However, one can reset the state of [`MT19937`](https://numpy.org/doc/stable/reference/random/bit_generators/mt19937.html#numpy.random.MT19937) using the state of the [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState):

  - [RandomState|Legacy Random Generation — NumPy Manual](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState)

  - ```python
    In [20]: from numpy.random import MT19937
        ...: from numpy.random import RandomState
        ...:
        ...: rs = RandomState(12345)
        ...: mt19937 = MT19937()
        ...: mt19937.state = rs.get_state()
        ...: rs2 = RandomState(mt19937)
    
    
    In [22]: rs.standard_normal(),rs2.standard_normal()
    Out[22]: (0.47894333805754824, 0.47894333805754824)
    
    In [23]: rs.random(),rs2.random()
    Out[23]: (0.18391881167709445, 0.18391881167709445)
    
    In [24]: rs.standard_exponential(),rs2.standard_exponential()
    Out[24]: (0.22886020849774785, 0.22886020849774785)
    ```

  - 这段代码演示了如何使用RandomState的状态重置MT19937的状态，以便产生与旧版NumPy版本完全相同的随机数。具体来说，代码的执行如下：
    1. 从numpy.random模块导入MT19937和RandomState类。
    2. 创建RandomState对象rs，并使用种子12345初始化它。
    3. 创建MT19937对象mt19937。
    4. 将mt19937对象的状态设置为rs对象的状态，以便将其重置为与rs对象相同的状态。
    5. 使用mt19937对象创建一个新的RandomState对象rs2。
    6. 调用rs和rs2对象的standard_normal()方法，产生一个标准正态分布的随机数。由于rs2对象的状态与rs对象相同，因此这两个方法的输出应该相同。
    7. 调用rs和rs2对象的random()方法，产生一个[0,1)区间上的均匀分布的随机数。由于rs2对象的状态与rs对象相同，因此这两个方法的输出应该相同。
    8. 调用rs和rs2对象的standard_exponential()方法，产生一个标准指数分布的随机数。由于rs2对象的状态与rs对象相同，因此这两个方法的输出应该相同。

  RandomState提供对旧版生成器的访问。此生成器被视为冻结的，不会有进一步的改进。它保证生成与NumPy v1.16最终版本相同的值。这些都依赖于Box-Muller正态分布或逆CDF指数分布或伽马分布。只有在必须要获得与早期NumPy版本生成的随机数完全相同的情况下，才应该使用此类。

  RandomState向状态添加了额外的信息，这在使用Box-Muller正态分布时是必需的，因为这些分布是成对产生的。使用RandomState.get_state而不是底层比特生成器状态来访问状态非常重要，以便保存这些额外的值。

  尽管我们提供了MT19937比特生成器供独立于RandomState使用，但请注意其默认种子使用SeedSequence而不是旧版的种子算法。RandomState将使用旧版的种子算法。当前使用旧版种子算法的方法是私有的，因为使用它们的主要原因仅仅是实现RandomState。然而，可以使用RandomState的状态重置MT19937的状态：

### MT19937

- [Mersenne Twister (MT19937) — NumPy  Manual](https://numpy.org/doc/stable/reference/random/bit_generators/mt19937.html#numpy.random.MT19937)

- MT19937是一种基于梅森旋转算法的伪随机数生成器，它产生32位的随机数。该算法由Matsumoto和Nishimura于1998年提出，是目前应用最广泛的伪随机数生成器之一。
- MT19937的周期非常长，为2的19937次方，这意味着可以生成大量的随机数序列而不会出现重复。此外，它的随机性和统计特性也非常好，被广泛应用于模拟、密码学、游戏等领域。
- 在NumPy中，MT19937是一个BitGenerator类的实现，可以用于生成随机数。它的状态可以通过get_state()方法获取，也可以通过set_state()方法设置。另外，NumPy中的RandomState类也使用MT19937作为默认的随机数生成器。
- 如果需要更好的随机性和统计特性，可以考虑使用更复杂的随机数生成器，如PCG64。

## 随机数重现@种子

### Legacy

```python
In [3]: np.random.seed?
Docstring:
seed(self, seed=None)

Reseed a legacy MT19937 BitGenerator

Notes
-----
This is a convenience, legacy function.

The best practice is to **not** reseed a BitGenerator, rather to
recreate a new one. This method is here for legacy reasons.
This example demonstrates best practice.

>>> from numpy.random import MT19937
>>> from numpy.random import RandomState, SeedSequence
>>> rs = RandomState(MT19937(SeedSequence(123456789)))
# Later, you want to restart the stream
>>> rs = RandomState(MT19937(SeedSequence(987654321)))
Type:      builtin_function_or_metho
```



```python
In [15]: np.random.seed(1);np.random.rand()
Out[15]: 0.417022004702574

In [16]: np.random.seed(1);np.random.rand()
Out[16]: 0.417022004702574

In [17]: np.random.seed(2);np.random.rand()
Out[17]: 0.43599490214200376

In [18]: np.random.seed(2);np.random.rand()
Out[18]: 0.43599490214200376

In [19]: np.random.rand()
Out[19]: 0.025926231827891333

In [20]: np.random.rand()
Out[20]: 0.5496624778787091

In [21]: np.random.rand()
Out[21]: 0.4353223926182769

In [22]: np.random.rand()
Out[22]: 0.42036780208748903

In [23]: np.random.rand()
Out[23]: 0.3303348210038741
```

- 上面的方法不推荐.
  - [python - Reproducible NumPy's random results: Reseeding vs Recreating - Stack Overflow](https://stackoverflow.com/questions/62692658/reproducible-numpys-random-results-reseeding-vs-recreating)

### New

- 和上面的操作类似,如果想要多次调用随机数生成方法得到的结果一致,就必须显式的在这些不同次调用前设置相同的种子(seed)

- 如果只设置一次,而后续的调用不执行设置操作,那么结果会发生变化,例如:

- ```python
  In [1]: import numpy as np
  
  In [2]: rng=np.random.default_rng(1)
  
  In [3]: rng.random()
  Out[3]: 0.5118216247002567
  
  In [4]: rng.random()
  Out[4]: 0.9504636963259353
  
  In [5]: rng.random()
  Out[5]: 0.14415961271963373
  ```

- ```python
  
  In [6]: rng=np.random.default_rng(1);rng.random()
  Out[6]: 0.5118216247002567
  
  In [7]: rng=np.random.default_rng(1);rng.random()
  Out[7]: 0.5118216247002567
  #或者使用链式方式调用
  In [9]: np.random.default_rng(1).random()
  Out[9]: 0.5118216247002567
  
  In [10]: np.random.default_rng(1).random()
  Out[10]: 0.5118216247002567
  
  ```

  











